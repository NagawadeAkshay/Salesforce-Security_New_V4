@IsTest
private with sharing class TestTaskReassignmentBatch {

    
    @isTest
    private static void TestTaskReassignmentBatchMethod(){
        TestHelper.createCustomSettings(true);
        TestHelper.getCustomAppConfig(true);
        TestHelper.getUserPreference(true,'ActiveAppName__c','StateasGrantor');
        //Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        Account acc=TestHelper.getAccount(false);
        //acc.Status__c = 'Active';
        //acc.IsActiveAgency__c=true;
        //acc.RecordTypeId =recordTypeId;
        insert acc;
        
        
        PhaseConfig__c pconfig=TestHelper.getPhase(true);
            
        TaskConfig__c taskactionsummary=TestHelper.getTaskConfig(false);
        taskactionsummary.DueDateOffset__c=7;
        taskactionsummary.GroupType__c='MyTasks';
        taskactionsummary.Sequence__c=2;
        taskactionsummary.TaskLabel__c='Review Announcements';
        taskactionsummary.PhaseConfig__c=pconfig.id;
        insert taskactionsummary;
        
        
        Task t = new Task();
        t.whatId = acc.id;
        t.TaskAction__c='Review Announcements';
        t.ownerId = UserInfo.getUserId();
        insert t;
        Set<Id> taskId = new Set<Id>();
        taskId.add(t.id);
        User u = TestHelper.getAdminUser(true);
        KeyValueStore__c TaskReassignmentEmailFields = new KeyValueStore__c(Name='TaskReassignmentEmailFields',TextValue__c='TaskAction__c',
                        Description__c='fields that should be included in Task reassignment email sent',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        insert TaskReassignmentEmailFields;                
        
        Test.startTest();
        TaskReassignmentBatch bat = new TaskReassignmentBatch(taskId,UserInfo.getUserId(),u.id);        
        Database.executeBatch(bat, 1);
        Test.stopTest();
        System.assertNotEquals(null, bat);
    }

}