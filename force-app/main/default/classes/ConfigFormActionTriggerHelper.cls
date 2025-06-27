/**
 * Created by REI on 02-01-2020.
 */

public with sharing class ConfigFormActionTriggerHelper extends TriggerHelper{
    public override void processBeforeInsert() {
        populateHideExpFields();
    }

    public override void processBeforeUpdate(){
        populateHideExpFields();
    }

    @TestVisible
    private void populateHideExpFields(){
        Set<Id> formIdSet = new Set<Id>();
        List<CaptureAction__c> captureActionList = (List<CaptureAction__c>)Trigger.new;

        for(CaptureAction__c captActionItem: captureActionList){
            formIdSet.add(captActionItem.CaptureForm__c);
        }

        // Iterating over capture form...
        List<CaptureForm__c> cpFormsList = new List<CaptureForm__c>();
        if(Schema.sObjectType.CaptureForm__c.isAccessible()){
            cpFormsList = [SELECT Id,Name,ObjectType__c
                                            FROM  CaptureForm__c
                                            WHERE Id IN :formIdSet WITH USER_MODE];
        }
        Map<Id,String> formIdAndSObjectMap = new Map<Id,String>();

        for(CaptureForm__c cpForms: cpFormsList){
            formIdAndSObjectMap.put(cpForms.Id,cpForms.ObjectType__c);
        }

        for(CaptureAction__c actionVal: captureActionList){
            if(String.isNotEmpty(actionVal.HideExpressionJSON__c)){
                String expJson = actionVal.HideExpressionJSON__c;
                String fieldExpStr = ExpressionJsonEvaluator.getfieldNamesFromJSON(expJson);
                if(String.isNotEmpty(fieldExpStr)){
                    if(ExpressionJsonEvaluator.hasSObjectField(fieldExpStr,formIdAndSObjectMap.get(actionVal.CaptureForm__c))){
                        actionVal.HideExpressionFields__c = fieldExpStr;
                    }else{
                        actionVal.HideExpressionFields__c = '';
                    }
                }else{
                    actionVal.HideExpressionFields__c = '';
                }
            }
        }
    }

}