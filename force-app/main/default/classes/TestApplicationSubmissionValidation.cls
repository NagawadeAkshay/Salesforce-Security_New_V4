@isTest
private with sharing class TestApplicationSubmissionValidation{
    private static void setup(){
        TestHelper.getCustomAppConfig(true);
        TestHelper.getUserPreference(true, 'ActiveAppName__c', 'StateAsGrantor');
    }
    @IsTest
    public static void testAllMethods(){
        setup();
        Map<String,Object> result_1 = TaskSummaryCtrl.getTaskCountByPhase();
        System.assertNotEquals(result_1, null);
    }
    
}