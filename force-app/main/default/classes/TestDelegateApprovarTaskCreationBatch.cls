/**
Test class for DelegateApprovarTaskCreationBatch
**********************************************************
Audit History
**********************************************************
3/4/2019      Sonali Bajirao Jadhav            Created
**********************************************************  
*/
@isTest
public class TestDelegateApprovarTaskCreationBatch  {
    public static List<String> userList;
    public static List<String> userList2;
    public static void setUp(){
        user u = TestHelper.getUser(false);
        u.IsActive=true;
        u.EnableDelegate__c=true;
        u.DelegateFrom__c=Date.Today().addDays(-1);
         u.DelegateTo__c = Date.Today() ;
        u.UserName='TesterTestingjohn@acme.com';
        u.DelegatedApproverId =UserInfo.getUserId();
        insert u;
        userList= new List<String>();
        userList.add(u.id);
        userList2= new List<String>();
            
        List<ProcessInstanceWorkitem> processes = new List<ProcessInstanceWorkitem>();
        ProcessInstanceWorkitem p1 = TestHelper.getWorkItem();
        Account acc=TestHelper.getAccount(false);
        insert acc;
        Task t = new task();
        t.whatId = acc.id;
        t.TaskAction__c='Review Announcements';
        t.ownerId = u.id;
        t.WorkitemId__c = p1.id;
        insert t;
        
        list<String> delagetedeId =  new List<String>();
        delagetedeId.add(t.id);
                    
    }
    
     /*@isTest
    private static void testReassignTasksCtrl(){
       
        Test.StartTest();
        setup();
        DelegateApprovarTaskCreationBatch taskCreationBatch = new DelegateApprovarTaskCreationBatch ();
        Database.executeBatch(taskCreationBatch );
        
        DelegateApprovarTaskCreationBatch Taskcreate = new DelegateApprovarTaskCreationBatch(userList);
        Database.executeBatch(Taskcreate );
        
        DelegateApprovarTaskCreationBatch Taskcreate2 = new DelegateApprovarTaskCreationBatch(userList2);
        Database.executeBatch(Taskcreate2 );
        system.assertEquals(1, userList.size());
       
        Test.StopTest();
         
    }  */
}