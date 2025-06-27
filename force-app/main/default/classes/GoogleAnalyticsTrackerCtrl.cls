public with sharing class GoogleAnalyticsTrackerCtrl {
	public transient Boolean enableTracking {get; private set;}
	public transient String trackerId {get; private set;}
	public transient Boolean enableGoogleTagMgr {get; set;}
	public transient String tagMangerId {get;set;} 
	public GoogleAnalyticsTrackerCtrl() {
		//UserPreferences__c pref = UserPreferences__c.getInstance(UserInfo.getProfileId());

		//string namespacedEnableTracker = AppUtils.applyNameSpacePrefix('GoogleAnalyticsEnableTracker__c');
		//string namespacedTrackerId = AppUtils.applyNameSpacePrefix('GoogleAnalyticsTrackerId__c');


		//enableTracking =  pref.get(namespacedEnableTracker) == null ? false : Boolean.valueOf(pref.get(namespacedEnableTracker));
		//trackerId = pref.get(namespacedTrackerId) == null ? '' : String.valueOf(pref.get(namespacedTrackerId));

		// Key Value Store Helper....
		trackerId = String.escapeSingleQuotes(KeyValueStoreHelper.getTextValue('GoogleAnalyticsId', true) == null ? '' : KeyValueStoreHelper.getTextValue('GoogleAnalyticsId', true));
		enableTracking = KeyValueStoreHelper.getBooleanValue('EnableGoogleAnalytics', true) == null ? false : KeyValueStoreHelper.getBooleanValue('EnableGoogleAnalytics', true);

		// Key Value Store Helper Google Tag Manger........
		enableGoogleTagMgr = KeyValueStoreHelper.getBooleanValue('EnableGTM',true) == null ? false : KeyValueStoreHelper.getBooleanValue('EnableGTM', true);
		tagMangerId = KeyValueStoreHelper.getTextValue('GTMId', true) == null ? '' : KeyValueStoreHelper.getTextValue('GTMId', true);
	}
}