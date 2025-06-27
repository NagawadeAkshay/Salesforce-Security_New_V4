/*
  This class has methods to fetch charts according to User Preferences.
  **********************************************************
  Audit History
  **********************************************************
  2014-03-26  Manasi Gangal     Created
  4-6-2014      Nakul Kadam     Updated loadChartData
  **********************************************************  
*/ 
 //Deprecated HighChart using Lightning Standard Charts.
 global with sharing class ChartsViewCtrl{
    
    global List<ChartConfig__c> charts;
    global integer row{get;set;}
    
    global ChartsViewCtrl(){
    }
  
    /*Alternalte method to display charts dynamically using component */
    
      global Component.Apex.OutputPanel getChartPanel() {
        Component.Apex.OutputPanel dynCharts = new Component.Apex.OutputPanel(layout='block'); 
        return dynCharts;
     }
    
    /*
        This method is fetching charts ids from UserPreference custom setting (custom app specific).
    */
    global void loadChartData(){
      
    }
}