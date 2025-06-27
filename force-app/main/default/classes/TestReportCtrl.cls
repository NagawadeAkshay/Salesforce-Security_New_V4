@isTest
private with sharing class TestReportCtrl{

    @isTest
    static void testgetReportIcon(){
        Test.startTest();
        Map<String, String> result = ReportCtrl.getReportIcon();
        Map<String, String> resultLWC = ReportCtrl.getReportIconLwc();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }
    
}