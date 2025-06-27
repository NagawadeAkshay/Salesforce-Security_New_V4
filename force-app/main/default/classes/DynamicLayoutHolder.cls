/**
    Displays dynamic page layout for a set of tab names which are part of a page layout configured in PageLayout__c 
    custom object. This class should be used as the parent class to leverage this functionality.
        
        Input to this class: layoutId, recordId 
    
    **********************************************************
    Audit History
    **********************************************************
    3/14/2012   Shah Kadirmohideen      Created
    **********************************************************  
*/
global with sharing class DynamicLayoutHolder {  
     
    // Intializing of Default Values in create context
    public List<DynamicLayoutDefaultValueHelper> listDefaultValues {get;set;} 
    public transient String editordata {get; set;}
    public transient Integer textAreaCharacterMaxLimit {get; set;}
    public transient Integer textAreaCharacterWarningLimit {get; set;} 
    public transient Integer textAreaWordMaxLimit {get; set;}
    public transient Integer auotpPromptTimer {get; set;}
    public transient Integer textAreaWordWarningLimit {get; set;}
    public transient Boolean textAreaCharacterMaxLimitFlag {get; set;}
    public transient Boolean textAreaCharacterWarningLimitFlag {get; set;} 
    public transient Boolean textAreaWordMaxLimitFlag {get; set;}
    public transient Boolean textAreaWordWarningLimitFlag {get; set;}
    public transient Boolean richTextAreaPluginFlag {get; set;}
    public transient Boolean textAreaPluginLimitFlag {get;set;}
    public transient String renderCondition {get;set;}
    public transient Map<String,String> fieldApiNameToFilterCriteriaMap{get;set;}
    //The following variables should be set by the extension class 
    global String layoutId {get; set;}
    //to be delete
    global transient List<Id> layoutIds = new List<Id>(); // form pdf
    global transient List<PageLayoutConfigHelper.Layout> layouts {get; set;}// form pdf
    global PageTemplate__c pageTemplate{get;set;} // cannot make transient used in save and continue behaviour 
    public string templateName {get;set;} // Used in SnapshotUtils, can not used transient keyword
    global transient  string packageId {get;set;}
    global transient List<String> formTypes{get;set;}
    // in case of forms we need parent template id to render overview tab
    public transient String parentTemplateId{get;set;}
    //Removed transient from recordId, caused numerous issues with actionClass on page layout actions, William Moore
    global String recordId {get; set;}
    public String gurId {get; set;}
    public transient string selectedRecordTypeId {get;set;}
    global  string editRecordTypeId {get;set;}
    public transient string pageBlockIds {get;set;}
    global transient string editLayoutId {get;set;}
    public Set<Object> pageBlockIdset {get;set;}
    //public Double percentageSubmit{get;set;}
    public transient List<List<Sobject>> gridLayoutSobjectList {get; set;}
    public transient Map<String,Object> gridInitiatorMap {get;set;}
    
    //Don't make this transient, it messes up the grid layout
    public  boolean isViewLayout{get;set;}
    public  Map<String,String> fieldMap;
    public transient Map<String, Map<String,String>> formFieldMap;
    //Holds the main data - used by the page to populate fields data 
    global Map<String, SObject> recordMap {get; set;}  //object API Name->object record
    public Map<String, DynaTabWrapper> tabMap {get; set;}  //tab name->list of all page blocks in a tab
    global PageLayoutConfigHelper.Layout layout {get; set;}
    global transient List<PageLayoutConfigHelper.layout> formLayouts {get;set;}
    public transient Boolean showAdminSetupLink {get; set;} 
    
    private transient Boolean isCreate;
    // can't make transient. used in take snapshot fuctionality 
    global  String flexTableParameters {get;set;} 
    global  String listParameters{get;set;}
    global transient string recordJSON {get;set;}
    global   String objName {get;set;}
    //List of  Queue Names
    //can we remove this??
    global transient Set<String> queues  = new set<String>();
    global transient Map<String,Set<Id>> queueMemberSet = new Map<String,Set<Id>>();
            
    //public Integer sequenceNumber;
    //variables required for PDF
    public transient Map<String, SObject> formRecordMap {get; set;}  //layoutId->record
    public String fieldLabelMap{get;set;}
    public Map<String,String> idtoNameMap{get;set;}
    public transient Integer autoPromptTimer{get;set;}
    public transient Boolean autoPromptEnable{get;set;} 
    public transient Boolean hideBusinessFormFieldOnEdit{get;set;}
    //public Boolean enableLightningLookup{get;set;}
    public PageReference deletePage; 
    public transient String timeZoneFormatHolder{get;set;}
    public transient String dateFormatHolder{get;set;}
    public transient String dateTimeFormatHolder{get;set;}
    public static List<XSSSanitization__mdt> lstMetadata;
    public static List<String> xssSanitizeStr = new List<String>();

    static{
        lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues' WITH USER_MODE];
        if(!lstMetadata.isempty())
             xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c) ? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();
    }



    //Constructor
    global DynamicLayoutHolder(String recordId, Boolean isViewLayout) {
    } 
    //for pdf form
    global DynamicLayoutHolder(List<Id> LayoutIds,String rcrdId, Boolean isViewLayout) {
    }

  
    
    //Constructor
    global DynamicLayoutHolder(String layoutId, String recordId, Boolean isViewLayout) {
        fetchLayout(layoutId, recordId,isViewLayout, null, null);
        
    } 
    
      //Constructor formStep config add parameter isFormStep 
    global DynamicLayoutHolder(String layoutId, String recordId, Boolean isViewLayout,Integer sequenceNumber) {     
    } 
    
    //Constructor
    public DynamicLayoutHolder(String layoutId, String recordId, Boolean isViewLayout,Set<Object> pageBlockSet) {
        fetchLayout(layoutId, recordId,isViewLayout, pageBlockSet, null);
        
    }
        
    //Constructor for Default values during create context
    public DynamicLayoutHolder(String layoutId, String recordId, Boolean isViewLayout, Set<Object> pageBlockSet, List<DynamicLayoutDefaultValueHelper> listDefaultValues){
        this.listDefaultValues = listDefaultValues;
        fetchLayout(layoutId, recordId, isViewLayout, pageBlockSet, null);
    }
     
    //for pdf
    public DynamicLayoutHolder(String layoutId, String recordId, Boolean isViewLayout, String packageId) {
        fetchLayout(layoutId, recordId,isViewLayout, null, packageId);
    }
    
    private void fetchLayout(String layoutId, String recordId, Boolean isViewLayout, Set<Object> pageBlockSet, String packageId) {
        if(recordId != null){
            Id ObjId = (Id)recordId;
            objName = ObjId.getSObjectType().getDescribe().getName();
        }
        // User Story 127005: Internal - Spring'21 release - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users - Part 2
        Boolean skipUpdateAccessCheckForGuestUser = AppUtils.isSkipPermissionCheck();
        if(skipUpdateAccessCheckForGuestUser){
            this.gurId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('gurId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            if(String.isBlank(objName) && this.gurId != null){
                objName = Id.valueOf(this.gurId).getSObjectType().getDescribe().getName();
            }
        }
        this.layoutId = layoutId;
        if (layoutId == null) {
            throw new AppUtils.ValidationException('LayoutId is empty in DynamicLayoutHolder');
        }
        this.recordId = recordId;
        this.recordMap = new Map<String, SObject>();   
        this.idtoNameMap= new Map<String,String>(); 
        this.tabMap = new Map<String, DynaTabWrapper>();
        this.showAdminSetupLink = AppUtils.isAdminUser();
        this.timeZoneFormatHolder = AppUtils.getUserTimeZoneFormat();
        this.dateFormatHolder = AppUtils.getUserDateFormatHolder();
        this.dateTimeFormatHolder = AppUtils.getUserDateTimeFormatHolder();
        this.isViewLayout = isViewLayout;
        this.formRecordMap = new Map<String, SObject>();
        //this.sequenceNumber = sequenceNumber;
        this.pageBlockIdset = pageBlockSet;
        if(isViewLayout){           
            loadViewComponents(packageId);            
        }else{          
            loadEditComponents();
        }
      
        gridLayoutSobjectList = new List<List<Sobject>>();
        gridInitiatorMap = new Map<String,Object>();
        if(recordId != null){
            gridInitiatorMap.put('ObjectIdentifier',recordId);
            gridInitiatorMap.put('IsRecordId',true);                
        }else{          
            gridInitiatorMap.put('ObjectIdentifier',layout.objectName);
            gridInitiatorMap.put('IsRecordId',false);
        }
        gridInitiatorMap.put('IsViewLayout',isViewLayout == true ? true : false);
        if(layout.messages != null){
            layout.messages.updateRenderOnDecision(layout.objectName, recordId, getPrimarySObject());
        }
        for( PageLayoutConfigHelper.Tab tab : layout.tabs){
            for( PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks){
                if(pb.messages != null){
                    pb.messages.updateRenderOnDecision(layout.objectName, recordId, getPrimarySObject());
                }
                for (PageLayoutConfigHelper.Field field : pb.fields) {
                    if(field.isRichTextAreaField && !isViewLayout && field.isReadOnlyField){
                        Object value = AppUtils.getFieldValue( recordMap.get(layout.objectName),field.fieldAPIName); 
                        if(value != null){
                            String sanitizedVal = (String)value;
                            sanitizedVal = sanitizedVal != null ? SFDCEncoder.EncodeRichText((String)sanitizedVal,xssSanitizeStr) : '';
                            AppUtils.setFieldValue(recordMap.get(layout.objectName), field.fieldAPIName, sanitizedVal);
                        }
                    }
                    if(field.dataType == 'CUSTOM-REFERENCE' && getFieldValue(field) != null){
                        String recorId = String.escapeSingleQuotes((String) getFieldValue(field));
                        String query = 'select Name from ' + String.escapeSingleQuotes(String.valueOf(((Id) recorId).getSobjectType())) + ' where Id=: '+ String.escapeSingleQuotes(recorId);
                        List<SObject> records;   
                        if(AppUtils.isObjectAccessible(String.valueOf(((Id) recorId).getSobjectType()))){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                            records = Database.query(query, AccessLevel.USER_MODE); //SOQL Injection - False +ve - object name is fetche from Schema Method
                        }
                        if(records.size() > 0) {
                            String val = (String)records[0].get('Name');
                            
                            idtoNameMap.put(recorId, val);
                       }
                    }
                }              
            }
        }
        getRichTextAreaConfigurations();
        getDynamicRenderingFieldMap();
        this.fieldLabelMap = JSON.serialize(layout.fieldLabelMap);
        
        // To get autoprompt timing

        this.autoPromptTimer = KeyValueStoreHelper.getIntegerValue('AutopromptTiming', true);
         if(this.autoPromptTimer == null){
                this.autoPromptTimer =  100;
            }
            this.autoPromptEnable = KeyValueStoreHelper.getBooleanValue('autoPromptEnable', true);
          if(this.autoPromptEnable == null)  {
                this.autoPromptEnable = false;
            }

        this.hideBusinessFormFieldOnEdit = KeyValueStoreHelper.getBooleanValue('hideBusinessFormFieldOnEdit', true) == null ? false : KeyValueStoreHelper.getBooleanValue('hideBusinessFormFieldOnEdit', true);    
        //this.enableLightningLookup = KeyValueStoreHelper.getBooleanValue('enableLightningLookup',true) == null ? false : KeyValueStoreHelper.getBooleanValue('enableLightningLookup', true);   
        
        /*if(this.fieldLabelMap != null) {
            this.fieldLabelMap = this.fieldLabelMap.replace('"', '\'');
        }*/
    }
    
    public Object getFieldValue(PageLayoutConfigHelper.Field f) {
        SObject obj = recordMap.get(f.objectAPIName);
        return AppUtils.getFieldValue(obj, f.fieldAPIName);       
    }
    
    public Object getFormFieldValue(PageLayoutConfigHelper.Field f, String layoutId) {
        Object fieldValue = Null;
        SObject obj = formRecordMap.get(layoutId);
        return AppUtils.getFieldValue(obj, f.fieldAPIName);                                                    
    }
     
    public String getFieldValueAsString(PageLayoutConfigHelper.Field f) {
        Object obj = getFieldValue(f);
        if (obj != null) {
            return String.valueOf(obj);
        }
        return '';
    }
    
    
    public String getAddressFields(PageLayoutConfigHelper.Field f)  { /*disply google map on detail pages*/
        String strAddress = '';
        if(f.addressField != null) {
            if(String.isNotBlank(f.addressField.LatitudeField) && String.isNotBlank(f.addressField.LongitudeField)) {
                String addressString = '';
                String tValue = '';
                 if(String.isNotblank(f.addressField.LatitudeField)) {
                    tValue = getAddressFieldValue(f.addressField.LatitudeField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 if(String.isNotblank(f.addressField.LongitudeField)) {
                    tValue = getAddressFieldValue(f.addressField.LongitudeField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 
                 if(String.isNotBlank(addressString)) {
                    addressString = addressString.substring(0,addressString.length()-1);
                    strAddress = addressString;
                 }    
            } else {   
                String addressString = '';
                String tValue = '';
                 if(String.isNotblank(f.addressField.StreetField)) {
                    tValue = getAddressFieldValue(f.addressField.StreetField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 if(String.isNotblank(f.addressField.CityField)) {
                    tValue = getAddressFieldValue(f.addressField.CityField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 if(String.isNotblank(f.addressField.StateField)) {
                    tValue = getAddressFieldValue(f.addressField.StateField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 if(String.isNotblank(f.addressField.ZipCodeField)) {
                    tValue = getAddressFieldValue(f.addressField.ZipCodeField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 if(String.isNotblank(f.addressField.CountryField)) {
                    tValue = getAddressFieldValue(f.addressField.CountryField, f);
                    if(String.isNotBlank(tValue)) {
                        addressString += tValue + ',';
                    }
                 }
                 
                 if(String.isNotBlank(addressString)) {
                    addressString = addressString.substring(0,addressString.length()-1);
                    strAddress = addressString;
                 }               
            }   
        }
        return strAddress;
    }
    @testVisible
    private String getAddressFieldValue(String fieldName, PageLayoutConfigHelper.Field f) {
        String strValue = '';
        if(String.isNotBlank(fieldName) && f != null) {
            if(fieldName.contains('.')) {               
                String[] splittedName =  fieldName.split('\\.');                
                SObject objRecord = recordMap.get(f.getAdjustedObjectAPIName());
                if(objRecord != null) {
                    sObject relatedObject = objRecord.getSobject(splittedName[0]);
                    if(relatedObject != null) {
                        strValue = String.valueOf(relatedObject.get(splittedName[1]));
                    }
                }
            } else {
                SObject objRecord = recordMap.get(f.getAdjustedObjectAPIName());
                if(objRecord != null) {                   
                     strValue = String.valueOf(objRecord.get(fieldName));                   
                }
            }
        }
        return strValue;
    }
    
    public String getFormFieldValueAsString(PageLayoutConfigHelper.Field f, String layoutId) {
        Object fieldValue = getFormFieldValue(f, layoutId);
        if (fieldValue != null && f.getAdjustedFieldAPIName() != null) {
            return String.valueOf(fieldValue);
        }
        return '';                                                   
    }
         
    global void setReadOnlyPageBlock(Set<Object>pageBlocksIds){
        for( PageLayoutConfigHelper.Tab tab : layout.tabs){
            for( PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks){
                Id pbId = pb.pageBlockId;
                if(!pageBlocksIds.contains(pbId)){
                    pb.isHiddenPageBlock = true;
                }
            }
        }
    }
    
    public Map<String, Object> getRecordData() {
        Map<String, Object> returnMap = new Map<String, Object>();
        if(layout != null) {
            for(PageLayoutConfigHelper.Tab tab : layout.tabs ) {
                for(PageLayoutConfigHelper.PageBlock pageBlock : tab.pageBlocks) {
                    for(PageLayoutConfigHelper.Field f : pageBlock.fields) {
                        returnMap.put(f.getAdjustedFieldAPIName(), getFieldValue(f));
                    }
                }
            }
        }
        return returnMap;
    }

    //Upserts all the dynamic records which were loaded by this class
    public Boolean upsertDynamicRecords() {
        SObject record = getPrimarySObject();

        if(record != null){
            if(selectedRecordTypeId != null){
                record.put('RecordTypeId', selectedRecordTypeId);
            }

            // Task 104303: Internal - Enhancement - Ignore record/object-level access check
            Boolean skipPermissionCheck = AppUtils.isSkipPermissionCheck();
            // User Story 123898: Internal - View All, Modify All, Edit, and Delete Object Permissions Removed for Guest Users
            Boolean insertRecord = record.get('Id') == null;
            SObject recordCopy = record.clone(false);
            if(skipPermissionCheck && String.isNotBlank(flexTableParameters)){
                Map<String, String> tmpTableParams = (Map<String, String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(flexTableParameters), Map<String, String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                if(tmpTableParams != null && tmpTableParams.containsKey('gurid')){
                    Id gurid = tmpTableParams.get('gurid');
                    if(gurid != null){
                        recordCopy.put('Id', gurid);
                        insertRecord = false;
                    }
                }
            }

            String objectName = record.getSObjectType().getDescribe().getName();
            if(insertRecord && AppUtils.isObjectCreateable(objectName)){
                insert as user record;  //CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
                return true;
            }else if(!insertRecord){
                // Task 104303: Internal - Enhancement - Ignore record/object-level access check
                if(skipPermissionCheck){
                    Boolean tmpSuccess = new SystemContextMethodsHelper().updateSobjectWithoutPermission(new List<SObject>{recordCopy});
                    if(tmpSuccess){
                        record.put('Id', gurid);
                        return true;
                    }
                }else if(AppUtils.isObjectUpdateable(objectName)){
                    update as user record; //CRUD - False +ve - As this is Sobject with the help of other method we have checked CRUD
                    return true;
                }
            }
        }
        return false;
    }
    
    /*
        Method to get the Primary SObject for the layout as the recordMap could
        contain more than 1 SObjects including the lookup relationship objects
    */
    global SObject getPrimarySObject() {
        if(objName == null && layout != null) {
            objName = layout.objectName;
        }
        return recordMap.get(objName);
    } 
    
    /* PRIVATE METHODS */ 
    
    public Boolean checkForValidationErrors(SObject record) {
        BusinessRuleResult result = BusinessRuleConfigHelper.execute(record, this);
        
        if (result != null && result.hasErrors()) {
            result.addErrorsToPage();
            return false;
        }   
        return true; //no errors
    }

    //Loads all dyanmic components for display
    private void loadViewComponents(String packageId) {
        //for the input layout id, load all tabs, page blocks & fields
        PageLayoutConfigHelper plConfigHelper = new PageLayoutConfigHelper(layoutId, true, packageId); 
        plConfigHelper.recordId = this.recordId;
        this.layout = plConfigHelper.getTabLayoutConfig();
        objName = layout.objectName;
        
        fetchSObjects();
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            tabMap.put(tab.tabId, new DynaTabWrapper(recordMap, tab, layout.isEditLayout));
        }

        //fillMissingStandardTabs();
        if(PageLayoutConfigHelper.skipFormDownload == false) {
            List<PageLayoutConfigHelper.layout> layouts = plConfigHelper.getFormLayoutConfig();
            formLayouts = new List<PageLayoutConfigHelper.layout>();
            fetchFormRecords(layouts, this.layout.objectName);
        }
    }
    
    //Loads all dynamic components for display
    private void loadEditComponents() {
 
        //for the input layout id, load all tabs, page blocks & fields
        PageLayoutConfigHelper plConfigHelper = new PageLayoutConfigHelper(layoutId, false); 
        plConfigHelper.recordId = this.recordId;
        this.layout = plConfigHelper.getTabLayoutConfig();
        objName = layout.objectName;
        
        if(pageBlockIdset != null){
             setReadOnlyPageBlock(pageBlockIdset);
        }
        fetchSObjects();
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            tabMap.put(tab.tabId, new DynaTabWrapper(recordMap, tab, layout.isEditLayout));
        }
    }
    
    private void fetchSObjects() {
        if (recordId != null) {
            isCreate = false;
            String soql;
            
            if (layout != null) {
                soql = prepareSOQL(layout, false, null);
                if(layout != null && layout.RecentlyView != null && layout.RecentlyView) {
                    soql += ' for view';    
                }
            } else {
                Set<String> fieldNames = ((Id)recordId).getSobjectType().getDescribe().fields.getMap().keyset();
                List<String> iterableFields = new List<String>(fieldNames);
                soql = 'SELECT ' + String.escapeSingleQuotes(String.join(iterableFields, ',') )+ ' FROM ' + String.escapeSingleQuotes(objName) 
                + ' WHERE id =: '+ String.escapeSingleQuotes(recordId);
            }
            
            if (soql != null) { 
                List<Sobject> recordList  = new List<Sobject>();
                try {
                   // if(AppUtils.isObjectAccessible(objName)){  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                        recordList  = Database.query(soql, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic Parts of the Query Strings are escapeSingleQuotes
                   // }
                } catch(Exception ex) {
                    CustomExceptions.logException(AppUtils.handleSystemExceptionMsg(ex) + ' : Issue for layout : ' + layout.Name  , false);
                }
                
                if(recordList.size() == 0) {
                    CustomExceptions.logException(System.Label.RecordpermissionLabel, false);  
                }
                recordMap.put(objName, recordList.get(0));  
               
                if (layout != null) {
                    populateRelationshipObjects(recordList);
                    recordJSON = json.serialize(recordList.get(0));
                }
            }
            if (layout != null) {
                initializeHideValues(layout, false);
                escapeSpecialCharacter(layout, recordMap.get(layout.objectName));
                fetchQueueMembers();
                initializeReadValues();
                intializeMergeFieldValues(layout, recordMap.get(layout.objectName));
            }
        } else {
            isCreate = true;
            initializeSObjects();
           initializeDefaultValues();
            if (layout != null) { 
                initializeHideValues(layout, false); 
            }
        }
    }
    

    private void initializeDefaultValues(){
         if(listDefaultValues != null){
            SObject primaryObj = getPrimarySObject();
            for(DynamicLayoutDefaultValueHelper dv : listDefaultValues){
                string fieldName = dv.fieldAPIName; 
                if(fieldName.contains('__r')){
                    if(primaryObj != null){
                        primaryObj.putSObject(fieldName, (sObject)dv.defaultValue);
                    }
                }else{
                if(primaryObj != null){
                    primaryObj.put(fieldName, dv.defaultValue);
                }
                }
                
                recordJSON = JSON.serialize(primaryObj);          
            }
         }
    }
    
    private void fetchFormRecords(List<PageLayoutConfigHelper.Layout> layouts, String parentObjName) {
        formRecordMap = new Map<String, SObject>();
        for(PageLayoutConfigHelper.Layout layout : layouts) {
            String soql = prepareSOQL(layout, true, parentObjName);
            List<SObject> record;
            if(AppUtils.isObjectAccessible(objName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                record = Database.query(soql, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic Parts of the where clause are escapeSingleQuotes in prepareSOQL method
            }
            if(record != null && record.size() > 0) {
                formRecordMap.put(layout.layoutId, record.get(0));
                initializeHideValues(layout, true);
                intializeMergeFieldValues(layout, record.get(0));
                formLayouts.add(layout);
            }
        }
    }
    
    private void intializeMergeFieldValues(PageLayoutConfigHelper.Layout layoutObj, Sobject record){
        fieldApiNameToFilterCriteriaMap = new Map<String,String>();
        for(PageLayoutConfigHelper.Tab tab : layoutObj.tabs){
            for(PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks){
                if(pb.flexHeaderDesc != null){
                    pb.flexHeaderDesc = AppUtils.replaceMergeFields(pb.flexHeaderDesc,record);
                    
                }
                for(PageLayoutConfigHelper.Field field: pb.fields){
                    if(field.helpTextPost!=null){
                        field.helpTextPost =  AppUtils.replaceMergeFields(field.helpTextPost,record);
                    }
                    if(field.staticTextMergeFields!=null){
                        field.staticText = AppUtils.replaceMergeFields(field.staticText, record);
                    }
                    if(field.staticText != null && layoutObj.isPrint) {
                        field.staticText = field.staticText.UnescapeJava();
                    }
                    fieldApiNameToFilterCriteriaMap.put(field.fieldApiName, String.isNotEmpty(field.filterCriteria) ? field.filterCriteria : 'undefined');
                }
            }
        }
        layoutObj.windowTitle = AppUtils.replaceMergeFields(layoutObj.windowTitle, record);
    }
    //Get Queue Members

    private void fetchQueueMembers(){
        if(layout.queues.size() > 0 ){
            queues.addAll(layout.queues);  
            if(queues.size()>0){
                List<GroupMember> groupMembers = [SELECT Id, GroupId, UserOrGroupId, Group.DeveloperName 
                                                FROM GroupMember where Group.DeveloperName in :queues
                                                and Group.type = 'Queue' WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(GroupMember memberInstance : groupMembers){
                    if(queueMemberSet.get(memberInstance.Group.DeveloperName) != null){
                        Set<Id> memberList = queueMemberSet.get(memberInstance.Group.DeveloperName);
                        memberList.add(memberInstance.UserOrGroupId);
                    } else {
                        Set<Id> memberList = new Set<Id> (); 
                        memberList.add(memberInstance.userOrGroupId);
                        queueMemberSet.put(memberInstance.Group.DeveloperName, memberList);
                    }
                } 
            }
            initializeHideforQueueValues();
        } 
    }
    // This method is to escape special character appostrophe in longtextarea
      private void escapeSpecialCharacter(PageLayoutConfigHelper.Layout lay, sObject sobj){
       
         for (PageLayoutConfigHelper.Tab tab : lay.tabs) {
            
            if(tab.hideTab != 'true'){
                for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) { 
                    for (PageLayoutConfigHelper.Field field : pb.fields) {
                        //When field is textarea or richtext area below code works.
                        if(field.dataType == 'TEXTAREA'){
                            //This method is used to get relationship fields.For e.g sampleobject2__r.Account__r.Name.
                            Object value = AppUtils.getFieldValue(sobj,field.fieldAPIName); 
                            if(value != null){
                                String longtextArea = (String)value;//(String)sobj.get(field.fieldAPIName);
                                //Below code is used to escape special characters.
                                longtextArea = longtextArea.unescapeHtml4();
                               // This method is used to set value in relationship fields.For e.g sampleobject2__r.Account__r.Name here we need to set name value in previous objects.
                                AppUtils.setFieldValue(sobj, field.fieldAPIName, longtextArea);
                                //sobj.put(field.fieldAPIName, longtextArea);
                            }
                        }
                    }
                }
            }
            
        }
    }
     
    //Initialize Hide values based on Context,UserType,Profile
    private void initializeHideValues(PageLayoutConfigHelper.Layout lay, Boolean isForm){
        Sobject record;
        if(isForm){
             record= formRecordMap.get(lay.layoutId);
        }
        else{
            record = recordMap.get(lay.objectName);
        }  
        Boolean hideDecisionValue = false;
        layout.activeTabSize = 0;
         for (PageLayoutConfigHelper.Tab tab : lay.tabs) {
            initializeHideValuesForTabs(tab,record,hideDecisionValue);
            //If tab hidden no need to execute for loop 
            if(tab.hideTab != 'true'){
                for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) { 
                    initializeHideValuesForPageBlock(pb,record,hideDecisionValue);
                    for (PageLayoutConfigHelper.Field field : pb.fields) {
                        initializeHideValuesForPageBlockDetail(field,record,hideDecisionValue);
                    }
                }
            }
            if(tab.active && !tab.isOverview && (tab.hideTab == 'false' || tab.hideTab == null) ){// {isViewLayout &&!isViewLayout && tab.flexTableCount == 0 )
                layout.activeTabSize ++;
            } 
        }
    }

    //Initialize Hide values of tabs based  on HideExpressionJson or Context,UserType,Profile(First precendence to HideExpressionJson)
    private void initializeHideValuesForTabs(PageLayoutConfigHelper.Tab tab,SObject record,Boolean hideDecisionValue ){
        if(!String.isEmpty(tab.hideExpressionJson)){
             if(isViewLayout){
                hideDecisionValue =ExpressionJsonEvaluator.evaluateExpression(tab.hideExpressionJson,record,'View');
             }else{
                 String context = String.isBlank(record.Id) ? 'Create' : 'Edit';
                 hideDecisionValue =ExpressionJsonEvaluator.evaluateExpression(tab.hideExpressionJson,record,context);
             }
                
                 tab.hideTab = String.valueOf(hideDecisionValue);
            }else if(!String.isEmpty(tab.hideDecisionField)){
                hideDecisionValue = false;
                Object val = AppUtils.getFieldValue(record, tab.hideDecisionField);
                if(val != null) {
                    hideDecisionValue = (Boolean)val;
                }
                if(hideDecisionValue != null){
                    if(!String.isEmpty(tab.hideTab)){
                        if(tab.operator == 'AND') {
                            tab.hideTab = String.valueOf(Boolean.valueOf(tab.hideTab) && hideDecisionValue);
                        }else{
                            tab.hideTab = String.valueOf(Boolean.valueOf(tab.hideTab) || hideDecisionValue);
                        }
                    }else{
                        tab.hideTab = String.valueOf(hideDecisionValue);
                    }
                }
                else{
                        tab.hideTab = tab.hideTab == null?'false':tab.hideTab;
                }
                
            }
    }
    //Initialize Hide values of PageBlock based on HideExpressionJson or Context,UserType,Profile(First precendence to HideExpressionJson)
    private void initializeHideValuesForPageBlock(PageLayoutConfigHelper.PageBlock pb,Sobject record,Boolean hideDecisionValue){
        if(!pb.isHiddenPageBlock){
            if(String.isNotBlank(pb.hideExpressionJson)) {
                if(isViewLayout) {
                    hideDecisionValue = ExpressionJsonEvaluator.evaluateExpression(pb.hideExpressionJson, record, 'View');
                } else {
                    String context = String.isBlank(record.Id) ? 'Create' : 'Edit';
                    hideDecisionValue = ExpressionJsonEvaluator.evaluateExpression(pb.hideExpressionJson, record, context);
                }
                pb.hidePageBlock = String.valueOf(hideDecisionValue);
            } else if(!String.isEmpty(pb.hideDecisionField)){
                hideDecisionValue = false;
                Object val = AppUtils.getFieldValue(record, pb.hideDecisionField);
                if(val != null) {
                    hideDecisionValue = (Boolean)val;
                }
                if(hideDecisionValue != null){
                    if(!String.isEmpty(pb.hidePageBlock)){
                        if(pb.operator == 'AND') {
                            pb.hidePageBlock = String.valueOf(Boolean.valueOf(pb.hidePageBlock) && hideDecisionValue);
                        }else{
                            pb.hidePageBlock = String.valueOf(Boolean.valueOf(pb.hidePageBlock) || hideDecisionValue);
                        }
                    }else{
                        pb.hidePageBlock = String.valueOf(hideDecisionValue);
                    }
                }else{
                    pb.hidePageBlock = pb.hidePageBlock == null?'false':pb.hidePageBlock;
                }
            }
        }else{
                pb.hidePageBlock = 'true';
        }
    }

    private void initializeHideValuesForPageBlockDetail(PageLayoutConfigHelper.Field field,Sobject record,Boolean hideDecisionValue){
        if(String.isNotBlank(field.hideExpressionJson)) {
            if(isViewLayout) {
                hideDecisionValue = ExpressionJsonEvaluator.evaluateExpression(field.hideExpressionJson, record, 'View');
            } else {
                String context = String.isBlank(record.Id) ? 'Create' : 'Edit';
                hideDecisionValue = ExpressionJsonEvaluator.evaluateExpression(field.hideExpressionJson, record, context);
            }
                field.hideField = String.valueOf(hideDecisionValue);
        } else if(!String.isEmpty(field.hideDecisionField)) {
            Object val = AppUtils.getFieldValue(record, field.hideDecisionField);
            if(val != null) {
                hideDecisionValue = (Boolean)val;
            }
            if(hideDecisionValue != null){
                field.hideField = !String.isEmpty(field.hideField) ? ((field.operator == 'AND') ? String.valueOf(Boolean.valueOf(field.hideField) && hideDecisionValue) : 
                        String.valueOf(Boolean.valueOf(field.hideField) || hideDecisionValue) ) : String.valueOf(hideDecisionValue);
            }else{
                field.hideField = field.hideField == null?'false':field.hideField;
            }
        } 
    }
    //Initialize Queue Values
    private void initializeHideForQueueValues(){    
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) { 
                for (PageLayoutConfigHelper.Field field : pb.fields) {
                    if(field.queues.size() > 0){
                        for(String queueName : field.queues) {
                            if(queueMemberSet.containsKey(queueName) && queueMemberSet.get(queueName).contains(UserInfo.getUserId()) ){
                                if(field.operator == 'AND'){
                                    //Hide for queue should work if other hide logic are not configure.This is added for pageblock,pageblock detail and tab.
                                    if(field.hideField == null || field.hideField == ''){
                                        field.hideField = 'true';
                                    }else{
                                    field.hideField = String.valueOf(Boolean.valueOf(field.hideField) && true); 
                                    }
                                    break;
                                }else{
                                    if(field.hideField == null){
                                        field.hideField = 'true';
                                    }else{
                                    field.hideField = String.valueOf(Boolean.valueOf(field.hideField) || true);
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                if(pb.queues.size() > 0){
                    for(String queueName : pb.queues) {
                        if(queueMemberSet.containsKey(queueName) && queueMemberSet.get(queueName).contains(UserInfo.getUserId()) ){
                            if(pb.operator == 'AND'){
                                if(pb.HidePageBlock == null || pb.HidePageBlock =='' ){
                                    pb.HidePageBlock = 'true';
                                }else{
                                pb.HidePageBlock = String.valueOf(Boolean.valueOf(pb.HidePageBlock) && true);
                                }
                                break;
                            }else{
                                if(pb.HidePageBlock == null || pb.HidePageBlock ==''){
                                    pb.HidePageBlock = 'true';
                                }else{
                                pb.HidePageBlock = String.valueOf(Boolean.valueOf(pb.HidePageBlock) || true);
                                }
                                break;
                            }
                        }
                    }
                }
            }
            if(tab.queues.size() > 0){
                for(String queueName : tab.queues) {
                    if(queueMemberSet.containsKey(queueName) && queueMemberSet.get(queueName).contains(UserInfo.getUserId()) ){
                        if(tab.operator == 'AND'){
                            if(tab.HideTab == null){
                                tab.HideTab = 'true';
                            }else{
                            tab.hideTab = String.valueOf(Boolean.valueOf(tab.HideTab) && true);
                            }
                            break;
                        }else{
                            if(tab.HideTab == null){
                                tab.HideTab = 'true';
                            }else{
                            tab.hideTab = String.valueOf(Boolean.valueOf(tab.HideTab) || true);
                            }
                            break;
                        }
                    }
                }               
            }
        }
    }
  
    private void initializeReadValues() {
        Sobject record = recordMap.get(layout.objectName);  
        Boolean readDecisionValue = false;
        Boolean requiredForSubmit = false;  //Bug 183986 
         for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) { 
                for (PageLayoutConfigHelper.Field field : pb.fields) {
                        if(field.isReadOnlyField == true) continue;
                        if(String.isNotBlank(field.readOnlyExpressionJson)) {
                            Boolean readOnlyDecisionValue = false;
                            if(isViewLayout) {
                                readOnlyDecisionValue = ExpressionJsonEvaluator.evaluateExpression(field.readOnlyExpressionJson, record, 'View');
                            } else {
                                String context = String.isBlank(record.Id) ? 'Create' : 'Edit';
                                readOnlyDecisionValue = ExpressionJsonEvaluator.evaluateExpression(field.readOnlyExpressionJson, record, context);
                                /* Bug 183986 START - Product - Page layout/Modal - If a field on layout is read only then it should not show the submit for required when it is in read only on Edit page
                                 Added this check to hide/show required for submit icon on the basis of read on JSON */
                                if(readOnlyDecisionValue != null && readOnlyDecisionValue == true){  
                                    field.requiredForSubmit = false; 
                            	}
                                // Bug 183986 - END 
                            }
                                field.isReadOnlyField =  readOnlyDecisionValue;  
                              
                        } else if(!String.isEmpty(field.readDecisionField)){
                            readDecisionValue = (Boolean)record.get(field.readDecisionField);
                            if(readDecisionValue != null){
                                if(Boolean.valueOf(field.isReadOnlyField) == false){
                                    //field.isReadOnlyField = true;
                                    if(field.operator == 'AND' && field.hasReadOptions) {
                                        field.isReadOnlyField = ((field.isReadOnlyField) && readDecisionValue);
                                    } else {
                                        field.isReadOnlyField = ((field.isReadOnlyField) || readDecisionValue);
                                    }
                                    
                                }else{
                                    field.isReadOnlyField = (readDecisionValue);
                                }
                            }else{
                                    field.isReadOnlyField = field.isReadOnlyField == null?false:field.isReadOnlyField;
                            }
                        }
                }
            }
        }
    }
    //Initializes all the records with empty value for fields. This is needed for the edit page's when a new record is being created
    private void initializeSObjects() {
        String pageDataHolderId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('pageDataHolder'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(!String.isEmpty(pageDataHolderId)) {
            String objectAPIName = '';
            //Pankaj : Check if there is another way
            for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
                for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) {
                    for (PageLayoutConfigHelper.Field field : pb.fields) {
                        if (field.fieldType == 'Field' || field.fieldType == 'Captcha') {
                            objectAPIName = field.objectAPIName;
                            break;
                        }
                    }
                }
            }
            PageDataHolder__c pageDataHolder;
            if(Schema.sObjectType.PageDataHolder__c.isAccessible()){
                pageDataHolder = [select id, JSONData1__c from PageDataHolder__c where id=:pageDataHolderId WITH USER_MODE];
            }
            SObject record;
            if(pageDataHolder.JSONData1__c != null) {
                record = (SObject)JSON.deserialize(SFDCEncoder.sanitizeJSON(pageDataHolder.JSONData1__c), SObject.Class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
            } else {
                record = SchemaManager.getSObject(objectAPIName).objectType.newSObject();
            }
            recordMap.put(objectAPIName, record);
        } else {
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) {
                 
                for (PageLayoutConfigHelper.Field field : pb.fields) {
                    
                    if (field.fieldType == 'Field' || field.fieldType == 'Captcha') {
                        SObject record = recordMap.get(field.objectAPIName);
                        if (record == null) {
                            record = SchemaManager.getSObject(field.objectAPIName).objectType.newSObject();
                            recordMap.put(field.objectAPIName, record);
                        }
                        
                        if (field.isRelationshipField()) {
                            
                            PageLayoutConfigHelper.Field relField = field.relationshipField;
                            record = recordMap.get(relField.objectAPIName);
                            if (record == null) {
                                record = SchemaManager.getSObject(relField.objectAPIName).objectType.newSObject();
                                recordMap.put(relField.objectAPIName, record);
                            }
                        }
                        if(field.altRen != null && (field.altRen.typex == 'Checkbox')) {
                            String fieldVal = String.valueOf(record.get(field.fieldAPIName));
                            record.put(field.fieldAPIName, ( fieldVal != null ? AppUtils.decodeToArray(fieldVal) : null) );
                        }
                        if(field.altRen != null && (field.altRen.typex == 'Multiselect')) {                            
                            record.put(field.fieldAPIName, record.get(field.fieldAPIName));
                        }
                    }
                }
            }
        } 
    }
    }
    
    //Retrieves the relationship records that are linked from the primary record identified by recordId variable.
    private void populateRelationshipObjects(List<SObject> primaryRecordList) {
        Sobject primaryRecord = primaryRecordList[0];
        Set<String> relationshipNamesProcessed = new Set<String>();
        
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) { 
                for (PageLayoutConfigHelper.Field field : pb.fields) {
                 //Commented code as approach changed, using RelationshipField component instead - Tomy - 04/06/2018
                     if(field.altRen != null && field.altRen.typex=='TypeAhead' && isViewLayout) {
                        
                        Id id = (Id)primaryRecord.get(field.fieldAPIName);
                        if(Id != null) {
                            //TODO: The below SOQL is not bulkified
                            String query = 'select name from '+ string.escapeSingleQuotes(field.altRen.autoCompleteSobject) +' where id = \''+ string.escapeSingleQuotes(id) +'\'';
                            List<Sobject> sobj;
                            if(AppUtils.isObjectAccessible(field.altRen.autoCompleteSobject)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                                sobj = Database.query(query, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic Parts of the query Strings are escapeSingleQuotes
                            }
                            if(sobj != null && sobj.size() > 0)  
                                primaryRecord.put(field.fieldAPIName,sobj[0].get('name'));
                        }
                    }
                }
            }
        }
        
        //Print all records for debugging
        
        for (String key : recordMap.keySet()) {
            SObject rec = recordMap.get(key);
            
        }
    }
    
    //input: relationshipName->Opportunity__r.SourceOfIntel__r
    private SObject fetchRelationshipRecord(List<SObject> primaryRecordList, String relationshipName) {
        Sobject primaryRecord = primaryRecordList[0];
        List<String> relationshipNames = relationshipName.split('\\.'); 
        SObject record = primaryRecord;
        for (String relationshipFieldName : relationshipNames) {
            if(record != null){
                record = record.getSObject(relationshipFieldName);
            }
        }      
        return record;
    }
        
    private String getKeyForValue(Map<String,String>  paramMap, String searchKey) {
        for(String key : paramMap.keySet()) {
            if(searchKey == paramMap.get(key)) {
                return key;
            }
        }
        return null;
    }
   
    
    private String prepareSOQL(PageLayoutConfigHelper.Layout layout, Boolean isForm, String parentObjName) {
        if(!isForm) {
            fieldMap = AppUtils.getRelationshipFieldMap(layout.objectName);  
        } else {
            if(formFieldMap == null ) {
                formFieldMap = new Map<String, Map<String, String>>();
            }
            if(formFieldMap.get(layout.layoutId) == null) {
                formFieldMap.put(layout.layoutId, AppUtils.getRelationshipFieldMap(layout.objectName));
            }
        }
        SoqlBuilder2 soqlBuilder = new SoqlBuilder2()
                .selectx('Id');
        if(!objName.equalsIgnoreCase('case') && !objName.equalsIgnoreCase('Task') && !objName.equalsIgnoreCase('caseComment') && !objName.equalsIgnoreCase('Event')){
            soqlBuilder.selectx('Name');
        }
        if(layout!= null && layout.fieldsToQuery!= null && layout.fieldsToQuery.size() > 0){
            soqlBuilder.selectx(layout.fieldsToQuery);
        }
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
            if(tab.HideExpressionFields != null){
                soqlBuilder.selectx(new Set<String>((tab.HideExpressionFields).split(',')));    
            }
            soqlBuilder.selectx(tab.HideDecisionField);
            for (PageLayoutConfigHelper.PageBlock pb : tab.pageBlocks) { 
                if(pb.hideExpressionFields != null){
                    soqlBuilder.selectx(new Set<String>((pb.hideExpressionFields).split(',')));    
                }
                if(pb.recordTypeName == 'ReCaptcha' && pb.captchaFieldAPIName != null){
                    soqlBuilder.selectx(pb.captchaFieldAPIName);
                }
                soqlBuilder.selectx(pb.HideDecisionField);
                soqlBuilder.selectx(pb.headerDescMergeFieldSet);
                for (PageLayoutConfigHelper.Field field : pb.fields) {
                    if(field.hideExpressionFields != null){
                        soqlBuilder.selectx(new Set<String>((field.hideExpressionFields).split(',')));    
                    }
                    if(field.readOnlyExpressionFields != null){
                        soqlBuilder.selectx(new Set<String>((field.readOnlyExpressionFields).split(',')));    
                    }
                    soqlBuilder.selectx(field.HideDecisionField);
                    soqlBuilder.selectx(field.ReadDecisionField);
                    soqlBuilder.selectx(field.scoreFieldApiName);  
                    soqlBuilder.selectx(field.staticTextMergeFields);
                    soqlBuilder.selectx(field.helpTextPostMergeFields);
                    if(field.fieldType == 'Google Map Location')
                    {                       
                        if(field.addressField != null)
                        {
                            if(String.isNotBlank(field.addressField.LatitudeField) && String.isNotBlank(field.addressField.LongitudeField))
                            {
                                soqlBuilder.selectx(field.addressField.LatitudeField);
                                soqlBuilder.selectx(field.addressField.LongitudeField);
                            }
                            else
                            {                               
                                if(String.isNotBlank(field.addressField.StreetField))
                                    soqlBuilder.selectx(field.addressField.StreetField);
                                if(String.isNotBlank(field.addressField.CityField))
                                    soqlBuilder.selectx(field.addressField.CityField);
                                if(String.isNotBlank(field.addressField.StateField))
                                    soqlBuilder.selectx(field.addressField.StateField);
                                if(String.isNotBlank(field.addressField.ZipCodeField))
                                    soqlBuilder.selectx(field.addressField.ZipCodeField);
                                if(String.isNotBlank(field.addressField.CountryField))
                                    soqlBuilder.selectx(field.addressField.CountryField);
                                
                            }
                        }
                    }
                    else if (field.fieldType == 'Field' || field.fieldType == 'Captcha') {
                        Boolean skipRelationshipMethod = false;
                        if(field.fieldAPIName.toLowercase() != 'id'){
                            soqlBuilder.selectx(field.fieldAPIName);
                            if(field.dataType == 'REFERENCE'){
                                String relationShipField = (!isForm) ? fieldMap.get(field.fieldAPIName.toLowercase()) : formFieldMap.get(layout.layoutId).get(field.fieldAPIName.toLowercase());
                                if(!String.isEmpty(relationShipField)){
                                    relationShipField+= '.Name';
                                    soqlBuilder.selectx(relationShipField);
                                }else if(field.isRelationshipField()){
                                    string fieldName = field.fieldAPIName;
                                    fieldName = fieldName.replaceAll('__c','__r');
                                    String fieldToQueryName =fieldName +  '.Name';
                                    soqlBuilder.selectx(fieldToQueryName);
                                    String fieldToQueryId  =fieldName + '.Id'; 
                                    soqlBuilder.selectx(fieldToQueryId);
                                }
                                skipRelationshipMethod = true;
                            }

                            if ( field.isRelationshipField() && !skipRelationshipMethod ){//&& field.fieldAPIName.containsIgnoreCase('__r')) {                            
                                soqlBuilder.selectx(getRelationshipLookupFieldAPIName(field.fieldAPIName));   
                            }
                        }
                    }
                }
            }
        }
        // Code added for issue - When we define conditional rendering functionality for a dynamic layout button, 
        // and If we don?t include the same field in the list of fields for the layout, currently we are getting error message.
        // This code is used to add those fields in the main SOQL query.
       
       // it can be part of innner query
        //PageLayoutActionConfig__c[] pactionList = [Select Id, HideDecisionField__c, DisableDecisionField__c from PageLayoutActionConfig__c Where PageLayoutConfig__c = :layout.layoutId];
        for(PageLayoutActionConfig__c actionConfig : layout.pageLayoutActions){
            if(actionConfig.HideDecisionField__c != null){
                soqlBuilder.selectx(actionConfig.HideDecisionField__c);
            }
            if(actionConfig.DisableDecisionField__c != null){
                soqlBuilder.selectx(actionConfig.DisableDecisionField__c);
            }
        }
        
        // Fetch Merge fields from Business rule expression 
        //LayoutBusinessRuleConfig__c[] businessRules = [select Expression__c from LayoutBusinessRuleConfig__c where Active__c = true and PageLayoutConfig__c =:layoutId];
        Set<String> ruleMergeFields = new Set<String>();
        for(LayoutBusinessRuleConfig__c businessRule : layout.pageLayoutBizRuleConfigs){
              if(String.isNotEmpty(businessRule.ExpressionJSONFields__c)){
                    ruleMergeFields.addAll(AppUtils.getMergeFields(businessRule.ExpressionJSONFields__c));     
              }  
        }
        for(String mergeField : ruleMergeFields){
            if(mergeField.equalsIgnoreCase('name') || mergeField.equalsIgnoreCase('id'))
            continue;
            soqlBuilder.selectx(mergeField);     
        }
        // Query fields to be displayed in header
        String pageLayoutHeader = layout.header;
        if(!String.isEmpty(pageLayoutHeader) && !String.isEmpty(recordId)){
            List<String> mergeFields = AppUtils.getMergeFields(pageLayoutHeader);
            for(String field :mergeFields){
                if(field.equalsIgnoreCase('name') || field.equalsIgnoreCase('id'))
                continue;
                soqlBuilder.selectx(field);
            }
        }
        
        if(!isForm) {
            if(DynamicMessageHolder.renderMessageFieldAPINameList != null) {
                soqlBuilder.selectx(DynamicMessageHolder.renderMessageFieldAPINameList);
            }
            soqlBuilder
                    .fromx(layout.objectName)
                    .wherex('Id', '=', String.escapeSingleQuotes(recordId), null);
        } else {
            if(parentObjName.equalsIgnoreCase(layout.objectName)) {
                soqlBuilder
                    .fromx(layout.objectName)
                    .wherex('Id', '=', String.escapeSingleQuotes(recordId), null);
            } else {
                soqlBuilder
                    .fromx(layout.objectName)
                    .wherex(String.escapeSingleQuotes(layout.formParentFieldAPI), '=',String.escapeSingleQuotes(recordId), null);
                String FormConfigFieldAPI = getRelationShipFieldAPINameForPageTemplate(layout.objectName);//getKeyForValue(formFieldMap.get(layout.layoutId), (AppUtils.getNamespacePrefix()+'PageTemplate__c')toLowercase());
                soqlBuilder
                    .fromx(layout.objectName)
                    .wherex(' and ' + String.escapeSingleQuotes(FormConfigFieldAPI), '=',+String.escapeSingleQuotes(layout.formId), null);
            }
        }
        
        return soqlBuilder.toSoql();
    }
    
    private String getRelationShipFieldAPINameForPageTemplate(String objectAPIName) {
        SObjectType sObjType = Schema.getGlobalDescribe().get(objectAPIName);
        Map<String, Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();
        String packageReferenceFieldAPIName = null;
        for(Schema.SObjectField sObjField : mfields.values()){
            Schema.DescribeFieldResult fldDesc = sObjField.getDescribe();
            if( fldDesc.getType().name() == 'REFERENCE') {
                if( (fldDesc.getReferenceTo()[0]).getDescribe().getName() == AppUtils.getnamespacePrefix()+'PageTemplate__c'){
                    return fldDesc.getName();
                }
            }
        }
        return null;
    }
    
   
    //input->Opportunity__r.SourceOfIntel__r.HomePhone, output->Opportunity__r.SourceOfIntel__c
    private String getRelationshipLookupFieldAPIName(String relationshipFieldName) {
        Integer i = relationshipFieldName.lastIndexOF('.');
       
        if (i == -1) return null;
        String relationshipFieldAPIName = relationshipFieldName.substring(0, i);
        
        if (relationshipFieldAPIName.endsWith('__r')) {
            relationshipFieldAPIName = relationshipFieldAPIName.substring(0, relationshipFieldAPIName.length()-1) + 'c';
        } 
        return relationshipFieldAPIName; 
    }

    //input->Opportunity__r.SourceOfIntel__r.HomePhone, output->Opportunity__r.SourceOfIntel__r
    private String getRelationshipAPIName(String relationshipFieldName) {
        Integer i = relationshipFieldName.lastIndexOF('.');
        if (i == -1) return null;
        String relationshipFieldAPIName = relationshipFieldName.substring(0, i);
        return relationshipFieldAPIName;
    }
    
    private void fillMissingStandardTabs() {
       
        
        Schema.DescribeFieldResult fieldDesc = TabConfig__c.StandardTabName__c.getDescribe();
        
        for (Schema.PicklistEntry entry : fieldDesc.getPicklistValues()) {
            String tabName = entry.getValue();
            if (tabMap.containsKey(tabName) == false) {
                DynaTabWrapper tabWrapper = new DynaTabWrapper();
                tabWrapper.tab = new PageLayoutConfigHelper.Tab();
                
                tabMap.put(tabName, tabWrapper);
            }
        }          
    }
    
    private void getRichTextAreaConfigurations() {
        this.textAreaCharacterMaxLimit = KeyValueStoreHelper.getIntegerValue('TextAreaCharacterMaxLimit', true);
        this.textAreaCharacterWarningLimit = KeyValueStoreHelper.getIntegerValue('TextAreaCharacterWarningLimit', true);
        this.textAreaWordMaxLimit = KeyValueStoreHelper.getIntegerValue('TextAreaWordMaxLimit', true);
        this.auotpPromptTimer = KeyValueStoreHelper.getIntegerValue('auotpPromptTimer',true);
        this.textAreaWordWarningLimit = KeyValueStoreHelper.getIntegerValue('TextAreaWordWarningLimit', true);
        this.textAreaCharacterMaxLimitFlag = KeyValueStoreHelper.getBooleanValue('TextAreaCharacterMaxLimit', true);
        this.textAreaCharacterWarningLimitFlag = KeyValueStoreHelper.getBooleanValue('TextAreaCharacterWarningLimit', true);
        this.textAreaWordMaxLimitFlag = KeyValueStoreHelper.getBooleanValue('TextAreaWordMaxLimit', true);
        this.textAreaWordWarningLimitFlag = KeyValueStoreHelper.getBooleanValue('TextAreaWordWarningLimit', true);
        this.richTextAreaPluginFlag = KeyValueStoreHelper.getBooleanValue('RichTextAreaPlugin', true);  
        this.textAreaPluginLimitFlag = KeyValueStoreHelper.getBooleanValue('TextAreaPluginLimit', true);
    }

    private void getDynamicRenderingFieldMap() {
         this.renderCondition = PageLayoutConfigHelper.fieldConditionMap;
    }
    
    /* INNER CLASS */
    
    public with sharing class DynaTabWrapper {
        public Map<String, SObject> recordMap {get; set;}
        public PageLayoutConfigHelper.Tab tab {get; set;}
        public Boolean isEditLayout {get; set;}
        
        public DynaTabWrapper() {
            this.recordMap = new Map<String, SObject>();
        }
        
        public DynaTabWrapper(Map<String, SObject> recordMap, PageLayoutConfigHelper.Tab tab, Boolean isEditLayout) {
            this.recordMap = recordMap;
            this.tab = tab;
            this.isEditLayout = isEditLayout;
        }
    }
}