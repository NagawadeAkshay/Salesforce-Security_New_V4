/*
    Interface for calling Page methods to update records when sending an email
    with EmailTemplateCtrl
    ***********************************************************
    Audit History
    ***********************************************************
    2015-08-18      Shrawan Raina   Created
*/
global Interface invokeEmailActionInterface {
    String actionToInvokeBefore();
    String actionToInvokeAfter();
}