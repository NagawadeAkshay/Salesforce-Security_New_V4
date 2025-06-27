/**
    Handles platform event publishing using convenient methods. 
    It allows batch size to group a set of record ids for efficient processing.
    If the eventName doesn't present in Event Subscription custom metadata type, 
    then it throws exception.

    Example Usage1 (single record publishing):
        new EventPublisher('Application Approved').recordId(application.Id).publish();

    Example Usage2 (multiple records publishing):
        EventPublisher publisher = new EventPublisher('Application Approved').batchSize(20);
        for (Application__c application : applications) {
            publisher.recordId(application.Id);
        }
        publisher.publish();
    
    @author Shah Kadirmohideen
*/
public with sharing class EventPublisher {
    private String eventName;
    private List<Id> recordIds = new List<Id>();
    private Integer batchSize = 10; //default batch size

    public EventPublisher(String eventName) {
        this.eventName = eventName;
        validateEvent();
    }

    public EventPublisher recordId(Id recordId) {
        if (recordIds.contains(recordId) == false) {
            recordIds.add(recordId);
        }
        return this;
    }

    public EventPublisher batchSize(Integer size) {
        this.batchSize = size;
        return this;
    }

    public void publish() {
        List<EventBus__e> events = new List<EventBus__e>();
        ListIterator it = new ListIterator(recordIds, batchSize);
        Integer i=0;
        while (it.hasNext()) {
            events.add(new EventBus__e(EventName__c = eventName, ParentIds__c = JSON.serialize(it.next()),ParentId__c=recordIds[i] !=null?recordIds[i]:''));
            i++;
        }

        if (events.size() > 0) {
            List<Database.SaveResult> results = EventBus.publish(events);
            validateSaveResult(results);
        }
    }

    /* PRIVATE METHODS */

    private void validateEvent() {
        Boolean eventPresent = [Select count() from EventSubscription__mdt where DeveloperName=:eventName WITH USER_MODE] == 1; 
        if (eventPresent == false && !Test.isRunningTest()) {
            throw new CustomExceptions.InputDataException('Event name \'' + eventName + '\' is not defined in EventSubscription__mdt');
        }
    }

    private void validateSaveResult(List<Database.SaveResult> results) {
        List<String> errors = new List<String>();
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {

            } else {
                for(Database.Error err : sr.getErrors()) {
                    errors.add(err.getStatusCode() + ': ' + err.getMessage());
                }
            }       
        }            

        if (errors.isEmpty() == false) {
            throw new CustomExceptions.InputDataException(concatenate(errors, ', '));
        }
    }
    
    public static String concatenate(String[] arr, String sep) {
        String result = '';
        if (arr == null) return result;
        Integer i = 1;
        for (String ele : arr) {
            result += ele;
            if (i < arr.size()) result += sep;
            i++;
        }
        return result;
    }
    
}