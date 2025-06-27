/**
* @Class Name: TestEmailTemplateCtrl
* @Description: This class is test class for EmailTemplateCtrl
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |12/03/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/
@isTest
private class TestEmailTemplateCtrl {

    @isTest
    static void test_1() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Test.startTest();
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate('true','testDateFormat', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'false';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.targetId=UserInfo.getUserId();
        emailCtrl.templateName = 'ok';
        emailCtrl.isLabelShow='true';
        emailCtrl.fileList='test';
        emailCtrl.email = 'test@gmail.com';
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = 'test@gmail.com';
        emailCtrl.emailBody = 'Hi, this is emailBody {!user.name}';
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        emailCtrl.labelFieldMap= '{"isTest":"true","name":"test"}';
        //emailCtrl.labelFieldMap='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';
        emailCtrl.readOnlyMode=true;
        emailCtrl.sendEmailFunction();
        emailCtrl.emailBody = 'Hi, this is emailBody {!user.name}';
        emailCtrl.sendEmailFunction();
        EmailTemplateCtrl.isBulkMode = 'true';
        emailCtrl.sendEmailFunction();
        Map<String,Id> targetMap= new Map<String,Id>();
        targetMap.put(UserInfo.getUserId(), UserInfo.getUserId());
        emailCtrl.targetIds=UserInfo.getUserId();
        emailCtrl.sendEmailInBulk(targetMap);
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
        Test.stopTest();
    }
    @isTest
    static void test_1One() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Test.startTest();
         Contact con = TestHelper.getContact(true);
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate('true','testDateFormat', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'false';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.targetId = con.Id;
        emailCtrl.templateName = 'ok';
        emailCtrl.isLabelShow='true';
        emailCtrl.fileList='test';
        emailCtrl.email = 'test@gmail.com';
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = 'test@gmail.com';
        emailCtrl.emailBody = 'Hi, this is emailBody {!user.name}';
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        emailCtrl.labelFieldMap= '{"isTest":"true","name":"test"}';
        //emailCtrl.labelFieldMap='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';
        emailCtrl.readOnlyMode=true;
        emailCtrl.sendEmailFunction();
        emailCtrl.emailBody = 'Hi, this is emailBody {!user.name}';
        emailCtrl.sendEmailFunction();
        EmailTemplateCtrl.isBulkMode = 'true';
        emailCtrl.sendEmailFunction();
       
       Map<String,Id> targetMap= new Map<String,Id>();
        targetMap.put(con.id, con.id);
        emailCtrl.targetIds=con.id;
        emailCtrl.sendEmailInBulk(targetMap);
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
        Test.stopTest();
    }
    
    @isTest()
    static void test_2() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Test.startTest();
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate('true','test2', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'true';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.targetId=UserInfo.getUserId();
        emailCtrl.templateName = 'ok';
        emailCtrl.email = 'test@gmail.com';
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = 'test@gmail.com';
        emailCtrl.emailBody = emailBody;
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        emailCtrl.sendEmailFunction();
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
        Test.stopTest();
    }
    
    @isTest()
    static void test_3() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Test.startTest();
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate('','test2', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'true';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.targetId=UserInfo.getUserId();
        emailCtrl.templateName = 'ok';
        emailCtrl.email = null;
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = 'test@gmail.com';
        emailCtrl.emailBody = emailBody;
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        emailCtrl.sendEmailFunction();
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
        Test.stopTest();
    }
    
    @isTest()
    static void test_4() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Test.startTest();
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate('','test2', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'true';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.targetId=UserInfo.getUserId();
        emailCtrl.templateName = 'ok';
        emailCtrl.email = 'test';
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = null;
        emailCtrl.emailBody = emailBody;
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
     	Test.stopTest();
    }
    
    @isTest()
    static void test_5() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Test.startTest();
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate(null,'test2', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'true';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.targetId=UserInfo.getUserId();
        emailCtrl.templateName = 'ok';
        emailCtrl.email = 'test';
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = 'test';
        emailCtrl.emailBody = null;
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        emailCtrl.sendEmailFunction();
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
   		Test.stopTest();
    }
    @isTest()
    static void testForContact() {    
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        Contact objContact = new Contact(LastName = 'Test Contact',Email='test@abc.com');
        insert objContact;
        system.assertNotEquals(null,objContact.Id);
        Test.startTest();
        String emailBody = EmailTemplateCtrl.fetchEmailTemplate(null,'test2', sampleObj.Id, 'pankaj.hingane@reisystems.in').get('body');
        EmailTemplateCtrl emailCtrl = new EmailTemplateCtrl();
        EmailTemplateCtrl.response = 'ok';
        EmailTemplateCtrl.isCC = true;
        EmailTemplateCtrl.isAttachment = false;
        EmailTemplateCtrl.isBulkMode = 'true';
        EmailTemplateCtrl.isUser = false;
        emailCtrl.readOnlyMode = true;
        emailCtrl.targetIds = objContact.Id;
        emailCtrl.templateName = 'ok';
        emailCtrl.email = 'test';
        emailCtrl.email1 = 'test@gmail.com';
        emailCtrl.subject = 'test';
        emailCtrl.ccEmail = 'test@gmail.com;test@gmail.com';
        emailCtrl.documentBody = 'Testing document body';
        emailCtrl.documentName = 'test@gmail.com';
        emailCtrl.isError = false;
        emailCtrl.sendEmailFunction();
        EmailTemplateCtrl.fetchEmailTemplate('',objContact.Id,'');
        List<EmailQueue__c> lst = [SELECT Id FROM EmailQueue__c];
        System.assertNotEquals(null, lst.size());
   		Test.stopTest();
    }
    @isTest
    static void testGetMapMergeFieldLabel(){
        Contact contact = new Contact(Firstname='FirstName', Lastname='LastName',Email='email@email.com', Title='Title',Phone ='123-123-1234');
        insert contact;
        Map<String, Set<String>> mergeFieldMap =  new Map<String, Set<String>>();
        mergeFieldMap.put('Contact', new Set<String>{'Firstname','Lastname','Email'});
        Test.startTest();
        EmailTemplateCtrl.getMapMergeFieldLabel(mergeFieldMap,contact.id);
        Test.stopTest();
        System.assertNotEquals(null, contact);
    }
    @isTest
    static void testupdateMergeFieldsBylabel(){
        string str = 'Hello, This email is to notify you that {!Contact.Firstname} Contact Details: Contact ID: {!Contact.Id} Contact Name:{!Contact.Firstname}';
        Contact contact = new Contact(Firstname='FirstName', Lastname='LastName',Email='email@email.com', Title='Title',Phone ='123-123-1234');
        insert contact;
        Test.startTest();
        EmailTemplateCtrl.updateMergeFieldsBylabel(str,contact.id);
        Test.stopTest();
        System.assertNotEquals(null, contact);
    }
    @isTest
    static void testgetEmailTemplateWrapper(){
        Test.startTest();
        List<sObject> sObjectList = new List<sObject>();
        Map<String, String> fieldLableMap = new Map<String, String>();
        Map<String, String> fieldDataTypeMap = new Map<String, String>();
        Map<String, Integer> scaleMap =new  Map<String, Integer>();
        String label;
        EmailTemplateCtrl.EmailTemplateWrapper costom = new EmailTemplateCtrl.EmailTemplateWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
        Test.stopTest();
        System.assertNotEquals(sObjectList,null);
       }
}