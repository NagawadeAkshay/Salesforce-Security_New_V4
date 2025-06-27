/*
    All code for Trigger on Page Block Detail Config Object
    ************************************************************************
    Audit History
    ************************************************************************
    06/03/2014      Prem Pal             Created
    12/08/2014      Nishit Babaria       Added validateRecordFieldApiName() 
                                         to throw back an error to user if the 
                                         fieldname of pageBlockDetail entered 
                                         does not exist in the Object's list 
                                         of fieldAPI Names.
    ************************************************************************* 
*/
public with sharing class PageBlockDetailConfigTriggerHelper extends TriggerHelper{
    
    public override void processAfterInsert() {
        //checkDuplicateFields();                      
    }
    public override void processAfterUpdate() {
        //checkDuplicateFields();        
    } 

    public override void processBeforeUpdate() {

        List<String> pageBlockDetailIdsList = new List<String>();

        Map<String,String> pbdConfigMap = new Map<String,String>();
        List<PageBlockDetailConfig__c> pbdConfigList = new List<PageBlockDetailConfig__c>();

        for(PageBlockDetailConfig__c pbd : (List<PageBlockDetailConfig__c>)trigger.new){
                pageBlockDetailIdsList.add(pbd.Id);
        }
        if(Schema.sObjectType.PageBlockDetailConfig__c.isAccessible()){
        pbdConfigList = [SELECT PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c 
                        FROM PageBlockDetailConfig__c WHERE Id IN :pageBlockDetailIdsList WITH USER_MODE];
        }

        for(PageBlockDetailConfig__c pbd: pbdConfigList){
                pbdConfigMap.put(pbd.Id, pbd.PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c);
        } 

        for(PageBlockDetailConfig__c pbd :(List<PageBlockDetailConfig__c>)trigger.new){
            String mergeFields = '';
            String expJson = '';

            if(String.isNotEmpty(pbd.HideExpressionJSON__c)){
                expJson = pbd.HideExpressionJSON__c;
                mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);  
            }
            if(String.isNotEmpty(mergeFields)){
                if(ExpressionJSONEvaluator.hasSObjectField(mergeFields, pbdConfigMap.get(pbd.Id)) == true){
                    pbd.HideExpressionFields__c = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
                }   
            }

            String mergeFieldsReadOnly = '';
            String expJsonReadOnly = '';

            if(String.isNotEmpty(pbd.ReadOnlyExpressionJSON__c)){
                expJsonReadOnly = pbd.ReadOnlyExpressionJSON__c;
                mergeFieldsReadOnly = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJsonReadOnly);  
            }
            if(String.isNotEmpty(mergeFieldsReadOnly)){
                if(ExpressionJSONEvaluator.hasSObjectField(mergeFieldsReadOnly, pbdConfigMap.get(pbd.Id)) == true){
                    pbd.ReadOnlyExpressionFields__c = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJsonReadOnly);
                }   
            }
        }

    } 
}