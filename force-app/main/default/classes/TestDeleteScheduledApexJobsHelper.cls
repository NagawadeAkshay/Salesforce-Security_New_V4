@isTest
public class TestDeleteScheduledApexJobsHelper {
@isTest
    private static void setupData(){
           
        DeleteScheduledApexJobsHelper obj1 = new DeleteScheduledApexJobsHelper();
        Map<String,Object> res1 = obj1.clickHandler();
         system.assertNotEquals(null,obj1);      
    }
}