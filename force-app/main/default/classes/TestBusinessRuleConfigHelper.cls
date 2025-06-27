/*
    This is a test class for BusinessRuleConfigHelper class
    **********************************************************
    Audit History
    **********************************************************
    05-28-2014  Hafsa Syed  Created  
    **********************************************************  
 */
@IsTest
private class TestBusinessRuleConfigHelper {
	public static SampleObject12__c samObj_2;
 	public static SampleObject11__c samObj_1;
 	public static BusinessRuleConfig__c rule;
 	public static PageLayoutConfig__c pc;
 	public static PageLayoutActionConfig__c pac;
 	public static LayoutBusinessRuleConfig__c lbr = new LayoutBusinessRuleConfig__c();  
 	public static PageLayoutActionConfig__c pageAction;
	private static void setup(){
		samObj_1 = TestHelper.getSampleObject1(true);
		samObj_2 = TestHelper.getSampleObject2(true,samObj_1.id);	
 	 	rule = new BusinessRuleConfig__c(Name='Test',Active__c = true,ClassName__c = 'TestRule',Description__c = 'Description');
 	 	insert rule;
    	pc = TestHelper.getPageLayoutConfig(true);
	    pac = new PageLayoutActionConfig__c ();
	    pac.PageLayoutConfig__c = pc.Id;
	    insert pac;
        lbr.Expression__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Profile","Value":""},"Operator":"IN","ROperand":{"Type":"","Value":null,"Values":["System Administrator"]}}],"Groups":[]}';
        lbr.PageLayoutConfig__c = pc.Id;
        lbr.PageLayoutActionConfig__c  = null;
        lbr.RecordTypeId = Schema.SObjectType.LayoutBusinessRuleConfig__c.getRecordTypeInfosByName().get('Save Action - Class based Rule').getRecordTypeId();
        lbr.Active__c = true;
        //lbr.ClassName__c = 'TestRule';
        insert lbr;
        pageAction = TestHelper.getPageLayoutActionConfig(true,pc.id);
	}
	
	@isTest(OnInstall=false)
    static void testBusinessRule() {
		
		setup();
        DynamicLayoutHolder holder = new DynamicLayoutHolder(pc.Id,samObj_2.id,true);
        BusinessRuleResult  result_1=BusinessRuleConfigHelper.execute(samObj_2, holder);
        System.assertEquals(null,result_1);
    }
    @isTest(OnInstall=false)
    static void test_1() {
		setup();
        DynamicLayoutHolder holder = new DynamicLayoutHolder(pc.Id,samObj_2.id,true);
        BusinessRuleResult  result_1=  BusinessRuleConfigHelper.execute(pageAction.id,samObj_2, holder);
        System.assertEquals(null,result_1);
    }
}