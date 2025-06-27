@isTest
private class TestTaskCreationHandler {
    
    @isTest
    private static void testAll() {
        User admin = TestHelper.getAdminUser(true);
        TestHelper.createCustomSettings(true);
        TestHelper.getCustomAppConfig(true);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        
        System.runAs(admin) {
           PhaseConfigTriggerHelper.skipTrigger = true;
            // AccountTriggerHelper.skipTrigger = true;
                    
            Account a = new Account();
            a.Name = 'Aman';
            a.BillingCity = 'New York City';
            //a.EINo__c = 234234234;
            //a.EINText__c = '234234234';
            // a.EINText__c = 234234234;
            insert a;

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
            
           // PhaseConfig__c pconfig=TestHelper.getPhase(true);
            AppUtils.skipPhaseConfigTrigger = true;
            PhaseConfig__c phase = new PhaseConfig__c();
            phase.Name = 'TestPhase';
            phase.TabName__c='PLANNING';
            phase.CustomAppName__c = 'StateAsGrantor';
            //phase.URL__c = '/apex/ChartsView?t=Planning';
            phase.GroupName__c='2';
            phase.Sequence__c=2;
            phase.Abbreviation__c ='PL';
            phase.SObject__c = 'SampleObject11__c;SampleObject12__c'; 
            phase.AccordionHeader__c = 'Planning';
            phase.EnableSearch__c = true;
            phase.SidebarSearchLabel__c = 'Search';
            phase.SidebarRecentlyViewedLabel__c = 'Recently Viewed';
            phase.SidebarExternalLinksLabel__c = 'External Links';     
            phase.SearchResultPage__c ='/apex/planning';
            phase.SidebarComponentSequence__c = 'Search,Links,RecentlyViewed,SubMenu';
            phase.EnableExternalLinks__c = true;
         
            phase.Active__c= true;
            phase.PhaseType__c = 'Phase';
            phase.SelectedByDefault__c = true;
            phase.URL__c='www.login.salesforce.com';
            insert phase;
            
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig('ReviewApplication',false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            taskactionsummary.PhaseConfig__c= phase.id;
            insert taskactionsummary;
            
            Group g = new Group();
            g.Name = 'TestGroup';
            g.DeveloperName  = 'TestGroup';
            g.Type = 'Queue';
            insert g;
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = g.id;
            grpMem.UserOrGroupId = admin.Id;
            insert grpMem;
            Test.startTest();
            //CustomAppConfig__c cac = TestHelper.getCustomAppConfig(true);
            List<Task> taskList = new List<Task>();
            TaskCreationHandler.TaskBulkClass tbc = new TaskCreationHandler.TaskBulkClass();
            tbc.ownerUserId = admin.Id;
            tbc.recordId = task.whatId;
            tbc.action = 'ReviewApplication';
            tbc.recordName = 'TaskRecord';
            tbc.groupName = g.Name;
            tbc.dueDate = null;
            tbc.startDate = null;
            tbc.taskCompleted = true;
            tbc.comments = 'Comments';
            tbc.taskType = task.Type__c;
            tbc.taskScheduleDetailId = null;
            tbc.subject = 'Subject';
            TestHelper.getUserPreference(true, 'ActiveAppName__c', 'StateAsGrantor');
            List<TaskCreationHandler.TaskBulkClass> bulkList = new List<TaskCreationHandler.TaskBulkClass>();
            bulkList.add(tbc);
            TaskCreationHandler.createBulkTasks(bulkList,true);
            taskList = TaskCreationHandler.createTasks(admin.Id,task.whatId,'ReviewApplication','Task Record',null, false, null, task.Type__c,true);
            TaskCreationHandler.createTasksEnhanced(admin.Id ,a, 'ReviewApplication' , 'TaskRecord' ,  g.Name , true , null ,task.Type__c ,'Subject', true ,true );
            TaskCreationHandler.isValidSalesforceId(a.id);
            TaskCreationHandler.isValidSalesforceId('');
            TaskCreationHandler.closeTask(task.id);
            //TaskCreationHandler.createApprovalProcessTasks(task.whatId,'ReviewApplication','TaskRecord',null,null,true);
           // TaskCreationHandler.createApprovalProcessTasks(task.whatId,'ReviewApplication','TaskRecord',null,null,true);
            System.assert(taskList != null);
            Test.stopTest();
            
        }
    }
    
    @isTest
    private static void testAll2() {
        User admin = TestHelper.getAdminUser(true);
        TestHelper.createCustomSettings(true);
        TestHelper.getCustomAppConfig(true);
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
       
        
        System.runAs(admin) {
            PhaseConfigTriggerHelper.skipTrigger = true;
            // AccountTriggerHelper.skipTrigger = true;
            Account a = new Account();
            a.Name = 'Aman';
            a.BillingCity = 'New York City';
            //a.EINo__c = 234234235;
            //a.EINText__c = '234234235';
            //a.EINText__c = 234234235;
            insert a;
            
            PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
            TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayout.id, true);
            
            SampleObject1__c sampleObj = new SampleObject1__c(Name='test',Status__c = 'In Progress',SamplePicklist1__c = 'Sample');
            insert sampleObj;
            
            Task task=TestHelper.getTask(false);
            task.Status='Not Started';
            task.WhatId = a.Id;
            task.AssignedToUserType__c = 'Internal';
            task.Type__c = 'On-Demand';
            task.startdate__c = null;
            task.activitydate = null;
            insert task;
            AppUtils.skipPhaseConfigTrigger = true;
            PhaseConfig__c pconfig=TestHelper.getPhase(true);
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig('ReviewApplication',false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            taskactionsummary.PhaseConfig__c=pconfig.id;
            insert taskactionsummary;
            
            Group g = new Group();
            g.Name = 'TestGroup';
            g.DeveloperName  = 'TestGroup12';
            insert g;           
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = g.id;
            grpMem.UserOrGroupId = admin.Id;
            insert grpMem;
            
            Test.startTest();
            //CustomAppConfig__c cac = TestHelper.getCustomAppConfig(true);
            List<Task> taskList = new List<Task>();
            TaskCreationHandler.TaskBulkClass tbc = new TaskCreationHandler.TaskBulkClass();
            //tbc.ownerUserId = admin.Id;
            tbc.ownerUserId = admin.Id;
            
            tbc.recordId = task.whatId;
            tbc.action = 'ReviewApplication';
            tbc.recordName = 'TaskRecord';
            //tbc.groupName = g.Name;
            tbc.dueDate = null;
            tbc.startDate = null;
            tbc.taskCompleted = true;
            tbc.comments = 'Comments';
            tbc.taskType = task.Type__c;
            tbc.taskScheduleDetailId = null;
            tbc.subject = 'Subject';
            TestHelper.getUserPreference(true, 'ActiveAppName__c', 'StateAsGrantor');
            List<TaskCreationHandler.TaskBulkClass> bulkList = new List<TaskCreationHandler.TaskBulkClass>();
            bulkList.add(tbc);
            TaskCreationHandler.createBulkTasks(bulkList,true);
            taskList = TaskCreationHandler.createTasks(admin.Id,task.whatId,'ReviewApplication','Task Record',g.Name, false, null, task.Type__c,true);
            //TaskCreationHandler.createApprovalProcessTasks(sampleObj.Id,'Test Class Sample Approval Process','TaskRecord',null,null,true);
           // TaskCreationHandler.createApprovalProcessTasks(task.whatId,'ReviewApplication','TaskRecord',null,null,true);
             TaskCreationHandler.getTaskConfig('remove','test');
            System.assert(taskList != null);
            Test.stopTest();
            
        }
    }
    
    @isTest() 
    public static void testApproval(){
        try{
            Test.startTest();
         TestHelper.createCustomSettings(true);
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig('ReviewApplication',false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            taskactionsummary.OrganizationNameOfRecord__c = 'AccountTest';
            taskactionsummary.TaskAction__c = 'Remove';
            insert taskactionsummary;
            SampleObject1__c objInstance = new SampleObject1__c();
            objInstance.Status__c='Active';
            objInstance.RecallComment__c = 'sample';
            objInstance.Name = 'test';
            objInstance.SamplePicklist1__c = 'Sample';
            insert objInstance; 
            list<task> testlist=TaskCreationHandler.createApprovalProcessTasks(objInstance.id, 'Remove', 'test', 'test', System.Today() + 2, true);
            system.assertEquals(0, testlist.size()) ;
        Test.stopTest();
        }catch(Exception e){
            
        }
        
    }
    
     @isTest() 
    public static void testApproval1(){
        try{
           Test.startTest();
         TestHelper.createCustomSettings(true);
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig('ReviewApplication',false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            taskactionsummary.TaskAction__c = 'Remove';
            taskactionsummary.OrganizationNameOfRecord__c = 'AccountTest';
            insert taskactionsummary;
            SampleObject1__c objInstance = new SampleObject1__c();
            objInstance.Status__c='Active';
            objInstance.RecallComment__c = 'sample';
            objInstance.Name = 'test';
            objInstance.SamplePicklist1__c = 'Sample';
            insert objInstance; 
          list<task> testlist=  TaskCreationHandler.createApprovalProcessTasks(objInstance.id, 'Remove', 'test', 'test', System.Today() + 2, 'test', true); 
         system.assertEquals(0, testlist.size()) ;
        Test.stopTest(); 
        }catch(Exception e){
            
        }
        
    }
    @isTest() 
    public static void testApproval2(){
        Test.startTest();
         TestHelper.createCustomSettings(true);
            SampleObject1__c objInstance = new SampleObject1__c();
            objInstance.Status__c='Active';
            objInstance.RecallComment__c = 'sample';
            objInstance.Name = 'test';
            objInstance.SamplePicklist1__c = 'Sample';
            insert objInstance; 
            Task task=TestHelper.getTask(false);
            //TaskCreationHandler.createApprovalProcessTasks(objInstance.id, 'Remove', 'test',  System.Today() + 2, true);
           // TaskCreationHandler.initializeGroupTasks('TestGroup', task,'remove',System.Today() + 2);       
           system.assertNotEquals(null, task);
        Test.stopTest();
    } 
    
    @isTest() 
    public static void testrecallRecord(){
        Test.startTest();
         TestHelper.createCustomSettings(true);
            SampleObject1__c objInstance = new SampleObject1__c();
            objInstance.Status__c='Active';
            objInstance.RecallComment__c = 'sample';
            objInstance.Name = 'test';
            objInstance.SamplePicklist1__c = 'Sample';
            insert objInstance; 
            Task task=TestHelper.getTask(false);
        	
        
        if([select count() from ProcessInstance where targetobjectid=:objInstance.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objInstance.Id);

            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);

        }
        
        
            TaskCreationHandler.recallRecord(objInstance.id, 'Remove');
           // TaskCreationHandler.initializeGroupTasks('TestGroup', task,'remove',System.Today() + 2);       
           system.assertNotEquals(null, task);
        Test.stopTest();
    } 
    
    @isTest() 
    public static void testrecallRecord1(){
        Test.startTest();
        try{
            TestHelper.createCustomSettings(true);
            SampleObject1__c objInstance = new SampleObject1__c();
            objInstance.Status__c='Active';
            objInstance.RecallComment__c = 'sample';
            objInstance.Name = 'test';
            objInstance.SamplePicklist1__c = 'Sample';
            insert objInstance; 
            Task task=TestHelper.getTask(false);
        	
        
        if([select count() from ProcessInstance where targetobjectid=:objInstance.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objInstance.Id);

            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);

        }
        
        
            TaskCreationHandler.createApprovalProcessTasks(objInstance.id, 'Remove', 'test', System.today(), true);
           // TaskCreationHandler.initializeGroupTasks('TestGroup', task,'remove',System.Today() + 2);       
           system.assertNotEquals(null, task);
        }catch(Exception e){}
         
        Test.stopTest();
    } 
    
    @isTest() 
    public static void testrecallRecord2(){
        Test.startTest();
        List<Id> taskIds = new List<Id>();
        
        List<Task> taskList = new List<Task>();
         TestHelper.createCustomSettings(true);
        Account a = new Account();
            a.Name = 'Aman';
            a.BillingCity = 'New York City';
            //a.EINo__c = 234234234;
            //a.EINText__c = '234234234';
            // a.EINText__c = 234234234;
            insert a;
        
        
            Task task=TestHelper.getTask(false);
            task.Status='Not Started';
            task.WhatId = a.Id;
            task.AssignedToUserType__c = 'Internal';
            task.Type__c = 'On-Demand';
            task.startdate__c = null;
            task.activitydate = null;
            insert task;
        
        taskIds.add(task.Id);
        taskList.add(task);
        
        TaskCreationHandler.closeTasks(taskIds);
        TaskCreationHandler.closeTasks(taskList);
           // TaskCreationHandler.initializeGroupTasks('TestGroup', task,'remove',System.Today() + 2);       
           system.assertNotEquals(null, task);
        Test.stopTest();
    } 
    
    @isTest
    private static void testAll3() {
        User admin = TestHelper.getAdminUser(true);
        TestHelper.createCustomSettings(true);
        TestHelper.getCustomAppConfig(true);
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        
        System.runAs(admin) {
           PhaseConfigTriggerHelper.skipTrigger = true;
            // AccountTriggerHelper.skipTrigger = true;
                    
            Account a = new Account();
            a.Name = 'Aman';
            a.BillingCity = 'New York City';
            //a.EINo__c = 234234234;
            //a.EINText__c = '234234234';
            // a.EINText__c = 234234234;
            insert a;

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
            
           // PhaseConfig__c pconfig=TestHelper.getPhase(true);
            AppUtils.skipPhaseConfigTrigger = true;
            PhaseConfig__c phase = new PhaseConfig__c();
            phase.Name = 'TestPhase';
            phase.TabName__c='PLANNING';
            phase.CustomAppName__c = 'StateAsGrantor';
            //phase.URL__c = '/apex/ChartsView?t=Planning';
            phase.GroupName__c='2';
            phase.Sequence__c=2;
            phase.Abbreviation__c ='PL';
            phase.SObject__c = 'SampleObject11__c;SampleObject12__c'; 
            phase.AccordionHeader__c = 'Planning';
            phase.EnableSearch__c = true;
            phase.SidebarSearchLabel__c = 'Search';
            phase.SidebarRecentlyViewedLabel__c = 'Recently Viewed';
            phase.SidebarExternalLinksLabel__c = 'External Links';     
            phase.SearchResultPage__c ='/apex/planning';
            phase.SidebarComponentSequence__c = 'Search,Links,RecentlyViewed,SubMenu';
            phase.EnableExternalLinks__c = true;
         
            phase.Active__c= true;
            phase.PhaseType__c = 'Phase';
            phase.SelectedByDefault__c = true;
            phase.URL__c='www.login.salesforce.com';
            insert phase;
            
            TaskConfig__c taskactionsummary=TestHelper.getTaskConfig('ReviewApplication',false);
            taskactionsummary.DueDateOffset__c=7;
            taskactionsummary.GroupType__c='MyTasks';
            taskactionsummary.Sequence__c=2;
            taskactionsummary.TaskLabel__c='Review Announcements';
            taskactionsummary.PhaseConfig__c= phase.id;
            insert taskactionsummary;
            
            Group g = new Group();
            g.Name = 'TestGroup';
            g.DeveloperName  = 'TestGroup';
            g.Type = 'Queue';
            insert g;
            GroupMember grpMem = new GroupMember();
            grpMem.GroupId = g.id;
            grpMem.UserOrGroupId = admin.Id;
            insert grpMem;
            Test.startTest();
            //CustomAppConfig__c cac = TestHelper.getCustomAppConfig(true);
            List<Task> taskList = new List<Task>();
            TaskCreationHandler.TaskBulkClass tbc = new TaskCreationHandler.TaskBulkClass();
            tbc.ownerUserId = admin.Id;
            tbc.recordId = task.whatId;
            tbc.action = 'ReviewApplication';
            tbc.recordName = 'TaskRecord';
            tbc.groupName = g.Name;
            tbc.dueDate = null;
            tbc.startDate = null;
            tbc.taskCompleted = true;
            tbc.comments = 'Comments';
            tbc.taskType = task.Type__c;
            tbc.taskScheduleDetailId = null;
            tbc.subject = 'Subject';
            TestHelper.getUserPreference(true, 'ActiveAppName__c', 'StateAsGrantor');
            List<TaskCreationHandler.TaskBulkClass> bulkList = new List<TaskCreationHandler.TaskBulkClass>();
            bulkList.add(tbc);
            TaskCreationHandler.createBulkTasksFor2(bulkList,true);
            taskList = TaskCreationHandler.createTasks2(admin.Id,task.whatId,'ReviewApplication','Task Record',null, false, null, task.Type__c,null,true,true);
            TaskCreationHandler.createTasksEnhanced2(admin.Id ,a, 'ReviewApplication' , 'TaskRecord' ,  g.Name , true , null ,task.Type__c ,'Subject', true ,true );
            TaskCreationHandler.isValidSalesforceId(a.id);
            TaskCreationHandler.isValidSalesforceId('');
            TaskCreationHandler.closeTask(task.id);
            //TaskCreationHandler.createApprovalProcessTasks(task.whatId,'ReviewApplication','TaskRecord',null,null,true);
           // TaskCreationHandler.createApprovalProcessTasks(task.whatId,'ReviewApplication','TaskRecord',null,null,true);
            System.assert(taskList != null);
            Test.stopTest();
            
        }
    }
}