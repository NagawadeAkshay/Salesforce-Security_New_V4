/**
 * Created by REI on 18-06-2020.
 */

@IsTest
private with sharing class TestFlexLayoutPrintGenerator {

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
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        
         FlexLayoutPrintGenerator flexPrintObj = new FlexLayoutPrintGenerator(dynamicHolder,false,'','','','Test Sub Header',false);
        
    	Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generate();
        for (PageLayoutConfigHelper.Tab tab : dynamicHolder.layout.tabs) {
            for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                for (PageLayoutConfigHelper.PageBlock block : blocks) {
                    flexPrintObj.renderRecordHistoryTable(block);
                    flexPrintObj.renderDigitallySigned(block);
                    flexPrintObj.renderCollab(block);
                }
            }

        }

        System.assertNotEquals(null,flexOutputPanel);
        Test.stopTest();
    }

   /* @IsTest
    private static void testGenerateFormHeader(){
        Test.startTest();
        dynamicHolder = TestHelper.getDynamicLayoutHolder();
        Sobject sobj = dynamicHolder.formRecordMap.get(dynamicHolder.layoutId);
        FlexLayoutPrintGenerator flexPrintObj = new FlexLayoutPrintGenerator(dynamicHolder,false,'','','','Test Sub Header',false);
        flexPrintObj.generateFormHeader(dynamicHolder.layout,sobj);
        System.assertNotEquals(null,flexPrintObj);
        Test.stopTest();
    }*/



    @IsTest
    private static void testGenerateHeader(){
        Test.startTest();
        FlexLayoutPrintGenerator flexPrintObj = new FlexLayoutPrintGenerator(dynamicHolder,false,'','','','Test Sub Header',false);
        Component.Apex.OutputPanel flexOutputPanel = flexPrintObj.generateHeader();
        System.assertNotEquals(null,flexOutputPanel);
        Test.stopTest();
    }



    @IsTest
    private static void testAddIndexToHTML(){
        Test.startTest();
        FlexLayoutPrintGenerator flexPrintObj = new FlexLayoutPrintGenerator(dynamicHolder,false,'','','','Test Sub Header',false);
        flexPrintObj.addIndexToHTML();
        System.assertNotEquals(null,flexPrintObj);
        Test.stopTest();
    }


}