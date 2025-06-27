/*
* CHANGE HISTORY
* =============================================================================
*   Date            Name                            Description
* 15/12/2018      Pankaj Hingane                    Created
* 04/03/2019      Rahul Thange                      Modified and Enhanced
* 04/03/2019      Yogesh Gaikwad                    Reviewed
* =============================================================================
*/

 //Deprecated HighChart using Lightning Standard Charts.

 global with sharing class EnhancedChartCtrl {
    

 	public string chartType{ get;set;}
    public string chartUniqueName {get; set;}
    public string recId {get; set;}
    public String chartId{get; set;}
	public ChartConfig__c chartConfig {get; set;}
    public String filterFieldLabel {get; set;}

	public EnhancedChartCtrl() {}
	
    @RemoteAction
    global static Map<String, Object> getChartData(Map<String, Object> paramMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        return returnMap;
    }
}