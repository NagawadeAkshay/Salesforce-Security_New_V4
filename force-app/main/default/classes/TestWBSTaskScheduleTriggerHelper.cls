/**
* @Class Name: TestWBSTaskScheduleTriggerHelper
* @Description: This class is test class for WbsTaskScheduleTrigger
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |03/04/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/

@isTest
public class TestWBSTaskScheduleTriggerHelper {
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testSingleWBSTaskSchedule
* @Description: This method is used to test insert update delete undelete of single WBSTaskSchedule__c record.
* @Param: NA  
* @Return: NA
* @Date: 03/04/2019
**/ 
    @isTest
    private static void testSingleWBSTaskSchedule(){
        test.startTest();
        WBSTaskSchedule__c wbsTask = new WBSTaskSchedule__c(ProgressIndicator__c=2);
        insert wbsTask;
        String wbsTaskID=wbsTask.id;
        WBSTaskSchedule__c wbsTask1 = new WBSTaskSchedule__c();
        wbsTask1.ParentWBSTaskSchedule__c=wbsTask.ID;
        wbsTask1.ProgressIndicator__c=3;
        insert wbsTask1;
        System.assertNotEquals(null, wbsTask1.Id);
        delete wbsTask1;
        undelete wbsTask1;
        test.stopTest();
    }
    
    
   /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testListWBSTaskSchedule
* @Description: This method is used to test insert update delete undelete of  WBSTaskSchedule__c records List.
* @Param: NA  
* @Return: NA
* @Date: 03/04/2019
**/ 
    @isTest
    private static void testListWBSTaskSchedule(){
        test.startTest();
        List<WBSTaskSchedule__c> WBSTaskScheduleList= new List<WBSTaskSchedule__c>();
        WBSTaskSchedule__c wbsTask = new WBSTaskSchedule__c(ProgressIndicator__c=6);
        insert wbsTask;
        System.assertNotEquals(null, wbsTask);
               
        WBSTaskSchedule__c wbsTask1 = new WBSTaskSchedule__c(ParentWBSTaskSchedule__c=wbsTask.ID,ProgressIndicator__c=1);
        WBSTaskSchedule__c wbsTask2 = new WBSTaskSchedule__c(ParentWBSTaskSchedule__c=wbsTask.ID,ProgressIndicator__c=2);
        WBSTaskSchedule__c wbsTask3 = new WBSTaskSchedule__c(ParentWBSTaskSchedule__c=wbsTask.ID,ProgressIndicator__c=3);
        WBSTaskSchedule__c wbsTask4 = new WBSTaskSchedule__c(ParentWBSTaskSchedule__c=wbsTask.ID,ProgressIndicator__c=4);//insert WBSTaskScheduleList;
        WBSTaskScheduleList.add(wbsTask1);
        WBSTaskScheduleList.add(wbsTask2);
        WBSTaskScheduleList.add(wbsTask3);
        WBSTaskScheduleList.add(wbsTask4);
        insert WBSTaskScheduleList;
        delete WBSTaskScheduleList;
        undelete WBSTaskScheduleList;

        test.stopTest();
    }
}