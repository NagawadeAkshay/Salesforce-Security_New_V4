/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review
    ****************************************************************************************
*/
global with sharing class FormatCurrencyCtrl {
    
    global Integer decimalScale{get;set;}
    global Double val{get;set;}
    global String formattedValue{get;set;}
    global String currencySymbol{get;set;}
    
    
    global Component.Apex.OutputPanel getFormattedCurrency() {
         Component.Apex.OutputPanel outputPanel = new Component.Apex.OutputPanel();
        return outputPanel;
    }
}