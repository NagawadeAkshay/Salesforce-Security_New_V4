@isTest
public with sharing class TestUsefulLinksCtrl {
	static UsefulLinksCtrl ctrl;
	public static void setupData(){
		List<UsefulLinkConfig__c> listCustomSetting = new List<UsefulLinkConfig__c>();
		UsefulLinkConfig__c usefulLink1 = new UsefulLinkConfig__c(Name='Link1',Active__c=true,Label__c='testLabel1',URL__c='www.login.salesforce.com',OpenInNewWindow__c=true,Location__c='ApplicantLogin',Sequence__c=1);
		UsefulLinkConfig__c usefulLink2 = new UsefulLinkConfig__c(Name='Link2',Active__c=true,Label__c='testLabel2',URL__c='www.login.salesforce.com',OpenInNewWindow__c=true,Location__c='ReviewerLogin',Sequence__c=1);
		listCustomSetting.add(usefulLink1);
		listCustomSetting.add(usefulLink2);
		insert listCustomSetting;	
		TestHelper.createCustomSettings(true);	
		KeyValueStoreHelper.setIntegerValue('UsefulLinksCharacterCount', 150, true);
        KeyValueStoreHelper.setIntegerValue('UsefulLinksExpandedItemsCount', 6, true);
        KeyValueStoreHelper.setIntegerValue('UsefulLinksVisibleItemsCount', 3, true);				
	}

	@isTest
	static void testIf(){
		user u = TestHelper.getAdminUser(false);
		system.runAs(u){
			Test.startTest();
			setupData();
			Test.setCurrentPageReference(new PageReference('Page.ApplicantLogin1'));
   			ctrl = new UsefulLinksCtrl();	
			Test.stopTest();
			system.assert(ctrl != null);
		}
	}

	@isTest
	static void testElse(){
		user u = TestHelper.getAdminUser(false);
		system.runAs(u){
			Test.startTest();
			setupData();
			Test.setCurrentPageReference(new PageReference('Page.ReviewerLogin1'));        				
   			ctrl = new UsefulLinksCtrl();				
			Test.stopTest();
			system.assert(ctrl != null);
		}
	}
}