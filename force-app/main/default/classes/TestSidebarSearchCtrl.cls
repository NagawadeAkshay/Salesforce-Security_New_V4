@isTest
 private with sharing class TestSidebarSearchCtrl{
	@isTest
    private static void setupData(){
        SidebarSearchCtrl obj = new SidebarSearchCtrl();
        obj.phaseNameVal = '';
        SidebarSearchCtrl obj1 = new SidebarSearchCtrl('phaseName');
        Map<String,Object> mapobj = SidebarSearchCtrl.fetchSearchInitialData('phaseName');
        SidebarSearchCtrl.updateSidebarCollapsed('test');
        Map<String,Object> mapobj2 = SidebarSearchCtrl.getTypeAheadRecords ('test','SampleObject2__c');
        system.assertNotEquals(null,obj1);      
    }
    
    @isTest
    static void testgetSidebarSearchIcon(){
        Test.startTest();
        Map<String, String> result = SidebarSearchCtrl.getSidebarSearchIcon();
        Map<String, String> resultLWC = SidebarSearchCtrl.getSidebarSearchIconLwc();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }

  }