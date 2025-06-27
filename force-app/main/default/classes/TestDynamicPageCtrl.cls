/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private with sharing class TestDynamicPageCtrl {
	public static PageTemplate__c pagTemp;
	public static SampleObject11__c sampleObj_1;
	public static SampleObject12__c sampleObj_2;
	public static SObjectLayoutConfig__c sObjLayCon; 
	public static DataTableConfig__c dataTable;
	public static List<DynamicLayoutDefaultValueHelper> listDefaultValues = new List<DynamicLayoutDefaultValueHelper>();
	
	@TestSetup
	static void setup() {   		
   			 	
	}
	
	@isTest
    private static void test_2() {
        pagTemp = TestHelper.getPageTemplateConfig(false);
        pagTemp.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject12__c';
        pagTemp.ParentObjectFieldAPI__c = AppUtils.getNamespacePrefix() + 'SampleObject11__c';
        insert pagTemp;
        pagTemp.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject11__c';
        update pagTemp;
            Package__c packageObj = TestHelper.getPackage(true, pagTemp);

            PackageFormConfig__c packageFormConfig = new PackageFormConfig__c(
                PackageConfig__c = packageObj.Id,
                Order__c = 1,
                FormConfig__c = pagTemp.Id
            );
            insert packageFormConfig;
        sampleObj_1 = TestHelper.getSampleObject1(true);
        sampleObj_2 = TestHelper.getSampleObject2(false, sampleObj_1.id);
        insert sampleObj_2;
            FormInstance__c formInstance = new FormInstance__c(
                PackageBusinessForm__c = packageFormConfig.Id,
                FormId__c = pagTemp.Id,
                ParentRecordId__c = sampleObj_2.Id
            );
            insert formInstance;
		System.assertNotEquals(null, formInstance);
        DynamicPageCtrl.getformDetailsLWC(formInstance.Id, '/lightning/r/FormInstance__c/'+formInstance.Id+'view?c__Mode=edit');
    }
    @isTest
    private static void test_1() {
		TestHelper.createCustomSettings(true);
   		dataTable = TestHelper.getFlexDataTableConfig(false);
   		dataTable.RecordTypeId = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Budget Grid').getRecordTypeId();
   		insert dataTable;	

		sampleObj_1 = TestHelper.getSampleObject1(true);
		sampleObj_2 = TestHelper.getSampleObject2(false, sampleObj_1.id);
		insert sampleObj_2;

		pagTemp = TestHelper.getPageTemplateConfig(false);
		pagTemp.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject12__c';
		pagTemp.ParentObjectFieldAPI__c = AppUtils.getNamespacePrefix() + 'SampleObject11__c';
		insert pagTemp;
	 	sObjLayCon = TestHelper.getSObjectLayoutConfig(true);
		Test.setCurrentPageReference(new PageReference('Page.DynamicFormView'));
		System.currentPageReference().getParameters().put('formId', pagTemp.id);
		System.currentPageReference().getParameters().put('id', sampleObj_1.id);
		System.currentPageReference().getParameters().put('ParentId', sampleObj_2.id);
		System.currentPageReference().getParameters().put('parentLayoutId', sObjLayCon.id);
		System.currentPageReference().getParameters().put('packageId', null);
		System.currentPageReference().getParameters().put('isFormSaved', 'false');
		System.currentPageReference().getParameters().put('templateName', pagTemp.Name);
		System.currentPageReference().getParameters().put('formTypes', JSON.serialize(new List<String>{'Type1','Type2'}));
		System.currentPageReference().getParameters().put('formInstanceId', pagTemp.id);
		
		DynamicPageCtrl obj = new DynamicPageCtrl();
		System.assertNotEquals(null, obj);
		String strKeyValueMap = obj.getKeyValueMap();
		System.assertNotEquals(null, strKeyValueMap);
		
		PageReference pRef;

		try{
			Test.setCurrentPageReference(new PageReference('Page.DynamicFormView'));
			System.currentPageReference().getParameters().put('formId', pagTemp.id);
			System.currentPageReference().getParameters().put('ParentId', sampleObj_1.id);
			System.currentPageReference().getParameters().put('parentLayoutId', sObjLayCon.id);
			System.currentPageReference().getParameters().put('packageId', null);
			System.currentPageReference().getParameters().put('isFormSaved', 'false');
			System.currentPageReference().getParameters().put('templateName', pagTemp.Name);
			System.currentPageReference().getParameters().put('formTypes', JSON.serialize(new List<String>{'Type1','Type2'}));
			System.currentPageReference().getParameters().put('formInstanceId', pagTemp.id);
			System.currentPageReference().getParameters().put('id', '');
			obj = new DynamicPageCtrl();
			System.assertNotEquals(null, obj);
			strKeyValueMap = obj.getListParameters();
			strKeyValueMap = obj.getKeyValueMap();
			System.assertNotEquals(null, strKeyValueMap);
			pRef = obj.initiate();
		} catch (Exception ex){

		}

		try{
			Test.setCurrentPageReference(new PageReference('Page.DynamicFormView'));
			System.currentPageReference().getParameters().put('formId', pagTemp.id);
			System.currentPageReference().getParameters().put('ParentId', sampleObj_1.id);
			System.currentPageReference().getParameters().put('parentLayoutId', sObjLayCon.id);
			System.currentPageReference().getParameters().put('packageId', null);
			System.currentPageReference().getParameters().put('isFormSaved', 'false');
			System.currentPageReference().getParameters().put('templateName', pagTemp.Name);
			System.currentPageReference().getParameters().put('formTypes', JSON.serialize(new List<String>{'Type1','Type2'}));
			System.currentPageReference().getParameters().put('formInstanceId', pagTemp.id);
			System.currentPageReference().getParameters().put('id', '');
			System.currentPageReference().getParameters().put('clsName', 'testClass');
			obj = new DynamicPageCtrl();
		} catch (Exception ex){

		}

		try{
			Test.setCurrentPageReference(new PageReference('Page.DynamicFormView'));
			System.currentPageReference().getParameters().put('formId', pagTemp.id);
			System.currentPageReference().getParameters().put('ParentId', sampleObj_1.id);
			System.currentPageReference().getParameters().put('parentLayoutId', sObjLayCon.id);
			System.currentPageReference().getParameters().put('packageId', null);
			System.currentPageReference().getParameters().put('isFormSaved', 'false');
			System.currentPageReference().getParameters().put('templateName', pagTemp.Name);
			System.currentPageReference().getParameters().put('formTypes', JSON.serialize(new List<String>{'Type1','Type2'}));
			System.currentPageReference().getParameters().put('formInstanceId', pagTemp.id);
			System.currentPageReference().getParameters().put('id', '');
			obj = new DynamicPageCtrl();
            DynamicPageCtrl.updateFormInstanceFormId('formId','formInsId');
		} catch (Exception ex){

		}

		try{
			pagTemp.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject11__c';
			update pagTemp;
			Package__c packageObj = TestHelper.getPackage(true, pagTemp);

			PackageFormConfig__c packageFormConfig = new PackageFormConfig__c(
				PackageConfig__c = packageObj.Id,
				Order__c = 1,
				FormConfig__c = pagTemp.Id
			);
			insert packageFormConfig;

			FormInstance__c formInstance = new FormInstance__c(
				PackageBusinessForm__c = packageFormConfig.Id,
				FormId__c = pagTemp.Id,
				ParentRecordId__c = sampleObj_2.Id
			);
			insert formInstance;

			Test.setCurrentPageReference(new PageReference('Page.DynamicFormView'));
			System.currentPageReference().getParameters().put('formId', pagTemp.id);
			System.currentPageReference().getParameters().put('ParentId', sampleObj_2.id);
			System.currentPageReference().getParameters().put('parentLayoutId', sObjLayCon.id);
			System.currentPageReference().getParameters().put('packageId', null);
			System.currentPageReference().getParameters().put('isFormSaved', 'false');
			System.currentPageReference().getParameters().put('templateName', pagTemp.Name);
			System.currentPageReference().getParameters().put('formTypes', JSON.serialize(new List<String>{'Type1','Type2'}));
			System.currentPageReference().getParameters().put('formInstanceId', formInstance.id);
			System.currentPageReference().getParameters().put('id', '');

			pRef = obj.initiate();
		} catch (Exception ex){

		}
	}

	@isTest
    static void testProperties() {
        DynamicPageCtrl obj = new DynamicPageCtrl();
        Account acc = new Account(Name='Test');
        Test.startTest();
        insert acc;
        Test.stopTest();
        String sampleLayoutType = 'Detail';
        String sampleParentRecordId = acc.Id;
        String sampleHideCancel = 'true';
        String sampleObjectName = 'Account';
        obj.layoutType = sampleLayoutType;
        obj.parentRecordId = acc.Id;
        obj.hideCancel = sampleHideCancel;
        obj.objectName = sampleObjectName;
		 Map<String, String> resultLWC = DynamicPageCtrl.getIconLwc();
		 System.assertNotEquals(null,resultLWC);
        System.assertEquals(sampleLayoutType, obj.layoutType);
        System.assertEquals(sampleParentRecordId, obj.parentRecordId);
        System.assertEquals(sampleHideCancel, obj.hideCancel);
        System.assertEquals(sampleObjectName, obj.objectName);
    }
}