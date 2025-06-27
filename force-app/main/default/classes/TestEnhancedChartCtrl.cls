/*
* CHANGE HISTORY
* =============================================================================
*   Date            Name                            Description
* 06/03/2019      Rahul Thange                      Created
* 06/03/2019      Yogesh Gaikwad                    Reviewed
* 06/03/2019      Rahul Thange                      Modified Field API Name
* =============================================================================
*/
//Deprecated HighChart using Lightning Standard Charts. 
@isTest
public class TestEnhancedChartCtrl {

    @isTest
    static void testEnhancedChartCtrl(){
        Test.StartTest();
        EnhancedChartCtrl chrt = new EnhancedChartCtrl();
        chrt.chartConfig = new ChartConfig__c();
        EnhancedChartCtrl.getChartData(new Map<String, Object>());
        Test.stopTest();
            
        System.assert(chrt.chartType == null, 'defaultPhase should be null');
        System.assert(chrt.chartUniqueName == null, 'userPrefId should be null');
        System.assert(chrt.recId == null, 'retURL should be null');
        System.assert(chrt.chartId == null, 'retURL should be null');
        System.assert(chrt.filterFieldLabel == null, 'retURL should be null');
    }    
    
}