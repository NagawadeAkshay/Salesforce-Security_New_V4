/**
* Extend this class if you like to provide any custom behavior for a 
* chart. Then implemented class name
* should be entered on Chart Config object.
*   
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 11/1/2018    Pankaj Hingane      Created
* =============================================================================
*/
 //Deprecated High using Lightning Standard Charts.
global abstract with sharing class EnhancedChartLoad {
    
    /*
        The following variable is populated by chart controller .
    */
    global Id recordId;
    
    /*
        Key Value pairs of url parameters which were used to display the flex table
    */
    global Map<String, String> keyValMap = new Map<String, String>();
    
    /*
        Key Value pairs of merge fields which were used to generate dynamic query
    */
    global Map<String, String> mergeFieldkeyValMap = new Map<String, String>();
    
    /*
        Key Value pairs of url parameters which were used to display the flex table
    */
    global Map<String, Object> listMap = new Map<String, Object>();

    /*
        The config to get data
    */
    global ChartConfig__c actionConfig;
         
    global abstract String getChartJSON();
  //  global EnhancedChartLoad(){
        
  //  }
    global abstract Map<String, Object> getChartTableData();


}