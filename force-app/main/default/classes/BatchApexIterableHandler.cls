/*
Batch class to mimic salesforce iterator batch functionality  
**********************************************************
Audit History

**********************************************************
2018-1-9      Prajakta Gadhe            Created 
**********************************************************  
*/

global abstract with sharing class BatchApexIterableHandler extends JobManager implements Database.Batchable<Object> , Database.Stateful, Database.AllowsCallouts {
    
   
    private String errorString = '';     global Iterable<Object> start(Database.BatchableContext BC) {
        Iterable<Object> records;
        try {
            records = getRecords();
            startJobStatus();
        } catch(Exception e) {
            setExceptionError(e);
            return null;
        }
        return records;
    }
    global void execute(Database.BatchableContext BC, List<Object> scope) {
        try {
            execute(scope);
           
        } catch (Exception e) {
            setError(e,scope);
        }
    }
    global void finish(Database.BatchableContext BC) {
        try {
            finish();
            stopJobStatus();
        } catch (Exception e) {
            setExceptionError(e);
        }
        persistErrors();
    }
    
    /* IMPLEMENTING CLASS SHOULD PROVIDE LOGIC FOR THE BELOW METHODS */

    global abstract List<Object> getRecords();  
    global abstract void execute(List<Object> records);
    global virtual void finish() {}

}