/**
    When an event is published, this trigger is invoked and it looks for
    the appropriate handler classes and executes them.

    @author Shah Kadirmohideen
*/
public with sharing class EventBusTriggerHelper extends TriggerHelper {

    public override void processAfterInsert() {
        handleEvent();
    }

    /* PRIVATE METHODS */

    private void handleEvent() {
        Map<String, Set<String>> eventMap = groupEvents();
        Map<String, String> handlerMap = new Map<String, String>(); //key->event name, value->handler class name
        if(EventSubscription__mdt.sObjectType.getDescribe().isAccessible()) {
            for (EventSubscription__mdt config: [Select DeveloperName, HandlerClass__c
            from EventSubscription__mdt where DeveloperName in :eventMap.keySet() WITH USER_MODE]) { 
                handlerMap.put(config.DeveloperName, config.HandlerClass__c);
            }
        }

        ErrorHandler errHandler = new ErrorHandler();

        for (String eventName : eventMap.keySet()) {
            Set<String> parentRecordIds = eventMap.get(eventName);
            String handlerClassName = handlerMap.get(eventName);
            handleEvent(eventName, parentRecordIds, handlerClassName, errHandler);
        }

        errHandler.persist();
    }

    private Map<String, Set<String>> groupEvents() {
        Map<String, Set<String>> eventMap = new Map<String, Set<String>>(); //key->event name, value->collection of record ids
        for (EventBus__e event : (List<EventBus__e>) Trigger.New) {
            if (event.ParentId__c != null) {
                Set<String> parentRecordIds = eventMap.get(event.EventName__c);
                if (parentRecordIds == null) {
                    parentRecordIds = new Set<String>();
                    eventMap.put(event.EventName__c, parentRecordIds);
                }
                parentRecordIds.add(event.ParentId__c);
            }
        }
        return eventMap;
    }

    private void handleEvent(String eventName, Set<String> parentRecordIds, String handlerClassName, ErrorHandler errHandler) {
        Savepoint snapshot = Database.setSavepoint();
        try {
            if (handlerClassName == null) {
                errHandler.add('Event handler class not defined in custom meta data type for event: ' + eventName, parentRecordIds);
                return;
            }
            Type classType = Type.forName(handlerClassName);
            PlatformEventHandler handler = (PlatformEventHandler) classType.newInstance();
            handler.handle(parentRecordIds);
        }
        catch (Exception e) {
            Database.rollback(snapshot);
            errHandler.add(e, parentRecordIds);
        }
    }

}