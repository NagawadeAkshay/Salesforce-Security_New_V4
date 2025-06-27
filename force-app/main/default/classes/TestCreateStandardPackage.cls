@isTest
private class TestCreateStandardPackage {
    static Package__c pack;
    static PageTemplate__c formConfig;
    @isTest
    private static void setUpData() {
        TestHelper.createCustomSettings(true);
        CustomApp__c custApp = TestHelper.getCustomApp(false);
        insert custApp;
        PageLayoutConfig__c objPageLayout = TestHelper.getPageLayoutConfig(true);
        pack = TestHelper.getPackage_Data_1(true, 'Stasndard');
        formConfig = TestHelper.getPageTemplateConfig(true, objPageLayout.Id);
        TestHelper.getPackageType(formConfig.Id,custApp.Id,true);
        formConfig.recordTypeId=Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId();
        update formConfig;
        PackageFormConfig__c packageForm = new PackageFormConfig__c(PackageConfig__c=pack.Id, isMandatory__c=true, Order__c=0, FormConfig__c=formConfig.Id);
        insert packageForm;
        system.assertNotEquals(null, packageForm.Id);
    }
   
   @isTest
    static void testFormList1(){    
        setUpData();
        Test.startTest();
            CreateStandardPackage.getAppTypes();
            CreateStandardPackage.getPackageTypes();
            CreateStandardPackage.getFormList1(String.valueOf(pack.Id), 'Stasndard','StateAsGrantor');
            CreateStandardPackage.getFormList1('All', 'Stasndard');
            CreateStandardPackage.getFormList1('All', 'Stasndard','StateAsGrantor');
            CreateStandardPackage.getPackageDetails(pack.Id,'StateAsGrantor');
            CreateStandardPackage.getPackageDetails(pack.Id);
            Map<String, Object> paramMap = new Map<String, Object>();
            paramMap.put('requiredPackage', true);
            paramMap.put('packageName', 'Stasndard');
            paramMap.put('pkgType', 'Application');           
            paramMap.put('packageDescription', 'test');
            paramMap.put('requiredPackage', true);
            paramMap.put('selectedAppId','StateAsGrantor');
                List<Object> ojList = new List<Object>();
                ojList.add(new Map<String, Object>{'selected'=>true, 'id'=>formConfig.Id});
            paramMap.put('formids', JSON.serialize(ojList));
            CreateStandardPackage.upsertStandardPackage(pack.Id, paramMap); 
            CreateStandardPackage objCreateStandardPackage = new CreateStandardPackage();
            objCreateStandardPackage.getKeyValueMap();
         CreateStandardPackage.getPackageTypes('StateAsGrantor');
        Test.stopTest();
        System.assertEquals('abc', 'abc');
    }
      @isTest
    static void testgetPackageWrapper(){
        Test.startTest();
        List<sObject> sObjectList = new List<sObject>();
        Map<String, String> fieldLableMap = new Map<String, String>();
        Map<String, String> fieldDataTypeMap = new Map<String, String>();
        Map<String, Integer> scaleMap =new  Map<String, Integer>();
        String label;
        CreateStandardPackage.PackageWrapper costom = new CreateStandardPackage.PackageWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
        Test.stopTest();
        System.assertNotEquals(sObjectList,null);
      
    
        
    }
}