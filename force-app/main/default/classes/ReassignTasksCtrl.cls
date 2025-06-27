public with sharing class ReassignTasksCtrl extends FlexTableActionHandler {
    
    public override Map<String,Object> clickHandler(){
         Map<String,object> resultMap = new Map<String,object>();
         Id ownerId = urlParams.get('sourceUser');
         Id targetId = urlParams.get('targetUser');
         String phaseName = urlParams.get('phaseName');
         UserPreferences__c pref = UserPreferences__c.getInstance();
         String appName;
         if(pref != null){
            appName = pref.ActiveAppName__c;
         }else{
            pref = UserPreferences__c.getInstance();
            appName = string.escapeSingleQuotes(pref.ActiveAppName__c);
         } 
         String query = 'select id,IsReassignmentInitiated__c from Task where ownerId=: '+ string.escapeSingleQuotes(ownerId) +' and status in(\'Not Started\',\'In Progress\') AND CustomAppName__c =:appName and IsReassignmentInitiated__c = false ';         
         if(!String.isEmpty(phaseName)){
            query += 'and PhaseName__c like \'% '+ string.escapeSingleQuotes(phaseName) + '%\''+' WITH USER_MODE'; 
         }   
         List<Sobject> sobjs = database.query(query);//Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
         if(sobjs.size() == 0){
            resultMap.put('Error','No records to assign');
         }
         if(sobjs.size() > 0){
         Set<Id> ids = new Set<Id>();
         String sobjName = '';
         for(Sobject sobj : sobjs){
            if(String.isBlank(sobjName)){
               sobjName = sobj.Id.getSobjectType().getDescribe().getName();
            }
                  SObjectType objectType = ((SObject)Type.forName('Schema', sobjName).newInstance()).getSObjectType();
                  if(objectType.getDescribe().fields.getMap().get('IsReassignmentInitiated__c').getDescribe().isUpdateable()){
             		sobj.put('IsReassignmentInitiated__c',true);
                  } 
                
             ids.add(sobj.id);   
         }
         if(AppUtils.isObjectAccessible(sobjName) && AppUtils.isObjectUpdateable(sobjName)) { //Added for SF review  
            update as user sobjs; //FLS/ CRUD False +ve with the help of apputil we have performed check
         }
         TaskReassignmentBatch batch = new TaskReassignmentBatch(ids,ownerId,targetId );
         database.executeBatch(batch);
         resultMap.put('Message', Label.TaskReassignmentNotification);
         String ns = AppUtils.getNamespacePrefix();
         /*if(selectedRecordIds!=null && selectedRecordIds.size() == 0){
            resultMap.put('PageReference', '/apex/'+ns+'TaskReassignment');
            return resultMap;
         }*/
         }
         return resultMap;
    }
}