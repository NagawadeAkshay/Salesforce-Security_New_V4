/**
 * Created by REI on 22-06-2020.
 */

@IsTest
private with sharing class TestBatchConfigEnhancedCtrl {
    private static BatchConfigEnhancedCtrl batchConfigEnhancedObj;
    @TestSetup static void Setup(){
        batchConfigEnhancedObj =  new BatchConfigEnhancedCtrl();
    }

    @IsTest
    private static void refreshCacheTest(){
        Setup();
        Test.startTest();
        batchConfigEnhancedObj.refreshCache();
        System.assertNotEquals(null,batchConfigEnhancedObj);
        Test.stopTest();
    }
}