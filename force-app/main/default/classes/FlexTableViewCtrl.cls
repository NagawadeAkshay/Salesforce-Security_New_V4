/**
*  Responsible to display any flex table using the request parameters found on the URL.
*
* CHANGE HISTORY
*=========================================================================
* Dated          Name                   Description 
* 03/31/2014     Shah Kadirmohideen     Created
* 
*=========================================================================
*/
global with sharing class FlexTableViewCtrl {
    public String flexTableName {get; set;}
    public String parameterMap {get; set;}
    public String parameterMap1 {get; set;}
    public String ft1 {get;set;}
    public String ft2 {get;set;}


    global FlexTableViewCtrl() {
        loadInputParams();
        ft1 = SFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('ft1'));  //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        ft2 = SFDCEncoder.SFDC_HTMLENCODE(ApexPages.currentPage().getParameters().get('ft2'));   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
    }

    /* PRIVATE METHODS */

    private void loadInputParams() {
        Map<String, String> keyValueMap = new Map<String, String>();
        for (String key : ApexPages.currentPage().getParameters().keySet()) {
            if (key == 'flexTableName') {
                this.flexTableName = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get(key));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            }
            else if(key == 'ownerId') {
                keyValueMap.put(key, UserInfo.getUserId());
            }
            //fetching the phase ID and passing it on as a phaseConfigLayoutId
  
            else {
                keyValueMap.put(key, SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get(key)));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            }
        }
        
        this.parameterMap = JSON.serialize(keyValueMap);
        Map<String,Object> flexTableMergeFieldsMap = new Map<String,Object>();
        flexTableMergeFieldsMap = keyValueMap;    
        this.parameterMap1 =  JSON.serialize(flexTableMergeFieldsMap);
       
    }
}