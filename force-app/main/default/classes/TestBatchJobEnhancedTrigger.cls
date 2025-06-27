/**
 * Created by REI on 15-06-2020.
 */

@IsTest
private with sharing class TestBatchJobEnhancedTrigger {
    /*If this test class fail with error System.AsyncException: Based on configured schedule, the given trigger 'SCHEDULED_APEX_JOB_TYPE.000000000000000' will never fire.
    Then change the cron exp yr*/
    public static String CRON_EXP = '0 0 0 15 3 ? 2025';

    @testSetup static void setup(){
        TestHelper.getApexJob(true);
    }

    @IsTest
    private static void testExecute(){
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new BatchJobEnhancedKicker());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        Test.stopTest();
    }

    @IsTest
    private static void testScheduleKicker(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        System.assertNotEquals(null, batchJobEkicker);
        batchJobEkicker.scheduleKicker();
        Test.stopTest();
    }

    @IsTest
    private static void testScheduleRecurringJobs(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        System.assertNotEquals(null, batchJobEkicker);
        batchJobEkicker.scheduleRecurringJobs();
        Test.stopTest();
    }

    @IsTest
    private static void testSchedulableClass(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.ClassName__c = 'SchedulableHandler';
        insert apexJob;
        System.assertNotEquals(null,apexJob.ClassName__c);
        batchJobEkicker.scheduleRecurringJobs();
        Test.stopTest();
    }

    @IsTest
    private static void testBatchApexItrable(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.ClassName__c = 'BatchApexIterableHandler';
        apexJob.BatchSize__c = 0;
        insert apexJob;
        System.assertEquals('BatchApexIterableHandler',apexJob.ClassName__c);
        batchJobEkicker.scheduleRecurringJobs();
        Test.stopTest();
    }

    @IsTest
    private static void testBatchQueueable(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.ClassName__c = 'QueueableHandler';
        insert apexJob;
        System.assertNotEquals(null,apexJob.ClassName__c);
        batchJobEkicker.scheduleRecurringJobs();
        Test.stopTest();
    }

    @IsTest
    private static void testOneTimeSchedulable(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.CronExpression__c = '';
        apexJob.ClassName__c = 'SchedulableHandler';
        insert apexJob;
        System.assertNotEquals(null,apexJob.ClassName__c);
        try {
            Type t = Type.forName(apexJob.ClassName__c);
            Object obj = t.newInstance();
            batchJobEkicker.scheduleOnetimeJob((SchedulableHandler) obj, apexJob);
        } catch (Exception ex){}
        
        Test.stopTest();
    }

    @IsTest
    private static void testCustomException(){
        Test.startTest();
        BatchJobEnhancedKicker batchJobEkicker = new BatchJobEnhancedKicker();
        ApexJob__c apexJob = TestHelper.getApexJob(false);
        apexJob.ClassName__c = '';
        insert apexJob;
        System.assertNotEquals(null,apexJob.ClassName__c);
        batchJobEkicker.scheduleRecurringJobs();
        Test.stopTest();
    }

}