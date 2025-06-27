@isTest
private class TestSobjectAutoSnapShotTriggerHelper {
    
    @testSetup static void setup() {
        TestHelper.getSObjectAutoSnap(true);
    } 
    
    @isTest static void testInsert(){
		SObjectAutoSnapshot__c  sobjAutoSnap; 
        Test.startTest();
        sobjAutoSnap = [Select Id,SObject__c,isActive__c, SnapShotFileName__c from SObjectAutoSnapshot__c LIMIT 1];
        System.AssertEquals('Demo Snap Shot',sobjAutoSnap.SnapShotFileName__c);
        Test.stopTest();
       	
    } 
    
    @isTest static void testUpdate(){
        SObjectAutoSnapshot__c  sobjAutoSnap;
        Test.startTest();
            sobjAutoSnap = [Select Id,SObject__c,isActive__c, SnapShotFileName__c from SObjectAutoSnapshot__c LIMIT 1];
        sobjAutoSnap.SnapShotFileName__c = 'New Snap';
        update sobjAutoSnap;
            System.AssertEquals('New Snap',sobjAutoSnap.SnapShotFileName__c);
        Test.stopTest();
        
    }

    @isTest static void testDelete(){
        SObjectAutoSnapshot__c  sobjAutoSnap;
        Test.startTest();
        	sobjAutoSnap =  [Select Id,SObject__c,isActive__c,IsDeleted, SnapShotFileName__c from SObjectAutoSnapshot__c  LIMIT 1];
        delete sobjAutoSnap;
        list<SObjectAutoSnapshot__c> objafterdelete = [Select Id,SObject__c,isActive__c,IsDeleted, SnapShotFileName__c from SObjectAutoSnapshot__c  LIMIT 1];
        system.assertEquals(0, objafterdelete.size());
        Test.stopTest();           
    }

    @isTest static void testDeleteSobjectAutoSnapCache(){
        SObjectAutoSnapshot__c  sobjAutoSnap;
        Test.startTest();
            sobjAutoSnap =  [Select Id,SObject__c,isActive__c, SnapShotFileName__c from SObjectAutoSnapshot__c LIMIT 1];
        sobjAutoSnap.isActive__c = false;
        update sobjAutoSnap;
            System.assertEquals(false, sobjAutoSnap.isActive__c);
        Test.stopTest();
       
        
    }
}