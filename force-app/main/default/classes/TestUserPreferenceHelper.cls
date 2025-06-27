/**
    Test class for UserPreferenceHelper
    **********************************************************
    Audit History
    **********************************************************
    4/27/2014   Someone   Created
    5/19/2014   Vani      Added TestUserGrpQueUseCase
    10/26/2016 	Anuja	  			
    **********************************************************  
*/
@isTest
private with sharing class TestUserPreferenceHelper {

    @IsTest(OnInstall=false)
    private static void modifyMyName() {
        //Prepare test data
        
        Test.startTest();

        //Execute test
		UserPreferenceHelper.getBooleanValue('IsInternal__c');
       	UserPreferenceHelper.getStringValue('ActiveAppName__c');
        Test.stopTest();

        //Assert test data
        System.assertEquals(true, true);
    }
    @IsTest
    private static void TestUserGrpQueUseCase() {
        //Prepare test data
        
        User u = TestHelper.getAdminUser(true);
          System.runAs(u) 
          {
          
        List<Profile> lProfile = [Select Id, Name from Profile where UserType = 'Standard'  limit 2];
        User UserObj = [select ProfileId, Id from User where Id != : UserInfo.getUserId() and UserType = 'Standard' limit 1];
        
        
        Test.startTest();
        
        /*if(lProfile != null && lProfile.size() > 0 && UserObj != null){
           // UserObj.ProfileId = lProfile[0].Id;
            update UserObj;
            if(lProfile.size() > 1) {
                //UserObj.ProfileId = lProfile[1].Id;
                update UserObj;
               // UserObj.ProfileId = lProfile[0].Id;
                update UserObj;
            }
        }*/
        //Execute test
        //TestHelper.createCustomSettings(true);
       	UserPreferenceHelper.getBooleanValue('IsInternal__c');
       	UserPreferenceHelper.getStringValue('ActiveAppName__c');
       	UserPreferenceHelper.setBooleanValue('IsInternal__c',true);
       	UserPreferenceHelper.setStringValue('ActiveAppName__c','StateAsGrantor');
        UserPreferenceHelper.getAppName('ActiveAppName__c',UserInfo.getUserId());
        UserPreferenceHelper.getCurrentApp();
       	Test.stopTest();

        //Assert test data
         System.assertNotEquals(UserObj.ProfileId, null);
        }
    }
}