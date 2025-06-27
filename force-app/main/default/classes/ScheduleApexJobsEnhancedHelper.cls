public with sharing class ScheduleApexJobsEnhancedHelper  extends FlexTableActionHandler {
    private static final Integer MAX_JOBS = 5000;
    public override Map<String,Object> clickHandler(){
        Map<String,Object> returnMap = new Map<String,Object>();
        deleteScheduledJobs();
        if(Test.isRunningTest() == false){
            new BatchJobEnhancedKicker().scheduleRecurringJobs();
            new BatchJobEnhancedKicker().scheduleKicker();
        }
        List<CronTrigger> apexJobs = [SELECT Id FROM CronTrigger where EndTime=null and CronJobDetail.JobType='7' WITH USER_MODE limit :MAX_JOBS];
        returnMap.put('Message','Apex jobs were scheduled. To view the list of jobs, visit the ' +
                '<a href="/08e?setupid=ScheduledJobs" style="color: blue;">Scheduled Jobs</a> page.');
        return returnMap;
    }
    
    //Selects all apex scheduled jobs (not scheduled reports or dashboards) and deletes them
        //from the scheduled jobs page so that any deployments can be made.
        public static void deleteScheduledJobs() {
            List<CronTrigger> apexJobs = [SELECT Id FROM CronTrigger where EndTime=null and CronJobDetail.JobType='7' WITH USER_MODE limit 100];
            for (CronTrigger job : apexJobs) {
                System.abortJob(job.Id);
            }
            //init();
            //returnMap('Message ' + apexJobs.size() + ' apex jobs were deleted from Scheduled Jobs page');
            //return returnMap;
        }
}