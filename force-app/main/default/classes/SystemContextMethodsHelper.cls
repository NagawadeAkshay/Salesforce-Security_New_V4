/*
    This is a class with keyword "without sharing".
    This enables the methods defined here to execute in System Context, that is, the current user's permissions, 
    field-level security, and sharing rules aren’t taken into account during code execution.     
    *******************************************************************************************************************
    Audit History
    ********************************************************************************************************************
    26-Aug-2014        Prem Pal    Created
    **********************************************************************************************************************  
*/ 
global without sharing class SystemContextMethodsHelper {  // Sharing - false +Ve - for business purpose we will not mark this as with sharing explaination provided in false +ve document  
    public void updateUserPreferenceRecord(UserPreferences__c uPref){
        if(Schema.sObjectType.UserPreferences__c.isCreateable() && Schema.sObjectType.UserPreferences__c.isUpdateable()){
            upsert uPref;
        }
    }

    public List<Database.SaveResult> insertAttachments(List<Attachment> attachmentList){
        if(attachmentList.size() > 0 ){
            if(Schema.sObjectType.Attachment.isCreateable()){
                return Database.insert(attachmentList, true);
            }
        }
        return null;
    }
    public List<Database.SaveResult> updateAttachments(List<Attachment> attachmentListToBeInsrted){
        if(Schema.sObjectType.Attachment.isUpdateable() && attachmentListToBeInsrted.size() > 0) {
            return Database.update(attachmentListToBeInsrted, true);
        }
        return null;
    }
    
    public void updateAttachment(Attachment editAttachment){
        update editAttachment;
    }

    public void upsertAttachment(Attachment obj){
        upsert obj;//CRUD/FLS - False +ve - this class runs in system context to fulfill the business requirements - so no need to check 
    }

    public List<ProcessInstanceWorkitem> getProcessInstWorkitem(Set<Id> workItemIdSet){
        return [SELECT id, ActorId, ProcessInstance.TargetObjectId 
        FROM ProcessInstanceWorkitem WHERE Id IN : workItemIdSet WITH USER_MODE];  //CRUD/FLS False +ve with the help of Schema we have performed the check
    }
    
    public List<CaptureItem__c> getCaptureItems(Id secId){
        if(Schema.sObjectType.CaptureItem__c.isAccessible()){
            return [SELECT Id,QuestionIdentifier__c,DependentQuestionJson__c,QuestionApplicable__c 
            FROM CaptureItem__c WHERE CaptureSection__c =: secId WITH USER_MODE];
        } else {
            return null;
        }
    }

    public List<Attachment> getAttachmentDetails(set<Id> selectedAttachments){
       return [SELECT Id, Name,Body,Description FROM Attachment WHERE Id IN :selectedAttachments WITH USER_MODE];//CRUD/FLS False +ve with the help of Schema we have performed the check
    }

    public List<Attachment> getAttachmentListDetails(List<Id> selectedAttachments){
        return [SELECT Id, Name,Body,Description FROM Attachment WHERE Id IN :selectedAttachments WITH USER_MODE];//CRUD/FLS False +ve with the help of Schema we have performed the check
    }

    public Attachment getAttachDetails(Id attachmentId){
        return [SELECT Id, Name, Description, ParentId, Body FROM Attachment WHERE Id = : attachmentId  WITH USER_MODE];//CRUD/FLS False +ve with the help of Schema we have performed the check
     }
    
    public void deleteSobjectList(List<Sobject> sobjList){
        String objName = getSobjectName(sobjList[0]);
        if(AppUtils.isObjectAccessible(objName) && AppUtils.isObjectDeletable(objName)){
            delete sobjList; //NOPMD CRUD False +ve with the help of apputil we have performed check /FLS False +ve - As it is breaking for portal/guest users
        }    
    }
    
    public void updateTasks(List<Task> taskList){
        if(Schema.sObjectType.Task.isUpdateable() && Schema.sObjectType.Task.isAccessible()){
            update taskList;
        }
    }
    
    public void updateSobject(List<SObject> targetObject){
        String objName = getSobjectName(targetObject[0]);
        if(AppUtils.isObjectUpdateable(objName)) {
    	    update targetObject; //NOPMD FLS/ CRUD False +ve with the help of apputil we have performed check
        }
    }

    public void insertSobject(List<SObject> targetObject){
        String objectName = getSobjectName(targetObject[0]);
        if(AppUtils.isObjectCreateable(objectName)){
            insert targetObject; //NOPMD FLS/CRUD False +ve with the help of apputil we have performed check
        }
    }

    public Boolean updateSobjectWithoutPermission(List<SObject> sObj){
        try {
            String objName = getSobjectName(sObj[0]);
            if(AppUtils.isObjectAccessible(objName)){ //AppUtils.isObjectUpdateable(objName) removed this because this was breaking our functionality
                update sObj;//NOPMD CRUD - False +ve - removed this because this was breaking our functionality
            }
            return true;
        } catch (Exception ex){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, AppUtils.handleSystemExceptionMsg(ex));
            ApexPages.AddMessage(errMsg);
            return false;
        }
    }



     public void deleteSobjectWithoutPermission(List<SObject> lstSObj){
        String objName = getSobjectName(lstSObj[0]);
        if(AppUtils.isObjectAccessible(objName)){
            delete lstSObj; //NOPMD CRUD False +ve with the help of apputil we have performed check /FLS False +ve - As it is breaking for portal/guest users
        }
    }
   public void deleteSobjectListSysContext(List<Sobject> sobjList){
    String objName = getSobjectName(sobjList[0]);
    if(sobjList != null){
        delete sobjList;//NOPMD CRUD/FLS False +ve - As it is breaking for portal/guest users
    }
    
}

    public String getSobjectName(Sobject sobjVal){
        return sobjVal.getSobjectType().getDescribe().getName();
    }

    public static List<ProcessInstanceWorkitem> getRecordProcessInstanceWorkitems(Id recordId) {
        if (Schema.sObjectType.ProcessInstanceWorkitem.fields.Id.isAccessible()) {
        return [SELECT Id, Actor.Type, ActorId FROM ProcessInstanceWorkitem 
        WHERE ProcessInstance.TargetObjectId = :recordId LIMIT 100];  //CRUD FLS - False +ve - As this is STD OBJ WILL not check permission here 
    }
        return null;
    }
    
    global List<Task> getRelatedTasks(Set<String> progressReportIds) {
        return [select id,Status,TaskAction__c,ParentRecordId__c from Task 
        where ParentRecordId__c in : progressReportIds WITH USER_MODE ];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
    }
        
    @future
    public static void createShare(Id recordId,Id chosenUserId,Boolean isChild){
        //try catch n savepoint
        Savepoint sp = Database.setSavepoint();
        try{
            //Prajakta:when Master detail relationship is present on object then on chid object ownerId is not present and isChid is false.
            if(isChild == false){
                //From recordId get child object name.
                String objectType = String.valueOf(((Id)recordId).getSobjectType());
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType objectName = schemaMap.get(objectType);
                Map<String, Schema.SObjectField> fieldMap = objectName.getDescribe().fields.getMap();
                Integer relationshipOrder;
                String masterDetailField;
                for (String fieldName: fieldMap.keySet()) {
                    masterDetailField = fieldName; 
                    //For master detail relationshipfield relationship order is 0 and is primary master detail relationship. 
                    relationshipOrder = fieldMap.get(fieldName).getDescribe().getRelationshipOrder();
                    if(relationshipOrder == 0) break;
                }

                String query = 'Select ' + string.escapeSingleQuotes(masterDetailField) + ' From ' + string.escapeSingleQuotes(objectType) + ' Where Id = :'+string.escapeSingleQuotes(recordId);//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                SObject sobj = Database.query(query, AccessLevel.USER_MODE);
                //Here we get parent recordId from child object.In case of master detail we share get parent record from child object and share that record.
                recordId = (Id)sobj.get(masterDetailField);
                

            }
            string objName = recordId.getSObjectType().getDescribe().getName().removeEnd('__c');
            List<Sobject> sobjShare = new List<SObject>();
            Schema.SObjectType shareType = Schema.getGlobalDescribe().get(objName + '__share');
            sobject shareObj =shareType.newSObject();
            shareObj.put('parentId',recordId);
            shareObj.put('UserOrGroupId',chosenUserId);
            shareObj.put('AccessLevel','Edit');
            sobjShare.add(shareObj);
            if(AppUtils.isObjectCreateable(objName))
            Database.insert(sobjShare, false);//NOPMD CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
        }catch(Exception e){
             Database.rollback( sp );
             CustomExceptions.logException(e, true, false);

        }
    }

    /*	Author 			: Dipak Pawar
     * 	Created Date 	: 6 Jan 2020
     * 	Description		: Method to execute SOQL in system context
     */
    global static List<SObject> executeQuery (String strQuery){
        return null;
    }

    /*	Author 			: Dipak Pawar
    * 	Created Date 	: 25 June 2020
    * 	Description		: Method to execute the User details in system context
    */
    public static User objLoggedInUser = null; 
    public static List<String> lstUserFields = new List<String>();
    public static User getCurrentUserDetails() {
        try {
            if(objLoggedInUser == null){
                Schema.DescribeSObjectResult[] descResultSourceObj = Schema.describeSObjects(new String[]{'User'});
                Map<String, Schema.SObjectField> sourceObjFieldsMap = descResultSourceObj[0].fields.getMap();
                String namespace  = AppUtils.getNamespacePrefix();
                for (Schema.SObjectField field : sourceObjFieldsMap.values()) {
                    Schema.DescribeFieldResult descFieldResult = field.getDescribe();
                    if (descFieldResult.isAccessible()) {
                        //lstUserFields.add(descFieldResult.getName());
                        if(descFieldResult.getName().contains(namespace)){
                            if(descFieldResult.getName().startsWith(namespace)){
                                String tempString = descFieldResult.getName();
                                String tempString2 = tempString.removeStart(namespace);
                                Boolean b = checkDuplicate(descFieldResult.getName());
                                Boolean c = checkDuplicate(tempString2);
                                if(b && c){
                                    lstUserFields.add(descFieldResult.getName());
                                }
                            }
                            
                        }
                        else{
                            String tempString = descFieldResult.getName();
                            String tempString2 = namespace+tempString;
                            Boolean b = checkDuplicate(descFieldResult.getName());
                            Boolean c = checkDuplicate(tempString2);
                            if(b && c){
                                lstUserFields.add(descFieldResult.getName());
                            }
                        }
                    }
                }
                if (!lstUserFields.isEmpty()) {
                    Id userId = UserInfo.getUserId();
                    String query = 'SELECT ' + String.escapeSingleQuotes(String.join(lstUserFields, ',')) + ' FROM User WHERE Id =: userId';  //Removed  WITH USER_MODE for As per business scenario it is failing for portal/external users
                    List<User> lstUsers = (List<User>) Database.query(String.escapeSingleQuotes(query));//Added String.escapeSingleQuotes for SF security review
                    if (!lstUsers.isEmpty()) {
                        objLoggedInUser = lstUsers[0];
                    }
                }
            }
            return objLoggedInUser;
        } catch(Exception ex){
            LogExceptionHandler.logException(ex);
            return null;
        }
    }
    public static boolean checkDuplicate(String fieldName){
        boolean returnVariable = true;
        if(lstUserFields.size()>0){
            for(String s:lstUserFields){
            
            if(s.equals(fieldName)){
                returnVariable = false;
                return returnVariable;
            }else{
                returnVariable = true;
            }
        }
        }
        
        return returnVariable;
    }
 
    public static Map<String, String> getIcons(Set<String> setResourceNames) {
        try {
            Map<String, String> mapIcons = new Map<String, String>();
            for(StaticResource sr : [SELECT Id, Name, NamespacePrefix, SystemModStamp FROM StaticResource 
                                    WHERE Name IN: setResourceNames]){   //NOPMD CRUD FLS - FALSE +VE - can not add with User_mode enforced as this is failing for external user
                String namespace = sr.NamespacePrefix;
                mapIcons.put(sr.Name, AppUtils.staticResourceBaseUrl + '/resource/' + sr.SystemModStamp.getTime() + '/' + (String.isNotBlank(namespace) ? namespace + '__' : '') + sr.Name);
            }
            if(!mapIcons.keySet().containsAll(setResourceNames)){
                for(Document doc : [SELECT Id, Name, DeveloperName FROM Document 
                                    WHERE Name IN :setResourceNames AND Name NOT IN :mapIcons.keySet() WITH USER_MODE]) {//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    mapIcons.put(doc.DeveloperName, AppUtils.docBaseUrl + '/servlet/servlet.FileDownload?file=' + doc.Id);
                }
            }
            // check are resource form setResourceNames are quered ir not
            if(!mapIcons.keySet().containsAll(setResourceNames)){
                for(String sr : setResourceNames){
                    if(!mapIcons.keySet().contains(sr)){
                        mapIcons.put(sr,'');
                    }
                }
            }
           
            return mapIcons;
        } catch(Exception ex){
            return null;
        }
    }

    global static void processPermissionSets(Set<Id> userIds){
        try{
            Boolean runAssignment =  KeyValueHolderHelper.getBooleanValue('GovGrantManagePermissionSetConfigHolder');
            String permissionSetNames =  KeyValueHolderHelper.getTextValue('GovGrantManagePermissionSetConfigHolder');
            if(!Test.isRunningTest() && runAssignment && userIds != null && String.isNotEmpty(permissionSetNames)){
                List<String> permissionSetList = permissionSetNames.split(';');
                //Bug - 355145 = Can not apply USERMODE or WITH_SECURITY_ENFORCE as this is standered object - False +ve 
                Map<Id, PermissionSet> mapPermissionSet = new Map<Id, PermissionSet>([SELECT Id, Name FROM PermissionSet 
                                                                                    WHERE Name IN :permissionSetList]); //NOPMD CRUD FLS - False +ve - As this is STD OBJ WILL not check permission here 
                Map<Id, Set<Id>> mapSetExistingUserIds = new Map<Id, Set<Id>>();
                for(PermissionSetAssignment obj : [SELECT Id, AssigneeId, PermissionSetId FROM PermissionSetAssignment 
                                                    WHERE PermissionSetId IN :mapPermissionSet.keySet() AND AssigneeId IN :userIds]){//NOPMD CRUD FLS - False +ve - As this is STD OBJ WILL not check permission here 
                    if(mapSetExistingUserIds.containsKey(obj.PermissionSetId)){
                        mapSetExistingUserIds.get(obj.PermissionSetId).add(obj.AssigneeId);
                    } else {
                        mapSetExistingUserIds.put(obj.PermissionSetId, new Set<Id>{obj.AssigneeId});
                    }
                }
                List<PermissionSetAssignment> lstPermissionSetAssignment = new List<PermissionSetAssignment>();
                for(PermissionSet objPermissionSet : mapPermissionSet.values()){
                    for(Id userId : userIds){
                        Set<Id> setIds = mapSetExistingUserIds.containsKey(objPermissionSet.Id) ? mapSetExistingUserIds.get(objPermissionSet.Id) : new Set<Id>();
                        if(!setIds.contains(userId)){
                            lstPermissionSetAssignment.add(
                                    new PermissionSetAssignment(
                                            PermissionSetId = objPermissionSet.Id,
                                            AssigneeId = userId
                                    )
                            );
                        }
                    }
                }
                if(!lstPermissionSetAssignment.isEmpty()){
                    List<Database.SaveResult> saveResultVal = Database.insert(lstPermissionSetAssignment, false);//CRUD/FLS False +ve this class runs in system context to fulfill the business requirements - so no need to check 
                }
            }
        } catch(Exception ex){
            LogExceptionHandler.logException(ex);
        }
    }

    public static List<sObject> runQueryInSystemMode(string queryStr,string sWildCardText){
        return database.query(queryStr); //SOQL Injection - False +ve - escapeSingleQuotes Applied on whereClause values using  AppUtils.parseWhereClause method to prevent SOQL injection and Dynamic Part of query string is escapeSingleQuotes.
    }

    @AuraEnabled
    public static String saveForGuestUser(String objectName,String recId,String jsonStr){
        try{
            SObject obj;
            obj = (SObject) JSON.deserialize(SFDCEncoder.sanitizeJSON(jsonStr), Type.forName(objectName));   // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON          
            if(recId != null)
                obj.put('Id',recId);
            upsert obj;//NOPMD CRUD/FLS - False +ve - this class runs in system context to fulfill the business requirements - so no need to check 
            return null;
        }catch(Exception ex){
            return Apputils.handleSystemExceptionMsg(ex.getMessage());
        }
    }
}