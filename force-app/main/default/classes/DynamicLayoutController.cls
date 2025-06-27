/**
* Class to handle the DynamicLayout component
* 1. Inputs Expected: PageTemplateName & RecordID   rcrdId
* 2. DynamicLayout will decide which component to render - DynamicEditLayout or DynamicViewLayout based on Component's Type Attribute 
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 02/05/2014    Kunal Shah      Created
* 02/26/2014    Kunal Shah      Created layoutType Attribute
* 09/13/2015    Shah Kadirmohideen  Refactored the methods
* =============================================================================
*/

global with sharing class DynamicLayoutController {

    //Properties    
    global transient string tmplName {get; set;}
    global transient string phaseName {get; set;}  //User Story 110688: Internal - Enhancement - Side bar vanishes after clicking on links from the regular Email or outlook - Part2
    global transient string pkgName {get; set;}
    global string parId {get; set;}
    global string pkgId {get; set;}
    global transient string pckgName {get;set;}
    global transient Double currentOrder{get;set;}
    global transient Double lastFormOrder{get;set;}
    global transient string formnumber {get; set;}
    global transient string formversion {get; set;}
    global string parentLytId {get;set;}
    global transient List<string> formTypeList {get; set;}
    global List<SelectOption> formTypeList1 {get; set;} // cannot make transient used in dynamic forms
    global string rcrdId {get; set;}
    public static set<String> fieldsToHide = new set<String>();
    global PageTemplate__c pageTemplate {get;set;}
    global string type {get; set;}
    global DynamicLayoutHolder layoutHolder {get;set;} 
    public transient Boolean RenderDownloadPDFMenuAsButton{get; set;}
    public transient Boolean renderModalDownloadPDFAsButton{get;set;}
    global transient string flexTableParameterJSONChanged  {get;set;}
    public transient string ckeditorMessage  {get;set;}
    global transient String themeDocumentId {get; set;}
    public String bulbIconInstruction{get;set;}
    public transient Boolean isPreviewLayout {get;set;}
    public transient Boolean isNotApplicable {get;set;}
    public transient Boolean isMandatory{get;set;}
    public transient Boolean refreshLayoutSpecificTables {get;set;}
    public transient Boolean hideBlankRelatedList{get;set;}
    public String standardObjRqrdFlds{get;set;}

    public DateTime lastmodifieddateonloadofpage {get;set;}
    public boolean recordTypeExists {
        get{
         if(recordTypeExists == null ) {
               try {
                    checkIfRecordTypePresent();   
                    checkFormIsApplicable(); 
               } catch(Exception ex) {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex.getMessage())));
               }
            }
          return recordTypeExists;
        }
        set;
        
    } 
    global PageReference savePage {get;set;}
    global PageReference cancelPage {get;set;}
    global PageReference deletePage {get;set;}
    global string layoutId {get;set;}
    global string header {get;set;}

    public Boolean isUpdateable {get;set;}
    @TestVisible private boolean isCustomHeader;
    public Boolean isDeletable {get;set;}
    public string subHeader {get;set;}
    global  List<DynamicLayoutDefaultValueHelper> listDefaultValues {get;set;}
    public List<RecordTypeWrapper> recordTypeWrapper {get;set;}
    public DynamicRecordCompletion recordCompletion {get;set;}
    public string selectedRecordTypeId {get;set;}
    public transient set<string> getterCallList = new set<string>();
    global transient String flexTableParameters {get{
        if(flexTableParameters != null && !string.isBlank(flexTableParameters)  && ((getterCallList != null && !getterCallList.contains('flexTableParameters'))  || (getterCallList == null) )){
            if(getterCallList == null){
                getterCallList  = new set<string>();
            }
            getterCallList.add('flexTableParameters');
            return SFDCEncoder.sanitizeJSON(flexTableParameters);
        } 
        return flexTableParameters;
    }set;}
    global String flexTableParameterJSON{get{
        if(flexTableParameterJSON != null && !string.isBlank(flexTableParameterJSON) && ((getterCallList != null && !getterCallList.contains('flexTableParameterJSON'))  || (getterCallList == null) )){
            if(getterCallList == null){
                getterCallList  = new set<string>();
            }
            getterCallList.add('flexTableParameterJSON');
            return SFDCEncoder.sanitizeJSON(flexTableParameterJSON);
        } 
        return flexTableParameterJSON;
    }set;}
    global String listParameters{get{
        if(listParameters!= null  &&  !string.isBlank(listParameters)  && ((getterCallList != null && !getterCallList.contains('listParameters'))  || (getterCallList == null) )){
            if(getterCallList == null){
                getterCallList  = new set<string>();
            }
            getterCallList.add('listParameters');
            return SFDCEncoder.sanitizeJSON(listParameters);
        } 
        return listParameters;
    }set;}
    global transient String listParams{get{
        if(listParams != null && !string.isBlank(listParams)  && ((getterCallList != null && !getterCallList.contains('listParams'))  || (getterCallList == null) )){
            if(getterCallList == null){
                getterCallList  = new set<string>();
            }
            getterCallList.add('listParams');
            return SFDCEncoder.sanitizeJSON(listParams);
        } 
        return listParams;
    }set;}
    // need to delete
    global transient String chartParameters {get{
        if(chartParameters != null && !string.isBlank(chartParameters)  && ((getterCallList != null && !getterCallList.contains('chartParameters'))  || (getterCallList == null) )){
            if(getterCallList == null){
                getterCallList  = new set<string>();
            }
            getterCallList.add('chartParameters');
            return SFDCEncoder.sanitizeJSON(chartParameters);
        } 
        return chartParameters;
    }set;}
    public transient String chartParameter {get{
        if(chartParameter != null && !string.isBlank(chartParameter)  && ((getterCallList != null && !getterCallList.contains('chartParameter'))  || (getterCallList == null) )){
            if(getterCallList == null){
                getterCallList  = new set<string>();
            }
            getterCallList.add('chartParameter');
            return SFDCEncoder.sanitizeJSON(chartParameter);
        } 
        return chartParameter;
    }set;}
    global string selectedPageLayoutId {get;set;}
    global transient string windowTitle {get;set;}
    public transient string appLabel {get;set;}
    public Package__c packageObj{get; set;}
    public List<Package__c> packages {get; set;}
    public transient String currentTabLabelName {get; set;}
    public transient PhaseConfig__c phaseConfig {get; set;}

    public string recordTypeName {get;set;}
    public  Boolean hideContextSpecificSidebar {get; set;}
    public boolean hasReadAccess {get{
        if(hasReadAccess == null ) { 
            try {            
                checkRecordLevelAccess();
            }catch(Exception ex) {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex.getMessage())));
            }
        }
        return hasReadAccess;
        } set;}
    public transient boolean hasEditAccess {get; set;}
    global Boolean enableNativeLayoutFromDynamicLayout{get;set;}
    global boolean hasDeleteAccess {get; set;}
    global String accessMessage {get; set;}
    global Boolean hasErrors {get; set;}
    private String cancelURL;
    private string paremeterMap;
    global string pageBlockIds{get;set;}
    private List<String>pageBlockIdLst;
    private String editId;
    global boolean hideSidebarUser {get;set;}
    public String namespace {get;set;}
    private string editRecordTypeId;
    Id viewLayoutId,editLayoutId,printLayoutId ;
    global String currentPageURL{get;set;}  
    global String keyValueMapForFlexTable{get;set;}
    public Boolean isErrorNotFound {get;set;}
    public boolean isError {get;set;}
    public String emailMessage {get;set;}
    public boolean errorReported{get;set;}
    @TestVisible private String actionId;
    private String className;
    private String promptDailogVal;
    public ID tabId{get;set;}
    public String sObjectName{get;set;}
    
    public Boolean isRecordAccess {get;set;}
   
    public  string formDisplayType{get;set;}//for FormStep Config
    //public  Integer seqNum;
    global  transient Integer sequenceNumber{get;set;}
    //public  String prevStepId{get;set;}
    //public  String startStepNum{get;set;}
    //public Boolean isLastStep{get;set;}
    public List<Id> formpreviewList{get;set;}
    public string formUrl{get;set;}
    public String previewLayoutId{get;set;} //for form preview in planning
    global String formSaved{get;set;}
    public Boolean formIsValidated{get;set;}
    public String formInstanceId{get;set;}
    global transient Integer AutopromptTimer{get;set;}
    private transient Boolean disableRecordLocking{get; set;}
    global transient Boolean autoPromptEnable{get;set;}
    public transient Boolean cancelPromptEnable{get;set;}
    public Boolean isModal{get;set;}
    public transient string headerBackButton{get;set;}
	// if we move this variable to DynamiclayoutHolder then it will break dependat piclist as page message component is called multiple times.
    public String errorMsgMap{
            get{
                if(String.isEmpty(errorMsgMap) == true) {
                    if(layoutHolder != null) {
                        errorMsgMap = layoutHolder.fieldLabelMap;
                    } else {
                        errorMsgMap = '';
                    }
                }
                return errorMsgMap;
            }
        set;}
    public Boolean enableOldSidebar { get; private set; }
    // This Variable used to switch approval decision component at bottom.
    public Boolean switchApprovalCompButtom{get;set;}
    public Boolean enableModalHeaderActionButtons{get;set;}
    public String govGrants {
        get;
        set;
    }
    public String govGrantsExternal {
        get;
        set;
    }
    public String tooltipster {
        get;
        set;
    }
    /* US - 199729 START  */ 
    public Boolean isFormsPresent{get;set;}
    public Boolean isFrmsContainValidateRTBtn{get;set;}
    public static Boolean skipFormSpecificValidations;
    public static Map<String,Object> result = new Map<String,Object>();
    /* US - 199729 END  */
     public Boolean isFormsURL{get;set;} // Bug 182667 
    public static String requiredForSubmitIconCSS{get;set;}
    // User Story 123898: Internal - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users
    public Boolean skipUpdateAccessCheckForGuestUser{get;set;}
