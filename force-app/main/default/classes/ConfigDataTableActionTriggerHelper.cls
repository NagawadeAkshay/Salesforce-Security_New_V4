/*
    Trigger Helper 
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review, Flex table action is controlled 
    by parent ie.Flex table which is and Page message is public read only
    ****************************************************************************************
*/
public with sharing class ConfigDataTableActionTriggerHelper extends TriggerHelper {
    Id dataTableId = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('FlexGrid Enhanced Action').getRecordTypeId(); 
    public override void processBeforeInsert() { 
        for(DataTableAction__c dataTableAction :(list<DataTableAction__c>)trigger.new){
            if(validate(dataTableAction)){
                checkHideFields(dataTableAction);
            }
        }
    }
    public override void processBeforeUpdate() { 
        for(DataTableAction__c dataTableAction :(list<DataTableAction__c >)trigger.new){
            if(validate(dataTableAction)){
                checkHideFields(dataTableAction);
            }
        }
        
        List<String> actionIdsList = new List<String>();
        Map<String,String> tabConfigMap = new Map<String,String>();
        List<DataTableAction__c> dataTableActionList = new List<DataTableAction__c>();
        for(DataTableAction__c tab:(list<DataTableAction__c>)trigger.new){
            actionIdsList.add(tab.Id);
        } 
        if(Schema.sObjectType.DataTableAction__c.isAccessible()){
            dataTableActionList = [SELECT Id, Name, HideExpressionJSON__c, DataTableConfig__r.SObject__c, HideExpressionFields__c FROM DataTableAction__c where Id IN :actionIdsList WITH USER_MODE];
        }
        for(DataTableAction__c tab: dataTableActionList){
            tabConfigMap.put(tab.Id,tab.DataTableConfig__r.SObject__c);
        } 
        for(DataTableAction__c tab :(list<DataTableAction__c>)trigger.new){
            String expJson = '';
            if(!String.isEmpty(tab.HideExpressionJSON__c)){
                String mergeFields= '';
                expJson = tab.HideExpressionJSON__c;
                mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
                String alternateSobjectName = '';
                try {
                    Map<String,Object> jsonParsed = (Map<String,Object>)Json.deserializeUntyped(expJson);
                    if(jsonParsed.get('ExpressionObject') != null) {
                        alternateSobjectName = String.valueOf(jsonParsed.get('ExpressionObject'));
                    }
                } catch(Exception ex) { 
                }
                
                if(!String.isEmpty(mergeFields)){
                    if(ExpressionJSONEvaluator.hasSObjectField(mergeFields,tabConfigMap.get(tab.Id)) == true){
                        tab.HideExpressionFields__c = mergeFields;
                    } else if(String.isNotEmpty(alternateSobjectName) && (ExpressionJSONEvaluator.hasSObjectField(mergeFields,alternateSobjectName) == true)) {
                        tab.HideExpressionFields__c = mergeFields;
                    }   
                } 
            }
            if(String.isEmpty(tab.HideExpressionJSON__c)){
                tab.HideExpressionFields__c = '';     
            }
        }
    }
    
    private void checkHideFields(DataTableAction__c dataTableAction){
        if((dataTableAction.HideForProfile__c == null && dataTableAction.HideForRole__c == null && dataTableAction.HideForUser__c == null)){
            dataTableAction.HideOperator__c = 'AND';
        }
    }
    
    private Boolean validate(DataTableAction__c dataTableDetail){
        Boolean result = true;
        
        if(dataTableDetail.RecordTypeId == dataTableId){
            String internalUniqueId  = ' : InternalUniqueId : '+dataTableDetail.InternalUniqueID__c + ' : FlexTabeId : '+ dataTableDetail.DataTableConfig__c;
            if(dataTableDetail.Location__c == null){
                dataTableDetail.addError(' Select the Location '+ internalUniqueId);
                result = false;
            }
            if(dataTableDetail.ShowConfirmationBox__c == true && dataTableDetail.ConfirmationMessage__c == null){
                dataTableDetail.addError(' Enter Confirmation message '+ internalUniqueId);
                result = false;
            }
            if(dataTableDetail.ActionBehavior__c == 'OpenURL' && (dataTableDetail.ActionURLLong__c == null && dataTableDetail.ActionURLLongLWC__c == null)){
                dataTableDetail.addError(' Enter Action URL Long or Action URL Long LWC'+ internalUniqueId);
                result = false;
            }
            if(dataTableDetail.ActionBehavior__c == 'ExecuteClass' && dataTableDetail.ActionClass__c == null){
                dataTableDetail.addError(' Enter Action Class'+ internalUniqueId);
                result = false;
            }
            if(dataTableDetail.ActionBehavior__c == 'EditRecord' && dataTableDetail.SingleRowEditBehavior__c == null){
                dataTableDetail.addError(' Select Single Row Edit Behavior'+ internalUniqueId);
                result = false;
            }
            if(dataTableDetail.ActionBehavior__c == 'EditRecord' && dataTableDetail.Location__c == 'Top'){
                dataTableDetail.addError(' Select Location as Row'+ internalUniqueId);
                result = false;
            }
            if(dataTableDetail.ActionBehavior__c == 'EditMultipleRecords' && dataTableDetail.Location__c != 'Top'){
                dataTableDetail.addError(' Enter Confirmation message '+ internalUniqueId);
                result = false;
            }
        }
        return result;
    }
}