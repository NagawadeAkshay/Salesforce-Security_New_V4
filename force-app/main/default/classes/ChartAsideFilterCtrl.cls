/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Deprecated HighChart using Lightning Standard Charts.
global with sharing class ChartAsideFilterCtrl {

    public transient String defaultPhase { get; set; }
    public transient  Id userPrefId{get;set;}
    public transient  String retURL{get;set;}
    public transient  Boolean showWrench{get;set;}
    public transient  Boolean enableManageChart{get;set;}
    public transient String namespace{get;set;}
    public static String tableHeader{get;set;}
  
    global ChartAsideFilterCtrl (){}
    @RemoteAction
    global static Map<String, Object> initAsideChartFilterData(String chartName, String phaseName){
    Map<String, Object> retVal = new Map<String, Object>();

        return retVal ;
    }
}