public with sharing class FlexLayoutController {
    
    private static Set<String> fieldSet = new Set<String>();
    private static Map<String,Schema.SObjectField> fieldsMap = new Map<String,Schema.SObjectField>();
    private static String userRole;
    private static Boolean getRoleInfoCalled = false;
    private static List<Sobject> recordDetailsList;
    private static Map<String,String> IconCssMap = new Map<String,String>();
    private static List<String> headerTitleForModal;

    @TestVisible
    private with sharing class PageLayoutWrapper{
        private String pageLayoutId;
        private String pageLayoutName{get;set;}
        private String formName{get;set;}//this is PageTemplate__c.Name
        private String formId{get;set;}////this is PageTemplate__c.Id
        private String autoSnapShotFieldAPIName{get;set;}
        private String nameSpace{get;set;}
        private String keyValueMap{get;set;}
        private String listValueMap{get;set;}
        private String ApexClass{get;set;}
        private String stepProgressGroupName{get;set;}
        private String objectName{get;set;}
        private String saveButtonLabel{get;set;}
        private String cancelButtonLabel{get;set;}  
        @TestVisible
        private Id recordId{get;set;}
        private string headerInstructions{get;set;}
        private List<TabWrapper> tabs{get;set;}
        private List<ActionWrapper> actionConfigs{get;set;}
        private List<string> headerTitle{get;set;}
        private List<LightningPageMessage> pageMessageList = new List<LightningPageMessage>();
        private Integer messageTimeOut{get;set;}
        private Boolean messageTimeOutEnabled{get;set;}
        private String richTextFormats{get;set;}
        private Integer allowedCharsForRichTextArea{get;set;}
        private Integer warningCharsForRichTextArea{get;set;}
        private Integer allowedWordsForRichTextArea{get;set;}
        private Integer warningWordsForRichTextArea{get;set;}
        private Boolean showCharLimit{get;set;}
        private Boolean showCharLimitWarning{get;set;}
        private Boolean showWordLimit{get;set;}
        private Boolean showWordLimitWarning{get;set;}
        private Map<String,Object> modalAttributeMap{get;set;}
        private String redirectLogic{get;set;} 
        private Boolean showDownloadAsPdf{get;set;}
        private Boolean showSnapshotMenuButton{get;set;}
        private String onDemandSnapClassification{get;set;}
        private List<DynamicLayoutDefaultValueHelper> listDefaultValues{get;set;}
        private String labelOverrideSaveandClose{get;set;}
        private String labelOverrideSaveandContinue{get;set;} 
        private Boolean isHeaderTabAvaiable{get;set;}
        private Boolean hasRecordEditAccess{get;set;}  
        private String createHeaderOverride{get;set;}  
        private String headerNew{get;set;}  

        PageLayoutWrapper(){}
        @TestVisible
        PageLayoutWrapper(PageLayoutConfig__c layoutConfig){
            this.pageLayoutId = layoutConfig.Id;
            this.pageLayoutName = layoutConfig.Name;
            this.objectName = layoutConfig.ObjectAPIName__c;
            this.stepProgressGroupName = layoutConfig.ProgressbarGroupName__c;
            this.headerInstructions = layoutConfig.HeaderDescription__c;
            this.saveButtonLabel = layoutConfig.SaveButtonLabel__c;
            this.cancelButtonLabel = layoutConfig.CancelButtonLabel__c;
            this.showDownloadAsPdf = layoutConfig.HidePDFDownload__c==true?false:true;
            this.showSnapshotMenuButton = layoutConfig.HideOnDemandSnaphot__c==true?false:true;
            this.onDemandSnapClassification = layoutConfig.SnapshotClassification__c;
            this.createHeaderOverride = layoutConfig.HeaderOverride__c;
            this.headerNew = layoutConfig.FormTitle__c;
        }
    }

    private with sharing class errorHandlerWrapper{
        private Boolean isError{get;set;}
        private string errorMessage{get;set;}

        errorHandlerWrapper(String message){
            this.isError = true;
            this.errorMessage = message;
        }
    }

    private with sharing class TabWrapper{
        private String id{get;set;}
        private String tabName{get;set;}
        private String iconName{get;set;}   
        private String tabHeaderInstruction{get;set;}
        private Boolean isOverview{get;set;}      

        TabWrapper(){}

        TabWrapper(TabConfig__c tab){
            this.id = tab.Id;
            this.tabName = tab.StandardTabName__c;
            this.isOverview = tab.isOverview__c;
            String IconCSS = tab.TabIcon__c;
            if(IconCSS!=null){
                IconCSS=IconCSS.replaceAll('<[/a-zAZ0-9]*','');
                IconCSS=IconCSS.replaceAll('>','');
                IconCSS=IconCSS.replaceAll('"','');
                List<String> iconList = IconCSS.split('=');
                if(iconList.size()==2){
                    this.iconName = IconCssMap.get(iconList[1].trim());
                }else if(iconList.size()==3){
                    List<String> tempList = iconList[1].split(' ');
                    if(tempList.size()>=2){
                        this.iconName = IconCssMap.get(tempList[0].trim()+' '+tempList[1].trim());
                    }
                }else{
                    this.iconName = IconCssMap.get(iconList[0].trim());
                }
                this.iconName = iconName==null?tab.TabIcon__c:iconName;
            }
            this.tabHeaderInstruction = tab.HeaderInstructionText__c;
        }
    }
    
    @TestVisible
    private with sharing class ActionWrapper{
        private String actionName{get;set;}
        private String actionClass{get;set;}
        private String recordTypeName{get;set;}
        private string actionId{get;set;}
        private Boolean showIconOnly{get;set;}
        private string iconCss{get;set;}
        private string layoutType{get;set;}
        private string actionType{get;set;}
        private string standardActionType{get;set;}
        // private string controllerClassORFlexTableName{get;set;}
        private boolean showButton {get;set;}        
        private string actionBehavior{get;set;}
        private Boolean skipRollbackLogic{get;set;}       
        private string actionUrl{get;set;}
        private string toolTipText{get;set;}
        private string warningMessage{get;set;}
        private Boolean isSubmit{get;set;}  
        private Boolean isMenuButton{get;set;}
        private Boolean isHeaderButton{get;set;}
        private string ModalTitle{get;set;}
        private string refreshBehaviour{get;set;}
        private Boolean EnablePromptInputDialog{get;set;}
        private string PromptDailogHeader{get;set;}
        private string PromptDialogText{get;set;}
        private string promptVal{get;set;}

        ActionWrapper(){}
        
        @TestVisible
        ActionWrapper(PageLayoutActionConfig__c action){
            this.actionName = action.name;
            this.actionId = action.id;
            this.actionType = String.isNotBlank(action.StandardAction__c)?action.StandardAction__c:'Custom';
            this.layoutType = action.LayoutType__c;
            this.showIconOnly = action.ShowIconOnly__c;
            this.iconCss = action.IconCSS__c;
            this.actionClass = action.ActionClass__c;
            this.actionBehavior = action.ActionBehavior__c;
            this.actionUrl = action.ActionURLLightning__c;
            this.recordTypeName = action.RecordType.name;            
            this.isSubmit = action.IsSubmitAction__c;
            this.EnablePromptInputDialog = action.EnablePromptInputDialog__c;
            this.PromptDailogHeader = action.PromptDailogHeader__c;
            this.PromptDialogText = action.PromptDialogText__c;
            this.isMenuButton = action.DisplayArea__c=='Menu' || action.DisplayArea__c=='Both'?true:false;
            this.isHeaderButton = action.DisplayArea__c=='Page Header' || action.DisplayArea__c=='Both' || action.DisplayArea__c==null?true:false;
            // this.controllerClassORFlexTableName = action.ControllerClassORFlexTableName__c;
            this.actionBehavior = action.ActionBehavior__c;
            this.refreshBehaviour = action.RefreshBehaviour__c;
            this.skipRollbackLogic = action.SkipRollbackLogic__c;            
            this.toolTipText = String.isNotBlank(action.Tooltip__c)?action.Tooltip__c:String.isNotBlank(action.ButtonHelpText__c)?action.ButtonHelpText__c:action.name;            
            this.warningMessage = String.isNotBlank(action.SubmitWarningMessageLong__c)?action.SubmitWarningMessageLong__c:action.SubmitWarningMessage__c;
            this.ModalTitle = String.isNotBlank(action.ModalTitle__c) ? action.ModalTitle__c : action.name;
        }
    }

    private with sharing class PageBlockWrapper{
        private String label {get;set;}
        private String pageBlockHeaderInstruction {get;set;}
        private String pageBlockHelpText {get;set;}
        private String Id {get;set;}
        private Boolean isApprovalHistory {get;set;}
        private Boolean isAttachment {get;set;}
        private Boolean isSnapshot {get;set;}
        private Boolean isNotes {get;set;}
        private string columns {get;set;}
        private String type {get;set;}
        private Boolean isFields {get;set;}
        private Id tableId {get;set;}
        private string flexTableName {get;set;}
        private string flexGridName {get;set;}
        private List<FieldWrapper> fieldConfigs {get;set;}
        private string AltRenderFieldvalueMapStr {get;set;} 
        //private List<LightningPageMessage> pageMessageList = new List<LightningPageMessage>();


        pageBlockWrapper(){}

        pageBlockWrapper(PageBlockConfig__c pageBlockConfig){
            this.label = pageBlockConfig.PageBlockTitle__c;
            this.pageBlockHeaderInstruction = pageBlockConfig.HeaderInstructionText__c;
            this.pageBlockHelpText = pageBlockConfig.HelpText__c;
            this.columns = 'slds-p-bottom_small slds-p-horizontal_small slds-col slds-size_1-of-'+pageBlockConfig.BodyColumns__c;
            this.type = pageBlockConfig.RecordType.Name;
            this.isFields = this.type == 'Fields' ? true : false;
            this.Id = pageBlockConfig.id;                        
            if(pageBlockConfig.FlexTableName__c != null && this.type!='Field History'){
                this.flexTableName = pageBlockConfig.FlexTableName__r.name;
                this.tableId = pageBlockConfig.FlexTableName__c;
            }else if(pageBlockConfig.FlexGridName__c != null && this.type!='Field History'){
                this.flexGridName = pageBlockConfig.FlexGridName__r.name;
                this.tableId = pageBlockConfig.FlexGridName__c;
            }else if(pageBlockConfig.FlexTableName__c == null && this.type=='Communication'){
                this.flexTableName = 'CommunicationHistory';
            }else if(this.type == 'Approval History'){
                this.isApprovalHistory = true;
            }else if(this.type == 'Attachments'){
                this.isAttachment = true;
            }else if(this.type == 'Record History'){
                this.isSnapshot = true;
            }else if(this.type == 'Notes and Attachments'){
                this.isAttachment = true;
                this.isNotes = true;
            }
        }
    }

    @TestVisible
    private with sharing class FieldWrapper{
        private Id pageBlockDetailId{get;set;}
        private String fieldAPIName{get;set;}
        private String actualApiName{get;set;}
        private String recordIdOfReference{get;set;}
        private String objectNameOfReference{get;set;}
        private String helpText{get;set;}
        private String helpTextPost{get;set;}
        private String label{get;set;}
        private Boolean isLabelRichText{get;set;}
        private Boolean hideLabel{get;set;}
        private Boolean readOnly{get;set;}
        private Boolean isDisabled{get;set;}
        //private String sldsColumnCSS{get;set;}
        private String fieldValue{get;set;}
        private String fieldType{get;set;}
        private Boolean IsUpdateable{get;set;}
        private Boolean isPhoneField{get;set;}
        private Boolean isMultiSelect{get;set;}
        private integer fieldLength{get;set;}
        private boolean isRichTextFieldType{get;set;}
        private Boolean requiredToSave{get;set;}
        private Boolean requiredToSubmit{get;set;}
        private Boolean isRelationalField{get;set;}
        private List<String> realtedObjects{get;set;}
        private Boolean isLookUpField{get;set;}
        private String lookupDisplayFields{get;set;}
        private String filterCriteria{get;set;}
        private Boolean isStaticText{get;set;}
        private Boolean isBlankSpace{get;set;}
        private String staticText{get;set;}
        private Integer charLength{get;set;}
        private Integer charactersLeft{get;set;}
        private Integer wordLength{get;set;}
        private Integer wordsLeft{get;set;}
        private Boolean showAsRichText{get;set;}
        private String hideFieldsJSON{get;set;}
        private Boolean isCheckBox{get;set;}
        private String classNameToHide{get;set;}
        private Boolean isUrlTypeField{get;set;}
        private Boolean isPicklistTypeField{get;set;}
        private Boolean isAltRendering{get;set;}
        private String altRenderFieldName{get;set;} 
        private String altRenderDisplayValue{get;set;}
        private String altRenderFieldType{get;set;}
        private boolean hideSelectAll{get;set;}
        private String altRenderSortOrderMap{get;set;}
        private List<String> multiselectValueList{get;set;}

        @TestVisible
        FieldWrapper(){}

        @TestVisible
        FieldWrapper(PageBlockDetailConfig__c pgBlockDetailConfig,Boolean isStaticText,Boolean isBlankSpace){
            if(isStaticText){
                this.pageBlockDetailId = pgBlockDetailConfig.Id;
                this.isStaticText = isStaticText;
                this.isBlankSpace = false;
                this.staticText = pgBlockDetailConfig.StaticText__c;
            }else if(isBlankSpace){
                this.pageBlockDetailId = pgBlockDetailConfig.Id;
                this.isStaticText = false;
                this.isBlankSpace = isBlankSpace;
                this.staticText = pgBlockDetailConfig.StaticText__c;
        	}
        }

        FieldWrapper(PageBlockDetailConfig__c field){            
            DescribeFieldResult fieldDescribe = fieldsMap.get(field.FieldAPIName__c).getDescribe();      
            
            this.pageBlockDetailId = field.Id;
            this.isRelationalField = false;
            this.isRichTextFieldType = false;
            this.isStaticText = false;
            this.isBlankSpace = false;
            this.fieldAPIName = field.FieldAPIName__c;                                    
            this.helpText = String.isNotEmpty(field.HelpTextLong__c) ? field.HelpTextLong__c : fieldDescribe.getInlineHelpText();
            this.helpTextPost = field.HelpTextPost__c;
            this.hideFieldsJSON = field.HideFieldsJSON__c;
            this.isCheckBox = fieldDescribe.getType().name() == 'BOOLEAN' ? true : false;
            this.isUrlTypeField = fieldDescribe.getType().name() == 'URL' ? true : false;
            this.isPicklistTypeField = fieldDescribe.getType().name() == 'PICKLIST' ? true : false;
            this.altRenderFieldName = field.AltRenderingConfig__c;
            this.hideSelectAll = field.DisableSelectAll__c;
            this.isAltRendering = altRenderFieldName != null ? true : false;
            if(this.isAltRendering){
                DynamicFieldConfigData__mdt DynaFieldConfig = [SELECT Name__c,DeveloperName, DisplayField__c, ReturnField__c,CheckBoxAlignment__c, SortField__c, Object__c, Type__c, WhereClause__c 
                        FROM DynamicFieldConfigData__mdt WHERE Name__c =:this.altRenderFieldName WITH USER_MODE]; 
                PageLayoutConfigHelper.AlternativeRendering altRen = new PageLayoutConfigHelper.AlternativeRendering(DynaFieldConfig);
                this.altRenderDisplayValue = JSON.serialize(altRen.dbValueMap);
                this.altRenderSortOrderMap = JSON.serialize(altRen.sortValueMap);
                this.altRenderFieldType = altRen.typex;
            }
            if(field.RequiredBehavior__c != null && !fieldDescribe.isCalculated() && !field.ReadOnly__c){
                this.requiredToSave = saveCheck(field.RequiredBehavior__c,field.RequiredByRole__c);            
                this.requiredToSubmit = submitCheck(field.RequiredBehavior__c,field.RequiredForSubmitByRole__c);
            }
            else{
                this.requiredToSave = false;
                this.requiredToSubmit = false;
            }
            this.isLabelRichText = String.isNotEmpty(field.FieldLabelOverrideRichText__c)?true:false;
            this.label = String.isNotEmpty(field.FieldLabelOverrideRichText__c)?field.FieldLabelOverrideRichText__c:String.isNotEmpty(field.FieldLabelOverride__c) ? field.FieldLabelOverride__c : fieldDescribe.getLabel();
            //fieldWrapper.label = String.isNotEmpty(field.FieldLabelOverride__c) ? field.FieldLabelOverride__c : fieldDescribe.getLabel();
            this.hideLabel = field.HideLabel__c;
            //this.readOnly = field.ReadOnly__c;
            //this.fieldType = fieldDescribe.getType().name();
            this.IsUpdateable = Boolean.valueOf(fieldDescribe.isUpdateable());
            this.isPhoneField = fieldDescribe.getType().name() == 'PHONE' ? true : false;            
            this.isMultiSelect = fieldDescribe.getType().name() == 'MULTIPICKLIST' ? true : false;  
                      
            this.isLookUpField = fieldDescribe.getType().name().equalsIgnoreCase('reference')?true:false;            
            this.filterCriteria = field.FilterCriteria__c;
            this.lookupDisplayFields = field.DisplayLookupFieldNames__c;

            if(fieldDescribe.getType() == Schema.DisplayType.TextArea){
                this.fieldLength = integer.valueOf(field.AllowedWordsForRichTextArea__c);
                this.isRichTextFieldType = true;
                this.showAsRichText = field.IsRichTextArea__c == true?true:false;
            }else{
                this.fieldLength =  fieldDescribe.getLength();
            }
        }

        FieldWrapper(PageBlockDetailConfig__c field,ReferenceFieldWrapper referenceFieldWrapper){
            
            if(field.FieldAPIName__c.contains('__r')){
               String currentApiName = field.FieldAPIName__c.split('__r')[0] + '__c';
                DescribeFieldResult fieldDescribe = fieldsMap.get(currentApiName).getDescribe();
                this.IsUpdateable = Boolean.valueOf(fieldDescribe.isUpdateable());
            } 

            this.isRelationalField = true;                                              
            this.pageBlockDetailId = field.Id;
            this.isStaticText = false;
            this.isBlankSpace = false;
            this.fieldAPIName = field.FieldAPIName__c;
            this.objectNameOfReference = referenceFieldWrapper.objectName;
            this.actualApiName = referenceFieldWrapper.actualApiName;                                   
            this.isMultiSelect = referenceFieldWrapper.isMultiSelect;                                 
            this.helpText = String.isNotEmpty(field.HelpTextLong__c) ? field.HelpTextLong__c : referenceFieldWrapper.helpText;
            this.helpTextPost = field.HelpTextPost__c;
            this.hideFieldsJSON = field.HideFieldsJSON__c;
            //fieldWrapper.sldsColumnCSS = firstColumn ? 'slds-col slds-size_1-of-2' : 'slds-col slds-size_2-of-2';                                    
            this.requiredToSave=(field.RequiredBehavior__c=='Required for Save')?true:false;
            this.requiredToSubmit=(field.RequiredBehavior__c=='Required for Submit')?true:false;
            this.isLabelRichText = String.isNotEmpty(field.FieldLabelOverrideRichText__c)?true:false;
            this.label = String.isNotEmpty(field.FieldLabelOverrideRichText__c)?field.FieldLabelOverrideRichText__c:String.isNotEmpty(field.FieldLabelOverride__c) ? field.FieldLabelOverride__c : referenceFieldWrapper.label;
            this.hideLabel = field.HideLabel__c;
            //this.readOnly = field.ReadOnly__c;
            if(referenceFieldWrapper.isTextArea){                            
                this.fieldLength = integer.valueOf(field.AllowedWordsForRichTextArea__c);
                this.isRichTextFieldType = true;                                    
                this.showAsRichText = field.IsRichTextArea__c == true?true:false;
            }else{
                this.fieldLength =  referenceFieldWrapper.fieldLength;
            }
        }
    }

    private with sharing class ReferenceFieldWrapper{
        private String helpText{get;set;}
        private String label{get;set;}
        private String actualApiName{get;set;}
        private String parentId{get;set;}
        private String objectName{get;set;}
        private Boolean isTextArea{get;set;}
        private Boolean isHtmlFormatted{get;set;}
        private Integer fieldLength{get;set;}
        private List<String> realtedObjects{get;set;}
        private Boolean ifError{get;set;}        
        private Boolean isMultiSelect{get;set;}      
    }

    private with sharing class ActionClassResponseWrapper{        
        private List<LightningPageMessage> pageMessageList = new List<LightningPageMessage>();
        private String redirectUrl;
        private String responseMessage;
        private string actionBehavior;
        // private Integer messageTimeOut; 
        // private Boolean messageTimeOutEnabled;
    }
    
    @AuraEnabled
    public static String getPageTemplateDetails(Id recId,string templateName ,string urlVal){

        String unMangedControllerName;
        String pageTemplateName = String.isNotBlank(templateName)?templateName:null;
        String pageContextMode;
        Map<String,Object> urlMap = new Map<String,Object>(); 
        if(String.isBlank(pageTemplateName) && String.isNotEmpty(urlVal) && urlVal!='\"\"'){
            urlMap = (Map<String,Object>)JSON.deserializeUntyped(urlVal);
            Map<String,Object> stateMap = (Map<String,Object>)urlMap.get('state');
            pageTemplateName = String.valueOf(stateMap.get('c__pageTemplateName')); 
            pageContextMode = String.valueOf(stateMap.get('c__Mode'));
        }     
        String objectName = recId.getSObjectType().getDescribe().getName();

        List<SobjectConfig__c> sobjectConfig = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
        sobjectConfig = [SELECT Id,DetailLayoutInitializer__c,AutoSnapShotFieldAPIName__c from SobjectConfig__c WHERE Name = :objectName WITH USER_MODE];        
        }
        List<Object> detailLayoutInitializerList = new List<Object>();
        if(sobjectConfig.size() == 1 && sobjectConfig[0].DetailLayoutInitializer__c != null){
            try {   
                detailLayoutInitializerList = (List<Object>) JSON.deserializeUntyped(sobjectConfig[0].DetailLayoutInitializer__c);    
            } catch (Exception ex) {
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** invalid JSON Format in Field detailLayoutInitializerList of sObject**** '+ String.valueOf(ex));                
                return JSON.serialize(errorWrapper);
            }
        }else{           
            if(sobjectConfig.size()!=1){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** 0 or more then 1 config records found for SobjectConfig__c****');                
                return JSON.serialize(errorWrapper);
            }else if(String.isEmpty(pageTemplateName)){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Field DetailLayoutInitializer has no value and URL does not have page template name****');
                return JSON.serialize(errorWrapper);
            }            
        }
        
        for(Object obj : detailLayoutInitializerList){
            Map<String, Object> DetailLayoutInitializerMap = ( Map<String, Object>) obj;
            if(String.valueOf(DetailLayoutInitializerMap.get('type')) == 'ApexClass' && DetailLayoutInitializerMap.get('value') != null){
                unMangedControllerName = String.valueOf(DetailLayoutInitializerMap.get('value'));
            }
            if(pageTemplateName == null && String.valueOf(DetailLayoutInitializerMap.get('type')) == 'PageTemplate' && DetailLayoutInitializerMap.get('value') != null){
                pageTemplateName = String.valueOf(DetailLayoutInitializerMap.get('value'));//2nd
            }
        }
        
        PageLayoutWrapper pageLayoutDetail = new PageLayoutWrapper();
        pageLayoutDetail.autoSnapShotFieldAPIName = sobjectConfig[0].AutoSnapShotFieldAPIName__c;
        if(String.isNotEmpty(unMangedControllerName)){
            GenericCtrl controllerInstance = (GenericCtrl) Type.forName(unMangedControllerName).newInstance(); 
            controllerInstance.lightningObject.currentRecordId = recId;
            controllerInstance.lightningObject.currentPageUrl = urlVal;   
            String returnValue = controllerInstance.init();  
            if(String.isBlank(pageTemplateName)){
                pageTemplateName = controllerInstance.lightningObject.pageTemplateName != null?controllerInstance.lightningObject.pageTemplateName:pageTemplateName;
            }
            if(String.isNotBlank(controllerInstance.lightningObject.redirectUrl)){
                Map<String,String> redirectUrlMap = new Map<String,String>();
                redirectUrlMap.put('redirectUrl',controllerInstance.lightningObject.redirectUrl);
                return JSON.serialize(redirectUrlMap);
            }
            if(String.isEmpty(pageTemplateName) && String.isNotEmpty(returnValue)){            
                pageTemplateName = returnValue;
            }
            pageLayoutDetail = getFormConfigDetails(pageTemplateName,pageLayoutDetail);
            if(String.isNotEmpty(pageContextMode) && pageContextMode  == 'edit'){
                pageLayoutDetail.hasRecordEditAccess =  hasRecordEditAccess(recId,'Edit',pageLayoutDetail?.pageLayoutId);
                if(!pageLayoutDetail.hasRecordEditAccess){
                    List<LightningPageMessage> MessageList = new list<LightningPageMessage>();
                    MessageList.add(New LightningPageMessage('Warning','You dont have sufficient access to edit this record'));
                    pageLayoutDetail.pageMessageList.addAll(MessageList);
                }
            }  
            if(pageLayoutDetail?.pageLayoutId==null){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Incorrect config found while fetching layout of form named: '+pageTemplateName+ ' ,Object- Config: Form Detail (PageTemplate__c)****');
                return JSON.serialize(errorWrapper);
            }
            pageLayoutDetail.keyValueMap = controllerInstance.getKeyValueMapGeneric(recId);
            pageLayoutDetail.keyValueMap = controllerInstance.lightningObject.keyValueMap != null?(controllerInstance.lightningObject.keyValueMap).toString():pageLayoutDetail.keyValueMap;
            //for bug Bug 362548-point 2, task 365157--start
            if(pageLayoutDetail.keyValueMap != null && String.isNotEmpty(recId)){
                Map<String,Object> keyValueMap = (Map<String,Object>) JSON.deserializeUntyped   (pageLayoutDetail.keyValueMap);
                String id18Digit = String.valueOf(Id.valueOf(recId));
                keyValueMap.put('parentRecordIdOfFlexTable', id18Digit);
                keyValueMap.put('RecordId', id18Digit);
                keyValueMap.put('recordId', id18Digit);
                keyValueMap.put('RecordId15', id18Digit.substring(0, 14));
                pageLayoutDetail.keyValueMap = JSON.serialize(keyValueMap);
            }

            pageLayoutDetail.listValueMap = controllerInstance.getListParamsGeneric(recId);
            pageLayoutDetail.listValueMap = controllerInstance.lightningObject.listValueMap != null?(controllerInstance.lightningObject.listValueMap).toString():pageLayoutDetail.listValueMap;
            pageLayoutDetail.pageMessageList.addAll(ErrorMessageHelper.errorMessageList);
            pageLayoutDetail.pageMessageList.addAll(controllerInstance.lightningObject.messageList);
            pageLayoutDetail.messageTimeOutEnabled = KeyValueStoreHelper.getBooleanValue('PageMessageTimeOut',true);                   
            pageLayoutDetail.messageTimeOut = KeyValueStoreHelper.getIntegerValue('PageMessageTimeOut',true);                    

            return JSON.serialize(pageLayoutDetail);
        }else if(String.isNotEmpty(pageTemplateName)){
            pageLayoutDetail = getFormConfigDetails(pageTemplateName,pageLayoutDetail);
            if(String.isNotEmpty(pageContextMode) && pageContextMode  == 'edit'){
                pageLayoutDetail.hasRecordEditAccess =  hasRecordEditAccess(recId,'Edit',pageLayoutDetail?.pageLayoutId);
                if(!pageLayoutDetail.hasRecordEditAccess){
                    List<LightningPageMessage> MessageList = new list<LightningPageMessage>();
                    MessageList.add(New LightningPageMessage('Warning','You dont have sufficient access to edit this record'));
                    pageLayoutDetail.pageMessageList.addAll(MessageList);
                }
            }
            if(pageLayoutDetail?.pageLayoutId==null){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Incorrect config found while fetching layout of form named: '+pageTemplateName+ ' ,Object- Config: Form Detail (PageTemplate__c)****');
                return JSON.serialize(errorWrapper);
            }
            pageLayoutDetail.messageTimeOutEnabled = KeyValueStoreHelper.getBooleanValue('PageMessageTimeOut',true);
            pageLayoutDetail.messageTimeOut = KeyValueStoreHelper.getIntegerValue('PageMessageTimeOut',true);
            return JSON.serialize(pageLayoutDetail);
        }
        else{
            errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Issue related to pageTemplateName or unMangedControllerName ****');
            return JSON.serialize(errorWrapper);
        }            
    }

	@AuraEnabled
    public static string getProgressBarAndHeaderInst(Id templateId, Id recId){
        String objectName = recId.getSObjectType().getDescribe().getName();
        Map<String,Object> returnMap = new Map<String,Object>();
        List<PageLayoutConfig__c> layoutConfig = new List<PageLayoutConfig__c>();
        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
        layoutConfig = [SELECT Id, ProgressbarGroupName__c,HeaderDescription__c
            FROM PageLayoutConfig__c WHERE ObjectAPIName__c = :objectName and
            Id = :templateId and IsActive__c = true WITH USER_MODE];
        }
        if(layoutConfig.size() == 1){
            returnMap.put('headerInstructions', layoutConfig[0].HeaderDescription__c);
            returnMap.put('objectName',objectName);
            returnMap.put('stepProgressGroupName',layoutConfig[0].ProgressbarGroupName__c);
            return JSON.serialize(returnMap);
        }else{
            if(layoutConfig.size()!=1){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** 0 or more then 1 config records found for layoutConfig****');                
                return JSON.serialize(errorWrapper);
            }else{
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Field layoutConfig has no value****');
                return JSON.serialize(errorWrapper);                
            }
        }
    }

    @AuraEnabled
    public static string getHeaderDetails(Id templateId, Id recId,String keyValueMapString,Boolean isViewContext){
            String objectName = recId.getSObjectType().getDescribe().getName();

            List<PageLayoutConfig__c> layoutConfig = new List<PageLayoutConfig__c>();
            if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
            layoutConfig = [SELECT Id, Name, ObjectAPIName__c,FormTitle__c,Title__c ,
                ProgressbarGroupName__c,HeaderDescription__c,SaveButtonLabel__c,CancelButtonLabel__c,
                HidePDFDownload__c,HideOnDemandSnaphot__c,SnapshotClassification__c,HeaderOverride__c,
                (SELECT Id FROM Tabs_Layout_Config__r WHERE IsActive__c = true AND isOverview__c = true)                
                FROM PageLayoutConfig__c WHERE ObjectAPIName__c = :objectName and
                Id = :templateId and IsActive__c = true WITH USER_MODE];
            }
            
            if(layoutConfig.size() == 1){
                
                PageLayoutWrapper pageLayoutWrapper = new PageLayoutWrapper(layoutConfig[0]);
                pageLayoutWrapper.recordId = recId;
                
                if(!layoutConfig[0].Tabs_Layout_Config__r.isEmpty()){
                    Id tabId = layoutConfig[0].Tabs_Layout_Config__r[0].id;
                    TabWrapper headerTab = new TabWrapper();
                    headerTab.id = tabId;                
                    pageLayoutWrapper.tabs = new List<TabWrapper>{headerTab};
                }
    
                List<String> mergeFields = AppUtils.getMergeFields(layoutConfig[0].Title__c);
                fieldSet.addAll(mergeFields);
                
                Boolean isInternal = AppUtils.isInternalUser();
                Boolean isApplicant = AppUtils.isApplicant();
                String userProfile = AppUtils.getProfileInfo();
                DynamicMessageHolder bannerMessages =  new DynamicMessageHolder(layoutConfig[0].Id,isViewContext,isInternal,isApplicant,userProfile,recId);
                DynamicMessageHolder.processDynamicMessageRecords();
                if(DynamicMessageHolder.renderMessageFieldAPINameList != null) {
                    fieldSet.addAll(DynamicMessageHolder.renderMessageFieldAPINameList);
                }
                
                if(fieldSet.size()>0 &&  recId != null){
                    try{
                        fetchFeildValuesForTitle(recId, objectName);
                    }catch(Exception ex){
                        errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** invalid value in Header title field**** '+ String.valueOf(ex));                
                        return JSON.serialize(errorWrapper);
                    }
                }
                pageLayoutWrapper.headerTitle = getHeaderTitle(layoutConfig[0].Title__c,mergeFields);
                pageLayoutWrapper.stepProgressGroupName = layoutConfig[0].ProgressbarGroupName__c;
                pageLayoutWrapper.objectName = objectName;
    
                //for layout message config in banner
                Set <String> displayStyle = bannerMessages.stdStyleMsgListMap.keySet();
                if(displayStyle.size()>0){                    
                    List<LightningPageMessage> bannerMessageList = new list<LightningPageMessage>();
                    for(String msgType : displayStyle){
                        List<DynamicMessageHolder.Message> messageDetails =  bannerMessages.stdStyleMsgListMap.get(msgType);
                        for(DynamicMessageHolder.Message msgDetail : messageDetails){
                            LightningPageMessage lightningPageMessage;
                            if(msgDetail.hidePageMessage != true){
                                if(String.isNotEmpty(msgDetail.renderDecisionField)){
                                    if(AppUtils.getFieldValue(recordDetailsList[0],msgDetail.renderDecisionField)==true){
                                        lightningPageMessage = new LightningPageMessage(msgType,msgDetail.message);
                                        lightningPageMessage.messageTimeOut = msgDetail.setTimeOut?.intValue();
                                        bannerMessageList.add(lightningPageMessage);
                                    }
                                }else{
                                    lightningPageMessage = new LightningPageMessage(msgType,msgDetail.message);
                                    lightningPageMessage.messageTimeOut = msgDetail.setTimeOut?.intValue();
                                    bannerMessageList.add(lightningPageMessage);
                                }
                            }
                        }
                    }
                    pageLayoutWrapper.pageMessageList = bannerMessageList;
                }

    
                return JSON.serialize(pageLayoutWrapper); 
            }else{
                if(layoutConfig.size()!=1){
                    errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** 0 or more then 1 config records found for layoutConfig****');                
                    return JSON.serialize(errorWrapper);
                }else{
                    errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Field layoutConfig has no value****');
                    return JSON.serialize(errorWrapper);                
                } 
            }
    }

    @AuraEnabled
    public static String getPageTemplateDetailsForModal(String modalAttribute,String sOjectName){
        List<Object> pageTemplateName = new List<Object>();
        String unMangedControllerName;
        String tableName;
        String flowName;
        Map<String,Object> modalAttributeMap = new Map<String,Object>();
        Map<String,Object> detailLayoutInitializerMap = new Map<String,Object>();
        PageLayoutWrapper pageLayoutDetail = new PageLayoutWrapper();

        // 1st priority
        if(String.isNotEmpty(modalAttribute)){
            try {   
                modalAttributeMap = (Map<String,Object>)JSON.deserializeUntyped(modalAttribute);
                if(modalAttributeMap.get('PageTemplate') != null){
                    pageTemplateName = (List<Object>)modalAttributeMap.get('PageTemplate');
                }
                if(modalAttributeMap.get('ApexClass')!= null){
                    unMangedControllerName = String.valueOf(modalAttributeMap.get('ApexClass'));
                }
                if(modalAttributeMap.get('FlexTableName') != null){
                    tableName = String.valueOf(modalAttributeMap.get('FlexTableName'));
                }
                if(modalAttributeMap.get('FlexGridName') != null){
                    tableName = String.valueOf(modalAttributeMap.get('FlexGridName'));
                }
                if(modalAttributeMap.get('flowName') != null){
                    flowName = String.valueOf(modalAttributeMap.get('flowName'));
                }
                detailLayoutInitializerMap = modalAttributeMap;// pass direct pageTemplate Name
            } catch (Exception ex) {
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** invalid JSON Format in modalAttribute**** '+ String.valueOf(ex));                
                return JSON.serialize(errorWrapper);
            }
        }

        // 2nd priority
        if(pageTemplateName.size() == 0  && unMangedControllerName == null && tableName == null && flowName == null ){

            List<SobjectConfig__c> sobjectConfig = new List<SobjectConfig__c>();
            if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
            sobjectConfig = [SELECT Id,DetailLayoutInitializer__c from SobjectConfig__c WHERE Name = :sOjectName WITH USER_MODE];    
            }   
            List<Object> detailLayoutInitializerList = new List<Object>();
            if(sobjectConfig.size() == 1 && sobjectConfig[0].DetailLayoutInitializer__c != null){
                try {   
                    detailLayoutInitializerList = (List<Object>) JSON.deserializeUntyped(sobjectConfig[0].DetailLayoutInitializer__c);    
                } catch (Exception ex) {
                    errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** invalid JSON Format in Field detailLayoutInitializerList of sObject**** '+ String.valueOf(ex));                
                    return JSON.serialize(errorWrapper);
                }
            }else{           
                if(sobjectConfig.size()!=1){
                    errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** 0 or more then 1 config records found for SobjectConfig__c****');                
                    return JSON.serialize(errorWrapper);
                }else if(pageTemplateName.size()<= 0){
                    errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Modal Field DetailLayoutInitializer has no value and URL does not have page template name****');
                    return JSON.serialize(errorWrapper);
                }            
            }

            for(Object obj : detailLayoutInitializerList){
                DetailLayoutInitializerMap = ( Map<String, Object>) obj;
                if(String.valueOf(DetailLayoutInitializerMap.get('type')) == 'ApexClass' && DetailLayoutInitializerMap.get('value') != null){
                    unMangedControllerName = String.valueOf(DetailLayoutInitializerMap.get('value'));
                }
                if(pageTemplateName.size() == 0 && String.valueOf(DetailLayoutInitializerMap.get('type')) == 'PageTemplate' && DetailLayoutInitializerMap.get('value') != null){
                    pageTemplateName.add(DetailLayoutInitializerMap.get('value'));
                }
            }

            //added this condition beacuse we having  differnt format of JSON in sobject level
            if(pageTemplateName.size() != 0){
                DetailLayoutInitializerMap.clear();
                detailLayoutInitializerMap.put('PageTemplate', pageTemplateName);
            }    
        }
        
        if(String.isNotEmpty(unMangedControllerName)){
            Id recId = null;
            GenericCtrl controllerInstance = (GenericCtrl) Type.forName(unMangedControllerName).newInstance(); 
            pageLayoutDetail.objectName = sOjectName;
            pageLayoutDetail.ApexClass = unMangedControllerName;
            if(modalAttributeMap.get('urlParams') != null){
                controllerInstance.lightningObject.currentPageUrl = String.valueOf(modalAttributeMap.get('urlParams'));
            }

            if(modalAttributeMap.get('recordId') != null){
                recId = String.valueOf(modalAttributeMap.get('recordId'));
                controllerInstance.lightningObject.currentRecordId = recId;
            }
            
            // 3rd priority
            String retrunValue = controllerInstance.init();
            if(String.isNotEmpty(controllerInstance.lightningObject.pageTemplateName) && pageTemplateName.size() == 0){
                pageTemplateName.add(controllerInstance.lightningObject.pageTemplateName);
                detailLayoutInitializerMap.put('PageTemplate', pageTemplateName);
            }else if(String.isNotEmpty(controllerInstance.lightningObject.flexTableName) && controllerInstance.lightningObject.Type == 'FlexGrid' && String.isEmpty(tableName)){
                detailLayoutInitializerMap.put('FlexGridName', controllerInstance.lightningObject.flexTableName);
            } else if(String.isNotEmpty(controllerInstance.lightningObject.flexTableName)  && String.isEmpty(tableName)){
                detailLayoutInitializerMap.put('FlexTableName', controllerInstance.lightningObject.flexTableName);
            }else{
                if(String.isNotEmpty(retrunValue)){
                    pageTemplateName.add(retrunValue);
                    detailLayoutInitializerMap.put('PageTemplate', pageTemplateName);
                }
            }

            if(controllerInstance.lightningObject.currentRecordId != null){
                pageLayoutDetail.recordId = controllerInstance.lightningObject.currentRecordId;
            }
            pageLayoutDetail.listDefaultValues=controllerInstance.lightningObject.listDefaultValuesLightning;

            pageLayoutDetail.modalAttributeMap = detailLayoutInitializerMap;
            
            pageLayoutDetail.keyValueMap = controllerInstance.getKeyValueMapGeneric(recId);
            pageLayoutDetail.keyValueMap = controllerInstance.lightningObject.keyValueMap != null?(controllerInstance.lightningObject.keyValueMap).toString():pageLayoutDetail.keyValueMap;
            
            if(pageLayoutDetail.keyValueMap != null && String.isNotEmpty(recId)){
                Map<String,Object> keyValueMap = (Map<String,Object>) JSON.deserializeUntyped(pageLayoutDetail.keyValueMap);
                String id18Digit = String.valueOf(Id.valueOf(recId));
                keyValueMap.put('parentRecordIdOfFlexTable', id18Digit);
                keyValueMap.put('RecordId', id18Digit);
                keyValueMap.put('recordId', id18Digit);
                keyValueMap.put('RecordId15', id18Digit.substring(0, 14));
                pageLayoutDetail.keyValueMap = JSON.serialize(keyValueMap);
            }

            pageLayoutDetail.listValueMap = controllerInstance.getListParamsGeneric(recId);
            pageLayoutDetail.listValueMap = controllerInstance.lightningObject.listValueMap != null?(controllerInstance.lightningObject.listValueMap).toString():pageLayoutDetail.listValueMap;
          

            pageLayoutDetail.pageMessageList.addAll(ErrorMessageHelper.errorMessageList);
            pageLayoutDetail.pageMessageList.addAll(controllerInstance.lightningObject.messageList);
            if(pageLayoutDetail.pageMessageList.size()>0){
                pageLayoutDetail.messageTimeOutEnabled = KeyValueStoreHelper.getBooleanValue('PageMessageTimeOut',true);                   
                pageLayoutDetail.messageTimeOut = KeyValueStoreHelper.getIntegerValue('PageMessageTimeOut',true);                    
            }
            if(pageLayoutDetail.pageMessageList.size() == 0 && pageTemplateName.size() == 0 && modalAttributeMap.get('FlexGridName')  == null && modalAttributeMap.get('FlexTableName') == null ){
                // if we unable to find out pageTemplateName or tableName with help of unMangedControllerName also
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Issue related to pageTemplateName or table Name ****');
                return JSON.serialize(errorWrapper);
            }
            if(pageTemplateName.size() > 0){
                pageLayoutDetail = getFormConfigDetails(String.valueOf(pageTemplateName[0]),pageLayoutDetail);
            }
            
            return JSON.serialize(pageLayoutDetail);
        }else if(pageTemplateName.size() > 0 || tableName != null || flowName != null){
            pageLayoutDetail.modalAttributeMap = detailLayoutInitializerMap; 
            if(pageTemplateName.size() > 0 ){
                pageLayoutDetail = getFormConfigDetails(String.valueOf(pageTemplateName[0]),pageLayoutDetail);
            }
            
            return JSON.serialize(pageLayoutDetail);
        }else{
            errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Issue related to pageTemplateName or unMangedControllerName ****');
            return JSON.serialize(errorWrapper);
        }   

    }

    @AuraEnabled(cacheable=true)
    public static String getLayoutOnLoadDetailsForModal(String templateName,Id recId,Boolean isViewContext){
        String templateId = getPageLayoutConfigId(templateName,recId);  
        return getLayoutOnLoadDetails(templateId,null,isViewContext);
    }

    @AuraEnabled(cacheable=true)
    public static string getLayoutOnLoadDetails(Id templateId,Id recId,Boolean isViewContext){

        List<PageLayoutConfig__c> layoutConfig = new List<PageLayoutConfig__c>();
        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
        layoutConfig = [SELECT Id, Name, ObjectAPIName__c ,Title__c,FormTitle__c,ProgressbarGroupName__c,HeaderOverride__c,HidePDFDownload__c,HideOnDemandSnaphot__c,SnapshotClassification__c,
                            (select id, RedirectBehaviour__c,LabelOverrideSaveandClose__c,LabelOverrideSaveandContinue__c,name from EditTemplateConfig__r ),                       
                            (SELECT Id FROM Tabs_Layout_Config__r WHERE IsActive__c = true AND isOverview__c = true)
                            FROM PageLayoutConfig__c WHERE
                            Id = :templateId and IsActive__c = true WITH USER_MODE ];
        }
        if(layoutConfig.size() == 1){
            PageLayoutWrapper pageLayoutWrapper = new PageLayoutWrapper();
            pageLayoutWrapper.pageLayoutId = layoutConfig[0].Id;
            pageLayoutWrapper.pageLayoutName = layoutConfig[0].Name;
            pageLayoutWrapper.objectName = layoutConfig[0].ObjectAPIName__c;
            pageLayoutWrapper.stepProgressGroupName = layoutConfig[0].ProgressbarGroupName__c;
            pageLayoutWrapper.recordId = recId;
            pageLayoutWrapper.showDownloadAsPdf = layoutConfig[0].HidePDFDownload__c==true?false:true;
            pageLayoutWrapper.showSnapshotMenuButton = layoutConfig[0].HideOnDemandSnaphot__c==true?false:true;
            pageLayoutWrapper.richTextFormats = KeyValueStoreHelper.getTextValue('richTextFormatsLightning',true);
            pageLayoutWrapper.richTextFormats = pageLayoutWrapper.richTextFormats == null ? '' : pageLayoutWrapper.richTextFormats; 
            pageLayoutWrapper.redirectLogic = layoutConfig[0].EditTemplateConfig__r[0].RedirectBehaviour__c;
            pageLayoutWrapper.labelOverrideSaveandContinue = layoutConfig[0].EditTemplateConfig__r[0].LabelOverrideSaveandContinue__c;
            pageLayoutWrapper.labelOverrideSaveandClose  =  layoutConfig[0].EditTemplateConfig__r[0].LabelOverrideSaveandClose__c;
            pageLayoutWrapper.createHeaderOverride = layoutConfig[0].HeaderOverride__c;
            pageLayoutWrapper.headerNew = layoutConfig[0].FormTitle__c;
            pageLayoutWrapper.headerTitle = headerTitleForModal;
            if(!layoutConfig[0].Tabs_Layout_Config__r.isEmpty()){
                pageLayoutWrapper.isHeaderTabAvaiable = true;
            }else{
                pageLayoutWrapper.isHeaderTabAvaiable = false;
            }
            return JSON.serialize(pageLayoutWrapper);

        }else{
            if(layoutConfig.size()!=1){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** 0 or more then 1 config records found for layoutConfig****');                
                return JSON.serialize(errorWrapper);
            }else{
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Field layoutConfig has no value****');
                return JSON.serialize(errorWrapper);               
            }
        }
    }

    @AuraEnabled
    public static String getmergeFiields(String modalAttribute,String unMangedControllerName){
        try {
            Map<String,Object> modalAttributeMap = new Map<String,Object>();
            PageLayoutWrapper pageLayoutDetail = new PageLayoutWrapper();
            modalAttributeMap = (Map<String,Object>)JSON.deserializeUntyped(modalAttribute);
            if(String.isNotEmpty(unMangedControllerName)){
                Id recId = null;
                GenericCtrl controllerInstance = (GenericCtrl) Type.forName(unMangedControllerName).newInstance(); 
                if(modalAttributeMap.get('urlParams') != null){
                    controllerInstance.lightningObject.currentPageUrl = String.valueOf(modalAttributeMap.get('urlParams'));
                }
    
                if(modalAttributeMap.get('recordId') != null){
                    recId = String.valueOf(modalAttributeMap.get('recordId'));
                    controllerInstance.lightningObject.currentRecordId = recId;
                }
                
                // 3rd priority
                String retrunValue = controllerInstance.init();
               
                
                pageLayoutDetail.keyValueMap = controllerInstance.getKeyValueMapGeneric(recId);
                pageLayoutDetail.keyValueMap = controllerInstance.lightningObject.keyValueMap != null?(controllerInstance.lightningObject.keyValueMap).toString():pageLayoutDetail.keyValueMap;
                
                if(pageLayoutDetail.keyValueMap != null && String.isNotEmpty(recId)){
                    Map<String,Object> keyValueMap = (Map<String,Object>) JSON.deserializeUntyped(pageLayoutDetail.keyValueMap);
                    String id18Digit = String.valueOf(Id.valueOf(recId));
                    keyValueMap.put('parentRecordIdOfFlexTable', id18Digit);
                    keyValueMap.put('RecordId', id18Digit);
                    keyValueMap.put('recordId', id18Digit);
                    keyValueMap.put('RecordId15', id18Digit.substring(0, 14));
                    pageLayoutDetail.keyValueMap = JSON.serialize(keyValueMap);
                }
    
                pageLayoutDetail.listValueMap = controllerInstance.getListParamsGeneric(recId);
                pageLayoutDetail.listValueMap = controllerInstance.lightningObject.listValueMap != null?(controllerInstance.lightningObject.listValueMap).toString():pageLayoutDetail.listValueMap;
                
                return JSON.serialize(pageLayoutDetail);
            }else{
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Issue related to pageTemplateName or unMangedControllerName ****');
                return JSON.serialize(errorWrapper);
            }  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<String> getPageLayoutTabs(Id pageLayoutId,String objectName,Id recId,String pageLayoutTabsString,Boolean isFirstCall,Boolean isViewContext){
        List<String> tabDetails = new List<String>();
        
        List<TabConfig__c> activeTabs;
        if(isFirstCall == true){
            if(Schema.sObjectType.TabConfig__c.isAccessible()){
            activeTabs = [SELECT ID,Name,StandardTabName__c,PageBlockOrientation__c,HelpText__c,
                            IsActive__c,Operator__c,isOverview__c,HideForUser__c,HideDecisionField__c,HideForContext__c,
                            HideExpressionFields__c,HideExpressionJSON__c,HideForProfile__c,
                            HeaderInstructionText__c,HideforQueue__c,TabIcon__c
                            FROM TabConfig__c WHERE PageLayoutConfig__c =:pageLayoutId
                            AND IsActive__c = true AND isOverview__c = false WITH USER_MODE ORDER BY SortOrder__c ASC, StandardTabName__c ASC];
        }
        }else{
            activeTabs = (List<TabConfig__c>) JSON.deserialize(pageLayoutTabsString,List<TabConfig__c>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
        }

        List<TabWrapper> tabWrappers = new List<TabWrapper>();
        List<TabConfig__c> visibleTabs = new List<TabConfig__c>();
        if(activeTabs?.size() > 0){
            visibleTabs = FlexLayoutCtrlHelper.getVisibleTabs(activeTabs,objectName,recId,isViewContext);
        }
        IconCssMap = AppUtils.getActionIcon();
        for(TabConfig__c tab : visibleTabs){
            TabWrapper tabWrapper = new TabWrapper(tab);
            tabWrappers.add(tabWrapper);
        }
        
        tabDetails.add(JSON.serialize(tabWrappers));
        tabDetails.add(JSON.serialize(activeTabs));
        return tabDetails;
    }

    @AuraEnabled
    public static List<String> getPageLayoutActions(String pageLayoutWrapperString,String pageLayoutActionsString,Boolean isFirstCall,String context,Boolean isFormLayout,String formParentId){

        PageLayoutWrapper pageLayoutWrapper = (PageLayoutWrapper) JSON.deserialize(pageLayoutWrapperString, PageLayoutWrapper.class); // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
        List<String> actionDetails = new List<String>();
        List<PageLayoutActionConfig__c> actions;
        if(isFirstCall == true){
            if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
            actions =
                [SELECT ActionBehavior__c,ActionClass__c,ActionURL__c,ActionURLLightning__c,ButtonHelpText__c,
                DisableDecisionExpression__c,DisableDecisionField__c,
                DisplayArea__c,EnablePromptInputDialog__c,HideDecisionExpression__c,HideDecisionExpressionLong__c,
                HideDecisionField__c,HideExpressionFields__c,HideExpressionJSON__c,HideForContext__c,HideForProfile__c,
                HideforQueue__c,HideForRole__c,HideForUser__c,HideOperator__c,HidePanel__c,IconCSS__c,Id,IsSubmitAction__c,IsSubmit__c,
                LayoutType__c,ModalHeight__c,ModalTitle__c,ModalWidth__c,Name,Operator__c,PromptDailogHeader__c,PromptDialogText__c,
                RecordType.DeveloperName,RecordType.name,RefreshBehaviour__c,ShowIconOnly__c,SkipRollbackLogic__c,SobjectActionConfig__c,
                SobjectActionConfig__r.HideDecisionExpression__c,SobjectActionConfig__r.HideDecisionExpressionLong__c,
                SobjectActionConfig__r.HideExpressionFields__c,SobjectActionConfig__r.HideExpressionJSON__c,
                SobjectActionConfig__r.HideForContext__c,SobjectActionConfig__r.HideForProfile1__c,
                SobjectActionConfig__r.HideForUser__c,StandardAction__c,SubmitAction__c,SubmitWarningMessage__c,
                SubmitWarningMessageLong__c,Tooltip__c,Type__c
                FROM PageLayoutActionConfig__c WHERE Active__c=true AND PageLayoutConfig__c =: pageLayoutWrapper.pageLayoutId WITH USER_MODE ORDER BY HeaderSequence__c ];            
            }
        }
        else{
            actions = (List<PageLayoutActionConfig__c>) JSON.deserialize(pageLayoutActionsString,List<PageLayoutActionConfig__c>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
        }

        Map<String,Object> keyValueMap = null;
        if(pageLayoutWrapper.keyValueMap!=null){
            keyValueMap = (Map<String,Object>) JSON.deserializeUntyped(pageLayoutWrapper.keyValueMap);
        }        
        
        List<ActionWrapper> actionWrappers = new List<ActionWrapper>();        
        Map<String,Set<Id>> queueMemberMap = loadQueueMemberSetForActions(actions);
        sObject record = loadRecordWithRequiredFields(actions, pageLayoutWrapper.objectName,pageLayoutWrapper.recordId);
        
        for(PageLayoutActionConfig__c action : actions){
            ActionWrapper actionWpr = new ActionWrapper(action);
            String recordId = pageLayoutWrapper.recordId;
            
            FlexLayoutActionHandler handler = new FlexLayoutActionHandler(action, recordId,pageLayoutWrapper.objectName,queueMemberMap, action.Operator__c, keyValueMap);
            
            FlexLayoutActionProperty decision = handler.decide();
            
            Boolean isHide = false;
            if(action.SobjectActionConfig__r.HideExpressionJSON__c != null){
                isHide = ExpressionJsonEvaluator.evaluateExpression(action.SobjectActionConfig__r.HideExpressionJSON__c,record,context);
            }else if(action.HideExpressionJSON__c != null){
                isHide = ExpressionJsonEvaluator.evaluateExpression(action.HideExpressionJSON__c,record,context);
            }
            if(decision != null && !isHide ){
                actionWpr.actionUrl = decision.lightningUrl;                
                actionWrappers.add(actionWpr);
            }
        }

        ActionWrapper actionWpr1 = new ActionWrapper();
        actionWpr1.actionType = 'Save';
        actionWpr1.actionId = 'Save';
        actionWpr1.isHeaderButton = true;
        if(String.isNotEmpty(pageLayoutWrapper.saveButtonLabel)){            
            actionWpr1.actionName = pageLayoutWrapper.saveButtonLabel;
            actionWpr1.toolTipText = pageLayoutWrapper.saveButtonLabel;                        
        }
        else {
            actionWpr1.actionName = 'Save';
            actionWpr1.toolTipText = 'Save';
        }
        actionWpr1.layoutType = 'Edit';
        actionWrappers.add(actionWpr1);
        
        actionWpr1 = new ActionWrapper();
        actionWpr1.actionType = 'Cancel';
        actionWpr1.actionId = 'Cancel';
        actionWpr1.isHeaderButton = true;
        if(String.isNotEmpty(pageLayoutWrapper.cancelButtonLabel)){        
            actionWpr1.actionName = pageLayoutWrapper.cancelButtonLabel;
            actionWpr1.toolTipText = pageLayoutWrapper.cancelButtonLabel;
        }
        else {            
            actionWpr1.actionName = 'Cancel';
            actionWpr1.toolTipText = 'Cancel';
        }               
        actionWpr1.layoutType = 'Edit';
        if(KeyValueStoreHelper.getBooleanValue('CancelPromptEnable', true) == true){
            actionWpr1.warningMessage = System.Label.CancelConfirmationMessage;
        }
        actionWrappers.add(actionWpr1);

        if(isFormLayout){
            ActionWrapper cancelAction;
            for(ActionWrapper action :actionWrappers){
                if( action.standardActionType == 'Back' ) {
                    cancelAction = action;
                }
            }

            if(cancelAction == null) {
                cancelAction = new ActionWrapper();
                cancelAction.actionName = Label.HeaderBackButton;
                cancelAction.actionId = 'cancelAction';
                cancelAction.actionType = 'Custom';
                cancelAction.layoutType = 'View';                
                cancelAction.recordTypeName = 'Action URL';    
            }
            cancelAction.actionUrl = '/'+formParentId;
            actionWrappers.add(cancelAction);
        
        }

        actionDetails.add(JSON.serialize(actionWrappers));
        actionDetails.add(JSON.serialize(actions));
        return actionDetails;
    }

    @AuraEnabled
    public static List<string> getPageBlockDetails(string tabId,string recId,string objectName,Boolean isViewContext,String pageBlockConfigString,Boolean isFirstCall){
        List<PageBlockConfig__c> activePgBlockConfigs = new List<PageBlockConfig__c>();
        List<String> pgBlockDetails = new List<String>();

        if(isFirstCall){
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
            activePgBlockConfigs = [SELECT Id, TabLayoutConfig__c, PageBlockTitle__c, HeaderInstructionText__c,HelpText__c,
            BodyColumns__c, RecordType.Name,FlexTableName__c,  FlexTableName__r.name,FlexGridName__c,FlexGridName__r.name,HideForUser__c,HideDecisionField__c,HideForContext__c,
            HideExpressionFields__c,Operator__c,HideExpressionJSON__c,HideForProfile__c,HideforQueue__c,
                (SELECT Id, FieldAPIName__c, FieldLabelOverride__c, FieldLabelOverrideRichText__c, ReadOnly__c, 
                HelpTextPost__c, HelpTextLong__c, HideLabel__c,IsRichTextArea__c,HideFieldsJSON__c,
                AllowedWordsForRichTextArea__c,RequiredBehavior__c,RequiredByRole__c,RequiredForSubmitByRole__c,
                HideForUser__c,HideDecisionField__c,HideForContext__c,HideExpressionFields__c,HideForRole__c,Operator__c,
                HideExpressionJSON__c,HideForProfile__c,HideforQueue__c,DisplayLookupFieldNames__c,FilterCriteria__c,                
                ReadDecisionField__c,ReadOnlyExpressionFields__c,ReadOnlyExpressionJSON__c,ReadOnlyForContext__c,
                ReadOnlyForProfile__c,ReadOnlyForRole__c,ReadOnlyForUser__c,StaticText__c,AltRenderingConfig__c,DisableSelectAll__c,
                RecordType.DeveloperName from PageBlockFieldConfig__r
                WHERE IsActive__c = true AND IsHiddenField__c = false ORDER BY SortOrder__c ASC,FieldAPIName__c ASC) 
            from PageBlockConfig__c WHERE TabLayoutConfig__c = :tabId AND 
            IsActive__c = TRUE WITH USER_MODE ORDER BY SortOrder__c ASC];
            }
        }else{
            activePgBlockConfigs = (List<PageBlockConfig__c>) JSON.deserialize(pageBlockConfigString, List<PageBlockConfig__c>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
        }
        
        FlexLayoutCtrlHelper.HideAndReadLogicDataWrapper hideAndReadLogicData = FlexLayoutCtrlHelper.hideAndReadLogicDataInitializer(activePgBlockConfigs,objectName,recId);

        List<PageBlockWrapper> pageBlockWrappers = new List<PageBlockWrapper>();
        
        List<PageBlockConfig__c> visiblePgBlockConfigs = 
                FlexLayoutCtrlHelper.getVisiblePageBlocks(activePgBlockConfigs,hideAndReadLogicData,recId,isViewContext);

        //for layout message config in banner
        Map<Id,DynamicMessageHolder> PgBlockBannerMessageMap = new Map<Id,DynamicMessageHolder>();

        for(PageBlockConfig__c pageBlockConfig: visiblePgBlockConfigs){
            PageBlockWrapper pageBlockWrapper = new PageBlockWrapper(pageBlockConfig);                
            if(pageBlockWrapper.type == 'Fields'){
                if(fieldsMap.isEmpty()){
                    fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
                }
                List<PageBlockDetailConfig__c> pgBlockDetailConfigs = new List<PageBlockDetailConfig__c>();
                for(PageBlockDetailConfig__c pgBlockDetailConfig : pageBlockConfig.PageBlockFieldConfig__r){
                    pgBlockDetailConfigs.add(pgBlockDetailConfig);
                }
                pgBlockDetailConfigs = FlexLayoutCtrlHelper.getVisiblePageBlockDetails(pgBlockDetailConfigs,hideAndReadLogicData,recId,isViewContext);

                Map<Id,Boolean> readOnlyFieldMap = FlexLayoutCtrlHelper.getReadOnlyDetails(pgBlockDetailConfigs,hideAndReadLogicData,recId,isViewContext);
                pageBlockWrapper.fieldConfigs = getFieldDetails(pgBlockDetailConfigs,readOnlyFieldMap);
                if(recId!=null){
                    pageBlockWrapper.AltRenderFieldvalueMapStr = getAlternateFieldValues(pageBlockWrapper.fieldConfigs,objectName,recId); 
                }
            }            
            pageBlockWrappers.add(pageBlockWrapper);
        }
		if(recId!=null){
            if(Id.valueOf(recId).getSObjectType().getDescribe().getName().equalsIgnoreCase(objectName)==false){
                recId=null;
            }
        }
        if(fieldSet.size()>0 &&  recId != null){
            try{
                //pageBlockWrappers = fetchFeildValues(recId, objectName, pageBlockWrappers, PgBlockBannerMessageMap);
                pageBlockWrappers = fetchFeildValues(recId, objectName, pageBlockWrappers);
            }catch(Exception ex){
                errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** Error while fetching field values **** '+ex);                
                return new List<String>{JSON.serialize(errorWrapper)};
            }
        }

        pgBlockDetails.add(JSON.serialize(pageBlockWrappers));
        pgBlockDetails.add(JSON.serialize(activePgBlockConfigs));
        return pgBlockDetails;
    }
    private static List<string> renderMultiSelectPicklist(string fieldAPIName,string objName,String oldpicklistVal){
        String picklistVal = oldpicklistVal;
        String multiselectValues;
        Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(objName,fieldAPIName);
        List<String> picklistValues = new List<String>();
        if(String.isNotEmpty(picklistVal)){
            picklistValues = picklistVal.split(';');
        }
        List<String> multiPickListValues = new List<String>();
        for(String values : picklistValues){   
            boolean containsVal = false;
            for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                    String label = ple.getLabel();
                    if(ple.getValue() == values){
                        multiPickListValues.add(label);
                        containsVal = true;
                }
            }
            if(!containsVal)
                multiPickListValues.add(values);
        }     
        return multiPickListValues;
    }
	
	@TestVisible
	private static string getAlternateFieldValues(List<FlexLayoutController.FieldWrapper> fieldList,string objName,string recId){
        Map<String,String> altFieldList = new Map<String,String>();
        set<String> fieldLst = new set<string>();
        for(FlexLayoutController.FieldWrapper Field : fieldList){
            if(Field.isAltRendering == true){
                fieldLst.add(String.escapeSingleQuotes(Field.fieldAPIName));
            }
        }        
        if(fieldLst.size()>0){
            string query = 'select '+String.join(new List<String> (fieldLst), ',')+ ' From ' + string.escapeSingleQuotes(objName) + ' Where  id = \''+String.escapeSingleQuotes(recId)+'\'  WITH USER_MODE';
            List<SObject> results = Database.query(query); //NOPMD SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes/static bind
            for(String str : fieldLst){
                altFieldList.put(str,(String)results[0].get(str));
            }
        }

        return JSON.serialize(altFieldList);
    }
    @AuraEnabled(Cacheable=false)
    public static String actionClassExecute(String actionConfigString,String recId,String currentUrl,String  keyValueMap,String listValueMap,String formName,Object fieldValue){
        
        Savepoint savepoint;
        try{
            ActionWrapper actionConfig = (ActionWrapper)JSON.deserialize(actionConfigString, ActionWrapper.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
            Object obj;
            ActionClassResponseWrapper responseWrapper = new ActionClassResponseWrapper();
            responseWrapper.actionBehavior = actionConfig.actionBehavior;

            if(actionConfig!=null){
                if(actionConfig.skipRollbackLogic == false){
                    savepoint = Database.setSavepoint();
                }
                System.Type type;
                if(actionConfig.actionClass.contains('.')){
                    String[] splitStr = actionConfig.actionClass.split('\\.');
                    type = System.Type.forName(splitStr[0], splitStr[1]);
                }else{
                    type = System.Type.forName(actionConfig.actionClass);
                }
                if(type==null){
                    throw new CustomExceptions.InputDataException('Class ' + actionConfig.actionClass + ' not found or it is not global. Please Contact administrator.');
                }
                obj = type.newInstance();
                //for autosnapshot
                TriggerHelper.autoSnapShotForLightning = true;
                TriggerHelper.autoSnapShotFieldValue = fieldValue;
                if(keyValueMap == null){
                    keyValueMap = JSON.serialize(new Map<string,object>());                   
                }
                if(listValueMap == null){
                    listValueMap = JSON.serialize(new Map<string,object>());
                }
                TriggerHelper.controllerParamsMap = (Map<string,object>)JSON.deserializeUntyped(keyValueMap);
                TriggerHelper.controllerListParamsMap = (Map<string,object>)JSON.deserializeUntyped(listValueMap);

                if(obj instanceOf DynamicLayoutActionRedirect){
                    DynamicLayoutActionRedirect action = (DynamicLayoutActionRedirect) obj;
                    action.lightningObject.currentRecordId = recId;
                    action.lightningObject.currentPageUrl = currentUrl;
                    action.lightningObject.isLightning = true;
                    action.promptInputValue = actionConfig.promptVal;

                    Object objectResult  = action.whenClicked();
                    responseWrapper.redirectUrl = objectResult!=null?String.valueOf(((PageReference)objectResult).getUrl()):'';                    
                    responseWrapper.pageMessageList.addAll(action.lightningObject.messageList);
                    // responseWrapper.pageMessageList.addAll(ErrorMessageHelper.errorMessageList);                    
                }
                else if(obj instanceOf DynamicLayoutActionStay){
                    DynamicLayoutActionStay action = (DynamicLayoutActionStay) obj;
                    action.lightningObject.currentRecordId = recId;
                    action.lightningObject.currentPageUrl = currentUrl;
                    action.lightningObject.isLightning = true;
                    action.promptInputValue = actionConfig.promptVal;

                    responseWrapper.pageMessageList.add(New LightningPageMessage('info',String.valueOf(action.whenClicked())));
                    responseWrapper.pageMessageList.addAll(action.lightningObject.messageList);
                    // responseWrapper.pageMessageList.addAll(ErrorMessageHelper.errorMessageList);                    
                }
                else if(obj instanceOf DynamicLayoutAction){
                    DynamicLayoutAction action = (DynamicLayoutAction) obj;
                    action.lightningObject.currentRecordId = recId;
                    action.lightningObject.currentPageUrl = currentUrl;
                    action.lightningObject.isLightning = true;

                    Object objectResult  = action.whenClicked();
                    responseWrapper.redirectUrl = objectResult!=null?String.valueOf(((PageReference)objectResult).getUrl()):'';
                    responseWrapper.pageMessageList.addAll(action.lightningObject.messageList);                   
                }                
                responseWrapper.pageMessageList.addAll(ErrorMessageHelper.errorMessageList);



                if(!hasErrorMessage(responseWrapper.pageMessageList)){
                    String flexTableParameterJSON = keyValueMap!=null?keyValueMap:'';
                    historySnapshotaction(actionConfig.actionId,recId,formName,flexTableParameterJSON,listValueMap);
                }

                return JSON.serialize(responseWrapper);
            }
            else{
                throw new CustomExceptions.InputDataException('Action not found. Please Contact administrator.');
            }
        }catch(Exception ex){
            if(savepoint!=null){
                Database.rollback(savepoint);
            }
            return Apputils.handleSystemExceptionMsg(ex.getMessage());
        }
    }

    private static Boolean hasErrorMessage(List<LightningPageMessage> pageMessageList){
        if(pageMessageList.size()>0){
            for(LightningPageMessage pgMessage : pageMessageList){
                if(pgMessage.messageType.toLowerCase() == 'error'){
                    return true;
                }
            }
            return false;
        }else{
            return false;
        }
    }

    @Future(callout=true)
    private static void historySnapshotaction(String actionId,String recId,String templateName,String flexTableParameterJSON,String listParams){
        SnapshotUtils.historyPostAction(actionId, recId, templateName, flexTableParameterJSON, listParams); 
    }

    private static List<String> getHeaderTitle(String title,List<String> mergeFields){
        try {
            if(String.isNotEmpty(title)){                
                List<String> headerTitle = new List<String>();
                if(mergeFields.size() > 0){
                    headerTitle = title.split(' - ');                    

                    for(String field:mergeFields){
                        String fieldValue = String.valueOf(AppUtils.getFieldValue(recordDetailsList[0],field));
                        fieldValue = fieldValue == null ? '': fieldValue;
                            for(Integer a = 0; a < headerTitle.size(); a++){                                
                                headerTitle[a] = headerTitle[a].replace('{!'+field+'}',fieldValue);
                            }
                        }
                    return headerTitle;
                }else{                    
                    headerTitle = title.split(' - ');
                }
                return headerTitle;
            }
            else{
                return null;
            }
        } catch (Exception e) {
            return new List<String>{'Incorrect configuration of header title'};
        }                       
    }

    private static void fetchFeildValuesForTitle(Id recId,String objectName){
        String queryStr = 'SELECT ' + String.escapeSingleQuotes(String.join(new List<String>(fieldSet), ', ')) + ' from '+ String.escapeSingleQuotes(objectName) +' where id ='+ String.escapeSingleQuotes(recId) +'WITH USER_MODE';
        
        recordDetailsList = Database.query(String.escapeSingleQuotes(queryStr)); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
    }    

    public static PageLayoutWrapper getFormConfigDetails(String pageTemplateName,PageLayoutWrapper pageLayoutDetail){
        try{
            List<PageTemplate__c> formConfig = new List<PageTemplate__c>();
            if(Schema.sObjectType.PageTemplate__c.isAccessible()){
            formConfig = [SELECT Id,Name,ViewLayoutConfig__c,EditLayoutConfig__c,PrintLayoutConfig__c,
                        AllowedCharsForRichTextArea__c,AllowedWordsForRichTextArea__c,RTALimitConfig__c from PageTemplate__c 
                        WHERE Name = :pageTemplateName WITH USER_MODE];
            }
            if(formConfig.size()==1 && formConfig[0].ViewLayoutConfig__c!=null){                
                pageLayoutDetail.pageLayoutId = formConfig[0].ViewLayoutConfig__c;
                pageLayoutDetail.formName = formConfig[0].Name;
                pageLayoutDetail.formId = formConfig[0].Id;
                pageLayoutDetail.nameSpace = AppUtils.getNameSpacePrefix();
                if(String.isNotEmpty(formConfig[0].RTALimitConfig__c)){
                    pageLayoutDetail.showCharLimit = formConfig[0].RTALimitConfig__c.contains('Enforce Char Limit')?true:false;
                    pageLayoutDetail.showWordLimit = formConfig[0].RTALimitConfig__c.contains('Enforce Word Limit')?true:false;
                }else{
                    pageLayoutDetail.showCharLimit = true;
                    pageLayoutDetail.showWordLimit = false;
                }

                if(pageLayoutDetail.showCharLimit){
                    if(formConfig[0].AllowedCharsForRichTextArea__c != null) {
                        pageLayoutDetail.allowedCharsForRichTextArea = integer.valueOf(formConfig[0].AllowedCharsForRichTextArea__c);
                    }else if(KeyValueStoreHelper.getIntegerValue('TextAreaCharacterMaxLimit', true) != null) {
                        pageLayoutDetail.allowedCharsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaCharacterMaxLimit', true);
                        
                    }else {
                        pageLayoutDetail.allowedCharsForRichTextArea = 2000;
                    }

                    if(KeyValueStoreHelper.getIntegerValue('TextAreaCharacterWarningLimit', true) != null) {
                        pageLayoutDetail.warningCharsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaCharacterWarningLimit', true);
                    }else {
                        pageLayoutDetail.warningCharsForRichTextArea = pageLayoutDetail.allowedCharsForRichTextArea - 50;
                    }
                    pageLayoutDetail.showCharLimitWarning = KeyValueStoreHelper.getBooleanValue('TextAreaCharacterWarningLimit', true);
                }
                
                if(pageLayoutDetail.showWordLimit){
                    if(formConfig[0].AllowedWordsForRichTextArea__c != null) {
                        pageLayoutDetail.allowedWordsForRichTextArea = integer.valueOf(formConfig[0].AllowedWordsForRichTextArea__c);
                    }else if(KeyValueStoreHelper.getIntegerValue('TextAreaWordMaxLimit', true) != null) {
                        pageLayoutDetail.allowedWordsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaWordMaxLimit', true);
                    }else {
                        pageLayoutDetail.allowedWordsForRichTextArea = 1500;
                    }

                    if(KeyValueStoreHelper.getIntegerValue('TextAreaWordWarningLimit', true) != null) {
                        pageLayoutDetail.warningWordsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaWordWarningLimit', true);
                    }else {
                        pageLayoutDetail.warningWordsForRichTextArea = pageLayoutDetail.allowedWordsForRichTextArea - 50;
                    }
                    pageLayoutDetail.showWordLimitWarning = KeyValueStoreHelper.getBooleanValue('TextAreaWordWarningLimit', true);
                }
                return pageLayoutDetail;
            }
            else{
                return null;
            }
        }catch(Exception ex){
            return null;
        }
    }

    @AuraEnabled    
    public static Id getPageLayoutConfigId(String pageTemplateName,Id recordId){
        try{
            List<PageTemplate__c> formConfig = new List<PageTemplate__c>();
            if(Schema.sObjectType.PageTemplate__c.isAccessible()){
            formConfig = [SELECT Id,Name,ViewLayoutConfig__c,ViewLayoutConfig__r.Title__c,ViewLayoutConfig__r.ObjectAPIName__c,EditLayoutConfig__c,PrintLayoutConfig__c from PageTemplate__c 
                        WHERE Name = :pageTemplateName WITH USER_MODE];
            }
            if(formConfig.size()==1 && formConfig[0].ViewLayoutConfig__c!=null){  
                List<String> mergeFields = AppUtils.getMergeFields(formConfig[0].ViewLayoutConfig__r.Title__c);
                fieldSet.addAll(mergeFields);
                if(fieldSet.size()>0){
                    try{
                        fetchFeildValuesForTitle(recordId, formConfig[0].ViewLayoutConfig__r.ObjectAPIName__c);
                    }catch(Exception ex){
                        errorHandlerWrapper errorWrapper = new errorHandlerWrapper('**** invalid value in Header title field**** '+ String.valueOf(ex));                
                        return JSON.serialize(errorWrapper);
                    }
                }
                headerTitleForModal = getHeaderTitle(formConfig[0].ViewLayoutConfig__r.Title__c,mergeFields);
                
                    return formConfig[0].ViewLayoutConfig__c;
                    //need to give support for edit layout 
            }
            else{
                return null;
            }
        }catch(Exception ex){
            return null;
        }
    }

    private static String getReferenceObjectId(Sobject record, String fieldAPIName) {
        if(String.isEmpty(fieldAPIName) || record == null) {
            return null;
        }
        String value = null;
        if(fieldAPIName.contains('.')){
            List<String> relationshipFields = fieldAPIName.split('\\.');
            Sobject temp;
            integer i = 0;
            temp = record.getSobject(relationshipFields[0]);
            for(i=1;i<relationshipFields.size()-1;i++){   
                String singleField = relationshipFields[i];
                temp = temp?.getSobject(singleField);             
            } 
            if(temp != null && temp.get(relationshipFields[i]) != null){
                value = temp.Id;                
            }
        }        
        return value;
    }         

    private static List<FieldWrapper> getFieldDetails(List<PageBlockDetailConfig__c> fields,Map<Id,Boolean> readOnlyFieldMap){
        List<FieldWrapper> fieldWrappers = new List<FieldWrapper>();
        for(PageBlockDetailConfig__c field :fields){            
            if(field.RecordType.DeveloperName == 'StaticText'){
                FieldWrapper fieldWrapper = new FieldWrapper(field,true,false);
                fieldWrappers.add(fieldWrapper);

            }else if(field.RecordType.DeveloperName == 'BlankSpace'){
                FieldWrapper fieldWrapper = new FieldWrapper(field,false,true);
                fieldWrappers.add(fieldWrapper);
            }else if(field.RecordType.DeveloperName == 'Field'){

            if(field.FieldAPIName__c.containsNone('__r.') || field.FieldAPIName__c.containsNone('.')){
                FieldWrapper fieldWrapper = new FieldWrapper(field);                
                fieldWrapper.readOnly = readOnlyFieldMap.get(field.Id);
                fieldWrappers.add(fieldWrapper);     
                if(Auth.CommunitiesUtil.isGuestUser() || fieldWrapper.isLookUpField == true || fieldWrapper.requiredToSubmit == true || fieldWrapper.isRichTextFieldType == true || String.isNotBlank(fieldWrapper.hideFieldsJSON) || fieldWrapper.isPhoneField==true || fieldWrapper.isMultiSelect==true){                    
                    fieldSet.add(field.FieldAPIName__c);
                }
            }
            else{
                
                ReferenceFieldWrapper referenceFieldWrapper = fetchReferenceFieldDetails(field.FieldAPIName__c);
                if(referenceFieldWrapper.ifError){
                    continue;
                }

                FieldWrapper fieldWrapper = new FieldWrapper(field,referenceFieldWrapper);
                
                fieldSet.add(field.FieldAPIName__c);        
                fieldWrapper.readOnly = readOnlyFieldMap.get(field.Id);
                fieldWrappers.add(fieldWrapper);
            }
        }
        }
        return fieldWrappers;
    }

    private static List<PageBlockWrapper> fetchFeildValues(String recId,String objectName,List<PageBlockWrapper> pageBlockWrappers){
        String queryStr = 'SELECT ' + String.escapeSingleQuotes(String.join(new List<String>(fieldSet), ', ')) + ' FROM '+ String.escapeSingleQuotes(objectName) +' WHERE id = '+ String.escapeSingleQuotes(recId) +' WITH USER_MODE';

            recordDetailsList = Database.query(String.escapeSingleQuotes(queryStr)); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            if(recordDetailsList.size() == 1){
                for(PageBlockWrapper pageBlockConfig : pageBlockWrappers){
                    if(pageBlockConfig.isFields){
                        for(FieldWrapper field : pageBlockConfig.fieldConfigs){                                               
                            if(field.isStaticText || field.isBlankSpace){
                                continue;
                            }else if(field.isMultiSelect){
                                field.fieldValue =  String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));
                                if(!field.isRelationalField){
                                    field.multiselectValueList =  renderMultiSelectPicklist(Field.fieldAPIName,objectName,field.fieldValue); 
                                }else{
                                    field.multiselectValueList =  renderMultiSelectPicklist(Field.actualApiName,field.objectNameOfReference,field.fieldValue); 
                                }
   
                            }
                            else if(field.isRelationalField){
                                field.recordIdOfReference = getReferenceObjectId(recordDetailsList[0], field.fieldAPIName);                                
                                field.fieldValue = String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));
                            }
                            else if(field.isLookUpField){
                                field.fieldValue =  String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));
                            }
                            else if(field.isRichTextFieldType || field.isPhoneField){
                                field.fieldValue =  String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));

                            }
                            else if(field.requiredToSubmit){
                                field.fieldValue =  String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));
                            }
                            else if(String.isNotBlank(field.hideFieldsJSON)){
                                field.fieldValue =  String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));
                            }else if(Auth.CommunitiesUtil.isGuestUser()){//for guest user
                                field.fieldValue =  String.valueOf(AppUtils.getFieldValue(recordDetailsList[0], field.fieldAPIName));
                            }
                        }
                    }
                }
                return pageBlockWrappers;
            }
            else {
                return null;
            }   
    }

    private static ReferenceFieldWrapper fetchReferenceFieldDetails(String fieldName){
        List<String> realtedObjects = fieldName.split('\\.');
        Integer size = realtedObjects.size();
        ReferenceFieldWrapper referenceFieldWrapper = new ReferenceFieldWrapper();
        referenceFieldWrapper.realtedObjects = realtedObjects;
        referenceFieldWrapper.ifError=false;
        if(size>5){
            referenceFieldWrapper.ifError=true;
            return referenceFieldWrapper;
        }
        String requiredfieldName = realtedObjects[size-1]; 
        String referenceObjectName = '';
        Map<String,Schema.SObjectField> fieldsMapOfCurrentObject = fieldsMap;
        try{
            for(Integer i=0;i<=size-2;i++){
                Schema.SObjectType currentObject = fieldsMapOfCurrentObject.get(realtedObjects[i].replace('__r','__c').toLowerCase()).getDescribe().getReferenceTo()[0];
                referenceObjectName = String.valueOf(currentObject);
                fieldsMapOfCurrentObject = currentObject.getDescribe().fields.getMap();
            }
            DescribeFieldResult fieldDescribe = fieldsMapOfCurrentObject.get(requiredfieldName).getDescribe();
            referenceFieldWrapper.label = fieldDescribe.getLabel();
            referenceFieldWrapper.objectName = referenceObjectName;
            referenceFieldWrapper.actualApiName = requiredfieldName;
            referenceFieldWrapper.helpText = fieldDescribe.getInlineHelpText();
            referenceFieldWrapper.isTextArea = fieldDescribe.getType() == Schema.DisplayType.TextArea ? true : false;
            referenceFieldWrapper.isMultiSelect = fieldDescribe.getType().name() == 'MULTIPICKLIST' ? true : false;  
            referenceFieldWrapper.isHtmlFormatted = fieldDescribe.isHtmlFormatted();
            referenceFieldWrapper.fieldLength = fieldDescribe.getLength();
            return referenceFieldWrapper;
        }
        catch(Exception ex){
            referenceFieldWrapper.ifError=true;
            return referenceFieldWrapper;
        }
    }        
    
    private static sObject loadRecordWithRequiredFields(List<PageLayoutActionConfig__c> actions,String sobjectName,String recId){
        Set<String> expfields = new Set<String>();
        
        try {
            for(PageLayoutActionConfig__c action: actions){
                if(String.isNotEmpty(action.HideExpressionJSON__c)){
                    String mergeFields= '';
                    mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(action.HideExpressionJSON__c);
                   String alternateSobjectName = sobjectName;                
                    Map<String,Object> jsonParsed = (Map<String,Object>)Json.deserializeUntyped(action.HideExpressionJSON__c);
                        if(String.isNotEmpty(String.valueOf(jsonParsed.get('ExpressionObject')))) {
                        alternateSobjectName = String.valueOf(jsonParsed.get('ExpressionObject'));
                    }
                    if(!String.isEmpty(mergeFields)){
                        if(String.isNotEmpty(alternateSobjectName) && (ExpressionJSONEvaluator.hasSObjectField(mergeFields,alternateSobjectName) == true)) {
                            expfields.addAll(mergeFields.split(','));
                        }
                    }
                }
                if(String.isNotEmpty(action.SobjectActionConfig__r.HideExpressionJSON__c)){
                    String mergeFields= '';
                    mergeFields = ExpressionJSONEvaluator.getfieldNamesFromJSON(action.SobjectActionConfig__r.HideExpressionJSON__c);
                    String alternateSobjectName = sobjectName;                
                    Map<String,Object> jsonParsed = (Map<String,Object>)Json.deserializeUntyped(action.SobjectActionConfig__r.HideExpressionJSON__c);
                    if(String.isNotEmpty(String.valueOf(jsonParsed.get('ExpressionObject')))) {
                        alternateSobjectName = String.valueOf(jsonParsed.get('ExpressionObject'));
                    }
                    if(!String.isEmpty(mergeFields)){
                        if(String.isNotEmpty(alternateSobjectName) && (ExpressionJSONEvaluator.hasSObjectField(mergeFields,alternateSobjectName) == true)) {
                            expfields.addAll(mergeFields.split(','));
                        }
                    }
                }
            }        

            Set<String> expfieldsInLowerCase = new Set<String>{'id'};
            for(String field:expfields){                
                expfieldsInLowerCase.add(field.toLowerCase());
            }

            String query = 'SELECT '+ String.escapeSingleQuotes(String.join(new List<String>(expfieldsInLowerCase), ',')) +' FROM '+String.escapeSingleQuotes(sobjectName) + ' WHERE Id =: '+ String.escapeSingleQuotes(recId) + ' WITH USER_MODE';
            List<Sobject> recordList = Database.query(String.escapeSingleQuotes(query)); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            return recordList[0];
        }catch(Exception e){
            return null;
        }        
    }

    private static Map<String,Set<Id>> loadQueueMemberSetForActions(List<PageLayoutActionConfig__c> actions){
        Set<String> queueNames = new Set<String>();
        for(PageLayoutActionConfig__c action : actions){    
            if(String.isNotEmpty(action.HideforQueue__c)){                
                queueNames.addAll(action.HideforQueue__c.split(';'));
            }
        }

        Map<String,Set<Id>> queueMemberSet = FlexLayoutCtrlHelper.loadQueueMemberSet(queueNames);
        return queueMemberSet;
    }

    private static Boolean saveCheck(String requiredBehavior,String requiredByRole){
        if(requiredBehavior == 'Required for Save'){
            if(!getRoleInfoCalled){
                userRole = AppUtils.getRoleInfo();
            }
            List<String> requiredByRoles = new List<String>();
            if(requiredByRole != null ) {
                requiredByRoles = requiredByRole.split(';');
                for(String role : requiredByRoles) {
                    if(String.isNotEmpty(userRole)){
                        if(userRole.equals(role)) {
                            return true;
                        }
                    }
                }
                return false;
            }else{
                return true;
            }
        }else {
            return false;
        }
    }

    private static Boolean submitCheck(String requiredBehavior,String requiredByRole){
        if(requiredBehavior == 'Required for Submit'){
            if(!getRoleInfoCalled){
                userRole = AppUtils.getRoleInfo();
            }
            List<String> requiredByRoles = new List<String>();
            if(requiredByRole != null ) {
                requiredByRoles = requiredByRole.split(';');
                for(String role : requiredByRoles) {
                    if(String.isNotEmpty(userRole)){
                        if(userRole.equals(role)) {
                            return true;
                        }
                    }
                }
                return false;
            }else{
                return true;
            }
        }else {
            return false;
        }
    }   
    
    private static List<PageBlockDetailConfig__c> getVisibleFieldsForValidation(Id pageLayoutId,Id recId,Boolean isViewContext,String requiredBehaviour){
        List<PageBlockDetailConfig__c> pgBlockDetails = new List<PageBlockDetailConfig__c>();
        String objectName = recId.getSObjectType().getDescribe().getName();
        List<TabConfig__c> tabs = new List<TabConfig__c>();
        if(Schema.sObjectType.TabConfig__c.isAccessible()){
        tabs = [SELECT ID,IsActive__c,Operator__c,isOverview__c,HideForUser__c,HideDecisionField__c,HideForContext__c,
                            HideExpressionFields__c,HideExpressionJSON__c,HideForProfile__c,HideforQueue__c
                            FROM TabConfig__c WHERE PageLayoutConfig__c =:pageLayoutId
                            AND IsActive__c = true AND isOverview__c = false WITH USER_MODE ORDER BY SortOrder__c];
        }
        if(tabs?.size() > 0){
            tabs = FlexLayoutCtrlHelper.getVisibleTabs(tabs,objectName,recId,isViewContext);
        }
        Set<Id> tabIds = (new Map<Id,SObject>(tabs)).keySet();

        List<PageBlockConfig__c> PgBlockConfigs = new List<PageBlockConfig__c>();
        if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
        PgBlockConfigs = [SELECT Id,RecordType.Name,
                HideForUser__c,HideDecisionField__c,HideForContext__c,
                HideExpressionFields__c,Operator__c,HideExpressionJSON__c,HideForProfile__c,HideforQueue__c,
                (SELECT Id, FieldAPIName__c, FieldLabelOverride__c, FieldLabelOverrideRichText__c, ReadOnly__c, 
                HelpTextPost__c, HelpTextLong__c, HideLabel__c,IsRichTextArea__c,HideFieldsJSON__c,
                AllowedWordsForRichTextArea__c,RequiredBehavior__c,RequiredByRole__c,RequiredForSubmitByRole__c,
                HideForUser__c,HideDecisionField__c,HideForContext__c,HideExpressionFields__c,HideForRole__c,Operator__c,
                HideExpressionJSON__c,HideForProfile__c,HideforQueue__c,DisplayLookupFieldNames__c,FilterCriteria__c,                
                ReadDecisionField__c,ReadOnlyExpressionFields__c,ReadOnlyExpressionJSON__c,ReadOnlyForContext__c,
                ReadOnlyForProfile__c,ReadOnlyForRole__c,ReadOnlyForUser__c,StaticText__c,PageBlockConfig__r.TabLayoutConfig__r.StandardTabName__c,
                RecordType.DeveloperName from PageBlockFieldConfig__r
                WHERE IsActive__c = true AND IsHiddenField__c = false AND RequiredBehavior__c =:requiredBehaviour
                ORDER BY SortOrder__c ASC,FieldAPIName__c ASC)
                from PageBlockConfig__c WHERE TabLayoutConfig__c In :tabIds AND 
            IsActive__c = TRUE WITH USER_MODE ORDER BY SortOrder__c ASC];
        }
        FlexLayoutCtrlHelper.HideAndReadLogicDataWrapper hideAndReadLogicData = FlexLayoutCtrlHelper.hideAndReadLogicDataInitializer(PgBlockConfigs,objectName,recId);
        PgBlockConfigs = FlexLayoutCtrlHelper.getVisiblePageBlocks(PgBlockConfigs,hideAndReadLogicData,recId,isViewContext);
        
        for(PageBlockConfig__c pageBlockConfig: PgBlockConfigs){
            if(pageBlockConfig.RecordType.Name == 'Fields'){
                List<PageBlockDetailConfig__c> pgBlockDetailConfigs = new List<PageBlockDetailConfig__c>();
                for(PageBlockDetailConfig__c pgBlockDetailConfig : pageBlockConfig.PageBlockFieldConfig__r){
                    if(pgBlockDetailConfig.RecordType.DeveloperName=='Field')
                    pgBlockDetailConfigs.add(pgBlockDetailConfig);
                }
                if(!pgBlockDetailConfigs.isEmpty()){
                    pgBlockDetails.addAll(FlexLayoutCtrlHelper.getVisiblePageBlockDetails(pgBlockDetailConfigs,hideAndReadLogicData,recId,isViewContext));
                }
            }
        }
        return pgBlockDetails;
    }

    // @AuraEnabled
    @AuraEnabled
    public static String requiredForSubmitOrSave(Id layoutId,Id recId,String objectName,String requiredBehaviour,String tabsOpenedString,String pageMessageListString,Boolean isViewContext){
        try{          
            List<LightningPageMessage> pageMessages = new List<LightningPageMessage>();            
            List<PageBlockDetailConfig__c> pgBlockDetails = new List<PageBlockDetailConfig__c>();
            List<String> tabsOpened;
            if(requiredBehaviour=='Required for Submit'){
                pgBlockDetails = getVisibleFieldsForValidation(layoutId,recId,isViewContext,requiredBehaviour);
            }else if(requiredBehaviour=='Required for Save'){
                tabsOpened = (List<String>)JSON.deserialize(tabsOpenedString, List<String>.class);  // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
                
                pageMessages.addAll((List<LightningPageMessage>)JSON.deserialize(pageMessageListString, List<LightningPageMessage>.class)); // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize
                pgBlockDetails = getVisibleFieldsForValidation(layoutId,recId,isViewContext,requiredBehaviour);                
            }

            Set<String> fields= new Set<String>{'Id'};
            Map<String,String> fieldInTabMap = new Map<String,String>();
            Map<String,String> fieldApiToFieldLabelMap = new Map<String,String>();

            for(PageBlockDetailConfig__c pgBlockDetail :pgBlockDetails){
                if( requiredBehaviour=='Required for Save' &&
                    tabsOpened.contains(String.valueOf(AppUtils.getFieldValue(pgBlockDetail,'PageBlockConfig__r.TabLayoutConfig__r.Id')))){
                    continue;
                }
                Boolean isReferenceField = false;
                DescribeFieldResult fieldDescribe;
                ReferenceFieldWrapper referenceFieldWrapper;
                if(pgBlockDetail.FieldAPIName__c.containsNone('__r.') || pgBlockDetail.FieldAPIName__c.containsNone('.')){
                    fieldDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(pgBlockDetail.FieldAPIName__c).getDescribe();
                }else{
                    isReferenceField = true;
                    referenceFieldWrapper = fetchReferenceFieldDetails(pgBlockDetail.FieldAPIName__c);
                }
                if(isReferenceField){
                    fieldApiToFieldLabelMap.put(pgBlockDetail.FieldAPIName__c,
                        String.isNotEmpty(pgBlockDetail.FieldLabelOverrideRichText__c)?
                        pgBlockDetail.FieldLabelOverrideRichText__c.stripHtmlTags():
                        String.isNotEmpty(pgBlockDetail.FieldLabelOverride__c)?
                        pgBlockDetail.FieldLabelOverride__c : referenceFieldWrapper.label);
                }else{
                    fieldApiToFieldLabelMap.put(pgBlockDetail.FieldAPIName__c,
                        String.isNotEmpty(pgBlockDetail.FieldLabelOverrideRichText__c)?
                        pgBlockDetail.FieldLabelOverrideRichText__c.stripHtmlTags():
                        String.isNotEmpty(pgBlockDetail.FieldLabelOverride__c)? 
                        pgBlockDetail.FieldLabelOverride__c : fieldDescribe.getLabel());
                }
                fields.add(pgBlockDetail.FieldAPIName__c);
                fieldInTabMap.put(pgBlockDetail.FieldAPIName__c,String.valueOf(AppUtils.getFieldValue(pgBlockDetail,'PageBlockConfig__r.TabLayoutConfig__r.StandardTabName__c')));
            }
            if(recId != null){
                String query = 'SELECT '+String.escapeSingleQuotes(String.join(new List<String>(fields), ',')) +' FROM '+ String.escapeSingleQuotes(objectName) + ' WHERE Id =: '+ String.escapeSingleQuotes(recId) +' WITH USER_MODE';

                List<Sobject> recordList = Database.query(String.escapeSingleQuotes(query));  //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                if(recordList.size()==1){
                    for(String fieldApiName :fields){
                        String fieldValue=String.valueOf(AppUtils.getFieldValue(recordList[0], fieldApiName));
                        if(String.isBlank(fieldValue)){
                            pageMessages.add(new LightningPageMessage('error' ,fieldApiToFieldLabelMap.get(fieldApiName)+' is '+requiredBehaviour.toLowercase()+' under '+fieldInTabMap.get(fieldApiName)));
                        }
                    }
                }
            }else{
                for(String fieldApiName :fields){
                        pageMessages.add(new LightningPageMessage('error' ,fieldApiToFieldLabelMap.get(fieldApiName)+' is '+requiredBehaviour.toLowercase()+' under '+fieldInTabMap.get(fieldApiName)));
                    
                }
            }
            return JSON.serialize(pageMessages);
        }catch(Exception ex){         
            return JSON.serialize(new List<LightningPageMessage>{new LightningPageMessage('error',Apputils.handleSystemExceptionMsg(ex.getMessage()))});
        }
    }

    @AuraEnabled
    public static String onDemandSnapShotHelper(String recId,String pageLayoutWrapperStr ){
        try{            
            PageLayoutWrapper pageLayoutWrapper = (PageLayoutWrapper) JSON.deserialize(pageLayoutWrapperStr, FlexLayoutController.PageLayoutWrapper.class); // false+ for Deserializing objects from an untrusted source is security-sensitive - The JSON string is created from the code and not from untrusted source so no need to sanitize

            String recordId = recId;
            String templateName = pageLayoutWrapper.formName;           
            String flexTableParameters = pageLayoutWrapper.keyValueMap!=null?pageLayoutWrapper.keyValueMap:'';
            String snapshotClassification = null;
            String layoutParams = pageLayoutWrapper.listValueMap;
            if(pageLayoutWrapper.onDemandSnapClassification != null){
                snapshotClassification = pageLayoutWrapper.onDemandSnapClassification;
            }

            String attchId = SnapshotUtils.createSnapshot(recordId, templateName, flexTableParameters, layoutParams, '',
                null, pageLayoutWrapper.formId, snapshotClassification);

            Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
            if(isSalesforceFileEnabled == null){
                isSalesforceFileEnabled = false;
            }
            String snapshotMsg = '';
            if(isSalesforceFileEnabled){
                snapshotMsg = Label.SnapshotMessageFile;
            } else{
                snapshotMsg = Label.Snapshot_Message;
            }
            
            String snapshotMsgReturn  = string.format(snapshotMsg, new String[]{attchId});
            return JSON.serialize(new LightningPageMessage('success',snapshotMsgReturn));
        }
        catch(Exception ex){
            return JSON.serialize(new LightningPageMessage('error',Apputils.handleSystemExceptionMsg(ex.getMessage())));
        }
    }

    public static Boolean hasRecordEditAccess(String recId,String type,String pageLayoutId){
        Boolean result = true;
        if(KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true) != null && 
            KeyValueStoreHelper.getBooleanValue('PreventURLHacking',true) == true){  
                result = DynamicLayoutHelper.isRecordAccess(recId,type,pageLayoutId);
        }
        return result;
    }

    @AuraEnabled
    public static Object getAutoSnapshotFieldValue(Id recId,String ObjectName, String fieldApiName){
        try{
            String query = 'Select Id,' + String.escapeSingleQuotes(fieldApiName) +' from '+ String.escapeSingleQuotes(ObjectName)+' WHERE id =: '+ String.escapeSingleQuotes(recId) +' LIMIT 1';
            sObject record = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
            return AppUtils.getFieldValue(record,fieldApiName);
        }catch(Exception ex){
            return null;
        }
    }

    @AuraEnabled
    public static void initiateAutoSnapshot(Id recId,Map<String,Object> keyValueMap,Map<String, Object> listParams,Object fieldValue){
        TriggerHelper.autoSnapShotForLightning = true;
        TriggerHelper.autoSnapShotFieldValue = fieldValue;
        TriggerHelper.controllerParamsMap = keyValueMap;
        TriggerHelper.controllerListParamsMap = listParams;

        sObject sobj = recId.getSobjectType().newSObject(recId);
        upsert as user sobj;
    }
}