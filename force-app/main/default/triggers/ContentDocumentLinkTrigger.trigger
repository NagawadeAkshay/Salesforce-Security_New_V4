/**
 * Created by Dipak on 30-12-2020.
 */

trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    // User Story 120423: NED - Salesforce Files - Allow support to upload files in User's private library
    // Moved this Trigger Logic in FileUploadCtrl.updateContentVersion method
    /*
    if(FeatureManagement.checkPermission('UploadFileToPrivateLibrary')){
        for (ContentDocumentLink obj : Trigger.new) {
            obj.Visibility = 'AllUsers';
        }
    }
    */
}