@isTest
private with sharing class TestErrorMessageConfigTriggerHelper {
    @isTest
    public static void processTest(){
        PhaseConfig__c phase = TestHelper.getPhase(false);
        phase.Name = 'SamplePhase';
        insert phase;
        System.assertEquals('SamplePhase', phase.Name);
        CustomApp__c app = TestHelper.getCustomApp(true);
        ErrorMessageConfig__c errorMsg = TestHelper.getErrorMessageConfig('101','TestErrorMessage', phase.Id, app.Id, false);
        errorMsg.ErrorCode__c = '101';
        insert errorMsg;
        System.assertEquals('TestErrorMessage', errorMsg.Message__c);
        errorMsg.Message__c  = 'TestErrorMsgUpdated';
        errorMsg.ErrorCode__c = '103';
        update errorMsg;
        System.assertEquals('TestErrorMsgUpdated', errorMsg.Message__c);
    }
     @isTest
    public static void processTest1(){
       PhaseConfig__c phase = TestHelper.getPhase(false);
        phase.Name = 'SamplePhase1';
        insert phase;
        System.assertEquals('SamplePhase1', phase.Name);
        CustomApp__c app = [Select id from CustomApp__c];
        ErrorMessageConfig__c errorMsg1 = TestHelper.getErrorMessageConfig('','TestErrorMessage1', phase.Id, app.Id, false);
        insert errorMsg1;
    }
}