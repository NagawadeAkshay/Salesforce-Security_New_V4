global with sharing class FormLayoutsCtrl {
   

    public FormLayoutsCtrl() {
    
    }
 
    @RemoteAction
    global static Map<String,Object> fetchPreviewData(String layoutId,String pageBlockId, String packageId) {        
        Map<String, Object> returnMap = new Map<String, Object>();
        return returnMap;
    }

    global static Map<String,Object> validateForm(String recordId, String packageId, String formId, Boolean isLast) {
        return null;
    }
    
    global static Map<String,Object> validateForm(String recordId, String packageId, String formTypeStr) {
        return new Map<String, Object>();
    }
    
    //validate form
    @RemoteAction
    global static Map<String,Object> validateForm(String recordId, String packageId, String formTypeStr, Map<String, Object> paramMap) {
        return new Map<String, Object>();    
    }
    
    @RemoteAction
    global static Map<String, Object> getLayouts (String layoutId, String recordId, String pageBlockId, String packageId, String formTypeStr) {
        return new Map<String, Object>();
    }
}