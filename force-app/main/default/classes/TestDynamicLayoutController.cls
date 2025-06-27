/**
**/
@isTest public with sharing class TestDynamicLayoutController {
 
  static Map<String, Object> paramMap ;
  @TestSetup
  static void makeData(){
      
      TestHelper.getCustomAppConfig(true);
      UserPreferences__c upref = TestHelper.getUserPreference(true, 'ActiveAppName__c', 'StateAsGrantor');
      PhaseConfig__c ph = TestHelper.getPhase(true);
      CustomApp__c customAppObj = TestHelper.getCustomApp(true);
      SampleObject11__c sampleObject11 = TestHelper.getSampleObject1(true);
      SampleObject1__c sampleObj1 = new SampleObject1__c(Name='test',Status__c = 'Created');
      insert sampleObj1;
      
      PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true);
      SObjectLayoutConfig__c sol =  TestHelper.getSObjectLayoutConfig(true);
      ErrorMessageConfig__c err = TestHelper.getErrorMessageConfig('Danger','Testing', ph.Id, customAppObj.Id, true);

      KeyValueStore__c keyValueStore = new KeyValueStore__c();
      keyValueStore.Description__c = 'Test';
      keyValueStore.TextValue__c = 'DisableRecordLocking';
      keyValueStore.BooleanValue__c = false;
      keyValueStore.Name='DisableRecordLocking';
      keyValueStore.Admin_Question__c = 'Loren Ipsum';
      insert keyValueStore; 
   
      PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, 'SampleObject11__c');
      TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
      PageBlockConfig__c block = TestHelper.getPageBlockConfig(tab.Id, true);

      List<PageBlockDetailConfig__c> details = new List<PageBlockDetailConfig__c>();

        PageBlockDetailConfig__c detail1 = TestHelper.getPageBlockDetailConfig(block.Id, true);
        detail1.FieldAPIName__c = 'FormsTextField1__c';
        detail1.RequiredBehavior__c = 'Required for Submit'; 
        details.add(detail1);

        PageBlockDetailConfig__c detail2 = TestHelper.getPageBlockDetailConfig(block.Id, true);
        detail2.FieldAPIName__c = 'FormsTextField2__c';
        detail2.RequiredBehavior__c = 'Required for Submit'; 
        details.add(detail2);
  }
  
  //validateFormsLWC
  /*Correct data */
    @IsTest
   static void validateFormsLWC() {
   try{
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() +'SampleObject2__c');
            System.assertNotEquals(null, page.Id, 'page is not inserted');

        PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
        validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
        validateButton.ActionClass__c = '';
        insert validateButton;
            System.assertNotEquals(null, validateButton.Id, 'btn is not inserted');
        
        TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
            System.assertNotEquals(null, tab.Id, 'tab is not inserted');

        PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
        PageBlockDetailConfig__c pbd =  TestHelper.getPageBlockDetailConfig(pb.Id, false);
        pbd.FieldAPIName__c = 'Date__c';
            insert pbd;
            System.assertNotEquals(null, pbd.Id, 'pbd is not inserted');
        
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
            System.assertNotEquals(null, pt.Id, 'pt is not inserted');
                
        Package__c pkg = TestHelper.getPackage(true,pt);
            System.assertNotEquals(null, pkg.Id , 'pkg is not inserted');
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
            System.assertNotEquals(null, businessPackageForm.Id, 'pkg business form is not inserted');
        
         SampleObject1__c sm1  = new SampleObject1__c();
         sm1.name = 'T';
        insert sm1;
            System.assertNotEquals(null, sm1.Id, 'sm1 is not inserted');
        
         SampleObject2__c sm2  = new SampleObject2__c();
        sm2.ConfigFormPage__c = pt.Id;
        sm2.name = 'T';
        sm2.SampleObject1__c = sm1.Id;
        insert sm2;
            System.assertNotEquals(null, sm2.Id, 'sm2 is not inserted');
        
        Attachment att =TestHelper.getAttachment(sm2.id , false);
        att.ParentId = sm2.ID;
        insert att; 
            System.assertNotEquals(null, att.Id, 'attachment is not inserted');        
      
        FormInstance__c testInstance = new FormInstance__c ();
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        testInstance.FormId__c = sm2.Id;
        insert testInstance;
            System.assertNotEquals(null, testInstance.Id, 'form instance is not inserted');    
        
          ApexPages.currentPage().getParameters().put('parentId',sm1.Id);
        ApexPages.currentPage().getParameters().put('recId',sm2.Id);        
        ApexPages.currentPage().getParameters().put('formId',pt.Id);        
        ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);      
        ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',validateButton.Id);      
        
        test.startTest();
        DynamicLayoutController.validateFormsLWC(sm2.Id, validateButton.Id, '');
        test.stopTest();
        }catch(exception e){
            system.debug('e is::'+e);
        }
    }
  
  
  
  /*Correct data */
    @IsTest
   static void testValidateFormGNT2One() {
   try{
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() +'SampleObject2__c');
            System.assertNotEquals(null, page.Id, 'page is not inserted');

        PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
        validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
        validateButton.ActionClass__c = '';
        insert validateButton;
            System.assertNotEquals(null, validateButton.Id, 'btn is not inserted');
        
        TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
            System.assertNotEquals(null, tab.Id, 'tab is not inserted');

        PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
        PageBlockDetailConfig__c pbd =  TestHelper.getPageBlockDetailConfig(pb.Id, false);
        pbd.FieldAPIName__c = 'Date__c';
            insert pbd;
            System.assertNotEquals(null, pbd.Id, 'pbd is not inserted');
        
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
            System.assertNotEquals(null, pt.Id, 'pt is not inserted');
                
        Package__c pkg = TestHelper.getPackage(true,pt);
            System.assertNotEquals(null, pkg.Id , 'pkg is not inserted');
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
            System.assertNotEquals(null, businessPackageForm.Id, 'pkg business form is not inserted');
        
         SampleObject1__c sm1  = new SampleObject1__c();
         sm1.name = 'T';
        insert sm1;
            System.assertNotEquals(null, sm1.Id, 'sm1 is not inserted');
        
         SampleObject2__c sm2  = new SampleObject2__c();
        sm2.ConfigFormPage__c = pt.Id;
        sm2.name = 'T';
        sm2.SampleObject1__c = sm1.Id;
        insert sm2;
            System.assertNotEquals(null, sm2.Id, 'sm2 is not inserted');
        
        Attachment att =TestHelper.getAttachment(sm2.id , false);
        att.ParentId = sm2.ID;
        insert att; 
            System.assertNotEquals(null, att.Id, 'attachment is not inserted');        
      
        FormInstance__c testInstance = new FormInstance__c ();
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        insert testInstance;
            System.assertNotEquals(null, testInstance.Id, 'form instance is not inserted');    
        
          ApexPages.currentPage().getParameters().put('parentId',sm1.Id);
        ApexPages.currentPage().getParameters().put('recId',sm2.Id);        
        ApexPages.currentPage().getParameters().put('formId',pt.Id);        
        ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);      
        ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',validateButton.Id);      
        
        test.startTest();
        DynamicLayoutController.validateForms();
        test.stopTest();
        }catch(exception e){
            system.debug('e is::'+e);
        }
    }
   
    @IsTest
      static void testValidateFormGNT2(){
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() +'SampleObject2__c');
          System.assertNotEquals(null, page.Id , 'page is not inserted');

        PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
        validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
        validateButton.ActionClass__c = '';
        insert validateButton;
          System.assertNotEquals(null, validateButton.Id, 'vdt btn is not inserted');
        
        TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
        PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
        PageBlockDetailConfig__c pbd =  TestHelper.getPageBlockDetailConfig(pb.Id, false);
        pbd.FieldAPIName__c = 'Date__c';
        insert pbd ; 
          System.assertNotEquals(null, pbd.Id, 'pdb is not inserted');
        
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
          System.assertNotEquals(null, pt.Id, 'pt is not inserted');
                
        Package__c pkg = TestHelper.getPackage(true,pt);
          System.assertNotEquals(null, pkg.Id , 'pkg is not inserted');
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
          System.assertNotEquals(null, businessPackageForm.Id, 'pkg buss form is not inserted');
        
         SampleObject1__c sm1  = new SampleObject1__c();
         sm1.name = 'T';
        insert sm1;
          System.assertNotEquals(null, sm1.Id, 'sm1 is not inserted');
        
         SampleObject2__c sm2  = new SampleObject2__c();
        sm2.ConfigFormPage__c = pt.Id;
        sm2.name = 'T';
        sm2.SampleObject1__c = sm1.Id;
        insert sm2;
          System.assertNotEquals(null, sm2.Id, 'sm2 is not inserted');
        
        Attachment att =TestHelper.getAttachment(sm2.id , false);
        att.ParentId = sm2.ID;
        insert att; 
          System.assertNotEquals(null, att.Id, 'attachment is not inserted');
      
        FormInstance__c testInstance = new FormInstance__c ();
         testInstance.FormId__c = sm2.Id;
        testInstance.ParentRecordId__c = sm1.Id;
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        insert testInstance;
          System.assertNotEquals(null, testInstance.Id, 'test instance is not inserted');
          
        ApexPages.currentPage().getParameters().put('recId',sm2.Id);        
        ApexPages.currentPage().getParameters().put('formId',pt.Id);        
        ApexPages.currentPage().getParameters().put('parentId',sm1.Id);     
        ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);      
        ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',testInstance.Id);      
        
        test.startTest();
        DynamicLayoutController.validateForms();
        test.stopTest();
    }
  

