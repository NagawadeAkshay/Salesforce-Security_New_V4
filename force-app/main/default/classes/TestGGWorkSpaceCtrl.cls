@isTest
private class TestGGWorkSpaceCtrl
{
    @isTest
    static void TestInitMethod()
    {
          Account acct = new Account(Name='TEST_ACCT');
            insert acct;
            User u = TestHelper.getAdminUser(true);
                        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                      
            ContentVersion contentVersion = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
             
            );
            insert contentVersion;    
            System.runAs(u){
                Test.startTest();
                  GGWorkSpaceCtrl.initData1(contentVersion.id, acct.id);
                Id conDoc = [Select ContentDocumentId from ContentVersion where id =:contentVersion.Id].ContentDocumentId;
                list<ContentDocumentLink> cdl = [select id  from ContentDocumentLink where ContentDocumentId =:conDoc];
                system.assertNotEquals(null, cdl);
                Test.stopTest();                    
            }
        
    }
}