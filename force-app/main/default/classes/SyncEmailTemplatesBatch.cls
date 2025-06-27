global with sharing class SyncEmailTemplatesBatch  extends BatchApexHandler {

    global SyncEmailTemplatesBatch(){}

    global override String getQuery() {
        return 'SELECT DeveloperName,Id,IsActive,Name,Subject FROM EmailTemplate WHERE IsActive = true WITH USER_MODE';
    }

    global override void execute(List<SObject> scope1){
        List<EmailTemplate> scope = (List<EmailTemplate>)scope1;
        List<EmailTemplateConfig__c> emailList = new List<EmailTemplateConfig__c>();
        if(Schema.sObjectType.EmailTemplateConfig__c.fields.Name.isCreateable() 
			 && Schema.sObjectType.EmailTemplateConfig__c.fields.Name.isUpdateable() 
             && Schema.sObjectType.EmailTemplateConfig__c.fields.DeveloperName__c.isCreateable() 
			 && Schema.sObjectType.EmailTemplateConfig__c.fields.DeveloperName__c.isUpdateable()){
       for(EmailTemplate email : scope){
           emailList.add(
               new EmailTemplateConfig__c(
                 Name=  email.Name,
                 DeveloperName__c = email.DeveloperName
               )
           );
       }
        }
    
        if(Schema.sObjectType.EmailTemplateConfig__c.isCreateable() && Schema.sObjectType.EmailTemplateConfig__c.isUpdateable()){
       upsert emailList DeveloperName__c;
        }
    }
   
}