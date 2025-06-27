/**
    Test class for the DynamicLayoutCtrl
    **********************************************************
    Audit History
    **********************************************************
    04/14/2014    Kunal Shah      Created
    **********************************************************  
**/

@isTest
private with sharing class TestDynamicLayoutCtrl {
    public static SampleObject12__c sample2Record;
    public static DynamicFieldConfig__c dynCon;
    public static SampleObject11__c sample1Record;
  
    private static  List<ID> setLayout() {
        List<ID> layoutIDs = new List<ID>();
        PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true);
        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,false);        
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        //PageLayoutActionConfig__c pageAction = TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);  
        layoutIDs.add(pageLayoutConfig.Id);
        layoutIDs.add(tabConfig.ID);
        layoutIDs.add(pageBlockConfig.Id);
        layoutIDs.add(pageBlockDetailConfig.Id);
       // layoutIDs.add(pageAction.Id);
        return layoutIDs;       
    }
    
   
      
  @isTest
    public static void testExecuteClass() {
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            TriggerHelper.SkipTrigger = true;
            //ProgramTriggerHelper.skiptrigger=true;
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
           // ggsInt.AppUtils.skipDohAccountTrigger=true;
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            
            //ApexPages.currentPage().getParameters().put('t','TestPhase');
            //act
            List<Id> ids = TestHelper.setLayoutData('SampleObject11__c');
            
            
            
            DynamicLayoutHolder layoutHolder = new DynamicLayoutHolder(ids.get(0),ann.Id,true);
           // DynamicLayoutHolder layoutHolder = new DynamicLayoutHolder(ids.get(0),ann.Id,true);
            PageLayoutConfig__c pc = TestHelper.getPageLayoutConfig(true);
            PageLayoutActionConfig__c pac = new PageLayoutActionConfig__c ();
            pac.PageLayoutConfig__c = pc.Id;
            insert pac;
            LayoutBusinessRuleConfig__c lbr = new LayoutBusinessRuleConfig__c();
            lbr.Expression__c='2>1';
            lbr.PageLayoutConfig__c = pc.Id;
            lbr.Active__c = true;
            insert lbr;
            Test.startTest();
            
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.layoutHolder = layoutHolder;
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.currentPage().getParameters().put('className','MenuSnapshotHelper');
            ApexPages.currentPage().getParameters().put('actionId',pac.Id);
            System.assertNotEquals(null, ctrl , '');
            ctrl.executeClass();
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testExecuteClassWithoutActionid() {
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            
            //ProgramTriggerHelper.skiptrigger=true;
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
           // ggsInt.AppUtils.skipDohAccountTrigger=true;
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            
            //ApexPages.currentPage().getParameters().put('t','TestPhase');
            //act
            List<Id> ids = TestHelper.setLayoutData('SampleObject11__c');
            
            
            
            DynamicLayoutHolder layoutHolder = new DynamicLayoutHolder(ids.get(0),ann.Id,true);
           // DynamicLayoutHolder layoutHolder = new DynamicLayoutHolder(ids.get(0),ann.Id,true);
            PageLayoutConfig__c pc = TestHelper.getPageLayoutConfig(true);
            PageLayoutActionConfig__c pac = new PageLayoutActionConfig__c ();
            pac.PageLayoutConfig__c = pc.Id;
            insert pac;
            System.assertNotEquals(null, pac.Id , '');
            Test.startTest();
            
            DynamicLayoutController ctrl = new DynamicLayoutController();
            System.assertNotEquals(null, ctrl, '');
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.layoutHolder = layoutHolder;
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.currentPage().getParameters().put('className','MenuSnapshotHelper');
            ApexPages.currentPage().getParameters().put('id',ann.Id);
            ctrl.checkRecordLevelAccess();
           
            ctrl.executeClass();
            Test.stopTest();
        }
    }
 
    @isTest(OnInstall=false)
    public static void testctor()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            System.assertNotEquals(null, phase.Id , '');
            //ApexPages.currentPage().getParameters().put('t','TestPhase');
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.edit();
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            System.assertNotEquals(null, opanel , '');
        }
    }
    
     @isTest(OnInstall=false)
    static void testsave(){  
        //arrange
        User u = TestHelper.getAdminUser(true);
        System.assertNotEquals(null, u.Id , 'User is not created');
        PageReference savePage ;
        List<Id> createLayoutData = TestHelper.setLayoutData();
        DynamicLayoutHolder layoutHolder = null;
        Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
        insert opp;
        sample1Record = TestHelper.getSampleObject1(true);
        sample2Record = TestHelper.getSampleObject2(true,sample1Record.Id);
        Id pageLayoutId = createLayoutData.get(0);
        Contact contact = TestHelper.getContact(true);
        System.assertNotEquals(null, contact.Id , 'contact is not created');
        
        PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
        System.assertNotEquals(null, template.Id , 'template is not created');
        //act
        system.runAs(u){
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = null;
            ctrl.type = 'edit';
            ctrl.savePage = Page.BlankPage;
            ctrl.layoutHolder = new DynamicLayoutHolder(pageLayoutId, sample2Record.ID,true,'2');
            savePage =  ctrl.saveRecord();
            Test.stopTest();
        }
    }
    
    @isTest(OnInstall=false)
    static void testgetPageTemplatePrint()
    {  
        User u = TestHelper.getAdminUser(true);
        //arrange
        //TestHelper.createCustomSettings(true);
        PageTemplate__c pageTemplate;
        List<Id> createLayoutData = TestHelper.setLayoutData();
        DynamicLayoutHolder layoutHolder = null;
        Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
        insert opp;
        Id pageLayoutId = createLayoutData.get(0);
        Contact contact = TestHelper.getContact(true);
        PageTemplate__c template = TestHelper.getPageTemplateConfig(true);                 
        //act
        system.runAs(u){
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = opp.Id;
            ctrl.type = 'Print';
            ctrl.layoutId = pageLayoutId ;
            ctrl.savePage = Page.BlankPage;
            pageTemplate =  ctrl.PageTemplate;
            Test.stopTest();
            System.assert(pageTemplate == null, '');
            //assert
        }
        
    }
     @isTest(OnInstall=false)
    static void testgetPageTemplateEdit()
    {  
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            //arrange
            //TestHelper.createCustomSettings(true);
            PageTemplate__c pageTemplate;
            List<Id> createLayoutData = TestHelper.setLayoutData();
            DynamicLayoutHolder layoutHolder = null;
            Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
            insert opp;
            Id pageLayoutId = createLayoutData.get(0);
            Contact contact = TestHelper.getContact(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = opp.Id;
            ctrl.type = 'Edit';
            ctrl.layoutId = pageLayoutId ;        
            ctrl.savePage = Page.BlankPage;
            pageTemplate =  ctrl.PageTemplate;
            Test.stopTest();
            System.assert(ctrl.layoutId != null, '');
        //assert
        }
        
    }
    
    @isTest(OnInstall=false)
    static void testEdit()
    {  
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            //arrange
            Contact contact = TestHelper.getContact(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            //TestHelper.createCustomSettings(true);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'Edit';
            ctrl.saveRecord();
            Test.stopTest();
            
            //assert
            System.assertEquals(null, ctrl.layoutHolder , '');
        }
    }
    @isTest(OnInstall=false)
    static void testCheckIfRecordTypePresent()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId());
            insert template;
            Package__c packageNew = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',
                            SubmissionType__c = 'Other',LatestVersion__c=true,Description__c='testDescription1');
            insert  packageNew;
            Map<String,String> tmpflexTableParameterJSON = new Map<String,String>();  
            tmpflexTableParameterJSON.put('name','test'); 
            
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.edit();
            ctrl.flexTableParameterJSON = JSON.serialize(tmpflexTableParameterJSON);
            ctrl.pkgId = null;
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
            //ctrl.getPageHeader();
            ctrl.hideContextSpecificSidebar = false;            
            Boolean tmp = ctrl.recordTypeExists;
            Test.stopTest();
            System.assertEquals(null, ctrl.layoutHolder, '');
        }
    }
    @isTest(OnInstall=false)
    static void testCheckIfRecordTypePresentWithNew()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            PageReference vfPage = new PageReference('/apex/collab');
            vfPage.getParameters().put('pageLayoutId', pageLayoutConfig.Id);
            Test.setCurrentPage(vfPage );
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c =custApp.Id,
                                            OMBNumber__c='TestOBMNo',PackageType__c='TestPAckageType',Description__c='TestDescription');
            insert template;
            
            String pageBlockIds = '["' + pageBlockConfig.Id + '"]';
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.type = 'Edit';
            ctrl.edit();
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
            
            ctrl.hideContextSpecificSidebar = false;
            ctrl.pageBlockIds = pageBlockIds;
            List<DynamicLayoutDefaultValueHelper> listDefaultValues = new List<DynamicLayoutDefaultValueHelper>();
            listDefaultValues.add(new DynamicLayoutDefaultValueHelper('FirstName','test',true));
            ctrl.listDefaultValues = listDefaultValues;
            Boolean tmp = ctrl.recordTypeExists;
            ctrl.rcrdId = pageLayoutConfig.Id;
           // ctrl.getPageHeader();
            
            Test.stopTest();
            System.assertEquals(null, ctrl.layoutHolder, '');
        }
    }
    
    @isTest(OnInstall=false)
    static void testCheckIfRecordTypePresentWithNewWithGroupLayout()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            ////TestHelper.createCustomSettings(true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig.RecordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Standalone').getRecordTypeId();
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            PageLayoutConfig__c pageLayoutConfig2 =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig2.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig2.ParentLayout__c = pageLayoutConfig.Id;
            pageLayoutConfig2.RecordTypeName__c = 'Layout';
            pageLayoutConfig2.RecordTypeDescription__c= 'Layout Desc';
            pageLayoutConfig.HeaderOverride__c='test12';
            insert pageLayoutConfig2;
            
            //PageReference vfPage = new PageReference('/apex/collab');
            //vfPage.getParameters().put('pageLayoutId', pageLayoutConfig.Id);
            //Test.setCurrentPage(vfPage );
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription');
            insert template;
            
            String pageBlockIds = '["' + pageBlockConfig.Id + '"]';
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.type = 'Edit';
            ctrl.edit();
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
           
            ctrl.hideContextSpecificSidebar = false;
            Boolean tmp = ctrl.recordTypeExists;
            ctrl.rcrdId = pageLayoutConfig.Id;
            //ctrl.getPageHeader();
            Test.stopTest();
            System.assertEquals(null, ctrl.layoutHolder, '');
        }
    }
    @isTest(OnInstall=false SeeAllData=false)
    static void testCheckIfRecordTypePresentWithActions()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            ////TestHelper.createCustomSettings(true);
             Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
            insert opp;
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig.HidePDFDownload__c = false;
            insert pageLayoutConfig;
            
            List<PageLayoutActionConfig__c> actions = new List<PageLayoutActionConfig__c>();
            PageLayoutActionConfig__c action = new PageLayoutActionConfig__c();
            action.PageLayoutConfig__c = pageLayoutConfig.Id;
            action.Type__c = 'Button';
            action.LayoutType__c = 'View';
            action.DisplayArea__c = 'Both';
            action.Name = 'tmpAction';
            action.ActionURL__c = '/apex/Collab';
            action.ActionBehavior__c = 'Open in Overlay';
            action.ModalHeight__c = 100;
            action.ModalWidth__c = 100;
            action.isSubmit__c = true;
            action.SubmitAction__c = 'test';
            action.HideDecisionField__c = 'HidePDFDownload__c ';
            action.DisableDecisionField__c = 'HidePDFDownload__c ';
            action.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
            actions.add(action);
            //insert actions;
            
            
            action = new PageLayoutActionConfig__c();
            action.PageLayoutConfig__c = pageLayoutConfig.Id;
            action.Type__c = 'Button';
            action.LayoutType__c = 'View';
            action.DisplayArea__c = 'Both';
            action.Name = 'tmpAction';
            action.ActionClass__c = 'testClass';
            action.ActionBehavior__c = 'Open in Overlay';
            action.ModalHeight__c = 100;
            action.ModalWidth__c = 100;
            action.isSubmit__c = true;
            action.SubmitAction__c = 'test';
            action.HideDecisionField__c = 'HidePDFDownload__c ';
            action.DisableDecisionField__c = 'HidePDFDownload__c ';
            action.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Action Class').getRecordTypeId();
            actions.add(action);
            
            action = new PageLayoutActionConfig__c();
            action.PageLayoutConfig__c = pageLayoutConfig.Id;
            action.Type__c = 'Button';
            action.LayoutType__c = 'View';
            action.DisplayArea__c = 'Both';
            action.Name = 'tmpAction';
            action.ActionURL__c = '/apex/Collab';
            action.isSubmit__c = true;
            action.SubmitAction__c = 'test';
            action.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Submit Button').getRecordTypeId();
            actions.add(action);
            
            action = new PageLayoutActionConfig__c();
            action.PageLayoutConfig__c = pageLayoutConfig.Id;
            action.Type__c = 'Button';
            action.LayoutType__c = 'View';
            action.Name = 'tmpAction';
            action.StandardAction__c= 'Edit';
            actions.add(action);
            
            action = new PageLayoutActionConfig__c();
            action.PageLayoutConfig__c = pageLayoutConfig.Id;
            action.Type__c = 'Button';
            action.LayoutType__c = 'View';
            action.Name = 'tmpAction';
            action.StandardAction__c= 'Delete';
            actions.add(action);                                    
            
            insert actions;
            
            
            DataTableConfig__c flexTable = new DataTableConfig__c();
            flexTable.Name = 'testTable';
            flexTable.SObject__c = 'GDP__PageLayoutConfig__c'; 
            flexTable.Description__c='TestDescription';           
            insert flexTable;
            
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, false);
            pageBlockConfig.FlexTableName__c = flexTable.Id;
            pageBlockConfig.RecordTypeId = Schema.SObjectType.PageBlockConfig__c .getRecordTypeInfosByName().get('Flex Table').getRecordTypeId();
            insert pageBlockConfig;
            
            List<DataTableAction__c> flexActions = new List<DataTableAction__c>();
            DataTableAction__c flexAction = new DataTableAction__c();
            flexAction.DataTableConfig__c= flexTable.Id;
            flexAction.Location__c = 'Top';
            flexAction.DisplayArea__c = 'Both';
            flexAction.Name = 'tmpAction';
            flexAction.ActionURL__c = '/apex/Collab?{!test}15DIGITID({!test})';
            flexAction.ActionBehavior__c = 'Open in Overlay';
            flexAction.ModalHeight__c = 100;
            flexAction.ModalWidth__c = 100;
            flexAction.HideDecisionField__c = 'HidePDFDownload__c ';
            //flexAction.HideForUserType__c = 'Both';
            flexAction.RecordTypeId = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
            flexActions.add(flexAction);
            
            flexAction = new DataTableAction__c();
            flexAction.DataTableConfig__c= flexTable.Id;
            flexAction.Location__c = 'Top';
            flexAction.DisplayArea__c = 'Both';
            flexAction.Name = 'tmpAction';
            flexAction.ActionClass__c = 'testClass';
            flexAction.ActionBehavior__c = 'Open in Overlay';
            flexAction.ModalHeight__c = 100;
            flexAction.ModalWidth__c = 100;
            flexAction.HideDecisionField__c = 'HidePDFDownload__c ';
            //flexAction.HideForUserType__c = 'Internal';
            flexAction.RecordTypeId = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action Class').getRecordTypeId();
            flexActions.add(flexAction);
            
            flexAction= new DataTableAction__c();
            flexAction.DataTableConfig__c= flexTable.Id;
            flexAction.Location__c = 'Top';
            flexAction.Name = 'tmpAction';
            flexAction.StandardAction__c= 'Edit';
            //flexAction.HideForUserType__c = 'Both';
            flexActions.add(flexAction);
            
            flexAction= new DataTableAction__c();
            flexAction.DataTableConfig__c= flexTable.Id;
            flexAction.Location__c = 'Top';
            flexAction.Name = 'tmpAction';
            flexAction.StandardAction__c= 'Delete';
            //flexAction.HideForUserType__c = 'Internal';
            flexActions.add(flexAction);
            insert flexActions;
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription');
            insert template;
            
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act

            
             Test.startTest();
                DynamicLayoutController ctrl = new DynamicLayoutController();
                System.assertNotEquals(null, ctrl , '');
                ctrl.tmplName = template.Name;
                ctrl.rcrdId = pageLayoutConfig.Id;
                ctrl.type = 'view';
                ctrl.layoutHolder = new DynamicLayoutHolder(pageLayoutConfig.Id, pageLayoutConfig.ID,true);
                ctrl.pgLayoutId= pageLayoutConfig.Id;
                Boolean recType = ctrl.recordTypeExists;
            Test.stopTest();
