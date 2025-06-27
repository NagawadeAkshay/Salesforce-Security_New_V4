/*
    Trigger Helper for ConfigPageLayoutActionTrigger.
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    06-09-2018      Tomy Pallissery     Modified
                                        1. Trigger bulkification and code cleanup
                    Tejashreee D        1. added with sharing for SF security review, PageLayoutActionConfig__c is controlled by 
                    parent that Page Layout Config and this is Public read only
    ****************************************************************************************
*/
public with sharing class ConfigPageLayoutActionTriggerHelper extends TriggerHelper{
	public override void processBeforeInsert() {
		decideHideExpFields();
	}

	public override void processBeforeUpdate() { 
		decideHideExpFields();
	}

    private void decideHideExpFields() {
        Set<Id> pageLayoutIdSet = new Set<Id>();
        List<PageLayoutActionConfig__c> pageLayoutActionList = (List<PageLayoutActionConfig__c>)Trigger.new;
        
        for(PageLayoutActionConfig__c pageLayoutAction :pageLayoutActionList) { 
            pageLayoutIdSet.add(pageLayoutAction.PageLayoutConfig__c);
        }

        List<PageLayoutConfig__c> pageLayoutConfigList = new List<PageLayoutConfig__c>();
        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
            pageLayoutConfigList = [SELECT Id, ObjectAPIName__c FROM PageLayoutConfig__c WHERE Id IN: pageLayoutIdSet WITH USER_MODE];
        }
        Map<Id,String> pageLayoutIdAndSObjectMap = new Map<Id,String>();

        for(PageLayoutConfig__c pageLayoutConfig :pageLayoutConfigList) { 
           pageLayoutIdAndSObjectMap.put(pageLayoutConfig.Id, pageLayoutConfig.ObjectAPIName__c);
        }

        for(PageLayoutActionConfig__c pageLayoutAction :pageLayoutActionList) { 
            if(String.isNotEmpty(pageLayoutAction.HideExpressionJSON__c)) {
                String expJson = pageLayoutAction.HideExpressionJSON__c;
                String mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
                if(String.isNotEmpty(mergeFields)) {
                    if(ExpressionJSONEvaluator.hasSObjectField(mergeFields, pageLayoutIdAndSObjectMap.get(pageLayoutAction.PageLayoutConfig__c))) {
                        pageLayoutAction.HideExpressionFields__c = mergeFields;
                    }
                } else {
                    pageLayoutAction.HideExpressionFields__c = '';
                }
            } else {
                pageLayoutAction.HideExpressionFields__c = '';
            }
        }
    }
}