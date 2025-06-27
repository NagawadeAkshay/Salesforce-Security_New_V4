global abstract with sharing class BatchApexHandler extends JobManager implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
                                                
    private String errorString = ''; 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        try{
        startJobStatus();
        return Database.getQueryLocator(getQuery());
        }catch(Exception e){
            setExceptionError(e);
            return null;
        }
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            execute(scope);
        }
        catch (Exception e) {
            setError(e,scope);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        try {
            finish();
            stopJobStatus(); 
        }
        catch (Exception e) {
            
            setExceptionError(e);
        }
        persistErrors();
    }
    
    /* IMPLEMENTING CLASS SHOULD PROVIDE LOGIC FOR THE BELOW METHODS */

    global abstract String getQuery();  
    global abstract void execute(List<sObject> records);
    global virtual void finish() {}

}