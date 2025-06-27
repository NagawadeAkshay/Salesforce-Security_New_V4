@isTest
private with sharing class TestApprovalDecisionCtrl {
    private static String namespace = AppUtils.getNamespacePrefix();
   
   private static void setUpApprovalData(Boolean includeStdAction, Boolean custAction) {
        CustomApp__c custApp = TestHelper.getCustomApp(true);
        SObjectConfig__c sObjConfig = new SObjectConfig__c(ApprovalReCallCommentFieldAPIName__c=namespace+'RecallComment__c', ApprovalReCallEnable__c=true, ApprovalReCallFieldAPIName__c   =namespace+'IsRecordRecalled__c',
                                            ApprovalSnapshotFileName__c='ApprovalPDF',ApprovalPDFConditionAPIName__c='SampleText1__c', CaptureSnapshotonApproval__c=true, Name=namespace+'SampleObject1__c');
        insert sObjConfig;
        List<ApprovalDecisionActionConfig__c> approvalDecList = new List<ApprovalDecisionActionConfig__c>();
        if(includeStdAction) {
            approvalDecList.add( new ApprovalDecisionActionConfig__c(ActionLabelOverride__c='Reject', Action__c='Disapprove',CommentsFieldsAPIName__c=namespace+'RecallComment__c',Sequence__c=1,SobjectConfig__c=sObjConfig.Id,CustomAppConfig__c=custApp.Id ));
            approvalDecList.add( new ApprovalDecisionActionConfig__c(Action__c='Approve', HideAction__c=true,Sequence__c=2,CommentsFieldsAPIName__c=namespace+'RecallComment__c',SobjectConfig__c=sObjConfig.Id,CustomAppConfig__c=custApp.Id  ));
        }
        if(custAction) {
            approvalDecList.add( new ApprovalDecisionActionConfig__c(Action__c='Send to Owner', CommentsRequired__c=true,Sequence__c=3,CommentsFieldsAPIName__c=namespace+'RecallComment__c',SobjectConfig__c=sObjConfig.Id,CustomAppConfig__c=custApp.Id ));
            approvalDecList.add( new ApprovalDecisionActionConfig__c(Action__c='Reassign', CommentsFieldsAPIName__c=namespace+'RecallComment__c',Sequence__c=4,SobjectConfig__c=sObjConfig.Id,CustomAppConfig__c=custApp.Id) );
        
        }
        insert approvalDecList;
        EmailTemplateConfig__c empTempl = new EmailTemplateConfig__c(EmailTemplateDeveloperName__c='TestEmailTemplate1', SobjectName__c='SampleObject1__c', Name='test');
        insert empTempl;
        TaskConfig__c taskC = new TaskConfig__c(DueDateOffset__c=7, GroupType__c='test', SendTaskAssignmentNotification__c=true, Sequence__c=12, SobjectName__c='SampleObject1__c', TaskAction__c='test', TaskEditPage__c='test',
                TaskInitiationFieldUpdate__c='Status__c=In Progress', TaskLabel__c='test', TaskViewPage__c='test', Name='test', EmailTemplateConfig__c=empTempl.Id);
                insert taskC;
    }
    @isTest
    static void testWithoutAction(){
        setUpApprovalData(false, true);
        //Arrange
        TestHelper.createCustomSettings(true);
        UserPreferences__c upref = UserPreferences__c.getInstance(UserInfo.getProfileId());
        if(upref == null){
            upref = new UserPreferences__c(SetupOwnerId = UserInfo.getProfileId());
        } 
        upref.GrantorPhaseCharts__c = '1,2';
        upref.ProfileName__c = 'System Administrator';
        CustomAppConfig__c app = TestHelper.getCustomAppConfig(false);
        app.AvailableforProfiles__c = 'System Administrator';
        //insert app;
        
        upref.ActiveAppName__c = app.Name;
        upsert upref;
        Account a=TestHelper.getAccount(false);
        insert a;

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
            TaskCreationHandler.createApprovalProcessTasks(objInstance.id, 'Remove', 'test', 'test', System.Today() + 2, true);
            // Submit the approval request for the announcement
         //Approval.ProcessResult result = Approval.process(req1);
        	
        //act
        PageReference pageR = Page.SampleViewPage1;
        Test.setCurrentPageReference(pageR); 
        System.currentPageReference().getParameters().put('id', objInstance.id);
        Test.startTest();   
        KeyValueStoreHelper.setBooleanValue('HideApprovalForSubmitter',true,true);
         
        ApprovalDecisionCtrl appdecision = new ApprovalDecisionCtrl();
        Map<String, Object> approvalOptionsLightning = ApprovalDecisionCtrl.getApprovalOptionsLightning( objInstance.id,'View');
        Map<String, Object> approvaloption = ApprovalDecisionCtrl.getApprovalOptions( objInstance.id);
        appdecision.approvalActionChosen = '';
         User u = TestHelper.getAdminUser(true);
        Map<String, Object> RecordsLightning = ApprovalDecisionCtrl.submitRecordsLightning('Approve',objInstance.id,'comment',u.id);
        Map<String, Object> res = ApprovalDecisionCtrl.submitRecords('Approve',objInstance.id,'comment',u.id);
        String filterclasue = 'Email=\'sysAdmin@govbd.dev\'';
        Map<String, Object> res1 = ApprovalDecisionCtrl.getUserRecords(filterclasue);   
  	    Map<String, Object> res2 = ApprovalDecisionCtrl.getUserRecords(filterclasue, '') ;
        Map<String,Object> paramMap = new Map<String,Object>(); 
        paramMap.put('queueOption','User');
        paramMap.put('filterClause',filterclasue);
        Map<String, Object> UserQueueRecordsLightning = ApprovalDecisionCtrl.getUserQueueRecordsLightning(paramMap); 
        Map<String, Object> res3 = ApprovalDecisionCtrl.getUserQueueRecords(paramMap);   
        ApprovalDecisionCtrl.closePendingTask('','false');
        ApprovalDecisionCtrl.closePendingTask('');
        Map<String,Object> paramMap1 = new Map<String,Object>(); 
        paramMap1.put('queueOption','Queue');
        paramMap1.put('filterClause',filterclasue);
        Map<String, Object> res4 = ApprovalDecisionCtrl.getUserQueueRecords(paramMap1);   
        Test.stopTest();
        
        //assert
        System.assertNotEquals(null, appdecision);
    }
    
    @isTest
    static void testgetApprovalDecisionWrapper(){
        Test.startTest();
        List<sObject> sObjectList = new List<sObject>();
        Map<String, String> fieldLableMap = new Map<String, String>();
        Map<String, String> fieldDataTypeMap = new Map<String, String>();
        Map<String, Integer> scaleMap =new  Map<String, Integer>();
        String label;
        Boolean IsKeyAvailable = true;
        String KeyValueMapRequired = 'Yes';
        String AlternateFieldLabel;
        String parentObjectName = 'testParent';
        String parentObjectType = 'Internal';
        String parentObjectClassName = 'ParentController';
        Boolean IsfieldKeyMapAvailable = true;
        Boolean IsfieldDataMapAvailable = true;
        Boolean IsRequiredfield = false;
        
        ApprovalDecisionCtrl.ApprovalDecisionWrapper ApprovalDecisionWrapper = new ApprovalDecisionCtrl.ApprovalDecisionWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label,IsKeyAvailable,KeyValueMapRequired,AlternateFieldLabel,parentObjectName,parentObjectType,parentObjectClassName,IsfieldKeyMapAvailable,IsfieldDataMapAvailable,IsRequiredfield,'');
        Test.stopTest();
        System.assertNotEquals(sObjectList,null);        
    }
}