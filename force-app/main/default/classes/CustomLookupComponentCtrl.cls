/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review
    ****************************************************************************************
*/
global with sharing class CustomLookupComponentCtrl {

    global String displayName{get;set;}
    global Sobject sobjVal{get;set;}
    global String fieldAPINameVal{get;set;}
    global String fieldLabelNameVal{get;set;}
    
    global DynamicLayoutHolder holder{get;set;}
}