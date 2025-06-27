/*
This class has methods to create charts according to object name.
**********************************************************
Audit History
**********************************************************
2018-10-29  Sonali Bajirao Jadhav     Modified
**********************************************************  
*/
@isTest
private with sharing class TestStepProgressbarCtrl {
    public static StepProgressbarHeader__c pbHeader;
    public static StepProgressbarDetail__c pbDetail;
    public static SampleObject11__c samObj;
    public static String sObjectName;
    public static Map<String, Object> result_1;
    public static Map<String, Object> result_2;
    public static Map<String, Object> result_3;
    public static Map<String, Object> result_4;
    
    private static void setup(){   
        samObj = TestHelper.getSampleObject1(true);
        System.assert(samObj.id !=NULL, 'The Test Sample Object11 did not insert properly, please check validation rules and other mechanisms');
        sObjectName = samObj.Id.getSObjectType().getDescribe().getName();
        //sObjectName = recordId.getSObjectType().getDescribe().getName();
        //sObjectName = AppUtils.removeNamespacePrefix(sObjectName);       
        pbHeader = new StepProgressbarHeader__c();
        pbHeader.GroupName__c = 'Test Group';
        pbHeader.sObjectName__c = sObjectName ;
        pbHeader.DecisionFieldAPIName__c = AppUtils.applyNamespacePrefix('Status__c');
        pbHeader.RenderforApp__c = 'Grantor';
        //pbHeader.RenderforUser__c = 'Internal';  
        pbHeader.IncompleteColor__c ='';
        pbHeader.RejectColor__c  ='';
        pbHeader.CompleteColor__c  ='';
        insert pbHeader;
        System.assert(pbHeader.id !=NULL, 'The Test Step Progressbar Header did not insert properly, please check validation rules and other mechanisms');
        
        pbDetail = new StepProgressbarDetail__c();
        pbDetail.Name = 'Test';
        pbDetail.Sequence__c = 1;
        pbDetail.PicklistValue__c = 'In Progress';
        pbDetail.ProgressbarHeaderConfig__c = pbHeader.Id; 
        pbDetail.isCreated__c=true;
        pbDetail.HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"id"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"null","Values":[]}}],"Groups":[]}';
        insert pbDetail; 
        System.assert(pbDetail.id !=NULL, 'The Test Step Progressbar Detail did not insert properly, please check validation rules and other mechanisms');
    }
    
    @isTest
    public  static void testProgressbar(){
        User u = TestHelper.getAdminUser(false);
        u.Enable508Compliance__c=true;
        insert u;
        System.runAs(u){
            setup();
            TestHelper.createCustomSettings_1(true);
            Test.startTest();
            UserPreferenceHelper.setBooleanValue('IsApplicant__c', true);
            UserPreferenceHelper.setBooleanValue('IsReviewer__c', true);
            UserPreferenceHelper.setBooleanValue('IsInternal__c', true);
            StepProgressbarCtrl ctrl = new StepProgressbarCtrl();
            result_1 = StepProgressbarCtrl.fetchorderedList(sObjectName, pbHeader.GroupName__c, samObj.Id);
            result_3 = StepProgressbarCtrl.fetchorderedListLwc(sObjectName, pbHeader.GroupName__c, samObj.Id);
            pbHeader.RenderforApp__c = 'Grantee';
            update pbHeader; 
            result_2 = StepProgressbarCtrl.fetchorderedList(sObjectName, pbHeader.GroupName__c, samObj.Id);
            result_4 = StepProgressbarCtrl.fetchorderedListLwc(sObjectName, pbHeader.GroupName__c, samObj.Id);
            Test.stopTest();
        }
        System.assertNotEquals(result_1,null); 
        System.assertNotEquals(result_2,null);
        
    }
}