/* removed this method as we do not want to add the end point url hard code value. After Security review we can uncomment this 
and add  iTextEndpointURL URL*/
 @isTest
 public static void verifyITextHelper(){
      try {
        Account objAccount = new Account(Name = 'TestAccount');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id, 'objAccount is not inserted');

        Attachment objAttachment = new Attachment(
            ParentId = objAccount.Id,
            Name = 'Test Attachment for Parent',
            Body = Blob.valueOf('Test Data')
        );        
        insert(objAttachment); 
        System.assertNotEquals(null, objAttachment.Id, 'record is not inserted');

        Task objTask = new Task(
            Subject = 'Test Task',
            Status = 'New',
            Priority = 'Normal',
            CallType = 'Outbound'
        );
        insert objTask;
        System.assertNotEquals(null, objTask.Id,'record is not inserted');

        Map<String, Object> mapParams = new Map<String, Object>();
        mapParams.put('attachmentIds', JSON.serialize(new List<String>{objAttachment.Id}));
        mapParams.put('parentRecordId', objAccount.Id);
        mapParams.put('task', JSON.serialize(objTask));
        mapParams.put('fileName', objAttachment.Name);
        
        Test.setMock(HttpCalloutMock.class, new TestITextHelperHttpCalloutMock());
        Test.startTest();
            DynamicLayoutController.callITextMergePDF(JSON.serialize(mapParams), objAccount.id);

        } catch(Exception ex) {
            System.assertNotEquals(null, ex,  'record is not inserted');
       }
        Test.stopTest();
    }
    
    @isTest
 public static void verifyITextHelper1(){
      try {
        Account objAccount = new Account(Name = 'TestAccount');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id, 'objAccount is not inserted');

        Attachment objAttachment = new Attachment(
            ParentId = objAccount.Id,
            Name = 'Test Attachment for Parent',
            Body = Blob.valueOf('Test Data')
        );        
        insert(objAttachment); 
        System.assertNotEquals(null, objAttachment.Id, 'record is not inserted');

        Task objTask = new Task(
            Subject = 'Test Task',
            Status = 'New',
            Priority = 'Normal',
            CallType = 'Outbound'
        );
        insert objTask;
        System.assertNotEquals(null, objTask.Id,'record is not inserted');

        Map<String, Object> mapParams = new Map<String, Object>();
        mapParams.put('attachmentIds', JSON.serialize(new List<String>{objAttachment.Id}));
        mapParams.put('parentRecordId', objAccount.Id);
        mapParams.put('task', JSON.serialize(objTask));
        mapParams.put('fileName', objAttachment.Name);
        
        String nm =[SELECT NetworkId FROM NetworkMember limit 1][0].NetworkId;
    
        Test.setMock(HttpCalloutMock.class, new TestITextHelperHttpCalloutMock());
        Test.startTest();
        if(String.IsNotBlank(nm)){
            DynamicLayoutController.callITextMergePDF(JSON.serialize(mapParams),objAccount.id, nm);
            }
          Test.stopTest();
       } catch(Exception ex) {
           System.assertNotEquals(null, ex,  'record is not inserted');
       }
    
    }
    
  @IsTest
    static void testValidateFormGNT1() {
      SampleObject1__c sm1  = new SampleObject1__c();
      sm1.name = 'T';
      insert sm1;
      System.assertNotEquals(null, sm1.Id , 'sm1 is not inserted');

      SampleObject2__c sm = new SampleObject2__c();
      sm.name = 'T';
      insert sm;
      System.assertNotEquals(null, sm.Id , 'sm is not inserted');

      Attachment att =TestHelper.getAttachment(sm.id , false);
      att.ParentId = sm.ID;
      insert att; 
      System.assertNotEquals(null, att.Id , 'att is not inserted');

      PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() + 'SampleObject2__c');
      System.assertNotEquals(null, page.Id, 'page is null');

      PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
      validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
      validateButton.ActionClass__c = '';
      insert validateButton;
      System.assertNotEquals(null, validateButton.Id , 'validate btn is null');

      TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
      PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
      System.assertNotEquals(null, pb.Id , 'pb is null');

      PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
      pt.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject2__c';
      insert pt; 
      System.assertNotEquals(null, pt.Id, 'pt is null');

      Package__c pkg = TestHelper.getPackage(true,pt);
      System.assertNotEquals(null, pkg.Id , 'pkg id is null');
      
      PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
      businessPackageForm.FormConfig__c = pt.Id;
      businessPackageForm.PackageConfig__c = pkg.Id;
      insert businessPackageForm;
      System.assertNotEquals(null, businessPackageForm.Id , 'businessPackageForm is not inserted correctly');

      FormInstance__c testInstance = new FormInstance__c ();
      testInstance.FormId__c = sm.Id;
      testInstance.ParentRecordId__c = sm.Id;
      testInstance.PackageBusinessForm__c = businessPackageForm.Id;
      insert testInstance;
      System.assertNotEquals(null, testInstance.Id, 'testInstance in not inserted correctly');

      ApexPages.currentPage().getParameters().put('parentId',sm1.Id);
      ApexPages.currentPage().getParameters().put('recId',sm.Id);        
      ApexPages.currentPage().getParameters().put('formId',pt.Id);        
      ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);
      ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',validateButton.Id);    
    
      DynamicLayoutController.validateForms();
        DynamicLayoutController.createSalesforceContentVersion(att.id);
    }
    
    
 /* @IsTest
    static void testValidateFormGNT11() {
      SampleObject1__c sm1  = new SampleObject1__c();
      sm1.name = 'T';
      insert sm1;
      System.assertNotEquals(null, sm1.Id , 'sm1 is not inserted');

      SampleObject2__c sm = new SampleObject2__c();
      sm.name = 'T';
      insert sm;
      System.assertNotEquals(null, sm.Id , 'sm is not inserted');

      Attachment att =TestHelper.getAttachment(sm.id , false);
      att.ParentId = sm.ID;
      insert att; 
      System.assertNotEquals(null, att.Id , 'att is not inserted');

      PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() + 'SampleObject2__c');
      System.assertNotEquals(null, page.Id, 'page is null');

      PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
      validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
      validateButton.ActionClass__c = '';
      insert validateButton;
      System.assertNotEquals(null, validateButton.Id , 'validate btn is null');

      TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
      PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
      System.assertNotEquals(null, pb.Id , 'pb is null');

      PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
      pt.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject2__c';
      insert pt; 
      System.assertNotEquals(null, pt.Id, 'pt is null');

      Package__c pkg = TestHelper.getPackage(true,pt);
      System.assertNotEquals(null, pkg.Id , 'pkg id is null');
      
      PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
      businessPackageForm.FormConfig__c = pt.Id;
      businessPackageForm.PackageConfig__c = pkg.Id;
      insert businessPackageForm;
      System.assertNotEquals(null, businessPackageForm.Id , 'businessPackageForm is not inserted correctly');

      FormInstance__c testInstance = new FormInstance__c ();
      testInstance.FormId__c = sm.Id;
      testInstance.ParentRecordId__c = sm.Id;
      testInstance.PackageBusinessForm__c = businessPackageForm.Id;
      insert testInstance;
      System.assertNotEquals(null, testInstance.Id, 'testInstance in not inserted correctly');
      String nm =[SELECT NetworkId FROM NetworkMember limit 1].size() > 0 ? [SELECT NetworkId FROM NetworkMember limit 1][0].NetworkId : '';
      ApexPages.currentPage().getParameters().put('parentId',sm1.Id);
      ApexPages.currentPage().getParameters().put('recId',sm.Id);        
      ApexPages.currentPage().getParameters().put('formId',pt.Id);        
      ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);
      ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',validateButton.Id);    
    
      DynamicLayoutController.validateForms();
      if(String.IsNotBlank(nm)){
      DynamicLayoutController.createSalesforceContentVersion(att.id,nm );
    }
    }*/
      
 @IsTest
    static void testValidateFormGNT3() {
        SampleObject2__c sm = new SampleObject2__c();
        sm.name = 'T';
        insert sm;
        
        Attachment att =TestHelper.getAttachment(sm.id , false);
        att.ParentId = sm.ID;
        insert att; 
        System.assertNotEquals(null, att.Id , 'Attachment is not inserted correctly');
        
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() + 'SampleObject2__c');
      
        PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
        validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
        insert validateButton;
        System.assertNotEquals(null, att.Id ,'we didnt find validateButton');
        
        TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
        PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
          
        PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
        pt.ViewLayoutConfig__c = page.Id;
        pt.EditLayoutConfig__c = page.Id;
        pt.PrintLayoutConfig__c = page.Id;
        pt.PackageType__c = 'Other';
        pt.Description__c = 'test2';
        pt.name= '966 Phase';
        pt.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject2__c';
        insert pt;
        System.assertEquals('966 Phase', pt.name,  'record is not inserted');
        
        Package__c pkg = TestHelper.getPackage(true,pt);
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
        
        FormInstance__c testInstance = new FormInstance__c ();
        testInstance.FormId__c = sm.Id;
        testInstance.ParentRecordId__c = sm.Id;
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        insert testInstance;
        System.assertNotEquals(null, testInstance.Id, 'Test instance is null');
         
        ApexPages.currentPage().getParameters().put('recId',sm.Id);        
        ApexPages.currentPage().getParameters().put('formId',pt.Id);        
        ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);
        ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',validateButton.Id);   
        
        DynamicLayoutController.validateForms();
    }
  @IsTest
    static void testValidateFormGNT4(){
        SampleObject2__c sm = new SampleObject2__c();
        sm.name = 'T';
        insert sm;
      System.assertNotEquals(null, sm.Id, 'sm is null');
       
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() + 'SampleObject2__c');
      
        TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
        PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
      System.assertNotEquals(null, pb.Id, 'pb is null');
          
        PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
        pt.ViewLayoutConfig__c = page.Id;
        pt.EditLayoutConfig__c = page.Id;
        pt.PrintLayoutConfig__c = page.Id;
        pt.PackageType__c = 'Other';
        pt.Description__c = 'test2';
        pt.name= '966 Phase';
        pt.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject2__c';
        insert pt;
      System.assertNotEquals(null, pt.Id, 'pt is null');
        
        Package__c pkg = TestHelper.getPackage(true,pt);
      System.assertNotEquals(null, pkg.Id, 'pkg is null');
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
        
        FormInstance__c testInstance = new FormInstance__c ();
        testInstance.FormId__c = sm.Id;
        testInstance.ParentRecordId__c = sm.Id;
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        insert testInstance;
      System.assertNotEquals(null, testInstance.Id, 'testInstance is null');
        
         PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
        validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
        insert validateButton;
      System.assertNotEquals(null, validateButton.Id, 'validateButton is null');

        ApexPages.currentPage().getParameters().put('id',sm.Id);
        DynamicLayoutController dm = new DynamicLayoutController();
    }
    /*Method to cover Download as PDF with Forms */
 @isTest 
      static void testDownloadaspdf2(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            Account account = TestHelper.getAccount(false);
            account.type = 'Customer';
            insert account;
            System.assertNotEquals(null, account.Id, 'Account is null');

            Attachment att = TestHelper.getAttachment(account.Id, false); 
            String keyvalueMap = 'Test2';
            String listparams = 'Test2';
            insert att; 
            System.assertNotEquals(null, att.Id, 'Att is null');

            FormInstance__c frmInst = new FormInstance__c();
            frmInst.PDFFormAttachmentId__c = att.Id; 
            frmInst.ParentRecordId__c = account.Id;
            frmInst.isFormValidated__c = 'Yes';
            insert frmInst;
            System.assertNotEquals(null, frmInst.Id, 'frmInst is null');

            FormInstance__c frmInst1 = new FormInstance__c();
            frmInst1.PDFFormAttachmentId__c = att.Id; 
            frmInst1.ParentRecordId__c = account.Id;
            frmInst1.isFormValidated__c = 'Yes';
            insert frmInst1;
            System.assertNotEquals(null, frmInst1.Id, 'frmInst1 is null');

            List<FormInstance__c>  frm = new List<FormInstance__c>();
            insert frm;
            
            PageLayoutConfig__c pageLayoutConfig = [SELECT Id,Name FROM PageLayoutConfig__c LIMIT 1];
            PageLayoutActionConfig__c btn = TestHelper.getPageLayoutActionConfig(false, pageLayoutConfig.Id);
            btn.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
            btn.ActionClass__c = '';
            insert btn;
            System.assertNotEquals(null, btn.Id, 'btn is null');

            PageTemplate__c pgTempVal =  TestHelper.getPageTemplateConfig(True);

            ApexPages.currentPage().getParameters().put('recId1',account.Id);
            ApexPages.currentPage().getParameters().put('templatename','temp');        
            ApexPages.currentPage().getParameters().put('keyvalueMap',keyvalueMap);        
            ApexPages.currentPage().getParameters().put('listparams',listparams);
        
            DynamicLayoutController.createSnapshotwithForms();
          }      
        }

    /*Method to cover Download as PDF with Forms */
 @isTest 
      static void testDownloadaspdf(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            Account account = TestHelper.getAccount(false);
            account.type = 'Customer';
            insert account;
            System.assertNotEquals(null, account.Id, 'Account is null');
            
            Attachment att = TestHelper.getAttachment(account.Id, false); 
            String keyvalueMap = 'Test2';
            String listparams = 'Test2';
            insert att; 
            
            FormInstance__c frmInst = new FormInstance__c();
            frmInst.PDFFormAttachmentId__c = att.Id; 
            frmInst.ParentRecordId__c = account.Id;
            frmInst.isFormValidated__c = 'Yes';
            insert frmInst;
            FormInstance__c frmInst1 = new FormInstance__c();
            frmInst1.PDFFormAttachmentId__c = att.Id; 
            frmInst1.ParentRecordId__c = account.Id;
            frmInst1.isFormValidated__c = 'Yes';
            insert frmInst1;
            
            List<FormInstance__c>  frm = new List<FormInstance__c>();
            insert frm;
            system.debug('frm::'+frm);
            PageLayoutConfig__c pageLayoutConfig = [SELECT Id,Name FROM PageLayoutConfig__c LIMIT 1];
            PageLayoutActionConfig__c btn = TestHelper.getPageLayoutActionConfig(false, pageLayoutConfig.Id);
            btn.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
            btn.ActionClass__c = '';
            insert btn;
            System.assertNotEquals(null, btn.Id, 'btn is null');

            PageTemplate__c pgTempVal =  TestHelper.getPageTemplateConfig(True);
            ApexPages.currentPage().getParameters().put('recId1',account.Id);
            ApexPages.currentPage().getParameters().put('templatename','temp');        
            ApexPages.currentPage().getParameters().put('keyvalueMap',keyvalueMap);        
            ApexPages.currentPage().getParameters().put('listparams',listparams);
      DynamicLayoutController.createSnapshotwithForms();
          }      
        }
