public virtual with sharing class JobManager {
    public Id jobConfigId;
    public ApexJob__c jobConfig;
    protected ErrorHandler errorHandler = new ErrorHandler();

    @TestVisible
    protected void startJobStatus() {
        if(jobConfigId == null){
            findJobConfig();
        }
        if (jobConfigId != null
                && Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.FirstRunStartedOn__c.isUpdateable() 
                && Schema.SObjectType.ApexJob__c.fields.LastRunStartedOn__c.isUpdateable()) {
            try {
                errorHandler = new ErrorHandler(jobConfigId);
                loadJobConfig();
                jobConfig.LastRunStartedOn__c = System.now();
                jobConfig.LastRunEndedOn__c = null;
                jobConfig.Status__c = 'Started';
                // New Add As per Shah Batch Job.
                if(jobConfig.FirstRunStartedOn__c == null) {
                  jobConfig.FirstRunStartedOn__c = System.now();
                }
                //jobConfig.ErrorMessage__c = null;
                if(Schema.sObjectType.ApexJob__c.isUpdateable()){
                    update as user jobConfig;
                }
            }
            catch (Exception e) {     
                setExceptionError(e);
            }
        }       
    }

    @TestVisible
    protected void stopJobStatus() {
        if (jobConfig != null && Schema.SObjectType.ApexJob__c.fields.Status__c.isAccessible()
                && Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()) {
            jobConfig.LastRunEndedOn__c = System.now();
            jobConfig.Status__c = 'Completed';
            if(Schema.sObjectType.ApexJob__c.isUpdateable()){
                update as user jobConfig;               
            }       
        }
    }

    @TestVisible
      protected void persistErrors() {
        if (errorHandler != null) {
          errorHandler.persist();
        }
      }

      @TestVisible
    private void loadJobConfig() {
        this.jobConfig = [SELECT Id, ClassName__c, RunOnce__c, FirstRunStartedOn__c, InitialStartDelayMins__c, IntervalMins__c, CronExpression__c, 
                                        BatchSize__c from ApexJob__c where Id=:jobConfigId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
    }

    // New Batch Job FrameWork.
    public void setExceptionError(Exception e){
        if(Schema.SObjectType.ApexJob__c.fields.Status__c.isAccessible() && 
            Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
            && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isAccessible() &&
            Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()
            && Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isAccessible() &&
            Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isUpdateable()){
            jobConfig.LastRunEndedOn__c = System.now();
            jobConfig.Status__c = 'Failed';
            jobConfig.ErrorMessage__c = e.getMessage() + '\n' + 'Line: ' + e.getLineNumber() + 
                    '\n' + e.getStackTraceString();
                if(Schema.sObjectType.ApexJob__c.isUpdateable()){
                    update as user jobConfig;
                }
        }
        errorHandler.add(e);
    }

    // New Batch Job FrameWork.
    public void setError(Exception e, List<sObject> scope){
        if(Schema.SObjectType.ApexJob__c.fields.Status__c.isAccessible() && Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isUpdateable()){
                jobConfig.LastRunEndedOn__c = System.now();
                jobConfig.Status__c = 'Failed';
                jobConfig.ErrorMessage__c = e.getMessage() + '\n' + 'Line: ' + e.getLineNumber() + 
                        '\n' + e.getStackTraceString();
            if(Schema.sObjectType.ApexJob__c.isUpdateable() && Schema.sObjectType.ApexJob__c.isAccessible()){
                update as user jobConfig;
            }
        }
        errorHandler.add(e);
    }

    // This method to handle Error at BatchableIterableApex Handler..
    public void setError(Exception e, List<Object> scope){
        if(Schema.SObjectType.ApexJob__c.fields.Status__c.isAccessible() && Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isUpdateable()){
                jobConfig.LastRunEndedOn__c = System.now();
                jobConfig.Status__c = 'Failed';
                jobConfig.ErrorMessage__c = e.getMessage() + '\n' + 'Line: ' + e.getLineNumber() + 
                        '\n' + e.getStackTraceString();
                if(Schema.sObjectType.ApexJob__c.isUpdateable() && Schema.sObjectType.ApexJob__c.isAccessible()){
                    update as user jobConfig;
                }
        }
        errorHandler.add(e);
    }

    @TestVisible
    protected void setError(Exception e) {
        if(Schema.SObjectType.ApexJob__c.fields.Status__c.isAccessible() && Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isUpdateable()){
                jobConfig.LastRunEndedOn__c = System.now();
                jobConfig.Status__c = 'Failed';
                jobConfig.ErrorMessage__c = e.getMessage() + '\n' + 'Line: ' + e.getLineNumber() + 
                        '\n' + e.getStackTraceString();
                if(Schema.sObjectType.ApexJob__c.isUpdateable() && Schema.sObjectType.ApexJob__c.isAccessible()){
                    update as user jobConfig;               
                }
        }
        //update log to log Object as jobConfig.ErrorMessage__c will get overwritten in next batch execution  
        CustomExceptions.logException(jobConfig.ErrorMessage__c, true); 
        notifyAdminonError(jobConfig.ErrorMessage__c);             
    }
    
    @TestVisible
    protected void setError(String e) {
        if(Schema.SObjectType.ApexJob__c.fields.Status__c.isAccessible() && Schema.SObjectType.ApexJob__c.fields.Status__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.LastRunEndedOn__c.isUpdateable()
                && Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isAccessible() &&
                Schema.SObjectType.ApexJob__c.fields.ErrorMessage__c.isUpdateable()){
                jobConfig.LastRunEndedOn__c = System.now();
                jobConfig.Status__c = 'Failed';
                jobConfig.ErrorMessage__c = (e.length() > 32767 ? e.subString(0, 32767): e);
            if(Schema.sObjectType.ApexJob__c.isUpdateable() && Schema.sObjectType.ApexJob__c.isAccessible()){
                update as user jobConfig; 
            }
        }
        CustomExceptions.logException(e,true);   
        notifyAdminonError(jobConfig.ErrorMessage__c);             
    }
    
    
    private void notifyAdminonError(String exceptionMsg) {
        String Subject = 'Exception in Batch Job : ' + jobConfig.ClassName__c + ' Org Id:' + UserInfo.getOrganizationId();
        new EmailFeeder().TargetObjectId(UserInfo.getUserId()).subject(Subject).htmlBody(exceptionMsg).send();
    }

    // New Batch Job FrameWork.
    private void findJobConfig(){
        String classname = String.valueOf(this).split(':')[0];
        List<ApexJob__c> configList = [SELECT Id FROM ApexJob__c WHERE ClassName__c=:classname WITH USER_MODE limit 1];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
         if (configList.isEmpty() == false) {
          this.jobConfigId = configList.get(0).Id;
        }
    }

}