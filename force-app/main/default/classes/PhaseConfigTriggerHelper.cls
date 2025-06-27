/*
    All trigger logic on PhaseConfig__c object
    **********************************************************
    Audit History
    **********************************************************
    4/21/2013        Vinayak Sharma     Created
    **********************************************************  
*/
global with sharing class PhaseConfigTriggerHelper extends TriggerHelper{
    //deprecated
    global Boolean skipTrigger;
    global static Boolean skipTrigger;
    
    public override void processAfterInsert() {
        syncDataToCache();
    } 

    public override void processAfterUpdate() {
        syncDataToCache();
    }

    public override void processBeforeDelete() {
        syncDataToCache();
    }
     public override void processBeforeInsert() { 
        Map<String, Id> mapPhase = new Map<String, Id>();
        Set<String> setPhaseName = new Set<String>();
        for(PhaseConfig__c phase :(list<PhaseConfig__c>)trigger.new){
            phase.Name = phase.Name.deleteWhitespace();
            setPhaseName.add(phase.Name);
        }
        // Populates Custom App Value
            populateCustomAppName();
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()) {
            for(PhaseConfig__c phase :[SELECT Id, Name FROM   PhaseConfig__c WHERE  Name IN :setPhaseName WITH USER_MODE]){
                mapPhase.put(phase.Name, phase.Id);
            }
        }
        for(PhaseConfig__c phase : (list<PhaseConfig__c>) trigger.new){
             if(mapPhase.containsKey(phase.Name) && mapPhase.get(phase.Name) != phase.Id){
                String phaseName = SFDCEncoder.SFDC_HTMLENCODE(phase.Name);
                phase.addError('There is already another Phase Config with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapPhase.get(phaseName)) + '\'>' + phaseName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
              }
        }
    } 
    public override void processBeforeUpdate() { 
        Map<String, Id> mapPhase = new Map<String, Id>();
        Set<String> setPhaseName = new Set<String>();
        for(PhaseConfig__c phase :(list<PhaseConfig__c>)trigger.new){
            phase.Name = phase.Name.deleteWhitespace();
            setPhaseName.add(phase.Name);
        } 
       // Populate Custom App Value
          populateCustomAppName();
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()) {
            for(PhaseConfig__c phase :[SELECT Id, Name FROM   PhaseConfig__c WHERE  Name IN :setPhaseName WITH USER_MODE]){
                mapPhase.put(phase.Name, phase.Id);
            }
        }
        for(PhaseConfig__c phase : (list<PhaseConfig__c>) trigger.new){
             if(mapPhase.containsKey(phase.Name) && mapPhase.get(phase.Name) != phase.Id){
                String phaseName = SFDCEncoder.SFDC_HTMLENCODE(phase.Name);
                phase.addError('There is already another  Phase config  with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapPhase.get(phaseName)) + '\'>' + phaseName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
              }
        }
    }
    private void syncDataToCache() {
        new DataSyncTriggerHelper(CustomAppPhaseConfig__c.getSObjectType()).process();
    } 
    
    // Assign value of CustomAppName to CustomApp lookup config or Vice Versa.
    private void populateCustomAppName(){
        Map<Id, CustomApp__c> customAppMapByIds = new Map<Id, CustomApp__c>();
        Map<String, CustomApp__c> customAppMapByName = new Map<String, CustomApp__c>();
        
        // In This Query we assume there cannot be Custom App more than 100
        if(Schema.sObjectType.CustomApp__c.isAccessible()) {
            for(CustomApp__c custapp : [SELECT Id, Name FROM CustomApp__c WITH USER_MODE Limit 100]){
                customAppMapByIds.put(custapp.Id, custapp);
                customAppMapByName.put(custapp.Name, custapp);
            }
        }
        
        for(PhaseConfig__c phase :(list<PhaseConfig__c>)trigger.new){
            if(!String.isEmpty(phase.CustomAppConfig__c)){
               phase.CustomAppName__c = customAppMapByIds.get(phase.CustomAppConfig__c).Name;   
            }
            if(String.isEmpty(phase.CustomAppConfig__c)){
                if(!String.isEmpty(phase.CustomAppName__c) && customAppMapByName.containsKey(phase.CustomAppName__c)){
                    phase.CustomAppConfig__c= customAppMapByName.get(phase.CustomAppName__c).Id;
                }
                else{
                    phase.addError('Custom App Name does not exits in Custom App Config - Record Id:' +phase.Id +'    '+' - Record Internal UniqueId:' +phase.InternalUniqueID__c +'    '+' - Record Name:' +phase.Name+'   '+'-Custom App Name: '+phase.CustomAppName__c);
                }
            }
            
          }   
    }
}