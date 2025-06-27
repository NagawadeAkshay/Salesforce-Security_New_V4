/**
*  Controller class for the External links component
*
* CHANGE HISTORY
*================================================================ 
* Dated          Name               Description 
* 01/30/2014    Vinayak Sharma      Created 
* 
*
*================================================================
*/

global with sharing class ExternalLinksCtrl {
         
    global ExternalLinksCtrl(){}
    global String phaseNameObj{get;set;}

    @RemoteAction 
    global static Map<String,Object> getLstExternalLink(String phaseNameObj) {
        Map<String,Object> externalLinkData = new Map<String,Object>();
        return externalLinkData;
    }
    
    @RemoteAction
    global static void updateExternalLinkCollapsed(String collapsed){
   }
}