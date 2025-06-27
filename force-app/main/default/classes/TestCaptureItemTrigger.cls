/**
 * Created by REI on 25-01-2020.
 */

@isTest
public with sharing class TestCaptureItemTrigger {

     @testSetup static void setup() {
       TestHelper.getCaptureItemConfig(true);
    }

    @isTest static void testGenerateCaptureItem(){
        Test.startTest();
        CaptureItem__c cpItem = [Select Id, QuestionRichText__c,Type__c,MaxScore__c,Order__c,CaptureSection__c from CaptureItem__c LIMIT 1];
        System.AssertEquals('Demo Question',cpItem.QuestionRichText__c);
        Test.stopTest();
    }
}