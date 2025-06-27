trigger TaskTrigger on Task (after delete, after insert, after update, before delete, before insert, before update) {
    new TaskTriggerHelper().process();
}