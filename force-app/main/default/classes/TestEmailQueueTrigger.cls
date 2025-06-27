@isTest
private class TestEmailQueueTrigger{  
static EmailTemplate em;
    private static void setupData1(){
        em = TestHelper.getEmailTemplate(false,'testtemplate','testtemplate');
        em.DeveloperName = 'TestEmailTemplate';
        em.Name = 'TestEmailTemplate';
        em.Body = 'Hello {!Account.Name}';
        em.Subject = 'Hello {!Account.BillingCity}';
        em.HtmlValue = 'Hello {!Account.Name}';
        insert em;  
    }
    @future
    private static void setupData2(){
        EmailTemplateConfig__c e = TestHelper.getEmailTempalteConfig(false);
        e.Name = 'TestEmailTemplate';
        e.DeveloperName__c = 'TestEmailTemplate';
        insert e;
        e.DeveloperName__c = 'TestEmailTemplate';
        upsert e;
    }

    @future
    private static void setupData4(){
        Account a = TestHelper.getAccount(false);
        a.BillingCity = 'TestCity';
        insert a;
		EmailQueue__c eq = new EmailQueue__c();
        eq.ToEmails__c = 'abc@xyz.com';
        eq.TemplateName__c = 'TestEmailTemplate';
        eq.ContextRecordIds__c =a.Id;
        insert eq;
        upsert eq;
    }   
    @isTest
    static void testAll(){
       	Test.startTest(); 
      	setupData1();
        setupData2();
       // setupData3();
        setupData4();
       	Test.stopTest();         
         System.assertNotEquals(null, em);       
    }
}