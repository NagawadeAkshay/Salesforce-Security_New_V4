/**
 * Created by REI on 23-06-2020.
 */

@IsTest
private with sharing class TestFlexGridUtility {

    private static DataTableConfig__c dataTableConfig;
    private static FlexGridConfig__c flexGridConfig;
    @TestSetup
    static void setup(){
        //dataTableConfig = TestHelper.getFlexBudgetGridConfig(true);
    }

    @IsTest
    private static void testFieldNamesForBudgetGrid(){
        Test.startTest();
        dataTableConfig = TestHelper.getFlexBudgetGridConfig(true);
        FlexGridUtility gridUtility = new FlexGridUtility();
        gridUtility.getFieldNamesForBudgetGrid(dataTableConfig);
        System.assertNotEquals(null,gridUtility);
        Test.stopTest();
    }

    @IsTest
    private static void testGridType(){
        flexGridConfig = TestHelper.getFlexGridConfigBudgetGrid(true);
        System.assertNotEquals(null,flexGridConfig);
        Test.startTest();
        String keyValMap = '';
        String listValMap = '';
        FlexGridUtility gridUtility = new FlexGridUtility();
        gridUtility.getGridType(flexGridConfig.Name,keyValMap,listValMap,false);
        Test.stopTest();
    }

    @IsTest
    private static void testGetHideField(){
        dataTableConfig = TestHelper.getFlexBudgetGridConfig(true);
        System.assertNotEquals(null,dataTableConfig);
        Test.startTest();
        FlexGridUtility gridUtility = new FlexGridUtility();
        gridUtility.getHidefield(dataTableConfig);
        Test.stopTest();
    }
}