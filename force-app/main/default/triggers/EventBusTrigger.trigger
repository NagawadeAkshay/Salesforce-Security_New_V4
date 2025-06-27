/**
    For each event that is logged in this object, it looks for a corresponding subscription
    from EventSubscription__e object and invokes the corresponding handler class.
    If no matching handler class is found, it sends error notification to system admin.

    @author Shah Kadirmohideen
*/
trigger EventBusTrigger on EventBus__e (after insert) {
    new EventBusTriggerHelper().process();    
}