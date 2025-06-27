public with sharing class DataCopyConfigTriggerHelper extends TriggerHelper{
    public override void processBeforeInsert() {    	
        verifyDuplicateTargetFieldName('BeforeInsert');
    }
    public override void processBeforeUpdate() {
        verifyDuplicateTargetFieldName('BeforeUpdate');
    }

    public static void verifyDuplicateTargetFieldName(String context) {        
        Map<String,Set<String>> sourceDestinationTargetField = new Map<String,Set<String>>();
        Set<String> srcObjSet = new Set<String>();
        Set<String> tarObjSet = new Set<String>();
        Map<String,Set<String>> srcDestTargetField = new Map<String,Set<String>>();
        for(RecordCopyConfig__c rccc : (List<RecordCopyConfig__c>) Trigger.new) {
            srcObjSet.add(rccc.SourceObjectName__c);
            tarObjSet.add(rccc.TargetObjectName__c);
        }
        List<RecordCopyConfig__c> dataCopyRecords = new List<RecordCopyConfig__c>([SELECT Id,SourceObjectName__c,TargetObjectName__c, 
                                                                            SourceFieldName__c,TargetFieldName__c 
                                                                            FROM RecordCopyConfig__c 
                                                                            WHERE SourceObjectName__c 
                                                                            in : srcObjSet 
                                                                            AND TargetObjectName__c in : tarObjSet WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Set<String> targetFields = new Set<String>();
        Set<String> comboSet = new Set<String>();
        Set<Id> ids = new Set<Id>();
        for(RecordCopyConfig__c rc : dataCopyRecords) {
            String combination = rc.SourceObjectName__c + rc.TargetObjectName__c;
            comboSet.add(combination);
            ids.add(rc.Id);
        }

        for(String comb : comboSet) {
            Set<String> targetFieldNameSet = new Set<String>();
            for(RecordCopyConfig__c rc1 : dataCopyRecords) {
                if(rc1.SourceObjectName__c + rc1.TargetObjectName__c == comb) {
                    targetFieldNameSet.add(rc1.TargetFieldName__c);
                }
            }
            sourceDestinationTargetField.put(comb,targetFieldNameSet);
        }

        for(RecordCopyConfig__c rcc : (List<RecordCopyConfig__c>) Trigger.new) {
             String combo = rcc.SourceObjectName__c + rcc.TargetObjectName__c;
             Set<String> checkDuplicateTarget = sourceDestinationTargetField.get(combo);             
             if(checkDuplicateTarget != null) {
                if(context.equals('BeforeInsert')) {
                     if(checkDuplicateTarget.contains(rcc.TargetFieldName__c)) {
                        rcc.addError('Another TargetField of same name exists');
                    }
                    else {
                        checkDuplicateTarget.add(rcc.TargetFieldName__c);
                    }
                    sourceDestinationTargetField.put(combo,checkDuplicateTarget);
                }
                else if(context.equals('BeforeUpdate')) {                    
                    if(checkDuplicateTarget.contains(rcc.TargetFieldName__c) && ids.contains(rcc.Id) != true) {
                        rcc.addError('Another TargetField of same name exists');
                    }
                    else {
                        checkDuplicateTarget.add(rcc.TargetFieldName__c);
                    }
                    sourceDestinationTargetField.put(combo,checkDuplicateTarget);
                }
               
             }
             else {
                Set<String> newTargetFields = new Set<String>();
                newTargetFields.add(rcc.TargetFieldName__c);
                sourceDestinationTargetField.put(combo,newTargetFields);
             }
        }
    }    
}