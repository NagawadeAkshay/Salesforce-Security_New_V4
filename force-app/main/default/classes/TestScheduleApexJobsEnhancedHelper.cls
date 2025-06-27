@isTest
public class TestScheduleApexJobsEnhancedHelper {
@isTest
    private static void setupData(){
        ScheduleApexJobsEnhancedHelper obj = new ScheduleApexJobsEnhancedHelper(); 
        Map<String,Object> mapObj = obj.clickHandler();
        ScheduleApexJobsEnhancedHelper.deleteScheduledJobs();
        system.assertNotEquals(null,obj);       
    }
}