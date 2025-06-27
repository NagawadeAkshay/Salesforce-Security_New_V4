@isTest
private class GoogleAnalyticsTrackerCtrlTest {
    @isTest
    static void verifyGoogleAnalyticsTrackerCtrl(){
        GoogleAnalyticsTrackerCtrl obj = new GoogleAnalyticsTrackerCtrl();
        System.assertNotEquals(null, obj.trackerId);
        System.assertNotEquals(null, obj.enableTracking);
        System.assertNotEquals(null, obj.enableGoogleTagMgr);
        System.assertNotEquals(null, obj.tagMangerId);
    }
}