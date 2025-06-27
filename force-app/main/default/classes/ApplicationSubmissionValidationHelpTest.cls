/**
* @Class Name: testApplicationSubmissionValidationHelp
* @Description: This class is test class for ApplicationSubmissionValidationHelper
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       | 11 June 2020  | Framework Team                      | Initial
* ====================================================================================================================
**/
@isTest
private class ApplicationSubmissionValidationHelpTest {
    @IsTest
    public static void testvalidateApplication(){
        DynamicLayoutHolder layoutHolder;
        PageLayoutConfig__c pageLay;
        SampleObject12__c Sample_2;
        SampleObject11__c Sample_1;
        AttachmentExtension__c attachx;
        PageAttachmentConfig__c pc ;
    
        Sample_1 = TestHelper.getSampleObject1(true);
        Id recordtypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Standalone').getRecordTypeId();
        Sample_2 = TestHelper.getSampleObject2(false,Sample_1.Id);
        Sample_2.FormsValidated__c=true;
        insert Sample_2;
        
        pageLay = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pageLay.Id, true);
        PageBlockConfig__c pbc = TestHelper.getPageBlockConfig(tab.Id, true);
        
        PageBlockDetailConfig__c pbdc = TestHelper.getPageBlockDetailConfig(pbc.id,false);
        pbdc.FieldAPIName__c = AppUtils.getNamespacePrefix() + 'SampleTextArea1__c';
        pbdc.AllowedWordsForRichTextArea__c = 200;
        pbdc.IsHiddenField__c = false;
        pbdc.IsRichTextArea__c = true;
        pbdc.RequiredBehavior__c = 'Required for Submit';
        pbdc.IsActive__c = true;
        pbdc.RequiredForSubmitByRole__c='CEO';
        //pbdc.HideDecisionField__c = AppUtils.getNamespacePrefix() +'FormsValidated__c';
        insert pbdc;    
        
        PageBlockDetailConfig__c pbdc1 = TestHelper.getPageBlockDetailConfig(pbc.id,false);
        pbdc1.FieldAPIName__c = AppUtils.getNamespacePrefix() + 'FormsValidated__c';
        pbdc1.IsHiddenField__c = false;
        pbdc1.RequiredBehavior__c = 'Required for Submit';
        pbdc1.IsActive__c = true;
        pbdc1.HideDecisionField__c=AppUtils.getNamespacePrefix() +'FormsValidated__c';
        insert pbdc1;
       
        layoutHolder = new DynamicLayoutHolder(pageLay.Id,Sample_2.Id,true);
        String sObjectName = AppUtils.getNamespacePrefix()+'PageLayoutConfig__c';
        Schema.SObjectType t  = Schema.getGlobalDescribe().get(sObjectName);
        SObject s = t.newSObject();
        s.put('RecordTypeId', Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosByName().get('Standalone').getRecordTypeId());
        ApplicationSubmissionValidationHelper.sobj=s;
        ApplicationSubmissionValidationHelper.editRecordTypeId = recordtypeId;

        Test.startTest();
        Boolean result_1 = ApplicationSubmissionValidationHelper.validateApplication(layoutHolder,Sample_2.Id);
        System.assertNotEquals(result_1, false);
        Boolean result_2 = ApplicationSubmissionValidationHelper.validateApplicationsRTAWordCount(layoutHolder);
        System.assertNotEquals(result_2, false);
        Boolean result_3 = ApplicationSubmissionValidationHelper.isEnableSubmit(pageLay.Id,AppUtils.getNamespacePrefix()+'SampleObject12__c',Sample_2.id,false,true);
        System.assertNotEquals(result_3, false);
        Boolean result_4 = ApplicationSubmissionValidationHelper.isTextAreaCharCountExceeded(layoutHolder);
        System.assertNotEquals(result_4, true);
        Test.stopTest();        
    }    
}