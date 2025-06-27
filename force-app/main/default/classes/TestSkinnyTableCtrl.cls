/**
	Test class for SkinnyTableCtrl
	**********************************************************
	Audit History
	**********************************************************
	4/28/2014   Vineeth	  Created
	**********************************************************  
*/
@isTest
private with sharing class TestSkinnyTableCtrl {

	@IsTest(OnInstall=false)
	private static void modifyMyName() {
		//Prepare test data

		//Act		
		Test.startTest();
		SkinnyTableCtrl ctrl = new SkinnyTableCtrl();

		Test.stopTest();

		//Assert test data
		System.assertEquals(ctrl.headerValue, null);
		System.assertEquals(ctrl.tableData, null);
	}
}