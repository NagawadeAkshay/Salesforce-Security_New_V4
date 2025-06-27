/*
    Test Class for Snapshot Controller
    ***********************************************************
    Audit History
    ***********************************************************
    04/25/2014      Vineeth Shetty             Created
    *********************************************************** 
*/
@isTest
private class TestSnapshotCtrl {

    static testMethod void TestUnassignedCtrl() {
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
        //Arrange
        SampleObject11__c announcementInstance = TestHelper.getSampleObject1(true);
        ApexPages.currentPage().getParameters().put('id', announcementInstance.Id);
        
        //Act
        Test.startTest();   
        Test.stopTest();
         system.assertNotEquals(null, announcementInstance)  ; 
        }               
    }
}