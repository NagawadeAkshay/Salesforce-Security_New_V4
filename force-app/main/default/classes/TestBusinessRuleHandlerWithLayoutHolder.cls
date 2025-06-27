/**
 * Created by REI on 23-06-2020.
 */

@IsTest
private with sharing class TestBusinessRuleHandlerWithLayoutHolder {

    private static DynamicLayoutHolder layoutHolder;

    @IsTest
    private static void testAbstractMethod(){
        layoutHolder = TestHelper.getDynamicLayoutHolder();
        Test.startTest();
        Sobject recObj = new SampleObject12__c(Name='Test Obj Val');
        SampleBAClass sampleBAObj = new SampleBAClass();
        sampleBAObj.createBusinessRuleWithLayoutHolder(recObj,layoutHolder);
        sampleBAObj.createBusinessRule(recObj);
        System.assertNotEquals(null,sampleBAObj);
        Test.stopTest();
    }

}