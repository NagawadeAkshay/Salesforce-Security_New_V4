/**
    For a given flex view layout, it analyzes all the defined active buttons
    and identifies the ones which should be rendered on the view layout.
    It returns a collection of all the buttons which are eligible for rendering
    either as visible or disabled mode.

    @author Shah Kadirmohideen  
*/
global with sharing class FlexLayoutActionsGenerator {
    private String recordId;
    private String layoutId;

    private PageLayoutConfig__c layout;
    private List<PageLayoutActionConfig__c> actions;
    private List<FlexLayoutActionProperty> decisionList = new List<FlexLayoutActionProperty>(); 

    private Map<String,Set<Id>> queueMemberMap = new Map<String,Set<Id>>(); //key->queue developer name

    private Boolean isFormLayout;
    private Map<String, Object> paramMap;
    Public string headerBackButton; 

    public FlexLayoutActionsGenerator(String recordId, String layoutId, Map<String, Object> paramMap) {
        this.recordId = recordId;
        this.layoutId = layoutId;
        this.paramMap = paramMap;
        String parentId = (String)paramMap.get('parentId');
        this.isFormLayout = !String.isEmpty(parentId) ? true : false;
    }

    public Map<String, Object> decide() {
        Map<String, Object> retVal = new Map<String, Object>();

        try {
            if (String.isNotEmpty(recordId)) {
                loadLayout();
                loadActions();
                if(isFormLayout) {
                    loadFormDefaultActions();
                }
                loadQueues();
                analyzeActions();
            }
            retVal.put('Success', true);
            retVal.put('Actions', decisionList);
            if(KeyValueStoreHelper.getBooleanValue('EnableModalHeaderActionButtons', true) != null){      
                retVal.put('EnableModalHeaderActionButtons', KeyValueStoreHelper.getBooleanValue('EnableModalHeaderActionButtons', true));
            }else{
                retVal.put('EnableModalHeaderActionButtons', false);
            }
        }
        catch (Exception e) {
            retVal.put('Success', false);
            retVal.put('Error', AppUtils.handleSystemExceptionMsg(e) + ', trace: ' + e.getStackTraceString());
        }
        return retVal;
    }



    private void loadLayout() {
        if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
            this.layout = [Select Id, Name, ObjectAPIName__c from PageLayoutConfig__c where Id=:layoutId WITH USER_MODE];
        }
    }

    private void loadActions() {    //include  sobject action fields
        if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
            this.actions = [Select Id, Name, HideDecisionExpression__c,HideDecisionExpressionLong__c, DisableDecisionExpression__c, 
                        HideDecisionField__c, DisableDecisionField__c, DisplayArea__c,IconCSS__c, 
                        ActionURL__c, ActionClass__c, ModalHeight__c, ModalTitle__c, ModalWidth__c, ActionBehavior__c,
                        SubmitWarningMessage__c, StandardAction__c, RecordType.DeveloperName, SubmitWarningMessageLong__c,
                        SubmitAction__c, IsSubmit__c, HideOperator__c,Type__c, ShowIconOnly__c,
                        HideForUser__c, HideForProfile__c, HideForQueue__c, HideForContext__c, Tooltip__c,
                        HidePanel__c,RefreshBehaviour__c,SobjectActionConfig__r.HideDecisionExpression__c,SobjectActionConfig__r.HideDecisionExpressionLong__c,
                        SobjectActionConfig__r.HideForContext__c,SobjectActionConfig__r.HideForUser__c,SobjectActionConfig__r.HideForProfile1__c,
                        EnablePromptInputDialog__c,PromptDailogHeader__c,PromptDialogText__c,ButtonHelpText__c,HideExpressionJSON__c,HideExpressionFields__c,SobjectActionConfig__r.HideExpressionJSON__c,SobjectActionConfig__r.HideExpressionFields__c,ActionURLLightning__c             
                        from PageLayoutActionConfig__c
                        where PageLayoutConfig__c=:layout.Id and Active__c = true WITH USER_MODE order by HeaderSequence__c];
        }
    }

    private void loadQueues() {
        Set<String> queueNames = new Set<String>();
        for(PageLayoutActionConfig__c action : actions){
            if (String.isNotEmpty(action.HideForQueue__c)){
                action.HideForQueue__c = action.HideForQueue__c.replace(',', ';');
                for (String queue : action.HideForQueue__c.split(';')) {
                    queueNames.add(queue.trim());
                }
            }
        }

        if (queueNames.size() > 0) {
            List<GroupMember> groupMembers;
            if(GroupMember.sObjectType.getDescribe().isAccessible()) {
                groupMembers = [SELECT Id, GroupId, UserOrGroupId, Group.DeveloperName FROM GroupMember 
                    where Group.DeveloperName in :queueNames and Group.type = 'Queue' WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            }
            
            for(GroupMember memberInstance : groupMembers){
                if(queueMemberMap.get(memberInstance.Group.DeveloperName) != null){
                    Set<Id> memberList = queueMemberMap.get(memberInstance.Group.DeveloperName);
                    memberList.add(memberInstance.UserOrGroupId);
                }
                else{
                    Set<Id> memberList = new Set<Id> (); 
                    memberList.add(memberInstance.userOrGroupId);
                    queueMemberMap.put(memberInstance.Group.DeveloperName, memberList);
                }
            } 
        }
    }

    
    private void analyzeActions() {
        Map<String, Object> keyValMap = new Map<String, Object>();
        String keyValJSON = (String)paramMap.get('keyValMap');
        if(String.isNotEmpty(keyValJSON)) {
            keyValMap = (Map<String,Object>)JSON.deserializeUntyped(keyValJSON);
        }
        Set<String> hideExpressionFieldsSet = new Set<String>();
        Set<String> hideExpressionFieldsSetIgnoreDuplicates = new Set<String>();
        for(PageLayoutActionConfig__c action:actions){
            if(String.isNotEmpty(action.SobjectActionConfig__r.HideExpressionJSON__c)){
                if(String.isNotEmpty(action.SobjectActionConfig__r.HideExpressionFields__c)){
                    hideExpressionFieldsSet.addAll((action.SobjectActionConfig__r.HideExpressionFields__c).split(','));
                }
            } else if(String.isNotEmpty(action.HideExpressionJSON__c)){
                if(String.isNotEmpty(action.HideExpressionFields__c)){
                    hideExpressionFieldsSet.addAll((action.HideExpressionFields__c).split(','));
                }
            }
        }
        for(String itrHideExpressionFieldsSet : hideExpressionFieldsSet){
            if(!hideExpressionFieldsSetIgnoreDuplicates.contains(itrHideExpressionFieldsSet.toLowerCase())){
                hideExpressionFieldsSetIgnoreDuplicates.add(itrHideExpressionFieldsSet.toLowerCase());
            }
        }
        List<sObject> sobjList = new List<sObject>();
        if(hideExpressionFieldsSet.size() > 0 ){
            String query = 'SELECT '+String.escapeSingleQuotes(String.join(new List<String>(hideExpressionFieldsSetIgnoreDuplicates.size()>0 ? hideExpressionFieldsSetIgnoreDuplicates : hideExpressionFieldsSet),',')) + ' From '+string.escapeSingleQuotes(layout.ObjectAPIName__c)+ ' WHERE Id = \''+string.escapeSingleQuotes(recordId)+'\'';
             sobjList = Database.query(query, AccessLevel.USER_MODE);
        }

        for (PageLayoutActionConfig__c action : actions) {
            Boolean expResult = false;
            if(String.isNotEmpty(action.SobjectActionConfig__r.HideExpressionJSON__c)){
                    expResult = ExpressionJSONEvaluator.evaluateExpression(action.SobjectActionConfig__r.HideExpressionJSON__c,sobjList,'View');   
            } else if(String.isNotEmpty(action.HideExpressionJSON__c) && String.isEmpty(action.SobjectActionConfig__c)){
                    expResult = ExpressionJSONEvaluator.evaluateExpression(action.HideExpressionJSON__c,sobjList,'View');   
            }
            if(String.isNotEmpty(action.SobjectActionConfig__r.HideExpressionJSON__c) || String.isNotEmpty(action.HideExpressionJSON__c)){
                action.HideForProfile__c = null;
                action.HideForContext__c = null;
                action.HideForUser__c = null;
                action.HideDecisionField__c = null; 
            }
            FlexLayoutActionHandler handler = new FlexLayoutActionHandler(action, recordId, layout.ObjectAPIName__c, 
                    queueMemberMap, action.HideOperator__c, keyValMap);
            FlexLayoutActionProperty decision = handler.decide();
            if(expResult){
                decision =null;    
            }
            if (decision != null ) {
                decisionList.add(decision);
            }
        }       
    }

    private void loadFormDefaultActions() {
        PageLayoutActionConfig__c editAction;
        PageLayoutActionConfig__c cancelAction;
        for (PageLayoutActionConfig__c action : actions) {
            if( action.StandardAction__c == 'Edit' ) {
                editAction = action;
            }
            if( action.StandardAction__c == 'Back' ) {
                cancelAction = action;
            }
        }
        getCancelFormAction(cancelAction);
        getEditFormAction(editAction);
    }
    
    private void getCancelFormAction(PageLayoutActionConfig__c cancelAction) {
        if(cancelAction == null) {
            headerBackButton = Label.HeaderBackButton;
        	RecordType obj = new RecordType();
        	obj.DeveloperName = 'ActionURL';
            cancelAction = new PageLayoutActionConfig__c(Name=headerBackButton, Type__c='Button',RecordType = obj);
            actions.add(cancelAction);
        }
        cancelAction.ActionURL__c = '/';
        cancelAction.ActionURL__c += (paramMap.get('parentId') != null) ? (String)paramMap.get('parentId') : '';
    }
    
    private void getEditFormAction(PageLayoutActionConfig__c editAction) {
        if(editAction == null) {
        	RecordType obj = new RecordType();
        	obj.DeveloperName = 'ActionURL';
            editAction = new PageLayoutActionConfig__c(Name='Edit', Type__c='Button',RecordType = obj);
            actions.add(editAction);
        }
        editAction.ActionURL__c = '/apex/DynamicFormEdit?id=' + recordId;
        editAction.ActionURL__c += (paramMap.get('formTypes') != null) ? '&formTypes='+ (String)paramMap.get('formTypes') : '';
        editAction.ActionURL__c += (paramMap.get('formId') != null) ? '&formId='+ (String)paramMap.get('formId') : '';
        editAction.ActionURL__c += (paramMap.get('packageId') != null) ? '&packageId='+ (String)paramMap.get('packageId') : '';
        editAction.ActionURL__c += (paramMap.get('parentId') != null) ? '&parentId='+ (String)paramMap.get('parentId') : '';
        editAction.ActionURL__c += (paramMap.get('parentLayoutId') != null) ? '&parentLayoutId='+ (String)paramMap.get('parentLayoutId') : '';
        editAction.ActionURL__c += (paramMap.get('tempalteName') != null) ? '&templateName='+ (String)paramMap.get('tempalteName') : '';
        editAction.ActionURL__c += (paramMap.get('formInstanceId') != null && paramMap.get('formInstanceId') != '') ? '&formInstanceId='+ (String)paramMap.get('formInstanceId') : '';
    }

}