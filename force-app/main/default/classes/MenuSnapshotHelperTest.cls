@isTest
private class MenuSnapshotHelperTest {
    static DynamicLayoutHolder layoutHolder;
    static PageLayoutConfig__c pageLay;
    static SampleObject12__c Sample_2;
    static SampleObject11__c Sample_1;
    static AttachmentExtension__c attachx;
    static PageAttachmentConfig__c pc ;
    static String namespace1 = AppUtils.getNamespacePrefix();
    
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
        layoutHolder.templateName = '';
        layoutHolder.flexTableParameters = '';
    }
    @isTest
    static void verifyMenuSnapshotHelperTest() {
        setup();
        Test.startTest();        
        System.assertNotEquals(null, layoutHolder);
        MenuSnapshotHelper objMenuSnapshotHelper = new MenuSnapshotHelper();
        objMenuSnapshotHelper.layoutHolder = layoutHolder;
        String strResult = objMenuSnapshotHelper.whenClicked();
        Test.stopTest();
    }
}