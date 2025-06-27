/**
* Class to handle the view of a submission package
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 03/011/2014   Kunal Shah      Created
* =============================================================================
*/
global with sharing class SubmissionPackageViewCtrl {
    
    //Properties
    global ID recordId{get;set;}
            
    global SubmissionPackageViewCtrl(ApexPages.StandardController stdController) {
        recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
    }
    
    /*
        Method to populate the parameters for the FlexTable
    */
    public string getKeyValueMap(){
        Map<String,String> keyValueMap = new Map<String,String>();
        if(recordId != null){
            keyValueMap.put('packageId',recordId);
        }
        return JSON.serialize(keyValueMap);
    }
}