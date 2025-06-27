/**
* @Class Name: TestEmailTemplateController
* @Description: This class is test class for EmailTemplateController
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |20/02/2024   | Framework Team                      | Initail
* ====================================================================================================================
**/
@isTest
public with sharing class TestEmailTemplateController {
    @isTest
    static void test_Contact(){  
        Test.startTest();
        Contact con = TestHelper.getContact(true);
        Map<string, Object> templateInfoMap = EmailTemplateController.getContactById(con.id);
        system.assertNotEquals(null,templateInfoMap);
        Test.stopTest();
    }
    
    @isTest
    static void test_SendEmail(){  
        Test.startTest();
        Map<String, Object> fileDetails = new Map<String, Object>{
            'filename' => 'Test',
            'base64' => 'aaab'
        };
        Contact con = TestHelper.getContact(true);
        Map<string, Object> templateInfoMap = EmailTemplateController.getContactById(con.id);
        Map<String,Object> mapOfResult = EmailTemplateController.sendEmail('Hello Test',con.Email,'test@gmail.com','false',fileDetails,con.Id,'Send Invitation',con.Id,null);

        System.debug('mapOfResult'+mapOfResult);
        system.assertEquals(true,mapOfResult.get('IsSuccess'));
        system.assertEquals('Email Sent Succesfully.',mapOfResult.get('Message'));
        Test.stopTest();
    }
    @isTest
    static void test_SendEmailBlankMail(){  
        Test.startTest();
        Map<String, Object> fileDetails = new Map<String, Object>{
            'filename' => 'Test',
            'base64' => 'aaab'
        };
        Contact con = TestHelper.getContact(true);
        Map<string, Object> templateInfoMap = EmailTemplateController.getContactById(con.id);
        Map<String,Object> mapOfResult = EmailTemplateController.sendEmail('Hello Test','','abc','false',fileDetails,con.Id,'Send Invitation',con.Id,null);

        System.debug('mapOfResult'+mapOfResult);
        system.assertEquals(false,mapOfResult.get('IsSuccess'));
        system.assertEquals('Invalid Email Address.',mapOfResult.get('Message'));
        Test.stopTest();
    }
    @isTest
    static void test_SendEmailBlankSub(){  
        Test.startTest();
        Contact con = TestHelper.getContact(true);
        Map<string, Object> templateInfoMap = EmailTemplateController.getContactById(con.id);
        Map<String,Object> mapOfResult = EmailTemplateController.sendEmail('',con.Email,'test@gmail.com','false','test.doc',con.Id,'',con.Id,null);

        System.debug('mapOfResult'+mapOfResult);
        system.assertEquals(false,mapOfResult.get('IsSuccess'));
        system.assertEquals('Subject must be required.',mapOfResult.get('Message'));
        Test.stopTest();
    }
    @isTest
    static void test_SendEmailBlankBody(){  
        Test.startTest();
        Contact con = TestHelper.getContact(true);
        Map<string, Object> templateInfoMap = EmailTemplateController.getContactById(con.id);
        Map<String,Object> mapOfResult = EmailTemplateController.sendEmail('',con.Email,'test@gmail.com','false','test.doc',con.Id,'Send Invitation',con.Id,null);

        System.debug('mapOfResult'+mapOfResult);
        system.assertEquals(false,mapOfResult.get('IsSuccess'));
        system.assertEquals('Invalid Body.',mapOfResult.get('Message'));
        Test.stopTest();
    }
     @isTest
    static void test_SendEmailBlankCCMail(){  
        Test.startTest();
        Map<String, Object> fileDetails = new Map<String, Object>{
            'filename' => 'Test',
            'base64' => 'aaab'
        };
        Contact con = TestHelper.getContact(true);
        Map<string, Object> templateInfoMap = EmailTemplateController.getContactById(con.id);
        Map<String,Object> mapOfResult = EmailTemplateController.sendEmail('Hello Test','test@gmail.com','abc1','false',fileDetails,con.Id,'Send Invitation',con.Id,null);

        System.debug('mapOfResult'+mapOfResult);
        system.assertEquals(false,mapOfResult.get('IsSuccess'));
        system.assertEquals('Invalid Email Address.',mapOfResult.get('Message'));
        Test.stopTest();
    }

    @isTest
    static void testProperties() {
        EmailTemplateController obj = new EmailTemplateController();
        Account acc = new Account(Name='Test');
        Test.startTest();
        insert acc;
        Test.stopTest();
        Id testId = acc.Id;
        obj.targetId = acc.Id;
        System.assertEquals(testId, obj.targetId, 'targetId should be set correctly.');
        String testEmailBody = 'Test email body content';
        obj.emailBody = testEmailBody;
        System.assertEquals(testEmailBody, obj.emailBody, 'emailBody should be set correctly.');
    }
}