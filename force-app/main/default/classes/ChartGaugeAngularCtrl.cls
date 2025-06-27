/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Deprecated HighChart using Lightning Standard Charts.
global with sharing class ChartGaugeAngularCtrl {

    public String currentFiscalYear{get;set;} 
    public String defaultPhase{get;set;}
    public String recordId{get;set;}
    global ChartGaugeAngularCtrl(){
    }
    
    @RemoteAction
    global static Map<string,Object> fetchInitialData(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause){
        return null;
    }
    
     @RemoteAction
    global static Map<string,Object> fetchInitDataWithRecordId(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause,string recordId){
        return null;
    }
}