/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private with sharing class TestCongaInvokerCtrl {
    // public static SampleObject12__c samObj_2;
 	// public static SampleObject11__c samObj_1;
	// @testSetup
	// public static void allTheDataForThisTestClass() {
	
	// //	Testhelper.getPageLayoutConfig(true);
	// 	PageLayoutConfig__c p1 = Testhelper.getPageLayoutConfig(true);
	//     PageLayoutActionConfig__c objPageLayoutActionConfig = new PageLayoutActionConfig__c();
	// 	objPageLayoutActionConfig.CongaTemplateName__c = 'Test template';
	// 	objPageLayoutActionConfig.CongaAttachmentParent__c = 'SampleNumber1__c';
	// 	objPageLayoutActionConfig.CongaFileName__c = 'Test conga file name';
	// 	objPageLayoutActionConfig.CongaDownloadType__c = '	Download to Salesforce';
	// 	objPageLayoutActionConfig.PageLayoutConfig__c = p1.id;
	// 	insert objPageLayoutActionConfig;
		
	// }
 	// @IsTest
    // public static void test_1() {
    //     PageLayoutActionConfig__c objlayoutactionconfig = [select id from PageLayoutActionConfig__c 
    //                                            where CongaTemplateName__c = 'Test template'];
      
    //    	samObj_1 = TestHelper.getSampleObject1(true);
	// 	samObj_2 = TestHelper.getSampleObject2(true,samObj_1.id);	
		
    //    	CongaURLGenerator objCongaURLGenerator = new CongaURLGenerator(samObj_2.id,objlayoutactionconfig.id);
    //     objCongaURLGenerator.masterRecord = samObj_2;
    //     objCongaURLGenerator.documentName = 'Test doc';
    //     Blob b = Blob.valueOf('Test Data');  
    //     Attachment attachment = new Attachment();  
    //     attachment.ParentId = samObj_2.id;  
    //     attachment.Name = 'Test doc';  
    //     attachment.Body = b;  
    //     insert attachment;  
                                               
    //    	ApexPages.currentPage().getParameters().put('recordId',samObj_2.id);
    //    	ApexPages.currentPage().getParameters().put('buttonId',objlayoutactionconfig.id);
    // 	Test.startTest();
    // 	CongaInvokerCtrl ctrl = new CongaInvokerCtrl();
    	
    // 	ctrl.redirect();
    // 	//Pagereference result1=ctrl.redirect();
    // 	Test.stopTest();
    // 	System.assertNotEquals(ctrl,null);
    	  
    // }
}