/**
**/
public with sharing class redirectToFileDownloadController{

     // public redirectToFileDownloadController(){
     //      redirectFileDownloadURL();
     // } 
    
     public pageReference redirectFileDownloadURL(){
          //get the content document id from the URL
          String contentVerId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('contentDocumentId'));  //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
          
          // query for content version record
          List<ContentVersion> cntversionLst = [SELECT Id,VersionNumber FROM ContentVersion 
                                             WHERE Id=:contentVerId and IsLatest=true WITH USER_MODE]; //CRUD/FLS False -ve as before fetching the data using soql query we are enforcing with user mode.
          
          // return to download of file URL
          return new pageReference(URL.getOrgDomainURL().toExternalForm()+'/sfc/servlet.shepherd/version/download/'+cntversionLst[0].Id); //ApexOpenRedirect  - False +Ve - fetching cntversionLst[0].Id from query 
     }
}