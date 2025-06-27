@isTest
public with sharing class TestConfigFormActionTriggerHelper {
    public TestConfigFormActionTriggerHelper() {

    }
    @TestSetup
    static void makeData(){
       
        List<CaptureForm__c> captureFormLst = new List<CaptureForm__c>();
        for(Integer i =0; i<=2 ; i++) {
            captureFormLst.add(new CaptureForm__c(Name__c = 'Test form '+i, ObjectType__c='SampleObject1__c'));
        }
        insert captureFormLst;
        List<CaptureAction__c> captureActionLst = new List<CaptureAction__c>();
        Map<Id, CaptureForm__c> captureFormMap = new Map<Id, CaptureForm__c>([SELECT Id, Name , ObjectType__c FROM CaptureForm__c]);
        for(Integer i =0; i<=2 ; i++){
            for(Id captureFormId : captureFormMap.keyset()){
                 captureActionLst.add(new CaptureAction__c(CaptureForm__c = captureFormId,Name__c = 'Test Action '+i,Action__c='Action Class',ActionTarget__c='NewAccount',HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Id"},"Operator":"!=","ROperand":{"Type":"Freetext","Value":"null","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject1__c"}'));
            }
        }
        insert captureActionLst;
        
    }

    @isTest 
    static void testPopulateHideExpFieldsPositive(){
        Test.startTest();
        List<CaptureAction__c> captureActionLst = new List<CaptureAction__c>();
        Map<Id, CaptureForm__c> captureFormMap = new Map<Id, CaptureForm__c>([SELECT Id, Name , ObjectType__c FROM CaptureForm__c]);
        for(Integer i =0; i<=2 ; i++){
            for(Id captureFormId : captureFormMap.keyset()){
                 captureActionLst.add(new CaptureAction__c(CaptureForm__c = captureFormId,Name__c = 'Test Action '+i,Action__c='Action Class',ActionTarget__c='NewAccount',HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Id"},"Operator":"!=","ROperand":{"Type":"Freetext","Value":"null","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject1__c"}'));
            }
        }
        insert captureActionLst;
        System.assertEquals('Test Action 0' ,captureActionLst[0].Name__c);
        Test.stopTest();
       
    }
    @isTest 
    static void testPopulateHideExpFieldsNegative(){
         Test.startTest();
        List<CaptureAction__c> captureActionLst = new List<CaptureAction__c>();
        CaptureForm__c captureForm =[SELECT Id, Name , ObjectType__c FROM CaptureForm__c LIMIT 1];
        captureForm.ObjectType__c = 'Announcement__c';
        upsert captureForm;
        for(Integer i =0; i<=2 ; i++){
            captureActionLst.add(new CaptureAction__c(CaptureForm__c = captureForm.Id,Name__c = 'Test Action '+i,Action__c='Action Class',ActionTarget__c='NewAccount',HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Id"},"Operator":"!=","ROperand":{"Type":"Freetext","Value":"null","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject1__c"}'));
         }
        insert captureActionLst;
        System.assertEquals('Test Action 0' ,captureActionLst[0].Name__c);
        Test.stopTest();
}
    @isTest 
    static void testPopulateHideExpFieldsUpdate(){
        Test.startTest();
        List<CaptureAction__c> captureActionLst = [SELECT Id,CaptureForm__c,Name__c,Action__c,ActionTarget__c,HideExpressionJSON__c FROM  CaptureAction__c];
        for(CaptureAction__c captureAction :captureActionLst){
            captureAction.Name__c= 'Updated Test Action ';
        }
        update captureActionLst;
        System.assertEquals('Updated Test Action ' ,captureActionLst[0].Name__c);
        Test.stopTest();
    }

    
}