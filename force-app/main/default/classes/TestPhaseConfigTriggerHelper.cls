@isTest
private with sharing class  TestPhaseConfigTriggerHelper {
      
     @isTest
    public static void testExternalLinksConfigLayoutEditCtrl(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
            
            PhaseConfig__c phase=TestHelper.getPhase(false);
            phase.Name = 'TestPhase';
            phase.CustomAppName__c = 'StateAsGrantor';
           
            insert phase;
            list<PhaseConfig__c> insertlist=[select id,name from PhaseConfig__c where Name=: 'TestPhase'] ;
            system.assertEquals(1, insertlist.size());
            
            phase.Name = 'TestPhase2';
            update phase;
            list<PhaseConfig__c> updatelist=[select id,name from PhaseConfig__c where Name=: 'TestPhase2'] ;
            system.assertEquals(insertlist[0].id, updatelist[0].id);
            
            Delete phase;
            list<PhaseConfig__c> deletelist=[select id,name from PhaseConfig__c where Name=: 'TestPhase2'];
            system.assertEquals(0, deletelist.size());
            
            Test.stopTest();
        }
    }
}