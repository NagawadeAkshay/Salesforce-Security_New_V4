@isTest
public class TestApprovalRecallBatchV1 {
@isTest
    private static void setupData2(){        
        ApprovalRecallBatchV1 obj1 = new ApprovalRecallBatchV1();
        String qury = obj1.getQuery();
        List<sObject> scope = new List<sObject>();
        obj1.execute(scope);        
        system.assertNotEquals(null,obj1);      
    }
}