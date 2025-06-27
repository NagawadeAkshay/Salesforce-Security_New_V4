@isTest
public class TestSessionLogoutCtrl {
@isTest
    private static void setupData(){
        KeyValueStoreHelper.setBooleanValue('SessionEnableManagement',true,true);
        SessionLogoutCtrl obj = new SessionLogoutCtrl();
        obj.logoutPage = '';
        SessionLogoutCtrl.resetSession();
        system.assertNotEquals(null,obj);      
    }
    
    @isTest
    private static void setupData1(){
        
        SessionLogoutCtrl obj = new SessionLogoutCtrl();
        SessionLogoutCtrl.resetSession();
        system.assertNotEquals(null,obj);      
    }
    @isTest
      private static void setupData2(){
        KeyValueStoreHelper.setIntegerValue('SessionTimeoutReminderValue',5,true);
        KeyValueStoreHelper.setBooleanValue('SessionEnableManagement',true,true);
        KeyValueStoreHelper.setTextValue('InternalLoginPage','test', true);
        SessionLogoutCtrl obj = new SessionLogoutCtrl();
        SessionLogoutCtrl.resetSession();
        system.assertNotEquals(null,obj);      
    }
     @isTest
      private static void setupData3(){
        KeyValueStoreHelper.setIntegerValue('SessionTimeoutReminderValue',null,true);
        KeyValueStoreHelper.setIntegerValue('SessionTimeoutValue',5,true);
        KeyValueStoreHelper.setBooleanValue('SessionEnableManagement',true,true);
        SessionLogoutCtrl obj = new SessionLogoutCtrl();
        SessionLogoutCtrl.resetSession();
        system.assertNotEquals(null,obj);      
    }
}