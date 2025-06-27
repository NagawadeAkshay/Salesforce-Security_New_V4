/*  This class is used to display the progressbar Graphic
    **********************************************************
    Audit History
    **********************************************************
    07/15/2015   Shrawan Raina      Created
    07/28/2015   Shrawan Raina      Modified    Added configuration for customizing colors
    23/11/2016   Anuja Joshi        Modified    Added function to show modified by and date on stepprogressbar
*/
global with sharing class StepProgressbarCtrl {

    global transient String groupName {get; set;}
    global transient String sObjectName {get;set;}
    global transient Id recordId {get;set;}
    
    public static String nameSpace {get;set;}
    public Integer  timeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
    }
    @AuraEnabled
    public static String  timeZone {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return String.valueOf(tz);
        }set;
    }
    @AuraEnabled
    public static String locale{
        get{                     
            return UserInfo.getLocale();
           
        }set;
    }
    private static transient boolean showLegend {get;set;}
    private static transient String appType {get;set;} 
    private static transient String userType {get;set;}
    private static  transient String currStatus {get;set;}   
    private static transient List<StepProgressbarHeader__c> pbColor {get;set;}
    public transient Boolean enableEnhancedProgressBar { get; private set; }
    
    global StepProgressbarCtrl(){
        appType = '';
        userType = '';
        currStatus = '';        
        showLegend = false;
        pbColor = new List<StepProgressbarHeader__c>();
        nameSpace = AppUtils.getNameSpacePrefix();
        enableEnhancedProgressBar = (KeyValueStoreHelper.getBooleanValue('EnhancedProgressBar', true) == null ? false : KeyValueStoreHelper.getBooleanValue('EnhancedProgressBar', true));
        //setRenderCriteria();
    }
    
    public with sharing class pbStepWrapper implements Comparable{
        @AuraEnabled
        public String displayName;
        @AuraEnabled
        public String picklistVal;
        @AuraEnabled
        public Decimal sequence;
        @AuraEnabled
        public Integer clrCode; // 0:Silver, 1:Green, 2:Current, 3:Red
        
        Set<String> hideForUser = new Set<String>();
        
        pbStepWrapper() {
            displayName = '';
            picklistVal = '';
            sequence = 0;
            clrCode = 0;
        }
    
        public Integer compareTo(Object compareTo){
            pbStepWrapper custObj = (pbStepWrapper) compareTo;
            if(this.sequence > custObj.sequence)
                return 1;
            if(this.sequence == custObj.sequence)
                return (this.clrCode > custObj.clrCode) ? 1 : 0;
            return -1;
        }
    }
    
    @AuraEnabled
    public static Map<String, Object> fetchorderedListLwc(String sobjectName, String groupName, Id recordId){
        return fetchorderedList(sobjectName, groupName, recordId);
    }

    @AuraEnabled(cacheable=true) @RemoteAction
    global static Map<String, Object> fetchorderedList(String sobjectName, String groupName, Id recordId){
        List<Object> historyList = new List<Object>(); 
        //try {
            if((recordId != null || recordId != '') && (groupName != null || groupName != '')) {
                StepProgressbarCtrl.setRenderCriteria();
                sObjectName = recordId.getSObjectType().getDescribe().getName();
                //sObjectName = AppUtils.removeNamespacePrefix(sObjectName);
                recordId = String.escapeSingleQuotes(recordId);
                Map<String, Object> pklistMap = StepProgressbarCtrl.fetchStepProgressbarConfig(sObjectName, groupName, recordId);
                    
                historyList.add(pklistMap.get('history'));                  /*retrived history fields from map*/
                pklistMap.remove('history');
                
                //Creating custom object from current status
                List<Object> resultList = StepProgressbarCtrl.generateResultList(pklistMap, currStatus);
                List<Object> showLegendList = new List<Object>();
                List<Object> currentStatus = new List<Object>();
                List<Object> timeZoneList = new List<Object>();
                List<Object> localeList = new List<Object>();                
                showLegendList.add(showLegend);
                currentStatus.add(currStatus);
				timeZoneList.add(timeZone);
                localeList.add(locale);
                
                Map<String, List<Object>> resultMap = new Map<String, List<Object>>();
                resultMap.put('color', pbColor);
                resultMap.put('resultList', resultList);
                resultMap.put('showLegend', showLegendList);                
                resultMap.put('currentStatus', currentStatus);
                resultMap.put('history', historyList);
				resultMap.put('timeZone', timeZoneList);
				resultMap.put('locale', localeList); 
                return resultMap;
            }
            return null;
    }
    
    private static void setRenderCriteria(){
        //try{
            showLegend = UserPreferenceHelper.getBooleanValue('ShowProgressbarLegend__c') == null ? false : UserPreferenceHelper.getBooleanValue('ShowProgressbarLegend__c');
            String appName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
            if(appName != null) {
                if(appName.equalsIgnoreCase('StateasGrantor'))
                    appType = 'Grantor';
                else if(appName.equalsIgnoreCase('StateasGrantee'))
                    appType = 'Grantee';
                else if(appName.equalsIgnoreCase('Recipient'))
                    appType = 'Recipient';
            }
            UserPreferences__c userPrefs = UserPreferences__c.getInstance();
            if(userPrefs != null){
                if(userPrefs.IsApplicant__c)
                    userType = 'External';
                if(userPrefs.IsReviewer__c)
                    userType = 'Reviewer';
                if(userPrefs.IsInternal__c)
                    userType = 'Internal';
            }
        /*}
        catch(Exception e){
        }*/
    }
    
    private static SObject getRecord(String sObjectName, String statusField, Id recordId,  Set<String> fieldSet) {
        if(sObjectName != null && sObjectName != '' && recordId != null && statusField != null && statusField != ''){
         //Added hidedecison fields and status field in set.
         fieldSet.add(statusField.toLowerCase()); 
         String soqlQuery = 'SELECT ' + string.escapeSingleQuotes(String.join(new List<String> (fieldSet), ',')) + ' FROM '+ 
         string.escapeSingleQuotes(sObjectName) + ' WHERE Id =: recordId LIMIT 1';
         return Database.query(soqlQuery, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
    }
        return null;
    }
    
    private static Map<String, Object> fetchStepProgressbarConfig(String sObjectName, String groupName, Id recordId) {
        Map<String, Object> pklistMap = new Map<String, Object>();
        String createdObj;
        String soql = 'SELECT Id, DecisionFieldAPIName__c, CompleteColor__c, IncompleteColor__c, RejectColor__c,' +
                        ' (SELECT Name, PicklistValue__c, Sequence__c,isCreated__c,NegativePath__c,HideForUsers__c,HideExpressionJSON__c FROM ProgressbarHeaderConfig__r order by Sequence__c Asc ,NegativePath__c Asc) FROM StepProgressbarHeader__c' +
                        ' WHERE GroupName__c = :'+string.escapeSingleQuotes(groupName)+ 'AND sObjectName__c = :'+string.escapeSingleQuotes(sObjectName);
        if(userType != null && userType != '')          
            soql += ' AND RenderforUser__c INCLUDES (:userType)';
        if(appType != null && appType != '')
            soql += ' AND RenderforApp__c INCLUDES (:appType)';
        List<StepProgressbarHeader__c> pbHeader = Database.query(soql, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is :bind to prevent SOQL Injection
        
        
        if(pbHeader.size() > 0){
            pbColor = pbHeader;
            //  07282015    Shrawan     Added config for customizing colors --Begin
            if(pbColor[0].CompleteColor__c == null || pbColor[0].CompleteColor__c == '')
                pbColor[0].CompleteColor__c = '#3ba10b';
            if(pbColor[0].IncompleteColor__c == null || pbCOlor[0].IncompleteColor__c == '')
                pbColor[0].IncompleteColor__c = '#a0a0a0';
            if(pbColor[0].RejectColor__c == null || pbCOlor[0].IncompleteColor__c == '')
                pbColor[0].RejectColor__c = '#E60000';
            //End
                         
            Boolean isEnable508 = [SELECT Enable508Compliance__c FROM User 
                                WHERE Id =: UserInfo.getUserId() WITH USER_MODE].Enable508Compliance__c;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            
            if(isEnable508 == true){
                 pbColor[0].CompleteColor__c = '#1b4b05';
                 pbColor[0].IncompleteColor__c = '#545454';
                 pbColor[0].RejectColor__c = '#a70000';
            }
            List<StepProgressbarDetail__c> pbList = pbHeader[0].ProgressbarHeaderConfig__r;
            Set<String> fieldSet = new Set<String>();
            for(StepProgressbarDetail__c progessBar : pbList){
                if(String.isNotEmpty(progessBar.HideExpressionJSON__c)){
                    String expressionJson = progessBar.HideExpressionJSON__c;
                    // ExpressionJSONEvaluator.getfieldNamesFromJSON gives comma separated fields.
                    String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
                    if(String.isNotEmpty(fields)){
                        fields = fields.toLowerCase();
                        fieldSet.addAll(fields.split(','));
                    }
                }
                  
            }
            //getRecord method gives sobject record. Passed extra parameter i.e set of fields.
            Sobject sobj = getRecord(sObjectName, pbHeader[0].DecisionFieldAPIName__c, recordId, fieldSet);
            currStatus = (String)sobj.get(pbHeader[0].DecisionFieldAPIName__c);
            string  prevStatus = '';    
            
            if(pbList.size() > 0){
                for(StepProgressbarDetail__c pbStep : pbList){
                    //Prajakta:ExpressionJsonEvaluator.evaluateExpression method returns boolean value.It is used to hide based on conditions.
                    if(String.isNotEmpty(pbStep.HideExpressionJSON__c)) {
                        Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(pbStep.HideExpressionJSON__c, sobj, 'View');
                        if(hideResult != null && hideResult) {
                            continue;
                        }
                    }
                    pbStepWrapper currStep = new pbStepWrapper();
                    currStep.displayName = pbStep.Name;
                    currStep.picklistVal =  pbstep.PicklistValue__c;
                    currStep.sequence = pbStep.Sequence__c;
                    if(pbStep.isCreated__c) {
                      createdObj = pbstep.PicklistValue__c;
                    }
                    //Setting clrCode to the Negative Step
                    currStep.clrCode = (pbStep.NegativePath__c) ? 3 : 0; 
                    currStep.hideForUser.add(pbStep.HideForUsers__c); 
                    if(JSON.serialize(currStep.hideForUser).contains(userType)) {
                        if(currStatus.equalsIgnorecase(pbstep.PicklistValue__c) ) {
                            currStatus = prevStatus;
                        }
                    } else {                       
                        pklistMap.put(pbStep.PickListValue__c, currStep);
                        if(!pbStep.NegativePath__c) {
                            prevStatus = pbStep.PickListValue__c;
                        }   
                    }
                    
                }
            }
        }
        /* inserted history fields */
        if(pbHeader != null && pbHeader.size() > 0) {
            Map<String,Map<String,Object>> statusHistory = fetchStatusHistory(sObjectName,pbHeader[0].DecisionFieldAPIName__c, recordId,pklistMap.keySet());
          if(createdObj != null) {
            statusHistory.putAll(fetchCreatedDetails(sObjectName,createdObj,recordId)); 
          }
            pklistMap.put('history',statusHistory);
        }
        return pklistMap;
    }
     
    // CreatedBy And Date for Newly Created Object
    private static Map<String,Map<String,Object>> fetchCreatedDetails(String ObjName,String fieldName,Id recordId) {
        Map<String,Map<String,Object>> requiredCreateDetails = new Map<String,Map<String,Object>>();
        List<SObject> creatObj;
      
        String soqlQuery = 'SELECT CreatedBy.Name, CreatedDate FROM ' + string.escapeSingleQuotes(ObjName) +' WHERE Id =:recordId';
        creatObj = Database.query(soqlQuery, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
        SObject obj = creatObj[0];
        Map<String,Object> requiredCreateFields = new Map<String,Object>();
        requiredCreateFields.put('CreatedBy',obj .getSobject('CreatedBy').get('Name'));
        requiredCreateFields.put('CreatedDate',obj .get('CreatedDate'));
        requiredCreateDetails.put(fieldName,requiredCreateFields);
        return requiredCreateDetails;
      
    }
    
    /*function to show modified date and modified by name on step progress bar*/
    private static Map<String,Map<String,Object>> fetchStatusHistory(String objName, String fieldName, Id recordId,Set<String> picklist) {
        Map<String,Map<String,Object>> requiredHistory = new Map<String,Map<String,Object>>();
        List<SObject> historyObj;
        if(!String.isEmpty(objName)  && !String.isEmpty(recordId) && !String.isEmpty(fieldName)){
            // Modified by Dipak Pawar for Task 104067
            String suffix = '__c', parentField = 'ParentId';
            if(objName.endsWithIgnoreCase(suffix)){
                objName = objName.replace(suffix, '__History');
            } else {
                parentField = objName + 'Id';
                objName = objName + 'History';
            }

            /* This Code Block While Throw Exception if Object Field History Not Enabled.*/
            try{
                 AppUtils.isObjectAccessible(objName);
            }
            catch(Exception e){
                 throw new CustomExceptions.InputDataException('Object Tracking Field History Need To Be Config for following Object:' + objName);
            }
            String soqlHistory = 'SELECT CreatedBy.Name, CreatedDate, Field, Id, NewValue FROM ' + string.escapeSingleQuotes(objName) +
            ' WHERE Field =: fieldName AND ' + string.escapeSingleQuotes(parentField) +' =:recordId order by CreatedDate asc';
                historyObj = Database.query(soqlHistory, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection and recordId escapeSingleQuotes used fetchorderedList Method.        
            for(SObject field : historyObj){
                Map<String,Object> requiredHistoryFields = new Map<String,Object>();
                requiredHistoryFields.put('CreatedBy',field.getSobject('CreatedBy').get('Name'));
                requiredHistoryFields.put('CreatedDate',field.get('CreatedDate'));
                String status = (String)field.get('NewValue');
                requiredHistory.put(status,requiredHistoryFields);
            }
            return requiredHistory;
        }
        return null;
    }
    
    private static List<Object> generateResultList(Map<String, Object> pklistMap, String currentStatus) {
        Map<String, Object> finalMap = new Map<String, Object>();
        pbStepWrapper currObj = (pbStepWrapper) pklistMap.get(currentStatus);
        if(currObj != null){
            currObj.clrCode = (currObj.clrCode != 3) ? 2 : 3; //Setting color of current object to complete if not reject
            //Adding current status to list
            finalMap.put(currObj.picklistVal, currObj);

            for(String key : pklistMap.keySet()){
                pbStepWrapper obj = (pbStepWrapper) pklistMap.get(key);
                    if(obj.picklistVal.equalsIgnoreCase(currObj.picklistVal)){
                        
                        continue;
                    }
                if(currObj.clrCode == 3){
                    if(obj.clrCode != 3 && obj.sequence < currObj.sequence){
                        //Setting color to complete color for all previous steps before rejection
                        obj.clrCode = 1;
                        finalMap.put(obj.picklistVal, obj);
                    }
                }
                else if(currObj.clrCode == 2){
                    if(obj.clrCode != 3){
                        if(obj.sequence < currObj.sequence){
                            obj.clrCode = 1;
                        }
                        finalMap.put(obj.picklistVal, obj);
                    }
                }
            }
        }
        if(finalMap != null){
            List<Object> resultList = finalMap.values();
            resultList.sort();        
            return resultList;
        }
        else{
            return null;
        }
    }
}