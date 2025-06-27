/*
  This class has methods to fetch the Sidebar menu from the related objects and and persist the user preference for sidebar menu.
  *************************************************************
  Audit History
  *************************************************************
  2014-01-30  Manasi Gangal     Created
  2015-01-08  William Moore     Added PhaseId to fetchAccordionData result
  2015-03-10  William Moore   Change line 206 to use the created object instead of recreating it
  **********************************************************  
*/

global with sharing class SidebarMenuCtrl{
    global transient string tabId {get;set;}
    global transient  string parameterMap{get;set;}
    global transient  string type{get;set;}
    global String icon {get;set;}
    
    global String hideSidebar {get;set;}

    global SidebarMenuCtrl(String tabId,String parameterMap,string type, String hiddenSidebar){
       
        }        
    global SidebarMenuCtrl(){
        
        }    
             
           
            
 
    /*This method is used to fetch acccordion data to be displayed */
    @RemoteAction
    global static Map<string,object> fetchAccordionData(String tabName,String paramMap,string type, String hiddenSidebar) {
            
        return null;
    }
    
    /* This method upates User Preference custom setting to sava the collapsed and the expanded accordion values*/
    @RemoteAction
    global static void updateUserPreference(boolean accordionCollapsed,List<String> expandedArray ,List<String> collapsedArray){
    

    }
   

}