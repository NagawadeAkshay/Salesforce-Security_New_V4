/*
	**********************************************************
	Audit History
	**********************************************************
	4/4/2013			Kunal Shah				Created
	**********************************************************  
*/
@IsTest
private with sharing class TestPageBlockDetailConfigAfter {
	@IsTest
	public static void testPageBlockConfigAfter()
	{
		//arrange
		PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
		TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayout.id, true);
		PageBlockConfig__c pageBlockConfig = TestHelper.getPageBlockConfig(tabConfig.id, true);
			  
		//act
		Test.startTest();
		PageBlockDetailConfig__c pageBlockDetail = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id, true);
		Test.stopTest();
		
		//assert
		List<PageBlockDetailConfig__c> pageBlockDetailList =[SELECT Id FROM PageBlockDetailConfig__c WHERE PageBlockConfig__c = :pageBlockConfig.Id];
		System.assertEquals(1, pageBlockDetailList.size());
	}
}