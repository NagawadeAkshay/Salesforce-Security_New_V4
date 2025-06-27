/*
**********************************************************
Audit History

**********************************************************
2017-11-3      Prajakta Gadhe            Created 
    Copy pagelayout field Object API Name to PageTemplate field SobjectName 
**********************************************************  
*/

public with sharing class ConfigPageTemplateTriggerHelper extends TriggerHelper {

    public override void processBeforeInsert() {
         performDelegateValidations();
         performValidation();   
    }
     
   
    public override void processBeforeUpdate() {
         performDelegateValidations();
         performValidation();
     
              
    }

    //We call this method in before inset and update context
    private void  performDelegateValidations() {
        List<String> viewLayoutIdList = new List<String>();
         for (PageTemplate__c pageTemplate :(List<PageTemplate__c >) Trigger.new){
           if(pageTemplate .ViewLayoutConfig__c != null){//here we get view layout id in list.
               viewLayoutIdList.add(pageTemplate .ViewLayoutConfig__c);
           }
        }
        //In this map we strore view layout id with respect to layout. We directly assign SOQL query to map in order to get map of id and object.
        Map<String,PageLayoutConfig__c> pageLayoutMap = new Map<String,PageLayoutConfig__c>([Select id,ObjectAPIName__c From PageLayoutConfig__c 
                    Where id in: viewLayoutIdList WITH USER_MODE]);
        List<PageTemplate__c > pageTemplateList = new  List<PageTemplate__c > ();
        for(PageTemplate__c pageTemplate :(List<PageTemplate__c >) Trigger.new){//We iterate on new list of from config
             if(pageLayoutMap.get(pageTemplate.ViewLayoutConfig__c) != null) {
                 pageTemplate.SObjectName__c = pageLayoutMap.get(pageTemplate.ViewLayoutConfig__c).ObjectAPIName__c ;//here we copy layout object name to pagetemplate sobject name.
             }
        }
    
    }

    //This method is used to validate if field defined on ParentObjectFieldAPI__c is valid and object API Name is valid
      private void  performValidation(){
           for(PageTemplate__c pageTemplate :(List<PageTemplate__c >) Trigger.new){
               //here we do describe call on object and get all fields of that object.
              if(Schema.getGlobalDescribe().get(pageTemplate.SObjectName__c) == null) {
                  pageTemplate.addError('Please Enter Valid SObjectName. recordId:' + pageTemplate.Id + ':InternalUniqueId:' + pageTemplate.InternalUniqueId__c);
              } else {
                  Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(pageTemplate.SObjectName__c).getDescribe().fields.getMap();// HERE all fields of task object are get to copy all data of original user to delegate user
                  //If field enter in ParentObjectFieldAPI is not present object then it will through validation
                if(pageTemplate.ParentObjectFieldAPI__c != null && !fieldMap.containsKey(pageTemplate.ParentObjectFieldAPI__c)){
                    pageTemplate.addError('Please Enter Valid ParentObjectFieldAPI Name. recordId:' + pageTemplate.Id + ':InternalUniqueId:' + pageTemplate.InternalUniqueId__c);
                }
              }
           } 
       }
}