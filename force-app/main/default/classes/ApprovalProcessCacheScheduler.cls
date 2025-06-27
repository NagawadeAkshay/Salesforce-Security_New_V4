global with sharing class ApprovalProcessCacheScheduler  implements Schedulable, Database.AllowsCallouts{
    String sessionId;
    public ApprovalProcessCacheScheduler() {
    
    }
    
    public ApprovalProcessCacheScheduler(String sessionId) {
    	this.sessionId = sessionId;
    	}
    global void execute(SchedulableContext SC) {
    	database.executebatch(new ApprovalProcessCachebatch(), 10);
    }
}