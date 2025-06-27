/**
 * Created by Aniket on 9/22/2020.
 */

@isTest
private class TestCollabNavigator {
    @IsTest
    public static void setup1(){
        PageReference urlRef;
        PageReference currentURL = new PageReference('_ui/core/chatter/ui/ChatterPage');
        Test.startTest();
        CollabNavigator obj = new CollabNavigator();
        urlRef = obj.mapRequestUrl(currentURL);
        List<PageReference> lst = new List<PageReference>();
        List<PageReference> lstResult = obj.generateUrlFor(lst);
        Test.stopTest();
        System.assertEquals(lstResult,lst);
    }
}