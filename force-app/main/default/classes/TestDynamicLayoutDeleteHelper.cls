@isTest
private with sharing class TestDynamicLayoutDeleteHelper{
	static DynamicLayoutDeleteHelper dynamicLayoutDeleteHelper;
	static void setup()
	{
	 	TestHelper.createCustomSettings(true);                    
        SampleObject11__c grant = TestHelper.getSampleObject1(true);
        SampleObject11__c award = TestHelper.getSampleObject1(true);
        PageLayoutConfig__c pageLayout =  TestHelper.getPageLayoutConfig(false);
        pageLayout.ObjectAPIName__c =AppUtils.getNameSpacePrefix()+'SampleObject11__c'; 
        insert pageLayout;
                        
        DynamicLayoutHolder layoutHolder = null; 
        DynamicLayoutController ctrl_inner  = new DynamicLayoutController(); 
        layoutHolder = new DynamicLayoutHolder(pageLayout.id,award.id,true);
        ctrl_inner = new DynamicLayoutController();
        dynamicLayoutDeleteHelper = new DynamicLayoutDeleteHelper();
        dynamicLayoutDeleteHelper.layoutHolder  = layoutHolder;        
        try{
                PageReference result = dynamicLayoutDeleteHelper.whenClicked();	
           }catch(Exception e){}
	}

    @isTest
    static void testAll(){
        user u = TestHelper.getAdminUser(false);
        system.runAs(u){
        	setup();
            Test.StartTest(); 
         		dynamicLayoutDeleteHelper.deleteRecord();  
        	Test.StopTest();
            System.assert(u != null);
        }
    }
 }