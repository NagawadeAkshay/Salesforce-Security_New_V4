@isTest
private with sharing class DynamicLayoutExportMultipleFormsCtrlTest {
     public static String serializeStr;
     public static String serializeStr2;
     public static Map<String,object> listParm;
     public static List<String> formTypes = new List<String>();
     public static SampleObject11__c announcement;
     public static Map<String,String> mapParams;
     public static Map<String, Object> objectParamMap;
     public static Package__c packageObj;
     public static PageTemplate__c pageTemplateObj;
     public static DataTableConfig__c dataTableObj;
     public static PageDataHolder__c pageDataHolder;
   //  public static Map<String,object> flexTableParam;
    public static Map<String, Object> urlParamMap;
       
    public static void setup(){
            TestHelper.getNameTemplateConfigAnnouncement(true);
            announcement = TestHelper.getSampleObject1(false);
            announcement.Name='test';
            insert announcement;
        
            listParm = new Map<String, Object>();
            listParm.put('rer', 'dfd');
            serializeStr = JSON.serialize(listParm);
        
            PageLayoutConfig__c pageLayoutConfigObj = TestHelper.getPageLayoutConfig(false, AppUtils.getNamespacePrefix() + 'SampleObject12__c');
            pageLayoutConfigObj.RecordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Layout').getRecordTypeId();
            pageLayoutConfigObj.Name = 'Test View Layout';
            insert pageLayoutConfigObj;
            
            mapParams = new Map<String, String>();
            mapParams.put('parentId',announcement.Id);
        
            pageDataHolder   = new PageDataHolder__c(Name = 'Test PDF Record');
            insert pageDataHolder;
            
            Attachment attachmentObj = new Attachment();
            attachmentObj.Name = 'MergedFile.pdf';
            attachmentObj.Body = Blob.valueOf('Test');
            attachmentObj.Description = 'Description';
            attachmentObj.ParentId = announcement.Id;
            insert attachmentObj;

            objectParamMap = new Map<String, Object>();
            objectParamMap.put('PageDataHolderId',pageDataHolder.id);
            objectParamMap.put('AttachmentIdList',attachment.id);
   
            pageTemplateObj = TestHelper.getPageTemplateConfig(true, pageLayoutConfigObj.Id);
            packageObj = TestHelper.getPackage(true, pageTemplateObj);
            dataTableObj = TestHelper.getDataTableConfig(true);
        
             urlParamMap=new Map<String, Object>();
             urlParamMap.put('PageDataHolderId',pageDataHolder.id);
       
    }
 
    @isTest
    public static void testConstructor(){
        
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {            
            setup();
            Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
            ApexPages.CurrentPage().getParameters().put('id', announcement.id);
            ApexPages.CurrentPage().getParameters().put('packageId',packageObj.Id);
            ApexPages.CurrentPage().getParameters().put('viewTemplateName', pageTemplateObj.name);
            ApexPages.CurrentPage().getParameters().put('flexTableParam',JSON.serialize(urlParamMap));
            ApexPages.CurrentPage().getParameters().put('listParm', serializeStr);
            ApexPages.currentPage().getParameters().put('formTypes', JSON.serialize(new List<String>{'Test'}));
           
           
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TestMergedItextPDf());
            DynamicLayoutExportMultipleFormsCtrl ctrl = new DynamicLayoutExportMultipleFormsCtrl();
            ApexPages.currentPage().getParameters().put('formTypes', JSON.serialize(new List<String>()));
            DynamicLayoutExportMultipleFormsCtrl ctrl1 = new DynamicLayoutExportMultipleFormsCtrl();
            //DynamicLayoutExportMultipleFormsCtrl.getMergedItextPDF(objectParamMap);
            DynamicLayoutExportMultipleFormsCtrl.getPlaceHolder(pageDataHolder.Name);
            DynamicLayoutExportMultipleFormsCtrl.pollForAttachment(mapParams);
            System.assertNotEquals(null, ctrl);
            dataTableObj.AdditionalColumns__c = 'EnableTotalRecordsCount__c';
            update dataTableObj;
            delete dataTableObj;
            Test.stopTest();
        }
    }
    
    public class TestMergedItextPDf implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(req.getBody());
            res.setStatusCode(200);            
            return res;
        }
}
}