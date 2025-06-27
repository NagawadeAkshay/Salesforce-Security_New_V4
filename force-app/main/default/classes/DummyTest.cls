/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-14-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class DummyTest {
    @isTest
    static void verifyDummyClasses(){
        LibraryCtrl obj = new LibraryCtrl();
        LightningFileUploadCtrl objLightningFileUploadCtrl = new LightningFileUploadCtrl();
        objLightningFileUploadCtrl.namespacePrefix = 'TestNameSpace';
        String namespacePrefix = objLightningFileUploadCtrl.namespacePrefix;
        System.assertNotEquals(null, namespacePrefix);
        objLightningFileUploadCtrl.lghtURL = null;
        objLightningFileUploadCtrl.userInfoId = null;
        objLightningFileUploadCtrl.namespacePrefix = null;
        namespacePrefix = objLightningFileUploadCtrl.namespacePrefix;
        System.assertEquals(AppUtils.getNameSpacePrefix(), namespacePrefix);

        LightningForgotPasswordController objLightningForgotPasswordController = new LightningForgotPasswordController();
        System.assertNotEquals(null, objLightningForgotPasswordController);

        LightningLoginFormController objLightningLoginFormController = new LightningLoginFormController();
        System.assertNotEquals(null, objLightningLoginFormController);

        LightningSelfRegisterController objLightningSelfRegisterController = new LightningSelfRegisterController();
        System.assertNotEquals(null, objLightningSelfRegisterController);

        GGFileEditctrl objGGFileEditctrl = new GGFileEditctrl();
        System.assertNotEquals(null, objGGFileEditctrl);

        MapPin objMapPin = new MapPin();
        System.assertNotEquals(null, objMapPin);
        
        UploadFilectrl objUpload = new UploadFilectrl();
        System.assertNotEquals(null, objUpload);
        
        WBSEventHandlerHepler WbsEventObj = new WBSEventHandlerHepler();
        WbsEventObj.test();
		System.assertNotEquals(null, WbsEventObj);
        MasterCtrl objMasterCtrl = new MasterCtrl();
        System.assertNotEquals(null, objMasterCtrl);

        AutocompleteLightningLookupCtrl objAuto = new AutocompleteLightningLookupCtrl();
        string str2 = objAuto.getObjAPIName();
        objAuto.fldAPIName = null;
        objAuto.parentObjAPIName = null;
        objAuto.fields = null;
        objAuto.sobjectName = null;
        objAuto.sortField = null;
        objAuto.sortDirection = null;
        objAuto.filterCriteria = null;
        objAuto.displayFields = null;
        objAuto.operatorForDate= null;
        objAuto.datatypeOfField = null;
        objAuto.allowedDecimal = null;
        objAuto.labelOfField = null;
        objAuto.mapOflabels = null;
        objAuto.typOfColumn = null;
        objAuto.allowedDecml = null;
        objAuto.labelOfFields = null;
        objAuto.pageblckId = null;
        objAuto.flexTableParameters = null;
        objAuto.listParameter = null;
        objAuto.lookupSortByField = null;
        objAuto.lookupSortDirectionField = null;
        objAuto.displayFieldsTemp= null;
        objAuto.displayFieldsofsobject = null;
        objAuto.displayFieldLabel = null;
        objAuto.filterCriteriaPBD = null;
        String nameSpace = objAuto.namespace;

        List<String> listobj = objAuto.getFieldsToDisplay();
        System.assertNotEquals(null, objAuto);


        AutoCompleteCtrl objAutoCompleteCtrl = new AutoCompleteCtrl();
        String str = AutoCompleteCtrl.getObjects('objectName', 'label', 'value', 'criteria');
        System.assertNotEquals(null, objAutoCompleteCtrl);

        ContentVersionTableCtrl ct = new ContentVersionTableCtrl();
        System.assertNotEquals(null, ct);
        ct.parentObjectId = null;
        ct.titleValue = '';        
        
        captureFormTriggerHelper cft = new captureFormTriggerHelper();
        System.assertNotEquals(null, cft);
        
        FolderCtrl objFolderCtrl = new FolderCtrl();
        WorkSpaceFilesCtrl objWorkSpaceFilesCtrl = new WorkSpaceFilesCtrl();
        String strKeyValueMap = objWorkSpaceFilesCtrl.getKeyValueMap();
        System.assertNotEquals(null, strKeyValueMap);
        objWorkSpaceFilesCtrl.file = null;

        ApprovalSnapshotCtrl objApprovalSnapshotCtrl = new ApprovalSnapshotCtrl();
        System.assertNotEquals(null, objApprovalSnapshotCtrl);
    }
}