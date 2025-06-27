@isTest
private class ApexJobTriggerHelperTest {


@IsTest
    private static void testQueued() {
      ApexJob__c job = new ApexJob__c();
      job.Status__c = 'Scheduled';
      insert job;
      
      job.Status__c = 'Queued';
      update job;
      
      job = [SELECT Id, LastQueuedOn__c FROM ApexJob__c WHERE Id = :job.Id];
      System.assertEquals(System.now(), job.LastQueuedOn__c);
    }

}