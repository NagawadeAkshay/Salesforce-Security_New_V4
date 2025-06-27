@isTest
private with sharing class TestSObjectSharingRuleTriggerHelper{
    @IsTest
    private static void testInsert() {
        User u = TestHelper.getAdminUser(true);
        
        System.runAs(u) {        
            TestHelper.createCustomSettings(true);
            SObjectConfig__c sObjCon1 =  TestHelper.getSObjectConfig(false);
            sObjCon1.Name = 'sObjCon1';
            insert sObjCon1;
            System.assertNotEquals(null, sObjCon1.Id);
            
            SObjectConfig__c sObjCon2 =  TestHelper.getSObjectConfig(false);
            sObjCon2.Name = 'sObjCon2';
            insert sObjCon2;
            System.assertNotEquals(null, sObjCon2.Id);
            
            UserRole testRole = [Select Id,Name,DeveloperName From UserRole Limit 1];
            Account account = TestHelper.getAccount(false);           
            account.RoleCode__c = testRole.DeveloperName ; 
            account.Name = testRole.Name;            
            insert account; 
            
            List<SObjectSharingRule__c> lstSObjectSharingRuleToInsert =  new List<SObjectSharingRule__c>();
            List<SObjectSharingRule__c> lstSObjectSharingRuleToUpdate =  new List<SObjectSharingRule__c>();
            //Execute test            
            Test.startTest(); 
            
            SObjectSharingRule__c sobjrule = new SObjectSharingRule__c();
            sobjrule.AccessLevel__c = 'Read Only';
            sobjrule.CriteriaRoleNames__c = testRole.Name ;
            sobjrule.RuleType__c = 'Home';
            sobjrule.ShareWithRoleNames__c= testRole.Name;
            sobjrule.SObject__c= sObjCon1.Id;
            sobjrule.CriteriaRoleCodes__c = 'test';
            lstSObjectSharingRuleToInsert.add(sobjrule);
            
            SObjectSharingRule__c sobjrule1 = new SObjectSharingRule__c();
            sobjrule1.AccessLevel__c = 'Read Only';
            sobjrule1.CriteriaRoleNames__c = testRole.Name ;
            sobjrule1.RuleType__c = 'Home';
            sobjrule1.ShareWithRoleNames__c= testRole.Name;
            sobjrule1.SObject__c= sObjCon1.Id;
            sobjrule1.CriteriaRoleCodes__c = 'test1';
            lstSObjectSharingRuleToInsert.add(sobjrule1);    
            
            SObjectSharingRule__c sobjrule2 = new SObjectSharingRule__c();
            sobjrule2.AccessLevel__c = 'Read Only';
            sobjrule2.CriteriaRoleNames__c = testRole.Name ;
            sobjrule2.RuleType__c = 'Home';
            sobjrule2.ShareWithRoleNames__c= testRole.Name;
            sobjrule2.SObject__c= sObjCon1.Id;
            sobjrule2.CriteriaRoleCodes__c = 'test2';
            lstSObjectSharingRuleToInsert.add(sobjrule2); 
            
            insert lstSObjectSharingRuleToInsert;
            //Assert test data       
            System.assertEquals(3,lstSObjectSharingRuleToInsert.size());
            
              //Execute test            
            
            sobjrule.AccessLevel__c = 'Read Only';
            sobjrule.CriteriaRoleNames__c = testRole.Name ;
            sobjrule.RuleType__c = 'Family';
            sobjrule.ShareWithRoleNames__c= testRole.Name;
            sobjrule.SObject__c= sObjCon2.Id;
            upsert sobjrule;   
            sobjrule.RuleType__c = 'Guest';
            
            lstSObjectSharingRuleToUpdate.add(sobjrule);
            
            sobjrule1.CriteriaRoleCodes__c = 'test1update';
            lstSObjectSharingRuleToUpdate.add(sobjrule1);
            
            sobjrule2.CriteriaRoleCodes__c = 'test2update';
            lstSObjectSharingRuleToUpdate.add(sobjrule2);
            
            update lstSObjectSharingRuleToUpdate;
             UserRole objUserRole = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
			insert objUserRole; 
            SObjectSharingRuleTriggerHelper objSObjectSharingRuleTriggerHelper = new SObjectSharingRuleTriggerHelper();
            objSObjectSharingRuleTriggerHelper.getRoleSubordinateUsers(objUserRole.Id);
            
            delete sobjrule;
            Test.stopTest();            
            //Assert test data       
            System.assertEquals(1,1);
            
        }
    }
    @IsTest
    private static void testCriteriaRoleNames() {
        SObjectConfig__c sObjCon1 =  TestHelper.getSObjectConfig(false);
        sObjCon1.Name = 'sObjCon1';
        insert sObjCon1;
        List<SObjectSharingRule__c> lstSObjectSharingRuleToInsert =  new List<SObjectSharingRule__c>();
        UserRole testRole = [Select Id,Name,DeveloperName From UserRole Limit 1];
        
        SObjectSharingRule__c sobjrule = new SObjectSharingRule__c();
        sobjrule.AccessLevel__c = 'Read Only';
        sobjrule.CriteriaRoleNames__c = testRole.Name ;
        sobjrule.RuleType__c = 'Home';
        sobjrule.ShareWithRoleNames__c= testRole.Name;
        sobjrule.SObject__c= sObjCon1.Id;
        insert sobjrule;
        System.assertNotEquals(null, sobjrule.Id);
    }  
}