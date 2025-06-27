/*
    All trigger logic on Package Object
    **********************************************************
    Audit History
    **********************************************************
    2014-06-11      Kunal Shah              Created 
    2014-12-23      Nakul 	                Upadated updateStatus
    **********************************************************  
*/

public with sharing class PackageTriggerHelper extends TriggerHelper{
    
    public override void processBeforeUpdate(){
        updateVersion();
    }
    public override void processBeforeInsert(){
        //update Source
        if(UserPreferenceHelper.getStringValue('ActiveAppName__c') == 'StateAsGrantor'){
        	List<Package__c> packages = (List<Package__c>) Trigger.New;
        	for(Package__c p : packages){
        		p.Source__c = 'State';
        	}
        }
    }
    
    /* METHOD TO UPDATE THE LATESTVERSION AND VERSION NUMBER ON A PACKAGE */
    private void updateVersion(){
        if(Trigger.New.Size() > 1){
            return;
        }
        
        Package__c oldPackageInstance = (Package__c) Trigger.Old.get(0);
        Package__c newPackageInstance = (Package__c) Trigger.New.get(0);
        List<Package__c> packages =  new List<Package__c> ();
        
        if( newPackageInstance.SubmissionType__c == null ) {
        	throw new CustomExceptions.InputDataException('Please specify Submission type.');
        }
        
    }

}