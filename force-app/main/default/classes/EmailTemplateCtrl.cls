/**
*   Send Email to User, Contact, Person Account
*
*   CHANGE HISTORY
*   ===================================================
    ===================================================
*   Date            Name                Description
*   08/24/2015      Shrawan Raina       Created
*   09/02/2015      Shrawan Raina       Edited    -- Added feature to add attachments
*   27/7/2017       Shantanu Gdhe       Edited    -- removed unwanted characters from body.
*/


global with sharing class EmailTemplateCtrl {
    public static String response {get;set;}
    public static boolean isCC {get;set;}
    public static boolean isAttachment {get;set;}
    public static String isBulkMode {get;set;}
    public String isLabelShow {
        get;
        set {

            if (value != null) {
                isLabelShow = value;
            }
        }
    }

    public static boolean isUser {get;set;}
    public static invokeEmailActionInterface updRecord {
        get;
        set {
            if (value != null) {
                updRecord = value;
            }
        }
    }
    public String templateName {get;set;}
    public String fileList {get;set;}
    public Id targetId {get;set;}
   
  // map of email and target object's Id used for bulik mail  
    private Map<String,Id> emailTargetId= new Map<String,Id>(); // to set email and Id of the target object
  // This variable is used to get collection of targeted object ids in bulkmode in comma separated value 
    public String targetIds{

        get;
        set {
            if (value != null) {
                List<Id> targetIdList= (List<Id>)value.split(',');
                List<String> targetIdListSanitized = new List<String>();
                for(String str : targetIdList){
                    targetIdListSanitized.add(String.escapeSingleQuotes(str));
                }
                List<Contact> contactCon= new List<Contact>();
                List<User> Usercons = new List<User>();
                List<String> emailIds = new List<String>();
                if(targetIdList != null){
                    String type = targetIdList[0].getSObjectType().getDescribe().getName(); 
                    if(type == 'Contact'){
                        String q = 'SELECT Id, Email,accountid,account.parentId FROM Contact where Id IN: targetIdListSanitized';
                        contactCon = Database.query(String.escapeSingleQuotes(q), AccessLevel.USER_MODE);
                    }else if(type == 'User'){
                        String q = 'SELECT Id, Email,accountid,account.parentId FROM User where Id IN: targetIdListSanitized';
                        Usercons = Database.query(String.escapeSingleQuotes(q), AccessLevel.USER_MODE);
                    }
                    email='';
                    for(Contact c : contactCon){
                        if(c.get('Email') != null) {
                            emailIds.add(String.valueOf(c.get('Email')));
                            emailTargetId.put(c.Email, c.Id);
                        }
                    }
                    for(User c : Usercons){
                        if(c.get('Email') != null) {
                            emailIds.add(String.valueOf(c.get('Email')));
                            emailTargetId.put(c.Email, c.Id);
                        }
                    }
                    email =String.join(emailIds, ';'); 
                }
            }
        }
    }
    public Id whatId {get;set;}
    public String email {get;set;}
    public String email1 {get;set;}
    public String subject {get;set;}
    public String emailBody {get;set;}
    public Boolean readOnlyMode{get;set;}

    public String ccEmail {get;set;}
    public transient String documentBody {get;set;}
    public transient String documentName {get;set;}
    public transient Boolean isError {get;set;}
    public String labelFieldMap {get;

        set{
            if (value != null) {
                labelFieldMap = value;
                if(labelFieldMap.contains('&quot;')){
                    labelFieldMap= labelFieldMap.replace('&quot;','"');
                }
            }
        }
    }
    public EmailTemplateCtrl(){
        response = '';
    }
    
    public String updateRecordBefore() {
        return updRecord.actionToInvokeBefore();
    }
    public String updateRecordAfter() {
        return updRecord.actionToInvokeAfter();
    }
    
    private Boolean checkEmailAddress(String emailAddress) {
        String emailRegex = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
        List<String> ListEAddrs = emailAddress.split(';');
        for( String singleEmail : ListEAddrs) {
            if(!Pattern.compile(emailRegex).matcher(singleEmail).matches()) {
                return false;
            }
        }
        return true;            
    }
    public void sendEmailFunction() {
       if(String.isNotEmpty(labelFieldMap)){
            Map<String,String> labelMap = ( Map<String,String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(labelFieldMap), Map<String,String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
            for(String key: labelMap.keySet()){
                emailBody = emailBody.replace(labelMap.get(key), key);
            }
        }
        //As we dont get Email body when we set inputTextArea to readOnly mode.
        if(String.isEmpty(emailBody) && readOnlyMode  == true){
            Map<String, String> result = new Map<String, String>();
            result =  fetchEmailTemplate(isLabelShow,templateName,targetId,email);
            emailBody = result.get('body');
        }
        isError = false;
        if(isBulkMode == 'true' && email == null) {
            email = email1;
        }
        try {
            if(!String.isEmpty(email) && !checkEmailAddress(email)) {
                throw new CustomExceptions.InputDataException('Invalid Email Address.');
            } else if(subject == null || subject == '') {
                throw new CustomExceptions.InputDataException('Invalid Subject.');
            } else if(emailBody == null || emailBody == '') {
                throw new CustomExceptions.InputDataException('Invalid Body.');
            }
            if(isBulkMode == 'true') {
                if( !String.isEmpty(email) && !checkEmailAddress(email) ) {
                    throw new CustomExceptions.InputDataException('Invalid Email Address.');
                }
                if( !String.isEmpty(ccEmail) && !checkEmailAddress(ccEmail) ) {
                    throw new CustomExceptions.InputDataException('Invalid Email Address.');
                }
                sendEmail();
            }else {
                if( !String.isEmpty(ccEmail) && !checkEmailAddress(ccEmail) ) {
                    throw new CustomExceptions.InputDataException('Invalid Email Address.');
                }
                sendEmail();
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email Sent Successfully'));
        } catch(Exception ex) {
            isError = true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AppUtils.handleSystemExceptionMsg(ex.getMessage()))); 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AppUtils.handleSystemExceptionMsg(ex))); 
        }
    }

