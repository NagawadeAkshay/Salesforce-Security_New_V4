/**
 * Created by REI on 23-06-2020.
 */

@IsTest
private with sharing class TestBusinessRuleHandler {

    @IsTest
    private static void testAbstractMethod(){
        Test.startTest();
        SampleBAClass samplABObj = new SampleBAClass();
        Sobject sobj = new Account(Name='Trailhead');
        samplABObj.createBusinessRule(sobj);
        System.assertNotEquals(null,samplABObj);
        Test.stopTest();
    }

}