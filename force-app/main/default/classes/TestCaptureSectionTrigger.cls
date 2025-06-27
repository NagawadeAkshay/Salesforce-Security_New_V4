/**
 * Created by REI on 25-01-2020.
 */
@isTest
public with sharing class TestCaptureSectionTrigger {

    @testSetup static void setup() {
        TestHelper.getCaptureSectionConfig(true);
    }
   
    @isTest static void testGenerateCaptureSection(){
        Test.startTest();
        CaptureSection__c cpSection = [Select Id, Name__c, CaptureForm__c, Order__c, SectionColumn__c from CaptureSection__c LIMIT 1];
        System.AssertEquals('Section 1',cpSection.Name__c);
        Test.stopTest();
    }
}