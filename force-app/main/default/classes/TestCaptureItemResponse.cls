/**
 * Created by REI on 25-01-2020.
 */

@isTest
public with sharing class TestCaptureItemResponse {

    @testSetup static void setup() {
        TestHelper.getCaptureItemResponseConfig(true);
    }

    
    @isTest static void testGenerateCaptureItemResponse(){
        Test.startTest();
        CaptureItemResponse__c cpItemResponse = [Select Id, Answer__c from CaptureItemResponse__c LIMIT 1];
        System.AssertEquals('Demo Val',cpItemResponse.Answer__c);
        Test.stopTest();
    }
}