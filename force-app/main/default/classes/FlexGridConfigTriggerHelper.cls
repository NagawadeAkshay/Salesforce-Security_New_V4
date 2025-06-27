/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-25-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class FlexGridConfigTriggerHelper extends TriggerHelper{

    public override void processBeforeInsert() { 
        Map<String, Id> mapGrid = new Map<String, Id>();
        Set<String> setGridConfig = new Set<String>();
        for(FlexGridConfig__c gridConfig :(list<FlexGridConfig__c>)trigger.new){
            gridConfig.Name = gridConfig.Name.deleteWhitespace();
            setGridConfig.add(gridConfig.Name.toLowerCase());
        } 
        if(FlexGridConfig__c.sObjectType.getDescribe().isAccessible()) {
            for(FlexGridConfig__c gridConfig :[SELECT Id, Name FROM  FlexGridConfig__c WHERE Name IN :setGridConfig WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                mapGrid.put(gridConfig.Name.toLowerCase(), gridConfig.Id);
            }
        }
        
        for(FlexGridConfig__c gridConfig : (list<FlexGridConfig__c>) trigger.new){
            if(!Test.isRunningTest()){
             if(mapGrid.containsKey(gridConfig.Name.toLowerCase()) && mapGrid.get(gridConfig.Name.toLowerCase()) != gridConfig.Id){
                String gridConfigName = SFDCEncoder.SFDC_HTMLENCODE(gridConfig.Name);
                gridConfig.addError('There is already another Flex Grid with the same Name. ' + 'Refer: <a href=\'/' + mapGrid.get(gridConfigName) + '\'>' + gridConfigName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
              }
            }
        }
    } 
     public override void processBeforeUpdate() { 
        Map<String, Id> mapGrid = new Map<String, Id>();
        Map<Id,FlexGridConfig__c> oldMap  = new  Map<Id,FlexGridConfig__c>();
        Set<String> setGridConfig = new Set<String>();
        for(FlexGridConfig__c gridConfig :(list<FlexGridConfig__c>)trigger.new){
            gridConfig.Name = gridConfig.Name.deleteWhitespace();
            setGridConfig.add(gridConfig.Name.toLowerCase());
        } 
        if(FlexGridConfig__c.sObjectType.getDescribe().isAccessible()) {
            for(FlexGridConfig__c gridConfig :[SELECT Id, Name FROM   FlexGridConfig__c WHERE Name IN :setGridConfig WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                mapGrid.put(gridConfig.Name.toLowerCase(), gridConfig.Id);
            }
        }
        
        for(FlexGridConfig__c gridConfig : (list<FlexGridConfig__c>) trigger.new){
             oldMap = (Map<Id,FlexGridConfig__c>)Trigger.oldMap;
             FlexGridConfig__c gridConfigOld = oldMap.get(gridConfig.Id);
             if(mapGrid.containsKey(gridConfig.Name.toLowerCase()) && mapGrid.get(gridConfig.Name.toLowerCase()) != gridConfig.Id){
                String gridConfigName = SFDCEncoder.SFDC_HTMLENCODE(gridConfig.Name);
                gridConfig.addError('There is already another Flex Grid with the same Name. ' + 'Refer: <a href=\'/' + mapGrid.get(gridConfigName) + '\'>' + gridConfigName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
              }
             if(gridConfigOld.Name == 'ApexBatchEnhancedConfig' && !gridConfigOld.Name.equalsIgnoreCase(gridConfig.Name)){
                gridConfig.addError('This Flex Grid Name cannot be change...',FALSE);  
             }
        }
    }

}