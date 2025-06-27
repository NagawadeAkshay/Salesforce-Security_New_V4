/**
**/
global with sharing class TaskReassignmentCtrl {

    /*
    *This method queries data according to the passed parameters
    ***/
    public boolean showFlexTable {get;set;}
    public string sourceUserName {get;set;}
    public string targetUserName {get;set;}
    public string flexTableName {get;set;}

    global TaskReassignmentCtrl(){
        init();
    }

    private void init(){
        String srcId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('sourceUser'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String targetId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('targetUser'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String phaseName = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('phaseName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(String.isEmpty(phaseName)){
            flexTableName = 'TaskReassignment';
        }else{
             flexTableName = 'TaskReassignmentByPhase';
        }
        if(String.isNotEmpty(srcId) && String.isNotEmpty(targetId)){
            showFlexTable = true;
            List<Id> userIds = new List<Id>();
            userIds.add(srcId);
            userIds.add(targetId);
            Map<Id,User> users = new Map<Id,User>([select id,name FROM User where id in :userIds WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            sourceUserName = users.get(Id.valueOf(srcId)).Name;
            targetUserName = users.get(Id.valueOf(targetId)).Name;
        }else{
            showFlexTable = false;
        }
    }

    public string getKeyValueMap(){
        Map<String,String> keyValueMap = new Map<String,String>();
        String srcId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('sourceUser'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String targetId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('targetUser'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String phaseName = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('phaseName')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(String.isNotEmpty(srcId) && String.isNotEmpty(targetId)){
            keyValueMap.put('srcUserId',srcId);
            keyValueMap.put('targetUserId',targetId);
            keyValueMap.put('targetUserName',targetUserName);
            keyValueMap.put('phaseName',phaseName);


        }
        return json.serialize(keyValueMap);
    }  

    @RemoteAction
    global static Map<String,Object> fetchUsers(String term){
        
        Map<String,Object> userMap = new Map<String,Object>();
        List<UserData> userDatas= new List<UserData>();
        String nameStr = '%'+ String.escapeSingleQuotes(term) +'%';
        String userType = 'Guest';
        String soql = 'select id,name from User where Name like :nameStr and IsActive = true and IsExternalUser__c = false and UserType != :userType';////SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
     	if(!Test.isRunningTest()){												/*put this condition becoz IsExternalUser__c field was not their in User obj on GNT org  :AJ*/
            for( Sobject sObj : Database.query(String.escapeSingleQuotes(soql), AccessLevel.USER_MODE)){
	            userDatas.add(new UserData(sObj.get('Id'),sObj.get('Name')));
	        }
        }
        userMap.put('UserList',userDatas);
        return userMap;
    }

    @RemoteAction
    global static Map<String,Object> fetchUser(String term){
        term = String.escapeSingleQuotes(term);
        Map<String,Object> userMap = new Map<String,Object>();
        List<UserData> userDatas= new List<UserData>();
        String soql = 'select id,name from User where id=:term';//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
        for( Sobject sObj : Database.query(soql,AccessLevel.USER_MODE)){
            userDatas.add(new UserData(sObj.get('Id'),sObj.get('Name')));
        }
        userMap.put('UserList',userDatas);
        return userMap;
        
    }
    
    global with sharing class UserData{
        public String id;
        public String text;
        
        global UserData(Object id, Object text){
            this.id = String.valueOf(id);
            this.text = String.valueOf(text);
        }
    }
}