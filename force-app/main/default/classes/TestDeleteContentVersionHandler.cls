@isTest
public class TestDeleteContentVersionHandler {
@isTest
    private static void setupData(){
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;     
        DeleteContentVersionHandler obj1 = new DeleteContentVersionHandler();
        Map<String,Object> res1 = obj1.clickHandler();
        
        DeleteContentVersionHandler obj = new DeleteContentVersionHandler();
        obj.selectedRecordId = cv.id;
        Map<String,Object> res = obj.clickHandler();
         system.assertNotEquals(null,obj);      
    }
}