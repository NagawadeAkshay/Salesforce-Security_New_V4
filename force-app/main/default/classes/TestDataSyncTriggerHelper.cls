@isTest

private with sharing class TestDataSyncTriggerHelper{

    @isTest
    private static void testConstructor(){
        Test.startTest();
            DataSyncTriggerHelper dataHelper = new DataSyncTriggerHelper(PhaseConfig__c.sObjectType);
        Test.stopTest();
        System.assertNotEquals(null, dataHelper);
        
    }  
    
     @isTest
    private static void testinsert(){
        PhaseConfig__c phase;
        Test.startTest();
         phase = TestHelper.getPhase(true); 
        Test.stopTest();
        system.assert(phase.Id != null);
    }    
     @isTest
    private static void testDelete(){
        PhaseConfig__c phase = TestHelper.getPhase(true); 
        Test.startTest();
         delete phase ;
        Test.stopTest();
        List<PhaseConfig__C> phaseList = [select id from PhaseConfig__c where id =: phase.id];
        system.assert(phaseList.size()== 0);
    }    
    
}