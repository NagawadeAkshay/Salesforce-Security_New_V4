/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review ApprovalProcessStepCache is Public R/W
    ****************************************************************************************
*/
global with sharing class TimeBasedAutoApprovalBatch extends BatchApexHandler{
   
   private String query = 'SELECT ApprovalStepId__c,ApprovalDefinitionId__c,TimeForApproval__c FROM ApprovalProcessStepCache__c '+
   'WHERE EnableTimeBaseApproval__c = true and Sobject__r.EnableTimeBaseApproval__c = true WITH USER_MODE';
   
    global override String getQuery() {         
        return query;
      }
      // Batch Size Should Be 1.
      global override void execute(List<SObject> scope1){
          List<ApprovalProcessStepCache__c> scope = (List<ApprovalProcessStepCache__c>)scope1; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
          List<ProcessInstanceNode> prInNode = [SELECT ProcessInstanceId FROM ProcessInstanceNode
                                                    WHERE ProcessNodeId = :scope.get(0).ApprovalStepId__c 
                                                    and NodeStatus = 'Pending' WITH USER_MODE];
                                                 
           if(prInNode.size() > 0){
               List<ProcessInstanceWorkitem> piwItems = new List<ProcessInstanceWorkitem>();
               List<Id> prInstIdList = new List<Id>(); 
               for(ProcessInstanceNode pNode : prInNode){
                    prInstIdList.add(pNode.ProcessInstanceId); 
               } //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                  piwItems =[ SELECT Id,ElapsedTimeInDays,ElapsedTimeInHours,ElapsedTimeInMinutes,ProcessInstanceId 
                                    FROM  ProcessInstanceWorkitem 
                            WHERE ProcessInstanceId in :prInstIdList WITH USER_MODE limit 20];  
               
               
                      //json deserialize
                      TimeBasedApproval timeBaseApproval = (TimeBasedApproval)JSON.deserialize(scope.get(0).TimeForApproval__c, TimeBasedApproval.Class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
                      String msg= System.Label.AutoApprovalMsg;
                      List<String> approvalInstanceIds = new List<String>();
                          for(ProcessInstanceWorkitem piwItem : piwItems){
                              if(timeBaseApproval.hours != null && Double.valueOf(timeBaseApproval.hours) < piwItem.ElapsedTimeInHours){
                                  ApprovalDecisionCtrl.approvaRequest(piwItem,msg);
                              }
                              else if(timeBaseApproval.min != null && Double.valueOf(timeBaseApproval.min) < piwItem.ElapsedTimeInMinutes){
                                  ApprovalDecisionCtrl.approvaRequest(piwItem,msg);                       
                              }
                              else if(timeBaseApproval.day != null && Double.valueOf(timeBaseApproval.day) < piwItem.ElapsedTimeInDays){
                                  ApprovalDecisionCtrl.approvaRequest(piwItem,msg);                        
                              }               
                              approvalInstanceIds.add(piwItem.Id);                    
                          }
                      
               			// Closing Task For AuTo Approval 
               			if(approvalInstanceIds != null && approvalInstanceIds.size()>0){
                  			ApprovalDecisionCtrl.closePendingTaskWithoutFuture(JSON.serialize(approvalInstanceIds));             
           				}
                }                                                    
      }
      
      /*
        This is a Wrapper class for the TimeBasedApproval.
      */
    
    public with sharing class TimeBasedApproval{
      public Date dateVal{get;set;}
      public String hours{get;set;}
      public String min{get;set;}
      public String day{get;set;}
    }
}