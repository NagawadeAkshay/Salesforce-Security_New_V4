/*
    Batch class to send the emails by fetching EmailQueue__c Records. 
    **********************************************************
    Audit History
    
    **********************************************************
    2017-05-15         Shantanu Gadhe            Created.
    2017-12-07         Shantanu Gadhe            Updated(created cloneEmailsforQueueMembers method to 
                                                         send emails to all members of the queue). 
    2018-03-21         Atul Naik                 Updated(Add Facility Merge Field Support for User,Account,Organization)                                                                   
    **********************************************************  
*/
global with sharing class EmailSenderJob implements Database.Batchable<sObject> {
    private String emailQueueStatus = 'Queued';
    private String query = 'SELECT Id FROM EmailQueue__c WHERE Status__c =:emailQueueStatus';
    public static String communityUrl = '{COMMUNITY_URL}';
    public static String siteUrl = '{SITE_URL}'; 
    public static String instanceName = '{INSTANCE_NAME}';
    public static String objectLabel = '{OBJECT_LABEL}';
    public static String baseUrl = '{BASE_URL}';
    
    global Database.QueryLocator start(Database.BatchableContext bachableCon){         
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bachableCon, List<EmailQueue__c> scope) {
          /*
          get all the records of EmailQueue__c and create the set of ToEmails,
          recordIds,Template Names and check set of ToEmails and Template Names for validation 
          change the Status__c and ErrorMessage__c Accordingly 
          */
        
        processRecords(scope);
        
    }   
    
    global void finish(Database.BatchableContext bachableCon){
    }
    
    public static void processRecords(List<EmailQueue__c> scope) {
        try {
            if(EmailQueue__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.EmailQueue__c.fields.AttachmentIds__c.isAccessible()
            && Schema.SObjectType.EmailQueue__c.fields.BccEmails__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.CcEmails__c.isAccessible() 
            && Schema.SObjectType.EmailQueue__c.fields.contextRecordIds__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.ErrorMessage__c.isAccessible()
            && Schema.SObjectType.EmailQueue__c.fields.ReplyEmail__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.HtmlBody__c.isAccessible()
            && Schema.SObjectType.EmailQueue__c.fields.OrgWideFromEmail__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.PlainTextBody__c.isAccessible()
            && Schema.SObjectType.EmailQueue__c.fields.ProcessedDate__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.Status__c.isAccessible()
            && Schema.SObjectType.EmailQueue__c.fields.Subject__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.TemplateName__c.isAccessible() 
            && Schema.SObjectType.EmailQueue__c.fields.ToEmails__c.isAccessible() && Schema.SObjectType.EmailQueue__c.fields.TargetObjectId__c.isAccessible()
            && Schema.SObjectType.EmailQueue__c.fields.RecordSnapshot__c.isAccessible()) {
                List<EmailQueue__c> queue = [SELECT AttachmentIds__c,BccEmails__c,CcEmails__c,CreatedById,
                contextRecordIds__c,ErrorMessage__c,ReplyEmail__c,HtmlBody__c,OrgWideFromEmail__c,
                PlainTextBody__c,ProcessedDate__c,Status__c,Subject__c,
                TemplateName__c,ToEmails__c,TargetObjectId__c,RecordSnapshot__c,OwnerId,CreatedBy.OrganizationId__c
                FROM EmailQueue__c where id IN :scope WITH USER_MODE];
                Set<String> emails = new Set<String>();
                Set<String> recordIds = new Set<String>();   
                Set<String> templateNames = new Set<String>();
                Set<String> emailAttachmentsIds = new Set<String>();
                List<EmailQueue__c> queueWithSuccess = new List<EmailQueue__c>();
                List<EmailQueue__c> queueWithError = new List<EmailQueue__c>();
                List<String> groupIds = new List<String>();
                //Owner Id,User,Account,Organization List for Merge Field Support
                List<String> ownerIdList = new List<String>();
                List<String> accOrgnaizationIdList = new List<String>();
                List<String> userMergeFieldsList = new List<String>();
                List<String> acctMergeFieldsList = new List<String>();
                List<String> orgMergeFieldsList = new List<String>();
                // User Merege Field Handler
                List<User> userList = new List<User>();
                List<Account> accList = new List<Account>();
                List<Organization> orgList = new List<Organization>(); 

                // Iterate Owner Id From Email-Queue
                ownerIdList = iterateOwnerIdFromQueue(queue);
                // Iterate User Account Id From Email Queue
                accOrgnaizationIdList = iterateOrganizationIdFromQueue(queue);
                collectIds(queue, emails, recordIds, templateNames, emailAttachmentsIds, queueWithSuccess, queueWithError, groupIds);               
                Map<String, Attachment> attachmentMap = new Map<String, Attachment>();
                Map<String, ContentVersion> contentMap = new Map<String, ContentVersion>();
                getAttachmentsMap(emailAttachmentsIds,attachmentMap,contentMap);
                //get sobjectName and related record Ids
                Map<String,Set<String>> recordMap = getSObjectAndRelatedRecordIds(recordIds);   
                Map<String,User> userMap = getUserMap(emails); 
                Map<String, String> grpWithEmailId = getGropWithEmailId(groupIds);
            
                // Map of templateName and EmailTemplate Object  
                Map<String,EmailTemplate> templatesMap = getTemplateMap(templateNames); 
                //Map of SobjectName and related fields 
                Map<String, Set<String>> fieldsMap = new Map<String, Set<String>>();  
                Map<String, sObject> recordIdWithObject = new Map<String, sObject>();
                queueWithSuccess = processGetMergeFields(queueWithSuccess, fieldsMap, templatesMap, queueWithError, userMergeFieldsList, acctMergeFieldsList, orgMergeFieldsList);
                
                //Map of record Id and related sObject
                getRecordIdwithrelatedSObject(fieldsMap, recordMap, recordIdWithObject);
                
                /* This Method Support For Iterating Fields Value*/
                getUserAccountFieldValue(userMergeFieldsList, acctMergeFieldsList, orgMergeFieldsList, userList, accList, orgList, ownerIdList, accOrgnaizationIdList);
                

                List<EmailQueue__c> queueToBeProcessList = new List<EmailQueue__c>();
                List<Messaging.SingleEmailMessage> queuedEmailsList = createSingleEmails(queueWithSuccess, templatesMap, recordIdWithObject,
                                        fieldsMap, attachmentMap, contentMap, userMap, queueWithError, queueToBeProcessList, grpWithEmailId, userList,
                                    accList, orgList, userMergeFieldsList, acctMergeFieldsList, orgMergeFieldsList);
                sendEmails(queuedEmailsList, queueToBeProcessList);
                if(Schema.sObjectType.EmailQueue__c.isCreateable() && Schema.sObjectType.EmailQueue__c.isUpdateable()){
                    Database.upsert(queueWithError, false, AccessLevel.USER_MODE);
                }
            }
        } catch(Exception ex) {
            String errorMsg = 'Batch failed with unexpeccted error. Please contact administrator. Error:' + 
            '----\n--------getMessage------' + ex.getMessage() +
                '----\n--------StackTrace------' + ex.getStackTraceString();
            for(EmailQueue__c emailQueue : scope) {
                if(Schema.sObjectType.EmailQueue__c.fields.Status__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Status__c.isUpdateable()){
                    emailQueue.Status__c = 'Failed';
                }
                if(Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isUpdateable()){
                    emailQueue.ErrorMessage__c = errorMsg;
                }
            }
            if(Schema.sObjectType.EmailQueue__c.isCreateable() && Schema.sObjectType.EmailQueue__c.isUpdateable()){
                Database.upsert(scope, false, AccessLevel.USER_MODE);
            }
        }
    }

    /* OwnerId List is Maintained for Merge Field Support */
    private static List<String> iterateOwnerIdFromQueue(List<EmailQueue__c> queueList){
       List<String> ownerIdList = new List<String>();
       if(queueList.size() > 0){
           for(EmailQueue__c eq : queueList){
              
              ownerIdList.add(string.escapeSingleQuotes(eq.OwnerId));
           }
       }
       return ownerIdList;
    }

    /* User Account List is Maintained for Merge Field Support */
    private static List<String> iterateOrganizationIdFromQueue(List<EmailQueue__c> queueList){
        List<String> accOrgIdList = new List<String>();
        if(queueList.size() > 0){
           for(EmailQueue__c eq : queueList){
              accOrgIdList.add(string.escapeSingleQuotes(eq.CreatedBy.OrganizationId__c));
           }
       }
       return accOrgIdList;
    }
    
    private static void sendEmails(List<Messaging.SingleEmailMessage> queuedEmailsList, List<EmailQueue__c> queueList) {
        List<Messaging.SendEmailResult> resultList = Messaging.sendEmail(queuedEmailsList, false);
        Integer Index = 0;
        for(Messaging.SendEmailResult result : resultList) {
            if (!result.isSuccess()) {
                String errorMessage = result.getErrors()[0].getMessage();
                EmailQueue__c q = queueList.get(index);
                if(Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isUpdateable()){
                    q.ErrorMessage__c = errorMessage;
                }
                if(Schema.sObjectType.EmailQueue__c.fields.Status__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Status__c.isUpdateable()){
                    q.Status__c = 'Failed';
                }
            }
            Index++;
        }
        if(Schema.sObjectType.EmailQueue__c.isCreateable() && Schema.sObjectType.EmailQueue__c.isUpdateable()){
            Database.upsert(queueList,false, AccessLevel.USER_MODE);
		}
    }
    // todo - handle bulkify
    // todo - Add support for Heirarchical custom setting
    private static String replaceCustomSetting(String body){
        if(String.isEmpty(body)){
            return body;
        }
        Pattern regex = Pattern.compile('\\{CT(.)*\\}'); 
        Matcher myMatcher = regex.matcher(body); 

        while(myMatcher.find()) {//SOQL/SOSL Injection False +ve
            if(myMatcher.group() != null) {               
                String matchStr = myMatcher .group().replace('{CT.', '').replace('}', '');                             
                List<String> exp = matchstr.split('\\.');
                String nameValue = string.escapeSingleQuotes(exp[2]);
                List<sObject> obj = Database.query('SELECT '+string.escapeSingleQuotes(exp[1])+' from '+string.escapeSingleQuotes(exp[0])+' where Name =:nameValue', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                if(obj.size() == 0){
                    body = body.replace(myMatcher.group(),'');
                }
                else{
                    body = body.replace(myMatcher.group(),String.valueOf(obj[0].get(exp[1])));
                }            
            }       
        }
        return body;
    }
    
    private static Map<String, String> getGropWithEmailId(List<String> groupIds) {
        Map<String, String> groupByEmail = new Map<String, String>();
        if(groupIds.size() > 0) {
              List<Group> groups = [SELECT Email,Id,Type FROM Group where Id in:groupIds and Email != null and Type != 'Queue' WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(Group grp : groups) {                
                        groupByEmail.put(grp.Id, grp.Email);                               
                }
        }
        return groupByEmail;
    }
    
   

    private static String repalceConstants(String body, String recordId) {
        if(String.isEmpty(body)) {
            return body;
        }
        if(keyValueStoreHelper.getTextValue('ExternalLoginPage', true) != null ) {
            body = body.replace(communityUrl, keyValueStoreHelper.getTextValue('ExternalLoginPage', true));
        }
        if(keyValueStoreHelper.getTextValue('InternalLoginPage', true) != null ) {
            body = body.replace(siteUrl, keyValueStoreHelper.getTextValue('InternalLoginPage', true));
        }
        if(String.isNotEmpty(recordId)) {
            String objLabel = ((Id)recordId).getSObjectType().getDescribe().getLabel();
            body = body.replace(objectLabel, objLabel);
        }
        if(body.contains(instanceName)) {
            String intanceURL = [Select InstanceName from Organization WITH USER_MODE LIMIT 1].InstanceName;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            body = body.replace(instanceName, intanceURL);
        }
        if(body.contains(baseUrl)) {
            String baseURL = System.URL.getOrgDomainUrl().toExternalForm();
            body = body.replace(baseUrl, baseURL);
        }
        return body;
    }

    //Pankaj: There are queries inside for loop. It won't cause issue as batch size is 10 but we need to look into it.
    private static String massageBrandTemplate(Map<String,EmailTemplate> templatesMap, EmailQueue__c q) {
        if(String.isEmpty(q.HtmlBody__c) ==  true) {
            return q.HtmlBody__c;
        }
        String brandTemplateId = null;
        if(q.TemplateName__c != null && templatesMap.get(q.TemplateName__c) != null) {
            brandTemplateId = templatesMap.get(q.TemplateName__c).BrandTemplateId;
        }
        //if brand template is not associated then check for template at account level and use it.
        if(brandTemplateId == null) {
            brandTemplateId = getAccountBrandTemplateName(q.CreatedById);
            if(brandTemplateId == null){
                if(Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isUpdateable()){
                    q.HtmlBody__c =  EncodingUtil.urlDecode(q.HtmlBody__c, 'UTF-8');
                }
            }            
        }
        if(brandTemplateId != null) {
            List<BrandTemplate> brandTemplates = [SELECT Id,Value FROM BrandTemplate where Id=:brandTemplateId or DeveloperName=:brandTemplateId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(brandTemplates.size() > 0 &&  brandTemplates.get(0).value != null) {
                String brandTemplate = removeUnwantedCharacters(brandTemplates.get(0).value);
                if(Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isUpdateable()){
                    q.HtmlBody__c = getMassasedBody(brandTemplate, q.HtmlBody__c);
                    q.HtmlBody__c = '<style>p{margin-top:0px; margin-bottom:0px;}</style>' + q.HtmlBody__c.unescapeHtml4(); 
                    q.HtmlBody__c =  EncodingUtil.urlDecode(q.HtmlBody__c, 'UTF-8');
                }
            }
        }
        return q.HtmlBody__c;
    }

    private static String getAccountBrandTemplateName(Id createUser) {
        if(createUser == null){
            return null;
        }
        
        if(User.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.User.fields.OrganizationId__c.isAccessible()){
            String orgId = [SELECT OrganizationId__c FROM User WHERE Id =: createUser].OrganizationId__c;
            String brandTemplateName = null;
            do {
                if(orgId == null){
                    break;
                }
                if(Account.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Account.fields.LetterHeadDeveloperName__c.isAccessible()) {
                    List<Account> accts = [SELECT LetterHeadDeveloperName__c, ParentId FROM Account WHERE Id =: orgId WITH USER_MODE];
                    if(accts.size() > 0) {
                        brandTemplateName = accts[0].LetterHeadDeveloperName__c;
                        if(brandTemplateName != null || accts[0].ParentId == null){
                            break;
                        }
                        orgId = accts[0].ParentId;    
                    }else{
                        break;
                    }
                }            
            }while(true);
            return brandTemplateName;
        }
       return null;
    }

    private static String getMassasedBody(String brandTemplate, String emailTemplate) {
        Dom.Document inDoc = new Dom.Document();
        inDoc.load(brandTemplate);
        Dom.XmlNode root = inDoc.getRootElement();
        updateStyleAttr(root);
        List<String> imgListToRemove = new List<String>();
        processNode(root, emailTemplate, imgListToRemove);
        String emailDOMString = inDoc.toXmlString();
        for(String imgURL : imgListToRemove) {
            emailDOMString = emailDOMString.replace(imgURL, '><');
        }
        return emailDOMString;
    }

    private static String processNode(Dom.XmlNode xmlNode, String emailTemplate, List<String> imgListToRemove) {
        String labelVal = updateStyleAttr(xmlNode);
        processImageTag(xmlNode, imgListToRemove);
        Dom.XmlNode[] childnodes = xmlNode.getChildElements();
        for(Dom.XmlNode xmlNode1 : childnodes) {
            processNode(xmlNode1, emailTemplate, imgListToRemove);
        }
        if(labelVal != null && labelVal.equalsIgnoreCase('main')) {
            xmlNode.addTextNode(emailTemplate);
        }
        return '';
    }


    private static String updateStyleAttr(Dom.XmlNode tag) {
        String returnStr = '';
        Dom.XmlNode aTag = tag.getChildElement('style', null);
        if(aTag != null) {
            String attrStr = '';
            for(Integer i=0; i<aTag.getAttributeCount(); i++) {
                String attr = aTag.getAttributeKeyAt(i);
                String value = aTag.getAttributeValue(attr, '');
                if(attr == 'bLabel') { 
                    returnStr = value;
                }
                attrStr += attr + ':' + value+'; ';
            }
            tag.removeChild(aTag);
            tag.setAttribute('Style', attrStr);
        }
        return returnStr;
    }

    private static void processImageTag(Dom.XmlNode xmlNode, List<String> imgListToRemove) {
        if(xmlNode.getName().equalsIgnoreCase('img')) {
            String imageURL = xmlNode.getText();
            if(String.isNotEmpty(imageURL)) {
                imgListToRemove.add('>' + imageURL + '<');
                xmlNode.setAttribute('src', System.URL.getOrgDomainUrl().toExternalForm() + imageURL);
            }
        }
    }

    public static String removeUnwantedCharacters(String body) {
        if(String.isEmpty(body)){
            return body;
        }
        body = reveCDATATag(body);
        body = body.replace('\n', '');
        string HTML_TAG_PATTERN = '>.*?<';
        pattern myPattern = pattern.compile(HTML_TAG_PATTERN);
        matcher myMatcher = myPattern.matcher(body);
        while(myMatcher.find()) {//SOQL/SOSL Injection False +ve
            if(!myMatcher.group().equalsIgnoreCase('><')) {
                String matchStr = myMatcher.group().replace('>', '').replace('<', '');
                //remove all tags and convert to plane
                String encoded = EncodingUtil.urlEncode(matchStr, 'UTF-8');
                body = body.replace(matchStr, encoded);

            }
            
        }
        return body;
    }

    private static String reveCDATATag(String body) {
        if(String.isEmpty(body)){
            return body;
        }
        body = body.replace('<![CDATA[', '').replace(']]>', '');
        return body;
    }
    
    private static List<Messaging.SingleEmailMessage> createSingleEmails(List<EmailQueue__c> queue, Map<String,EmailTemplate> templatesMap,  Map<String, sObject> recordIdWithObject, Map<String, Set<String>> fieldsMap,
            Map<String, Attachment> attachmentMap,Map<String, ContentVersion> contentMap, Map<String,User> userMap, List<EmailQueue__c> queueWithError, List<EmailQueue__c> queueToBeProcessList, Map<String, String> grpWithEmailId, List<User> userList,
                            List<Account> accList, List<Organization> orgList, List<String> userMergeFieldsList, List<String> acctMergeFieldsList, List<String> orgMergeFieldsList) {
        List<Messaging.SingleEmailMessage> queuedEmails = new List<Messaging.SingleEmailMessage>();
         Map<Id, User> userMergeMap = new Map<Id, User>();
         Map<Id, Account> accMergeMap = new Map<Id, Account>();
        List<User> userValList = new List<User>();
        List<Account> accountList = new List<Account>();
        if(userList !=null && userList.size() > 0){
             for(User u:userList){
                userMergeMap.put(u.Id,u);
            } 
        }
        if(accList !=null && accList.size() > 0){
            for(Account acc: accList){
                accMergeMap.put(acc.Id, acc);
            }
        }
        
        
        for(EmailQueue__c q: queue) {
            try {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //get target object id
                String tagetObjectId;
                if(q.TargetObjectId__c != null){
                    
                    tagetObjectId = q.TargetObjectId__c;
                    if(q.TargetObjectId__c.startsWith('00G')) {
                        String emailId = grpWithEmailId.get(q.TargetObjectId__c);
                        if(String.isNotEmpty(emailId)) {
                            List<String> toEmail = emailId.split(','); 
                            mail.setToAddresses(toEmail);
                        } 
                    } else {
                        mail.setTargetObjectId(q.TargetObjectId__c);
                    }
                    
                } else {
                    List<String> toEmail = q.ToEmails__c.split(',');                          
                    if(toEmail.size() == 1){
                        user u = userMap.get(toEmail[0]);
                        if(u == null){
                            mail.setToAddresses(toEmail);
                        }else{
                            mail.setTargetObjectId(u.Id);
                            tagetObjectId = u.Id;
                        }         
                    }else{
                        mail.setToAddresses(toEmail);
                    } 
                }
                if(Schema.sObjectType.EmailQueue__c.fields.Subject__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Subject__c.isUpdateable()){
                    q.Subject__c =  replaceMergeFields(q.Subject__c, q.contextRecordIds__c, q.TargetObjectId__c,q.RecordSnapshot__c, recordIdWithObject, fieldsMap);
                    q.Subject__c = replaceCustomSetting(q.Subject__c);
                }
                if(Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isUpdateable()){
                    q.HtmlBody__c = replaceMergeFields(q.HtmlBody__c, q.contextRecordIds__c, q.TargetObjectId__c,q.RecordSnapshot__c, recordIdWithObject, fieldsMap);
                    q.HtmlBody__c = replaceCustomSetting(q.HtmlBody__c);
                    if(q.HtmlBody__c != null){
                        q.HtmlBody__c =  EncodingUtil.urlEncode(q.HtmlBody__c, 'UTF-8');
                    }                    
                    q.HtmlBody__c = massageBrandTemplate(templatesMap, q);
                    q.HtmlBody__c = repalceConstants(q.HtmlBody__c, q.contextRecordIds__c);
                    q.HtmlBody__c = reveCDATATag(q.HtmlBody__c);
                    //Replace Html Body User Fields Merge Fields with Value.
                    if(userMergeMap !=null && userMergeMap.get(q.OwnerId) != null){
                        userValList.add(userMergeMap.get(q.OwnerId));
                        q.HtmlBody__c = AppUtils.replceMergeFieldsList(q.HtmlBody__c, userValList, userMergeFieldsList);
                    }
                    //Replace Html Body User Account Merge Field with value.
                    if(accMergeMap !=null && accMergeMap.get(q.CreatedBy.OrganizationId__c) != null){
                        accountList.add(accMergeMap.get(q.CreatedBy.OrganizationId__c));
                        q.HtmlBody__c = AppUtils.replceMergeFieldsList(q.HtmlBody__c, accountList, acctMergeFieldsList);
                    }
                        
                    //Replace Html Body User Organization Merge Field with value.
                    
                    if(orgList.size() > 0){
                        q.HtmlBody__c = AppUtils.replceMergeFieldsList(q.HtmlBody__c, orgList, orgMergeFieldsList);
                    }
                }
                if(Schema.sObjectType.EmailQueue__c.fields.PlainTextBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.PlainTextBody__c.isUpdateable()){
                    q.PlainTextBody__c = replaceMergeFields(q.PlainTextBody__c, q.contextRecordIds__c, q.TargetObjectId__c,q.RecordSnapshot__c, recordIdWithObject, fieldsMap);
                    q.PlainTextBody__c = replaceCustomSetting(q.PlainTextBody__c);                   
                    q.PlainTextBody__c = repalceConstants(q.PlainTextBody__c, q.contextRecordIds__c);
                    q.PlainTextBody__c = reveCDATATag(q.PlainTextBody__c);
                }

                if(Schema.sObjectType.EmailQueue__c.fields.Status__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Status__c.isUpdateable()){
                    q.Status__c = 'Processed';
                }
                if(Schema.sObjectType.EmailQueue__c.fields.ProcessedDate__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.ProcessedDate__c.isUpdateable()){
                    q.ProcessedDate__c = System.now();
                }
                
                mail.setHtmlBody(q.HtmlBody__c);
                mail.setPlainTextBody(q.PlainTextBody__c);
                mail.setSubject(q.Subject__c);     
                
                
                if(q.CcEmails__c != null){
                    List<String> ccEmail = q.CcEmails__c.split(',');
                    mail.setCcAddresses(ccEmail);     
                }
                if(q.BccEmails__c != null){
                    List<String> bccEmail = q.BccEmails__c.split(',');
                    mail.setBccAddresses(bccEmail);
                }             
                List<String> emailAttachments = new List<String>();
                if(q.AttachmentIds__c != null){
                    emailAttachments = q.AttachmentIds__c.split(',');
                } 
                if(q.ReplyEmail__c != null){
                    mail.setReplyTo(q.ReplyEmail__c);
                    
                }
                if(q.OrgWideFromEmail__c == null){
                    if(keyValueStoreHelper.getTextValue('DefaultOrgWideEmailAddress', true) != null ){
                        if(Schema.sObjectType.EmailQueue__c.fields.OrgWideFromEmail__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.OrgWideFromEmail__c.isUpdateable()){
                            q.OrgWideFromEmail__c = KeyValueStoreHelper.getTextValue('DefaultOrgWideEmailAddress',true);
                        }
                    }else{
                        mail.setSenderDisplayName(q.Owner.Name);
                    }
                }
                if(q.OrgWideFromEmail__c != null){
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:q.OrgWideFromEmail__c WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        mail.setSenderDisplayName(q.Owner.Name);
                    }   
                }
                mail.setFileAttachments(  getFileAttachments(emailAttachments, attachmentMap, contentMap) );
                mail.saveAsActivity = false; 
                queuedEmails.add(mail);
                queueToBeProcessList.add(q);

            } catch(Exception ex) {
                if(Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isUpdateable()){
                    q.ErrorMessage__c = AppUtils.handleSystemExceptionMsg(ex) + '\n--------StackTrace------\n' + ex.getStackTraceString();   
                }
                if(Schema.sObjectType.EmailQueue__c.fields.Status__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Status__c.isUpdateable()){
                    q.Status__c = 'Failed';
                }
                queueWithError.add(q);
            }
        }
        return queuedEmails;
    }
    
    private static void collectIds( List<EmailQueue__c> queue, Set<String> emails, Set<String> recordIds, Set<String> templateNames, Set<String> emailAttachmentsIds, 
                        List<EmailQueue__c> queueWithSuccess, List<EmailQueue__c> queueWithError, List<String> groupIds) {
        for(EmailQueue__c q : queue) { 
            if(q.TemplateName__c != null) {
                templateNames.add(q.TemplateName__c);                         
            }          
            if(!validate(q)) {
                queueWithError.add(q);
                continue;
            } 
            queueWithSuccess.add(q);                                      
            if(q.ToEmails__c != null) {
                emails.addAll(q.ToEmails__c.split(','));
            }            
            if(q.contextRecordIds__c != null) {
                recordIds.addAll(q.contextRecordIds__c.split(','));
            }
            if(q.TargetObjectId__c != null) {
                recordIds.addAll(q.TargetObjectId__c.split(','));
                if(q.TargetObjectId__c.startsWith('00G')) {
                    groupIds.addAll(recordIds);
                }
            }             
            if(q.AttachmentIds__c != null) {
                  emailAttachmentsIds.addAll(q.AttachmentIds__c.split(','));                
            }      
        }
        cloneEmailsforQueueMembers(groupIds,queueWithSuccess,recordIds);
    }
    
    private static void cloneEmailsforQueueMembers(List<String> groupIds, List<EmailQueue__c> queueWithSuccess, Set<String> recordIds){
        List<GroupMember>  queueMembers = [SELECT GroupId,UserOrGroupId,Id from GroupMember where GroupId IN:groupIds AND Group.Type ='Queue' WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Map<String,Set<String>> membersMap = new Map<String,Set<String>>();
        List<EmailQueue__c> queueMembersEmails = new List<EmailQueue__c>();
        for(GroupMember member:queueMembers){
                if(membersMap.get(member.GroupId) == null){
                    membersMap.put(member.GroupId,new Set<String>());
                }
                membersMap.get(member.GroupId).add(member.UserOrGroupId);
        }
        if(Schema.sObjectType.EmailQueue__c.fields.TargetobjectId__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.TargetobjectId__c.isUpdateable()){ 
           for(EmailQueue__c queue: queueWithSuccess){
                Id TargetObjectId = queue.TargetObjectId__c;
               if(membersMap.get(TargetObjectId) != null){
                    recordIds.addAll(membersMap.get(TargetObjectId));
                    Boolean cloned = false;
                    for (String memberId:membersMap.get(TargetObjectId)){
                        if(cloned == false){
                           queue.TargetobjectId__c = memberId;
                           cloned=true;                         
                        }else{
                            EmailQueue__c eq = new EmailQueue__c();
                            eq = queue.clone(false, false, false, false);
                            eq.TargetobjectId__c = memberId;
                            queueMembersEmails.add(eq);
                        }                                                                           
                    }
                }
            }
        }
        queueWithSuccess.addAll(queueMembersEmails);
    }
    
    private static List<EmailQueue__c> processGetMergeFields(List<EmailQueue__c> queue, Map<String,Set<String>> fieldsMap, Map<String,EmailTemplate> templatesMap, List<EmailQueue__c> queueWithError, List<String> userMergeFieldsList, List<String> acctMergeFieldsList, List<String> orgMergeFieldsList) {
        List<EmailQueue__c> emailQueueWithSuccess = new List<EmailQueue__c>();
        for(EmailQueue__c q: queue) {
            try {
                getMergeFieldForQueue(q, fieldsMap, templatesMap, userMergeFieldsList, acctMergeFieldsList, orgMergeFieldsList);
                emailQueueWithSuccess.add(q);
            } catch(Exception ex) {
                if(Schema.sObjectType.EmailQueue__c.fields.Status__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Status__c.isUpdateable()){ 
                    q.Status__c = 'Failed';
                }
                if(Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.ErrorMessage__c.isUpdateable()){ 
                    q.ErrorMessage__c = AppUtils.handleSystemExceptionMsg(ex);
                }
                if(Schema.sObjectType.EmailQueue__c.fields.ProcessedDate__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.ProcessedDate__c.isUpdateable()){ 
                    q.ProcessedDate__c = system.now();
                }
                queueWithError.add(q);
            }
        }
        return emailQueueWithSuccess;
    }

    private static void getMergeFieldForQueue(EmailQueue__c q, Map<String,Set<String>> fieldsMap, Map<String,EmailTemplate> templatesMap, List<String> userMergeFieldsList, List<String> acctMergeFieldsList, List<String> orgMergeFieldsList) {

        if(q.TemplateName__c != null){
            EmailTemplate template= templatesMap.get(q.TemplateName__c);

            if(template == null){
                throw new CustomExceptions.InputDataException('Template Developer Name incorrect or does not exist : '+q.TemplateName__c) ;
            }
           if(Schema.sObjectType.EmailQueue__c.fields.Subject__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Subject__c.isUpdateable()){   
                q.Subject__c = template.Subject;
            }
            if(Schema.sObjectType.EmailQueue__c.fields.HTMLBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.HTMLBody__c.isUpdateable()){ 
                if(template.TemplateType.equalsIgnoreCase('visualforce')) {
                    Messaging.SingleEmailMessage singleEmail = Messaging.renderStoredEmailTemplate(template.id, q.TargetObjectId__c, q.contextRecordIds__c );
                    q.HtmlBody__c = singleEmail.htmlBody;
                    if(q.HTMLBody__c == null) {
                        q.HTMLBody__c = template.Body;
                    }
                } else {
                    if(template.Htmlvalue != null){
                        q.HtmlBody__c = template.HtmlValue;
                    }
                    else{
                        q.HtmlBody__c = template.Body;
                    } 
                }
            }
        } 
        List<String> plainTextMergeFields = AppUtils.getMergeFields(q.PlainTextBody__c);
        if(Schema.sObjectType.EmailQueue__c.fields.PlainTextBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.PlainTextBody__c.isUpdateable()){ 
            q.PlainTextBody__c = getsObjectAndRelatedFields(plainTextMergeFields, fieldsMap, q.PlainTextbody__c);
        }
        Map<String, Set<String>> jsonMap = AppUtils.getJSONMergeFields(q.PlainTextbody__c);
        for(String objName : jsonMap.KeySet()) {
            if(fieldsMap.get(objName) == null) {
                fieldsMap.put(objName, new Set<String>());
            }
            fieldsMap.get(objName).addAll(jsonMap.get(objName));
        }

        List<String> subjectMergeFields = AppUtils.getMergeFields(q.Subject__c);
        if(Schema.sObjectType.EmailQueue__c.fields.Subject__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.Subject__c.isUpdateable()){ 
            q.Subject__c = getsObjectAndRelatedFields(subjectMergeFields, fieldsMap, q.Subject__c);
        }
        
        List<String> bodyMergeFields = AppUtils.getMergeFields(q.HtmlBody__c);
        if(Schema.sObjectType.EmailQueue__c.fields.HTMLBody__c.isCreateable() && Schema.sObjectType.EmailQueue__c.fields.HTMLBody__c.isUpdateable()){ 
            q.HtmlBody__c = getsObjectAndRelatedFields(bodyMergeFields, fieldsMap, q.HtmlBody__c);
        }
        
        List<String> objAPINameList = new List<String>();
        objAPINameList.add('User');
        /* Get User Merge Fields from Apputils 
           Eg Pass Parameter {!User.Name} --> It return Name*/
        if(AppUtils.getMergeFieldSupport(q.HtmlBody__c,objAPINameList) !=null){
            userMergeFieldsList.addAll(AppUtils.getMergeFieldSupport(q.HtmlBody__c,objAPINameList));
        }

        /* Get Account Merge Fields from Apputils 
           Eg Pass Parameter {!Account.Name} --> It return Name*/
        if(AppUtils.getMergeFieldSupport(q.HtmlBody__c,objAPINameList) !=null){
            acctMergeFieldsList.addAll(AppUtils.getMergeFieldSupport(q.HtmlBody__c,objAPINameList));
        } 

        /* Get Organization Merge Fields from Apputils 
           Eg Pass Parameter {!Organization.Name} --> It return Name*/
        if(AppUtils.getMergeFieldSupport(q.HtmlBody__c,objAPINameList) !=null){
            orgMergeFieldsList.addAll(AppUtils.getMergeFieldSupport(q.HtmlBody__c,objAPINameList));
         }

        jsonMap = AppUtils.getJSONMergeFields(q.HtmlBody__c);
        for(String objName : jsonMap.KeySet()) {
            if(fieldsMap.get(objName) == null) {
                fieldsMap.put(objName, new Set<String>());
            }
            fieldsMap.get(objName).addAll(jsonMap.get(objName));
        }
    }

   private static List<Organization> getUserOrganizationReleatedFields(List<String> orgMergeFieldsList){
     List<Organization> orgObjList = new List<Organization>();
     String orgId = String.escapeSingleQuotes(UserInfo.getOrganizationId());
     Set<String> orgMergeFieldsSet = new Set<String>(orgMergeFieldsList);
     orgMergeFieldsList = new List<String>(orgMergeFieldsSet);
      if(orgMergeFieldsList.size() > 0){
         orgObjList = Database.query('SELECT '+String.escapeSingleQuotes(String.join(orgMergeFieldsList, ',')) + ',' +' CreatedById FROM Organization WHERE Id =:orgId', AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static Bind
      }
      return orgObjList;
   }
    
   // Get User Account Object Related Fields List 
   private static List<Account> getUserAccountObjectRelatedFields(List<String> acctFieldsToQueryList, List<String> accOrgnaizationIdList){
      Set<String> acctFieldsSet = new Set<String>(acctFieldsToQueryList);
      List<Account> accountObjList = new List<Account>();
      acctFieldsToQueryList = new List<String>(acctFieldsSet);
      List<String> accOrgnaizationIdListSanitized = new List<String>();
      for(string str : accOrgnaizationIdList){
        accOrgnaizationIdListSanitized.add(String.escapeSingleQuotes(str));
      }
      if(acctFieldsToQueryList.size() > 0 && acctFieldsToQueryList.size() > 0){
        if(Account.SObjectType.getDescribe().isAccessible()){
            accountObjList = Database.query('SELECT '+ String.escapeSingleQuotes(String.join(acctFieldsToQueryList, ',')) + ' FROM Account WHERE Id IN :accOrgnaizationIdListSanitized', AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
        }
      }
      return accountObjList;
   }  

   /*
      Modified By : Mayuresh G
      Date : 15th May'18
      Bug : 23520 : Collab-Send Email->Emails status is showing failed at email queues
      Comment : To resolve duplicate filed fetch in SOQL
      */
    // Get User Object Related Fields List
    private static List<User> getUserObjectRelatedFields(List<String> userFieldsToQueryList, List<String> ownerIdList){
        List<User> userObjList = new List<User>();
        Set<String> setUserFieldsToQuery = new Set<String>(userFieldsToQueryList);
        List<String> lstUserFieldsToQuery = new List<String>(setUserFieldsToQuery);
        List<String> ownerIdListSanitized = new  List<String>();
        for(String str : ownerIdList){
            ownerIdListSanitized.add(String.escapeSingleQuotes(str));
        }
        if(userFieldsToQueryList.size() > 0){
            userObjList = Database.query('SELECT '+ String.escapeSingleQuotes(String.join(lstUserFieldsToQuery, ',')) + ' FROM User WHERE Id IN :ownerIdListSanitized', AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
        }
        return userObjList;
    } 

    //replace the email body mergefields with values
    private  static String replaceMergeFields(String body, String contextRecordIds, String targetObjectIds,String recordSnapshot, Map<String,sObject> recordIdWithObject, Map<String,Set<String>> fieldsMap){
        if(contextRecordIds == null && targetObjectIds == null) {
            return body;
        }
        if(body == null){
            return body;
        } 
        List<String> mergeFields = AppUtils.getMergeFields(body);
        Map<String, Set<String>> jsonMap = AppUtils.getJSONMergeFields(body);
        if(mergeFields.size() == 0 && jsonMap.size() == 0){
            return body;
        }   
       
        List<String> recordIds = new List<String>();
         if(String.isNotEmpty(contextRecordIds)){
            if(contextRecordIds.contains(',')){
                recordIds.addAll(contextRecordIds.split(','));
            }else{
                recordIds.add(contextRecordIds);
            }
        }
        if(String.isNotEmpty(targetObjectIds)) {
            if(targetObjectIds.contains(',')){
                recordIds.addAll(targetObjectIds.split(','));
            }else{
                recordIds.add(targetObjectIds);
            }
        }
        
        for(String ids:recordIds){
            //convert 15 digit id to 18 digit
            Id idStr = ids;
            sObject sa = recordIdWithObject.get(idStr);
            if(recordSnapshot != null){
                Map<String,sObject> recordSnapshotMap = (Map<String,sObject>)JSON.deserialize(SFDCEncoder.sanitizeJSON(recordSnapshot), Map<String,sObject>.class);// false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                sa = recordSnapshotMap.get(idStr);
                if(sa == null){
                    sa = recordIdWithObject.get(idStr);
                }
            }
            String sobjectName = findObjectAPIName(idStr);
            Set<String> fields = fieldsMap.get(sobjectName);
            if(fields == null || fields.size() == 0) {
                continue;
            }
            if(sa == null){
              throw new CustomExceptions.InputDataException('Context recordId is incorrect or does not exist : '+idStr) ;
            }
            
           
            List<String> fieldList = new List<String>();
            for (String field : fields) {     
                if (body.contains(sobjectName+'.'+field)){
                    fieldList.add(field);
                    /*if(sa.get(field) != null) {

                        body = body.replace('{!'+sobjectName+'.'+field+'}',String.valueOf(sa.get(field)));              
                    } else {
                        body = body.replace('{!'+sobjectName+'.'+field+'}', '');
                    } */
                }
            }
            body = AppUtils.replaceMergeFieldForTemplate(body, sobjectName, fieldList, sa);
            body = replaceSpecialFields(body, sobjectName, sa);
            body = replaceJSONMergeFields(body, sa, sobjectName);
        }
        return body;
    }
    @TestVisible
    private static String replaceSpecialFields(String body, String sObjectName, sObject sobj) {
        if(String.isEmpty(body)){
            return body;
        }
        if (body.contains(sobjectName+'.Link')){
            body = body.replace('{!' + sobjectName+'.Link}', ' ' + System.URL.getOrgDomainUrl().toExternalForm() + '/' + sobj.get('Id') + ' '); 
        }
        return body;
    }
    
    
    public static String replaceJSONMergeFields(String content, SObject obj, String objectAPIName) {
        content = content.unescapeHtml4();
        Pattern regex = Pattern.compile('\\{"([^}]*)\\"}'); 
        Matcher regexMatcher = regex.matcher(content);        
        
        while (regexMatcher.find()){//SOQL/SOSL Injection False +ve
            String fieldNameStr = regexMatcher.group();
            String fieldName = fieldNameStr.replace('{','').replace('"','').replace('}','');
            List<String> objList = fieldName.split(',');
            String newStr = fieldNameStr.replace('{','').replace('}','');
            for(String objByFld : objList) {
                List<String> data = objByFld.split(':');
                String val ='';
                if(objectAPIName.equalsIgnoreCase( data.get(0).trim())) {
                    try {
                        if(data.get(1).trim() != null){
                            if((data.get(1).trim()).contains('.')){
                                val = String.valueOf(AppUtils.getFieldValue(obj,data.get(1).trim()));
                            }else{
                                val = obj.get(data.get(1).trim()) != null ? String.valueOf(obj.get(data.get(1).trim())) : '';
                            }
                        }                       
                        newStr = newStr.replace('"' + data.get(0) + '":"' + data.get(1) + '"', val);
                    } catch(Exception ex) {
                        newStr = newStr.replace('"' + data.get(0) + '":"' + data.get(1) + '"', '');
                    }
                }else{
                    newStr = newStr.replace('"' + data.get(0) + '":"' + data.get(1) + '"', '');
                }
                
            }
            newStr = newStr.replace(',', '');
            content = content.replace(fieldNameStr, newStr);
        }
        return content;    
    }
    
    private static boolean validate(EmailQueue__c q){ 
       if(q.ToEmails__c == null){
            if(q.TargetObjectId__c != null){
                return true;
            }else{
                q.ErrorMessage__c = 'Both ToEmails and setTargetObjectId can\'t be Empty. Either one should be Provided.';
                q.Status__c = 'Failed';
                q.ProcessedDate__c = System.now();
                //notify admin through email here 
                return false;      
            }
        }
        if(q.TemplateName__c == null){     
            if(q.Subject__c == null){
                q.ErrorMessage__c = 'Subject can\'t be Empty';
                q.Status__c = 'Failed'; 
                q.ProcessedDate__c = System.now(); 
                return false;           
            //notify admin through email here            
            }
            if(q.HtmlBody__c == null && q.PlainTextBody__c == null){
                q.ErrorMessage__c = 'both  HtmlBody and plaintext can\'t be Empty.either one should be provided';
                q.Status__c = 'Failed';
                q.ProcessedDate__c = System.now();
                //notify admin through email here
                return false;
            }
        }     
        return true;
    } 
    
    private static string  findObjectAPIName( String recordId ){  
        String objectType = String.valueOf(((Id)recordId).getSobjectType());
        return objectType;
    }
    
    //Method to get Map of SObject names and related RecordIds Set
    private  static Map<String,Set<String>> getSObjectAndRelatedRecordIds(Set<String> recordIDs){
        Map<String,Set<String>> recordMap = new Map<String,Set<String>>();
        for(String recordId:recordIds){
            String sObjectName = findObjectAPIName(recordID);
            if(recordMap.get(sObjectName) == null){
                recordMap.put(sObjectName,new Set<String>());
            }
            recordMap.get(sObjectName).add(recordId);     
        }   
        return recordMap;
    }
    
     //Based on ToEmails
    //Method to get Map of email and ActiveUser contains that email
    private  static Map<String,User> getUserMap(Set<String> emails){
            Map<String,User> userMap = new Map<String,User>();
            if(User.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.User.fields.Email.isAccessible()
            && Schema.SObjectType.User.fields.IsActive.isAccessible()){
                List<User>  users = [SELECT Id,Email from User where IsActive = true and Email
                                IN :emails WITH USER_MODE];
                for(user u: users){
                    userMap.put(u.email,u);
                }
                return userMap;
            }
            return null;
        }   
    
    //Method to get Map of TemplateName and related EmailTemplate Object
    private static Map<String,EmailTemplate> getTemplateMap(Set<String> templateNames){
        List<EmailTemplate> emailTemplates = [SELECT Subject,Body,HtmlValue,Name,DeveloperName,BrandTemplateId,TemplateType from EmailTemplate where DeveloperName
                                                 IN:templateNames WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Map<String,EmailTemplate> templatesMap= new Map<String,EmailTemplate>();
            for(EmailTemplate em: emailTemplates){
                templatesMap.put(em.DeveloperName,em);
            }
        return templatesMap;
       
    } 
    
    //Method to provide Map of  Sobject Name and related set of fields
    private static String getsObjectAndRelatedFields(List<String> mergeFields,
                          Map<String,Set<String>> fieldsMap, String body){
         for(String s:mergeFields){               
            List<String> s1 = s.split('\\.',2); 
            String fieldAPI = s1.get(1);
            if(SchemaManager.doesObjExist(s1.get(0)) == false){
                throw new CustomExceptions.InputDataException('Object does not exist with API Name : ' + s1.get(0));                          
            }
            if(fieldAPI == 'LINK') {
                fieldAPI = 'Id';
            }else if(fieldAPI == 'OwnerFirstName') {
                fieldAPI = 'Owner.FirstName';
                body = body.replace(s, s1.get(0) + '.Owner.FirstName');
            }else if(fieldAPI == 'OwnerLastName') {
                fieldAPI = 'Owner.LastName';
                body = body.replace(s, s1.get(0) + '.Owner.LastName');
            }else if(fieldAPI == 'OwnerEmail') {
                fieldAPI = 'Owner.Email';
                body = body.replace(s, s1.get(0) + '.Owner.Email');
            }else if(fieldAPI == 'OwnerFullName') {
                fieldAPI = 'Owner.Name';
                body = body.replace(s, s1.get(0) + '.Owner.Name');
            }else if(fieldAPI == 'OwnerTitle') {
                fieldAPI = 'Owner.Title';
                body = body.replace(s, s1.get(0) + '.Owner.Title');
            } else if(fieldAPI == 'CreatedBy') {
                fieldAPI = 'CreatedBy.Name';
                body = body.replace(s, s1.get(0) + '.CreatedBy.Name');
            } else if(fieldAPI == 'LastModifiedBy') {
                fieldAPI = 'LastModifiedBy.Name';
                body = body.replace(s, s1.get(0) + '.LastModifiedBy.Name');
            } else {         
                //validate if field API present
                SchemaManager.getSObjectField(s1.get(0), fieldAPI);
            } 
                
            if(fieldsMap.get(s1.get(0)) == null){
                fieldsMap.put(s1.get(0),new Set<String>());
            }
            
            fieldsMap.get(s1.get(0)).add(fieldAPI);
        }
        return body;
    }
    
    /*This Method for Merge Field Support of User Account Organization
      Parameter : Provided with User,Account,Organization Merge Field List*/
    private static void getUserAccountFieldValue(List<String> userMergeFieldsList, List<String> acctMergeFieldsList, List<String> orgMergeFieldsList, List<User> userList, List<Account> accList, List<Organization> orgList, List<String> ownerIdList, List<String> accOrgnaizationIdList){
        // Query on User Object to Get Field value..
        if(getUserObjectRelatedFields(userMergeFieldsList, ownerIdList) != null){
           userList.addAll(getUserObjectRelatedFields(userMergeFieldsList, ownerIdList));
        }
        
        // Query on Account Object to Get Field value..
        if(getUserAccountObjectRelatedFields(acctMergeFieldsList, accOrgnaizationIdList) !=null){
           accList.addAll(getUserAccountObjectRelatedFields(acctMergeFieldsList, accOrgnaizationIdList));
        }

        // Query on Organization Object to Get Field value..
        if(getUserOrganizationReleatedFields(orgMergeFieldsList) != null){
           orgList.addAll(getUserOrganizationReleatedFields(orgMergeFieldsList));
        }
    }  
    
    //Method to get  Map of RecordId  and related Sobject
    private static void getRecordIdwithrelatedSObject(Map<String, Set<String>> fieldsMap, Map<String,Set<String>> recordMap, Map<String,sObject> recordIdWithObject){
        for( String sObjectName: fieldsMap.keySet()){
            String fields = String.join(new List<String>(fieldsMap.get(sObjectName)),',');
            String records = String.join(new List<String>(recordMap.get(sObjectName)),'\',\'');
            // records = '(\''+string.escapeSingleQuotes(records)+'\')';
            // String  sObjectsQuery = 'SELECT '+fields+' FROM '+string.escapeSingleQuotes(sObjectName)+' where Id IN '+records;
            
            records = '(\''+records+'\')';
            String  sObjectsQuery = 'SELECT '+string.escapeSingleQuotes(fields)+' FROM '+string.escapeSingleQuotes(sObjectName)+' where Id IN '+AppUtils.parseWhereClause(records);
            
            List<sObject> tRecordList = Database.query(sObjectsQuery, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
            recordIdWithObject.putAll(tRecordList);
        }
    }
    
    //Method to get Map of attachment Id and Attachment
    private  static void getAttachmentsMap(Set<String> emailAttachmentsIds,
                                        Map<String,Attachment> attachmentMap,Map<String,ContentVersion> contentMap){
                                        List<Attachment> attachments = [SELECT Id,Name,Body,ContentType FROM  Attachment 
                                            where Id IN:emailAttachmentsIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                                            for(Attachment a:attachments){
                                                attachmentMap.put(a.id,a);  
                                            }
                                        
                                        List<ContentVersion> versionList = [SELECT ContentDocumentId,Id,IsLatest,Title,VersionData FROM ContentVersion 
                                            WHERE Id IN: emailAttachmentsIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users

                                            for(ContentVersion cvL:versionList){
                                                contentMap.put(cvL.Id,cvL);
                                            }
     }
    
    //Method to attach the files to mail
    private static List<Messaging.Emailfileattachment>  getFileAttachments(List<String> emailAttachments,
                              Map<String,Attachment> attachmentMap,Map<String,ContentVersion> contentMap ){
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for(String att:emailAttachments){
            Attachment a = attachmentMap.get(att);
            if(a == null){
                  //throw new CustomExceptions.InputDataException('Attachment Id is incorrect or does not exist : '+ att ) ;
            }
            if(a != null){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);  
            }             
        }

        for(String att:emailAttachments){
            ContentVersion a = contentMap.get(att);
            if(a == null){
                  //throw new CustomExceptions.InputDataException('Attachment Id is incorrect or does not exist : '+ att ) ;
            }
            if(a != null){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Title);
                efa.setBody(a.VersionData);
                fileAttachments.add(efa);
            }               
        }
        return fileAttachments; 
    }
}