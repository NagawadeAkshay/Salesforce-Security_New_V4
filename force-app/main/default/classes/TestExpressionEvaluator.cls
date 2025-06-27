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
private class TestExpressionEvaluator {
	public static Account act = new Account();
	public static Contact con = new Contact();
	public Static Integer i = 4;
 	
    @testSetup
 	private static void setup(){
        // TO DO: implement unit test
        act = TestHelper.getAccount(true);
    }
    @IsTest
    public static void test_1(){
    	Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('RecordType.DeveloperName == null  &&  ggsInt__TaskSummaryAPI__c == null');
    	boolean result=expEval.evaluate(act);
        system.assertEquals(false, result);
        Test.stopTest();
    }
    @IsTest
    public static void test_2(){
        Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('ggsInt__RequestedAmount__c >= 20000');
    	boolean result=expEval.evaluate(act);
        system.assertEquals(false, result);
        Test.stopTest();

    }
 	@IsTest
    public static void test_3(){
    	Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('ggsInt__RequestedAmount__c <= 20000');
    	boolean result=expEval.evaluate(act);
        system.assertEquals(false, result);
        Test.stopTest();
    }
    @IsTest
    public static void test_4(){
    	Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('ggsInt__RequestedAmount__c == 20000');
    	boolean result=expEval.evaluate(act);
        system.assertEquals(false, result);
        Test.stopTest();
    }
    @IsTest
    public static void test_5(){
    	Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('ggsInt__RequestedAmount__c < 20000');
    	boolean result=expEval.evaluate(act);
        system.assertEquals(false, result);
        Test.stopTest();
    }
    @IsTest
    public static void test_6(){
    	Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('ggsInt__RequestedAmount__c = 20000');
    	boolean result_1 = expEval.evaluate(act);
    	boolean result_2 = expEval.evaluate(act.id);
    	expEval.getFieldNames();
        system.assertEquals(false, result_1);
        system.assertEquals(true, result_2);
        Test.stopTest();
    }
    @IsTest
    public static void test_7(){
    	Test.startTest();
    	ExpressionEvaluator expEval = new ExpressionEvaluator('ggsInt__RequestedAmount__c > 20000');
    	boolean result = expEval.evaluate(act);
        system.assertEquals(false, result);
        Test.stopTest();
    }
    
     @isTest
static void testGetExpressionWprapper(){
	Test.startTest();
    List<sObject> sObjectList = new List<sObject>();
    Map<String, String> fieldLableMap = new Map<String, String>();
    Map<String, String> fieldDataTypeMap = new Map<String, String>();
    Map<String, Integer> scaleMap =new  Map<String, Integer>();
    String label;
	ExpressionJsonEvaluator.expressionWprapper costom = new ExpressionJsonEvaluator.expressionWprapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
	//CustomLookupLwcController custom = new CustomLookupLwcController();
	Test.stopTest();
    System.assertNotEquals(sObjectList,null);
   
	
}
}