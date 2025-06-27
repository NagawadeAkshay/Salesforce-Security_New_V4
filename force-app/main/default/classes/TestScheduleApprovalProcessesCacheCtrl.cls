@isTest
public class TestScheduleApprovalProcessesCacheCtrl {
	@isTest
    private static void setupData(){
        ScheduleApprovalProcessesCacheCtrl obj = new ScheduleApprovalProcessesCacheCtrl();
        obj.refreshCache();
        obj.scheduleApprovaHistoryRefreshJob();        
        system.assertNotEquals(null,obj);      
    }
}