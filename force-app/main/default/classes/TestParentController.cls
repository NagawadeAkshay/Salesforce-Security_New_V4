/**
 **********************************************************************************
 Audit History
 *********************************************************************************
 4-28-2014          Hafsa Syed          Created
 **********************************************************************************
 */
@isTest
private class TestParentController {

    @IsTest(OnInstall=false)
    private static void testParentCtrl() {
        
        Test.startTest();
        ApexPages.currentPage().getHeaders().put('User-Agent','MSIE 10.0');
        ParentController PCtrl = new ParentController();
        PCtrl.makeIECompatible();
        String searchtext = PCtrl.getSearchText();
        Boolean isempty = PCtrl.getDisplaySearchResult();
        String searchkey = PCtrl.getSearchKeyValueMap();
        List<String> searchObj = new List<String>();
        ApexPages.currentPage().getParameters().put('searchObject','Account,Contact');
        searchObj  = PCtrl.getSearchObjects();
        Test.stopTest();
        System.assertnotEquals(null, PCtrl);
    }
}