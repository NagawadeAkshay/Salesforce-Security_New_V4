global with sharing class EmailFeeder{
    private String fromEmail;
    private String toEmail;
    private String ccEmail;
    private String bccEmail;
    private String subject;
    private String plainText;
    private String htmlBody;
    private String templateName;
    private String recordId;
    private String replyEmail;
    private Id attachmentId;
    private String attachmentIdString;
    private Id targetObjectId;
    
    global EmailFeeder orgWideFromEmail(String fromEmail){
        this.fromEmail = fromEmail;
        return this;
    }
    
    global EmailFeeder toEmail(String toEmail){
        if(String.isNotEmpty(this.toEmail)){
           this.toEmail += ','+toEmail; 
        }else {
            this.toEmail = toEmail;
        }   
        return this;
    }
    
    global EmailFeeder ccEmail(String ccEmail){
        if(String.isNotEmpty(this.ccEmail)){
            this.ccEmail +=','+ccEmail;
            }else{
                this.ccEmail = ccEmail;
            }   
        return this;
    }
    
    global EmailFeeder bccEmail(String bccEmail){
        if(String.isNotEmpty(this.bccEmail)){
            this.bccEmail += ','+bccEmail;
            }else {
                this.bccEmail = bccEmail;
            }   
        return this;
    }
    
    global EmailFeeder subject(String subject){ 
        this.subject = subject;
        return this;
    }
    
    global EmailFeeder plainTextBody(String plaintext){
        this.plainText = plainText;
        return this;
    }
    
    global EmailFeeder htmlBody(String htmlBody){
        this.htmlBody = htmlBody;
        return this;
    }
    
    global EmailFeeder targetObjectId(Id targetObjectId){
        if(this.targetObjectId != null){  
            this.targetObjectId +=',' + targetObjectId;
        }else{
            this.targetObjectId = targetObjectId;
        }
        return this;
    }
    
    global EmailFeeder template(String templateName){
        this.templateName = templateName; 
        return this;
    }
    
    global EmailFeeder contextRecordId(String recordId){
        if(String.isNotEmpty(this.recordId)){  
            this.recordId +=',' + recordId;
        }else{
            this.recordId = recordId;
        }
        
        return this;
    }
    
    global EmailFeeder replyToEmail(String replyEmail){
        this.replyEmail = replyEmail;
        return this;
    }
    
    global EmailFeeder attachment(Id attachmentId){
        if(this.attachmentId != null){
            this.attachmentId += ','+attachmentId;
            }else{
                this.attachmentId = attachmentId;
            }
        
        return this;
    }
    
    global EmailFeeder attachmentIdString(String  attachmentIdStr){
        if(String.isNotEmpty(this.attachmentIdString)){
            this.attachmentIdString += ','+attachmentIdStr;
        }else{
            this.attachmentIdString = attachmentIdStr;
        }
        return this;
    }
    
    global void send(){
        EmailQueue__c email = convertEmailFeederToSobj(this);
        if(Schema.sObjectType.EmailQueue__c.isCreateable()){
            insert as user email;
        }
    }
    
    private static EmailQueue__c convertEmailFeederToSobj(EmailFeeder emailFeeder) {
        EmailQueue__c email = new EmailQueue__c();
        if(Schema.sObjectType.EmailQueue__c.fields.ToEmails__c.isCreateable()){
            email.ToEmails__c = emailFeeder.toEmail;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.CcEmails__c.isCreateable()){
            email.CcEmails__c = emailFeeder.ccEmail;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.BccEmails__c.isCreateable()){
            email.BccEmails__c = emailFeeder.bccEmail;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.Subject__c.isCreateable()){
            email.Subject__c = emailFeeder.subject;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.PlainTextBody__c.isCreateable()){
            email.PlainTextBody__c = emailFeeder.plaintext;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.HtmlBody__c.isCreateable()){
            email.HtmlBody__c = emailFeeder.htmlBody;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.OrgWideFromEmail__c.isCreateable()){
            email.OrgWideFromEmail__c = emailFeeder.fromEmail;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.contextRecordIds__c.isCreateable()){
            email.contextRecordIds__c = emailFeeder.recordId;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.TemplateName__c.isCreateable()){
            email.TemplateName__c = emailFeeder.templateName;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.ReplyEmail__c.isCreateable()){
            email.ReplyEmail__c = emailFeeder.replyEmail;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.AttachmentIds__c.isCreateable()){
            email.AttachmentIds__c = emailFeeder.attachmentId;
            if(!String.isEmpty(emailFeeder.attachmentIdString) && emailFeeder.attachmentIdString!=null){
                String str = emailFeeder.attachmentIdString.removeStart('null,');
                email.AttachmentIds__c = str;
            }
        }
        if(Schema.sObjectType.EmailQueue__c.fields.TargetObjectId__c.isCreateable()){
            email.TargetObjectId__c = emailFeeder.TargetObjectId;
        }
        if(Schema.sObjectType.EmailQueue__c.fields.Status__c.isCreateable()){
           email.Status__c = 'Queued';
        }
       return email;
    }
    
    global static void sendEmails(List<EmailFeeder> emailFeeders) {
        List<EmailQueue__c> emails = new List<EmailQueue__c>();
        for(EmailFeeder emailFeeder : emailFeeders) {
            emails.add( convertEmailFeederToSobj(emailFeeder) );
        }
        if(Schema.sObjectType.EmailQueue__c.isCreateable()){
            insert as user emails;
        }
    }
}