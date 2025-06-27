trigger PhaseConfigTrigger on PhaseConfig__c (before insert, after insert, before update, after update, before delete) {
   if(!AppUtils.skipPhaseConfigTrigger) { 
        new PhaseConfigTriggerHelper().process();
    }
}