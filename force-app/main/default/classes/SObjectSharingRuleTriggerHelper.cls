/* ------------------------------------------------------------------------------
Name: SObjectSharingRuleTriggerHelper
Purpose: Validate and massage data for SObjectSharingRule__c object.
Author: Prem Pal
------------------------------------------------------------------------------ */
public with sharing class SObjectSharingRuleTriggerHelper extends TriggerHelper{           
    
    private Set<String> uniqueRoleCodesSet;
    private Set<String> uniqueRoleNameSet;
    private Set<String> uniqueSet;
    private Set<String> publicGroupSet;

    private List<SObjectSharingRule__c> incomingSobjectSharingRulesList;
    private List<SObjectSharingRule__c> oldIncomingSobjectSharingRulesList;
    private Map<Id,SObjectSharingRule__c> oldIncomingSobjectSharingRulesMap;
    private Map<String,String> roleCodeToRoleNameMap;
    private Map<String,String> roleCodeToRoleIdMap;
    private Map<String,String> roleNameToRoleCodeMap;
    private Set<String> userRoleSet;
    private Map<String,String> sobjectIdToSobjectNameMap; 
    private Map<String,Map<String,Id>> groupMap;
    private String familyChildNodeNames;
    private String familyChildNodeCodes;

    public override void processBeforeInsert(){          
        incomingSobjectSharingRulesList = (List<SObjectSharingRule__c>)Trigger.new;
        setAllRequiredMapsOnInsert();         
        filterAndMassageRecords();               
    } 
    public override void processAfterInsert(){
        incomingSobjectSharingRulesList = (List<SObjectSharingRule__c>)Trigger.new;
        insertSObjectSharingRuleCache();
    }
    public override void processBeforeUpdate(){          
        incomingSobjectSharingRulesList = (List<SObjectSharingRule__c>)Trigger.new;
        oldIncomingSobjectSharingRulesList = (List<SObjectSharingRule__c>)Trigger.old;
        oldIncomingSobjectSharingRulesMap = (Map<Id,SObjectSharingRule__c>)Trigger.oldMap;

        setAllRequiredMapsOnUpdate();         
        filterAndMassageRecords();               
    } 
    public override void processAfterUpdate(){
        incomingSobjectSharingRulesList = (List<SObjectSharingRule__c>)Trigger.new;
        updateSObjectSharingRuleCache();
    }
    public override void processAfterDelete(){
        incomingSobjectSharingRulesList = (List<SObjectSharingRule__c>)Trigger.old;        
        deleteSObjectSharingRuleCache();
    }
    private void insertSObjectSharingRuleCache(){
        List<SObjectSharingRuleCache__c> sobjSharingRuleCacheList = new List<SObjectSharingRuleCache__c>();
        for(SObjectSharingRule__c sobjSharingRule : incomingSobjectSharingRulesList){
            SObjectSharingRuleCache__c sobjSharingRuleCache = new SObjectSharingRuleCache__c();
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.AccessLevel__c.isCreateable()){
                sobjSharingRuleCache.AccessLevel__c = sobjSharingRule.AccessLevel__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.CriteriaRoleCodes__c.isCreateable()){
                sobjSharingRuleCache.CriteriaRoleCodes__c = sobjSharingRule.CriteriaRoleCodes__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.ShareWithGroupIds__c.isCreateable()){
                sobjSharingRuleCache.ShareWithGroupIds__c = sobjSharingRule.ShareWithGroupIds__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.SObjectName__c.isCreateable()){
                sobjSharingRuleCache.SObjectName__c = sobjSharingRule.SobjectName__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.Name.isCreateable()){
                sobjSharingRuleCache.Name = sobjSharingRule.Id;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.RuleType__c.isCreateable()){
                sobjSharingRuleCache.RuleType__c = sobjSharingRule.RuleType__c;
            }
            sobjSharingRuleCacheList.add(sobjSharingRuleCache);
        }
        if(Schema.sObjectType.SObjectSharingRuleCache__c.isCreateable()){
            insert as user sobjSharingRuleCacheList;
        }
    }

    private void updateSObjectSharingRuleCache(){
        List<SObjectSharingRuleCache__c> sobjSharingRuleCacheList = new List<SObjectSharingRuleCache__c>();
        for(SObjectSharingRule__c sobjSharingRule : incomingSobjectSharingRulesList){
            SObjectSharingRuleCache__c sobjSharingRuleCache = SObjectSharingRuleCache__c.getValues(sobjSharingRule.Id);
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.AccessLevel__c.isUpdateable()){
                sobjSharingRuleCache.AccessLevel__c = sobjSharingRule.AccessLevel__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.CriteriaRoleCodes__c.isUpdateable()){
                sobjSharingRuleCache.CriteriaRoleCodes__c = sobjSharingRule.CriteriaRoleCodes__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.ShareWithGroupIds__c.isUpdateable()){
                sobjSharingRuleCache.ShareWithGroupIds__c = sobjSharingRule.ShareWithGroupIds__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.SObjectName__c.isUpdateable()){
                sobjSharingRuleCache.SObjectName__c = sobjSharingRule.SobjectName__c;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.Name.isUpdateable()){
                sobjSharingRuleCache.Name = sobjSharingRule.Id;
            }
            if(Schema.sObjectType.SObjectSharingRuleCache__c.fields.RuleType__c.isUpdateable()){
                sobjSharingRuleCache.RuleType__c = sobjSharingRule.RuleType__c;
            }
            sobjSharingRuleCacheList.add(sobjSharingRuleCache);
        }
        if(Schema.sObjectType.SObjectSharingRuleCache__c.isUpdateable() && Schema.sObjectType.SObjectSharingRuleCache__c.isAccessible()){
            update as user sobjSharingRuleCacheList;
        }
    }
    
    private void deleteSObjectSharingRuleCache(){
        List<SObjectSharingRuleCache__c> sobjSharingRuleCacheList = new List<SObjectSharingRuleCache__c>();
        for(SObjectSharingRule__c sobjSharingRule : incomingSobjectSharingRulesList){
            SObjectSharingRuleCache__c sobjSharingRuleCache = SObjectSharingRuleCache__c.getValues(sobjSharingRule.Id);   
            if(sobjSharingRuleCache != null){           
                sobjSharingRuleCacheList.add(sobjSharingRuleCache);
            }
        }
        if(sobjSharingRuleCacheList.isEmpty() == false){
            if(Schema.sObjectType.SObjectSharingRuleCache__c.isDeletable()){
                delete sobjSharingRuleCacheList;
            }
        }
        
    }
    private void processAndExtractRequiredRoles(String roleCodesString,Set<String> uniqueSet){
        List<String> roleCodesStringList = roleCodesString.split(',');
        for(String roleCode : roleCodesStringList){
            if(!uniqueSet.contains(roleCode)){
                uniqueSet.add(roleCode);
            }
        }
    }

    private void processOtherRecordsOnInsert(){        
        for(Integer i = 1 ; i <  incomingSobjectSharingRulesList.size() - 1 ; i++){            
            SObjectSharingRule__c sobjSharingRule = incomingSobjectSharingRulesList[i];
            if(sobjSharingRule.CriteriaRoleCodes__c != null && 
                    sobjSharingRule.CriteriaRoleCodes__c != incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c){                
                processAndExtractRequiredRoles(sobjSharingRule.CriteriaRoleCodes__c,uniqueRoleCodesSet);                
            }else if(sobjSharingRule.CriteriaRoleNames__c != null && 
                    sobjSharingRule.CriteriaRoleNames__c != incomingSobjectSharingRulesList[0].CriteriaRoleNames__c){
                processAndExtractRequiredRoles(sobjSharingRule.CriteriaRoleNames__c,uniqueRoleNameSet);
            }
            if(sobjSharingRule.ShareWithRoleCodes__c != null && 
                    sobjSharingRule.ShareWithRoleCodes__c != incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c){
                processAndExtractRequiredRoles(sobjSharingRule.ShareWithRoleCodes__c,uniqueRoleCodesSet);
            }else if(sobjSharingRule.ShareWithRoleNames__c != null && 
                    sobjSharingRule.ShareWithRoleNames__c != incomingSobjectSharingRulesList[0].ShareWithRoleNames__c){
                processAndExtractRequiredRoles(sobjSharingRule.ShareWithRoleNames__c,uniqueRoleNameSet);
            } 
            sobjectIdToSobjectNameMap.put(sobjSharingRule.SObject__c,sobjSharingRule.SobjectName__c);               
        }               
    }

    private void processOtherRecordsOnUpdate(){        
        for(Integer i = 1 ; i <  incomingSobjectSharingRulesList.size() - 1 ; i++){            
            SObjectSharingRule__c sobjSharingRule = incomingSobjectSharingRulesList[i];
            if(sobjSharingRule.CriteriaRoleCodes__c != null  &&
                    sobjSharingRule.CriteriaRoleCodes__c != incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c){                
                processAndExtractRequiredRoles(sobjSharingRule.CriteriaRoleCodes__c,uniqueRoleCodesSet);                
            }else if(sobjSharingRule.CriteriaRoleNames__c != null &&
                    sobjSharingRule.CriteriaRoleNames__c != incomingSobjectSharingRulesList[0].CriteriaRoleNames__c){
                processAndExtractRequiredRoles(sobjSharingRule.CriteriaRoleNames__c,uniqueRoleNameSet);
            }
            if(sobjSharingRule.ShareWithRoleCodes__c != null &&
                    sobjSharingRule.ShareWithRoleCodes__c != incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c){
                processAndExtractRequiredRoles(sobjSharingRule.ShareWithRoleCodes__c,uniqueRoleCodesSet);
            }else if(sobjSharingRule.ShareWithRoleNames__c != null &&
                    sobjSharingRule.ShareWithRoleNames__c != incomingSobjectSharingRulesList[0].ShareWithRoleNames__c){
                processAndExtractRequiredRoles(sobjSharingRule.ShareWithRoleNames__c,uniqueRoleNameSet);
            } 
            sobjectIdToSobjectNameMap.put(sobjSharingRule.SObject__c,sobjSharingRule.SobjectName__c);               
        }              
    }

    private void getGroupsMap(){
        groupMap = new Map<String,Map<String,Id>>();
        Map<String,Id> roleAndSubordinatesMap = new Map<String,Id>();        
        Map<String,Id> publicGroupMap = new Map<String,Id>();        
        Map<String,Id> roleMap = new Map<String,Id>(); 
        List<Group> groupsList;
        if(publicGroupSet != null){
            groupsList = [SELECT DeveloperName,Id,Name,Type 
                                            FROM Group 
                                            WHERE Type IN ('RoleAndSubordinatesInternal','Regular','Role')
                                            AND (DeveloperName IN :roleCodeToRoleNameMap.keySet()
                                            OR Name IN :publicGroupSet) WITH USER_MODE];        
        }else{
            groupsList = [SELECT DeveloperName,Id,Name,Type 
                                            FROM Group 
                                            WHERE Type IN ('RoleAndSubordinatesInternal','Regular','Role')
                                            AND DeveloperName IN :roleCodeToRoleNameMap.keySet() WITH USER_MODE];
        }
        for(Group grp : groupsList){
            if(grp.Type == 'RoleAndSubordinatesInternal'){
                roleAndSubordinatesMap.put(grp.DeveloperName,grp.Id);
            }else if(grp.Type == 'Regular'){
                publicGroupMap.put(grp.Name,grp.Id);
            }else if(grp.Type == 'Role'){
                roleMap.put(grp.DeveloperName,grp.Id);
            }
        }
        
        groupMap.put('RoleAndSubordinates',roleAndSubordinatesMap);       
        groupMap.put('PublicGroup',publicGroupMap);
        groupMap.put('Role',roleMap);
    }

    private void getRoleRelatedMaps(){
        roleCodeToRoleNameMap = new Map<String,String>();
        roleCodeToRoleIdMap = new Map<String,String>();
        roleNameToRoleCodeMap = new Map<String,String>();
        uniqueSet = uniqueRoleCodesSet != null ? uniqueRoleCodesSet : uniqueRoleNameSet != null ? uniqueRoleNameSet : null;
        List<UserRole> userRolesList;
        if(uniqueRoleCodesSet != null){
            userRolesList = [SELECT Id,Name,DeveloperName 
                                FROM UserRole WHERE DeveloperName IN :uniqueRoleCodesSet WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }else{
            userRolesList = [SELECT Id,Name,DeveloperName 
                                FROM UserRole WHERE Name IN :uniqueRoleNameSet WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
        userRoleSet = new Set<String>(); 
        for(UserRole urole: userRolesList){
            userRoleSet.add(urole.Name);
            roleCodeToRoleNameMap.put(urole.DeveloperName,urole.Name);
            roleNameToRoleCodeMap.put(urole.Name,urole.DeveloperName);
            roleCodeToRoleIdMap.put(urole.DeveloperName,urole.Id);
        }
        getGroupsMap();
        
    } 

    private void getUniqueRoleCodeSet(){
        List<String> roleCodesList = new List<String>();
        List<String> criteriaRoleCodeList = incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c.split(',');        
        roleCodesList.addAll(criteriaRoleCodeList);

        if(incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c != null){ 
            List<String> shareWithRoleCodeList;
            if(Trigger.isInsert && incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c != incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c ){                            
                shareWithRoleCodeList = incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c.split(','); 
                roleCodesList.addAll(shareWithRoleCodeList); 
            }else if(Trigger.isUpdate && incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c != incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c && incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c !=  oldIncomingSobjectSharingRulesList[0].ShareWithRoleCodes__c){
                shareWithRoleCodeList = incomingSobjectSharingRulesList[0].ShareWithRoleCodes__c.split(','); 
                roleCodesList.addAll(shareWithRoleCodeList);       
            }
        }
        uniqueRoleCodesSet = new Set<String>(roleCodesList);
    }

    private void getUniqueRoleNameSet(){
        List<String> roleNamesList = new List<String>();
        publicGroupSet = new Set<String>();
        List<String> criteriaRoleNameList = incomingSobjectSharingRulesList[0].CriteriaRoleNames__c.split(',');        
        roleNamesList.addAll(criteriaRoleNameList);
        if(incomingSobjectSharingRulesList[0].ShareWithRoleNames__c != null){
            List<String> shareWithRoleNamesList;
            if(Trigger.isInsert && incomingSobjectSharingRulesList[0].CriteriaRoleNames__c != incomingSobjectSharingRulesList[0].ShareWithRoleNames__c){
                shareWithRoleNamesList = incomingSobjectSharingRulesList[0].ShareWithRoleNames__c.split(',');        
                roleNamesList.addAll(shareWithRoleNamesList);
            }else if(Trigger.isUpdate && incomingSobjectSharingRulesList[0].CriteriaRoleNames__c != incomingSobjectSharingRulesList[0].ShareWithRoleNames__c && incomingSobjectSharingRulesList[0].ShareWithRoleNames__c !=  oldIncomingSobjectSharingRulesList[0].ShareWithRoleNames__c){
                shareWithRoleNamesList = incomingSobjectSharingRulesList[0].ShareWithRoleNames__c.split(',');        
                roleNamesList.addAll(shareWithRoleNamesList);
            }
        }else if(incomingSobjectSharingRulesList[0].ShareWithPublicGroupNames__c != null){
            List<String> shareWithPublicGroupNamesList;
            if(Trigger.isInsert){
                shareWithPublicGroupNamesList = incomingSobjectSharingRulesList[0].ShareWithPublicGroupNames__c.split(',');        
                publicGroupSet.addAll(shareWithPublicGroupNamesList);
            }else if(Trigger.isUpdate && incomingSobjectSharingRulesList[0].ShareWithPublicGroupNames__c !=  oldIncomingSobjectSharingRulesList[0].ShareWithPublicGroupNames__c){
                shareWithPublicGroupNamesList = incomingSobjectSharingRulesList[0].ShareWithPublicGroupNames__c.split(',');        
                publicGroupSet.addAll(shareWithPublicGroupNamesList);
            }
        }   
        uniqueRoleNameSet = new Set<String>(roleNamesList);
    }

    private void setAllRequiredMapsOnInsert(){
        sobjectIdToSobjectNameMap = new Map<String,String>();
        
         if(incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c != null){
            getUniqueRoleCodeSet();
        }else if(incomingSobjectSharingRulesList[0].CriteriaRoleNames__c != null){
            getUniqueRoleNameSet();
        }
        sobjectIdToSobjectNameMap.put(incomingSobjectSharingRulesList[0].SObject__c,incomingSobjectSharingRulesList[0].SobjectName__c);
        
        if(incomingSobjectSharingRulesList.size() > 1){
            processOtherRecordsOnInsert();
        }   
        getRoleRelatedMaps();                 
    } 

    private void setAllRequiredMapsOnUpdate(){
        sobjectIdToSobjectNameMap = new Map<String,String>();
        
       if( incomingSobjectSharingRulesList[0].CriteriaRoleCodes__c  != null){
            getUniqueRoleCodeSet();
        }else if(incomingSobjectSharingRulesList[0].CriteriaRoleNames__c != null){
            getUniqueRoleNameSet();
        }
        sobjectIdToSobjectNameMap.put(incomingSobjectSharingRulesList[0].SObject__c,incomingSobjectSharingRulesList[0].SobjectName__c);
        
       if(incomingSobjectSharingRulesList.size() > 1){
            processOtherRecordsOnUpdate();
        }           
        getRoleRelatedMaps();                 
    }   

    /*---------------------------------------------------------------------------------------------------------------
    Pupose: 1. Validate roles names (comma separated) entered in RoleNames__c field against the UserRole.Name field.
            2. Avoid conflicting sharing rules for the same sobject
                    Example. Here the second rule should be prevented from creation.
                        a. One sibling rule with read only
                        b. Another sibling rule with read/write
            3. Avoid duplicate sharing rules for the same sobject with same access level
                    Example1. Here the second rule should be prevented from creation.
                        a. One sibling rule with read only
                        b. Another sibling rule with ready only
                    Example2. Here the second rule should be prevented from creation.
                        a. One family rule with read only
                        b. Another sibling rule with ready only which covers the nodes that are part of earlier family rule.

    ---------------------------------------------------------------------------------------------------------------*/
    private void filterAndMassageRecords(){                                
        Set<String> md5HashSet = new Set<String>();
        List<SObjectSharingRule__c> existingSharingRules;
        if(Trigger.isInsert){ 
            if(Schema.sObjectType.SObjectSharingRule__c.isAccessible()) {
                existingSharingRules = [SELECT Id,MD5Hash__c,CriteriaRoleCodes__c,
                                        ShareWithRoleCodes__c,SObject__c,RuleType__c,AccessLevel__c
                                        FROM SObjectSharingRule__c 
                                        WHERE SObject__c IN :sobjectIdToSobjectNameMap.keySet() WITH USER_MODE];
            }
        }else if(Trigger.isUpdate){
            if(Schema.sObjectType.SObjectSharingRule__c.isAccessible()) {
                existingSharingRules = [SELECT Id,MD5Hash__c,CriteriaRoleCodes__c,
                                            ShareWithRoleCodes__c,SObject__c,RuleType__c,AccessLevel__c
                                            FROM SObjectSharingRule__c 
                                            WHERE SObject__c IN :sobjectIdToSobjectNameMap.keySet()
                                            AND Id NOT IN :oldIncomingSobjectSharingRulesMap.keySet() WITH USER_MODE];
            }
        }
        for(SObjectSharingRule__c newSobjSharingRule : incomingSobjectSharingRulesList){
            setSharingRuleFields(newSobjSharingRule);
            List<String> newCriteriaRoleCodeList = newSobjSharingRule.CriteriaRoleCodes__c.split(',');  
            List<String> newShareWithRoleCodeList;
            if(newSobjSharingRule.ShareWithRoleCodes__c != null){         
                newShareWithRoleCodeList = newSobjSharingRule.ShareWithRoleCodes__c.split(',');  
            }   
            for(SObjectSharingRule__c  oldSobjSharingRule : existingSharingRules){
                List<String> oldCriteriaRoleCodeList = oldSobjSharingRule.CriteriaRoleCodes__c != null ? 
                                                            oldSobjSharingRule.CriteriaRoleCodes__c.split(',') : new List<String>();
                Set<String> oldCriteriaRoleCodeSet = new Set<String>(oldCriteriaRoleCodeList);
                List<String> oldShareWithRoleCodeList;
                Set<String> oldShareWithRoleCodeSet;
                if(newSobjSharingRule.ShareWithRoleCodes__c != null){
                    oldShareWithRoleCodeList = oldSobjSharingRule.ShareWithRoleCodes__c != null ?
                                                    oldSobjSharingRule.ShareWithRoleCodes__c.split(',')
                                                    : new List<String>();
                    oldShareWithRoleCodeSet = new Set<String>(oldShareWithRoleCodeList);
                }
                if(newSobjSharingRule.SObject__c == oldSobjSharingRule.SObject__c){if(newSobjSharingRule.RuleType__c != 'Family' 
                        && newShareWithRoleCodeList != null
                        && oldShareWithRoleCodeSet.containsAll(newShareWithRoleCodeList)
                        && oldCriteriaRoleCodeSet.containsAll(newCriteriaRoleCodeList)
                        && newSobjSharingRule.AccessLevel__c == oldSobjSharingRule.AccessLevel__c){
                        newSobjSharingRule.addError('A similar sharing role exists. Click <a href="/'+oldSobjSharingRule.Id+'">here</a> to view it.');
                        break;
                    }
                    if(newSobjSharingRule.RuleType__c == 'Family' &&  oldSobjSharingRule.RuleType__c == 'Family'                        
                        && oldCriteriaRoleCodeSet.containsAll(newCriteriaRoleCodeList)){
                        newSobjSharingRule.addError('A similar sharing role exists. Click <a href="/'+oldSobjSharingRule.Id+'">here</a> to view it.');
                        break;
                    }                    
                }
            }
            String md5Hash = getUniqueId(newSobjSharingRule); 
            newSobjSharingRule.MD5Hash__c = md5Hash; 
        }
        
    }

    private String getUniqueId(SObjectSharingRule__c sobjSharingRule){
        String uniqueString = sobjSharingRule.SObject__c + sobjSharingRule.CriteriaRoleCodes__c 
                                + sobjSharingRule.ShareWithRoleCodes__c 
                                + sobjSharingRule.RuleType__c + sobjSharingRule.Direction__c;                               
        return EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(uniqueString)));
    }

    public void getRoleSubordinateUsers(Id roleId){    
        // get all of the roles underneath the role passed in parameter
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
    }

    private Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();

        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id,Name,DeveloperName from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null WITH USER_MODE]){ //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            currentRoleIds.add(userRole.Id);
            familyChildNodeNames += userRole.Name + ',';
            familyChildNodeCodes += userRole.DeveloperName + ',';
        }
        if(currentRoleIds.size() > 0){
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }

    private void setAllNodesForFamilyRoot(SObjectSharingRule__c sobjSharingRule){
        String familyRootName = sobjSharingRule.ShareWithRoleNames__c;
        sobjSharingRule.FamilyRootRoleName__c = familyRootName;
        String rootCode = roleNameToRoleCodeMap.get(familyRootName);
        familyChildNodeNames = familyRootName + ',';  
        familyChildNodeCodes = rootCode + ',' ;     
        getRoleSubordinateUsers(roleCodeToRoleIdMap.get(rootCode));

        familyChildNodeNames = familyChildNodeNames.length() > 1 ? familyChildNodeNames.substring(0, familyChildNodeNames.length() - 1) : null;
        familyChildNodeCodes = familyChildNodeCodes.length() > 1 ? familyChildNodeCodes.substring(0, familyChildNodeCodes.length() - 1) : null;
        
        sobjSharingRule.CriteriaRoleNames__c = familyChildNodeNames;
        sobjSharingRule.CriteriaRoleCodes__c = familyChildNodeCodes;       
    }

    private void setSharingRuleFields(SObjectSharingRule__c sobjSharingRule){
        if(sobjSharingRule.RuleType__c == 'Family'){
            setAllNodesForFamilyRoot(sobjSharingRule);
        }
        if(sobjSharingRule.CriteriaRoleNames__c != null && sobjSharingRule.CriteriaRoleCodes__c == null){
            String criteriaRoleNames = sobjSharingRule.CriteriaRoleNames__c;
            String criteriaRoleCodeString = '';
            List<String> criteriaRoleNamesList = criteriaRoleNames.split(',');
            for(String criteriaRole : criteriaRoleNamesList){
                criteriaRoleCodeString += roleNameToRoleCodeMap.get(criteriaRole) + ',';
            }
            sobjSharingRule.CriteriaRoleCodes__c = criteriaRoleCodeString.length() > 1 ? criteriaRoleCodeString.substring(0, criteriaRoleCodeString.length() - 1) : null;
        }
        if(sobjSharingRule.ShareWithRoleNames__c != null && (sobjSharingRule.ShareWithRoleCodes__c == null || sobjSharingRule.ShareWithGroupIds__c == null)){
            String shareWithRoleNames = sobjSharingRule.ShareWithRoleNames__c;
            String shareWithRoleCodeString = '';
            String shareWithGroupIdString = '';
            Map<String,Id> roleCodeToGroupIdMap = new Map<String,Id>();
            if(sobjSharingRule.RuleType__c == 'Family'){
                roleCodeToGroupIdMap = groupMap.get('RoleAndSubordinates');
            }else{
                roleCodeToGroupIdMap = groupMap.get('Role');
            }
            List<String> shareWithRoleNamesList = shareWithRoleNames.split(',');
            for(String shareWithRole : shareWithRoleNamesList){
                String roleCode = roleNameToRoleCodeMap.get(shareWithRole);
                shareWithRoleCodeString += roleCode + ',';
                shareWithGroupIdString  += roleCodeToGroupIdMap.get(roleCode) + ',';
            }
            sobjSharingRule.ShareWithRoleCodes__c = shareWithRoleCodeString.length() > 1 ? shareWithRoleCodeString.substring(0, shareWithRoleCodeString.length() - 1) : null;
            sobjSharingRule.ShareWithGroupIds__c = shareWithGroupIdString.length() > 1 ? shareWithGroupIdString.substring(0, shareWithGroupIdString.length() - 1) : null;
        }
        if(sobjSharingRule.ShareWithPublicGroupNames__c != null && sobjSharingRule.ShareWithGroupIds__c == null){
            String shareWithGroupIdString = '';
            String shareWithPublicGroupNames = sobjSharingRule.ShareWithPublicGroupNames__c;
            List<String> shareWithPublicGroupNamesList = shareWithPublicGroupNames.split(',');
            Map<String,Id> groupNameToGroupIdMap = new Map<String,Id>();
            groupNameToGroupIdMap = groupMap.get('PublicGroup');
            for(String shareWithPublicGroup : shareWithPublicGroupNamesList){                
                shareWithGroupIdString  += groupNameToGroupIdMap.get(shareWithPublicGroup) + ',';
            }
            sobjSharingRule.ShareWithGroupIds__c = shareWithGroupIdString.length() > 1 ? shareWithGroupIdString.substring(0, shareWithGroupIdString.length() - 1) : null;
        }
    }
}