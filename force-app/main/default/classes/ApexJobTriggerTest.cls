@isTest
private class ApexJobTriggerTest {
    
    @isTest
    static void verifyApexJobTrigger1(){
        ApexJob__c objApexJob = new ApexJob__c(
            Active__c = true,
            CronExpression__c = 'testexpression',
            Description__c = 'Test record',
            IntervalMins__c = 5,
            Status__c = 'Started'
        );
        insert objApexJob;
        System.assertNotEquals(null, objApexJob.Id);
        objApexJob.Status__c = 'Queued';
        update objApexJob;

    }
     @isTest
    static void verifyApexJobTrigger2(){
        ApexJob__c objApexJob = new ApexJob__c(
            Active__c = true,
            CronExpression__c = 'testexpression',
            Description__c = 'Test record',
            IntervalMins__c = 5,
            Status__c = 'Created'
        );
        insert objApexJob;
        System.assertNotEquals(null, objApexJob.Id);
        objApexJob.Status__c = 'Started';
        update objApexJob;

    }
     @isTest
    static void verifyApexJobTrigger3(){
        ApexJob__c objApexJob = new ApexJob__c(
            Active__c = true,
            CronExpression__c = 'testexpression',
            Description__c = 'Test record',
            IntervalMins__c = 5,
            Status__c = 'Started'
        );
        insert objApexJob;
        System.assertNotEquals(null, objApexJob.Id);
        objApexJob.Status__c = 'Completed';
        update objApexJob;

    }
}