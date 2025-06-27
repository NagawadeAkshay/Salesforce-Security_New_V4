@isTest
private with sharing class TestDynamicLayoutHolder  {

      @IsTest(OnInstall=false)
      public static void setup()
    {
        //arrange
        //List<Id> createLayoutData = TestHelper.setLayoutData1(AppUtils.getNamespacePrefix()+'SampleObject11__c');
        List<Id> createLayoutData = setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');
        DynamicLayoutHolder layoutHolder = null;
      //  //AccountTriggerHelper.skipTrigger = true;
        SampleObject11__c ann = TestHelper.getSampleObject1(true);
        Id pageLayoutId = createLayoutData.get(0);
        Id pageBlockId = createLayoutData.get(2);
        Test.startTest();
           //test view layout
        DynamicLayoutHolder layoutHolder1 = new DynamicLayoutHolder(ann.ID,true);
        DynamicLayoutHolder layoutHolder2 = new DynamicLayoutHolder(createLayoutData, ann.ID,true);
        DynamicLayoutHolder layoutHolder3 = new DynamicLayoutHolder(pageLayoutId, ann.ID,true,1);
        Set<Object> pageBlockSet = new Set<Object>();
        pageBlockSet.add(pageBlockId);
        DynamicLayoutHolder layoutHolder4 = new DynamicLayoutHolder(pageLayoutId, ann.ID,true,pageBlockSet);
        DynamicLayoutHolder layoutHolder5 = new DynamicLayoutHolder(pageLayoutId, ann.ID,true,pageBlockSet,null);
        PageTemplate__c pageTemplate = TestHelper.getPageTemplateConfig(true) ;
        Package__c pkg = TestHelper.getPackage(true,pageTemplate);
        DynamicLayoutHolder layoutHolder6 = new DynamicLayoutHolder(pageLayoutId, ann.ID,true,pkg.id);
        layoutHolder = new DynamicLayoutHolder(pageLayoutId, ann.ID,true);
         System.assertNotEquals(null, layoutHolder);
        }
    
      @IsTest(OnInstall=false)
      public static void getRelationhipAPI()
    {
        //arrange
        //List<Id> createLayoutData = TestHelper.setLayoutData1(AppUtils.getNamespacePrefix()+'SampleObject11__c');
        List<Id> createLayoutData = setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');
        DynamicLayoutHolder layoutHolder = null;
      //  //AccountTriggerHelper.skipTrigger = true;
        SampleObject11__c ann = TestHelper.getSampleObject1(true);
        Id pageLayoutId = createLayoutData.get(0);
        Id pageBlockId = createLayoutData.get(2);
        Test.startTest();
           //test view layout
        PageLayoutConfigHelper.Field pageHelperField;
        pageHelperField = new PageLayoutConfigHelper.Field();        
        layoutHolder = new DynamicLayoutHolder(pageLayoutId, ann.ID,true);
        String res = layoutHolder.getAddressFields(pageHelperField);
         System.assertNotEquals(null, layoutHolder);
        }
     
            @IsTest(OnInstall=false)
      public static void getRelationhipAPI1()
        {
            List<Id> createLayoutData = setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');
            DynamicLayoutHolder layoutHolder = null;
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            Id pageLayoutId = createLayoutData.get(0);
            Id pageBlockId = createLayoutData.get(2);
            Test.startTest();
            //test view layout
            PageLayoutConfigHelper.Field pageHelperField;
            pageHelperField = new PageLayoutConfigHelper.Field();        
            layoutHolder = new DynamicLayoutHolder(pageLayoutId, ann.ID,true);
            String res = layoutHolder.getAddressFields(pageHelperField);
            layoutHolder.getAddressFieldValue('Account.Name', pageHelperField );
            System.assertNotEquals(null, layoutHolder);
        }
        
           @IsTest(OnInstall=false)
      public static void getRelationhipAPI2()
        {
            List<Id> createLayoutData = setLayoutData(AppUtils.getNamespacePrefix()+'SampleObject11__c');
            DynamicLayoutHolder layoutHolder = null;
            SampleObject11__c ann = TestHelper.getSampleObject1(true);
            Id pageLayoutId = createLayoutData.get(0);
            Id pageBlockId = createLayoutData.get(2);
            Test.startTest();
            //test view layout
            PageLayoutConfigHelper.Field pageHelperField;
            pageHelperField = new PageLayoutConfigHelper.Field();        
            layoutHolder = new DynamicLayoutHolder(pageLayoutId, ann.ID,true);
            String res = layoutHolder.getAddressFields(pageHelperField);
            layoutHolder.getAddressFieldValue('Name', pageHelperField );
            layoutHolder.getRecordData();
            layoutHolder.upsertDynamicRecords(); 
            layoutHolder.checkForValidationErrors(ann);
            System.assertNotEquals(null, layoutHolder);
        }
     public static List<ID> setLayoutData(String objectAPIName) {
        List<ID> layoutIDs = new List<ID>();
        PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true,objectAPIName);
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =   TestHelper.getPageBlockConfig(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig =  TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        PageLayoutActionConfig__c pageAction =  TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        layoutIDs.add(pageLayoutConfig.Id);
        layoutIDs.add(tabConfig.ID);
        layoutIDs.add(pageBlockConfig.Id);
        layoutIDs.add(pageBlockDetailConfig.Id);
        layoutIDs.add(pageAction.Id);
        return layoutIDs;       
    }
    public static TabConfig__c getTabConfig(Id pageLayout,Boolean create) {
        TabConfig__c tabConfig = new TabConfig__c(IsActive__c=true,PageLayoutConfig__c=pageLayout,SortOrder__c=0,StandardTabName__c='Tab 1',HideforQueue__c='test',HeaderInstructionText__c='test',isOverview__c=false,SkipForExport__c=false,HideExpressionFields__c='Name',
                                                 HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Name"},"Operator":"NOT IN","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject11__c"}');
        if (create) {  
            insert tabConfig;
        }
        return tabConfig;
    }
}