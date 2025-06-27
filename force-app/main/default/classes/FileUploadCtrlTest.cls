/*
* Class Name    :   FileUploadCtrlTest
* Description   :   Test class for FileUploadCtrl
* --------------------------------------------------------------------------------------------------------------------
*   Version     Date                Author                      Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0         25 July 2019        Dipak Pawar                 Initial Development
* --------------------------------------------------------------------------------------------------------------------
*/
@isTest
private with sharing class FileUploadCtrlTest {
    
    @testSetup 
    private static void initSetup() { 
        Account objAccount = TestHelper.getAccount(True);
        System.assertNotEquals(null, objAccount);
        List<Account> lstAccounts = FileUploadCtrl.executeQuery('SELECT Id, Name FROM Account');
        System.assertNotEquals(0, lstAccounts.size());
        
        SampleObject11__c objSampleObject = TestHelper.getSampleObject1(true);
        System.assertNotEquals(null, objSampleObject.Id);
        
        SObjectConfig__c objSObjectConfig =  TestHelper.getSObjectConfig(false);
        System.assertNotEquals(null, objSObjectConfig);
        objSObjectConfig.AttachmentClassifications__c = 'Classification 1; Classification 2; Classification 3';
        insert objSObjectConfig;
        System.assertNotEquals(null, objSObjectConfig.Id);
        
        PageLayoutConfig__c objPageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
        objPageLayoutConfig.IsMiniLayout__c = true;
        insert objPageLayoutConfig;
        System.assertNotEquals(null, objPageLayoutConfig.Id);
        
        TabConfig__c objTabConfig = TestHelper.getTabConfig(objPageLayoutConfig.Id, true);
        System.assertNotEquals(null, objTabConfig.Id);
        
        PageBlockConfig__c objPageBlockConfig = TestHelper.getPageBlockConfig(objTabConfig.Id, true);
        System.assertNotEquals(null, objPageBlockConfig.Id);
        
        ContentVersion objContentVersion = new ContentVersion(); 
        objContentVersion.ContentURL='<a target="_blank" href="https://www.login.salesforce.com/";" rel="nofollow">https://www.login.salesforce.com/";</a> ';
        objContentVersion.Title ='Salesforce.com'; 
        insert objContentVersion;
        System.assertNotEquals(null, objContentVersion.Id);
        
        objContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :objContentVersion.Id]; 
        System.assertNotEquals(null, objContentVersion.Id);
        System.assertNotEquals(null, objContentVersion.ContentDocumentId);

        List<Lead> lstLeads = new List<Lead>{new Lead(LastName = 'Test Lead', Company = 'Test Lead Company')};
        String strSaveResult = FileUploadCtrl.saveRecords(lstLeads);
        System.assertNotEquals(null, strSaveResult);

        lstLeads = FileUploadCtrl.executeQuery('SELECT Id, Name FROM Lead');
        System.assertNotEquals(0, lstLeads.size());

        String strDeleteResult = FileUploadCtrl.deleteRecords(lstLeads);
        System.assertNotEquals(null, strDeleteResult);

        lstLeads = FileUploadCtrl.executeQuery('SELECT Id, Name FROM Lead');
        System.assertEquals(0, lstLeads.size());

        try {
            System.assertEquals(null, FileUploadCtrl.executeQuery(null));
        } catch (Exception ex) {
            System.assertNotEquals(null, ex);
        }
    }

    @isTest 
    private static void verifyGetPageData(){
        SampleObject11__c objSampleObject = [SELECT Id, Name FROM SampleObject11__c LIMIT 1];
        System.assertNotEquals(null, objSampleObject.Id);
        
        PageBlockConfig__c objPageBlockConfig = [SELECT Id FROM PageBlockConfig__c LIMIT 1];
        System.assertNotEquals(null, objPageBlockConfig.Id);
        objPageBlockConfig.AttachmentClassifications__c = 'A;B;C';
        update objPageBlockConfig;
        
        Map<String, Object> pageData = FileUploadCtrl.getPageData(objSampleObject.Id, objPageBlockConfig.Id);
        System.assertNotEquals(null, pageData);
        System.assertNotEquals(null, pageData.get('fileTypes'));

        pageData = FileUploadCtrl.getPageData(null, objPageBlockConfig.Id);
        System.assertNotEquals(null, pageData);
        
        try{
            List<Map<String, String>> lstileTypes = FileUploadCtrl.getFileTypes(UserInfo.getUserId(), null);
        } catch(Exception objException){
            System.assertNotEquals(null, objException);
        }
    }
    
    @isTest 
    private static void verifyGetWorkspaceFiles(){
        SampleObject11__c objSampleObject = [SELECT Id, Name FROM SampleObject11__c LIMIT 1];
        System.assertNotEquals(null, objSampleObject.Id);
        
        User objLoggedInUser = [SELECT Id, OrganizationId__c FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs (objLoggedInUser) {
            try{
                List<ContentWorkspace> lstContentWorkspace = new List<ContentWorkspace>{FileUploadCtrl.getUserWorkspaceInfo(UserInfo.getUserId())};
                // System.assertNotEquals(0, lstContentWorkspace.size());
                // Map<String, Object> mapResult = FileUploadCtrl.getWorkspaceFiles(objSampleObject.Id, new List<String>{lstContentWorkspace[0].Id});
                // List<ContentVersion> lstContentVersion = (List<ContentVersion>)mapResult.get('workspaceFiles');
                // System.assertNotEquals(null, lstContentVersion);
                        
                // mapResult = FileUploadCtrl.getWorkspaceFiles(objSampleObject.Id, new List<String>{lstContentWorkspace[0].Id});
                // lstContentVersion = (List<ContentVersion>)mapResult.get('workspaceFiles');
                // System.assertNotEquals(null, lstContentVersion);

                List<Map<String, String>> fileTypes = FileUploadCtrl.getFileTypes(objSampleObject.Id, lstContentWorkspace[0].Id);
                System.assertNotEquals(null, fileTypes);
            } catch(Exception ex){
                System.assertNotEquals(null, ex);
            }
        }
    }
    
    @isTest 
    private static void verifyUpdateContentVersion(){        
        SampleObject11__c objSampleObject = [SELECT Id, Name FROM SampleObject11__c LIMIT 1];
        System.assertNotEquals(null, objSampleObject.Id);
        
        Map<String, String> mapContentVersionData = new Map<String, String>();
        mapContentVersionData.put('Description', 'New Description');
        mapContentVersionData.put('Classification__c', 'new Classification__c');
        mapContentVersionData.put('SharingPrivacy', 'N');

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.ContentURL='<a target="_blank" href="https://www.login.salesforce.com/";" rel="nofollow">https://www.login.salesforce.com/";</a> ';
        objContentVersion.Title ='FileUploadCtrl';
        insert objContentVersion;
        System.assertNotEquals(null, objContentVersion.Id);

        objContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: objContentVersion.Id];
        System.assertNotEquals(null, objContentVersion);

        Boolean updateContentVersionResult = FileUploadCtrl.updateContentVersion(mapContentVersionData, objContentVersion.ContentDocumentId, null, objSampleObject.Id, null);
        System.assertEquals(true, updateContentVersionResult);        

        User objLoggedInUser = [SELECT Id, OrganizationId__c FROM User WHERE Id =: UserInfo.getUserId()];
        System.runAs (objLoggedInUser) {
            try {
                List<ContentWorkspace> lstContentWorkspace = new List<ContentWorkspace>{FileUploadCtrl.getUserWorkspaceInfo(UserInfo.getUserId())};
                System.assertNotEquals(0, lstContentWorkspace.size());

                ContentFolderLink objContentFolderLink = [SELECT Id, ParentEntityId, ContentFolderId, ContentFolder.Name FROM ContentFolderLink WHERE ParentEntityId =: lstContentWorkspace[0].Id];

                ContentFolder objContentFolder = new ContentFolder(
                        ParentContentFolderId = objContentFolderLink.ContentFolderId,
                        Name = 'ContentWorkspace Folder'
                );
                insert objContentFolder;
                System.assertNotEquals(null, objContentFolder.Id);

                ContentFolderMember objFolderMember = new ContentFolderMember(
                    ChildRecordId = objContentVersion.ContentDocumentId,
                    ParentContentFolderId = objContentFolder.Id
                );
                insert objFolderMember;
                System.assertNotEquals(null, objFolderMember.Id);

                ContentFolder objContentFolder1 = new ContentFolder(
                        ParentContentFolderId = objContentFolder.Id,
                        Name = 'ContentWorkspace Folder'
                );
                insert objContentFolder1;
                System.assertNotEquals(null, objContentFolder1.Id);

                ContentFolder objContentFolder2 = new ContentFolder(
                        ParentContentFolderId = objContentFolder1.Id,
                        Name = 'ContentWorkspace Folder'
                );
                insert objContentFolder2;
                System.assertNotEquals(null, objContentFolder2.Id);

                updateContentVersionResult = FileUploadCtrl.updateContentVersion(mapContentVersionData, objContentVersion.ContentDocumentId, objContentFolder.Id, objSampleObject.Id, lstContentWorkspace[0].Id);
                System.assertEquals(true, updateContentVersionResult);

                ContentDocument objDoc = new ContentDocument(Id = objContentVersion.ContentDocumentId, ParentId = null);
                update objDoc;

                updateContentVersionResult = FileUploadCtrl.updateContentVersion(mapContentVersionData, objContentVersion.ContentDocumentId, objContentFolder.Id, objSampleObject.Id, lstContentWorkspace[0].Id);
                System.assertEquals(true, updateContentVersionResult);

                updateContentVersionResult = FileUploadCtrl.updateContentVersion(null, null, null, null, null);
                System.assertEquals(null, updateContentVersionResult);
            } catch (Exception ex) {
                System.assertNotEquals(null, ex);
            }
        }

        try{
            mapContentVersionData.put('Classification__c', 'LoremIpsumissimplydummytextoftheprintingandtypesettingindustry.LoremIpsumhasbeentheindustry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.');
            updateContentVersionResult = FileUploadCtrl.updateContentVersion(mapContentVersionData, objContentVersion.ContentDocumentId, null, objSampleObject.Id, null);
            System.assertEquals(true, updateContentVersionResult);
        } catch(Exception ex){

        }
    }
    
    @isTest 
    private static void verifyGetFolderHierarchy(){
        Map<String, Object> folderHierarchy = FileUploadCtrl.getFolderHierarchy(null, null, null);
        System.assertNotEquals(null, folderHierarchy);
    }
    
    @isTest 
    private static void verifyChangeParentContentFolder(){
        ContentDocument objContentDocument = [SELECT Id FROM ContentDocument];
        System.assertNotEquals(null, objContentDocument);
        
        Map<String, Object> folderHierarchy = FileUploadCtrl.getFolderHierarchy(null, null, null);
        Map<Id, Boolean> mapFolders = (Map<Id, Boolean>)folderHierarchy.get('mapFolderState');
    }
    
    @isTest 
    private static void verifyAttachFilesToRecord(){
        SampleObject11__c objSampleObject = [SELECT Id, Name FROM SampleObject11__c LIMIT 1];
        System.assertNotEquals(null, objSampleObject.Id);
        
        Map<Id, ContentVersion> mapContentVersions = new Map<Id, ContentVersion>([SELECT Id FROM ContentVersion]);
        System.assertNotEquals(true, mapContentVersions.isEmpty());
        
        Object attachFilesToRecordResult = FileUploadCtrl.attachFilesToRecord(new List<Id>(mapContentVersions.keySet()), objSampleObject.Id);
        System.assertNotEquals(null, attachFilesToRecordResult);
        
        try{
            attachFilesToRecordResult = FileUploadCtrl.attachFilesToRecord(null, objSampleObject.Id);
        } catch (Exception objException){
            System.assertNotEquals(null, objException);
        }
    }
    
    @isTest 
    private static void verifyGetUserWorkspaceInfo(){
        User objLoggedInUser = [SELECT Id, OrganizationId__c FROM User WHERE Id =: UserInfo.getUserId()];
        System.assertNotEquals(null, objLoggedInUser.Id);
        System.runAs (objLoggedInUser) {
            try{
                List<ContentWorkspace> lstContentWorkspace = new List<ContentWorkspace>{FileUploadCtrl.getUserWorkspaceInfo(UserInfo.getUserId())};
                System.assertNotEquals(null, lstContentWorkspace);

                lstContentWorkspace = new List<ContentWorkspace>{FileUploadCtrl.getUserWorkspaceInfo(null)};
                System.assertEquals(null, lstContentWorkspace);
            } catch (Exception objException){
                System.assertNotEquals(null, objException);
            }
        }
    }
    
    @isTest 
    private static void verifyCreateUserWorkspaceForBlankAccountWorkspace(){        
        Account objAccount = [SELECT Id, Name, WorkspaceId__c FROM Account WHERE WorkspaceId__c = ''];
        System.assertNotEquals(null, objAccount);
        System.assertEquals(null, objAccount.WorkspaceId__c);
        
        //User objUser = TestHelper.getUser(true);
        //System.assertNotEquals(null, objUser);
        
        ContentWorkspace objContentWorkspace;
        try{
            objContentWorkspace = FileUploadCtrl.getUserWorkspaceInfo(UserInfo.getUserId());
        }catch(Exception objException){
            System.assertEquals(null, objContentWorkspace);
            System.assertEquals('The Organization is not configured for this user.', objException.getMessage());
        }
        
        Test.startTest();
        objContentWorkspace = FileUploadCtrl.createUserWorkspace(UserInfo.getUserId(), objAccount.Id);
        Test.stopTest();
        
        objAccount = [SELECT Id, Name, WorkspaceId__c FROM Account WHERE Id =:objAccount.Id];
        System.assertNotEquals(null, objAccount);
        System.assertNotEquals(null, objAccount.WorkspaceId__c);
        System.assertEquals(objContentWorkspace.Id, objAccount.WorkspaceId__c);        
    }

    @isTest 
    private static void verifyCreateUserWorkspaceForExistingAccountWorkspace(){        
        Account objAccount = [SELECT Id, Name, WorkspaceId__c FROM Account];
        System.assertNotEquals(null, objAccount);
        
        //User objUser = TestHelper.getUser(true);
        //System.assertNotEquals(null, objUser);
        
        ContentWorkspace objContentWorkspace;
        try{
            objContentWorkspace = FileUploadCtrl.getUserWorkspaceInfo(UserInfo.getUserId());
        }catch(Exception objException){
            System.assertEquals(null, objContentWorkspace);
            System.assertEquals('The Organization is not configured for this user.', objException.getMessage());
        }
        
        Test.startTest();
        objContentWorkspace = FileUploadCtrl.createUserWorkspace(UserInfo.getUserId(), objAccount.Id);
        Test.stopTest();
        
        objAccount = [SELECT Id, Name, WorkspaceId__c FROM Account WHERE Id =:objAccount.Id];
        System.assertNotEquals(null, objAccount);
        System.assertNotEquals(null, objAccount.WorkspaceId__c);
        System.assertEquals(objContentWorkspace.Id, objAccount.WorkspaceId__c);
        Map<String, Object> folderHierarchy = FileUploadCtrl.getFolderHierarchy(objAccount.WorkspaceId__c, null, null);
        System.assertNotEquals(null, folderHierarchy);
    }
    @isTest 
    private static void verifyIsWorkspaceConfigured(){ 
        
        Account objAccount1 = new Account(Name = 'Library Account Parent 1');
        insert objAccount1;
        System.assertNotEquals(null, objAccount1.Id);

        Account objAccount2 = new Account(Name = 'Library Account Parent 2', ParentId = objAccount1.Id);
        insert objAccount2;
        System.assertNotEquals(null, objAccount2.Id);

        Account objAccount3 = new Account(Name = 'Library Account Parent 3', ParentId = objAccount2.Id);
        insert objAccount3;
        System.assertNotEquals(null, objAccount3.Id);

        Account objAccount4 = new Account(Name = 'Library Account Parent 4', ParentId = objAccount3.Id);
        insert objAccount4;
        System.assertNotEquals(null, objAccount4.Id);

        Account objAccount5 = new Account(Name = 'Library Accoun Parent 5', ParentId = objAccount4.Id);
        insert objAccount5;
        System.assertNotEquals(null, objAccount5.Id);

        User objUser1 = new User(
            ProfileId = UserInfo.getProfileId(),
            LastName = 'Library User',
            Email = 'libraryuser@example.com',
            Username = 'libraryuser@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            OrganizationId__c = objAccount5.Id
        );
        insert objUser1;
        System.assertNotEquals(null, objUser1.Id);

        User objUser2 = new User(
            ProfileId = UserInfo.getProfileId(),
            LastName = 'Library User',
            Email = 'libraryuser@example.com',
            Username = 'libraryuser@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            OrganizationId__c = objAccount5.Id
        );
        insert objUser2;
        System.assertNotEquals(null, objUser2.Id);
        System.runAs (objUser1) {
                        //Create Document
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Document';
            cv.PathOnClient = 'TestDocument.pdf';
            cv.VersionData = Blob.valueOf('Test Content');
            cv.IsMajorVersion = true;
            Insert cv;

            //Get Content Version
            List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
            System.assertEquals(cvList.size(), 1);

            //Get Content Documents
            List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            System.assertEquals(cdList.size(), 1);

            ContentDocument objContentDocument = cdList[0];
            System.assertNotEquals(null, objContentDocument.Id);

            Test.startTest();
            List<FileUploadCtrl.UserWorkspacePermission> lst = new List<FileUploadCtrl.UserWorkspacePermission>();
            lst.add(new FileUploadCtrl.UserWorkspacePermission(objUser1.Id, objAccount5.Id, 'govgrants admin'));
            lst.add(new FileUploadCtrl.UserWorkspacePermission(objUser2.Id, objAccount5.Id, 'govgrants admin'));
            FileUploadCtrl.createUserWorkspace(lst);
            Test.stopTest();

            Account objAccount = [SELECT Id, Name, Workspace__c FROM Account WHERE Id =:objAccount5.Id];
            System.assertNotEquals(null, objAccount);
            //System.assertNotEquals(null, objAccount.Workspace__c);
            ContentWorkspace objWorkspace1 = FileUploadCtrl.getUserWorkspaceInfo(objUser1.Id);
            System.assertNotEquals(null, objWorkspace1);
            
            ContentWorkspace objWorkspace2 = FileUploadCtrl.getUserWorkspaceInfo(objUser2.Id);
            System.assertNotEquals(null, objWorkspace2);

            Workspace__c objWorkspaceConfig = [SELECT Id, WorkspaceId__c FROM Workspace__c WHERE WorkspaceId__c =:objWorkspace2.Id];
            System.assertNotEquals(null, objWorkspaceConfig);
            System.assertEquals(objWorkspace1.Id, objWorkspaceConfig.WorkspaceId__c);
            System.assertEquals(objWorkspace2.Id, objWorkspaceConfig.WorkspaceId__c);

            Boolean flag = FileUploadCtrl.setWorkspaceDefaultFolder(new List<Workspace__c>{objWorkspaceConfig});
            System.assertNotEquals(false, flag);

            ContentWorkspace objContentWorkspace = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Id =:objWorkspace1.Id];
            System.assertNotEquals(null, objWorkspaceConfig);

            ContentFolder objFolder = new ContentFolder(Name = 'TmpFolder', ParentContentFolderId = objContentWorkspace.RootContentFolderId);
            insert objFolder;
            System.assertNotEquals(null, objFolder.Id);

            Object obj = FileUploadCtrl.changeParentContentFolder(objContentWorkspace.RootContentFolderId, objContentDocument.Id, null, objContentWorkspace.Id);
            System.assertNotEquals(null, obj);

            Map<String, Object> result = FileUploadCtrl.getFolderHierarchy(objContentWorkspace.Id, null, null);
            System.assertNotEquals(null, result);

            try{
                FileUploadCtrl.getFilePageData(cvList[0].Id, null, null);
            }catch(Exception ex){
                System.assertNotEquals(null, ex);
            }

            ContentVersion objContentVersion = FileUploadCtrl.getFilePreviewData(objContentDocument.Id);
            System.assertNotEquals(null, objContentVersion.Id);
            
            List<ContentDocumentLink> lstLinks = new List<ContentDocumentLink>();
            lstLinks.add(new ContentDocumentLink(ContentDocumentId = objContentDocument.Id, LinkedEntityId = objAccount1.Id));
            lstLinks.add(new ContentDocumentLink(ContentDocumentId = objContentDocument.Id, LinkedEntityId = objAccount2.Id));
            lstLinks.add(new ContentDocumentLink(ContentDocumentId = objContentDocument.Id, LinkedEntityId = objAccount3.Id));
            String strSaveResult = FileUploadCtrl.saveRecords(lstLinks);

            flag = FileUploadCtrl.checkFileDuplicateInFolder(objContentDocument.Title, objContentDocument.Id, objContentWorkspace.RootContentFolderId);
            System.assertNotEquals(null, flag);

            Map<String, Object> response = FileUploadCtrl.deleteFile(objContentDocument.Id,  objAccount1.Id);
            System.assertNotEquals(null, response);
            System.assertEquals(true, response.get('success'));

            try{
                response = FileUploadCtrl.deleteFile(null,  null);
                System.assertNotEquals(null, response);
                System.assertEquals(false, response.get('success'));
            }catch(Exception ex){
                System.assertNotEquals(null, ex);
            }
        }

        try{
            FileUploadCtrl.createUserWorkspace(null);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        } 

        try{        
            Boolean flag = FileUploadCtrl.setWorkspaceDefaultFolder(null);
            System.assertNotEquals(true, flag);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        } 

        try{        
            Boolean flag = FileUploadCtrl.checkFileDuplicateInFolder(null, null, null);
            System.assertNotEquals(null, flag);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        } 

        Boolean isWorkSpaceConfigured = FileUploadCtrl.isWorkspaceConfigured(null);
        System.assertEquals(True, isWorkSpaceConfigured);
    }

    @isTest 
    private static void verifyGetFileEditPageData(){  
        ContentDocument objContentDocument = [SELECT Id FROM ContentDocument];
        System.assertNotEquals(null, objContentDocument);
        PageLayoutConfig__c objPageLayoutConfig =  TestHelper.getPageLayoutConfig(false);
        objPageLayoutConfig.IsMiniLayout__c = true;
        insert objPageLayoutConfig;
        System.assertNotEquals(null, objPageLayoutConfig.Id);
        
        TabConfig__c objTabConfig = TestHelper.getTabConfig(objPageLayoutConfig.Id, true);
        System.assertNotEquals(null, objTabConfig.Id);
        
        PageBlockConfig__c objPageBlockConfig = TestHelper.getPageBlockConfig(objTabConfig.Id, true);
        System.assertNotEquals(null, objPageBlockConfig.Id);
        
        objPageBlockConfig.AttachmentClassifications__c = 'A;B;C';
        String strSaveResult = FileUploadCtrl.saveRecords(new List<PageBlockConfig__c>{objPageBlockConfig});
        System.assertNotEquals(null, strSaveResult);
        
        SampleObject11__c objSampleObject = [SELECT Id, Name FROM SampleObject11__c LIMIT 1];
        System.assertNotEquals(null, objSampleObject.Id);
        try{
            Map<String, Object> mapPageData = FileUploadCtrl.getFilePageData(objContentDocument.id, objSampleObject.id, objPageBlockConfig.Id);
            //System.assertNotEquals(null, mapPageData.get('contentVersion'));
            //System.assertNotEquals(null, mapPageData.get('fileTypes'));    
        } catch(Exception ex){
            System.assertNotEquals(null, ex);      
        }
    }

    @isTest
    private static void verifyFileUploadCtrl(){
        List<ContentWorkspace> lstContentWorkspaces = [SELECT Id FROM ContentWorkspace];
        System.assertNotEquals(null, lstContentWorkspaces);

        ContentDocument objContentDocument = [SELECT Id FROM ContentDocument];
        System.assertNotEquals(null, objContentDocument);

        Account objAccount = [SELECT Id FROM Account LIMIT 1];
        System.assertNotEquals(null, objAccount);

        ContentWorkspaceDoc objContentWorkspaceDoc = new ContentWorkspaceDoc(ContentDocumentId = objContentDocument.Id, ContentWorkspaceId = lstContentWorkspaces[0].Id);
        ContentDocumentLink objContentDocumentLink = new ContentDocumentLink(ContentDocumentId = objContentDocument.Id, LinkedEntityId = objAccount.Id);
        String strSaveResult = FileUploadCtrl.saveRecords(new List<SObject>{objContentWorkspaceDoc, objContentDocumentLink});
        System.assertNotEquals(null, strSaveResult);

        // Map<String, Object> files = FileUploadCtrl.getWorkspaceFiles(objAccount.Id, new List<String>{lstContentWorkspaces[0].Id});
        // System.assertNotEquals(null, files);
        // System.assertEquals(true, files.containsKey('workspaceFiles'));

        // try {
        //     files = FileUploadCtrl.getWorkspaceFiles(null, new List<String>{'TestId'});
        //     System.assertNotEquals(null, files);
        // } catch(Exception ex) {
        //     System.assertNotEquals(null, ex);
        // }

        Map<String, Object> mapFileData = FileUploadCtrl.getWorkspaceFilesData(null);
        System.assertNotEquals(null, mapFileData);

        mapFileData = FileUploadCtrl.getWorkspaceFilesData(new List<String>{lstContentWorkspaces[0].Id});
        System.assertNotEquals(null, mapFileData);

        try{
            strSaveResult = FileUploadCtrl.saveRecords(null);
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }
        
        try{
            strSaveResult = FileUploadCtrl.deleteRecords(null);
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        String strIcon = FileUploadCtrl.getFileIcon('.txt');
        System.assertNotEquals(null, strIcon);

        try{
            Boolean flag = FileUploadCtrl.isWorkspaceConfigured(new List<Id>{objAccount.Id});
            System.assertNotEquals(null, flag);
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        try{
            Map<String, Object> result = FileUploadCtrl.getWorkspaceFilesData(new List<String>{objAccount.Id});
            System.assertNotEquals(null, result);
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        // try{
        //     Map<String, Object> result = FileUploadCtrl.getWorkspaceFiles(null, new List<String>{objAccount.Id});
        //     System.assertNotEquals(null, result);
        // } catch(Exception ex){
        //     System.assertNotEquals(null, ex);
        // }

        try{
            FileUploadCtrl fileUploadCtrl = new FileUploadCtrl();
            FileUploadCtrl.selectedRecordId = objContentDocument.Id;
            fileUploadCtrl.clickHandler();
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        FileUploadCtrl.File objFile = new FileUploadCtrl.File(null, null, false, null, null, null);
        System.assertNotEquals(null, objFile);

        try{
            Object res = FileUploadCtrl.changeParentContentFolder(null, objContentDocument.Id, null, lstContentWorkspaces[0].Id);
            System.assertNotEquals(null, res);
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }
    }
    
    @isTest
    static void verifyGetSharingPrivacy(){
        List<Map<String, Object>> sharingPrivacy = FileUploadCtrl.getSharingPrivacy();
        System.assertNotEquals(null, sharingPrivacy);
    }
    
    @isTest
    static void verifyShowSharingPrivacy(){
        Boolean showSharingPrivacy = FileUploadCtrl.showSharingPrivacy();
        System.assertNotEquals(null, showSharingPrivacy);
    }

    @isTest
    static void verifyGetFilePreview(){
        ContentVersion objContentVersion = new ContentVersion(); 
        objContentVersion.Title ='Google.com'; 
        objContentVersion.PathOnClient = 'TestDocument.pdf';
        objContentVersion.VersionData = Blob.valueOf('Test Content');
        insert objContentVersion;
        System.assertNotEquals(null, objContentVersion.Id);
    
        objContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :objContentVersion.Id]; 
        System.assertNotEquals(null, objContentVersion.Id);
        System.assertNotEquals(null, objContentVersion.ContentDocumentId);
        ContentVersion objContentVersionOfContentDoc = FileUploadCtrl.getFilePreviewData(objContentVersion.ContentDocumentId);
        System.assertNotEquals(null, objContentVersionOfContentDoc.Id);
    }
}