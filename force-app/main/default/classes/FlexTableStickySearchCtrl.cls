public with sharing class FlexTableStickySearchCtrl {

	@AuraEnabled
    public static void updateFlexTableListViewConfig(Id flexTableId, Id userId, String updatedHeaderLabel){
        List<SObject> listToBeUpdated = new List<Sobject>();
        List<SObject> listToBeDeleted = new List<Sobject>();
        Id updatedFlexTableFilterListViewConfig;
        List<FlexTableFilterListViewConfig__c> FlexTableFilterListViewConfigList = new List<FlexTableFilterListViewConfig__c>();
        if(Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
            FlexTableFilterListViewConfigList = [SELECT Id,Name,IsDefault__c,IsActive__c,Label__c FROM FlexTableFilterListViewConfig__c WHERE FlexTableConfig__c = :flexTableId AND IsActive__c = true WITH USER_MODE];
        }
        if(FlexTableFilterListViewConfigList.size() > 0){
            for(FlexTableFilterListViewConfig__c record : FlexTableFilterListViewConfigList){
                if(record.Label__c.equalsIgnoreCase(updatedHeaderLabel)){                    
                    updatedFlexTableFilterListViewConfig = record.Id;
                }
            }
        }

        List<FlexTableListViewUserConfig__c> FlexTableListViewUserConfigList = new List<FlexTableListViewUserConfig__c>();
        if(Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
            FlexTableListViewUserConfigList = [SELECT Id,Name,User__c,FlexTableListViewConfig__c,FlexTableConfig__c
                                                                                FROM FlexTableListViewUserConfig__c
                                                                                WHERE User__c = :userId AND FlexTableConfig__c = :flexTableId WITH USER_MODE FOR UPDATE];  
        }
        if(FlexTableListViewUserConfigList.size() > 0){
            for(FlexTableListViewUserConfig__c record : FlexTableListViewUserConfigList){
                if(updatedFlexTableFilterListViewConfig != null){
                    if(Schema.sObjectType.FlexTableListViewUserConfig__c.fields.FlexTableListViewConfig__c.isUpdateable()){
                        record.FlexTableListViewConfig__c = updatedFlexTableFilterListViewConfig;
                    }
                    if(Schema.sObjectType.FlexTableListViewUserConfig__c.fields.FlexTableConfig__c.isUpdateable()){
                        record.FlexTableConfig__c = flexTableId;
                    }
                    listToBeUpdated.add(record);
                }else{
                    listToBeDeleted.add(record);
                }                
            }
        }else{
            FlexTableListViewUserConfig__c record = new FlexTableListViewUserConfig__c();
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.fields.User__c.isCreateable()){
                record.User__c = userId;
            }
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.fields.FlexTableListViewConfig__c.isCreateable()){
                record.FlexTableListViewConfig__c = updatedFlexTableFilterListViewConfig;
            }
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.fields.FlexTableConfig__c.isCreateable()){
                record.FlexTableConfig__c = flexTableId;
            }
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.isCreateable() && Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
                insert as user record;
            }
        }

        if(listToBeUpdated.size() > 0){ 
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.isUpdateable()){
                update as user listToBeUpdated; //FLS/ CRUD False +ve used schema method to check isUpdateable
             }
        }
        /*if(listToBeDeleted.size() > 0){
            delete listToBeDeleted;
        }*/
    }
}