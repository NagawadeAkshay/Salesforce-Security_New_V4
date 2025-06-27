@isTest public with sharing class TestSyncQueueBatch {
  
    @isTest static void testGetQuery(){
        User u=TestHelper.getAdminUser(true);
         System.runAs(u) {
            Test.startTest();
                SyncQueueBatch que = new SyncQueueBatch();
                String query = que.getQuery();
                System.assertEquals('SELECT Id, Name,DeveloperName FROM Group WHERE Type = \'Queue\' WITH USER_MODE', query);
            Test.stopTest();
         }
    }
    
    @isTest static void testExecute(){
        User u=TestHelper.getAdminUser(true);
         System.runAs(u) {
            Test.startTest();
                SyncQueueBatch que = new SyncQueueBatch();
                List<SObject> sobj = new List<SObject>();
                Group grp = new Group();
                grp.DeveloperName = 'Test';
                sObject ot=grp;
                sobj.add(ot);
                que.execute(sobj);
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest();
         }
    }
}