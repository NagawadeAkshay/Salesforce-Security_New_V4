/*
Created By    : Amol Darekar
Created Date  : 17th Sept 2018
Modified Date : 17th Sept 2018
Purpose: This class is used to call Itext API.
*/

Global with sharing class ITextHelper {

   //This function calls the API of IText to merge the PDF files into one file and return the attachment IDs.
   Global static Map<String, Object>mergePDF(Map<String, Object> objectParamMap){
      Map<String, Object> returnMap = new Map<String, Object>();
         return returnMap;
    }
   
   //This function create body to pass the IText API.
   private static string createRequestBody(Map<String, Object> objectParamMap){
        Map<String,String> bodyMap = new Map<String,String>();
        //Attachment Ids to be merged
        bodyMap.put('attachmentIds',((String)objectParamMap.get('attachmentIds'))); 
        bodyMap.put('sessionId', '{!$Credential.OAuthToken}');
        //Create a task with specified name        
        bodyMap.put('task',((String)objectParamMap.get('task')));
        //Parent record Id where merged field to be attached
        bodyMap.put('recordId',((String)objectParamMap.get('parentRecordId')));
        //Name of the merged file.
        bodyMap.put('fileName',((String)objectParamMap.get('fileName')));
        bodyMap.put('serviceEndPoint',URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/u/40.0/');  
        return JSON.serialize(bodyMap);
    }
   }