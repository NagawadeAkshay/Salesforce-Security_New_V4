@isTest
public class TestFilesLinksPageCtrl {
    @isTest
    private static void testMethod1(){
        Test.startTest();
        PageDataHolder__c pageDataHolder = new PageDataHolder__c(Name = 'Test Record');
        insert pageDataHolder;
        System.AssertEquals(pageDataHolder.Name, 'Test Record', 'Name of record is Test Record'  );
        FilesLinksPageCtrl ctrl1 = new FilesLinksPageCtrl();
        ctrl1.urlParamsMap.put('PageDataHolderId',pageDataHolder.Id);
        ctrl1.selectedRecordIds=new List<String>();
        ctrl1.selectedRecordIds.add(pageDataHolder.id);
        ctrl1.clickHandler();
        Test.stopTest();
    }
    
    @isTest
    private static void testMethod2(){
        Test.startTest();
        PageDataHolder__c pageDataHolder = new PageDataHolder__c(Name = 'Test Record');
        insert pageDataHolder;
        System.AssertEquals(pageDataHolder.Name, 'Test Record', 'Name of record is Test Record'  );
        FilesLinksPageCtrl ctrl1 = new FilesLinksPageCtrl();
        ctrl1.urlParamsMap.put('PageDataHolderId',pageDataHolder.Id);
        ctrl1.clickHandler();
        Test.stopTest();
    }
}