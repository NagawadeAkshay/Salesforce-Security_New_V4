/**
    **********************************************************************************************************************
    Audit History
    **********************************************************************************************************************
    2019-07-1       Amol Salve           Created
    **********************************************************************************************************************
    Purpose :This is helper class for WBSTaskScheduleTrigger..
    **********************************************************************************************************************  
*/ 
global with sharing class WBSTaskScheduleTriggerHelper {

    public static Map<String, Map<Id,Id>> mapOfwbsIdVSWBSMap = new map<String, Map<Id,Id>>();
    public static void afterInsertWbsTaskSchedule(Map<Id, WBSTaskSchedule__c> newIdVsWbsTaskScheduleMap){
        Map<String, Map<Id,Id>> mapOfUpdatedFieldMap = new Map<String, Map<Id,Id>>{'Progress' => new Map<Id,Id>(),
                                                                                    'Date' => new Map<Id,Id>()};
        if(newIdVsWbsTaskScheduleMap != null && newIdVsWbsTaskScheduleMap.keySet().size() > 0){
            Set<Id> parentWbstaskIdSet = new Set<Id>();
            List<WBSTaskSchedule__c> wbsRecordList = new List<WBSTaskSchedule__c>();
            for(Id newObjId : newIdVsWbsTaskScheduleMap.keySet()){
                if(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c != null){
                    parentWbstaskIdSet.add(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);
                    mapOfUpdatedFieldMap.get('Progress').put(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c,newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);    
                    mapOfUpdatedFieldMap.get('Date').put(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c,newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);                        
                }                  
            }
            if(parentWbstaskIdSet.size() > 0){
                getUpdatedChangeFieldVsWBSMap(parentWbstaskIdSet, mapOfUpdatedFieldMap, null);
            }
        }
    }   
    
    public static void beforeInsertWbsTaskSchedule(List<WBSTaskSchedule__c> wbsTaskScheduleList){
        if(wbsTaskScheduleList != null && wbsTaskScheduleList.size() > 0 ){
            Date todaysDate = system.today();
            for(WBSTaskSchedule__c wbsObj : wbsTaskScheduleList){
                if(wbsObj.EndDate__c < todaysDate){                     
                    wbsObj.Status__c = 'Incomplete';
                }
            }       
        }
    }
    
    public static void beforeUpdateWbsTaskSchedule(Map<Id, WBSTaskSchedule__c> newIdVsWbsTaskScheduleMap, Map<Id, WBSTaskSchedule__c> oldIdVsWbsTaskScheduleMap){
        if(newIdVsWbsTaskScheduleMap != null && newIdVsWbsTaskScheduleMap.keySet().size() > 0 &&
           oldIdVsWbsTaskScheduleMap != null && oldIdVsWbsTaskScheduleMap.keySet().size() > 0){
            Map<decimal, String> mapOfStatus = new Map<decimal, String>{Integer.ValueOf(System.label.WBSStatus_New) => 'New', Integer.ValueOf(System.label.WBSStatus_Inprogress) => 'Inprogress',
                                                                        Integer.ValueOf(System.label.WBSStatus_Completed) => 'Completed'};
            List<decimal> keyList = new List<decimal>(mapOfStatus.keySet());
            Date todaysDate = system.today();
            for(Id newObjId : newIdVsWbsTaskScheduleMap.keySet()){
                if(oldIdVsWbsTaskScheduleMap.containsKey(newObjId)){
                    if(newIdVsWbsTaskScheduleMap.get(newObjId).ProgressIndicator__c != oldIdVsWbsTaskScheduleMap.get(newObjId).ProgressIndicator__c || 
                       newIdVsWbsTaskScheduleMap.get(newObjId).EndDate__c != oldIdVsWbsTaskScheduleMap.get(newObjId).EndDate__c){
                        for(Integer i=0; i< keyList.size(); i++){
                            if(newIdVsWbsTaskScheduleMap.get(newObjId).EndDate__c < todaysDate  && newIdVsWbsTaskScheduleMap.get(newObjId).ProgressIndicator__c != 100.00){
                                
                                newIdVsWbsTaskScheduleMap.get(newObjId).Status__c = 'Incomplete';
                            }
                            else{
                                if(newIdVsWbsTaskScheduleMap.get(newObjId).ProgressIndicator__c <= keyList[i]){
                                newIdVsWbsTaskScheduleMap.get(newObjId).Status__c = mapOfStatus.get(keyList[i]);
                                break;
                                }
                            }
                        }
                    }
                }
            }       
        }
    }
    public static void afterUpdateWbsTaskSchedule(Map<Id, WBSTaskSchedule__c> newIdVsWbsTaskScheduleMap, Map<Id, WBSTaskSchedule__c> oldIdVsWbsTaskScheduleMap){
        if(newIdVsWbsTaskScheduleMap != null && newIdVsWbsTaskScheduleMap.keySet().size() > 0 &&
           oldIdVsWbsTaskScheduleMap != null && oldIdVsWbsTaskScheduleMap.keySet().size() > 0){
            Map<String, Map<Id,Id>> mapOfUpdatedFieldMap = new Map<String, Map<Id,Id>>{'Progress' => new Map<Id,Id>(),
                                                                                        'Date' => new Map<Id,Id>()};
            Set<Id> parentWbstaskIdSet = new Set<Id>();
            List<WBSTaskSchedule__c> wbsRecordList = new List<WBSTaskSchedule__c>();
            for(Id newObjId : newIdVsWbsTaskScheduleMap.keySet()){
                if(oldIdVsWbsTaskScheduleMap.containsKey(newObjId)){
                    if(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c != null){
                        if(newIdVsWbsTaskScheduleMap.get(newObjId).ProgressIndicator__c != oldIdVsWbsTaskScheduleMap.get(newObjId).ProgressIndicator__c){
                        
                            parentWbstaskIdSet.add(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);
                            mapOfUpdatedFieldMap.get('Progress').put(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c, newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);                           
                        }                                  
                       if((newIdVsWbsTaskScheduleMap.get(newObjId).StartDate__c != oldIdVsWbsTaskScheduleMap.get(newObjId).StartDate__c) ||
                            (newIdVsWbsTaskScheduleMap.get(newObjId).EndDate__c != oldIdVsWbsTaskScheduleMap.get(newObjId).EndDate__c) ){
                                parentWbstaskIdSet.add(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);
                                mapOfUpdatedFieldMap.get('Date').put(newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c, newIdVsWbsTaskScheduleMap.get(newObjId).ParentWBSTaskSchedule__c);                           
                        }
                    }
                }           
            }
            if(parentWbstaskIdSet.size() > 0){
                getUpdatedChangeFieldVsWBSMap(parentWbstaskIdSet, mapOfUpdatedFieldMap, null);
            }
        }
    }
    
    public static  void beforeDeleteWbsTaskSchedule(Map<Id, WBSTaskSchedule__c> idVsWbsTaskScheduleMap){ 
        if(idVsWbsTaskScheduleMap != null && idVsWbsTaskScheduleMap.keySet().size() > 0){
            Set<Id> parentWbstaskIdSetForParogress = new Set<Id>(); 
            Map<String, Map<Id,Id>> mapOfUpdatedFieldMap = new Map<String, Map<Id,Id>>{'Progress' => new Map<Id,Id>(),
                                                                                       'Date' => new Map<Id,Id>()};
            List<WBSTaskSchedule__c> wbsRecordList = new List<WBSTaskSchedule__c>();
            for(Id WbsTaskId : idVsWbsTaskScheduleMap.keySet()){
                if(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c != null){
                    parentWbstaskIdSetForParogress.add(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c);
                    mapOfUpdatedFieldMap.get('Progress').put(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c, idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c);
                    mapOfUpdatedFieldMap.get('Date').put(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c, idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c);   
                }       
            }
            if(parentWbstaskIdSetForParogress.size() > 0){
                mapOfwbsIdVSWBSMap.putAll(mapOfUpdatedFieldMap);
                getUpdatedChangeFieldVsWBSMap(parentWbstaskIdSetForParogress, mapOfUpdatedFieldMap,idVsWbsTaskScheduleMap);
            }
            List<WBSTaskSchedule__c> wbsList = new List<WBSTaskSchedule__c>();
            if (Schema.sObjectType.WBSTaskSchedule__c.isAccessible()) {
                wbsList = [SELECT Id, ParentWBSTaskSchedule__c
                                                FROM WBSTaskSchedule__c      
                                                WHERE ParentWBSTaskSchedule__c IN: idVsWbsTaskScheduleMap.keySet() WITH USER_MODE];
            }
            if(wbsList.size() > 0){
                if(Schema.sObjectType.WBSTaskSchedule__c.isDeletable())
                delete as user wbsList;
            }
        }
    }
    
    public static  void afterUndeleteWbsTaskSchedule(Map<Id, WBSTaskSchedule__c> idVsWbsTaskScheduleMap){   
        if(idVsWbsTaskScheduleMap != null && idVsWbsTaskScheduleMap.keySet().size() > 0){
            Set<Id> parentWbstaskIdSet = new Set<Id>();
            Map<String, Map<Id,Id>> mapOfUpdatedFieldMap = new Map<String, Map<Id,Id>>{'Progress' => new Map<Id,Id>(),
                                                                                       'Date' => new Map<Id,Id>()};
            
			String relatedobj;       
            Set<Id> relatedobjIDSet = new set<Id>(); 
			List<WBSTaskSchedule__c> wbsRecordList = new List<WBSTaskSchedule__c>();
            for(Id WbsTaskId : idVsWbsTaskScheduleMap.keySet()){
                if(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c != null){
                    parentWbstaskIdSet.add(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c);
                    mapOfUpdatedFieldMap.get('Progress').put(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c, idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c);
                    mapOfUpdatedFieldMap.get('Date').put(idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c, idVsWbsTaskScheduleMap.get(WbsTaskId).ParentWBSTaskSchedule__c);
                }
				if(idVsWbsTaskScheduleMap.get(WbsTaskId).RelatedSobject__c!=NULL )
                {
                    relatedobj = idVsWbsTaskScheduleMap.get(WbsTaskId).RelatedSobject__c;
                    if(idVsWbsTaskScheduleMap.get(WbsTaskId).get(relatedobj)!= null)
                    {
                        relatedobjIDSet.add(string.valueof( idVsWbsTaskScheduleMap.get(WbsTaskId).get(relatedobj)));
                    }
                }
            }
            if(parentWbstaskIdSet.size() > 0){
                getUpdatedChangeFieldVsWBSMap(parentWbstaskIdSet, mapOfUpdatedFieldMap, null);
            } 
			if(relatedobjIDSet.size() > 0){
                String soqlQuery = 'SELECT Id, ParentWBSTaskSchedule__c, WBSNumber__c ,' + string.escapeSingleQuotes(relatedobj) + ' FROM WBSTaskSchedule__c WHERE '+ string.escapeSingleQuotes(relatedobj)+' IN: relatedobjIDSet ORDER BY CreatedDate';
                if (Schema.sObjectType.WBSTaskSchedule__c.isAccessible()) {
                    wbsRecordList = Database.query(soqlQuery, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                }
               updateWbsTaskScheduleID(wbsRecordList );
            }
        }
    }
	
	public static  void afterdeleteWbsTaskSchedule(Map<Id, WBSTaskSchedule__c> idVsWbsTaskScheduleMap){   
        Set<id> relatedobjIDSet= new set<id>();
        List<WBSTaskSchedule__c> wbsRecordList = new List<WBSTaskSchedule__c>();
        
        if(idVsWbsTaskScheduleMap != null && idVsWbsTaskScheduleMap.keySet().size() > 0){            
            String relatedobj;
            for(Id WbsTaskId : idVsWbsTaskScheduleMap.keySet()){
                if(idVsWbsTaskScheduleMap.get(WbsTaskId).RelatedSobject__c!=NULL )
                {
                    relatedobj = idVsWbsTaskScheduleMap.get(WbsTaskId).RelatedSobject__c;
                    if(idVsWbsTaskScheduleMap.get(WbsTaskId).get(relatedobj)!= null)
                    {
                        relatedobjIDSet.add(String.escapeSingleQuotes(string.valueof( idVsWbsTaskScheduleMap.get(WbsTaskId).get(relatedobj))));
                    }
                }
                
            }
            
            if(relatedobjIDSet.size() > 0){
                String soqlQuery = 'SELECT Id, ParentWBSTaskSchedule__c, WBSNumber__c ,' + string.escapeSingleQuotes(relatedobj) + ' FROM WBSTaskSchedule__c WHERE '+ string.escapeSingleQuotes(relatedobj)+' IN: relatedobjIDSet ORDER BY CreatedDate';
                if (Schema.sObjectType.WBSTaskSchedule__c.isAccessible()) {
                    wbsRecordList = Database.query(soqlQuery, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                }
                updateWbsTaskScheduleID(wbsRecordList );
            }
            
        }
        
    }
    
    public static void getUpdatedChangeFieldVsWBSMap(Set<Id> parentWbstaskIdSet, Map<String, Map<Id,Id>> mapOfUpdatedFieldMap, Map<Id, WBSTaskSchedule__c> idVsWbsTaskScheduleMap){
        if(parentWbstaskIdSet != null && parentWbstaskIdSet.size() > 0 && mapOfUpdatedFieldMap != null && mapOfUpdatedFieldMap.keyset().size() > 0){
            List<WBSTaskSchedule__c> wbsRecordList = new List<WBSTaskSchedule__c>();
            map <Id, WBSTaskSchedule__c> updatedMap = new map <Id, WBSTaskSchedule__c>();
            Map<String, List<WBSTaskSchedule__c>> mapOfFieldVsListOfWBS = new Map<String, List<WBSTaskSchedule__c>>{'Progress' => new list<WBSTaskSchedule__c>(),
                                                                                                                    'Date' => new list<WBSTaskSchedule__c>()};
            List<WBSTaskSchedule__c> wbstaskList = new List<WBSTaskSchedule__c>();
            if(Schema.sObjectType.WBSTaskSchedule__c.isAccessible()) {                                                                                                    
                wbstaskList = [SELECT Id, ProgressIndicator__c,
                                                            StartDate__c,
                                                            EndDate__c,
                                                           ( SELECT Id,
                                                                    ProgressIndicator__c,
                                                                    StartDate__c,
                                                                    EndDate__c
                                                             FROM WBS_Task_Schedules__r)  
                                                    FROM WBSTaskSchedule__c 
                                                    WHERE Id IN: parentWbstaskIdSet WITH USER_MODE];
            }
            if(wbstaskList.size() > 0){
                for(WBSTaskSchedule__c wbsObj : wbstaskList){
                    if(mapOfUpdatedFieldMap.get('Progress').containsKey(wbsObj.Id)){
                        mapOfFieldVsListOfWBS.get('Progress').add(wbsObj);
                    }
                    if(mapOfUpdatedFieldMap.get('Date').containsKey(wbsObj.Id)){
                        mapOfFieldVsListOfWBS.get('Date').add(wbsObj);
                    }
                }
            }
            if(mapOfFieldVsListOfWBS.get('Progress').size() > 0){
                updatedMap.putAll(updateParentProgress(mapOfFieldVsListOfWBS.get('Progress'),idVsWbsTaskScheduleMap));
            } 
            if(mapOfFieldVsListOfWBS.get('Date').size() > 0){
                updatedMap.putAll(updateParentDate(mapOfFieldVsListOfWBS.get('Date'), updatedMap, idVsWbsTaskScheduleMap));
            } 
            if(updatedMap.values().size() > 0){
                if(Schema.SObjectType.WBSTaskSchedule__c.isUpdateable()){
                    update as user updatedMap.values();
                }
            }
        }
    }
    
    public static map <Id, WBSTaskSchedule__c> updateParentProgress(List<WBSTaskSchedule__c> wbstaskList,Map<Id, WBSTaskSchedule__c> idVsWbsTaskScheduleMap){
        if(wbstaskList != null && wbstaskList.size() > 0){
            map <Id, WBSTaskSchedule__c> updateWBSTaskScheduleMap = new map <Id, WBSTaskSchedule__c>();
            for(WBSTaskSchedule__c wbstaskObj : wbstaskList){
                decimal progress = 0.0;
                decimal progressObj = 0.0;
                for(WBSTaskSchedule__c childwbsTaskObj : wbstaskObj.WBS_Task_Schedules__r){
                    if(idVsWbsTaskScheduleMap != null){
                        if(!idVsWbsTaskScheduleMap.containsKey(childwbsTaskObj.Id)){
                            progress = progress + childwbsTaskObj.ProgressIndicator__c;                             
                        }
                    }
                    else{
                        progress = progress + childwbsTaskObj.ProgressIndicator__c;
                    }                   
                }
                if(wbstaskObj.WBS_Task_Schedules__r.size() > 1 && idVsWbsTaskScheduleMap != null){
                    progressObj = progress / (wbstaskObj.WBS_Task_Schedules__r.size()-1);                      
                }
                else{
                    progressObj = progress / wbstaskObj.WBS_Task_Schedules__r.size();
                }
                wbstaskObj.ProgressIndicator__c = progressObj;
                updateWBSTaskScheduleMap.put(wbstaskObj.id, wbstaskObj);
            }
            if(updateWBSTaskScheduleMap.keyset().size() > 0){
                return updateWBSTaskScheduleMap;
            }                        
        }  
        return null;
    }
    
    public static map <Id, WBSTaskSchedule__c> updateParentDate(List<WBSTaskSchedule__c> wbstaskList,Map<Id, WBSTaskSchedule__c> idVsWbsTaskScheduleMap,Map<Id, WBSTaskSchedule__c> idVsWbsTaskMap){
        if(wbstaskList != null && wbstaskList.size() > 0){                                                                                          
            map <Id, WBSTaskSchedule__c> updateWBSTaskScheduleMap = new map <Id, WBSTaskSchedule__c>();
            for(WBSTaskSchedule__c wbstaskObj : wbstaskList){
                if(idVsWbsTaskScheduleMap != null && idVsWbsTaskScheduleMap.keyset().size() > 0){
                    if(idVsWbsTaskScheduleMap.containskey(wbstaskObj.id)){
                        wbstaskObj = idVsWbsTaskScheduleMap.get(wbstaskObj.id);
                    }
                }
                if(mapOfwbsIdVSWBSMap != null && mapOfwbsIdVSWBSMap.keyset().size() > 0){
                    if(mapOfwbsIdVSWBSMap.get('Date').containsKey(wbstaskObj.Id)){
                        if(Schema.sObjectType.WBSTaskSchedule__c.fields.StartDate__c.isUpdateable() && Schema.sObjectType.WBSTaskSchedule__c.fields.EndDate__c.isUpdateable()){
                        wbstaskObj.StartDate__c = null;
                        wbstaskObj.EndDate__c = null;
                    }
                }
                }
                for(WBSTaskSchedule__c childwbsTaskObj : wbstaskObj.WBS_Task_Schedules__r){                        
                    boolean  isDeleted = false;
                    if(idVsWbsTaskMap != null && idVsWbsTaskMap.keyset().size() > 0){
                        if(idVsWbsTaskMap.containsKey(childwbsTaskObj.Id)){
                            isDeleted = true;
                        }
                    }
                    if(!isDeleted){
                        if(childwbsTaskObj.StartDate__c != null && Schema.sObjectType.WBSTaskSchedule__c.fields.StartDate__c.isUpdateable()){
                            if(wbstaskObj.StartDate__c != null){
                                if(childwbsTaskObj.StartDate__c < wbstaskObj.StartDate__c){
                                    wbstaskObj.StartDate__c = childwbsTaskObj.StartDate__c;
                                }
                            }
                            else{
                                wbstaskObj.StartDate__c = childwbsTaskObj.StartDate__c;
                            }
                        }
                        if(childwbsTaskObj.EndDate__c != null && Schema.sObjectType.WBSTaskSchedule__c.fields.EndDate__c.isUpdateable()){
                            if(wbstaskObj.EndDate__c != null){
                                if(childwbsTaskObj.EndDate__c > wbstaskObj.EndDate__c){
                                    wbstaskObj.EndDate__c = childwbsTaskObj.EndDate__c;
                                }
                            }
                            else{
                                wbstaskObj.EndDate__c = childwbsTaskObj.EndDate__c;
                            }
                        }
                    }                   
                }
                updateWBSTaskScheduleMap.put(wbstaskObj.Id, wbstaskObj);
            }
            if(updateWBSTaskScheduleMap.keyset().size() > 0){
                return updateWBSTaskScheduleMap;
            }          
        }
        return null;
    }  

public static  void updateWbsTaskScheduleID(List<WBSTaskSchedule__c> wbsRecordList)
    {
        if(wbsRecordList.size()!=0){
            Map<id,List<WBSTaskSchedule__c>> existingWbsIdtoChildRecordMap = new Map<id,List<WBSTaskSchedule__c>>();
            List<WBSTaskSchedule__c> updateWbsRecordList = new List<WBSTaskSchedule__c>();
            Map<String , String> parentIndexToCurrentChildIndexMap= new Map<String , String>();
            Map<id, String> wbsIDtoWbsNoMap = new Map<id, String> ();
            Map<id, String> idToOldwbsNoMap= new Map<id, String>();
            Map<id, String> idToNewbsNoMap= new Map<id, String>();
            
            integer updateWbsNo = 1;
            
            for(WBSTaskSchedule__c WbsTask : wbsRecordList){
                List<WBSTaskSchedule__c> relatedChildWbsRecordList ;
                if(WbsTask.ParentWBSTaskSchedule__c ==null){
                    //parent level
                    relatedChildWbsRecordList = new List<WBSTaskSchedule__c>();
                    existingWbsIdtoChildRecordMap.put(WbsTask.id,relatedChildWbsRecordList);
                    idToOldwbsNoMap.put(WbsTask.id,WbsTask.WBSNumber__c);
                    if(Schema.SObjectType.WBSTaskSchedule__c.fields.WBSNumber__c.isUpdateable()){
                        if(updateWbsNo < 10){
                            WbsTask.WBSNumber__c = '0'+String.valueOf(updateWbsNo);
                        }else{
                            WbsTask.WBSNumber__c = String.valueOf(updateWbsNo);
                        }
                    }
                    idToNewbsNoMap.put(WbsTask.id, WbsTask.WBSNumber__c);
                    
                    wbsIDtoWbsNoMap.put(WbsTask.id,WbsTask.WBSNumber__c);
                    parentIndexToCurrentChildIndexMap.put(WbsTask.WBSNumber__c,'#');
                    updateWbsNo = updateWbsNo + 1;
                }
                else{
                    relatedChildWbsRecordList = existingWbsIdtoChildRecordMap.get(WbsTask.ParentWBSTaskSchedule__c);
                    relatedChildWbsRecordList.add(WbsTask);
                    idToOldwbsNoMap.put(WbsTask.id,WbsTask.WBSNumber__c);
                    String previousChildWbsNo = parentIndexToCurrentChildIndexMap.get(wbsIDtoWbsNoMap.get(WbsTask.ParentWBSTaskSchedule__c));
                    integer currentWbsNo;
                    if(Schema.SObjectType.WBSTaskSchedule__c.fields.WBSNumber__c.isUpdateable()){
                        if(previousChildWbsNo.indexOf('#') !=-1){//if contains # i.e no previous child
                            WbsTask.WBSNumber__c = wbsIDtoWbsNoMap.get(WbsTask.ParentWBSTaskSchedule__c)+'.1';
                        }else{
                            currentWbsNo= Integer.valueOf(previousChildWbsNo.substringAfterLast('.'))+1;
                            WbsTask.WBSNumber__c = wbsIDtoWbsNoMap.get(WbsTask.ParentWBSTaskSchedule__c)+'.'+String.valueOf(currentWbsNo);
                        }
                    }
                    wbsIDtoWbsNoMap.put(WbsTask.id,WbsTask.WBSNumber__c);
                    parentIndexToCurrentChildIndexMap.put(WbsTask.WBSNumber__c,'#');
                    parentIndexToCurrentChildIndexMap.put(wbsIDtoWbsNoMap.get(WbsTask.ParentWBSTaskSchedule__c),WbsTask.WBSNumber__c);
                    idToNewbsNoMap.put(WbsTask.id,WbsTask.WBSNumber__c);
                }
                
                existingWbsIdtoChildRecordMap.put(WbsTask.id,relatedChildWbsRecordList);
                
                //To avoid useless updations of records if its WBSNumber__c value remain same
                if(idToOldwbsNoMap.get(WbsTask.id) != idToNewbsNoMap.get(WbsTask.id))
                {
                    updateWbsRecordList.add(WbsTask);
                }
                
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.isUpdateable()){
                update as user updateWbsRecordList;
            }
        }
    }	
}