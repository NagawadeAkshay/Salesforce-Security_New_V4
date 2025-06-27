public with sharing class SobjectActionTriggerHelper extends TriggerHelper{


    public override void processBeforeInsert() { 
        Map<String, Set<String>> mapSobject1 = new Map<String, Set<String>>();
        Set<String> setSobjectActionName = new Set<String>();
        Set<String> setSobjectName = new Set<String>();
        
        for(SobjectActionConfig__c sobjAction :(list<SobjectActionConfig__c>)trigger.new){
            sobjAction.Name = sobjAction.Name.deleteWhitespace();
            setSobjectActionName .add(sobjAction.Name);

            checkHideFields(sobjAction);
            if(sobjAction.SobjectConfig__c!=null){
                setSobjectName.add(sobjAction.SobjectConfig__c);
            }
        } 
        if(Schema.sObjectType.SobjectActionConfig__c.isAccessible()) {
            for(SobjectActionConfig__c sobjAction :[SELECT Id, Name,SobjectConfig__c FROM  SobjectActionConfig__c 
                                                    WHERE Name IN :setSobjectActionName 
                                                    AND SobjectConfig__c IN:setSobjectName WITH USER_MODE]){
                
                if( mapSobject1.get(sobjAction .SobjectConfig__c) == null) {
                    mapSobject1.put(sobjAction .SobjectConfig__c, new Set<String>());    
                }
                mapSobject1.get(sobjAction .SobjectConfig__c).add(sobjAction .Name);
            }
        }
        for(SobjectActionConfig__c sobjAction : (list<SobjectActionConfig__c>) trigger.new){
                if(mapSobject1.get(sobjAction .SobjectConfig__c) != null && mapSobject1.get(sobjAction.SobjectConfig__c).contains(sobjAction.Name)){
                sobjAction.addError('There is already another Sobject Action  with the same Name. ',FALSE);
                  }
        }
    }  
    public override void processBeforeUpdate() { 
        
        Map<String, Map<String,id>> mapSobject1 = new  Map<String, Map<String,id>> ();
        Map<String,String> sObjectNameMap = new Map<String,String>(); 
        Set<String> setSobjectActionName = new Set<String>();
        Set<String> setSobjectName = new Set<String>();

        for(SobjectActionConfig__c sobjAction :(list<SobjectActionConfig__c>)trigger.new){
            sobjAction .Name = sobjAction .Name.deleteWhitespace();
            checkHideFields(sobjAction);
            setSobjectActionName .add(sobjAction .Name);
            if(sobjAction.SobjectConfig__c!=null){
                setSobjectName.add(sobjAction.SobjectConfig__c);
            }
        } 
        if(Schema.sObjectType.SobjectActionConfig__c.isAccessible()) {
            for(SobjectActionConfig__c sobjAction :[SELECT Id, Name,SobjectConfig__c,SobjectConfig__r.Name,HideExpressionJSON__c,HideExpressionFields__c 
                                                    FROM SobjectActionConfig__c 
                                                    WHERE Name IN :setSobjectActionName 
                                                    AND SobjectConfig__c IN:setSobjectName WITH USER_MODE]){
                sObjectNameMap.put(sobjAction.Id,sobjAction.SobjectConfig__r.Name);
                if( mapSobject1.get(sobjAction.SobjectConfig__c) == null) {
                    mapSobject1.put(sobjAction.SobjectConfig__c, new Map<String,id>()); 
                }
                mapSobject1.get(sobjAction.SobjectConfig__c).put(sobjAction.Name,sobjAction .Id);
            }
        }
        for(SobjectActionConfig__c sobjAction : (list<SobjectActionConfig__c>) trigger.new){
            if(mapSobject1.get(sobjAction.SobjectConfig__c) != null && mapSobject1.get(sobjAction.SobjectConfig__c).containsKey(sobjAction.Name) &&  mapSobject1.get(sobjAction.SobjectConfig__c).get(sobjAction.Name) != sobjAction.Id){
                 sobjAction.addError('There is already another Sobject Action  with the same Name. ',FALSE);
            }
        }
        checkHideExpressionJSONFields(sObjectNameMap);
    }

    private void checkHideExpressionJSONFields(Map<String,String> sObjectNameMap){
        String mergeFields = '';
        for(SobjectActionConfig__c sobjAction:(list<SobjectActionConfig__c>)trigger.new){
            if(String.isNotEmpty(sobjAction.HideExpressionJSON__c)){
                mergeFields =ExpressionJSONEvaluator.getfieldNamesFromJSON(sobjAction.HideExpressionJSON__c);
                if(!String.isEmpty(mergeFields)){
                    if(ExpressionJSONEvaluator.hasSObjectField(mergeFields,sObjectNameMap.get(sobjAction.Id)) == true){
                        sobjAction.HideExpressionFields__c = mergeFields;
                    }   
                }

            } 
            if(String.isEmpty(sobjAction.HideExpressionJSON__c)){
                sobjAction.HideExpressionFields__c = '';
            } 
        }
    }

    private void checkHideFields(SobjectActionConfig__c sobjAction){
        if((sobjAction.HideForProfile__c == null && sobjAction.HideForProfile1__c == null && sobjAction.HideForContext__c == null && sobjAction.HideForRole__c == null && sobjAction.HideForUser__c == null)){
            sobjAction.HideOperator__c = 'AND';
        }
    }       
}