trigger ConfigPackageFormTrigger on PackageFormConfig__c  (before insert, before update) {
     new ConfigPackageFormTriggerHelper().process();
}