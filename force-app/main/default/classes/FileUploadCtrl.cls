/*
* Class Name    :   FileUploadCtrl
* Description   :   Utility class for Salesforce Files functionality
* --------------------------------------------------------------------------------------------------------------------
*   Version     Date                Author                      Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0         25 July 2019        Dipak Pawar                 Initial Development
* --------------------------------------------------------------------------------------------------------------------
*/
global without sharing class FileUploadCtrl extends FlexTableActionHandler {
    
    public static Map<String,String> iconMap;
    private static final String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    /*
    * Description   :   Utility method to get query result by passing query as a parameter in strQuery.
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static List<SObject> executeQuery (String strQuery){        
        try{
            return Database.query(string.escapeSingleQuotes(strQuery));
        }catch(Exception objException){
            throw new AuraHandledException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    /*
    * Description   :   Utility method to save records by passing records as a parameter. 
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static String saveRecords (List<SObject> records){
        Savepoint objSavepoint = Database.setSavepoint();
        SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
        String sObjName = cls.getSobjectName(records[0]);
        try{
            if(records != null && records.size() > 0 && records[0].Id != null){
                if(AppUtils.isObjectUpdateable(sObjName)){
                    return JSON.serialize(Database.update(records)); //CRUD/FLS False +ve with the help of AppUtils we have performed check
                } 
            } else {
                if(AppUtils.isObjectCreateable(sObjName)){
                    return JSON.serialize(Database.insert(records)); //CRUD/FLS False +ve with the help of AppUtils we have performed check
                }                      
            }    
            return null;                  
        }catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new AuraHandledException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    /*
    * Description   :   Utility method to delete records by passing records as a parameter. 
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static String deleteRecords (List<SObject> records){        
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
            String sObjName = cls.getSobjectName(records[0]);
            if(AppUtils.isObjectDeletable(sObjName)){   
                return JSON.serialize(Database.delete(records)); //CRUD/FLS False +ve with the help of AppUtils we have performed check
            }
            return null;
        }catch(Exception objException){
            Database.rollback(objSavepoint);
            LogExceptionHandler.logException(objException);
            throw new AuraHandledException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    @AuraEnabled
    public static Boolean isWorkspaceConfigured(List<Id> workspaceIds){
        try{
            Integer countIds = workspaceIds != null ? workspaceIds.size() : 0;
            String strQuery = 'SELECT count() FROM ContentWorkspace';
            if(countIds > 0){
                strQuery += ' WHERE Id =: workspaceIds WITH USER_MODE';
               //strQuery += ' WHERE Id =\'%'+String.escape(workspaceIds)+'%\'  WITH USER_MODE';

                 
            }
            return Database.countQuery(strQuery) > 0;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    /*
   * Description   :   Method to get page data for WorkspaceFiles lightning component
   * Created By    :   Dipak Pawar on 30 July 2019
   */
    @AuraEnabled
    public static Map<String, Object> getWorkspaceFilesData(List<String> workspaceIds){
        try{
            Map<String, Object> mapWorkspaceFilesData = new Map<String, Object>();
            String disableUploadFromLibraryTabProfiles = KeyValueHolderHelper.getBooleanValue('DisableUploadFromLibraryTab') ? KeyValueHolderHelper.getTextValue('DisableUploadFromLibraryTab') : null;
            if(String.isNotBlank(disableUploadFromLibraryTabProfiles)) {
                Set<String> setProfiles = new Set<String>();
                for (String profileName : disableUploadFromLibraryTabProfiles.split(';')) {
                    setProfiles.add(profileName.trim().toLowerCase());
                }
                if(Schema.sObjectType.User.fields.Id.isAccessible()) {
                    User objUser = [SELECT Id, Name, IsActive, ProfileId, Profile.Name 
                    FROM User WHERE Id =: UserInfo.getUserId()];//WITH SECURITY_ENFORCED Removing as this do not work for SPI User
                    mapWorkspaceFilesData.put('disableUploadFromLibraryTab', objUser != null && setProfiles.contains(objUser.Profile.Name.toLowerCase()));
                }
            }
            Map<Id, ContentWorkspace> mapContentWorkspace;
            if(workspaceIds != null && !workspaceIds.isEmpty()){
                mapContentWorkspace = new Map<Id, ContentWorkspace>([SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId 
                FROM ContentWorkspace WHERE Id =:workspaceIds WITH USER_MODE]);
            } else {
                mapContentWorkspace = new Map<Id, ContentWorkspace>([SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId 
                FROM ContentWorkspace WITH USER_MODE]);
            }

            Boolean isWorkspaceConfigured = !mapContentWorkspace.isEmpty() || uploadFileToPrivateLibrary();
            String message;

            if(!isWorkspaceConfigured){
                message = 'You don\'t have access to any Library. Please contact your administrator.';                
            }

            mapWorkspaceFilesData.put('isWorkspaceConfigured', isWorkspaceConfigured);
            if(String.isNotBlank(message)){
                mapWorkspaceFilesData.put('message', message);
            }
            return mapWorkspaceFilesData;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    //User Story 90298: NFWF - Internal - Add a Private checkbox field in Files modal window (Add file modal page)
    static List<Map<String, Object>> getSharingOptions(){
        List<Map<String, Object>> sharingOptions = new List<Map<String, Object>>();
        Schema.DescribeFieldResult fieldResult = ContentVersion.SharingPrivacy.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            sharingOptions.add(new Map<String, Object>{'label' => f.getLabel(), 'value' => f.getValue()});
        }
        return sharingOptions;
    }
    
    /*
    * Description   :   Method to get page data for WorkspaceFiles lightning component
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static Map<String, Object> getPageData(Id recordId, Id pageBlockId){
        try{
            Map<String, Object> mapPageData = new Map<String, Object>();
            if(recordId != null || pageBlockId != null){
                mapPageData.put('fileTypes', getFileTypes(recordId, pageBlockId));
            }

            //User Story 90298: NFWF - Internal - Add a Private checkbox field in Files modal window (Add file modal page)
            mapPageData.put('sharingOptions', getSharingPrivacy());
            mapPageData.put('showSharingOptions', showSharingPrivacy());
            mapPageData.put('salesforceBaseUrl', 'callout:ApexMDApi');
            mapPageData.put('sessionId', UserInfo.getOrganizationId()+''+'{!$Credential.OAuthToken}');
            mapPageData.put('networkId', Network.getNetworkId());
            mapPageData.put('spinnerURL', LightningUtilityCtrl.getSpinnerURL());
            mapPageData.put('isExternalUser', isExternalUser());

            //User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
            Boolean uploadFileToPrivateLibrary = uploadFileToPrivateLibrary();
            mapPageData.put('uploadFileToPrivateLibrary', uploadFileToPrivateLibrary);

            //User Story 155253: LAHSA : Attachment Classification should be required on save
            Boolean classificationRequired = KeyValueHolderHelper.getBooleanValue('classificationRequired');
            mapPageData.put('classificationRequired', classificationRequired);

            if(!uploadFileToPrivateLibrary){
                mapPageData.put('defaultFolder', getDefaultFolder());
            }

            return mapPageData;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        } 
    }
    
    /*
    * Description   :   Method to get Workspace files for FileUploadFromWorkspace lightning component
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    // @AuraEnabled
    // public static Map<String, Object> getWorkspaceFiles(Id parentId, List<String> workspaceIds){
    //     return workspaceFilesHelper(parentId,workspaceIds,'');
    // }
    /*
    * Description   :   Method to get Workspace files for FileUploadFromWorkspace lightning component
    * Created By    :   Dipak Pawar on 30 July 2019
    * Modified By   :   Rahul on December 2020 for Server side searching
    */
    // @AuraEnabled
    // public static Map<String, Object> getWorkspaceFiles(Id parentId, List<String> workspaceIds, String searchTerm){
    //     return workspaceFilesHelper(parentId,workspaceIds,searchTerm);
    // }
    /*
    * Description   :   Method to get Workspace files for FileUploadFromWorkspace lightning component
    * Created By    :   Dipak Pawar on 30 July 2019
    * Modified By   :   Rahul on December 2020 for Server side searching
    */
    private static Map<String, Object> workspaceFilesHelper(Id parentId, List<String> workspaceIds, String searchTerm){
        try{
            List<ContentVersion> lstWorkspaceFiles = new List<ContentVersion>();
            Map<String, Object> mapWorkspaceFilesData = new Map<String, Object>();
            Map<Id, ContentWorkspace> mapContentWorkspace;
            if(workspaceIds != null && !workspaceIds.isEmpty()){
                mapContentWorkspace = new Map<Id, ContentWorkspace>([SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId 
                FROM ContentWorkspace WHERE Id =:workspaceIds WITH USER_MODE]);
            } else {
                mapContentWorkspace = new Map<Id, ContentWorkspace>([SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId 
                FROM ContentWorkspace where Name != '' WITH USER_MODE]);
            }
            // User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
            // User Story 120046: Internal - Workspace Files - Add Support of more than 10K records in attachments
            if(uploadFileToPrivateLibrary()){
                String strQuery = 'SELECT Id, Title, FileType, Description, Classification__c, ContentDocumentId, CreatedDate, LastModifiedDate FROM ContentVersion WHERE IsLatest = true';
                if(String.isNotEmpty(searchTerm)){
                    strQuery += ' AND (Title LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\' OR Description LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\' OR Classification__c LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\')';
                }
                strQuery += ' WITH USER_MODE LIMIT 1000';
                lstWorkspaceFiles = Database.query(strQuery);//NOPMD SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
            } else if(!mapContentWorkspace.isEmpty()){
                Set<Id> setWorkspaceDocumentIds = new Set<Id>(), setParentContentDocumentIds = new Set<Id>();
                for(ContentDocumentLink objContentDocumentLink : [SELECT Id, ContentDocumentId 
                FROM ContentDocumentLink WHERE LinkedEntityId = :parentId WITH USER_MODE]){
                    setParentContentDocumentIds.add(objContentDocumentLink.ContentDocumentId);
                }
                for(ContentDocumentLink objContentDocumentLink : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :mapContentWorkspace.keySet() 
                AND ContentDocumentId NOT IN :setParentContentDocumentIds WITH USER_MODE]){
                    setWorkspaceDocumentIds.add(objContentDocumentLink.ContentDocumentId);
                }
                String contentVersionQuery = 'SELECT Id, Title, FileType, Description, Classification__c, ContentDocumentId, CreatedDate, LastModifiedDate FROM ContentVersion WHERE ContentDocumentId IN :setWorkspaceDocumentIds AND IsLatest = true ';
                if(String.isNotEmpty(searchTerm)){
                    contentVersionQuery = contentVersionQuery + ' AND (Title LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\' OR Description LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\' OR Classification__c LIKE \'%'+String.escapeSingleQuotes(searchTerm)+'%\')';
                }
                contentVersionQuery += ' WITH USER_MODE LIMIT 1000';
                lstWorkspaceFiles = Database.query(contentVersionQuery); //SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                
                //lstWorkspaceFiles = new List<ContentVersion>([SELECT Id, Title, FileType, Description, Classification__c, ContentDocumentId, CreatedDate, LastModifiedDate FROM ContentVersion WHERE ContentDocumentId IN :setWorkspaceDocumentIds AND IsLatest = true LIMIT 1000]);
                
            }

            mapWorkspaceFilesData.put('workspaceFiles', lstWorkspaceFiles);
            mapWorkspaceFilesData.put('timezone', UserInfo.getTimeZone().getID());
            return mapWorkspaceFilesData;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    /*
    * Description   :   Method to get Files Types based on provided recordId or pageBlockId as parameter for FileUploadFromComputer lightning component
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    public static List<Map<String, String>> getFileTypes(Id recordId, Id pageBlockId){
        try{
            List<Map<String, String>> lstFileTypes = new List<Map<String, String>>();
            Set<String> setFileTypes = new Set<String>();
            String strNamespacePrefix = AppUtils.getNameSpacePrefix(), strQuery, strAttachmentClassifications;
            SObject sObjectRecord;
            
            if(pageBlockId != null){
                strQuery = 'SELECT ' + String.escapeSingleQuotes(strNamespacePrefix) + 'AttachmentClassifications__c FROM ' + String.escapeSingleQuotes(strNamespacePrefix) + 'PageBlockConfig__c WHERE Id =: pageBlockId WITH USER_MODE';
                sObjectRecord = Database.query(strQuery);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                if(sObjectRecord != null && sObjectRecord.get(strNamespacePrefix + 'AttachmentClassifications__c') != null){
                    strAttachmentClassifications = String.valueOf(sObjectRecord.get(strNamespacePrefix + 'AttachmentClassifications__c'));
                    for(String strFileType : strAttachmentClassifications.split(';')){
                        if(!setFileTypes.contains(strFileType.trim())){
                            setFileTypes.add(strFileType.trim());
                            lstFileTypes.add(new Map<String, String>{'label'=> strFileType.trim(), 'value'=> strFileType.trim()});
                        }                        
                    }                    
                    return lstFileTypes;
                }
            }           
            if(recordId != null && recordId.getSObjectType().getDescribe().getName() != null && lstFileTypes.isEmpty()){
                strQuery = 'SELECT ' + String.escapeSingleQuotes(strNamespacePrefix) + 'AttachmentClassifications__c FROM ' + String.escapeSingleQuotes(strNamespacePrefix) + 'SobjectConfig__c WHERE Name = \'' + recordId.getSObjectType().getDescribe().getName() + '\''+' WITH USER_MODE';            
                sObjectRecord = Database.query(strQuery);//NOPMD SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes or fetched from Schema Method to prevent SOQL Injection
                
                if(sObjectRecord != null && sObjectRecord.get(strNamespacePrefix + 'AttachmentClassifications__c') != null){
                    strAttachmentClassifications = String.valueOf(sObjectRecord.get(strNamespacePrefix + 'AttachmentClassifications__c'));
                    for(String strFileType : strAttachmentClassifications.split(';')){
                        if(!setFileTypes.contains(strFileType.trim())){
                            setFileTypes.add(strFileType.trim());
                            lstFileTypes.add(new Map<String, String>{'label'=> strFileType.trim(), 'value'=> strFileType.trim()});
                        } 
                    }
                    return lstFileTypes;
                }
            }           
            return lstFileTypes;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    /*
    * Description   :   Update ContentVersion record with mapContentVersionData.
    *                   Update ContentDocument related ContentFolder provided as a parameter in contentFolderId.
    *                   Relate ContentDocument to LinkedEntity record provided as a parameter in parentId 
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static Boolean updateContentVersion(Map<String, String> mapContentVersionData, Id contentDocId, Id contentFolderId, Id parentId, Id workspaceId){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            // Update ContentVersion record with mapContentVersionData
            // User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
            Boolean uploadFileToPrivateLibrary = uploadFileToPrivateLibrary();
            ContentVersion objContentVersion = [SELECT Id, ContentDocumentId, ContentDocument.ParentId, SharingPrivacy 
                                                FROM ContentVersion WHERE ContentDocumentId =:contentDocId WITH USER_MODE];
            if(objContentVersion != null){
                if(!uploadFileToPrivateLibrary || mapContentVersionData.get('IsFromTreeView') == 'TRUE'){ // User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
                    if(objContentVersion.ContentDocument.ParentId == null && workspaceId != null){
                        ContentWorkspaceDoc objContentWorkspaceDoc = new ContentWorkspaceDoc(
                                ContentDocumentId = contentDocId,
                                ContentWorkspaceId = workspaceId
                        );  //CRUD /FLS false +Ve id field
                        if(Schema.sObjectType.ContentWorkspaceDoc.isCreateable()){
                        insert objContentWorkspaceDoc;
                        }
                    } else if(objContentVersion.ContentDocument.ParentId != null && workspaceId != null && objContentVersion.ContentDocument.ParentId != workspaceId){
                        ContentDocument objContentDoc = new ContentDocument(
                                Id = objContentVersion.ContentDocumentId,
                                ParentId = workspaceId
                        );
                        if(Schema.sObjectType.ContentDocument.isUpdateable() && Schema.sObjectType.ContentDocument.isAccessible()){
                            update objContentDoc;
                        }

                        for(ContentWorkspaceDoc objWorkspaceDoc : [SELECT Id, ContentDocumentId, ContentWorkspaceId 
                        FROM ContentWorkspaceDoc WHERE ContentDocumentId =: objContentVersion.ContentDocumentId 
                        AND ContentWorkspaceId =:objContentVersion.ContentDocument.ParentId WITH USER_MODE]){
                            if(Schema.sObjectType.ContentWorkspaceDoc.isDeletable()) {
                                delete objWorkspaceDoc;
                            }
                        }
                    }
                }

                ContentVersion objContentVersionToUpdate = new ContentVersion(
                    Id = objContentVersion.Id,
                    Description = mapContentVersionData.get('Description'),
                    Classification__c = mapContentVersionData.get('Classification__c')
                );
                if(mapContentVersionData.get('FileExtension__c') != null){
                    objContentVersionToUpdate.FileExtension__c = mapContentVersionData.get('FileExtension__c');
                }
                if(mapContentVersionData.containsKey('SharingPrivacy') && mapContentVersionData.get('SharingPrivacy') != null || mapContentVersionData.get('SharingPrivacy') != ''){
                    objContentVersionToUpdate.sharingOption__c  = mapContentVersionData.get('SharingPrivacy');
                }
                if(showSharingPrivacy() && mapContentVersionData.containsKey('SharingPrivacy') && mapContentVersionData.get('SharingPrivacy') != 'I'){
                    objContentVersionToUpdate.SharingPrivacy = mapContentVersionData.get('SharingPrivacy');
                }else if(showSharingPrivacy() && mapContentVersionData.containsKey('SharingPrivacy') && mapContentVersionData.get('SharingPrivacy') == 'I'){
                    objContentVersionToUpdate.SharingPrivacy = 'N';
                }
                if(mapContentVersionData.containsKey('Title') && mapContentVersionData.get('Title') != null){
                    objContentVersionToUpdate.Title = mapContentVersionData.get('Title');
                }
                if(Schema.sObjectType.ContentVersion.isUpdateable() && Schema.sObjectType.ContentVersion.isAccessible()){
                    System.debug(':: objContentVersionToUpdate :: '+objContentVersionToUpdate);
                    update objContentVersionToUpdate;
                }

                // Linked the ContentDocument to record
                if(parentId != null) {
                    ContentDocumentLink objContentDocumentLink;
                    List<ContentDocumentLink> lstContentDocumentLinks = [SELECT Id, Visibility FROM ContentDocumentLink 
                    WHERE LinkedEntityId =: parentId AND ContentDocumentId =:objContentVersion.ContentDocumentId WITH USER_MODE];
                    if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable() 
                    && Schema.sObjectType.ContentDocumentLink.fields.ShareType.isUpdateable()) {
                        if(!lstContentDocumentLinks.isEmpty()){
                            objContentDocumentLink = lstContentDocumentLinks[0];
                        } else {
                            objContentDocumentLink = new ContentDocumentLink(
                                    ContentDocumentId = objContentVersion.ContentDocumentId,
                                    LinkedEntityId = parentId,
                                    ShareType = 'V'
                            );
                        }
                    }
                    
                    // User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
                    if (Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable() 
                    && Schema.sObjectType.ContentDocumentLink.fields.Visibility.isUpdateable()) {
                        if(uploadFileToPrivateLibrary && mapContentVersionData.get('SharingPrivacy') == 'N'){
                            objContentDocumentLink.Visibility = 'AllUsers';
                        } else if(uploadFileToPrivateLibrary && mapContentVersionData.get('SharingPrivacy') == 'I'){
                            objContentDocumentLink.Visibility = 'InternalUsers';
                        }
                    }
                    
                    if(Schema.sObjectType.ContentDocumentLink.isCreateable() && Schema.sObjectType.ContentDocumentLink.isUpdateable()){
                    upsert objContentDocumentLink;
                }
            }
            }
            // Add ContentDocument to ContentFolder
            if(contentFolderId != null){
                ContentFolderMember objContentFolderMemberToUpdate;
                for(ContentFolderMember objContentFolderMember : [SELECT Id, ParentContentFolderId, ParentContentFolder.Name, ChildRecordId 
                FROM ContentFolderMember WHERE ChildRecordId =:contentDocId WITH USER_MODE]){
                    if(!objContentFolderMember.ParentContentFolder.Name.startsWith('005')){
                        objContentFolderMemberToUpdate = objContentFolderMember;
                        objContentFolderMemberToUpdate.ParentContentFolderId = contentFolderId; //CRUD/FLS false +ve id field
                    }
                }
                if(objContentFolderMemberToUpdate != null && Schema.sObjectType.ContentFolderMember.isUpdateable()){
                    update objContentFolderMemberToUpdate;
                }
            }
            
            return true;
        } catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }        
    }
    
    /*
    * Description   :   Method to get User's ContentWorkspace record 
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    public static ContentWorkspace getUserWorkspaceInfo(Id userId){
        try{
            User objLoggedInUser = [SELECT Id, OrganizationId__c FROM User WHERE Id =: userId WITH USER_MODE];
            if(objLoggedInUser.OrganizationId__c != null && Schema.SObjectType.Account.fields.WorkspaceId__c.isAccessible() ){
                Account userOrganization = [SELECT Id, WorkspaceId__c FROM Account WHERE Id =: objLoggedInUser.OrganizationId__c WITH USER_MODE ];
                if(userOrganization != null && String.isNotBlank(userOrganization.WorkspaceId__c)){
                    ContentWorkspace objContentWorkspace = [SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId 
                    FROM ContentWorkspace WHERE Id =: userOrganization.WorkspaceId__c WITH USER_MODE];
                    if(objContentWorkspace != null){
                        return objContentWorkspace;
                    } else {
                        throw new FileUploadCtrlException('Workspace library is not configured for this user. Please contact your administrator.');
                    }                    
                } else {
                    throw new FileUploadCtrlException('Workspace library is not configured for this user. Please contact your administrator.');
                }
            } else {
                throw new FileUploadCtrlException('The Organization is not configured for this user.');
            }            
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }        
    }

    private static Map<Id, Id> getWorkspaceDefaultFolders(){
        Map<Id, Id> mapWorkspaceDefaultFolder = new Map<Id, Id>();
        Map<Id, ContentWorkspace> mapContentWorkspace = new Map<Id, ContentWorkspace>([SELECT Id FROM ContentWorkspace WHERE Id !=null WITH USER_MODE]);
        for(Workspace__c objWorkspace : [SELECT Id, Name, DefaultFolderName__c, DefaultFolderId__c, WorkspaceId__c FROM Workspace__c 
        WHERE WorkspaceId__c IN :mapContentWorkspace.keySet() WITH USER_MODE]){
            mapWorkspaceDefaultFolder.put(objWorkspace.WorkspaceId__c, objWorkspace.DefaultFolderId__c);
        }
        return mapWorkspaceDefaultFolder;
    }

    @AuraEnabled
    public static Object getDefaultFolder(){
        Map<String, Object> mapHierarchy = getFolderHierarchy(null, null, null);
        if(mapHierarchy != null && mapHierarchy.containsKey('defaultFolder') != null){
            return mapHierarchy.get('defaultFolder');
        }
        return null;
    }

    @AuraEnabled
    public static List<File> getFolderDetails(Id folderId) {
        try{
            List<File> lstFiles = new List<File>();
            for(ContentFolderMember objContentFolderMember : [SELECT Id, ParentContentFolderId, ParentContentFolder.Name, ChildRecordId, ChildRecord.Title, ChildRecord.OwnerId, CreatedDate, ChildRecord.FileExtension 
            FROM ContentFolderMember WHERE ParentContentFolderId =: folderId WITH USER_MODE ORDER BY CreatedDate ASC]){
                File objFile = new File(objContentFolderMember.ChildRecordId, objContentFolderMember.ChildRecord.Title, objContentFolderMember.ChildRecord.OwnerId == UserInfo.getUserId(), objContentFolderMember.CreatedDate, objContentFolderMember.ChildRecord.FileExtension, objContentFolderMember.ParentContentFolder.Name);
                lstFiles.add(objFile);
            }
            return lstFiles;
        } catch (Exception objException) {
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    /*
    * Description   :   Method to get LoggedIn user's Workspace ContentFolder Hierarchy
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static Map<String, Object> getFolderHierarchy(Id workspaceId, List<String> workspaceIds, Map<Id, Boolean> mapFolderState) {
        try {
            Map<String, Object> returnMap = new Map<String, Object>();
            Set<Id> setWorkspaceIds = new Set<Id>();
            if(workspaceIds != null && !workspaceIds.isEmpty()){
                for(String strId : workspaceIds){
                    setWorkspaceIds.add(Id.valueOf(strId));
                }
            }
            if(workspaceId != null){
                setWorkspaceIds.add(workspaceId);
            }
            if (isWorkspaceConfigured(new List<Id>(setWorkspaceIds))) {
                List<Folder> folders = new List<Folder>();
                Map<Id, Folder> mapFolders = new Map<Id, Folder>();
                if(mapFolderState == null){
                    mapFolderState = new Map<Id, Boolean>();
                }
                Set<Id> setFolderIds = new Set<Id>();
                Set<Id> setLibraryIds = new Set<Id>(); 
                Set<Id> setMemberIds = new Set<Id>();
                User objLoggedInUser = [SELECT Id, OrganizationId__c FROM User WHERE Id = :UserInfo.getUserId() WITH USER_MODE];
                Id userWorkspaceId;
                Id parentWorkspaceId;
                Folder objDefaultFolder = null;
                Folder assetFolder = null;
                if (String.isNotBlank(objLoggedInUser.OrganizationId__c)) {
                    List<Account> objUserOrganization = [SELECT Id, Workspace__c, Workspace__r.WorkspaceId__c FROM Account WHERE Id = :objLoggedInUser.OrganizationId__c WITH USER_MODE ];
                    userWorkspaceId = !objUserOrganization.isEmpty() && objUserOrganization[0].Workspace__c != null ? objUserOrganization[0].Workspace__r.WorkspaceId__c : null;
                }

                for (GroupMember objGroupMember : [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId() WITH USER_MODE]) {
                    setMemberIds.add(objGroupMember.GroupId);
                }
                setMemberIds.add(UserInfo.getUserId());

                // User Story 68073: Internal - SF Files - Adding support to superior permission to workspace based on Workspace Member
                if (!setMemberIds.isEmpty()) {
                    Map<Id, WorkspacePermission> mapWorkspacePermissions = new Map<Id, WorkspacePermission>();
                    for (ContentWorkspaceMember objContentWorkspaceMember : [SELECT Id, MemberId, ContentWorkspaceId, ContentWorkspace.Name, ContentWorkspacePermissionId, ContentWorkspacePermission.Name, ContentWorkspacePermission.Type, ContentWorkspacePermission.PermissionsManageWorkspace, ContentWorkspacePermission.PermissionsAddContent, ContentWorkspacePermission.PermissionsDeleteContent, ContentWorkspacePermission.PermissionsOrganizeFileAndFolder 
                                                                            FROM ContentWorkspaceMember WHERE MemberId IN :setMemberIds WITH USER_MODE]) {
                        ContentWorkspacePermission objContentWorkspacePermission = objContentWorkspaceMember.ContentWorkspacePermission;
                        if (mapWorkspacePermissions.containsKey(objContentWorkspaceMember.ContentWorkspaceId)) {
                            WorkspacePermission oldWorkspacePermission = mapWorkspacePermissions.get(objContentWorkspaceMember.ContentWorkspaceId);
                            String newPermissionName = objContentWorkspacePermission.Name, oldPermissionName = oldWorkspacePermission.Name;
                            if (oldPermissionName.containsIgnoreCase('viewer') && (newPermissionName.containsIgnoreCase('author') || newPermissionName.containsIgnoreCase('admin'))) {
                                WorkspacePermission objWorkspacePermission = new WorkspacePermission(objContentWorkspacePermission.Name, objContentWorkspacePermission.Type, objContentWorkspacePermission.PermissionsAddContent, objContentWorkspacePermission.PermissionsDeleteContent, objContentWorkspacePermission.PermissionsManageWorkspace, objContentWorkspacePermission.PermissionsOrganizeFileAndFolder);
                                mapWorkspacePermissions.put(objContentWorkspaceMember.ContentWorkspaceId, objWorkspacePermission);
                            } else if (oldPermissionName.containsIgnoreCase('author') && newPermissionName.containsIgnoreCase('admin')) {
                                WorkspacePermission objWorkspacePermission = new WorkspacePermission(objContentWorkspacePermission.Name, objContentWorkspacePermission.Type, objContentWorkspacePermission.PermissionsAddContent, objContentWorkspacePermission.PermissionsDeleteContent, objContentWorkspacePermission.PermissionsManageWorkspace, objContentWorkspacePermission.PermissionsOrganizeFileAndFolder);
                                mapWorkspacePermissions.put(objContentWorkspaceMember.ContentWorkspaceId, objWorkspacePermission);
                            }
                        } else {
                            WorkspacePermission objWorkspacePermission = new WorkspacePermission(objContentWorkspacePermission.Name, objContentWorkspacePermission.Type, objContentWorkspacePermission.PermissionsAddContent, objContentWorkspacePermission.PermissionsDeleteContent, objContentWorkspacePermission.PermissionsManageWorkspace, objContentWorkspacePermission.PermissionsOrganizeFileAndFolder);
                            mapWorkspacePermissions.put(objContentWorkspaceMember.ContentWorkspaceId, objWorkspacePermission);
                        }
                    }
                    Map<Id, Id> mapWorkspaceDefaultFolders = getWorkspaceDefaultFolders();
                    if (!setWorkspaceIds.isEmpty()) {
                        for(ContentWorkspace objContentWorkspace : [SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId, CreatedDate 
                        FROM ContentWorkspace WHERE Id = :setWorkspaceIds WITH USER_MODE]){
                            Boolean isExpanded = mapFolderState.containsKey(objContentWorkspace.RootContentFolderId) ? mapFolderState.get(objContentWorkspace.RootContentFolderId) : false;
                            Folder objFolder = new Folder(objContentWorkspace.RootContentFolderId, objContentWorkspace.Name, objContentWorkspace.Name, true, objContentWorkspace.Id, false, null, objContentWorkspace.CreatedDate, mapWorkspacePermissions.get(objContentWorkspace.Id), isExpanded);
                            objFolder.IsDefault = mapWorkspaceDefaultFolders.get(objFolder.WorkspaceId) != null && mapWorkspaceDefaultFolders.get(objFolder.WorkspaceId) == objFolder.Id;
                            mapFolders.put(objContentWorkspace.RootContentFolderId, objFolder);
                            setFolderIds.add(objContentWorkspace.RootContentFolderId);
                            folders.add(objFolder);
                            mapFolderState.put(objFolder.Id, isExpanded);
                            setLibraryIds.add(objContentWorkspace.Id);
                        }
                    } else {
                        for (ContentWorkspace objContentWorkspace : [SELECT Id, Name, Description, DeveloperName, WorkspaceType, RootContentFolderId, CreatedDate 
                        FROM ContentWorkspace WHERE Id !=null WITH USER_MODE ]) {
                            Boolean isExpanded = mapFolderState.containsKey(objContentWorkspace.RootContentFolderId) ? mapFolderState.get(objContentWorkspace.RootContentFolderId) : false;
                            Folder objFolder = new Folder(objContentWorkspace.RootContentFolderId, objContentWorkspace.Name, objContentWorkspace.Name, true, objContentWorkspace.Id, false, null, objContentWorkspace.CreatedDate, mapWorkspacePermissions.get(objContentWorkspace.Id), isExpanded);
                            mapFolders.put(objContentWorkspace.RootContentFolderId, objFolder);
                            setFolderIds.add(objContentWorkspace.RootContentFolderId);
                            folders.add(objFolder);
                            mapFolderState.put(objFolder.Id, isExpanded);
                            setLibraryIds.add(objContentWorkspace.Id);
                        }
                    }

                    if(!setLibraryIds.isEmpty()){
                        for(Folder objFolder : folders){
                            objFolder.IsDefault = mapWorkspaceDefaultFolders.get(objFolder.WorkspaceId) != null && mapWorkspaceDefaultFolders.get(objFolder.WorkspaceId) == objFolder.Id;
                            if (objFolder.IsDefault && userWorkspaceId == objFolder.WorkspaceId) {
                                objDefaultFolder = objFolder;
                            }
                            if(objFolder.Name.equalsIgnoreCase('Asset Library')){
                                assetFolder = objFolder;
                                assetFolder.IsAsset = true;
                            }
                        }
                        Boolean breakout = false;
                        Integer counter = 1;
                        do {
                            if (setFolderIds != null) {
                                List<ContentFolder> lstFolders = [SELECT Id, Name, ParentContentFolderId, CreatedById, CreatedDate 
                                FROM ContentFolder WHERE ParentContentFolderId IN :setFolderIds WITH USER_MODE ORDER BY CreatedDate ASC ];
                                setFolderIds = new Set<Id>();
                                if (lstFolders.size() > 0) {
                                    for (ContentFolder objContentFolder : lstFolders) {
                                        setFolderIds.add(objContentFolder.Id);
                                        Folder parentFolder = mapFolders.get(objContentFolder.ParentContentFolderId);
                                        if (parentFolder != null) {
                                            parentWorkspaceId = parentFolder.WorkspaceId;
                                        }
                                        Folder objFolder = new Folder(objContentFolder.Id, objContentFolder.Name, objContentFolder.Name, false, parentWorkspaceId, objContentFolder.CreatedById == UserInfo.getUserId(), objContentFolder.ParentContentFolderId, objContentFolder.CreatedDate, null, false);

                                        objFolder.IsDefault = mapWorkspaceDefaultFolders.get(objFolder.WorkspaceId) != null && mapWorkspaceDefaultFolders.get(objFolder.WorkspaceId) == objFolder.Id;
                                        if (objFolder.IsDefault && userWorkspaceId == objFolder.WorkspaceId) {
                                            objDefaultFolder = objFolder;
                                        }
                                        if(mapFolderState.containsKey(objContentFolder.Id) && mapFolderState.get(objContentFolder.Id)){
                                            objFolder.IsExpanded = true;
                                        } else {
                                            mapFolderState.put(objFolder.Id, false);
                                        }
                                        parentFolder.Folders.add(objFolder);
                                        mapFolders.put(objContentFolder.Id, objFolder);
                                    }
                                } else {
                                    breakout = true;
                                }

                                counter++;
                                if (counter > 50) {
                                    breakout = true;
                                }
                            }
                        } while (!breakout);
                    }
                }
                returnMap.put('folders', folders);
                returnMap.put('mapFolderState', mapFolderState);
                returnMap.put('isWorkspaceConfigured', true);
                if (objDefaultFolder != null) {
                    returnMap.put('defaultFolder', objDefaultFolder);
                } else if(assetFolder != null){
                    returnMap.put('defaultFolder', assetFolder);
                }
                returnMap.put('isExternalUser', isExternalUser());
            } else {
                returnMap.put('isWorkspaceConfigured', false);
            }
            return returnMap;
        } catch (Exception objException) {
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    public class Folder{
        @AuraEnabled
        public Id Id {get; set;}
        @AuraEnabled
        public Boolean Loaded {get; set;}
        @AuraEnabled
        public String Label {get; set;}
        @AuraEnabled
        public String Name {get; set;}
        @AuraEnabled
        public Boolean IsLibrary {get; set;}
        @AuraEnabled
        public Set<Folder> Folders {get; set;}
        @AuraEnabled
        public Set<File> Files{get; set;}
        @AuraEnabled
        public Boolean IsSearched {get; set;}
        @AuraEnabled
        public Boolean IsOwner {get; set;}
        @AuraEnabled
        public Id WorkspaceId {get; set;}
        @AuraEnabled
        public Id ParentContentFolderId {get; set;}
        @AuraEnabled
        public Datetime CreatedDate {get; set;}
        @AuraEnabled
        public WorkspacePermission Permission {get; set;}
        @AuraEnabled
        public Boolean IsExpanded {get; set;}
        @AuraEnabled
        public Boolean IsDefault {get; set;}
        @AuraEnabled
        public Boolean IsAsset {get; set;}

        public Folder() {}
        
        public Folder(Id id, String label, String name, Boolean isLibrary, Id workspaceId, Boolean isOwner, Id parentContentFolderId, Datetime createdDate, WorkspacePermission permission, Boolean isExpanded){
            this.Id = id;
            this.Label = label;
            this.Name = name;
            this.IsLibrary = isLibrary;
            this.Files = new Set<File>();
            this.Folders = new Set<Folder>();
            this.IsSearched = false;
            this.IsOwner = isOwner;
            this.WorkspaceId = workspaceId;
            this.ParentContentFolderId = parentContentFolderId;
            this.CreatedDate = createdDate;
            this.Permission = permission;
            this.IsExpanded = isExpanded;
            this.IsDefault = false;
            this.IsAsset = false;
            this.Loaded = false;
        }
    }
    
    public class File {
        @AuraEnabled
        public Id Id{get; set;}
        @AuraEnabled
        public String Name {get; set;}
        @AuraEnabled
        public Boolean IsSearched {get; set;}
        @AuraEnabled
        public Boolean IsOwner {get; set;}        
        @AuraEnabled
        public Datetime CreatedDate {get; set;}
        @AuraEnabled
        public String FileType {get; set;}
        @AuraEnabled
        public String ParentContentFolderName {get; set;}
        
        public File(Id id, String name, Boolean isOwner, Datetime createdDate, String fileType, String parentContentFolderName){
            this.Id = id;
            this.Name = name;
            this.IsSearched = false;
            this.IsOwner = isOwner;            
            this.CreatedDate = createdDate;
            this.FileType = FileUploadCtrl.getFileIcon(fileType);
            this.ParentContentFolderName = parentContentFolderName;
        }
    }
    
    public class WorkspacePermission {
        @AuraEnabled
        public String Name{get; set;}
        @AuraEnabled
        public String Type{get; set;}
        @AuraEnabled
        public Boolean PermissionsAddContent{get; set;}
        @AuraEnabled
        public Boolean PermissionsDeleteContent{get; set;}
        @AuraEnabled
        public Boolean PermissionsManageWorkspace{get; set;}
        @AuraEnabled
        public Boolean PermissionsOrganizeFileAndFolder{get; set;}
        
        public WorkspacePermission(String Name, String Type, Boolean PermissionsAddContent, Boolean PermissionsDeleteContent, Boolean PermissionsManageWorkspace, Boolean PermissionsOrganizeFileAndFolder){
            this.Name = Name;
            this.Type = Type;
            this.PermissionsAddContent = PermissionsAddContent;
            this.PermissionsDeleteContent = PermissionsDeleteContent;
            this.PermissionsManageWorkspace = PermissionsManageWorkspace;
            this.PermissionsOrganizeFileAndFolder = PermissionsOrganizeFileAndFolder;
        }
    }
    
    public static String getFileIcon(String fileType){            
        if(iconMap == null){
            iconMap = new Map<String,String>();
            //audio file extensions
            iconMap.put('aif', 'audio');
            iconMap.put('cda', 'audio');
            iconMap.put('mid', 'audio');
            iconMap.put('mp3', 'audio');
            iconMap.put('mpa', 'audio');
            iconMap.put('ogg', 'audio');
            iconMap.put('wav', 'audio');
            iconMap.put('wma', 'audio');
            iconMap.put('wpl', 'audio');
            
            //Compressed file extensions
            iconMap.put('7z', 'zip');
            iconMap.put('arj', 'zip');
            iconMap.put('deb', 'zip');
            iconMap.put('pkg', 'zip');
            iconMap.put('rar', 'zip');
            iconMap.put('rpm', 'zip');
            iconMap.put('tar.gz', 'zip');
            iconMap.put('z', 'zip');
            iconMap.put('zip', 'zip');
            
            //Disc and media file extensions
            iconMap.put('bin', 'unknown');
            iconMap.put('dmg', 'unknown');
            iconMap.put('iso', 'unknown');
            iconMap.put('toast', 'unknown');
            iconMap.put('vcd', 'unknown');
            
            //Data and database file extensions
            iconMap.put('csv', 'csv');
            iconMap.put('dat', 'overlay');
            iconMap.put('db', 'overlay');
            iconMap.put('dbf', 'overlay');
            iconMap.put('log', 'gdoc');
            iconMap.put('mdb', 'gdoc');
            iconMap.put('sql', 'gdoc');
            iconMap.put('xml', 'xml');
            
            //Executable file extensions
            iconMap.put('apk', 'exe');
            iconMap.put('bat', 'exe');
            iconMap.put('bin', 'exe');
            iconMap.put('cgi', 'exe');
            iconMap.put('pl', 'exe');
            iconMap.put('com', 'exe');
            iconMap.put('exe', 'exe');
            iconMap.put('gadget', 'exe');
            iconMap.put('jar', 'exe');
            iconMap.put('py', 'exe');
            iconMap.put('wsf', 'exe');
            
            //Image file formats by file extension
            iconMap.put('ai', 'ai');
            iconMap.put('bmp', 'image');
            iconMap.put('gif', 'image');
            iconMap.put('ico', 'image');
            iconMap.put('jpeg', 'image');
            iconMap.put('jpg', 'image');
            iconMap.put('png', 'image');
            iconMap.put('ps', 'image');
            iconMap.put('psd', 'image');
            iconMap.put('svg', 'image');
            iconMap.put('tif', 'image');
            iconMap.put('tiff', 'image');
            
            //Presentation file formats by file extension
            iconMap.put('key', 'ppt');
            iconMap.put('odp', 'ppt');
            iconMap.put('pps', 'ppt');
            iconMap.put('ppt', 'ppt');
            iconMap.put('pptx', 'ppt');
            
            //Spreadsheet file formats by file extension
            iconMap.put('ods', 'excel');
            iconMap.put('xlr', 'excel');
            iconMap.put('xls', 'excel');
            iconMap.put('xlsx', 'excel');
            
            //Video file formats by file extension
            iconMap.put('3g2', 'video');
            iconMap.put('3gp', 'video');
            iconMap.put('avi', 'video');
            iconMap.put('flv', 'video');
            iconMap.put('h264', 'video');
            iconMap.put('m4v', 'video');
            iconMap.put('mkv', 'video');
            iconMap.put('mov', 'video');
            iconMap.put('mpg', 'video');
            iconMap.put('mpeg', 'video');
            iconMap.put('rm', 'video');
            iconMap.put('swf', 'video');
            iconMap.put('vob', 'video');
            iconMap.put('wmv', 'video');
            iconMap.put('mp4', 'mp4');
            
            //Word processor and text file formats by file extension
            iconMap.put('doc', 'gdocs');
            iconMap.put('docx', 'gdocs');
            iconMap.put('odt', 'gdocs');
            iconMap.put('pdf', 'pdf');
            iconMap.put('rtf', 'rtf');
            iconMap.put('txt', 'txt');
            iconMap.put('wks', 'word');
            iconMap.put('wpd', 'word');
            iconMap.put('wps', 'word');
            
            //Internet related file extensions
            iconMap.put('htm', 'html');
            iconMap.put('html', 'html');
            iconMap.put('xhtml', 'html');
            iconMap.put('php', 'html');
            
            //Other
            iconMap.put('other', 'unknown');
        }
        
        return iconMap.containsKey(fileType) ? 'doctype:' + iconMap.get(fileType) : 'doctype:unknown';
    }
    
    /*
    * Description   :   Method to changed 
    *                   1. ParentContentFolder of ContentFolder provided as a parameter in contentFolderId
    *                   2. ParentContentFolder of ContentDocument provided as a parameter in contentDocId
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static Object changeParentContentFolder(Id contentFolderId, Id contentDocId, Id parentContentFolderId, Id destWorkspaceId){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            if(contentFolderId != null && Schema.SObjectType.ContentFolder.fields.ParentContentFolderId.isAccessible()){
                ContentFolder objContentFolder = [SELECT Id, parentContentFolderId FROM ContentFolder 
                WHERE Id =: contentFolderId WITH USER_MODE];
                objContentFolder.ParentContentFolderId = parentContentFolderId;
                if(Schema.sObjectType.ContentFolder.isUpdateable()){
                    Database.SaveResult objSaveResult = Database.update(objContentFolder);
                    return JSON.serialize(objSaveResult);
                }
            } else if(contentDocId != null && destWorkspaceId != null){
                // User Story 77392: Internal - Salesforce Files – Default library for catch-all
                // Move ContentDOcument from one Workspace(Library) to another
                ContentDocument objContentDoc = [SELECT Id, ParentId FROM ContentDocument WHERE Id =:contentDocId WITH USER_MODE];
                objContentDoc.ParentId = destWorkspaceId;
                if(Schema.SObjectType.ContentDocument.isUpdateable()){
                    update objContentDoc;
                }
                
                ContentFolderMember objContentFolderMemberToUpdate;
                for(ContentFolderMember objContentFolderMember : [SELECT Id, ParentContentFolderId, ParentContentFolder.Name 
                FROM ContentFolderMember WHERE ChildRecordId =: contentDocId WITH USER_MODE]){
                    if(!objContentFolderMember.ParentContentFolder.Name.startsWith('005')){
                        objContentFolderMemberToUpdate = objContentFolderMember;
                    }
                }
                objContentFolderMemberToUpdate.ParentContentFolderId = parentContentFolderId;
                Database.SaveResult objSaveResult;
                if(Schema.sObjectType.ContentFolderMember.isUpdateable()){
                    objSaveResult = Database.update(objContentFolderMemberToUpdate);
                }
                return JSON.serialize(objSaveResult);
            }
            return null;
        }catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    /*
    * Description   :   Method to attach ContentDocument
    *                   1. ParentContentFolder of ContentFolder provided as a parameter in contentFolderId
    *                   2. ParentContentFolder of ContentDocument provided as a parameter in contentDocId
    * Created By    :   Dipak Pawar on 30 July 2019
    */
    @AuraEnabled
    public static Object attachFilesToRecord(List<Id> lstContentVersionIds, Id parentId){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            List<ContentDocumentLink> lstContentDocumentLinks = new List<ContentDocumentLink>();
            for(ContentVersion objContentVersion : [SELECT Id, ContentDocumentId FROM ContentVersion 
            WHERE Id IN :lstContentVersionIds WITH USER_MODE]){
                lstContentDocumentLinks.add(
                    new ContentDocumentLink(
                        ContentDocumentId = objContentVersion.ContentDocumentId,
                        LinkedEntityId = parentId,
                        ShareType = 'V'
                    )
                );
            }
            List<Database.SaveResult> lstSaveResult = new List<Database.SaveResult>();
            if(Schema.SObjectType.ContentDocumentLink.isCreateable())
            lstSaveResult = Database.insert(lstContentDocumentLinks);
            return JSON.serialize(lstSaveResult);            
        } catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    @future 
    public static void updateWorkspaceIdOnAccount(Id accountId, Id workspaceId){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            Account objAccount = new Account(
                Id = accountId,
                WorkspaceId__c = workspaceId
            );
            if(Schema.SObjectType.Account.isUpdateable())
            Database.SaveResult sr = Database.update(objAccount);            
        } catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    global static ContentWorkspace createUserWorkspace(Id userId, Id organizationId){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            ContentWorkspace objContentWorkspace;
            User objUser = [SELECT Id, OrganizationId__c FROM User WHERE Id =: userId WITH USER_MODE];
            if(objUser != null){
                Account objOrgAccount;
                if(organizationId != null){                    
                    objOrgAccount = [SELECT Id, Name, ParentId, Parent.ParentId, WorkspaceId__c FROM Account 
                    WHERE Id =:organizationId WITH USER_MODE ];
                    if(objOrgAccount == null){ // If Organization Id not present on User and "organizationId" is not provided.
                        throw new FileUploadCtrlException('Organization is not exist with provided organizationId');
                    }
                } else if(String.isNotBlank(objUser.OrganizationId__c)){
                    objOrgAccount = [SELECT Id, Name, ParentId, Parent.ParentId, WorkspaceId__c 
                    FROM Account WHERE Id =:objUser.OrganizationId__c WITH USER_MODE ];
                }
                if(objOrgAccount != null){                    
                    
                    if(objOrgAccount != null && String.isBlank(objOrgAccount.WorkspaceId__c)){
                        if(Schema.sObjectType.ContentWorkspace.fields.Name.isCreateable()){
                        objContentWorkspace = new ContentWorkspace(
                            Name = objOrgAccount.Name
                        );
                        }
                        if(Schema.sObjectType.ContentWorkspace.isCreateable()){
                            insert objContentWorkspace;
                        }
                        
                        updateWorkspaceIdOnAccount(objOrgAccount.Id, objContentWorkspace.Id);                        
                    } else {                        
                        objContentWorkspace = [SELECT Id, Name FROM ContentWorkspace WHERE Id =:objOrgAccount.WorkspaceId__c WITH USER_MODE];
                    }
                    
                    ContentWorkspacePermission objContentWorkspacePermission = [SELECT Id FROM ContentWorkspacePermission WHERE Type = 'Admin' WITH USER_MODE];
                    
                    //Create or Update group and its members for current Account Workspace
                    Id gourpId = addMembersToWorkspace(objOrgAccount, userId, objContentWorkspace.Name);
                    
                    List<ContentWorkspaceMember> lstContentWorkspaceMember = new List<ContentWorkspaceMember>([SELECT Id FROM ContentWorkspaceMember 
                    WHERE MemberId =:gourpId WITH USER_MODE]);
                    if(lstContentWorkspaceMember.isEmpty() 
                    && Schema.sObjectType.ContentWorkspaceMember.isCreateable() && ContentWorkspaceMember.sObjectType.getDescribe().isAccessible() == true){
                        insert new ContentWorkspaceMember(
                            ContentWorkspacePermissionId = objContentWorkspacePermission.Id,
                            ContentWorkspaceId = objContentWorkspace.Id,
                            MemberId = gourpId
                        );
                    }
                    return objContentWorkspace;
                } else { // Organization not present with "User OrganizationId" or provided "organizationId"
                    throw new FileUploadCtrlException('Invalid Organization Id on user');
                }
            } else { // If User not found with provided "userId"            
                throw new FileUploadCtrlException('User not exist with provided userId');
            }
        } catch(Exception objException){
            Database.rollback(objSavepoint); 
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    private static Id addMembersToWorkspace(Account objOrgAccount, Id userId, String strWorkspaceName){
        Set<Id> setParentOrgIds = new Set<Id>();        
        if(objOrgAccount.ParentId != null){
            setParentOrgIds.add(objOrgAccount.ParentId);
            if(objOrgAccount.Parent.ParentId != null){
                setParentOrgIds.add(objOrgAccount.Parent.ParentId);
            }
        }
        Group objMemberGroup;
        Set<Id> setGroupMemberIds = new Set<Id>();
        strWorkspaceName = strWorkspaceName.substring(0, strWorkspaceName.length() > 40 ? 40 : strWorkspaceName.length());
        for(Group objGroup : [SELECT Name, Id, Type, Email, (SELECT Id, GroupId, UserOrGroupId FROM GroupMembers) 
        FROM Group WHERE Name =: strWorkspaceName AND Type = 'Regular' WITH USER_MODE]){
            objMemberGroup = objGroup;
            for(GroupMember objGroupMember : objGroup.GroupMembers){
                setGroupMemberIds.add(objGroupMember.UserOrGroupId);
            }
        }
        if(objMemberGroup == null && Schema.SObjectType.Group.isCreateable() && Schema.sObjectType.Group.fields.Name.isCreateable()
        && Schema.sObjectType.Group.fields.Type.isCreateable()){
            objMemberGroup = new Group(
                Name = strWorkspaceName,
                Type = 'Regular'
            );
            if(Schema.sObjectType.Group.isCreateable() && Group.sObjectType.getDescribe().isAccessible() == true){
            insert objMemberGroup;
        }
        }
        
        List<GroupMember> lstNewGroupMembers = new List<GroupMember>();
        for(User objOrgUser : [SELECT Id FROM User 
                                WHERE IsActive = TRUE AND Id NOT IN :setGroupMemberIds 
                                AND OrganizationId__c IN :setParentOrgIds WITH USER_MODE]){
            lstNewGroupMembers.add(new GroupMember(
                GroupId = objMemberGroup.Id,
                UserOrGroupId = objOrgUser.Id
            ));
        }
        lstNewGroupMembers.add(new GroupMember(
            GroupId = objMemberGroup.Id,
            UserOrGroupId = userId
        ));
        if(!lstNewGroupMembers.isEmpty() && Schema.sObjectType.GroupMember.isCreateable() && GroupMember.sObjectType.getDescribe().isAccessible() == true){
            insert lstNewGroupMembers;
        }
        return objMemberGroup.Id;
    }

    /*
    * Description   :   Method to create or manage Workspaces(Libraries) with List<UserWorkspacePermission> as params.
    *                   UserWorkspacePermission contains UserId, OrganizationId and WorkspacePermission for each and every User provided in the List.
    * Created By    :   Dipak Pawar on 27 December 2019
    */ 
    global static void createUserWorkspace(List<UserWorkspacePermission> lstUserWorkspacePermissions){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            // Creating the map of UserId and provided UserWorkspacePermission.
            Map<Id, UserWorkspacePermission> mapUserWorkspacePermissions = new Map<Id, UserWorkspacePermission>();
            Set<String> setWorkspacePermissionNames = new Set<String>{'govgrants admin', 'govgrants author', 'govgrants viewer'};
            for(UserWorkspacePermission objUserWorkspacePermission : lstUserWorkspacePermissions){
                mapUserWorkspacePermissions.put(objUserWorkspacePermission.UserId, objUserWorkspacePermission);
                if(String.isNotBlank(objUserWorkspacePermission.WorkspacePermission)){
                    setWorkspacePermissionNames.add(objUserWorkspacePermission.WorkspacePermission.toLowerCase());
                }
            }

            Map<String, Id> mapWorkspacePermission = new Map<String, Id>();
            
            if(!setWorkspacePermissionNames.isEmpty()){
                for(ContentWorkspacePermission objContentWorkspacePermission : [SELECT Id, Name, Type FROM ContentWorkspacePermission 
                                                                                WHERE Name !=null WITH USER_MODE]){
                    mapWorkspacePermission.put(objContentWorkspacePermission.Name.toLowerCase(), objContentWorkspacePermission.Id);
                }
            }
            if(!mapUserWorkspacePermissions.isEmpty()){  
                // Getting Users from system for OrganizationId__c.
                Map<Id, User> mapUsers = new Map<Id, User>();
                Map<Id, Id> mapUserOrgIds = new Map<Id, Id>();
                Map<Id, Set<Id>> tmpAccountUserMap = new Map<Id, Set<Id>>();
                Map<Id, Account> mapAccounts = new Map<Id, Account>(), mapTmpAccounts = new Map<Id, Account>([SELECT Id, Name, ParentId, Parent.ParentId, Parent.Parent.ParentId, Parent.Parent.Parent.ParentId, Parent.Parent.Parent.Parent.ParentId, Parent.Parent.Parent.Parent.Parent.ParentId, WorkspaceId__c, Workspace__c 
                                                                                                            FROM Account WITH USER_MODE]);
                for(Id accountId : mapTmpAccounts.keySet()){
                    tmpAccountUserMap.put(accountId, new Set<Id>());
                }
                Id orgId;
                for(User objUser : [SELECT Id, OrganizationId__c FROM User WHERE IsActive = TRUE WITH USER_MODE]){
                    if(mapUserWorkspacePermissions.containsKey(objUser.Id)){
                        mapUsers.put(objUser.Id, objUser);  
                        UserWorkspacePermission objUserWorkspacePermission = mapUserWorkspacePermissions.get(objUser.Id);   
                        if(objUserWorkspacePermission != null && objUserWorkspacePermission.OrganizationId != null){                            
                            mapUserOrgIds.put(objUser.Id, objUserWorkspacePermission.OrganizationId);
                            orgId = objUserWorkspacePermission.OrganizationId;
                        } else if(String.isNotBlank(objUser.OrganizationId__c)){    
                            mapUserOrgIds.put(objUser.Id, objUser.OrganizationId__c);
                            orgId = objUser.OrganizationId__c;                            
                        }   
                    }
                    if(orgId != null){  
                        mapAccounts.put(orgId, mapTmpAccounts.get(orgId));
                    }
                    if(String.isNotBlank(objUser.OrganizationId__c) && tmpAccountUserMap.containsKey(objUser.OrganizationId__c)){
                        Set<Id> setIds = tmpAccountUserMap.get(objUser.OrganizationId__c);  
                        setIds.add(objUser.Id); 
                        tmpAccountUserMap.put(objUser.OrganizationId__c, setIds);
                    }
                }        

                Set<String> setAccountNames = new Set<String>(), setAccountAbbreviatedNames = new Set<String>();
                Map<Id, Id> mapAccountRelatedContentWorkspace = new Map<Id, Id>(), mapContentWorkspaceRelatedAccount = new Map<Id, Id>();
                Map<String, Id> mapAccountAbbreviatedNameRelatedIds = new Map<String, Id>();
                Map<Id, Set<Id>> mapAccountParentIds = new Map<Id, Set<Id>>();
                Map<String, Id> mapAccountNameIds = new Map<String, Id>();
                for(Id accountId : mapAccounts.keySet()){
                    Account objAccount = mapAccounts.get(accountId);
                    if(objAccount != null){
                        setAccountNames.add(objAccount.Name);
                        mapAccountNameIds.put(objAccount.Name.deleteWhitespace().toLowerCase(), objAccount.Id);                   

                        setAccountAbbreviatedNames.add(getAbbreviatedString(objAccount.Name));
                        mapAccountAbbreviatedNameRelatedIds.put(getAbbreviatedString(objAccount.Name), objAccount.Id);

                        if(String.isNotBlank(objAccount.WorkspaceId__c)){
                        mapAccountRelatedContentWorkspace.put(objAccount.Id, objAccount.WorkspaceId__c);
                        mapContentWorkspaceRelatedAccount.put(objAccount.WorkspaceId__c, objAccount.Id);
                        }
                        Set<Id> setParentAccountIds = tmpAccountUserMap.containsKey(objAccount.Id) ? tmpAccountUserMap.get(objAccount.Id) : new Set<Id>();
                        if(objAccount.ParentId != null){
                            setParentAccountIds.addAll(tmpAccountUserMap.get(objAccount.ParentId));
                            if(objAccount.Parent.ParentId != null){
                                setParentAccountIds.addAll(tmpAccountUserMap.get(objAccount.Parent.ParentId));
                                if(objAccount.Parent.Parent.ParentId != null){
                                    setParentAccountIds.addAll(tmpAccountUserMap.get(objAccount.Parent.Parent.ParentId));
                                    if(objAccount.Parent.Parent.Parent.ParentId != null){
                                        setParentAccountIds.addAll(tmpAccountUserMap.get(objAccount.Parent.Parent.Parent.ParentId));
                                        if(objAccount.Parent.Parent.Parent.Parent.ParentId != null){
                                            setParentAccountIds.addAll(tmpAccountUserMap.get(objAccount.Parent.Parent.Parent.Parent.ParentId));
                                            if(objAccount.Parent.Parent.Parent.Parent.Parent.ParentId != null){
                                                setParentAccountIds.addAll(tmpAccountUserMap.get(objAccount.Parent.Parent.Parent.Parent.Parent.ParentId));
                                            }
                                        }
                                    }
                                }
                            }                        
                        }
                        mapAccountParentIds.put(objAccount.Id, setParentAccountIds);
                    }
                }
                
                if(!setAccountNames.isEmpty()){   
                    Map<Id, ContentWorkspace> mapContentWorkspace = new Map<Id, ContentWorkspace>();
                    Map<Id, Set<Id>> mapWorkspaceMembers = new Map<Id, Set<Id>>();
                    Set<Id> setWorkspaceMembers;
                    for(ContentWorkspace objContentWorkspace : [SELECT Id, Name, (SELECT Id, MemberId, ContentWorkspacePermissionId FROM ContentWorkspaceMembers) 
                                                                FROM ContentWorkspace 
                                                                WHERE Name IN :setAccountNames OR Id IN :mapAccountRelatedContentWorkspace.values() WITH USER_MODE]){
                        mapContentWorkspace.put(objContentWorkspace.Id, objContentWorkspace);                        
                        // Mapping all the Workspace members for managing the members for existing or newly created Workspaces. 
                        setWorkspaceMembers = new Set<Id>();
                        for(ContentWorkspaceMember objWorkspaceMember : objContentWorkspace.ContentWorkspaceMembers){
                            setWorkspaceMembers.add(objWorkspaceMember.MemberId);                            
                        }
                        mapWorkspaceMembers.put(objContentWorkspace.Id, setWorkspaceMembers);
                        Id workspaceAccountId = mapAccountNameIds.containsKey(objContentWorkspace.Name.deleteWhitespace().toLowerCase()) ? mapAccountNameIds.get(objContentWorkspace.Name.deleteWhitespace().toLowerCase()) : null;
                        if(workspaceAccountId != null && mapAccountRelatedContentWorkspace.get(workspaceAccountId) != objContentWorkspace.Id){
                            mapAccountRelatedContentWorkspace.put(workspaceAccountId, objContentWorkspace.Id);
                        }
                    }
                    setWorkspaceMembers = null;

                    Map<Integer, Id> tmpMap = new Map<Integer, Id>();
                    Integer tmpIndex = 0;
                    
                    // New Workspaces(Libraries) are created if not exists in the Systems with the provided Account names.
                    List<ContentWorkspace> lstWorkspaceToCreated = new List<ContentWorkspace>();
                    for(Id accountId : mapAccounts.keySet()){
                        String accountName = mapAccounts.get(accountId).Name;
                        if(!mapAccountRelatedContentWorkspace.containsKey(accountId) 
                        && Schema.sObjectType.ContentWorkspace.fields.Name.isCreateable()){
                            ContentWorkspace objContentWorkspace = new ContentWorkspace(
                                Name = accountName
                            );
                            lstWorkspaceToCreated.add(objContentWorkspace);
                            
                            mapAccountRelatedContentWorkspace.put(accountId, objContentWorkspace.Id);
                            tmpMap.put(tmpIndex++, accountId);                            
                        }
                    }

                    if(!lstWorkspaceToCreated.isEmpty() && Schema.sObjectType.ContentWorkspace.isCreateable() && ContentWorkspace.sObjectType.getDescribe().isAccessible() == true){
                        insert lstWorkspaceToCreated;

                        Set<Id> setWorkspaceIds = new Set<Id>();
                        for(ContentWorkspace objContentWorkspace : lstWorkspaceToCreated){
                            setWorkspaceIds.add(objContentWorkspace.Id);
                        }                        
                        mapContentWorkspace.putAll(lstWorkspaceToCreated);
                        List<ContentWorkspaceMember> lstContentWorkspaceMemberToUpdate = new List<ContentWorkspaceMember>();
                        for(ContentWorkspaceMember objContentWorkspaceMember : [SELECT Id, MemberId, ContentWorkspacePermissionId 
                        FROM ContentWorkspaceMember 
                        WHERE MemberId =: UserInfo.getUserId() AND ContentWorkspaceId IN : lstWorkspaceToCreated WITH USER_MODE]){
                            lstContentWorkspaceMemberToUpdate.add(new ContentWorkspaceMember(Id = objContentWorkspaceMember.Id, ContentWorkspacePermissionId = mapWorkspacePermission.get('govgrants admin')));
                        }
                        if(Schema.sObjectType.ContentWorkspaceMember.isUpdateable()){
                            update lstContentWorkspaceMemberToUpdate;
                        }

                        tmpIndex = 0;
                        for(ContentWorkspace objContentWorkspace : lstWorkspaceToCreated){
                            mapContentWorkspaceRelatedAccount.put(objContentWorkspace.Id, tmpMap.get(tmpIndex));
                            mapAccountRelatedContentWorkspace.put(tmpMap.get(tmpIndex), objContentWorkspace.Id);
                            mapWorkspaceMembers.put(objContentWorkspace.Id, new Set<Id>());
                            tmpIndex++;
                        }
                    }

                    // Fetching Public Groups based on Account/Workspace names to Manage Workspace members
                    Map<Id, Set<Id>> mapGroupMembers = new Map<Id, Set<Id>>();
                    Set<Id> setGroupMemberIds;
                    Map<Id, Id> mapAccountRelatedGroupIds = new Map<Id, Id>();
                    List<GroupMember> lstGroupMembersToCreate = new List<GroupMember>();
                    for(Group objGroup : [SELECT Id, Name, (SELECT Id, GroupId, UserOrGroupId FROM GroupMembers) 
                    FROM Group WHERE Name IN : setAccountAbbreviatedNames AND Type = 'Regular' WITH USER_MODE]){
                        setGroupMemberIds = new Set<Id>();
                        for(GroupMember objGroupMember : objGroup.GroupMembers){
                            setGroupMemberIds.add(objGroupMember.UserOrGroupId);
                        }

                        Id groupAccountId = mapAccountAbbreviatedNameRelatedIds.get(getAbbreviatedString(objGroup.Name));
                        Account objGroupAccount = mapAccounts.get(groupAccountId);
                        
                        if(objGroupAccount.ParentId != null && mapAccountParentIds.containsKey(objGroupAccount.Id)){
                            for(Id parentId : mapAccountParentIds.get(objGroupAccount.Id)){ 
                                if(!setGroupMemberIds.contains(parentId)){
                                    lstGroupMembersToCreate.add(new GroupMember(
                                        GroupId = objGroup.Id,
                                        UserOrGroupId = parentId
                                    ));
                                    setGroupMemberIds.add(parentId);
                                }
                            }
                        }
                        mapGroupMembers.put(objGroup.Id, setGroupMemberIds);
                        mapAccountRelatedGroupIds.put(groupAccountId, objGroup.Id);
                    }
                    setGroupMemberIds = null;
                    
                    List<Group> lstGroupsToCreate = new List<Group>();
                    tmpMap = new Map<Integer, Id>();
                    tmpIndex = 0;
                    for(Id accountId : mapAccounts.keySet()){
                        if(!mapAccountRelatedGroupIds.containsKey(accountId)){
                            Group objGroup;
                            if(Schema.sObjectType.Group.fields.Name.isCreateable() && Schema.sObjectType.Group.fields.Type.isCreateable()){
                             objGroup = new Group(
                                Name = getAbbreviatedString(mapAccounts.get(accountId).Name),
                                Type = 'Regular'
                            );
                            }
                            lstGroupsToCreate.add(objGroup);
                            tmpMap.put(tmpIndex, mapAccountAbbreviatedNameRelatedIds.get(objGroup.Name));
                            tmpIndex++;
                        }
                    }
                    if(!lstGroupsToCreate.isEmpty() && Schema.sObjectType.Group.isCreateable() && Group.sObjectType.getDescribe().isAccessible() == true){
                        insert lstGroupsToCreate;
                        tmpIndex = 0;                        
                        for(Group objGroup : lstGroupsToCreate){
                            Id groupAccountId = tmpMap.get(tmpIndex);
                            
                            mapGroupMembers.put(objGroup.Id, new Set<Id>());
                            mapAccountRelatedGroupIds.put(groupAccountId, objGroup.Id);
                            setGroupMemberIds = new Set<Id>();

                            Account objGroupAccount = mapAccounts.get(groupAccountId);
                            
                            if(objGroupAccount.ParentId != null && mapAccountParentIds.containsKey(objGroupAccount.Id)){
                                for(Id parentId : mapAccountParentIds.get(objGroupAccount.Id)){
                                    lstGroupMembersToCreate.add(new GroupMember(
                                        GroupId = objGroup.Id,
                                        UserOrGroupId = parentId
                                    ));
                                    setGroupMemberIds.add(parentId);
                                }
                            }
                            mapGroupMembers.put(objGroup.Id, setGroupMemberIds);
                            tmpIndex++;
                        }
                    }

                    List<ContentWorkspaceMember> lstContentWorkspaceMembersToCreate = new List<ContentWorkspaceMember>();
                    Id accountId, accountGroupId, workspaceId, workspacePermissionId;
                    for(Id UserId : mapUserWorkspacePermissions.keySet()){
                        UserWorkspacePermission objUserWorkspacePermission = mapUserWorkspacePermissions.get(UserId);
                        workspacePermissionId = String.isNotBlank(objUserWorkspacePermission.WorkspacePermission) && mapWorkspacePermission.containsKey(objUserWorkspacePermission.WorkspacePermission.toLowerCase()) ? mapWorkspacePermission.get(objUserWorkspacePermission.WorkspacePermission.toLowerCase()) : mapWorkspacePermission.get('govgrants viewer');
                        accountId = mapUserOrgIds.get(UserId);
                        Account objAccount = mapAccounts.get(accountId);
                        if(objAccount != null && mapAccountRelatedContentWorkspace.containsKey(objAccount.Id) && workspacePermissionId != null){
                            workspaceId = mapAccountRelatedContentWorkspace.get(objAccount.Id);
                            ContentWorkspace objContentWorkspace = mapContentWorkspace.get(workspaceId);
                            if(objContentWorkspace != null){
                                accountGroupId = mapAccountRelatedGroupIds.get(objAccount.Id);
                                if(accountGroupId != null){
                                    setGroupMemberIds = mapGroupMembers.containsKey(accountGroupId) ? mapGroupMembers.get(accountGroupId) : new Set<Id>();
                                    if(!setGroupMemberIds.contains(UserId)){
                                        lstGroupMembersToCreate.add(new GroupMember(
                                            GroupId = accountGroupId,
                                            UserOrGroupId = UserId
                                        ));
                                        setGroupMemberIds.add(UserId);
                                        mapGroupMembers.put(accountGroupId, setGroupMemberIds);
                                    }

                                    setWorkspaceMembers = mapWorkspaceMembers.containsKey(objContentWorkspace.Id) ? new Set<Id>(mapWorkspaceMembers.get(objContentWorkspace.Id)) : new Set<Id>();
                                    if(!setWorkspaceMembers.contains(accountGroupId)){ // Added newly created Group related to Account as a Workspace Member
                                        lstContentWorkspaceMembersToCreate.add(new ContentWorkspaceMember(
                                            ContentWorkspacePermissionId = workspacePermissionId, //'05P***************
                                            ContentWorkspaceId = objContentWorkspace.Id,
                                            MemberId = accountGroupId
                                        ));
                                        setWorkspaceMembers.add(accountGroupId);
                                        mapWorkspaceMembers.put(objContentWorkspace.Id, setWorkspaceMembers);
                                    }
                                }
                            }
                        }
                    }

                    // New Group Members created if users are not existing members of related Group
                    if(!lstGroupMembersToCreate.isEmpty() && Schema.sObjectType.GroupMember.isCreateable() && GroupMember.sObjectType.getDescribe().isAccessible() == true){
                        insert lstGroupMembersToCreate;
                    }

                    // New Workspace Members created if Users/Groups are not existing members of related Workspace
                    if(!lstContentWorkspaceMembersToCreate.isEmpty() && Schema.sObjectType.GroupMember.isCreateable() && GroupMember.sObjectType.getDescribe().isAccessible() == true){
                        insert lstContentWorkspaceMembersToCreate;
                    } 
                    if(!mapAccountRelatedContentWorkspace.isEmpty()){
                        updateWorkspaceIdOnAccount(mapAccountRelatedContentWorkspace);
                    }                    
                }
            }
        } catch(Exception objException){
            Database.rollback(objSavepoint); 
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    // Method to abbreviate the Account/Group Name
    private static String getAbbreviatedString(String nonAbbreviatedString){
        if(String.isNotBlank(nonAbbreviatedString)){
            return nonAbbreviatedString.substring(0, nonAbbreviatedString.length() > 40 ? 40 : nonAbbreviatedString.length());
        }
        return null;
    }

    // Method to update Workspace Ids on Accounts provided in map of Account to Workspace Ids
    @future
    public static void updateWorkspaceIdOnAccount(Map<Id, Id> mapAccountRelatedContentWorkspace){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            Set<Id> setWorkspaceIds = new Set<Id>(mapAccountRelatedContentWorkspace.values());
            if(!setWorkspaceIds.isEmpty()){
                List<Workspace__c> lstWorkspaceToCreate = new List<Workspace__c>();
                Map<Id, Integer> tmpMap = new Map<Id, Integer>();
                Integer index = 0;
                for(ContentWorkspace objContentWorkspace : [SELECT Id, Name, RootContentFolderId FROM ContentWorkspace 
                                                            WHERE Id IN : setWorkspaceIds WITH USER_MODE]){
                    lstWorkspaceToCreate.add(
                        new Workspace__c(
                            WorkspaceId__c = objContentWorkspace.Id,
                            DefaultFolderId__c = objContentWorkspace.RootContentFolderId,
                            DefaultFolderName__c = objContentWorkspace.Name
                        )
                    );
                    tmpMap.put(objContentWorkspace.Id, index++);
                }
                if(Schema.sObjectType.Workspace__c.isCreateable() && Schema.SObjectType.Workspace__c.isUpdateable()){
                    Database.UpsertResult[] objUpsertResult = Database.upsert(lstWorkspaceToCreate, Workspace__c.WorkspaceId__c.getDescribe().getSObjectField(), false);
                }
                List<Account> lstAccounts = new List<Account>();
                for(Account objAccount : [SELECT Id, Workspace__c FROM Account WHERE Id IN : mapAccountRelatedContentWorkspace.keySet() WITH USER_MODE ]){
                    Id workspaceId = mapAccountRelatedContentWorkspace.get(objAccount.Id);                    
                    if(workspaceId != null && tmpMap.containsKey(workspaceId)){
                        Workspace__c objWorkspaceConfig = lstWorkspaceToCreate[tmpMap.get(workspaceId)];
                        if(objWorkspaceConfig != null && objAccount.Workspace__c != objWorkspaceConfig.Id){
                            if (Schema.sObjectType.Account.fields.Workspace__c.isUpdateable()) {
                                objAccount.Workspace__c = objWorkspaceConfig.Id;
                            }
                            if (Schema.sObjectType.Account.fields.WorkspaceId__c.isUpdateable()) {
                                objAccount.WorkspaceId__c = objWorkspaceConfig.WorkspaceId__c;
                            }
                            lstAccounts.add(objAccount);
                        }                        
                    }               
                }
                if(!lstAccounts.isEmpty() && Schema.sObjectType.Account.isUpdateable() && Schema.sObjectType.Account.isAccessible()){
                    update lstAccounts;
                }
            } 
        } catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    /*
    * Description   :   Wrapper class used in createUserWorkspace method to Create User Workspace or Manage Workspace Permission for the listed users with UserId, OrganizarionId and WorkspacePermission.
    * Properties    :   Id UserId
    *                   Id OrganizationId
    *                   String WorkspacePermission
    * Created By    :   Dipak Pawar on 20 December 2019
    */
    global class UserWorkspacePermission {
        global Id UserId {get; set;}
        global Id OrganizationId {get; set;}
        global String WorkspacePermission {get; set;}

        global UserWorkspacePermission(Id UserId, Id OrganizationId, String WorkspacePermission){
            this.UserId = UserId;
            this.OrganizationId = OrganizationId;
            this.WorkspacePermission = WorkspacePermission;
        }
    }
    
    @AuraEnabled
    public static Map<String, Object> getFilePageData(Id fileId, Id parentId, Id pageBlockId){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            Map<String, Object> mapPageData = new Map<String, Object>(); 
            Map<String, Object> workspaceFilesData = getWorkspaceFilesData(null);

            //User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
            Boolean uploadFileToPrivateLibrary = uploadFileToPrivateLibrary();
            mapPageData.put('uploadFileToPrivateLibrary', uploadFileToPrivateLibrary);

            if(workspaceFilesData != null && Boolean.valueOf(workspaceFilesData.get('isWorkspaceConfigured'))){                
                ContentVersion objContentVersion;
                List<ContentVersion> lst = new List<ContentVersion>();
                if(fileId.getSobjectType().getDescribe().getName() == 'ContentDocument'){
                    lst = [SELECT Id, ContentDocumentId, Title, Description, Classification__c, FileExtension__c, SharingPrivacy 
                    FROM ContentVersion WHERE ContentDocumentId =:fileId WITH USER_MODE];
                } else if(fileId.getSobjectType().getDescribe().getName() == 'ContentVersion'){
                    lst = [SELECT Id, ContentDocumentId, Title, Description, Classification__c, FileExtension__c, SharingPrivacy 
                    FROM ContentVersion WHERE Id =:fileId WITH USER_MODE];
                }

                if(!lst.isEmpty()){
                    objContentVersion = lst[0];
                    mapPageData.put('contentVersion', objContentVersion);

                    if(uploadFileToPrivateLibrary && parentId != null){
                        List<ContentDocumentLink> lstContentDocumentLinks = [SELECT Id, Visibility FROM ContentDocumentLink 
                        WHERE LinkedEntityId =: parentId AND ContentDocumentId =:objContentVersion.ContentDocumentId WITH USER_MODE];
                        if(!lstContentDocumentLinks.isEmpty() && lstContentDocumentLinks[0].Visibility == 'InternalUsers' && objContentVersion.SharingPrivacy == 'N') {
                            objContentVersion.SharingPrivacy =  'I';
                        }
                    }

                    if(objContentVersion != null && !uploadFileToPrivateLibrary){
                        String selectedFolderName;
                        List<ContentWorkspaceDoc> lstContentWorkspaceDoc = [SELECT Id, ContentDocumentId, ContentWorkspaceId 
                        FROM ContentWorkspaceDoc WHERE ContentDocumentId =:objContentVersion.ContentDocumentId WITH USER_MODE];
                        ContentWorkspaceDoc objContentWorkspaceDoc;
                        if(!lstContentWorkspaceDoc.isEmpty()){
                            objContentWorkspaceDoc = lstContentWorkspaceDoc[0];                        
                            for(ContentFolderMember objContentFolderMember : [SELECT Id, ParentContentFolderId, ParentContentFolder.Name, ParentContentFolder.CreatedById, ParentContentFolder.CreatedDate 
                            FROM ContentFolderMember 
                            WHERE ChildRecordId =: objContentVersion.ContentDocumentId AND ParentContentFolder.Name != :UserInfo.getUserId() WITH USER_MODE]){
                                selectedFolderName = objContentFolderMember.ParentContentFolder.Name;
                                if(!selectedFolderName.startsWith('005')){
                                    if(selectedFolderName.startsWith('058')){
                                        ContentWorkspace objContentWorkspace = [SELECT Id, Name FROM ContentWorkspace 
                                        WHERE Id =:objContentFolderMember.ParentContentFolder.Name WITH USER_MODE];
                                        selectedFolderName = objContentWorkspace.Name;
                                    }
                                    Folder objFolder = new Folder(objContentFolderMember.ParentContentFolderId, selectedFolderName, selectedFolderName, false, objContentWorkspaceDoc.ContentWorkspaceId, objContentFolderMember.ParentContentFolder.CreatedById == UserInfo.getUserId(), objContentFolderMember.ParentContentFolderId, objContentFolderMember.ParentContentFolder.CreatedDate, null, false);
                                    mapPageData.put('contentFolder', objFolder);
                                }
                            }
                        } else {
                            workspaceFilesData.put('isWorkspaceConfigured', false);
                            workspaceFilesData.put('message', 'You don\'t have access to Edit the file to any Library. Please contact your administrator.');
                        }
                    }
                
                    if(parentId != null || pageBlockId != null){
                        mapPageData.put('fileTypes', getFileTypes(parentId, pageBlockId));
                    }
                    //User Story 90298: NFWF - Internal - Add a Private checkbox field in Files modal window (Add file modal page)
                    mapPageData.put('sharingOptions', getSharingPrivacy());
                    mapPageData.put('showSharingOptions', showSharingPrivacy());
                    mapPageData.put('isExternalUser', isExternalUser());
                } else {
                    workspaceFilesData.put('isWorkspaceConfigured', false);
                    workspaceFilesData.put('message', 'You don\'t have access to Edit the file to any Library. Please contact your administrator.');
                }
            }
            mapPageData.put('workspaceFilesData', workspaceFilesData);

            if(!uploadFileToPrivateLibrary){
                mapPageData.put('defaultFolder', getDefaultFolder());
            }
            return mapPageData;
        } catch(Exception objException){
            Database.rollback(objSavepoint); 
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    //Method to delete File
    public override Map<String, Object> clickHandler(){        
        Map<String, Object> deleteResult = new Map<String, Object>();
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            Map<String, Object> result = new Map<String, Object>();
            ContentVersion objContentVersion = [SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentVersion 
            WHERE Id =: selectedRecordId WITH USER_MODE];
            
            ContentDocument objContentDocument = objContentVersion.ContentDocument;
            
            Map<String, Object> mapDeleteFileResult = deleteFile(objContentDocument.Id, urlParamsMap.get('RecordId') != null ? String.valueOf(urlParamsMap.get('RecordId')) : null);
            
            deleteResult.put('Message', mapDeleteFileResult.get('message'));
            deleteResult.put('Success', mapDeleteFileResult.get('success'));
            return deleteResult;
        } catch(Exception objException){
            Database.rollback(objSavepoint); 
            deleteResult.put('Message', AppUtils.handleSystemExceptionMsg(objException));
            deleteResult.put('Error', true);
            return deleteResult;
        }        
    }
    
    @AuraEnabled
    public static Map<String, Object> deleteFile(Id fileId, Id recordId){    
        Savepoint objSavepoint = Database.setSavepoint();    
        try {
            Integer recordCount = 0;
            Map<String, Object> mapDeleteFileResult = new Map<String, Object>();
            ContentDocumentLink objContentDocumentLinkToDelete;
            String strFileName;
            for(ContentDocumentLink objContentDocumentLink : [SELECT Id, ContentDocumentId, ContentDocument.Title, LinkedEntityId 
            FROM ContentDocumentLink WHERE ContentDocumentId =: fileId WITH USER_MODE]){
                String strObjectType = objContentDocumentLink.LinkedEntityId.getSobjectType().getDescribe().getName();
                strFileName = objContentDocumentLink.ContentDocument.Title;
                if(strObjectType != 'ContentWorkspace' && strObjectType != 'User'){
                    recordCount += 1;
                    if(objContentDocumentLink.LinkedEntityId == recordId){
                        objContentDocumentLinkToDelete = objContentDocumentLink;                        
                    }
                }
            }
            if(recordCount > 0 && recordId == null){
                mapDeleteFileResult.put('message', 'You can not delete File <strong>' + strFileName + '</strong>, as it is associated with business records.');
                mapDeleteFileResult.put('success', false);                
            } else if(recordCount > 1 && recordId != null){
                if(Schema.sObjectType.ContentDocumentLink.isDeletable() && Schema.sObjectType.ContentDocumentLink.isAccessible()) {
                    delete objContentDocumentLinkToDelete;
                }
                mapDeleteFileResult.put('message', 'File <strong>' + strFileName + '</strong> link deleted successfully.');
                mapDeleteFileResult.put('success', true);                
            } else {
                if(Schema.sObjectType.ContentDocument.isDeletable() && Schema.sObjectType.ContentDocument.isAccessible()) {
                    delete new ContentDocument(Id = fileId);
                }
                mapDeleteFileResult.put('message', 'File <strong>' + strFileName + '</strong> deleted successfully.');
                mapDeleteFileResult.put('success', true);
            }
            return mapDeleteFileResult;
        } catch(Exception objException){
            Database.rollback(objSavepoint); 
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
    
    @AuraEnabled
    public static Boolean checkFileDuplicateInFolder(String fileName, Id fileId, Id folderId) {
        try {
            Map<Id, ContentDocument> mapFiles;
            if(fileId != null){
                mapFiles = new Map<Id, ContentDocument>([SELECT Id, Title FROM ContentDocument 
                WHERE Id <> :fileId AND Title =:fileName WITH USER_MODE]);
            } else {
                mapFiles = new Map<Id, ContentDocument>([SELECT Id, Title FROM ContentDocument 
                WHERE Title =:fileName WITH USER_MODE]);
            }            
            
            if(!mapFiles.isEmpty()){                
                List<ContentFolderMember> lstContentFolderMembers = new List<ContentFolderMember>([SELECT Id, ParentContentFolderId, ChildRecordId 
                FROM ContentFolderMember WHERE ParentContentFolderId =: folderId AND ChildRecordId IN :mapFiles.keySet() WITH USER_MODE]);
                return lstContentFolderMembers != null && lstContentFolderMembers.size() > 0;
            }
            return false;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }   
    }

    @AuraEnabled
    public static Boolean setWorkspaceDefaultFolder(List<Workspace__c> records){
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            // Bug 70871: Internal : Default Folder is going to set only with the latest added folder with same name
            for (Workspace__c objWorkspace : records) {
                objWorkspace.IsSystem__c = true;
            }
            
            if(Schema.sObjectType.Workspace__c.isCreateable() && Schema.SObjectType.Workspace__c.isUpdateable()){
                Database.UpsertResult[] objUpsertResult = Database.upsert(records, Workspace__c.WorkspaceId__c.getDescribe().getSObjectField(), true);
            }
            return true;
        } catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    @AuraEnabled
    public static Boolean isExternalUser(){
        try{
            String lstExternalProfiles = KeyValueHolderHelper.getBooleanValue('ExternalProfiles') ? KeyValueHolderHelper.getTextValue('ExternalProfiles') : null;
            Set<String> setExternalProfiles = new Set<String>();
            if(String.isNotBlank(lstExternalProfiles)){
                for(String profileName : lstExternalProfiles.split(';')){
                    setExternalProfiles.add(profileName.trim().toLowerCase());
                }
                if(Schema.sObjectType.User.fields.Id.isAccessible()) {
                    User objUser = [SELECT Id, Name, IsActive, ProfileId, Profile.Name FROM User
                    WHERE Id =: UserInfo.getUserId()];//WITH SECURITY_ENFORCED Removing as this do not work for SPI User
                    return objUser != null && setExternalProfiles.contains(objUser.Profile.Name.toLowerCase());
                }
            }
            return false;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    //User Story 90298: NFWF - Internal - Add a Private checkbox field in Files modal window (Add file modal page)
    public static List<Map<String, Object>> getSharingPrivacy(){
        try{
            List<Map<String, Object>> picklistValues = new List<Map<String, Object>>();
            Schema.DescribeFieldResult fieldResult = ContentVersion.SharingPrivacy.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple) {
                picklistValues.add(new Map<String, Object>{'label' => f.getLabel(), 'value' => f.getValue()});
            }
            return picklistValues;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    //User Story 90298: NFWF - Internal - Add a Private checkbox field in Files modal window (Add file modal page)
    public static Boolean showSharingPrivacy(){
        try{ /** /Task 163529: NED - Performance optimization Auguest 2021 release start            
            String key = 'ShowSharingPrivacy';
        List<KeyValueHolder__mdt> lstKeyValueHolders = Database.query('SELECT Id, TextValue__c FROM KeyValueHolder__mdt WHERE BooleanValue__c = true AND DeveloperName =:key LIMIT 1');
        if(lstKeyValueHolders.isEmpty()) {
            return false;
        } else {
            KeyValueHolder__mdt objKeyValueHolder = lstKeyValueHolders[0];
            String lstProfiles = objKeyValueHolder.TextValue__c; */                
                Boolean showShareBoolean = KeyValueHolderHelper.getBooleanValue('ShowSharingPrivacy') != null ? true : false;
                String lstProfiles = KeyValueHolderHelper.getTextValue('ShowSharingPrivacy') != null ? KeyValueHolderHelper.getTextValue('ShowSharingPrivacy'): '';
                //Task 163529: NED - Performance optimization Auguest 2021 release end
                Set<String> setProfiles = new Set<String>();
                if (String.isNotBlank(lstProfiles) && showShareBoolean == true ) {
                    for (String profileName : lstProfiles.split(';')) {
                        setProfiles.add(profileName.trim().toLowerCase());
                    }
                    if(Schema.sObjectType.User.fields.Id.isAccessible()) {
                        User objUser = [SELECT Id, Name, IsActive, ProfileId, Profile.Name FROM User 
                        WHERE Id = :UserInfo.getUserId()];//WITH SECURITY_ENFORCED Removing as this do not work for SPI User 
                        return objUser != null && setProfiles.contains(objUser.Profile.Name.toLowerCase());
                    }
                }
            //}
            return false;
        } catch(Exception objException){
            throw new FileUploadCtrlException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }

    @AuraEnabled
    public static ContentVersion getFilePreviewData(String fileId){
        List<ContentVersion> lstContentVersion = [SELECT Id, ContentDocumentId, ContentBodyId, FileExtension 
        FROM ContentVersion WHERE ContentDocumentId =:fileId WITH USER_MODE];
        return lstContentVersion[0];
    }

    //User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
    private static Boolean uploadFileToPrivateLibrary(){
        return FeatureManagement.checkPermission('UploadFileToPrivateLibrary');
    }

    //Reterives specific file information
    @AuraEnabled
    public static FileData GetFile(string contentversionId) {
        List<ContentVersion> versions = [SELECT Id,Title,ContentDocumentId,FileExtension,FileType,ContentBodyId,PageCount__c,CreatedDate FROM ContentVersion 
        WHERE Id = :contentversionId AND IsLatest = true WITH USER_MODE];
        FileData data = new FileData();
        String url;
        //data.Content = EncodingUtil.base64Encode(versions[0].VersionData);

        data.DownloadUrl = BASE_URL + '/sfc/servlet.shepherd/document/download/' + versions[0].ContentDocumentId;
        Set<String> extensions = new Set<String>{
                'PNG', 'JPG', 'JPEG'
        };
        if (extensions.contains(versions[0].FileType)) {
            data.FileUrl = BASE_URL + '/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_' + versions[0].FileType;
        } else {
            if(versions[0].PageCount__c!=null && versions[0].PageCount__c!=0){
                data.FileUrl = BASE_URL + '/sfc/servlet.shepherd/version/renditionDownload?rendition=SVGZ';
                data.FileUrl += '&operationContext=CHATTER';
                data.FileUrl += '&contentId=' + versions[0].ContentBodyId;
                data.pageCount = (Integer) versions[0].PageCount__c;
            }else{
                data.FileUrl = BASE_URL + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480';
            }
        }
        data.ContentType = versions[0].FileExtension;
        data.FileUrl += '&versionId=' + versions[0].Id;
        
        Datetime timeOfFileUpload = versions[0].CreatedDate;
        Datetime now = Datetime.now();
        Integer timeSinceUpload = now.isSameDay(timeOfFileUpload) ?
            ((now.hour() - timeOfFileUpload.hour()) * 60) + (now.minute() - timeOfFileUpload.minute()) :
            999;
        data.timeSinceUpload = timeSinceUpload;
        return data;
    }
    public class FileData {
        @AuraEnabled
        public string Content { get; set; }
        @AuraEnabled
        public string ContentType { get; set; }
        @AuraEnabled
        public string FileUrl { get; set; }
        @AuraEnabled
        public string DownloadUrl { get; set; }
        @AuraEnabled
        public Integer pageCount { get; set; }
        @AuraEnabled
        public Integer timeSinceUpload { get; set; }
    }
    
    public class FileUploadCtrlException extends Exception {}
}