// Method is used to set Common Data to EmailFeeder
    public EmailFeeder setEmailDataFeeeder(){
         
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            EmailFeeder emailFeeder = new EmailFeeder();
            // User Story 118616: NED - Secondary User Email Invitation - Attachments are not sent out
            if(documentName != null && !String.isEmpty(documentName) && User.sObjectType != targetId.getsObjectType() 
             && Schema.sObjectType.Attachment.isCreateable()){ // Security Scan FLS Update. added TD
                documentBody = documentBody.substringAfter('.com/');
                Attachment objAttachment = new Attachment();
                if(Schema.sObjectType.Attachment.fields.Name.isCreateable()){
                    objAttachment.Name = documentName; 
                }
                if(Schema.sObjectType.Attachment.fields.Body.isCreateable()){
                    objAttachment.Body = EncodingUtil.base64Decode(documentBody);//Blob.valueOf(documentBody),
                }
                if(Schema.sObjectType.Attachment.isCreateable()){
                    objAttachment.ParentId = targetId; // CRUD/FLS False Positive: Id field  // User Story 118616 - Business record Id
                }
                if(Schema.sObjectType.Attachment.isCreateable()){
                    insert as user objAttachment; // Security Scan FLS Update added TD
                }
                emailFeeder.attachmentIdString(objAttachment.Id);
            }
            String body = updateMergeFields(emailBody, targetId);
            if(body != null){
                emailBody = body;
            }
            emailFeeder.htmlBody(emailBody);
            emailFeeder.subject(subject);
            if(whatId != null && !String.isEmpty(whatId)){
                emailFeeder.contextRecordId(whatId);
            }
            return emailFeeder;
    }

