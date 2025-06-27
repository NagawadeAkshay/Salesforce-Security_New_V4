@IsTest
public class TestFlexLayoutViewGenerator {
	private static DynamicLayoutHolder dynamicHolder;
    private static String recordId='';
    private static PageLayoutConfigHelper pageLayoutHelper;

         @TestSetup static void setup(){

         SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
         SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
         recordId = sampleObject12.Id;
       
        // dynamicHolder = TestHelper.getDynamicLayoutHolder();
         new FlexLayoutPrintGenerator(dynamicHolder,false,'','','','Test Sub Header');
     }
     @IsTest
    private static void testGenerateMethod(){
        Test.startTest();
        PageTemplate__c pgTempVal =  TestHelper.getPageTemplateConfigForPrintGenrator(True);
        SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
        SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        KeyValueStoreHelper.setBooleanValue('EnableDigitalSignature', true,true);
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        
        FlexLayoutViewGenerator flexPrintObj = new FlexLayoutViewGenerator(dynamicHolder,false,'','','',false);
        
    	Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generate();
        
        for (PageLayoutConfigHelper.Tab tab : dynamicHolder.layout.tabs) {
            for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                for (PageLayoutConfigHelper.PageBlock block : blocks) {
                    flexPrintObj.renderFormTable(block);
                  }
               }
         }
		 System.assertNotEquals(null,flexOutputPanel);      
        Test.stopTest();
    }
     @IsTest
    private static void testGenerateMethod1(){
        Test.startTest();
        PageTemplate__c pgTempVal =  TestHelper.getPageTemplateConfigForPrintGenrator(True);
        SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
        SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        
        FlexLayoutViewGenerator flexPrintObj = new FlexLayoutViewGenerator(dynamicHolder,true,'','','',false);
        
    	Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generate();
		   System.assertNotEquals(null,flexOutputPanel);      
        Test.stopTest();
    }
     @IsTest
    private static void testGenerateHeader(){
        Test.startTest();
         PageTemplate__c pgTempVal =  TestHelper.getPageTemplateConfigForPrintGenrator(True);
        SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
        SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        FlexLayoutViewGenerator flexPrintObj = new FlexLayoutViewGenerator(dynamicHolder,false,'','','',false);
        Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generateHeader();
        System.assertNotEquals(null,flexOutputPanel);
        Test.stopTest();
    }
    
	  @IsTest
    private static void testGenerateHeader1(){
        Test.startTest();
         PageTemplate__c pgTempVal =  getPageTemplateConfigForPrintGenrator(True,'Files',false);
        SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
        SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        FlexLayoutViewGenerator flexPrintObj = new FlexLayoutViewGenerator(dynamicHolder,false,'','','');
        Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generateHeader();
        System.assertNotEquals(null,flexOutputPanel);
        Test.stopTest();
    }
     @IsTest
    private static void testGenerateHeader2(){
        Test.startTest();
         PageTemplate__c pgTempVal =  getPageTemplateConfigForPrintGenrator(True,'ReCaptcha',true);
        SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
        SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        FlexLayoutViewGenerator flexPrintObj = new FlexLayoutViewGenerator(dynamicHolder,false,'','','');
        Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generateHeader();
        System.assertNotEquals(null,flexOutputPanel);
        Test.stopTest();
    }
    
     @IsTest
    private static void testGenerateHeader3(){
        Test.startTest();
         PageTemplate__c pgTempVal =  getPageTemplateConfigForPrintGenrator(True,'Library',true);
        SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
        SampleObject12__c sampleObject12 = TestHelper.getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        FlexLayoutViewGenerator flexPrintObj = new FlexLayoutViewGenerator(dynamicHolder,false,'','','');
        Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generateHeader();
        System.assertNotEquals(null,flexOutputPanel);
        Test.stopTest();
    }
    public static PageTemplate__c getPageTemplateConfigForPrintGenrator(Boolean create, String recordType,Boolean overview) {
        PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true);
        TabConfig__c tabConfig = new TabConfig__c(IsActive__c=true,PageLayoutConfig__c=pageLayoutConfig.id,SortOrder__c=0,StandardTabName__c='Tab 1',HideforQueue__c='test',HeaderInstructionText__c='test',isOverview__c=overview,SkipForExport__c=false);
        insert tabConfig;      
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true,recordType);//getPageBlockConfig(tabConfig.Id, true);
        pageBlockConfig.CaptchaFieldAPIName__c ='Name';
        update pageBlockConfig;
        TestHelper.getPageAttachmentConfig(pageBlockConfig.Id, true);
        DataTableConfig__c dtConfig = TestHelper.getFlexTableConfig(true);
        TestHelper.setCommunicationPageBlock(tabConfig.Id,true);
        TestHelper.setFlexTableConfig(tabConfig.Id, dtConfig.Id,true);      
        FlexGridConfig__c flexGridConfig = TestHelper.getFlexGridConfig(true);
        TestHelper.setBudgetFlexGridConfig(tabConfig.Id, flexGridConfig.Id,true);
       
        //    FlexGridConfig__c flexGridConfigMe = getFlexGridConfigME(true);
       
        FlexGridConfig__c flexGridConfigN2G =  TestHelper.getFlexGridConfigN2G(true);
        //   setMassEditableFlexGridConfig(tabConfig.Id, flexGridConfigMe.Id,true);
        TestHelper.setN2GFlexGridConfig(tabConfig.Id, flexGridConfigN2G.Id,true);
        TestHelper.setPageBlockConfigWithForm(tabConfig.Id, true);
         TestHelper.setPageBlockConfigWithAttachment(tabConfig.Id, true);
        TestHelper.setPageBlockConfigWithNotes(tabConfig.Id, true);
        TestHelper.setPageBlockConfigWithApprovalHistory(tabConfig.Id, true);
        TestHelper.setPageBlockConfigWithCollab(tabConfig.Id, true);
        TestHelper.setPageBlockConfigWithDigitalSigned(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig =  TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);

        TestHelper.renderBlankSpace(pageBlockConfig.Id,true);
        TestHelper.renderStaticPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderFieldLevelAttachment(pageBlockConfig.Id,true);
        TestHelper.renderCurrencyFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderMultiSelectPicklistFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderDateFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderDateTimeFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderTimeFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderRichTextAreaFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderRefrenceFieldPageBlockDetail(pageBlockConfig.Id,true);

        TestHelper.renderBooleanFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderTextAreaFieldPageBlockDetail(pageBlockConfig.Id,true);
        TestHelper.renderPicklistFieldPageBlockDetail(pageBlockConfig.Id,true);


        TestHelper.renderAlternateRenderPicklist(pageBlockConfig.Id,true);
        TestHelper.renderAlternateRenderCheckBox(pageBlockConfig.Id,true);
        TestHelper.renderAlternateRenderRadio(pageBlockConfig.Id, true);
        //renderAlternateRenderTypeahead(pageBlockConfig.Id,true);
        //getPageBlockConfigWithFlexTable(tabConfig.Id, true);
        TestHelper.getPageLayoutActionConfig(true, pageLayoutConfig.Id);
        TestHelper.getMessageConfig(pageLayoutConfig.Id, pageBlockConfig.Id, true);
        TestHelper.getLayoutBizRule(pageBlockConfig.Id, pageLayoutConfig.Id, true);
        CustomApp__c custApp = TestHelper.getCustomApp(true);
       
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',SkipFormDownload__c=false,
                RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
        if (create) {
            insert template;
        }
        return template;
    }
 @isTest
    static void testgetflexLayoutViewWrapper(){
        Test.startTest();
        List<sObject> sObjectList = new List<sObject>();
        Map<String, String> fieldLableMap = new Map<String, String>();
        Map<String, String> fieldDataTypeMap = new Map<String, String>();
        Map<String, Integer> scaleMap =new  Map<String, Integer>();
        String label;
        FlexLayoutViewGenerator.FlexLayoutWrapper costom = new FlexLayoutViewGenerator.FlexLayoutWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
        FlexLayoutViewGenerator.FlexlayoutGeneratorWrapper custom = new FlexLayoutViewGenerator.FlexlayoutGeneratorWrapper(label);

        Test.stopTest();
        System.assertNotEquals(sObjectList,null);
       }

   }