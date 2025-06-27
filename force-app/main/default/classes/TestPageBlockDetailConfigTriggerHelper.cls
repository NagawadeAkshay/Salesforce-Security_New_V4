@isTest
private with sharing class TestPageBlockDetailConfigTriggerHelper{
    
    private testMethod static void testAll(){
      		   Test.startTest();	
               PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
               TabConfig__c tabConfig =  testHelper.getTabConfig(pageLayoutConfig.Id,true);
               PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);
               PageBlockDetailConfig__c pageBlockDetailConfig = testHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);                      
               pageBlockDetailConfig.FieldAPIName__c='Id';
               pageBlockDetailConfig.HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}';
               pageBlockDetailConfig.ReadOnlyExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}';       
               update pageBlockDetailConfig ;
               test.stopTest();
               system.assertEquals(pageBlockDetailConfig.FieldAPIName__c,'Id');
           
    }
    private testMethod static void testValidateRecordFieldApiName() {
      String objectAPIName = 'SampleObject11__c'; 
      String objectAPINamePrefix = AppUtils.applyNamespacePrefix(objectAPIName);
      PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true,objectAPINamePrefix);
      TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayout.Id,true);
      PageBlockConfig__c pageBlock = TestHelper.getPageBlockConfig(tabConfig.Id,true);
      PageBlockDetailConfig__c pageBlockDetail = TestHelper.getPageBlockDetailConfig(pageBlock.Id,true);
      Test.startTest();
      pageBlockDetail.FieldAPIName__c = 'Name';
      update pageBlockDetail;
      Test.stopTest();
      system.assertEquals(pageBlockDetail.FieldAPIName__c,'Name');
    }
}