/*
    Author : Tanmay Deshpande
    Purpose: Helper class To Insert, Update, Delete records into RecordIdStorage__c     
*/
global with sharing class RecordIdStorageHelper{
    global static void setRecordIds(List<String> recordIds, String typeOfRecord){
        List<RecordIdStorage__c> recordIdStorageList = new List<RecordIdStorage__c>();
        for(String recordIdSingle : recordIds){
            RecordIdStorage__c recordIdStorage = new RecordIdStorage__c();
            if(Schema.sObjectType.RecordIdStorage__c.fields.RecordId__c.isCreateable()){
                recordIdStorage.RecordId__c = recordIdSingle;
            }
            if(Schema.sObjectType.RecordIdStorage__c.fields.Type__c.isCreateable()){
                recordIdStorage.Type__c = typeOfRecord;
            }
            recordIdStorageList.add(recordIdStorage);
        }
        if(recordIdStorageList.size() > 0 && Schema.sObjectType.RecordIdStorage__c.isCreateable()){
            insert as user recordIdStorageList;
        }
    }

    global static List<Id> getRecordIds(String typeOfRecord){        
        List<Id> recordIdList = new List<Id>();
        if(Schema.sObjectType.RecordIdStorage__c.isAccessible()){
            for(RecordIdStorage__c recIdStorage : [SELECT RecordId__c FROM RecordIdStorage__c WHERE Type__c = :typeOfRecord AND OwnerId = :UserInfo.getUserId() WITH USER_MODE]){
                recordIdList.add(recIdStorage.RecordId__c);
            }
        }
        return recordIdList;
    }

    global static void deleteRecordIds(String typeOfRecord){
        List<RecordIdStorage__c> recordIdList = new List<RecordIdStorage__c>();
        if(Schema.sObjectType.RecordIdStorage__c.isAccessible()){
            recordIdList = [SELECT RecordId__c,Type__c FROM RecordIdStorage__c WHERE Type__c = :typeOfRecord AND OwnerId = :UserInfo.getUserId() WITH USER_MODE];
        }
        if(!recordIdList.isEmpty() && Schema.sObjectType.RecordIdStorage__c.isDeletable()){
            delete as user recordIdList;
        }
    }
}