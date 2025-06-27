public with sharing class DeleteScheduledApexJobsHelper extends FlexTableActionHandler {
       public override Map<String,Object> clickHandler(){
        Map<String,Object> returnMap = new Map<String,Object>();
        deleteScheduledJobs();
        
        returnMap.put('Message','Jobs were deleted');
        return returnMap;
       }
       
       public static void deleteScheduledJobs() {
        if(CronTrigger.sObjectType.getDescribe().isAccessible() == true){ 
            List<CronTrigger> apexJobs = [SELECT Id FROM CronTrigger where EndTime=null and CronJobDetail.JobType='7' WITH USER_MODE limit 150];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            for (CronTrigger job : apexJobs) {
                System.abortJob(job.Id);
            }
        }
    }
    
}