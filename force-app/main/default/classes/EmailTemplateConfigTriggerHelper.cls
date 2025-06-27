/*
This  TriggerHelper 
*******************************************************************************
Audit History
    
*******************************************************************************
08-01-2022      Tejashreee D        1. added with sharing for SF security review, Email template is Public R/W AND 
Config form is Public Read only     
*******************************************************************************
*/
public with sharing class EmailTemplateConfigTriggerHelper extends TriggerHelper{
    public override void processBeforeInsert() { 
            updateSOQLField(trigger.new);
    }
    public override void processBeforeUpdate() {        
            updateSOQLField(trigger.new);
    }

    public void updateSOQLField(List<EmailTemplateConfig__c> ec){
        List<String> developerNames = new List<String>();
        Map<String,EmailTemplate> templateMap =new Map<String,EmailTemplate>();
        
        List<EmailTemplate> template = new List<EmailTemplate>();
        for(EmailTemplateConfig__c developerName :ec){
            if(developerName.DeveloperName__c != null && developerName.DisableSync__c != true){
                developerNames.add(developerName.DeveloperName__c);
            }
        } 
        if(Emailtemplate.sObjectType.getDescribe().isAccessible() == true){ 
            template = [SELECT DeveloperName,Subject,Body,HtmlValue FROM Emailtemplate 
                        where DeveloperName IN:developerNames WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users        
        }

        if(template.size() > 0){
            for(EmailTemplate et : template){
                templateMap.put(et.DeveloperName, et);
            }
        }      
        for(EmailTemplateConfig__c config :ec){
            Set<String> mergeFields = new Set<String> ();
            if(config.DeveloperName__c != null){
                
                EmailTemplate etemplate = templateMap.get(config.DeveloperName__c);
                if(etemplate != null){
                    mergeFields.addAll(getMergeFields(etemplate.Body));
                    mergeFields.addAll(getMergeFields(etemplate.Subject));
                    mergeFields.addAll(getMergeFields(etemplate.HtmlValue));
                }
            }
            config.SOQLField__C = String.join(new List<String>(mergeFields),',');
            config.ErrorMessage__c = null;
            if(config.SOQLField__C.containsIgnoreCase('/Div') || config.SOQLField__C.containsIgnoreCase('/span') || 
                config.SOQLField__C.containsIgnoreCase('/font') || config.SOQLField__C.containsIgnoreCase('<font') || 
                config.SOQLField__C.containsIgnoreCase('<Div') || config.SOQLField__C.containsIgnoreCase('<span') ) {
                config.ErrorMessage__c = 'Invalid fields found.' + config.SOQLField__c;
                config.SOQLField__c = null;
                
            }  
        } 
    }

    public  List<String> getMergeFields(String header){
        List<String>mergeFieldKey = new List<String>();
        if (header == null){return mergeFieldKey;}
        Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
        Matcher regexMatcher = regex.matcher(header);        
        while (regexMatcher.find()){//SOQL/SOSL Injection False +ve  
            List<String> fieldNames = new List<String>();
            String fieldName = regexMatcher.group();
            if(!fieldName.contains('$')){
                fieldName = fieldName.substring(2,fieldName.length()-1);
                fieldNames = fieldName.split('\\.',2);
                if(fieldNames.size() == 2){
                    if(fieldNames[0] != 'Contact' && fieldNames[0] != 'User'){
                        if(fieldNames[1] == 'Link' ){
                            mergeFieldKey.add(fieldNames[1] = 'Id');
                        }
                        else if(fieldNames[1] == 'OwnerFirstName') {
                           mergeFieldKey.add(fieldNames[1] = 'Owner.FirstName');
                        }
                        else if(fieldNames[1] == 'OwnerLastName') {
                            mergeFieldKey.add(fieldNames[1] = 'Owner.LastName');
                        }
                        else if(fieldNames[1] == 'OwnerEmail') {
                            mergeFieldKey.add(fieldNames[1] = 'Owner.Email');
                        }else if(fieldNames[1] == 'OwnerFullName') {
                           mergeFieldKey.add(fieldNames[1] = 'Owner.Name');
                        }else if(fieldNames[1] == 'OwnerTitle') {
                            mergeFieldKey.add(fieldNames[1] = 'Owner.Title');
                        }
                        else if(fieldNames[1] == 'CreatedBy') {
                           mergeFieldKey.add(fieldNames[1] = 'CreatedBy.Name');
                        }
                        else if(fieldNames[1] == 'LastModifiedBy') {
                            mergeFieldKey.add(fieldNames[1] = 'LastModifiedBy.Name');
                        }else{
                             mergeFieldKey.add(fieldNames[1]);
                        }

                    }
                }
            }                                        
        }      
        return mergeFieldKey;
    }
}