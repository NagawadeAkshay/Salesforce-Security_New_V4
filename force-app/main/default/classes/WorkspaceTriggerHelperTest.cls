@isTest
private class WorkspaceTriggerHelperTest {

    @isTest
    static void verifyWorkspaceTriggerHelper() { 
        List<ContentWorkspace> lstLibraries = new List<ContentWorkspace>();       
        User objUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (objUser) {            
            lstLibraries.add(new ContentWorkspace(
                Name = 'Test Library'
            ));
            insert lstLibraries;
            for(ContentWorkspace objLibrary : lstLibraries){
                System.assertNotEquals(null, objLibrary.Id);
            }
        }
        
        Test.startTest();
        lstLibraries = [SELECT Id, Name, RootContentFolderId FROM ContentWorkspace];
        System.assertNotEquals(0, lstLibraries.size());
        
        List<Workspace__c> lstConfigWorkspace = new List<Workspace__c>();        
        for(ContentWorkspace objLibrary : lstLibraries){
            lstConfigWorkspace.add(new Workspace__c(
                WorkspaceId__c = objLibrary.Id,
                DefaultFolderId__c = objLibrary.RootContentFolderId,
                DefaultFolderName__c = objLibrary.Name
            ));
        }
        insert lstConfigWorkspace;
        Test.stopTest();

        lstConfigWorkspace = new List<Workspace__c>([SELECT Id, WorkspaceId__c, DefaultFolderId__c, DefaultFolderName__c FROM Workspace__c]);
        System.assertNotEquals(null, lstConfigWorkspace);
        System.assertNotEquals(0, lstConfigWorkspace.size());
        Integer iIndex = 1;
        for(Workspace__c objConfigWorkspace : lstConfigWorkspace){
            System.assert(String.isNotBlank(objConfigWorkspace.WorkspaceId__c));
            System.assert(String.isNotBlank(objConfigWorkspace.DefaultFolderName__c));
            objConfigWorkspace.DefaultFolderName__c = 'Folder-'+iIndex;
            iIndex++;
        }
        update lstConfigWorkspace;

        lstConfigWorkspace = new List<Workspace__c>([SELECT Id, WorkspaceId__c, DefaultFolderId__c, DefaultFolderName__c FROM Workspace__c]);
        System.assertNotEquals(null, lstConfigWorkspace);
        System.assertNotEquals(0, lstConfigWorkspace.size());
        for(Workspace__c objConfigWorkspace : lstConfigWorkspace){
            System.assert(String.isNotBlank(objConfigWorkspace.WorkspaceId__c));
            System.assert(String.isNotBlank(objConfigWorkspace.DefaultFolderName__c));
            System.assert(String.isNotBlank(objConfigWorkspace.DefaultFolderName__c));
        }
    }
}