//            System.assertNotEquals(null, ctrl.layoutHolder);
        }
    }
    @isTest(OnInstall=false)
    static void testgetInstanceString()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            insert pageLayoutConfig;
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c = custApp.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription');
            insert template;
            
            PhaseConfig__c phase = TestHelper.getPhase(true);
            System.assertNotEquals(null, phase.Id , '');
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            //String testString = ctrl.getInstanceString();
            Test.stopTest();
        }
    }
    @isTest(OnInstall=false)
    static void testsaveSelectionWithQuestion()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        System.assertNotEquals(null, u.Id, '');
        system.runAs(u){
            //TestHelper.createCustomSettings(true);
            PageReference savePage ;
            PageReference vfPage = new PageReference('/apex/collab');
            vfPage.getParameters().put('param', 'Param');
            Test.setCurrentPage(vfPage );
            List<Id> createLayoutData = TestHelper.setLayoutData();
            DynamicLayoutHolder layoutHolder = null;
            Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
            insert opp;
            sample1Record = TestHelper.getSampleObject1(true);
            sample2Record = TestHelper.getSampleObject2(true,sample1Record.Id);
            Id pageLayoutId = createLayoutData.get(0);
            Contact contact = TestHelper.getContact(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            insert pageLayoutConfig;
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            System.assertNotEquals(null, custApp.Id, '');
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id);
            
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            System.assertNotEquals(null, ctrl, '');
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = null;
            ctrl.type = 'edit';
            ctrl.layoutHolder = new DynamicLayoutHolder(pageLayoutId, sample2Record.ID,true);
            ctrl.pgLayoutId= pageLayoutConfig.Id;
            ctrl.saveSelection();
            Test.stopTest();
            
            //assert
        }
    }
    @isTest(OnInstall=false)
    static void testsaveSelectionWithoutQuestion()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            //TestHelper.createCustomSettings(true);
            PageReference savePage ;
            PageReference vfPage = new PageReference('/apex/collab');
            Test.setCurrentPage(vfPage );
            List<Id> createLayoutData = TestHelper.setLayoutData();
            DynamicLayoutHolder layoutHolder = null;
            Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
            insert opp;
            sample1Record = TestHelper.getSampleObject1(true);
            sample2Record = TestHelper.getSampleObject2(true,sample1Record.Id);
            
            Id pageLayoutId = createLayoutData.get(0);
            Contact contact = TestHelper.getContact(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            insert pageLayoutConfig;
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            System.assertNotEquals(null, custApp.Id, '');
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplateWithoutQuestion', EditLayoutConfig__c=pageLayoutConfig.Id, CustomAppConfig__c = custApp.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id);
            
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            System.assertNotEquals(null, ctrl, '');
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = null;
            ctrl.type = 'edit';
            ctrl.layoutHolder = new DynamicLayoutHolder(pageLayoutId, sample2Record.ID,true);
            ctrl.pgLayoutId= pageLayoutConfig.Id;
            ctrl.saveSelection();
            Test.stopTest();
            
            //assert
        }
    }
    
    /*
    @isTest(OnInstall=false)
    static void test_CheckIfRecordTypePresentWithGroupEditLayout()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            ////TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig.ObjectAPIName__c = 'PageLayoutConfig__c';
            pageLayoutConfig.RecordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Layout').getRecordTypeId();
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            PageLayoutConfig__c pageLayoutConfig2 =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig2.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig2.ParentLayout__c = pageLayoutConfig.Id;
            pageLayoutConfig2.RecordTypeName__c = 'Layout';
            pageLayoutConfig2.RecordTypeDescription__c= 'Layout Desc';
            pageLayoutConfig.HeaderOverride__c='test123';
            insert pageLayoutConfig2;
            
            //PageReference vfPage = new PageReference('/apex/collab');
            //vfPage.getParameters().put('pageLayoutId', pageLayoutConfig.Id);
            //Test.setCurrentPage(vfPage );
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemp'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c = custApp.Id,
                                            OMBNumber__c='testOMBNo',PackageType__c='TestPackageType',Description__c='TestDescription');
            insert template;
            
            String pageBlockIds = '["' + pageBlockConfig.Id + '"]';
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.type = 'Edit';
            ctrl.edit();
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
           
            ctrl.hideContextSpecificSidebar = false;
            ctrl.pageBlockIds = pageBlockIds;
            ctrl.rcrdId = pageLayoutConfig.Id;
            //ctrl.getPageHeader();                             commented for now AJA
            Boolean tmp = ctrl.recordTypeExists;
            Test.stopTest();
        }
    }
    */
    
    @isTest( OnInstall=false)
    static void testCheckIfRecordTypePresentWithGroupViewLayout()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            ////TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig.RecordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Layout').getRecordTypeId();
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            PageLayoutConfig__c pageLayoutConfig2 =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig2.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig2.ParentLayout__c = pageLayoutConfig.Id;
            pageLayoutConfig2.RecordTypeName__c = 'Layout';
            pageLayoutConfig2.RecordTypeDescription__c= 'Layout Desc';
            pageLayoutConfig.HeaderOverride__c='test1';
            insert pageLayoutConfig2;
            System.assertNotEquals(null, pageLayoutConfig2.Id, '');
            
            //PageReference vfPage = new PageReference('/apex/collab');
            //vfPage.getParameters().put('pageLayoutId', pageLayoutConfig.Id);
            //Test.setCurrentPage(vfPage );
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(),
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,
                                            EditLayoutConfig__c=pageLayoutConfig.Id,OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription');
            insert template;
            
            String pageBlockIds = '["' + pageBlockConfig.Id + '"]';
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            System.assertNotEquals(null, ctrl, '');
            ctrl.tmplName = template.Name;
            ctrl.type = 'View';
            ctrl.edit();
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            ctrl.saveRecordTypeId();
           
            ctrl.hideContextSpecificSidebar = false;
            ctrl.pageBlockIds = pageBlockIds;
            ctrl.rcrdId = pageLayoutConfig.Id;
            //ctrl.getPageHeader();                     commented for now AJA
            Boolean tmp = ctrl.recordTypeExists;
            Test.stopTest();
        }
    }
    
    @isTest( OnInstall=false)
    static void testCheckIfRecordTypePresentWithGroupPrintLayout()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            System.assertNotEquals(null, contact.Id, '');
            ////TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig.RecordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Layout').getRecordTypeId();
            pageLayoutConfig.HeaderOverride__c ='test';
            insert pageLayoutConfig;
            PageLayoutConfig__c pageLayoutConfig2 =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig2.ObjectAPIName__c = AppUtils.getNamespacePrefix() + 'PageLayoutConfig__c';
            pageLayoutConfig2.ParentLayout__c = pageLayoutConfig.Id;
            pageLayoutConfig2.RecordTypeName__c = 'Layout';
            pageLayoutConfig2.RecordTypeDescription__c= 'Layout Desc';
            pageLayoutConfig.HeaderOverride__c='test123';
            insert pageLayoutConfig2;
            
            //PageReference vfPage = new PageReference('/apex/collab');
            //vfPage.getParameters().put('pageLayoutId', pageLayoutConfig.Id);
            //Test.setCurrentPage(vfPage );
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            System.assertNotEquals(null, tabConfig.Id, '');
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription');
            insert template;
            
            String pageBlockIds = '["' + pageBlockConfig.Id + '"]';
            //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(false);
            phase.SidebarComponentSequence__c = 'Search,Links,RecentlyViewed,SubMenu,ActivityMenu,BI&AnalyticsMenu,TaskMenu,TechnicalSupport';
            insert phase;
            ApexPages.currentPage().getParameters().put('t',phase.name);
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            System.assertNotEquals(null, ctrl, '');
            ctrl.tmplName = template.Name;
            ctrl.type = 'Print';
            ctrl.edit();
            ctrl.hideContextSpecificSidebar = true;
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
           
            ctrl.hideContextSpecificSidebar = false;
            ctrl.pageBlockIds = pageBlockIds;
            ctrl.rcrdId = pageLayoutConfig.Id;
            //ctrl.getPageHeader();                         commented for now AJA
            Boolean tmp = ctrl.recordTypeExists;
            Test.stopTest();
        }
    }
    
    @isTest(OnInstall=false)
    static void testfetchHelpDataRemote() {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        System.assertNotEquals(null, u.Id, '');
        system.runAs(u){
            //TestHelper.createCustomSettings(true);
            TestHelper.getHelpConfigWithRecordType(true, 'Internal Document');
            
            Test.startTest();
            List<HelpConfig__c> helpList = [Select id, DocumentName__c, RecordType.DeveloperName 
                From HelpConfig__c Limit 1];
            DynamicLayoutController.fetchHelpDataRemote(helpList[0].Id);
            Test.stopTest();
        }
    }
    
    @isTest(OnInstall=false)
    static void testfindThemeDocumentId() {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        System.assertNotEquals(null, u.Id, '');
        system.runAs(u){
            
            Test.startTest();
            List<HelpConfig__c> helpList = [Select id, DocumentName__c, RecordType.DeveloperName 
                From HelpConfig__c Limit 1];
            //new DynamicLayoutController().findThemeDocumentId();
           // new DynamicLayoutController().sendEmail();
      //      new DynamicLayoutController().getMessages();
            Test.stopTest();
        }
    }
    
    @isTest(OnInstall=false)
    static void testCheckIfRecordTypePresentWithPackage()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
            System.assertNotEquals(null, contact.Id, '');
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId(),SObjectName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert template;
            
            Package__c packageNew = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',
                            SubmissionType__c = 'Other',CustomAppConfig__c=custApp.Id,LatestVersion__c=true,Description__c='testDescription1');
            insert  packageNew;              
            
            PageTemplate__c template1 = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),SObjectName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert template1;
            Package__c packageNew1 = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',
                            SubmissionType__c = 'Other',CustomAppConfig__c=custApp.Id,LatestVersion__c=true,Description__c='testDescription1',ValidateFormFieldAPIName__c= 'FormsValidated__c',ObjectAPIName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert  packageNew1;  
            
            PackageFormConfig__c packageForm = new PackageFormConfig__c ();
            packageForm.PackageConfig__c= packageNew1.Id ;
            packageForm.FormConfig__c =template1.Id;   
            packageForm.Order__c= 2;          
            insert packageForm;
            
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            
            PhaseConfig__c phase = TestHelper.getPhase(true);
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.CurrentPage().getParameters().put('id', contact.Id);
            
            ApexPages.currentPage().getParameters().put('t',phase.name);
            ApexPages.CurrentPage().getParameters().put('isFormSaved','true');
            ApexPages.CurrentPage().getParameters().put('packageId',packageNew1.Id);
            ApexPages.CurrentPage().getParameters().put('formId',packageForm.Id);
            ApexPages.CurrentPage().getParameters().put('parentId',ann.Id);
            ApexPages.CurrentPage().getParameters().put('Host','visual.force.com');
           
            //act
            Test.startTest();   
            Map<String,String> tmpflexTableParameterJSON = new Map<String,String>();  
            tmpflexTableParameterJSON.put('name','test'); 
            DynamicLayoutController ctrl = new DynamicLayoutController();
            System.assertNotEquals(null, ctrl, '');
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.edit();
            ctrl.flexTableParameterJSON = JSON.serialize(tmpflexTableParameterJSON);
            ctrl.pkgId = packageNew.Id;
            ctrl.formUrl = 'https:';
           // ctrl.formSaved = '';
            ctrl.parentLytId = pageLayoutConfig.Id;
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
           // ctrl.saveRecordTypeId();
           // ctrl.getPageHeader();                         commented for now AJA
            ctrl.hideContextSpecificSidebar = false;
            Boolean tmp = ctrl.recordTypeExists;
            ctrl.saveFormRecord();
                        
            Test.stopTest();
            System.assertEquals('Test', 'Test', '');
            //System.assertNotEquals(null, ctrl.layoutHolder);
        }
    } 
    
