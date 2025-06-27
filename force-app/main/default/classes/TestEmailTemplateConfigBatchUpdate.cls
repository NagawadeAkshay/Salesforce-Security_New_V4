@isTest
private with sharing class TestEmailTemplateConfigBatchUpdate{
    
    @isTest
    static void testAll(){
        User u = TestHelper.getAdminUser(false);
        system.runAs(u){            
            
            Test.startTest();        
            TestHelper.createCustomSettings(true);
            AppUtils.SOQL_LIMIT_FOR_BATCH = 1;
            EmailTemplateConfig__c tempConfig = new EmailTemplateConfig__c();
            tempConfig.EmailTemplateDeveloperName__c = 'Test'+system.now();
            tempConfig.SobjectName__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
            insert tempConfig;
            
             KeyValueStore__c EmailTemplateMigrationScheduleInterval = new KeyValueStore__c(Name='EmailTemplateMigrationScheduleInterval',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Flag to indicate that the exception email should be sent in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum',IntegerValue__c= 1);
                        
             KeyValueStore__c EmailTemplateMigrationFolder = new KeyValueStore__c(Name='EmailTemplateMigrationFolder',TextValue__c='GovGrants',
                        Description__c='Flag to indicate that the exception email should be sent in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');           
                                    
            insert EmailTemplateMigrationScheduleInterval;
            insert EmailTemplateMigrationFolder;
                                   
            EmailTemplate temp = TestHelper.getEmailTemplate(true,'test','test123445');
            
            EmailTemplateConfigBatchUpdate ctrl = new EmailTemplateConfigBatchUpdate();
            Database.executeBatch(ctrl,1);
            Test.stopTest();
            System.assert(temp!=null);
        }
    }
}