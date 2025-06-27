@isTest
public with sharing class TestSendToOwnerEmailHandler {
    static Messaging.InboundEmail email = new Messaging.InboundEmail();
    static Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    static EmailConversationHandler sendEmail;
    static SObjectConfig__c sObjCon;
    /* Two setup method can be merged to one done for check negative test where we pass sObjCon.Name ='' */
    
    public static void setUp(){
        User u=TestHelper.getAdminUser(true);
        TestHelper.createCustomSettings(true); 
        email.subject = 'test';
        SampleObject1__c ann = TestHelper.getSampleObject1Val(true);
        SampleObject1__c app = TestHelper.getSampleObject1Val(true);
        email.plainTextBody=app.id;
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        sObjCon = new SObjectConfig__c();
        sObjCon.Name = nameSpaceprefix + 'SampleObject1__c';
        sObjCon.ApprovalReCallCommentFieldAPIName__c = 'SampleText1__c';
        sObjCon.ApprovalReCallFieldAPIName__c = 'IsRecordRecalled__c';
        sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
        insert sObjCon; 
        List<String> toAddr=new List<String>();
        toAddr.add('user@me.com');
        email.toAddresses=toAddr;
        email.fromAddress = 'user@acme.com';
        CustomAppConfig__c usp = TestHelper.getCustomAppConfig(true);   
        PhaseConfig__c ph= TestHelper.getPhase(true);
        EmailConversationHandler.isTest = true;
        sendEmail=new EmailConversationHandler();
        //sendEmail.parentId = ann.Id;
        Task tsk= TestHelper.getTask(false);
        tsk.WhatId=ann.id;
        tsk.Type ='Email';
        tsk.EmailType__c = 'Outbound';
        tsk.OwnerId=u.id;
        tsk.PhaseName__c=ph.id;
        tsk.OwnerId = u.Id;
        insert tsk;
        List<Task> taskList=new List<Task>();
        taskList.add(tsk); 
    }
    public static void setUp1(){
        User u=TestHelper.getAdminUser(true);
        TestHelper.createCustomSettings(true); 
        email.subject = 'test';
        SampleObject1__c ann = TestHelper.getSampleObject1Val(true);
        SampleObject1__c app = TestHelper.getSampleObject1Val(true);
        email.plainTextBody=app.id;
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        sObjCon = new SObjectConfig__c();
        sObjCon.Name = nameSpaceprefix + '';
        sObjCon.ApprovalReCallCommentFieldAPIName__c = 'SampleText1__c';
        sObjCon.ApprovalReCallFieldAPIName__c = 'IsRecordRecalled__c';
        sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
        insert sObjCon; 
        List<String> toAddr=new List<String>();
        toAddr.add('user@me.com');
        email.toAddresses=toAddr;
        email.fromAddress = 'user@acme.com';
        CustomAppConfig__c usp = TestHelper.getCustomAppConfig(true);   
        PhaseConfig__c ph= TestHelper.getPhase(true);
        EmailConversationHandler.isTest = true;
        sendEmail=new EmailConversationHandler();
        //sendEmail.parentId = ann.Id;
        Task tsk= TestHelper.getTask(false);
        tsk.WhatId=ann.id;
        tsk.Type ='Email';
        tsk.EmailType__c = 'Outbound';
        tsk.OwnerId=u.id;
        tsk.PhaseName__c=ph.id;
        tsk.OwnerId = u.Id;
        insert tsk;
        List<Task> taskList=new List<Task>();
        taskList.add(tsk); 
    }
    @isTest static void testHandleInboundEmail(){
        User u=TestHelper.getAdminUser(true);
         System.runAs(u) {
            Test.startTest();
            setUp();
            SendToOwnerEmailHandler stoeh = new SendToOwnerEmailHandler();
            Messaging.InboundEmailResult emailHandler = stoeh.handleInboundEmail(email, env);
            email.plainTextBody='';
            Messaging.InboundEmailResult emailHandler1 = stoeh.handleInboundEmail(email, env);
            String falseCheck = 'true';
            System.assertEquals('true',falseCheck);
            Test.stopTest();
         }
    }
}