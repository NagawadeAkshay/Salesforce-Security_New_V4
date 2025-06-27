/*
This class has methods to test FlexTableCtrl.
**********************************************************
Audit History
**********************************************************
Rahul Thange
**********************************************************  
*/
@isTest
private with sharing class ExpressionBuilderCtrlTest{
    static SObjectConfig__c sObjCon =  TestHelper.getSObjectConfig(true);
    @isTest
    public static void fetchSobjectConfigListTest(){
        //System.assertEquals(null, ExpressionBuilderCtrl.fetchExpressionJSON('005erosjaSHAjskADS','Name'));
        CustomAppConfig__c app = TestHelper.getCustomAppConfig(true);
        //ExpressionBuilderCtrl ExpressionBuilderCtrlObj = new ExpressionBuilderCtrl();
        System.assertNotEquals(null, ExpressionBuilderCtrl.saveJSONExpression(app.Id, 'Name', 'StateAsGrantor'));
        System.assertNotEquals(null, ExpressionBuilderCtrl.fetchSobjectConfigList());
        System.assertEquals(null, ExpressionBuilderCtrl.fetchExpressionJSON('','Name'));
        System.assertNotEquals(null, ExpressionBuilderCtrl.fetchExpressionJSON(app.Id,'Name'));
        System.assertNotEquals(null, ExpressionBuilderCtrl.fetchConfigurations());
        System.assertEquals(null,ExpressionBuilderCtrl.fetchInitialRelatedFields(''));
        System.assertNotEquals(null,ExpressionBuilderCtrl.fetchInitialRelatedFields(AppUtils.getNameSpacePrefix()+'SampleObject11__c'));
        System.assertNotEquals(null,ExpressionBuilderCtrl.fetchObjectRelatedFields(AppUtils.getNameSpacePrefix()+'SampleObject11__c',1));
    }
    
}