@isTest()
public class TestGGQueueTriggerHelper{
   
     
    @isTest
    private static void testBatchApexCtrl(){
       Test.StartTest();
        user u = TestHelper.getStandardUser(true);

          
        Group grp = new Group();
        grp.Type = 'Queue';
        grp.DeveloperName = 'test1';
        grp.Name = 'test1';
        insert grp;
        
        GGQueueTriggerHelper triggerHelper = new GGQueueTriggerHelper();
        GGQueue__c ggQueue = new GGQueue__c();
        ggQueue.DeveloperName__c = 'test1';
         ggQueue.Name = 'test1';
        insert ggQueue;
        list<GGQueue__c> ggq = [select id,Name from GGQueue__c where Name='test1' ];
        System.assertNotEquals(null, ggq);
        
        ggQueue.Name = 'test2';
        update ggQueue;
        System.assertEquals('test2', ggQueue.Name);
      
        
        
       List<Group> grupList = [SELECT Id, Type,DeveloperName FROM Group Where Name ='test1' ];
        System.assertNotEquals(null, grupList);
        
       Test.StopTest();   
       
    }
}