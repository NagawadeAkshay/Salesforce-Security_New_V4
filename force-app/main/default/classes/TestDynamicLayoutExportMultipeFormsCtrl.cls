/*
Created By: Amol Darekar
Created date: 27th Aug 2018
Purpose: Test class to cover TestDynamicLayoutExportCtrl.
*/
@isTest
private with sharing class TestDynamicLayoutExportMultipeFormsCtrl {

 /*@isTest
 public static void saveFormPDFTest() {
  User u = TestHelper.getAdminUser(true);
  System.runAs(u) {
   
   //Create page layout for object SampleObject12__c
   PageLayoutConfig__c pageLayoutConfigObj = TestHelper.getPageLayoutConfig(false, AppUtils.getNamespacePrefix() + 'SampleObject12__c');
   pageLayoutConfigObj.RecordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Layout').getRecordTypeId();
   pageLayoutConfigObj.Name = 'Test View Layout';
   insert pageLayoutConfigObj;
   System.assertNotEquals(pageLayoutConfigObj.Id,null);
  
   
   //PageTemplate__c templateObj = TestHelper.getPageTemplateConfig(true);
   DataTableConfig__c dataTableObj = TestHelper.getDataTableConfig(true);

   TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayoutConfigObj.Id, true);
   
   PageBlockConfig__c pageBlockConfig = TestHelper.getPageBlockConfig(tabConfig.Id, false);
   
   Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Forms').getRecordTypeId();
   pageBlockConfig.RecordTypeId = recTypeId;
   insert pageBlockConfig;
   
   System.assertNotEquals(pageBlockConfig.Id,null);

   PageTemplate__c pageTemplateObj = TestHelper.getPageTemplateConfig(true, pageLayoutConfigObj.Id);
   Package__c packageObj = TestHelper.getPackage(true, pageTemplateObj);

   PackageFormConfig__c packageFormConfig = new PackageFormConfig__c();
   packageFormConfig.PackageConfig__c = packageObj.Id;
   packageFormConfig.Order__c = 1;
   packageFormConfig.FormConfig__c = pageTemplateObj.Id;
   insert packageFormConfig;
   
   String formId =pageTemplateObj.Id;
   
   //Insert sample object
   SampleObject11__c sampleObj = TestHelper.getSampleObject1(true); 

   FormInstance__c formInstance = new FormInstance__c();
   formInstance.PackageBusinessForm__c = packageFormConfig.id;
   formInstance.FormId__c = formId;
   formInstance.ParentRecordId__c = sampleObj.id;
   insert formInstance;

   pageTemplateObj.ExportPageName__c = 'Test View Form';
   Update pageTemplateObj;
   
   PageDataHolder__c pageDataHolder = new PageDataHolder__c(Name = 'Test PDF Record');//flexTableParamMap.get('parentId')
   insert pageDataHolder;
   
   Attachment attachmentObj = new Attachment();
   attachmentObj.Name = 'New Attachment';
   attachmentObj.Body = Blob.valueOf('Test');
   attachmentObj.Description = 'Description';
   attachmentObj.ParentId = sampleObj .Id;
   insert attachmentObj;
   
   
   Map<String, Object> objectMap = new Map<String, Object>();
   objectMap.put('PageDataHolderId',pageDataHolder.id);
   objectMap.put('AttachmentIdList',attachment.id);

   Test.startTest();
   ApexPages.CurrentPage().getParameters().put('recordId', sampleObj.id);
   ApexPages.CurrentPage().getParameters().put('packageId', packageObj.id);
   ApexPages.CurrentPage().getParameters().put('viewTemplateName', pageTemplateObj.name);
   ApexPages.CurrentPage().getParameters().put('flexTableParam', dataTableObj.id);
   DynamicLayoutExportMultipleFormsCtrl ctrl = NEW DynamicLayoutExportMultipleFormsCtrl();
   DynamicLayoutExportMultipleFormsCtrl.deleteData();
   DynamicLayoutExportMultipleFormsCtrl.getData();
   DynamicLayoutExportMultipleFormsCtrl.getMergedItextPDF(objectMap);
   
   system.assert(ctrl != null);
   Test.stopTest();

  }
 }*/
}