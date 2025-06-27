/**
**/
public with sharing class FlexTableTriggerHelper extends TriggerHelper{
    String ns = AppUtils.getNameSpacePrefix();   
    Boolean updatingFlextableListViewConfig  = AppUtils.UPDATINGFLEXTABLELISTVIEWCONFIG;
    public override void processBeforeInsert() {  
        Map<String, Id> mapFlexTable = new Map<String, Id>();
        Set<String> setFlexTableName = new Set<String>();
        validateFields((list<DataTableConfig__c>) trigger.new,setFlexTableName);        
        for(DataTableConfig__c dataTable :[SELECT Id, Name FROM   DataTableConfig__c WHERE  Name IN :setFlexTableName WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            mapFlexTable.put(dataTable.Name.toLowerCase(), dataTable.Id);
        }
        for(DataTableConfig__c dataTable : (list<DataTableConfig__c>) trigger.new){
            if(mapFlexTable.containsKey(dataTable.Name.toLowerCase()) && mapFlexTable.get(dataTable.Name.toLowerCase()) != dataTable.Id){
                String dataTableName = SFDCEncoder.SFDC_HTMLENCODE(dataTable.Name);
                dataTable.addError('There is already another flextable with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapFlexTable.get(dataTableName))+ '\'>' + dataTableName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
            }
        }
        //validateFieldAPIName(Trigger.New); 
         //CheckForHistoryFlexTable(Trigger.New);        
    }
   
     public override void processBeforeUpdate() { 
        Map<String, Id> mapFlexTable = new Map<String, Id>();
        Map<Id,DataTableConfig__c> oldMap  = new  Map<Id,DataTableConfig__c>();
        Set<String> setFlexTableName = new Set<String>();
        validateFields((list<DataTableConfig__c>) trigger.new,setFlexTableName);
        if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
            for(DataTableConfig__c dataTable :[SELECT Id, Name FROM   DataTableConfig__c WHERE  Name IN :setFlexTableName WITH USER_MODE]){
                mapFlexTable.put(dataTable.Name.toLowerCase(), dataTable.Id);
            }
        }
        for(DataTableConfig__c dataTable : (list<DataTableConfig__c>) trigger.new){
            oldMap = (Map<Id,DataTableConfig__c>)Trigger.oldMap;
            DataTableConfig__c tableConfigOld = oldMap.get(dataTable.Id);

            if(mapFlexTable.containsKey(dataTable.Name.toLowerCase()) && mapFlexTable.get(dataTable.Name.toLowerCase()) != dataTable.Id){
                String dataTableName = SFDCEncoder.SFDC_HTMLENCODE(dataTable.Name);
                dataTable.addError('There is already another flextable with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapFlexTable.get(dataTableName)) + '\'>' + dataTableName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
            }

            if(tableConfigOld.Name == 'ApexBatchEnhancedConfig' && !tableConfigOld.Name.equalsIgnoreCase(dataTable.Name)){
                dataTable.addError('This Flex Table Name cannot be change...',FALSE);
            }
        }
        //validateFieldAPIName(Trigger.New); 
         //CheckForHistoryFlexTable(Trigger.New);        
    }      
       /* if(!updatingFlextableListViewConfig){          
          CreateFlexTableListView(Trigger.New);             
        } else{
          CheckForHistoryFlexTable(Trigger.New);
        }*/
     
    
     public override void processAfterInsert(){                
          CreateFlexTableListView(Trigger.New);                    
     }

     public override void processBeforeDelete(){
          DeleteFlexTableDetails(Trigger.Old);
     }
    //Identifies the Duplicate Field between FieldNames__c and AdditionalColumns__c and returns Duplicate fields
    private String validateAdditionalColumns(String fieldNames, String additionalColumns){
        List<String> fieldNamesList = fieldNames.split(',',-1);
        String duplicateField = null;
        for(String fieldName:fieldNamesList){
            if(additionalColumns.contains(fieldName)){  
                duplicateField =  fieldName;   
                break;       
            }
        }       
    return duplicateField;
    }
    //validates the Display Field Names and Additional Columns if found duplicate field between them ,then it throws error.
    private void validateFields(List<DataTableConfig__c> dataTableConfig, Set<String> setFlexTableName){
        for(DataTableConfig__c dataTable :dataTableConfig){
            dataTable.Name = dataTable.Name.deleteWhitespace();
            if(dataTable.FieldNames__c != null){
                dataTable.FieldNames__c= dataTable.FieldNames__c.deleteWhitespace();
                dataTable.FieldNames__c= dataTable.FieldNames__c.replace('\n', ' ');
            }
            if(dataTable.AdditionalColumns__c != null){
                dataTable.AdditionalColumns__c = dataTable.AdditionalColumns__c.deleteWhitespace();
                dataTable.AdditionalColumns__c = dataTable.AdditionalColumns__c.replace('\n', ' ');
                String validate = validateAdditionalcolumns(dataTable.AdditionalColumns__c,dataTable.FieldNames__c);
                    if(validate != null){
                        List<String> addErrorList = new List<String>();
                        addErrorList.add(validate);
                        addErrorList.add(dataTable.Name);
                        addErrorList.add(dataTable.id);
                        addErrorList.add(dataTable.InternalUniqueID__c);
                        dataTable.addError(String.format(System.Label.TaskTriggerAdditionalFieldsError,addErrorList));
                    }
            }
            
            setFlexTableName.add(dataTable.Name.toLowerCase());
        }
    }
     
    private void  DeleteFlexTableDetails(List<DataTableConfig__c> flexTableList){
       List<Id> flexTableIdList = new List<Id>();
       for(DataTableConfig__c record : flexTableList){
          flexTableIdList.add(record.Id);
       }
       if(flexTableIdList.size() > 0){
           List<DataTableDetailConfig__c> flexTableDetailList = new List<DataTableDetailConfig__c>();
           if(Schema.sObjectType.DataTableDetailConfig__c.isAccessible()){
            flexTableDetailList = [SELECT Id FROM DataTableDetailConfig__c WHERE FlexTableConfig__c IN :flexTableIdList WITH USER_MODE];
           }
           if(Schema.sObjectType.DataTableDetailConfig__c.isDeletable())
                delete as user flexTableDetailList;
            }
    }
     
    private void CreateFlexTableListView(List<DataTableConfig__c> flexTableList) {
        List<FlexTableFilterListViewConfig__c> listToBeInserted = new List<FlexTableFilterListViewConfig__c>();
        List<Sobject> listToBeUpdated = new List<Sobject>();
        Map<Id,DataTableConfig__c> flexIdToRecordMap = new Map<Id,DataTableConfig__c>();
        Map<Id,Set<FlexTableFilterListViewConfig__c>> flexToListViewConfigMap = new Map<Id,Set<FlexTableFilterListViewConfig__c>>();
        List<Id> flexTableIdList = new List<Id>();
        for(DataTableConfig__c record : flexTableList){
          flexTableIdList.add(record.Id);
          flexIdToRecordMap.put(record.Id,record);
        }

        List<FlexTableFilterListViewConfig__c> existingListViewConfig = new List<FlexTableFilterListViewConfig__c>();
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.isAccessible()){
            existingListViewConfig = [SELECT Id,FilterClause__c,Label__c,IsActive__c,IsMasterView__c,IsDefault__c,FlexTableConfig__c 
                                                                            FROM FlexTableFilterListViewConfig__c
                                                                            WHERE IsMasterView__c = true AND FlexTableConfig__c IN :flexTableIdList WITH USER_MODE];
        }
        if(existingListViewConfig.size() >0){
          for(FlexTableFilterListViewConfig__c record : existingListViewConfig){
              Set<FlexTableFilterListViewConfig__c> relatedListViewSet = flexToListViewConfigMap.get(record.FlexTableConfig__c);
              if(relatedListViewSet == null){
                relatedListViewSet = new Set<FlexTableFilterListViewConfig__c>();
              }
              relatedListViewSet.add(record);
              flexToListViewConfigMap.put(record.FlexTableConfig__c,relatedListViewSet);
          }

          for(Id flexTableId : flexToListViewConfigMap.keySet()){
            Set<FlexTableFilterListViewConfig__c> listViewSet = flexToListViewConfigMap.get(flexTableId);
            DataTableConfig__c flexTableRecord = flexIdToRecordMap.get(flexTableId);
            if(listViewSet.size() > 0){
              for(FlexTableFilterListViewConfig__c record : listViewSet){ //update existing one
                record.FilterClause__c = flexTableRecord.FilterCriteria__c;
                record.Label__c = flexTableRecord.Header__c;
                listToBeUpdated.add(record);
              }
            }
          }
        }else{
              for(DataTableConfig__c flexTableRecord : flexTableList){
                FlexTableFilterListViewConfig__c flexTableListView = new FlexTableFilterListViewConfig__c(); //else create new one
                flexTableListView.Label__c = flexTableRecord.Header__c;
                flexTableListView.FilterClause__c = flexTableRecord.FilterCriteria__c;
                flexTableListView.IsMasterView__c = true;
                flexTableListView.FlexTableConfig__c = flexTableRecord.Id;
                flexTableListView.IsActive__c = true;
                listToBeInserted.add(flexTableListView);
              }              
        }                                                               
    }
}