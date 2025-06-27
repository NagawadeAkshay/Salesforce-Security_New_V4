@isTest
private with sharing class TestPackageTrigger{

    @isTest
    static void testAll(){
              user u = TestHelper.getAdminUser(false);
            
           system.runAs(u){

               Test.startTest();
               Account acc = TestHelper.getAccount(true);
               Package__c pkg = TestHelper.getPackage_Data_1(false,'Award');
               pkg.Status__c = 'Active';
               insert pkg;                           
               update pkg;
               system.assertEquals(pkg.Status__c,'Active');
               delete pkg;
               Test.stopTest();
               
           }
        } 
}