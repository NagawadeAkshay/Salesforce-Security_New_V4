/**
    Test class for AttachmentUtils
    **********************************************************
    Audit History
    **********************************************************
    4/27/2014   Someone   Created
    **********************************************************  
*/
@isTest
private with sharing class TestAttachmentUtils {

    @IsTest(OnInstall=false)
    private static void testAttachments() {
        //Prepare test data
        User u = TEstHelper.getAdminUser(true);
        system.runAs(u){
            Test.startTest();
            String nameSpaceprefix  = AppUtils.getNamespacePrefix();
            Pagereference exportPage = Page.BlankPage;
            Account acc = TestHelper.getAccount(true);
            SampleObject11__c sobj = TestHelper.getSampleObject1(true);
            SObjectConfig__c sconfig=TestHelper.getSObjectConfig(false);
            sconfig.Name = nameSpaceprefix + 'SampleObject11__c';
            sconfig.AttachmentName__c = 'test';
            insert sconfig;
            String parentId = acc.id;
            String parentId_1 = sconfig.id;
            //AttachmentUtils.exportAsPDF(exportPage, parentId, 'history', 'test.pdf');
            AttachmentUtils.exportAsPDF(exportPage, parentId, 'history','test.pdf');
            AttachmentUtils.exportAsPDF(exportPage, parentId,'history','testing reason', 'test.pdf');
            AttachmentUtils.exportAsPDF(exportPage, parentId,'history','test.pdf');
            AttachmentUtils.exportAsPDF(exportPage,sobj.id ,'history');
            
            //AttachmentUtils.exportAsPDF(exportPage, parentId,'history','test.pdf');
            Test.stopTest();
            
            System.assertNotEquals(null, acc);

            ContentVersion objContentVersion = new ContentVersion(); 
            objContentVersion.ContentURL='<a target="_blank" href="https://www.login.salesforce.com/";" rel="nofollow">https://www.login.salesforce.com/";</a> ';
            objContentVersion.Title ='Salesforce.com';

            try {
                objContentVersion = AttachmentUtils.exportAsFilePDF(null, parentId, 'Test', 'Test', objContentVersion.Title, 'txt');
                System.assertNotEquals(null, objContentVersion.Id);
            } catch(Exception ex) {}            

            try {
                objContentVersion = AttachmentUtils.exportAsApprovalFilePDF(null, parentId, 'test', 'attName');
            } catch(Exception ex) {}
        }        
    }
    
}