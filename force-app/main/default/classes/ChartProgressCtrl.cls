/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Deprecated HighChart using Lightning Standard Charts.
global with sharing class ChartProgressCtrl {
  
	public transient String currentFiscalYear{get;set;} 
	public transient String defaultPhase{get;set;}
	public transient String recordId{get;set;}
    global ChartProgressCtrl(){
    }

    @RemoteAction
    global static Map<string,Object> fetchInitialData(String chartName,String phaseName,String chartId,boolean isDashboard, String filterClause){
       
        Map<String,Object> resultMap = new Map<String,Object> ();
        return resultMap;
    }
    
    @RemoteAction
    global static Map<string,Object> fetchInitDataWithRecordId(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause,string recordId){
        Map<String,Object> resultMap = new Map<String,Object> ();
        return resultMap;
    }
	   
}