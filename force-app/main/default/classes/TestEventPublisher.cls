/**
 * Created by REI on 23-06-2020.
 */

@IsTest
private with sharing class TestEventPublisher {

    private static EventBus__e eventVal;
    private static Id recordId;
    @TestSetup
    static void setup(){
        SampleObject2__c sampleObject2Obj = TestHelper.getSampleObject2Val(true);
        recordId = sampleObject2Obj.Id;
        eventVal = new EventBus__e(EventName__c='TestSendToOwner', ParentId__c=recordId);
    }

    @IsTest
    private static void testEventPubConstructor(){
        setup();
        Test.startTest();
        EventPublisher eventPublisher = new EventPublisher('TestSendToOwner');
        eventPublisher.recordId(recordId);
        eventPublisher.batchSize(1);
        Test.stopTest();
        System.assertNotEquals(null,eventPublisher);
    }

    @IsTest
    private static void testPublishEvent(){
        setup();
        Test.startTest();
        EventPublisher eventPublisher = new EventPublisher('TestSendToOwner');
        // Call method to publish events
        eventPublisher.recordId(recordId);
        eventPublisher.batchSize(10);
        eventPublisher.publish();
        Test.stopTest();
        System.assertNotEquals(null,eventPublisher);
    }

    @IsTest
    private static void testConcatenate(){
        Test.startTest();
        String[] errorMsgStr = new List<String>();
        System.assertNotEquals(null, errorMsgStr);
        errorMsgStr.add('Required Field Missing');
        errorMsgStr.add(':For field ParentId__c');
        EventPublisher.concatenate(errorMsgStr,',');
        Test.stopTest();
    }
}