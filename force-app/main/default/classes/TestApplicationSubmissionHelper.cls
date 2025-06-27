/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 * 
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private with sharing class TestApplicationSubmissionHelper {
    public static DynamicLayoutHolder layoutHolder;
    public static PageLayoutConfig__c pageLay;
    public static SampleObject12__c Sample_2;
    public static SampleObject11__c Sample_1;
    public static AttachmentExtension__c attachx;
    public static PageAttachmentConfig__c pc ;
    public static String namespace1 = AppUtils.getNamespacePrefix();
    
    private static void setup(){
        Sample_1 = TestHelper.getSampleObject1(true);
        Sample_2 = TestHelper.getSampleObject2(true,Sample_1.Id);
        Attachment att=TestHelper.getAttachment(Sample_1.id,true);
        pageLay = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pageLay.Id, true);
        PageBlockConfig__c pbc = TestHelper.getPageBlockConfig(tab.Id, true);
        PageBlockDetailConfig__c pbdc = TestHelper.getPageBlockDetailConfig(pbc.id,false);
        pbdc.FieldAPIName__c = namespace1 + 'SampleObject11__r.Name';
        pbdc.AllowedWordsForRichTextArea__c = 200;
        pbdc.IsRichTextArea__c = true;
        insert pbdc;
        pc = new PageAttachmentConfig__c ();
        pc.PageBlockConfig__c = pbc.Id;
        pc.AttachmentCount__c = -12;
        pc.Classification__c = 'test';
        pc.MaximumAttachmentCount__c = -11;
        insert pc;
        attachx = TestHelper.getAttachmentExtension('test',Sample_2.Id, true);
        //pageLay = TestHelper.getPageLayoutConfig(true);
        layoutHolder = new DynamicLayoutHolder(pageLay.Id,Sample_2.Id,true);
    }
    
    @IsTest
    public static void testAllMethods(){
        setup();
        Test.startTest();
        Boolean result_1 = ApplicationSubmissionValidationHelper.validateApplication(layoutHolder,Sample_2.Id);
        Boolean result_2 = ApplicationSubmissionValidationHelper.validateApplicationsRTAWordCount(layoutHolder);
        Boolean result_3 = ApplicationSubmissionValidationHelper.isEnableSubmit(pageLay.Id,'test',Sample_2.id,false,true);
        Boolean result_4 = ApplicationSubmissionValidationHelper.isTextAreaCharCountExceeded(layoutHolder);
        Test.stopTest();
        System.assertNotEquals(result_1, false);
    }
    
}