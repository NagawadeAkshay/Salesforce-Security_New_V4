@isTest
private class TestDataCopyConfigTriggerHelper {
    static List<RecordCopyConfig__c> lstRecordCopyConfig = new List<RecordCopyConfig__c>();
    public static void setUp(){
        RecordCopyConfig__c objRecordCopyConfig = new RecordCopyConfig__c();
        objRecordCopyConfig.SourceObjectName__c ='Account';
        objRecordCopyConfig.TargetObjectName__c = 'contact';
        lstRecordCopyConfig.add(objRecordCopyConfig);
        insert lstRecordCopyConfig;
        update lstRecordCopyConfig;
    }
    public static testmethod void test1(){
        Test.startTest();
        	setUp();
        	System.assertEquals('Account',lstRecordCopyConfig[0].SourceObjectName__c );
        test.stopTest();
    }
     
	
}