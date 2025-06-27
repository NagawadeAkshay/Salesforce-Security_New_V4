@isTest
private class EmailSenderJobTest {
    @isTest
    static void verifyEmailSenderJob(){
        Account objAccount = new Account(Name = 'Library Accoun Parent 5');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);

        User objUser = new User(
            ProfileId = UserInfo.getProfileId(),
            LastName = 'Library User',
            Email = 'libraryuser@example.com',
            Username = 'libraryuser@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            OrganizationId__c = objAccount.Id
        );
        insert objUser;
        System.assertNotEquals(null, objUser.Id);

        Attachment attach = new Attachment(
            Name='Unit Test Attachment',
            Body = Blob.valueOf('Unit Test Attachment Body'),
            ParentId = objAccount.Id
        );
        insert attach;
        System.assertNotEquals(null, attach.Id);

        EmailQueue__c objEmailQueue = new EmailQueue__c(
            AttachmentIds__c = attach.Id,
            BccEmails__c = 'testemail@example.com',
            CcEmails__c = 'testemail@example.com',
            ContextRecordIds__c = objAccount.Id,
            ErrorMessage__c = 'Error Message',
            ReplyEmail__c = 'testemail@example.com',
            HtmlBody__c = 'Test Body',
            OrgWideFromEmail__c = 'testemail@example.com',
            PlainTextBody__c = 'Test Data',
            Status__c = 'Queued',
            Subject__c = 'Test Subject',
            TemplateName__c = null,
            ToEmails__c = 'testemail@example.com',
            TargetObjectId__c = objAccount.Id            
        );
        insert objEmailQueue;
        System.assertNotEquals(null, objEmailQueue.Id);

        EmailSenderJob objEmailSenderJob = new EmailSenderJob();
        Id jobId = Database.executeBatch(objEmailSenderJob);

        System.runAs(objUser){
            EmailTemplate emailtemplate = new EmailTemplate (
                DeveloperName = 'test',
                FolderId = UserInfo.getUserId(),
                TemplateType= 'Text',
                Name = 'test'
            );
            insert emailtemplate;
            System.assertNotEquals(null, emailtemplate.Id);

            objEmailQueue = new EmailQueue__c(
                AttachmentIds__c = attach.Id,
                BccEmails__c = 'testemail@example.com',
                CcEmails__c = 'testemail@example.com',
                ContextRecordIds__c = objAccount.Id,
                ErrorMessage__c = 'Error Message',
                ReplyEmail__c = 'testemail@example.com',
                HtmlBody__c = 'Test Body',
                OrgWideFromEmail__c = 'testemail@example.com',
                PlainTextBody__c = 'Test Data',
                Status__c = 'Queued',
                Subject__c = 'Test Subject',
                TemplateName__c = null,
                ToEmails__c = 'testemail@example.com',
                TargetObjectId__c = objAccount.Id            
            );
            insert objEmailQueue;
            System.assertNotEquals(null, objEmailQueue.Id);

            objEmailSenderJob = new EmailSenderJob();
            jobId = Database.executeBatch(objEmailSenderJob);
        }
    }

    @isTest
    static void testRemoveUnwantedCharacters() {
        String inputWithUnwantedChars = '<div>This is a <b>test</b> string with unwanted characters and tags.</div>';
        String sanitizedResult = EmailSenderJob.removeUnwantedCharacters(inputWithUnwantedChars);
        System.assertEquals('<div>This+is+a+<b>test</b>+string+with+unwanted+characters+and+tags.</div>', sanitizedResult);
        String emptyInput = '';
        String emptyResult = EmailSenderJob.removeUnwantedCharacters(emptyInput);
        System.assertEquals('', emptyResult);
        String cleanInput = 'This is a clean string without unwanted characters or tags.';
        String cleanResult = EmailSenderJob.removeUnwantedCharacters(cleanInput);
        System.assertEquals('This is a clean string without unwanted characters or tags.', cleanResult);
    }

    @isTest
    static void testReplaceJSONMergeFields() {
        Account testObj = new Account(Name = 'TestObject');
        insert testObj;
        String inputContent = 'Sample content with JSON merge fields: {"Account":"Name"}';
        String replacedContent = EmailSenderJob.replaceJSONMergeFields(inputContent, testObj, 'Account');
        System.assertEquals('Sample content with JSON merge fields: TestObject', replacedContent);
    }

    @isTest
    static void testReplaceSpecialFields() {
        Account testAccount = new Account(Name = 'Test Account');
        Test.startTest();
        insert testAccount;
        Test.stopTest();
        String bodyWithLink = 'Click {!Account.Link} to view account details.';
        String sObjectName = 'Account';
        String replacedBody = EmailSenderJob.replaceSpecialFields(bodyWithLink, sObjectName, testAccount);
        String expectedUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + testAccount.Id;
        String expectedReplacedBody = 'Click ' + expectedUrl + ' to view account details.';
        System.assertNotEquals(null, expectedReplacedBody, 'Link replacement should be done correctly.');
        String emptyBody = '';
        String result = EmailSenderJob.replaceSpecialFields(emptyBody, sObjectName, testAccount);
        System.assertEquals('', result, 'Empty body should return empty string.');
        String bodyWithoutLink = 'No link to replace.';
        String resultWithoutLink = EmailSenderJob.replaceSpecialFields(bodyWithoutLink, sObjectName, testAccount);
        System.assertEquals(bodyWithoutLink, resultWithoutLink, 'Body without link should remain unchanged.');
    }
}