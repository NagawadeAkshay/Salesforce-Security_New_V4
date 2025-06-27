@RestResource(urlMapping='/AutomationAPI/*')
global with sharing class AutomationAPI {
    public with sharing class AutomationAPIException extends Exception {}
 
    @HttpGet
    global static void doGet() {
        process(RestContext.request);
    }

    @HttpPost
    global static void doPost(){
        process(RestContext.request);
    }

    @HttpDelete
    global static void doDelete(){
        process(RestContext.request);
    }

    static void process(RestRequest request){
    }

}