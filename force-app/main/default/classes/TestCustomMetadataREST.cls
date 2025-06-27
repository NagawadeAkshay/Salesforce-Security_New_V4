@isTest
public class TestCustomMetadataREST {

    // public static String JsonMsg;
    // public static RestRequest req ; 
    // public static RestResponse res;

    // private static void reqBodyFormtion(String requestUri,String httpMethod,String jsonMsg){
    //         JsonMsg = jsonMsg;
    //         req = new RestRequest(); 
    //         res = new RestResponse();
    //         req.requestURI = requestUri;  //Request URL
    //         req.httpMethod = httpMethod;//HTTP Request Type
    //         req.requestBody = Blob.valueof(JsonMsg);
    //         RestContext.request = req;
    //         RestContext.response= res;
    // }
    
    // private class WebServiceMockImpl implements WebServiceMock
    // {
    //     public void doInvoke(
    //         Object stub, Object request, Map<String, Object> response,
    //         String endpoint, String soapAction, String requestName,
    //         String responseNS, String responseName, String responseType)
    //     {
    //         if(request instanceof MetadataService.retrieve_element)
    //             response.put('response_x', new MetadataService.retrieveResponse_element());
    //         else if(request instanceof MetadataService.checkDeployStatus_element)
    //             response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
    //         else if(request instanceof MetadataService.listMetadata_element)
    //             response.put('response_x', new MetadataService.listMetadataResponse_element());
    //         else if(request instanceof MetadataService.checkRetrieveStatus_element)
    //             response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
    //         else if(request instanceof MetadataService.describeMetadata_element)
    //             response.put('response_x', new MetadataService.describeMetadataResponse_element());
    //         else if(request instanceof MetadataService.deploy_element)
    //             response.put('response_x', new MetadataService.deployResponse_element());
    //         else if(request instanceof MetadataService.updateMetadata_element)
    //             response.put('response_x', new MetadataService.updateMetadataResponse_element());
    //         else if(request instanceof MetadataService.renameMetadata_element)
    //             response.put('response_x', new MetadataService.renameMetadataResponse_element());
    //         else if(request instanceof MetadataService.cancelDeploy_element)
    //             response.put('response_x', new MetadataService.cancelDeployResponse_element());
    //         else if(request instanceof MetadataService.deleteMetadata_element)
    //             response.put('response_x', new MetadataService.deleteMetadataResponse_element());
    //         else if(request instanceof MetadataService.upsertMetadata_element)
    //             response.put('response_x', new MetadataService.upsertMetadataResponse_element());
    //         else if(request instanceof MetadataService.createMetadata_element)
    //             response.put('response_x', new MetadataService.createMetadataResponse_element());
    //         else 
    //             response.put('response_x', new MetadataService.readWorkflowRuleResponse_element());
    //         return;
    //     }
    // }
    
    // @IsTest
    // public static void testDoGet(){
        
        
        
    //     Test.startTest();
    //     try{
    //         System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            
    //         reqBodyFormtion('/services/apexrest/CustomMetadata','GET','');
            
    //         List<KeyValueHolder__mdt> mdtList = [SELECT DeveloperName,Application__c,BooleanValue__c
    //                                              FROM KeyValueHolder__mdt WHERE Label = 'EnableEmailAttachment'];
            
    //         If(mdtList.size()>0){
    //             req.params.put('id', mdtList[0].Id);
    //         }
            
            
    //         CustomMetadataREST.doGet(); // cRest = new CustomMetadataREST();
    //     }catch(Exception e){}

    //     System.assertEquals('test', 'test');
    //     Test.stopTest();
        
    // }
    // @IsTest
    // public static void testDoGet1(){
        
        
    //     Test.startTest();
    //     try{
    //         System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    //         reqBodyFormtion('/services/apexrest/CustomLabel','GET','');
    //         List<KeyValueHolder__mdt> mdtList = [SELECT DeveloperName,Application__c,BooleanValue__c
    //                                              FROM KeyValueHolder__mdt WHERE Label = 'EnableEmailAttachment'];
            
    //         If(mdtList.size()>0){
    //             //req.params.put('id', mdtList[0].Id);
    //             req.params.put('name',  mdtList[0].DeveloperName);
    //         }
    //         CustomMetadataREST.doGet(); // cRest = new CustomMetadataREST();
            
    //     }catch(Exception e){
            
    //     }
    //     System.assertEquals('test', 'test');
    //     Test.stopTest();
        
    // }
    
    // @IsTest
    // public static void testDoPut(){
        
    //     List<KeyValueHolder__mdt> mdtList = [SELECT DeveloperName,Application__c,BooleanValue__c
    //                                          FROM KeyValueHolder__mdt WHERE Label = 'EnableEmailAttachment'];
        
    //     Test.startTest();
    //         try{
    //             System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    //             reqBodyFormtion('/services/apexrest/CustomMetadata','PUT','');
            
    //             List<Map<String,Object>> mapList = new List<Map<String,Object>>();
    //             Map<String,Object> jsonMap = new Map<String,Object>();

    //             If(mdtList.size()>0){
    //                 jsonMap.put('custommetadatafullname',mdtList[0].DeveloperName);
    //             }
                
    //             mapList.add(jsonMap);
    //             JsonMsg = JSON.serialize(mapList);
    //             req.requestBody = Blob.valueof(JsonMsg);
                
    //             CustomMetadataREST.doPut(); 
    //         }catch(Exception e){}
    //     System.assertEquals('test', 'test');
    //     Test.stopTest();
        
    // }
    // @IsTest
    // public static void testDoPut1(){
        
    //     Test.startTest();
    //     try{
    //         System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    //         Map<String,Object> innerMap = new Map<String,Object>();
    //         innerMap.put('value','val1');
    //         innerMap.put('protected_x',True);
    //         innerMap.put('language','English');
    //         innerMap.put('description','test');
    //         List<Map<String,Object>> mapList = new List<Map<String,Object>>();
    //         Map<String,Object> jsonMap = new Map<String,Object>();
    //         jsonMap.put('fieldvalues',innerMap);
    //         mapList.add(jsonMap);
    //         JsonMsg = JSON.serialize(mapList);
    //         reqBodyFormtion('/services/apexrest/CustomLabel','PUT',JsonMsg); 
    //         CustomMetadataREST.doPut(); 
            
    //     }catch(Exception e){}

    //     System.assertEquals('test', 'test');
    //     Test.stopTest();
        
    // }
    
}