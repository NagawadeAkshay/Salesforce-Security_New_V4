/**
    Implementation classes SHOULD NOT handle exception.
    EventBusTriggerHelper class handles the exceptions for you.
    In rare cases, if you choose to handle exceptions by yourself,
    make sure to insert the errors into ErrorLog__c custom object
    so that the errors will surface to end users on flex layout.

    @author Shah Kadirmohideen
*/
global interface PlatformEventHandler {
    void handle(Set<String> parentIds);
}