global with sharing class ApprovalDecisionCtrl {
    public transient String chosenRoleName {get;set;}
    public transient String approvalActionChosen {get;set;}
    public transient String chosenUserId {get;set;}
    public transient String comments {get;set;}
    public transient List<ProcessInstanceNode> processInstanceNode {get;set;}
    public transient Boolean showComponent {get;set;}
    private transient boolean hasOwner {get;set;}
    public transient String showMessage {get;set;}
    public transient boolean isError {get;set;}
    public transient boolean showUserPanel {get;set;}
    public transient String classForMessage {get;set;}
    public transient Boolean showAsterisk {get;set;}
    public transient string  templateName {get;set;}
    public transient string flexTableParam {get;set;}
    public transient string listParam {get;set;}
    public transient boolean nextStepExists {get;set;}
    public transient string userFilter {get;set;}
    private transient string objectName;
    public transient string layoutContext {get;set;}

    private transient Map<String,ApprovalDecisionActionConfig__c> actionConfigMap;
    public transient string commentActionMap {get;set;}
    private transient List<ApprovalDecisionActionConfig__c> approvalDecisionActionConfigList;
    //Variable to store object Info 
    private transient SchemaManager.SObjectWrapper parentSObject;
    //Variable to store record Id
    private transient Id recordId;
    private transient string commentsFieldAPIName;
    public transient boolean showDelegatedHeader = false;
    public transient boolean isSendToowner = false;
    public Boolean skipUpdateAccessCheckForGuestUser {get;set;}
    global ApprovalDecisionCtrl (){
        skipUpdateAccessCheckForGuestUser = AppUtils.isSkipPermissionCheck();
    }

    @AuraEnabled
    public static Map<String, Object> getApprovalOptionsLightning(Id recordId , String layoutContext) {
		List<ProcessInstanceWorkitem> workItemList = 
            SystemContextMethodsHelper.getRecordProcessInstanceWorkitems(recordId);
        
        if(workItemList!=null && !workItemList.isEmpty()){
        return getApprovalOptions(recordId,layoutContext);
        }else {
            return new Map<String, Object> {'RenderComponent' => false};
        }
    }

    @AuraEnabled 
    public static Map<String, Object> submitRecordsLightning(String action,Id recordId,String comment,String chosenUsersId){
        return submitRecords(action,recordId,comment,chosenUsersId);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getUserQueueRecordsLightning(Map<String,Object> paramMap) {
        return getUserQueueRecords(paramMap);
    }

    global static Map<String, Object> getApprovalOptions(Id recordId) {
        String recIdStr = String.escapeSingleQuotes(String.valueOf(recordId));
        return getApprovalOptions(Id.valueOf(recIdStr),'View');  //return getApprovalOptions(recordId,'View');
    }
    
    // In this method added mode parameter to get layouttype.
    @RemoteAction
    global static Map<String, Object> getApprovalOptions(Id recordId , String layoutContext) {
        List<Map<String, String>> result = new  List<Map<String, String>>();
        Map<String, Object> returnMap = new Map<String, Object>();
        ApprovalDecisionCtrl approval = new ApprovalDecisionCtrl();
        approval.layoutContext = layoutContext;
        approval.recordId = Id.valueOf(String.escapeSingleQuotes(recordId));
        approval.loadApprovaldecisionData(recordId);
        //result.add( new Map<String, String>{'label'=>'-- Select --', 'name'=>'-- Select --'} );
        result = approval.getApprovalActions();
        for(Map<String, String> map1 : result){
            if(map1.get('Action') == 'Reassign'){
                map1.put('filterClause',approval.userFilter);
            }
        }
        //Prajakta: Below method is used to check if Current user is submittor,Current user is member of queue and custom setting value is true then we need to hide approval component for Submittor.
        Boolean isUserSubmittor = approval.isCurrentUserRecordSubmittor(recordId); 
       if(isUserSubmittor){
            List<String> messageList = new  List<String>();
            messageList.add(System.Label.CurrentUserAsSubmittor);
            returnMap.put('recordSendToowner',true);
            returnMap.put('errorList',messageList);                
       }else if(approval.isSendToowner == true){
            List<String> messageList = new  List<String>();
            messageList.add(System.Label.RecordSendToOwner);

            returnMap.put('recordSendToowner',true);
            returnMap.put('msgList',messageList);
                
       }else{
            returnMap.put('Options',result);
            returnMap.put('RenderComponent',approval.showComponent);
            returnMap.put('IsDelegate',approval.showDelegatedHeader);
       }
       return returnMap;
    }

    @RemoteAction
    global static Map<String, Object> submitRecords(String action,Id recordId,String comment,String chosenUsersId) {
    //Savepoint sp = Database.setSavepoint();
    Map<String, Object> resultlist = new  Map<String, Object>();
    List<String> messageList = new  List<String>();
        try{
            ApprovalDecisionCtrl approval = new ApprovalDecisionCtrl();
            approval.comments = comment;
            approval.approvalActionChosen = action;
            approval.recordId = recordId;
            approval.chosenUserId = chosenUsersId;
            //Add new parameter 'chosenUsersId' for sendForApproval() when user is going to reassign owner for Opportunity.
            approval.sendForApproval(messageList,chosenUsersId);
            resultlist.put('Success',true);
            if(action == 'Approve'){
                messageList.add(System.Label.ApprovalRequest);
            }
            if(action == 'Disapprove'){
                messageList.add(System.Label.DisapproveRequest);
            }
            if(action == 'Reassign'){
                messageList.add(System.Label.ReassignRequest);
            }
            if(action == 'Send to Owner'){
                messageList.add(System.Label.SendToOwnerRequest);
            }
            resultlist.put('msgList',messageList);
        }catch(Exception e) {
             // resultlist.put('Message',e.getMessage());
            
            //resultlist.put('Message',AppUtils.handleSystemExceptionMsg(e.getMessage()));
            resultlist.put('Message',AppUtils.handleSystemExceptionMsg(e));
            resultlist.put('Success',false);
            //showMessage = e.getMessage();
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error ' + String.valueOf(e.getLineNumber()) + ': ' + e.getMessage()));    
            // Database.rollback( sp );
            CustomExceptions.logException(e, true, false);
            return resultlist;
        }
        return resultlist;
    }

    global static Map<String, Object> getUserRecords(String filterClause) {
        return getUserRecords(filterClause, null);
    }


   
    global static Map<String, Object> getUserRecords(String filterClause, String keyValueMapString) {
       return null;
    }


    @TestVisible 
    public with sharing class ApprovalDecisionWrapper{
        @AuraEnabled
		public list<sObject> ObjectList {get;set;}
		@AuraEnabled
		public Map<String, String> fieldKeyMap {get;set;}
		@AuraEnabled
		public Map<String, String> fieldDataMap  {get;set;}
		@AuraEnabled
		public Map<String, Integer> scale {get;set;}
		@AuraEnabled
		public String timelol {get;set;}   
		@AuraEnabled
		 public String userLol {get;set;}
		@AuraEnabled
		public String field {get;set;}
		 @AuraEnabled
		public String requiredfield {get;set;}
		 @AuraEnabled
		public String testrequired {get;set;}
		 @AuraEnabled
		public String fieldlabel {get;set;}
		@AuraEnabled
		public String key {get;set;}
		@AuraEnabled 
		public Boolean IsKeyAvailable{get;set;}
		@AuraEnabled 
		public String KeyValueMapRequired {get;set;}
		@AuraEnabled 
		public String AlternateFieldLabel {get;set;}
		@AuraEnabled 
		public Boolean IsAlternateFieldAvailable {get;set;}
		@AuraEnabled 
		public Boolean IsAlternateFieldRequired {get;set;}
		@AuraEnabled 
		public String parentObjectName {get;set;}
		@AuraEnabled 
		public String parentObjectType {get;set;}
		@AuraEnabled 
		public String parentObjectClassName {get;set;}
		@AuraEnabled 
		public Boolean IsfieldKeyMapAvailable {get;set;}
		@AuraEnabled 
		public Boolean IsfieldDataMapAvailable {get;set;}
		@AuraEnabled 
		public Boolean IsRequiredfield {get;set;}
		@AuraEnabled 
		public String RecordTypeName {get;set;}
         

        public ApprovalDecisionWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label,Boolean IsKeyAvailable,String KeyValueMapRequired,String AlternateFieldLabel, String parentObjectName, String parentObjectType, String parentObjectClassName,boolean IsfieldKeyMapAvailable,boolean IsfieldDataMapAvailable, boolean IsRequiredfield, string RecordTypeName){
            this.ObjectList = sObjectList;
        this.fieldKeyMap = fieldLableMap;
        this.fieldDataMap = fieldDataTypeMap;
        this.scale = scaleMap;
        this.timelol = (UserInfo.getTimeZone()).toString();
        this.userLol =UserInfo.getLocale();
        this.field = label;
        this.requiredfield = label;
        this.testrequired = label;
        this.fieldlabel = label;
        this.key  = label;
        this.IsKeyAvailable = IsKeyAvailable;
        this.KeyValueMapRequired = KeyValueMapRequired;
        this.AlternateFieldLabel = AlternateFieldLabel;
        this.parentObjectName = parentObjectName;
        this.parentObjectType = parentObjectType;
        this.parentObjectClassName = parentObjectClassName;
        this.IsfieldKeyMapAvailable = IsfieldKeyMapAvailable;
        this.IsfieldDataMapAvailable = IsfieldDataMapAvailable;
        this.IsRequiredfield = IsRequiredfield;
        this.RecordTypeName = RecordTypeName;
        }
    }

    /*Prajakta:This method is used to in ressign action of approval process. It is use in case of queue to queue,user to queue,user to user and queue to user reassignment.*/
    @RemoteAction
    global static Map<String, Object> getUserQueueRecords(Map<String,Object> paramMap) {
        String filterClause;
        if(String.valueOf(paramMap.get('filterClause')) != null && String.valueOf(paramMap.get('filterClause')) != 'undefined'){
            filterClause = String.valueOf(paramMap.get('filterClause'));
        }
        String flexTableParameters ;
        if(String.valueOf(paramMap.get('flexTableParameters')) != null && String.valueOf(paramMap.get('flexTableParameters')) != 'undefined'){
            flexTableParameters = String.valueOf(paramMap.get('flexTableParameters'));
        }
        String listParameters;
        if(String.valueOf(paramMap.get('listParameters')) != null && String.valueOf(paramMap.get('listParameters')) != 'undefined'){
            listParameters = String.valueOf(paramMap.get('listParameters'));
        }
        String queueOption;
        if(String.valueOf(paramMap.get('queueOption')) != null && String.valueOf(paramMap.get('queueOption')) != 'undefined'){
            queueOption = String.valueOf(paramMap.get('queueOption'));
        }
        String queueFilterClause;
        if(String.valueOf(paramMap.get('queueFilterClause')) != null && String.valueOf(paramMap.get('queueFilterClause')) != 'undefined'){
            queueFilterClause = String.valueOf(paramMap.get('queueFilterClause'));
        }
        List<Map<String,String>> resultList = new List<Map<String,String>>();
            //In case of queueOption as Both it should display both users and queue in reassign dropdown list.
             if(String.isEmpty(queueOption) || queueOption == 'User' || queueOption == 'Both'){
                resultList.addAll(getUserList(filterClause,flexTableParameters,listParameters));

             }
             if(queueOption == 'Queue' || queueOption == 'Both'){
                resultList.addAll(getQueueList(queueFilterClause,flexTableParameters,listParameters));
            }
            Map<String, Object> returnMap = new Map<String, Object>(); 
            returnMap.put('SobjList', resultList);
        return returnMap;
    }

    /*Prajakta:Below method is used to get userslist to show in dropdown.*/
    private static List<Map<String,String>> getUserList(String filterClause, String flexTableParameters, String listParameters){
            String query = 'select Name from User';
            if(String.isNotEmpty(filterClause) && String.isNotEmpty(flexTableParameters)) {
                Map<String,Object> margeFieldKeyValueMap =  (Map<string,object>)JSON.deserializeUntyped(flexTableParameters);     
                filterClause = new FlexTableCtrl().getFilterClauseString(filterClause, margeFieldKeyValueMap);
            }

            if(String.isNotEmpty(filterClause) && String.isNotEmpty(listParameters)) {
                Map<String,Object> margeFieldKeyValueMap =  (Map<string,object>)JSON.deserializeUntyped(listParameters);     
                filterClause = new FlexTableCtrl().getFilterClauseString(filterClause, margeFieldKeyValueMap);
            }
            List<User> users = new List<User>();
            if(String.isNotEmpty(filterClause)) {
                query += ' where '+AppUtils.parseWhereClause(filterClause) + ' ORDER BY Name';//SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause clause
            }
            users = SystemContextMethodsHelper.runQueryInSystemMode(query,null); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            List<Map<String,String>> result = new List<Map<String,String>>();
            for(User u : users){
                Map<String,String> item = new Map<String,String>();
                item.put('id',u.Id);
                item.put('text',u.Name);
                result.add(item);
            }  
            return result;
    }

        /*Prajakta:Below method is used to get queuelist to show in dropdown*/
    private static List<Map<String,String>> getQueueList(String queueFilterClause, String flexTableParameters, String listParameters){
        String query = 'select Name,DeveloperName__c,QueueId__c from GGQueue__c';
        if(String.isNotEmpty(queueFilterClause) && String.isNotEmpty(flexTableParameters)) {
            Map<String,Object> margeFieldKeyValueMap =  (Map<string,object>)JSON.deserializeUntyped(flexTableParameters);     
            queueFilterClause = new FlexTableCtrl().getFilterClauseString(queueFilterClause, margeFieldKeyValueMap);
        }

        if(String.isNotEmpty(queueFilterClause) && String.isNotEmpty(listParameters)) {
            Map<String,Object> margeFieldKeyValueMap =  (Map<string,object>)JSON.deserializeUntyped(listParameters);     
            queueFilterClause = new FlexTableCtrl().getFilterClauseString(queueFilterClause, margeFieldKeyValueMap);
        }

       
        List<GGQueue__c> queueList = new List<GGQueue__c>();
        if(String.isNotEmpty(queueFilterClause)) {
            query += ' WHERE ' + AppUtils.parseWhereClause(queueFilterClause)+' ORDER BY Name';//SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of queueFilterClause clause
        }
        if(Schema.sObjectType.GGQueue__c.isAccessible()) {
            queueList = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
        }
        List<Map<String,String>> result = new List<Map<String,String>>();
        for(GGQueue__c u : queueList){
            Map<String,String> item = new Map<String,String>();
            item.put('id',u.QueueId__c);
            item.put('text',u.Name);
            result.add(item);
        }  
        return result;
    }

    private List<ApprovalDecisionActionConfig__c> getApprovalDecisionActionConfigList(id recordId){
        
        String customAppName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        if(String.isEmpty(customAppName)){
            CustomExceptions.logException(String.format(System.Label.UserPrefrenceLabel, new List<String>{Userinfo.getUserId()}), false);
        }

        List<ApprovalDecisionActionConfig__c> approvalDecisionActionConfigList =  new List<ApprovalDecisionActionConfig__c>();
        if(recordId != null) {
            parentSObject = SchemaManager.getSObject((Id)recordId);
            try{
                SchemaManager.SObjectFieldWrapper fieldWrapper =parentSObject.getField('OwnerId');
                hasOwner = true;
            }catch(Exception e){
                hasOwner = false;    
            }
            if(parentSObject != null && parentSObject.objectName != null){
                if(!string.isEmpty(parentSObject.objectName)){
                    if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible()){
                        approvalDecisionActionConfigList  =  [SELECT ActionLabelOverride__c,Action__c,CommentsFieldsAPIName__c,CommentsRequired__c,HideAction__c,
                                                            FilterCriteriaforUserReassign__c,SobjectConfig__r.ApprovalReCallEnable__c,SobjectConfig__r.ApprovalReCallFieldAPIName__c,
                                                            SobjectConfig__r.ApprovalReCallCommentFieldAPIName__c,ConfirmationMessage__c,ConfirmationTitle__c,HideExpressionJSON__c,QueueReassignOptions__c,FilterCriteriaforQueueReassign__c FROM ApprovalDecisionActionConfig__c 
                                                            WHERE SobjectConfig__r.Name =:parentSObject.objectName AND CustomAppConfig__r.Name=:customAppName WITH USER_MODE ORDER BY Sequence__c];
                    }
                }
            }
            objectName = parentSObject.objectName;
        }
        return approvalDecisionActionConfigList;
    }

    private void loadApprovaldecisionData(Id recordId) {
        showAsterisk = true;
        actionConfigMap = new Map<String,ApprovalDecisionActionConfig__c> ();
        nextStepExists = true;
        isError = false;
        //recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));
        if(recordId != null && ProcessInstanceWorkItem.sObjectType.getDescribe().isAccessible() == true){
            showComponent = false;
            approvalDecisionActionConfigList =  new List<ApprovalDecisionActionConfig__c>();
            approvalDecisionActionConfigList = getApprovalDecisionActionConfigList(recordId);
            Map<String,boolean> commentActionMandatoryMap = new Map<String,Boolean>();
            userFilter =   String.isEmpty(userFilter) ? 'IsActive=true': ' AND IsActive=true ';
            if(approvalDecisionActionConfigList != null && approvalDecisionActionConfigList.size() > 0) {
                Boolean isSentToOwnerCheck = isSentTOOwner(approvalDecisionActionConfigList[0]);
                if( isSentToOwnerCheck ) {
                     isSendToowner = true;
                    return;
                }
            }
            for(ApprovalDecisionActionConfig__c approvalDecisionActionConfig: approvalDecisionActionConfigList){
                actionConfigMap.put(approvalDecisionActionConfig.Action__c,approvalDecisionActionConfig);
                commentActionMandatoryMap.put(approvalDecisionActionConfig.Action__c,approvalDecisionActionConfig.CommentsRequired__c);
                if(!String.isEmpty(approvalDecisionActionConfig.FilterCriteriaforUserReassign__c)){
                   userFilter = approvalDecisionActionConfig.FilterCriteriaforUserReassign__c;
                   //userFilter =String.escapeSingleQuotes(userFilter);
                }
            }
            commentActionMap = json.serialize(commentActionMandatoryMap); 
           List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
            if(ProcessInstanceWorkitem.sObjectType.getDescribe().isAccessible() == true){
                workItemList = SystemContextMethodsHelper.getRecordProcessInstanceWorkitems(recordId);
            }
            List<String> actorIdList = new List<String>();
            for(ProcessInstanceWorkitem processWorkitem : workItemList ){
                actorIdList.add(processWorkitem.ActorId);
            }
            List<User> delegatedApprovers = new List<User>();
            Boolean hideDelagateUserForDate = true;
            Date d1 = date.today();
            delegatedApprovers = [SELECT id,Name,DelegatedApproverId,DelegateFrom__c,DelegateTo__c,EnableDelegate__c FROM User WHERE Id IN:actorIdList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            set<String> delegateApproversSet = new set<String>();
            for(User u : delegatedApprovers){
                if(u.DelegatedApproverId != null){
                    delegateApproversSet.add(u.DelegatedApproverId);
                }
                if(u.DelegatedApproverId == UserInfo.getUserId() && d1 >= u.DelegateFrom__c && d1 <= u.DelegateTo__c && u.EnableDelegate__c == true){
                    hideDelagateUserForDate = false;
                }
            }
            //ApprovalDecisionCtrl approval = new ApprovalDecisionCtrl();
            processInstanceNode = [SELECT Id,NodeStatus,ProcessInstanceId,ProcessNodeId,ProcessNodeName,ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId 
                                    FROM ProcessInstanceNode 
                                    where  ProcessInstance.TargetObjectId = :recordId And NodeStatus in('Started', 'Pending') WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users    

            Boolean delegateApprove = false;
            if(processInstanceNode.size() > 0){
                 String approvalDefinationId1 = processInstanceNode.get(0).ProcessInstance.ProcessDefinitionId;
                 String approvalStepId1 = processInstanceNode.get(0).ProcessNodeId;
                 List<ApprovalProcessStepCache__c>  approvalStepCacheList = new List<ApprovalProcessStepCache__c>();
                 if(Schema.sObjectType.ApprovalProcessStepCache__c.isAccessible()){
                    approvalStepCacheList = [SELECT ApprovalDefinitionId__c,ApprovalStepId__c,allowDelegate__c FROM ApprovalProcessStepCache__c 
                                                                            Where ApprovalDefinitionId__c = : approvalDefinationId1 And ApprovalStepId__c = : approvalStepId1 WITH USER_MODE]; //SF Review
                 }                                                                            
                 if(approvalStepCacheList.size() > 0) {
                    delegateApprove = approvalStepCacheList.get(0).allowDelegate__c;
                }
            }
            showMessage = '';
            showUserPanel = false;
            classForMessage = 'alert alert-dismissable alert-';
            if(workItemList.isEmpty() == true){
                showComponent = false;
            } else{
                if(workItemList.isEmpty() != true){
                    //If the Approval was assigned to a User - Actor Id Type is a User then show Component for Approval
                    List<String> groupIds = new List<String>();
                     Id uId = UserInfo.getUserId();
                    for(ProcessInstanceWorkitem processIntanceWorkItem : workItemList) {
                        Id piwActorId = processIntanceWorkItem.ActorId;
                        if(processIntanceWorkItem.Actor.Type != null && processIntanceWorkItem.Actor.Type.equals('User') && piwActorId == uId) {
                            showComponent = true;
                            break;
                        } else {
                            groupIds.add(processIntanceWorkItem.ActorId);
                        }
                    }
                    //If the Approval was assigned to a Queue(Group) -- Check if the logged in user is a member of the Group -- If Yes then show Component for Approval
                    if(showComponent == false && groupIds.size() > 0) {
                        checkGroupData(groupIds);
                    }
                    //Delegate Approvar changes for Queue started
                    List<GroupMember> groupMembers;
                   
                    if(groupIds != null) {
                        groupMembers =[SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: groupIds WITH USER_MODE LIMIT :AppUtils.SOQL_LIMIT];  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    } 

                    Set<Id> activeUsers = new Set<Id>();
                    for(GroupMember grpMember1 : groupMembers){
                        activeUsers.add(grpMember1.UserOrGroupId);
                    }

                    List<User> delegatedApproversForQueue = new List<User>();
                    delegatedApproversForQueue = [SELECT id,Name,DelegatedApproverId,DelegateFrom__c,DelegateTo__c,EnableDelegate__c FROM User WHERE Id IN:activeUsers WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    for(User u : delegatedApproversForQueue){
                        if(u.DelegatedApproverId != null){
                            delegateApproversSet.add(u.DelegatedApproverId);
                        }
                        if(u.DelegatedApproverId == UserInfo.getUserId() && d1 >= u.DelegateFrom__c && d1 <= u.DelegateTo__c && u.EnableDelegate__c == true){
                            hideDelagateUserForDate = false;
                        }
                    }

                    ////Delegate Approvar changes for Queue end

                    if(showComponent == false && delegateApproversSet.size() > 0 && delegateApprove == true ) {
                        for(ProcessInstanceWorkitem processIntanceWorkItem : workItemList){
                            if(processIntanceWorkItem.Actor.Type != null && processIntanceWorkItem.Actor.Type.equals('User') && delegateApproversSet.contains(UserInfo.getUserId()) && hideDelagateUserForDate == false){
                                 showComponent = true;
                                 showDelegatedHeader = true;
                                 break;
                            }
                            if(processIntanceWorkItem.Actor.Type != null && processIntanceWorkItem.Actor.Type.equals('Queue') && delegateApproversSet.contains(UserInfo.getUserId()) && hideDelagateUserForDate == false){
                                 showComponent = true;
                                 showDelegatedHeader = true;
                                 break;
                            }
                        }
                    }
                }
            }
        }
    }

    /*
        Prajakta:Below method is used to check if Current user is submittor,Current user is member of queue and custom setting value is true then we need to hide approval component for Submittor.
    */
    private Boolean isCurrentUserRecordSubmittor(Id recordId) {
        if(KeyValueStoreHelper.getBooleanValue('HideApprovalForSubmitter',true) != null && KeyValueStoreHelper.getBooleanValue('HideApprovalForSubmitter',true)){
            List<ProcessInstance> processInstance = [SELECT SubmittedById From ProcessInstance WHERE TargetObjectId =:recordId AND Status in ('Pending') WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            List<ProcessInstanceWorkitem>  workItemList = [SELECT id, Actor.Type, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :recordId WITH USER_MODE LIMIT 100];  //polymorfic
            if(workItemList.size()>0){
                List<String> groupIds = new List<String>();
                //It checks actor is queue member or not.
                if(String.valueOf(workItemList[0].ActorId).startsWith('00G')){
                    groupIds.add(workItemList[0].ActorId);
                    //If the Approval was assigned to a Queue(Group) -- Check if the logged in user is a member of the Group.
                    checkGroupData(groupIds);
                    return showComponent;
                }
                else{
                    //here we check current user and record submittor
                    if(processInstance.size() > 0  && UserInfo.getUserId() == processInstance[0].SubmittedById){
                        showComponent = false;
                        return true;
                    }
                }   
            }                    
        }        
        return false;
    }

    @TestVisible
    private void checkGroupData(List<String> groupIds) {
        List<String> allGroups = new List<String>();
        allGroups.addAll(checkGroups(groupIds));
        if(!showComponent) {
            allGroups.addAll(groupIds);
            List<Group> roleGroups = new List<Group>(); 
                roleGroups = [SELECT RelatedId FROM Group WHERE RelatedId != null AND Id IN: allGroups WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            Set<String> roleIds = new Set<String>();
            for(Group rg: roleGroups) {
                roleIds.add(rg.relatedId);
            }
            if(roleIds.contains(UserInfo.getUserRoleId())) {
                showComponent = true;
            }
        }
    }
    
    public List<String> checkGroups(List<String> groupIds) {
        List<GroupMember> groupMemberList = new List<GroupMember>(); 
            groupMemberList = [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN: groupIds WITH USER_MODE LIMIT :AppUtils.SOQL_LIMIT]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        List<String> newGroupIds = new List<String>();
        for(GroupMember groupMemberUser : groupMemberList){
            if(groupMemberUser.UserOrGroupId == UserInfo.getUserId()){
                showComponent = true;
                return new List<String>();
            } else if(String.valueOf(groupMemberUser.UserOrGroupId).startsWith('00G')) {
                newGroupIds.add(String.valueOf(groupMemberUser.UserOrGroupId));
            }
        }
        if(newGroupIds.size() > 0) {
            newGroupIds.addAll(checkGroups(newGroupIds));
            if(showComponent) {
                return new List<String>();
            }
        }
        return newGroupIds; 
    }

    private List<Map<String, String>> getApprovalActions() {
        List<Map<String, String>> actionOptions = new List<Map<String, String>>();
            //if processInstanceNode is null then it should bot break
            if(processInstanceNode == null || processInstanceNode.size() == 0 ){
                return actionOptions;    
            }
            String approvalDefinationId1 = processInstanceNode.get(0).ProcessInstance.ProcessDefinitionId;
            String approvalStepId1 = processInstanceNode.get(0).ProcessNodeId;
            //In approval step cache added support to show confirmattion message and title
            List<ApprovalProcessStepCache__c>  approvalStepCacheList = new List<ApprovalProcessStepCache__c>();
            if(Schema.sObjectType.ApprovalProcessStepCache__c.isAccessible()){
                approvalStepCacheList = [SELECT ApprovalDefinitionId__c,ApprovalStepId__c,allowDelegate__c,ApprovalConfirmationMessage__c,ApproveConfirmationTitle__c,ReassignConfirmationTitle__c,ReassignConfirmationMessage__c,RejectConfirmationMessage__c,RejectConfirmationTitle__c,
                                SendToOwnerConfirmationMessage__c ,SendToOwnerConfirmationTitle__c FROM ApprovalProcessStepCache__c Where ApprovalDefinitionId__c = : approvalDefinationId1 And ApprovalStepId__c = : approvalStepId1 WITH USER_MODE];
            }
        //Prajakta: Below code is used to give support for expression builder for approval actions.
        Set<String> fieldSet = new Set<String>() ;
        for(ApprovalDecisionActionConfig__c approvalDecisionAction : approvalDecisionActionConfigList){
            if(String.isNotEmpty(approvalDecisionAction.HideExpressionJSON__c)){
                String expressionJson = approvalDecisionAction.HideExpressionJSON__c;
                // ExpressionJSONEvaluator.getfieldNamesFromJSON gives comma separated fields.
                String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
                if(String.isNotEmpty(fields)){
                    fields = fields.toLowerCase();
                    fieldSet.addAll(fields.split(','));
                }
            }
                  
        }
        
        List<SObject> recordForExp = new List<SObject>();
        if(fieldSet.size() > 0){
            //Below query gives sobject record.
            if(AppUtils.isObjectAccessible(recordId.getSObjectType().getDescribe().getName())){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                recordForExp = Database.query('select ' + String.join(new List<String> (fieldSet), ',') + ' from ' + string.escapeSingleQuotes(recordId.getSObjectType().getDescribe().getName()) + ' where Id=: '+string.escapeSingleQuotes(recordId) ,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
            }
        }
        Set<String> actions = new Set<String>();
        String label;
        // Approve and Reject will be always there unless we explicitly hide it using hideAction.
        if(approvalDecisionActionConfigList.size() > 0){
            Boolean hideApprove = false;
            Boolean hideReject = false;
            for(ApprovalDecisionActionConfig__c approvalDecisionActionConfig : approvalDecisionActionConfigList){
               
                label = String.isNotEmpty(approvalDecisionActionConfig.ActionLabelOverride__c)?approvalDecisionActionConfig.ActionLabelOverride__c:approvalDecisionActionConfig.Action__c;
                actions.add(approvalDecisionActionConfig.Action__c);
                if(!approvalDecisionActionConfig.HideAction__c ){
                    //Prajakta:ExpressionJsonEvaluator.evaluateExpression method returns boolean value.It is used to hide based on conditions.
                    if(String.isNotEmpty(approvalDecisionActionConfig.HideExpressionJSON__c)) {
                        Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(approvalDecisionActionConfig.HideExpressionJSON__c, recordForExp, layoutContext);
                        if(hideResult != null && hideResult) {
                            continue;
                    }
                    }
                    //Added below conditions to check confirmation message and title from approval step cache and then from sobject action
                    if(approvalDecisionActionConfig.Action__c =='Approve'){
                        actionOptions.add( new Map<String, String>{'Action'=>approvalDecisionActionConfig.Action__c,'Label'=>label,'ConfirmationMessage'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).ApprovalConfirmationMessage__c != null) ?approvalStepCacheList.get(0).ApprovalConfirmationMessage__c:approvalDecisionActionConfig.ConfirmationMessage__c,'ConfirmationTitle'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).ApproveConfirmationTitle__c != null) ?approvalStepCacheList.get(0).ApproveConfirmationTitle__c:approvalDecisionActionConfig.ConfirmationTitle__c,'CommentRequired'=>approvalDecisionActionConfig.Action__c.contains('Reassign')?'false' :String.valueOf(approvalDecisionActionConfig.CommentsRequired__c),'QueueOption'=>approvalDecisionActionConfig.QueueReassignOptions__c,'QueueFilterClause'=>approvalDecisionActionConfig.FilterCriteriaforQueueReassign__c} );
        
                    }else if(approvalDecisionActionConfig.Action__c =='Disapprove'){
                        actionOptions.add( new Map<String, String>{'Action'=>approvalDecisionActionConfig.Action__c,'Label'=>label,'ConfirmationMessage'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).RejectConfirmationMessage__c != null)?approvalStepCacheList.get(0).RejectConfirmationMessage__c:approvalDecisionActionConfig.ConfirmationMessage__c,'ConfirmationTitle'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).RejectConfirmationTitle__c != null) ?approvalStepCacheList.get(0).RejectConfirmationTitle__c:approvalDecisionActionConfig.ConfirmationTitle__c,'CommentRequired'=>approvalDecisionActionConfig.Action__c.contains('Reassign')?'false' :String.valueOf(approvalDecisionActionConfig.CommentsRequired__c),'QueueOption'=>approvalDecisionActionConfig.QueueReassignOptions__c,'QueueFilterClause'=>approvalDecisionActionConfig.FilterCriteriaforQueueReassign__c} );
                    }else if(approvalDecisionActionConfig.Action__c == 'Reassign'){
                        actionOptions.add( new Map<String, String>{'Action'=>approvalDecisionActionConfig.Action__c,'Label'=>label,'ConfirmationMessage'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).ReassignConfirmationMessage__c != null)?approvalStepCacheList.get(0).ReassignConfirmationMessage__c:approvalDecisionActionConfig.ConfirmationMessage__c,'ConfirmationTitle'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).ReassignConfirmationTitle__c != null) ?approvalStepCacheList.get(0).ReassignConfirmationTitle__c :approvalDecisionActionConfig.ConfirmationTitle__c,'CommentRequired'=>String.valueOf(approvalDecisionActionConfig.CommentsRequired__c),'QueueOption'=>approvalDecisionActionConfig.QueueReassignOptions__c,'QueueFilterClause'=>approvalDecisionActionConfig.FilterCriteriaforQueueReassign__c} );
        
                    }else if(approvalDecisionActionConfig.Action__c =='Send to Owner'){
                        actionOptions.add( new Map<String, String>{'Action'=>approvalDecisionActionConfig.Action__c,'Label'=>label,'ConfirmationMessage'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).SendToOwnerConfirmationMessage__c != null)?approvalStepCacheList.get(0).SendToOwnerConfirmationMessage__c:approvalDecisionActionConfig.ConfirmationMessage__c,'ConfirmationTitle'=> (approvalStepCacheList.size()>0 && approvalStepCacheList.get(0).SendToOwnerConfirmationTitle__c != null) ?approvalStepCacheList.get(0).SendToOwnerConfirmationTitle__c:approvalDecisionActionConfig.ConfirmationTitle__c,'CommentRequired'=>approvalDecisionActionConfig.Action__c.contains('Reassign')?'false' :String.valueOf(approvalDecisionActionConfig.CommentsRequired__c),'QueueOption'=>approvalDecisionActionConfig.QueueReassignOptions__c,'QueueFilterClause'=>approvalDecisionActionConfig.FilterCriteriaforQueueReassign__c} );
        
                    }
                }
               /* if(!approvalDecisionActionConfig.HideAction__c ){
                    actionOptions.add( new Map<String, String>{'Action'=>approvalDecisionActionConfig.Action__c, 'Label'=>label,'ConfirmationMessage'=> approvalDecisionActionConfig.ConfirmationMessage__c,'ConfirmationTitle'=> approvalDecisionActionConfig.ConfirmationTitle__c,'CommentRequired'=>approvalDecisionActionConfig.Action__c.contains('Reassign')?'false' :String.valueOf(approvalDecisionActionConfig.CommentsRequired__c)} );
                }*/
                if( actions.contains('Approve') && approvalDecisionActionConfig.HideAction__c){
                    hideApprove = true;
                }
                if( actions.contains('Disapprove') && approvalDecisionActionConfig.HideAction__c){
                    hideReject = true;
                }
                //actionOptions.add( new Map<String, String>{'Action'=>approvalDecisionActionConfig.Action__c, 'Label'=>label,'CommentRequired'=>String.valueOf(approvalDecisionActionConfig.CommentsRequired__c)} );
            }
            if(!actions.contains('Approve') && hideApprove == false){
                actionOptions.add( new Map<String, String>{'Action'=>'Approve', 'Label'=>'Approve'} );
            }
             if(!actions.contains('Disapprove') && hideReject == false){
                actionOptions.add( new Map<String, String>{'Action'=>'Disapprove', 'Label'=>'Reject'} );
                //actionOptions.sort();
            }

        }else{
            actionOptions.add( new Map<String, String>{'Action'=>'Approve', 'Label'=>'Approve'} );
            actionOptions.add( new Map<String, String>{'Action'=>'Disapprove', 'Label'=>'Reject'} );
        }
        return actionOptions;
    }
    
    @TestVisible
    private Boolean isSendToOwnerDisable(ApprovalDecisionActionConfig__c approvalDecisionActionConfig) {
        if(approvalDecisionActionConfig.SobjectConfig__r.ApprovalReCallEnable__c && approvalDecisionActionConfig.SobjectConfig__r.ApprovalReCallFieldAPIName__c!= null) {
            return false;
        }
        return true;
    }
    
    private Boolean isSentTOOwner(ApprovalDecisionActionConfig__c approvalDecisionActionConfig) {
        if(approvalDecisionActionConfig.SobjectConfig__r.ApprovalReCallEnable__c && approvalDecisionActionConfig.SobjectConfig__r.ApprovalReCallFieldAPIName__c!= null) {
            List<SObject> sobjList = new List<SObject>();
            String fieldName = approvalDecisionActionConfig.SobjectConfig__r.ApprovalReCallFieldAPIName__c;
            if(objectName != null && fieldName != null){
                String query = 'select ' + String.escapeSingleQuotes(fieldName) + ' from ' + String.escapeSingleQuotes(objectName) + ' where Id=: '+String.escapeSingleQuotes(recordId);
                if(AppUtils.isObjectAccessible(objectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sobjList = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                }  
            }   
            if(sobjList.size() > 0) {
                return (Boolean) sobjList[0].get(approvalDecisionActionConfig.SobjectConfig__r.ApprovalReCallFieldAPIName__c);
            } else {
                return false;
            }
        }
        return false;
    }
    

    public PageReference sendForApproval(List<String> messageList,String reassignOwnerId){
        Savepoint sp = null;
        classForMessage = 'alert alert-dismissable alert-';
        //Build a SOQL for to query the information of the current record
        TaskConfig__c taskAction = new TaskConfig__c();
        actionConfigMap = new Map<String,ApprovalDecisionActionConfig__c> ();
        approvalDecisionActionConfigList =  new List<ApprovalDecisionActionConfig__c>();
        //vlodation
        String customAppName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        if(String.isEmpty(customAppName)) {
            CustomExceptions.logException(String.format(System.Label.UserPrefrenceLabel, new List<String>{Userinfo.getUserId()}), false);
        }
               /* if(approvalDecisionActionConfigList != null && approvalDecisionActionConfigList.size() > 0) {
                    if( isSentTOOwner(approvalDecisionActionConfigList[0])) {
                        return;
                    }
                }*/
        Boolean redirectFlag = false;
        try{
            parentSObject = SchemaManager.getSObject((Id)recordId);
            SchemaManager.SObjectFieldWrapper fieldWrapper = parentSObject.getField('OwnerId');
            hasOwner = true;
        }catch(Exception e){
            hasOwner = false;    
        }
        String ownerField = '';
        if(hasOwner){
            ownerField = ',OwnerId';
        }
        if(parentSObject != null && parentSObject.objectName != null){
            if(!string.isEmpty(parentSObject.objectName)){
                if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible()){
                        approvalDecisionActionConfigList  =  [SELECT ActionLabelOverride__c,Action__c,CommentsFieldsAPIName__c,
                                                              CommentsRequired__c,HideAction__c,FilterCriteriaforUserReassign__c,
                                                              SobjectConfig__r.ApprovalReCallEnable__c,SobjectConfig__r.ApprovalReCallFieldAPIName__c,
                                                              SobjectConfig__r.ApprovalReCallCommentFieldAPIName__c,HideExpressionJSON__c FROM ApprovalDecisionActionConfig__c 
                                                              where SobjectConfig__r.Name =:parentSObject.objectName and 
                                                              CustomAppConfig__r.Name=:customAppName WITH USER_MODE order by Sequence__c];
                }
            }
        }
        objectName = String.escapeSingleQuotes(parentSObject.objectName);
        Map<String,boolean> commentActionMandatoryMap = new Map<String,Boolean>();
        userFilter =  ' AND IsActive=true ';
        for(ApprovalDecisionActionConfig__c approvalDecisionActionConfig: approvalDecisionActionConfigList){
                actionConfigMap.put(approvalDecisionActionConfig.Action__c,approvalDecisionActionConfig);
                commentActionMandatoryMap.put(approvalDecisionActionConfig.Action__c,approvalDecisionActionConfig.CommentsRequired__c);
                if(!String.isEmpty(approvalDecisionActionConfig.FilterCriteriaforUserReassign__c)){
                        userFilter =  'AND ' + approvalDecisionActionConfig.FilterCriteriaforUserReassign__c;
                }
        }
        commentActionMap = json.serialize(commentActionMandatoryMap);  
        //Get the workItemId of the Approval Process that is initiated for this record
        List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
        set<String> delegateApproversSet = new set<String>();
        if(recordId != null || recordId != ''){
            workItemList = [SELECT id, ActorId,Actor.Name,Actor.Type,ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem 
                            WHERE ProcessInstance.TargetObjectId = :recordId WITH USER_MODE LIMIT 100];    //polymorphic //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
        if(workItemList.size() == 0){
            CustomExceptions.logException(System.Label.ApprovalExceptionLabel, false);
        }
        List<String> actorIdList = new List<String>();
        for(ProcessInstanceWorkitem processWorkitem : workItemList ){
            actorIdList.add(processWorkitem.ActorId);
        }
        List<User> delegatedApprovers = new List<User>();
        delegatedApprovers = [SELECT id,Name,DelegatedApproverId FROM User WHERE Id IN:actorIdList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            
        for(User u : delegatedApprovers){
                if(u.DelegatedApproverId != null){
                        delegateApproversSet.add(u.DelegatedApproverId);
                }
        }  
        /*if (workItemList.size() == 0) {
            return null;
        }*/
        List<Task> approvalTaskList = new List<Task>();
            List<String> approvalProcessWorkItemId = new List<String>();
            for(ProcessInstanceWorkitem workItem: workItemList) {
                approvalProcessWorkItemId.add(workItem.Id);
            }
            approvalTaskList = [SELECT WhatId, Status, OwnerId, Id, ObjectRelationName__c, TaskAction__c, 
                                DocumentType__c, WorkitemId__c,GroupId__c, Subject, ActivityDate, AssignedToQueue__c FROM Task
                                WHERE WorkitemId__c in:approvalProcessWorkItemId AND OwnerId = :UserInfo.getUserId() WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
       /* if(String.isEmpty(approvalActionChosen)){
            showComponent = true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select one option in recommendation'));
            showMessage = 'Please select one option in recommendation';
            classForMessage += 'warning';
            return null;     
        }*/
        ProcessInstanceWorkitem selectedInstanceWorkItem;
        List<String> groupIds = new List<String>();
        List<String> approvalInstanceIds = new List<String>();
        for(ProcessInstanceWorkitem processIntanceWorkItem : workItemList) {
            if(processIntanceWorkItem.ActorId == UserInfo.getUserId()) {
                selectedInstanceWorkItem = processIntanceWorkItem;
                //we can not break as we need to get all instance Ids to close task for unanimous 
                //break;
            } else {
                groupIds.add(processIntanceWorkItem.ActorId);
            }
            approvalInstanceIds.add(processIntanceWorkItem.Id);
        }
        if(selectedInstanceWorkItem == null && groupIds.size() > 0) {
            //Need to add support where group can be member of group
            List<GroupMember> groupMemberList = [SELECT groupId, UserOrGroupId FROM GroupMember 
                                                WHERE GroupId IN: groupIds and UserOrGroupId=:UserInfo.getUserId() WITH USER_MODE LIMIT :AppUtils.SOQL_LIMIT];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            /*groupIds.addAll(checkGroups(groupIds));
            List<Group> roleGroups = new List<Group>(); 
            if(GroupMember.sObjectType.getDescribe().isAccessible() == true){
                roleGroups = [SELECT Id, RelatedId FROM Group WHERE Id IN:groupIds limit 1];
            }*/
            if(groupMemberList.size() > 0) {
                String groupId = groupMemberList.get(0).groupId;
                for(ProcessInstanceWorkitem processIntanceWorkItem : workItemList) {
                    if( processIntanceWorkItem.ActorId == groupId ) {
                        selectedInstanceWorkItem = processIntanceWorkItem;
                        break;
                    }
                }
            }
        }
            //added delegateApproversSet for delegate Approver
           List<GroupMember> groupMembers;
           if(groupIds != null) {
             groupMembers = [SELECT Id, Group.DeveloperName, GroupId, UserOrGroupId FROM GroupMember Where Group.Id IN :groupIds and Group.Type='Queue' WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
           }

           Set<Id> activeUsers = new Set<Id>();
            for(GroupMember grpMember1 : groupMembers){
                activeUsers.add(grpMember1.UserOrGroupId);
            }
           List<User> delegatedApproversForGrup = new List<User>();
           if(activeUsers != null){
            delegatedApproversForGrup = [SELECT id,Name,DelegatedApproverId FROM User WHERE Id IN:activeUsers WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
           }
           
           for(User u : delegatedApproversForGrup){
            if(u.DelegatedApproverId != null){
                    delegateApproversSet.add(u.DelegatedApproverId);
            }
        }
        //
        if(selectedInstanceWorkItem == null && delegateApproversSet.size() > 0 ){
            for(ProcessInstanceWorkitem processIntanceWorkItem : workItemList) {
                if(delegateApproversSet.contains(UserInfo.getUserId())) {
                    selectedInstanceWorkItem = processIntanceWorkItem;
                    //we can not break as we need to get all instance Ids to close task for unanimous 
                    //break;
                } 
            }
        }
        //this will be used in case of uninoumus approval process.
        List<ProcessInstanceNode> processInstanceNodes = getProcessInstanceNodes(recordId);
        List<ApprovalProcessStepCache__c> processStepCacheList = getApprovalProcessStepCache(processInstanceNodes);
        try{
            if(processStepCacheList.size() > 0){
                if(processStepCacheList.get(0).ActionClass__c != null){
                    String responseMessage = executeActionclass(processStepCacheList.get(0).ActionClass__c,approvalActionChosen,recordId);
                    messageList.add(responseMessage);  
                }
            }
            sp = Database.setSavepoint();
            //notifyAdditionalPeople( approvalActionChosen, recordId, processStepCacheList,reassignOwnerId);
       
            if(approvalActionChosen != 'Send to Owner'){
                notifyAdditionalPeople( approvalActionChosen, recordId, processStepCacheList,reassignOwnerId);
            }
            performApprovalActions(approvalActionChosen, selectedInstanceWorkItem, processInstanceNodes, approvalTaskList, approvalInstanceIds, redirectFlag, taskAction);
            if(Schema.sObjectType.Task.isUpdateable() && Task.sObjectType.getDescribe().isAccessible() == true && !isError){
                update as user approvalTaskList;//here task are updated
            }

            updateCommentOnParentObject(recordId, actionConfigMap.get(approvalActionChosen), comments);
            if(redirectFlag == true && !isError){              
                PageReference postDescisionPage = new PageReference(URL.getOrgDomainURL().toExternalForm() +'/apex/'+taskAction.PostDecisionPage__c); // ApexOpenRedirect  - False +Ve - PostDecisionPage__c is taken from TaskConfig__c, which can only be created or Updated by Admin User.
                postDescisionPage.getParameters().put('id',recordId);          
                return postDescisionPage;
            }
        }catch(Exception e){ 
                if(sp != null){
                     Database.rollback( sp );
                }
               
                showComponent = true;            
                classForMessage += 'danger';
                isError = true;
                String errorMsg = e.getMessage();
                if(errorMsg.contains('MANAGER_NOT_DEFINED')){
                   CustomExceptions.logException(System.Label.UserManagerNotDefined, true, true);
                    //}              
                }else if(errorMsg.contains('nextApproverIds')){
                        CustomExceptions.logException(System.Label.NextAprroverNotDefined, true, true);

                }else{
                    CustomExceptions.logException(e, true, true);
                }
                
        }
        return null;
    }
    //Added this method to copy comments in CommentsFieldsAPIName__c of  ApprovalDecisionActionConfig__c.
    private void updateCommentOnParentObject(Id recordId, ApprovalDecisionActionConfig__c  approvalDecisionConfig, String comments){
        //created new instance of object.
        if(approvalDecisionConfig != null &&  approvalDecisionConfig.CommentsFieldsAPIName__c != null && comments!= null){
            sObject sObj = recordId.getSobjectType().newSObject(recordId);
            sObj.put(approvalDecisionConfig.CommentsFieldsAPIName__c, comments);

            List<SObject> listToUpdate = new List<SObject>();
            listToUpdate.add(sObj);
            SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
            if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible() && Schema.sObjectType.ApprovalDecisionActionConfig__c.fields.CommentsFieldsAPIName__c.isUpdateable() ){
                systemContextMethodsHelper.updateSobject(listToUpdate);
            }
            //update sobj;   
        }
        
    }

    public static void closePendingTask(String workItemIdsJSON){
      closePendingTask(workItemIdsJSON,null);
    }

    /*This method is used to create new task when any user from queue assign task to an single user.
    SO we pass id of 1 st user from reassign section. So except this user all other users
    in queue their task get completed and te first user task get reassigned to new user*/
    @future
    public static void closePendingTask(String workItemIdsJSON, String skipTaskIdToDelete ) {
      closePendingTaskWithoutFuture(workItemIdsJSON,skipTaskIdToDelete);
    }
    
    // pass work items as in string json format. 
    // It will get all tasks associated with approval process and close them
    public Static void closePendingTaskWithoutFuture(String workItemIdsJSON) {
        closePendingTaskWithoutFuture(workItemIdsJSON, null);
    }
    public Static void closePendingTaskWithoutFuture(String workItemIdsJSON, String skipTaskIdToDelete) {
        Savepoint sp = Database.setSavepoint();

        try{

            List<String> workItemIds = (List<String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(workItemIdsJSON), List<String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
            if(!workItemIds.isEmpty() && Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.fields.AssignedToQueue__c.isUpdateable() && Schema.sObjectType.Task.fields.Status.isUpdateable()){
                List<ProcessInstanceWorkitem> newProcessInstanceNodes = [select id from ProcessInstanceWorkitem where Id in :workItemIds WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                Set<String> processInstancceIds = new Set<String>();
                for(ProcessInstanceWorkitem processInstance : newProcessInstanceNodes) {
                    processInstancceIds.add(processInstance.Id);
                }
                list<String> taskIdList;
                if(skipTaskIdToDelete !=null){
                   taskIdList  = skipTaskIdToDelete.split(',');
                }else{
                    taskIdList = new List<String>();
                }
                List<Task> approvalTaskList = [SELECT WhatId, Status, WorkitemId__c,AssignedToQueue__c FROM Task WHERE WorkitemId__c in:workItemIds and Status != 'Completed' and id not In :taskIdList  WITH USER_MODE];//here we compare user id with parameter user id.so task is not close of 1st user and it get reassign to new user //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(Schema.sObjectType.Task.fields.Status.isUpdateable()){
                    for(Task approvalTask : approvalTaskList) {
                        //When approval process is assigned to queue then AssignedToQueue__c is always true.
                        if (Schema.sObjectType.Task.fields.Status.isUpdateable()) {
                            if(approvalTask.AssignedToQueue__c == true){
                                approvalTask.Status = 'Completed';
                            }else{
                                if(!processInstancceIds.contains(approvalTask.WorkitemId__c)) {
                                    approvalTask.Status = 'Completed';
                                }
                            }
                        }
                    }
                }
                if(Schema.sObjectType.Task.isUpdateable()){
                    update as user approvalTaskList;
                }
            }
        }catch(Exception e){  
             Database.rollback( sp );
             CustomExceptions.logException(e, true, false);
        }
    }
    /*
        Method checks for additional WorkItems created in case of the Approval Process has multiple steps
    */
    private boolean checkForNextStep(List<Task> oldApprovalTaskList){
        Task oldApprovalTask;
        if(oldApprovalTaskList.isEmpty() != true){
            oldApprovalTask = oldApprovalTaskList.get(0);
        
            List<ProcessInstanceWorkitem> workItemList = new List<ProcessInstanceWorkitem>();
                workItemList = [SELECT id, Actor.Type, ActorId, ProcessInstance.ProcessDefinitionId 
                FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :recordId WITH USER_MODE LIMIT 1]; // polymorfic 
             
            if(workItemList.size()>0){
                List<ProcessNode> approvalSteps = new List<ProcessNode>();
                    approvalSteps = [SELECT Id FROM ProcessNode Where ProcessDefinitionId = :workItemList[0].ProcessInstance.ProcessDefinitionId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(approvalSteps.size() > 1){
                    //Fixed Issues for Multistep Approval Process.
                    List<Task> approvalTaskList = TaskCreationHandler.createApprovalProcessTasks(recordId, oldApprovalTask.TaskAction__c, oldApprovalTask.ObjectRelationName__c, null, oldApprovalTask.ActivityDate, oldApprovalTask.subject, true);                        
                    
                    return true;
                }
            }
        }
        return false;
    }
    /* 
        Method called when the record is Approved
    */
    private void approveRequest(ProcessInstanceWorkitem workItem, ApprovalDecisionActionConfig__c  approvalDecisionConfig){
        //try{            
        approvaRequest(workItem, comments);          
            // Submit the request for approval.
            
            showComponent = false;
            showMessage = 'Successfully Approved.';
            classForMessage += 'success';
            if(!String.isEmpty(commentsFieldAPIName)){  
                List<SObject> targetObject = new List<SObject>();
                targetObject.add(fetchSobject(approvalDecisionConfig));
                for (SObject obj : targetObject) {
                    if(!String.isEmpty((string)obj.get(commentsFieldAPIName))){
                        comments = obj.get(commentsFieldAPIName) + '<br>' +workItem.Actor.Name +': '+comments;
                    // comments = obj.get(commentsFieldAPIName) + '\n' +workItem.Actor.Name +': '+comments;
                        obj.put(commentsFieldAPIName,comments);
                    }
                }
                //update targetObject;
                SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
                if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible() && Schema.sObjectType.ApprovalDecisionActionConfig__c.fields.CommentsFieldsAPIName__c.isUpdateable() ){
                    systemContextMethodsHelper.updateSobject(targetObject);
                }
            }
    }
    
    public static void approvaRequest(ProcessInstanceWorkitem workItem, String comments) {
         // Instantiate the new ProcessWorkitemRequest object and populate it
        if(workItem == null){
            CustomExceptions.logException(String.format(System.Label.RecordAlreadyApproved, new List<String>{}), false,true);
        }
        List<ApprovalProcessStepCache__c> approverProStepCacheList = new List<ApprovalProcessStepCache__c>();
        Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest();
        workItemRequest.setComments(comments);
        workItemRequest.setAction('Approve');
        workItemRequest.setNextApproverIds(null);
        List<ProcessInstance> appProccInstStepList = [SELECT Id,ProcessDefinitionId,TargetObjectId FROM ProcessInstance WHERE Id =: workItem.ProcessInstanceId AND Status IN ('Pending') WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        List<ProcessInstanceNode> appProccNodeIdList = [SELECT ProcessNodeId FROM ProcessInstanceNode WHERE ProcessInstanceId=:appProccInstStepList[0].Id AND NodeStatus IN ('Pending') WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        //Code Change chk Approval Process Step by StepIds
        if(appProccNodeIdList !=null && appProccNodeIdList.size() > 0){
            if(Schema.sObjectType.ApprovalProcessStepCache__c.isAccessible()){
                approverProStepCacheList = [SELECT ApproverFieldAPIName__c from ApprovalProcessStepCache__c WHERE ApprovalStepId__c =:appProccNodeIdList[0].ProcessNodeId WITH USER_MODE]; 
            }
        }
        if(approverProStepCacheList.size() > 0 && approverProStepCacheList.get(0).ApproverFieldAPIName__c != null){
            String sobjectAPIName = appProccInstStepList.get(0).TargetObjectId.getSObjectType().getDescribe().getName();
            String recId = String.escapeSingleQuotes(appProccInstStepList.get(0).TargetObjectId);
            String fieldAPIName = approverProStepCacheList.get(0).ApproverFieldAPIName__c;
            SObject sobj;
            if(sobjectAPIName != null && fieldAPIName != null){
                String query = 'Select ' + String.escapeSingleQuotes(fieldAPIName) + ' From ' + String.escapeSingleQuotes(sobjectAPIName) + ' Where Id = :recId';
                if(AppUtils.isObjectAccessible(sobjectAPIName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sobj = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                }
            }
            if(sobj.get(fieldAPIName) !=null ){
                Id userId= (Id)sobj.get(fieldAPIName);
                List<Id> userIdList = new List<Id>();
                userIdList.add(userId);
                workItemRequest.setNextApproverIds(userIdList); 
            } 
        }
         // Use the ID from the newly created item to specify the item to be worked
        workItemRequest.setWorkitemId(workItem.Id);
        Approval.ProcessResult approvalResult =  Approval.process(workItemRequest);
    }
    

    private void disapproveRequest(ProcessInstanceWorkitem workItem,  ApprovalDecisionActionConfig__c  approvalDecisionConfig){
        if(workItem == null){
            CustomExceptions.logException(String.format(System.Label.RecordAlreadyApproved, new List<String>{}), false,true);
        }
        Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest();
        workItemRequest.setComments(comments);
        workItemRequest.setAction('Reject');
        workItemRequest.setNextApproverIds(null);
       workItemRequest.setWorkitemId(workItem.Id);
        
       
            Approval.ProcessResult approvalResult =  Approval.process(workItemRequest);
            showComponent = false;
            showMessage = 'Successfully Disapproved.';
            classForMessage += 'success';
            if(!String.isEmpty(commentsFieldAPIName)){
                List<SObject> targetObject = new List<SObject>();
                targetObject.add(fetchSobject(approvalDecisionConfig));    
                for (SObject obj : targetObject) {
                    if(!String.isEmpty((string)obj.get(commentsFieldAPIName))){
                        comments = obj.get(commentsFieldAPIName) + '<br>' +workItem.Actor.Name +': '+comments;
                      obj.put(commentsFieldAPIName,comments);
                    }
                }
                SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
                if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible() && Schema.sObjectType.ApprovalDecisionActionConfig__c.fields.CommentsFieldsAPIName__c.isUpdateable() ){
                    systemContextMethodsHelper.updateSobject(targetObject);
                }
            }
        
    }
    

    private void sendForFurtherReview(ProcessInstanceWorkitem workItem, ApprovalDecisionActionConfig__c  approvalDecisionConfig){
        if(workItem == null){
            CustomExceptions.logException(String.format(System.Label.RecordAlreadyApproved, new List<String>{}), false,true);
        }
        //if(Schema.sObjectType.ProcessInstanceWorkitem.fields.ActorId.isUpdateable()){
            workItem.ActorId = chosenUserId;
        //}
        if(Schema.sObjectType.ProcessInstanceWorkitem.isUpdateable() && ProcessInstanceWorkitem.sObjectType.getDescribe().isAccessible() == true){
            update as user workItem;
        }
        List<SObject> targetObject = new List<SObject>();
        targetObject.add(fetchSobject(approvalDecisionConfig));
        if(!String.isEmpty(commentsFieldAPIName)){  
            for (SObject obj : targetObject) {
                if(!String.isEmpty((string)obj.get(commentsFieldAPIName))){
                    comments = obj.get(commentsFieldAPIName) + '<br>' +workItem.Actor.Name +': '+comments;
                   obj.put(commentsFieldAPIName,comments);
                }
            }
            SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
            if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible() && Schema.sObjectType.ApprovalDecisionActionConfig__c.fields.CommentsFieldsAPIName__c.isUpdateable() ){
                systemContextMethodsHelper.updateSobject(targetObject);
            }
        }
            
            systemContextMethodsHelper.createShare(recordId,chosenUserId, hasOwner);
        
        
       List<ProcessInstance> processInstList = [SELECT Id, (SELECT Id, StepStatus FROM StepsAndWorkitems 
                                                                                    WHERE StepStatus = 'Reassigned' 
                                                                                    ORDER BY CreatedDate DESC LIMIT 1 ) 
                                                FROM ProcessInstance WHERE Id =:workItem.ProcessInstanceId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(processInstList.size() > 0) {
            List<ProcessInstanceHistory> processHistList = processInstList[0].StepsAndWorkitems;
            if(processHistList.size() > 0) {
                ApprovalHistoryExtension__c appHistExt = new ApprovalHistoryExtension__c();
                appHistExt.WorkInstanceItemId__c = processHistList[0].Id;
                appHistExt.Comments__c = comments;
                List<SObject> histExtList = new List<SObject>();
                histExtList.add(appHistExt);
                SystemContextMethodsHelper systemContextMethodsHelperRef = new SystemContextMethodsHelper();
                systemContextMethodsHelperRef.insertSobject(histExtList);
            } 
        }
        
        showComponent = false;
        showMessage = 'Successfully Re-Assigned.';
        classForMessage += 'success';
    }
    

    public void sendToOwner(ProcessInstanceWorkitem workItem,  ApprovalDecisionActionConfig__c  approvalDecisionConfig){
        if(workItem == null){
            CustomExceptions.logException(String.format(System.Label.RecordAlreadyApproved, new List<String>{}), false,true);
        }

        List<SObject> targetObject = new List<SObject>();
        targetObject.add(fetchSobject(approvalDecisionConfig));
        List<SObjectConfig__c> sobjConfigs = new List<SObjectConfig__c>();
        if(Schema.sObjectType.SObjectConfig__c.isAccessible()){
            sobjConfigs = [select ApprovalReCallFieldAPIName__c,SendToOwnerStatus__c,ApprovalReCallCommentFieldAPIName__c from SObjectConfig__c where Name=:objectName and ApprovalReCallEnable__c=true WITH USER_MODE];
            for (SObject obj : targetObject) {
                try{
                
                   if(sobjConfigs.size() > 0 && !String.isEmpty(sobjConfigs[0].SendToOwnerStatus__c)) {
                       obj.put('Status__c', sobjConfigs[0].SendToOwnerStatus__c);
                   }
                   else{
                   obj.put('Status__c', 'Change Requested');
                   }
                   
                   if(sobjConfigs.size() > 0 && !String.isEmpty(sobjConfigs[0].ApprovalReCallFieldAPIName__c)) {
                       obj.put(sobjConfigs[0].ApprovalReCallFieldAPIName__c, true);
                   }
                   if(sobjConfigs.size() > 0 && !String.isEmpty(sobjConfigs[0].ApprovalReCallCommentFieldAPIName__c)) {
                       obj.put(sobjConfigs[0].ApprovalReCallCommentFieldAPIName__c, comments);
                   }
                }catch(Exception e){

                } 
                if(!String.isEmpty(commentsFieldAPIName)){
                    if(!String.isEmpty((string)obj.get(commentsFieldAPIName))){
                       comments = obj.get(commentsFieldAPIName) + '<br>' +workItem.Actor.Name +': '+comments;
                    }
                  obj.put(commentsFieldAPIName,comments);
                }
            }
            SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
            if(Schema.sObjectType.ApprovalDecisionActionConfig__c.isAccessible() && Schema.sObjectType.ApprovalDecisionActionConfig__c.fields.CommentsFieldsAPIName__c.isUpdateable() ){
                systemContextMethodsHelper.updateSobject(targetObject);
            }
            showMessage = 'Successfully sent to Owner. It may take few minutes to process record.';  
            classForMessage += ' success';     
            sendEmailToRunBatch();     
        }
       
    }
    
   private void sendEmailToRunBatch() {                      
        EventBus__e eventBusRec = new EventBus__e(EventName__c='SendToOwner', ParentId__c=recordId);
        Database.SaveResult objSaveResult = EventBus.publish(eventBusRec);
        if(!objSaveResult.isSuccess()){
            try {
                List<ErrorLog__c> lstErrorLogs = new List<ErrorLog__c>();
                for(Database.Error err : objSaveResult.getErrors()) {
                    if(Schema.sObjectType.ErrorLog__c.fields.AffectedUser__c.isCreateable() &&
                    Schema.sObjectType.ErrorLog__c.fields.ExceptionType__c.isCreateable() &&
                    Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()){
                    lstErrorLogs.add(new ErrorLog__c(
                            AffectedUser__c = UserInfo.getUserId(),
                            ExceptionType__c = String.valueOf(err.getStatusCode()),
                            ErrorMessage__c = err.getMessage()
                    ));
                }
                }
                if(!lstErrorLogs.isEmpty()){
                    sendExceptionEmail(null, lstErrorLogs);
                    if(Schema.sObjectType.ErrorLog__c.isCreateable()){
                        insert as user lstErrorLogs;
                    }
                }
            } catch (Exception ex ){
                sendExceptionEmail(ex, null);
            }

            try {
               List<EmailServicesAddress> emailAddresses = [SELECT AuthorizedSenders,EmailDomainName,FunctionId,IsActive,LocalPart,RunAsUserId
                    FROM EmailServicesAddress where Function.FunctionName = 'SendToOwnerEmailHandler' and IsActive=true and Function.IsActive=true WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(emailAddresses.size() == 0) {
                    throw new CustomExceptions.RequiredException('Email address or Email service with name SendToOwnerEmailHandler missing. Please contact admin user');
                }
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setPlainTextBody(recordId);
                msg.setToAddresses(new String[] {emailAddresses.get(0).LocalPart + '@' + emailAddresses.get(0).EmailDomainName});
                msg.setSaveAsActivity(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
            } catch (Exception ex ){
                sendExceptionEmail(ex, null);
            }
        }
    }

    void sendExceptionEmail(Exception ex, List<ErrorLog__c> errorLogs){
        Boolean notifyAdmin = KeyValueHolderHelper.getBooleanValue('ReCallNotification');
        if(notifyAdmin){
            String adminEmails = KeyValueHolderHelper.getTextValue('ReCallNotification');
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.setToAddresses(new List<String>(adminEmails.split(';')));
            semail.setSubject('HIGH ALERT: Approval Process Recall failed');
            String htmlBody = '<p>Hello {toUser},</p><p>Please find the below exception details:</p><table style="width: 579px; border-color: #000;" border="2px"><tbody><tr><td style="width: 150px;"><strong>Message</strong></td><td style="width: 411px;">{message}</td></tr><tr><td style="width: 150px;"><strong>Line Number</strong></td><td style="width: 411px;">{lineNumber}</td></tr><tr><td style="width: 150px;"><strong>Stack Trace</strong></td><td style="width: 411px;">{stackTrace}</td></tr></tbody></table><p>Thanks,</p><p>GovGrants Team.</p>';
            if(ex != null){
                htmlBody = htmlBody.replace('{toUser}', UserInfo.getName());
                htmlBody = htmlBody.replace('{message}', ex.getMessage());
                htmlBody = htmlBody.replace('{lineNumber}', String.valueOf(ex.getLineNumber()));
                htmlBody = htmlBody.replace('{stackTrace}', ex.getStackTraceString());
            } else if(errorLogs != null){
                htmlBody = htmlBody.replace('{toUser}', UserInfo.getName());
                htmlBody = htmlBody.replace('{stackTrace}', JSON.serialize(errorLogs));
            }
            semail.setHtmlBody(htmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        }
    }
    
    private Sobject fetchSobject(ApprovalDecisionActionConfig__c  approvalDecisionConfig){
        String ownerField = hasOwner?',OwnerId':'';
        String commentsFieldAPIName = '';
        String commentsFieldAPINameQuery = '';
        String pdfConditionAPIName='';
        if(approvalDecisionConfig != null){
            if(!String.isEmpty(approvalDecisionConfig.CommentsFieldsAPIName__c)){
                commentsFieldAPINameQuery = ','+ approvalDecisionConfig.CommentsFieldsAPIName__c;
                commentsFieldAPIName =  approvalDecisionConfig.CommentsFieldsAPIName__c;
            }
            
        }
        List<sObject> objectResult = new List<sObject>();
            String soql = 'Select Id ' +String.escapeSingleQuotes(ownerField)+' '+ String.escapeSingleQuotes(commentsFieldAPINameQuery)  + ' from ' + String.escapeSingleQuotes(AppUtils.removeNamespacePrefix(objectName)) +
                    ' where Id=: '+String.escapeSingleQuotes(recordId);
                if(AppUtils.isObjectAccessible(AppUtils.removeNamespacePrefix(objectName))){
                    objectResult = Database.query(String.escapeSingleQuotes(soql), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                }
       return objectResult[0];      
    }
     global static void generateSnapshot(String parentId,String templateName,String flexTableParam,String listParam){
     }
    
    @AuraEnabled @RemoteAction
    global static Map<String, Object> generateSnapshotOnApproval(String parentId,String templateName,String flexTableParam,String listParam){
        Savepoint sp = Database.setSavepoint();
        Map<String, Object> resultMap = new  Map<String, Object>();
        try{
            Id recordId = parentId;
            String pdfConditionAPIName ='';
            boolean takeSnapshot = false;
            List<SobjectConfig__c> sobjects = new List<SobjectConfig__c>();
            if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
                sobjects = [select ApprovalPDFConditionAPIName__c,ApprovalSnapshotFileName__c,CaptureSnapshotonApproval__c from SobjectConfig__c where Name=:String.valueOf(recordId.getSobjectType()) WITH USER_MODE]; 
                if(sobjects.size() > 0 ) {
                    if(!String.isEmpty(sobjects[0].ApprovalPDFConditionAPIName__c)){
                        pdfConditionAPIName = ',' + sobjects[0].ApprovalPDFConditionAPIName__c;
                    }
                    if(sobjects[0].CaptureSnapshotonApproval__c != null){
                        takeSnapshot =  sobjects[0].CaptureSnapshotonApproval__c;
                    }
                }
            }
            if(takeSnapshot){ 
                List<Sobject> objectResult = new List<Sobject>();
                String objectName = String.valueOf(recordId.getSobjectType());
                    String query = 'select id '+String.escapeSingleQuotes(pdfConditionAPIName)+ ' from '+ String.escapeSingleQuotes(objectName) + ' where Id =: '+String.escapeSingleQuotes(recordId);
                    if(AppUtils.isObjectAccessible(objectName)){
                        objectResult = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                    }
                ApprovalDecisionCtrl.captureSnapshot(sobjects,objectResult,templateName,flexTableParam, listParam);
            }
            resultMap.put('Success',true);
        }catch(Exception e) {
            resultMap .put('Message',e.getMessage());
            resultMap .put('Success',false);
            Database.rollback( sp );
            CustomExceptions.logException(e, true, false);
        }
        return resultMap;
    }  
    
    private static void captureSnapshot( List<SobjectConfig__c>  sobjectConfigLst,List<Sobject> objectResult,String templateName,String flexTableParam,String listParam){
        Boolean isApprovalSnapshotRequired = false; 
        if(sobjectConfigLst != null  &&  sobjectConfigLst.size() > 0 ){
            for(SobjectConfig__c sobjectConfig: sobjectConfigLst){
                if(sobjectConfig != null){
                    isApprovalSnapshotRequired = sobjectConfig.CaptureSnapshotonApproval__c;
                } 
                Boolean takeSnapshot = false;
                if(isApprovalSnapshotRequired){
                    if(!String.isEmpty(sobjectConfig.ApprovalPDFConditionAPIName__c)){
                        Object val = objectResult[0].get(sobjectConfig.ApprovalPDFConditionAPIName__c);
                        if(val != null){
                            takeSnapshot = (Boolean)val;
                            if(takeSnapshot){
                                List<ProcessInstance> historySteps = new List<ProcessInstance>();
                                historySteps =[SELECT ProcessDefinition.Name, (SELECT Actor.Name, StepStatus, Comments,CreatedDate FROM StepsAndWorkitems  order by createdDate DESC)
                                    FROM ProcessInstance where TargetObjectId =:objectResult[0].id WITH USER_MODE order by createdDate DESC  LIMIT :Apputils.SOQL_LIMIT];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                                 System.enqueueJob(new EnqueueSnapshotUtils(historySteps[0].StepsAndWorkitems[0].id,objectResult[0].id ,templateName, flexTableParam, listParam,sobjectConfig.ApprovalSnapshotFileName__c));                       
                            } 
                        } 
                    }else{
                        List<ProcessInstance> historySteps = new List<ProcessInstance>();
                        historySteps =[SELECT ProcessDefinition.Name, (SELECT id,Actor.Name, StepStatus, Comments,CreatedDate FROM StepsAndWorkitems order by createdDate DESC)
                                    FROM ProcessInstance where TargetObjectId =:objectResult[0].id WITH USER_MODE order by createdDate DESC  LIMIT :Apputils.SOQL_LIMIT];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                       System.enqueueJob(new EnqueueSnapshotUtils(historySteps[0].StepsAndWorkitems[0].id,objectResult[0].id ,templateName, 
                                flexTableParam, listParam,sobjectConfig.ApprovalSnapshotFileName__c));                        
                    }
                }
            }
        }
    }
    
    public static Boolean isValidSalesforceId( String sfdcId){
        try{
            if( Pattern.compile( '[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}' ).matcher( sfdcId ).matches() ){
                return true;
            }
        }catch(Exception e){
            return null;
        }
        return false;
    }
/*
    Method provide the Approval process Step Cache record.
*/
    public static List<ApprovalProcessStepCache__c> getApprovalProcessStepCache(List<ProcessInstanceNode> processInstanceSteps){
        List<ApprovalProcessStepCache__c> processStepCacheList = new List<ApprovalProcessStepCache__c>();
        if(processInstanceSteps == null || processInstanceSteps.size() == 0){
            return processStepCacheList;
        }
        String approvalDefinationId = processInstanceSteps.get(0).ProcessInstance.ProcessDefinitionId;
        String approvalStepId = processInstanceSteps.get(0).ProcessNodeId;
        if(Schema.sObjectType.ApprovalProcessStepCache__c.isAccessible()){
            processStepCacheList = [SELECT ApprovalDefinitionId__c,ApprovalStepId__c,NotifyAdditionalPeople__c,
                                ApproveEmailTemplate__r.DeveloperName__c,ReassignedEmailTemplate__r.DeveloperName__c,
                                RejectEmailTemplate__r.DeveloperName__c,SendToOwnerEmailTemplate__r.DeveloperName__c,
                                EmailFieldAPIName__c,NotifyPreviousApprovers__c,FieldAPIForTask__c,
                                ApproveTaskConfig__r.TaskAction__c,ReassignTaskConfig__r.TaskAction__c,
                                DisapproveTaskConfig__r.TaskAction__c,SendtoOwnerTaskConfig__r.TaskAction__c,
                                ActionClass__c FROM ApprovalProcessStepCache__c Where ApprovalDefinitionId__c = : approvalDefinationId And ApprovalStepId__c = : approvalStepId WITH USER_MODE];
        }                
        return processStepCacheList;    
    }
/*
    Method to execute Action Class for Approval Step.
*/
   private static  String executeActionclass(String className, String approvalAction, Id selectedRecordId){
        String[] spliStr;
        Type t;
        ApprovalDecisionActionHandler  approvalDecision;
        try {
            if(className.contains('.')){
                spliStr = className.split('\\.');
                t = Type.forName(spliStr[0], spliStr[1]);
            }else{
                t = Type.forName(null, className);
            }
            approvalDecision = (ApprovalDecisionActionHandler)t.newInstance();
        } catch(Exception ex) {
            throw new CustomExceptions.InputDataException('Class not found with Name ' + className + '. Please check class name or it is not global.');
        }
        approvalDecision.selectedRecordId = selectedRecordId;
        approvalDecision.selectedAction = approvalAction;
        String msg = approvalDecision.execute();
        return msg;
    }

    public static void notifyAdditionalPeople(String action,Id recordId,List<ApprovalProcessStepCache__c> processStepCacheList, String reassignOwnerId){
            String templateName = '';
            if(processStepCacheList.size() > 0 && processStepCacheList.get(0).NotifyAdditionalPeople__c == true){
                Set<String> setSendEmailToUserIds = new Set<String>();
                if(processStepCacheList.get(0).EmailFieldAPIName__c != null){
                    String sobjectName = recordId.getSObjectType().getDescribe().getName();
                    String emailFields = processStepCacheList.get(0).EmailFieldAPIName__c;
                    SObject sobj;
                    if(sobjectName != null && emailFields!=null){
                        String query = 'Select ' + String.escapeSingleQuotes(emailFields) + ' From ' + String.escapeSingleQuotes(sobjectName) + ' Where Id = :'+String.escapeSingleQuotes(recordId);
                        if(AppUtils.isObjectAccessible(sobjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                            sobj = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                        }
                    }
                    List<String> emailSeparatedFields = emailFields.split(',');
                    if(reassignOwnerId != null && reassignOwnerId != ''){
                    	setSendEmailToUserIds.add(reassignOwnerId);
                    }
                    
                    for(String emailSep : emailSeparatedFields){
                        String emailId = (String)sobj.get(emailSep);
                        if(emailId != null){
                            setSendEmailToUserIds.addAll(emailId.split(','));
                        }
                    }
                }
                if(action == 'Approve'){
                    templateName = processStepCacheList.get(0).ApproveEmailTemplate__r.DeveloperName__c;
                }
                else if(action == 'Reassign'){
                     templateName = processStepCacheList.get(0).ReassignedEmailTemplate__r.DeveloperName__c;
                }
                else if(action == 'Disapprove'){
                     templateName = processStepCacheList.get(0).RejectEmailTemplate__r.DeveloperName__c;
                }
                else if(action == 'Send to Owner'){
                     templateName = processStepCacheList.get(0).SendToOwnerEmailTemplate__r.DeveloperName__c;
                    
                }
                if(processStepCacheList.get(0).NotifyPreviousApprovers__c == true){
                     List<ProcessInstanceStep> processInstance = [SELECT Id,ActorId,OriginalActorId,ProcessInstanceId,StepStatus,ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId 
                     FROM ProcessInstanceStep where  ProcessInstance.TargetObjectId = :recordId And StepStatus='Approved' WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                     for(ProcessInstanceStep actor : processInstance){
                        setSendEmailToUserIds.add(actor.ActorId);
                     }
                }
                if(setSendEmailToUserIds.size() > 0 && templateName != null) {
                    for(String userId : setSendEmailToUserIds) {
                        //check pattern
                        if(isValidSalesforceId(userId)){
                            new EmailFeeder().TargetObjectId(userId).template(templateName).contextRecordId(recordId).send(); 
                        }
                        else{
                            new EmailFeeder().toEmail(userId).template(templateName).contextRecordId(recordId).send(); 
                        }
                    }
                }
                      
            }
            if(processStepCacheList.size() > 0 ){
                Set<String> taskusers = new Set<String>();
                if(processStepCacheList.get(0).FieldAPIForTask__c != null){
                    String sobjectName1 = recordId.getSObjectType().getDescribe().getName();
                    String fieldForTask = processStepCacheList.get(0).FieldAPIForTask__c;
                    SObject sobj1;
                    if( fieldForTask != null && sobjectName1 != null){
                        String query1 = 'Select ' + String.escapeSingleQuotes(fieldForTask)  + ' From ' + String.escapeSingleQuotes(sobjectName1) + ' Where Id = : '+String.escapeSingleQuotes(recordId);
                        if(AppUtils.isObjectAccessible(sobjectName1)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                            sobj1 = Database.query(String.escapeSingleQuotes(query1), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                        }
                    }
                    List<String> taskSeparatedFields = fieldForTask.split(',');
                    //Prajakta remove comment
                    for(String taskSep : taskSeparatedFields){
                        String taskField = (String)sobj1.get(taskSep);
                        if(taskField != null){
                            taskusers.addAll(taskField.split(','));
                        }
                    }
                }
                String fieldAPIname = null;
                if( action == 'Approve'){
                    fieldAPIname = processStepCacheList.get(0).ApproveTaskConfig__r.TaskAction__c;
                }
                if( action == 'Reassign'){
                    fieldAPIname = processStepCacheList.get(0).ReassignTaskConfig__r.TaskAction__c;
                }
                if( action == 'Disapprove'){
                    fieldAPIname = processStepCacheList.get(0).DisapproveTaskConfig__r.TaskAction__c;
                }
                if( action == 'Send to Owner' ){
                    fieldAPIname = processStepCacheList.get(0).SendtoOwnerTaskConfig__r.TaskAction__c;
                }
                if(taskusers.size() > 0 && fieldAPIname != null) {
                    //Added code to pass recordname to create task method.To Populate Task description we pass recordname 
                    String sobjectName1 = recordId.getSObjectType().getDescribe().getName();
                    String query11 = 'Select Name From ' +String.escapeSingleQuotes(sobjectName1) + ' Where Id = : '+String.escapeSingleQuotes(recordId);//Here we get name of record from recordid
                    List<SObject> sobj11 = new List<SObject>();
                    if(AppUtils.isObjectAccessible(sobjectName1)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                        sobj11 = Database.query(String.escapeSingleQuotes(query11), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                    }
                    String recordname = null;
                    for(SObject so :sobj11){
                        recordname = (String)so.get('Name');
                    }
                    for(String task1 : taskusers ){
                        List<Task> approvalTaskList1 = TaskCreationHandler.createTasks(task1,recordId,fieldAPIname , recordname, null, null, null, null, null, false, true); 
                    }

                }
            }
    }


    public void performApprovalActions( String approvalActionChosen, ProcessInstanceWorkitem selectedInstanceWorkItem,
                                        List<ProcessInstanceNode> processInstanceNodes,List<Task> approvalTaskList,
                                         List<String> approvalInstanceIds, Boolean redirectFlag, TaskConfig__c taskAction){
        List<TaskConfig__c> taskActionList = new List<TaskConfig__c>();
        List<Task> closeDuplicateTask = new List<Task>();//delegated issue 
        if(approvalActionChosen == 'Approve') {
            isError = false;
            nextStepExists = true;
           approveRequest(selectedInstanceWorkItem, actionConfigMap.get('Approve'));
                if(!isError){
                   List<ProcessInstanceNode> newProcessInstanceNodes = [SELECT id FROM ProcessInstanceNode WHERE NodeStatus in('Started', 'Pending') AND ProcessInstance.TargetObjectId = :recordId
                                                and ProcessNodeId != :processInstanceNodes[0].ProcessNodeId WITH USER_MODE limit 1];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if(newProcessInstanceNodes.size() > 0) {
                        nextStepExists = checkForNextStep(approvalTaskList);
                    }
                    if(approvalTaskList.size() > 0){
                        closeDuplicateTask = [SELECT id,ActivityDate,WorkitemId__c from Task where WorkitemId__c =:approvalTaskList.get(0).WorkitemId__c AND OwnerId != :UserInfo.getUserId() AND Subject =:approvalTaskList.get(0).Subject WITH USER_MODE];  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    }
                    if(!closeDuplicateTask.isEmpty()){
                        for(Task t : closeDuplicateTask){
                            if (Schema.sObjectType.Task.fields.Status.isUpdateable()) {
                                t.Status = 'Completed';   
                            }
                        }
                        if(Schema.sObjectType.Task.isUpdateable()){
                        update as user closeDuplicateTask;
                    } 
                    } 
                    //close pending task if any
                    closePendingTask(JSON.serialize(approvalInstanceIds));
                }
            if(!approvalTaskList.isEmpty()){
                approvalTaskList.get(0).Status = 'Completed';
                if(Schema.sObjectType.TaskConfig__c.isAccessible()){
                    if(approvalTaskList.get(0).AssignedToQueue__c == true){
                        List<TaskConfig__c> taskActionList1 = [SELECT PostDecisionPage__c FROM TaskConfig__c WHERE TaskAction__c=:approvalTaskList.get(0).TaskAction__c AND GroupType__c = 'GroupTasks' WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                            if(taskActionList1.size() > 0) {
                                taskAction = taskActionList1.get(0);
                            }
                        if(taskAction != null && taskAction.PostDecisionPage__c != null){
                            redirectFlag = true;
                        }
                    }else{
                            taskActionList = [SELECT PostDecisionPage__c FROM TaskConfig__c WHERE TaskAction__c=:approvalTaskList.get(0).TaskAction__c AND GroupType__c = 'MyTasks' WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                        if(taskActionList.size() > 0 && taskActionList[0].PostDecisionPage__c!=null){
                            redirectFlag = true;
                            taskAction = taskActionList[0];
                        }   
                    }
                }
            }
        }
        if(approvalActionChosen == 'Disapprove'){
            isError = false;
            nextStepExists = true;
            disapproveRequest(selectedInstanceWorkItem, actionConfigMap.get('Disapprove'));
            if(!isError){
                List<ProcessInstanceNode> newProcessInstanceNodes = [SELECT id from ProcessInstanceNode where NodeStatus in('Started', 'Pending') and ProcessInstance.TargetObjectId = :recordId
                                            and ProcessNodeId != :processInstanceNodes[0].ProcessNodeId WITH USER_MODE limit 1]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(newProcessInstanceNodes.size() > 0) {
                    nextStepExists = checkForNextStep(approvalTaskList);
                }
                if(approvalTaskList.size() > 0){
                    closeDuplicateTask = [SELECT id,ActivityDate,WorkitemId__c from Task 
                                        where WorkitemId__c =:approvalTaskList.get(0).WorkitemId__c AND OwnerId != :UserInfo.getUserId() AND Subject =:approvalTaskList.get(0).Subject WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                }
                if(!closeDuplicateTask.isEmpty()){
                    for(Task t : closeDuplicateTask){
                        if (Schema.sObjectType.Task.fields.Status.isUpdateable()) {
                            t.Status = 'Completed';
                        }
                    }
                    if(Schema.sObjectType.Task.isUpdateable()){
                    update as user closeDuplicateTask;
                } 
                } 
                //close pending task if any
                closePendingTask(JSON.serialize(approvalInstanceIds));
            }
            if(!approvalTaskList.isEmpty()){
                approvalTaskList.get(0).Status = 'Completed';                 
            }
        }
        if(approvalActionChosen == 'Reassign'){
            isError = false;            
            sendForFurtherReview(selectedInstanceWorkItem,actionConfigMap.get('Reassign'));
            if(!approvalTaskList.isEmpty()){
                approvalTaskList.get(0).Status = 'Completed';
                closeDuplicateTask = [SELECT id,ActivityDate,WorkitemId__c from Task where WorkitemId__c =:approvalTaskList.get(0).WorkitemId__c AND OwnerId != :UserInfo.getUserId() AND Subject =:approvalTaskList.get(0).Subject WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(!closeDuplicateTask.isEmpty()){
                    for(Task t : closeDuplicateTask){
                        if (Schema.sObjectType.Task.fields.Status.isUpdateable()) {
                            t.Status = 'Completed';   
                        }
                    }
                    if(Schema.sObjectType.Task.isUpdateable() && Task.sObjectType.getDescribe().isAccessible() == true){
                    update as user closeDuplicateTask;
                }   
                }   
             List<String> newtaskIdList = createReassignTask(approvalTaskList,chosenUserId);
             closePendingTask(JSON.serialize(approvalInstanceIds),String.join(newtaskIdList,','));
            }
        }
        if(approvalActionChosen == 'Send to Owner'){
            isError = false;
            sendToOwner(selectedInstanceWorkItem, actionConfigMap.get('Send to Owner'));
            if(!approvalTaskList.isEmpty()){
                approvalTaskList.get(0).Status = 'Completed';
                closeDuplicateTask = [SELECT id,ActivityDate,WorkitemId__c from Task where WorkitemId__c =:approvalTaskList.get(0).WorkitemId__c AND OwnerId != :UserInfo.getUserId() AND Subject =:approvalTaskList.get(0).Subject WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(!closeDuplicateTask.isEmpty()){
                    for(Task t : closeDuplicateTask){
                        if (Schema.sObjectType.Task.fields.Status.isUpdateable()) {
                            t.Status = 'Completed';   
                        }
                    }
                    if(Schema.sObjectType.Task.isUpdateable() && Task.sObjectType.getDescribe().isAccessible() == true){
                    update as user closeDuplicateTask;
                    }
                } 
            }
            //close pending task if any
            closePendingTask(JSON.serialize(approvalInstanceIds));
        }
    }
    public static  List<ProcessInstanceNode> getProcessInstanceNodes(String recordId){
        List<ProcessInstanceNode> processInstanceNodes = new List<ProcessInstanceNode>();
        processInstanceNodes = [SELECT id,ProcessNodeName,ProcessNodeId,NodeStatus,ProcessInstanceId,
                                ProcessInstance.ProcessDefinitionId,ProcessInstance.TargetObjectId
                                 from ProcessInstanceNode where NodeStatus in('Started', 'Pending')
                                  and ProcessInstance.TargetObjectId = :recordId WITH USER_MODE limit 1]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        return processInstanceNodes;
    }
  
    //This method is to create new task for reassign user. The user name will get populated in assigned by field of task who reassigned task.
     private List<String> createReassignTask(List<Task> approvalTaskList, String chosenUserId){
                
                Set<String> fieldNames = new Set<String>();
                Map<String, Schema.SObjectField> FieldMap = Schema.SObjectType.Task.fields.getMap();
                for (Schema.SObjectField f : FieldMap.values()) {
                    Schema.DescribeFieldResult DescField = f.getDescribe();
                    //we are getting duplicate field selected issues when we are having same field on managed and unmanaged side ,so we are using getLocalName() method.
                    fieldNames.add(DescField.getLocalName());
                }
                List<String> fieldList = new  List<String>();
                fieldList.addAll(fieldNames);
                String fieldName = String.join(fieldList, ',');
                string recordId = '';
                if(approvalTaskList.size() > 0){
                    recordId = approvalTaskList.get(0).Id;
                }
                //Get all fields from task.
                List<SObject> sobj11 = new List<SObject>();
                if(fieldName != null){
                    String query = 'Select ' + String.escapeSingleQuotes(fieldName)  + ' From ' + 'Task' + ' Where Id = : '+String.escapeSingleQuotes(recordId); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    sobj11 = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind 
                }
                if(chosenUserId.startsWith('005')){
                    return getUser(chosenUserId,sobj11);
  
                }

                if(chosenUserId.startsWith('00G')){
                    return getQueue(chosenUserId,sobj11);
  
                }
                return null;
                
                
        }


            private static list<String> getUser(String chosenUserId, List<SObject> sobj){
                 list<String> userList = new list<String>();
                List<Task> CloneApprovalTaskList = sobj.clone();
                CloneApprovalTaskList.get(0).Status = 'Not Started';
                CloneApprovalTaskList.get(0).OwnerId = chosenUserId;
                CloneApprovalTaskList.get(0).Id = null;
                CloneApprovalTaskList.get(0).GroupId__c = null;
               SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
                systemContextMethodsHelper.insertSobject(CloneApprovalTaskList);
                userList.add(CloneApprovalTaskList.get(0).Id);
                return userList;

            }

            //Below method is used to create task for queue. Queue cannot be owner of task. So we created list and added all queue memebers in list.
            private static list<String> getQueue(String chosenUserId, List<SObject> sobj){
                list<String> queueList = new list<String>();
                Id groupId = Id.valueOf(chosenUserId);
        List<GroupMember> groupMemeberList = [Select UserOrGroupId from GroupMember where GroupId =: groupId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                 List<String> UserOrGroupIdList = new lIST<String>();
                 for(GroupMember grpMem : groupMemeberList){
                    UserOrGroupIdList.add(grpMem.UserOrGroupId);
                 }
                 List<Task> CloneApprovalTaskList = new List<Task>();
                 List<User> uList = [Select Id ,IsActive from User Where IsActive = true and Id in:UserOrGroupIdList WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                 for(User u :uList){
                    Task task = (Task)sobj.get(0).clone();
                    task.Status = 'Not Started';
                    task.OwnerId = u.Id ;
                    task.Id = null;
                    //For queue this field needs to be set for closing task of users in queue.
                    task.GroupId__c = chosenUserId;
                    CloneApprovalTaskList.add(task);   
                 }
                /*for(GroupMember groupMem: groupMemeberList){
                     Task task = (Task)sobj.get(0).clone(); 

                     //CloneApprovalTaskList.get(0).Status = 'Not Started';
                    task.Status = 'Not Started';
                    task.OwnerId = groupMem.UserOrGroupId;
                    task.Id = null;
                    //For queue this field needs to be set for closing task of users in queue.
                    task.GroupId__c = chosenUserId;
                    CloneApprovalTaskList.add(task);    
                }*/
                SystemContextMethodsHelper systemContextMethodsHelper = new SystemContextMethodsHelper();
                if(Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.fields.Status.isCreateable() && Schema.sObjectType.Task.fields.OwnerId.isCreateable() && Schema.sObjectType.Task.fields.GroupId__c.isCreateable()){
                    systemContextMethodsHelper.insertSobject(CloneApprovalTaskList);
                }
                for(Task clone : CloneApprovalTaskList){
                    queueList.add(clone.Id);
                }

                return queueList;

    }
    // handle and parse Trigger Error Message
    private static string parseTriggerErrorMsg(String errorMsg){

        String finalErrorMsg = '';
        if(!String.isEmpty(errorMsg) && errorMsg.contains(':')){
            List<String> parts = new List<String>();
            List<String> subParts = new List<String>();
        
            parts = errorMsg.split(':', 2);
           
            if(!String.isEmpty(parts[1]) && parts[1].contains(',')){
                subParts = parts[1].split(',',2);
                if(!String.isEmpty(subParts[1])){
                    String partString = subParts[1];
                    String errorMessage = partString.substringBefore(': [');
                    if(partString.contains(': [') && !String.isEmpty(errorMessage)){
                        finalErrorMsg = errorMessage.trim();
                    }
                }                    
            }
        }
        return finalErrorMsg;
    }
  
}