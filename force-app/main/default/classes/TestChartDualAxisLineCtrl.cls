/*
This class has methods to create charts according to object name.
**********************************************************
Audit History
**********************************************************
2018-10-24  Sonali Bajirao Jadhav     Created
**********************************************************  
*/
//Deprecated HighChart using Lightning Standard Charts. 
@isTest
private with sharing class TestChartDualAxisLineCtrl {

    @isTest
    static void testChartDualAxisLine(){
        Test.StartTest();
        ChartDualAxisLineCtrl chrt = new ChartDualAxisLineCtrl();
        ChartDualAxisLineCtrl.fetchInitialData('','','',false, '');
        ChartDualAxisLineCtrl.fetchInitDataWithRecordId('','','',false, '','');
        ChartDualAxisLineCtrl.getChartsData(new Map<String, Object>());
        Test.stopTest();
            
        System.assert(chrt.defaultPhase == null, 'defaultPhase should be null');
        System.assert(chrt.currentFiscalYear == null, 'userPrefId should be null');
        System.assert(chrt.recordId == null, 'retURL should be null');
    }
   
}