@isTest
private class TestSObjectLayoutConfigTriggerHelper {
    @isTest
    private static void testpopulateLayoutExpressionFields() {
        SObjectLayoutConfig__c sobjLayoutConfig = TestHelper.getSObjectLayoutConfig(true);
        sobjLayoutConfig.DisplayLayoutExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Id"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"a1N6A000000ZfCK","Values":[]}}],"Groups":[]}';
        update sobjLayoutConfig;
        
        sobjLayoutConfig = [SELECT DisplayLayoutExpressionFields__c FROM SObjectLayoutConfig__c WHERE Id =:sobjLayoutConfig.Id ];
        system.assertEquals('Id', sobjLayoutConfig.DisplayLayoutExpressionFields__c);
    }
}