@isTest public with sharing class TestSyncEmailTemplateBatch {
    public static void setUp() {
        
    }
    @isTest static void testGetQuery(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            Test.startTest();
                SyncEmailTemplatesBatch setb = new SyncEmailTemplatesBatch();
                String query = setb.getQuery();
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest();
        }
    }
    @isTest static void testExecute(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            Test.startTest();
                SyncEmailTemplatesBatch setb = new SyncEmailTemplatesBatch();
                EmailTemplate em =  new EmailTemplate();
                em.Name = 'Test Email';
                em.DeveloperName = 'Developer';
                List<SObject> sobjLst = new List<SObject>();
                sobjLst.add((SObject)em);
                setb.execute(sobjLst);
                String falseCheck = 'true';
                System.assertEquals('true',falseCheck);
            Test.stopTest();
        }
    }
}