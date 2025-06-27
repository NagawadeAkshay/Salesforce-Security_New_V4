global with sharing class ApplicationSubmissionValidationHelper{
    @TestVisible private static Sobject sobj;
    @TestVisible private static string editRecordTypeId;   
    global static boolean validateApplication(DynamicLayoutHolder layoutHolder,Id recordId){
        return true;
    }
    
    public static boolean validateApplicationsRTAWordCount(DynamicLayoutHolder layoutHolder){
        //return isEnableSubmitRichTextAreaWordsCount(layoutHolder);
        return true;
    }
    
    /*
        isEnableSubmit : fetch all the active page block details for the edit layout of the currently viewed record
                         which are required for submit, and check if thse fields are populated or not.
                         If all such fields are populated then enable the Submit button, else disable it.
    */
    global static   boolean isEnableSubmit(Id editLayoutId, String objectName, Id rcrdId, Boolean isInternal, Boolean isApplicant){
        Id recordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Standalone').getRecordTypeId();
        if(editLayoutId != null && editRecordTypeId == recordTypeId){ 
            sObject currentObject = sobj;
            String recId = (String)currentObject.get('RecordTypeId');
            List<RecordType> recType = new List<RecordType>();
            if(RecordType.getSObjectType().getDescribe().isAccessible()){ //CRUD/FLS False +ve with the help of Schema we have performed check
                recType = [SELECT DeveloperName FROM RecordType WHERE id =:recId WITH USER_MODE]; //SF Seq review //SOQL Injection - False +ve - Dynamic part of query is static bind 
            }
            if(recType.size() > 0){
                String recordTypeName = recType[0].DeveloperName;
                    if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
                    editLayoutId = String.escapeSingleQuotes(String.valueOf(editLayoutId));
                    recordTypeName = String.escapeSingleQuotes(recordTypeName);

                    String pageConfigQuery = 'SELECT RecordTypeName__c,RecordTypeDescription__c,ObjectAPIName__c,ParentLayout__c,Title__c FROM PageLayoutConfig__c WHERE ParentLayout__c  =:editLayoutId AND RecordTypeName__c =:recordTypeName';
                    List<PageLayoutConfig__c> pageConfig = Database.query(String.escapeSingleQuotes(pageConfigQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind 
                    if(pageConfig.size () > 0){
                        editLayoutId = pageConfig[0].id; 
                    }
                }
            }
        }
                
        Boolean fieldsFilledForSubmit = true;
        PageBlockDetailConfig__c[] pbds;
        if(PageBlockDetailConfig__c.getSObjectType().getDescribe().isAccessible()){ //CRUD/FLS False +ve with the help of Schema we have performed check
             pbds = [SELECT FieldAPIName__c,RequiredForSubmitByRole__c, hideForContext__c, HideDecisionField__c, hideForUser__c
             FROM PageBlockDetailConfig__c 
                WHERE PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__c = :editLayoutId AND IsHiddenField__c = false
                    AND RequiredBehavior__c = 'Required for Submit' AND IsActive__c = true AND RecordType.Name = 'Field' WITH USER_MODE];  //SF Seq review //SOQL Injection - False +ve - Dynamic part of query is static bind 
        }
            if(pbds.size() > 0){
                String fields = '';
                for(PageBlockDetailConfig__c pbd : pbds){
                    fields +=pbd.FieldAPIName__c+',';
                }
                fields = fields.removeEnd(',');
                List<sObject> objList = new List<sObject>();
                if(AppUtils.isObjectAccessible(objectName)){//CRUD/FLS False +ve with the help of AppUtils we have performed the check
                    rcrdId = String.escapeSingleQuotes(String.valueOf(rcrdId));
                    String query = 'SELECT Id, ' + String.escapeSingleQuotes(fields) + ' FROM '+ String.escapeSingleQuotes(objectName) + ' WHERE id = :rcrdId LIMIT 1'; //SF Seq review
                    objList = Database.query(query, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                }
                    if(objList.size() > 0){
                        sObject obj = objList[0];
                        for(PageBlockDetailConfig__c pbd : pbds){
                            if(pbd.FieldAPIName__c != null && !pbd.FieldAPIName__c.contains('.') && obj.get(pbd.FieldAPIName__c) == null){
                                Boolean hidePageAction = AppUtils.showHideComponent(false,isInternal,isApplicant, '', obj.Id, pbd.hideForContext__c, pbd.hideForUser__c, '');                                
                                boolean hiddenField,hideDecisionValue ;                                
                                if(!String.isEmpty(pbd.HideDecisionField__c)){
                                    hideDecisionValue = (Boolean)obj.get(pbd.HideDecisionField__c);
                                    if(hideDecisionValue != null){
                                        if(hidePageAction != null){
                                            hiddenField = hidePageAction && hideDecisionValue;
                                        }else{
                                            hiddenField = hideDecisionValue;
                                        }
                                    }
                                }
                                else{
                                        String[] requiredBySubmitRoles;
                                        if(pbd.RequiredForSubmitByRole__c != null ) {
                                            requiredBySubmitRoles = (pbd.RequiredForSubmitByRole__c).split(';');
                                        }
                                        Boolean requiredBySubmitCheck = null;
                                        if(requiredBySubmitRoles != null) {
                                            if(requiredBySubmitRoles.size() > 0) {
                                                requiredBySubmitCheck = false;
                                                for(String role : requiredBySubmitRoles) {                                    
                                                    if(!String.isEmpty(AppUtils.getRoleInfo())){
                                                        if(AppUtils.getRoleInfo().equals(role)) {
                                                            requiredBySubmitCheck = true;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        hiddenField = hidePageAction == null?false:hidePageAction;
                                        if(requiredBySubmitCheck == false) {
                                            hiddenField = true;
                                        }
                                    }
                                if(!(hiddenField)){
                                    fieldsFilledForSubmit = false;
                                    break;
                                }
                            }
                        }
                    }
            }
        return fieldsFilledForSubmit;
    }

    global static  boolean isTextAreaCharCountExceeded(DynamicLayoutHolder layoutHolder){
        string objName = layoutHolder.objName;
        sObject obj =  layoutHolder.recordMap.get(objName);
        if(layoutHolder.layout != null) {
            for(PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs){
                for(PageLayoutConfigHelper.pageBlock pgBlock: tab.pageBlocks){
                    for(PageLayoutConfigHelper.Field field : pgBlock.fields){
                        if(field.isTextAreaField){
                            String textValue = string.valueOf(obj.get(field.fieldAPIName));
                            if(!String.isEmpty(textValue)){
                                Integer textLength = textValue.length();
                                Schema.DescribeFieldResult fldRes = SchemaManager.getFieldSchemaResult(objName, field.fieldAPIName).fieldDesc;
                                if(fldRes != null && textLength > fldRes.getLength()){
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    @TestVisible 
     public with sharing class ApplicationWrapper{
        @AuraEnabled
        public list<sObject> ObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldKeyMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scale {get;set;}
        @AuraEnabled
        public String timelol {get;set;}   
        @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public ApplicationWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
            this.ObjectList = sObjectList;
            this.fieldKeyMap = fieldLableMap;
            this.fieldDataMap = fieldDataTypeMap;
            this.scale = scaleMap;
            this.timelol = (UserInfo.getTimeZone()).toString();
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }
}