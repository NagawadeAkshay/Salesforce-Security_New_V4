/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class ErrorMessageHelper{ 
    public static List<LightningPageMessage> errorMessageList = new List<LightningPageMessage>();

    private static Map<String,ErrorMessageConfig__c> errorMessageMap = new Map<String,ErrorMessageConfig__c>();
    global static string fetchMessage(String errorCode){
        if(errorMessageMap.get(errorCode) != null){
            return errorMessageMap.get(errorCode).Message__c;
        }
        List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
        if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
            errorMessages = [select id,Message__c,Message_Type__c from ErrorMessageConfig__c where 
                ErrorCode__c=:errorCode WITH USER_MODE];
        }
        if(errorMessages.size() > 0){
            errorMessageMap.put(errorCode, errorMessages[0]);
            return errorMessages[0].Message__c;
        }
        return null;
    }
    
    global static string fetchMessageType(String errorCode){
        if(errorMessageMap.get(errorCode) != null){
            return errorMessageMap.get(errorCode).Message_Type__c;
        }
        List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
        if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
            errorMessages = [select id,Message_Type__c,Message__c from ErrorMessageConfig__c where 
                ErrorCode__c=:errorCode WITH USER_MODE];
        }
        if(errorMessages.size() > 0){
            errorMessageMap.put(errorCode, errorMessages[0]);
            return errorMessages[0].Message_Type__c;
        }
        return null;
    }

    global static Map<String, String> fetchMessages(Set<String> errorCodes){
        Map<String, String> errMessageMap = new Map<String, String>();
        for(String errorCode : errorMessageMap.keySet()) {
            errMessageMap.put(errorCode, errorMessageMap.get(errorCode).Message__c);
        }

        Set<String> errorCodesTemp = new Set<String>();
        
        for(String errorCode : errorCodes) {
            if(errMessageMap.get(errorCode) != null) {
                errorCodesTemp.add(errorCode);
            }
        }
        if(errorCodesTemp.size() == errorCodes.size()) {
            return errMessageMap;
        }
        List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
        if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
            errorMessages = [select id, Message__c, Message_Type__c, ErrorCode__c
                                                    from ErrorMessageConfig__c where ErrorCode__c IN :errorCodes WITH USER_MODE];
        }
        for(ErrorMessageConfig__c errMsg : errorMessages) {
            errMessageMap.put(errMsg.ErrorCode__c, errMsg.Message__c);
        }
        return errMessageMap;
    }
	
	/* Global Method To Be Exposed to Add Mssage for ApexPage Message
      Parameter : errorCode of Error msg Config Object */
    global static void addMessage(String errorCode){    
        List<ErrorMessageConfig__c> errorMsgs;
        if(errorMessageMap.get(errorCode) != null){
            errorMessageList.add(New LightningPageMessage(errorMessageMap.get(errorCode).Message_Type__c,errorMessageMap.get(errorCode).Message__c));
        }else{
            if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
                errorMsgs = [SELECT Id,Message_Type__c,Message__c from ErrorMessageConfig__c where 
                ErrorCode__c=:errorCode WITH USER_MODE];
                if(errorMsgs.size() > 0){                
                    errorMessageMap.put(errorCode, errorMsgs[0]);
                        errorMessageList.add(new LightningPageMessage(errorMsgs[0].Message_Type__c,errorMsgs[0].Message__c));
                }
            } 
        }                   
    }
}