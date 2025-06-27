/*
	Created By : Tomy Pallissery
	Created On : 09/04/2018
	Purpose	   : Helper class for SObjectLayoutConfig Trigger
*/
public with sharing class SObjectLayoutConfigTriggerHelper extends TriggerHelper {

	public override void processBeforeUpdate() {
    	populateLayoutExpressionFields(Trigger.New);   
    }

    private void populateLayoutExpressionFields(List<SObjectLayoutConfig__c> sObjectLayoutConfigList) {

    	List<String> sObjectLayoutIdsList = new List<String>();

        Map<String,String> sObjectLayoutCnfgAndSObjNameMap = new Map<String,String>();
        List<SObjectLayoutConfig__c> sObjectLayoutConfigs = new List<SObjectLayoutConfig__c>();

        for(SObjectLayoutConfig__c sObjectLayoutConfig : sObjectLayoutConfigList){
                sObjectLayoutIdsList.add(sObjectLayoutConfig.Id);
        }
        if(Schema.sObjectType.SObjectLayoutConfig__c.isAccessible()) {
            sObjectLayoutConfigs = [SELECT SObjectConfig__r.Name 
                        		FROM SObjectLayoutConfig__c WHERE Id IN :sObjectLayoutIdsList WITH USER_MODE];
        }
        for(SObjectLayoutConfig__c sObjectLayoutConfig : sObjectLayoutConfigs){
                sObjectLayoutCnfgAndSObjNameMap.put(sObjectLayoutConfig.Id, sObjectLayoutConfig.SObjectConfig__r.Name);
        } 

        for(SObjectLayoutConfig__c sObjectLayoutConfig : sObjectLayoutConfigList){
            String mergeFields= '';
            String expJson = '';
            if(String.isNotEmpty(sObjectLayoutConfig.DisplayLayoutExpressionJSON__c)){
                expJson = sObjectLayoutConfig.DisplayLayoutExpressionJSON__c;
                mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
            }
            if(String.isNotEmpty(mergeFields)){
                if(ExpressionJSONEvaluator.hasSObjectField(mergeFields, sObjectLayoutCnfgAndSObjNameMap.get(sObjectLayoutConfig.Id)) == true){
                    sObjectLayoutConfig.DisplayLayoutExpressionFields__c = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
                }   
            }
        }

    }
}