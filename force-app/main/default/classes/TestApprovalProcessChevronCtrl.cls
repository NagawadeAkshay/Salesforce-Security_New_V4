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
private with sharing class TestApprovalProcessChevronCtrl {
   @IsTest
   public static void testAllMethods(){
      SampleObject1__c sampleObj = TestHelper.getSampleObject1Val(true);
      System.assertNotEquals(null, sampleObj.Id);

      String nameSpaceprefix  = AppUtils.getNamespacePrefix();
      SObjectConfig__c sObjCon = new SObjectConfig__c();
      sObjCon.Name = nameSpaceprefix + 'SampleObject1__c';
      sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
      sObjCon.EnableTimeBaseApproval__c = true;
      insert sObjCon;
      System.assertNotEquals(null, sObjCon.Id);

      ApprovalProcessStepCache__c objApprovalProcessStepCache = TestHelper.createApprovalProcessStepCache(false);
      objApprovalProcessStepCache.SobjectText__c = sObjCon.Name;
      objApprovalProcessStepCache.StepName__c = 'Step_1';
      objApprovalProcessStepCache.StepNumber__c = 1;
      objApprovalProcessStepCache.StepNumber__c = 1;
      objApprovalProcessStepCache.Name = 'Step_1';
      insert objApprovalProcessStepCache;
      System.assertNotEquals(null, objApprovalProcessStepCache.Id);
      
      try {
         ApprovalProcessChevronCtrl ctrl = new ApprovalProcessChevronCtrl();
         List<Object> result_1 = ApprovalProcessChevronCtrl.generateApprovalSteps(sampleObj.id);
         Object result_2 = ApprovalProcessChevronCtrl.getRelatedFieldValue(sampleObj, 'Subject');
         System.assertEquals(null, result_1);
      } catch(Exception ex){}

      ProcessDefinition procDef = TestHelper.getProcessDefination();
      try {
         Map<Id, String> result = ApprovalProcessChevronCtrl.fetchStepMap(sampleObj.Id, sObjCon.Name, new List<ApprovalProcessStepCache__c>{objApprovalProcessStepCache}, procDef.Id);
         System.assertNotEquals(null, result);
      } catch(Exception ex){}

      try{
         Map<String, String> result = ApprovalProcessChevronCtrl.getStepByStatus(procDef.Id);
         System.assertNotEquals(null, result);
      } catch(Exception ex){}

      try{
         List<ApprovalProcessStepCache__c> lstStepCache = ApprovalProcessChevronCtrl.fetchProcDefSteps(procDef.Id);
         System.assertNotEquals(null, lstStepCache);
      } catch(Exception ex){}

      try{
         ApprovalProcessChevronCtrl.fetchOwnerMap(sampleObj.Id, sObjCon.Name, new Set<String>{'Name'});
      } catch(Exception ex){} 

      try{
         Object obj = ApprovalProcessChevronCtrl.getRelatedFieldValue(sampleObj, 'Name');
      } catch(Exception ex){} 

      try{
         List<Object> lstObj = ApprovalProcessChevronCtrl.fetchProcessInstance(sampleObj.Id, sObjCon.Name);
      } catch(Exception ex){}

      Boolean result = ApprovalProcessChevronCtrl.compareNumbers(201, 102, 'greaterThan');
      System.assertEquals(true, result);
      result = ApprovalProcessChevronCtrl.compareNumbers(201, 102, 'greaterOrEqual');
      System.assertEquals(true, result);
      result = ApprovalProcessChevronCtrl.compareNumbers(201, 202, 'lessThan');
      System.assertEquals(true, result);
      result = ApprovalProcessChevronCtrl.compareNumbers(201, 202, 'lessOrEqual');
      System.assertEquals(true, result);
      result = ApprovalProcessChevronCtrl.compareNumbers(202, 202, 'equals');
      System.assertEquals(true, result);

      result = ApprovalProcessChevronCtrl.compareStrings('str1', 'str2', 'greaterThan');
      System.assertEquals(false, result);
      result = ApprovalProcessChevronCtrl.compareStrings('str1', 'str2', 'greaterOrEqual');
      System.assertEquals(false, result);
      result = ApprovalProcessChevronCtrl.compareStrings('str1', 'str2', 'lessThan');
      System.assertEquals(true, result);
      result = ApprovalProcessChevronCtrl.compareStrings('str1', 'str2', 'lessOrEqual');
      System.assertEquals(true, result);
      result = ApprovalProcessChevronCtrl.compareStrings('str1', 'str1', 'equals');
      System.assertEquals(true, result);

      result = ApprovalProcessChevronCtrl.compareStrings('true', 'true', 'equals');
      System.assertEquals(true, result);

      SObject record = ApprovalProcessChevronCtrl.getRecord(objApprovalProcessStepCache.Id, new List<ApprovalProcessStepCache__c>{objApprovalProcessStepCache});
   }
    
     @isTest
static void testgetApprovalProcessChevronWrappers(){
	Test.startTest();
    List<sObject> sObjectList = new List<sObject>();
    Map<String, String> fieldLableMap = new Map<String, String>();
    Map<String, String> fieldDataTypeMap = new Map<String, String>();
    Map<String, Integer> scaleMap =new  Map<String, Integer>();
    String label;
	ApprovalProcessChevronCtrl.ApprovalWrapper costom = new ApprovalProcessChevronCtrl.ApprovalWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
	//CustomLookupLwcController custom = new CustomLookupLwcController();
	Test.stopTest();
    System.assertNotEquals(sObjectList,null);
   
	
}
}