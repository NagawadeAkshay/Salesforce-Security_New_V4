/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-18-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global with sharing class SelectListCtrl {
    
    global sObject sObj {get; set;}
    global String fieldApiName {get; set;}
    global List<SelectOption> pickListOptions{get; set;}
    
    global String[] value{get; set;}
    global String valuepicklist {get; set;}
    
    global String renderValue{get; set;}
       
}