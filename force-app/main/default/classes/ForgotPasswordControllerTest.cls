@isTest
private class ForgotPasswordControllerTest {    

    @isTest
    public static void testForgotPasswordControllerSuccess() {
        User objUser = new User(
            ProfileId = UserInfo.getProfileId(),
            LastName = 'Test User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert objUser;
        System.assertNotEquals(null, objUser.Id);

        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = objUser.UserName;
        PageReference forgotPasswordResult;
        system.runAs(objUser){
            forgotPasswordResult = controller.forgotPassword();
        }
    }
}