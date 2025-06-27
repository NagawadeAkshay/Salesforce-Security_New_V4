/**
**/
public with sharing class RedirectToFileDownloadCtrl {

    public pageReference redirectFileDownloadURL(){
          
          //get the content document id from the URL
          String contentVerId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('contentVersionId'));  //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
          String contentDocId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('contentDocId'));  //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
          
          String urlId;
          // query for content version record
          if(String.isNotEmpty(contentVerId)){
            List<ContentVersion> cntversionLst = [SELECT Id,VersionNumber FROM ContentVersion 
                                                WHERE Id=:contentVerId and IsLatest=true WITH USER_MODE]; 
            
            for(ContentVersion cv:cntversionLst ){
                urlId = cv.id;
            }
          }

           if(String.isNotEmpty(contentDocId)){
            List<ContentVersion> cntversionLst = [SELECT Id,ContentDocumentId,VersionNumber 
                                                  FROM ContentVersion 
                                                  WHERE ContentDocumentId=:contentDocId and IsLatest=true WITH USER_MODE]; 
            
          for(ContentVersion cv:cntversionLst ){
              urlId = cv.id;
          }
          }


          // return to download of file URL
         // return new pageReference('/sfc/servlet.shepherd/version/download/'+cntversionLst[0].Id);
         return new pageReference(URL.getOrgDomainURL().toExternalForm()+'/sfc/servlet.shepherd/version/download/'+urlId);  //ApexOpenRedirect  - False +Ve - fetching urlId from query 
     }
}