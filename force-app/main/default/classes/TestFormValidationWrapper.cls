@isTest
public class TestFormValidationWrapper{  
    @isTest
    private static void seupData(){
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() +'SampleObject2__c');
        
        PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
        pt.ViewLayoutConfig__c = page.Id;
        pt.EditLayoutConfig__c = page.Id;
        pt.PrintLayoutConfig__c = page.Id;
        pt.name= '966 Phase II';
        pt.PackageType__c = 'Other';
        pt.FormType__c = 'Other';
        pt.Description__c = 'test2';
        pt.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject2__c';
        insert pt;
        
        Package__c pkg = TestHelper.getPackage(true,pt);
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
        
        
        SampleObject1__c sm1  = new SampleObject1__c();
        sm1.name = 'T';
        insert sm1;
        
        SampleObject2__c sm2  = new SampleObject2__c();
        sm2.ConfigFormPage__c = pt.Id;
        sm2.name = 'T';
        sm2.SampleObject1__c = sm1.Id;
        insert sm2;
        
        FormInstance__c testInstance = new FormInstance__c ();
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        insert testInstance;
        System.assertNotEquals(null, testInstance.Id, '' );
        String objectName = 'SampleObject1__c';
        
        FormValidationWrapper obj1 = new FormValidationWrapper();
        obj1.objectName = objectName;
        obj1.formId = sm2.id;
        obj1.parentId = sm1.Id;
        obj1.formInstanceId = testInstance.Id;
    }
}