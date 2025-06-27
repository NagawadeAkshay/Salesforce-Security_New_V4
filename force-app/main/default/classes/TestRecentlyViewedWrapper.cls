@isTest
public class TestRecentlyViewedWrapper {	
 @isTest
    private static void seupData(){
        RecentlyViewedWrapper obj = new RecentlyViewedWrapper();
        SampleObject1__c so1 = TestHelper.getSampleObject1Val(true);
        Id recordId =  so1.id;
        String strName = 'test';
        String strRecordTypeDevloperName = 'test';
        RecentlyViewedWrapper obj1 = new RecentlyViewedWrapper(recordId,strName,strRecordTypeDevloperName,null);
        DateTime lastViewedDate = Datetime.newInstance(2020, 6, 6);
        RecentlyViewedWrapper obj2 = new RecentlyViewedWrapper(recordId,strName,strRecordTypeDevloperName,null,lastViewedDate);
        system.assertNotEquals(null,obj); 
        system.assertNotEquals(null,obj1); 
        system.assertNotEquals(null,obj2); 
    }
}