public  transient  Boolean isLwc{get;set;}
public  transient  Boolean isLwcStepProgressbar{get;set;}
    // CustomLookup Save Action Related issue is Resolved Using addEventListener

    public void setlwcSelectedRecordId(String n) {
        lwcSelectedRecordId = n;
    }
    public String getlwcSelectedRecordId() {
        return lwcSelectedRecordId;
    }
    public void setlwcFieldApiName(String n) {
        lwcFieldApiName = n;
    }
    public String getlwcFieldApiName() {
        return lwcFieldApiName;
    }
    private String lwcSelectedRecordId = '';
    private String lwcFieldApiName = '';

    public PageReference LwcEventHandlerMethod() {
        if(layoutHolder.objName != null){
            SObject updatedLayoutHolder = layoutHolder.recordMap.get(layoutHolder.objName);
            if(lwcFieldApiName != null && lwcSelectedRecordId != null ){
                updatedLayoutHolder.put(lwcFieldApiName, lwcSelectedRecordId);
            }
            layoutHolder.recordMap.put(layoutHolder.objName,updatedLayoutHolder);
        } 
        return null;
    }

    //Constructors 

    global DynamicLayoutController() {
        /* US - 199729 START  - Here we will check if we have form instance record on Parent application and do we have button of Record type Validate then boolean 
        variables are set here */ 
       isFrmsContainValidateRTBtn = false; 
		/*Bug 182667 Get URL valie if it contains formId then set boolean  isFormsURL to true START-*/
       String URL = Apexpages.currentPage().getUrl();
       isFormsURL = false;
        if(String.IsNotBlank(URL)){
            if(URL.contains('formId')){
                isFormsURL = true;
            }
        }
        /*Bug 182667 END */ 
       isFormsPresent = false; 
       String recordId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
       List<FormInstance__c> frmInstance  = new List<FormInstance__c>(); 
       if(FormInstance__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.FormInstance__c.fields.Id.isAccessible() 
            && Schema.SObjectType.FormInstance__c.fields.ParentRecordId__c.isAccessible()
            ) {
                frmInstance = [Select Id,ParentRecordId__c,PackageBusinessForm__r.FormConfig__r.ViewLayoutConfig__c
                                             from FormInstance__c where ParentRecordId__c =: recordId WITH USER_MODE];
            
        }                                  
        if(frmInstance.size() > 0 ){
            isFormsPresent = true; 
            Set<Id> pageLayoutId = new Set<Id>();
            for(FormInstance__c frm : frmInstance){
                pageLayoutId.add(frm.PackageBusinessForm__r.FormConfig__r.ViewLayoutConfig__c);
            }
            List<PageLayoutActionConfig__c> pLActionsList = new List<PageLayoutActionConfig__c>();
            if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
                pLActionsList = [SELECT id, PageLayoutConfig__c,Name, RecordType.Name
                                                  from PageLayoutActionConfig__c 
                                                  where PageLayoutConfig__c =: pageLayoutId and Active__c = true WITH USER_MODE];
            }

                                                  if(pLActionsList.size() > 0){
                                                    for(PageLayoutActionConfig__c pg : pLActionsList){
                                                        if(pg.RecordType.Name == 'Validate'){
                                                            isFrmsContainValidateRTBtn = true;
                                                            break;  
                                                        }
                                                    }
                                                  }
        }
        /* US - 199729 END  */ 
        // User Story 123898: Internal - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users
        skipUpdateAccessCheckForGuestUser = AppUtils.isSkipPermissionCheck();
        String appName = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        CustomAppConfig__c customAppCon = CustomAppConfig__c.getValues(appName);
        if(customAppCon != null) {
           appLabel = customAppCon.Label__c;
        }
		 KeyValueHolder__mdt objMetadataHolder = KeyValueHolderHelper.getKeyValueHolder('EnableLWC');    
        if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c){
            isLwc = true; 
			 if(objMetadataHolder.TextValue__c.contains('stepProgressbar')){
                isLwcStepProgressbar= true;
            } 
		}
        String currentTabName;
              //User Story 110688: Internal - Enhancement - Side bar vanishes after clicking on links from the regular Email or outlook - Part2
                Cookie  cook;
                    if(String.isNotBlank(Apexpages.currentPage().getUrl())){
                        if(Apexpages.currentPage().getUrl().contains('DynamicForm')){ //B19u30g52 - added if for forms browser title
                            if(String.isNotBlank(SFDCEncoder.SFDC_JSENCODE(Apexpages.currentpage().getparameters().get('currentPhaseName')))){
                                currentTabName = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('currentPhaseName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                            }else if(String.isNotEmpty(phaseName)){
				                currentTabName = phaseName;
				            }else if(cook != null){
				                currentTabName = cook.getValue();
				            }
				        }
				    }

            
        AppUtils.fetchIcons(new List<String>{'govGrantPleaseWaitIcon', 'FaviconIcon', 'GovGrantsTheme','govGrantsFooterImage', 'govGrantsFooterImageAfterCollapse','GovGrantsTheme_Collab', 'govGrantsColorContrast_collab','ColorContrast_Grantor','GovGrants','ExternalLibNew','Tooltipster','GovGrants','GovGrantsExternal', 'SessionLogout','BulbIconInstruction','FlexGridEnhanced'}); 
        tooltipster = AppUtils.getIcons('Tooltipster');
        govGrantsExternal = AppUtils.getIcons('GovGrantsExternal');
        govGrants = AppUtils.getIcons('GovGrants');
        bulbIconInstruction = AppUtils.getIcons('BulbIconInstruction');

       String phaseConfig;
        if(String.isNotEmpty(currentTabName)){
            CustomAppPhaseConfig__c customAppPhase = CustomAppPhaseConfig__c.getValues(currentTabName);
            if(customAppPhase != null) {
                phaseConfig = customAppPhase.TabName__c;
            }
        }
        //Set body page include         
        if(phaseConfig != null){
           currentTabLabelName = phaseConfig;
        }

        headerBackButton = Label.HeaderBackButton;
		try {
            if(KeyValueStoreHelper.getTextValue('CKEditorMessage', true) != null ){
                ckeditorMessage = KeyValueStoreHelper.getTextValue('CKEditorMessage', true);
    
            }else{
               ckeditorMessage = 'Character limit has been exceeded. Try again after removing some characters.';     
            }
            // Required for Submit Icon CSS Value...............
            requiredForSubmitIconCSS = KeyValueHolderHelper.getTextValue('RequiredSubmitIconCSSHolder') == null ? '' : KeyValueHolderHelper.getTextValue('RequiredSubmitIconCSSHolder');
            enableOldSidebar = (KeyValueStoreHelper.getBooleanValue('EnableOldSidebar', true) == null ? false : KeyValueStoreHelper.getBooleanValue('EnableOldSidebar', true));
            cancelPromptEnable = (KeyValueStoreHelper.getBooleanValue('CancelPromptEnable', true) == null ? false : KeyValueStoreHelper.getBooleanValue('CancelPromptEnable', true));
            switchApprovalCompButtom = (KeyValueStoreHelper.getBooleanValue('SwitchApprovalDecisionComponentBottom', true) == null ? false : KeyValueStoreHelper.getBooleanValue('SwitchApprovalDecisionComponentBottom', true));
            enableModalHeaderActionButtons = (KeyValueStoreHelper.getBooleanValue('EnableModalHeaderActionButtons',true) == null ? false : KeyValueStoreHelper.getBooleanValue('EnableModalHeaderActionButtons',true)); 
            loadDynamicLayoutControllerData();
            loadErrorMessage();
             if(switchApprovalCompButtom || parentLytId !=null){
                hideBlankRelatedList = true;
            }
         } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex.getMessage())));
         }
    }


    @RemoteAction
    global static Map<String, Object> isUrlActionAlreadyPerformed(String recordId,String actionId) {
        Map<String, Object> retVal = new Map<String, Object>();
        Boolean avoidActionPerformedCheck = false;
        if(KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true) != null){ 
            avoidActionPerformedCheck = KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true);
        }
        if(avoidActionPerformedCheck == true){
            Boolean hideResult = DynamicLayoutHelper.isActionAlreadyPerformed(recordId,null,null,actionId);
            if(hideResult == false){
                retVal.put('Success', false);
            }else{
                retVal.put('Success', true);
            }
        }else{
            retVal.put('Success', true);
        }
        return retVal;
    }

    public PageReference isActionAlreadyPerformedErrorMessage() {
        String errorMessage = 'This Action has been taken by another user. Refresh the page to see the updated status....';
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errorMessage);
        ApexPages.addMessage(msg);
        return null;
    }
     //This method is to load message on onload of page.
    @TestVisible
    private void loadErrorMessage() {
        string errorMessageCode = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('pageMessageId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String messageTTLInSec = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('messageTTLInSec'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        //actionExecTime parameter needs to be in Datetime format.
        String strActionExecTime = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('actionExecTime'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        //The message will be visible for seconds specified in messageTTLInSec.These parameters are optional.
        if(String.isNotEmpty(messageTTLInSec) && String.isNotEmpty(strActionExecTime)){
            Decimal decimaltimeForMessage = Decimal.valueOf(messageTTLInSec);
            Datetime actionExecTime =  Datetime.valueOfGmt(strActionExecTime); 
            //actionExeTime.getTime() gives time in milliseconds. Then we convert it into seconds.
            Decimal timeDifference = (decimal.valueOf(system.now().getTime() - actionExecTime.getTime()))/1000;
            if(timeDifference > decimaltimeForMessage){
                return;
            }
        }
       
        if(String.isNotEmpty(errorMessageCode)){
            //if(String.isNotEmpty(errorMessageCode)){
            String message = ErrorMessageHelper.fetchMessage(errorMessageCode);
            if(String.isNotEmpty(message)){
                String messageType = ErrorMessageHelper.fetchMessageType(errorMessageCode);
                if(messageType == 'success' || messageType == 'Success Message'){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, message)); 

                }else if(messageType == 'danger' || messageType == 'Error'){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message)); 

                }else if(messageType == 'info' || messageType == 'Confirmation Message'){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, message)); 

                }else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING, message)); 

                }
            }
           // }    
        }
        
    }
    @TestVisible
    private void checkFormIsApplicable(){
        List<FormInstance__c> formInstance = new List<FormInstance__c>();
        formInstanceId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('formInstanceId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(String.isNotEmpty( formInstanceId )){
            try{
            if(Schema.sObjectType.FormInstance__c.isAccessible()){
                formInstance = [Select Id,IsNotApplicable__c  from FormInstance__c where Id =: formInstanceId WITH USER_MODE]; 
            }
           isNotApplicable = formInstance[0].IsNotApplicable__c;
            }catch(Exception ex){
                AppUtils.handleSystemExceptionMsg(ex);
            }
           
        }
    }

   
    private void loadDynamicLayoutControllerData() {
        formSaved = ApexPages.currentPage().getCookies() != null && ApexPages.currentPage().getCookies().get('isFormSaved') != null ? String.valueOf(ApexPages.currentPage().getCookies().get('isFormSaved').getValue()) : 'false';
        if(ApexPages.CurrentPage().getParameters().get('cancelURL') != null){
            this.cancelURL = SFDCEncoder.SFDC_URLENCODE(ApexPages.CurrentPage().getParameters().get('cancelURL'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            this.cancelURL = EncodingUtil.urlEncode(this.cancelURL, 'UTF8');
        }           

        this.autopromptTimer = KeyValueStoreHelper.getIntegerValue('AutopromptTiming',true);
        this.autoPromptEnable = KeyValueStoreHelper.getBooleanValue('autoPromptEnable',true);
        
        this.isModal = false;
        this.hideContextSpecificSidebar = KeyValueStoreHelper.getBooleanValue('HideContextSpecificSidebar', true);
        if(this.hideContextSpecificSidebar == null) {
            this.hideContextSpecificSidebar = true;
        }
        boolean hideSidebar = UserPreferenceHelper.getBooleanValue('HideSidebar__c');
        this.renderDownloadPDFMenuAsButton =  KeyValueHolderHelper.getBooleanValue('RenderDownloadPDFMenuAsButton') == null ? false : KeyValueHolderHelper.getBooleanValue('RenderDownloadPDFMenuAsButton');
        this.renderModalDownloadPDFAsButton = KeyValueHolderHelper.getBooleanValue('RenderModalDownloadPDFMenuAsButton') == null ? false : KeyValueHolderHelper.getBooleanValue('RenderModalDownloadPDFMenuAsButton');
        namespace = AppUtils.getNamespacePrefix();
        hasErrors = true;
        //isLastStep = true;
        layoutId = ''; 
        header = '';
        subHeader = '';
        errorMsgMap = '';
       
        this.hideSidebarUser = hideSidebar == null?false:hideSidebar;
        this.isCustomHeader = false;
        this.currentPageURL = SFDCEncoder.SFDC_URLENCODE(ApexPages.CurrentPage().getUrl());
        enableNativeLayoutFromDynamicLayout = GlobalConfigHelper.getEnableAdminSetup() ;
        if(enableNativeLayoutFromDynamicLayout == null){
            enableNativeLayoutFromDynamicLayout = false;
        }  
        //Code to check if the record is accessible to the logged in user.
        String rId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        //accessMessage = checkRecordLevelAccess(rId);
        
        if(formSaved == 'true') {
            formSavedMessage();
        }
        addSuccessMessage();

    }
    @TestVisible
    private static void addSuccessMessage(){
        //public String message{get;set;}
        String message = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('success'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(message != null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Record saved successfully')); 
        }
     }
    
    
    global DynamicLayoutController(ApexPages.StandardController controller) {
        namespace = AppUtils.getNamespacePrefix();
        this.autopromptTimer = KeyValueStoreHelper.getIntegerValue('AutopromptTiming',true);
        this.autoPromptEnable = KeyValueStoreHelper.getBooleanValue('autoPromptEnable',true);
        
    }

    // Deprecated
    global static Map<String, Object> decideActions(String recordId, String layoutId) {
        return decideActions(recordId, layoutId, new Map<String, Object>());
    }
    
    @RemoteAction
    global static Map<String, Object> decideActions(String recordId, String layoutId, Map<String, Object> paramMap) {
        recordId = String.escapeSingleQuotes(recordId);
        FlexLayoutActionsGenerator fag = new FlexLayoutActionsGenerator(recordId, layoutId, paramMap);
        return fag.decide();
    }

    @RemoteAction
    global static Map<String,Object>fetchMiniLayout(Id referenceId){
        referenceId = String.escapeSingleQuotes(referenceId);
        return MiniLayoutController.getLayout(referenceId);
    }
     /* US - 199729 START  */ 
    //Tejashree Download as PDF with forms
    //This method is not in use
    global static Map<String,Object> validateForms(String recId,String formId,String parentId,String formInstanceId, String actionIdForValidateBtn){
        return null;
    }
  //This method is not in use
    global static Map<String,Object> createSnapshotwithForms(Id recId,String templatename,String keyvalueMap,String listparams){ 
        return null;
    }

    global static PageReference validateForms(){
        Savepoint sp = Database.setSavepoint();
        try{
            Id recId =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('recId'));
            Id formId =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formId'));
            Id parentId =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentId'));
            Id formInstanceId =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formInstanceId'));
            Id actionIdForValidateBtn =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('actionIdForValidateBtn'));
            FormInstance__c formInstance;
            Boolean formIncomplete = false;            
            
            String sObjectType =  Id.valueOf(parentId).getSObjectType().getDescribe().getName();
            String classnamefromButton = getFormValidationClassName(actionIdForValidateBtn);
            if(String.IsNotEmpty(classnamefromButton)){
                FormSpecificValidationAbstractHandler polymorphicInstance = getFormSpecificValidationHandlerInstance(classnamefromButton);
                //Perform Custom validations
                FormValidationWrapper formValidateWrap = new FormValidationWrapper();
                formValidateWrap.objectName = sObjectType;
                formValidateWrap.formId = recId;
                formValidateWrap.parentId = parentId;
                formValidateWrap.formInstanceId = formInstanceId;

                Boolean formSpecificValidationFailed = performFormSpecificValidation(formValidateWrap,polymorphicInstance);  
                if(formSpecificValidationFailed != null){
            //Perform Standard validations 
            Map<String, FlexUtils.FormCompletionDTO> formPer = FlexUtils.getLayoutCompletionOnFormId(recId, formId);
            if (formPer != null && formPer.size() > 0) {
                for (FlexUtils.FormCompletionDTO dto : formPer.values()) {
                    PackageFormConfig__c packageForm = dto.packageForm;
                    if (dto.submitPercentage < 100 && packageForm.FormConfig__c == formId) {
                        formIncomplete = true;
                    }
                }
            }
            //If form is validated in both the validation or  we do not have custom validation then formSpecificValidationFailed is by default set to False so below if will run 
            if (formIncomplete == false && formSpecificValidationFailed == false){
                        polymorphicInstance.updateFormInstanceValidationFlag(formInstanceId); 
               String loggedInUserId = UserInfo.getUserId();
                DynamicLayoutController.generateFormPdf(formInstanceId,parentId,loggedInUserId );
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, Label.FormValidated));
            }else if(formIncomplete) { // formSpecificValidationFailed removed this as form specific validation message are show from that method only and not from here 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.StandardFormValidationFailed));
            }
                }
            }
      }Catch(Exception e){
		Database.rollback(sp);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DownloadAsPDFWithFormsErrors));
      }
      return null; 
    }
    public static list<LightningPageMessage> messageList = new list<LightningPageMessage> ();
    
    @AuraEnabled
    public static String validateFormsLWC( Id formId, Id actionConfigId, String currentUrl){    
        Savepoint sp = Database.setSavepoint();
        ActionClassResponseWrapper responseWrapper = new ActionClassResponseWrapper();
        Id parentRecId;
        Id formInstanceId;
        Id formConfigId;
        try{
            List<FormInstance__c> frmInstance = new  List<FormInstance__c>();
            if(FormInstance__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.FormInstance__c.fields.Id.isAccessible() 
            && Schema.SObjectType.FormInstance__c.fields.FormId__c.isAccessible()
            && Schema.SObjectType.FormInstance__c.fields.ParentRecordId__c.isAccessible()
            ) {
                frmInstance = [select Id, FormId__c, ParentRecordId__c,PackageBusinessForm__r.FormConfig__c
                                                 from FormInstance__c where FormId__c =: formId WITH USER_MODE];

            }
            if(frmInstance.size() > 0 ){
                parentRecId = frmInstance[0].ParentRecordId__c;
                formInstanceId = frmInstance[0].Id;
                formConfigId = frmInstance[0].PackageBusinessForm__r.FormConfig__c;
            }
            FormInstance__c formInstance;
            Boolean formIncomplete = false;  
            String sObjectType =  Id.valueOf(parentRecId).getSObjectType().getDescribe().getName();
            String classnamefromButton = getFormValidationClassName(actionConfigId);
            if(String.IsNotEmpty(classnamefromButton)){
                    FormSpecificValidationAbstractHandler polymorphicInstance = getFormSpecificValidationHandlerInstance(classnamefromButton);
                    //Perform Custom validations
                    FormValidationWrapper formValidateWrap = new FormValidationWrapper();
                    formValidateWrap.objectName = sObjectType;
                    formValidateWrap.formId = formId;
                    formValidateWrap.parentId = parentRecId;
                    formValidateWrap.formInstanceId = formInstanceId;
                    Boolean formSpecificValidationFailed = performFormSpecificValidation(formValidateWrap,polymorphicInstance);  
                    if(formSpecificValidationFailed != null){
                            //Perform Standard validations 
                            Map<String, FlexUtils.FormCompletionDTO> formPer = FlexUtils.getLayoutCompletionOnFormId(formId, formConfigId);
                            if (formPer != null && formPer.size() > 0) {
                                for (FlexUtils.FormCompletionDTO dto : formPer.values()) {
                                    PackageFormConfig__c packageForm = dto.packageForm;
                                    if (dto.submitPercentage < 100 && packageForm.FormConfig__c == formConfigId) {
                                        formIncomplete = true;
                                    }
                                }
                            }
                                if (formIncomplete == false && formSpecificValidationFailed == false){
                                    polymorphicInstance.updateFormInstanceValidationFlag(formInstanceId); 
                                    String loggedInUserId = UserInfo.getUserId();
                                    DynamicLayoutController.generateFormPdf(formInstanceId,parentRecId,loggedInUserId );
                                    messageList.add(New LightningPageMessage(ApexPages.Severity.CONFIRM,Label.FormValidated));
                                    
                                }else if(formIncomplete) { 
                                    messageList.add(New LightningPageMessage(ApexPages.Severity.ERROR,Label.StandardFormValidationFailed));
                                }
    
                        }
                        responseWrapper.pageMessageList.addAll(messageList);
                        if(messageList.size()>0){
                            responseWrapper.messageTimeOutEnabled = KeyValueStoreHelper.getBooleanValue('PageMessageTimeOut',true);                   
                            responseWrapper.messageTimeOut = KeyValueStoreHelper.getIntegerValue('PageMessageTimeOut',true);                    
                        }
                    }
            }Catch(Exception e){
                Database.rollback(sp);
                messageList.add(New LightningPageMessage(ApexPages.Severity.ERROR,Label.DownloadAsPDFWithFormsErrors));
            }
        return JSON.serialize(responseWrapper);
    }
    private with sharing class ActionClassResponseWrapper{        
        private List<LightningPageMessage> pageMessageList = new List<LightningPageMessage>();
        private String responseMessage;
        private Integer messageTimeOut; 
        private Boolean messageTimeOutEnabled;
    }
    private static string getFormValidationClassName(Id actionId){
        string classNameFromBtn;
        if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
            List<PageLayoutActionConfig__c> actionConfigs = [
                    Select Id, ActionClass__c
                    from PageLayoutActionConfig__c
                Where  Id = :actionId AND ActionClass__c != null WITH USER_MODE
            ];
            classNameFromBtn = 'FormSpecificValidation';
            if (actionConfigs.size() > 0 && String.isNotEmpty(actionConfigs[0].ActionClass__c)){
                classNameFromBtn = actionConfigs[0].ActionClass__c; // example: OSPI_ValidateIntentForm
            }
        }
        return classNameFromBtn;
    }

    private static FormSpecificValidationAbstractHandler getFormSpecificValidationHandlerInstance(String classNameFromBtn){
		System.Type clsType = System.Type.forName('', classNameFromBtn);
		Object obj = clsType.newInstance();
		FormSpecificValidationAbstractHandler polymorphicInstance = (FormSpecificValidationAbstractHandler) obj;
		return polymorphicInstance;
    }
                
    private static Boolean performFormSpecificValidation(FormValidationWrapper formValidateWrap,FormSpecificValidationAbstractHandler polymorphicInstance) {    // FormValidationData formDataWrapper
		try{
            Boolean formSpecificValidationFailed = false;
            skipFormSpecificValidations = false;
            
            List<String> errors = polymorphicInstance.formValidations(formValidateWrap);   //formValidations validateForm
            skipFormSpecificValidations = polymorphicInstance.skipFormValidations;
	            if (errors.size() > 0) {
	                formSpecificValidationFailed = true;
	                Boolean isLightning = AppUtils.isLightningTheme() || AppUtils.isExperienceCloud();
	                for (String error : errors) {
	                    if(isLightning == true){
	                        messageList.add(New LightningPageMessage(ApexPages.Severity.ERROR,error));
	                    }else{
	                    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
	                	}
	            	}
	            }
        	return formSpecificValidationFailed;
		}Catch(Exception e){ /*Exception added in case of form specific validation class is not written correctly */
            Boolean isLightning = AppUtils.isLightningTheme();
            if(isLightning == true){
                messageList.add(New LightningPageMessage(ApexPages.Severity.ERROR,Label.DownloadAsPDFWithFormsErrors));
            }else{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DownloadAsPDFWithFormsErrors));
    		}
    	}
        return null;
    }


    /**Form PDF will be generated. and PDFAttachmentId will be populated with newly created PDF id which will be used in Download as pdf with forms */
    @future(callout=true)
    public static void generateFormPdf(Id formInstanceId, Id parentId, String loggedInUserId) {
        Map<Id, Id> pageTemplateToFormInstanceMap = new Map<Id, Id>();
        Map<String, String> formParentSobjectToPageTemplateRef = new Map<String, String>();
        Id finalAttachmentId;
        Map<Id, Id> formInstanceToParentFormRecordId = new Map<Id, Id>();
        String sobjectType = parentId.getSobjectType() + '';
        sobjectType = sobjectType.toLowerCase();
        Set<String> formParentSobjectNameSet = new Set<String>();
        Id attachmentIdToDelete;
        FormInstance__c form;
       try{
        List<FormInstance__c> formInstanceList = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()){
            formInstanceList = [SELECT Id,Name,PDFFormAttachmentId__c, PackageBusinessForm__r.FormConfig__r.Name,PackageBusinessForm__r.FormConfig__r.SObjectName__c,ParentRecordId__c 
                                                    FROM FormInstance__c 
                                                    WHERE Id = :formInstanceId AND PackageBusinessForm__r.FormConfig__c != NULL WITH USER_MODE];
        }
        if (formInstanceList.size() > 0) {
            form = formInstanceList[0];
            if(String.isNotBlank(formInstanceList[0].PDFFormAttachmentId__c)){
        		attachmentIdToDelete = form.PDFFormAttachmentId__c;
            }
        pageTemplateToFormInstanceMap.put(form.PackageBusinessForm__r.FormConfig__c, form.Id);                
        String formParentSobjectName = form.PackageBusinessForm__r.FormConfig__r.SObjectName__c;                
        formParentSobjectName = formParentSobjectName.toLowerCase();                 
        formParentSobjectNameSet.add(formParentSobjectName);
        if (formParentSobjectToPageTemplateRef.get(formParentSobjectName) == null) {                 
            Schema.SObjectType parentSobjectType = Schema.getGlobalDescribe().get(formParentSobjectName); //GenerateFormInstancePdf.globalMap.get(formParentSobjectName);                    
            Map<String, SobjectField> fieldMap = parentSobjectType.getDescribe().fields.getMap();                     
            for (String field : fieldMap.keySet()) {                     
                SobjectField sField = fieldMap.get(field);
                String fieldType = sField.getDescribe().getType() + '';
                fieldType = fieldType.trim();                         
                String referenceTo = sField.getDescribe().getReferenceTo() + ''.trim();                         
                referenceTo = referenceTo.substring(1, referenceTo.length() - 1);                         
                        if (fieldType.equalsIgnoreCase('REFERENCE') && referenceTo.equalsIgnoreCase(AppUtils.getNamespacePrefix()+'PageTemplate__c')) {
                    		formParentSobjectToPageTemplateRef.put(formParentSobjectName.toLowerCase(), field);
                    		break;
                		}
            	}
        	}
       }     
           
              if (attachmentIdToDelete != null) {
                List<Attachment> attToDelete = [SELECT Id,OwnerId FROM Attachment 
                                                WHERE ID = :attachmentIdToDelete WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users  
                List<Attachment> attFinalToDelete = new List<Attachment>();
                if(attToDelete.size() > 0){
                    for(Attachment att : attToDelete){  
                        if(att.OwnerId == loggedInUserId){
                            attFinalToDelete.add(att);
                        }
                    }
                }
                   if(attFinalToDelete.size() > 0 && Schema.sObjectType.Attachment.isDeletable()){
                        Delete as user attFinalToDelete;
                    }
            }


        List<Sobject> formParentRecordIds = new List<Sobject>();
        for (String sobj : formParentSobjectNameSet) {
            String pageTemplateRefApiName = formParentSobjectToPageTemplateRef.get(sobj);
            String formParentQuery = 'SELECT Id,Name,' + String.escapeSingleQuotes(pageTemplateRefApiName) + ' FROM ' + String.escapeSingleQuotes(sobj) + ' WHERE ' + String.escapeSingleQuotes(sobjectType) + ' = :parentId ';
            List<Sobject> recordIdList;
            if(AppUtils.isObjectAccessible(sobj)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                recordIdList = Database.query(String.escapeSingleQuotes(formParentQuery), AccessLevel.USER_MODE);   //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            }
            formParentRecordIds.addAll(recordIdList);
        }

        if (formParentRecordIds.size() > 0) {
            for (Sobject sobj : formParentRecordIds) {
                String formParentSobjectType = sobj.getSobjectType() + '';
                formParentSobjectType = formParentSobjectType.toLowerCase();
                String pageTemplateRefApiName = formParentSobjectToPageTemplateRef.get(formParentSobjectType);
                Id pageTemplateId = Id.valueOf(sobj.get(pageTemplateRefApiName) + '');
                Id formId = pageTemplateToFormInstanceMap.get(pageTemplateId);
                formInstanceToParentFormRecordId.put(formId, sobj.Id);
            }
        }

        
        Map<String, String> keyValueMap = new Map<String, String>();
                User userRec = [select OrganizationId__c from User where Id = :UserInfo.getUserId() WITH USER_MODE];
            keyValueMap.put('OrganizationId', userRec.OrganizationId__c);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        
        keyValueMap.put('parentId', parentId);
        Id formParentId = formInstanceToParentFormRecordId.get(formInstanceId);
        keyValueMap.put('recordId', formParentId);
        keyValueMap.put('template', form.PackageBusinessForm__r.FormConfig__r.Name);
        String keyValueMapJSON = JSON.serialize(keyValueMap);
        if (formParentId != null) {
            Id attId = SnapshotUtils.createSnapshot(formParentId, form.PackageBusinessForm__r.FormConfig__r.Name, keyValueMapJSON, '');
            finalAttachmentId = attId;
        }

        	FormInstance__c formInstance = new FormInstance__c(Id = formInstanceId, PDFFormAttachmentId__c = finalAttachmentId);
        	if(Schema.sObjectType.FormInstance__c.fields.PDFFormAttachmentId__c.isUpdateable()&& Schema.sObjectType.FormInstance__c.isUpdateable()){
        	    update as user formInstance;
            }
        }catch(exception e){ 
            Boolean isLightning = AppUtils.isLightningTheme();
            if(isLightning == true){
                messageList.add(New LightningPageMessage(ApexPages.Severity.ERROR,Label.DownloadAsPDFWithFormsErrors));
            }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DownloadAsPDFWithFormsErrors));
        	}
        }

    }

  //Teja Download as PDF with forms  - This method will create Snapshot of parent record with forms records 
  public static PageReference createSnapshotwithForms(){ 
        try{
            Id recId =Id.valueOf(SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('recId1')));
            String templatename =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('templatename'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            String keyvalueMap =SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('keyvalueMap'));  //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            String listparams = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('listparams'));   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            Id parentAattachmentIdsToMerge = SnapshotUtils.createSnapshot(recId,templatename,keyvalueMap,listparams);
            if(parentAattachmentIdsToMerge != null || parentAattachmentIdsToMerge != ''){
                getFormPDFIds(recId,parentAattachmentIdsToMerge);
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DownloadAsPDFWithFormsErrors));
            }
        }Catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    @RemoteAction
    global static Void getFormPDFIds(Id parentId,Id parentAattachmentIdsToMerge){
       
        List<Id> attachmentIdsToMerge = new List<Id>();
        List<FormInstance__c> formInstnaceList = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()){
            formInstnaceList = [SELECT Id,PDFFormAttachmentId__c FROM FormInstance__c 
                                                  WHERE PDFFormAttachmentId__c != NULL and ParentRecordId__c = :parentId and isFormValidated__c = 'Yes' 
                                                  WITH USER_MODE ORDER BY PackageBusinessForm__r.Order__c];
        }
        attachmentIdsToMerge.add(parentAattachmentIdsToMerge);
        if(formInstnaceList.size() > 0){
            for(FormInstance__c form : formInstnaceList){
                attachmentIdsToMerge.add(form.PDFFormAttachmentId__c);
            }

            if(attachmentIdsToMerge.size() > 0){
                String sobjectType = parentId.getSObjectType().getDescribe().getName(); 
                //callMergePDFAPI(parentId, sobjectType, attachmentIdsToMerge);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PDFWithFormsRequestProcessed));
               
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.FormPDFNotFound));
        }
    }
  
    private static void callMergePDFAPI(Id parentId, String sobjectType, List<Id> attachmentIdsToMerge){
        String attachmentIds = String.join(attachmentIdsToMerge,',');
        Map<String, String> userMap = new Map<String, String>();
        userMap.put('attachmentIds', attachmentIds);
        userMap.put('sessionId', '{!$Credential.OAuthToken}'); 
        userMap.put('task', 'PDFMerger');       
        userMap.put('fileName', 'Merged_'+sobjectType.replace('__c', '_PDF_') + System.Now() + '.pdf');      
        userMap.put('parentRecordId', parentId);        
        if (!Test.isRunningTest()) {
            List<NetworkMember> nm;
            List<User> usr;
            if(Schema.sObjectType.NetworkMember.fields.Id.isAccessible()) {
                nm = [SELECT NetworkID, MemberID FROM NetworkMember 
                                        where MemberID =: UserInfo.getUserId()]; //NOPMD CRUD  FLS- False +ve - Std obj  - will not check permission here 
                if(Schema.sObjectType.User.fields.Id.isAccessible()) {
                    usr = [SELECT id , name, Profile.UserLicense.Name from user 
                              where id =: UserInfo.getUserId()];  //NOPMD CRUD  FLS- False +ve - can not add WITH SECURITY_ENFORCED it break our business functionlity for portal users
                }
            }
            if(usr.size() > 0 && usr[0].Profile.UserLicense.Name == 'Partner Community'){
                if(nm!=null && !nm.isEmpty() ){
                    String netId = nm[0].NetworkID;
                    callITextMergePDF(JSON.serialize(userMap), parentId, netId);
                }
            }else{
                    callITextMergePDF(JSON.serialize(userMap), parentId);
                }
        }    
    }
    /**Method for External users */
    @future(callout=true)
    public static void callITextMergePDF(String userMapSerialized, Id parentId, String netValue) {
        // deserialize back into our map of lists
        Map<String, String> paramMap = (Map<String, String>) JSON.deserialize(SFDCEncoder.sanitizeJSON(userMapSerialized), Map<String, String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON 
        //Call the itext function to merge the pdf
        Map<String, Object> returnMap = ITextHelper.mergePDF(paramMap);
        // Below code converts the Attachment into File & deletes the Attachment record.
        // if (((String) returnMap.get('AttachmentId')) != null) {
        //    createSalesforceContentVersion((String)returnMap.get('AttachmentId'),netValue);   
        // }
    }
    
     /**Method for External users */
    @testvisible
    private static void createSalesforceContentVersion(Id attachmentId, String netValue){ 
         List<Attachment> attList = [SELECT Id,Name,Description,Body,ParentId FROM Attachment 
                                    where Id = :attachmentId WITH USER_MODE];//CRUD  FLS- False +ve - can not add WITH SECURITY_ENFORCED it break our business functionlity for portal users
        if(attList.size() > 0){
            Attachment att = attList[0];
            ContentVersion objCntVersion = new ContentVersion();
            if(Schema.sObjectType.ContentVersion.fields.Title.isCreateable()){
            objCntVersion.Title = att.Name;
            }
            if(Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()){
            objCntVersion.PathOnClient = '/' + att.Name;
            }
            if(Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()){
            objCntVersion.VersionData = (att.Body == null ? Blob.valueOf('.') : att.Body);
            }
            if(Schema.sObjectType.ContentVersion.fields.Description.isCreateable()){
            objCntVersion.Description = att.Description != null ? att.Description : 'Complete PDF including forms';
            }
            //objCntVersion.SharingPrivacy = 'N'; // Can be always public.
            objCntVersion.FirstPublishLocationId = att.ParentId; // Parent Id
            if(Schema.sObjectType.ContentVersion.fields.Classification__c.isCreateable()){
            objCntVersion.Classification__c = 'Other';
            }
            if(Schema.sObjectType.ContentVersion.fields.FileExtension__c.isCreateable()){
            objCntVersion.FileExtension__c = 'pdf';
            }
            objCntVersion.NetworkId = netValue;
            if(Schema.sObjectType.ContentVersion.isCreateable()){
                insert as user objCntVersion;
            }
            if(Schema.sObjectType.Attachment.isDeletable()){
                delete as user att;
            }  
        }
    }
    
    @future(callout=true)
    public static void callITextMergePDF(String userMapSerialized, Id parentId) {
        // deserialize back into our map of lists
        Map<String, String> paramMap = (Map<String, String>) JSON.deserialize(SFDCEncoder.sanitizeJSON(userMapSerialized), Map<String, String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON 
        //Call the itext function to merge the pdf
        Map<String, Object> returnMap = ITextHelper.mergePDF(paramMap);
        // Below code converts the Attachment into File & deletes the Attachment record.
        if (((String) returnMap.get('AttachmentId')) != null) {
           createSalesforceContentVersion((String)returnMap.get('AttachmentId'));   
        }
    }
   
    // /**Method for internal users */
    @testvisible
    private static void createSalesforceContentVersion(Id attachmentId){
        List<Attachment> attList = [SELECT Id,Name,Description,Body,ParentId FROM Attachment 
                                    where Id = :attachmentId WITH USER_MODE];//CRUD  FLS- False +ve - can not add WITH SECURITY_ENFORCED it break our business functionlity for portal users
        if(attList.size() > 0){
            Attachment att = attList[0];
            ContentVersion objCntVersion = new ContentVersion();
            if(Schema.sObjectType.ContentVersion.fields.Title.isCreateable()){
            objCntVersion.Title = att.Name;
            }
            if(Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()){
            objCntVersion.PathOnClient = '/' + att.Name;
            }
            if(Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()){
            objCntVersion.VersionData = (att.Body == null ? Blob.valueOf('.') : att.Body);
            }
            if(Schema.sObjectType.ContentVersion.fields.Description.isCreateable()){
            objCntVersion.Description = att.Description != null ? att.Description : 'Complete PDF including forms';
            }
            //objCntVersion.SharingPrivacy = 'N'; // Can be always public.
            objCntVersion.FirstPublishLocationId = att.ParentId; // Parent Id
            if(Schema.sObjectType.ContentVersion.fields.Classification__c.isCreateable()){
            objCntVersion.Classification__c = 'Other';
            }
            if(Schema.sObjectType.ContentVersion.fields.FileExtension__c.isCreateable()){
            objCntVersion.FileExtension__c = 'pdf';
            }
            if(Schema.sObjectType.ContentVersion.isCreateable()){
            insert as user objCntVersion;
            }
            if(Schema.sObjectType.Attachment.isDeletable()){
                delete as user att;
            }  
        }  
    }
    
    public void checkRecordLevelAccess(){
        // Task 104303: Internal - Enhancement - Ignore record/object-level access check 
        if(AppUtils.isSkipPermissionCheck()){
            hasReadAccess = true;
            return;
        }
        String rcrdId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if (String.isEmpty(rcrdId)) {
            hasReadAccess = true;
            return ;
        }    
        List<UserRecordAccess> accessList = [SELECT HasReadAccess,HasEditAccess,HasDeleteAccess,RecordId FROM UserRecordAccess 
                                             WHERE RecordId=:rcrdId AND UserId=:UserInfo.getUserId() WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
       hasReadAccess = false;	
		if(accessList.size() > 0){
		    if(accessList[0].HasReadAccess && type.equalsIgnoreCase('View')){
			    hasReadAccess = true;
            }
            else if(accessList[0].HasEditAccess && type.equalsIgnoreCase('Edit')){
                hasReadAccess = true;
            }
            else if(accessList[0].HasDeleteAccess && type.equalsIgnoreCase('Delete')){
                hasReadAccess = true;
            }
		}		
        Boolean enableUrlHacking = false;
        if(KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true) != null){           
          enableUrlHacking = KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true);
        }
        
        if(enableUrlHacking == true){
            String templateId;
            if( pkgId != null && pkgId != '' && parentLytId == null ) {
                if(Package__c.sObjectType.getDescribe().isAccessible()){
                    if(packageObj == null){
                        packageObj  = [select id,name,PageTemplateConfig__r.Name,PageTemplateConfig__r.ViewLayoutConfig__c from Package__c where Id=:pkgId WITH USER_MODE];
                    }
                    if(String.isNotBlank(packageObj.PageTemplateConfig__c)) { 
                        tmplName = packageObj.PageTemplateConfig__r.Name;
                        templateId = packageObj.PageTemplateConfig__c;
                    }
                } 
            }else if( pkgName != null && pkgName != '' ) {
                if(Package__c.sObjectType.getDescribe().isAccessible()){
                    if(packages == null){
                        packages  = [select id,name,PageTemplateConfig__r.Name,PageTemplateConfig__r.ViewLayoutConfig__c from Package__c where Name=:pkgName WITH USER_MODE];
                    }
                    if(packages.size() > 1){
                        throw new CustomExceptions.InputDataException('Found 2 packages with same Name. Please check with Administrator.');
                    }else if(packages.size() == 0){
                        throw new CustomExceptions.InputDataException('No Package found for given Name.');
                    }
                    if(String.isNotBlank(packages[0].PageTemplateConfig__c)) { //Tomy - 19/04/2018 - ticket 20215 Changes for utah support, allow null value for form config lookup
                        tmplName = packages[0].PageTemplateConfig__r.Name;
                        templateId = packages[0].PageTemplateConfig__c;
                    }
                }
            }
            if(tmplName == null || tmplName == '') {
                String context = String.isNotBlank(rcrdId) ? type : 'Create';
                //Tomy - changed from templateId to tmplName, as getTemplateName returns name now
                tmplName = DynamicLayoutHelper.getTemplateName(rcrdId, context, listDefaultValues, sObjectName);
            }
            if(pageTemplate == null){
                if(Schema.sObjectType.PageTemplate__c.isAccessible()){
                    if(templateId != null ){
                        pageTemplate = [SELECT id,Name,AllowedCharsForRichTextArea__c,AllowedWordsForRichTextArea__c,RTALimitConfig__c,EditLayoutConfig__c,ToolBarGroups__c,ViewLayoutConfig__c,PrintLayoutConfig__c,EditLayoutConfig__r.ObjectApiName__c,EditLayoutConfig__r.HideOnDemandSnaphot__c,
                                                HelpConfig__c,EditLayoutConfig__r.RecordTypeId,EditLayoutConfig__r.RecordTypeWindowTitle__c,RedirectBehaviour__c,NextPageURL__c,
                                                ViewLayoutConfig__r.RecordTypeId,ViewLayoutConfig__r.ObjectApiName__c,ViewLayoutConfig__r.HideOnDemandSnaphot__c,
                                                LabelOverrideSaveandContinue__c,PrintLayoutConfig__r.RecordTypeId,PrintLayoutConfig__r.ObjectApiName__c,OMBNumber__c,Version__c,DisplayName__c,ShowFooterText__c,ShowHeaderText__c,FormDisplayType__c,GroupName__c,LabelOverrideSaveandClose__c,DoNotTranslateForm__c
                                                FROM PageTemplate__c WHERE Id = : templateId WITH USER_MODE];
                        
                    }else{
                        List<PageTemplate__c> pageTemplateList = [SELECT id,Name,AllowedCharsForRichTextArea__c,AllowedWordsForRichTextArea__c,RTALimitConfig__c,ToolBarGroups__c,EditLayoutConfig__c,ViewLayoutConfig__c,PrintLayoutConfig__c,EditLayoutConfig__r.ObjectApiName__c,EditLayoutConfig__r.HideOnDemandSnaphot__c,
                                                HelpConfig__c,EditLayoutConfig__r.RecordTypeId,EditLayoutConfig__r.RecordTypeWindowTitle__c,RedirectBehaviour__c,NextPageURL__c,
                                                ViewLayoutConfig__r.RecordTypeId,ViewLayoutConfig__r.ObjectApiName__c,ViewLayoutConfig__r.HideOnDemandSnaphot__c,
                                                LabelOverrideSaveandContinue__c,PrintLayoutConfig__r.RecordTypeId,PrintLayoutConfig__r.ObjectApiName__c,OMBNumber__c,Version__c,DisplayName__c,ShowFooterText__c,ShowHeaderText__c,FormDisplayType__c,GroupName__c,LabelOverrideSaveandClose__c,DoNotTranslateForm__c
                                                FROM PageTemplate__c WHERE Name = : tmplName WITH USER_MODE];
                        
                        if(pageTemplateList.size() == 0){
                            CustomExceptions.logException(String.format(System.Label.FormEntryLabel, new List<String>{tmplName}), false);
                            //throw new CustomExceptions.InputDataException('No form entry found for '+tmplName);
                        }
                        if(pageTemplateList.size() > 1){
                            CustomExceptions.logException(String.format(System.Label.DuplicateForm, new List<String>{tmplName}), false);
                        }
                        pageTemplate = pageTemplateList[0];
                    }
                }
            }
        }

        if(hasReadAccess == true && enableUrlHacking == true) {   
            if(String.isNotBlank(pageTemplate.ViewLayoutConfig__c)) { 
                hasReadAccess = DynamicLayoutHelper.isRecordAccess(rcrdId,type,pageTemplate.ViewLayoutConfig__c);
            }else{
                hasReadAccess = DynamicLayoutHelper.isRecordAccess(rcrdId,type,null); //Chek for record access
            } 
        }
        accessMessage = null;
        if (hasReadAccess == false) {
            accessMessage = 'You dont have permission to access this record. Please contact administrator.';
        }
        // return accessMessage;
    }

    public Component.Apex.OutputPanel getViewLayoutTabsContent() {
        
        try{
             return new FlexLayoutViewGenerator(layoutHolder, isPreviewLayout, flexTableParameterJSONChanged, 
                    listParameters, chartParameter,false,type == 'Edit'?true:false ).generate();
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex.getMessage())));
            CustomExceptions.logException(ex, false, false);

        }
        return null;
       
    }
    
    public Component.Apex.OutputPanel getModalViewLayoutTabsContent() {
        return new FlexLayoutViewGenerator(layoutHolder, isPreviewLayout, flexTableParameterJSONChanged, 
                    listParameters, chartParameter, true).generate();
    }
    
    /*
        Shrawan Raina    10/23/2015
        UI-Added for new header overview component
    */
    public Component.Apex.OutputPanel getHeaderOverviewContent() {
         try{
              return new FlexLayoutViewGenerator(layoutHolder, isPreviewLayout, flexTableParameterJSONChanged, 
                    listParameters, chartParameter).generateHeader();
             
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex)));
           LogExceptionHandler.logException(ex);            
        }
        return null;
       
    }

    public PageReference saveRecordTypeId(){    // Dk : Spring Cleanup 7-5-16
        return null;
    }
    
             
    
    //This method uses header & subheader variables. header holds the object name. subheader holds the value from Name field
    public String getPageHeader() {
        String txt = ''; 
        if (String.isEmpty(rcrdId)) {  //means create context
            if(layoutHolder !=null){
                if(!String.isEmpty(layoutHolder.layout.headerOverride)) {
                    txt = layoutHolder.layout.headerOverride;
                }else if (previewLayoutId != null && layoutHolder.layout.header != null) { //for perview for planning tab
                    //txt = header;
                    txt = layoutHolder.layout.header;               
                }else if(previewLayoutId != null && layoutHolder.layout.header == null) {
                    txt = header;
                }else {
                    //txt = 'Create ' + header;
                    if(layoutHolder.layout.headerNew != null){
                        txt = layoutHolder.layout.headerNew;
                        }
                        else{
                            txt = 'Create ' + header;
                        }                    
                    txt = applyRecordType(txt);    
                }
            }    
            txt = txt.replace(' - ', '<br />'); //User Story 131586: NED - User Registration Header Changes
             
           
        }
        else {  //means view or edit context
            if(isCustomHeader){
                txt = subheader;
            }else if(parentLytId !=null || parentLytId != 'Undefined' || parentLytId != '' ){               
                txt = ''+subheader;
            }
            else{
                txt = header + ' ' + type + ' - ' + subheader;
            }
        }
        
        
        String isPreview = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('isPreviewLayout'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 

        if (isPreview == 'true' && parentLytId != null) {
            //Task 122643: Test 8 --> Grantee -->Federal Financial Report Form (FFR SF-425)--> Preview --> Form name is incorrect and rows from transaction section are not present.
            if(layoutHolder.pageTemplate.DisplayName__c != null) {
               // txt = layoutHolder.layout.header + ' - Preview';
                txt = layoutHolder.pageTemplate.DisplayName__c + ' - Preview';
            }else {
                txt = ' Preview';
            }
        }else if(isPreview == 'true'){
            txt += ' - Preview';
        }
        //if(layoutHolder.layout.headerNew != null){ //Start User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable         
           // txt = layoutHolder.layout.headerNew;            
        //}  //End User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
        return txt;        
    }    

    private String applyRecordType(String data) {
        
        if (!String.isEmpty(recordTypeName)) {
            data = data + ' (' + recordTypeName + ')';
        }
        return data;
    }
    
    /*
    * Method to return the instance of this controller
    */
    public DynamicLayoutController getInstance(){
        return this;
    }
   
    private Boolean isRequiredFieldMissing() {
        Boolean isRequired = false;
        sObject recValues = layoutHolder.getPrimarySObject();
        //check active tab count
        Integer tabCount = 0;
        for(PageLayoutConfigHelper.Tab t : layoutHolder.layout.tabs){
            if(t.active && t.hideTab != 'true' && t.isOverview != true){
                tabCount++;
                // purpose is to check if tab count is greater than zero
                if(tabCount > 1) {
                    break;
                }
            }
        }

        String errorLabel = (tabCount > 1) ? Label.RequiredFieldMessage : Label.RequiredFieldMessageForWithoutTab;
        for(PageLayoutConfigHelper.Tab t : layoutHolder.layout.tabs){
            if(t.active && t.hideTab != 'true' && t.isOverview != true){
                for( PageLayoutConfigHelper.PageBlock pb : t.pageBlocks){
                	if (pb.isHiddenPageBlock || pb.hidePageBlock == 'true'){
                        continue; 
                    }
                    evaluateHideFields(pb.fields,layoutHolder);
                    for(PageLayoutConfigHelper.Field field : pb.fields){
                        
                    if(!fieldsToHide.contains(field.fieldAPIName)){    
                        if(field.fieldType == 'Captcha'){
                            sObject obj = layoutHolder.recordMap.get(layoutHolder.layout.objectName);
                            String squery = 'SELECT Id,'+field.fieldAPIName+' FROM '+String.escapeSingleQuotes(layoutHolder.layout.objectName) +' WHERE Id =:obj.Id ';
                            Sobject sobj;
                            if(AppUtils.isObjectAccessible(layoutHolder.layout.objectName)){     //CRUD/FLS False +ve with the help of AppUtils we have performed check
                                sobj = Database.query(String.escapeSingleQuotes(squery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                            }
                            if((Boolean)sobj.get(field.fieldAPIName) == true){
                                obj.put(field.fieldAPIName,true);
                                layoutHolder.recordMap.put(layoutHolder.layout.objectName,obj);
                                recValues.put(field.fieldAPIName,true);
                            }else{
                                obj.put(field.fieldAPIName,false);
                                layoutHolder.recordMap.put(layoutHolder.layout.objectName,obj);
                                recValues.put(field.fieldAPIName,false);
                                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please validate captcha below.');
                                isRequired = true;
                                ApexPages.addMessage(errorMsg);
                            }
                        }
                        // Validating of URL...........
                    if(String.isNotBlank(field.fieldAPIName)){
                        if(SchemaManager.getFieldSchemaResult(layoutHolder.layout.objectName, field.fieldAPIName).fieldDesc.getType() == Schema.DisplayType.URL){
                            String recordValStr = String.valueOf(recValues.get(field.fieldAPIName));
                            if(String.isNotBlank(recordValStr)){
                                Boolean validUrl = AppUtils.validateURLFormat(recordValStr);
                                if(validUrl == false){
                                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, field.fieldLabel + ': Please enter valid URL value.');
                                    isRequired = true;
                                    ApexPages.addMessage(errorMsg);
                                }
                            }
                        }
                    }

                   	if (field.isHiddenField || field.hideField == 'true' || field.isReadOnlyField || String.isEmpty(field.fieldAPIName) || field.isRelationshipFieldType || field.required == false){
                            continue;
                    }
                    if(SchemaManager.getFieldSchemaResult(layoutHolder.layout.objectName, field.fieldAPIName).isUpdatable != true && !AppUtils.isSkipPermissionCheck()){
                            continue;
                    }
						Boolean isValueBlank = false;
                        if(recValues.get(field.fieldAPIName) == ''){
                             isValueBlank = String.isBlank(String.valueOf(recValues.get(field.fieldAPIName)));
                        }

                        if(((recValues.get(field.fieldAPIName) == null) || isValueBlank)){
                            if(!(fieldsToHide.contains(field.fieldAPIName))){
                            String errorMsgStr  = string.format(errorLabel, new String[]{field.fieldLabel,t.Name,'\''+field.fieldAPIName+'\'','\''+t.tabId+'\''});
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMsgStr, 'GGFrameworkMessage');
                            ApexPages.addMessage(errorMsg);
                            }
                            isRequired = true;
                        }
                            if(isRequired && fieldsToHide.contains(field.fieldAPIName)){
                                isRequired = false;
                        }
                      }
                       
                    }
                }
               
            }
        }
        return isRequired;
    }
    private static void evaluateHideFields(List<PageLayoutConfigHelper.Field> fields,DynamicLayoutHolder layoutHolder) {
        for(PageLayoutConfigHelper.Field f : fields){
        if(String.isNotEmpty(f.hideFieldsJSON)){
            String hideVal=''; 
            list<Map<String,String>> hideValuesMap = (List<Map<String,String>>)JSON.deserialize(f.hideFieldsJSON, List<Map<String,String>>.class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
            String selectedValue = String.valueof(layoutHolder.getFieldValue(f));
            for(Map<String,String> mapVal : hideValuesMap){
                String operation = mapVal.get('Action');
                if(String.isempty(operation) || operation == 'hide'){
                    String fieldToHideApiname = mapVal.get('FieldToHide');
                    String operator = mapVal.get('Operator');
                    if(f.dataType =='REFERENCE'){
                        sObject objVal;
                        objVal = layoutHolder.recordMap.get(f.getAdjustedObjectAPIName());
                        if(objVal !=null){
                            string objName = f.getAdjustedFieldAPIName().replace('__c','__r');
                            if(objVal.getSobject(objName)!=null){
                                selectedValue = (String)objVal.getSobject(objName).get('Name');
                            }
                        } 
                    }
                    hideVal = mapVal.get('FieldValue'); 
                    hideVal = removeDecimalPart(hideVal);
                    selectedValue = removeDecimalPart(selectedValue);
                    if(operator == '=='){
                        if(String.isNotBlank(selectedValue)){
                            if(selectedValue == hideVal ){
                                fieldsToHide.add(fieldToHideApiname);
                            }
                        }else if(String.isBlank(hideVal) ){
                            fieldsToHide.add(fieldToHideApiname);
                        }
                    }else if(operator == '!='){
                        if(String.isNotBlank(selectedValue)){
                            if(selectedValue != hideVal ){
                                fieldsToHide.add(fieldToHideApiname);
                            }
                        }else if(String.isNotBlank(hideVal)){
                            fieldsToHide.add(fieldToHideApiname);
                        }
                    
                    }else if(operator == 'IN'){
                        List<String> splittedFields = new List<String>();
                        splittedFields = hideVal.split(',');
                        Set<String> splittedSet = new Set<String>();
                        splittedSet.addAll(splittedFields);
                        if(splittedSet.contains(selectedValue)){
                            fieldsToHide.add(fieldToHideApiname);
                        }
                    }else if(operator == 'NOT IN'){
                        List<String> splittedFields = new List<String>();
                        splittedFields = hideVal.split(',');
                        Set<String> splittedSet = new Set<String>();
                        splittedSet.addAll(splittedFields);
                        if(splittedSet.contains(selectedValue) == false){
                            fieldsToHide.add(fieldToHideApiname);
                        }
                    }
                }
            }
        }
        }
    }

    private static String removeDecimalPart(String fieldVal){
        List<String> decimalVal = String.isNotBlank(fieldVal) ? fieldVal.split('\\.') : null;
        if(decimalVal != null && decimalVal.size() > 1){
            fieldVal =(decimalVal.get(1) == '0' || decimalVal.get(1) == '00' || decimalVal.get(1) == '000') ? decimalVal.get(0) : fieldVal;
            return fieldVal.replaceAll(',', '');
        }
        return fieldVal;
    }

    /*
    * Method to save the dynamic layout
    *   Input: savePageURL - fed from the page
    */
    public PageReference saveRecord() {
        PageReference newPage;
        Savepoint sp = Database.setSavepoint();
        this.disableRecordLocking = KeyValueStoreHelper.getBooleanValue('DisableRecordLocking', true) == null ? true : KeyValueStoreHelper.getBooleanValue('DisableRecordLocking', true);
        
        ID rcrdId;
        if(SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id')) != null){   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            rcrdId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        }
        

        if(rcrdId != null && !this.disableRecordLocking){
            String sObjName = rcrdId.getSObjectType().getDescribe().getName();
            String strQuery = ' SELECT Id, LastModifiedDate FROM ' + string.escapeSingleQuotes(sObjName) + ' WHERE ID = : rcrdId ';
            List<SObject> listData;
            if(AppUtils.isObjectAccessible(sObjName)){//CRUD/FLS False +ve with the help of AppUtils we have performed check
                listData = Database.query(String.escapeSingleQuotes(strQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            }
            DateTime lastmodifieddateonload = (DateTime)listData[0].get('LastModifiedDate');
          
            If(this.lastmodifieddateonloadofpage != NULL && this.lastmodifieddateonloadofpage != lastmodifieddateonload){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.RecordlockingErrorMessage));
                return null;
            }
            else{
                this.lastmodifieddateonloadofpage = lastmodifieddateonload;
            }
        }
      

        List<String> fieldName = new List<String>();
        try{
            if(layoutHolder!=null) {
               
                if(isRequiredFieldMissing()){
                    return null;
                }
                
                // remove isReadOnly field
                Set<String> isReadOnlyFieldNameList = new Set<String>();
                Integer count = 0;
                Map<String,Integer> duplicateFieldNameCount = new Map<String,Integer>();
                for(PageLayoutConfigHelper.Tab t : layoutHolder.layout.tabs){
                    if(!t.isOverview){
                        for(PageLayoutConfigHelper.PageBlock SinglePageBlock : t.pageBlocks){
                            for(PageLayoutConfigHelper.Field field : SinglePageBlock.fields){
                                if(!duplicateFieldNameCount.containsKey(field.fieldAPIName)){
                                    count = 1;
                                    duplicateFieldNameCount.put(field.fieldAPIName, count);
                                }else{
                                    count = duplicateFieldNameCount.get(field.fieldAPIName) + 1 ;
                                    duplicateFieldNameCount.put(field.fieldAPIName, count);
                                }

                                if(field.isReadOnlyField == true && field.isRelationshipFieldType != true && !(duplicateFieldNameCount.get(field.fieldAPIName) > 1) ){
                                     isReadOnlyFieldNameList.add(field.fieldAPIName);
                                }
                                count = 0;//reset
                            }
                        }
                    }   
                }
                if(isReadOnlyFieldNameList.size()>0 && rcrdId != null){
                    String soqlQuery = 'SELECT Id, ';
                    for(String fieldApiName : isReadOnlyFieldNameList){
                        soqlQuery +=String.escapeSingleQuotes(fieldApiName)+',';
                    }
                    soqlQuery  = soqlQuery.removeEnd(',');
                    soqlQuery += ' FROM '+String.escapeSingleQuotes(layoutHolder.objName)+' WHERE Id =:rcrdId ';
                    SObject updatedLayoutHolder = layoutHolder.recordMap.get(layoutHolder.objName);
                    Sobject updatedRecord = null;
                    if(AppUtils.isObjectAccessible(layoutHolder.objName)){
                        try {
                            updatedRecord = Database.query(String.escapeSingleQuotes(soqlQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                        } catch (Exception ex) {
                            updatedRecord = null;
                        }
                        if(updatedRecord != null){
                            for(String fieldApiName : isReadOnlyFieldNameList){
                                try {
                                    updatedLayoutHolder.put(fieldApiName, updatedRecord.get(fieldApiName));
                                } catch (Exception ex) {
                                 
                                } 
                            }
                        }
                    }
                    layoutHolder.recordMap.put(layoutHolder.objName,updatedLayoutHolder);
                }
                
                if (layoutHolder.checkForValidationErrors(layoutHolder.getPrimarySObject()) == false) {
		            return null; 
		        }
		        
                populateTriggerParameterMap();
                Boolean success = layoutHolder.upsertDynamicRecords();
                if (success == false) {
                    hasErrors = true;
                    return null;  
                }

                if(success == true){
                    if(pkgId != null){
                        AppUtils.createFormInstanceRecord(pkgId,layoutHolder.getPrimarySObject().Id, formTypeList);
                    }
                }
          
                if(savePage != null) {
                    newPage = savePage;                 
                 
                    if(skipUpdateAccessCheckForGuestUser && SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('gurid')) != null) {    //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                        newPage.getParameters().put('gurid', layoutHolder.getPrimarySObject().Id);
                    } else if(SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id')) == null  && newPage.getParameters().get('id') == null) {   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                        newPage.getParameters().put('id',layoutHolder.getPrimarySObject().Id);
                    }                      
                } else {
                    newPage = new PageReference(URL.getOrgDomainURL().toExternalForm()+'/' + layoutHolder.getPrimarySObject().Id);
                    if(layoutHolder.pageTemplate.RedirectBehaviour__c == 'Save and Close Modal') {
                        String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
              
                        String targetURL = 'https://' + hostVal;
                        targetURL += layoutHolder.pageTemplate.NextPageURL__c;// SFDCEncoder.SFDC_URLENCODE(layoutHolder.pageTemplate.NextPageURL__c);
                        PageReference nextPage = new PageReference(EncodingUtil.urlEncode(targetURL,'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
                        nextPage.setRedirect(true);
                        if(skipUpdateAccessCheckForGuestUser) {
                            nextPage.getParameters().put('gurid', layoutHolder.getPrimarySObject().Id);
                        } else {
                            nextPage.getParameters().put('id', layoutHolder.getPrimarySObject().Id);
                        }
                        savePage = nextPage;
                        hasErrors = false;
                        return null;
                    }
                }
                if(layoutHolder.layout != null) {
                    String tableName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('TableName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                    String tableType = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('TableType'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                    String refreshBehaviour = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('RefreshBehaviour'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                    if(layoutHolder.layout.closeOnSave || (String.isNotEmpty(refreshBehaviour) && refreshBehaviour != 'null')) {
                        hasErrors = false;
                        newPage = null;
                    }
                }     
            }
        }
        catch(System.Exception e){
            Database.rollback(sp);
            hasErrors = true;
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,AppUtils.handleSystemExceptionMsg(e));
            ApexPages.AddMessage(errMsg);
            return null;
        }
        if (newPage != null) {
            newPage.setRedirect(true);
        }
        return newPage;
    }
    
    public PageReference saveAndContinue() {
        PageReference newPage;
        Savepoint sp = Database.setSavepoint();
        try{
            if(layoutHolder!=null){
            	if(isRequiredFieldMissing()){
                    return null;
                }
                
                if (layoutHolder.checkForValidationErrors(layoutHolder.getPrimarySObject()) == false) {
		            return null; //errors are found
		        }
                
                populateTriggerParameterMap();
                Boolean success = layoutHolder.upsertDynamicRecords();
                if (success == false) {
                    hasErrors = true;
                    return null;  //return errors back to UI
                }
                //redirect to the new page
                newPage = continueRecord();
                // User Story 127005: Internal - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users - Part 2
                if(skipUpdateAccessCheckForGuestUser) {
                    newPage.getParameters().put('gurid',layoutHolder.getPrimarySObject().Id);
                } else {
                    newPage.getParameters().put('id', layoutHolder.getPrimarySObject().Id);
                }
            }
        }
        catch(System.Exception e){
            Database.rollback(sp);
            hasErrors = true;
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,AppUtils.handleSystemExceptionMsg(e));
            ApexPages.AddMessage(errMsg);
            return null;
        }
        if (newPage != null) {
            newPage.setRedirect(true);
        }
        return newPage;
    }
    
    public PageReference continueRecord() {
        try{
			if(isRequiredFieldMissing()){
                return null;
            }
            
            if (layoutHolder.checkForValidationErrors(layoutHolder.getPrimarySObject()) == false) {
	            return null; //errors are found
	        }
            Map<String, Object> recordData = layoutHolder.getRecordData();
            Map<String, String> existingDataMap = ApexPages.CurrentPage().getParameters();
            String hostVal  = ApexPages.currentPage().getHeaders().get('Host');
            // Modified on 2 July 2020 to resolve Encoded URL issue
            String targetURL = 'https://' + hostVal;
            targetURL += layoutHolder.pageTemplate.NextPageURL__c;// SFDCEncoder.SFDC_URLENCODE(layoutHolder.pageTemplate.NextPageURL__c);
            PageReference nextPage = new PageReference(EncodingUtil.urlEncode(targetURL,'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
            nextPage.setRedirect(true);
            SObject sobj = layoutHolder.getPrimarySObject();
            Id pageDataHolderId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('pageDataHolder')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            String retURL;
            if(SFDCEncoder.SFDC_URLENCODE(ApexPages.CurrentPage().getParameters().get('retURL')) != null){     //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                //Bug 196625: Internal: When click on "Associate forms" button on 'Create Packages' modal then "invalid page redirection" error message are display
                String retURL1;
                retURL1 = SFDCEncoder.SFDC_URLENCODE(ApexPages.CurrentPage().getParameters().get('retURL'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                retURL = retURL1.replace('https',''); 
            }
            if(Schema.sObjectType.PageDataHolder__c.fields.JSONData1__c.isCreateable() && Schema.sObjectType.PageDataHolder__c.fields.JSONData1__c.isUpdateable()){
            PageDataHolder__c pageDataHolder = new PageDataHolder__c(Id=pageDataHolderId, JSONData1__c= JSON.serialize(sobj));
            if(Schema.sObjectType.PageDataHolder__c.isCreateable() && Schema.sObjectType.PageDataHolder__c.isUpdateable()){
                upsert as user  pageDataHolder;
                    nextPage.getParameters().put('pageDataHolder', pageDataHolder.Id);
                }
            }
            hasErrors = false;
            
            if(retURL != null) {
                nextPage.getParameters().put('retURL', retURL);
            }
            if(layoutHolder.pageTemplate.RedirectBehaviour__c == 'Continue And Close Modal') {
                savePage = nextPage;
                return null;
            } else {
                return nextPage;
            }
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex.getMessage())));
            CustomExceptions.logException(ex, true, false);
        }
        return null;
    }
      
    private boolean isAutoCreate(){
        if(rcrdId != null && rcrdId!= ''){
            Id ObjId = (Id)rcrdId;
            String objName = ObjId.getSObjectType().getDescribe().getName();
        }
        return false;
    }
    
    public String getFormTypeJSON() {
        if(formTypeList == null) {
            formTypeList = new List<String>();
        }else{
            list<String> str = new list<String>(); 
            for(String s : formTypeList){
                str.add(SFDCEncoder.SFDC_HTMLENCODE(s));
            }
            return JSON.serialize(str);
        }
        return JSON.serialize(formTypeList);
    }
    
    /*
    * Method to edit the record 
    *   RecordId/e - Action override will take care of the rest
    */
    public PageReference edit()
    {   
        PageReference pageRef = new PageReference(URL.getOrgDomainURL().toExternalForm() +'/'+rcrdId+'/e');  
        pageRef.SetRedirect(true);  
        return pageRef;  
    }
    
    public String pgLayoutId{get;set;}
    public String recTypeId {get;set;}
    public String recTypeName {get;set;}
    public String redirectUrl{get;set;}
    public void saveSelection(){
        redirectUrl = Apexpages.currentPage().getUrl();
        redirectUrl = ((redirectUrl.indexOf('?')!=-1) ? '&' : '?') + 'pageLayoutId='+pgLayoutId+'&recordTypeId='+recTypeId+'&rtName='+recTypeName;    
    }
    
    @RemoteAction
    global static void markPageLayoutAsActive(map<string,object>args){
        Id pageLayoutIdVal;
        
        string tmplName = (string)args.get('key');       
        String type =(string)args.get('value');
        
        List<PageTemplate__c> pageTemplateList = new List<PageTemplate__c>();
        if(Schema.sObjectType.PageTemplate__c.isAccessible()){
            pageTemplateList = [SELECT Id,Name,
                EditLayoutConfig__r.IsActive__c,PrintLayoutConfig__r.IsActive__c,ViewLayoutConfig__r.IsActive__c
                FROM PageTemplate__c WHERE Name = : tmplName WITH USER_MODE];
        }
        if(!pageTemplateList.isEmpty()){
            if(type =='Print' && pageTemplateList[0].PrintLayoutConfig__r.IsActive__c == false){
                pageLayoutIdVal = pageTemplateList[0].PrintLayoutConfig__c;
            }else if(type =='Edit' && pageTemplateList[0].EditLayoutConfig__r.IsActive__c == false){
                pageLayoutIdVal = pageTemplateList[0].EditLayoutConfig__c;
            }else if(type =='View' && pageTemplateList[0].ViewLayoutConfig__r.IsActive__c == false) {               
                pageLayoutIdVal = pageTemplateList[0].ViewLayoutConfig__c;
            }
            if(pageLayoutIdVal != null){
                if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
                    try{
                        PageLayoutConfig__c pageLayout = [SELECT Id,IsActive__c FROM PageLayoutConfig__c WHERE Id=:pageLayoutIdVal AND IsActive__c = true WITH USER_MODE LIMIT 1];
                    if(Schema.sObjectType.PageLayoutConfig__c.fields.IsActive__c.isUpdateable()){
                        pageLayout.IsActive__c = true;
                    }
                    if(Schema.sObjectType.PageLayoutConfig__c.isUpdateable()){
                        update as user pageLayout;
                    }
                    }catch(Exception ex){
                    }
                }
            }
        }else{
        throw new CustomExceptions.RequiredException('No record found for page template : '+tmplName);      
        }
    }
    
    /*
    * Check if template is associated with record types
    */
    private  boolean checkIfRecordTypePresent(){
            recordTypeExists = false;            
            Map<String,Object> tempflexTableParams ;//= new Map<String,Object>();
            if(!String.isEmpty(flexTableParameterJSON)){
                tempflexTableParams =(Map<String,Object>)JSON.deserializeUntyped(flexTableParameterJSON);
            }            
            if(tempflexTableParams != null){
                if(String.isNotEmpty(rcrdId)) {
        			//convert to 18 digit Id. It will helpful to render attchment and form Table.
                    String id18Digit = String.valueOf(Id.valueOf(rcrdId));
	                tempflexTableParams.put('parentRecordIdOfFlexTable', id18Digit);
	                tempflexTableParams.put('RecordId', id18Digit);
					tempflexTableParams.put('recordId', id18Digit);
                    tempflexTableParams.put('RecordId15', id18Digit.substring(0, 14));
            	}
                flexTableParameterJSONChanged = JSON.serialize(tempflexTableParams);                        
            }     
            String templateId;
             if( pkgId != null && pkgId != '' && parentLytId == null ) {
                if(Package__c.sObjectType.getDescribe().isAccessible()){
                      if(packageObj == null){ 
                         packageObj  = [select id,name,PageTemplateConfig__r.Name from Package__c where Id=:pkgId WITH USER_MODE];
                      }
                     if(String.isNotBlank(packageObj.PageTemplateConfig__c)) { //Tomy - 19/04/2018 - ticket 20215 Changes for utah support, allow null value for form config lookup
	                        tmplName = packageObj.PageTemplateConfig__r.Name;
	                        templateId = packageObj.PageTemplateConfig__c;
                    }
                }
            } else if( pkgName != null && pkgName != '' ) {
                if(Package__c.sObjectType.getDescribe().isAccessible()){
                   if(packages == null){
                         packages  = [select id,name,PageTemplateConfig__r.Name from Package__c where Name=:pkgName WITH USER_MODE];
                    } 
                    if(packages.size() > 1){
                        throw new CustomExceptions.InputDataException('Found 2 packages with same Name. Please check with Administrator.');
                    }else if(packages.size() == 0){
                        throw new CustomExceptions.InputDataException('No Package found for given Name.');
                    }
                    if(String.isNotBlank(packages[0].PageTemplateConfig__c)) { //Tomy - 19/04/2018 - ticket 20215 Changes for utah support, allow null value for form config lookup
                        tmplName = packages[0].PageTemplateConfig__r.Name;
                        templateId = packages[0].PageTemplateConfig__c;
                    }
                }
            }
            if(tmplName == null || tmplName == '') {
                String context = String.isNotBlank(rcrdId) ? type : 'Create';
                tmplName = DynamicLayoutHelper.getTemplateName(rcrdId, context, listDefaultValues, sObjectName);
            }
            if(parentLytId != null){
                processForms();
                
            }
            List<PageLayoutConfig__c> pageConfig = new List<PageLayoutConfig__c>();
            if(pageTemplate == null){
                if(Schema.sObjectType.PageTemplate__c.isAccessible()){
                    if(templateId != null ){
                        pageTemplate = [SELECT id,Name,AllowedCharsForRichTextArea__c,AllowedWordsForRichTextArea__c,RTALimitConfig__c,EditLayoutConfig__c,ToolBarGroups__c,ViewLayoutConfig__c,PrintLayoutConfig__c,EditLayoutConfig__r.ObjectApiName__c,EditLayoutConfig__r.HideOnDemandSnaphot__c,
                                            HelpConfig__c,EditLayoutConfig__r.RecordTypeId,EditLayoutConfig__r.RecordTypeWindowTitle__c,RedirectBehaviour__c,NextPageURL__c,
                                            ViewLayoutConfig__r.RecordTypeId,ViewLayoutConfig__r.ObjectApiName__c,ViewLayoutConfig__r.HideOnDemandSnaphot__c,
                                                LabelOverrideSaveandContinue__c,PrintLayoutConfig__r.RecordTypeId,PrintLayoutConfig__r.ObjectApiName__c,OMBNumber__c,Version__c,DisplayName__c,ShowFooterText__c,ShowHeaderText__c,FormDisplayType__c,GroupName__c,LabelOverrideSaveandClose__c,DoNotTranslateForm__c
                                            FROM PageTemplate__c WHERE Id = : templateId WITH USER_MODE];
                    
                    }else{
                        List<PageTemplate__c> pageTemplateList = [SELECT id,Name,AllowedCharsForRichTextArea__c,AllowedWordsForRichTextArea__c,RTALimitConfig__c,ToolBarGroups__c,EditLayoutConfig__c,ViewLayoutConfig__c,PrintLayoutConfig__c,EditLayoutConfig__r.ObjectApiName__c,EditLayoutConfig__r.HideOnDemandSnaphot__c,
                                                HelpConfig__c,EditLayoutConfig__r.RecordTypeId,EditLayoutConfig__r.RecordTypeWindowTitle__c,RedirectBehaviour__c,NextPageURL__c,
                                                ViewLayoutConfig__r.RecordTypeId,ViewLayoutConfig__r.ObjectApiName__c,ViewLayoutConfig__r.HideOnDemandSnaphot__c,
                                                LabelOverrideSaveandContinue__c,PrintLayoutConfig__r.RecordTypeId,PrintLayoutConfig__r.ObjectApiName__c,OMBNumber__c,Version__c,DisplayName__c,ShowFooterText__c,ShowHeaderText__c,FormDisplayType__c,GroupName__c,LabelOverrideSaveandClose__c,DoNotTranslateForm__c
                                                FROM PageTemplate__c WHERE Name = : tmplName WITH USER_MODE];
                        
                        if(pageTemplateList.size() == 0){
                            CustomExceptions.logException(String.format(System.Label.FormEntryLabel, new List<String>{tmplName}), false);
                        }
                        if(pageTemplateList.size() > 1){
                            CustomExceptions.logException(String.format(System.Label.DuplicateForm, new List<String>{tmplName}), false);
                        }
                        pageTemplate = pageTemplateList[0];
                    }
                }

            }
            
            PageLayoutConfigHelper.pageTemplate = pageTemplate;
            if(String.isEmpty(pageTemplate.LabelOverrideSaveandContinue__c)){
            	pageTemplate.LabelOverrideSaveandContinue__c = 'Save and Continue';
            }
            if(parentLytId != null){
                formnumber = pageTemplate.OMBNumber__c;
                formversion = pageTemplate.Version__c;
            }
            if(type =='Print' && pkgId != null) {
                List<PackageFormConfig__c> businessFromList = new List<PackageFormConfig__c>();
                if(PackageFormConfig__c.sObjectType.getDescribe().isAccessible()){
                    if(formTypeList != null && formTypeList.size() > 0) {
                        businessFromList = [SELECT FormConfig__r.PrintLayoutConfig__c,FormPreview__c FROM PackageFormConfig__c WHERE PackageConfig__c =:pkgId and FormConfig__r.FormType__c in:formTypeList  WITH USER_MODE Order By Order__c];
                    } else {
                        businessFromList = [SELECT FormConfig__r.PrintLayoutConfig__c,FormPreview__c FROM PackageFormConfig__c WHERE PackageConfig__c =:pkgId WITH USER_MODE Order By Order__c];
                    }
                    formpreviewList = new List<Id>();
                    if(businessFromList != null) {
                        for(PackageFormConfig__c rerdId : businessFromList) {                                               
                            formpreviewList.add(rerdId.FormPreview__c);
                        }
                    }   
                }        
            }
            If(pageTemplate != null){
                standardObjReqrdFlds(pageTemplate.EditLayoutConfig__r.ObjectApiName__c);
                windowTitle = pageTemplate.EditLayoutConfig__r.RecordTypeWindowTitle__c;
                Id recordTypeId = Schema.SObjectType.PageLayoutConfig__c.getRecordTypeInfosByName().get('Standalone').getRecordTypeId();
                String pageLayoutId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('pageLayoutId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                selectedRecordTypeId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('recordTypeId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                recordTypeName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('rtName')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                
                
                formDisplayType = pageTemplate.FormDisplayType__c;          //For Step base Wizard Approch 
                   
                //Temporary fix. We should optimize SOQL queries
                if(type == 'Print') {
                    PageLayoutConfigHelper.isPrint = true;
                    PageLayoutConfigHelper.formTypeList = formTypeList;
                }
                if(type == 'Edit' && rcrdId == null) {
                    if(pageTemplate.EditLayoutConfig__c != null && pageTemplate.EditLayoutConfig__r.RecordTypeId == recordTypeId && pageLayoutId == null){
                        loadRecordTypes(pageTemplate.EditLayoutConfig__c,pageTemplate.EditLayoutConfig__r.ObjectApiName__c);
                        recordTypeExists = true;
                    }else if(pageLayoutId != null){
                        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
                        pageConfig = [select RecordTypeName__c,RecordTypeDescription__c,ObjectAPIName__c,
                                    ParentLayout__c,Title__c, IsActive__c from PageLayoutConfig__c where id =:pageLayoutId AND IsActive__c = true WITH USER_MODE];
                        }
                        setDynamicLayoutAttributes(pageConfig[0],false);
                        
                    }else{
                        setDynamicLayoutAttributes(pageTemplate,true);
                    }
                }else{
                    String query;
                    Sobject rec; 
                    String recId;
                    String layoutId; 
                    List<Id> layoutIds = new List<Id>();
                    Boolean hasRecordType = false;
                    Boolean isView = false;
                    editRecordTypeId = pageTemplate.EditLayoutConfig__r.RecordTypeId;
                    if(type == 'View' && pageTemplate.ViewLayoutConfig__c != null && pageTemplate.ViewLayoutConfig__r.RecordTypeId == recordTypeId){
                        query = 'select RecordTypeId from '+string.escapeSingleQuotes(pageTemplate.ViewLayoutConfig__r.ObjectApiName__c)+' where id=:rcrdId ';
                        layoutId = pageTemplate.ViewLayoutConfig__c;
                        layoutIds.add(pageTemplate.ViewLayoutConfig__c);
                        hasRecordType = true;
                    }else if(type == 'Print'&& pageTemplate.PrintLayoutConfig__c != null && pageTemplate.PrintLayoutConfig__r.RecordTypeId == recordTypeId){
                        query = 'select RecordTypeId from '+string.escapeSingleQuotes(pageTemplate.PrintLayoutConfig__r.ObjectApiName__c)+' where id=:rcrdId ';
                        layoutId = pageTemplate.PrintLayoutConfig__c;
                        layoutIds.add(pageTemplate.PrintLayoutConfig__c);
                        hasRecordType = true;
                    }else if(type == 'Edit' && pageTemplate.EditLayoutConfig__c != null && pageTemplate.EditLayoutConfig__r.RecordTypeId == recordTypeId){
                        query = 'select RecordTypeId from '+string.escapeSingleQuotes(pageTemplate.EditLayoutConfig__r.ObjectApiName__c)+' where id=:rcrdId ';
                        layoutId  = pageTemplate.EditLayoutConfig__c;
                        layoutIds.add(pageTemplate.EditLayoutConfig__c);
                        hasRecordType = true;
                        
                    }
                    if(hasRecordType == true ){
                        if(AppUtils.isObjectAccessible(pageTemplate.EditLayoutConfig__r.ObjectApiName__c)){  //CRUD/FLS False +ve with the help of AppUtils we have performed check
                            rec = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                        }recId = (String)rec.get('RecordTypeId');
                        
                        List<RecordType> recType = [select DeveloperName from RecordType where id =:recId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                        if(recType.size() > 0){
                            String recordTypeName = recType[0].DeveloperName;
                            String pageConfigQuery = 'select RecordTypeName__c,RecordTypeDescription__c,ObjectAPIName__c,'+
                                'ParentLayout__c,Title__c, IsActive__c from PageLayoutConfig__c where ParentLayout__c in :layoutIds'+
                                ' and RecordTypeName__c =:recordTypeName AND IsActive__c = true ';
                            pageConfig = Database.query(String.escapeSingleQuotes(pageConfigQuery), AccessLevel.USER_MODE);//SOQL Injection - False +ve - No Dynamic part in query string
                        }
                    }       
                    if(pageConfig.size() > 0){
                        setDynamicLayoutAttributes(pageConfig[0],false);
                    }else{
                        setDynamicLayoutAttributes(pageTemplate,true);
                    }
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter valid Template name'));
            }
        return recordTypeExists;
    }
    /*Task 110503: Dev - Internal - Required fields - Show errors at a time for all missing mandatory fields   && !objToken.getDescribe().isCustom()*/
    public void standardObjReqrdFlds( String objName){
        
        //SObjectType objToken = Schema.getGlobalDescribe().get(objName);

        if(SchemaManager.getSObject('Account')  != null && !SchemaManager.getSObject('Account').objectResult.isCustom()){
            //Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
            Set<String> systemField = new Set<String>{'id','isdeleted','hasoptedoutofemail','hasoptedoutoffax','donotcall','ownerid','createddate','createdbyid','lastmodifieddate','lastmodifiedbyid','systemmodstamp','isemailbounced','enable508compliance__c'};
            List<String> rqrdFldLst = new List<String>();
            //Schema.SObjectType s = m.get(objName) ; 
            //Schema.DescribeSObjectResult r = s.getDescribe() ;
            //SchemaManager.SObjectWrapper abc = new SchemaManager.SObjectWrapper();
            //Schema.DescribeSObjectResult r = SchemaManager.getSObject(objName).objectResult.fieldsMap.keySet();
            //Map<String,Schema.SObjectField> fields = r.fields.getMap() ;

            for(String field : SchemaManager.getSObject(objName).fieldsMap.keySet()){
                //Schema.DescribeFieldResult desribeResult = fields.get(field).getDescribe();
                Schema.DescribeFieldResult desribeResult = SchemaManager.getSObject(objName).fieldsMap.get(field).fieldResult;
                if(!desribeResult.isNillable() && !systemField.contains(field)){
                    rqrdFldLst.add(field);
                }
            }
            standardObjRqrdFlds = !rqrdFldLst.isEmpty() ? JSON.serialize(rqrdFldLst):'';
        }
    }

    private void processForms(){
        String formInstanceId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('formInstanceId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String parentRecordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('ParentId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        formTypeList1 = new List<SelectOption>(); 
        String formTitle;
        if(String.isNotEmpty(formInstanceId)){
           newApproachFormProcess(formInstanceId,parentRecordId,formTypeList1,formTitle); 
        }else{
           oldApproachFormProcess(parentRecordId,formTypeList1,formTitle);   
        }
        if(formTypeList1.size() == 1){
            List<SelectOption> formTypeListTemp = new List<SelectOption>{
                new SelectOption('','--Select--')
            }; 
            formTypeListTemp.add(formTypeList1[0]);
            formTypeList1 = formTypeListTemp;
        }
        
    }
    //if we formInstanceId no need to query on package__c and packageBusinessform__c
    private void newApproachFormProcess(String formInstanceId,String parentRecordId,List<SelectOption> formTypeList1,String formTitle){
        parId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('parentId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        List<FormInstance__c> formInstList = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()){
        formInstList = [SELECT Id,PackageBusinessForm__r.IsMandatory__c,IsNotApplicable__c,PackageBusinessForm__r.FormConfig__r.DisplayName__c,PackageBusinessForm__r.FormConfig__r.Hidefromdropdown__c from FormInstance__c where ParentRecordId__c =:parentRecordId WITH USER_MODE ORDER BY PackageBusinessForm__r.Order__c];
        }
            if(formInstList.size() > 0){
                for (FormInstance__c formInstance:formInstList){
                    if (formInstance.id == formInstanceId){
                        formTitle = formInstance.PackageBusinessForm__r.FormConfig__r.DisplayName__c;
                        isMandatory = formInstance.PackageBusinessForm__r.IsMandatory__c;
                    }
                    if(!formInstance.PackageBusinessForm__r.FormConfig__r.Hidefromdropdown__c){
                    formTypeList1.add(new SelectOption(formInstance.id,formInstance.PackageBusinessForm__r.FormConfig__r.DisplayName__c));    
                }
            }
        }
    }

    private void oldApproachFormProcess(String parentRecordId,List<SelectOption> formTypeList1,String formTitle){
        Package__c packageObj;
        String frmIdCurrent;
        parId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('parentId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        frmIdCurrent = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('formId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if( formTypeList == null || formTypeList.size() == 0 ) {
            packageObj = [SELECT Id, Name,PageTemplateConfig__c,ValidateFormFieldAPIName__c, (SELECT FormConfig__r.Name,FormConfig__r.DisplayName__c,FormConfig__r.Id,FormConfig__r.OMBNumber__c,FormConfig__r.Hidefromdropdown__c,FormConfig__r.Version__c,Order__c,isMandatory__c FROM PackageFormsConfig__r order By Order__c )  FROM Package__c WHERE Id=: pkgId WITH USER_MODE];
        }else{
            packageObj = [SELECT Id, Name,PageTemplateConfig__c,ValidateFormFieldAPIName__c, (SELECT FormConfig__r.Name,FormConfig__r.DisplayName__c,FormConfig__r.Id,FormConfig__r.OMBNumber__c,FormConfig__r.Hidefromdropdown__c,FormConfig__r.Version__c,Order__c,isMandatory__c FROM PackageFormsConfig__r where FormConfig__r.FormType__c in:formTypeList order By Order__c )  FROM Package__c WHERE Id=: pkgId WITH USER_MODE];               
        }
        for(PackageFormConfig__c packageForm: packageObj.PackageFormsConfig__r) { 
            if(packageForm.FormConfig__c == null){
                continue; //when form config is null do not show in picklist. It was breaking in case of external forms
            }
            
            if(!packageForm.FormConfig__r.Hidefromdropdown__c){
            formTypeList1.add(new SelectOption(packageForm.FormConfig__r.Id,packageForm.FormConfig__r.DisplayName__c));
            }
            formTitle = packageForm.FormConfig__r.DisplayName__c;
            lastFormOrder = packageForm.Order__c;
            if(frmIdCurrent == packageForm.FormConfig__r.Id){
                currentOrder = packageForm.Order__c;
                isMandatory = packageForm.isMandatory__c;
            } 
        }     
    }
    public void formSavedMessage() {        
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.FormSavedSuccessfully);
            ApexPages.addMessage(myMsg); 
    }
     
    public PageReference saveFormRecord() {
        Savepoint sp = Database.setSavepoint();
        try {
            if(layoutHolder != null) {
                if(isRequiredFieldMissing()){
                        return null;
                    }
                    
                    if (layoutHolder.checkForValidationErrors(layoutHolder.getPrimarySObject()) == false) {
                        return null; //errors are found
                    }
                    populateTriggerParameterMap();
                Boolean success = layoutHolder.upsertDynamicRecords();
                if (success == false) {
                    hasErrors = true;
                    return null;  //return errors back to UI
                }
                if(success == true){
                    hasErrors = false;
                    updateFormInstancePercent();
                    return redirectToFormView();
                }
                //Get Percentage Form Complete
            }
        }
        catch(System.Exception e) {
            Database.rollback(sp);
            hasErrors = true;
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,AppUtils.handleSystemExceptionMsg(e));
            ApexPages.AddMessage(errMsg);
            return null;
        }
        return null;
    }

    private PageReference redirectToFormView(){
        String pkagId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('packageId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String formInstanceId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formInstanceId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String parentLayoutId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentLayoutId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String frmId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String parentId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String formType = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formTypes'));   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String templateName = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('templateName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String rcrdId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String hostVal  = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getHeaders().get('Host'));
        String targetURL = 'https://' + hostVal+ '/apex/DynamicFormView?formTypes='+ SFDCEncoder.SFDC_JSDECODE(formtype) +'&formId='+ frmId +'&id='+ rcrdId +'&packageId='+ pkagId +'&parentId='+ parentId +'&parentLayoutId='+ parentLayoutId +'&templateName='+ templateName + '&isFormSaved=true';
        String strTargetFormInstanceUrl = '';
        if(String.isNotEmpty(formInstanceId)){
            strTargetFormInstanceUrl = targetURL+'&formInstanceId='+formInstanceId;           
        }else{
            strTargetFormInstanceUrl = targetURL;
        }
        PageReference pf = new PageReference(EncodingUtil.urlEncode(strTargetFormInstanceUrl,'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding        
        pf.setRedirect(true); 
        return pf;
    }

    /* Update Form Instance Percentage Col*/
    private void updateFormInstancePercent(){
        Id frmId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formId'));
        Id formInstanceId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formInstanceId'));
        Id rcrdId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));
        Map<String, FlexUtils.FormCompletionDTO> formMap = new Map<String, FlexUtils.FormCompletionDTO>();
        List<FormInstance__c> formInst = new List<FormInstance__c>(); 
        Id pckBuFormId;
        Double percentComplete = 0.00;
        formMap = FlexUtils.getLayoutCompletionOnFormId(String.valueOf(rcrdId), String.valueOf(frmId));
        //update Form Instance Percentage Field 
        List<FormInstance__c> fcInstance = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()) {
            fcInstance = [SELECT Id, PackageBusinessForm__c,IsNotApplicable__c FROM FormInstance__c WHERE FormId__c =:rcrdId WITH USER_MODE];
        }
        if(fcInstance.size() > 0){
          pckBuFormId = fcInstance[0].PackageBusinessForm__c;
        }
        if(pckBuFormId !=null){
            if(Schema.sObjectType.FormInstance__c.isAccessible()) 
             formInst = [SELECT Percentage__c, FormId__c, PackageBusinessForm__c, ParentRecordId__c,IsNotApplicable__c FROM FormInstance__c WHERE Id=:formInstanceId WITH USER_MODE];
         }
        if(formMap !=null){
            for(FlexUtils.FormCompletionDTO formDto:formMap.values()){
                percentComplete = formDto.submitPercentage;
                if(percentComplete > 100){
                    percentComplete = 100.00;
                }
            }
        }else{
             percentComplete = 0.0;
        }
        if(formInst.size() > 0){
            if(Schema.sObjectType.FormInstance__c.fields.IsNotApplicable__c.isCreateable() && Schema.sObjectType.FormInstance__c.fields.IsNotApplicable__c.isUpdateable()){
                formInst[0].IsNotApplicable__c = isNotApplicable == null?false:isNotApplicable;
            }
            if(Schema.sObjectType.FormInstance__c.fields.Percentage__c.isCreateable() && Schema.sObjectType.FormInstance__c.fields.Percentage__c.isUpdateable()){
                if(formInst[0].IsNotApplicable__c == true){
                    formInst[0].Percentage__c = 100.00;
                }else{
                    formInst[0].Percentage__c = percentComplete;
                }
            }
             if(Schema.sObjectType.FormInstance__c.isCreateable() && Schema.sObjectType.FormInstance__c.isUpdateable()){
                 upsert as user formInst;
             }
        }     
    }
    
    /*For Navigation*/

    @RemoteAction    
    global static String  navForms1(String url,String value,String selectedform) { 
        return '';
    }   
 
    private static String newApproachNavigateForm(String selectedFormId,PageReference newurl){
        List<FormInstance__c> formInstance = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()){
        formInstance = [SELECT id,PackageBusinessForm__r.PackageConfig__r.PageTemplateConfig__r.SObjectName__c,
                                                PackageBusinessForm__r.FormConfig__r.id,PackageBusinessForm__r.FormConfig__r.SObjectName__c,FormId__c,
                                                PackageBusinessForm__r.FormConfig__r.Name,PackageBusinessForm__r.FormConfig__r.ParentObjectFieldAPI__c from 
                                                FormInstance__c where Id =:selectedFormId WITH USER_MODE];    
        }
        Map<String, String> params  =  newurl.getParameters();
        params.remove('id');
        params.remove('formInstanceId');
        params.remove('formId');
        params.remove('templateName');
        params.put('id',formInstance[0].FormId__c);
        params.put('formInstanceId',formInstance[0].id);
        params.put('formId',formInstance[0].PackageBusinessForm__r.FormConfig__r.id);
        params.put('templateName',formInstance[0].PackageBusinessForm__r.FormConfig__r.Name);
        params.put('isFormSaved','false');
        String enUrl = EncodingUtil.urlEncode(newurl.getUrl(), 'UTF-8');       
        return enUrl;
    }

    private static String oldApproachNavigateForm(String selectedFormId, PageReference newurl){
        String nextFrmTemplate; 
        String objName;    
        Package__c packageObj; 
        String objectAPIName = null;  
        String parentObjectFieldAPIName = null;   
        String packageReferenceFieldAPIName = null; 
        String parentId = newurl.getParameters().get('parentId');
        String pkagId = newurl.getParameters().get('packageId');
        if(Schema.sObjectType.Package__c.isAccessible()){
            packageObj = [SELECT Id, Name,PageTemplateConfig__c,PageTemplateConfig__r.SObjectName__c,PageTemplateConfig__r.ParentObjectFieldAPI__c,(SELECT FormConfig__r.Name,FormConfig__r.SObjectName__c,FormConfig__r.ParentObjectFieldAPI__c,FormConfig__r.Id,Order__c FROM PackageFormsConfig__r order By Order__c )  FROM Package__c WHERE Id =: pkagId WITH USER_MODE];
        }
        objName = packageObj.PageTemplateConfig__r.SObjectName__c;
        for(PackageFormConfig__c packageForm: packageObj.PackageFormsConfig__r){
            if(packageForm.FormConfig__r.Id == selectedFormId){
                objectAPIName =  packageForm.FormConfig__r.SObjectName__c;
                nextFrmTemplate = packageForm.FormConfig__r.Name;
                parentObjectFieldAPIName = packageForm.FormConfig__r.ParentObjectFieldAPI__c;
            }
        }
        SObjectType sObjType = Schema.getGlobalDescribe().get(objectAPIName);
        Map<String, Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();
        for(Schema.SObjectField sObjField : mfields.values()){
            Schema.DescribeFieldResult fldDesc = sObjField.getDescribe();
            if( fldDesc.getType().name() == 'REFERENCE') {
               if( (fldDesc.getReferenceTo()[0]).getDescribe().getName() == AppUtils.getnamespacePrefix()+'PageTemplate__c'){
                   packageReferenceFieldAPIName = fldDesc.getName();
               }
             }             
        }
        if(selectedFormId != '' && selectedFormId!='None'){
            if(objName != objectAPIName){
                String query1 = 'SELECT Id From ' + sObjType +' WHERE '+ string.escapeSingleQuotes(parentObjectFieldAPIName)  + ' = :parentId AND '+ string.escapeSingleQuotes(packageReferenceFieldAPIName) + '= : selectedformId ';
                List<Sobject> result;
                if(AppUtils.isObjectAccessible(parentObjectFieldAPIName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    result = Database.query(String.escapeSingleQuotes(query1), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                }
                if(result != Null && result.size()>0) {
                    newurl.getParameters().put('id', result[0].Id);
                }else {
                    Map<String, String> params  =  newurl.getParameters();
                    params.remove('id'); 
                    newurl.getParameters().putAll(params);                  
                }
            }else{
                newurl.getParameters().put('id',parentId);
            }
            newurl.getParameters().put('isFormSaved', 'false');                        
            newurl.getParameters().put('templateName', nextFrmTemplate);  
            Map<String, String> params  =  newurl.getParameters();
            params.remove('formId');
            params.put('formId',selectedFormId);
            newurl.getParameters().putAll(params);
        } 
        String enUrl = EncodingUtil.urlEncode(newurl.getUrl(), 'UTF-8');
        return enUrl;
    }
    /*
    * Load the recordTypes associated with the pageLayout
    */
    
   private void loadRecordTypes(Id pgConfigId,String objectName){
         recordTypeWrapper = new List<RecordTypeWrapper>();
         List<PageLayoutConfig__c> pageConfigs = new List<PageLayoutConfig__c>();
         Map<String,RecordType> mapNames = new Map<String,RecordType>();
        
         Map<Id,RecordType> recordTypeMp = new Map<Id,RecordType>([select id,developerName,name from RecordType
                                                 where SobjectType =:objectName WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
         for(String recordTypeName :recordTypeMp.keyset()){
            mapNames.put(recordTypeMp.get(recordTypeName).developerName,recordTypeMp.get(recordTypeName));
         }
         if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
         pageConfigs = [select RecordTypeName__c,RecordTypeDescription__c,ObjectAPIName__c,
                        sequence__c,ParentLayout__c,Title__c, IsActive__c from PageLayoutConfig__c where ParentLayout__c = :pgConfigId AND IsActive__c = true WITH USER_MODE];
         }
         for(PageLayoutConfig__c pageConfig :pageConfigs){
            String recordTypeLabel = mapNames.get(pageConfig.RecordTypeName__c).Name;
            String recordTypeId = mapNames.get(pageConfig.RecordTypeName__c).Id;
            recordTypeWrapper.add(new RecordTypeWrapper(pageConfig,recordTypeLabel,recordTypeId,pageConfig.RecordTypeDescription__c));
         }
         recordTypeWrapper.sort();
     }
    
    
    /*
    * Method to Load the layout for dynamic page layout based on PageTemplate__c Name and recordId PageTemplate__c pageTemplate
    */
    //TODO: refactor this method in smaller units
    private void setDynamicLayoutAttributes(Sobject layoutObject,Boolean isPageTemplate) {
        namespace = AppUtils.getNamespacePrefix();
       // if(layoutObject.getSobjectType()== Schema.PageTemplate__c.getSObjectType()){
          if(isPageTemplate){
            layoutId = (String)layoutObject.get(namespace+'ViewLayoutConfig__c');
            printLayoutId =(String)layoutObject.get(namespace+'PrintLayoutConfig__c');
            editLayoutId  = (String)layoutObject.get(namespace+'EditLayoutConfig__c');
        }else{
            layoutId = editLayoutId = printLayoutId= (String)layoutObject.get('Id');
            
        }   

        // Added by chinmay to get the lastmodified date of the record on load of page.
         Id recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        this.disableRecordLocking = KeyValueStoreHelper.getBooleanValue('DisableRecordLocking', true)==null ? true : KeyValueStoreHelper.getBooleanValue('DisableRecordLocking', true);

        if(recordId != null && !this.disableRecordLocking){
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            String strQuery = ' SELECT Id, LastModifiedDate FROM '+ string.escapeSingleQuotes(sObjName) +' WHERE ID = :recordId ';
            List<SObject> listData;
            if(AppUtils.isObjectAccessible(sObjName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                listData = Database.query(String.escapeSingleQuotes(strQuery), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            }
             lastmodifieddateonloadofpage = (DateTime)listData[0].get('LastModifiedDate');
        }
        if(layoutObject != null){
          /******************following code is for fetching parentRecordId into the flex table paramerters*************************/
            Map<String,String> keyValueMapForFlexTable = new  Map<String,String>(); 
            keyValueMapForFlexTable.put('parentRecordIdOfFlexTable',String.valueOf(rcrdId));
            this.keyValueMapForFlexTable = JSON.serialize(keyValueMapForFlexTable);
            /*******************************************/                
            if(type == 'View') {
                this.layoutHolder = new DynamicLayoutHolder(layoutId, rcrdId, true);
                this.layoutHolder.editLayoutId = editLayoutId;                 
                getHeaderAttributes(this.layoutHolder);
                this.layoutHolder.flexTableParameters = this.flexTableParameterJSONChanged;                                
                this.layoutHolder.editRecordTypeId = editRecordTypeId;
                this.layoutHolder.deletePage = deletePage;
                this.layoutHolder.listParameters = this.listParameters;
            } else if(type == 'Print') {
                if(pkgId !=null) {
                    this.layoutHolder = new DynamicLayoutHolder(printLayoutId, rcrdId, true, pkgId);
                } else {
                    this.layoutHolder = new DynamicLayoutHolder(printLayoutId, rcrdId, true);   
                }
                getHeaderAttributes(this.layoutHolder);
                this.layoutHolder.flexTableParameters = this.flexTableParameterJSONChanged;
                this.layoutHolder.listParameters = this.listParameters;
            } else { 
                if(!String.isEmpty(pageBlockIds)) {
                    List<Object> pageIds = (List<Object>)JSON.deserializeUntyped(pageBlockIds);
                    Set<Object> blockIds = new Set<Object>(); 
                    blockIds.addAll(pageIds);
                    this.layoutHolder = new DynamicLayoutHolder(editLayoutId, rcrdId, false,blockIds);
                } else {
                    /*if(formDisplayType != 'Step based') {
                       // this.layoutHolder = new DynamicLayoutHolder(editLayoutId, rcrdId, false);
                    } else {                      
                        //this.layoutHolder = new DynamicLayoutHolder(editLayoutId, rcrdId, false,stepId); 
                    }*/
                    this.layoutHolder = new DynamicLayoutHolder(editLayoutId, rcrdId, false, null, listDefaultValues);
                }       
                this.layoutHolder.editLayoutId = editLayoutId;          
                this.layoutHolder.editRecordTypeId = editRecordTypeId;             
                this.layoutHolder.flexTableParameters = this.flexTableParameterJSONChanged;

                // User Story 127005: Internal - Spring'21 release - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users - Part 2
                if(SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id')) == null && SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('gurid')) == null){ //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding //means create context
                    //setCreateDefaultValues();
                    removeFlexTables();
                }
                
                getHeaderAttributes(this.layoutHolder);
            }
            //User Story 106073: Flexwind - Provide a visual indicator on the tabs that have required actions - Part 2
            //isRequiredSubmitFieldMissing();
            //User Story 114651: Internal - Show Visual Indicator for required for save fields
            showVisualIndicatorForSaveAndSubmit();
            hideTabsForUser();
            this.layoutHolder.selectedRecordTypeId = selectedRecordTypeId;
            this.layoutHolder.packageId = pkgId;
            this.layoutHolder.formTypes = formTypeList;
            this.layoutHolder.pageTemplate = pageTemplate;
            this.layoutHolder.parentTemplateId = parentLytId;
            this.layoutHolder.templateName = this.tmplName;
        }else{
            throw new CustomExceptions.InputDataException('Layout not found.');
        }
    }
    
    
    /* PRIVATE METHODS */

    /*
        Method to set the default values for the layout only on CREATE
        This logic moved to layout holder for Hide Expression in Create Mode...
    */
    /*private void setCreateDefaultValues() {
        //check for default values
        
        if(listDefaultValues != null) { 
            SObject primaryObj = layoutHolder.getPrimarySObject();

            for(DynamicLayoutDefaultValueHelper dv : listDefaultValues) {
                string fieldName = dv.fieldAPIName; //includes namespace
                
                
                if(primaryObj != null){
                    primaryObj.put(fieldName, dv.defaultValue);
                }
                layoutHolder.recordJSON = JSON.serialize(primaryObj);    
            }
        }
        
    }*/
    
    /*
    * This method hides tabs for Internal or External users based on the field 
    * TabConfig__c.HideForUserType__c.
    */
    private void hideTabsForUser(){
       
    }
    
    /*
    * When the context is 'Edit' with no Id then it is a create call.
    * In this create context we need to remove flex tables since there is no data
    * to display in those flex tables.  We can accomplish this by removing the
    * Page Blocks with the flex tables.  Ultimately if there are no Page Blocks left
    * for the Tab we can remove the Tab as well.  This also removes related tables
    * like Attachments and Approval History.
    */
    private void removeFlexTables() {       
        //iterate through all tabs
        List<PageLayoutConfigHelper.Tab> tabs = layoutHolder.layout.tabs;
        layoutHolder.layout.activeTabSize = tabs.size();
        for( Integer i = 0; i < tabs.size(); ){
            //iterate through all Page Blocks
            if(tabs.get(i).isOverview == true) {
                layoutHolder.layout.activeTabSize--;
                i++;
                continue;
            }
            List<PageLayoutConfigHelper.pageBlock> pageBlocks = tabs.get(i).pageBlocks;
            for( Integer j = 0; j < pageBlocks.size(); ){
                //Check if the current Page Block is a Flex Table
                PageLayoutConfigHelper.PageBlock theBlock = pageBlocks.get(j);
                if(theBlock.flexTableName != null || theBlock.flexTableId != null || theBlock.isApprovalHistoryList || theBlock.isNotesAttachmentsList 
                    || theBlock.isMapBlock || theBlock.isAttachment || theBlock.flexGridId != null || theBlock.isDigitallySigned || theBlock.isFormTable
                         || theBlock.isWBS || theBlock.communicationFieldName != null || theBlock.isCollab || theBlock.chartId !=null || theBlock.isCollabInfo || theBlock.isRecordHistory || theBlock.isFieldHistory || theBlock.gridHeaderId != null){
                    //after removal - the next one will be at the same index so do not increment
                    pageBlocks.remove(j);
                }else{
                    //no need to remove - increment
                    j++;
                }
            }
            //check to see if the Tab has > 0 Page Blocks
            //remove it if it does not
            if(pageBlocks.size() == 0){
                //after removal - the next one will be at the same index so do not increment
                tabs.remove(i);
                layoutHolder.layout.activeTabSize--;
            }else{
                //no need to remove - increment
                i++;
            }
        }
    }
    
    /*
    * Method to load the DynamicLayoutHeader attributes
    * header - Name of Object
    * subHeader - Name of Record
    */
    //TODO: render the layout header text using remote call to reduce the page loading time
    private void getHeaderAttributes(DynamicLayoutHolder layoutHolder) {
        string objName = this.layoutHolder.layout.objectName;
        
        isCustomHeader=false;
        
        SchemaManager.SObjectWrapper sObj = SchemaManager.getSObject(objName);
        Schema.DescribeSObjectResult objResult = sObj.objectResult;
        header = objResult.getLabel();
        isUpdateable = objResult.isUpdateable();
        isDeletable = objResult.isDeletable();  
          
        sObject obj = this.layoutHolder.recordMap.get(objName);
        
        
        if(layoutHolder.layout.header != '' && layoutHolder.layout.header != null && rcrdId != null ){//(layoutHolder.layout.headerSuffix != '' && layoutHolder.layout.headerSuffix != null) {
            subHeader = layoutHolder.layout.header;
            if(type != 'Print'){ 
                subHeader = subheader.replace(' - ', '<br />'); //UI-Shrawan-10302015   Added for new header
             }
           
            List<String> mergeFields = AppUtils.getMergeFields(layoutHolder.layout.header);
            if(mergeFields.size() > 0){
                for(String field:mergeFields){
                    if(obj.get(field) != null){
                        subHeader = subHeader.replace('{!'+field+'}',SFDCEncoder.SFDC_HTMLENCODE(String.valueOf(obj.get(field))));
                    }
                    else{
                        subHeader = subHeader.replace('{!'+field+'}','');
                    }
                    isCustomHeader = true;
                }   
            }
            
        } else {
            if(obj != null){
                
                //Davinder - Changes made on 8/4/15 for GovGrants Tech Support
                if(objName.equalsIgnoreCase('case') || objName.equalsIgnoreCase('caseComment')){
                    subHeader = subHeader;
                    // Skip it.
                }else if(objName.equalsIgnoreCase('Event') || objName.equalsIgnoreCase('Task')){ 
                    subHeader = string.valueOf(obj.get('Subject'));
                }else{
                    subHeader = string.valueOf(obj.get('Name'));
                }
            
            }
        }
        
        layoutId = this.layoutHolder.layout.layoutId;   
    }

    //TODO: create a new class called DynamicLayoutUtils and move the below method to that class.
    private String getCurrentTabName() {
        String tabName;
        if(Network.getNetworkId() == null){
            tabName = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('t'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        }else{
            tabName = System.currentPageReference().getParameters().get('t');
        }        
        return tabName;     
    } 

    
     private static String getValue(SObject o, String fieldName){
        return (o.get(fieldName) != null) ? String.valueOf(o.get(fieldName)) : '';
     }

    
    public with sharing class RecordTypeWrapper implements Comparable{
        public transient boolean isSelected {get;set;}
        public transient  string RecordTypeName {get;set;}
        public transient string RecordTypeId {get;set;}
        public transient string RecordTypeDescription {get;set;}
        public transient PageLayoutConfig__c pageConfig {get;set;} 
        
        public RecordTypeWrapper(PageLayoutConfig__c pageConfig,string RecordTypeName,string RecordTypeId, string RecordTypeDescription){
            this.isSelected = false;
            this.RecordTypeName = RecordTypeName;
            this.RecordTypeId = RecordTypeId;
            this.RecordTypeDescription = RecordTypeDescription;
            this.pageConfig = pageConfig;
        }
         public Integer compareTo(Object other) {
            RecordTypeWrapper otherObj = (RecordTypeWrapper) other;
            if (this.pageConfig.sequence__c < otherObj.pageConfig.sequence__c) {
                return -1;
            }
            else if (this.pageConfig.sequence__c > otherObj.pageConfig.sequence__c) {
                return 1;
            }
            else {
                return 0;
            }
        }
    }      
    @RemoteAction    
    global static void postHistorySnapshot(String actionId,Id recordId,String tmplName,String flexTableParameterJSON,String listParams){
         SnapshotUtils.historyPostAction(actionId,recordId,tmplName,flexTableParameterJSON,listParams);
    }
    
     public void takeSnapshot(){
        // this.layoutHolder.templateName = this.tmplName; 
           if(actionId != null){
                SnapshotUtils.historyPostAction(actionId, layoutHolder.recordId, this.layoutHolder.templateName ,
                                flexTableParameterJSON, listParams);
            }     
     }
    // opt changes 
      public PageReference executeClass() {
        Savepoint sp ;

        //= Database.setSavepoint();
        try{
         className =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('className'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
         actionId =SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('actionId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
         populateTriggerParameterMap();
         List<PageLayoutActionConfig__c> pageLayoutList = new List<PageLayoutActionConfig__c>();
         //Nullcheck for actionId otherwise it will break in case of take snapshot. 
         if(actionId != null ){
            //Excetion Handling -rollback logic 
            if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
                pageLayoutList = [Select SkipRollbackLogic__c,AnonymousExecuteScript__c,IsSubmitAction__c,RecordTypeId,SobjectActionConfig__c,HideForProfile__c,StandardAction__c,HideDecisionField__c,HideDecisionExpression__c,HideDecisionExpressionLong__c,HideForContext__c,HideForUser__c,HideOperator__c,HideForRole__c,HideExpressionFields__c,HideExpressionJSON__c from PageLayoutActionConfig__c Where id =: actionId WITH USER_MODE];   
            }
             if (pageLayoutList.size() > 0) {
                if(Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosById().get(pageLayoutList[0].RecordTypeId).getname() == 'Anonymous Execute'){
                	if(pageLayoutList[0].AnonymousExecuteScript__c == null || pageLayoutList[0].AnonymousExecuteScript__c == ''){
                		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error ' + 'Apex Run Failed :: Connect with System Admin.'));
                		return null;
                	}
                	Map<String,String> mapRecordIds = new Map<String,String>();
                	mapRecordIds.put('recordId',layoutHolder.recordId);
                	mapRecordIds.put('buttonId',actionId);
                	executeAnonymous(mapRecordIds);
                	return null;
                }

                Boolean avoidActionPerformedCheck = false;
                if(KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true) != null){       
                    avoidActionPerformedCheck = KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true);
                }
                if(avoidActionPerformedCheck == true){
                    Boolean hideResult = DynamicLayoutHelper.isActionAlreadyPerformed(layoutHolder.recordId,'View',pageLayoutList,null);
                    if(hideResult == false){
                        String errorMessage = 'This Action has been taken by another user. Refresh the page to see the updated status....';
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errorMessage);
                        ApexPages.addMessage(msg);
                        return null;
                    }
                }

                if(pageLayoutList[0].SkipRollbackLogic__c == false){
                    sp = Database.setSavepoint();
                }
            }
         }
        
        promptDailogVal = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('promptVal'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(promptDailogVal != null && promptDailogVal != ''){
            promptDailogVal = promptDailogVal.unescapeJava();
        }
         String recrdId;
         String templtname;
         Boolean isErrormsg; 
         if(actionId !=null && actionId != ' ') {
         SObject  record = layoutHolder.getPrimarySObject();
         
         BusinessRuleResult result;
         if(actionId != ''){
             result = BusinessRuleConfigHelper.execute(Id.valueOf(actionId),record, this.layoutHolder);
         }
            if (result != null && result.hasErrors()) {
                result.addErrorsToPage();
                return null;
             }else{ 
                /* SnapshotUtils.historyPreAction(actionId, layoutHolder.recordId, this.layoutHolder.templateName ,
                                    flexTableParameterJSON, listParams);*/
                 System.Type t;
                 if(className.contains('.')){
                    String[] splitStr = className.split('\\.');
                    t = System.Type.forName(splitStr[0], splitStr[1]);
                 }else{
                    t = System.Type.forName('', className);
                 }
                 if(t == null) {
                    throw new CustomExceptions.InputDataException('Class ' + className + ' not found or it is not global. Please Contact administrator.');
                 } 
                 //System.Type t = System.Type.forName(className);
                 Object obj = t.newInstance();
                 if(obj instanceOf DynamicLayoutActionRedirect){
                    DynamicLayoutActionRedirect redirect = (DynamicLayoutActionRedirect)obj;
                    redirect.layoutHolder = this.layoutHolder;
                    redirect.promptInputValue = promptDailogVal; 
                    redirect.actionId = actionId;

                   if(pageLayoutList[0].IsSubmitAction__c == true){
                     List<String> requiredSubmitErrors = isRequiredSubmitFieldMissing();
                     if(requiredSubmitErrors.size() > 0) {
                         return submitPageRedirect(requiredSubmitErrors);
                      }
      
                      
                    }
                    PageReference p = redirect.whenClicked();
                    isErrormsg = ApexPages.hasMessages(ApexPages.Severity.ERROR);            
                    if(isErrormsg == false){
                        if(actionId != null){ 
                            recrdId = layoutHolder.recordId;
                            templtname = this.layoutHolder.templateName;
                            /*SnapshotUtils.historyPostAction(actionId, layoutHolder.recordId, this.layoutHolder.templateName,
                                            flexTableParameterJSON, listParams);*/
                                historySnapshotaction(actionId, recrdId, templtname, flexTableParameterJSON, listParameters);
                            }
                        }
                        return p;                 
                     }else{
                        DynamicLayoutActionStay stay = (DynamicLayoutActionStay)obj;
                        stay.layoutHolder = this.layoutHolder;

                         if(pageLayoutList[0].IsSubmitAction__c == true){
                            List<String> requiredSubmitErrors = isRequiredSubmitFieldMissing();
                             if(requiredSubmitErrors.size() > 0) {
                                return submitPageRedirect(requiredSubmitErrors);
                             }
                      
                        }
                        String successMsg = stay.whenClicked(); 
                        stay.promptInputValue = promptDailogVal;   
                        isErrormsg = ApexPages.hasMessages(ApexPages.Severity.ERROR);
                        if(isErrormsg == false){
                        if(String.isEmpty(stay.errorMsg)){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, successMsg);
                            ApexPages.addMessage(myMsg);
                            if(actionId != null){
                                recrdId = layoutHolder.recordId;
                                
                                templtname = this.layoutHolder.templateName;
                                historySnapshotaction(actionId, recrdId, templtname, flexTableParameterJSON, listParameters);
                            }       
                        }
                        }else{ 
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, stay.errorMsg);
                            ApexPages.addMessage(myMsg); 
                        }
                        
                        return null;
                     } 
                }
      }else{                
        /*SnapshotUtils.createSnapshot(layoutHolder.recordId, this.layoutHolder.templateName,
                                        flexTableParameterJSON, listParams);*/
                 System.Type t;
                 if(className.contains('.')){
                    String[] splitStr = className.split('\\.');
                    t = System.Type.forName(splitStr[0], splitStr[1]);
                 }else{
                    t = System.Type.forName('', className);
                 } 
                 //System.Type t = System.Type.forName(className);
                 Object obj = t.newInstance();
                 DynamicLayoutActionStay stay = (DynamicLayoutActionStay)obj;
                 stay.layoutHolder = this.layoutHolder;  
                 String successMsg = stay.whenClicked();
                 if(String.isEmpty(stay.errorMsg)){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, successMsg);
                            ApexPages.addMessage(myMsg);
                 }                               
      }
      }catch(Exception ex){
           if(sp!=null){
		   	Database.rollback(sp);
		   }

            if(ex != null && KeyValueHolderHelper.getBooleanValue('EnableLogException') != null && KeyValueHolderHelper.getBooleanValue('EnableLogException')){
                LogExceptionHandler.logException(ex);
            }
          
            if(ex instanceOf NullPointerException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf ListException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf DmlException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf QueryException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf SObjectException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf JSONException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf NoDataFoundException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);
            }else if(ex instanceOf SerializationException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);                
            }else if(ex instanceOf TypeException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);    
            }else if(ex instanceOf CalloutException){
                CustomExceptions.logSystemException(ex,layoutHolder.recordId,null);    
            }else{
                throw new CustomExceptions.InputDataException(AppUtils.handleSystemExceptionMsg(ex.getMessage()));
            }

            String errMsg = Apputils.handleSystemExceptionMsg(ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg);
           ApexPages.addMessage(myMsg); 
           return null;   
      }
      return null;
        
    }
    
    @Future(callout=true)
    static void historySnapshotaction(String actionId,String recrdId,String templtname,String flexTableParameterJSON,String listParams){
        SnapshotUtils.historyPostAction(actionId, recrdId, templtname, flexTableParameterJSON, listParams); 
    }
    

    @RemoteAction
    global static Map<String,String> fetchHelpDataRemote(Id helpConfigId){        
        Map<String,String> retVal = new Map<String,String>();
        retVal.put('isInternalDocument', 'false');
        retVal.put('docId', '');
        if(helpConfigId != null){            
            List<HelpConfig__c> helpList = new List<HelpConfig__c>();
            if(Schema.sObjectType.HelpConfig__c.isAccessible()){
                helpList = [Select id, DocumentName__c, RecordType.DeveloperName 
                From HelpConfig__c Where id = :helpConfigId WITH USER_MODE Limit 1];
            }
            if(helpList != null && helpList.size() > 0){
                if(helpList[0].RecordType.DeveloperName == 'InternalDocument'){
                    retVal.put('isInternalDocument', 'true');
                    if(helpList[0].DocumentName__c != null){
                        List<Document> doc = [Select id From Document Where 
                                DeveloperName = : helpList[0].DocumentName__c WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                        if(doc != null && doc.size() > 0){                           
                            retVal.put('docId', doc[0].id);
                        }
                    }
                }
            }
        }
        return retVal;
    }

public PageReference submitPageRedirect(List<String> requiredSubmitErrors){
        ErrorLog__c error = new ErrorLog__c();
        error.Errordescription__c = String.join(requiredSubmitErrors, ';;');
        List<SObject> listToInsert = new List<SObject>();
        listToInsert.add(error);
        SystemContextMethodsHelper contextMethod = new SystemContextMethodsHelper();
        contextMethod.insertSobject(listToInsert);
        String headerdata = ApexPages.currentPage().getHeaders().get('Host');
        String url = 'https://' + headerdata;
        url += '/' + layoutHolder.recordId + '/e?errorLogId=' + error.Id; 
        PageReference newPage = new PageReference(EncodingUtil.urlEncode(url, 'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
        return newPage;
    }

   //User Story 114651: Internal - Show Visual Indicator for required for save fields 
    private void showVisualIndicatorForSaveAndSubmit(){
        sObject recValues = layoutHolder.getPrimarySObject();
        Boolean isRequired = false;
        for(PageLayoutConfigHelper.Tab t : layoutHolder.layout.tabs){
            if(t.active && t.hideTab != 'true' && t.isOverview != true){
                for( PageLayoutConfigHelper.PageBlock pb : t.pageBlocks){
                    evaluateHideFields(pb.fields,layoutHolder);
                    if (pb.isHiddenPageBlock || pb.hidePageBlock == 'true'){
                        continue; 
                    }
                    for(PageLayoutConfigHelper.Field field : pb.fields){
                        /*Added new check to verify the If the Field is readOnly then requiredForSubmit set to false
                        Tried to achieve in PageLayoutConfigHelper but isReadOnlyField is only resolved when ReadOnly check is checked*/
                        if(field.isReadOnlyField){
                            field.requiredForSubmit = false;
                        }

                        if (field.isHiddenField || field.hideField == 'true' || field.isReadOnlyField || String.isEmpty(field.fieldAPIName) || field.isRelationshipFieldType){
                            continue; 
                        }
                        if(SchemaManager.getFieldSchemaResult(layoutHolder.layout.objectName, field.fieldAPIName).isUpdatable != true){
                            continue;
                        }
                        Boolean isValueBlank = false;

                        if(recValues.get(field.fieldAPIName) == ''){
                             isValueBlank = String.isBlank(String.valueOf(recValues.get(field.fieldAPIName)));
                        }
                        if(((recValues.get(field.fieldAPIName) == null) || isValueBlank) ){
                            //User Story 106073: Flexwind - Provide a visual indicator on the tabs that have required actions - Part 2
                            if(!(fieldsToHide.contains(field.fieldAPIName))){
                                if(field.required == true){
                                     t.requiredFieldForSave = true;
                                } else if(field.requiredForSubmit == true){
                                    t.requiredFieldForSubmit = true;
                                }
                        }
                            isRequired = true;
                        }
                        //User Story 111636: Internal-Add hide field json support for Visual indicator
                           if(isRequired && fieldsToHide.contains(field.fieldAPIName)){
                            if(field.required == true){
                                t.requiredFieldForSave = false;
                               }else if(field.requiredForSubmit == true){
                                t.requiredFieldForSubmit = false;
                               }
                        }
                    }
                }
            }  
        }  
    }

    private List<String> isRequiredSubmitFieldMissing() {
        Map<String,Object> mapReturn = new Map<String,Object>();
        List<String> errorMessagesList = new List<String>();
        Boolean isRequired = false;
        sObject recValues = layoutHolder.getPrimarySObject();
        //check active tab count
        Integer tabCount = 0;
        for(PageLayoutConfigHelper.Tab t : layoutHolder.layout.tabs){
            if(t.active && t.hideTab != 'true' && t.isOverview != true){
                tabCount++;
                // purpose is to check if tab count is greater than zero
                if(tabCount > 1) {
                    break;
                }
            }
        }

        String errorLabel = (tabCount > 1) ? Label.RequiredSubmitFieldMessage : Label.RequiredSubmitFieldMessageForWithoutTab;

        for(PageLayoutConfigHelper.Tab t : layoutHolder.layout.tabs){
            if(t.active && t.hideTab != 'true' && t.isOverview != true){
                for( PageLayoutConfigHelper.PageBlock pb : t.pageBlocks){
                    evaluateHideFields(pb.fields,layoutHolder);
                    if (pb.isHiddenPageBlock || pb.hidePageBlock == 'true'){
                        continue; 
                    }
                    for(PageLayoutConfigHelper.Field field : pb.fields){
                        if (field.isHiddenField || field.hideField == 'true' || field.isReadOnlyField || String.isEmpty(field.fieldAPIName) || field.isRelationshipFieldType || field.requiredForSubmit == false){
                            continue; 
                        }
                        if(SchemaManager.getFieldSchemaResult(layoutHolder.layout.objectName, field.fieldAPIName).isUpdatable != true){
                            continue;
                        }
                        Boolean isValueBlank = false;

                        if(recValues.get(field.fieldAPIName) == ''){
                             isValueBlank = String.isBlank(String.valueOf(recValues.get(field.fieldAPIName)));
                        }
                      
                        if(((recValues.get(field.fieldAPIName) == null) || isValueBlank) ){
                            String errorMsgStr  = string.format(errorLabel, new String[]{field.fieldLabel,t.Name,'\''+field.fieldAPIName+'\'','\''+t.tabId+'\''});
                            errorMessagesList.add(errorMsgStr);
                            isRequired = true;
                        }
                    }
                }
            }
        }

        return errorMessagesList;
    }
    
    /*
    Method  :   executeAnonymous(Map<String,String> mapRecordIds)
    Purpose :   This method will run script which is define in flex table action.
    */
    private static void executeAnonymous(Map<String,String> mapRecordIds) {
    	Id buttonId = (mapRecordIds.get('buttonId') != null ? Id.ValueOf(mapRecordIds.get('buttonId')) : null);
    	Id recordId = (mapRecordIds.get('recordId') != null ? Id.ValueOf(mapRecordIds.get('recordId')) : null);
    	Id parentId = (mapRecordIds.get('parentId') != null ? Id.ValueOf(mapRecordIds.get('parentId')) : null);
        if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
            List<PageLayoutActionConfig__c> lstPgLayOutActns = [Select Id, Name,AnonymousExecuteScript__c From PageLayoutActionConfig__c Where Id =: buttonId WITH USER_MODE];
            String resultVal = null;
            String anonymousExecuteScriptResult = null;
            if(lstPgLayOutActns != null && lstPgLayOutActns.size() > 0 && lstPgLayOutActns[0].AnonymousExecuteScript__c != null){
                String anonymousExecuteScript = lstPgLayOutActns[0].AnonymousExecuteScript__c;
                if(recordId != null){
                    anonymousExecuteScriptResult = AppUtils.replaceRecordMergeFields(anonymousExecuteScript,recordId);
                }
                resultVal = AppUtils.executeAnonymousScript(anonymousExecuteScriptResult);
                if(resultVal != null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resultVal));
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'Apex Script Run Successfully!!'));
                }
            } 
        }            
    }

 @auraEnabled
    public static void updateFormInstancePercentLightning(Id formRecordId){
        Id frmId = formRecordId;
        Id formInstanceId ;
        Id rcrdId = formRecordId;
        Map<String, FlexUtils.FormCompletionDTO> formMap = new Map<String, FlexUtils.FormCompletionDTO>();
        List<FormInstance__c> formInst = new List<FormInstance__c>(); 
        Id pckBuFormId;
        Double percentComplete = 0.00;
        formMap = FlexUtils.getLayoutCompletionOnFormId(String.valueOf(rcrdId), String.valueOf(frmId));
        //update Form Instance Percentage Field 
        List<FormInstance__c> fcInstance = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()){
        fcInstance = [SELECT Id, PackageBusinessForm__c,IsNotApplicable__c FROM FormInstance__c WHERE FormId__c =:rcrdId WITH USER_MODE];
        }
        if(fcInstance.size() > 0){
          pckBuFormId = fcInstance[0].PackageBusinessForm__c;
          formInstanceId = fcInstance[0].Id;
        }
        if(pckBuFormId !=null){
            if(Schema.sObjectType.FormInstance__c.isAccessible()){
             formInst = [SELECT Percentage__c, FormId__c, PackageBusinessForm__c, ParentRecordId__c,IsNotApplicable__c FROM FormInstance__c WHERE Id=:formInstanceId WITH USER_MODE];
            }
         }
        if(formMap !=null){
            for(FlexUtils.FormCompletionDTO formDto:formMap.values()){
                percentComplete = formDto.submitPercentage;
                if(percentComplete > 100){
                    percentComplete = 100.00;
                }
            }
        }else{
             percentComplete = 0.0;
        }
        if(formInst.size() > 0){
            // if(Schema.sObjectType.FormInstance__c.fields.IsNotApplicable__c.isCreateable() && Schema.sObjectType.FormInstance__c.fields.IsNotApplicable__c.isUpdateable()){
            //     formInst[0].IsNotApplicable__c = isNotApplicable == null?false:isNotApplicable;
            // }
            if(Schema.sObjectType.FormInstance__c.fields.Percentage__c.isCreateable() && Schema.sObjectType.FormInstance__c.fields.Percentage__c.isUpdateable()){
                if(formInst[0].IsNotApplicable__c == true){
                    formInst[0].Percentage__c = 100.00;
                }else{
                    formInst[0].Percentage__c = percentComplete;
                }
            }
             if(Schema.sObjectType.FormInstance__c.isCreateable() && Schema.sObjectType.FormInstance__c.isUpdateable()){
                 upsert as user formInst;
             }
        }
    }
    //sets the global static property of TriggerHelper named controllerParamsMap, to flexTableParameters passed,
    //so that the variables passed from the controller can be accessed in the trigger of the object.
    private void populateTriggerParameterMap() {
        try {
            TriggerHelper.autoSnapShotForClassic = true;
            if(String.isNotEmpty(flexTableParameterJSON)){
                TriggerHelper.controllerParamsMap = (Map<String,Object>)JSON.deserializeUntyped(flexTableParameterJSON);
            }

            if(String.isNotEmpty(listParameters)){
                TriggerHelper.controllerListParamsMap = (Map<String,Object>)JSON.deserializeUntyped(listParameters);
            }

        } catch(Exception ex) {
        } 
    }
    @TestVisible
	Public with sharing class layoutWrapper{
        @AuraEnabled
		Public String fieldName	{get;set;}
        @AuraEnabled
		Public String fieldType	{get;set;}
		@AuraEnabled
        Public String fieldConfig	{get;set;}
		@AuraEnabled
        Public String dataType	{get;set;}
		@AuraEnabled
        Public String length {get;set;}
        @AuraEnabled
		Public String fieldLength	{get;set;}
        @AuraEnabled
		Public String EnableTotal	{get;set;}
        @AuraEnabled
		Public String APIName	{get;set;}
        @AuraEnabled
		Public String fieldWidth	{get;set;}
        @AuraEnabled
		Public String helpText	{get;set;}
        @AuraEnabled
		Public String Pagination	{get;set;}
		
         

		public layoutWrapper(String fieldName,String fieldType,String fieldConfig,String dataType,String length,String fieldLength,String EnableTotal,String APIName,String fieldWidth,String helpText,String Pagination){
			this.fieldName =fieldName;
			this.fieldType	=fieldType;
			this.fieldConfig =fieldConfig;
			this.dataType	=dataType;
			this.length	  =	length;
			this.fieldLength	=fieldLength;
			this.EnableTotal =EnableTotal;
			this.APIName	=APIName;
			this.fieldWidth	=fieldWidth;
			this.helpText	=helpText;
			this.Pagination	=Pagination;
			
			
		}
    }
    
     @TestVisible 
     public with sharing  class LayoutDynamicWrapper{
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
         

        public LayoutDynamicWrapper(String label){
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }

}