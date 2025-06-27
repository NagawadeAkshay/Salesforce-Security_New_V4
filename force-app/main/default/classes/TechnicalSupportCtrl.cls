/**
*  Controller class for the Technical Support component
*
* CHANGE HISTORY
*================================================================ 
* Dated          Name               Description 
* 07/16/2015    Davinder Singh       Created 
* 
*
*================================================================
*/

global with sharing class TechnicalSupportCtrl {
         
   
    global TechnicalSupportCtrl(){
                
    }
    global String phaseNameObj{get;set;}
    
    /*
     *  Returns a list of the  Technical Support links in the phase
     *  @param  name of the current Phase  
     *  @return list of the  URLs with name 
     */
    
    @RemoteAction 
    global static Map<String,Object> getLstTechnicalSupportLink(String phaseNameObj) {
    
        return null;
    }
   
    


    
     @RemoteAction
     global static void updateTechnicalSupportLinkCollapsed(String collapsed){
       
   }
}