/*
    This class has methods to execute methods related to Workspace Trigger 
    **********************************************************
    Audit History
    **********************************************************
    21-January-2020  Dipak Pawar       Created
  
    **********************************************************  
*/
public with sharing class WorkspaceTriggerHelper extends TriggerHelper {
    public override void processBeforeInsert() {
        syncFolderNameAndId();
    }

    public override void processBeforeUpdate() {
        syncFolderNameAndId();
    }

    private static void syncFolderNameAndId() {
        Map<String, Workspace__c> mapDefaultFolderNames = new Map<String, Workspace__c>();
        Set<String> setFolderNames = new Set<String>();
        Set<Id> setWorkspaceIds = new Set<Id>();

        //Get overall hierarchy to get ContentFolders based on ContentWorkspace for "Bug 70637: Internal:File- Error display when we set as Default folder if the same folder name exists in any library"
        Map<String, Object> folderHierarchy = FileUploadCtrl.getFolderHierarchy(null, null, null);
        Map<Id, Map<String, ContentFolder>> mapWorkspaceFolders = new Map<Id, Map<String, ContentFolder>>();
        if (folderHierarchy != null && folderHierarchy.containsKey('mapWorkspaceContentFolders')) {
            Map<Id, List<ContentFolder>> mapWorkspaceContentFolders = (Map<Id, List<ContentFolder>>) folderHierarchy.get('mapWorkspaceContentFolders');
            for (Id workspaceId : mapWorkspaceContentFolders.keySet()) {
                for (ContentFolder objContentFolder : mapWorkspaceContentFolders.get(workspaceId)) {
                    if (mapWorkspaceFolders.containsKey(workspaceId)) {
                        mapWorkspaceFolders.get(workspaceId).put(objContentFolder.Name.toLowerCase(), objContentFolder);
                    } else {
                        mapWorkspaceFolders.put(workspaceId, new Map<String, ContentFolder>{objContentFolder.Name.toLowerCase() => objContentFolder});
                    }
                }
            }
        }
        for (Workspace__c objWorkspace : (List<Workspace__c>) Trigger.new) {
            if (String.isNotBlank(objWorkspace.DefaultFolderName__c)) {
                setFolderNames.add(objWorkspace.DefaultFolderName__c);
            }
            setWorkspaceIds.add(objWorkspace.WorkspaceId__c);
        }

        Map<Id, ContentWorkspace> mapContentWorkspace = new Map<Id, ContentWorkspace>([SELECT Id, Name, RootContentFolderId FROM ContentWorkspace WHERE Id IN :setWorkspaceIds WITH USER_MODE]);
        List<ContentFolder> lstContentFoldersToCreate = new List<ContentFolder>();
        Boolean folderFlag = false;
        Integer configIndex = 0, folderIndex = 0;
        Map<Integer, Integer> tmpIndex = new Map<Integer, Integer>();

        for (Workspace__c objWorkspace : (List<Workspace__c>) Trigger.new) {
            ContentWorkspace objContentWorkspace = mapContentWorkspace.get(objWorkspace.WorkspaceId__c);
            objWorkspace.Name = objContentWorkspace.Name;
            if (String.isNotBlank(objWorkspace.DefaultFolderName__c) && !objWorkspace.IsSystem__c) {
                if (mapWorkspaceFolders.containsKey(objWorkspace.WorkspaceId__c) && mapWorkspaceFolders.get(objWorkspace.WorkspaceId__c).containsKey(objWorkspace.DefaultFolderName__c.toLowerCase())) {
                    objWorkspace.DefaultFolderId__c = mapWorkspaceFolders.get(objWorkspace.WorkspaceId__c).get(objWorkspace.DefaultFolderName__c.toLowerCase()).Id;
                    objWorkspace.DefaultFolderName__c = mapWorkspaceFolders.get(objWorkspace.WorkspaceId__c).get(objWorkspace.DefaultFolderName__c.toLowerCase()).Name;
                    folderFlag = true;
                } else if (!objWorkspace.DefaultFolderName__c.equalsIgnoreCase(objContentWorkspace.Name)) {
                    ContentFolder objContentFolder = new ContentFolder();
                    if(Schema.sObjectType.ContentFolder.fields.Name.isCreateable()){
                        objContentFolder.Name = objWorkspace.DefaultFolderName__c;
                    }
                    objContentFolder.ParentContentFolderId = objContentWorkspace.RootContentFolderId;
                    objWorkspace.DefaultFolderId__c = objContentFolder.Id;
                    lstContentFoldersToCreate.add(objContentFolder);
                    folderFlag = true;
                    tmpIndex.put(configIndex, folderIndex++);
                }
            }
            if (!folderFlag && !objWorkspace.IsSystem__c) {
                objWorkspace.DefaultFolderId__c = objContentWorkspace.RootContentFolderId;
                objWorkspace.DefaultFolderName__c = objContentWorkspace.Name;
            }
            configIndex++;
        }
        if (!lstContentFoldersToCreate.isEmpty() && Schema.sObjectType.ContentFolder.isCreateable() && ContentFolder.sObjectType.getDescribe().isAccessible() == true) {
            insert as user lstContentFoldersToCreate;
            configIndex = 0;
            for (Workspace__c objWorkspace : (List<Workspace__c>) Trigger.new) {
                if (tmpIndex.containsKey(configIndex) && !objWorkspace.IsSystem__c) {
                    objWorkspace.DefaultFolderId__c = lstContentFoldersToCreate[tmpIndex.get(configIndex)].Id;
                }
                configIndex++;
            }
        }
        for (Workspace__c objWorkspace : (List<Workspace__c>) Trigger.new) {
            objWorkspace.IsSystem__c = false;
        }
    }
}