@isTest
private with sharing class CICDConfigDataServiceTest{
    @IsTest
    private static void testNegativedoDuplicateParamsTest() {
        String returnJson = CICDConfigDataService.doDuplicateParamsTest(null,null);
        System.assertnotequals(null,returnJson );
    }
    
    @IsTest
    private static void testPositivedoDuplicateParamsTest() {
        String returnJson = CICDConfigDataService.doDuplicateParamsTest(new List<String>{'SetupAuditTrail','User'},System.now());
        System.assertnotequals(null,returnJson );
    }
    
    @IsTest
    private static void testLMDdoDuplicateParamsTest() {
        String returnJson = CICDConfigDataService.doDuplicateParamsTest(new List<String>{'User'},null);
        System.assertnotequals(null,returnJson );
    }
}