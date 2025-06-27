public with sharing class SObjectAutoSnapshotExpBuilderctrl{
   
  public String FieldProviderSObject{get;set;}
  
   public SObjectAutoSnapshotExpBuilderctrl(ApexPages.StandardController stdController){
      Id sobjAutoSnapId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));
      SObjectAutoSnapshot__c sObjAutoSnap; 
      if(Schema.sObjectType.SObjectAutoSnapshot__c.isAccessible()){
      sObjAutoSnap = [SELECT SObject__r.Name FROM SObjectAutoSnapshot__c 
                                             WHERE Id =:sobjAutoSnapId WITH USER_MODE]; 
      }
      FieldProviderSObject = sObjAutoSnap.SObject__r.Name;                                            
   }
}