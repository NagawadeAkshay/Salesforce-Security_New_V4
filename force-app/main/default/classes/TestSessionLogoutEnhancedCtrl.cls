@isTest
public class TestSessionLogoutEnhancedCtrl {
    @isTest
    private static void testResetSession(){
        
        SessionLogoutEnhancedCtrl obj = new SessionLogoutEnhancedCtrl();
        obj.enableSessionManagement = true;
        obj.enableSessionDialogBox = true;
        obj.enableSessionReminder = false;
        obj.sessionTimeoutValue = 20;
        obj.sessionTimeoutReminderValue = 20;
        obj.userId = UserInfo.getUserId();
        obj.dialogTimeoutLimit = 10;
        obj.logoutPage = '/apex/logout';
        System.assertEquals(10,obj.dialogTimeoutLimit);
        obj = new SessionLogoutEnhancedCtrl();
        
        SessionLogoutEnhancedCtrl.resetSession();
        System.assertNotEquals(10,obj.dialogTimeoutLimit);
    }
}