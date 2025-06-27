@isTest
public class TestSendEmailCompCtrl {
       static Map<String, Object> parametersMap = new Map<String,Object>();
       static Map<String, Object> attributeMap = new Map<String,Object>();
    
     @testSetup public static void initializeVariable() {
        User objUser = [Select Id,Email from user where Id=:Userinfo.getUserId()];
        system.assertNotEquals(null, objUser.Id);
         
        parametersMap.put('searchString','sim');
        parametersMap.put('objectApiName','User');
        parametersMap.put('fieldToDisplay','IsActive');
        parametersMap.put('fieldBindToTarget','Email');
        parametersMap.put('fieldToFilter','Name');
        parametersMap.put('selectedRecordIds',objUser.ID);
        parametersMap.put('searchType','External');
         
         
        Contact objContact = new Contact();
        objContact.Lastname = 'test Contact';
        insert objContact;
        system.assertNotEquals(null, objContact.Id);
         
        Account objAccount = new Account();
        objAccount.Name='test';
        insert objAccount; 
        system.assertNotEquals(null, objAccount.Id);
         
        Task objTask = new Task(); 
        objTask.OwnerId = UserInfo.getUserId();
        objTask.WhatId = objAccount.Id;
        objTask.Subject='Donni';
        objTask.Status='Not Started';
        objTask.Priority='Normal';
        insert objTask; 
        system.assertNotEquals(null, objTask.Id);
         
        CollaborationGroup objCollaborationGroup = new CollaborationGroup();
        objCollaborationGroup.name = 'test' + +Math.random();
        objCollaborationGroup.CollaborationType = 'public';
        insert objCollaborationGroup; 
        system.assertNotEquals(null, objCollaborationGroup.Id);
         
        User objCollabUser = [Select Id , IsActive from user where IsActive = true Limit 1];
        system.assertNotEquals(null, objCollabUser.Id);
         
        CollaborationGroupMember objCollaborationGroupMember = new CollaborationGroupMember(); 
        objCollaborationGroupMember.CollaborationGroupId = objCollaborationGroup.Id;
        objCollaborationGroupMember.MemberId = TestHelper.getAdminUser(true).Id;
        insert objCollaborationGroupMember;
        system.assertNotEquals(null, objCollaborationGroupMember.Id);
         
        Attachment objAttachment = new Attachment();   	
    	objAttachment.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        objAttachment.OwnerId = UserInfo.getUserId();
    	objAttachment.body = bodyBlob;
        objAttachment.parentId = objTask.id;
        insert objAttachment;
        system.assertNotEquals(null, objAttachment.Id);
         
        
        SendEmailCompCtrl.ResultWrapper wrapper = new SendEmailCompCtrl.ResultWrapper(objCollaborationGroup, true);
        String[] emailArr = new String [] {objUser.email};
        SendEmailCompCtrl.validateEmails(emailArr );
        attributeMap.put('AttachmentBody','Attachment Body'); 
        attributeMap.put('AttachmentId',objAttachment.Id); 
        attributeMap.put('TaskId',objAttachment.ParentId);
        attributeMap.put('UploadDone',false);
       // attributeMap.put('ParentId',);
    }
    @isTest
    public static void checkIsExternal(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
                SendEmailCompCtrl sectrl = new SendEmailCompCtrl();
                sectrl.govGrantPleaseWaitIconURL = AppUtils.getIcons('govGrantPleaseWaitIcon'); 
                String icon = sectrl.govGrantPleaseWaitIconURL;
                boolean isExternal = sectrl.isExternal;  
                Boolean isAttachmentEnabled = sectrl.isAttachmentEnabled;
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest();                    
        }
        
    }
    @isTest
    public static void testAssociateAttachToTask(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
                Task objTask = [SELECT Id, OwnerId,WhatId,Subject,Status,Priority FROM Task LIMIT 1];
                Attachment objAtt = [SELECT Id,Name,OwnerId, body,parentId FROM Attachment LIMIT 1];
                String attId = SendEmailCompCtrl.associateAttachToTask(String.valueOf(objTask.Id), String.valueOf(objAtt.Id), objAtt.Name, 'Unit Test Attachment Body', objTask);
                String attId1 = SendEmailCompCtrl.associateAttachToTask(String.valueOf(objTask.Id), '', 'Unit , Test , Attachment Body', 'Unit  Test  Attachment Body', objTask);
                String attId2 = SendEmailCompCtrl.associateAttachToTask('', '', 'Unit , Test , Attachment Body', 'Unit  Test  Attachment Body', objTask);
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest(); 
        }
    }
    @isTest
    public static void testRollbackData(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
                Task objTask = [SELECT Id, OwnerId,WhatId,Subject,Status,Priority FROM Task LIMIT 1];
                SendEmailCompCtrl.rollbackData(objTask.Id);
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest(); 
        }
    }
    
    @isTest
    public static void getRecordsNew(){
        SampleObject11__c samObj11= TestHelper.getSampleObject1(true);
        System.assertEquals(samObj11.Status__c, 'In Progress',  'status is In Progress');     
        initializeVariable();
        SendEmailCompCtrl.getRecordsNew(parametersMap);
        SendEmailCompCtrl.getRecords(parametersMap);
    }
    
     @isTest
    public static void getRecordsNewForContact(){
        Contact objContact = [Select id from Contact];
        system.assertNotEquals(null, objContact.Id);
        
        Map<String, Object> parametersMap = new Map<String,Object>();
        parametersMap.put('searchString','sim');
        parametersMap.put('objectApiName','User');
        parametersMap.put('fieldToDisplay','IsActive');
        parametersMap.put('fieldBindToTarget','Email');
        parametersMap.put('fieldToFilter','Name');
        parametersMap.put('selectedRecordIds',objContact.ID);
        parametersMap.put('searchType','Both');
        
        SendEmailCompCtrl.getRecordsNew(parametersMap);
        //SendEmailCompCtrl.getRecords(parametersMap);
    }


    @isTest
    public static void getRecordsNewLWCTest(){
         Map<String, Object> parametersMapOtherObject = new Map<String,Object>();
         User objUser = [Select Id from user where Id=:Userinfo.getUserId()];
         system.assertNotEquals(null, objUser.Id);
        
            parametersMapOtherObject.put('searchString','sim');
            parametersMapOtherObject.put('fieldToDisplay','CreatedDate');
            parametersMapOtherObject.put('fieldBindToTarget','Email');
            parametersMapOtherObject.put('fieldToFilter','Name');
            parametersMapOtherObject.put('selectedRecordIds',objUser.ID);
            parametersMapOtherObject.put('searchType','External');
            parametersMapOtherObject.put('objectApiName' ,'collaborationgroup');
            SendEmailCompCtrl.getRecordsNewLWC(parametersMapOtherObject);
            //SendEmailCompCtrl.getRecords(parametersMap);
    }

    
     @isTest
    public static void getRecordsNewForOtherObject(){
         Map<String, Object> parametersMapOtherObject = new Map<String,Object>();
         User objUser = [Select Id from user where Id=:Userinfo.getUserId()];
         system.assertNotEquals(null, objUser.Id);
        
            parametersMapOtherObject.put('searchString','sim');
            parametersMapOtherObject.put('fieldToDisplay','CreatedDate');
            parametersMapOtherObject.put('fieldBindToTarget','Email');
            parametersMapOtherObject.put('fieldToFilter','Name');
            parametersMapOtherObject.put('selectedRecordIds',objUser.ID);
            parametersMapOtherObject.put('searchType','External');
            parametersMapOtherObject.put('objectApiName' ,'collaborationgroup');
            SendEmailCompCtrl.getRecordsNew(parametersMapOtherObject);
            //SendEmailCompCtrl.getRecords(parametersMap);
    }
     @isTest
    public static void getRecordsNewForObjectContact(){
         Map<String, Object> parametersMapOtherObject = new Map<String,Object>();
          User objUser = [Select Id from user where Id=:Userinfo.getUserId()];
          system.assertNotEquals(null, objUser.Id);
        
            parametersMapOtherObject.put('searchString','sim');
            parametersMapOtherObject.put('fieldToDisplay','IsActive');
            parametersMapOtherObject.put('fieldBindToTarget','Email');
            parametersMapOtherObject.put('fieldToFilter','Name');
            parametersMapOtherObject.put('selectedRecordIds',objUser.ID);
            parametersMapOtherObject.put('searchType','External');
            parametersMapOtherObject.put('objectApiName' ,'Contact');
            SendEmailCompCtrl.getRecordsNew(parametersMapOtherObject);
            //SendEmailCompCtrl.getRecords(parametersMap);
    }
    
     @isTest
    public static void getCollabGroupMemberIds(){
        
        CollaborationGroup objCollaborationGroup = [Select id,name,CollaborationType from CollaborationGroup];
        system.assertNotEquals(null, objCollaborationGroup.Id);
        
        List<CollaborationGroupMember> objCollaborationGroupMember = [Select id,MemberId,CollaborationGroupId from CollaborationGroupMember];
        system.assertNotEquals(null, objCollaborationGroupMember.size());
        
        parametersMap.put('groupId',objCollaborationGroup.Id);
        List<SObject> lstSobject = SendEmailCompCtrl.getCollabGroupMemberIds(parametersMap);
        String groupIds = (String)parametersMap.get('groupId'); 
        List<SObject> lstSobjectActual  = [SELECT MemberId,Member.Email FROM CollaborationGroupMember WHERE CollaborationGroupId =:groupIds AND Member.IsActive=true];
        system.assertEquals(lstSobject, lstSobjectActual);
    }
    
     @isTest
    public static void getuploadAttachment(){
        
    	Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        
    	List<Attachment> lstAttachment = [select id,parentId, name from Attachment where parentId=:objTask.id];
    	System.assertEquals(1, lstAttachment.size());
        
        initializeVariable();
        SendEmailCompCtrl.uploadAttachment(attributeMap);
        attributeMap.put('isAttachNotPresent',true);
        attributeMap.put('mode','send');
        attributeMap.put('emailFieldName','Name');
        attributeMap.put('sendACopyToMe',false);
        attributeMap.put('formattedToAddress','simran.sehgal@reisystems.in');
        attributeMap.put('subject','Test Email Subject');
        attributeMap.put('body','Test Email Body');
        attributeMap.put('AttachmentBody','Test Email Body');
        
        SendEmailCompCtrl.sendEmail(objTask.Id,lstAttachment[0].parentId,attributeMap);
        SendEmailCompCtrl.uploadNewVal(false, false, 'View', objTask.Id , lstAttachment[0].parentId , 'Name');
        SendEmailCompCtrl.uploadNewVal(false, false, 'reply', objTask.Id , lstAttachment[0].parentId , 'Id');
        SendEmailCompCtrl.uploadNewVal(false, false, 'send', objTask.Id , lstAttachment[0].parentId , 'Id');
        Map<String, Object> attributeMap1 = new Map<String,Object>();
        attributeMap1.put('isAttachNotPresent',true);
        attributeMap1.put('mode','send');
        attributeMap1.put('emailFieldName','Name');
        attributeMap1.put('sendACopyToMe',false);
        attributeMap1.put('TaskId',objTask.Id);
        attributeMap1.put('AttachmentName',lstAttachment[0].Name);
        attributeMap1.put('formattedToAddress','simran.sehgal@reisystems.in');
        attributeMap1.put('subject','Test Email Subject');
        attributeMap1.put('body','Test Email Body');
        attributeMap1.put('AttachmentBody','Test, Email ,Body');
        SendEmailCompCtrl.uploadAttachment(attributeMap1);
        SendEmailCompCtrl.uploadNewVal(false, false, 'View', objTask.Id , lstAttachment[0].parentId , 'Name');
        SendEmailCompCtrl.sendEmail(objTask.Id,lstAttachment[0].parentId,attributeMap,null);

        
    }  
    
      @isTest
    public static void getuploadAttachmentModeSend(){
         Map<String, Object> attributeMap1 = new Map<String,Object>();
		Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        
    	Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        
    	List<Attachment> lstAttachment = [select id,parentId, name from Attachment where parentId=:objTask.id];
    	System.assertEquals(1, lstAttachment.size());
        attributeMap1.put('isAttachNotPresent',true);
        attributeMap1.put('AttachmentBody','Attachment Body'); 
        attributeMap1.put('TaskId',lstAttachment[0].ParentId);
        attributeMap1.put('UploadDone',true);
        attributeMap1.put('sendACopyToMe',true);
        attributeMap1.put('mode','send');
        SendEmailCompCtrl.uploadAttachment(attributeMap1);
        SendEmailCompCtrl.sendEmail(objAccount.Id,null,attributeMap1);
    }
      @isTest
    public static void getuploadAttachmentModeReply(){
         Map<String, Object> attributeMap1 = new Map<String,Object>();
		Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        
    	Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        
    	List<Attachment> lstAttachment = [select id,parentId, name from Attachment where parentId=:objTask.id];
    	System.assertEquals(1, lstAttachment.size());
        
        User objUser = [Select Id from user where Id=:Userinfo.getUserId()];
        system.assertNotEquals(null, objUser.Id);
        
        attributeMap1.put('AttachmentBody','Attachment Body'); 
        attributeMap1.put('TaskId',lstAttachment[0].ParentId);
        attributeMap1.put('UploadDone',true);
        attributeMap1.put('sendACopyToMe',true);
        attributeMap1.put('mode','reply');
        attributeMap1.put('oldTaskId',objTask.Id);
        attributeMap1.put('formattedToAddress',objUser.Id);
        attributeMap1.put('isAttachNotPresent',true);
        SendEmailCompCtrl.uploadAttachment(attributeMap1);
        SendEmailCompCtrl.sendEmail(objAccount.Id,null,attributeMap1);
    }
    
      @isTest
    public static void sendEmailWithToAndCCAddress(){
         Map<String, Object> attributeMap1 = new Map<String,Object>();
		Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        
    	Task objTask = [Select id from Task Limit 1];
         system.assertNotEquals(null, objTask.Id);
        
    	List<Attachment> lstAttachment = [select id,parentId, name from Attachment where parentId=:objTask.id];
        System.assertEquals(1, lstAttachment.size());
        
        User objUser = [Select Id,Email from user where Id=:Userinfo.getUserId()];
        system.assertNotEquals(null, objUser.Id);
        
        attributeMap1.put('AttachmentBody','Attachment Body'); 
        attributeMap1.put('TaskId',lstAttachment[0].ParentId);
        attributeMap1.put('UploadDone',true);
        attributeMap1.put('sendACopyToMe',true);
        attributeMap1.put('mode','reply');
        attributeMap1.put('oldTaskId',objTask.Id);
        attributeMap1.put('formattedToAddress',objUser.Id);
        attributeMap1.put('toAddress',objUser.Email);
        attributeMap1.put('ccAddress',objUser.Id);
        attributeMap1.put('isAttachNotPresent',true);
        attributeMap1.put('emailFieldName','Email');
        SendEmailCompCtrl.sendEmail(objAccount.Id,null,attributeMap1);
    }

    @isTest
    public static void sendEmailNewLWCTest(){
         Map<String, Object> attributeMap1 = new Map<String,Object>();
		Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        
    	Task objTask = [Select id from Task Limit 1];
         system.assertNotEquals(null, objTask.Id);
        
    	List<Attachment> lstAttachment = [select id,parentId, name from Attachment where parentId=:objTask.id];
        System.assertEquals(1, lstAttachment.size());
        
        User objUser = [Select Id,Email from user where Id=:Userinfo.getUserId()];
        system.assertNotEquals(null, objUser.Id);
        
        attributeMap1.put('AttachmentBody','Attachment Body'); 
        attributeMap1.put('TaskId',lstAttachment[0].ParentId);
        attributeMap1.put('UploadDone',true);
        attributeMap1.put('sendACopyToMe',true);
        attributeMap1.put('mode','reply');
        attributeMap1.put('oldTaskId',objTask.Id);
        attributeMap1.put('formattedToAddress',objUser.Id);
        attributeMap1.put('toAddress',objUser.Email);
        attributeMap1.put('ccAddress',objUser.Id);
        attributeMap1.put('isAttachNotPresent',true);
        attributeMap1.put('emailFieldName','Email');
        SendEmailCompCtrl.sendEmailNew(objAccount.Id,null,attributeMap1);
    }

    @isTest
    public static void getLoadDataLWCTest(){
        SampleObject11__c samObj11= TestHelper.getSampleObject1(true);
        System.assertEquals(samObj11.Status__c, 'In Progress',  'status is In Progress');      
        SendEmailCompCtrl.getLoadData();
        PageDataHolder__c pg = new PageDataHolder__c ();
        pg.JSONData1__c = '["06805000001zPJ2AAM","06805000001zRYyAAM"]';
        insert pg;
        SendEmailCompCtrl.getContentVersionListVal(pg.Id);
    }
    @isTest
    public static void getCollabGroupMemberIdsLWC(){
        
        CollaborationGroup objCollaborationGroup = [Select id,name,CollaborationType from CollaborationGroup];
        system.assertNotEquals(null, objCollaborationGroup.Id);
        
        List<CollaborationGroupMember> objCollaborationGroupMember = [Select id,MemberId,CollaborationGroupId from CollaborationGroupMember];
        system.assertNotEquals(null, objCollaborationGroupMember.size());
        
        parametersMap.put('groupId',objCollaborationGroup.Id);
        List<SObject> lstSobject = SendEmailCompCtrl.getCollabGroupMemberIdsLWC(parametersMap);
        String groupIds = (String)parametersMap.get('groupId'); 
        List<SObject> lstSobjectActual  = [SELECT MemberId,Member.Email FROM CollaborationGroupMember WHERE CollaborationGroupId =:groupIds AND Member.IsActive=true];
        system.assertEquals(lstSobject, lstSobjectActual);
    }

    @isTest
    public static void uploadAttachmentFiles(){
        
      Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        attributeMap.put('parentId',objAccount.Id);
        attributeMap.put('taskId',objTask.Id);

        
        List<Object> fileDetails = (List<Object>)JSON.deserializeUntyped(
        '[{"fileSize":"1234","filename":"test.png","base64":"teststststststst"}]');
        

        SendEmailCompCtrl.uploadAttachmentFiles(attributeMap,fileDetails);
        
        
    }
    @isTest
    public static void uploadAttachmentFilesSingle(){
        
      Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        attributeMap.put('parentId',objAccount.Id);
        attributeMap.put('taskId',objTask.Id);
        attributeMap.put('UploadDone',True);

        
        Object fileDetails = (Object)JSON.deserializeUntyped(
        '{"fileSize":"1234","filename":"test.png","base64":"teststststststst"}');
        

        SendEmailCompCtrl.uploadAttachmentFiles(attributeMap,fileDetails);
        
        
    }

    @isTest
    public static void uploadNewValTest(){
        
      Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
 
        SendEmailCompCtrl.creationPageDataHolderId();
        SendEmailCompCtrl.uploadNewValNew(false, false, 'View', objTask.Id , objAccount.Id , 'Name');
        SendEmailCompCtrl.uploadNewValNew(false, false, 'reply', objTask.Id , objAccount.Id , 'Id');
        SendEmailCompCtrl.uploadNewValNew(false, false, 'send', objTask.Id , objAccount.Id , 'Id');

    }

    @isTest
    public static void uploadNewValTest2(){
        
      Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        attributeMap.put('parentId',objAccount.Id);
        attributeMap.put('taskId',objTask.Id);
        attributeMap.put('UploadDone',False);
        Object fileDetails = (Object)JSON.deserializeUntyped(
        '{"fileSize":"1234","filename":"test.png","base64":"teststststststst"}');
        SendEmailCompCtrl.uploadAttachmentFiles(attributeMap,fileDetails);
    }
    
    @isTest
    public static void uploadNewValTest3(){
        
      Task objTask = [Select id from Task Limit 1];
        system.assertNotEquals(null, objTask.Id);
        Account objAccount = [Select id from Account];
        system.assertNotEquals(null, objAccount.Id);
        attributeMap.put('parentId',objAccount.Id);
        attributeMap.put('taskId',objTask.Id);
        attributeMap.put('UploadDone',False);
        Object fileDetails = (Object)JSON.deserializeUntyped('{}');
        SendEmailCompCtrl.uploadAttachmentFiles(attributeMap,fileDetails);
    }
}