/*
  This is a test Class for the NameTemplateTriggerHelper class
   which is called by any object on a before insert event 
   the purpose of the NameTemplateTriggerHelper is to set the 
   name field on the incoming records according to a specified 
   template 
  **********************************************************
  Audit History
  **********************************************************
  2014-03-05   Vinayak Sharma Created
  **********************************************************  
*/

@isTest
private with sharing class TestNameTemplateTriggerHelper {
    
    @isTest
    public static void testTemplateTrigger(){ 
        User u = TestHelper.getStandardUser(true);
        System.runAs(u) {
    	Test.startTest();
        TestHelper.CreateCustomSettings(true);
        NameTemplateConfig__c configAnnouncement =  TestHelper.getNameTemplateConfigAnnouncement(true);
        NameTemplateConfig__c config =  TestHelper.getNameTemplateConfig(false);
        insert config;         
        NameTemplateSequence__c templateSequence = TestHelper.getNameTemplateSequence(true);
        NameTemplateSequence__c templateSequenceAnnouncement = TestHelper.getNameTemplateSequenceAnnouncement(true);        
        NameTemplateTriggerHelper namTemp = new NameTemplateTriggerHelper();
        
        Test.stopTest();
        NameTemplateSequence__c app = [Select Id,Name from NameTemplateSequence__c where Id =:templateSequence.Id];        
        System.assertNotEquals(null, app);  
        }
    }                        
    
    @isTest
    public static void testAutoNumberSkipped(){
        User u = TestHelper.getStandardUser(true);
        System.runAs(u) {
        TestHelper.CreateCustomSettings(true);
        NameTemplateConfig__c configAnnouncement =  TestHelper.getNameTemplateConfigAnnouncement(true);
        NameTemplateConfig__c config =  TestHelper.getNameTemplateConfig(false); 
        config.StartNumber__c = 1000;
        config.SkipAutoNumberReset__c = true;  
        insert config;         
        NameTemplateSequence__c templateSequence = TestHelper.getNameTemplateSequence(false);
        NameTemplateSequence__c templateSequenceAnnouncement = TestHelper.getNameTemplateSequenceAnnouncement(true);
        templateSequence.Year__c = (System.today().year()- 1); 
        templateSequence.LastSequence__c = 2000;
        insert templateSequence;         
        //SampleObject11__c announcement = TestHelper.getSampleObject1(true);
        Test.startTest();
        SampleObject11__c application = TestHelper.getSampleObject1(true); 
        Test.stopTest();
       NameTemplateSequence__c app = [Select Id,Name from NameTemplateSequence__c where Id =:templateSequence.Id];        
        System.assertNotEquals(null, app);  
        }
    }

    @isTest
    static void verifyNameTemplateTriggerHelper(){
        NameTemplateSequence__c templateSeq = new NameTemplateSequence__c(); 
        templateSeq.Name = 'Sample-New-TBD-';
        String nameSpace = AppUtils.getNameSpacePrefix();
        templateSeq.ObjectName__c = nameSpace+'SampleObject1__c';
        templateSeq.StartSequence__c = 1000;
        templateSeq.Year__c = System.today().year();
        insert templateSeq;

        NameTemplateConfig__c objNameTemplate = new NameTemplateConfig__c(
            Active__c = true,
            AutoNumberFormat__c = '{00000}',
            FormulaFieldName__c = 'NameTemplate__c',
            Name = 'SampleObject1__c',
            SkipAutoNumberReset__c = true,
            StartNumber__c = 1
        );
        insert objNameTemplate;
        System.assertNotEquals(null, objNameTemplate);
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        System.assertNotEquals(null, sampleObject1.Id);
    }
}