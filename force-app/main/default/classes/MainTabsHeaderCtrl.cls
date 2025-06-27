/*
    Controller for MainTabsHeader component. This component and controller replaces the
    MainTabs component and MainTabsController.
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    02-05-2018		Tomy Pallissery		Created
    04-10-2018		Tomy Pallissery		Modification - Render JSON support for custom app config
    ****************************************************************************************
*/
global with sharing class MainTabsHeaderCtrl {


	global MainTabsHeaderCtrl() {
	}

	@RemoteAction
	global static Map<String, Object> fetchHeaderAndTabsData(Map<String, Object> parameterMap) {

		Map<String, Object> headerDataCollection = new Map<String, Object>();
		return headerDataCollection;
	}

	@RemoteAction
	global static boolean updateUserPreference(boolean sidebar){
		return sidebar;
	}

	/*
		getLogoURLs from MainTabsController renamed to getDeptLogoAndLoggedInfo, logic unchanged
	*/
	@RemoteAction
    global static Map<String, Object> getDeptLogoAndLoggedInfo() {
        Map<String, Object> returnMap = new Map<String, Object>();      
        return returnMap;
    }

    @RemoteAction
	global static string saveCurrentAppName(String appName) {
	     return appName;
	 }
}