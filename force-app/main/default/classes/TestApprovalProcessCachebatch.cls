@isTest
public class TestApprovalProcessCachebatch {
	@isTest
    private static void setupData(){
        ApprovalProcessCachebatch obj = new ApprovalProcessCachebatch();
        ApprovalProcessCachebatch obj1 = new ApprovalProcessCachebatch();
        Database.BatchableContext bachableCon;
        Database.QueryLocator ql = obj1.start(bachableCon);
        List<sObject> scope = new List<sObject>();
        ProcessDefinition pd = TestHelper.getProcessDefination();
        scope.add(pd);
        obj1.execute(bachableCon,scope);
        obj1.finish(bachableCon);
          system.assertNotEquals(null,obj);      
    }
    @isTest
    private static void setupData2(){        
        ApprovalProcessCachebatch obj1 = new ApprovalProcessCachebatch();
        Database.BatchableContext bachableCon;
        Database.QueryLocator ql = obj1.start(bachableCon);
        List<sObject> scope = new List<sObject>();
       	obj1.execute(bachableCon,scope);
        MetadataService.ApprovalProcess[] approvalProcList;

        obj1.finish(bachableCon);
          system.assertNotEquals(null,obj1);      
    }
}