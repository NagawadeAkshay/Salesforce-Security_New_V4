/*
	Represents KeyValueHolder__mdt metadata type object. This class has convenient 
	methods to fetch and persist values from this metadata type. 
	**********************************************************
	Audit History
	**********************************************************
	2019-11-15	Yogeshkumar Gaikwad			Made it to make aleternative for keyvaluestore custom setting
	**********************************************************  
*/ 
global with sharing class KeyValueHolderHelper {
	// Cached all records to avoid SOQL as a part of Optimization
	//Task 163529: NED - Performance optimization Auguest 2021 release
   static Map<String, KeyValueHolder__mdt> mapKeyValueHolder = new Map<String, KeyValueHolder__mdt>();
	
	static {
		for(KeyValueHolder__mdt obj : [SELECT Id, DeveloperName, TextValue__c, BooleanValue__c, Description__c FROM KeyValueHolder__mdt where DeveloperName != null WITH USER_MODE]){ //CRUD  FLS- False +ve - this is metadata will not check permission here 
			//SF security review
			mapKeyValueHolder.put(obj.DeveloperName.trim().toLowerCase(), obj);
		}
	}
	public static KeyValueHolder__mdt getKeyValueHolder(String key){					
		return mapKeyValueHolder.get(key.trim().toLowerCase());
	}
	
	//Getters
	//Use this method to return value from TextValue__c field
	global static String getTextValue(String key) {	
		//KeyValueHolder__mdt keyValueRecord = KeyValueHolder__mdt.getInstance(key);//getPublicRecord(key,'TextValue__c');
		KeyValueHolder__mdt keyValueRecord = mapKeyValueHolder.get(key.trim().toLowerCase());//getPublicRecord(key,'TextValue__c');		
		//KeyValueHolder__mdt keyValueRecord = mcs.get(key);	
		if(keyValueRecord != null) {
			return keyValueRecord.TextValue__c;
		}
		return null;
	}
	//Use this method to return value from BooleanValue__c field
    global static Boolean getBooleanValue(String key) {	
		//KeyValueHolder__mdt keyValueRecord = KeyValueHolder__mdt.getInstance(key);	
		KeyValueHolder__mdt keyValueRecord = mapKeyValueHolder.get(key.trim().toLowerCase());
		//KeyValueHolder__mdt keyValueRecord = mcs.get(key);
		if(keyValueRecord != null) {
			return keyValueRecord.BooleanValue__c;
		}
		return false;
	}
	
	//Use this method to return value from IntegerValue__c field
	global static Integer getIntegerValue(String key) {	
		KeyValueHolder__mdt keyValueRecord = mapKeyValueHolder.get(key.trim().toLowerCase());
		if(keyValueRecord != null && keyValueRecord.TextValue__c != null && KeyValueRecord.TextValue__c.isNumeric()) {
			return Integer.valueOf(keyValueRecord.TextValue__c);
		}
		return null;
	}
	
	//Use this method to return value from DecimalValue__c field
    global static Decimal getDecimalValue(String key) {	
		KeyValueHolder__mdt keyValueRecord = mapKeyValueHolder.get(key.trim().toLowerCase());
		if(keyValueRecord != null && keyValueRecord.TextValue__c != null){
			try{
				Decimal decVal =  Decimal.valueOf(keyValueRecord.TextValue__c);
				return decVal; 
			} 
			catch (Exception e) {
				return null;
			}
	    }	
		
		return null;
	}
	
	//Cannot remove Global methods
	global static Date getDateValue(String key) {return null;}
	global static DateTime getDateTimeValue(String key) {return null;}
	global static String getModuleValue(String key) {return null;}
	global static String getAdminQuestionValue(String key) {return null;}
	global static String getParameterValue(String key) {return null;}

	//Use this method to return value from Description field
    global static String getDescriptionValue(String key) {
		KeyValueHolder__mdt keyValueRecord = mapKeyValueHolder.get(key.trim().toLowerCase());
		if(keyValueRecord != null){
			return keyValueRecord.Description__c;
		}
		return null;
	}
}