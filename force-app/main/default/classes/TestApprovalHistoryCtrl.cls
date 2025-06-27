/**
Test class for ApprovalHistoryCtrl
**********************************************************
Audit History
**********************************************************
3/4/2019      Sonali Bajirao Jadhav            Created
**********************************************************  
*/
@isTest
private with sharing class TestApprovalHistoryCtrl {
    public static SampleObject1__c objInstance;
    public static void setUp(){
            String nameSpaceprefix  = AppUtils.getNamespacePrefix();
            objInstance = new SampleObject1__c();
            objInstance.Name='test';
            objInstance.Status__c = 'Active';
            objInstance.SamplePicklist1__c = 'Sample';
            insert objInstance;
            
            TaskConfig__c taskConfig= testhelper.getTaskConfig('Program Approve Task',true);
            TaskCreationHandler.createApprovalProcessTasks(objInstance.id,'Program Approve Task', 'test', 'test', System.Today() + 2, true);
            Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
            System.currentPageReference().getParameters().put('id', objInstance.id);
            
        
    }
    @IsTest
    private static void testApprovalHistoryCtrl() {
        User manager = testHelper.getAdminUser(true);
        User u = TestHelper.getAdminUser(false);
        u.Manager = manager;
        insert u;
        System.runAs(u) {
            setUp();
            Test.startTest();
            ApprovalHistoryCtrl ApprovalHistoryCtrlOnj= new ApprovalHistoryCtrl(objInstance.id);
            ApprovalHistoryCtrl.fetchApprovalHistory(objInstance.id);
            system.assertEquals('test', objInstance.Name);
            
            ApprovalHistoryCtrl.ApprovalStepWrapper wrap=new ApprovalHistoryCtrl.ApprovalStepWrapper();
            system.assertEquals(null,+wrap.stepStatus);
            Test.stopTest();            
        }
    }

    @isTest
    static void testgetApprovalHistoryWrapper(){
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
        
        ApprovalHistoryCtrl.ApprovalWrapper ApprovalHistoryWrapper = new ApprovalHistoryCtrl.ApprovalWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label,IsKeyAvailable,KeyValueMapRequired,AlternateFieldLabel,parentObjectName,parentObjectType,parentObjectClassName,IsfieldKeyMapAvailable,IsfieldDataMapAvailable,IsRequiredfield,'');
        Test.stopTest();
        System.assertNotEquals(sObjectList,null);        
    }
}