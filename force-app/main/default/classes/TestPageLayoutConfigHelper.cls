@isTest
private with sharing class TestPageLayoutConfigHelper  {
    static CustomApp__c custApp;
    @IsTest
    public static void testAllTabs()
    {
        //arrange
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pageLayout.id, true);   
        
        tab = [Select Name From TabConfig__c Where Id = :tab.Id];
        ApexPages.CurrentPage().getParameters().put('tabName',tab.Name);
       
        PageBlockConfig__c block =TestHelper.getPageBlockConfig(tab.id, false);
        block.BodyColumns__c = '2';
          Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Map').getRecordTypeId();
          block.RecordTypeId = recTypeId ;
        insert block;
        
      
        PageBlockDetailConfig__c pbd = TestHelper.getPageBlockDetailConfig(block.id,false);
        pbd.RenderCondition__c = 'Test equals test AND Test equals test';
        insert pbd;
        if(custApp == null) {
            custApp = TestHelper.getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayout.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                                        ViewLayoutConfig__c=pageLayout.Id,PrintLayoutConfig__c = pageLayout.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',ParentObjectFieldAPI__c = AppUtils.getNamespacePrefix()+'SampleObject11__c',
                                         RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
                                         
        ApexPages.CurrentPage().getParameters().put('id',pbd.Id);
        
        String name = [select name,HideDecisionField__c,HideforQueue__c from  TabConfig__c where id = :tab.id].name;
        
        Test.startTest();
        Picklist__c pl = new Picklist__c();
        pl.DisplayValue__c = 'test';
        pl.GroupName__c = 'MyAlrts';
        pl.Sort__c = 0;
        pl.Value__c= '0';
        pl.name=  'rest';
        insert pl;
        Picklist__c pl2 = new Picklist__c();
        pl2.DisplayValue__c = 'test';
        pl2.GroupName__c = 'MyAlrts';
        pl2.Sort__c = 1;
        pl2.Value__c= '0';
        pl2.name=  'rest2';
        insert pl2;
        DynamicFieldConfigData__mdt cs = new DynamicFieldConfigData__mdt();
        cs.DisplayField__c = 'DisplayValue__c';
        cs.Name__c = 'Picklist__c';        
        cs.ReturnField__c = 'Value__c';
        cs.SortField__c = 'Sort__c';
        cs.Type__c = 'Multiselect';
        cs.Object__c = 'Picklist__c';
        cs.WhereClause__c = 'GroupName__c = \'MyAlrts\'';
        //insert cs;
        
        PageLayoutConfigHelper.AlternativeRendering ctrl_inner = new PageLayoutConfigHelper.AlternativeRendering(cs);
        selectOption opt = new selectOption('returnValue', 'displayValue');       
        Object sortValue = cs.SortField__c;
        PageLayoutConfigHelper.Tab ctrl_inner_2 = new PageLayoutConfigHelper.Tab();
        PageLayoutConfigHelper.pageTemplate = template;
        ctrl_inner_2.bodyColumnSize = 10;
        List<List<PageLayoutConfigHelper.pageblock>> foramttedPageBlocks = new List<List<PageLayoutConfigHelper.pageblock>>();
       
        foramttedPageBlocks = ctrl_inner_2.getFormattedPageBlocks();
        
        PageLayoutConfigHelper ctrl = new PageLayoutConfigHelper(pageLayout.ID,name,true);
        PageLayoutConfigHelper ctrl1 = new PageLayoutConfigHelper(pageLayout.ID,name,false);
        System.assertNotEquals(null, ctrl.getTabLayoutConfig());
        System.assertNotEquals(null, ctrl1.getTabLayoutConfig());
        
        ctrl = new PageLayoutConfigHelper(pageLayout.ID, true);
        System.assertNotEquals(null, ctrl.getTabLayoutConfig());
        ctrl1 = new PageLayoutConfigHelper(pageLayout.ID, false);
        System.assertNotEquals(null, ctrl1.getTabLayoutConfig());
        new PageLayoutConfigHelper(pageLayout.ID,true,false, true);
        new PageLayoutConfigHelper(pageLayout.ID,false,true, false);
       // new PageLayoutConfigHelper().loadFullLayout(pageLayout.ID,false);
       // new PageLayoutConfigHelper().loadFullLayout(pageLayout.ID,true);
        Test.stopTest();
        System.assert(ctrl != null);
        
    }
  
    
    @IsTest
    public static void testAlternativeRendering()
    {
        //arrange
        String ns = AppUtils.getNameSpacePrefix();
        DynamicFieldConfigData__mdt altRen = new DynamicFieldConfigData__mdt(
                Name__c = 'test',
                Type__c = 'Radio',
                DisplayField__c = ns+'TabName__c',
                Object__c = ns+'PhaseConfig__c',
                ReturnField__c = ns+'Sequence__c'
        );
        //insert altRen;
        
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pageLayout.id, true);
        TabConfig__c tab2 = TestHelper.getTabConfig(pageLayout.id, true);
        
        PageBlockConfig__c block = TestHelper.getPageBlockConfig(tab.id, true);
        PageBlockDetailConfig__c pbDetail = TestHelper.getPageBlockDetailConfigFieldSet(block.id, false);
        pbDetail.AltRenderingConfig__c = altRen.Name__c;
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        pbDetail.RecordTypeId = recTypeId;
        insert pbDetail;
        
        if(custApp == null) {
            custApp = TestHelper.getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayout.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                                        ViewLayoutConfig__c=pageLayout.Id,PrintLayoutConfig__c = pageLayout.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',ParentObjectFieldAPI__c = AppUtils.getNamespacePrefix()+'SampleObject11__c',
                                         RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
                                         
        
                                        
        String name = [SELECT name FROM TabConfig__c WHERE id = :tab.id].name;
        
        //act
        Test.startTest();
        PageLayoutConfigHelper.pageTemplate = template;
        PageLayoutConfigHelper helper = new PageLayoutConfigHelper(pageLayout.Id, false, true, false);
        //Set<String> tester = helper.getAPINames();
        PageLayoutConfigHelper.Field testField = new PageLayoutConfigHelper.Field();
        DynamicFieldConfigData__mdt cs = new DynamicFieldConfigData__mdt();
        PageLayoutConfigHelper.AlternativeRendering testAlterRender  = new PageLayoutConfigHelper.AlternativeRendering(cs);
        String APIName = testField.getFieldAPIName();
        testField.setFieldAPIName('Name');
        String fildexp = testField.getFieldExpression();
        String AdjustedFieldAPIName = testField.getAdjustedFieldAPIName();
        String AdjustedObjectAPIName = testField.getAdjustedObjectAPIName();        
        List<List<PageLayoutConfigHelper.PageBlock>> testBlock = new List<List<PageLayoutConfigHelper.PageBlock>>();
         Test.stopTest();
        //assert
        System.assert(AdjustedFieldAPIName != null);
    }
    
     @IsTest
    public static void testLoadFields()
    {
        //arrange
        String ns = AppUtils.getNameSpacePrefix();
        DynamicFieldConfigData__mdt altRen = new DynamicFieldConfigData__mdt(
                Name__c = 'test',
                Type__c = 'Radio',
                DisplayField__c = ns+'TabName__c',
                Object__c = ns+'PhaseConfig__c',
                ReturnField__c = ns+'Sequence__c'
        );
       // insert altRen;
        
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pageLayout.id, true);
        TabConfig__c tab2 = TestHelper.getTabConfig(pageLayout.id, true);
        
        PageBlockConfig__c block = TestHelper.getPageBlockConfig(tab.id, false);
        RecordType rt = [Select Id From RecordType Where Name='Field Set' LIMIT 1];
        block.RecordType = rt;
        insert block;
        PageBlockDetailConfig__c pbDetail = TestHelper.getPageBlockDetailConfigFieldSet(block.id, false);
        pbDetail.AltRenderingConfig__c = altRen.Name__c;
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        pbDetail.RecordTypeId = recTypeId;
        insert pbDetail;
        
        if(custApp == null) {
            custApp = TestHelper.getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayout.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                                        ViewLayoutConfig__c=pageLayout.Id,PrintLayoutConfig__c = pageLayout.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',ParentObjectFieldAPI__c = AppUtils.getNamespacePrefix()+'SampleObject11__c',
                                         RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
                                         
        String name = [SELECT name FROM TabConfig__c WHERE id = :tab.id].name;
        
        //act
        Test.startTest();
        PageLayoutConfigHelper.pageTemplate = template;
        PageLayoutConfigHelper helper = new PageLayoutConfigHelper(pageLayout.Id, false, true, false);
        //Set<String> tester = helper.getAPINames();
        PageLayoutConfigHelper.Field testField = new PageLayoutConfigHelper.Field();
        DynamicFieldConfigData__mdt cs = new DynamicFieldConfigData__mdt();
        PageLayoutConfigHelper.AlternativeRendering testAlterRender  = new PageLayoutConfigHelper.AlternativeRendering(cs);
        String APIName = testField.getFieldAPIName();
        testField.setFieldAPIName('Name');
        String fildexp = testField.getFieldExpression();
        String AdjustedFieldAPIName = testField.getAdjustedFieldAPIName();
        String AdjustedObjectAPIName = testField.getAdjustedObjectAPIName();        
        List<List<PageLayoutConfigHelper.PageBlock>> testBlock = new List<List<PageLayoutConfigHelper.PageBlock>>();
        Test.stopTest();
        
        //assert
        System.assert(AdjustedFieldAPIName != null);
    }
    
    
 
    
}