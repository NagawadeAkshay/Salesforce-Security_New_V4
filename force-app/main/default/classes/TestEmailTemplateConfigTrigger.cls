@isTest
public class TestEmailTemplateConfigTrigger {
  static  EmailTemplate em;
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
    @isTest
    static void testAll(){
        Test.startTest(); 
        setupData1();
        setupData2();
        Test.stopTest();
        system.assertNotEquals(em ,null);
    }
}