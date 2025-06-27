@isTest
private with sharing class TestSidebarMenuCtrl{
    @isTest
    private static void setupData(){
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pageLayout.id, true);
        SidebarMenuCtrl obj = new SidebarMenuCtrl();
        obj.tabId = tab.id;
        obj.parameterMap = '';
    	obj.type = 'test';
    	obj.icon = 'test';    
    	obj.hideSidebar = 'test';
        SidebarMenuCtrl obj1 = new SidebarMenuCtrl(tab.id,null,'test','test');
        Map<string,object> testMap = SidebarMenuCtrl.fetchAccordionData(tab.name,null,'test','test');            
        SidebarMenuCtrl.updateUserPreference(true,null ,null);    
         system.assertNotEquals(null,obj1);      
    }

}