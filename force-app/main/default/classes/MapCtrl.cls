//Deprecated HighChart using Lightning Standard Charts. 
global with sharing class MapCtrl {
    global transient String currentFiscalYear {get;set;}
    global transient String defaultPhase {get;set;}
    global transient String recordId {get;set;}
    global transient string chartFilterParameters {get;set;}
    global transient String chartJSName{get;set;}
    global transient String unmanagedMapResourceUrl {get; set;}
    global transient String recordTypeDeveloperName{get;set;}
    global transient String apexClassName{get;set;}
    global transient String chartSFId{get;set;}
    

    global String chartUniqueName{get;set;}
    
    global MapCtrl() {
    }  
    
    global static Map < string, Object > fetchData(String chartName, String phaseName, String chartId, boolean isDashboard, string filterClause, string recordId) {
        Map < String, Object > resultMap = new Map < String, Object > ();
        return resultMap;
    }
     @RemoteAction
    global static Map<String, Object> getChartsData(Map<String, Object> paramMap) {
        Map<String,Object> resultMap = new Map<String,Object> ();
        return resultMap;
    }

    global static Map < string, Object > fetchInitDataWithRecordId(String chartName, String phaseName, String chartId, boolean isDashboard, string filterClause, string recordId) {
        return null; //
    }

}