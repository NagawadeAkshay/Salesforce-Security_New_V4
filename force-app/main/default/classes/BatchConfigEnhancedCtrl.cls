/*class lavel comments - Refresh Approval Step Cache*/

public with sharing class BatchConfigEnhancedCtrl{
    public String msg {get;set;}
   
    
    public BatchConfigEnhancedCtrl() {
       list<AsyncApexJob> lstJob = [SELECT ApexClassId,ApexClass.Name,CompletedDate,Id,JobItemsProcessed,JobType,LastProcessed,MethodName,NumberOfErrors,ParentJobId,Status FROM AsyncApexJob WHERE Status = 'Queued'  WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
       if(lstJob.size()>0){
           for(AsyncApexJob ajob : lstJob ){
               if(ajob.ApexClass.Name == 'BatchJobEnhancedKicker'){
                   msg= 'BatchJobEnhanced kicker is Running';
               }
           }
       }
       else {
           msg= 'BatchJobEnhanced kicker is Stop';
       }    
    }
    public void refreshCache() {
       try{
           Database.executebatch(new ApprovalProcessCachebatch(), 10);
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Cache refresh is in progress. It may take few minutes.'));
       }catch(Exception e){
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AppUtils.handleSystemExceptionMsg(e)));
       } 
   }
}