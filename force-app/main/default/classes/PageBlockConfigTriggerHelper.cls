public with sharing class PageBlockConfigTriggerHelper extends TriggerHelper{

    public override void processBeforeInsert() {   
        populateFlexTableForHistoryPageBlock(Trigger.New);               
    }
    public override void processBeforeUpdate() { 
    populateFlexTableForHistoryPageBlock(Trigger.New);
    populateHideExpFields(Trigger.New);   
    }  
    
    private void populateFlexTableForHistoryPageBlock(List<PageBlockConfig__c> pageBlockList){
        Id historyTableId = null;
        List<DataTableConfig__c> flexTableList = new List<DataTableConfig__c>();
        if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
            flexTableList = [Select id,Name From DataTableConfig__c Where Name='History' WITH USER_MODE limit 1];
        }
        if (flexTableList.size() == 0) {
            historyTableId = createHistoryTable();
        }
        else {
            historyTableId = flexTableList.get(0).Id;
        }

        Id fieldHistoryRecTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Field History').getRecordTypeId();
        for(PageBlockConfig__c pb:pageBlockList){
            if(pb.RecordTypeId == fieldHistoryRecTypeId && pb.FlexTableName__c == null){
                pb.FlexTableName__c = historyTableId;
            }
        }
    }

    private Id createHistoryTable() {
        String filterCriteria = 'ParentId= \'{!parentid}\' AND Field NOT IN (\'created\',\'feedEvent\',\'ownerAccepted\',\'ownerAssignment\',\'locked\',\'unlocked\')';
        DataTableConfig__c historyFlexTable = new DataTableConfig__c(); 
        if(Schema.sObjectType.DataTableConfig__c.fields.Name.isCreateable()){
            historyFlexTable.Name = 'History';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.RecordTypeId.isCreateable()){
            historyFlexTable.RecordTypeId = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Data Table').getRecordTypeId();
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.SObject__c.isCreateable()){
            historyFlexTable.SObject__c = 'History';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.FieldNames__c.isCreateable()){
            historyFlexTable.FieldNames__c = 'Field,NewValue,OldValue,CreatedById,CreatedDate';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.FilterCriteria__c.isCreateable()){
            historyFlexTable.FilterCriteria__c = filterCriteria;
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.OrderBy__c.isCreateable()){
            historyFlexTable.OrderBy__c = 'CreatedDate';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Sort_Direction__c.isCreateable()){
            historyFlexTable.Sort_Direction__c ='Desc';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Header__c.isCreateable()){
            historyFlexTable.Header__c = 'Field History';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.EnablePagination__c.isCreateable()){
            historyFlexTable.EnablePagination__c = true; 
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.EnablePageSize__c.isCreateable()){
            historyFlexTable.EnablePageSize__c = true; 
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Description__c.isCreateable()){
            historyFlexTable.Description__c = 'Generic history flex table';
        }
        if(Schema.sObjectType.DataTableConfig__c.isCreateable()){
            insert as user historyFlexTable;
        }

        return historyFlexTable.Id;
    }

    /*
        Method for extracting the fields from hide expression JSON, and populating the list
        of fields into HideExpressionFields__c
    */
    private void populateHideExpFields(List<PageBlockConfig__c> pageBlockList)
    {
        List<String> pageBlockIdsList = new List<String>();

        Map<String,String> pbConfigMap = new Map<String,String>();
        List<PageBlockConfig__c> pbConfigList = new List<PageBlockConfig__c>();

        for(PageBlockConfig__c pb : pageBlockList){
                pageBlockIdsList.add(pb.Id);
        }
        if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
        pbConfigList = [SELECT TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c 
                        FROM PageBlockConfig__c WHERE Id IN :pageBlockIdsList WITH USER_MODE];
        }

        for(PageBlockConfig__c pb : pbConfigList){
                pbConfigMap.put(pb.Id, pb.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c);
        } 

        for(PageBlockConfig__c pb : pageBlockList){
            String mergeFields= '';
            String expJson = '';
            if(String.isNotEmpty(pb.HideExpressionJSON__c)){
                expJson = pb.HideExpressionJSON__c;
                mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
            }
            if(String.isNotEmpty(mergeFields)){
                if(ExpressionJSONEvaluator.hasSObjectField(mergeFields, pbConfigMap.get(pb.Id)) == true){
                    pb.HideExpressionFields__c = ExpressionJSONEvaluator.getfieldNamesFromJSON(expJson);
                }   
            }
        }
    }
}