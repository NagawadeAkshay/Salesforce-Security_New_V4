/**
 
 **********************************************************
 Audit History
 **********************************************************
 9/8/2015   Swati singh Created
 **********************************************************  
*/
@isTest
public with sharing class TestEmailConversationHandler {
	static EmailConversationHandler sendEmail;
	@isTest
    private static void testSendEmailIfStringFound2(){
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u1 = new User(Alias = 'standa', Email='saplingstandarduser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId = p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='saplingstandarduser@testorg.com');
		insert u1;

		User u = [SELECT Id from User Where Id=:u1.Id];
        User u2 = TestHelper.getAdminUser(true);
  
        System.runAs(u2) {
  
        	//ProgramTriggerHelper.skiptrigger=true;
        	//TriggerHelper.skipTrigger=true;
            TaskTriggerHelper.skipTrigger = true; 
			Test.startTest();
             
	             TestHelper.createCustomSettings(true);            
	             Messaging.InboundEmail email = new Messaging.InboundEmail();
	             Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	             email.subject = 'test';
				 email.htmlBody ='This is test mail';
	             SampleObject11__c ann = TestHelper.getSampleObject1(true);
	             SampleObject11__c app = TestHelper.getSampleObject1(true);
	             email.plainTextBody='test email[ref:'+app.id+':ref]';
	             List<String> toAddr=new List<String>();
	             toAddr.add('user@me.com');
	             email.toAddresses=toAddr;
	             email.fromAddress = 'saplingstandarduser@testorg.com';

				 Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
				 attachment.body = blob.valueOf('my attachment text');
				 attachment.fileName = 'textfileone.txt';
				 attachment.mimeTypeSubType = 'text/plain';
				 email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

				 Messaging.InboundEmail.TextAttachment   text = new Messaging.InboundEmail.TextAttachment ();
				 text.body = 'my attachment text';
				 text.fileName = 'textfileone.txt';
				 text.mimeTypeSubType = 'text/plain';
				 email.textAttachments  = new Messaging.inboundEmail.TextAttachment[] { text };

	           	 CustomAppConfig__c usp = TestHelper.getCustomAppConfig(true);   
	             
	             EmailConversationHandler.isTest = true;
	             sendEmail=new EmailConversationHandler();
	             
				 Task parentTask = new Task();
				 parentTask.OwnerId = u.Id;
				 parentTask.FromAddress__c = 'saplingstandarduser@testorg.com';
				 parentTask.WhatId = app.Id;
				 parentTask.Type ='Email';
				 parentTask.EmailType__c = 'Outbound';
				 parentTask.ActivityDate = System.today();
				 parentTask.ActivityDuplicateDate__c= System.today();
				 parentTask.Description = 'The new phone books are here Im somebody again';
				 parentTask.DocumentType__c = 'SampleObjects';
                 TaskTriggerHelper.skipTrigger = true; 
                 TriggerHelper.skipTrigger = true;
				 insert parentTask;


	             Task tsk= TestHelper.getTask(false);
	             tsk.WhatId=ann.id;
	             tsk.Type ='Email';
	             tsk.EmailType__c = 'Inbound';
	             
	             tsk.OwnerId = u.Id;
	             insert tsk;
	             List<Task> taskList=new List<Task>();
	             taskList.add(tsk);
             	 sendEmail.handleInboundEmail(email, env ); 
             Test.stopTest();
         }
        System.assertNotEquals(u, null);
    }
    
    @isTest
    private static void testSendEmailIfStringNotFound(){
         User u=TestHelper.getAdminUser(true);
         System.runAs(u){
         	//ProgramTriggerHelper.skiptrigger=true;
         	 TriggerHelper.skipTrigger=true;
             	Test.startTest();
		             TestHelper.createCustomSettings(true);
		             Messaging.InboundEmail email = new Messaging.InboundEmail();
		             Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		             email.subject = 'test';
					 email.htmlBody = 'This is test mail';
		             SampleObject11__c ann = TestHelper.getSampleObject1(true);
		             SampleObject11__c app = TestHelper.getSampleObject1(true);
		             email.plainTextBody='test email[ref:'+app.id+':re]';
		             List<String> toAddr=new List<String>();
		             toAddr.add('user@me.com');
		             email.toAddresses=toAddr;
		             email.fromAddress = 'user@acme.com';        
		             EmailConversationHandler.isTest = true;     
		             sendEmail=new EmailConversationHandler();
		             sendEmail.handleInboundEmail(email, env ); 
             	Test.stopTest();
         	}
         	System.assertNotEquals(u, null);
         	
    	}

		@isTest
		public static void testUserWorkspaceInfoWithValidData() {
			EmailConversationHandler ech = new EmailConversationHandler();
			User testUser = TestHelper.getAdminUser(true);
			Account testAccount = new Account(Name = 'TestAccount');
			testUser.OrganizationId__c = testAccount.Id;
        	testAccount.WorkspaceId__c = 'TestWorkspaceId';
			Test.startTest();
        	insert testAccount;
			Id workspaceId = EmailConversationHandler.getUserWorkspaceInfo(testUser.Id);
			Test.stopTest();
			System.assertEquals(null,workspaceId);
		}
    
}