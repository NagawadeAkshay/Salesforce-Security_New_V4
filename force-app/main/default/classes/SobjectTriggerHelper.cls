public with sharing class SobjectTriggerHelper extends TriggerHelper{

    public override void processBeforeInsert() { 
        Map<String, Id> mapSobject = new Map<String, Id>();
        Set<String> setSobjectName = new Set<String>();
        for(SobjectConfig__c sobj :(list<SobjectConfig__c  >)trigger.new){
            sobj.Name = sobj.Name.deleteWhitespace();
            setSobjectName.add(sobj.Name.toLowerCase());
        } 
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()) {
            for(SobjectConfig__c sobj :[SELECT Id, Name FROM SobjectConfig__c   WHERE  Name IN :setSobjectName WITH USER_MODE]){
                mapSobject.put(sobj.Name.toLowerCase(), sobj.Id);
            }
        }
        for(SobjectConfig__c   sobj : (list<SobjectConfig__c  >) trigger.new){
             if(mapSobject.containsKey(sobj.Name.toLowerCase()) && mapSobject.get(sobj.Name.toLowerCase()) != sobj.Id){
                String sobjName = SFDCEncoder.SFDC_HTMLENCODE(sobj.Name);
                sobj.addError('There is already another sobject with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapSobject.get(sobjName)) + '\'>' + sobjName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
              }
        }
    } 
     public override void processBeforeUpdate() { 
        Map<String, Id> mapSobject = new Map<String, Id>();
        Set<String> setSobjectName = new Set<String>();
        for(SobjectConfig__c sobj :(list<SobjectConfig__c  >)trigger.new){
            sobj.Name = sobj.Name.deleteWhitespace();
            setSobjectName.add(sobj.Name.toLowerCase());
        }
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()) {
            for(SobjectConfig__c sobj :[SELECT Id, Name FROM SobjectConfig__c   WHERE  Name IN :setSobjectName WITH USER_MODE]){
                mapSobject.put(sobj.Name.toLowerCase(), sobj.Id);
            }
        }
        for(SobjectConfig__c   sobj : (list<SobjectConfig__c  >) trigger.new){
             if(mapSobject.containsKey(sobj.Name.toLowerCase()) && mapSobject.get(sobj.Name.toLowerCase()) != sobj.Id){
                String sobjName = SFDCEncoder.SFDC_HTMLENCODE(sobj.Name);
                sobj.addError('There is already another sobject with the same Name. ' + 'Refer: <a href=\'/' + SFDCEncoder.SFDC_HTMLENCODE(mapSobject.get(sobjName)) + '\'>' + sobjName + '</a>',FALSE);//NOPMD ApexXSSFromEscapeFalse - False +ve - Sanitized value on above line number - Used SFDCEncoder.SFDC_HTMLENCODE custom() for sanitization
              }
        }
    }
    
    public override void processAfterInsert() {
        syncDataToCache();
    } 

    public override void processAfterUpdate() {
        syncDataToCache();
    }

    public override void processBeforeDelete() {
        syncDataToCache();
    }
    
    private void syncDataToCache() {
        new DataSyncTriggerHelper(SObjectCache__c.getSObjectType()).process();
    } 

}