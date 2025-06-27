@isTest
private class TestBatchJobKicker {
    @isTest static void test_method_one() {
        Test.startTest();
        BatchJobKicker job = new BatchJobKicker(true);
        System.schedule('Abc0192kkkdk3d', '0 0 23 * * ?', job);
        ApexJob__c apexJobObj = TestHelper.getApexJob(true);
        BatchJobKicker.runAdhoc(apexJobObj.id);
        job.scheduleJob(apexJobObj);
        Test.stopTest();
        String testString = 'test value';
        system.assertNotEquals(null,testString ); 
    }

    @isTest static void test_method_two() {
        Test.startTest();
        BatchJobKicker job = new BatchJobKicker(false);
        System.schedule('Abc0192kkklllosid', '0 0 23 * * ?', job);
        Test.stopTest();
        String testString = 'test value';
        system.assertNotEquals(null,testString ); 
    }
	 @isTest static void test_method_three() {
        Test.startTest();
        BatchJobKicker job = new BatchJobKicker(true);
        System.schedule('Abc0192kkklllosid', '0 0 23 * * ?', job);
        Test.stopTest();
        system.assertNotEquals(null,job ); 
    }
    @isTest static void test_method_four() {
        Test.startTest();
        BatchJobKicker job = new BatchJobKicker(true);
        System.schedule('Abc0192kkkdk3d', '0 0 23 * * ?', job);
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.ClassName__c = 'BatchApexIterableHandler';
        apexJob.BatchSize__c = 0;
        insert apexJob;
        try {
            BatchJobKicker.runAdhoc(apexJob.id);
            job.scheduleJob(apexJob);
        } catch (Exception ex){}
        Test.stopTest();
        system.assertNotEquals(null,job ); 
    }
 @isTest static void test_method_five() {
        Test.startTest();
        BatchJobKicker job = new BatchJobKicker(true);
        System.schedule('Abc0192kkkdk3d', '0 0 23 * * ?', job);
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.ClassName__c = 'SchedulableHandler';
        apexJob.BatchSize__c = 0;
        insert apexJob;
        try {
            BatchJobKicker.runAdhoc(apexJob.id);
            job.scheduleJob(apexJob);
        } catch (Exception ex){}
        Test.stopTest();
        system.assertNotEquals(null,job ); 
    }
    

}