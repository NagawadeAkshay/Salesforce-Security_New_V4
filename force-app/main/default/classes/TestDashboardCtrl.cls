/*
    Test class for DashboardCtrl
    
    **********************************************************
    Audit History
    **********************************************************
    4/14/2014       Nakul Kadam         Created
    **********************************************************  
*/
//Deprecated HighChart using Lightning Standard Charts. 
@isTest
private with sharing class TestDashboardCtrl{

    @isTest
    static void testDashboardCtrl(){
        Test.StartTest();
        DashboardCtrl chrt = new DashboardCtrl();
        chrt.getNamespace();
        chrt.getChartsPerPhase();
        chrt.initCharts();
        chrt.getChartPanel();
        DashboardCtrl.initData = new Map<String,Object>();
        chrt.isInvalidURL = true;
        chrt.size = 5;
        chrt.row = 5;
        DashboardCtrl.initPhases();
        DashboardCtrl.GetFiscalYearValues();
        DashboardCtrl.getTypeAheadRecords('','', '', true);
        Test.stopTest();
            
        System.assert(chrt.DivisionName == null, 'defaultPhase should be null');
        System.assert(chrt.appLabel == null, 'userPrefId should be null');
        System.assert(chrt.currentTabLabelName == null, 'retURL should be null');
    }    

    @isTest
    static void testIcons(){
        Test.startTest();
        Map<String, String> result = DashboardCtrl.getActionIcon();
        Map<String, String> resultLWC = DashboardCtrl.getActionIconLWC();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }
}