@isTest
private with sharing class  TestCustomAppconfigTriggerHelper {
      
     @isTest
    public static void testExternalLinksConfigLayoutEditCtrl(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
            
            CustomApp__c app = new CustomApp__c ();
            app.Name = 'TestPhase';
            app.Abbreviation__c = 'SG';
            app.Label__c = 'State As Grantor';
            app.ReportsFolderName__c = 'gg';
            app.Sequence__c = 1;
            app.Active__c = true;
            insert app;            
            app.Name = 'TestPhase2';
            update app;
            Delete app;
            list<CustomApp__c> applist=[select id from CustomApp__c where Name =:'TestPhase2'];
            system.assertEquals(0, applist.size());
            Test.stopTest();
        }
    }
}