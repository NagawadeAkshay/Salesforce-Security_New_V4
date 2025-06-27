public with sharing class FlexTableListViewTriggerHelper extends TriggerHelper{  
    public Map<Id,Boolean> oneIsChecked = new Map<Id,Boolean>();
    public Boolean allAreUnchecked = false;  
    public Boolean updatingFlextableListViewConfig  = AppUtils.UPDATINGFLEXTABLECONFIG;
    public String namespace = AppUtils.getNamespacePrefix();
    public Map<Id,Sobject> listToBeUpdated = new Map<Id,Sobject>();
    public Map<Id,FlexTableFilterListViewConfig__c> oldMap;
    
    public override void processBeforeUpdate(){
        AppUtils.UPDATINGFLEXTABLELISTVIEWCONFIG = true;        
        if(!updatingFlextableListViewConfig){
            UpdateFlexTableListViewUser(Trigger.New);
             if(!Test.isRunningTest()){
                UpdateRelatedDefault(Trigger.New);
             }
        }        
        AppUtils.UPDATINGFLEXTABLELISTVIEWCONFIG = false;     
    }
    
    public override void processBeforeInsert(){
        AppUtils.UPDATINGFLEXTABLELISTVIEWCONFIG = true;        
        if(!updatingFlextableListViewConfig){
            if(!Test.isRunningTest()){
                UpdateRelatedDefault(Trigger.New);
             }
        }        
        AppUtils.UPDATINGFLEXTABLELISTVIEWCONFIG = false;    
    }     

    public override void processAfterInsert(){
         UpdateFlexTableCriteria(Trigger.New);
     }        
    
     public override void processAfterUpdate(){
         UpdateFlexTableCriteria(Trigger.New);
     }   
    

    private void UpdateFlexTableListViewUser(List<FlexTableFilterListViewConfig__c> newFlexTableListViewList){
        Set<Id> inactiveListViewConfig = new Set<Id>();
        //List<Sobject> listToBeUpdated = new List<Sobject>();

        for(FlexTableFilterListViewConfig__c record : newFlexTableListViewList){
            if(!record.IsActive__c){
                inactiveListViewConfig.add(record.Id);
            }
        }
	        List<FlexTableListViewUserConfig__c> listViewUserConfigRecordsToBeUpdated = new List<FlexTableListViewUserConfig__c>();
            if(Schema.sObjectType.FlexTableListViewUserConfig__c.isAccessible()){
                listViewUserConfigRecordsToBeUpdated = [SELECT Id,Name,FlexTableListViewConfig__c FROM FlexTableListViewUserConfig__c WHERE FlexTableListViewConfig__c IN :inactiveListViewConfig WITH USER_MODE];
            }
	        if(listViewUserConfigRecordsToBeUpdated.size() > 0 && Schema.sObjectType.FlexTableListViewUserConfig__c.fields.FlexTableListViewConfig__c.isUpdateable()){
	            for(FlexTableListViewUserConfig__c record  : listViewUserConfigRecordsToBeUpdated){
	                record.FlexTableListViewConfig__c = null;
	                listToBeUpdated.put(record.Id,record);
	            }
	        }

        if(listToBeUpdated.size() > 0 && Schema.SObjectType.FlexTableListViewUserConfig__c.isUpdateable()){
           update as user listToBeUpdated.values();
        }
    }

    private void UpdateFlexTableCriteria(List<FlexTableFilterListViewConfig__c> newFlexTableListViewList){

        Set<Id> setFlexTableIds = new Set<Id>();
        List<DataTableConfig__c> lstDataTableConfigToUpdate = new List<DataTableConfig__c>();
        for(FlexTableFilterListViewConfig__c objFilterListViewConfig : newFlexTableListViewList){
            setFlexTableIds.add(objFilterListViewConfig.FlexTableConfig__c);
        }

        if(!setFlexTableIds.isEmpty()){
            for(DataTableConfig__c objDataTableConfig : [SELECT Id, Header__c, FilterCriteria__c, (SELECT Id, Label__c, FilterClause__c FROM Flex_Table_Filter_List_View_Configs__r WHERE IsMasterView__c = true AND IsActive__c = true ORDER BY LastModifiedDate DESC LIMIT 1)
                                                        FROM DataTableConfig__c WHERE Id IN :setFlexTableIds WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(!objDataTableConfig.Flex_Table_Filter_List_View_Configs__r.isEmpty()){
                    FlexTableFilterListViewConfig__c objFilterListViewConfig = objDataTableConfig.Flex_Table_Filter_List_View_Configs__r[0];
                    if(Schema.SObjectType.DataTableConfig__c.fields.Header__c.isUpdateable()
                            && Schema.SObjectType.DataTableConfig__c.fields.FilterCriteria__c.isUpdateable()){

                    objDataTableConfig.Header__c = objFilterListViewConfig.Label__c;
                    objDataTableConfig.FilterCriteria__c = objFilterListViewConfig.FilterClause__c;
                    }

                    lstDataTableConfigToUpdate.add(objDataTableConfig);
                }
            }
        }

        if(!lstDataTableConfigToUpdate.isEmpty()){
            if(Schema.sObjectType.DataTableConfig__c.isUpdateable()){
            update as user lstDataTableConfigToUpdate;
        }
    }
    }
    
     private void UpdateRelatedDefault(List<FlexTableFilterListViewConfig__c> newFlexTableListViewList){
        List<id> flexTableIdList= new List<Id>();
        List<FlexTableFilterListViewConfig__c> listToBeUpdated = new List<FlexTableFilterListViewConfig__c>();
         
         for(FlexTableFilterListViewConfig__c record :newFlexTableListViewList)
         {
           if(record.IsDefault__c &&  record.IsActive__c)
           {
               if(!flexTableIdList.contains(record.FlexTableConfig__c))
               {
                   flexTableIdList.add(record.FlexTableConfig__c);
               }
               else
               {
                   //to avoid multiple list view of same flex table as default from back end
                   record.IsDefault__c= false;
               }
               
           }
         }
        List<FlexTableFilterListViewConfig__c> ExistingRecords;
		if(Trigger.newMap != null){
            ExistingRecords =  new List<FlexTableFilterListViewConfig__c>([SELECT IsActive__c, FlexTableConfig__c, IsMasterView__c, IsDefault__c, Id, Name FROM FlexTableFilterListViewConfig__c where  IsActive__c= true AND IsDefault__c= true AND FlexTableConfig__c IN :flexTableIdList AND Id NOT IN :Trigger.newMap.keySet() WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        } else {
            ExistingRecords =  new List<FlexTableFilterListViewConfig__c>([SELECT IsActive__c, FlexTableConfig__c, IsMasterView__c, IsDefault__c, Id, Name FROM FlexTableFilterListViewConfig__c where  IsActive__c= true AND IsDefault__c= true AND FlexTableConfig__c IN :flexTableIdList WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        }
         
		for(FlexTableFilterListViewConfig__c record :ExistingRecords)
         {
            if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.IsDefault__c.isCreateable()){
             record.IsDefault__c = false;
            }
             listToBeUpdated.add(record);
         }
        if(listToBeUpdated.size() > 0 && Schema.sObjectType.FlexTableFilterListViewConfig__c.isUpdateable()){
             update as user listToBeUpdated;
         }
     }
}