/**
*   Send Email  Contact
*
*   CHANGE HISTORY
*   ===================================================
    ===================================================
*   Date            Name                Description
*   20/02/2024      Sonali Jagtap       Created
*/
public with sharing class EmailTemplateController {
    public string documentName;
    public Id targetId {get;set;}
    public String documentBody;
    public String emailBody {get;set;}
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getContactById(String contactId) {
        Map<string, Object> templateInfoMap = new Map<string, Object>();
        Integer MessageTimeOut = FlexGridEnhancedCtrl.getmessageTimeOut();
        Boolean MessageTimeOutEnabled = FlexGridEnhancedCtrl.getmessageTimeOutEnabled();
        templateInfoMap.put('target',[SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId with USER_MODE LIMIT 1]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        templateInfoMap.put('MessageTimeOut',MessageTimeOut);
        templateInfoMap.put('MessageTimeOutEnabled',MessageTimeOutEnabled);
        return templateInfoMap;
    }
    public static EmailFeeder setEmailDataFeeeder(string emailBody,object fileDetails,Id targetId,String subject,String whatId){
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    EmailFeeder emailFeeder = new EmailFeeder();
    Map<String,Object> paramsMap = new Map<string, Object>();
    List<Id> cvIds = new List<Id>();
    List<ContentVersion> cvList = new List<ContentVersion>();
    List<ContentDocumentLink> cdocLink = new List<ContentDocumentLink>();
    if(fileDetails != null){
    paramsMap = (Map<string, Object>)JSON.deserializeUntyped(JSON.serialize(fileDetails));
    if(paramsMap!=null){
        ContentVersion cv = createContentVersion((String)paramsMap.get('filename'),(String)paramsMap.get('base64'));
        if (Schema.sObjectType.ContentVersion.isCreateable()) {
            insert as user cv;
            cvList.add(cv);
            cvIds.add(cv.Id);
        }
    }
    if(cvList.size()>0){
        cdocLink = createContentLink(cvIds, targetId);
        if(cdocLink.size()>0){
            if (Schema.sObjectType.ContentDocumentLink.isCreateable()) {
                insert as user cdocLink;
            }
        }
    }
    List<String> cdIdList = new List<String>();
    for(ContentDocumentLink cd : cdocLink) {
        cdIdList.add(cd.Id);
    }
    Map<String,List<Object>> returnData = getFilesIdOnTaskforId(cdIdList);
    String[] attachmentIdArray = (List<String>)returnData.get('Ids');

    List<ContentVersion> contentData = (List<ContentVersion>)returnData.get('Records');
    String attchId = String.join(attachmentIdArray, ','); 

    emailFeeder.attachmentIdString(attchId);
}
    emailFeeder.htmlBody(emailBody);
    emailFeeder.subject(subject);

    if(whatId != null && !String.isEmpty(whatId)){
        emailFeeder.contextRecordId(whatId);
    }
    return emailFeeder;
     }
// function is used to send emails to EmailFeeder
@AuraEnabled
public static Map<String,Object>  sendEmail(String emailBody,String email, String ccEmail,String isBulkMode,Object fileDetails,Id targetId,String subject,String whatId,String clsName) {       
    String[] newEmails;  
    String message = '';
    Map<String,Object> result = new Map<String,Object>();
    String className = String.valueOf(clsName);
    String[] classNameParts;
    Type actionClassType;
    invokeEmailAction  emailAction;
    try {
    if(className != null){
        if(className.contains('.')){
            classNameParts = className.split('\\.');
            actionClassType = Type.forName(classNameParts[0], classNameParts[1]);
        }else{
            actionClassType = Type.forName('', className);
        }
    }
    } catch(Exception ex) {
        result.put('Message','Class not found with Name ' + className + '. Please check class name.');
        result.put('IsSuccess',False);
        return result;
    }
     if(className != null){
        emailAction = (invokeEmailAction)actionClassType.newInstance();
        emailAction.lightningObject.currentRecordId = targetId;
        if(isBulkMode != 'true'){
            String messageBefore = emailAction.actionToInvokeBefore();
            if(messageBefore != 'success'){
                
                result.put('Message',AppUtils.handleSystemExceptionMsg(messageBefore));
                result.put('IsSuccess',False);
                return result;
                
            }
        }
     }
    try {
        if((!String.isEmpty(email) && !checkEmailAddress(email)) || String.isBlank(email)) {
          
               message ='Invalid Email Address.';
               result.put('Message',message);
               result.put('IsSuccess',False);
               return result;
        
          
        } else if(subject == null || subject == '') {
         
               message ='Subject must be required.';
               result.put('Message',message);
               result.put('IsSuccess',False);
               return result;

             
           
        } else if( String.isBlank(emailBody)|| emailBody == null || emailBody == '') {

               message ='Invalid Body.';
               message = AppUtils.handleSystemExceptionMsg(message);
               result.put('Message',message);
               result.put('IsSuccess',False);
               return result;
           
        } else if(!String.isEmpty(ccEmail) && !checkEmailAddress(ccEmail)) {
          
               message ='Invalid Email Address.';
               result.put('Message',message);
               result.put('IsSuccess',False);
               return result;
           
          
        }
        if(isBulkMode == 'true') {
            if( !String.isEmpty(email) && !checkEmailAddress(email) ) {
               
                   message= 'Invalid Email Address.';
                   message = AppUtils.handleSystemExceptionMsg(message);
                   result.put('Message',message);
                   result.put('IsSuccess',False);
                   return result;
                  
            }
           
     }} catch(Exception e) {
     
           message = e.getMessage();
           message = AppUtils.handleSystemExceptionMsg(message);
           result.put('Message',message);
           result.put('IsSuccess',false);
           return result;
       
       
    }
    if(isBulkMode != 'true'){
      
        EmailFeeder emailFeeder = setEmailDataFeeeder(emailBody,fileDetails,targetId,subject,whatId);
        if(String.isNotEmpty(email)) {
            emailFeeder.toEmail(email);    
        }
        if(ccEmail != null && ccEmail != ''){
            emailFeeder.ccEmail(ccEmail);                      
        }
        if(targetId != null && !String.isEmpty(targetId)){
            emailFeeder.TargetObjectId(targetId);
        }
        emailFeeder.send();
        if(className != null){
            if(isBulkMode != 'true'){
                String messageAfter=  emailAction.actionToInvokeAfter();
                if(messageAfter != 'success'){
                    result.put('Message',AppUtils.handleSystemExceptionMsg(messageAfter));
                    result.put('IsSuccess',False);
                    return result;
                    
                }
            }
        }
        result.put('Message','Email Sent Succesfully.');
        result.put('IsSuccess',true);
    }else{
       }
       
       return result;
   }


    public static Boolean checkEmailAddress(String emailAddress) {
        String emailRegex = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
        List<String> ListEAddrs = emailAddress.split(';');
        for( String singleEmail : ListEAddrs) {
            if(!Pattern.compile(emailRegex).matcher(singleEmail).matches()) {
                return false;
            }
        }
        return true;            
    }
    private static List<ContentDocumentLink> createContentLink(List<Id> cVersions, String recordId) {
        if (cVersions == null || recordId == null) { return null; }
        List<ContentDocumentLink> cdocLink = new List<ContentDocumentLink>();
        Map<Id,Id> verDocData = new Map<Id,Id>();
        List<ContentVersion> versionsList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN:cVersions WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        For(Integer m=0; m<versionsList.size(); m++){
          verDocData.put(versionsList[m].Id,versionsList[m].ContentDocumentId);
        }
        for(Integer k=0; k<versionsList.size();k++){
          ContentDocumentLink cdl = new ContentDocumentLink();
          cdl.ContentDocumentId = verDocData.get(cVersions[k]);  //CRUD/FLS False+ve ID field
          cdl.LinkedEntityId = recordId; //CRUD/FLS False+ve ID field
          if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
              cdl.ShareType = 'V';
          }
          if (Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable()) {
              cdl.Visibility = 'AllUsers';
          }
          cdocLink.add(cdl);
        }
    try {
    return cdocLink;
    } catch(DMLException e) {
    return null;
    }
    }
    private static ContentVersion createContentVersion(String filename,String base64) {
        ContentVersion cv = new ContentVersion();
        if (Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()) {
            cv.VersionData = EncodingUtil.base64Decode(base64);
        }
        if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {
            cv.Title = filename;
        }
        if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {
            cv.PathOnClient = filename;
        }
        try {
          return cv;
        } catch(DMLException e) {
          return null;
        }
      }
      private static Map<String,List<Object>> getFilesIdOnTaskforId(List<String> cdIdList){
    
        String[] docIds = new String[]{};
        String[] verIds = new String[]{};
        Map<String,List<Object>> returnMap = new Map<String,List<Object>>();
        
            List<ContentDocumentLink> attObj = [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE id IN: cdIdList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            for(ContentDocumentLink cdL:attObj){
                docIds.add(cdL.ContentDocumentId);
            }
    
            List<ContentVersion> versionList = [SELECT ContentDocumentId,Id,IsLatest,Title FROM ContentVersion WHERE ContentDocumentId IN: docIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
    
            for(ContentVersion cvL:versionList){
                verIds.add(cvL.Id);
            }
            
            returnMap.put('Ids',verIds);
            returnMap.put('Records',versionList);
            return returnMap;
    }
}