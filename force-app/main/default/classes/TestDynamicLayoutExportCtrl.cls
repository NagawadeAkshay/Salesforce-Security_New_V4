/**
* @Class Name: TestDynamicLayoutExportCtrl
* @Description: This class is test class for DynamicLayoutExportCtrl
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |15/03/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/
@isTest

private with sharing class TestDynamicLayoutExportCtrl{
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testConstructor
* @Description: This method is used to test DynamicLayoutExportCtrl
* @Param: NA
* @Return: NA
* @Date: 15/03/2019
**/ 
    @isTest
    public static void testConstructor(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            TestHelper.createCustomSettings(true);
            TestHelper.createTestDocument(true,'PDFTopLeftImageDocName');
            TestHelper.createTestDocument(true,'PDFTopMiddleImageDocName');
            TestHelper.createTestDocument(true,'PDFTopRightImageDocName');
            TestHelper.createTestDocument(true,'PDFBottomRightImageDocName');
            TestHelper.createTestDocument(true,'PDFBottomLeftImageDocName');
            TestHelper.createTestDocument(true,'GovGrantsThemeToPrint');
            TestHelper.createTestDocument(true,'PDFBottomMiddleImageDocName');
            TestHelper.createTestDocument(true,'templateFileName');
            List< document > documentList = [select Name from document];
            TestHelper.getNameTemplateConfigAnnouncement(true);
            SampleObject11__c announcement = TestHelper.getSampleObject1(false);
            announcement.Name='test';
            insert announcement;
            
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            
            
            Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
            ApexPages.CurrentPage().getParameters().put('id', announcement.id);
            ApexPages.CurrentPage().getParameters().put('viewTemplateName', template.name);
            ApexPages.CurrentPage().getParameters().put('flexTableParam', '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Name"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject11__c"}');
            
            Test.startTest();
            DynamicLayoutExportCtrl ctrl = NEW DynamicLayoutExportCtrl();
            ctrl.redirect();
            system.assertEquals(null, ctrl.redirect());
            Test.stopTest();
        }
    }
    
}