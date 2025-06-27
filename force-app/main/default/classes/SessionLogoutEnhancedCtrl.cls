global with sharing class SessionLogoutEnhancedCtrl {

    public transient Boolean enableSessionManagement {get;set;}  
    public transient Boolean enableSessionDialogBox {get;set;} 
    public transient Boolean enableSessionReminder {get;set;}  
    public transient Integer sessionTimeoutValue {get;set;} 
    public transient Integer sessionTimeoutReminderValue {get;set;} 
    public transient Id userId {get;set;}
    public transient Integer dialogTimeoutLimit {get;set;}
    public transient String logoutPage {get;set;}
    public String sessionLogoutResource {get;set;}

    global SessionLogoutEnhancedCtrl(){
        try{
            sessionLogoutResource = AppUtils.getResourceURL('SessionLogout');
            if(enableSessionManagement == true ){   //User Story 153849: ROP - GUEST USER SESSION TIMEOUT          && userType != 'GUEST') {
                if(enableSessionDialogBox){
                    sessionTimeoutValue = sessionTimeoutValue - dialogTimeoutLimit;
                }
                userId = Userinfo.getUserId();
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  AppUtils.handleSystemExceptionMsg(e)));    
        }
    }

    @RemoteAction
    global static void resetSession() {

    }
}