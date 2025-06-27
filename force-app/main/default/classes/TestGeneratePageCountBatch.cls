@IsTest
private class TestGeneratePageCountBatch {
    @IsTest
    static void testBehavior() {

        String wordFileExt = '.docx';
        String excelFileExt = '.xlsx';
        //String pdfFileExt = '.pdf';
        String imgFileExt = '.png';
        String contentBody = 'Test Data';

        List<ContentVersion> attachments = new List<ContentVersion>();
        attachments.add(new ContentVersion(Title = 'Attachment A', ContentLocation = 'S',
                PathOnClient = 'AttachmentA' + wordFileExt, VersionData = EncodingUtil.base64Decode(contentBody)));
        attachments.add(new ContentVersion(Title = 'Attachment B', ContentLocation = 'S',
                PathOnClient = 'AttachmentB' + excelFileExt, VersionData = EncodingUtil.base64Decode(contentBody)));
        attachments.add(new ContentVersion(Title = 'Attachment C', ContentLocation = 'S',
                PathOnClient = 'AttachmentC' + imgFileExt, VersionData = EncodingUtil.base64Decode(contentBody)));
        insert attachments;
        System.assertNotEquals(null,attachments, '' );
        GeneratePageCountBatch fileBatch = new GeneratePageCountBatch();
        Test.startTest();
        Database.executeBatch(fileBatch);
        Test.setMock(HttpCalloutMock.class, new MockConnectApiResponsePageCountBatch ());
        Database.executeBatch(fileBatch);
        Test.stopTest();
    }
}