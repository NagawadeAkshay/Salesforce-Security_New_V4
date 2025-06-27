public with sharing class SobjectAutoSnapShotTriggerHelper extends TriggerHelper{

   
  // Insert Formula field sObject Name into text sobject config name
   public override void processBeforeInsert(){
        getSobjectFieldConfig();                 
   }
   
   // update Formula field sObject Name into text sobject config name
   public override void processBeforeUpdate(){
         getSobjectFieldConfig();      
   }
  
   public override void processAfterInsert() {
        syncDeleteOfSobjectAutoSnapCache();               
    } 

    public override void processAfterUpdate() {
        syncDeleteOfSobjectAutoSnapCache();         
    }

    public override void processBeforeDelete() {
       List<SObjectAutoSnapshot__c> delSobjAutoSnapList = new List<SObjectAutoSnapshot__c>();
        syncDataToCache(delSobjAutoSnapList);
    }
    
    
    /* Method :getSobjectFieldConfig
       Purpose : This Method to get formula field value of Sobject Field Id into Text Field
    */ 
    private void getSobjectFieldConfig(){
         for(SObjectAutoSnapshot__c sobjAutoSnap :(list<SObjectAutoSnapshot__c  >)trigger.new){
            if(String.isNotEmpty(sobjAutoSnap.sObjectFieldName__c)){
                sobjAutoSnap.SobjectFieldConfigName__c = sobjAutoSnap.sObjectFieldName__c;
            }
        }           
    }
    
    /* Method : synDeleteofSobjectAutoSnapCache
       Purpose : This Method to perform Sync and Delete of Sobject Auto Snap Cache
    */
    private void syncDeleteOfSobjectAutoSnapCache(){
        List<SObjectAutoSnapshot__c> updateActiveList = new List<SObjectAutoSnapshot__c>();
		List<SObjectAutoSnapshot__c> deleteSobjectList = new List<SObjectAutoSnapshot__c>(); 
        for(SObjectAutoSnapshot__c sobjAutoSnap :(list<SObjectAutoSnapshot__c  >)trigger.new){
            if(sobjAutoSnap.isActive__c){
                updateActiveList.add(sobjAutoSnap);
            }else{
                deleteSobjectList.add(sobjAutoSnap);                               
            }
        }
		if(updateActiveList.size() > 0) {
            syncAutoSnapCache(updateActiveList);
		}
        if(deleteSobjectList.size() > 0) {
			deleteSObjectAutoSnapCache(deleteSobjectList);
		}
                        
    }
    
    /* Method :syncDataToCache
       Purpose : This method is used for syncing Data of Custom Object Config with Custom Setting..
    */
    private void syncDataToCache(List<SObjectAutoSnapshot__c> sobjeAutoSnapList) {
        new DataSyncTriggerHelper(SObjectAutoSnapshotCache__c.getSObjectType(), sobjeAutoSnapList).process();
    }
    
    private void syncAutoSnapCache(List<SObjectAutoSnapshot__c> sobjeAutoSnapList){
        new SobjectAutoSnapCacheSyncTriggerHelper(sobjeAutoSnapList).process(); 
    }
    
    /* Method :deleteSObjectAutoSnapCache
       Purpose : This method is used for deleting Custom Setting auto snap data which is inactive ..
    */
    private void deleteSObjectAutoSnapCache(List<SObjectAutoSnapshot__c> deleteList){
       List<String> configNameList = new  List<String>();
       if(deleteList.size() > 0){
            for(SObjectAutoSnapshot__c sobjAutoSnap : deleteList){
               configNameList.add(sobjAutoSnap.Name);
           } 
           List<SObjectAutoSnapshotCache__c> deleteSobjectAutoSnapCacheList = new List<SObjectAutoSnapshotCache__c>();
           if(Schema.sObjectType.SObjectAutoSnapshotCache__c.isAccessible()) {
                deleteSobjectAutoSnapCacheList = [SELECT Id FROM SObjectAutoSnapshotCache__c WHERE Name IN :configNameList WITH USER_MODE]; 
           }
           if(deleteSobjectAutoSnapCacheList .size() > 0){
               if(SObjectAutoSnapshotCache__c.SObjectType.getDescribe().isAccessible() && SObjectAutoSnapshotCache__c.SObjectType.getDescribe().isDeletable())
               delete as user deleteSobjectAutoSnapCacheList; 
           }           
       }                           
    }
}