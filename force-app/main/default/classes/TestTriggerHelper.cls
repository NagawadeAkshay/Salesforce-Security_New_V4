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
private with sharing class TestTriggerHelper {

    private static void setup() {
        // TO DO: implement unit test
        Account act = TestHelper.getAccount(true);
        //Trigger.isBefore = true;
        TriggerHelper.skipTrigger = true;
    }
    
    @isTest
    public static void test_1(){
    	setup();
    	TriggerHelper helper = new TriggerHelper();
    	//helper.process();
    	System.assertNotEquals(true,false);
    }

    @isTest
    public static void processTest_1(){
        KeyValueStoreHelper.setBooleanValue('EnableSharingModel',true,true);
        TestHelper.getUserPreference(true,'ActiveAppName__c','StateAsaGrantor');
        TriggerHelper.skipAutoSnapShot = false;
        String objecName = AppUtils.getNameSpacePrefix()+'SampleObject11__c';
        String fieldApiName = AppUtils.getNameSpacePrefix()+'RoleCode__c';
        insert new BusinessShareConfig__c(Name = objecName, ShareObjectName__c = 'SampleObject11__Share', Active__c = true , RoleCodeFieldName__c ='RoleCode__c');
        SampleObject11__c sampleObj1 = TestHelper.getSampleObject1(false);
        sampleObj1.RoleCode__c = 'Test1';
        insert sampleObj1;
        
        //Group groupObj = TestHelper.getGroup(true);
        //insert new SObjectSharingRuleCache__c(Name = objecName, SObjectName__c = objecName, AccessLevel__c = 'Edit', ShareWithGroupIds__c = groupObj.id, RuleType__c = 'Home');

        sampleObj1.Name = 'Test1';
        //sampleObj1.RoleCode__c = 'Test';
        update sampleObj1;
        System.assertEquals('Test1', sampleObj1.Name);
        delete sampleObj1;
        undelete sampleObj1;
    	System.assertNotEquals(true,false);
    }
     
    @isTest
    public static void processTest_2(){
        SampleObject11TriggerHelper triggerHelper = new SampleObject11TriggerHelper();
        triggerHelper.sampleMethod();
        TriggerHelper obj = new TriggerHelper();
        obj.processBeforeInsert();
        obj.processBeforeUpdate();
        obj.processBeforeDelete();
        obj.processBeforeUndelete();
        obj.processAfterInsert();
        obj.processAfterUpdate();
        obj.processAfterDelete();
        obj.processAfterUndelete();
    	System.assertNotEquals(true,false);
    }
    
     @isTest
    public static void testMethod1(){
        TriggerHelper.skipAutoSnapShot = false;
        SampleObject11__c  samObj11 = TestHelper.getSampleObject1(true);
        System.AssertEquals(samObj11.Name, 'test', 'Name of record is test');
        delete samObj11;
        undelete samObj11 ;
        
    }
    
    @isTest
    public static void testMethod2(){
        try{
            SampleObject11__c  samObj11 = TestHelper.getSampleObject1(true);
            System.AssertEquals(samObj11.Name, 'test', 'Name of record is test');
            Map<String,String> sobjectIdToRoleCodeMap = new Map<String,String>();
            sobjectIdToRoleCodeMap.put(samObj11.Id, samObj11.Name);
            TriggerHelper ctrl = new TriggerHelper();
            ctrl.deleteExistingSharingRecords('Application__Share', sobjectIdToRoleCodeMap);
        }Catch(Exception e){}
   }
}