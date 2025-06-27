@isTest
public class TestEmailFeeder{      	
    @isTest
	private static void test1(){
        Test.startTest();
        EmailTemplate e = new EmailTemplate();
        e.Name = 'DemoTemplate';
        EmailQueue__c email = new EmailQueue__c();
        Account account = new Account();
		Attachment attachment = new Attachment();       	
		EmailFeeder ef = new EmailFeeder().toEmail('abc@xyz.com').bccEmail('xyz@abc.com').subject('test EmailFeeder').
            htmlBody('this is body').ccEmail('abc@yzx.com').plainTextBody('this is plaintext').template(String.valueOf(e.Name)).
            contextRecordId(String.valueOf(account.Id)).replyToEmail('cde@yxz.com').attachment(String.valueOf(attachment.id));
        new EmailFeeder().orgWideFromEmail('Email3@y.com').toEmail('Email1@y.com').toEmail('Email2@z.com').ccEmail('Email3@x.com').ccEmail('Email3@x.com').bccEmail('Email3@q.com').bccEmail('Emaile@y.com').targetObjectId('a1h05000000X664AAC').attachmentIdString('a1h05000000X664AAC').send();
            System.assertNotEquals(null, ef);
        Test.stopTest();
	}

    @isTest
    public static void testSendEmails() {
        List<EmailFeeder> testEmailFeeders = new List<EmailFeeder>();
        Test.startTest();
        EmailFeeder.sendEmails(testEmailFeeders);
        Test.stopTest();
        List<EmailQueue__c> createdEmails = [SELECT Id FROM EmailQueue__c];
        System.assertEquals(testEmailFeeders.size(), createdEmails.size());
    }

    @isTest
    static void testgetDownloadPdfIcon(){
        Test.startTest();
        Map<String, String> result = ExecuteDownloadPdf.getDownloadPdfIcon();
        Map<String, String> resultLWC = ExecuteDownloadPdf.getDownloadPdfIconLwc();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }
}