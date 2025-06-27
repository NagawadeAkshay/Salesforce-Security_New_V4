/*
    Trigger Helper 
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review, Page tab is controlled by 
                    parent that Page Layout Config and this is Public read only
    ****************************************************************************************
*/
public with sharing class ConfigTabTriggerHelper extends TriggerHelper{

    public override void processBeforeUpdate() { 
        List<String> tabIdsList = new List<String>();

        Map<String,String> tabConfigMap = new Map<String,String>();
        List<TabConfig__c> tabConfigList = new List<TabConfig__c>();
        for(TabConfig__c tab:(list<TabConfig__c>)trigger.new){
                tabIdsList.add(tab.Id);
        } 
        if(Schema.sObjectType.TabConfig__c.isAccessible()){
            tabConfigList = [SELECT PageLayoutconfig__r.ObjectAPIName__c FROM TabConfig__c where Id IN :tabIdsList WITH USER_MODE];
        }
        for(TabConfig__c tab: tabConfigList){
                tabConfigMap.put(tab.Id,tab.PageLayoutconfig__r.ObjectAPIName__c);
        } 
        for(TabConfig__c tab :(list<TabConfig__c>)trigger.new){
            String mergeFields= '';
            String expJson = '';
            if(!String.isEmpty(tab.HideExpressionJSON__c)){
                expJson = tab.HideExpressionJSON__c;
                mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);  
            }
            if(!String.isEmpty(mergeFields)){
                if(ExpressionJSONEvaluator.hasSObjectField(mergeFields,tabConfigMap.get(tab.Id)) == true){
                    tab.HideExpressionFields__c = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
                }   
            }
        }
    }
}