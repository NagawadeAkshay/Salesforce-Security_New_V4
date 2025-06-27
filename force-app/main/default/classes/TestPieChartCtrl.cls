/*
This class has methods to create charts according to object name.
**********************************************************
Audit History
**********************************************************
2018-10-19  Sonali Bajirao Jadhav     Created
**********************************************************  
*/
//Deprecated HighChart using Lightning Standard Charts. 
@isTest
private with sharing class TestPieChartCtrl{

    @isTest
    static void testPieChart(){
        Test.StartTest();
        PieChartCtrl chrt = new PieChartCtrl();
        PieChartCtrl.fetchInitialData('','','', '');
        PieChartCtrl.fetchInitDataWithRecordId('','','',false, '','');
        PieChartCtrl.fetchData('','','','');
        PieChartCtrl.fetchInitData('','','',false,'');
        PieChartCtrl.getChartsData(new Map<String, Object>());
        Test.stopTest();
            
        System.assert(chrt.defaultPhase == null, 'defaultPhase should be null');
        System.assert(chrt.currentFiscalYear == null, 'userPrefId should be null');
        System.assert(chrt.recordId == null, 'retURL should be null');
        System.assert(chrt.chartFilterParameters == null, 'retURL should be null');
    }    

    @isTest
    static void testPieChartCtrl1(){
        Map<String,String> IconCssMap = new Map<String,String>();
        Map<String,String> IconCssMapNew = new Map<String,String>();
        Test.startTest();
            IconCssMap = PieChartCtrl.getActionIcon(); 
            IconCssMapNew = PieChartCtrl.getActionIconLwc(); 
        Test.stopTest();
        System.assertNotEquals(null, IconCssMap);
        System.assertNotEquals(null, IconCssMapNew);
    }
    
}