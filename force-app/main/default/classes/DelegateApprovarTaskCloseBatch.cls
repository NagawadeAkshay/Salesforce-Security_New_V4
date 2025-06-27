/*
Batch class to close task for delegated approver  
**********************************************************
Audit History

**********************************************************
2017-11-6      Prajakta Gadhe            Created 
**********************************************************  
*/ 
/*In This batch we pass two constructors parameterized constuctor is  used to get user with old delagated approver Id. Suppose delegate is change then task should get close for old delegate and task should get create for new delegate user.In finish method delegatetaskcreation batch is call to create task for new delegate approver.*/
//This Batch will run on daily basis at 10 PM
global with sharing class DelegateApprovarTaskCloseBatch extends BatchApexHandler {
    //private String userId;
    private Map<String, string> userWithOldDelegateUserMap;
    //private String delegateApporverId;
    private Boolean processDelegateApprover;
     global DelegateApprovarTaskCloseBatch(List<User> userWithOldDelegate){ //here we pass instance of user which contains user with its old delegate user
          userWithOldDelegateUserMap = new Map<String, string>(); //here we initialize a map which contains user with its old delegate approver
          for(User u : userWithOldDelegate){
              userWithOldDelegateUserMap.put(u.id, u.DelegatedApproverId);
          }
          processDelegateApprover = true;//if parametrized constructor we call then this becomes true wle false.
    }
     global DelegateApprovarTaskCloseBatch (){
         processDelegateApprover = false;
    }

    global override String getQuery() { // here from getquery method we get all users with their old delegate
    String query;
        if(processDelegateApprover == true){
            //List<String> userIds = new List<String>();
            //userIds.addall(userWithOldDelegateUserMap.keySet()); //here we get all users ids from map
            String userIdstr = '(';
            for(String singleId : userWithOldDelegateUserMap.keySet()){
                userIdstr += '\'' + string.escapeSingleQuotes(singleId) + '\'';
            }
            userIdstr += ')';
            query = 'Select Id,DelegatedApproverId from User where Id in '+userIdstr +' WITH USER_MODE';// here we get all users with their delegate.
        }else{
            query = 'Select Id,DelegatedApproverId from User where isActive= true and EnableDelegate__c =  true And DelegatedApproverId !=null and DelegateTo__c = LAST_N_DAYS:3 WITH USER_MODE';
        }
        return query;
    }
    global override void execute(List<SObject> scope1){   
        try{
            processRecords(scope1);
        }catch(Exception e){
            CustomExceptions.logException(e, true, false);
        }        
    }   

    global override void finish(){
    if(processDelegateApprover == true){
        List<String> userIdList = new List<String>();
        userIdList.addall(userWithOldDelegateUserMap.keySet());// here in finish method we get again user whose delegate is set that is new delegate is set and we create task for that user
        DelegateApprovarTaskCreationBatch creationBtch = new DelegateApprovarTaskCreationBatch (userIdList); 
        Database.executeBatch(creationBtch );
     } 

    }
    private void processRecords(List<User> UserList) {
        List<String> delegateUserIdList = new List<String>();
        List<String> originalUserIdList = new List<String>();
        for(User usr : UserList) {
         if(processDelegateApprover == true){
             delegateUserIdList.add(userWithOldDelegateUserMap.get(usr.id)); //here with get method we get values from that. i.e we get  its delegate user.
         }else{
            delegateUserIdList.add(usr.DelegatedApproverId );
          }
            originalUserIdList.add(usr.id);
        }
    
        List<String> parentIdList = new List<String>();
        List<task> dueTasksList = [SELECT ParentTask__c FROM Task WHERE OwnerId IN : delegateUserIdList And ParentTask__c != null And Status != 'Completed' And  WorkitemId__c != null WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users  
        for(Task taskUser : dueTasksList ){
            parentIdList.add(taskUser.ParentTask__c);
        }
    
        List<task> originalUserTasksList = [SELECT Id FROM Task WHERE id IN  : parentIdList And OwnerId IN : originalUserIdList WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Set<String> parentIdSet =  new Set<String>();
        for(Task parentTask : originalUserTasksList ){
            parentIdSet.add(parentTask.id);
        }
        List<Task> taskListToUpdate =  new List<Task>();
        for(Task ownerTask : dueTasksList) {
            if(parentIdSet.contains(ownerTask.ParentTask__c)){
                if(Schema.sObjectType.Task.fields.Status.isUpdateable()){
                    ownerTask.Status = 'Completed';
                }
                taskListToUpdate.add(ownerTask);
            }
        }
        if(Schema.sObjectType.Task.isUpdateable() && Schema.sObjectType.Task.isAccessible()){
            update as user taskListToUpdate;
        }
    }
 }