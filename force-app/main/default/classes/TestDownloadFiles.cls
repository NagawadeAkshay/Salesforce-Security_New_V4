@isTest
public class TestDownloadFiles {
    @isTest
 private static void setupData(){
      User standardUser = TestHelper.getStandardUser(true);      
      SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test');
      insert s1;
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
      List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];           List<ContentDocumentLink> lstLinks = new List<ContentDocumentLink>();
      lstLinks.add(new ContentDocumentLink(ContentDocumentId = cdList[0].id, LinkedEntityId = s1.Id));
      insert lstLinks;
      Test.StartTest(); 
      System.runAs(standardUser) {
        PageReference pageRef = Page.RedirectToFileDownload; // Add your VF page Name here
        pageRef.getParameters().put('id',s1.id);
        pageRef.getParameters().put('contentDocId',cdList[0].id);
        Test.setCurrentPage(pageRef);  
        DownloadFiles testAccPlan = new DownloadFiles();
      
        Test.StopTest();
        System.assertEquals(cdList.size(), 1);
      }
    }
}