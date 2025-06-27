global with sharing class BatchJobKicker implements Schedulable {
    private Boolean firstTimeRun;

    global BatchJobKicker(Boolean firstTimeRun) {
        this.firstTimeRun = firstTimeRun;
    }

    global void execute(SchedulableContext sc) {
        try {
            abortCompletedJobEntries();
            scheduleApexJobsFromObject();      
        }
        catch (Exception e) {       
            CustomExceptions.logException(e, true, false);        
            this.sendExceptionEmail(e);
        }
    }

    global void scheduleApexJobsFromObject() {
        List<ApexJob__c> jobs = null;
        if(ApexJob__c.sObjectType.getDescribe().isAccessible() == true){
            if (firstTimeRun) {
                jobs = [SELECT Id, Name, ClassName__c, IntervalMins__c, RunOnce__c, CronExpression__c, BatchSize__c from ApexJob__c 
                                            where Active__c=true WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            }
            else {
                jobs = [SELECT Id, Name, ClassName__c, IntervalMins__c, RunOnce__c, CronExpression__c, BatchSize__c from ApexJob__c 
                                            where ApexRerunReady__c=true or RunOnce__c = true WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            }

            for (ApexJob__c j : jobs) {
                scheduleJob(j);
            }
        }            
        runMeAfterTwoMins();
    }

    webservice static void runAdhoc(Id recordId) {
        if(ApexJob__c.sObjectType.getDescribe().isAccessible() == true){
            ApexJob__c job = [Select Id, Name, ClassName__c, IntervalMins__c, CronExpression__c, BatchSize__c from ApexJob__c 
                                            where Id=:recordId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            job.CronExpression__c = null;
            job.IntervalMins__c = 1;
            BatchJobKicker kicker = new BatchJobKicker(true);
            kicker.scheduleJob(job);
        }
    }

    /* PRIVATE METHODS */

    public void scheduleJob(ApexJob__c jobConfig) {   
        if(String.isEmpty(jobConfig.ClassName__c)) {
        	throw new CustomExceptions.InputDataException('Class not defined:' + jobConfig.Name);
        }    
        Type t = Type.forName(jobConfig.ClassName__c);
        if(t == null) {
            throw new CustomExceptions.InputDataException(jobConfig.Name + ':Class does not exist:' + jobConfig.ClassName__c);
        }
        Object obj = t.newInstance();                
        if (obj instanceof BatchApexHandler) {
            handleBatchable((BatchApexHandler) obj, jobConfig);            
        } 
        else if (obj instanceof BatchApexIterableHandler) {
            handleIterableBatchable((BatchApexIterableHandler) obj, jobConfig);            
        }
        else if (obj instanceof SchedulableHandler) {
            handleSchedulable((SchedulableHandler) obj, jobConfig);
        }
        else {
            throw new CustomExceptions.InputDataException(jobConfig.Name + ':Unrecognized parent class. Please make sure class is extend framework class:' + jobConfig.ClassName__c);
        }
    }
    
    private void handleIterableBatchable(BatchApexIterableHandler job, ApexJob__c jobConfig) {
        job.jobConfigId = jobConfig.Id;

        if (jobConfig.BatchSize__c == null || jobConfig.BatchSize__c == 0) {
            jobConfig.BatchSize__c = 200; 
        }

        if (firstTimeRun) {
            if (String.isNotEmpty(jobConfig.CronExpression__c)) {
                scheduleRecurringJob(job, jobConfig);     
            }
            else { 
                if (!Test.isRunningTest()) {
                    jobConfig.ApexJobId__c = Database.executeBatch(job, jobConfig.BatchSize__c.intValue()); 
                }
            }
        }
        else { 
            if (!Test.isRunningTest()) {
                jobConfig.ApexJobId__c = Database.executeBatch(job, jobConfig.BatchSize__c.intValue());
            }
        }
    }

    private void handleBatchable(BatchApexHandler job, ApexJob__c jobConfig) {
        job.jobConfigId = jobConfig.Id;

        if (jobConfig.BatchSize__c == null || jobConfig.BatchSize__c == 0) {
            jobConfig.BatchSize__c = 200;
        }

        if (firstTimeRun) {
            if (String.isNotEmpty(jobConfig.CronExpression__c)) {
                scheduleRecurringJob(job, jobConfig);     
            }
            else { 
                if (!Test.isRunningTest()) {
                    jobConfig.ApexJobId__c = Database.executeBatch(job, jobConfig.BatchSize__c.intValue()); 
                }
            }
        }
        else { 
            if (!Test.isRunningTest()) {
                jobConfig.ApexJobId__c = Database.executeBatch(job, jobConfig.BatchSize__c.intValue());
            }
        }
    }

    private void handleSchedulable(SchedulableHandler job, ApexJob__c jobConfig) {
        job.jobConfigId = jobConfig.Id;
        
        if (firstTimeRun) {
            if (String.isNotEmpty(jobConfig.CronExpression__c)) {
                scheduleRecurringJob(job, jobConfig);   
            }
            else { 
                scheduleOnetimeJob(job, jobConfig);
            }
        }
        else { 
            scheduleOnetimeJob(job, jobConfig);
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
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job); 
        }      
    }
    private void scheduleRecurringJob(BatchApexIterableHandler jobHandler, ApexJob__c jobConfig) {
        String jobName = jobConfig.ClassName__c;
        String cron = jobConfig.CronExpression__c;
        BatchApexJobScheduler job = new BatchApexJobScheduler(jobHandler, jobConfig.BatchSize__c.intValue(), true);
    
        if (!Test.isRunningTest()) { 
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job); 
        }      
    }

    private void scheduleOnetimeJob(Schedulable job, ApexJob__c jobConfig) {
        String jobName = AppUtils.getUniqueJobName(jobConfig.ClassName__c);
        Integer delayMins = findDelayMins(jobConfig);           
        String cron = AppUtils.prepareJobsSchTime(DateTime.now(), delayMins);  

        if (!Test.isRunningTest()) {
            jobConfig.ApexJobId__c = System.schedule(jobName, cron, job);   
        }       
    }

    private Integer findDelayMins(ApexJob__c jobConfig) {
        Integer delayMins = 2;  //default delay
        if (firstTimeRun) {
            delayMins = 2;
        }
        else {
            if (jobConfig.IntervalMins__c != null && jobConfig.IntervalMins__c > 0) {
                delayMins = jobConfig.IntervalMins__c.intValue(); 
            }
        }
        return delayMins;
    } 

    private void runMeAfterTwoMins() {
        String cron = AppUtils.prepareJobsSchTime(DateTime.now(), 2);  
        String jobName = AppUtils.getUniqueJobName('BatchJobKicker');
        
        if (!Test.isRunningTest()) {
            System.schedule(jobName, cron, new BatchJobKicker(false));
        }
    } 

    private void abortCompletedJobEntries() {
        Integer SOQLLimit = 150;
        if (Test.isRunningTest()) SOQLLimit = 1;

        DateTime currTime = System.now();
        currTime = currTime.addMinutes(-5);

        if(CronTrigger.sObjectType.getDescribe().isAccessible() == true){ 
            List<CronTrigger> completedJobs = [SELECT Id, EndTime from CronTrigger where State='DELETED' 
                                and NextFireTime=null and TimesTriggered=1 and PreviousFireTime < :currTime WITH USER_MODE limit :SOQLLimit];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            for (CronTrigger completedJob : completedJobs) {
                if (!Test.isRunningTest()) {
                    System.abortJob(completedJob.Id);  
                }
            }
        }
    }

    private void sendExceptionEmail(Exception ex){
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        String subject = 'HIGH ALERT: BatchJobKicker Failed';
        String toEmail = UserInfo.getUserEmail();
        String bccAddress = KeyValueStoreHelper.getTextValue('NotifyFailedBatchToUser', true);
        semail.setToAddresses(new list<string>{toEmail});
        if(bccAddress != null){
            semail.setBccAddresses(new list<string>{bccAddress});
        }
        semail.setSubject(subject);
        String htmlBody = '<p>Hello {toUser},</p><p>Please find the below exception details:</p><table style="width: 579px; border-color: #000;" border="2px"><tbody><tr><td style="width: 150px;"><strong>Message</strong></td><td style="width: 411px;">{message}</td></tr><tr><td style="width: 150px;"><strong>Line Number</strong></td><td style="width: 411px;">{lineNumber}</td></tr><tr><td style="width: 150px;"><strong>Stack Trace</strong></td><td style="width: 411px;">{stackTrace}</td></tr></tbody></table><p>Thanks,</p><p>GovGrants Team.</p>';
        htmlBody = htmlBody.replace('{toUser}', UserInfo.getName());
        htmlBody = htmlBody.replace('{message}', ex.getMessage());
        htmlBody = htmlBody.replace('{lineNumber}', String.valueOf(ex.getLineNumber()));
        htmlBody = htmlBody.replace('{stackTrace}', ex.getStackTraceString());
        semail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
    }  
}