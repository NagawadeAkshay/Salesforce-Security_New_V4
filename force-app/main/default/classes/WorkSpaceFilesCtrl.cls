/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review
    ****************************************************************************************
*/
global with sharing class WorkSpaceFilesCtrl{
    public blob file {get;set;}
    public String lghtURL {get;set;}

    global WorkSpaceFilesCtrl(){
        lghtURL = System.Label.LightningFileUploadURL;
    }

    global string getKeyValueMap(){
     	Map<String,String> keyValueMap = new Map<String,String>();
     	keyValueMap.put('userInfoId',  UserInfo.getUserId()); 
     	return JSON.serialize(keyValueMap);
    }
}