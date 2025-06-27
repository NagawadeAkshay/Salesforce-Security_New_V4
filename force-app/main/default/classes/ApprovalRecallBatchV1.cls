global with sharing class ApprovalRecallBatchV1  extends BatchApexHandler{
    global override String getQuery() {
       return ApprovalRecallBatch.query;
   }
   
   global override void execute(List<SObject> scope){
   		List<SobjectConfig__c> scopeRecs = (List<SobjectConfig__c>)scope;
   		ApprovalRecallBatch.processRecords(scopeRecs);
   }
}