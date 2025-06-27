/**
 * Created by REI on 25-01-2020.
 */
@isTest
public with sharing class TestCaptureFormTrigger {

    @testSetup static void setup() {
        TestHelper.createCaptureForm();
    }

    @isTest static void testGenerateCaptureForm(){
        Test.startTest();
        CaptureForm__c cpForm =[Select ID, Name__c from CaptureForm__c];
        System.AssertEquals('Sample Form Test',cpForm.Name__c);
        Test.stopTest();
    }
}