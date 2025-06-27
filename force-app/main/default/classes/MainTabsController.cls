/*
    This controller is used to construct Top Level Custom Salesforce Tabs for GovGrants.
    **********************************************************
    Audit History
    **********************************************************
    2/20/2014   Jag Valaiyapathy      Created
    09/05/2018  This class has been deprecated - 5th September 2018
    **********************************************************  
*/
global with sharing class MainTabsController {
   
   
    //public String userDeptLogoImage{get;set;}
    global MainTabsController () { }
    
    
    //This remote Call is used to store App Name in a cookie
     global static string saveCurrentAppName(String appName){ return null;}
      

    
    global static void updateUserPreference(boolean isCollapsed){ }
    
    // get different logos like - Dept, app, orgnization.
    // Currently added support only for Dept logo. Need to add others as well
    // This method will also return logged in user attempts and allowed attempts
    global static Map<String, String> getLogoURLs() { return null; }
   
}