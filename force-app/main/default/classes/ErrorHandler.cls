/**
    Accumulates error messages and finally persists them into ErrorLog__c custom object
    for a given business record.

   
*/
public with sharing class ErrorHandler {

    @TestVisible private List<ErrorLog__c> errors = new List<ErrorLog__c>();
    @TestVisible private Id jobConfigId;
    //private String jobConfigId;

    public ErrorHandler(){}

    public ErrorHandler(Id jobConfigId){
        this.jobConfigId = jobConfigId;
    }

    public ErrorHandler add(Exception e, Id parentId) {
        ErrorLog__c log; 
        if(Schema.sObjectType.ErrorLog__c.fields.ParentId__c.isCreateable() 
        && Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()){
            log = new ErrorLog__c(ParentId__c = parentId, ErrorMessage__c = getException(e));
        }
        this.errors.add(log);
        return this;
    }

    public ErrorHandler add(Exception e, Set<String> parentIds) {
        for (String parentId : parentIds) {
            add(e, parentId);
        }
        return this;
    }

    public ErrorHandler add(String errorMessage, Id parentId) {
        if (Schema.sObjectType.ErrorLog__c.fields.ParentId__c.isCreateable() &&
        Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()) {
            ErrorLog__c log = new ErrorLog__c(ParentId__c = parentId, ErrorMessage__c = errorMessage);
            this.errors.add(log);
        } 
        return this;
    }

    public ErrorHandler add(String errorMessage, Set<Id> parentIds) {
        for (Id parentId : parentIds) {
            add(errorMessage, parentId);
        }
        return this;
    }

    //Method Add For BatchJob RecordIds during Exception Thrown..
    public ErrorHandler add(Exception e, List<SObject> scope){
        if(jobConfigId !=null){
            if (Schema.sObjectType.ErrorLog__c.fields.ParentId__c.isCreateable() &&
            Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable() &&
            Schema.sObjectType.ErrorLog__c.fields.RecordIds__c.isCreateable()) {
                ErrorLog__c log = new ErrorLog__c(ParentId__c = jobConfigId, 
                ErrorMessage__c = getException(e), 
                RecordIds__c = getScopeRecordIds(scope));
                this.errors.add(log);
            }
        }
        return this;
    }

    //Methods For BatchJobs 
    public ErrorHandler add(Exception e){
        if(jobConfigId !=null){
            if (Schema.sObjectType.ErrorLog__c.fields.ParentId__c.isCreateable() &&
            Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()) {
            ErrorLog__c log = new ErrorLog__c(ParentId__c = jobConfigId, 
                                                ErrorMessage__c = getException(e));
            this.errors.add(log);
            }
        }
        return this;
    } 

    public ErrorHandler add(String errorMessage, Set<String> parentIds) {
        for (String parentId : parentIds) {
            add(errorMessage, parentId);
        }
        return this;
    }

    public ErrorHandler add(ErrorLog__c log) {
        this.errors.add(log);
        return this;
    }

    public Boolean isEmpty() {
        return errors.isEmpty();
    }

    public void persist() {
        try {
            if(Schema.sObjectType.ErrorLog__c.isCreateable()){
                insert as user errors;
            }
        } catch (Exception e) {
            notify(e);
        }
    }

    public void notify(Exception e) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = fetchRecipients();
        message.subject = 'Error logging failed';
        message.plainTextBody = getConcatenatedErrorMessages();
        Messaging.SingleEmailMessage[] messages =
                new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }

    private List<String> fetchRecipients() {
        List<String> tos = new List<String>();
        Set<Id> userIds = new Set<Id>();
        for (ApexEmailNotification recipient : [SELECT Email, UserId FROM ApexEmailNotification WHERE UserId !=NULL WITH USER_MODE]) {//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if (String.isNotEmpty(recipient.Email)) {
                tos.add(recipient.Email);
            }
            if (String.isNotEmpty(recipient.UserId) && UserInfo.getUserType() != 'AutomatedProcess') {
                userIds.add(recipient.UserId);
            }
        }

        if (userIds.isEmpty() == false) {
            for (User user : [Select Email from User where Id in :userIds and Email != null WITH USER_MODE]) {//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                tos.add(user.Email);
            }
        }
        if (tos.isEmpty()) {
            tos.add(UserInfo.getUserEmail());
        }
        return tos;
    }

    public static String getException(Exception e) {
        return e.getMessage() + '\n\n' + 'Line: ' + e.getLineNumber() + '\nStack Trace: ' + e.getStackTraceString();
    }

    @TestVisible 
    private String getScopeRecordIds(List<SObject> scope) {
        try {
            List<String> ids = new List<String>();
            for (SObject record : scope) {
                ids.add(record.Id);
            }
            return AppUtils.concatenate(ids, '\n');
            //return String.join(ids, '\n');
        } catch (Exception e) {
            return null;
        }
    }

    @TestVisible 
    private String getConcatenatedErrorMessages() {
        List<String> messages = new List<String>();
        for (ErrorLog__c log : errors) {
            messages.add(toString(log));
        }
        return AppUtils.concatenate(messages, '\n');
       // return String.join(messages, '\n');
    }

    private String toString(ErrorLog__c log) {
        return 'Parent Record: ' + log.ParentId__c + ', Error Message:' + log.ErrorMessage__c +'\n'+log.RecordIds__c;
    }

}