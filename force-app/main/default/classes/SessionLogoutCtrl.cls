/*
 Description:
 Automatic session logout. The localStorage object stores data with no expiration date. 
 The data will not be deleted when the browser is closed, and will be available the next day, week, or year.
 
**********************************************************
Audit History

**********************************************************
2018-15-2      Prajakta Gadhe             Created 
**********************************************************  

*/ 




global with sharing class SessionLogoutCtrl{
   public transient Boolean enableSessionDialogBox {get;set;} 
   public transient Boolean enableSessionManagement {get;set;}  
   public transient Boolean enableSessionReminder {get;set;}  
   public transient Integer sessionTimeoutValue {get;set;} 
   public transient Integer sessionTimeoutReminderValue {get;set;} 
   public transient Id userId {get;set;}
   public transient Integer dialogTimeoutLimit {get;set;}
   public transient String logoutPage{get;set;}
   public String sessionLogoutResource {get;set;}

   global SessionLogoutCtrl(){ 
       try{
           sessionLogoutResource = AppUtils.getIcons('SessionLogout');
           enableSessionManagement = KeyValueStoreHelper.getBooleanValue('SessionEnableManagement',true);
             String userType = UserInfo.getUserType();

           if(enableSessionManagement == true && userType != 'GUEST') {
               enableSessionDialogBox = KeyValueStoreHelper.getBooleanValue('SessionEnableDialogBox',true);
               enableSessionReminder = KeyValueStoreHelper.getBooleanValue('SessionEnableReminder',true);
               
               sessionTimeoutValue = KeyValueStoreHelper.getIntegerValue('SessionTimeoutValue',true);
               dialogTimeoutLimit = KeyValueStoreHelper.getIntegerValue('SessionDialogTimeoutLimit',true);
               
               sessionTimeoutReminderValue = KeyValueStoreHelper.getIntegerValue('SessionTimeoutReminderValue',true);
               
               
               if(dialogTimeoutLimit == null){
                   dialogTimeoutLimit  = 10;
               }
               if(sessionTimeoutValue == null){
                    CustomExceptions.logException('Please defined SessionTimeoutValue in keyvalue custom setting', false);
               }
               if(sessionTimeoutReminderValue == null ){
                   sessionTimeoutReminderValue = 10;    
               }
               sessionTimeoutValue = sessionTimeoutValue*60;
               dialogTimeoutLimit = dialogTimeoutLimit *60;
               sessionTimeoutValue = sessionTimeoutValue - dialogTimeoutLimit ;
               sessionTimeoutReminderValue = sessionTimeoutReminderValue*60;
               userId = Userinfo.getUserId();
               UserPreferences__c pref = UserPreferences__c.getInstance();
               if(pref == null ) {
                  CustomExceptions.logException(String.format(System.Label.UserPrefrenceLabel, new List<String>{Userinfo.getUserId()}), false);
        
               }      
               if (pref.IsApplicant__c || pref.IsReviewer__c ) {
                   if(KeyValueStoreHelper.getTextValue('ExternalLoginPage', true) != null ){
                      logoutPage = KeyValueStoreHelper.getTextValue('ExternalLoginPage', true);
        
                   }else{
                      CustomExceptions.logException('KeyValue not found for ExternalLoginPage ', false);
                   }
                    
                }
                else{
                    if( KeyValueStoreHelper.getTextValue('InternalLoginPage', true) != null){
                      logoutPage = KeyValueStoreHelper.getTextValue('InternalLoginPage', true);
                    }else{
                       CustomExceptions.logException('KeyValue not found for InternalLoginPage', false);
        
                    }
        
                }
           } else {
				//session will not be for guest user
				enableSessionManagement = false;
               sessionTimeoutValue = 200000;
                dialogTimeoutLimit = 100000;
                sessionTimeoutReminderValue = 100000;
               
           
           }
           
          } catch(Exception e) {
             
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  AppUtils.handleSystemExceptionMsg(e)));    
          
          }
    
   }
   
    @RemoteAction
    global static void resetSession() {
    
    }
}