// function is used to send emails to EmailFeeder
    public void sendEmail() {       
        String[] newEmails;  
        if(isBulkMode != 'true'){
            if(updRecord != null) {
                String messageBefore = updateRecordBefore();
                if(messageBefore != 'success'){
                    throw new CustomExceptions.InputDataException('Before record fail.');
                }
            }
        //call this method to set email data to EmailFeeder
            EmailFeeder emailFeeder = setEmailDataFeeeder();
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
            if(updRecord != null){
                String messageAfter = updateRecordAfter();
                if(messageAfter != 'success'){
                    throw new CustomExceptions.InputDataException('After record fail.');
                }
            }
        }else{
             sendEmailInBulk(emailTargetId);
        }
    }

    global static Map<String, String> fetchEmailTemplate(String templateName, Id targetId, String email){
        return null;
    }  
 // Method call from vf page to fetch EmailTemplete Data   
    @remoteAction @AuraEnabled
    global static Map<String, String> fetchEmailTemplate(String labelShow, String templateName, Id targetId, String email){
        Map<String, String> result = new Map<String, String>();
            
        try{
            if(templateName != null && templateName != ''){

                String soql = 'SELECT Id, subject,HtmlValue,body FROM EmailTemplate WHERE DeveloperName =: '+ String.escapeSingleQuotes(templateName); //CRUD  FLS- False +ve - Std obj - WITH USER MODE removed becuase soql failing for guest and portal user. 
                List<EmailTemplate> emailTemp = Database.query(String.escapeSingleQuotes(soql));
                if(emailTemp.size() > 0){
                    String body = '';
                    String body2 = '';
                    result.put('subject', emailTemp[0].subject);
                    if(labelShow != null && labelShow == 'true' ){
                       Map<String,String> labelMap  = EmailTemplateCtrl.updateMergeFieldsBylabel(emailTemp[0].HTMLValue, targetId);
                       body = labelMap.get('emailBody');
                       String fieldMap = labelMap.get('finalMap');
                        result.put('labelFieldMap',fieldMap); 
                    }else{
                        body  = EmailTemplateCtrl.updateMergeFields(emailTemp[0].HTMLValue, targetId);
                    }                    
                    if(body != null){
                        body = EmailSenderJob.removeUnwantedCharacters(body);
                        body = EncodingUtil.urlDecode(body, 'UTF-8');
                        result.put('body', body);    
                    }
                    else{
                        result.put('body', emailTemp[0].HTMLValue);
                    }
                }
            }
        }
        catch(Exception e){ 
            result.put('Error', AppUtils.handleSystemExceptionMsg(e));
            CustomExceptions.logException(e, true, false);  
        }
        return result;
    }
    

    private static String updateMergeFields(String emailBody, Id targetId){
        if(emailBody != null){
            Map<String, Set<String>> mergeFieldMap = new Map<String, Set<String>>();
            Set<String> mergeFieldList = new Set<String>();
            Pattern p = Pattern.compile('(\\{!)(\\w+)(\\.)?(\\w+)(\\})');
            Matcher m = p.matcher(emailBody);
            while (m.find()) {//SOQL/SOSL Injection False +ve
                if(!mergeFieldMap.containsKey(m.group(2).toLowerCase())){
                    mergeFieldMap.put(m.group(2).toLowerCase(), new Set<String> { m.group(4).toLowerCase() });
                }else {
                    Set<String> value = mergeFieldMap.get(m.group(2).toLowerCase());
                    value.add(m.group(4).toLowerCase());
                    mergeFieldMap.put(m.group(2).toLowerCase(), value);
                }
                mergeFieldList.add(m.group());
            }
            Map<String, List<sObject>> fieldMap = EmailTemplateCtrl.executeSOQL(mergeFieldMap, targetId);
            Map<String, String> finalMap = new Map<String, String>();
            if(fieldMap != null){
                for(String mergeField : mergeFieldList){
                    String [] field = mergeField.substring(2, mergeField.length() - 1).split('\\.');
                    if(fieldMap.containsKey(field[0].toLowerCase())){
                        List<sObject> fields = fieldMap.get(field[0].toLowerCase());
                        if(fields.size() > 0){
                            if(fields[0].get(field[1]) != null && fields[0].get(field[1]) != ''){
                                finalMap.put(mergeField, String.valueOf(fields[0].get(field[1])));
                            }else{
                                finalMap.put(mergeField, '');
                            }
                        }
                    }
                }
            }
            if(finalMap != null){
                for(String key : finalMap.keySet()){
                    emailBody = emailBody.replace(key, finalMap.get(key));
                }
            }
            return emailBody;
        }
        return null;
    }
    
    private static Map<String, List<sObject>> executeSOQL(Map<String, Set<String>> mergeFieldMap, Id targetId){
        if(mergeFieldMap != null){
            Map<String, List<sObject>> fieldMap = new Map<String, List<sObject>>();
            for(String key : mergeFieldMap.keySet()){
                List<String> lst = new List<String>();
                lst.addAll(mergeFieldMap.get(key));
                String fields = String.join(lst, ',');
                String soql = 'SELECT ' + String.escapeSingleQuotes(fields) + ' FROM ' + String.escapeSingleQuotes(key) + ' WHERE Id =: '+ String.escapeSingleQuotes(targetId) +' LIMIT 1';
                List<sObject> obj = Database.query(String.escapeSingleQuotes(soql), AccessLevel.USER_MODE);
                if(obj.size() > 0){
                    fieldMap.put(key, obj);    
                }
            }
            return fieldMap;
        }
        else{
            return null;
        }
    }
    @TestVisible
    private static Map<String, String> getMapMergeFieldLabel(Map<String, Set<String>> mergeFieldMap, Id targetId){
        if(mergeFieldMap != null){
            Map<String,String> fieldMap = new Map<String, String>();
            
             List<String> lst = new List<String>();
            for(String key : mergeFieldMap.keySet()){
             
             lst.addAll(mergeFieldMap.get(key));
             for(String name : lst){
                try {
                    String label =Schema.getGlobalDescribe().get(key.toLowerCase()).getDescribe().fields.getMap().get(name).getDescribe().getLabel();
                    fieldMap.put(name,'{'+label+'}');
                } catch(Exception ex) {
                    ex.getMessage();
                }
             }
              
           }
            return fieldMap;
        }
        else{
            return null;
        }
    }

    @TestVisible
    private static Map<String, String> updateMergeFieldsBylabel(String emailBody1, Id targetId){
        if(emailBody1 != null){
            Map<String, String> mergeFieldLabelMap = new Map<String, String>();
            Map<String, Set<String>> mergeFieldMap = new Map<String, Set<String>>();
            Set<String> mergeFieldList = new Set<String>();
            Pattern p = Pattern.compile('(\\{!)(\\w+)(\\.)?(\\w+)(\\})');
            Matcher m = p.matcher(emailBody1);
            while (m.find()) {//SOQL/SOSL Injection False +ve
                if(!mergeFieldMap.containsKey(m.group(2))){
                    mergeFieldMap.put(m.group(2), new Set<String> { m.group(4)});
                }else {
                    Set<String> value = mergeFieldMap.get(m.group(2));
                    value.add(m.group(4));
                    mergeFieldMap.put(m.group(2), value);
                }
                mergeFieldList.add(m.group());
            }
           
            Map<String, String> fieldMap = EmailTemplateCtrl.getMapMergeFieldLabel(mergeFieldMap, targetId);
            Map<String, String> finalMap = new Map<String, String>();
            if(fieldMap != null){
                for(String mergeField : mergeFieldList){
                    String [] field = mergeField.substring(2, mergeField.length() - 1).split('\\.');
                    if(fieldMap.containsKey(field[1])){
                        finalMap.put(mergeField, fieldMap.get(field[1]));
                    }
                }
            }
            if(finalMap != null){
               mergeFieldLabelMap.put('finalMap',JSON.serialize(finalMap));
                for(String key : finalMap.keySet()){
                    emailBody1 = emailBody1.replace(key, finalMap.get(key));
                }
                mergeFieldLabelMap.put('emailBody',emailBody1);
            }
            return mergeFieldLabelMap;
        }
        return null;
    }    

// Method is used to send mail in bulk
    public void sendEmailInBulk(Map<String,Id> targetIds){
        List<EmailFeeder> EmailFeederList = new  List<EmailFeeder>();
        for(String key : targetIds.keySet()){

          
            EmailFeeder emailFeeder = setEmailDataFeeeder();
            emailFeeder.toEmail((key)); 
            emailFeeder.TargetObjectId(targetIds.get(key));
            EmailFeederList.add(emailFeeder);
            //emailFeeder.send();
            if(updRecord != null){
                String messageAfter = updateRecordAfter();
                if(messageAfter != 'success'){
                    throw new CustomExceptions.InputDataException('After record fail.');
                }
            }

        }
        EmailFeeder.SendEmails(EmailFeederList);
    }
    @TestVisible 
    public with sharing class EmailTemplateWrapper{
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
        

       public EmailTemplateWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
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