trigger ConfigCustomAppTrigger on CustomApp__c ( before insert, after insert, before update, after update, before delete) {  
    if(TestHelper.skipCustomAppTrigger == false){
    new ConfigCustomAppTriggerhelper().process();
    }
}