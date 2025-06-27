@isTest
public class TestErrorLogTrigger {

 @isTest
    public static void testBeforeInert(){
        Test.startTest();
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            ErrorLog__c apexJob = new ErrorLog__c(Errordescription__c = 'test');
       
            insert apexJob;     
            list<ErrorLog__c> ap= [select id,Errordescription__c from  ErrorLog__c];
            system.assertNotEquals(null,ap.size());
              
        }
        Test.stopTest();
        
    }

}