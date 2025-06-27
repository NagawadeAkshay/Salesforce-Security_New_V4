/**
*  Test class for the TreeViewCtrl
*
*  CHANGE HISTORY
*================================================================ 
*  Dated          Name              Description 
*  12/15/2017     Shantanu Gadhe    Created 
*================================================================
*/
@isTest
private with sharing class TestTreeViewCtrl{

private static void setup(){
Map <Id,Account> parentAccountMap = new Map<id,Account>();  
Map <Id,Account> childAccountMap = new Map<id,Account>();  
}

 @isTest
 public static void testTreewithParentAndChild(){
   setup();
   User u = TestHelper.getAdminUser(true);
       System.runAs(u) {
           test.startTest();
           Map<String, Object> accountMap = new Map<String, Object>();
           Map<String, Object> paramMap = new Map<String, Object>();
           paramMap.put('objectAPIName','Account');
           paramMap.put('selfLookupFieldAPIName','ParentId');
           paramMap.put('filterclause',null);
           accountMap = TreeViewCtrl.getAccountHierarchy(paramMap);  
           test.stopTest(); 
           System.assertNotEquals(accountMap.size(),0);
       }
}
 }