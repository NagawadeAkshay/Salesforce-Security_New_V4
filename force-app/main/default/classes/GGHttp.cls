/*  Class is mimic  of Standarad Salesforce Http Class,we can use it with 
    GGHttpRequest to set method,url,endpoint and GGHttpResponse to get the response.Here we log the Callout in  ErrorLog_c Object.
    **********************************************************
    Audit History
    
    **********************************************************
    2017-11-20        Shantanu Gadhe            Created 
    ********************************************************** 
    Example:-GGHttpRequest request = new GGHttprequest().setMethod('GET').setEndPoint('https://example.com/ex');
             GGHttp http = new  GGHttp(request,true);
             GGHttpResponse response = http.send();
*/
global with sharing class GGHttp{ 
    
    global GGHttp(GGHttpRequest request,Boolean flush){
        
    }
    global GGHttpResponse send(){
        return new GGHttpResponse();   
    }
    
}