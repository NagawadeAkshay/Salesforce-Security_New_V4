@isTest
private with sharing class TaskReminderJobTest{
    @isTest
    private static void getQueryTest(){
        TaskReminderJob obj = new TaskReminderJob();
        String query = obj.getQuery();
        
        system.assertEquals('Select Id,Name from User where isActive= true WITH USER_MODE', query);
    }

    // @isTest
    // private static void executeTest(){
    //     TaskReminderJob obj = new TaskReminderJob();
    //     User u = TestHelper.getUser(true);
    //     Task tsk;
    //     System.runAs(u){
    //         TestHelper.getEmailTemplate(true,'emailTemp','emailTemp');
    //         tsk = TestHelper.getTask(false);
    //         tsk.Status = 'Not Started';
    //         insert tsk;
    //         tsk = TestHelper.getTask(false);
    //         tsk.Status = 'Not Started';
    //         insert tsk;
    //     }
    //     KeyValueStoreHelper.setTextValue('TaskReminderType', 'Mulitple', true);
    //     KeyValueStoreHelper.setTextValue('TaskReminderTemplateMultiple', 'emailTemp', true);
    //     //KeyValueStoreHelper.setTextValue('TaskReminderTemplateIndividual', 'emailTemp', true);
    //     List<User> useList = new List<User>();
    //     useList.add(u);
    //     obj.execute(useList);
    //     System.assertnotEquals(null, tsk);
    //     
    // }
    @isTest
    private static void execute2Test(){
        TaskReminderJob obj = new TaskReminderJob();
        User u = TestHelper.getAdminUser(true);
        Task tsk;
        System.runAs(u){
            SObjectConfig__c sObjCon =  TestHelper.getSObjectConfig(false);//SampleObject11__c
            sObjCon.ReminderDays__c = '4';
            insert sObjCon;
            TaskConfig__c tskCon = TestHelper.getTaskConfig('send',false);
            tskCon.ReminderDays__c = '4';
            tskCon.SendIndividualTaskReminder__c = true;
            insert tskCon;
            TestHelper.getEmailTemplate(true,'emailTemp','emailTemp');
            tsk = TestHelper.getTask(false);
            tsk.Status = 'Not Started';
            tsk.Activitydate = Date.Today().addDays(4);
            tsk.TaskConfig__c = tskCon.id;
            insert tsk;
            tsk = TestHelper.getTask(false);
            tsk.Status = 'Not Started';
            tsk.TaskConfig__c = tskCon.id;
            insert tsk;
        }
        KeyValueStoreHelper.setTextValue('TaskReminderType', 'Individual', true);
        //KeyValueStoreHelper.setTextValue('TaskReminderTemplateMultiple', 'emailTemp', true);
        KeyValueStoreHelper.setTextValue('TaskReminderTemplateIndividual', 'emailTemp', true);
        List<User> useList = new List<User>();
        useList.add(u);
        obj.execute(useList);
        System.assertnotEquals(null, tsk);
    }
}