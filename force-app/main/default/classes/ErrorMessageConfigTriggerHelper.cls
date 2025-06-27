public with sharing class ErrorMessageConfigTriggerHelper extends TriggerHelper {
  
    public override void processBeforeInsert() {
        Set<Id> phaseIds = new set<Id>();
        Set<Id> customAppIds = new set<Id>();
        List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
        for(ErrorMessageConfig__c errorMessage: (List<ErrorMessageConfig__c>)trigger.new){
           if(!String.isEmpty(errorMessage.PhaseConfig__c)){
               phaseIds.add(errorMessage.phaseConfig__c);
           }
           if(!String.isEmpty(errorMessage.CustomAppConfig__c)){
               customAppIds.add(errorMessage.CustomAppConfig__c); 
           }
           if(String.isEmpty(errorMessage.ErrorCode__c)){
                errorMessages.add(errorMessage);
           }
        }
        if(errorMessages.size() > 0){
            generateUniqueName(errorMessages,phaseIds,customAppIds);    
        }

        checkForUniqueness();
    }
    public override void processBeforeUpdate() {
        checkForUniqueness();
    }
    private void generateUniqueName(List<ErrorMessageConfig__c> errorMessages,Set<Id> phaseIds,Set<Id>customAppIds){
        Map<Id,PhaseConfig__c> phases;
        Map<Id,CustomApp__c> apps;
        If(phaseIds.size() > 0){
            if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
           phases = new Map<Id,PhaseConfig__c>([select Id,Abbreviation__c from PhaseConfig__c  where id in:phaseIds WITH USER_MODE]);
            }
        }
        If(customAppIds.size() > 0){
            if(Schema.sObjectType.CustomApp__c.isAccessible()){
           apps = new Map<Id,CustomApp__c>([select Id,Abbreviation__c from CustomApp__c where id in:customAppIds WITH USER_MODE]);
            }
        }
        Set<String> names = new Set<String>();
        String phaseAbbr;
        for(ErrorMessageConfig__c errorMessage: errorMessages){
            String randomNumber =  generateRandomNumber();
            if(errorMessage.PhaseConfig__c != null && errorMessage.CustomAppConfig__c != null && errorMessage.ErrorCode__c==null) {
                errorMessage.ErrorCode__c = phases.get(errorMessage.PhaseConfig__c).Abbreviation__c + '-' +  apps.get(errorMessage.CustomAppConfig__c ).Abbreviation__c + '-' + randomNumber; 
            }
        }
    }
    
    private String generateRandomNumber(){
        Long key = crypto.getRandomLong();
        if(key>-10000 && key<1000)
            key = key+key+key+key+key+key+key+key+key+key+key+key+key+key;
        if(key>-1000 && key<1001)
            key = key+key+key+key+key+key+key+key;
        String pin = key+'';
        return pin.substring(1,6);
    }

    private void checkForUniqueness(){
        Set<String> errorNames = new Set<String>();
        Map<Id,ErrorMessageConfig__c> errorMessageMap = (Map<Id,ErrorMessageConfig__c>)trigger.oldMap;    
        Set<String> existingErrorNames = new Set<String>();
        for(ErrorMessageConfig__c errorMessage: (List<ErrorMessageConfig__c>) trigger.new){
                if(trigger.isInsert){
                    errorNames.add(errorMessage.ErrorCode__c); 
                }
                if(trigger.isUpdate){
                    if(errorMessageMap.get(errorMessage.id).ErrorCode__c!= errorMessage.ErrorCode__c){
                         errorNames.add(errorMessage.ErrorCode__c); 
                    }
                }
        }
        List<ErrorMessageConfig__c> errorMessages = new List<ErrorMessageConfig__c>();
        if(Schema.sObjectType.ErrorMessageConfig__c.isAccessible()){
            errorMessages = [select ErrorCode__c from ErrorMessageConfig__c where ErrorCode__c in: errorNames WITH USER_MODE];
        }
        if(errorMessages.size() != 0){
            for(ErrorMessageConfig__c errorMessage : errorMessages){
                   existingErrorNames.add(errorMessage.ErrorCode__c); 
            }

            for(ErrorMessageConfig__c errorMessage: (List<ErrorMessageConfig__c>) trigger.new){
                if(existingErrorNames.contains(errorMessage.ErrorCode__c)){
                    errorMessage.addError(Label.UniqueErrorCodeMessage);
                } 
            }
        }
    }
}