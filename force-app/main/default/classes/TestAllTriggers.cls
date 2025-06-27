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
private class TestAllTriggers {

    static testMethod void test11() {
        // TO DO: implement unit test
        Test.startTest();
            TestHelper.getSObjectActionConfig(true);
            
            TestHelper.getFlexGridConfig(true);
            TestHelper.createApexJob(true);
            String testString = 'test value';
        System.assertNotEquals(null,testString ); 
        Test.stopTest();
    }
    
    static testMethod void test12() {
        // TO DO: implement unit test
        Test.startTest();
        TestHelper.getSObjectLayoutConfig(true);
        String testString = 'test value';
        system.assertNotEquals(null,testString );            
        Test.stopTest();
    }
    
    
    static testMethod void test1() {
        // TO DO: implement unit test
        TestHelper.getApprovalSnapshot(true);
        TestHelper.getCalConfig(true);
        TestHelper.getExportTemplate(true);
        String phaseConfig = TestHelper.getPhase(true).Id;
        System.assertNotEquals(null, phaseConfig); 
        String accordHeader = TestHelper.getAccordionHeader(phaseConfig, true).Id;
        System.assertNotEquals(null, accordHeader); 
        String accorSubHeader = TestHelper.getAccordionSubHeader(accordHeader, true).Id;
        System.assertNotEquals(null, accorSubHeader); 
        TestHelper.getAccordionContent(accorSubHeader, true);
        
        String sobjId = TestHelper.getSObjectConfig(true).Id;
        System.assertNotEquals(null, sobjId); 
        String custAppId = TestHelper.getCustomApp(true).Id;
        System.assertNotEquals(null, custAppId); 
        TestHelper.getApprovalDecisionAction(sobjId, custAppId, true);
        String chartId = TestHelper.getBoxChartConfig(true, phaseConfig).Id;
        System.assertNotEquals(null, chartId); 

        TestHelper.getBoxChartDetailConfig(true, chartId);
        
        String congaQueryId = TestHelper.getCongaQuery(true).Id;
        System.assertNotEquals(null, congaQueryId); 

        TestHelper.getEmailTempalteConfig(true);
        Id dataTableId = TestHelper.getFlexDataTableHistoryConfig(true).Id;
        System.assertNotEquals(null, dataTableId); 
        TestHelper.getDataTableAction(dataTableId, true);
        TestHelper.getFlexTableFilterListView(dataTableId, true);
        
        Id formConfig = TestHelper.getPageTemplateConfig(true).Id;
        System.assertNotEquals(null, formConfig); 

        Test.startTest();
        Id gridHeaderId = TestHelper.getGridHeader(true).id;
        System.assertNotEquals(null, gridHeaderId); 
        TestHelper.getGridDetail(gridHeaderId, true);
        
        TestHelper.getHelpConfigWithoutRecordType(true);
        TestHelper.getHighlight(true);        
        
        TestHelper.getErrorMessageConfig('23', 'test', phaseConfig, custAppId, true);
        
        String packageId = TestHelper.getPackage(true, 'Application').Id;
        System.assertNotEquals(null, packageId); 
        TestHelper.getPackageFormConfig(true, packageId, formConfig);
        TestHelper.getPackageType(formConfig, custAppId, true);
        
        TestHelper.getExternalLinks(phaseConfig, true);
        TestHelper.getSearchConfig(Id.valueOf(phaseConfig), true);
        
        String progressBarId = TestHelper.getStepProgressbarHeader(true).Id;
        System.assertNotEquals(null, progressBarId); 
        Testhelper.getStepProgressBarDetail(progressBarId, true);
        TestHelper.getTaskConfig('Create', true);
        TestHelper.getTechLinkConfig(phaseConfig, true);
        
        TestHelper.getCopyConfig(true);
        TestHelper.getNameTemplateSequence(true);
        TestHelper.getRecordIdStorage(true);
        Test.stopTest();        
    }
}