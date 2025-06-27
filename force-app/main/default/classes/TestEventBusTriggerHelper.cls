@isTest
private class TestEventBusTriggerHelper {
 @isTest
    private static void testEventBus(){
        Test.startTest();
        EventBusTriggerHelper EventBusTriggerHelperObj =new EventBusTriggerHelper();
       	SampleObject11__c Objectinstance = TestHelper.getSampleObject1(true);	
        EventBus__e eventBusRec = new EventBus__e(EventName__c='SendToOwner', ParentId__c=Objectinstance.id);
        Database.SaveResult sr = EventBus.publish(eventBusRec);
        system.assertNotEquals(sr,null);
        Test.stopTest();
    }
}