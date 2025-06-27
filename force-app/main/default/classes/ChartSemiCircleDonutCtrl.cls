/*
  This class has methods to create charts according to object name.
  **********************************************************
  Audit History
  **********************************************************
  2014-03-25  Manasi Gangal     Created
  **********************************************************  
*/
//Deprecated HighChart using Lightning Standard Charts.
 
global with sharing class ChartSemiCircleDonutCtrl{
    
	public transient String currentFiscalYear{get;set;} 
    public transient String defaultPhase{get;set;}
    public transient String recordId{get;set;}

    global ChartSemiCircleDonutCtrl(){
    }

    global static Map<string,Object> fetchInitialData(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause){
        return null;
    }
    
    global static Map<string,Object> fetchInitDataWithRecordId(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause,string recordId){
        return null;
    }
    @RemoteAction
    global static Map<String, Object> getChartsFilterData(Map<String, Object> paramMap) {
        return null;
    }
}