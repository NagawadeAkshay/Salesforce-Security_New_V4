@isTest
private class TestBusinessRuleResult {

@isTest
  private static void TestupdateAttachment(){ 
    Test.startTest();
    BusinessRuleResult BusinessRuleResultObj = new BusinessRuleResult();
    System.assertNotEquals(null, BusinessRuleResultObj);
    BusinessRuleResultObj.hasErrors();
    BusinessRuleResultObj.addErrorsToPage();
    Test.stopTest();
  }
}