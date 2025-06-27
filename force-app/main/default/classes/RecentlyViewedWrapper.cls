/*
    Wrapper class to facilitate and render recently viewed items at side bar.
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    10-10-2018		Yogeshkumar Gaikwad		Created
    ****************************************************************************************
*/
global with sharing class RecentlyViewedWrapper
{
	@AuraEnabled global Id RecordId {get; set;}
	@AuraEnabled global String Name { get; set;}
	@AuraEnabled global String RecordTypeDevloperName {get; set;}
	@AuraEnabled global String Type {get; set;}
	@AuraEnabled global Datetime LastViewedDate {get; set;}

	global RecentlyViewedWrapper(){

	}
	// This method has been absolete
	global RecentlyViewedWrapper(Id recordId, String strName, String strRecordTypeDevloperName, String strType){
		
	}
	// This method is reffered recently
	global RecentlyViewedWrapper(Id recordId, String strName, String strRecordTypeDevloperName, String strType , DateTime lastViewedDate){
		
	}
}