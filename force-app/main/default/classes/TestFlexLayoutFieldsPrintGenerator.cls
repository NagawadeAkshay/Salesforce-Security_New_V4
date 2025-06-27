/**
 * Created by REI on 19-06-2020.
 */

@IsTest
private with sharing class TestFlexLayoutFieldsPrintGenerator {

    private static DynamicLayoutHolder dynamicHolder;
    private static String recordId='';
    private static PageLayoutConfigHelper pageLayoutHelper;
    private static String layoutId='';
    private static Component.Apex.OutputPanel body;

    @TestSetup  static  void setup(){
        PageLayoutConfig__c PageLayoutConfig = TestHelper.getPageLayoutConfig(true);
        layoutId = PageLayoutConfig.Id;   
    }
    
     @IsTest
    private static void testFlexLayoutFieldPrintGenerator(){
        Test.startTest();
        dynamicHolder = TestHelper.getDynamicLayoutHolder();
        setup();
        FlexLayoutFieldsPrintGenerator flexFieldPrintGenObj;
        for(PageLayoutConfigHelper.Tab tab : dynamicHolder.layout.tabs){
            for(PageLayoutConfigHelper.pageBlock pgBlock: tab.pageBlocks){
                for(PageLayoutConfigHelper.Field field : pgBlock.fields){
                    flexFieldPrintGenObj = new FlexLayoutFieldsPrintGenerator(dynamicHolder,body,field,layoutId);
                    flexFieldPrintGenObj.renderVisibleHelpText();
                    if(field.altRen != null){
                        flexFieldPrintGenObj.renderAltRenCheckbox();
                        flexFieldPrintGenObj.renderAltRenPicklist();
                    }
                }
            }
        }
        System.assertNotEquals(null,flexFieldPrintGenObj);
        Test.stopTest();
    }
    
    @IsTest
    private static void testPrintGenerator(){
        Test.startTest();
        setup();
        String generatePrintObj='';
        dynamicHolder = TestHelper.getDynamicLayoutHolder();
        FlexLayoutFieldsPrintGenerator flexFieldPrintGenObj;
        for(PageLayoutConfigHelper.Tab tab : dynamicHolder.layout.tabs){
            for(PageLayoutConfigHelper.pageBlock pgBlock: tab.pageBlocks){
                for(PageLayoutConfigHelper.Field field : pgBlock.fields){
                    flexFieldPrintGenObj = new FlexLayoutFieldsPrintGenerator(dynamicHolder,body,field,layoutId);
                     generatePrintObj = flexFieldPrintGenObj.generate();
                }
            }
        }
        System.assertNotEquals(null,generatePrintObj);
        Test.stopTest();
    }
}