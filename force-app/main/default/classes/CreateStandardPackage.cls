/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review,
    CustomAppConfig__c, Custom App Public R/W
    ****************************************************************************************
*/
global with sharing class CreateStandardPackage {
    /**
    * Pankaj - This method will use to get all package types
    */
    
     @RemoteAction
    global static List<Map<String, String>> getAppTypes() {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        returnList.add( new Map<String, String>{'id'=>'-- Select --', 'name'=>'-- Select --'} );
        if(Schema.sObjectType.CustomAppConfig__c.isAccessible()){
            List<CustomAppConfig__c> customAppList = [SELECT Name FROM CustomAppConfig__c WHERE Active__c = true WITH USER_MODE ];
                                                            
            for(CustomAppConfig__c customAppListTypeConfig : customAppList){
                returnList.add( new Map<String, String>{'id'=>customAppListTypeConfig.name, 'name'=>customAppListTypeConfig.name} );
                //returnList.add( new Map<String, String>{'id'=>'Grantee', 'name'=>'Grantee'} );
            }
        }
        return returnList;
    }
     
    global static List<Map<String, String>> getPackageTypes() {
        return null;
    }
    @RemoteAction
    global static List<Map<String, String>> getPackageTypes(String selectedAppId) {
        List<Map<String, String>> returnList = new List<Map<String, String>>();
        returnList.add( new Map<String, String>{'id'=>'-- Select --', 'name'=>'-- Select --'} );
        if(Schema.sObjectType.PackageTypeConfig__c.isAccessible()){
            List<PackageTypeConfig__c> packageTypeList = [select name,CustomAppConfig__c,LayoutForm__c
                                                        from PackageTypeConfig__c where CustomAppConfig__r.Name =: selectedAppId
                                                        WITH USER_MODE ];
            

            for(PackageTypeConfig__c packageTypeConfig : packageTypeList){
                returnList.add( new Map<String, String>{'id'=>packageTypeConfig.name, 'name'=>packageTypeConfig.name} );
            
            }
        }
        return returnList;         
    }
    
    
    /**
    * Pankaj :- Method use to get all forms associated with packageId. If packageId is All then return all forms for given submission type.
    */
    global static List<Map<String, Object>> getFormList1(String packageId, String submissionType) {
        return null;
    }
    
    @RemoteAction
    global static List<Map<String, Object>> getFormList1(String packageId, String submissionType,String selectedAppId) {
        List<Map<String, Object>> returnList = new List<Map<String, Object>>();
        if(packageId != 'All') {
            if(Schema.sObjectType.PackageFormConfig__c.isAccessible()){
                List<PackageFormConfig__c> lstPackageForms = [Select Id,Name,FormConfig__r.Name,FormConfig__r.OMBNumber__c,FormConfig__r.Version__c,isMandatory__c 
                                                                from PackageFormConfig__c where PackageConfig__c =: packageId WITH USER_MODE order by Order__c];
                for(PackageFormConfig__c pkgForm : lstPackageForms){
                    returnList.add(new Map<String, Object>{'id'=>pkgForm.FormConfig__r.Id,'selected'=>pkgForm.isMandatory__c, 'name'=>pkgForm.FormConfig__r.Name + 
                                                            (pkgForm.FormConfig__r.OMBNumber__c != null ? ', '+pkgForm.FormConfig__r.OMBNumber__c : '') +
                                                            (pkgForm.FormConfig__r.Version__c != null ? ', v'+pkgForm.FormConfig__r.Version__c : '')});
                }
            }
        } else {
            if(Schema.sObjectType.PageTemplate__c.isAccessible()){
                List<PageTemplate__c> pageFormsList = [select Id,Name,OMBNumber__c,Version__c from PageTemplate__c where PackageType__c =:submissionType and 
                                                            CustomAppConfig__r.Name=:selectedAppId and Status__c = 'Active' and
                                                            RecordType.Name='Business Form' WITH USER_MODE ];
                for(PageTemplate__c pageForm : pageFormsList){
                    returnList.add(new Map<String, Object>{'id'=>pageForm.Id, 'name'=>pageForm.Name + 
                                                            (pageForm.OMBNumber__c != null ? ', '+pageForm.OMBNumber__c : '') +
                                                            (pageForm.Version__c != null ? ', v'+pageForm.Version__c : '')});
                }
            }
        }
         return returnList; 
    }
    
    /**
    * Pankaj - This method will use to get all packages for given submission type
    */
    global static Map<String, Object> getPackageDetails(String packageId) {
        return null;
    }
    @RemoteAction
    global static Map<String, Object> getPackageDetails(String packageId,String selectedAppId) {
        Map<String, Object> returnMap = new Map<String, Object>();
        /*Package__c packageObj = [select id,name,Description__c,Source__c,
                                            RecordType.name,SubmissionType__c from Package__c where Id=:packageId];*/
        Package__c packageObj;
        FrameworkConfig__c fc = FrameworkConfig__c.getValues('PackageAgencyFieldAPIName');
        String query = 'SELECT Id,Name,Description__c,Source__c,RecordType.name,SubmissionType__c,HideForExternalUser__c ';
        if(fc != null && fc.TextValue__c != null) {
            query += ', ' + string.escapeSingleQuotes(fc.TextValue__c);
        }                                   
        query += ' FROM Package__c where id=' + '\'' + String.escapeSingleQuotes(packageId) +'\'';
        if(Schema.sObjectType.Package__c.isAccessible()){
            packageObj = Database.query(query, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
        }if(fc != null && fc.TextValue__c != null && fc.TextValue__c.contains('.')) {
            String nextField = fc.TextValue__c.substringAfter('.');
            String relation = fc.TextValue__c.substringBefore('.');
            if(packageObj.getSObject(relation) != null) {
            String AgencyName = (String)packageObj.getSObject(relation).get(nextField); 
            returnMap.put('Agency',AgencyName);     
            }
        }       
        returnMap.put('packageName', packageObj.Name);
        returnMap.put('packageDescription', packageObj.Description__c);
        returnMap.put('recordType', packageObj.RecordType.name);
        returnMap.put('PackageForms', getFormList1( packageId, packageObj.SubmissionType__c,selectedAppId ) );      
        returnMap.put('submissionType', packageObj.SubmissionType__c);
        returnMap.put('hideForExternalUser', packageObj.HideForExternalUser__c);
        return returnMap;
    }
    
    @RemoteAction
    global static void upsertStandardPackage(String pkgId, Map<String, Object> paramMap) {
        
    }

    private static Integer getMaxVersionNo(String submissionType,String selectedAppId){
        List<Package__c> pkgLst = new List<Package__c>();
        if(Schema.sObjectType.Package__c.isAccessible()){
        pkgLst = [select VersionNumber__c from Package__c
                                    where SubmissionType__c=:submissionType and CustomAppConfig__r.Name=:selectedAppId
                                     WITH USER_MODE order by VersionNumber__c desc limit 1];
        }
        if(pkgLst.size() == 0){
            return 1;
        } else {
            return pkgLst[0].VersionNumber__c != null ? (Integer)pkgLst[0].VersionNumber__c + 1 : 1;
        }
    }

    public string getKeyValueMap(){
        Map<String,String> keyValueMap = new Map<String,String>();
        keyValueMap.put('objName','');
        keyValueMap.put('activeAppID',[Select Id from CustomApp__c where Name =: UserPreferenceHelper.getStringValue('ActiveAppName__c')  WITH USER_MODE limit 1].Id); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        return JSON.serialize(keyValueMap);
        // get the users current active Application       
    }
    @TestVisible 
     public with sharing class PackageWrapper{
        @AuraEnabled
        public list<sObject> ObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldKeyMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scale {get;set;}
        @AuraEnabled
        public String timelol {get;set;}   
        @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public PackageWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
            this.ObjectList = sObjectList;
            this.fieldKeyMap = fieldLableMap;
            this.fieldDataMap = fieldDataTypeMap;
            this.scale = scaleMap;
            this.timelol = (UserInfo.getTimeZone()).toString();
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }
}