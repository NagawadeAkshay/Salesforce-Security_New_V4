@isTest
private with sharing class TestTaskSummaryCtrl{
    public static CustomAppConfig__c custAppCon;
    public static CustomAppPhaseConfig__c custAppPhaCon;
    public static CustomAppPhaseConfig__c custAppPhaCon_1;
    public static Task tsk;
    public static Task tsk_1;
    
    private static void setup(){
        TestHelper.getCustomApp(true);
         TestHelper.createCustomSettings(true);
         custAppCon = TestHelper.getCustomAppConfig(true); 
         
         custAppPhaCon = TestHelper.getCustomAppPhaseConfig(false);
         custAppPhaCon.isPhase__c =  true;
         insert custAppPhaCon;
         
         custAppPhaCon_1 = TestHelper.getCustomAppPhaseConfig(false);
         custAppPhaCon_1.isPhase__c = true;
         custAppPhaCon_1.Name = 'No Phase associated';
         insert custAppPhaCon_1;
         
         tsk = TestHelper.getTask(false);
         tsk.status = 'Not Started';
         tsk.PhaseName__c = 'Planning';
         insert tsk;
         
         tsk_1 = TestHelper.getTask(false);
         tsk_1.status = 'completed';
         tsk_1.PhaseName__c = 'Planning';
         insert tsk_1;
    }
    @IsTest
    public static void testAllMethods(){
        setup();
        TaskSummaryCtrl.taskSummaryWrapper compare =  new TaskSummaryCtrl.taskSummaryWrapper();
        compare.taskCount = 0 +'';
        compare.taskLabel = 'Late';
        compare.actionUrl = '#';
        compare.sequence = 0.0;
        
        Test.startTest();
        Map<String,Object> result_1 = TaskSummaryCtrl.getTaskCountByPhase();
        Map<String,Object> result_2 = TaskSummaryCtrl.getLateTasks();
        Map<String,Object> result_3 = TaskSummaryCtrl.getDueComingMonthsTasks();
        Map<String,Object> result_4 = TaskSummaryCtrl.getDueInSevenDaysTasks();
        Map<String,Object> result_5 = TaskSummaryCtrl.getDueInThirtyDaysTasks();
        TaskSummaryCtrl.taskSummaryWrapper tskWrap = new TaskSummaryCtrl.taskSummaryWrapper();
        Integer result_6 = tskWrap.compareTo(compare);
        Test.stopTest();
        System.assertNotEquals(result_1, null);
    }

    @isTest
    static void testGetHideChartConfig2(){
        UserPreferences__c pref = new UserPreferences__c(
            IsHideByPhaseTaskSummaryChart__c = true,
            IsHideByDuedateTaskSummaryChart__c = false
        );
        Test.startTest();
        insert pref;
        Test.stopTest();
        Map<String,Boolean> result = TaskSummaryCtrl.getHideChartConfig2();
        System.assertNotEquals(null, result);
        System.assertEquals(true, result.get('isHideByphase'));
        System.assertEquals(false, result.get('isHideByDuedate'));
    }
    
}