trigger ErrorMessageConfigTrigger on ErrorMessageConfig__c (before insert,before update) {
    new ErrorMessageConfigTriggerHelper().process();
}