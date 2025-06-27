global with sharing class WBSCtrl{
    @RemoteAction
    global static Map<String,Object> fetchMiniLayout(Id referenceId){
        return MiniLayoutController.getLayout(referenceId);
    }

    @RemoteAction
    global static List<SelectOption> fetchStatusField(String wbsGridName){        
        return null;
    }

    @RemoteAction
    global static Map<String,Object> getWBSDataMap(String paramMapString){
        Map<String,Object> paramMap = new Map<String,Object>(); 
        paramMap = (Map<string,object>)JSON.deserializeUntyped(paramMapString);                        
        String wbsGridName = String.valueOf(paramMap.get('WBSGridName'));
        String parametersMapString = String.valueOf(paramMap.get('ParametersMap'));
        Map<String,String> parametersMap = new Map<String,String>(); 
        if(parametersMapString != null && parametersMapString != ''){
            parametersMap = (Map<string,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(parametersMapString),Map<string,String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
        }        
        Map<String,Object> retVal = new Map<String,Object>();
        retVal = WBSCtrl.getWBSData(wbsGridName,parametersMap );
        return retVal;
    }

    public static Map<String,Object> getWBSData(String wbsGridName,Map<String,String> parametersMap){
        Map<String,Object> retVal = new Map<String,Object>();
        retVal.put('Namespace',AppUtils.getNamespacePrefix());
        return retVal;
    }    
    
    /*
    Method  :   executeClass()
    Purpose :   This method dynamically executes a class.
    */
    @RemoteAction
    global static Map<String,Object> executeClass(String className,String keyValueMapString) {
        Map<String, Object> result = new Map<String, Object>();        
        try{
            Map<String,Object> keyValueMap = (Map<String,Object>)JSON.deserializeUntyped(keyValueMapString);
			Map<String,Object> resultMap = new Map<String,Object>();			
			if(keyValueMap.get('eventMethodname') == 'onAfterTaskAdd'){
				resultMap =  onAfterTaskAddHandler(keyValueMap);   
			}else if(keyValueMap.get('eventMethodname') == 'onAfterTaskUpdate'){
				resultMap =  onAfterTaskUpdateHandler(keyValueMap);   
			}else if(keyValueMap.get('eventMethodname') == 'onAfterTaskDelete'){
				resultMap =  onAfterTaskDeleteHandler(keyValueMap);   
			}
            result.put('ResultMap',resultMap);
        }
        catch(Exception e){
            result.put('Error',AppUtils.handleSystemExceptionMsg(e.getMessage()));
        }
        return result; 
    }  
    
    @RemoteAction
    global static Map<String,Object> fetchAutoSuggestData(String fieldName,String sobjName,String searchTerm,String filterClause) {
        Map<String, Object> result = new Map<String, Object>();
        
        String queryString;
        if(searchTerm != null && searchTerm != ''){
            filterClause = filterClause == null | filterClause == '' ? '' : ' AND ' + AppUtils.parseWhereClause(filterClause);
            searchTerm = '%' + String.escapeSingleQuotes(searchTerm) + '%';
            queryString = 'SELECT ID, ' + String.escapeSingleQuotes(fieldName) + ' FROM ' + String.escapeSingleQuotes(sobjName) + ' WHERE ' + String.escapeSingleQuotes(fieldName) + ' LIKE : searchTerm ' + filterClause +  ' ORDER BY ' + String.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
        }else{
            filterClause = filterClause == null || filterClause == '' ? '': ' WHERE ' + AppUtils.parseWhereClause(filterClause);
            queryString = 'SELECT ID, ' + String.escapeSingleQuotes(fieldName) + ' FROM ' + String.escapeSingleQuotes(sobjName) + filterClause +  ' ORDER BY ' + String.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
        }
        List<LookupData> sobjList = new List<LookupData>();
        if(AppUtils.isObjectAccessible(sobjName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
            for( Sobject sObj : Database.query(queryString, AccessLevel.USER_MODE)){//NOPMD SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes,Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
                sobjList.add(new LookupData(sObj.get('Id'),sObj.get(fieldName)));
            }
        }
        result.put('SobjList',sobjList);
        return result;
    }

    @RemoteAction
    global static Map<String,Object> fetchAutoSuggestDataWithParams(String fieldName,String sobjName,String searchTerm,String filterClause,String paramMapString) {
        Map<String, Object> result = new Map<String, Object>();
        Map<String,String> paramMap =  (Map<String,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(paramMapString),Map<String,String>.class);   // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
		List<User> userList = [SELECT Id, OrganizationId__c FROM User WHERE Id = : UserInfo.getUserId() WITH USER_MODE];
	   WBSCtrl wbsCtrl = new WBSCtrl(); 
        String queryString;
        Id orgId = userList[0].OrganizationId__c;
        if(orgId != null){
			if(searchTerm != null && searchTerm != ''){
				filterClause = filterClause == null | filterClause == '' ? '' : ' AND ' + AppUtils.parseWhereClause(filterClause);            
				filterClause = wbsCtrl.getFilterClauseString(filterClause, paramMap);
				searchTerm = '%' + String.escapeSingleQuotes(searchTerm) + '%';
				queryString = 'SELECT ID, AccountId, ' + String.escapeSingleQuotes(fieldName) + ' FROM Contact' +  + ' WHERE ' +  String.escapeSingleQuotes(fieldName) + ' LIKE :searchTerm AND AccountId =:orgId ORDER BY ' + String.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
			} else {
				filterClause = filterClause == null || filterClause == '' ? '': ' WHERE ' + AppUtils.parseWhereClause(filterClause);           
                filterClause = wbsCtrl.getFilterClauseString(filterClause, paramMap);                
				queryString = 'SELECT ID, AccountId, ' + String.escapeSingleQuotes(fieldName) + ' FROM Contact' +  + ' WHERE  AccountId =:orgId ORDER BY ' + String.escapeSingleQuotes(fieldName) + ' ASC LIMIT 1000';
			}
			List<LookupData> sobjList = new List<LookupData>();
            if(Schema.sObjectType.Contact.isAccessible()){
                for( Sobject sObj : Database.query(queryString, AccessLevel.USER_MODE)){//NOPMD SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes,Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
                    sobjList.add(new LookupData(sObj.get('Id'),sObj.get(fieldName)));
                }
            }
			result.put('SobjList',sobjList);
		}
        return result;        
    }

    public String getFilterClauseString(String filterClause, Map<String,String> paramMap){
        for(String key: paramMap.keySet()){
            if(paramMap.get(key) != null){
                filterClause = filterClause.replace('{!' + key + '}',String.escapeSingleQuotes(paramMap.get(key)));    
            }
        }
        return filterClause;
    }

    public with sharing class LookupData{
        public String id;
        public String text;
        
        public LookupData(Object id, Object text){
            this.id = String.valueOf(id);
            this.text = String.valueOf(text);
        }
    }

	public static Map<String,Object> onAfterTaskAddHandler(Map<String,Object> keyValueMap){        
        Map<String,Object> retVal = new Map<String,Object>(); 
        WBSTaskSchedule__c wbsTask = new WBSTaskSchedule__c();
        try{
            Map<String,Object> item = (Map<String,Object>)keyValueMap.get('item');                        
            Boolean isSuccess = true;
            String message = '';                        
            if((String)item.get('text') != null){
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.Name.isCreateable()){
                    wbsTask.Name = (String)item.get('text');
                }
            }else{
                isSuccess = false;
                message += '<P>Title is a required field.</p>';        
            }  
            if((String)item.get('owner') != null){
                Id recordId = Id.valueOf((String)item.get('owner'));
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.TaskOwner__c.isCreateable()){
                    wbsTask.TaskOwner__c = recordId;
                }
            }                             
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Description__c.isCreateable()){
                wbsTask.Description__c = (String)item.get('description');            
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Milestone__c.isCreateable()){
                wbsTask.Milestone__c = (Boolean)item.get('milestone') == null ? false : (Boolean)item.get('milestone'); 
            }
            date todayDate = Date.today(); 
            if((Integer)item.get('progress') != null && (Integer)item.get('progress') <= 100 && (Integer)item.get('progress') >= 0){
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.ProgressIndicator__c.isCreateable()){
                    wbsTask.ProgressIndicator__c = (Integer)item.get('progress');
                }
            }else{
                isSuccess = false;
                message += 'Progress is a percentage field and the value should be between 0 and 100.' ;       
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Status__c.isCreateable()){
                wbsTask.Status__c  = (String)item.get('status');               
            }
            if((String)item.get('start_date') != null){
                String sDateString = (String)item.get('start_date'); 
                if(sDateString != '') {                                 
                    if(Schema.sObjectType.WBSTaskSchedule__c.fields.StartDate__c.isCreateable()){
                        wbsTask.StartDate__c = Date.valueOf(sDateString);                
                    }
                }
            }                   
            if((String)item.get('end_date') != null){
                String eDateString = (String)item.get('end_date'); 
                if(eDateString != '') {                                 
                    if(Schema.sObjectType.WBSTaskSchedule__c.fields.EndDate__c.isCreateable()){
                        wbsTask.EndDate__c = Date.valueOf(eDateString);         
                    }
                }               
            }
			if(wbsTask.StartDate__c > wbsTask.EndDate__c){
                isSuccess = false;
                message += '<p>Start date should be earlier than End date.</p>' ; 
            } 
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.TaskDuration__c.isCreateable()){
                wbsTask.TaskDuration__c = (Integer)item.get('duration');  
            }
            Map<String,Object> paramMap = (Map<String,Object>)System.JSON.deserializeUntyped((String)keyValueMap.get('paramtersMap'));
            String WBSGridName = (String)keyValueMap.get('WBSGridName');
            List<DataTableConfig__c> dataTableConfigList = new List<DataTableConfig__c>();
            if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
                dataTableConfigList = [SELECT Id,Name,WBSDataConfig__c,WBSEventHandlerConfig__c,WBSHelperClass__c,HeaderDescription__c,
                                                                       WBSPropertiesConfig__c,WBSLinkConfig__c,Header__c, WBSStatusConfig__c
                                                                FROM DataTableConfig__c 
                                                                WHERE Name =:WBSGridName
                                                                WITH USER_MODE
                                                                LIMIT 1];
            }
            String filterClause = '';
            If(dataTableConfigList.size() > 0){
                DataTableConfig__c dataTableConfig = dataTableConfigList[0];      
                List<Object> WBSDataConfigList = (List<Object>)JSON.deserializeUntyped(dataTableConfig.WBSDataConfig__c);                                  
                for(Object WBSDataConfigObject : WBSDataConfigList){
                    Map<String,Object> WBSDataConfig = (Map<String,Object>)WBSDataConfigObject;                         
                    String dummy = (String)WBSDataConfig.get('filterClause');
                    filterClause = dummy.substringBefore('=');
                    String relatedSobjectName= filterClause.remove(AppUtils.getNamespacePrefix());
                    if(Schema.sObjectType.WBSTaskSchedule__c.fields.RelatedSobject__c.isCreateable()){
                        wbsTask.RelatedSobject__c =relatedSobjectName; 
                    }
                }
            }
            if(filterClause != null && !string.isBlank(filterClause)){
                String programId=(String)paramMap.get('RecordId');
                wbsTask.put(filterClause,programId);
            } 
            Map<String,Object> idMapper= (Map<String,Object>)keyValueMap.get('idMapper');
            if(item.get('parent') != 0){                
                String parentId = (String)item.get('parent');                                
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.ParentWBSTaskSchedule__c.isCreateable()){
                    if((Id)idMapper.get(parentId) == null){
                        wbsTask.ParentWBSTaskSchedule__c = parentId;
                    }else{
                        wbsTask.ParentWBSTaskSchedule__c = (Id)idMapper.get(parentId);
                    }
                }
            }            
            String prev_sibling_id = '';
            if(item.get('prev_sibling_id') instanceof Long){
                prev_sibling_id = (Long)item.get('prev_sibling_id') + '';
            }else{
                prev_sibling_id = (String)item.get('prev_sibling_id');
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.PreviousSiblingWBSTask__c.isCreateable()){
                if((Id)idMapper.get(prev_sibling_id) == null){
                    wbsTask.PreviousSiblingWBSTask__c = prev_sibling_id;
                }else{
                    wbsTask.PreviousSiblingWBSTask__c= (Id)idMapper.get(prev_sibling_id);
                }
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.WBSNumber__c.isCreateable()){
                wbsTask.WBSNumber__c = (String)item.get('wbsno'); 
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Source__c.isCreateable()){
                wbsTask.Source__c = wbsTask.ParentWBSTaskSchedule__c;           
            }
            if(isSuccess == true){
                if(Schema.sObjectType.WBSTaskSchedule__c.isCreateable()){
                    insert as user wbsTask;
                }
                retVal.put('Success',true);
                retVal.put('WbsTask',wbsTask);            
                retVal.put('Id',wbsTask.Id);                
                retVal.put('keyValueMap',keyValueMap);
                retVal.put('Refresh',true);
            }else{
                retVal.put('Success',false);
                retVal.put('ShowMessage',true);
                retVal.put('Message',message);
            }           
        } catch(Exception e){
            retVal.put('Success',false);
            retVal.put('ShowMessage',true);
            retVal.put('Message',AppUtils.handleSystemExceptionMsg(e.getMessage()));
        }           
        return retVal;  
    }

	public static Map<String,Object> onAfterTaskUpdateHandler(Map<String,Object> keyValueMap){
        Map<String,Object> retVal = new Map<String,Object>(); 
        try{
            WBSTaskSchedule__c wbsTask = new WBSTaskSchedule__c();
            Map<String,Object> item = (Map<String,Object>)keyValueMap.get('item');
            Object wbstaskId = item.get('id');
            if(Schema.sObjectType.WBSTaskSchedule__c.isUpdateable()){
                if(wbstaskId instanceof Id){
                    wbsTask.Id = (String)wbstaskId; 
                }else{
                    Map<String,Object> idMapper= (Map<String,Object>)keyValueMap.get('idMapper');
                    wbsTask.Id = (Id)idMapper.get(String.valueOf((Long)wbstaskId));   
                }
            }  
            
            Boolean isSuccess = true;
            String message = '';
            if((String)item.get('text') != null){
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.Name.isUpdateable()){
                    wbsTask.Name = (String)item.get('text');
                }
            }else{
                isSuccess = false;
                message += 'Title is a required field.\n';        
            }           
            if((String)item.get('owner') != null){
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.TaskOwner__c.isUpdateable()){
                    wbsTask.TaskOwner__c = (String)item.get('owner');
                }
            }               
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Description__c.isUpdateable()){
                wbsTask.Description__c = (String)item.get('description');
            }
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Milestone__c.isUpdateable()){
                wbsTask.Milestone__c = (Boolean)item.get('milestone');
            }
            if((Decimal)item.get('progress') != null && (Decimal)item.get('progress') <= 100 && (Decimal)item.get('progress') >= 0){
                if(Schema.sObjectType.WBSTaskSchedule__c.fields.ProgressIndicator__c.isUpdateable()){
                    wbsTask.ProgressIndicator__c =(Decimal)item.get('progress');
                }
                if((Decimal)item.get('progress') == 100) {
                    if(Schema.sObjectType.WBSTaskSchedule__c.fields.Status__c.isUpdateable()){
                        wbsTask.Status__c = 'Completed';
                    }
                }
            }else{
                isSuccess = false;
                message += 'Progress is a percentage field and the value should be between 0 and 100.' ;       
            }            
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.Status__c.isUpdateable()){
                wbsTask.Status__c  = (String)item.get('status'); 
            }
            if( !wbsTask.Status__c.equals('Completed')){
                Map<String,Object> paramMap = (Map<String,Object>)System.JSON.deserializeUntyped((String)keyValueMap.get('paramtersMap'));
                String programId=(String)paramMap.get('programid');   
                date todayDate = Date.today();
                if((String)item.get('start_date') != null){
                    String sDateString = (String)item.get('start_date');
                    if(sDateString != '') { 
                        if(Schema.sObjectType.WBSTaskSchedule__c.fields.StartDate__c.isUpdateable()){
                            wbsTask.StartDate__c = Date.valueOf(sDateString);         
                        }
                    }
                }                   
                if((String)item.get('end_date') != null){
                    String eDateString = (String)item.get('end_date'); 
                    if(eDateString != '') { 
                        if(Schema.sObjectType.WBSTaskSchedule__c.fields.EndDate__c.isUpdateable()){
                            wbsTask.EndDate__c = Date.valueOf(eDateString);               
                        }
                    }
                }
               if(wbsTask.StartDate__c > wbsTask.EndDate__c){
                    isSuccess = false;
                    message += 'Start date should be earlier than End date.' ; 
                }
            }            
            if(Schema.sObjectType.WBSTaskSchedule__c.fields.TaskDuration__c.isUpdateable()){
                wbsTask.TaskDuration__c = (Integer)item.get('duration');            
            }
            if(isSuccess == true){
                if(Schema.sObjectType.WBSTaskSchedule__c.isUpdateable()){
                    update as user wbsTask;
                }
                retVal.put('Success',true);
                retVal.put('WbsTask',wbsTask);
                retVal.put('Id',wbsTask.Id);            
                retVal.put('keyValueMap',keyValueMap); 
                retVal.put('Refresh',true);
            }else{
                retVal.put('Success',false);
                retVal.put('ShowMessage',true);
                retVal.put('Message',message);
            }            
        }catch(Exception e){
            retVal.put('Success',false);
            retVal.put('ShowMessage',true);
            retVal.put('Message',AppUtils.handleSystemExceptionMsg(e.getMessage()));
        }
        return retVal;
    }

    public static Map<String,Object> onAfterTaskDeleteHandler(Map<String,Object> keyValueMap){
        Map<String,Object> retVal = new Map<String,Object>();
        try{
            String wbsId = String.valueOf(keyValueMap.get('id'));   
            boolean isAvailable = false;
            List<WBSTaskSchedule__c> wbsRec = new List<WBSTaskSchedule__c>();
            if (Schema.sObjectType.WBSTaskSchedule__c.isAccessible()) {
                wbsRec = [SELECT Id FROM WBSTaskSchedule__c WHERE Id =: wbsId WITH USER_MODE];
            }
            if(wbsRec.size() > 0){
                if(Schema.sObjectType.WBSTaskSchedule__c.isDeletable()){
                    delete as user wbsRec;
                }
                isAvailable = true;             
            }
            if(isAvailable){
                retVal.put('Success',true);
                retVal.put('ShowMessage',true);     
                retVal.put('Message','Record has been successfully deleted.');
                retVal.put('Refresh', true);
            }           
            return retVal;
        }catch(Exception e){        
            retVal.put('Success',false);
            retVal.put('ShowMessage',true);
            retVal.put('Message',AppUtils.handleSystemExceptionMsg(e.getMessage()));
        }   
        retVal.put('DeleteSuccess',true);       
        return retVal;
    }

    //Added by Dipak Pawar to get Status picklist values
    private static Map<String, String> getStatusPicklistOptions(){
        Map<String, String> mapPicklistValues = new Map<String, String>();
        SchemaManager.Field field = SchemaManager.getFieldSchemaResult(AppUtils.getNameSpacePrefix()+'WBSTaskSchedule__c', AppUtils.getNameSpacePrefix()+'Status__c');
        Map<String, String> mapStatusFieldMetadata = new Map<String, String>();
        for(Schema.PicklistEntry picklistEntry : field.fieldDesc.getPicklistValues()){
            mapStatusFieldMetadata.put(picklistEntry.getValue(), picklistEntry.getLabel());    
        }
        return mapStatusFieldMetadata;
    }
}