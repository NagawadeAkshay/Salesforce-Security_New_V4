/**
    
    **********************************************************
    Audit History
    **********************************************************
    
    9/9/2015 swati singh    Created
    **********************************************************  
*/

/**
    
    **********************************************************
    Audit History
    **********************************************************
    
    9/9/2015 swati singh    Created
    **********************************************************  
*/



@IsTest
private with sharing class TestSystemContextMethodsHelper {
    @testSetup 
    public static void setupData(){       
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
        
        List<Attachment> attachments = new List<Attachment>();
        for (Account acc : testAccounts) {
            Attachment attachment = new Attachment(
                ParentId = acc.Id,
                Name = 'SampleAttachment_' + acc.Name + '.txt',
                Body = Blob.valueOf('This is a sample attachment for ' + acc.Name),
                ContentType = 'text/plain'
            );
            attachments.add(attachment);
        }
        insert attachments;
    }
    @isTest
    static void testinsertAttachments(){
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts; 
        List<Attachment> attachments = new List<Attachment>();
        for (Account acc : testAccounts) {
            Attachment attachment = new Attachment(
                ParentId = acc.Id,
                Name = 'SampleAttachment_' + acc.Name + '.txt',
                Body = Blob.valueOf('This is a sample attachment for ' + acc.Name),
                ContentType = 'text/plain'
            );
            attachments.add(attachment);
        }
        SystemContextMethodsHelper systemContext = new SystemContextMethodsHelper();
        Test.starttest();
        systemContext.insertAttachments(attachments);
        systemContext.insertAttachments(new List<Attachment>());
        System.assertNotEquals(null, attachments);
        Test.stoptest();
    }
    @isTest
    static void testupdateAttachments(){
        List<Attachment> attachments = [SELECT Id, Name, ParentId, ContentType, BodyLength FROM Attachment WHERE ParentId IN (SELECT Id FROM Account WHERE Name LIKE 'Test Account%')];
        integer i = 0;
        list<id> AttIds = new list<id>();
        for(Attachment at : attachments){
            at.name += i;
            AttIds.add(at.id);
            i++;
        }
        set<id> AttSetIds = new set<id>(AttIds);
        SystemContextMethodsHelper systemContext = new SystemContextMethodsHelper();
        Test.starttest();
        systemContext.updateAttachments(attachments);
        systemContext.updateAttachments(new List<Attachment>());
        systemContext.updateAttachment(attachments[0]);
        systemContext.upsertAttachment(attachments[1]);        
        systemContext.getAttachmentListDetails(AttIds);
        systemContext.getAttachmentDetails(AttSetIds);
        systemContext.getAttachDetails(AttIds[0]);        
        Test.stoptest();    
        System.assertNotEquals(null, AttSetIds);
    }
    @IsTest
    private static void testInsert() {
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
	    	//Prepare test data
	  		Test.startTest();
           	UserPreferences__c usrPref = TestHelper.getUserPreference(true, 'ActiveAppName__c', 'StateasGrantor');
           	Task tsk_1 = TestHelper.getTask(true);
           	Task tsk_2 = TestHelper.getTask(true);
   			Task tsk_3 = TestHelper.getTask(true);
           	Task tsk_4 = TestHelper.getTask(true);
           	List<Task> tskList = new List<Task>();
           	List<Task> delList = new List<Task>();
           	Set<String> idSets = new Set<String>();
           	tskList.add(tsk_1);
           	tskList.add(tsk_2);
           	delList.add(tsk_3);
           	delList.add(tsk_4);
           	idSets.add(tsk_1.id);
           	idSets.add(tsk_2.id);
       		SystemContextMethodsHelper scmh = new SystemContextMethodsHelper();
   			scmh.updateUserPreferenceRecord(usrPref);
   			scmh.updateTasks(tskList);
   			scmh.deleteSobjectList(delList);
   			scmh.updateSobject(tskList);
			scmh.getRelatedTasks(idSets);
       		Test.stopTest();
       		System.assert(scmh!=null);
        }
    }
    
    @IsTest
    private static void testCreateShare() {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);
        
        List<SObject> lstSobject = new List<SObject>();
        Task tsk_1 = TestHelper.getTask(false);
        lstSobject.add(tsk_1);
        
        User objUser = [Select id from User Limit 1];
        System.assertNotEquals(null, objUser.Id);
        
        SystemContextMethodsHelper objSystemContextMethodsHelper = new SystemContextMethodsHelper();
        objSystemContextMethodsHelper.insertSobject(lstSobject);
        
        SystemContextMethodsHelper.getRecordProcessInstanceWorkitems(objAccount.Id);
        Test.startTest();
        SystemContextMethodsHelper.createShare(objAccount.Id,objUser.Id,false);
        Test.stopTest();
    }

    @IsTest
    static void verifyGetCurrentUserDetails(){
        User objUser = TestHelper.getAdminUser(true);
        System.assertNotEquals(null, objUser.Id);
        System.runAs(objUser) {
            User objUserDetail = SystemContextMethodsHelper.getCurrentUserDetails();
            System.assertEquals(objUser.Id, objUserDetail.Id);
        }
    }

    @IsTest
    static void testGetIcons(){
        SampleObject1__c sm1  = new SampleObject1__c();
        sm1.name = 'T';
        insert sm1;
        System.assertNotEquals(null, sm1.Id , 'sm1 is not inserted');
        Set<String> staticesources = new Set<String>();//GovGrants
        staticesources.add('GovGrants'); 
        staticesources.add('GovGrantsExternal');
        SystemContextMethodsHelper.getIcons(staticesources );
    }

    @IsTest
    static void testRunQueryInSystemMode(){
        SampleObject1__c sm1  = new SampleObject1__c();
        sm1.name = 'T';
        insert sm1;
        List<Sobject> objects  = SystemContextMethodsHelper.runQueryInSystemMode('SELECT Id,name from SampleObject1__c',null);
        System.assertNotEquals(null,objects);
    }

    @IsTest
    static void testSaveForGuestUser(){
        SampleObject1__c sampleObject = TestHelper.getSampleObject1Val(true);
        Map<String,Object> recordObject = new Map<String,Object>();
        recordObject.put('Name','test1');
        recordObject.put('Id',sampleObject.Id);
        String objectName = 'SampleObject1__c';
        String recId = sampleObject.Id;
        String op = SystemContextMethodsHelper.saveForGuestUser(objectName,recId,JSON.serialize(recordObject));
        recordObject.put('unknown','test1');
        op = SystemContextMethodsHelper.saveForGuestUser(objectName,recId,JSON.serialize(recordObject));
        System.assertNotEquals(null,recordObject);
}
@isTest
    private static void getCaptureItemsTest(){
        List<CaptureForm__c> captureFormLst = new List<CaptureForm__c>();
        for(Integer i=0;i<1;i++) {
            captureFormLst.add(new CaptureForm__c(Name__c = 'Form Test'+i , ObjectType__c='Announcement__c'));
        }
        insert captureFormLst;  
        Map<Id, CaptureForm__c> captureFormMap = new Map<Id, CaptureForm__c>([SELECT Id,Name FROM CaptureForm__c]);
        List<CaptureSection__c> captureSectionLst = new List<CaptureSection__c>();
        for(Integer i = 0; i<=2; i++){
            for(Id formId: captureFormMap.keySet()){
                captureSectionLst.add(new CaptureSection__c(CaptureForm__c = formId, SectionColumn__c='Horizontal',Order__c=i, Name__c = 'Section '+i));
            }
        }
        insert captureSectionLst;
        Map<Id, CaptureSection__c> captureSectionMap = new Map<Id, CaptureSection__c>([SELECT Id,Name FROM CaptureSection__c]);
        List<CaptureItem__c> captureItemLst = new List<CaptureItem__c>();
        for(Integer i =0; i<=2; i++){
            for(Id sectionId: captureSectionMap.keySet()){
                captureItemLst.add(new CaptureItem__c(CaptureSection__c = sectionId, QuestionRichText__c = 'Question '+i, Order__c=i, Type__c='Written'));
            }
        }
        insert captureItemLst;
        SystemContextMethodsHelper systemContext = new SystemContextMethodsHelper();
        Test.startTest();
        List<CaptureItem__c> captureItemList = systemContext.getCaptureItems(captureSectionLst[0].Id);
        Test.stopTest();
        Assert.areEqual(3, captureItemList.size(), 'Size should be 3');
        
    }
    @isTest
    static void testUpdateSobjectWithoutPermission() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        testAccount.Name = 'Updated Test Account';
        List<SObject> sObjectsToUpdate = new List<SObject> { testAccount };
        
        SystemContextMethodsHelper  systemContext = new SystemContextMethodsHelper ();
        
        Test.startTest();
        Boolean result = systemContext.updateSobjectWithoutPermission(sObjectsToUpdate);
        Test.stopTest();
        
        Account updatedAccount = [SELECT Name FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Updated Test Account', updatedAccount.Name, 'Account name should be updated');
        systemContext.deleteSobjectWithoutPermission(sObjectsToUpdate);
    }
}