/*
    Handles the encoding of the multipicklist as checkboxes
    **********************************************************
    Audit History
    **********************************************************
    
    **********************************************************  
*/
global with sharing class SelectCheckboxesCtrl {
	
	global sObject sObj {get; set;}
	global String fieldApiName {get; set;}
	
	global String[] value {
		get {
			return AppUtils.decodeToArray(String.valueOf(sObj.get(fieldApiName)));
		}
		set {
			sObj.put(fieldApiName, AppUtils.encodeToString(value));
		}
	}
}