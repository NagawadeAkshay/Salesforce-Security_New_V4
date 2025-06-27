@isTest
private class TestFeedItemInfo {
    @isTest
    private static void testFeedItemInfo1() {
        User admin = TestHelper.getAdminUser(true);
        System.runAs(admin) {
            Test.startTest();
            
            TestHelper.getContentVersion(true);
            ContentVersion contentVersion = [Select ContentDocumentId FROM ContentVersion WHERE ContentDocumentId != null LIMIT 1];
            ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
            //FeedItemInfo f=new FeedItemInfo(input);
            Test.stopTest();
             system.assertNotEquals(null, contentVersion );
        }
    } 
    
    @isTest 
    private static void testFeedItemInfo2() {
        User admin = TestHelper.getAdminUser(true);
        System.runAs(admin) {
            Test.startTest();
            ContentVersion cv = new ContentVersion();
            cv.ContentUrl = '/Test/ContentVersion/content/';
            //cv.versionData = Blob.valueOf('Unit Test Content Version');
            //cv.title = 'testFile.txt';
            //cv.pathOnClient ='/' + cv.title;
            insert cv;
            ContentVersion contentVersion = [Select ContentUrl FROM ContentVersion WHERE ContentUrl != null LIMIT 1];
            Test.stopTest();
             system.assertNotEquals(null, contentVersion );
           
        }
    } 
}