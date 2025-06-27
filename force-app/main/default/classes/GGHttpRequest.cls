/*  Class is mimic of Standard Salesforce HttpRequest class where you can set method,body,headerEndpoint. 
    **********************************************************
    Audit History
    
    **********************************************************
    2017-11-20        Shantanu Gadhe            Created 
    **********************************************************
    Example:-GGHttpRequest request = new GGHttprequest().setMethod('GET').setEndPoint('https://example.com/ex');
*/
global with sharing class GGHttpRequest {
          
    global GGHttpRequest setEndPoint(String url){
        return new GGHttpRequest();
    }
    global String getEndPoint(){
        return null;      
    }
    
    global GGHttpRequest setHeader(String headerKey, String headerValue){  
        return this;
    }
    global Map<String,String> getHeader(){
        return null;
    }
    global String getHeaderKey(){
       return null; 
    }
    global String getHeaderValue(){
       return null; 
    }
    global GGHttpRequest setBody(String body){
        return new GGHttpRequest();
    }
    global String  getBody(){
        return null;       
    }
    global GGHttpRequest setMethod(String method){
        return new GGHttpRequest();
    }
    global String  getMethod(){
        return null;
    }  
}