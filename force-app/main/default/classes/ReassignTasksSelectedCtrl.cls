public with sharing class ReassignTasksSelectedCtrl extends FlexTableActionHandler {
    
    public override Map<String,Object> clickHandler(){
         Map<String,object> resultMap = new Map<String,object>();
         Id ownerId = urlParams.get('sourceUser');
         Id targetId = urlParams.get('targetUser');
         UserPreferences__c pref = UserPreferences__c.getInstance();
         String appName;
         if(pref != null){
            appName = pref.ActiveAppName__c;
         }else{
            pref = UserPreferences__c.getInstance();
            appName = string.escapeSingleQuotes(pref.ActiveAppName__c);
         } 
         String query = 'select id,IsReassignmentInitiated__c from Task where ownerId=:'+ string.escapeSingleQuotes(ownerId) +'  and status in(\'Not Started\',\'In Progress\') AND CustomAppName__c =:appName and IsReassignmentInitiated__c = false ';         
         if(selectedRecordIds != null && selectedRecordIds.size()>0){
            query += 'and id in: selectedRecordIds WITH USER_MODE'; 
         }else{
             resultMap.put('Error','No records to assign');
             return resultMap;
         }   
         List<Sobject> sobjs = database.query(query);
         if(sobjs.size() == 0){
            resultMap.put('Error','No records to assign');
         }
         
         if(sobjs.size() > 0){
               Set<Id> ids = new Set<Id>();
                  Schema.sObjectType objType ;
                  String sobjName = '';
                  for(Sobject sobj : sobjs){
                     if(String.isBlank(sobjName)){
                        sobjName = sobj.Id.getSobjectType().getDescribe().getName();
                     }
                  
                  objType  = sobj.getSObjectType();
                  SObjectType objectType = ((SObject)Type.forName('Schema', sobjName).newInstance()).getSObjectType();
                     if(objectType.getDescribe().fields.getMap().get('IsReassignmentInitiated__c').getDescribe().isUpdateable()){ 
                        sobj.put('IsReassignmentInitiated__c',true);
                        ids.add(sobj.id);   
                     }
                  }
                  
                  if(objType.getDescribe().isAccessible() && objType.getDescribe().isUpdateable() && sobjs.size() > 0) { //Added for SF review  
                     update as user sobjs; //FLS/ CRUD False +ve used schema method to check isUpdateable
                  }
               TaskReassignmentBatch batch = new TaskReassignmentBatch(ids,ownerId,targetId );
               database.executeBatch(batch);
               resultMap.put('Message', Label.TaskReassignmentNotification);
               String ns = AppUtils.getNamespacePrefix();
           }
         return resultMap;
    }
}