public with sharing class LogExceptionHandler {

    public static void logException(List<Log_Exception__e> lstLogExceptions){
        List<ErrorLog__c> lstErrorLogs = new List<ErrorLog__c>();
        for(Log_Exception__e objLogException : lstLogExceptions){
            if(String.isNotBlank(objLogException.Message__c)){
                GGException objGGException = (GGException)JSON.deserialize(objLogException.Message__c, GGException.class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
                if(objGGException != null){
                    if(Schema.sObjectType.ErrorLog__c.fields.AffectedUser__c.isCreateable() && Schema.sObjectType.ErrorLog__c.fields.AffectedUserProfileId__c.isCreateable()
                    && Schema.sObjectType.ErrorLog__c.fields.ErrorLineNumber__c.isCreateable() && Schema.sObjectType.ErrorLog__c.fields.ExceptionType__c.isCreateable()
                    && Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable() && Schema.sObjectType.ErrorLog__c.fields.StackTrace__c.isCreateable()
                    ){
                    lstErrorLogs.add(new ErrorLog__c(
                            AffectedUser__c = objGGException.AffectedUserId,
                            AffectedUserProfileId__c = objGGException.AffectedUserProfileId,
                            ErrorLineNumber__c = objGGException.ErrorLineNumber,
                            ExceptionType__c = objGGException.ExceptionType,
                            ErrorMessage__c = objGGException.ErrorMessage,
                            StackTrace__c = objGGException.StackTrace
                    ));
                    }
                }
            }
        }
        if(!lstErrorLogs.isEmpty() && ErrorLog__c.sObjectType.getDescribe().isAccessible() == true 
        && Schema.sObjectType.ErrorLog__c.isCreateable()){
            insert as user lstErrorLogs;
        }
    }

    public static void logException(Exception objException){
        Boolean isEnabled = KeyValueHolderHelper.getBooleanValue('EnableLogException');
        if(objException != null && isEnabled || Test.isRunningTest()){
            Map<String, Object> excMap = new Map<String, Object>();
            excMap.put('AffectedUserId', UserInfo.getUserId());
            excMap.put('AffectedUserProfileId', UserInfo.getProfileId());
            excMap.put('ErrorLineNumber', objException.getLineNumber());
            excMap.put('ExceptionType', objException.getTypeName());
            excMap.put('ErrorMessage', objException.getMessage());
            excMap.put('StackTrace', objException.getStackTraceString());
            Log_Exception__e objLogException = new Log_Exception__e(Message__c = JSON.serialize(excMap));
            try {
                Database.SaveResult objSaveResult = EventBus.publish(objLogException);
            } catch(Exception ex) {
       
            }
        }
    }

    public with sharing class GGException extends Exception {
        public Id AffectedUserId {get;set;}
        public Id AffectedUserProfileId {get;set;}
        public Integer ErrorLineNumber {get;set;}
        public String ExceptionType {get;set;}
        public String ErrorMessage {get;set;}
        public String StackTrace {get;set;}
    }
}