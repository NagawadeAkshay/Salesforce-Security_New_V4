public with sharing class ScheduleApprovalProcessesCacheCtrl {
    public void refreshCache() {
    try{
         Database.executebatch(new ApprovalProcessCachebatch(), 10);
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Cache refresh is in progress. It may take few minutes.'));
    	
       }catch(Exception e){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AppUtils.handleSystemExceptionMsg(e)));
        } 
    }
    
    public void scheduleApprovaHistoryRefreshJob() {
        try{
            System.schedule('ApprovalCacheScheuler', '0 '+DateTime.now().addMinutes(1).minute()+' */1 ? * *', new ApprovalProcessCacheScheduler());
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Cache refresh is scheduled for daily.'));

           }catch(Exception ex){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AppUtils.handleSystemExceptionMsg(ex)));
           }      
    }
}