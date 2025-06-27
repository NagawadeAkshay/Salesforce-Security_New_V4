/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Deprecated HighChart using Lightning Standard Charts.
global with sharing class ChartLineBasicCtrl {
   
    public transient String currentFiscalYear{get;set;} 
    public transient  String defaultPhase{get;set;}
    public transient  String recordId{get;set;}  
    public transient string chartFilterParameters{get;set;}    
   global ChartLineBasicCtrl(){
   }
  
  global static Map<string,Object> fetchInitialData(String chartName,String phaseName,String chartId,boolean isDashboard, String filterClause){
      return null;
  }
  
  global static Map<string,Object> fetchInitDataWithRecordId(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause,string recordId){
      return null;
  }
  @RemoteAction
  global static Map<String, Object> getChartsData(Map<String, Object> paramMap) {
      return null;
  }  
 
}