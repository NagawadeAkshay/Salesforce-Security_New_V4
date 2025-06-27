@isTest
public with sharing class GenericCtrlTest {

    @isTest
    public static void testConstructors(){
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        ApexPages.StandardController sc = new ApexPages.StandardController(sampleObject1);
        GenericCtrl gvc1 = new GenericCtrl(sc);
        System.assertNotEquals(null, gvc1);
    }

    @isTest
    public static void testInitMethods(){
        GenericCtrl gvc = new GenericCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        String name = sampleObject1.name;
        System.assertEquals(null, gvc.init());
        System.assertEquals(null, gvc.init(recordId));
        System.assertEquals(null, gvc.init(recordId,'url'));
    }
    @isTest
    public static void testGetKeyValueMapGenericMethods() {
        GenericCtrl gvc = new GenericCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        System.assertEquals(null, gvc.getKeyValueMapGeneric(recordId,recordId));
        System.assertEquals(null, gvc.getKeyValueMapGeneric(recordId));
        System.assertEquals(null, gvc.getKeyValueMapGeneric('recorobjectNamedId', recordId));
    }

    @isTest
    public static void testGetChartParameters() {
        GenericCtrl gvc = new GenericCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        System.assertEquals(null, gvc.getChartParameters(recordId));
    }

    @isTest
    public static void testGetWarningMessage() {
        GenericCtrl gvc = new GenericCtrl();
        System.assertEquals(null, gvc.getWarningMessage());
    }
    @isTest
    public static void testGetListParameters() {
        GenericCtrl gvc = new GenericCtrl();
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        String recId = sampleObject1.id;
        System.assertEquals(null, gvc.getListParamsGeneric(recordId));
        System.assertEquals(null, gvc.getListParamsGeneric(recId));
    }
}