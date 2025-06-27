@isTest
private with sharing class TaskTableFilterCtrlTest {
    @IsTest
    static void methodName(){
        Account account = TestHelper.getAccount(true);
        System.assertNotEquals(null, account.Id, 'account is null');
    }
}