public with sharing class SampleObjectTriggerHelper extends TriggerHelper {
    public override void processBeforeInsert() {
        NameTemplateTriggerHelper.beforeInsert();
    }
}