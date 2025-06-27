/*
    Super class for all triggers. 
    When a new trigger is created for any object, a separate helper class can be created 
    which can extend from this super class. In the extended class, the following
    virtual methods can be overridden and Trigger.XXX variables (eg: Trigger.New, Trigger.OldMap)
    can be directly used depending on the context.
    
    Example:
    Trigger Code:
    -------------
        trigger GeoLevel1Trigger on Geo_Level_1__c (before insert, before update, after insert, after update) {
            new GeoLevel1TriggerHelper().process();
        }
        
    Helper Class Code:
    -----------------           
        public with sharing class GeoLevel1TriggerHelper extends TriggerHelper {
            public override void processBeforeInsert() {
                //before insert logic goes here
            }
            public override void processAfterUpdate() {
                //after update logic goes here
            }
        }   
*/
global virtual with sharing class TriggerHelper {
    global static Boolean skipTrigger = false;
    global static Boolean skipSharingLogic = true;
    global static Boolean skipAutoSnapShot = true;
    global static Boolean skipRollupCalculations = false;
    public static Boolean autoSnapShotForLightning = false;
    public static Boolean autoSnapShotForClassic = false;
    public static Object autoSnapShotFieldValue;
    /*
        Key Value pairs passed to flex edit layout/flex view layout would be stored in this property, 
        in order to facilitate accessibility of static values passed from controller class into the trigger.
    */
    global static Map<String, Object> controllerParamsMap = new Map<String, Object>();
    global static Map<String, Object> controllerListParamsMap = new Map<String, Object>();
    global void process() {
        Savepoint sp ;
        sp = Database.setSavepoint();
        try{
        if (!skipTrigger) {
            if(Trigger.isBefore){
                if(Trigger.isInsert){
                    processBeforeInsert();
                    updateCurrentAppName();
                }      
                else if(Trigger.isUpdate){
                    processBeforeUpdate();
                }
                else if(Trigger.isDelete){
                    processBeforeDelete();
                }
                else if(Trigger.isUndelete){
                    processBeforeUndelete();
                }
            }
            else if(Trigger.isAfter){
                if(Trigger.isInsert){
                    processAfterInsert();
                }      
                else if(Trigger.isUpdate){
                    processAfterUpdate();
                }
                else if(Trigger.isDelete){
                    processAfterDelete();
                }
                else if(Trigger.isUndelete){
                    processAfterUndelete();
                }
            }  
        }

        if( ((Trigger.isInsert || 
                Trigger.isUpdate || 
                Trigger.isUndelete) && Trigger.isAfter) || (Trigger.isDelete && Trigger.isBefore)) {
            new RollupFieldHelper().evaluateAndProcess();
        }

        setInternalUniqueID();
        handleSharingSettings();
        autoSnapShot();
        }catch(Exception ex){
            if(sp!=null){
                Database.rollback(sp);
            }
            if(ex != null && KeyValueHolderHelper.getBooleanValue('EnableLogException') != null && KeyValueHolderHelper.getBooleanValue('EnableLogException')){
                LogExceptionHandler.logException(ex);                
            }
            
            String errMsg = Apputils.handleSystemExceptionMsg(ex);
            throw new CustomExceptions.TriggerException(errMsg);
        }
        
    }
    
    /* The following methods can be overridden in the sub classes as per the need */
    
    global virtual void processBeforeInsert() {}
    global virtual void processBeforeUpdate() {}
    global virtual void processBeforeDelete() {}
    global virtual void processBeforeUndelete() {}
    global virtual void processAfterInsert() {}
    global virtual void processAfterUpdate() {}
    global virtual void processAfterDelete() {}
    global virtual void processAfterUndelete() {}
    
    //The below method should ALWAYS be invoked independent of skipTrigger logic
    global virtual void setInternalUniqueID() {
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                generateUniqueId();                
            }      
            else if(Trigger.isUpdate){
                generateUniqueId();
            }
            else if(Trigger.isUndelete){
                generateUniqueId();               
            }
        }        
    }
    
    //The below method should ALWAYS be invoked independent of skipTrigger logic
    global virtual void handleSharingSettings() {        
        Boolean enableSharingModel = KeyValueStoreHelper.getBooleanValue('EnableSharingModel',true) != null ? KeyValueStoreHelper.getBooleanValue('EnableSharingModel',true) : false ;
        if(Trigger.isAfter && enableSharingModel){
            if(Trigger.isInsert || Trigger.isUpdate){
                createSharingRecords();                
            }
        }
    }

    // Auto Snap Shot Generator Execute upon value of field changes which configured in sObject AutoSnapshot Field API Name.
    public virtual void autoSnapShot(){
       if(Trigger.isAfter && !skipAutoSnapShot && (autoSnapShotForLightning || autoSnapShotForClassic)){
            if(Trigger.isInsert || Trigger.isUpdate){
                AutoSnapShotHelper.createAutoSnapShot();
            }
        }
    }


    /* PRIVATE METHODS */

    private void generateUniqueId() {
        String objType = Trigger.New[0].getSObjectType().getDescribe().getName();
        //Add Object API names that want to skip for internalUniqueId
        Set<String> objectAPINameSet = new Set<String>();
        objectAPINameSet.add('User');
        objectAPINameSet.add('ContentDocument');
        //objectAPINameSet.add('ContentVersion');
        if( !objectAPINameSet.contains(objType) ) {
            for (SObject record : Trigger.New) {
                String objectAPIName = String.valueOf(record.getSObjectType());
                SObjectCache__c sobjectCache = SObjectCache__c.getInstance(objectAPIName);
                if(sobjectCache == null || sobjectCache.SkipInternalUniqueId__c == false) {
                    String idValue = (String) record.get('InternalUniqueID__c');
                    if (String.isEmpty(idValue)) {
                        idValue = AppUtils.generateToken(null);
                        System.debug('idValue check:'+idValue);
                        do{//Bug 206562: OSPI - InternalUniqueId - TestClasses failing showing an error "Key size for HMAC must be at least 112 bits in approved mode: SHA-1/HMAC (GNT):" while deployment
                            idValue = idValue + AppUtils.generateToken(null);
                        }while(idValue.length() < 14);
                        if(idValue.length() > 32){
                            idValue = idValue.subString(0,31);
                        }
                        record.put('InternalUniqueID__c', idValue);
                    }
                }
                
            }    
        }
    }
     
    public void deleteExistingSharingRecords(String shareObjectName,Map<String,String> sobjectIdToRoleCodeMap){
        Set<String> parentIdsSet = new Set<String>();
        parentIdsSet = sobjectIdToRoleCodeMap.keySet();
        Set<String> parentIdsSetSanitized = new Set<String>();
        for(String parentId : parentIdsSet) {
            parentIdsSetSanitized.add(string.escapeSingleQuotes(parentId));
        }
        String deleteQuery = 'SELECT Id '+
                                'FROM '+ string.escapeSingleQuotes(shareObjectName) + 
                                ' WHERE RowCause IN (\'Home__c\',\'Guest__c\',\'Family__c\',\'Sibling__c\')'+
                                ' AND ParentId IN:parentIdsSetSanitized WITH USER_MODE';
        List<Sobject> sharingRecToBeDeleted = Database.query(deleteQuery);//NOPMD Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
        SystemContextMethodsHelper sch = new SystemContextMethodsHelper();
        sch.deleteSobjectList(sharingRecToBeDeleted);
    }
    
    public void createSharingRecords(){ 
                               
        Map<String,String> sobjectIdToRoleCodeMap = new Map<String,String>();
        
        String objectAPIName = Trigger.New[0].getSObjectType().getDescribe().getName();
        BusinessShareConfig__c bizShareConfig = BusinessShareConfig__c.getValues(objectAPIName);
        if(bizShareConfig != null &&  bizShareConfig.Active__c == true){        
            String shareObjectName = bizShareConfig.ShareObjectName__c;
            Schema.SObjectType shareObjectType = Schema.getGlobalDescribe().get(shareObjectName);
                        
            for (SObject record : Trigger.New) {                              
                String roleCodeValue = (String)record.get(bizShareConfig.RoleCodeFieldName__c);                
                if(Trigger.isUpdate){
                    Sobject oldRecord = Trigger.OldMap.get(record.Id);
                    String oldRoleCodeValue = (String)oldRecord.get(bizShareConfig.RoleCodeFieldName__c);
                    if(roleCodeValue != oldRoleCodeValue){
                        sobjectIdToRoleCodeMap.put((String)record.get('Id'),roleCodeValue);                                
                    }
                }else if(Trigger.isInsert){
                    sobjectIdToRoleCodeMap.put((String)record.get('Id'),roleCodeValue);                                
                }                                        
            }           
            if(sobjectIdToRoleCodeMap.size() > 0){
                if(Trigger.isUpdate){
                    deleteExistingSharingRecords(shareObjectName,sobjectIdToRoleCodeMap);
                }
                insertSharingRules(objectAPIName,shareObjectType,sobjectIdToRoleCodeMap);                
            }
        }                               
            
    }
    
    public void insertSharingRules(String objectAPIName,Schema.SObjectType shareObjectType,
                                        Map<String,String> sobjectIdToRoleCodeMap){
        Map<String, SObjectSharingRuleCache__c> sharingRuleCacheMap = SObjectSharingRuleCache__c.getAll();
        List<Sobject> shareRecordsList = new List<Sobject>();
        for(SObjectSharingRuleCache__c sobjSharingRuleCache : sharingRuleCacheMap.values()){
            if(objectAPIName == sobjSharingRuleCache.SObjectName__c){                                 
                getSharingRecordsList(sobjSharingRuleCache,sobjectIdToRoleCodeMap,shareRecordsList,shareObjectType);
            }
        }
        if(shareRecordsList.size() > 0){
            //insert shareRecordsList;
            SystemContextMethodsHelper sch = new SystemContextMethodsHelper();
            sch.insertSobject(shareRecordsList);
        }
    }
    
    public void getSharingRecordsList(SObjectSharingRuleCache__c sobjSharingRuleCache,
                            Map<String,String> sobjectIdToRoleCodeMap,List<Sobject> shareRecordsList,Schema.SObjectType shareObjectType){
        
       List<String> roleCodeList = sobjSharingRuleCache.CriteriaRoleCodes__c.split(',');
        Set<String> roleCodeSet = new Set<String>(roleCodeList);
        String shareWithGroupIds = sobjSharingRuleCache.ShareWithGroupIds__c;
        String accessLevel = sobjSharingRuleCache.AccessLevel__c ;
        
        for(SObject record : Trigger.new){
            String roleCodeValue = sobjectIdToRoleCodeMap.get((String)record.get('Id'));
            if(roleCodeValue != null && roleCodeSet.contains(roleCodeValue)){
                if(shareWithGroupIds != null){
                    List<String> shareWithGroupIdsList = shareWithGroupIds.split(',');
                    for(String shareGroupId : shareWithGroupIdsList){
                        sObject shareRecord = shareObjectType.newSObject(); 
                        shareRecord.put('ParentId', (String)record.get('Id'));
                        shareRecord.put('UserOrGroupId', shareGroupId);
                        shareRecord.put('AccessLevel', accessLevel);
                        shareRecord.put('RowCause', sobjSharingRuleCache.RuleType__c + '__c');
                        shareRecordsList.add(shareRecord);
                    }
                }
            }
        }          
    }
    
    /*
    * Author : Pankaj H.
    * Description : This method will execute in before insert context and will get field API name from SObject and update current app name into record.
    *
    */
    private void updateCurrentAppName() {
        String appName = UserPreferenceHelper.getCurrentApp();
        if(String.isNotEmpty(appName)) {
            for(SObject record : Trigger.new) {
                String objectAPIName = String.valueOf(record.getSObjectType());
                SObjectCache__c sobjectCache = SObjectCache__c.getInstance(objectAPIName);
                if(sobjectCache != null && sobjectCache.CurrentAppField__c != null) {
                    record.put(sobjectCache.CurrentAppField__c, appName);
                }
            }
        }
    }

    global static String getContextSObjName() {
        SObject contextSobj = Trigger.isDelete ? Trigger.Old[0] : Trigger.New[0];
        String sobjName = contextSobj.getSObjectType() + '';
        return sobjName;
    }
}