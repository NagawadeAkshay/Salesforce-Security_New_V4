public with sharing class FlexGridUtility{
    public DataTableConfig__c getFieldNamesForBudgetGrid(DataTableConfig__c dataTableConfig){
       // String fields='';
       String fields= dataTableConfig.FieldNames__c == null ? '' : dataTableConfig.FieldNames__c + ',';
        
        String orderBy='';
        List<Object> fieldsMapList = new List<Object>();
        if(dataTableConfig.RowGroupingFieldsJSON__c != null){
            String rowGroupingFieldsJSON = dataTableConfig.RowGroupingFieldsJSON__c;
            fieldsMapList = (List<Object>)JSON.deserializeUntyped(rowGroupingFieldsJSON);
            for(Object fieldsMap :fieldsMapList){
                String str = JSON.serialize(fieldsMap);
                Map<String,String> sobj = (Map<String,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Map<String, String>.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                fields += sobj.get('field') + ', ';
                orderBy += sobj.get('field') + ', ';
                fields += sobj.get('column') + ', ';
            }
        }  
        
        if(dataTableConfig.ColumnGroupingFieldJSON__c != null){  
            String colGroupingFieldsJSON = dataTableConfig.ColumnGroupingFieldJSON__c;
            fieldsMapList = (List<Object>)JSON.deserializeUntyped(colGroupingFieldsJSON);
            for(Object fieldsMap :fieldsMapList){
                String str = JSON.serialize(fieldsMap);
                Map<String,String> sobj = (Map<String,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Map<String, String>.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                fields += sobj.get('field') + ', ';
                orderBy += sobj.get('field') + ', ';
                fields += sobj.get('column') + ', ';
            }
        }
        Set<String> queryFields = new Set<String>();
        if(dataTableConfig.budgetGridEditCondition__c != null){                  
            String budgetGridEditJSON = dataTableConfig.budgetGridEditCondition__c;
            if(budgetGridEditJSON != null){
                fieldsMapList = (List<Object>)JSON.deserializeUntyped(budgetGridEditJSON);
                for(Object fieldsMap :fieldsMapList){
                    String str = JSON.serialize(fieldsMap);
                    Map<String,String> sobj = (Map<String,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Map<String, String>.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                    queryFields.add(sobj.get('field'));                
                }
            }
        }
        if(dataTableConfig.HideColumnsText__c != null){   
            String hideColumnsJSON = dataTableConfig.HideColumnsText__c;
            if(hideColumnsJSON != null){
               fieldsMapList = (List<Object>)JSON.deserializeUntyped(hideColumnsJSON);
                for(Object fieldsMap :fieldsMapList){
                    String str = JSON.serialize(fieldsMap);
                    Map<String,String> sobj = (Map<String,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Map<String, String>.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                    queryFields.add(sobj.get('field'));                
                }
            }
        }
        
        if(dataTableConfig.budgetGridEditCondition__c != null || dataTableConfig.HideColumnsText__c != null){     
            for(String field: queryFields){
                fields += field + ', ';    
            }
            if (dataTableConfig.RecordType.Name == 'Budget Grid'){
                 fields += dataTableConfig.SummarizableField__c;
            }
                    
             fields = fields.removeEnd(', ');
             dataTableConfig.FieldNames__c = fields.removeEnd(', ');
             
        }
        
        
        if(dataTableConfig.RowGroupingFieldsJSON__c != null || dataTableConfig.ColumnGroupingFieldJSON__c != null){
            orderBy = orderBy.subString(0,orderBy.length()-2);
            dataTableConfig.OrderBy__c = orderBy;
            
        }
        
        
        //dataTableConfig.FieldNames__c = fields+  ',GGDemo2__Status__c';
        //dataTableConfig.FieldNames__c = fields;        
        return dataTableConfig;
        
    }
    /*
    Method  :   getGridType()
    Purpose :   This method gets the type of grid.
    */
   
    public Map<String,Object> getGridType(String flexGridConfigName,String keyValueMap,String listKeyValueMap,Boolean sforce1) {
        Map<String,Object> retVal = new Map<String,Object>();
        List<FlexGridConfig__c> flexGridConfigObjList = new List<FlexGridConfig__c>();
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible()){
            flexGridConfigObjList = [SELECT Id,Name,RecordTypeId,RecordType.Name FROM FlexGridConfig__c WHERE Name=:flexGridConfigName WITH USER_MODE LIMIT 1];
        }
        if(flexGridConfigObjList.size() > 0){
            FlexGridConfig__c flexGridConfig = flexGridConfigObjList[0];
            retVal.put('GridType',flexGridConfig.RecordType.Name);
            retVal.put('KeyValueMap',keyValueMap);
            retVal.put('ListKeyValueMap',listKeyValueMap);
        }
        return retVal;
    }
    
     public String getHidefield(DataTableConfig__c dataTableConfig){
        String fields= dataTableConfig.FieldNames__c == null ? '' : dataTableConfig.FieldNames__c + ',';
        Set<String> queryFields = new Set<String>();
        if(dataTableConfig.HideColumnsText__c != null){   
            String hideColumnsJSON = dataTableConfig.HideColumnsText__c;
            if(hideColumnsJSON != null){
               List<Object> fieldsMapList = (List<Object>)JSON.deserializeUntyped(hideColumnsJSON);
                for(Object fieldsMap :fieldsMapList){
                    String str = JSON.serialize(fieldsMap);
                    Map<String,String> sobj = (Map<String,String>)JSON.deserializeStrict(SFDCEncoder.sanitizeJSON(str),Map<String, String>.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                    queryFields.add(sobj.get('field'));                
                }              
            }
            for(String field: queryFields){
                fields += field + ', ';    
            }
            
            fields = fields.removeEnd(', ');       
            dataTableConfig.FieldNames__c = fields.removeEnd(', ');
            
        }
        
        return fields;
     }    
}