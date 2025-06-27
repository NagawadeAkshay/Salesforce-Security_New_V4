global with sharing class FeedbackCtrl {
    global transient  boolean showFeedbackComponent {get;set;}
    global transient  boolean adminSetupFlag {get;set;}
    global transient Boolean isGuest {get;set;}
    global FeedbackCtrl(){}


    @RemoteAction
    global static void getImageData(String jsonData){        
    } 

    global static String getImageData(String data, Boolean isFirst, Boolean iFinal, String parentId){
        return null;
    }
    
    @RemoteAction
    global static Map<String, Object> getSystemAlerts() {
        Map<String, Object> returnMap = new Map<String, Object>();
        return returnMap;
    }
}