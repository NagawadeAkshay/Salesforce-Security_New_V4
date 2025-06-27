/**
	Test class for SkinnyTableInfo
	**********************************************************
	Audit History
	**********************************************************
	4/28/2014   Vineeth	  Created
	**********************************************************  
*/
@isTest
private class TestSkinnyTableInfo {

    static testMethod void testSkinnyTableInfo() {
        //Arrange
        
        //act
        Test.startTest();   
        SkinnyTableInfo ctrl = new SkinnyTableInfo();
        ctrl.addStringRowCell('testRowValue');
        Test.stopTest();
        
        //assert
        System.assertEquals(1, ctrl.row.size());
    }
}