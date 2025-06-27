/**As discussed with Nakul commenting this out will verify with salesforce support team Note - in future 
 * if we found we are using this class then we need to uncomment and used oauth for sessionid 
 */
@RestResource(urlMapping='/frameworkCustomMetadataAPI/*')
global with sharing class CustomMetadataREST {
    @HttpGet
    global static String doGet() {
        return null;
    }
    
    @HttpPut
    global static String doPut() {
        return null;
    } 
    
    global static String getRecords(RestRequest restRequest){
        return null;
    }
    
    global static String getRecordsOfCustomLabel(RestRequest restRequest){
        return null;
    }
    
    global static String upsertRecords(String strRequestBody){
      return null;
    }
   
    global static String upsertRecordsOfCustomLabel(String strRequestBody){
    return null;
    }
}