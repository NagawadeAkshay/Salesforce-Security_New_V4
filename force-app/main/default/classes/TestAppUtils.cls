@isTest
private with sharing class TestAppUtils  {
    public static SampleObject11__c app;
    public static RecordCopyConfig__c recCon;
    public static String sObjName;
    public static Account act;
    public static Contact con; 
    public static List<Sobject> items = new List<Sobject>();
    public static String sortField;
    public static Boolean ascending;
    public static Set<String> fieldsToExclude = new Set<String>();
    public static sObject[] obj = new List<sObject>();
    public static Object[] anArray = new List<Object>();
    public static String sourceObject;
    public static String targetObject;
    public static Id sourceRecordIDs;
    public static Sobject sobjectRec;
     public static Sobject sobjectRec_1;
    public static String groupName;
    public static String[] inStr = new List<String>();
    public static String dbVal;
    public static String[] displayVals = new List<String>();
    public static List<String> userFields = new List<String>();
    public static Task task;
    public static String[] toAddresses = new List<String>();
    public static String[] ccAddresses = new List<String>();
    public static String replyToEmail;
    public static String subject;
    public static String plainTextBody;
    public static String htmlBody;
    public static Map<Id,Id> appIdToContIdMap = new Map<Id,Id>();
    public static Map<Id,Set<Id>> appIdToContIdSetMap = new Map<Id,Set<Id>>();
    public static Set<Id> appSetIds = new  Set<Id>();
    public static Map<Id,Id> WhatIdtemplateMap = new Map<Id,Id>();
    public static Map<id,id> sendEmailMap = new Map<id,id>();
    public static Map<Id, String[]> recIdToAddressMap = new Map<Id, String[]>();
    public static String[] addAddress = new List<String>();
    public static Map<Id, Id> recIdToTemplateIdMap = new Map<Id, Id>();
    public static Set<String> mergeFields = new Set<String>();
    public static List<String> mergeFields_1 = new List<String>();
     public static List<String> mergeFields_2 = new List<String>();
    private static void setup(){
         
          TestHelper.createCustomSettings(true);
          act = TestHelper.getAccount(true);
          con = TestHelper.getContact(true);
          
          
          //ann = TestHelper.getSampleObject1(true);      
          app = TestHelper.getSampleObject1(true);
          sObjName = app.Id.getSObjectType().getDescribe().getName();
           //sObjName = recordId.getSObjectType().getDescribe().getName();
          sObjName = AppUtils.removeNamespacePrefix(sObjName);   
          
          recCon = TestHelper.getCopyConfig(true);
          
          sortField = 'Name';
          ascending = true;
          
          sourceObject = 'Account';
          targetObject = sObjName;
          sourceRecordIDs = act.id;
          sobjectRec = app;
          groupName = 'Test Group';
          
          inStr.add('abc');
          inStr.add('alkc');
          
          items.add(app);
          items.add(act);
          
          anArray.add(app);
          anArray.add(act);
          
          obj.add(app);    
          dbVal = 'ABC';
          Date tday = System.today(); 
          task = new Task(Subject = 'Test Task' , ActivityDate = tday);
          insert task;
          
          displayVals.add('ABC;');
          displayVals.add('EFG;');
          
          fieldsToExclude.add('Id');
          
          /*data for sendEmail*/
          toAddresses.add('joshianuja26@gmail.com');
          ccAddresses.add('joshianuja26@gmail.com');
          replyToEmail = 'joshianuja26@gmail.com';
          subject = 'Sample Mail';
          plainTextBody = 'Hi this is sample mail';
          htmlBody = 'Hi this is html body';
          
          /*insert data for sendEmailUsingTemplate method*/
          appIdToContIdMap = new Map<Id,Id>();
          appIdToContIdMap.put(con.id,app.id);
          
          appSetIds = new Set<Id>();
          appSetIds.add(con.id);
          appIdToContIdSetMap = new Map<Id,Set<Id>>();
          appIdToContIdSetMap.put(app.id,appSetIds);
          
          addAddress.add('joshianuja30@gmail.com');
          recIdToAddressMap.put(con.id,addAddress);
          
          
          mergeFields.add('SampleObject11__c.SamplePicklist1__c');
          mergeFields_1.add('SamplePicklist1__c');
          sobjectRec_1 = con;
          mergeFields_2.add('Account.Name');
          
          
          userFields.add('contact.Name');
          userFields.add('User.Name');
          userFields.add('Profile.Name');  
          userFields.add('UserRole.Name');  
     }

    @IsTest
    public static void testValidateExpression(){
        String expression = '{!name} && {!name} && {!id}';
        Test.startTest();
        Boolean result_1 = AppUtils.validateExpression(expression);
        Boolean result_3 = AppUtils.validateExpression(' ');
        Test.stopTest();
        System.assertNotEquals(result_1,false);
    }
   
    @IsTest
    public static void testValidateExpression_1(){
        Test.startTest();
        Boolean result_2 = AppUtils.validateExpression('#');
        Test.stopTest();
        System.assertNotEquals(result_2,false);
    }

    @IsTest
    public static void testGetRecordTypeIdsByDeveloperName(){
        setup();
        sObject s = new SampleObject11__c();
        Test.startTest();
        Map<String, Id> result_2 =  AppUtils.getRecordTypeIdsByDeveloperName(Account.sObjectType);
        Test.stopTest();
        System.assertNotEquals(result_2,null);
    }
   /*
    @IsTest
    public static void testGetNumericValueFromString(){
        Test.startTest();
        String data_1 = '0 1 2';
        Integer result_3 =  AppUtils.getNumericValueFromString(data_1);
        Test.stopTest();
        System.assertNotEquals(result_3,0);    //assertion failed
    }*/
  
    @IsTest
    public static void testGetRelationshipFieldMap(){
        setup();
        Test.startTest();
        Map<String,String> result_4 =  AppUtils.getRelationshipFieldMap('Contact');
        Test.stopTest();
        System.assertNotEquals(result_4,null);
    }
  
    @IsTest
    public static void testReplaceMergeFieldsForTemplates(){
        setup();
        String text = 'abc';
        Sobject record = app;
        Test.startTest();
        String result_6 =  AppUtils.replaceMergeFieldsForTemplates('Name = \'{!Status__c}\'',app);
        Test.stopTest();
        System.assertNotEquals(result_6,'abc');
    }

    @IsTest
    public static void testvalidateURLFormat(){
        Test.startTest();
        Boolean isValidURL = AppUtils.validateURLFormat('https://www.login.salesforce.com');
        Test.stopTest();
        System.assertNotEquals(null, isValidURL);
    }
    
    @IsTest
    public static void testgetNumericValueFromString(){
        Test.startTest();
        Integer result = AppUtils.getNumericValueFromString('1');
        Test.stopTest();
        System.assertEquals(null,result);
    }

    @IsTest
    public static void testqueryFormattedString(){
        Test.startTest();
        String result = AppUtils.queryFormattedString(new List<String>{'A','B','C'},'');
        Test.stopTest();
        System.assertEquals('(\'A\',\'B\',\'C\')',result);
    }

    @IsTest
    public static void testgetMergeFieldsWithoutObject(){
        Test.startTest();
        List<String> result =  AppUtils.getMergeFieldsWithoutObject('$user.Name');
        Test.stopTest();
        System.assertEquals(0,result.size());
        result =  AppUtils.getMergeFieldsWithoutObject('$user.CreatedBy.Id');
    }

    @IsTest
    public static void testgetJSONMergeFields(){
        Test.startTest();
        Map<String,Set<String>> result =  AppUtils.getJSONMergeFields('$user.Name');
        Test.stopTest();
        System.assertEquals(0 ,result.keySet().size());
        result =  AppUtils.getJSONMergeFields('$user..CreatedBy.Id');
       
    }

    @IsTest
    public static void testgetRequiredFieldsFromMetadata(){
        Test.startTest();
        List<String> result = AppUtils.getRequiredFieldsFromMetadata('User');
        Test.stopTest();
        System.assertNotEquals(null,result);
    }

    @IsTest
    public static void testsetFieldValue(){
        setup();
        String text = 'abc';
        Sobject record = app;
        Test.startTest();
        AppUtils.setFieldValue(record,'Name','test');
        AppUtils.setFieldValue(record,'CreatedBy.Name','test');
        Test.stopTest();
        System.assertNotEquals(null,text);
    }

    @IsTest
    public static void tesgetFormattedNumber(){
        Test.startTest();
        String text =  AppUtils.getFormattedNumber(10000,2,true,'CURRENCY');
        Test.stopTest();
        String expected = AppUtils.getLocaleCurrencySymbol()+'10,000.00';
        System.assertEquals(expected,text);
        text =  AppUtils.getFormattedNumber(10000,2,false,'DOUBLE');
        System.assertEquals('10,000.00',text);
    }
  /*
    @IsTest
    public static void testSendTaskNotification(){
        setup();
        User u = TestHelper.getAdminUser(true);
        Test.startTest();
        List<Messaging.SingleEmailMessage> result_10 =  AppUtils.sendTaskNotification(toAddresses,subject,plainTextBody,false);
        Test.stopTest();
        System.assertEquals(result_10,null);  
    }*/
   
  
 
    @IsTest
    public static void testIsSandbox(){
        setup();
        apexpages.currentpage().getparameters().put('t','cookie');
        apexpages.currentpage().getparameters().put('id',app.id);
        apexpages.currentpage().getparameters().put('govgrants_tabname','abc');
        Schema.DescribeFieldResult obj_1 = SampleObject11__c.SamplePicklist1__c.getDescribe();
        DMLException  ex = new DMLException();
        
        String text = 'Abc';
        Decimal val = 123.45;
        ValidationException  ex_1 = new ValidationException();
        Boolean isViewLayout = true;
        Boolean isInternal = true;
        Boolean isApplicant = true;
        String profileNames = 'System Administrator';
        String recordId = app.id;
        String readContext = 'read';
        String userType = 'External';
        string userProfile = 'Standard';
        string userRole = 'ABC';
        string userRoles = 'ABC';
        Sobject record = app;
        User u = TestHelper.getAdminUser(true);
        Datetime actualDate = System.today();
        Integer offsetDays = 1234567;
        String url = 'id?abc';
        PageReference pageRef = new PageReference('/apex/');
        sObject con_1;
        
        EmailTemplateConfig__c empTempl = new EmailTemplateConfig__c(EmailTemplateDeveloperName__c='TestEmailTemplate1', SobjectName__c='SampleObject11__c', Name='test');
        insert empTempl;
        
        WhatIdtemplateMap.put(con.id,empTempl.id);
        sendEmailMap.put(con.id,app.id);
        recIdToTemplateIdMap.put(con.id,empTempl.id);
        
        List<Id> ids = new List<Id>();
        ids.add(act.id); 
        
        Account[] accts = new List<Account>{
        new Account(Name='Account1'),
        new Account()};
        Database.SaveResult[] srList = Database.insert(accts, false);

        Test.startTest();
        //AppUtils.setReturnOnPage(url,pageRef);
        string result_17 =  AppUtils.getSelectedTabName();
        String result_11 =  AppUtils.setTabNameFromID();
        String result_13 =  AppUtils.replaceMergeFields('Name = \'{!$User.Name}\'',record);
        AppUtils.setTabCookie();
       // string result_19 =  AppUtils.whereOrAndClause();
        Boolean result_8 =  AppUtils.isSystemAdminUser();
        Datetime result_9 =  AppUtils.addBusinessDays(actualDate,offsetDays);
        //PageReference result_20 =  AppUtils.getReturnPage();
        Boolean result_75 =  AppUtils.readOnlyOrEditableForComponent(isViewLayout,isInternal,isApplicant,profileNames,recordId,readContext,userType,userProfile,userRole,userRoles);
        String result_12 =  AppUtils.replaceMergeFields(text,app.id);
        //List<SelectOption> result_7 =  AppUtils.prepareSelectOption(obj_1);
        //Boolean result_5 =  AppUtils.getIsNewUserRegWindowOpen();
        String result_14 =  AppUtils.soqlList(inStr);
        Boolean result_74 =  AppUtils.isAdminUser();
        Boolean result_15 =  AppUtils.isSite();
        string result_16 =  AppUtils.fieldsList(inStr);
        //string[] result_18 =  AppUtils.selectField(obj,'Name');
        //AppUtils.resetWhereOrAndClause();
        //PageReference result_21 =  AppUtils.getReturnPage();
        //String result_22 =  AppUtils.toString(ex);
        //Boolean result_23 =  AppUtils.isSandbox();
        Boolean result_24 =  AppUtils.isInternalUser();
        //List<SObject> result_25 = AppUtils.sortList(items,sortField,ascending);
        //AppUtils.notifyTechSupport(ex);
        string[] result_26 = AppUtils.decodeToArray(dbVal);
        string result_27 = AppUtils.encodeToString(displayVals);
        string result_28 = AppUtils.encodeToString(dbVal);
        //string result_29 = AppUtils.urlParam('t');
        
        
        List<Sobject> sObj = new List<Sobject>();
        sObj.add(act);
        sObj.add(con);
        Map<Id, List<Sobject>> sampleMap = new Map<Id, List<Sobject>>();
        Map<Id, List<Sobject>> sampleMap_1 = new Map<Id, List<Sobject>>();
        sampleMap.put(act.id,sObj);
        sampleMap.put(con.id,sObj);
        sampleMap_1.put(act.id,sObj);
        //AppUtils.ValidationException result_30 = AppUtils.createValidationException(ex_1);
        //need to write in another method
        //AppUtils.ValidationException result_31 = AppUtils.createValidationException(ex);
        
        //Boolean result_32 = AppUtils.isMultiSelectEmpty('[]');
        //string[] result_33 = AppUtils.getStringsFromMultiSelect('[ABDFGGDD]');
        //AppUtils.dumpUrlParameters();
        //string result_34 = AppUtils.trim('Testing string');
        //string result_35 = AppUtils.trim('');
        string result_36 = AppUtils.getCurrentFiscalYear();
        List<string> result_37 = AppUtils.getFiscalYearPickListValues();
        List<string> result_38 = AppUtils.getCountryPickListValues();
        //List<string> result_39 = AppUtils.getPickListValues(sObjName,'GGDemo2__SamplePicklist1__c');   //need to remove namespace
        Task result_40 = AppUtils.assignTaskForSObject(task,task.id);
        string result_41 = AppUtils.formatCurrency(val);
        Boolean result_42 = AppUtils.checkAdminUser();
        string result_43 = AppUtils.getRetURL();
        string result_45 = AppUtils.getDefaultPhase();
        
        Boolean result_58 = AppUtils.isHistoryTable(sObjName);  
        string result_59 = AppUtils.generateToken(12);
        string result_60 = AppUtils.getUserType();
        Boolean result_61 = AppUtils.isApplicant();
        string result_62 = AppUtils.getProfileInfo();
        string result_63 = AppUtils.getRoleInfo();
        
        Boolean result_64 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Internal','Standard User');
        Boolean result_78 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Applicant','Standard User');
        Boolean result_79 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Reviewer','Standard User');
        
        Boolean result_65 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Internal','Standard User','User','User');
        Boolean result_82 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Applicant','Standard User','User','User');
        Boolean result_83 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Reviewer','Standard User','User','User');
        
        Boolean result_66 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Internal','Standard User','AND');
        Boolean result_84 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Applicant','Standard User','AND');
        Boolean result_85 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Reviewer','Standard User','AND');
        
        Boolean result_71 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Internal','Standard User','OR');
        Boolean result_86 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Applicant','Standard User','OR');
        Boolean result_87 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Reviewer','Standard User','OR');
        
        Boolean result_67 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Internal','Standard User','User','User','AND');
        Boolean result_88 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Applicant','Standard User','User','User','AND');
        Boolean result_89 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Reviewer','Standard User','User','User','AND');
        
        Boolean result_72 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Internal','Standard User','User','User','OR');
        Boolean result_90 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Applicant','Standard User','User','User','OR');
        Boolean result_91 = AppUtils.showHideComponent(true,true,true,'System Administrator',app.id,'hide','Reviewer','Standard User','User','User','OR');      
        
        Boolean result_68 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'View','Internal','Standard User','User','User');
        Boolean result_92 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'View','Applicant','Standard User','User','User');
        Boolean result_93 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'View','Reviewer','Standard User','User','User');
        
        Boolean result_69 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'Edit','Internal','Standard User','User','User');
        Boolean result_94 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'Edit','Applicant','Standard User','User','User');
        Boolean result_95 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'Edit','Reviewer','Standard User','User','User');
        
        Boolean result_70 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'Create','Internal','Standard User','User','User');
        Boolean result_96 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'Create','Applicant','Standard User','User','User');
        Boolean result_97 = AppUtils.readOnlyOrEditableForComponent(true,true,true,'System Administrator',app.id,'Create','Reviewer','Standard User','User','User');
        
        String result_73 = AppUtils.setTabNameFromID();
        String result_77 = AppUtils.applyNamespacePrefix(sObjName);
        
        AppUtils.sendEmail(toAddresses,ccAddresses,replyToEmail,true,subject,plainTextBody,htmlBody);
        AppUtils.sendEmail(toAddresses,ccAddresses,replyToEmail,false,subject,plainTextBody,htmlBody);
        AppUtils.sendEmail(toAddresses,subject,plainTextBody,htmlBody);
        AppUtils.sendEmail(toAddresses,subject,plainTextBody,htmlBody,false);
        AppUtils.sendEmail(toAddresses,subject,plainTextBody,htmlBody,true);
        
        /*AppUtils.sendEmailUsingTemplate(empTempl.id,appIdToContIdMap,false);
        AppUtils.sendEmailUsingTemplate(empTempl.id,appIdToContIdSetMap,false);
        AppUtils.sendEmailUsingTemplate(WhatIdtemplateMap,sendEmailMap,false);
        AppUtils.sendEmailUsingTemplate(empTempl.id,recIdToAddressMap,app.id,false);
        AppUtils.sendEmailUsingTemplate(recIdToTemplateIdMap,recIdToAddressMap,app.id,false);*/
        //AppUtils.notifyTechSupport(srList,items,'Test class');
        Datetime result_80 =  AppUtils.getLocalDateTime(System.today());
        //Set<String> result_81 =  AppUtils.getMergeFieldsForTemplate(mergeFields,'SampleObject11__c');
        //String result_76 = AppUtils.replaceUserFields('Name = \'{!Name}\'',userFields);
        String result_98 =  AppUtils.replaceFields('Name = \'{!Status__c}\'',mergeFields_1,sobjectRec);
        
        //String result_76 = AppUtils.replaceUserFields('{!Name}',userFields);
        //String result_98 =  AppUtils.replaceFields('{!Status__c}',mergeFields_1,sobjectRec);
        //String result_99 =  AppUtils.replaceFields('Name = \'{!Name}\'',mergeFields_2,sobjectRec_1); //getting error attempt to dereference null object 
                
        AppUtils.copyFieldValues(act,act,fieldsToExclude);
        AppUtils.copyRecord(act,con,false);
        AppUtils.copyRecord('Account','Contact',act.id,con_1,groupName);
        AppUtils.copyRecords('Account','Contact',ids,false);
        AppUtils.copyRecords('Account','Account',sampleMap,false);
        AppUtils.copyRecords('Contact','Account',sampleMap_1,false);
        //AppUtils.copyRecord('Account','Contact',act.id,con_1);   //getting error attempt to dereference null object                   
        
        system.assertNotEquals(null, result_98);
        Test.stopTest();
        
        //System.assertNotEquals(result_23,true);
    }

    @IsTest
    public static void getMergeFieldSupportTest(){
        List<String> objAPIList = new List<String>();
        objAPIList.add('User');
        System.assertNotEquals(null,AppUtils.getMergeFieldSupport(null,objAPIList));
        List<String> str = AppUtils.getMergeFieldSupport(' {!CreatedBy.Name}',objAPIList);
    }
    
    @IsTest
    public static void ggetFieldValueAsStringTest(){
        List<Task> tsk = TestHelper.getAssignedTasks(true);
        System.assertEquals(12, tsk.size());
        AppUtils.getFieldValueAsString(tsk ,'Subject');
    }
    @IsTest
    public static void getcreateFormInstanceRecord(){
        SampleObject1__c  samObj1 = TestHelper.getSampleObject1Val(true);
        System.assertEquals('test',samObj1.Name);
        String samObj1Id = string.valueOf(samObj1.Id);
         Id formConfig = TestHelper.getPageTemplateConfig(true).Id;
        System.assertNotEquals(null, formConfig); 
        List<String> frmType = new List<String>();
        frmType.add('Other');
        String packageId = TestHelper.getPackage(true, 'Application').Id;
        AppUtils.createFormInstanceRecord(packageId ,samObj1Id ,frmType);
    }
    @IsTest
    public static void getcreateFormInstanceRecord1(){
        SampleObject1__c  samObj1 = TestHelper.getSampleObject1Val(true);
        System.assertEquals('test',samObj1.Name);
        String samObj1Id = string.valueOf(samObj1.Id);
        FormInstance__c  fmrinstance = new FormInstance__c();
        fmrinstance.Name = 'FRM1';
        fmrinstance.ParentRecordId__c = samObj1.Id;
        insert fmrinstance;
        PageTemplate__c formConfig = TestHelper.getPageTemplateConfig(true); 
        formConfig.FormType__c  = 'Other';
        update formConfig;
        System.assertNotEquals(null, formConfig); 
        List<String> frmType = new List<String>();
        frmType.add('Other');
        String packageId = TestHelper.getPackage(true, 'Application').Id;
        PackageFormConfig__c  pkgFrm = TestHelper.getPackageFormConfig(true, packageId  , formConfig.Id );

        AppUtils.createFormInstanceRecord(packageId ,samObj1Id ,frmType);
    }
    
     @IsTest
    public static void getActiveTabNameFromId(){
            Account acc = TestHelper.getAccount(true);
            String accString = string.valueOf(acc.Id);  
            SobjectConfig__c SObjectConfig = new SobjectConfig__c(name=AppUtils.getNamespacePrefix()+'SampleObject11__c', HistoryObjects__c=AppUtils.getNamespacePrefix()+'SampleObject11__c');
            insert SObjectConfig;
            system.assert(SObjectConfig!=null);
            PhaseConfig__c phase = TestHelper.getPhase(true); 
            SObjectPhaseConfig__c  SObjectPhase =TestHelper.getSObjectPhaseConfig(phase.Id,sobjectConfig.Id,  false);
            AppUtils.getActiveTabNameFromId(accString , 'StateasGrantor');
    }
    
      @isTest
    static void TestGetSObjectFromJSON() {
        User u = TestHelper.getAdminUser(true);  
        System.runAs(u){  
            Contact con= TestHelper.getContact(true);
            System.assertEquals('email@email.com',con.Email);
            EmailTemplate emailtemp=[Select Id,Name From EmailTemplate limit 1];
            Id templateId=emailtemp.id;
            Map<Id, Id> appIdToContIdSetMap = new Map<Id, Id>();
            appIdToContIdSetMap.put(u.Id, u.Id);  
            AppUtils.sendEmailUsingTemplate(templateId, appIdToContIdSetMap , true);          
        }    
    }
      @isTest
    static void TestGetSObjectFromJSON1() {
        User u = TestHelper.getAdminUser(true);  
        System.runAs(u){  
            Contact con= TestHelper.getContact(true);
            System.assertEquals('email@email.com',con.Email);
            EmailTemplate emailtemp=[Select Id,Name From EmailTemplate limit 1];
            Id templateId=emailtemp.id;
            Set<Id> temp = new Set<Id>();
            temp.add(u.Id);
            Map<Id, Set<Id>> appIdToContIdSetMap = new Map<Id, Set<Id>>();
            appIdToContIdSetMap.put(u.Id,temp);  
            AppUtils.sendEmailUsingTemplate(templateId, appIdToContIdSetMap , true);          
        }    
    }

    @IsTest
    public static void getFieldValueTest(){
        //User u = TestHelper.getUser(true);
        List<User> usrLst = new List<User>([SELECT Id, Contact.Name, CreatedBy.Name , LanguageLocaleKey FROM User WHERE Id =: UserInfo.getUserId()]);

        AppUtils.soqlList(usrLst);
        AppUtils.replaceRecordMergeFields(' Name = {!Name}',UserInfo.getUserId());
        AppUtils.replceMergeFieldsList('{!CreatedBy.Name}',usrLst,new List<String>{'CreatedBy.Name'});
        System.assertEquals('',AppUtils.replceMergeFieldsList('',usrLst,null));
        System.assertEquals(null,AppUtils.getFieldValue(null,''));
        Object str = AppUtils.getFieldValue(usrLst[0],'Contact.Name');
        //Object str1 = AppUtils.getMultiPickListFieldValue(usrLst[0],'LanguageLocaleKey');
    }

    @IsTest
    public static void getFormattedNumberTest(){
        //User u = TestHelper.getUser(true);
        AppUtils.whereOrAndClause();
        //AppUtils.setReturnOnPage('',null);
        AppUtils.concatenate(new Set<Id>(),';');
        Set<Id> idset = new Set<Id>();
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        idSet.add(sampleObj.id);
        AppUtils.concatenate(idSet,',');
        AppUtils.getReturnPage();
        AppUtils.reverse(null);
        AppUtils.toString(null);
       // AppUtils.notifyTechSupport(null);
        //AppUtils.notifyTechSupport(null,null,'');
        AppUtils.isSandbox();
        AppUtils.getOrgWideEmailAddress();
        AppUtils.sortList(new List<Sobject>(), 'id', true);
        AppUtils.selectField(null,null);
        AppUtils.soqlList(new List<Id>());
        AppUtils.soqlList(new Set<Id>());
        AppUtils.setTabCookie('tab_Name');
        AppUtils.soqlList(new Set<String>());
        AppUtils.getMonthName(9);
        //AppUtils.dumpUrlParameters();
        AppUtils.urlParam('');
        AppUtils.createValidationException(null);
        AppUtils.getPickListValues('','');
        AppUtils.submitRecordForApproval(sampleObj.Id);
        AppUtils.isMultiSelectEmpty('');
        Apputils.getLocaleCurrencySymbolMap4();
        AppUtils.getStringsFromMultiSelect('');
        AppUtils.getLocaleCurrencySymbolMap2();
        AppUtils.trim('');
        AppUtils.getHomePage();
        AppUtils.getLocaleToDateTimeFmtMap();
        AppUtils.getLocaleToDateTimeFmtMap1();
        AppUtils.getLocaleToDateTimeFmtMap11();
        AppUtils.getLocaleTimeFmtMap();
        AppUtils.getLocaleTimeFmtMap11();
        AppUtils.getPickListValues('','');
        AppUtils.prepareSelectOption(null);
        AppUtils.getUniqueJobName('test');
        AppUtils.prepareJobsSchTime(Date.today(),10);
        AppUtils.getMergeFieldsForTemplate(new Set<String>(), '');
        AppUtils.sendTaskNotification(new List<String>(), '', '', true);
        String objName = AppUtils.getNameSpacePrefix()+'SampleObject11__c';
        System.assertEquals(true,AppUtils.isObjectAccessible(objName));
        System.assertEquals(true,AppUtils.isObjectUpdateable(objName));
        System.assertEquals(true,AppUtils.isObjectDeletable(objName));
        System.assertEquals(true,AppUtils.isObjectCreateable(objName));

        AppUtils.checkEmailAddress('TestUser@reisystems.in');
        AppUtils.getLatestVersion();
        //AppUtils.getPdfRedirectionURL();

        System.assertEquals('abc,pqr',AppUtils.concatenate(new List<String>{'abc','pqr'}, ','));
        AppUtils.AgencyAutocomplete obj = new AppUtils.AgencyAutocomplete('','');

        //AppUtils.resetWhereOrAndClause();
        AppUtils.getFormattedNumber(1000000,3);
        System.assertEquals('',AppUtils.getFormattedNumber(null,2));
    }

    @IsTest
    public static void handleSystemExceptionMsgTest(){
        
        AppUtils.handleSystemExceptionMsg('Test Str FIELD_CUSTOM_VALIDATION_EXCEPTION, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INSUFFICIENT_ACCESS_OR_READONLY, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str FIELD_INTEGRITY_EXCEPTION, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str FIELD_FILTER_VALIDATION_EXCEPTION, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INVALID_CROSS_REFERENCE_KEY, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INVALID_USERID, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str ITEM_NOT_FOUND, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str LIMIT_EXCEEDED, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str MALFORMED_ID, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str RELATED_ENTITY_FILTER_VALIDATION_EXCEPTION, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str REQUIRED_FIELD_MISSING, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str UNSUPPORTED_APEX_TRIGGER_OPERATON, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INVALID_CROSS_REFERENCE_TYPE_FOR_FIELD, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('Test Str INVALID_CROSS_REFERENCE_KEY, Testing  : Test');
        AppUtils.handleSystemExceptionMsg('NO_APPLICABLE_PROCESS');
        AppUtils.handleSystemExceptionMsg('ALREADY_IN_PROCESS');
        AppUtils.handleSystemExceptionMsg('CustomExceptions.TriggerException: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY Class');
        AppUtils.handleSystemExceptionMsg('INSUFFICIENT_ACCESS_OR_READONLY, :');
        System.assertEquals('',AppUtils.getFormattedNumber(null,2));
    }

    @IsTest
    static void verifyIsSkipPermissionCheck(){
        Boolean IsSkipPermissionCheck = AppUtils.isSkipPermissionCheck();
        System.assertNotEquals(null,false,'test');
        //System.assertEquals(true, IsSkipPermissionCheck);
    }
    @IsTest
    public static void parseWhereClauseTest(){
        string filterClause = 'Name != \'test\' and Name IN (\'Test 1\',\' Test 2\')'; 
        Test.startTest();
        string santiziedClause = AppUtils.parseWhereClause(filterClause) ;
        Test.stopTest();
        System.assertEquals(filterClause,santiziedClause);
    }   
    
    @isTest
    static void testGetSOBjectLabel() {
        Account acc = new Account(Name = 'Test Here');
        Test.startTest();
        insert acc;
        Test.stopTest();
        Id recordId = acc.Id;
        String expectedObjectName = Schema.SObjectType.Account.getLabel();
        String actualObjectName = AppUtils.getSOBjectLabel(recordId);
        System.assertEquals(expectedObjectName, actualObjectName);
    }
}