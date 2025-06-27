@isTest
private class TestConfigPageTemplateTriggerHelper{
    @isTest
    public static void test1(){
        PageLayoutConfig__c layout = TestHelper.getPageLayoutConfig(true);
       
        Test.startTest();
            PageTemplate__c page = TestHelper.getPageTemplateConfig(true);
            page.Name = 'UpdateName';
            update page;
       Test.stopTest();
       system.assert(page.SObjectName__c!= null);
    }
}