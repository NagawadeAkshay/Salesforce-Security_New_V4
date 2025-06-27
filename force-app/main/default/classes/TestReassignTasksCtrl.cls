@IsTest
private with sharing class TestReassignTasksCtrl {
   // static TaskActionSummary__c tas;
   // static Task ts;
    
    @isTest
    private static void testReassignTasksCtrl(){
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
        test.startTest();
        ReassignTasksCtrl fa = new ReassignTasksCtrl ();
        fa.urlParams = new Map<String, String>();
        fa.urlParams.put('sourceUser',UserInfo.getUserId());
        User u = TestHelper.getAdminUser(true);
        fa.urlParams.put('targetUser',u.id);
        test.stopTest();
        system.assert(fa.clickHandler() != null);
    }  
    
    
    @isTest
    private static void testReassignTasksCtrlPath2(){
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
        test.startTest();
        ReassignTasksCtrl fa = new ReassignTasksCtrl ();
        fa.urlParams = new Map<String, String>();
        fa.selectedRecordIds = new List<Id>();
        fa.selectedRecordIds.add(t.id);
        fa.urlParams.put('sourceUser',UserInfo.getUserId());
        User u = TestHelper.getAdminUser(true);
        fa.urlParams.put('targetUser',u.id);
        test.stopTest();
        system.assert(fa.clickHandler() != null);
    }  
    
  }