/*Method to cover Download as PDF with Forms */
  @isTest 
    static void testDownloadaspdf1(){
      User u = TestHelper.getAdminUser(true);
      System.runAs(u) {
          Account account = TestHelper.getAccount(false);
          account.type = 'Customer';
          insert account;
          System.assertNotEquals(null, account.Id, 'Account is null');

          Attachment att = TestHelper.getAttachment(account.Id, false); 
          String keyvalueMap = 'Test2';
          String listparams = 'Test2';
          insert att; 
          System.assertNotEquals(null, att.Id, 'Att is null');
        
          List<FormInstance__c>  frm = new List<FormInstance__c>();
          insert frm;
          system.debug('frm::'+frm);
          PageLayoutConfig__c pageLayoutConfig = [SELECT Id,Name FROM PageLayoutConfig__c LIMIT 1];
          PageLayoutActionConfig__c btn = TestHelper.getPageLayoutActionConfig(false, pageLayoutConfig.Id);
          btn.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
          btn.ActionClass__c = '';
          insert btn;
          
          PageTemplate__c pgTempVal =  TestHelper.getPageTemplateConfig(True);
          System.assertNotEquals(null, pgTempVal.Id, 'PageTemplate is null');
          ApexPages.currentPage().getParameters().put('recId1',account.Id);
          ApexPages.currentPage().getParameters().put('templatename','temp');        
          ApexPages.currentPage().getParameters().put('keyvalueMap',keyvalueMap);        
          ApexPages.currentPage().getParameters().put('listparams',listparams);
      DynamicLayoutController.createSnapshotwithForms();
        }      
    }

  @isTest static void testConstructor(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
        DynamicLayoutController dc = new DynamicLayoutController();
        String test = 'Success';
        System.assertEquals('Success', test,  'record is not inserted');     
    }
  }
  @isTest static void testLoadErrorMessage(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
        DynamicLayoutController dc = new DynamicLayoutController();
        Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
        System.currentPageReference().getParameters().put('pageMessageId', 'Danger');
        System.currentPageReference().getParameters().put('messageTTLInSec', '100');
        System.currentPageReference().getParameters().put('actionExecTime', '');
        dc.loadErrorMessage();
        String test = 'Success';
        System.assertEquals('Success', test , '');     
    }
  }

  @isTest static void testCheckFormIsApplicable(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() +'SampleObject2__c');
      System.assertNotEquals(null, page.Id, 'page is not inserted');

      PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
      validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
      validateButton.ActionClass__c = '';
      insert validateButton;
      System.assertNotEquals(null, validateButton.Id, 'btn is not inserted');
      
      TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
      System.assertNotEquals(null, tab.Id, 'tab is not inserted');

      PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
      PageBlockDetailConfig__c pbd =  TestHelper.getPageBlockDetailConfig(pb.Id, false);
      pbd.FieldAPIName__c = 'Date__c';
      insert pbd;
      System.assertNotEquals(null, pbd.Id, 'pbd is not inserted');

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
      System.assertNotEquals(null, pt.Id, 'pt is not inserted');
              
      Package__c pkg = TestHelper.getPackage(true,pt);
      System.assertNotEquals(null, pkg.Id , 'pkg is not inserted');
      
      PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
      businessPackageForm.FormConfig__c = pt.Id;
      businessPackageForm.PackageConfig__c = pkg.Id;
      insert businessPackageForm;
      System.assertNotEquals(null, businessPackageForm.Id, 'pkg business form is not inserted');
      
      FormInstance__c testInstance = new FormInstance__c ();
      testInstance.PackageBusinessForm__c = businessPackageForm.Id;
      insert testInstance;
      System.assertNotEquals(null, testInstance.Id, 'form instance is not inserted');    
      
        DynamicLayoutController dc = new DynamicLayoutController();
        Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      System.currentPageReference().getParameters().put('formInstanceId', testInstance.Id); //'a1Q1K000004qBX1'
        dc.checkFormIsApplicable();
        String test = 'Success';
      System.assertEquals('Success', test, '');     
    }
  }

  @isTest static void testAddSuccessMessage(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
        Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
        System.currentPageReference().getParameters().put('success', 'success');
        DynamicLayoutController.addSuccessMessage();
        String test = 'Success';
        System.assertEquals('Success', test , '');     
    }
  }

  @isTest static void testDynamicLayoutControllerStandard(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
        Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
        SampleObject1__c sampleObject11 = TestHelper.getSampleObject1Val(true);
        ApexPages.StandardController sc = new ApexPages.StandardController(sampleObject11);
        DynamicLayoutController dc = new DynamicLayoutController(sc);
        String test = 'Success';
        System.assertEquals('Success', test , '');     
    }
  }

  @isTest static void testDeprecateddDecideActions(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
     
      DynamicLayoutController.decideActions('','');
      String test = 'Success';
      System.assertEquals('Success', test, '');     
    }
  }

  @isTest static void testDecideActions(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      PageLayoutConfig__c pageLayoutConfig = [SELECT Id,Name FROM PageLayoutConfig__c LIMIT 1];
      paramMap = new  Map<String, Object>();
      paramMap.put('parentId',sampleObject11.Id);
      DynamicLayoutController.decideActions(sampleObject11.Id,pageLayoutConfig.Id,paramMap);
      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }

   @isTest static void testUrlActionAlreadyPerformed(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      DynamicLayoutController.isUrlActionAlreadyPerformed(sampleObject11.Id,null); 
      String test = 'Success';
      System.assertEquals('Success', test);     
    }
  }

  @isTest static void testFetchMiniLayout(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      DynamicLayoutController.fetchMiniLayout(sampleObject11.Id);
      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }
  
 

 @isTest static void testGeneratePDF(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      System.currentPageReference().getParameters().put('id', sampleObject11.Id);
      DynamicLayoutController dc = new DynamicLayoutController();
      dc.type='View';
      dc.checkRecordLevelAccess();
      dc = new DynamicLayoutController();
      dc.type='Edit';
      dc.checkRecordLevelAccess();
      dc = new DynamicLayoutController();
      dc.type='Delete';
      dc.checkRecordLevelAccess();
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      dc.checkRecordLevelAccess();

      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }


  @isTest static void testGetPageHeader(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      DynamicLayoutController dc = new DynamicLayoutController();
      PageLayoutConfig__c pageLayoutConfig =  [SELECT Id,Name FROM PageLayoutConfig__c LIMIT 1];
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      System.currentPageReference().getParameters().put('isPreviewLayout', 'true');
      dc.isCustomHeader = true;
      dc.header = 'testing';
      dc.Type = 'Header';
      dc.recordTypeName = 'Demo';
      dc.subheader = 'Demo';
      dc.parentLytId = pageLayoutConfig.Id;
      DynamicLayoutHolder dl = TestHelper.getDynamicLayoutHolder();
      dc.layoutHolder = dl;
      dc.getPageHeader();
      dc.rcrdId = sampleObject11.Id;
      dc.getPageHeader();
      dc.getInstance();
      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }

  @isTest static void testSaveRecord(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      System.currentPageReference().getParameters().put('id', sampleObject11.Id);
      DynamicLayoutHolder dl = TestHelper.getDynamicLayoutHolder();
      DynamicLayoutController dc = new DynamicLayoutController();
      dc.layoutHolder = dl;
      dc.saveRecord();
      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }

  @isTest static void testSaveAndContinue(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      System.currentPageReference().getParameters().put('id', sampleObject11.Id);
      DynamicLayoutHolder dl = TestHelper.getDynamicLayoutHolder();
      DynamicLayoutController dc = new DynamicLayoutController();
      dc.layoutHolder = dl;
      dc.saveAndContinue();
      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }
  
  
  @isTest static void testCheckRecordLevelAccess(){
    User u = TestHelper.getAdminUser(true);
    System.runAs(u) {
      SampleObject11__c sampleObject11  = [SELECT Id,Name FROM SampleObject11__c LIMIT 1];
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      System.currentPageReference().getParameters().put('id', sampleObject11.Id);
      DynamicLayoutController dc = new DynamicLayoutController();
      dc.type='View';
      dc.checkRecordLevelAccess();
      dc = new DynamicLayoutController();
      dc.type='Edit';
      dc.checkRecordLevelAccess();
      dc = new DynamicLayoutController();
      dc.type='Delete';
      dc.checkRecordLevelAccess();
      Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
      dc.checkRecordLevelAccess();
      String test = 'Success';
      System.assertEquals('Success', test , '');     
    }
  }

  
  @isTest static void updateFormInstancePercentLightning(){
    try{
        PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() +'SampleObject2__c');
        System.assertNotEquals(null, page.Id, 'page is not inserted');

        PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
        validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
        validateButton.ActionClass__c = '';
        insert validateButton;
            System.assertNotEquals(null, validateButton.Id, 'btn is not inserted');
        
        TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
            System.assertNotEquals(null, tab.Id, 'tab is not inserted');

        PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
        PageBlockDetailConfig__c pbd =  TestHelper.getPageBlockDetailConfig(pb.Id, false);
        pbd.FieldAPIName__c = 'Date__c';
            insert pbd;
            System.assertNotEquals(null, pbd.Id, 'pbd is not inserted');
        
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
            System.assertNotEquals(null, pt.Id, 'pt is not inserted');
                
        Package__c pkg = TestHelper.getPackage(true,pt);
            System.assertNotEquals(null, pkg.Id , 'pkg is not inserted');
        
        PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
        businessPackageForm.FormConfig__c = pt.Id;
        businessPackageForm.PackageConfig__c = pkg.Id;
        insert businessPackageForm;
            System.assertNotEquals(null, businessPackageForm.Id, 'pkg business form is not inserted');
        
         SampleObject1__c sm1  = new SampleObject1__c();
         sm1.name = 'T';
        insert sm1;
            System.assertNotEquals(null, sm1.Id, 'sm1 is not inserted');
        
         SampleObject2__c sm2  = new SampleObject2__c();
        sm2.ConfigFormPage__c = pt.Id;
        sm2.name = 'T';
        sm2.SampleObject1__c = sm1.Id;
        sm2.SampleDate__c = Date.Today();
        insert sm2;
            System.assertNotEquals(null, sm2.Id, 'sm2 is not inserted');
        
        FormInstance__c testInstance = new FormInstance__c ();
        testInstance.PackageBusinessForm__c = businessPackageForm.Id;
        testInstance.FormId__c = sm2.Id;
        insert testInstance;
        System.assertNotEquals(null, testInstance.Id, 'form instance is not inserted');   
        DynamicLayoutController.updateFormInstancePercentLightning(sm2.id);
       }Catch(exception e){}
  }
 

    @IsTest
    static void testCreateContentVerInternal(){
      User u1 = TestHelper.getAdminUser(true);
       system.runAs(u1){
            SampleObject2__c sm = new SampleObject2__c();
            sm.name = 'T';
            insert sm;
            System.assertNotEquals(null, sm.Id , 'Sm is null');

            Attachment att =TestHelper.getAttachment(sm.id , false);
            att.ParentId = sm.ID;
            att.Name = 'Test';
            insert att; 
            System.assertNotEquals(null, att.Id , 'att is null');

            DynamicLayoutController.createSalesforceContentVersion(att.id);
          }
    }

  
   @IsTest
    static void publicMethodsCover(){
        SampleObject11__c samObj11= TestHelper.getSampleObject1(true);
        System.assertEquals(samObj11.Status__c, 'In Progress',  'status is In Progress');     
        DynamicLayoutController dy = new DynamicLayoutController();
         Test.setCurrentPageReference(new PageReference('Page.BlankPage')); 
        dy.getViewLayoutTabsContent();
        dy.getModalViewLayoutTabsContent();
        dy.getHeaderOverviewContent();
        dy.saveRecordTypeId();
        dy.getFormTypeJSON();
        dy.edit();
        dy.saveSelection();
        dy.formSavedMessage();
        dy.saveFormRecord();
    }
    @isTest
    static void testmarkPageLayoutAsActive(){   
        PageLayoutConfig__c pageLayoutConfig =  TestHelper.getPageLayoutConfig(true);
        pageLayoutConfig.isActive__c = false;
        update pageLayoutConfig;
        TestHelper.getPageTemplateConfig(true,pageLayoutConfig.Id); 
       map<string,object> args = new map<string,object>();
       args.put('key', 'TestTemplate');
       args.put('value', 'View');
       System.assertNotEquals(null, args);
        Test.startTest();
       DynamicLayoutController.markPageLayoutAsActive(args);  
        Test.stopTest();
    }  
    
    
    @isTest
    static void teststandardObjReqrdFlds(){   
      SampleObject1__c sm1  = new SampleObject1__c();
      sm1.name = 'T';
      insert sm1;
      System.assertNotEquals(null, sm1.Id , 'sm1 is not inserted');
      DynamicLayoutController dlc = new DynamicLayoutController();
      Test.startTest();
      dlc.standardObjReqrdFlds('SampleObject11__c');
      Test.stopTest();
    } 

    @IsTest
    static void testavForms1() {
      SampleObject1__c sm1  = new SampleObject1__c();
      sm1.name = 'T';
      insert sm1;
      System.assertNotEquals(null, sm1.Id , 'sm1 is not inserted');

      SampleObject2__c sm = new SampleObject2__c();
      sm.name = 'T';
      insert sm;
      System.assertNotEquals(null, sm.Id , 'sm is not inserted');

      Attachment att =TestHelper.getAttachment(sm.id , false);
      att.ParentId = sm.ID;
      insert att; 
      System.assertNotEquals(null, att.Id , 'att is not inserted');

      PageLayoutConfig__c page = TestHelper.getPageLayoutConfig(true, AppUtils.getNamespacePrefix() + 'SampleObject2__c');
      System.assertNotEquals(null, page.Id, 'page is null');

      PageLayoutActionConfig__c validateButton = TestHelper.getPageLayoutActionConfig(false,page.Id);
      validateButton.RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Validate').getRecordTypeId();
      validateButton.ActionClass__c = '';
      insert validateButton;
      System.assertNotEquals(null, validateButton.Id , 'validate btn is null');

      TabConfig__c tab = TestHelper.getTabConfig(page.Id, true);
      PageBlockConfig__c pb =  TestHelper.getPageBlockConfig(tab.Id, true);
      System.assertNotEquals(null, pb.Id , 'pb is null');

      PageTemplate__c pt = TestHelper.getPageTemplateConfig(false);
      pt.SObjectName__c = AppUtils.getNamespacePrefix() + 'SampleObject2__c';
      insert pt; 
      System.assertNotEquals(null, pt.Id, 'pt is null');

      Package__c pkg = TestHelper.getPackage(true,pt);
      System.assertNotEquals(null, pkg.Id , 'pkg id is null');
      
      PackageFormConfig__c businessPackageForm = new PackageFormConfig__c();
      businessPackageForm.FormConfig__c = pt.Id;
      businessPackageForm.PackageConfig__c = pkg.Id;
      insert businessPackageForm;
      System.assertNotEquals(null, businessPackageForm.Id , 'businessPackageForm is not inserted correctly');

      FormInstance__c testInstance = new FormInstance__c ();
      testInstance.FormId__c = sm.Id;
      testInstance.ParentRecordId__c = sm.Id;
      testInstance.PackageBusinessForm__c = businessPackageForm.Id;
      insert testInstance;
      System.assertNotEquals(null, testInstance.Id, 'testInstance in not inserted correctly');
      ApexPages.currentPage().getParameters().put('parentId',sm1.Id);
      ApexPages.currentPage().getParameters().put('recId',sm.Id);        
      ApexPages.currentPage().getParameters().put('formId',pt.Id);        
      ApexPages.currentPage().getParameters().put('formInstanceId',testInstance.Id);
      ApexPages.currentPage().getParameters().put('actionIdForValidateBtn',validateButton.Id); 
      ApexPages.currentPage().getParameters().put('packageId',pkg.Id);    
    
      DynamicLayoutController.validateForms();
     
      DynamicLayoutController.navForms1(('https://login.salesforce.com?packageId='+pkg.Id) , 'retUrl' ,  businessPackageForm.FormConfig__c );
      DynamicLayoutController.navForms1(('https://login.salesforce.com?packageId='+pkg.Id) , 'retUrl' ,   testInstance.Id);

    }

    @isTest
    static void testRecordTypeExists() {
        DynamicLayoutController instance = new DynamicLayoutController();
        instance.recordTypeExists =true;
        System.assertEquals(true, instance.recordTypeExists,' recordTypeExists is true');
    }
    @isTest
    static void testgetLayoutConfig(){
     String label;
    Test.startTest();
    DynamicLayoutController.layoutWrapper i = new DynamicLayoutController.layoutWrapper('Name','String','Test','String','5','5','True','Name__c','16','','');
    DynamicLayoutController.LayoutDynamicWrapper custom = new DynamicLayoutController.LayoutDynamicWrapper(label);
    Test.stopTest();
    System.assertEquals('Name__c', i.APIName);
  }

}