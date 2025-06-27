/**
    Test class for ApprovalSubmissionCtrl
    **********************************************************
    Audit History
    **********************************************************
    4/27/2014   Vineeth   Created
    **********************************************************  
*/
@isTest
private with sharing class TestApprovalSubmissionCtrl {

    @IsTest(OnInstall=false)
    private static void testAnnouncementApprovalSubmission() {
        User u = TestHelper.getAdminUser(true);

        System.runAs(u) {
        //Prepare test data
        SampleObject11__c announcementInstance = TestHelper.getSampleObject1(false);
        announcementInstance.Status__c = 'Active';
        insert announcementInstance;
        KeyValueStoreHelper.setTextValue('QueueAdminUsername', UserInfo.getUserName(), true);
        KeyValueStoreHelper.setIntegerValue('TaskDueDateOffset', 3, true);
        ApexPages.currentPage().getParameters().put('id', announcementInstance.Id);
        
        //Act
        Test.startTest();
        ApprovalSubmissionCtrl ctrl = new ApprovalSubmissionCtrl();
        ctrl.submitForApproval();
        //ctrl.returnToViewPage();
        Boolean errorMsgFlag = ctrl.getErrorMessagesFlag();
        
        Test.stopTest();

        //Assert test data
        System.assertNotEquals(ctrl, null);
        }
    }
    
    private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
        Object stub, Object request, Map<String, Object> response,
        String endpoint, String soapAction, String requestName,
        String responseNS, String responseName, String responseType)
        {
            if(request instanceof MetadataService.retrieve_element)
            response.put('response_x', new MetadataService.retrieveResponse_element());
            else if(request instanceof MetadataService.checkDeployStatus_element)
            response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
            else if(request instanceof MetadataService.listMetadata_element)
            response.put('response_x', new MetadataService.listMetadataResponse_element());
            else if(request instanceof MetadataService.checkRetrieveStatus_element)
            response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
            else if(request instanceof MetadataService.describeMetadata_element)
            response.put('response_x', new MetadataService.describeMetadataResponse_element());
            else if(request instanceof MetadataService.deploy_element)
            response.put('response_x', new MetadataService.deployResponse_element());
            else if(request instanceof MetadataService.updateMetadata_element)
            response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof MetadataService.renameMetadata_element)
            response.put('response_x', new MetadataService.renameMetadataResponse_element());
            else if(request instanceof MetadataService.cancelDeploy_element)
            response.put('response_x', new MetadataService.cancelDeployResponse_element());
            else if(request instanceof MetadataService.deleteMetadata_element)
            response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            else if(request instanceof MetadataService.upsertMetadata_element)
            response.put('response_x', new MetadataService.upsertMetadataResponse_element());
            else if(request instanceof MetadataService.createMetadata_element)
            response.put('response_x', new MetadataService.createMetadataResponse_element());
            else 
                response.put('response_x', new MetadataService.readWorkflowRuleResponse_element());
            return;
        }
    }
    
    @IsTest(OnInstall=false)
    private static void testChevronCtrl() {
        //Prepare test data
        Savepoint sp = Database.setSavepoint();
        SampleObject11__c announcementInstance = TestHelper.getSampleObject1(false);
        announcementInstance.Status__c = 'Active';
        insert announcementInstance;
        KeyValueStoreHelper.setTextValue('QueueAdminUsername', UserInfo.getUserName(), true);
        KeyValueStoreHelper.setIntegerValue('TaskDueDateOffset', 3, true);
        ApexPages.currentPage().getParameters().put('id', announcementInstance.Id);
        
        ApprovalSubmissionCtrl ctrl = new ApprovalSubmissionCtrl();
        ctrl.submitForApproval();
        //Act
        Test.startTest();
        ApprovalProcessChevronCtrl app = new ApprovalProcessChevronCtrl();
    	//System.Test.setMock(HttpCalloutMock.class, new WebServiceMockImpl());
    	System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //ApprovalProcessChevronCtrl.generateApprovalSteps(announcementInstance.Id);
        Test.stopTest();

        //Assert test data
        System.assertNotEquals(ctrl, null);
    }
}