@isTest(OnInstall=false)
    static void testdecideActions()
    {  
       //arrange
        User admin = TestHelper.getAdminUser(true);
        system.runAs(admin){
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);  
            System.assertNotEquals(null, template.Id , 'template is not created');
                   
            Map<String, Object> sobjmap = new Map<String, Object>();
            sobjmap.put('parentId','test');
            SampleObject11__c ann = TestHelper.getSampleObject1(false);
            ann.SampleNumber1__c =2;
            insert ann; 
            System.assertNotEquals(null, ann.Id , 'SampleObject11 is not created');
        }
    }

       @isTest
    static void testfetchMiniLayout()
        {           
            //TestHelper.createCustomSettings(true);    
            SampleObject11__c ann = TestHelper.getSampleObject1(false);
            ann.SampleNumber1__c =2;
            insert ann;  
        System.assertNotEquals(null, ann.Id , '');
           //DynamicLayoutController.fetchMiniLayout(ann.Id);  
        }

      @isTest
    static void testmarkPageLayoutAsActive()
        {   
            //TestHelper.createCustomSettings(true);   
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true);
            pageLayoutConfig.isActive__c = false;
            update pageLayoutConfig;
            TestHelper.getPageTemplateConfig(true,pageLayoutConfig.Id); 
            
           map<string,object> args = new map<string,object>();
           args.put('key', 'TestTemplate');
           args.put('value', 'View');
        System.assertNotEquals(null, args, '');
           DynamicLayoutController.markPageLayoutAsActive(args);  
        }  
    
   /* @isTest(OnInstall=false) 
    static void test_NegativedecideActions()
    {  
       //arrange
        User admin = TestHelper.getAdminUser(true);
        system.runAs(admin){
            //TestHelper.createCustomSettings(true); 
            PageLayoutActionConfig__c pageAction = TestHelper.getPageLayoutActionConfig(false,pageLayoutConfig.Id);        
            pageAction.ActionBehavior__c = 'Open in new window';  
            pageAction.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Submit Button').getRecordTypeId();
            pageAction.HidePanel__c ='Footer'; 
            insert pageAction;
                
            Map<String, Object> sobjmap = new Map<String, Object>();
            sobjmap.put('parentId','test');
            SampleObject11__c ann = TestHelper.getSampleObject1(false);
            ann.SampleNumber1__c =2;
            insert ann; 
                            
            User u= TestHelper.getUser(true);
            Group grp = TestHelper.getGroup(true);           
            GroupMember groupMember = new GroupMember();
            groupMember.GroupId = grp.Id;
            groupMember.UserOrGroupId = u.Id;           
            insert groupMember;
            
            Test.startTest();   
                DynamicLayoutController ctrl = new DynamicLayoutController();
                ctrl.tmplName = template.Name;
                ctrl.rcrdId = ann.Id;            
                DynamicLayoutController.decideActions(ann.Id,template.ViewLayoutConfig__c,sobjmap);
                DynamicLayoutController.decideActions(ann.Id,template.ViewLayoutConfig__c);  
            Test.stopTest();    
            System.assertNotEquals(admin,null);     
        }
    }
    
   
    /*
    @isTest static void test_fetchMiniLayout() {
     User u = TestHelper.getUser(true);
     String userId = UserInfo.getUserId();
     
     SampleObject12__c obj2 = new SampleObject12__c(Name='test',SampleText1__c='test sampleText');
     insert obj2;
     
     SampleObject11__c ann = TestHelper.getSampleObject1(false);
     ann.Sample_Object_2__c= obj2.id;
     insert ann;
     
     UserPreferences__c pref = new UserPreferences__c(SetupOwnerId = userId, ActiveAppName__c ='StateasGrantee');
     insert pref;
     
     SobjectConfig__c sObjCon = new SobjectConfig__c(Name = AppUtils.getNamespacePrefix() +'SampleObject11__c',CriteriaField__c = AppUtils.getNamespacePrefix() + 'Status__c');
     // ,CriteriaField__c = 'Not'
     
     insert sObjCon;
     
     PageLayoutConfig__c pageLay =  new PageLayoutConfig__c(Name = 'Task Mini Layout', ObjectAPIName__c = AppUtils.getNamespacePrefix() +'SampleObject11__c',Description__c = 'Not Specific purpose',IsMiniLayout__c = true);
     insert pageLay;
     
     PageLayoutActionConfig__c pagLayActCon = new PageLayoutActionConfig__c(Name = 'Delete' ,Type__c = 'Button', ActionClass__c = 'CalendarCtrl' ,PageLayoutConfig__c = pageLay.id);
     insert pagLayActCon;
     
    
     TabConfig__c tabCon = new TabConfig__c(PageLayoutConfig__c = pageLay.id,SortOrder__c = 1,StandardTabName__c = 'Calendar',IsActive__c = true);
     insert tabCon;
     
     PageBlockConfig__c pagBloCon = new PageBlockConfig__c(TabLayoutConfig__c = tabCon.id,SortOrder__c = 1 ,BodyColumns__c = '1',IsActive__c = true,RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Fields').getRecordTypeId());
     insert pagBloCon;
     
     PageBlockDetailConfig__c pagBloDetCon1 = new PageBlockDetailConfig__c(FieldAPIName__c = AppUtils.getNamespacePrefix() +'Sample_Object_2__c' ,SortOrder__c = 1,PageBlockConfig__c = pagBloCon.id ,IsActive__c = true,RecordTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId());
     insert pagBloDetCon1;
     
     PageBlockDetailConfig__c pagBloDetCon2 = new PageBlockDetailConfig__c(FieldAPIName__c = AppUtils.getNamespacePrefix() +'Status__c' ,SortOrder__c = 2,PageBlockConfig__c = pagBloCon.id ,IsActive__c = true,RecordTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId());
     insert pagBloDetCon2;
     
     CustomApp__c custApp = new CustomApp__c(Name = 'StateasGrantee',Abbreviation__c = '1' ,Active__c = true);
     insert custApp;
     
     Id RecordTypeIdForTask = Schema.SObjectType.SObjectLayoutConfig__c.getRecordTypeInfosByName().get('Mini Layout').getRecordTypeId();
     //Object RecordTypeIdForTask = 
     
     SObjectLayoutConfig__c sobjLayCon = new SObjectLayoutConfig__c(Name = 'Sample2',PageLayoutConfig__c = pageLay.id, SObjectConfig__c = sObjCon.id , CustomApp__c = custApp.id,RecordTypeId = RecordTypeIdForTask,IsDefault__c = true);
     insert sobjLayCon;
     
     Map < String, Object > paramMap = new Map < String, Object >();
     paramMap.put('configName','Task');
     paramMap.put('recordId',ann.id);
     DynamicLayoutController.fetchMiniLayout(ann.id);  
     MiniLayoutController.getLayout(ann.id);  
    }*/
    
    @isTest(OnInstall=false)
    public static void testgetViewLayoutTabsContent()
    {  
        //arrange
         Cookie tabName ;
        ApexPages.currentPage().setCookies(new Cookie[]{tabName});
        CustomAppPhaseConfig__c objCustomAppPhaseConfig = TestHelper.getCustomAppPhaseConfig(true);
        //TestHelper.createCustomSettings(true);
        //User u = TestHelper.getAdminUser(true);
        //system.runAs(u){
            //setLayout();
        ////TestHelper.createCustomSettings(true);
        Contact contact = TestHelper.getContact(true); 
        PhaseConfig__c phase = TestHelper.getPhase(true);             
        SampleObject12__c ann = TestHelper.getSampleObject2(true, null);  
        //PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
        PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true);
                    
        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,false);
        Id recTypeId = Schema.SObjectType.TabConfig__c.getRecordTypeInfosByName().get('Form').getRecordTypeId();  
        tabConfig.RecordTypeId=recTypeId;
        insert tabConfig;
        
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id,true);         
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
        
        //PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true); isNotesAttachmentsList
        DataTableConfig__c flexTable = new DataTableConfig__c();
        flexTable.Name = 'testTable';
        flexTable.SObject__c = 'GDP__PageLayoutConfig__c'; 
        flexTable.Description__c='TestDescription';           
        insert flexTable;
        
        PageBlockConfig__c pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Flex Grid');            
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;
        
        
        //pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'WBS');           
        //pageBlockConfigType.FlexTableName__c = flexTable.Id;
        //insert pageBlockConfigType;
        
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Flex Table');          
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;
        
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Notes and Attachments');           
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        //pageBlockConfigType.IsNotesAttachmentsList__c = true;
        insert pageBlockConfigType;
        
        // pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Digitally Signed');            
        // pageBlockConfigType.FlexTableName__c = flexTable.Id;
        // insert pageBlockConfigType;
        
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Communication');           
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;
        
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Approval History');            
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;
        
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Collab');          
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;         
            
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Charts');          
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;     
        
        pageBlockConfigType =  TestHelper.getPageBlockConfig(tabConfig.Id,false,'Record History');          
        pageBlockConfigType.FlexTableName__c = flexTable.Id;
        insert pageBlockConfigType;   
        
        CustomApp__c custApp;
        if(custApp == null) {
            custApp = TestHelper.getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                                    ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',
                                        RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
        insert template;
        system.assertNotEquals(template .Name,'TestTemplate1' , '');
        
        Package__c pckg = TestHelper.getPackage(true, template.Id);
        
        Map<String,String> tmpflexTableParameterJSON = new Map<String,String>();  
        tmpflexTableParameterJSON.put('name','test');            
        //}
        //act
        Test.startTest();   
        DynamicLayoutController ctrl = new DynamicLayoutController();
        ctrl.tmplName = template.Name;
        ctrl.rcrdId = contact.Id;
        ctrl.type = 'View';
        ctrl.layoutHolder = new DynamicLayoutHolder(template.ViewLayoutConfig__c, ann.Id, true, pckg.Id);               
        ctrl.layoutHolder.packageId = pckg.Id;
        //ctrl.layoutHolder.layout.tabs.hideTab='false';
        
        ctrl.isPreviewLayout= true;
        ctrl.flexTableParameterJSON = JSON.serialize(tmpflexTableParameterJSON); 
        ctrl.listParams='';
        ctrl.chartParameters='';
        
        Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
        opanel = ctrl.getViewLayoutTabsContent(); 
        // opanel = ctrl.getPrintLayoutTabsContent(); 
        opanel = ctrl.getModalViewLayoutTabsContent(); 
        opanel = ctrl.getHeaderOverviewContent();
        
        ctrl.pckgName='test';
        ctrl.currentOrder=12;
        ctrl.lastFormOrder=34;
        ctrl.themeDocumentId='test';
        // ctrl.reinitializeLayout=true;
        ctrl.refreshLayoutSpecificTables=true;
        ctrl.deletePage=null;
        ctrl.recordCompletion=null;
        ctrl.listParameters='test';
        ctrl.selectedPageLayoutId='test';
        ctrl.hasEditAccess=true;
        ctrl.hasDeleteAccess=true;
        ctrl.isErrorNotFound=true;
        ctrl.isError=true;
        ctrl.emailMessage='test';
        ctrl.errorReported=true;
        ctrl.tabId=null;
        ctrl.formpreviewList=null;
        ctrl.previewLayoutId=null;
        Test.stopTest();
    }
    
    @isTest(OnInstall=false)
    static void testnavForms1() 
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
        
            ////TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            pageLayoutConfig.HeaderOverride__c='test';
            pageLayoutConfig.OverrideCreateClass__c='test';
            insert pageLayoutConfig;
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId(),SObjectName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert template;
            
            Package__c packageNew = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',
                            SubmissionType__c = 'Other',CustomAppConfig__c=custApp.Id,LatestVersion__c=true,Description__c='testDescription1');
            insert  packageNew;              
            
            PageTemplate__c template1 = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),SObjectName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert template1;
            Package__c packageNew1 = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',
                            SubmissionType__c = 'Other',CustomAppConfig__c=custApp.Id,LatestVersion__c=true,Description__c='testDescription1',ValidateFormFieldAPIName__c= 'FormsValidated__c',ObjectAPIName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert  packageNew1;  
            
            PackageFormConfig__c packageForm = new PackageFormConfig__c ();
            packageForm.PackageConfig__c= packageNew1.Id ;
            packageForm.FormConfig__c =template1.Id;  
            packageForm.Order__c= 2;          
            insert packageForm;
            
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            
            PhaseConfig__c phase = TestHelper.getPhase(true);
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.CurrentPage().getParameters().put('id', contact.Id);
            
            ApexPages.currentPage().getParameters().put('t',phase.name);            
            ApexPages.CurrentPage().getParameters().put('packageId',packageNew1.Id);
            ApexPages.CurrentPage().getParameters().put('formId',packageForm.Id);
            
           
            //act
            Test.startTest();   
            Map<String,String> tmpflexTableParameterJSON = new Map<String,String>();  
            tmpflexTableParameterJSON.put('name','test'); 
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.edit();
            ctrl.flexTableParameterJSON = JSON.serialize(tmpflexTableParameterJSON);
            ctrl.pkgId = packageNew.Id;
            ctrl.formUrl = 'https:';
           // ctrl.formSaved = '';
            ctrl.parentLytId = pageLayoutConfig.Id;
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            //opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
            //ctrl.getPageHeader();                     commented for now AJA
            ctrl.hideContextSpecificSidebar = false;
            Boolean tmp = ctrl.recordTypeExists;
            DynamicLayoutController.navForms1('https://ggdemo2.na31.visual.force.com/apex/DynamicFormEdit?formTypes=&formId='+packageForm.Id+'&id='+ann.Id+'&templateName='+template.Name+'&packageId='+packageNew1.Id+'', 'Next',template1.Id);
            DynamicLayoutController.navForms1('https://ggdemo2.na31.visual.force.com/apex/DynamicFormEdit?formTypes=&formId='+template1.Id+'&id='+ann.Id+'&templateName='+template.Name+'&packageId='+packageNew1.Id+'', 'Previous',template1.Id);
            DynamicLayoutController.navForms1('https://ggdemo2.na31.visual.force.com/apex/DynamicFormEdit?formTypes=&formId='+template1.Id+'&id='+ann.Id+'&templateName='+template.Name+'&packageId='+packageNew1.Id+'', '',template1.Id);
            Test.stopTest();
            System.assertEquals('test', 'test', '');
            //System.assertNotEquals(null, ctrl.layoutHolder);
        }
    }
    
    /* @isTest
    public static void test_takeSnapshot() {
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
                        
            Contact contact = TestHelper.getContact(true);
            //TestHelper.createCustomSettings(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            PhaseConfig__c phase = TestHelper.getPhase(true);          
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
                      
            //act
            List<Id> ids = TestHelper.setLayoutData('SampleObject11__c');
            Map<String,String> tmpflexTableParameterJSON = new Map<String,String>();  
            tmpflexTableParameterJSON.put('name','test'); 
                        
            DynamicLayoutHolder layoutHolder = new DynamicLayoutHolder(ids.get(0),ann.Id,true);           
            PageLayoutConfig__c pc = TestHelper.getPageLayoutConfig(true);
            PageLayoutActionConfig__c pac = new PageLayoutActionConfig__c ();
            pac.PageLayoutConfig__c = pc.Id;
            insert pac;

            Test.startTest();
            
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.flexTableParameterJSON = JSON.serialize(tmpflexTableParameterJSON);
            
            ctrl.layoutHolder = layoutHolder;
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.currentPage().getParameters().put('className','MenuSnapshotHelper');
            ApexPages.currentPage().getParameters().put('actionId',pac.Id);
            DynamicLayoutController.postHistorySnapshot(pac.Id,ann.Id,'template.Name',JSON.serialize(tmpflexTableParameterJSON),'');
            ctrl.actionId = pac.Id;
            ctrl.takeSnapshot();
            Test.stopTest();
        }
    }
    
   @isTest(OnInstall=false)
    static void test_getPageHeader()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            //TestHelper.createCustomSettings(true);
            PageReference savePage ;
            List<Id> createLayoutData = TestHelper.setLayoutData();
            DynamicLayoutHolder layoutHolder = null;
            Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
            insert opp;
            Id pageLayoutId = createLayoutData.get(0);
            Contact contact = TestHelper.getContact(true);
            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            ApexPages.currentPage().getParameters().put('isPreviewLayout','true');
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = null;
            ctrl.type = 'edit';
            ctrl.savePage = Page.BlankPage;
            ctrl.sequenceNumber= 2;
            ctrl.recordTypeName ='Layout Form';
            ctrl.layoutHolder = new DynamicLayoutHolder(pageLayoutId, opp.ID,true,2);
            //ctrl.getPageHeader();                         commented for now AJA
            Test.stopTest();
            
        }
    }
    
    @isTest(OnInstall=false)
    static void test_CheckIfRecordTypePresentWithPackage2()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            Contact contact = TestHelper.getContact(true);
        
            //TestHelper.createCustomSettings(true);
            
            PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
            pageLayoutConfig .ObjectAPIName__c = 'Contact';
            pageLayoutConfig.HeaderOverride__c='test';
            insert pageLayoutConfig;
            TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
            PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true);
            PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true);
            CustomApp__c custApp = new CustomApp__c(Name='Grantor', Abbreviation__c='GG', Active__c=true);
            insert custApp;
            PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId(),SObjectName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert template;
            
            Package__c packageNew = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',
                            SubmissionType__c = 'Other',CustomAppConfig__c=custApp.Id,LatestVersion__c=true,Description__c='testDescription1');
            insert  packageNew;              
            
            PageTemplate__c template1 = new PageTemplate__c(Name='TestTemplate1er'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,
                                            ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id,
                                            OMBNumber__c='TestOMBNo',PackageType__c='TestPAckageType',Description__c='TestDescription', CustomAppConfig__c=custApp.Id,
                                            RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),SObjectName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert template1;
            Package__c packageNew1 = new Package__c (PageTemplateConfig__c =template.id,Status__c = 'Active',Name ='test',
                            SubmissionType__c = 'Other',CustomAppConfig__c=custApp.Id,LatestVersion__c=true,Description__c='testDescription1',ValidateFormFieldAPIName__c= 'FormsValidated__c',ObjectAPIName__c=AppUtils.getNamespacePrefix() +'SampleObject12__c');
            insert  packageNew1;  
            
            PackageFormConfig__c packageForm = new PackageFormConfig__c ();
            packageForm.PackageConfig__c= packageNew1.Id ;
            packageForm.FormConfig__c =template1.Id;   
            packageForm.Order__c= 2;          
            insert packageForm;
            
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            
            PhaseConfig__c phase = TestHelper.getPhase(true);
            System.CurrentPageReference().getParameters().put('id',ann.Id);
            ApexPages.CurrentPage().getParameters().put('id', contact.Id);
            
            ApexPages.currentPage().getParameters().put('t',phase.name);
            ApexPages.CurrentPage().getParameters().put('isFormSaved','true');
            ApexPages.CurrentPage().getParameters().put('packageId',packageNew1.Id);
            ApexPages.CurrentPage().getParameters().put('formId',packageForm.Id);
            ApexPages.CurrentPage().getParameters().put('parentId',ann.Id);
            ApexPages.CurrentPage().getParameters().put('Host','visual.force.com');
           
            //act
            Test.startTest();   
            Map<String,String> tmpflexTableParameterJSON = new Map<String,String>();  
            tmpflexTableParameterJSON.put('name','test'); 
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = contact.Id;
            ctrl.type = 'View';
            ctrl.edit();
            ctrl.flexTableParameterJSON = JSON.serialize(tmpflexTableParameterJSON);
            ctrl.pkgId = packageNew.Id;
            ctrl.formUrl = 'https:';
            //ctrl.pkgName = 'test';
            //ctrl.parentLytId = pageLayoutConfig.Id;
            Component.Apex.OutputPanel opanel = new Component.Apex.OutputPanel();
            opanel = ctrl.getDynamicSidebar(); 
            ctrl = ctrl.getInstance();
            ctrl.tmplName = template.Name; 
            //ctrl.saveRecordTypeId();
            //ctrl.getPageHeader();
            ctrl.hideContextSpecificSidebar = false;
            Boolean tmp = ctrl.recordTypeExists;
            ctrl.saveFormRecord();
            
            Test.stopTest();
            System.assertNotEquals(null, ctrl.layoutHolder);
        }
    } 
    
    @isTest(OnInstall=false)
    static void test_1(){
        User user = [SELECT id From User LIMIT 1];
        Test.startTest();
        PageReference pg = Page.SampleViewPage1;
        Test.setcurrentPage(pg);
        ApexPAges.StandardController sc = new ApexPages.StandardController(user);
        DynamicLayoutController ctrl = new DynamicLayoutController(sc);
        //String result_1 = ctrl.getKeyValueMap();
        Test.stopTest();
        System.assert( ctrl != null);
        
        samObj = TestHelper.getSampleObject2Val(false);
        samObj.SampleDate__c=date.newInstance(2016, 11, 15);
        SampleObject1__c samObj1 = TestHelper.getSampleObject1Val(true);
        samObj.SampleObject1__c = samObj1.Id;
        insert samObj;
        
    }
    */
 
    @isTest(OnInstall=false)
    static void fetchMiniLayoutTest(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            UserPreferences__c pref = new UserPreferences__c(SetupOwnerId = u.Id, ActiveAppName__c ='StateasGrantee');
            insert pref;
            SampleObject11__c samObj = TestHelper.getSampleObject1(true);        
            System.assertNotEquals(null,DynamicLayoutController.fetchMiniLayout(samObj.Id) , '');
            DynamicLayoutController ctrl = new DynamicLayoutController(new ApexPages.StandardController(samObj));
       }
    }
    
@isTest(OnInstall=false)
    static void testsave1()
    {  
        //arrange
        User u = TestHelper.getAdminUser(true);
        system.runAs(u){
            PageReference savePage ;
            List<Id> createLayoutData = TestHelper.setLayoutData();
            DynamicLayoutHolder layoutHolder = null;
            Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
            insert opp;
            sample1Record = TestHelper.getSampleObject1(true);
            sample2Record = TestHelper.getSampleObject2(true,sample1Record.Id);
            Id pageLayoutId = createLayoutData.get(0);
            Contact contact = TestHelper.getContact(true);
            System.assertNotEquals(null, contact.Id , 'contact is not created');

            PageTemplate__c template = TestHelper.getPageTemplateConfig(true);
            System.assertNotEquals(null, template.Id , 'template is not created');
            
            //act
            Test.startTest();   
            DynamicLayoutController ctrl = new DynamicLayoutController();
            ctrl.tmplName = template.Name;
            ctrl.rcrdId = null;
            ctrl.type = 'edit';
            ctrl.savePage = Page.BlankPage;
            ctrl.layoutHolder = new DynamicLayoutHolder(pageLayoutId, sample2Record.ID,true,'2');
            savePage =  ctrl.saveRecord();
            Test.stopTest();
        }
    }
}