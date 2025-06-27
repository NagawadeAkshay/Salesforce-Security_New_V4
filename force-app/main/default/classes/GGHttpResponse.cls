/* Class is mimic of Standarad Salesforce HttpResponse where you access the variables to get the response.
    **********************************************************
    Audit History
    
    **********************************************************
    2017-11-20        Shantanu Gadhe            Created 
    **********************************************************  
*/
global with sharing class GGHttpResponse{
    global String body;
    global Integer statusCode;
    global String status;   
    global boolean isSuccess; 
}