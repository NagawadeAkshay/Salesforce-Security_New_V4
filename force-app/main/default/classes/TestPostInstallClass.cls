@isTest
private class TestPostInstallClass {
	
	@isTest static void testInstallation() {
		PostInstallClass postInstall = new PostInstallClass();
		Test.testInstall(postInstall, new Version(4,0));
        
String testString = 'test value';
        system.assertNotEquals(null,testString ); 
	}
    
    @isTest static void upsertSobjectPhaseConfigRecordsTest() {
        List<sObject> sobjectsToInsert = new List<sObject>();
        PhaseConfig__c phaseConfig = TestHelper.getPhase(false);
        phaseConfig.Name = 'GrantorPlanning';
        phaseConfig.SObject__c = 'Program__c;Announcement__c';
        sobjectsToInsert.add(phaseConfig);
        
        SObjectConfig__c sobjectConfig = new SObjectConfig__c();
        sobjectConfig.Name = 'Program__c';
        sobjectConfig.CriteriaField__c = 'Status__c';
        sobjectsToInsert.add(sobjectConfig);
        
        SObjectConfig__c sobjectConfigAnnouncement = new SObjectConfig__c();
        sobjectConfigAnnouncement.Name = 'Announcement__c';
        sobjectConfigAnnouncement.CriteriaField__c = 'Status__c';
        sobjectsToInsert.add(sobjectConfigAnnouncement);
        insert sobjectsToInsert;
        
        sobjectsToInsert.clear();
        
        SearchConfig__c searchConfig = TestHelper.getSearchConfig(phaseConfig.Id, false);
        SearchConfig__c searchConfigAnnoun = TestHelper.getSearchConfig(phaseConfig.Id, false);
        searchConfigAnnoun.SObject__c = 'Announcement__c';
        sobjectsToInsert.add(searchConfig);
        sobjectsToInsert.add(searchConfigAnnoun);

        SObjectPhaseConfig__c sobjectPhase = TestHelper.getSObjectPhaseConfig(phaseConfig.Id, sobjectConfig.Id, false);
        sobjectPhase.GlobalSearchVisibility__c = false;
        sobjectPhase.RecentlyViewedVisibility__c = false;
        sobjectsToInsert.add(sobjectPhase);
        
        insert sobjectsToInsert;
                
		PostInstallClass postInstall = new PostInstallClass();
        postInstall.upsertSobjectPhaseConfigRecords();
        
        List<SObjectPhaseConfig__c> dbListSobjectPhase = [SELECT PhaseConfig__c, PhaseConfig__r.Name, SObjectConfig__c, 
                                                          SObjectConfig__r.Name, GlobalSearchLabel__c, 
                                                          GlobalSearchFlexTableConfig__c, GlobalSearchVisibility__c, 
                                                          RecentlyViewedVisibility__c
                                                          FROM SObjectPhaseConfig__c];
        
        system.assert(dbListSobjectPhase.size() == 2);
        
        for(SObjectPhaseConfig__c sobjPhase : dbListSobjectPhase) {
            if(sobjPhase.SObjectConfig__r.Name == 'Program__c') {
                system.assert(sobjPhase.SObjectConfig__c == sobjectConfig.Id);
                system.assert(sobjPhase.GlobalSearchVisibility__c == true);
            } else {
                system.assert(sobjPhase.SObjectConfig__r.Name == 'Announcement__c');
            }
        }
        
	}
}