@isTest
private class TestErrorMessageTriggerHelper{
  
  @isTest
  private static void TestErrorMessageConfigInsert(){
      PhaseConfig__c phaseConfig = TestHelper.getPhase(true);
      CustomApp__c customAppConfig = new CustomApp__c();
      customAppConfig.Name = 'StateasGrantor';
      customAppConfig.Active__C = true;
      insert customAppConfig;
      Id errorMessageConfigId;
      Test.startTest();
          ErrorMessageConfig__c errorMessageConfig = TestHelper.getErrorMessageConfig('Error',phaseConfig.id,customAppConfig.id,true );
          errorMessageConfigId = errorMessageConfig.id;
      Test.stopTest();
      system.assert(errorMessageConfigId != null);
  }
    
}