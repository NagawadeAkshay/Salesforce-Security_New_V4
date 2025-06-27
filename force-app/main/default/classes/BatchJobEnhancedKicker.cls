/**
    It Schedules recurring and one time jobs usings cron expression and custom attributes.
*/
global with sharing class BatchJobEnhancedKicker implements Schedulable {
    //private Boolean firstTimeRun;

    global void execute(SchedulableContext ctx){
        List<ApexJob__c> schduleErrorLogList = new List<ApexJob__c>();
        List<ApexJob__c> jobs = new List<ApexJob__c>();
        if(Schema.sObjectType.ApexJob__c.isAccessible()) {
            jobs = [SELECT Id,Name,ClassName__c,IntervalMins__c,CronExpression__c,BatchSize__c FROM ApexJob__c
            WHERE KickNow__c = true WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }                         
        ErrorHandler errorHandler = new ErrorHandler();
        for(ApexJob__c j:jobs){
            schduleErrorLogList.add(j);
        }
        ErrorLog__c log = scheduleJob(schduleErrorLogList);
            if(log !=null){
                errorHandler.add(log);
            }
        errorHandler.persist();                                  
    }

    global void scheduleKicker(){
        try{
            for(Integer i=0;i<60;i++){
                String sch1 = '0 '+i+' * * * ?';
            }  
        }catch(Exception e){
        }              
    }

    global void scheduleRecurringJobs(){
        List<ApexJob__c> schduleErrorLogList = new List<ApexJob__c>();
        List<ApexJob__c> jobs = new List<ApexJob__c>();
        if(Schema.sObjectType.ApexJob__c.isAccessible()) {
            jobs = [SELECT Id, Name, ClassName__c, IntervalMins__c, CronExpression__c, BatchSize__c FROM ApexJob__c
                                 WHERE Active__c=true AND CronExpression__c !=null WITH USER_MODE]; 
        }                         
        ErrorHandler errorHandler = new ErrorHandler();
        for(ApexJob__c jobConfig:jobs){
            // Bulkification of apex method......
            schduleErrorLogList.add(jobConfig);
        }
        ErrorLog__c log = scheduleJob(schduleErrorLogList);
            if(log !=null){
                errorHandler.add(log);
            }
        errorHandler.persist();                                       
    }

    private ErrorLog__c scheduleJob(List<ApexJob__c> jobConfigLst){
        try{
            List<ApexJob__c> apexJobLst = new List<ApexJob__c>();
            for(ApexJob__c jobConfig: jobConfigLst){
                Type t = Type.forName(jobConfig.ClassName__c);
                if(t == null){
                    throw new CustomExceptions.InputDataException('Apex Class '+jobConfig.ClassName__c+' is not found');
                }
                Object obj = t.newInstance();

                if(obj instanceof BatchApexHandler){
                    handleBatchable((BatchApexHandler) obj, jobConfig);
                }
                else if(obj instanceof BatchApexIterableHandler){
                    handleIterableBatchable((BatchApexIterableHandler) obj, jobConfig);
                }
                else if(obj instanceof QueueableHandler){
                    handleQueueable((QueueableHandler) obj, jobConfig);
                }
                else if(obj instanceof SchedulableHandler){
                    handleSchedulable((SchedulableHandler) obj, jobConfig);
                }
                else{
                    throw new CustomExceptions.InputDataException('Unrecognized parent class found in job config:'+jobConfig.Id);                
                }

                if(Schema.sObjectType.ApexJob__c.fields.Status__c.isUpdateable()){
                    jobConfig.Status__c = 'Queued';
                }
                if(Schema.sObjectType.ApexJob__c.fields.LastRunStartedOn__c.isUpdateable()){
                    jobConfig.LastRunStartedOn__c = null;
                }
                if(Schema.sObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()){
                    jobConfig.LastRunEndedOn__c = null;
                }
                apexJobLst.add(jobConfig);
            }
            if(Schema.sObjectType.ApexJob__c.isUpdateable()){
                update as user apexJobLst;
            }
            return null;
        }catch(Exception e){
            ApexJob__c jobConfig = new ApexJob__c();
            if(Schema.sObjectType.ApexJob__c.fields.LastRunEndedOn__c.isCreateable()){
                jobConfig.LastRunEndedOn__c = System.now();
            }
            if(Schema.sObjectType.ApexJob__c.fields.Status__c.isCreateable()){
                jobConfig.Status__c = 'Failed';
            }
            if(Schema.sObjectType.ApexJob__c.fields.IntervalMins__c.isCreateable()){
            	jobConfig.IntervalMins__c= 1;
            }
            if(Schema.sObjectType.ApexJob__c.fields.ErrorMessage__c.isCreateable()){
                jobConfig.ErrorMessage__c = e.getMessage() + '\n' + 'Line: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
            }
            if(Schema.sObjectType.ApexJob__c.isCreateable()){
                insert as user jobConfig;
            }
            return new ErrorLog__c(ParentId__c = jobConfig.Id, ErrorMessage__c = ErrorHandler.getException(e));
        }    
    }
    
    private void handleIterableBatchable(BatchApexIterableHandler handler, ApexJob__c jobConfig) {
        handler.jobConfigId = jobConfig.Id;

        if (jobConfig.BatchSize__c == null || jobConfig.BatchSize__c == 0) {
            jobConfig.BatchSize__c = 200; //default batch size
        }

        //if (firstTimeRun) {
            if (String.isNotEmpty(jobConfig.CronExpression__c)) {
                scheduleRecurringJob(handler, jobConfig);     
            }
            else { //one time run
                if (!Test.isRunningTest()) {
                    jobConfig.ApexJobId__c = Database.executeBatch(handler, jobConfig.BatchSize__c.intValue()); 
                }
            }
        //}
       /* else { //one time run
            if (!Test.isRunningTest()) {
                jobConfig.ApexJobId__c = Database.executeBatch(job, jobConfig.BatchSize__c.intValue());
            }
        }*/
    }

    private void handleBatchable(BatchApexHandler handler, ApexJob__c jobConfig) {
        handler.jobConfigId = jobConfig.Id;

        if (jobConfig.BatchSize__c == null || jobConfig.BatchSize__c == 0) {
            jobConfig.BatchSize__c = 200; //default batch size
        }

        //if (firstTimeRun) {
            if (String.isNotEmpty(jobConfig.CronExpression__c)) {
                scheduleRecurringJob(handler, jobConfig);     
            }
            else { //one time run
                if (!Test.isRunningTest()) {

                    jobConfig.ApexJobId__c = Database.executeBatch(handler, jobConfig.BatchSize__c.intValue());
                }
            }
        //}
       /* else { //one time run
            if (!Test.isRunningTest()) {
                jobConfig.ApexJobId__c = Database.executeBatch(job, jobConfig.BatchSize__c.intValue());
            }
        }*/
    }

    private void handleQueueable(QueueableHandler handler, ApexJob__c jobConfig){
        handler.jobConfigId = jobConfig.Id;
        jobConfig.ApexJobId__c = System.enqueueJob(handler);                                
    }

    private void handleSchedulable(SchedulableHandler handler, ApexJob__c jobConfig) {
        handler.jobConfigId = jobConfig.Id;
        
            if (String.isNotEmpty(jobConfig.CronExpression__c)) {
                scheduleRecurringJob(handler, jobConfig);   
            }
            else { 
                scheduleOnetimeJob(handler, jobConfig);
            }
    }   

    private void scheduleRecurringJob(Schedulable job, ApexJob__c jobConfig) {
        String jobName = jobConfig.ClassName__c;
        String cron = jobConfig.CronExpression__c;
        if (!Test.isRunningTest()) {
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job); 
        }       
    }

    private void scheduleRecurringJob(BatchApexHandler jobHandler, ApexJob__c jobConfig) {
        String jobName = jobConfig.ClassName__c;
        String cron = jobConfig.CronExpression__c;
        BatchApexJobScheduler job = new BatchApexJobScheduler(jobHandler, jobConfig.BatchSize__c.intValue());
    
        if (!Test.isRunningTest()) { 
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job); //recurring schedule
        }      
    }


    private void scheduleRecurringJob(BatchApexIterableHandler jobHandler, ApexJob__c jobConfig) {
        String jobName = jobConfig.ClassName__c;
        String cron = jobConfig.CronExpression__c;
        BatchApexJobScheduler job = new BatchApexJobScheduler(jobHandler, jobConfig.BatchSize__c.intValue(), true);
    
        if (!Test.isRunningTest()) { 
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job); //recurring schedule
        }      
    }

    public void scheduleOnetimeJob(Schedulable job, ApexJob__c jobConfig) {
        String jobName = AppUtils.getUniqueJobName(jobConfig.ClassName__c);
        Integer delayMins = findDelayMins(jobConfig);           
        String cron = AppUtils.prepareJobsSchTime(DateTime.now(), delayMins);  

        if (!Test.isRunningTest()) {
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job);   
        }       
    }

    private Integer findDelayMins(ApexJob__c jobConfig) {
        Integer delayMins = 2;  
        if (jobConfig.IntervalMins__c != null && jobConfig.IntervalMins__c > 0) {
            delayMins = jobConfig.IntervalMins__c.intValue(); 
        }
        return delayMins;
    } 

}