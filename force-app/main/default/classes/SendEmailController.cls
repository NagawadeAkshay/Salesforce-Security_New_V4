/**
    This page is called using one of the following URLs to manage communication between
    two or more users in context of a business record.

    /apex/GNT__SendEmail?parentId={!parentId}&mode=send
    /apex/GNT__SendEmail?taskId={!Task.id}&mode=reply
    /apex/GNT__SendEmail?taskId={!Task.id}&mode=view
*/
global with sharing class SendEmailController {

    public String mode {get; set;}
    public Boolean sendACopyToMe {get;set;}
    public Task emailObj {get; set;}
    public Boolean emailSent {get; set;}

    private String parentId;
    private String taskId;
    private String identifier;
    private String emailFieldName;  //comma separated multiple to email addresses

    //The below constructor is needed to provide backward compatibility in managed package
    global SendEmailController() {}

    global SendEmailController(ApexPages.StandardController controller) {
        this.parentId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('parentId')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding  //needed only when mode=send
        this.taskId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('taskId')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding  //needed only when mode=reply or view
        this.mode = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('mode')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding //needed always
        this.emailFieldName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('emailFieldName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding  //optional - used when mode=send
        if (validatePageLoad()) {
            init();
        }
    }
    
    global PageReference sendEmail() {        
        try {
            if (validateBeforeSend()) {
                if(Schema.sObjectType.Task.fields.EmailSubject__c.isCreateable()){
                    emailObj.EmailSubject__c = emailObj.Subject;
                }
                if(Schema.sObjectType.Task.isCreateable()){
                    insert as user emailObj;
                }
                taskId = emailObj.Id;
                sendEmailToRecipients();

                mode = 'view';
                loadTask();
                emailSent = true;

                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, System.Label.EmailSent);
                ApexPages.addMessage(myMsg);                
            }                
        }
        catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);            
        }
        return null;
    }

    public String getNamespace() {
        return GlobalConfig__c.getInstance().Namespace__c;
    }


    /* PRIVATE METHODS */

    //Returns true if no errors
    private Boolean validatePageLoad() {
        if (String.isEmpty(mode)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Parameter mode is missing in the URL'));
        }
        else if (String.isEmpty(parentId) && mode == 'send') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Parameter parentId is missing in the URL since mode is set as send'));
        }
        else if (String.isEmpty(taskId) && (mode == 'reply' || mode == 'view')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Parameter taskId is missing in the URL since mode is set as either reply or view'));
        }
        else if (String.isNotEmpty(emailFieldName) && String.isEmpty(parentId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Parameter parentId is missing in the URL since emailFieldName is specified'));
        }

        return ApexPages.getMessages().size() == 0;
    }

    private void init() {
        sendACopyToMe = false;
        emailSent = false;

        if (mode == 'send') {
            if(Schema.sObjectType.Task.fields.Type.isCreateable() && Schema.sObjectType.Task.fields.IsRead__c.isCreateable() 
            && Schema.sObjectType.Task.fields.FromAddress__c.isCreateable() && Schema.sObjectType.Task.fields.EmailType__c.isCreateable() 
            && Schema.sObjectType.Task.fields.IsVisibleInSelfService.isCreateable()){
                emailObj = new Task(Type='Email', IsRead__c=true, FromAddress__c=UserInfo.getUserEmail(),
                                EmailType__c='Outbound', Status='Completed', IsVisibleInSelfService=true);
            }
			Schema.SObjectType token = ((Id)parentId).getSObjectType();
			if(String.valueOf(token).equalsIgnoreCase('Contact')) {
                if(Schema.sObjectType.Task.fields.WhoId.isCreateable()){
                    emailObj.WhoId = parentId;
                }
			} else {
                if(Schema.sObjectType.Task.fields.WhatId.isCreateable()){
                    emailObj.WhatId = parentId;
                }
			}
            if (String.isNotEmpty(emailFieldName)) {
                Id recordId = (Id) parentId;
                Schema.DescribeSObjectResult dr = recordId.getSObjectType().getDescribe();
                String soql = 'Select ' +String.escapeSingleQuotes(emailFieldName) + ' from ' + string.escapeSingleQuotes(dr.getName()) + ' where Id=: recordId';
	                SObject record = Database.query(String.escapeSingleQuotes(soql), AccessLevel.USER_MODE);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
	                if (record != null && Schema.sObjectType.Task.fields.ToAddress__c.isCreateable()) {
	                    emailObj.ToAddress__c = getFieldValue(record);
	                }
            }
        }
        else if (mode == 'reply') {
            loadTask();
            emailObj.Id = null;
            emailObj.Description = prepareReplyBodyHeader() + emailObj.Description;
            if (emailObj.Subject.startsWith('Re:') == false && emailObj.Subject.startsWith('RE:') == false && Schema.sObjectType.Task.fields.Subject.isCreateable()) {
                emailObj.Subject = 'Re: ' + emailObj.Subject;
            }

            if (emailObj.EmailType__c == 'Inbound') {
                if(Schema.sObjectType.Task.fields.ToAddress__c.isCreateable()){
                    emailObj.ToAddress__c = emailObj.FromAddress__c;
                }
                if(Schema.sObjectType.Task.fields.FromAddress__c.isCreateable()){
                    emailObj.FromAddress__c = UserInfo.getUserEmail();
                }
            }
        }
        else {  //mode = 'view'
            loadTask();
        }
    }

    private void loadTask() {
	        emailObj = [Select ToAddress__c, CCAddress__c, Subject, Description, WhatId, WhoId, Type, IsRead__c , 
	                                FromAddress__c, OwnerId, EmailType__c, CreatedDate, Status,
	                                IsVisibleInSelfService from Task where Id=:taskId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
    }

    //Returns true if no errors
    private Boolean validateBeforeSend() {
    if (String.isEmpty(emailObj.ToAddress__c) || emailObj.ToAddress__c == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Enter To email address'));
        }
        if(emailObj.ToAddress__c != null){
            if(!AppUtils.checkEmailAddress(emailObj.ToAddress__c)){  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Invalid Email Address'));
            }
        }
        if(emailObj.CCAddress__c != null){
            if(!AppUtils.checkEmailAddress(emailObj.CCAddress__c)){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                'Invalid Email Address'));
            }
        }
        if (String.isEmpty(emailObj.Subject)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Enter subject'));
        }
        if (String.isEmpty(emailObj.Description)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Enter body content'));
        }
        return ApexPages.getMessages().size() == 0;
    }

    private String getFieldValue(SObject record) {
        String[] fields = emailFieldName.split('\\.');

        for (Integer i=0; i<fields.size()-1; i++) {
            record = record.getSObject(fields[i]);
        }
        return (String) record.get(fields.get(fields.size()-1));
    }

    public static Map<String, String> getSendEmailIcon(){
        map<string,string> SendEmailIconMap = new map<string,string>();
        SendEmailIconMap.put('fa fa-pencil','utility:edit');
        SendEmailIconMap.put('fa fa-arrow','utility:right');
        SendEmailIconMap.put('fa fa-ban','utility:close');
        SendEmailIconMap.put('fa fa-bolt','utility:thunder');
        SendEmailIconMap.put('fa fa-check','utility:success'); 
        SendEmailIconMap.put('fa fa-clone','utility:clone');
        SendEmailIconMap.put('fa fa-close','utility:close');
        SendEmailIconMap.put('fa fa-cloud-download','utility:download');
        SendEmailIconMap.put('fa fa-cloud-upload','utility:upload');
        SendEmailIconMap.put('fa fa-comments','utility:chat');
        SendEmailIconMap.put('fa fa-exchange','utility:exchange');
        SendEmailIconMap.put('fa fa-external-link','utility:open');
        SendEmailIconMap.put('fa fa-eye','utility:preview');
        SendEmailIconMap.put('fa fa-file','utility:page');
        SendEmailIconMap.put('fa fa-file-pdf','utility:file_pdf');
        SendEmailIconMap.put('fa fa-file-text','utility:file');
        SendEmailIconMap.put('fa fa-gavel','utility:thunder');
        SendEmailIconMap.put('fa fa-level-up','utility:up');
        SendEmailIconMap.put('fa fa-money','utility:currency');
        SendEmailIconMap.put('fa fa-play','utility:play');
        SendEmailIconMap.put('fa fa-plus-circle','utility:add');
        SendEmailIconMap.put('fa fa-reply','utility:back');
        SendEmailIconMap.put('fa fa-share','utility:share');
        SendEmailIconMap.put('fa fa-share-square-o','utility:share_post');
        SendEmailIconMap.put('fa fa-sign-in','utility:login');
        SendEmailIconMap.put('fa fa-sign-out','utility:logout');
        SendEmailIconMap.put('fa fa-sitemap','utility:hierarchy');
        SendEmailIconMap.put('fa fa-sticky-note','utility:note');
        SendEmailIconMap.put('fa fa-stop','utility:stop');
        SendEmailIconMap.put('fa fa-tags','utility:tags');
        SendEmailIconMap.put('fa fa-times','utility:close');
        SendEmailIconMap.put('fa fa-trash','utility:delete');
        SendEmailIconMap.put('fa fa-trophy','custom:custom48');
        SendEmailIconMap.put('fa fa-undo','utility:undo');
        SendEmailIconMap.put('fa fa-unlock','utility:unlock');
        SendEmailIconMap.put('fa fa-paper-plane-o','utility:send');
        SendEmailIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        SendEmailIconMap.put('glyphicon glyphicon-remove','utility:close');
        SendEmailIconMap.put('glyphicon glyphicon-send','utility:send');
        SendEmailIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        SendEmailIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        SendEmailIconMap.put('glyphicon glyphicon-trash','utility:delete');
        SendEmailIconMap.put('fa fa-history','utility:skip_back');
        SendEmailIconMap.put('fa fa-table','utility:table');
        SendEmailIconMap.put('fa fa-coffee','utility:coffee');
        SendEmailIconMap.put('fa fa-cubes','utility:cubes');
        SendEmailIconMap.put('fa fa-star','utility:favorite');
        SendEmailIconMap.put('fa fa-exclamation-triangle','utility:warning');
        SendEmailIconMap.put('fa fa-line-SendEmail','utility:lineSendEmail');
        SendEmailIconMap.put('fa fa-comment','utility:comments');
        SendEmailIconMap.put('fa fa-caret-square-o-down','utility:down');
        SendEmailIconMap.put('fa fa-wrench','utility:settings');
        SendEmailIconMap.put('fa fa-share-square-o','utility:share');
        SendEmailIconMap.put('fa fa-bolt','utility:lightning');
        SendEmailIconMap.put('fa fa-trash-o','utility:delete');
        SendEmailIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        SendEmailIconMap.put('fa fa-file-text-o','utility:contract_doc');
        SendEmailIconMap.put('fa fa-wechat','utility:chat');
        SendEmailIconMap.put('fa fa-paperclip','utility:attach');
        SendEmailIconMap.put('fa fa-usd','utility:moneybag');
        SendEmailIconMap.put('glyphicon glyphicon-tasks','utility:task');
        SendEmailIconMap.put('fa fa-folder','utility:open_folder');
        SendEmailIconMap.put('fa fa-paper-plane-o','utility:send');
        SendEmailIconMap.put('fa fa-play','utility:play');
    
        return SendEmailIconMap;
    }
    
    public static Map<String, String> getSendEmailIconLwc(){
    
        map<string,string> SendEmailIconMaplwc = new map<string,string>();
        SendEmailIconMaplwc.put('fa fa-pencil','utility:edit');
        SendEmailIconMaplwc.put('fa fa-arrow','utility:right');
        SendEmailIconMaplwc.put('fa fa-ban','utility:error');
        SendEmailIconMaplwc.put('fa fa-bolt','utility:thunder');
        SendEmailIconMaplwc.put('fa fa-check','utility:success'); 
        SendEmailIconMaplwc.put('fa fa-clone','utility:clone');
        SendEmailIconMaplwc.put('fa fa-close','utility:close');
        SendEmailIconMaplwc.put('fa fa-cloud-download','utility:download');
        SendEmailIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        SendEmailIconMaplwc.put('fa fa-comments','utility:chat');
        SendEmailIconMaplwc.put('fa fa-exchange','utility:exchange');
        SendEmailIconMaplwc.put('fa fa-external-link','utility:open');
        SendEmailIconMaplwc.put('fa fa-eye','utility:preview');
        SendEmailIconMaplwc.put('fa fa-file','utility:page');
        SendEmailIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        SendEmailIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        SendEmailIconMaplwc.put('fa fa-file-text','utility:file');
        SendEmailIconMaplwc.put('fa fa-gavel','utility:thunder');
        SendEmailIconMaplwc.put('fa fa-level-up','utility:up');
        SendEmailIconMaplwc.put('fa fa-money','utility:currency');
        SendEmailIconMaplwc.put('fa fa-play','utility:play');
        SendEmailIconMaplwc.put('fa fa-plus-circle','utility:add');
        SendEmailIconMaplwc.put('fa fa-reply','utility:back');
        SendEmailIconMaplwc.put('fa fa-share','utility:share');
        SendEmailIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        SendEmailIconMaplwc.put('fa fa-sign-in','utility:login');
        SendEmailIconMaplwc.put('fa fa-sign-out','utility:logout');
        SendEmailIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        SendEmailIconMaplwc.put('fa fa-sticky-note','utility:note');
        SendEmailIconMaplwc.put('fa fa-stop','utility:stop');
        SendEmailIconMaplwc.put('fa fa-tags','utility:tags');
        SendEmailIconMaplwc.put('fa fa-times','utility:close');
        SendEmailIconMaplwc.put('fa fa-trash','utility:delete');
        SendEmailIconMaplwc.put('fa fa-trophy','custom:custom48');
        SendEmailIconMaplwc.put('fa fa-undo','utility:undo');
        SendEmailIconMaplwc.put('fa fa-unlock','utility:unlock');
        SendEmailIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        SendEmailIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        SendEmailIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        SendEmailIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        SendEmailIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        SendEmailIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        SendEmailIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        SendEmailIconMaplwc.put('fa fa-history','utility:skip_back');
        SendEmailIconMaplwc.put('fa fa-table','utility:table');
        SendEmailIconMaplwc.put('fa fa-coffee','utility:coffee');
        SendEmailIconMaplwc.put('fa fa-cubes','utility:cubes');
        SendEmailIconMaplwc.put('fa fa-star','utility:favorite');
        SendEmailIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        SendEmailIconMaplwc.put('fa fa-line-SendEmail','utility:graph');
        SendEmailIconMaplwc.put('fa fa-comment','utility:comments');
        SendEmailIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        SendEmailIconMaplwc.put('fa fa-wrench','utility:settings');
        SendEmailIconMaplwc.put('fa fa-share-square-o','utility:share');
        SendEmailIconMaplwc.put('fa fa-bolt','utility:lightning');
        SendEmailIconMaplwc.put('fa fa-trash-o','utility:delete');
        SendEmailIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        SendEmailIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        SendEmailIconMaplwc.put('fa fa-wechat','utility:chat');
        SendEmailIconMaplwc.put('fa fa-paperclip','utility:attach');
        SendEmailIconMaplwc.put('fa fa-usd','utility:moneybag');
        SendEmailIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        //SendEmailIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
        SendEmailIconMaplwc.put('fa fa-folder','utility:open_folder');
        SendEmailIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        SendEmailIconMaplwc.put('fa fa-play','utility:play');
        SendEmailIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        SendEmailIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        SendEmailIconMaplwc.put('fa fa-male','utility:user');
    
        return SendEmailIconMaplwc;
    }

    private void sendEmailToRecipients() {
        String[] toAddresses = split(emailObj.ToAddress__c);                        
        String[] ccAddresses = split(emailObj.CCAddress__c);
        
        String identifier = '\n\n[ref:' + parentId + ':ref]'; 
        String plainTextBody = emailObj.Description + identifier;                        
        String replyToEmail = KeyValueStoreHelper.getTextValue('CommunicationReplyEmailService', true);                
        AppUtils.sendEmail(toAddresses, ccAddresses, replyToEmail, 
                sendACopyToMe, emailObj.Subject, plainTextBody, null);
    }

    private String[] split(String data) {
        List<String> dataArray = new List<String>();
        if(String.isNotEmpty(data)){
            data = data.replace(',', ';');
            data = data.replace(' ', ';');
            String[] dataArrayUntrimmed = data.split(';');
            for (String email : dataArrayUntrimmed) { 
                email = email.trim();
                if (String.isNotEmpty(email)) {
                    dataArray.add(email);
                }
            }
        }

        return dataArray;
    }

    private String prepareReplyBodyHeader() {
        return '\n\n\n-----Original Message-----' +
                    '\nFrom: ' + emailObj.FromAddress__c + 
                    '\nSent: ' + emailObj.CreatedDate.format('EEEE, MMMM d, y h:mm a') +
                    '\nTo: '+ emailObj.ToAddress__c +
                    '\nSubject: '+ emailObj.Subject + '\n\n';
    }
}