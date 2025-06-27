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
private class TestApprovalRecallBatch {
    @isTest //@TestSetup
    static void verifyApprovalRecallBatch(){
        SampleObject1__c sampleObj = TestHelper.getSampleObject1Val(false);
        sampleObj.IsRecordRecalled__c = true;
        insert sampleObj;
        System.assertNotEquals(null, sampleObj.Id);

        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        SObjectConfig__c sObjCon = new SObjectConfig__c(
            Name = nameSpaceprefix + 'SampleObject1__c',
            CriteriaField__c =  nameSpaceprefix  + 'Status__c',
            EnableTimeBaseApproval__c = true,
            ApprovalReCallEnable__c = true,
            ApprovalReCallFieldAPIName__c = nameSpaceprefix  + 'IsRecordRecalled__c',
            ApprovalReCallCommentFieldAPIName__c = nameSpaceprefix  + 'RecallComment__c'
        );
        insert sObjCon;
        System.assertNotEquals(null, sObjCon.Id);
        
        Test.startTest();
        ApprovalRecallBatch objBatch = new ApprovalRecallBatch();
        Id batchId = Database.executeBatch(objBatch);
        System.assertNotEquals(null, batchId);
        Test.stopTest();
    }

    /*
   	@isTest
	static void verify(){
	  	Database.QueryLocator QL;
        Database.BatchableContext BC;
           // The query used by the batch job.
        String query = 'Select Name,ApprovalReCallFieldAPIName__c,ApprovalReCallCommentFieldAPIName__c from SobjectConfig__c where ApprovalReCallEnable__c=true and '+ 
        		'ApprovalReCallFieldAPIName__c != null';

        system.assertNotEquals(null, query);
    }
    */
}