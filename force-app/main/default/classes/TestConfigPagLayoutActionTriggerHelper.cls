@isTest
public class TestConfigPagLayoutActionTriggerHelper{
   
    @testSetup static void setup() {
        TestHelper.getPageLayoutConfig(true);
    }
    
    @isTest
    public static void test1(){   
        Test.startTest();
        	PageLayoutConfig__c layout = [Select Id, Name,Description__c,ObjectAPIName__c from PageLayoutConfig__c LIMIT 1];
        	PageLayoutActionConfig__c pageAction = TestHelper.getPageLayoutActionConfig(false,layout.Id);
        	insert pageAction;
        	pageAction.HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'SampleText1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[]}';
            update pageAction;
            System.AssertEquals('/apex/abc?xyz={!abc}',pageAction.ActionURL__c);
       	Test.stopTest();

    }
}