/*
This class has methods to test FlexTableCtrl.
**********************************************************
Audit History
**********************************************************
Rahul Thange
**********************************************************  
*/
@isTest
private with sharing class PageLayoutBuilderHelperTest{
    @istest
    private static void saveLayoutTest(){
        String objectName = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false, objectName);
        pageLayoutConfig.Description__c = 'Test Desc';
        insert pageLayoutConfig;

        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,false);
        tabConfig.SortOrder__c = 2;
        tabConfig.StandardTabName__c = 'TestTab';
        insert tabConfig;

        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);

        PageLayoutBuilderHelper.Field fld = new PageLayoutBuilderHelper.Field();
        fld.fieldId = pageBlockDetailConfig.Id;
        fld.fieldAPIName = 'Name';
        fld.fieldLabel = 'Name';
        fld.dataType = 'String';
        fld.sortOrder = 1;
        fld.disabled = false;
        fld.level = 1;
        fld.describeInfo = null;
        System.assertEquals(0, fld.compareTo(fld));

        PageLayoutBuilderHelper.PageBlockDetail pbd = new PageLayoutBuilderHelper.PageBlockDetail();
        pbd.pageBlockConfigId = pageBlockConfig.Id;
        pbd.fieldInfo = fld;
        pbd.index = 1;       
        pbd.availableFieldsIndex = 1;
        pbd.fieldId = pageBlockDetailConfig.Id;
        System.assertEquals(0, pbd.compareTo(pbd));
        
        List<PageLayoutBuilderHelper.PageBlockDetail> pbdList = new List<PageLayoutBuilderHelper.PageBlockDetail>();
        pbdList.add(pbd);

        PageLayoutBuilderHelper.PageBlock pb = new PageLayoutBuilderHelper.PageBlock();
        pb.parentId = tabConfig.Id;
        pb.pageBlockId = pageBlockConfig.Id;
        pb.columns = 'Name';
        pb.title = 'TestPageBlock';
        pb.id = pageBlockConfig.Id;
        pb.index = 1;
        pb.pageBlockDetailConfigList = pbdList;
        System.assertEquals(0, pb.compareTo(pb));
        
        List<PageLayoutBuilderHelper.PageBlock> pbList = new List<PageLayoutBuilderHelper.PageBlock>();
        pbList.add(pb);

        PageLayoutBuilderHelper.Tab tab = new PageLayoutBuilderHelper.Tab();
        tab.id = tabConfig.Id;
        tab.index = 1;
        tab.title = 'TestTab';
        tab.pageBlockConfigList = pbList;
        List<PageLayoutBuilderHelper.Tab> tabList = new List<PageLayoutBuilderHelper.Tab>();
        tabList.add(tab);
        System.assertEquals(0, tab.compareTo(tab));

        PageLayoutBuilderHelper.PageLayout layout = new PageLayoutBuilderHelper.PageLayout();
        layout.layoutId = pageLayoutConfig.Id;
        layout.objectAPIName = objectName;
        layout.description = 'Test Desc';
        layout.tabConfigList = tabList;

        PageLayoutBuilderHelper pageLayout = new PageLayoutBuilderHelper();
        System.assertNotEquals(null, PageLayoutBuilderHelper.saveLayout(JSON.serialize(layout)));
        System.assertNotEquals(null, PageLayoutBuilder.saveLayout(JSON.serialize(layout)));
    }
}