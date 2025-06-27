/*
    Below class is used to display existing files from workspace and to save selected file to business records. 
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    Prajakta Gadhe          Created
    ****************************************************************************************
*/


public with sharing class GGWorkSpaceCtrl{

@auraEnabled
    public static void initData1(String contentVersionId,String parentId) {
       Id conDoc = [Select ContentDocumentId from ContentVersion where id =:contentVersionId WITH USER_MODE].ContentDocumentId; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
        if(Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()){
        cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        }
        //cDe.Visibility = 'AllUsers';
        if(ContentDocumentLink.sObjectType.getDescribe().isAccessible() == true && Schema.sObjectType.ContentDocumentLink.isCreateable()){
        insert as user cDe;
        }
    }
}