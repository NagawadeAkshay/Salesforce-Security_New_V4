/*
	**********************************************************
	Audit History
	**********************************************************
	4/4/2013			Kunal Shah				Created
	**********************************************************  
*/
@IsTest
private with sharing class TestPageBlockConfigAfter {
	@IsTest
	public static void testPageBlockConfigAfter()
	{
		//arrange
		PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true);
		TabConfig__c tabConfig = TestHelper.getTabConfig(pageLayout.id, true);
				
		//act
		Test.startTest();
		PageBlockConfig__c pageBlockConfig = TestHelper.getPageBlockConfig(tabConfig.id, true);
		Test.stopTest();
		
		//assert
		List<PageBlockConfig__c> pageBlocks =[SELECT Id FROM PageBlockConfig__c WHERE TabLayoutConfig__c = :tabConfig.Id];
		System.assertEquals(1, pageBlocks.size());
	}
}