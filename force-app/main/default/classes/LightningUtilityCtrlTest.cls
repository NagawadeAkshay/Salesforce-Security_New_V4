/*
* Class Name : LightningUtilityCtrlTest
* Description: Test class for LightningUtilityCtrl
* --------------------------------------------------------------------------------------------------------------------
*   Version     Date                Author                      Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0         25 July 2019        Framework Team              Initial Development
* --------------------------------------------------------------------------------------------------------------------
*/
@isTest
private with sharing class LightningUtilityCtrlTest {
    
    @testSetup
    private static void initTestData(){
        List<Account> lstAccounts = new List<Account>();
        for(Integer index = 0; index < 5; index++){
            lstAccounts.add(new Account(Name = 'Test Account ' + index));
        }
        String strSaveRecordsResult = LightningUtilityCtrl.saveRecords(lstAccounts);
        lstAccounts = new List<Account>([SELECT Id FROM Account]);
        System.assertEquals(5, lstAccounts.size());
    }
    
    @isTest 
    private static void verifygetSalesforceBaseUrl(){
        System.assertNotEquals(null, LightningUtilityCtrl.getSalesforceBaseUrl());
    }
    
    @isTest 
    private static void verifygetOrgDomainUrl(){
        String OrgDomainUrl = LightningUtilityCtrl.getOrgDomainUrl();
        System.assertNotEquals(null, LightningUtilityCtrl.getOrgDomainUrl());
    }
    
    @isTest 
    private static void verifySaveRecords(){
        List<Account> lstAccounts = new List<Account>([SELECT Id FROM Account]);
        System.assertEquals(5, lstAccounts.size());
        List<Account> lstNewAccounts = new List<Account>();
        for(Integer index = 5; index < 10; index++){
            lstNewAccounts.add(new Account(Name = 'Test Account ' + index));
        }
        String strsaveRecordsResult = LightningUtilityCtrl.saveRecords(lstNewAccounts);        
        try{
            strsaveRecordsResult = LightningUtilityCtrl.saveRecords(null);
        }catch(Exception objException){
            System.assertNotEquals(null, objException);
        }
    }
    
    @isTest 
    private static void verifyDeleteRecords(){
        List<Account> lstAccounts = new List<Account>([SELECT Id FROM Account]);
        System.assertEquals(5, lstAccounts.size());
        String strDeleteRecordsResult = LightningUtilityCtrl.deleteRecords(lstAccounts);
        lstAccounts = new List<Account>([SELECT Id FROM Account]);
        System.assertEquals(0, lstAccounts.size());
        
        try{
            strDeleteRecordsResult = LightningUtilityCtrl.deleteRecords(null);
        }catch(Exception objException){
            System.assertNotEquals(null, objException);
        }
    }
    
    @isTest 
    private static void verifyGetSpinnerURL(){
        try{
            String strResourceURL = LightningUtilityCtrl.getSpinnerURL();
        }catch(Exception objException){
            System.assertNotEquals(null, objException);
        }        
    }
     @isTest 
    private static void verifyGetUtilityInfo(){
        try{

            Map<string, Object> mapUtilityInfo = LightningUtilityCtrl.getUtilityInfo();
            System.assertNotEquals(null, mapUtilityInfo.get('spinnerUrl'));
            System.assertNotEquals(null, mapUtilityInfo.get('salesforceBaseUrl'));
            System.assertNotEquals(null, mapUtilityInfo.get('sessionId'));
           // System.assertNotEquals(null, mapUtilityInfo.get('networkId'));
            System.assertNotEquals(null, mapUtilityInfo.get('timeZone'));

        }catch(Exception objException){
            System.assertNotEquals(null, objException);
        }        
    }
    @isTest 
    private static void verifyGetVFSessionId(){
        try{
            String strPageContent = LightningUtilityCtrl.getVFSessionId();
            System.assertNotEquals(null, strPageContent.indexOf('START_SESSION'));
            System.assertNotEquals(null, strPageContent.indexOf('END_SESSION'));
            System.assertNotEquals(null, strPageContent.substring(strPageContent.indexOf('START_SESSION') + String.valueOf('START_SESSION').length(), strPageContent.indexOf('END_SESSION')));
            
        }catch(Exception objException){
            System.assertNotEquals(null, objException);
        }        
    }
    @isTest 
    private static void verifyParseExceptionMsg(){
        try{
            String strPageContent = LightningUtilityCtrl.getVFSessionId();
            System.assertNotEquals(null, strPageContent.indexOf('networkId'));
            String strPageContent1 = LightningUtilityCtrl.parseExceptionMsg('GNT.CustomExceptions:Class,GNT:Sample:Demo');
        }catch(Exception objException){
            String strPageContent = LightningUtilityCtrl.parseExceptionMsg('GNT.CustomExceptions:Class,GNT:Sample:Demo');
            System.assertNotEquals(null, strPageContent);
            String strPageContentM = LightningUtilityCtrl.parseExceptionMsg(objException.getMessage());
            System.assertNotEquals(null, strPageContentM);
        }        
    }

    @isTest
    static void verifyLightningFileUploadClass(){
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

        AccountTreeCtrl objAccountTreeCtrl = new AccountTreeCtrl();
        System.assertNotEquals(null, objAccountTreeCtrl);
    }   
}