/**
	Generic job scheduler class
*/ 
global with sharing class BatchApexJobScheduler implements Schedulable { 
	private Database.Batchable<SObject> batchApexObject;
    private Database.Batchable<Object> batchApexIterableObject;

	private Integer batchSize;
	public static Boolean isTest = false;
	
	//Public constructor used to pass the batch apex object which is later used to invoke. 
	global BatchApexJobScheduler(Database.Batchable<SObject> batchApexObject, Integer batchSize) {
		this.batchApexObject = batchApexObject;
		this.batchSize = batchSize;
	}
    
    // constructor used to pass the Iterable batch apex object which is later used to invoke. 
    global BatchApexJobScheduler(Database.Batchable<Object> batchApexIterableObject, Integer batchSize, Boolean Iterable) {
        this.batchApexIterableObject = batchApexIterableObject;
        this.batchSize = batchSize;
    }
	
	//Private constructor is used to avoid creating instance of this class without passing 
	//any value for the batchApexObject variable
	private BatchApexJobScheduler() {
		//do nothing
	}
	 
	//Execute method which contains the logic to invoke the batch apex code based on the batchApexObject variable.
    global void execute(SchedulableContext sc) {
    	String jobId = sc.getTriggerId();
        if(batchApexObject != null){
            Database.executebatch(batchApexObject, batchSize);
        }else{
            Database.executebatch(batchApexIterableObject, batchSize);
        }    
    }


    global static String getUniqueJobName(String batchApexName) {
        return AppUtils.getUniqueJobName(batchApexName);
    }
    
    //prepares schedule time that would allow the job to run only once after X minutes from current time.
    global static String prepareJobsSchTime(DateTime startDate, Integer addMinutes) {
        return AppUtils.prepareJobsSchTime(startDate, addMinutes);
    }
    
    global static void abortJob(String jobId) {
        try {
            if (jobId != null) {
            }
        }
        catch (Exception ex) {
        }
    }
	
    /**
        It deletes the old entries from CronTrigger object by invoking System.abortJob() command. This was recommended by PSR as a workaround til 168 release.
        Returns true if more entries to be deleted.
    */ 
    global static Boolean abortObsoleteScheduledJobEntries(Id excludeId) {
    	try {
	    	Integer SOQLLimit_CronTriggerAbort = 100;
	        if (Test.isRunningTest()) SOQLLimit_CronTriggerAbort = 1;
	           if(CronTrigger.sObjectType.getDescribe().isAccessible() == true){ 
                    List<CronTrigger> oldJobs = [SELECT Id, CronExpression from CronTrigger where CreatedById = :UserInfo.getUserId() and State='DELETED' 
                                        and NextFireTime=null and Id != :excludeId WITH USER_MODE limit :SOQLLimit_CronTriggerAbort]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    for (CronTrigger oldJob : oldJobs) {
                        abortJob(oldJob.Id);  //If any exception is thrown, it can't be caught
                    }
                    if (oldJobs.size() > 0) return true;
                }
    	}
    	catch (Exception e) {
    	}        
    	return false;
    }   
	    
     
}