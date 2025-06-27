@isTest
private with sharing class TestMapViewCtrl {
    @isTest
    private static void testMapViewCtrl(){
        User u=TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
            Test.setCurrentPageReference(new PageReference('Page.MapView')); 
            System.currentPageReference().getParameters().put('test','testParameter' );
            MapViewCtrl mvc=new MapViewCtrl();
            //system.assert(MapViewCtrl.executeClass('DashboardApplicationMapHelper',ApexPages.currentPage().getUrl()) != null);
            System.assert(MapViewCtrl.executeClass('GenericMapHelper', ApexPages.currentPage().getUrl()) != null);
            Test.stopTest();
        }
    }
}