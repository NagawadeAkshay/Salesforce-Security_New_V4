global with sharing class EmailConversationHandler implements Messaging.InboundEmailHandler {
    public static boolean isTest = false;
    private Task mostRecentOutboundTask;
    
    boolean EnableReplyEmailsFromCollab = KeyValueHolderHelper.getBooleanValue('EnableReplyEmailsFromCollab') == null ? false : KeyValueHolderHelper.getBooleanValue('EnableReplyEmailsFromCollab');
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        result.success = true;

        String parentId = findParentId(email.plainTextBody);
        
        String AttentionTo = findAttentionTo(email.plaintextBody);
        if (parentId == null || (EnableReplyEmailsFromCollab && AttentionTo==null) ) {
            String plainTextBody = 'When responding to the ' +userinfo.getorganizationname()+ ' email, one or more Reference IDs was removed. Please make sure that you respond to the original email without removing the Reference IDs. Removing the Reference IDs does not guarantee the successful delivery of the email. Please reply to the ' +userinfo.getorganizationname()+ ' email again and add text without removing Reference IDs.' +
                '\n\n *** Note: Please DO NOT reply to this email ***';                                      
            sendErrorEmailToSender(email, plainTextBody);
            if(!EnableReplyEmailsFromCollab) {
                result.success = false;
                return result;
            } 
        }
        if(AttentionTo==null && parentId != null){
            mostRecentOutboundTask = findMostRecentOutboundEmail(parentId);
        }else{
            mostRecentOutboundTask = findOriginalOutboundEmail(AttentionTo);
        }
        Task taskForReceiver = new Task();
        if(parentId != null){
            taskForReceiver.WhatId = parentId; //CRUD/FLS False +ve
        }
        if(Schema.sObjectType.Task.fields.Type.isCreateable() || Schema.sObjectType.Task.fields.Type.isUpdateable()){
        	taskForReceiver.Type = 'Email';
        }
        if(Schema.sObjectType.Task.fields.IsRead__c.isCreateable() || Schema.sObjectType.Task.fields.IsRead__c.isUpdateable()){
        	taskForReceiver.IsRead__c = true;
        }
        if(Schema.sObjectType.Task.fields.FromAddress__c.isCreateable() || Schema.sObjectType.Task.fields.FromAddress__c.isUpdateable()){
        	taskForReceiver.FromAddress__c = envelope.fromAddress;
        }
        taskForReceiver.OwnerId = mostRecentOutboundTask != null ? mostRecentOutboundTask.OwnerId : null; //CRUD/FLS False +ve Id field
        if(Schema.sObjectType.Task.fields.EmailType__c.isCreateable() || Schema.sObjectType.Task.fields.EmailType__c.isUpdateable()){
        	taskForReceiver.EmailType__c = 'Inbound';
        }
        if(Schema.sObjectType.Task.fields.EmailSubject__c.isCreateable() || Schema.sObjectType.Task.fields.EmailSubject__c.isUpdateable()){
        	taskForReceiver.EmailSubject__c = email.subject;
        }
        if(Schema.sObjectType.Task.fields.Subject.isCreateable() || Schema.sObjectType.Task.fields.Subject.isUpdateable()){
        	taskForReceiver.Subject = email.subject;
        }
        if(Schema.sObjectType.Task.fields.IsVisibleInSelfService.isCreateable() || Schema.sObjectType.Task.fields.IsVisibleInSelfService.isUpdateable()){
        	taskForReceiver.IsVisibleInSelfService = true;
        }
        //taskForReceiver.Description = email.htmlBody;        
        if(Schema.sObjectType.Task.fields.Description.isCreateable() || Schema.sObjectType.Task.fields.Description.isUpdateable()){
            taskForReceiver.Description = EncodeText(email.htmlBody);//changes for User Story 156343 Send Email: When I reply back to collab email, on the collab preview column it is displaying like 'v\:* {behavior:url(#default#'             
        }
        if(Schema.sObjectType.Task.fields.Status.isCreateable() || Schema.sObjectType.Task.fields.Status.isUpdateable()){
        	taskForReceiver.Status = 'Completed';
        }
        if(Schema.sObjectType.Task.fields.ToAddress__c.isCreateable() || Schema.sObjectType.Task.fields.ToAddress__c.isUpdateable()){
        	taskForReceiver.ToAddress__c = convertRecipientArrayToString(email.toAddresses, true);
        }
        if(Schema.sObjectType.Task.fields.CCAddress__c.isCreateable() || Schema.sObjectType.Task.fields.CCAddress__c.isUpdateable()){
        	taskForReceiver.CCAddress__c = convertRecipientArrayToString(email.ccAddresses, true);
        }
        if(Schema.sObjectType.Task.fields.Action__c.isCreateable() || Schema.sObjectType.Task.fields.Action__c.isUpdateable()){
	        if(AttentionTo != null){
	              taskForReceiver.Action__c = 'Inbound Email Attention To Sender';
	        }
        }
        
        try {   
            //Changes added for User Story 161410: NFWF - File not links to task
            boolean EnableSalesforceContent = KeyValueHolderHelper.getBooleanValue('SendEmailFilesLinkConfigHolder') == null ? false : KeyValueHolderHelper.getBooleanValue('SendEmailFilesLinkConfigHolder');
            boolean EnableAttachments = KeyValueHolderHelper.getBooleanValue('EnableEmailAttachment') == null ? false : KeyValueHolderHelper.getBooleanValue('EnableEmailAttachment');
            List<ContentVersion> contentList = new List<ContentVersion>();
            Set<Id> documentIds = new Set<Id>();
            List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
            if(Schema.sObjectType.Task.isCreateable()){
            insert as user taskForReceiver;
            if(EnableSalesforceContent){
                //List<ContentVersion> contentList = createContentListForTask(email, taskForReceiver);
                contentList = createContentListForTask(email, taskForReceiver);
                if(contentList.size() > 0){
                    if(Schema.sObjectType.ContentVersion.isCreateable()){
                    	insert as user contentList;
                    }
                    List<ContentDocument> contLinkDocList = [SELECT ID, LatestPublishedVersionId FROM ContentDocument 
                                                            WHERE LatestPublishedVersionId IN:contentList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    
                    for(ContentDocument cdlist:contLinkDocList){
                        documentIds.add(cdlist.Id);
                    }

                    if(documentIds.size()>0){
                        List<ContentWorkspaceDoc> workDocList = createContentWorkspaceDocument(documentIds);          
                         if(workDocList!=null && workDocList.size()>0){
                             if(Schema.sObjectType.ContentWorkspaceDoc.isCreateable()){
                            	insert as user workDocList;
                         	}
                         }
                         contentDocumentLinks = createContentContentDocumentLinks(documentIds,taskForReceiver);
                         if(contentDocumentLinks!=null && contentDocumentLinks.size()>0){
                                if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                             		insert as user contentDocumentLinks;
                         		}
                     		}                     
                        }                     
                    Set<Id> tempIds = new Set<Id>();
                    for(ContentDocumentLink cdl:contentDocumentLinks){
                        tempIds.add(cdl.ContentDocumentId);
                    }
                    List<ContentDocument> contLinkDocListNew = [SELECT ID, LatestPublishedVersionId FROM ContentDocument 
                                                                WHERE Id IN:tempIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    
                    Set<Id> temp2Ids = new Set<Id>();
                    for(ContentDocument cdcc:contLinkDocListNew){
                        temp2Ids.add(String.escapeSingleQuotes(cdcc.latestPublishedVersionId));
                    }
                    String StrMeta = KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') != null ? KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder'):'';
                    String queryFieldName =  StrMeta.split('&')[1].split('=').size() > 1 ? StrMeta.split('&')[1].split('=')[1] : '';
                    //String queryFieldName = KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') != null ? KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder'):'';
                    String contentVersionQuery = 'SELECT Id, Title, Description, ContentUrl';
                    if(queryFieldName != null && queryFieldName !=''){
                        contentVersionQuery = contentVersionQuery + ', '+String.escapeSingleQuotes(queryFieldName);
                    }
                    contentVersionQuery = contentVersionQuery+ ' FROM ContentVersion WHERE Id IN :temp2Ids and IsLatest = true';
                    String linkBody = '<br><b> Links to Additional Attachments </b> (Please find below links to additional attachments other than those attached to this email. Click the filename to view the attachment.):';
                    for(ContentVersion cv: Database.query(contentVersionQuery, AccessLevel.USER_MODE)){ //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
                        if(queryFieldName != null && queryFieldName !=''){
                            //linkBody = linkBody + '<br><a href=' + cv.get(queryFieldName) + ' target="_blank" >' + cv.Title + '</a>';
                        }else if(cv.contentUrl!=null){
                            //linkBody = linkBody + '<br><a href=' + cv.contentUrl + ' target="_blank" >' + cv.Title + '</a>';
                        }else{
                            linkBody = linkBody + '<br><a href=/' + cv.Id + ' target="_blank" >' + cv.Title + '</a>';
                        }
                    }
                    linkBody = linkBody + '<br><br>';
                    if(Schema.sObjectType.Task.fields.Description.isUpdateable()){
                    	taskForReceiver.Description = linkBody + taskForReceiver.Description;
                    }
                        if(Schema.sObjectType.Task.isUpdateable()){
                    		update as user taskForReceiver;
                		}
                       
                    }
                //Changes end for User Story 161410: NFWF - File not links to task
            }
            }
            
            if(EnableAttachments){
                List<Attachment> attList = createAttachmentListForTask(email, taskForReceiver);
                if(attList.size() > 0){
                    if(Schema.sObjectType.Attachment.isCreateable()){
                    	insert as user attList;
                    }
                    if(Schema.sObjectType.Task.fields.Attachment__c.isUpdateable()){
                    	taskForReceiver.Attachment__c = true;
                    }
                    if(Schema.sObjectType.Task.isUpdateable()){
                    	update as user taskForReceiver;
                    }
                }
            }
        }
        catch (Exception e) {
            sendErrorEmailToSender(email, AppUtils.handleSystemExceptionMsg(e));
            result.success = false;
        }
        
        return result;
    }
    //changes start for User Story 156343 Send Email: When I reply back to collab email, on the collab preview column it is displaying like 'v\:* {behavior:url(#default#'
    public static String EncodeText(String input){
        if(input.containsIgnoreCase('v\\:* {behavior:url(#default#VML);}')){
            input = input.replace('v\\:* {behavior:url(#default#VML);}', '');
        }
        if(input.containsIgnoreCase('o\\:* {behavior:url(#default#VML);}')){
            input = input.replace('o\\:* {behavior:url(#default#VML);}', '');
        }
        if(input.containsIgnoreCase('w\\:* {behavior:url(#default#VML);}')){
            input = input.replace('w\\:* {behavior:url(#default#VML);}', '');
        }
        if(input.containsIgnoreCase('.shape {behavior:url(#default#VML);}')){
            input = input.replace('.shape {behavior:url(#default#VML);}', '');
        }
        if(input.containsIgnoreCase('P {margin-top:0;margin-bottom:0;}')){
            input = input.replace('P {margin-top:0;margin-bottom:0;}', '');
        }
        return input;
    }//changes end for User Story 156343 Send Email: When I reply back to collab email, on the collab preview column it is displaying like 'v\:* {behavior:url(#default#'
    private String convertRecipientArrayToString(String[] emailAddresses, Boolean isTo) {
        Set<String> resultEmails = new Set<String>(); 

        if (emailAddresses != null && emailAddresses.size() > 0) {
            for (String email : emailAddresses) {
                if (email.startsWith('communication@') == false) {
                    resultEmails.add(email);
                }
            }
        }
        /*
        if (isTo && mostRecentOutboundTask != null && mostRecentOutboundTask.FromAddress__c != null) {
            resultEmails.add(mostRecentOutboundTask.FromAddress__c);
        }*/
        return AppUtils.concatenate(resultEmails, '; ');
    }

    private String findParentId(String body) {
        Pattern regexForExtractingId = Pattern.compile('ref:[A-Za-z0-9]{15,18}:ref'); 
        Matcher regexMatcherForExtractingId = regexForExtractingId.matcher(body);        
        String parentId = null;

        if(regexMatcherForExtractingId.find()) {//SOQL/SOSL Injection False +ve
            parentId = regexMatcherForExtractingId.group();            
            parentId = parentId.substringBetween('ref:',':ref');           
        }

        return parentId;        
    }

    private Task findMostRecentOutboundEmail(String parentId) {
        List<Task> taskList = [Select OwnerId, FromAddress__c FROM Task where  WhatId = :parentId AND Type ='Email' AND  
                            EmailType__c = 'Outbound' WITH USER_MODE Order by CreatedDate DESC Limit 1];    //CRUD/FLS False +ve As per business scenario we can't check for portal/external users     
        if (taskList.size() == 1) {
            return taskList.get(0);
        }   
        return null;
    }
    
    private void sendErrorEmailToSender(Messaging.InboundEmail email, String plainTextBody) {
        String[] tos = null;
        if (email != null && email.fromAddress != null) {
            String[] splitAddresses=email.fromAddress.split(';');
            tos = splitAddresses;
        }
        String subject = 'Error processing email ('+email.subject+')';             
        AppUtils.sendEmail(tos, subject, plainTextBody, null);
    }

    private String findAttentionTo(String body) {
        String TaskIdRegex = 'AttentionTo:[A-Za-z0-9]{15,18}:AttentionTo'; 
        Pattern regexForExtractingEmail = Pattern.compile(TaskIdRegex);
        Matcher regexMatcherForExtractingEmail = regexForExtractingEmail.matcher(body);       
        String AttentionTo = null;

        if(regexMatcherForExtractingEmail.find()) {//SOQL/SOSL Injection False +ve
            AttentionTo = regexMatcherForExtractingEmail.group();
           AttentionTo = AttentionTo.substringBetween('AttentionTo:',':AttentionTo');           
        }
        return AttentionTo;        
    }

    private Task findOriginalOutboundEmail(String AttentionTo) {
        List<Task> taskList = [Select OwnerId, FromAddress__c FROM Task where  Id = :AttentionTo AND Type ='Email' 
                            WITH USER_MODE Order by CreatedDate DESC Limit 1]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users        
        if (taskList.size() == 1) {
            return taskList.get(0);
        }   
        return null;
    }


    private List<ContentWorkspaceDoc> createContentWorkspaceDocument(Set<Id> Ids){
        List<ContentWorkspaceDoc> docList = new List<ContentWorkspaceDoc>();
		Id cwId = getUserWorkspaceInfo(UserInfo.getUserId());
		If(cwId!=null){
            for(Id i:Ids){
                ContentWorkspaceDoc objContentWorkspaceDoc = new ContentWorkspaceDoc();
                objContentWorkspaceDoc.ContentDocumentId = i; //CRUD/FLS False +ve id field
                objContentWorkspaceDoc.ContentWorkspaceId = cwId; //CRUD/FLS False +ve id field
    
                docList.add(objContentWorkspaceDoc);
            }
            return docList;
        }else{
            return null;
        }
        
    }
    private List<ContentDocumentLink> createContentContentDocumentLinks(Set<Id> Ids, Task taskObj){
		Id cwId = getUserWorkspaceInfo(UserInfo.getUserId());
		If(cwId!= null){
            List<ContentDocumentLink> dlinks = new List<ContentDocumentLink>();
            for(Id i:Ids){
                ContentDocumentLink cdlink = new ContentDocumentLink();
                cdlink.LinkedEntityId = taskObj.Id;
                cdlink.ContentDocumentId = i;
                cdlink.shareType = 'v';
    
                dlinks.add(cdlink);
            }
            return dlinks;
        }else{
            return null;
        }
        
    }

    public static Id getUserWorkspaceInfo(Id userId){
        try{
            User objLoggedInUser = [SELECT Id, OrganizationId__c FROM User WHERE Id =: userId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(objLoggedInUser.OrganizationId__c != null && Schema.SObjectType.Account.fields.WorkspaceId__c.isAccessible() ){
                Account userOrganization = [SELECT Id, WorkspaceId__c FROM Account WHERE Id =: objLoggedInUser.OrganizationId__c WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(userOrganization != null && String.isNotBlank(userOrganization.WorkspaceId__c)){
                    ContentWorkspace objContentWorkspace = [SELECT Id FROM ContentWorkspace WHERE Id =: userOrganization.WorkspaceId__c WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if(objContentWorkspace != null){
                        return objContentWorkspace.Id;
                    }else{
                        return null;
                    } 
            } else {
                return null;
            } 
        } else{
            return null;
        }          
        } catch(Exception objException){
            return null;
        }        
    }


    private List<ContentVersion> createContentListForTask(Messaging.InboundEmail email, Task taskObj){
        List<ContentVersion> attList = new List<ContentVersion>();
        if(email.textAttachments != null && taskObj != null && email.textAttachments.size() > 0){
            for (Messaging.Inboundemail.TextAttachment singleAttach : email.textAttachments) { 
                if(!singleAttach.fileName.startsWith('~WRD')){ //Comdition added to avoid the extra outlook files in content version                     
                	ContentVersion singleContentVersion = new ContentVersion();
                	if (Schema.sObjectType.ContentVersion.fields.title.isCreateable()) {   
                		singleContentVersion.title = singleAttach.fileName;
                	}
                	if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {    
		                if(singleAttach.fileName!=null && singleAttach.fileName!=''){
		                    singleContentVersion.PathOnClient = singleAttach.fileName+'.txt';
		                }else{
		                    singleContentVersion.PathOnClient = 'TextFile.txt';
		                }
                }
                if (Schema.sObjectType.ContentVersion.fields.versionData.isCreateable()) {
                	singleContentVersion.versionData = Blob.valueOf(singleAttach.body);
                }
                attList.add(singleContentVersion);
            }
            }
        }
        if(email.binaryAttachments != null && taskObj != null && email.binaryAttachments.size() > 0){
            for (Messaging.Inboundemail.BinaryAttachment singleAttach : email.binaryAttachments) {
                if(!singleAttach.fileName.startsWith('~WRD')){ //Comdition added to avoid the extra outlook files in content version          
                	ContentVersion singleContentVersion = new ContentVersion();
                if (Schema.sObjectType.ContentVersion.fields.title.isCreateable()) {   
                	singleContentVersion.title = singleAttach.fileName;
                }
                if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) { 
	                if(singleAttach.fileName!=null && singleAttach.fileName!=''){
	                    singleContentVersion.PathOnClient = singleAttach.fileName+'.txt';
	                }else{
	                    singleContentVersion.PathOnClient = 'BinaryFile.txt';
	                }
                }
                if (Schema.sObjectType.ContentVersion.fields.versionData.isCreateable()) {
                	singleContentVersion.versionData = singleAttach.body;
                }
                attList.add(singleContentVersion);
            }
            }
        }
        return attList;
    }
    private List<Attachment> createAttachmentListForTask(Messaging.InboundEmail email, Task taskObj){
        List<Attachment> attList = new List<Attachment>();
        if(email.textAttachments != null && taskObj != null && email.textAttachments.size() > 0){
            for (Messaging.Inboundemail.TextAttachment singleAttach : email.textAttachments) {			  
                Attachment singleAttachment = new Attachment();
                if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) {
                	singleAttachment.Name = singleAttach.fileName;
                }
                if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) {
                	singleAttachment.Body = Blob.valueOf(singleAttach.body);
                }
                singleAttachment.ParentId = taskObj.Id; //CRUD/FLS False +ve Id field 
                singleAttachment.OwnerId = taskObj.OwnerId; //CRUD/FLS False +ve Id field 
                attList.add(singleAttachment);
            }
        }
        if(email.binaryAttachments != null && taskObj != null && email.binaryAttachments.size() > 0){
            for (Messaging.Inboundemail.BinaryAttachment singleAttach : email.binaryAttachments) {			  
                Attachment singleAttachment = new Attachment();
                if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) {
                	singleAttachment.Name = singleAttach.fileName;
                }
                if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) {
                	singleAttachment.Body = singleAttach.body;
                }
                singleAttachment.ParentId = taskObj.Id; //CRUD/FLS False +ve Id field 
                singleAttachment.OwnerId = taskObj.OwnerId;//CRUD/FLS False +ve Id field 
                attList.add(singleAttachment);
            }
        }
        return attList;
    }
}