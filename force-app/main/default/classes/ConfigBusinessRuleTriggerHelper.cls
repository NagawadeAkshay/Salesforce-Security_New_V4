public with sharing class ConfigBusinessRuleTriggerHelper extends TriggerHelper {
    
    public override void  processBeforeInsert() {
        populateExpFields((List<LayoutBusinessRuleConfig__c >)Trigger.New);
    }
    
    public override void  processBeforeUpdate() {
        populateExpFields((List<LayoutBusinessRuleConfig__c >)Trigger.New);
    }
    
    private void populateExpFields(List<LayoutBusinessRuleConfig__c > layoutBizRule) {
    	for(LayoutBusinessRuleConfig__c lbr : layoutBizRule) {
    		if(String.isEmpty(lbr.Expression__c) == false ) {
	    		lbr.ExpressionJSONFields__c = ExpressionJSONEvaluator.getfieldNamesFromJSON(lbr.Expression__c);
    		} else {
    			lbr.ExpressionJSONFields__c = null;
    		}
    	}
    }
}