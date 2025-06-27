/**
* 
* Controller class for the Recently Viewed Objects 
*
* CHANGE HISTORY
*================================================================ 
* Dated          Name               Description  
* 01/30/2014    Vinayak Sharma      Created 
* 02/11/2014    Manasi Gangal       
* 03/29/2018    Atul Naik           Record Type Json Updated..  
* 10/07/2018    Tomy Pallissery     getRecentlyViewedObjects logic moved to new helper => RecentlyViewedHelper  
*================================================================
*/
 
global with sharing class RecentlyViewedCtrl {
    global transient  String phaseNameObj {get;set;}
    public RecentlyViewedCtrl(){}

    @RemoteAction
    global static void updateRecentlyViewedCollapsed(String collapsed){
    }
 
            
    @RemoteAction    
    global static Map<String,Object> getRecentlyViewedObjects(String phaseNameObj) {     
        Map <String,Object> recentlyViewedMap = new  Map <String,Object>(); 
        return recentlyViewedMap; 
    }   

    @RemoteAction
    global static Map<String,Object> fetchMiniLayout (Id referenceId) {
        return MiniLayoutController.getLayout(referenceId);
    }
}