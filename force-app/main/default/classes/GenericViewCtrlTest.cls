@isTest
public with sharing class GenericViewCtrlTest {

    @isTest
    public static void testConstructors(){
        GenericViewCtrl gvc = new GenericViewCtrl();
        System.assertNotEquals(null, gvc);
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        ApexPages.StandardController sc = new ApexPages.StandardController(sampleObject1);
        GenericViewCtrl gvc1 = new GenericViewCtrl(sc);
        System.assertNotEquals(null, gvc1);
    }

    @isTest
    public static void testGetKeyValueMapGenericMethods() {
        GenericViewCtrl gvc = new GenericViewCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        System.assertEquals(null, gvc.getKeyValueMapGeneric(recordId,true));
    }

    @isTest
    public static void testGetChartParameters() {
        GenericViewCtrl gvc = new GenericViewCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        System.assertEquals(recordId , sampleObject1.id);
    }

    @isTest
    public static void testGetWarningMessage() {
        GenericViewCtrl gvc = new GenericViewCtrl();
        System.assertEquals(null, gvc.getWarningMessage());
    }

    @isTest
    public static void testInit() {
        GenericViewCtrl gvc = new GenericViewCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        System.assertEquals(null, gvc.init(recordId,true));
    }
}