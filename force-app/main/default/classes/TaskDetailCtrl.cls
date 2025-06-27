global with sharing class TaskDetailCtrl{

    @RemoteAction
    global static List<String> getData(String recordId,String taskId,Boolean  noStartMessage) {
        List<String> result = new List<String>();
        return result;
    }
    
    @RemoteAction
    global static String completeTask(String recordId) {
        List<Task> task =[select id,status,startdate__c,activitydate from Task where id =:recordId WITH USER_MODE limit 1];
        if(task.size () > 0){
          if(Schema.SObjectType.Task.fields.Status.isUpdateable()){
                task[0].status = 'Completed';
          }
                if(Schema.sObjectType.Task.isUpdateable())
                update as user task;
                return 'Task completed successfully!';
        }
        return null;
    }

}