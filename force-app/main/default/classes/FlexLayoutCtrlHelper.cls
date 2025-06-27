/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class FlexLayoutCtrlHelper {

    public with sharing class HideAndReadLogicDataWrapper{
        private SObject record;
        private Boolean isInternal;
        private Boolean isApplicant;
        private String userProfile;
        private Map<String,Set<Id>> queueMemberSet;
                }

    public static List<PageBlockDetailConfig__c> getVisiblePageBlockDetails(List<PageBlockDetailConfig__c> activePageBlockDetails,HideAndReadLogicDataWrapper hideAndReadLogicData,Id recId,Boolean isViewContext){
            List<PageBlockDetailConfig__c> pgBlockDetailstoDisplay = new List<PageBlockDetailConfig__c>();

            for(PageBlockDetailConfig__c pgBlockDetailConfig : activePageBlockDetails){
                Boolean isHidden = isHidden(pgBlockDetailConfig.HideForProfile__c,pgBlockDetailConfig.HideForContext__c,
                                            pgBlockDetailConfig.HideForUser__c,pgBlockDetailConfig.Operator__c,
                                            pgBlockDetailConfig.HideExpressionJSON__c,pgBlockDetailConfig.HideDecisionField__c,
                                            pgBlockDetailConfig.HideforQueue__c, recId,hideAndReadLogicData.record,
                                            isViewContext, hideAndReadLogicData.isInternal, 
                                            hideAndReadLogicData.isApplicant, hideAndReadLogicData.userProfile,
                                            hideAndReadLogicData.queueMemberSet);
                if(!isHidden){
                    pgBlockDetailstoDisplay.add(pgBlockDetailConfig);
                }
            }

            return pgBlockDetailstoDisplay;
        }

    public static List<PageBlockConfig__c> getVisiblePageBlocks(List<PageBlockConfig__c> activePageBlocks,HideAndReadLogicDataWrapper hideAndReadLogicData,Id recId,Boolean isViewContext){
            List<PageBlockConfig__c> pgBlockstoDisplay = new List<PageBlockConfig__c>();

            for(PageBlockConfig__c pgBlockConfig : activePageBlocks){
                Boolean isHidden = isHidden(pgBlockConfig.HideForProfile__c,pgBlockConfig.HideForContext__c,
                                            pgBlockConfig.HideForUser__c,pgBlockConfig.Operator__c,
                                            pgBlockConfig.HideExpressionJSON__c,pgBlockConfig.HideDecisionField__c,
                                            pgBlockConfig.HideforQueue__c, recId,hideAndReadLogicData.record, isViewContext,
                                            hideAndReadLogicData.isInternal,hideAndReadLogicData.isApplicant,
                                            hideAndReadLogicData.userProfile, hideAndReadLogicData.queueMemberSet);
                if(!isHidden){
                    pgBlockstoDisplay.add(pgBlockConfig);
                }
            }

            return pgBlockstoDisplay;
        }

    public static List<TabConfig__c> getVisibleTabs(List<TabConfig__c> activeTabs,String objectName,Id recId,Boolean isViewContext){
            List<TabConfig__c> tabstoDisplay = new List<TabConfig__c>();
            //below 3 are used to call AppUtils.showHideComponent from isTabHidden method        
            Boolean isInternal = AppUtils.isInternalUser();
            Boolean isApplicant = AppUtils.isApplicant();
            String userProfile = AppUtils.getProfileInfo();
            Map<String,Set<Id>> queueMemberSet;

            //to check if HideDecisionField__c,HideExpressionFields__c & HideforQueue__c fields has values
            Set<String> hideDecisionFields = new Set<String>();//{'Id'};
            Set<String> queueNames = new Set<String>();
            for(TabConfig__c tab : activeTabs){            
                if(String.isNotEmpty(tab.HideDecisionField__c)){
                    hideDecisionFields.add(tab.HideDecisionField__c);
                }
                if(String.isNotEmpty(tab.HideExpressionFields__c)){
                    List<String> hideJsonFields = tab.HideExpressionFields__c.split(',');
                    hideDecisionFields.addAll(hideJsonFields);
                }            

                if(String.isNotEmpty(tab.HideforQueue__c)){                
                    queueNames.addAll(tab.HideforQueue__c.split(';'));
                }
            }
            SObject record;
            if(!hideDecisionFields.isEmpty()){
                if(recId!=null){
                    String queryStr = 'Select ' + String.escapeSingleQuotes(String.join(new List<String>(hideDecisionFields), ', ')) + ' from '+ String.escapeSingleQuotes(objectName) +' where id ='+ string.escapeSingleQuotes(recId) +'WITH USER_MODE';       
                    List<SObject> recordsList = Database.query(String.escapeSingleQuotes(queryStr));   //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind         
                    if(recordsList.size()==1){
                        record = recordsList[0];
                    }
                }else{
                    record = Schema.getGlobalDescribe().get(objectName).newSObject() ;
                }
               
            }else{
                record = Schema.getGlobalDescribe().get(objectName).newSObject() ;
            }

            if(queueNames.size()>0){
                queueMemberSet = loadQueueMemberSet(queueNames);                      
            }
            
            for(TabConfig__c tab : activeTabs){                
                Boolean isHidden = isHidden(tab.HideForProfile__c,tab.HideForContext__c,tab.HideForUser__c,tab.Operator__c,
                                            tab.HideExpressionJSON__c,tab.HideDecisionField__c,tab.HideforQueue__c, recId,
                                            record, isViewContext, isInternal, isApplicant, userProfile, queueMemberSet);
                if(!isHidden){
                    tabstoDisplay.add(tab);
                }
            }

            return tabstoDisplay;
        }  

    private static Boolean isHidden(String hideForProfile,String hideForContext,String hideForUser,String operator,String hideExpressionJSON,String hideDecisionField,String hideforQueue,String recordId,SObject record,Boolean isViewLayout,Boolean isInternal,Boolean isApplicant,String userProfile,Map<String,Set<Id>> queueMemberSet){        
        Set<Boolean> isHiddenSet = new Set<Boolean>();

        if(String.isEmpty(hideExpressionJSON)){
            Boolean callAppUtilsMehtod = (String.isNotBlank(hideForProfile) || String.isNotBlank(hideForContext) || String.isNotBlank(hideForUser)) ? true : false;
            if(callAppUtilsMehtod){
                isHiddenSet.add(AppUtils.showHideComponent(isViewLayout ,isInternal,isApplicant,hideForProfile, recordId, hideForContext, hideForUser,userProfile, operator));
            }
        }
        //checking based on HideExpressionJSON__c & HideDecisionField__c        
        if(!String.isEmpty(hideExpressionJSON)){
            if(isViewLayout){
                isHiddenSet.add(ExpressionJsonEvaluator.evaluateExpression(hideExpressionJSON,record,'View'));
            }
            //for edit context
            else{
                String context = String.isBlank(recordId) ? 'Create' : 'Edit';
                isHiddenSet.add(ExpressionJsonEvaluator.evaluateExpression(hideExpressionJSON,record,context)); 
            }
            
        }else if(!String.isEmpty(hideDecisionField)){
                Object val = AppUtils.getFieldValue(record, hideDecisionField);
                if(val != null) {
                    isHiddenSet.add((Boolean)val);
                }else{
                    isHiddenSet.add(false);
                }
        }

        //for queues    
        if(String.isNotEmpty(hideforQueue)){
            Boolean isHiddenFromQueue = false;
            List<String> queueNames = hideforQueue.split(';');

            for(String queueName : queueNames){
                if(queueMemberSet.containsKey(queueName) && queueMemberSet.get(queueName).contains(UserInfo.getUserId()) ){
                    isHiddenFromQueue = true;
                    break;
                }
            }

            isHiddenSet.add(isHiddenFromQueue);
        }
        
        if(isHiddenSet.isEmpty() || isHiddenSet.contains(null)){
            return false;
        }else{
            Boolean isHidden;
            for(Boolean val : isHiddenSet){
                if(operator.equalsIgnoreCase('AND')){
                    isHidden = isHidden==null?val:isHidden && val;
                }else{
                    isHidden = isHidden==null?val:isHidden || val;
                }
            }
            isHidden = isHidden==null?false:isHidden;
            return isHidden;
        }
    }

    public static HideAndReadLogicDataWrapper hideAndReadLogicDataInitializer(List<PageBlockConfig__c> activePgBlockConfigs,String objectName,Id recId){
        HideAndReadLogicDataWrapper hideAndReadLogicData = new HideAndReadLogicDataWrapper();

        Set<String> decisionFields = new Set<String>();
        Set<String> queueNames = new Set<String>();

        for(PageBlockConfig__c pgBlockConfig : activePgBlockConfigs){
            if(String.isNotEmpty(pgBlockConfig.HideDecisionField__c)){
                decisionFields.add(pgBlockConfig.HideDecisionField__c);
            }

            if(String.isNotEmpty(pgBlockConfig.HideExpressionFields__c)){
                List<String> hideJsonFields = pgBlockConfig.HideExpressionFields__c.split(',');
                decisionFields.addAll(hideJsonFields);
            }

            if(String.isNotEmpty(pgBlockConfig.HideforQueue__c)){                
                queueNames.addAll(pgBlockConfig.HideforQueue__c.split(';'));
            }

            for(PageBlockDetailConfig__c pgBlockDetailConfig : pgBlockConfig.PageBlockFieldConfig__r){
                if(String.isNotEmpty(pgBlockDetailConfig.HideDecisionField__c)){
                    decisionFields.add(pgBlockDetailConfig.HideDecisionField__c);
                }

                if(String.isNotEmpty(pgBlockDetailConfig.HideExpressionFields__c)){
                    List<String> hideJsonFields = pgBlockDetailConfig.HideExpressionFields__c.split(',');
                    decisionFields.addAll(hideJsonFields);
                }

                if(String.isNotEmpty(pgBlockDetailConfig.ReadDecisionField__c)){
                    decisionFields.add(pgBlockDetailConfig.ReadDecisionField__c);
                }

                if(String.isNotEmpty(pgBlockDetailConfig.ReadOnlyExpressionFields__c)){
                    List<String> readJsonFields = pgBlockDetailConfig.ReadOnlyExpressionFields__c.split(',');
                    decisionFields.addAll(readJsonFields);
                }

                if(String.isNotEmpty(pgBlockDetailConfig.HideforQueue__c)){                
                    queueNames.addAll(pgBlockDetailConfig.HideforQueue__c.split(';'));
                }
            }
        }
        
        if(!decisionFields.isEmpty() && recId!=null){
            String queryStr = 'Select ' + String.escapeSingleQuotes(String.join(new List<String>(decisionFields), ', ')) + ' from '+ String.escapeSingleQuotes(objectName) +' where id =: '+String.escapeSingleQuotes(recId)+' WITH USER_MODE';       
            List<SObject> recordsList = Database.query(String.escapeSingleQuotes(queryStr));  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind          
            if(recordsList.size()==1){
                hideAndReadLogicData.record = recordsList[0];
            }
        }

        if(hideAndReadLogicData.record == null){
            hideAndReadLogicData.record = Schema.getGlobalDescribe().get(objectName).newSObject();
        }

        if(queueNames.size()>0){
            hideAndReadLogicData.queueMemberSet = loadQueueMemberSet(queueNames);
        }
        
        hideAndReadLogicData.isInternal = AppUtils.isInternalUser();
        hideAndReadLogicData.isApplicant = AppUtils.isApplicant();
        hideAndReadLogicData.userProfile = AppUtils.getProfileInfo();

        return hideAndReadLogicData;
    }

    public static Map<Id,Boolean> getReadOnlyDetails(List<PageBlockDetailConfig__c> activePageBlockDetails,HideAndReadLogicDataWrapper hideAndReadLogicData,Id recId,Boolean isViewContext){
        Map<Id,Boolean> readOnlyFieldMap = new Map<Id,Boolean>();
        Sobject record = hideAndReadLogicData.record;
        Boolean isInternal = hideAndReadLogicData.isInternal;
        Boolean isApplicant = hideAndReadLogicData.isApplicant;
        String userProfile = hideAndReadLogicData.userProfile;
        String userRole = AppUtils.getRoleInfo();
        
        for(PageBlockDetailConfig__c pgBlockDetail: activePageBlockDetails){
            readOnlyFieldMap.put(pgBlockDetail.Id,false);//if no read logic
            if(pgBlockDetail.ReadOnly__c){
                readOnlyFieldMap.put(pgBlockDetail.Id,true);
            }else{
                Boolean hasReadOnlyLogic = false;
                if(pgBlockDetail.ReadOnlyForProfile__c != null || pgBlockDetail.ReadOnlyForContext__c != null || pgBlockDetail.ReadOnlyForUser__c != null || pgBlockDetail.ReadOnlyForRole__c != null) {
                    hasReadOnlyLogic = true;
                }   
                Boolean readDecision = AppUtils.readOnlyOrEditableForComponent(isViewContext,isInternal,isApplicant,pgBlockDetail.ReadOnlyForProfile__c,
                        recId,pgBlockDetail.ReadOnlyForContext__c,pgBlockDetail.ReadOnlyForUser__c,userProfile,userRole,pgBlockDetail.ReadOnlyForRole__c);

                if(readDecision){ 
                    readOnlyFieldMap.put(pgBlockDetail.Id,readDecision);
                    continue;
                }

                if(String.isNotEmpty(pgBlockDetail.ReadOnlyExpressionJSON__c)){
                    Boolean isReadOnly = false;
                    if(isViewContext){
                        isReadOnly = ExpressionJsonEvaluator.evaluateExpression(pgBlockDetail.ReadOnlyExpressionJSON__c,record,'View');
                    }
                    else{
                        String context = String.isBlank(recId) ? 'Create' : 'Edit';
                        if(context == 'Edit'){
                            isReadOnly =  ExpressionJsonEvaluator.evaluateExpression(pgBlockDetail.ReadOnlyExpressionJSON__c,record,context);
                        }
                    }
                    readOnlyFieldMap.put(pgBlockDetail.Id, isReadOnly);
                }else if(String.isNotEmpty(pgBlockDetail.ReadDecisionField__c)){
                    Boolean isReadOnly = (Boolean)record.get(pgBlockDetail.ReadDecisionField__c);
                    
                    if(isReadOnly != null && hasReadOnlyLogic){
                        if(pgBlockDetail.Operator__c == 'AND') {
                            readOnlyFieldMap.put(pgBlockDetail.Id,(isReadOnly && readDecision));
                        } else {
                            readOnlyFieldMap.put(pgBlockDetail.Id,(isReadOnly || readDecision));
                        }
                    }else{
                        readOnlyFieldMap.put(pgBlockDetail.Id,isReadOnly);
                    }
                }else{
                    readOnlyFieldMap.put(pgBlockDetail.Id,readDecision);
                }
            }    
        }
        return readOnlyFieldMap;
    }

    public static Map<String,Set<Id>> loadQueueMemberSet(Set<String> queueNames){
        Map<String,Set<Id>> queueMemberSet = new Map<String,Set<Id>>();

        if(queueNames.size()>0){
            List<GroupMember> groupMembers = [SELECT Id, GroupId, UserOrGroupId, Group.DeveloperName 
                                                FROM GroupMember where Group.DeveloperName in :queueNames
                                                and Group.type = 'Queue' WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            
            for(GroupMember memberInstance : groupMembers){
                if(queueMemberSet.get(memberInstance.Group.DeveloperName) != null){
                    Set<Id> memberList = queueMemberSet.get(memberInstance.Group.DeveloperName);
                    memberList.add(memberInstance.UserOrGroupId);
                    queueMemberSet.put(memberInstance.Group.DeveloperName, memberList);            
                } else {
                    Set<Id> memberList = new Set<Id> ();
                    memberList.add(memberInstance.userOrGroupId);
                    queueMemberSet.put(memberInstance.Group.DeveloperName, memberList);
                }
            }
        }
        return queueMemberSet;
    }
}