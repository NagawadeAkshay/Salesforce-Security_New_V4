/**
    For a single action (button) that belongs to a view layout, it identifies if that button
    can be rendered or not. And if it is eligible for rendering, should be it be disabled or not?

    Note that it currently works only for view layout.

    @author Shah Kadirmohideen
*/
global with sharing class FlexLayoutActionHandler {
    private PageLayoutActionConfig__c action {get; set;}
    private String objectName;
    private String recordId;
    private Map<String, Set<Id>> queueMemberMap;
    private String operator;
    private Map<String, Boolean> hideDecisionMap = new Map<String, Boolean>();
    private Map<String, Object> keyValMap;
    private static String userProfileName = AppUtils.getProfileInfo();
    private static String userType = AppUtils.getUserType();
    
    //Obsolete constructor
    global FlexLayoutActionHandler(PageLayoutActionConfig__c action, String recordId, String objectName, 
                    Map<String, Set<Id>> queueMemberMap, String operator) { 
                        //keyValMap = new Map<String, String>();
    }
    global FlexLayoutActionHandler(PageLayoutActionConfig__c action, String recordId, String objectName, 
                    Map<String, Set<Id>> queueMemberMap, String operator, Map<String, String> keyValMap) {
        //Map<String, Object> keyValMap1 = (Map<String, Object>)keyValMap;
    }
    global FlexLayoutActionHandler(PageLayoutActionConfig__c action, String recordId, String objectName, 
                    Map<String, Set<Id>> queueMemberMap, String operator, Map<String, Object> keyValMap) {
        this.action = action;
        this.recordId = recordId;
        this.objectName = objectName;           
        this.queueMemberMap = queueMemberMap;
        this.operator = operator;
        this.keyValMap = keyValMap;
    }

    public FlexLayoutActionProperty decide() {
        Boolean hide = isHidden();
        if (hide) {
            return null;  //button should not be rendered on UI
        }

        //If don't hide, then check if there is a need to disable the button    
        FlexLayoutActionProperty decision = new FlexLayoutActionProperty(action, recordId, objectName);
        decision.disable = isDisabled();
        return decision;
    }

    /* PRIVATE METHODS */

    private Boolean isHidden() {        
        isHiddenByContext();
        isHiddenByUserType();       
        isHiddenByProfile();
        isHiddenByQueue(); 
        isHiddenByExpression(); 


        //Make final decision based on operator
        Integer trueCnt=0, falseCnt=0;
        for (Boolean flag : hideDecisionMap.values()) {
            if (flag) {
                trueCnt++;
            }
            else {
                falseCnt++;
            }
        }

        Boolean hide = false;
        if(operator == 'AND') {
            hide =  trueCnt > 0 && falseCnt == 0;
        }
        else { //operator is OR
            hide =  trueCnt > 0;
        }

        return hide;
    }

    private void isHiddenByContext() {                              
        if(String.isNotEmpty(action.SobjectActionConfig__c)){           /*Check SobjectAction*/
            if (String.isNotEmpty(action.SobjectActionConfig__r.HideForContext__c)) {
                hideDecisionMap.put('hideByContext', action.SobjectActionConfig__r.HideForContext__c.contains('View'));
            }                                 
        }else{
            if (String.isNotEmpty(action.HideForContext__c)) {
                hideDecisionMap.put('hideByContext', action.HideForContext__c.contains('View'));
            }
        }
        
    }

    private void isHiddenByUserType() {
        if(String.isNotEmpty(action.SobjectActionConfig__c)){
            if (String.isNotEmpty(action.SobjectActionConfig__r.HideForUser__c)) {
                hideDecisionMap.put('hideByUserType', action.SobjectActionConfig__r.HideForUser__c.contains(userType));
            }                                
        }else{
            if (String.isNotEmpty(action.HideForUser__c)) {
                hideDecisionMap.put('hideByUserType', action.HideForUser__c.contains(userType));
            }
        }
        
    }

    private void isHiddenByProfile() {
        if(String.isNotEmpty(action.SobjectActionConfig__c)){                            
                if(String.isNotEmpty(action.SobjectActionConfig__r.HideForProfile1__c)){
                    hideDecisionMap.put('hideByProfile', false);
                    for (String profile : action.SobjectActionConfig__r.HideForProfile1__c.split(';')) {
                    profile = profile.trim();
                    if (profile == userProfileName) {
                        hideDecisionMap.put('hideByProfile', true);
                        break;
                    }
                }    
                }                          
        }else{
            if (String.isNotEmpty(action.HideForProfile__c)) {
                hideDecisionMap.put('hideByProfile', false);
                for (String profile : action.HideForProfile__c.split(';')) {
                    profile = profile.trim();
                    if (profile == userProfileName) {
                        hideDecisionMap.put('hideByProfile', true);
                        break;
                    }
                }
            }
        }
        
    }

    private void isHiddenByQueue() {
        if (String.isNotEmpty(action.HideForQueue__c)) {
            hideDecisionMap.put('hideByQueue', false);
            List<String> queues = action.HideForQueue__c.split(';');
            for (String queue : queues) {
                queue = queue.trim();
                Set<Id> memberIds = queueMemberMap.get(queue);
                if (memberIds!= null && memberIds.contains(UserInfo.getUserId())){
                    hideDecisionMap.put('hideByQueue', true);
                    break;
                }
            }
        }       
    }

    /*private void isHiddenByField() {
        if (String.isNotEmpty(action.HideDecisionField__c)) {
            hideDecisionMap.put('hideByField', evaluateField(action.HideDecisionField__c));
        }   
    }*/

    private void isHiddenByExpression() {    //Check sobject action
         if(String.isNotEmpty(action.SobjectActionConfig__c)){   
             if (String.isNotEmpty(action.SobjectActionConfig__r.HideDecisionExpressionLong__c)) {
                hideDecisionMap.put('hideByExpression', evaluateExpression(action.SobjectActionConfig__r.HideDecisionExpressionLong__c));
             }
             else if (String.isNotEmpty(action.SobjectActionConfig__r.HideDecisionExpression__c)) {
                hideDecisionMap.put('hideByExpression', evaluateExpression(action.SobjectActionConfig__r.HideDecisionExpression__c));
             }                                        
        }
        else{
            if (String.isNotEmpty(action.HideDecisionExpressionLong__c	)) {
                hideDecisionMap.put('hideByExpression', evaluateExpression(action.HideDecisionExpressionLong__c	));
            }
            else if (String.isNotEmpty(action.HideDecisionExpression__c)) {
                hideDecisionMap.put('hideByExpression', evaluateExpression(action.HideDecisionExpression__c));
            }
        } 
    }

    private Boolean evaluateExpression(String expression) {
        expression = expression.replace('||', 'OR');
        expression = expression.replace('&&', 'AND');
        if(keyValMap != null) {
            for(String mergeField : keyValMap.keySet()) {
                if(keyValMap.get(mergeField) != null) { 
                    expression = expression.replace('{!' + mergeField + '}','\''+string.escapeSingleQuotes(String.valueOf(keyValMap.get(mergeField)))+'\'');
                }
            }
        }
        String soql = 'Select count() from ' + string.escapeSingleQuotes(objectName) + ' where Id=\'' + string.escapeSingleQuotes(recordId) + '\' and (' + string.valueOf(expression) + ')';
        Integer cnt = 0;

        try {
            cnt = Database.countQuery(soql, AccessLevel.USER_MODE);//NOPMD SOQL Injection false +ve dynamic parts of query are escapesingleQuotes
        }
        catch (Exception e) {
            throw new CustomExceptions.InputDataException('Failed while rendering button: ' + action.Name + ', SOQL failed: ' + soql);
        }

        return cnt == 1;
    }

    private Boolean isDisabled() {
        Boolean disable = false;
        if (String.isNotEmpty(action.DisableDecisionExpression__c)) {
            disable = evaluateExpression(action.DisableDecisionExpression__c);
        }   
        return disable;
    }

    //TODO: implement this method later as it is needed for application submission
    /*private Boolean isDisabledByRules() {
        //Boolean allowSubmit =  ApplicationSubmissionValidationHelper.validateApplication(this.layoutHolder, recordId);
        return false;
    }*/
}