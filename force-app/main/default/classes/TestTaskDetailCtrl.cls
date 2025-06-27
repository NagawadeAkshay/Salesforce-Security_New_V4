@isTest
private class TestTaskDetailCtrl {
    
    @isTest 
    private static void testAll() {
        User admin = TestHelper.getAdminUser(true);
        System.runAs(admin) {
            CustomAppConfig__c cac = TestHelper.getCustomAppConfig(true);
            Account a = new Account();
            a.Name = 'Aman';
            a.BillingCity = 'New York City';
            insert a;
            /*TaskSummary__c ts = new TaskSummary__c();
            ts.setupOwnerId = admin.Id;
            ts.AssignedCounts__c = '{"10":"10"}';
            ts.UnassignedCounts__c = '{"20":"20"}';
            insert ts;*/

            PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
            TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayout.id, true);
          
            Task task=TestHelper.getTask(false);
            task.Status='Not Started';
            task.WhatId = a.Id;
            task.AssignedToUserType__c = 'Internal';
            task.Type__c = 'On-Demand';
            task.startdate__c = null;
            task.activitydate = null;
            insert task;
            
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig(false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            insert taskactionsummary;
            
            Test.startTest();
            TaskDetailCtrl.getData(a.Id,task.Id,true);
            String result = TaskDetailCtrl.completeTask(task.Id);
            Test.stopTest();
            System.assert(result != null);
        }
    }
    
    @isTest 
    private static void testAll2() {
        User admin = TestHelper.getAdminUser(true);
        System.runAs(admin) {
            CustomAppConfig__c cac = TestHelper.getCustomAppConfig(true);
            Account a = new Account();
            a.Name = 'Aman';
            a.BillingCity = 'New York City';
            insert a;
            /*TaskSummary__c ts = new TaskSummary__c();
            ts.setupOwnerId = admin.Id;
            ts.AssignedCounts__c = '{"10":"10"}';
            ts.UnassignedCounts__c = '{"20":"20"}';
            insert ts;*/

            PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
            TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayout.id, true);
          
            Task task=TestHelper.getTask(false);
            task.Status='Not Started';
            task.WhatId = a.Id;
            task.AssignedToUserType__c = 'Internal';
            task.Type__c = 'On-Demand';
            task.startdate__c = null;
            task.activitydate = null;
            insert task;
            
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig(false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            insert taskactionsummary;
            
            Test.startTest();
            TaskDetailCtrl.getData(a.Id,task.Id,false);
            String result = TaskDetailCtrl.completeTask(task.Id);
            Test.stopTest();
            System.assert(result != null);
        }
    }
}