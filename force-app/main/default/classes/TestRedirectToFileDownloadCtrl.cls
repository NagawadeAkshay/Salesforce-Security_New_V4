@isTest
public class TestRedirectToFileDownloadCtrl {
	@isTest
    private static void setupData(){
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;         
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
         
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
       
        Test.StartTest(); 
         SampleObject1__c testAccount = new SampleObject1__c();
         ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
       
        
         PageReference pageRef = Page.RedirectToFileDownload; // Add your VF page Name here
         pageRef.getParameters().put('contentVersionId',cvList[0].id);
         pageRef.getParameters().put('contentDocId',cdList[0].id);
         Test.setCurrentPage(pageRef);  
         RedirectToFileDownloadCtrl testAccPlan = new RedirectToFileDownloadCtrl();
         testAccPlan.redirectFileDownloadURL();
         Test.StopTest();
         System.assertEquals(cdList.size(), 1);
    }
}