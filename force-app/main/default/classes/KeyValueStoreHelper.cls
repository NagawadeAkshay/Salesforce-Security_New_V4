/*
	Represents KeyValueStore__c custom setting object. This class has convenient 
	methods to fetch and persist values from this custom setting. Since custom setting is cached,
	this class will return the cached information only. 
	**********************************************************
	Audit History
	**********************************************************
	2012-03-18	Shah Kadirmohideen 		Created
	2013-11-22	Glen Watson				Added set methods
	2013-11-26	Glen Watson				Added access to private KVStore
	2014-02-14	Glen Watson				Made it manditory to specific public or private store
	**********************************************************  
*/ 
global with sharing class KeyValueStoreHelper {
	
	//Getters
	//Use this method to return value from TextValue__c field
	global static String getTextValue(String keyWord, boolean isPublic) {
		String value = null;
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			value = keyValueRecord == null ? null : keyValueRecord.TextValue__c;
		}	
		return String.escapeSingleQuotes(value);
	}
	
	//Use this method to return value from BooleanValue__c field
    global static Boolean getBooleanValue(String keyWord, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			return keyValueRecord == null ? null : keyValueRecord.BooleanValue__c;
		} 
		return null;
	}
	
	//Use this method to return value from IntegerValue__c field
	global static Integer getIntegerValue(String keyWord, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			return keyValueRecord == null ? null : keyValueRecord.IntegerValue__c == null ? null : keyValueRecord.IntegerValue__c.intValue();
		} 
		return null;
	}
	
	//Use this method to return value from DecimalValue__c field
    global static Decimal getDecimalValue(String keyWord, boolean isPublic) {	
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			return keyValueRecord == null ? null : keyValueRecord.DecimalValue__c;
		}
		return null;
	}
	
	//Use this method to return value from DateValue__c field
    global static Date getDateValue(String keyWord, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			return keyValueRecord == null ? null : keyValueRecord.DateValue__c;
		} 
		return null;
	}
	
	//Use this method to return value from DateTimeValue__c field
    global static DateTime getDateTimeValue(String keyWord, boolean isPublic) {	
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			return keyValueRecord == null ? null : keyValueRecord.DateTimeValue__c;
		} 
		return null;
	}
	
	//Setters
	//Use this method to set values to TextValue__c field
    global static void setTextValue(String keyWord, String value, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				insert as user new KeyValueStore__c(Name=keyWord, TextValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isUpdateable()){
					keyValueRecord.TextValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecord;
				}
			}
		} 
	}
	
	
	//Use this method to set values to BooleanValue__c field
    global static void setBooleanValue(String keyWord, Boolean value, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				insert as user new KeyValueStore__c(Name=keyWord, BooleanValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');//FLS False +ve As per business scenario it is breaking for portal/guest users.
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.BooleanValue__c.isUpdateable()){
					keyValueRecord.BooleanValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecord;
				}
			}
		} 
	}
	
	//Use this method to set values to IntegerValue__c field
    global static void setIntegerValue(String keyWord, Integer value, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				insert as user new KeyValueStore__c(Name=keyWord, IntegerValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.IntegerValue__c.isUpdateable()){
					keyValueRecord.IntegerValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecord;
				}
			}
		}
	}
	
	//Use this method to set values to DecimalValue__c field
    global static void setDecimalValue(String keyWord, Decimal value, boolean isPublic) {
		if(isPublic){
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				insert as user new KeyValueStore__c(Name=keyWord, DecimalValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');//FLS False +ve As per business scenario it is breaking for portal/guest users.
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.DecimalValue__c.isUpdateable()){
					keyValueRecord.DecimalValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecord;
				}
			}
		} 
	
	}
	
	//Use this method to set values to DateValue__c field
    global static void setDateValue(String keyWord, Date value, boolean isPublic) {	
		if(isPublic) { 
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				insert as user new KeyValueStore__c(Name=keyWord, DateValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');//FLS False +ve As per business scenario it is breaking for portal/guest users.
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.DateValue__c.isUpdateable()){
					keyValueRecord.DateValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecord;
				}
			}
		} 
	}
	
	//Use this method to set values to DateTimeValue__c field
    global static void setDateTimeValue(String keyWord, DateTime value, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				insert as user new KeyValueStore__c(Name=keyWord, DateTimeValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.DateTimeValue__c.isUpdateable()){
					keyValueRecord.DateTimeValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecord;
				}
			} 
		}
	}
	
	/* PRIVATE METHODS */
	private static KeyValueStore__c getPublicRecord(String keyWord) {
		return KeyValueStore__c.getInstance(keyWord);
	}
	
}