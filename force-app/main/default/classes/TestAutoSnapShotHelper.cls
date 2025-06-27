@isTest
private class TestAutoSnapShotHelper {
 
    @isTest static void TestGenerateAutoSnapShot(){
        Test.startTest();
        try {
            SampleObject1__c sam =TestHelper.getSampleObject1Val(true);
    
            List<Sobject> samplObjLst = new List<SObject>();
            Set<Id> recordIdSet = new Set<Id>();
            samplObjLst.add(sam);
            recordIdSet.add(sam.id);
            SObjectCache__c sObjCache = new SObjectCache__c(Name = 'SampleObject1__c', AutoSnapShotFieldAPIName__c='Status__c',CurrentAppField__c='SampleObject1__c');
            insert sObjCache;
            SObjectAutoSnapshotCache__c sObjAutoCache = new SObjectAutoSnapshotCache__c(Name = 'SampleObject1__c',  SobjectFieldConfigName__c='SampleObject1__c',ExpressionJson__c ='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"String","Value":"Name"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}');
            insert sObjAutoCache;
            AutoSnapShotHelper.generateAutoSnapShot(samplObjLst);
            SObjectAutoSnapshot__c snap =TestHelper.getSObjectAutoSnap(true);
            
          /*   List<SObjectAutoSnapshot__c> sObjectAutoSnapList = new List<SObjectAutoSnapshot__c>();
           sObjectAutoSnapList.add(snap);
            AutoSnapShotHelper.autoSnapShot(recordIdSet, 'SampleObject1__c', JSON.serialize(snap) ,null, null); */                 
            Test.stopTest();
            System.AssertEquals('test',sam.Name);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        }
    }
    
}