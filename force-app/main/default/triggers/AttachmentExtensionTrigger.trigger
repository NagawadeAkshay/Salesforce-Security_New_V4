trigger AttachmentExtensionTrigger on AttachmentExtension__c (before insert, before update) {
    new AttachmentExtensionTriggerHelper().process();
}