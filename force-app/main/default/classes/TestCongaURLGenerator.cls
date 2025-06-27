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
private class TestCongaURLGenerator {
	// public static PageLayoutConfig__c pagLayCon = new PageLayoutConfig__c();
	// public static PageLayoutActionConfig__c pagLayActCon =new PageLayoutActionConfig__c();
	// public static SampleObject11__c samObj11 = new SampleObject11__c();
	// public static SampleObject12__c samObj12 = new SampleObject12__c();
	// private static void setup(){
    //     // TO DO: implement unit test
	// 	pagLayCon = TestHelper.getPageLayoutConfig(true);
	// 	pagLayActCon = TestHelper.getPageLayoutActionConfig(false,pagLayCon.Id);
	// 	pagLayActCon.CongaTemplateName__c = 'test';
	// 	pagLayActCon.CongaDownloadType__c = 'Download to Salesforce';
	// 	insert pagLayActCon;
	// 	samObj11 = TestHelper.getSampleObject1(true);
	// 	samObj12 = TestHelper.getSampleObject2(true,samObj11.id);
    // }
    // @IsTest
    // public static void test_1(){
    // 	setup();
    // 	CongaURLGenerator ctrl = new CongaURLGenerator(samObj12.id,pagLayActCon.id);
    // 	ctrl.generateURL();
    // 	System.assertNotEquals(ctrl,null);
    // }
}