global with sharing class EmailSenderJobV1 extends BatchApexHandler{
    global override String getQuery() {
    	String query = 'SELECT Id FROM EmailQueue__c WHERE Status__c = \'Queued\' WITH USER_MODE';
       return query;
   }
   
   global override void execute(List<SObject> scope){
   		List<EmailQueue__c> scopeRecs = (List<EmailQueue__c>)scope;
   		EmailSenderJob.processRecords(scopeRecs);
   }
}