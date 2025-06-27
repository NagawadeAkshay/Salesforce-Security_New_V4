@RestResource(urlMapping='/docVerifyStatusUpdate/*')
global with sharing class DocVerifyRest{
    @HttpPost
    global static String getUpdatedDocument() {
        return null;
    }
    
    @Httpget
    global static String getUpdatedDocuments() {
        return 'test';
    }

}