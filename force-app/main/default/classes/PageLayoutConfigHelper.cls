/****
    Helper class used to fetch page layout & related configuration from various custom settings.
    A page layout consists of the following components:
        - Layout consists of Tabs (PageLayoutConfig__c)
        - Tab consists of Page Blocks (TabConfig__c)
        - Page Block consists of Fields or Field Sets (PageBlockConfig__c)
        - Fields or field sets belong to page blocks (PageBlockDetailConfig__c)
        
    **********************************************************
    Audit History
    **********************************************************
    3/18/2012   Shah Kadirmohideen      Created
    SF review
    **********************************************************  
*/
global with sharing class PageLayoutConfigHelper {
    private List<String> layoutIds;
    private transient String layoutId;
    public String recordId {get; set;}

    private Map<String, Map<String,String>> lookupFieldToObjNameMap = new Map<String,Map<String, String>>();
    private String tabName;
    public enum Orientation {LEFT_RIGHT, TOP_DOWN}
    public Layout layout;
    private transient Map<String, Layout> formLayoutById;  
    private transient Map<String, PageBlock> pageBlockMap;  
    private transient Map<String, Tab> tabMap = new Map<String, Tab>();
    private boolean isViewLayout;
    private boolean isInternal;
    private boolean isApplicant;
    public boolean isMiniLayout = false;
    private string userProfile;
    private string userRole;
    //public Set<String> fieldsToQuerySet; 
    transient Map<String, Map<String,String>> fieldCondMap {get;set;} // temp transient
    public static String fieldConditionMap {get;set;}
    public static PageTemplate__c pageTemplate{get;set;}
    private transient Integer  textRows = KeyValueStoreHelper.getIntegerValue('TextAreaRows', true);
    private transient Integer  textAreaColumns = KeyValueStoreHelper.getIntegerValue('TextAreaColumns', true); 
    private transient Integer  bodyColumnsPicklist2 = KeyValueStoreHelper.getIntegerValue('BodyColumn2PicklistWidth',true);
    private transient Integer  bodyColumnsPicklist1 = KeyValueStoreHelper.getIntegerValue('BodyColumn1PicklistWidth',true);
    private transient boolean isFormStep;
    private transient Map<String, PageTemplate__c> pageTemplateById = new Map<String, PageTemplate__c>();
    public static Boolean isPrint = false;
    public static Boolean skipFormDownload = false;
    public static transient List<String> formTypeList = new List<String>();
    private static Map<String,AlternativeRendering> dynamicConfigMapByName = new Map<String,AlternativeRendering>();
    public static List<XSSSanitization__mdt> lstMetadata;
    public static List<String> xssSanitizeStr = new List<String>();

    static{
       lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues' WITH USER_MODE];
       if(!lstMetadata.isempty())
           xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c) ? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();
    }
    
    global PageLayoutConfigHelper() {}
    
    //Constructor used to load all tabs for a given page layout. It does not load page blocks/fields
    global PageLayoutConfigHelper(String layoutId, Boolean isViewLayout) {
        this.layoutId = layoutId;
        List<String> layoutIds = new List<String>{layoutId};
        loadData(layoutIds, isViewLayout, null, null, null, true, null);
        if(ApexPages.CurrentPage() != null){
            String recId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));  //ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            if(!String.isEmpty(recId)) {
                this.recordId = recId;  
            }
        }
    }

     //This constructor is created for Mini Page Layout. 
    global PageLayoutConfigHelper(String layoutId,Id recordId) {
        this.layoutId = layoutId;
        List<String> layoutIds = new List<String>{layoutId};
        isMiniLayout= true;
        loadData(layoutIds, true, null, null, recordId, false, null);
    }
    
    // This constructor is for print layout
    global PageLayoutConfigHelper(String layoutId, Boolean isViewLayout, String packageId) {
        this.layoutId = layoutId;
        List<String> layoutIds = new List<String>{layoutId};
        if(packageId != null) {
            List<PackageFormConfig__c> packageFormConfigs = new List<PackageFormConfig__c>(); 
            if(Schema.sObjectType.PackageFormConfig__c.isAccessible()){
                if(formTypeList != null && formTypeList.size() > 0) {
                    packageFormConfigs = [select FormConfig__c, PackageConfig__r.PageTemplateConfig__r.SkipFormDownload__c, FormConfig__r.PrintLayoutConfig__c,FormConfig__r.ParentObjectFieldAPI__c,FormConfig__r.SkipFormDownload__c from PackageFormConfig__c 
                                        where PackageConfig__c=:packageId and FormConfig__r.FormType__c in:formTypeList WITH USER_MODE];
                } else {
                    packageFormConfigs = [select FormConfig__c, PackageConfig__r.PageTemplateConfig__r.SkipFormDownload__c, FormConfig__r.PrintLayoutConfig__c,FormConfig__r.ParentObjectFieldAPI__c,FormConfig__r.SkipFormDownload__c from PackageFormConfig__c 
                                        where PackageConfig__c=:packageId WITH USER_MODE];
                }
            }
            for(PackageFormConfig__c pkgFormConfig : packageFormConfigs) {
                if(pkgFormConfig.FormConfig__r.SkipFormDownload__c != true) {
                layoutIds.add(pkgFormConfig.FormConfig__r.PrintLayoutConfig__c);
                pageTemplateById.put(pkgFormConfig.FormConfig__r.PrintLayoutConfig__c, pkgFormConfig.FormConfig__r);
            }
        }
            if(packageFormConfigs.size() > 0 && packageFormConfigs.get(0).PackageConfig__r !=null && packageFormConfigs.get(0).PackageConfig__r.PageTemplateConfig__r.SkipFormDownload__c == true) {
                skipFormDownload = true;
            }
        }
        loadData(layoutIds, true, null, null, recordId, true, null);
    }
     
    //Constructor used to load 1st tab or All other tabs for a given page layout. 
    global PageLayoutConfigHelper(String layoutId, boolean firstTabOnly, boolean restOfTheTabs, Boolean isViewLayout) {
        this.layoutId = layoutId;
        List<String> layoutIds = new List<String>{layoutId};
        loadData(layoutIds, isViewLayout, firstTabOnly, restOfTheTabs, null, true, null);
    }
    
    //Constructor used to load all active page blocks and fields for a given tabname which is linked to a page layout
    global PageLayoutConfigHelper(String layoutId, String tabName, Boolean isViewLayout) {
        this.layoutId = layoutId;
        List<String> layoutIds = new List<String>{layoutId};
        loadData(layoutIds, isViewLayout, null, null, null, true, tabName);
    }
    //Constructor used to load all active page blocks and fields for a given StepID/Tab which is linked to a page layout
    global PageLayoutConfigHelper(String layoutId, Integer sequenceNumber,Boolean isViewLayout) {
    }
    
    public void loadData(List<String> layoutIds, Boolean isViewLayout, boolean firstTabOnly, boolean restOfTheTabs, String recordId, Boolean loadFieldRows, String tabName) {
        //fieldsToQuerySet = new Set<String>();
        this.isInternal = AppUtils.isInternalUser();
        this.isApplicant = AppUtils.isApplicant();
        this.layoutIds = layoutIds;
        this.tabName = tabName;
        this.userProfile = AppUtils.getProfileInfo();
        this.userRole = AppUtils.getRoleInfo();
        //this.namespace = AppUtils.getNameSpacePrefix();
        this.isViewLayout = isViewLayout;
        this.recordId = recordId;
        this.formLayoutById = new Map<String, Layout>(); 
        if(String.isEmpty(recordId) && ApexPages.CurrentPage() != null) {
            // Code Add for Hide for Context not working for Edit Mode:
            String recId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            this.recordId = recId;  
        }
       
        if(String.isEmpty(this.recordId)) {        
            //this.recordId = ApexPages.CurrentPage().getParameters().get('id');
            this.recordId = null;  
        }
        if(isViewLayout){ 
            loadViewLayout();
        } else{
            loadEditLayout();
        }
        if (this.layout == null) return;
        if(firstTabOnly != null && firstTabOnly){
            loadFirstTabOnly(this.layoutIds);
        } else if(firstTabOnly != null && restOfTheTabs){
            loadOtherTabs(this.layoutIds);
        } else if(tabName != null){
            loadTab();
        } else {
            loadTabs();
        }
        if (layout.tabs.size() == 0) return;
        loadPageBlocks();
        loadFields();
        DynamicMessageHolder.processDynamicMessageRecords();
        sortAll(); 
        if(loadFieldRows) {
            loadFieldRows();
        }
    }
     
    /*
        Returns the layout configuration for 1st tab of a given layout id
    */
    public void loadFirstTabOnly(List<string> layoutIds) {
        //String tabName = ApexPages.CurrentPage().getParameters().get('tabName');  
        String tabName = '';
        List<TabConfig__c> tc = new List<TabConfig__c>();
         if(Schema.SObjectType.TabConfig__c.isAccessible())
         tc = [SELECT ID,Name,StandardTabName__c,BodyColumns__c,RecordTypeId,RecordType.Name,RecordType.DeveloperName,
                                PageBlockOrientation__c,FlexTableCount__c,PageLayoutConfig__c,
                                SortOrder__c,HelpText__c,IsActive__c,HideForUser__c, HeaderInstructionText__c,
                                HideDecisionField__c,HideForContext__c,HideForProfile__c, Operator__c,HideforQueue__c,HideExpressionFields__c,HideExpressionJSON__c,IsOverview__c,TabIcon__c,skipForExport__c
                                FROM TabConfig__c WHERE PageLayoutConfig__c in :layoutIds and IsActive__c = true and IsOverview__c = false WITH USER_MODE order by SortOrder__c asc];
        if(tc.size()>0) {              

            //BulkiFying of Apex Code...ConvertTab
            List<Tab> tabList = convertAsTab(tc);
            for(Tab tab: tabList){
            if(tab.name.equalsIgnoreCase(tabName)){
              //  this.layout.activeTabId = tab.tabId;
            }
            if(tab.active && !tab.isOverview) {
                    this.layout.activeTabSize ++;
            }
            if(isViewLayout || (!isViewLayout )){
               // && tab.flexTableCount == 0
                this.layout.tabs.add(tab);
                this.tabMap.put(tab.tabId, tab);
            }                                            
        }
    } 
    } 
    
    
    /*
        Returns the layout configuration for rest of the tabs of a given layout id
    */
    public void loadOtherTabs(List<string> layoutIds) {
        
        //String tabName = ApexPages.CurrentPage().getParameters().get('tabName'); 
        String tabName = '';   
        List<TabConfig__c> tc = new List<TabConfig__c>();
        if(Schema.sObjectType.TabConfig__c.isAccessible()){
        tc = [SELECT ID,Name,StandardTabName__c,BodyColumns__c,RecordTypeId,RecordType.DeveloperName,RecordType.Name,
                                PageBlockOrientation__c,FlexTableCount__c,PageLayoutConfig__c,
                                SortOrder__c,HelpText__c,IsActive__c,HeaderInstructionText__c,
                                HideForUser__c,HideDecisionField__c,HideForContext__c,HideForProfile__c,
                                Operator__c,HideforQueue__c,HideExpressionFields__c,HideExpressionJSON__c, IsOverview__c,TabIcon__c,skipForExport__c
                                FROM TabConfig__c WHERE PageLayoutConfig__c in :layoutIds and IsActive__c = true WITH USER_MODE order by SortOrder__c asc ];
        }
        //for (integer i=1;i<tc.size();i++) {
        List<Tab> tablist = convertAsTab(tc);
            for(Tab tab: tablist){
            if(tab.name.equalsIgnoreCase(tabName)){
               // this.layout.activeTabId = tab.tabId;
            }
            if(tab.active) {
                this.layout.activeTabSize ++;
            } 
            if(isViewLayout || (!isViewLayout && tab.flexTableCount == 0)){
                this.layout.tabs.add(tab);
                this.tabMap.put(tab.tabId, tab);
            }             
        }
       // }
    }
    
    /*
        Returns the layout configuration for a given layout name
    */  
    public Layout getTabLayoutConfig() {
        return layout;
    }
    
    public List<Layout> getFormLayoutConfig() {
        return formLayoutById.values();
    }
    
    
    /* PRIVATE METHODS */
    /*
        Loads the input page layout configuration from PageLayoutConfig__c 
    */
    public void loadViewLayout() {	
        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible() && Schema.sObjectType.PageLayoutActionConfig__c.isAccessible() && Schema.sObjectType.LayoutBusinessRuleConfig__c.isAccessible()){
        for (PageLayoutConfig__c pl : [SELECT CloseModalOnSave__c,FormTitle__c,PDFRenderType__c,ProgressbarGroupName__c,HeaderOverride__c, HideApprovalDecisionComponentinEdit__c,ID,
                                NAME,ObjectAPIName__c,title__c,RecordCompletionPercentageField__c, HeaderDescription__c,HidePDFDownload__c, IsRecentlyViewed__c, AutoGenerated__c,
                                RefreshAllFlexTables__c,ShowCustomButtonsonFooterForViewLayout__c,HideOnDemandSnaphot__c,windowTitle__c,SaveButtonLabel__c,SnapshotClassification__c,
                                (Select Id, HideDecisionField__c, DisableDecisionField__c, ButtonHelpText__c,Active__C from PageLayoutActions__r where Active__C = true),
                                (select Expression__c,ExpressionJSONFields__c from Layout_Business_Rule_Config__r where Active__c = true) 
                                FROM PageLayoutConfig__c WHERE ID in :layoutIds WITH USER_MODE]) { 
            Layout l = new Layout();
            l.isPrint = pl.AutoGenerated__c;
            l.pdfRenderType = pl.PDFRenderType__c;
            l.layoutId = pl.Id;
            l.name = pl.Name;
            l.ProgressbarGroupName = pl.ProgressbarGroupName__c; // added for c:StepProgressbar
            l.objectName = pl.ObjectAPIName__c;
            l.isEditLayout = false;
            // Bug 75932: Internal - Blank space should not be present at UI layout if we do not set page instruction text
            String strHeaderDescription = String.isNotBlank(pl.HeaderDescription__c) ? pl.HeaderDescription__c.normalizeSpace() : null;
            if(String.isNotBlank(strHeaderDescription)){
                l.headerDescription = strHeaderDescription;
            }
            l.header = pl.title__c;
            l.headerOverride = pl.HeaderOverride__c; 
            //Start User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
            l.headerNew = pl.FormTitle__c;
            //End User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
            l.windowTitle = pl.windowTitle__c;
            if(String.isNotEmpty(l.windowTitle)) {
               if(l.fieldsToQuery == null) {
               		l.fieldsToQuery = new Set<String>();             
               }
               
               l.windowTitle = l.windowTitle.replace('{!mode}','View');
               l.fieldsToQuery.addAll(AppUtils.getMergeFields(l.windowTitle));
               l.fieldsToQuery.addAll(AppUtils.getUserMergeFields(l.windowTitle));
            }                       
            l.hidePDFDownload = pl.HidePDFDownload__c;
            l.hidetakeSnapshot = pl.HideOnDemandSnaphot__c;
            l.RecentlyView = pl.IsRecentlyViewed__c;
           // l.refreshAllFlexTables = pl.RefreshAllFlexTables__c;
            l.onDemandSnapClassification = pl.SnapshotClassification__c;
            l.hideApprovalComponentInEdit = pl.HideApprovalDecisionComponentinEdit__c;
            l.completionPercent = pl.RecordCompletionPercentageField__c != null ? Double.valueOf(pl.RecordCompletionPercentageField__c) : 0;
            if(!isPrint) {
                l.messages = new DynamicMessageHolder(pl.Id,isViewLayout,isInternal,isApplicant,userProfile,recordId);                
            }
            l.closeOnSave = pl.CloseModalOnSave__c;
           // l.ShowCustomButtonsonFooter = pl.ShowCustomButtonsonFooterForViewLayout__c;
            l.pageLayoutActions = pl.PageLayoutActions__r;
            l.pageLayoutBizRuleConfigs = pl.Layout_Business_Rule_Config__r;
            if (pl.Id == layoutId) {
                this.layout = l;
            } else {
                l.formId = pageTemplateById.get(pl.Id).Id;
                l.formParentFieldAPI = pageTemplateById.get(pl.Id).ParentObjectFieldAPI__c;
                this.formLayoutById.put(pl.Id, l);
            }
        } 
    }
    }
    /* 
        Loads the input page layout configuration from PageLayoutConfig__c 
    */
    private void loadEditLayout() {
        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible() && Schema.sObjectType.PageLayoutActionConfig__c.isAccessible() && Schema.sObjectType.LayoutBusinessRuleConfig__c.isAccessible()){
        for (PageLayoutConfig__c pl : [SELECT ID,NAME,FormTitle__c,PDFRenderType__c,ObjectAPIName__c,title__c,HeaderOverride__c,CloseModalOnSave__c,RecordCompletionPercentageField__c,AutoGenerated__c,
                     HeaderDescription__c,ProgressbarGroupName__c, IsActive__C, HideApprovalDecisionComponentinEdit__c, IsRecentlyViewed__c,HideOnDemandSnaphot__c,HidePDFDownload__c,windowTitle__c,CancelButtonLabel__c,SaveButtonLabel__c,
                    (Select Id, HideDecisionField__c,DisableDecisionField__c, Active__C from PageLayoutActions__r where Active__C = true ),
                    (select Expression__c,ExpressionJSONFields__c from Layout_Business_Rule_Config__r where Active__c = true) 
                    FROM PageLayoutConfig__c WHERE ID in :layoutIds AND IsActive__C = true WITH USER_MODE]) {
            //if (pl.Id == layoutId) {    
            Layout l = new Layout();
            l.isPrint = pl.AutoGenerated__c;
            l.layoutId = pl.Id;
            l.name = pl.Name;
            l.objectName = pl.ObjectAPIName__c;
            l.isEditLayout = true;
            l.header = pl.title__c;
            l.headerOverride = pl.HeaderOverride__c;
            //Start User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
            l.headerNew = pl.FormTitle__c;
            //End User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
            l.windowTitle = pl.windowTitle__c;
            if(String.isNotEmpty(l.windowTitle)) {
               if(l.fieldsToQuery == null) {
               		l.fieldsToQuery = new Set<String>();             
               }
               if(String.isNotEmpty(recordId)) {
                  l.windowTitle = l.windowTitle.replace('{!mode}','Edit');
               } else {
                  l.windowTitle = l.windowTitle.replace('{!mode}','Create');
                  l.windowTitle = stripMergeFields(l.windowTitle);
               }
               l.fieldsToQuery.addAll(AppUtils.getMergeFields(l.windowTitle));
               l.fieldsToQuery.addAll(AppUtils.getUserMergeFields(l.windowTitle));
            }
            
           
            l.CancelButtonLabel= pl.CancelButtonLabel__c;
            l.SaveButtonLabel= pl.SaveButtonLabel__c;
            // Bug 75932: Internal - Blank space should not be present at UI layout if we do not set page instruction text
            String strHeaderDescription = String.isNotBlank(pl.HeaderDescription__c) ? pl.HeaderDescription__c.normalizeSpace() : null;
            if(String.isNotBlank(strHeaderDescription)){
                l.headerDescription = strHeaderDescription;
            }
            l.ProgressbarGroupName = pl.ProgressbarGroupName__c; // added for c:StepProgressbar
            l.RecentlyView = pl.IsRecentlyViewed__c;
            l.hidePDFDownload = pl.HidePDFDownload__c;
            l.hidetakeSnapshot = pl.HideOnDemandSnaphot__c;
            //l.externalHeaderDescription = pl.ExternalHeaderDescription__c;
            l.hideApprovalComponentInEdit = pl.HideApprovalDecisionComponentinEdit__c;
            l.completionPercent = pl.RecordCompletionPercentageField__c != null ? Double.valueOf(pl.RecordCompletionPercentageField__c) : 0;
            l.messages = new DynamicMessageHolder(pl.Id,isViewLayout,isInternal,isApplicant,userProfile,recordId);
            l.closeOnSave = pl.CloseModalOnSave__c;
           // l.ShowCustomButtonsonFooter = true;    
            l.pageLayoutActions = pl.PageLayoutActions__r;
            l.pageLayoutBizRuleConfigs = pl.Layout_Business_Rule_Config__r;
            if(pageTemplate.RTALimitConfig__c != null) {
                //l.limitEnforceConfigRTA = new List<String>();
                //l.limitEnforceConfigRTA.addAll(pageTemplate.RTALimitConfig__c.split(';'));
                l.limitEnforceConfigRTA = pageTemplate.RTALimitConfig__c.split(';');
            }
            if(!String.isEmpty(pageTemplate.ToolBarGroups__c)) {
                //l.limitEnforceConfigRTA = new List<String>();
                //l.limitEnforceConfigRTA.addAll(pageTemplate.RTALimitConfig__c.split(';'));
                l.toolBarGroupsConfig =  EncodingUtil.urlEncode(pageTemplate.ToolBarGroups__c, 'UTF-8');

            }else if(!String.isEmpty(KeyValueStoreHelper.getTextValue('CkEditorToolBar', true))){
                //l.toolBarGroupsConfig = KeyValueStoreHelper.getTextValue('CkEditorToolBar', true)
                 List<document> documentList = [select Name,DeveloperName,body,ContentType from document where DeveloperName =: KeyValueStoreHelper.getTextValue('CkEditorToolBar', true) WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                 if(documentList.size() > 0){
                    Blob documentData = documentList[0].body;
                    l.toolBarGroupsConfig =  documentData.toString();   
                 }
                
            }
            
            if(pageTemplate.AllowedCharsForRichTextArea__c != null) {
                l.allowedCharsForRichTextArea = integer.valueOf(pageTemplate.AllowedCharsForRichTextArea__c);
                l.warningCharsForRichTextArea = l.allowedCharsForRichTextArea - 50; 
            }else if(KeyValueStoreHelper.getIntegerValue('TextAreaCharacterMaxLimit', true) != null) {
                l.allowedCharsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaCharacterMaxLimit', true);
                if(KeyValueStoreHelper.getIntegerValue('TextAreaCharacterWarningLimit', true) != null) {
                    l.warningCharsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaCharacterWarningLimit', true);
                }else {
                    l.warningCharsForRichTextArea = l.allowedCharsForRichTextArea - 50;
                }
            }else {
                l.allowedCharsForRichTextArea = 2000;                               
                l.warningCharsForRichTextArea = 1950; 
            }
            
            if(pageTemplate.AllowedWordsForRichTextArea__c != null) {
                l.allowedWordsForRichTextArea = integer.valueOf(pageTemplate.AllowedWordsForRichTextArea__c);
                l.warningWordsForRichTextArea = l.allowedWordsForRichTextArea - 50; 
            }else if(KeyValueStoreHelper.getIntegerValue('TextAreaWordMaxLimit', true) != null) {
                l.allowedWordsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaWordMaxLimit', true);
                if(KeyValueStoreHelper.getIntegerValue('TextAreaWordWarningLimit', true) != null) {
                    l.warningWordsForRichTextArea = KeyValueStoreHelper.getIntegerValue('TextAreaWordWarningLimit', true);
                }else {
                    l.warningWordsForRichTextArea = l.allowedWordsForRichTextArea - 50;
                }
            }else {
                l.allowedWordsForRichTextArea = 1500;
                l.warningWordsForRichTextArea = 1450;
            }   
            this.layout = l;
            //break;
            //}
        }
    }
    }
    
   
    /*
        Loads all tabs from TabConfig__c 
    */ 
    private void loadTab() {
        this.layout.activeTabSize = 0;      
        String tabName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('tabName')); //ApexXSSFromURLParam - False +Ve - We are using custom method for encoding        
        List<TabConfig__c> tcList = new List<TabConfig__c>();
        if(Schema.SObjectType.PageLayoutConfig__c.isAccessible())
        tcList = [SELECT ID,Name,StandardTabName__c,BodyColumns__c,PageBlockOrientation__c,RecordTypeId,RecordType.Name,RecordType.DeveloperName,FlexTableCount__c,
                                PageLayoutConfig__c,SortOrder__c,HelpText__c,IsActive__c,HideForUser__c,HeaderInstructionText__c, 
                                HideDecisionField__c,HideForContext__c,HideExpressionFields__c,HideExpressionJSON__c,HideForProfile__c, Operator__c, IsOverview__c,HideforQueue__c,TabIcon__c,skipForExport__c
                                FROM TabConfig__c WHERE PageLayoutConfig__c in :layoutIds and IsActive__c = true WITH USER_MODE order by SortOrder__c asc];
        for(TabConfig__c tc: tcList){
            if (tc.Name == tabName) {               
                List<TabConfig__c> tabConfigList = new List<TabConfig__c>();
                tabConfigList.add(tc);
                List<Tab> tabList = convertAsTab(tabConfigList);
                for(Tab tab: tabList){
                if(tab.name.equalsIgnoreCase(tabName)){
                   // this.layout.activeTabId= tab.tabId;
                }
                if(isViewLayout || (!isViewLayout)){
                    this.layout.tabs.add(tab);
                    this.tabMap.put(tab.tabId, tab);                       
                }
                if(tab.active && !tab.isOverview) {
                    this.layout.activeTabSize ++;
                }
                }
                break;            
            }
        }
     
   } 
   
    /*
        Loads all tabs from TabConfig__c 
    */
    private void loadTabs() {
        this.layout.activeTabSize = 0;
        String tabName;
        String isPreviewLayout = 'false';
        if(!isMiniLayout){
            //tabName = ApexPages.CurrentPage().getParameters().get('tabName'); 
            //isPreviewLayout  = ApexPages.CurrentPage().getParameters().get('isPreviewLayout');   
        }
        List<TabConfig__c> tcList = new List<TabConfig__c>();
         if(Schema.SObjectType.PageLayoutConfig__c.isAccessible())
         tcList = [SELECT ID,Name,StandardTabName__c,BodyColumns__c,PageBlockOrientation__c,RecordTypeId,RecordType.Name,RecordType.DeveloperName,
                                FlexTableCount__c,PageLayoutConfig__c,SortOrder__c,HelpText__c,IsActive__c, Operator__c,
                                HideForUser__c,HideDecisionField__c,HideForContext__c,HideExpressionFields__c,HideExpressionJSON__c,HideForProfile__c,HeaderInstructionText__c,HideforQueue__c,TabIcon__c, 
                            IsOverview__c,skipForExport__c FROM TabConfig__c WHERE PageLayoutConfig__c in :layoutIds and IsActive__C = true 
                            WITH USER_MODE ORDER BY SortOrder__c asc ];
            //we intentionally don't check for active tab active flag due to current limitation of dynamic component tag

        // Bulkification of Convert Tab....
        for(TabConfig__c tc: tcList){
            List<TabConfig__c> tcValList = new List<TabConfig__c>();
            tcValList.add(tc);
            List<Tab> tabList = convertAsTab(tcValList);
            if(tabList != null && tabList.size() > 0){
                for(Tab tab: tabList){
            this.tabMap.put(tab.tabId, tab);  
            if (tc.PageLayoutConfig__c == this.layoutId) {                  
                if(tab.name.equalsIgnoreCase(tabName)){
                   // this.layout.activeTabId= tab.tabId; 
                }   
                if(isPreviewLayout  != 'true' && String.isEmpty(recordId) && tab.active && !tab.isOverview && (tab.hideTab == 'false' || tab.hideTab == null) ) {
                    this.layout.activeTabSize ++;
                }else if(isPreviewLayout  == 'true' &&  tab.active && !tab.isOverview && (tab.hideTab == 'false' || tab.hideTab == null)) {
                    this.layout.activeTabSize ++;
                }                                                         
                this.layout.tabs.add(tab); 
            } else {
                this.formLayoutById.get(tc.PageLayoutConfig__c).tabs.add(tab);
            } 
        }
            }
        }

    }
    /*
        Loads all page blocks that belong to the input tab RecordTypeName__c 
    */
    private void loadPageBlocks() {
        pageBlockMap = new Map<String, PageBlock>();
        Set<String> headerDescMergeFieldSet = new Set<String>();
        if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
        for (PageBlockConfig__c pbc : [SELECT ID,Name,PageBlockTitle__c,BodyColumns__c,TabColumnSpan__c,
                            IsActive__c,FieldOrientation__c,TabLayoutConfig__c,SortOrder__c,HeaderInstructionText__c,AttachmentClassifications__c,
                            FlexTableName__r.Header__c,HideDisableRowactions__c,HelpText__c,GridHeaderConfig__c,FlexTableName__c,FlexTableName__r.Name,FlexTableName__r.HeaderDescription__c,
                            ChartConfigName__c,ChartConfigName__r.Name,ChartConfigName__r.UniqueName__c, ChartConfigName__r.RecordType.Name,
                            IsApprovalHistoryList__c,IsGrid__c,IsNotesAttachmentsList__c,HideDecisionField__c,IsAttachment__c,
                            HideExpressionJSON__c, HideExpressionFields__c,
                            IsDigitallySigned__c, RecordType.Name,TabLayoutConfig__r.PageLayoutConfig__c,TabLayoutConfig__r.StandardTabName__c,
                            RecordType.DeveloperName,MapClassName__c,HideforUser__c,HideForContext__c,HideForProfile__c, CityFieldAPI__c, 
                            StateFieldAPI__c,CaptchaFieldAPIName__c, StreetFieldAPI__c, CommunicationEmailFieldName__c,
                            FlexGridName__c,FlexGridName__r.Name,FlexGridName__r.ParentFlexTable__r.Header__c,FlexGridName__r.ParentFlexTable__r.Name, Operator__c,HideForQueue__c,SkipForExport__c,WorkspaceHierarchy__c
                            FROM PageBlockConfig__c 
                            WHERE TabLayoutConfig__r.PageLayoutConfig__c in :layoutIds and IsActive__c = true and TabLayoutConfig__r.IsActive__c = true WITH USER_MODE]) {
           
            Tab t = tabMap.get(pbc.TabLayoutConfig__c);
            if (t != null && pbc.IsActive__c == true) {
                    PageBlock pb = new PageBlock();
                    pb.recordTypeName = pbc.RecordType.Name;
                    pb.pageBlockId = pbc.Id;
                    //pb.name = pbc.Name;
                    pb.title = pbc.PageBlockTitle__c;
                    pb.bodyColumnSize = Integer.valueOf(pbc.BodyColumns__c == null ? '2' : pbc.BodyColumns__c); //defaulting to '2' if body colums null to avoid exception
                    pb.picklistStyle = 'max-width: 100% !important;';
                    pb.columnSpan = Integer.valueOf(pbc.TabColumnSpan__c);
                   // pb.fieldOrientation = convertOrientation(pbc.FieldOrientation__c);                  
                    pb.tabId = pbc.TabLayoutConfig__c;
                    pb.sortOrder = pbc.SortOrder__c.intValue();
                    pb.helpText = pbc.HelpText__c;// !=null ? SFDCEncoder.SFDC_JSENCODE(pbc.HelpText__c) : '';
                    pb.flexGridId = pbc.FlexGridName__c;
                    pb.flexGridName = pbc.FlexGridName__r.Name;
                    pb.parentFlextableName = pbc.FlexGridName__r.ParentFlexTable__r.Name;
                    pb.flexTableId = pbc.FlexTableName__c;
                    pb.gridHeaderId = pbc.GridHeaderConfig__c;
                    pb.flexTableName = pbc.FlexTableName__r.Name;
                    pb.chartConfigId = pbc.ChartConfigName__c;
                    pb.chartConfigName = pbc.ChartConfigName__r.Name;
                    pb.chartRecordType = pbc.ChartConfigName__r.RecordType.Name;
                    pb.chartId = pbc.ChartConfigName__r.UniqueName__c;
                    pb.isApprovalHistoryList = pbc.IsApprovalHistoryList__c;                
                    pb.isNotesAttachmentsList = pbc.IsNotesAttachmentsList__c;
                    pb.isAttachment = pbc.IsAttachment__c;
                    pb.captchaFieldAPIName = pbc.CaptchaFieldAPIName__c;
                    pb.isDigitallySigned = pbc.IsDigitallySigned__c;
                    pb.isCollab = pbc.RecordType.DeveloperName == 'Collab';
                    pb.isFormTable = pbc.RecordType.DeveloperName == 'Forms';
                    pb.isCommunicationHistoryTable = pbc.RecordType.DeveloperName == 'Communication';
                    pb.isCollabInfo = pbc.RecordType.DeveloperName == 'Collab_Info';
                    pb.isMapBlock = false;
                    pb.isWBS = false;
                    
                    pb.skipNavTabName = pbc.TabLayoutConfig__r.StandardTabName__c;
                    pb.skipNavFlexTableHeaderName= pbc.FlexTableName__r.Header__c;
                    pb.skipNavFlexGridHeaderName = pbc.FlexGridName__r.ParentFlexTable__r.Header__c;
                    
                    if(!String.isEmpty(pbc.HideforQueue__c)){
                        if(pbc.TabLayoutConfig__r.PageLayoutConfig__c == this.layoutId) {
                            layout.queues.addAll(pbc.HideforQueue__c.split(';'));
                        }
                        pb.queues.addAll(pbc.HideforQueue__c.split(';'));   
                    }
                   // pb.cityFieldAPI = pbc.CityFieldAPI__c;
                   // pb.streetFieldAPI = pbc.StreetFieldAPI__c;
                   // pb.stateFieldAPI = pbc.StateFieldAPI__c;
                    pb.attachmentClassifications = pbc.attachmentClassifications__c;
                    pb.ShowDisableAttachmentActions = pbc.HideDisableRowactions__c;
                    if (pb.ShowDisableAttachmentActions == null) {
                        pb.ShowDisableAttachmentActions = 'Hide';  //default value
                    }

                    if(pbc.RecordType.DeveloperName == 'Map'){
                        pb.isMapBlock = true;
                        pb.mapClassName = pbc.MapClassName__c;
                    }
                    else if(pbc.RecordType.DeveloperName == 'RecordHistory'){
                        pb.isRecordHistory = true;
                    }
                    else if(pbc.RecordType.DeveloperName == 'FieldHistory'){
                        pb.isFieldHistory = true; 
                    }
                    else if(pbc.RecordType.DeveloperName == 'WBS'){
                        pb.isWBS = true; 
                    }else if(pbc.RecordType.Name == 'Form Enhanced'){
                        pb.flexTableId = 'FormEnhancedTable' ;
                        pb.flexTableName = 'FormEnhancedTable';    
                    }
                    pb.hideDecisionField = pbc.HideDecisionField__c;
                    pb.headerInstructionText = pbc.HeaderInstructionText__c;
                    pb.operator = pbc.Operator__c;
                    pb.communicationFieldName = pbc.CommunicationEmailFieldName__c;
                    boolean callAppUtilsMehtod =(String.isNotBlank(pbc.HideForProfile__c) || String.isNotBlank(pbc.HideForContext__c) || String.isNotBlank(pbc.HideForUser__c)) ? true : false;
                    if(String.isNotBlank(pbc.HideExpressionJSON__c)) {
                        pb.hideExpressionJson = pbc.HideExpressionJSON__c;
                        pb.hideExpressionFields = pbc.HideExpressionFields__c;
                    } else if(callAppUtilsMehtod){
                        boolean hideBlock = AppUtils.showHideComponent(isViewLayout,isInternal,isApplicant,pbc.HideForProfile__c,recordId,pbc.HideForContext__c,pbc.HideforUser__c,userProfile, pbc.Operator__c);
                        //if(hideBlock == null){
                        //    hideBlock = false;
                        //}
                        pb.hidePageBlock = hideBlock == null ? '' : String.valueOf(hideBlock);
                    }
                    if(!isPrint) {
                        pb.messages = new DynamicMessageHolder(pbc.Id,isViewLayout,isInternal,isApplicant,userProfile,recordId);
                    }
                    if(pbc.FlexTableName__r.HeaderDescription__c != null){
                        pb.flexHeaderDesc = pbc.FlexTableName__r.HeaderDescription__c; 
                        List<String> mergeFields = AppUtils.getMergeFields(pb.flexHeaderDesc);
                        if(mergeFields.size () > 0){
                            headerDescMergeFieldSet.addAll(mergeFields);
                            pb.headerDescMergeFieldSet.addAll(headerDescMergeFieldSet);                            
                        }
                        
                    }
                    pb.SkipForExport = pbc.SkipForExport__c;
                    pb.WorkspaceHierarchy = pbc.WorkspaceHierarchy__c;
                    pageBlockMap.put(pb.pageBlockId, pb);
                    if (pb.bodyColumnSize == 1){
                    pb.className = 'col-md-12 col-xs-12 col-sm-12';
                    }
                    else if (pb.bodyColumnSize == 2){
                        pb.className = 'col-md-6 col-xs-6 col-sm-6';
                    }
                    else if (pb.bodyColumnSize == 3){
                        pb.className = 'col-md-4 col-xs-6 col-sm-4';
                    }
                    else {
                        pb.className = 'col-md-3 col-xs-6 col-sm-3';
                    }
                    t.pageBlocks.add(pb);
            }               
        }
    }
    }
    
    private void getRelationshipFieldMap(String objectName){      
        //try{
        //String ns = AppUtils.getNamespacePrefix();
        //objectName = objectName.remove(ns);
        if(lookupFieldToObjNameMap.get(objectName) == null ) {
            lookupFieldToObjNameMap.put(objectName, new Map<String, String>());
        }
        SchemaManager.SObjectWrapper sobjType = SchemaManager.getSObject(objectName);

        
        Schema.DescribeSObjectResult dsor = sobjType.fetchObjectResult(objectName);

        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : objectFields.keySet()){
              Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
              // add the results to the map to be returned
              String referenceTo = String.valueOf(dr.getReferenceTo());
              referenceTo = referenceTo.removeStart('(');
              referenceTo = referenceTo.removeEnd(')');
              if(String.isNotEmpty(referenceTo)){
                  lookupFieldToObjNameMap.get(objectName).put(dr.getName().toLowerCase().trim(),referenceTo.toLowerCase());
              } 
          }       
         
        /*}catch(Exception ex){
            
        }*/
    }
    
    /*
        Loads all fields/field sets that belong to a set of page blocks that belong to the input tab
    */
    private void loadFields() {
        
        getRelationshipFieldMap(layout.objectName);
                
        PageBlockDetailConfig__c[] pbds;
        if(Schema.sObjectType.PageBlockDetailConfig__c.isAccessible()){
        pbds = [SELECT ID,NAME,PageBlockConfig__c,AddressFields__c , LatitudeAndLongitude__c,AddressFieldJSON__c, TextAreaRows__c,TextAreaColumns__c,IsActive__c,RecordType.Name,SortOrder__c,
                                            FieldAPIName__c,ObjectAPIName__c,FieldLabelOverride__c,HelpTextLong__c,RequiredForSubmitByRole__c,RequiredByRole__c,RenderCondition__c,
                                            Render_Condition_Property__c,Style__c,IsHiddenField__c,AltRenderingConfig__c,LabelValuePixelRatio__c, IsRichTextArea__c,HelpTextPost__c, ReadOnly__c,
                                            ReadOnlyForProfile__c,ReadOnlyForRole__c,ReadOnlyForContext__c,ReadOnlyForUser__c,ReadDecisionField__c,HideDecisionField__c, AllowedWordsForRichTextArea__c,
                                            FieldAlignment__c,FilterCriteria__c,HideforQueue__c,HideForContext__c,HideForRole__c,HideForProfile__c,SkipForExport__c,HideForUser__c, RequiredBehavior__c,
                                            statictext__c,ScoringFactorFieldName__c, Operator__c,CustomLookupModalHeader__c,PageBlockConfig__r.TabLayoutConfig__r.isOverview__c,
                                            AttachmentClassifications__c,HideLabel__c,FieldLabelOverrideRichText__c,IsCustomLookup__c,HideFieldsJSON__c,DateTimeFormat__c,
                                            HideExpressionJSON__c,HideExpressionFields__c,ReadOnlyExpressionJSON__c,ReadOnlyExpressionFields__c,ShowLinkAsText__c,DisableSelectAll__c
                                            FROM PageBlockDetailConfig__c 
                                            WHERE PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__c in :layoutIds and IsActive__c = true 
                                                and PageBlockConfig__r.IsActive__c=true and PageBlockConfig__r.TabLayoutConfig__r.IsActive__c=true WITH USER_MODE];
        }
        String[] altRenderingNames = new String[0];
        Map<String,string> fieldRelatedObjectName = new Map<String,String>();
        List<String> relatedObjectNames = new List<String>();
        fieldCondMap = new Map<String, Map<String,String>>();
        Set<String> objectAPIs = new Set<String>();
        //User Story 120874: Internal - Need global setting to enable/disable CK Editor
        Boolean disableCkEditor = isCkEditorDisable();
        for (PageBlockDetailConfig__c pbd : pbds) {
            if(String.isEmpty(pbd.RenderCondition__c) != true) {                
                String[] cond= pbd.RenderCondition__c.split('AND');
                Map<String,String> innerMap = new Map<String,String>();
                for(String c : cond) {
                    String[] singleCond = c.split('equals');
                    fieldCondMap.put(singleCond[0].trim(),innerMap);
                    innerMap.put(singleCond[1].trim(),pbd.fieldAPIName__c);
                }                
            }
           
            if(String.isNotBlank(pbd.AltRenderingConfig__c)) {
                altRenderingNames.add(pbd.AltRenderingConfig__c);
            } 
            if(String.isNotBlank(pbd.FieldAPIName__c)){
                string fieldAPIName = pbd.FieldAPIName__c.toLowerCase().trim();
                if(!objectAPIs.Contains(pbd.ObjectAPIName__c)) {
                    objectAPIs.add(pbd.ObjectAPIName__c);
                    getRelationshipFieldMap(pbd.ObjectAPIName__c);
                }
                String referenceObject = lookupFieldToObjNameMap.get(pbd.ObjectAPIName__c).get(fieldAPIName);
                if(String.isNotEmpty(referenceObject)){
                    if(referenceObject.contains(',')){
                        relatedObjectNames.add(referenceObject.split(',')[1].trim());
                        fieldRelatedObjectName.put(pbd.FieldAPIName__c,referenceObject.split(',')[1].trim());
                    }
                    else{
                        relatedObjectNames.add(referenceObject);
                        fieldRelatedObjectName.put(pbd.FieldAPIName__c,referenceObject);
                    }
                }
            }                       
        }
        Map<String,string> headerTextMap = new Map<String,String>();
        Map<String,string> lookupFilterCriteriaMap = new Map<String,String>();
        if(relatedObjectNames.size() >0 ){
            List<SobjectConfig__c> sobjectConfigs = new List<SobjectConfig__c>();
            if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
            sobjectConfigs = [select Name,LookupHeaderText__c,LookupFilterCriteria__c from SobjectConfig__c 
                where Name in: relatedObjectNames WITH USER_MODE];
            }
            for(SobjectConfig__c sobj : sobjectConfigs){
                if(!String.isEmpty(sobj.LookupHeaderText__c))
                headerTextMap.put(sobj.Name.toLowerCase().trim(),sobj.LookupHeaderText__c);
                if(!String.isEmpty(sobj.LookupFilterCriteria__c))
                lookupFilterCriteriaMap.put(sobj.Name.toLowerCase().trim(),sobj.LookupFilterCriteria__c); 
            }
        }
         fieldConditionMap = JSON.serialize(fieldCondMap);
        //Glen: Optimization - should these be reteived on demand instead of cached in a map?
        Map<String, DynamicFieldConfigData__mdt> altMap = new Map<String, DynamicFieldConfigData__mdt>();
        if(altRenderingNames.size() > 0){
            for(DynamicFieldConfigData__mdt rendering : 
                    [SELECT Name__c,DeveloperName, DisplayField__c, ReturnField__c,CheckBoxAlignment__c, SortField__c, Object__c, Type__c, WhereClause__c 
                        FROM DynamicFieldConfigData__mdt WHERE Name__c IN :altRenderingNames WITH USER_MODE]) {
                altMap.put(rendering.DeveloperName, rendering);
            }               
        }
        Integer i=1;
        for (PageBlockDetailConfig__c pbd : pbds) {
            PageBlock pb = pageBlockMap.get(pbd.PageBlockConfig__c);            
                Field f = new Field();
                f.fieldId = pbd.Id;
                f.renderAction = pbd.Render_Condition_Property__c;
                f.skipForExport = pbd.SkipForExport__c;
                f.pageBlockId = pbd.PageBlockConfig__c;
                f.ShowLinkasText = pbd.ShowLinkAsText__c;
                f.hideFieldsJSON = pbd.HideFieldsJSON__c;
                f.fieldType = pbd.RecordType.Name; //use record type id
                f.disableSelectALL = pbd.DisableSelectAll__c;
                f.dateTimeFormat = pbd.DateTimeFormat__c;
                f.isBlankSpace = f.fieldType == 'Blank Space';
                f.isStaticText = f.fieldType == 'Static Text'; 
                f.staticText = f.fieldType == 'Static Text'?pbd.statictext__c : '';    
                f.staticTextMergeFields = new Set<String>();
                if(f.fieldType == 'Static Text') {
                    f.staticTextMergeFields.addAll(AppUtils.getMergeFields(f.staticText));
                   
                }
                if(f.fieldType == 'Google Map Location')
                {
                    
                     f.dataType = 'GOOGLE-MAP';
                     if(String.isNotBlank(pbd.LatitudeAndLongitude__c))
                     {
                        f.addressField = new AddressField(pbd.LatitudeAndLongitude__c,'latLang');
                     }
                     else if(String.isNotBlank(pbd.AddressFieldJSON__c))
                     {                        
                        f.addressField = new AddressField(pbd.AddressFieldJSON__c,'isJSON');                        
                     }
                     else if(String.isNotBlank(pbd.AddressFields__c))
                     {
                        f.addressField = new AddressField(pbd.AddressFields__c,'');
                     }
                     
                     pb.fields.add(f);  
                }
                if(f.fieldType == 'Field Level Attachment') {
                    f.isFieldLevelAttachment = true;
                }
                if(f.isFieldLevelAttachment) {
                    f.attachmentFieldClassification = pbd.AttachmentClassifications__c;
                    //f.helpText = String.isEmpty(pbd.HelpTextLong__c)==false ? SFDCEncoder.SFDC_JSENCODE(pbd.HelpTextLong__c): '';
                    f.helpText = pbd.HelpTextLong__c;
                    if (String.isEmpty(pbd.FieldLabelOverride__c) == false) {  //override field label if necessary
                        f.fieldLabel = pbd.FieldLabelOverride__c;                            
                    }  
                   pb.fields.add(f);                    
                }          
                f.sortOrder = pbd.SortOrder__c.intValue();         
                f.operator = pbd.Operator__c;  
               // f.isHeaderOverview = pbd.PageBlockConfig__r.TabLayoutConfig__r.isOverview__c;
                
                try{
                    Integer.valueOf(pbd.ScoringFactorFieldName__c); 
                }catch(Exception e){
                    f.scoreFieldApiName = pbd.ScoringFactorFieldName__c;
                }
                /*if(f.isHeaderOverview == true){
                    //pb.fields.add(f);
                } */                
                if (f.isBlankSpace == false) {  //field is of type 'Field' or 'Field Set'
                    f.objectAPIName = layout.objectName; //1st level object name
                    if(String.isNotEmpty(pbd.FilterCriteria__c)){
                        f.filterCriteria = pbd.filterCriteria__c;
                        f.filterCriteriaLwc = pbd.filterCriteria__c.replace('=', ':'); 
                    }  
                    else{
                        if(string.isNotEmpty(pbd.FieldAPIName__c)){
                            String objName = fieldRelatedObjectName.get(pbd.FieldAPIName__c);
                            if(String.isNotEmpty(objName)){
                                String filterCriteria = lookupFilterCriteriaMap.get(objName);        
                                if(!String.isEmpty(filterCriteria)){
                                    f.filterCriteria = filterCriteria;   
                                    f.filterCriteriaLwc = filterCriteria.replace('=', ':');    
                                }
                            }    
                        }
                    }
                    /*if(String.isNotEmpty(f.filterCriteria)){    
                        List<String>fieldsToBeQueryList = AppUtils.getMergeFields(f.filterCriteria);
                        fieldsToQuerySet.addAll(fieldsToBeQueryList);
                        layout.fieldsToQuery = fieldsToQuerySet;                
                    }*/
                    if(String.isNotEmpty(pbd.CustomLookupModalHeader__c)){
                        f.customLookupModalHeader = pbd.CustomLookupModalHeader__c;
                    }else if(!String.isEmpty(pbd.FieldAPIName__c) && !String.isEmpty(fieldRelatedObjectName.get(pbd.FieldAPIName__c))){
                        String objectNm = fieldRelatedObjectName.get(pbd.FieldAPIName__c);
                        if(!String.isEMpty(headerTextMap.get(objectNm)) ){
                            f.customLookupModalHeader = headerTextMap.get(objectNm);
                        }else{
                            String temp = pbd.FieldAPIName__c;
                            if(String.isNotEmpty(temp)){
                                //temp = temp.toLowerCase().trim();                       
                                if(fieldRelatedObjectName.get(temp) != null){
                                    String objName = fieldRelatedObjectName.get(temp);
                                    /*if(objName.contains(',')){ //for handling lookup to -->Group,User
                                        List<String>fieldsToInclude = objName.split(',');
                                        if(fieldsToInclude.size() > 0){
                                            objName = fieldsToInclude[1];
                                            objName = objName.removeStart(' ');
                                            objName = 'user';
                                        }
                                    }*/
                                    if(String.isNotEmpty(objName) && objName != null){
                                        objName = objName.trim();
                                        f.customLookupModalHeader = SchemaManager.getSObject(objName).fetchObjectResult(objName).getLabelPlural();
                                    }                           
                                }
                            }
                        }
                    }
                    
                    boolean isReference = false;
                    String fieldName = '';
                    f.fieldAPIName = pbd.FieldAPIName__c;
                    f.isHiddenField = pbd.IsHiddenField__c;
                    if(!f.isHiddenField){
                        boolean callAppUtilsMehtod =(String.isNotBlank(pbd.HideForProfile__c) || String.isNotBlank(pbd.HideForContext__c) || String.isNotBlank(pbd.HideForUser__c)) ? true : false;
                        if(String.isNotBlank(pbd.HideExpressionJSON__c)) {
                            f.hideExpressionJson = pbd.HideExpressionJSON__c;
                            f.hideExpressionFields = pbd.HideExpressionFields__c;
                        } else if(callAppUtilsMehtod){
                            boolean hideField = AppUtils.showHideComponent(isViewLayout,isInternal,isApplicant,pbd.HideForProfile__c,recordId,
                                                pbd.HideForContext__c,pbd.HideForUser__c,userProfile,pbd.HideForRole__c,userRole, pbd.Operator__c);
                            //if(hideField == null){
                            //    hideField = false;
                            //}
                            f.hideField = hideField == null ? '' : String.valueOf(hideField); 
                        }                                                   
                    }
                    if (pbd.TextAreaRows__c != null && pbd.TextAreaRows__c.intValue() > 0) {
                        f.textAreaRows = pbd.TextAreaRows__c.intValue();
                    } else {
                        f.textAreaRows = ( pbd.IsRichTextArea__c ) ? 240 : 5;
                    }
                    if(pbd.IsRichTextArea__c){
                        f.isRichTextAreTrue = true;
                    }
                    if (pbd.TextAreaColumns__c != null && pbd.TextAreaColumns__c.intValue() > 0) {
                        f.textAreaColumns = pbd.TextAreaColumns__c.intValue();
                    } else {
                        f.textAreaColumns = ( pbd.IsRichTextArea__c ) ? 100 : 60;
                    }
                    
                    f.hideDecisionField = pbd.HideDecisionField__c;

                    // User Story 100480: Internal - POC - Add Page Block separator at Page Block Detail level
                    if(f.fieldType =='PageBlockSeparator'){
                        if (!String.isEmpty(pbd.FieldLabelOverride__c)) { 
                            f.fieldLabel = pbd.FieldLabelOverride__c;
                            //User Story 103535: Intrenal - Enhancement - Add help text and layout for Page Block separator
                            f.helpText = String.isNotBlank(pbd.HelpTextLong__c) ?  String.escapeSingleQuotes(pbd.HelpTextLong__c) : pbd.HelpTextLong__c;
                        }
                        pb.fields.add(f);
                    }
                    
                    if (f.fieldType == 'Field' || f.fieldType == 'Captcha') {
                        SchemaManager.Field sf = SchemaManager.getFieldSchemaResult(pbd.ObjectAPIName__c, f.FieldAPIName);   
                        if (fieldNotAllowed(sf)) continue;
                        String altRenderVal = pbd.AltRenderingConfig__c;
                        string altRenderingValFromPageLayout;
                            if(altRenderVal != null && altRenderVal.contains(' ')){
                                altRenderingValFromPageLayout = altRenderVal.replace(' ','_');
                            }else{
                                altRenderingValFromPageLayout = pbd.AltRenderingConfig__c;
                            }
                        
                            if(altMap.containsKey(altRenderingValFromPageLayout)) { 
                                f.altRen = new AlternativeRendering(altMap.get(altRenderingValFromPageLayout));
                        }
                        
                        //Grab the original field label from field definition
                        f.fieldLabel = sf.fieldDesc.getLabel();
                        
                        //Check if the label over ride is defined in custom setting
                        //If yes, use that,if no, check for page block detail level override.
                        
                        
                        if(String.isEmpty(pbd.FieldLabelOverrideRichText__c) == false) {
                            layout.fieldLabelMap.put(f.fieldLabel, pbd.FieldLabelOverrideRichText__c);
                            f.fieldLabel = pbd.FieldLabelOverrideRichText__c;
                        } else if (String.isEmpty(pbd.FieldLabelOverride__c) == false) {  //override field label if necessary
                            layout.fieldLabelMap.put(f.fieldLabel, SFDCEncoder.SFDC_JSINHTMLENCODE(pbd.FieldLabelOverride__c));
                            f.fieldLabel = SFDCEncoder.SFDC_JSINHTMLENCODE(pbd.FieldLabelOverride__c); 
                            if( f.fieldLabel != null && f.fieldLabel.contains('\\')){
                                f.fieldLabel =  f.fieldLabel.replace('\\', '');
                            }   
                        }
                        
                       
                        
                        if(pbd.HideLabel__c == true) {
                            f.fieldLabel = '';
                        }
                        

                        f.relationshipField = convertSchemaManagerField(sf, pbd);        
                        String reqdBehavior = '';
                        if(!String.isEmpty(pbd.RequiredBehavior__c)){
                            reqdBehavior = pbd.RequiredBehavior__c;
                        }
                        String[] requiredByRoles;
                        String[] requiredBySubmitRoles;
                        if(pbd.RequiredByRole__c != null ) {
                            requiredByRoles = (pbd.RequiredByRole__c).split(';');
                        }
                        if(pbd.RequiredForSubmitByRole__c != null ) {
                            requiredBySubmitRoles = (pbd.RequiredForSubmitByRole__c).split(';');
                        }
                        f.requiredForSubmitByRole = pbd.RequiredForSubmitByRole__c;
                        Boolean requiredCheck = null;
                        Boolean requiredBySubmitCheck = null;
                        if(pbd.RequiredByRole__c == null || pbd.RequiredByRole__c == '') {
                            requiredCheck = false;
                        }
                        if(requiredByRoles != null) {
                            if(requiredByRoles.size() > 0) {
                                for(String role : requiredByRoles) {
                                    if(!String.isEmpty(userRole)){
                                        if(userRole.equals(role)) {
                                            requiredCheck = true;
                                        }
                                    }
                                }
                            }
                        }
                        if(requiredBySubmitRoles != null) {
                            if(requiredBySubmitRoles.size() > 0) {
                                for(String role : requiredBySubmitRoles) {
                                    if(!String.isEmpty(userRole)){
                                        if(userRole.equals(role)) {
                                            requiredBySubmitCheck = true;
                                        }
                                    }
                                }
                            }
                        }
                        Boolean saveCheck = false;
                        if(reqdBehavior != 'Required for Save' && pbd.RequiredByRole__c == '') {
                            saveCheck = false;
                        }
                        if(reqdBehavior == 'Required for Save' && (pbd.RequiredByRole__c == '' || pbd.RequiredByRole__c == null)) {
                            saveCheck = true;
                        }
                        if(reqdBehavior == 'Required for Save' && requiredCheck == true) {
                            saveCheck = true;
                        }
                        if(reqdBehavior == 'Required for Save' && requiredCheck == null) {
                            saveCheck = false;
                        }
                        Boolean submitCheck = false;
                        if(reqdBehavior != 'Required for Submit' && pbd.RequiredForSubmitByRole__c == '') {
                            submitCheck = false;
                        }
                        else if(reqdBehavior == 'Required for Submit' && (pbd.RequiredForSubmitByRole__c == '' || pbd.RequiredForSubmitByRole__c == null)) {
                            submitCheck = true;
                        }
                        else if(reqdBehavior == 'Required for Submit' && requiredBySubmitCheck == true) {
                            submitCheck = true;
                        }
                        else if(reqdBehavior == 'Required for Submit' && requiredBySubmitCheck == null) {
                            submitCheck = false;
                        }
                        f.required = saveCheck/*((reqdBehavior == 'Required for Save') ? true : false)*/ || 
                                (sf.fieldDesc.getType() != Schema.DisplayType.Boolean && !sf.fieldDesc.isNillable());
                        f.requiredForSubmit = submitCheck/*((reqdBehavior == 'Required for Submit') ? true : false) */||
                                (sf.fieldDesc.getType() != Schema.DisplayType.Boolean && !sf.fieldDesc.isNillable());

                       // User Story 111623: Internal - Remove required for submit symbol for standard fields which are required from salesforce
                        if(!sf.fieldDesc.isNillable() && sf.fieldDesc.getType() != Schema.DisplayType.Boolean){
                            f.required = true;
                            f.requiredForSubmit = false;
                        }
                        f.dataType = string.valueof(sf.fieldDesc.getType());  
                        if(pbd.IsCustomLookup__c == true) {
                            f.dataType = 'CUSTOM-REFERENCE';
                        }
                        //}     
                        f.decimalScale = sf.fieldDesc.getScale();
                        f.helpText = String.isEmpty(pbd.HelpTextLong__c)==false ? SFDCEncoder.SFDC_JSENCODE(pbd.HelpTextLong__c) : SFDCEncoder.SFDC_JSENCODE(sf.fieldDesc.getInlineHelpText());
                        //f.helpText = String.isEmpty(pbd.HelpTextLong__c)==false ? pbd.HelpTextLong__c : sf.fieldDesc.getInlineHelpText();
                        if(pbd.HelpTextPost__c != null){
                            String recId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
                            List<String> helpTextPostMergeFieldsList = new List<String>();
                            f.helpTextPost = pbd.HelpTextPost__c;                                                                                                   
                            helpTextPostMergeFieldsList = AppUtils.getMergeFields(f.helpTextPost);
                            if(recId!=null){                                                        
                                f.helpTextPostMergeFields = new Set<String>();
                                f.helpTextPostMergeFields.addAll(helpTextPostMergeFieldsList);
                            }else{
                                for(String field : helpTextPostMergeFieldsList){
                                    f.helpTextPost = f.helpTextPost.replace('{!'+field+'}','');
                                }                                    
                            }                            
                        }
                        f.isTextAreaField = sf.fieldDesc.getType() == Schema.DisplayType.TextArea;
                        if(f.isTextAreaField && pbd.IsRichTextArea__c  && !disableCkEditor){
                            f.isRichTextAreaField = true; 
                        }
                        f.boldTextStyleClass = 'bold-text';
                        f.fieldValueStyleClass = 'field-value';
                        if(!String.isEmpty(pbd.HideforQueue__c)){
                            layout.queues.addAll(pbd.HideforQueue__c.split(';'));
                            f.queues.addAll(pbd.HideforQueue__c.split(';'));    
                        }
                        if(pbd.FieldAlignment__c != null){
                            f.fieldAlignment = pbd.FieldAlignment__c ;
                            if(pbd.LabelValuePixelRatio__c != null && pbd.LabelValuePixelRatio__c == '50-45'){
                                f.boldTextStyleClass = 'bold-text-1';
                                f.fieldValueStyleClass = 'field-value-1';
                            }
                        }
                        f.isDateField =  sf.fieldDesc.getType() == Schema.DisplayType.Date; 
                        f.isDateTimeField =  sf.fieldDesc.getType() == Schema.DisplayType.DateTime; 
                        f.isPhoneField =  sf.fieldDesc.getType() == Schema.DisplayType.Phone; //Phone field
                        f.isTimeField = sf.fieldDesc.getType() == Schema.DisplayType.Time;
                        //introdeuce to skip SFDCEncoder.SFDC_HTMLENCODE if formula field contain hyperlink
                        if (sf.fieldDesc.isCalculated() &&  sf.fieldDesc.getCalculatedFormula() != null) {
                           if(sf.fieldDesc.getCalculatedFormula().replace('\n',' ').replace('\r',' ').contains('HYPERLINK')){
                                f.isFormulaHyperlinkField = true;
                           }
                            if(sf.fieldDesc.isHtmlFormatted()){  //B26u98g64 - check if formula contains HTML Tags then set isFormulaContainsHtml to true 
                                f.isFormulaContainsHtml = true;
                            }
                        }  
                        f.isReadOnlyField = pbd.ReadOnly__c;
                        f.hasReadOptions = false;
                         if(!f.isReadOnlyField) {
                            if(String.isNotBlank(pbd.ReadOnlyExpressionJSON__c)) {
                                f.readOnlyExpressionJson = pbd.ReadOnlyExpressionJSON__c;
                                f.readOnlyExpressionFields = pbd.ReadOnlyExpressionFields__c;
                            } else {

                                f.isReadOnlyField = AppUtils.readOnlyOrEditableForComponent(isViewLayout,isInternal,isApplicant,pbd.ReadOnlyForProfile__c,
                                                    recordId,pbd.ReadOnlyForContext__c,pbd.ReadOnlyForUser__c,userProfile,userRole,pbd.ReadOnlyForRole__c);
                                if(pbd.ReadOnlyForProfile__c != null || pbd.ReadOnlyForContext__c != null || pbd.ReadOnlyForUser__c != null || pbd.ReadOnlyForRole__c != null) {
                                    f.hasReadOptions = true;
                                } 
                            }
                        }
                        f.readDecisionField = pbd.ReadDecisionField__c;
                        f.style = String.isEmpty(pbd.Style__c)==false ? pbd.Style__c : '';
                        f.isRelationShipFieldType = false;
                        if(!(layout.isEditLayout )|| !(f.FieldAPIName.contains('.'))){  
                            pb.fields.add(f);
                        } else if((layout.isEditLayout ) && (f.FieldAPIName.contains('.'))) {    
                            // new relationship field
                            //f.fieldAPIName = f.fieldAPIName.replace('__r', '__c');
                             f.isRelationShipFieldType = true;
                             //f.isRelationHeader = true;
                             f.isReadOnlyField = true;
                            pb.fields.add(f);
                        }
                        if(f.isReadOnlyField == true) {
                            f.required = false;
                            f.requiredForSubmit = false;
                        }                       
                        
                    } else if (f.fieldType == 'Field Set') {
                        pb.fields.addAll(convertFieldSetToFields(f, pbd));  
                    }else if(f.fieldType == 'Static Text') {
                        /*if(pbd.FieldAlignment__c != null){
                            f.fieldAlignment = pbd.FieldAlignment__c ;
                        }*/
                        f.style = String.isEmpty(pbd.Style__c)==false ? pbd.Style__c : '';
                        pb.fields.add(f);
                    }
                    if(f.isReadOnlyField == true) {
                        f.required = false;
                        f.requiredForSubmit = false;                       
                    }
                    
                }
                else {
                    if(!(layout.isEditLayout && !String.isEmpty(f.FieldAPIName) && f.FieldAPIName.contains('.'))){
                        pb.fields.add(f);
                    }
                }
                i++;
        }
        
    }
    
    /*
        Bootstrap - Show one or two (max) fields in each row based on pageblock's bodyColumnSize
    */
    private void loadFieldRows() {
        for (PageBlock pb : pageBlockMap.values()) {
            if (pb.bodyColumnSize == 1 /* || pb.fieldOrientation == Orientation.TOP_DOWN */) { /*   UI-Shrawan-10092015 Removed or condition */
                loadOneColumnFields(pb);
            } 
            else if(pb.bodyColumnSize == 2){
                loadTwoColumnFields(pb);
            }              
            else if(pb.bodyColumnSize == 3){
                loadThreeColumnFields(pb);  /* UI-Shrawan-10092015 Added for three column layout */
            }
            else{
                loadFourColumnFields(pb);  /* UI-Shrawan-10232015 Added for three column layout */    
            }              
        }
    }
    
    /*
        METHOD TO LOAD FIELDS IN ONE COLUMN
    */
    private void loadOneColumnFields(PageBlock pb) {
        PageBlockSection pbSection = new PageBlockSection(pb.fields, 'col-md-12 col-xs-12 col-sm-12');
        pb.pbSections.add(pbSection);
    } 
    
    /*
        METHOD TO LOAD 
    */
    private void loadTwoColumnFields(PageBlock pb) {
        
        Integer fieldSize = pb.fields.Size();
        PageBlockSection pbSection = new PageBlockSection();
        pbSection.className = 'col-md-6 col-xs-6 col-sm-6';
        Integer count = 0;
        for(Integer i=0; i < fieldSize ; i++) {
            pbSection.fields.add(pb.fields[i]);
            count++;
            if(count == 2){
                pb.pbSections.add(pbSection);
                pbSection = new PageBlockSection();
                pbSection.className = 'col-md-6 col-xs-6 col-sm-6';
                count = 0;
            }
        } 
        pb.pbSections.add(pbSection);       
    } 
    
    /*
        Shrawan Raina UI-10082015
        METHOD TO LOAD FIELDS IN THREE COLUMN

    */
    private void loadThreeColumnFields(PageBlock pb) {
        
        Integer fieldSize = pb.fields.Size();
        PageBlockSection pbSection = new PageBlockSection();
        pbSection.className = 'col-md-4 col-xs-6 col-sm-4';
        Integer count = 0;
        for(Integer i=0; i < fieldSize ; i++) {
            pbSection.fields.add(pb.fields[i]);
            count++;
            if(count == 3){
                pb.pbSections.add(pbSection);
                pbSection = new PageBlockSection();
                pbSection.className = 'col-md-4 col-xs-6 col-sm-4';
                count = 0;
            }
        } 
        pb.pbSections.add(pbSection);
    } 

    /*
        Shrawan Raina UI-10232015
        METHOD TO LOAD FIELDS IN FOUR COLUMN

    */
    private void loadFourColumnFields(PageBlock pb) {
        
        Integer fieldSize = pb.fields.Size();
        PageBlockSection pbSection = new PageBlockSection();
        pbSection.className = 'col-md-3 col-xs-6 col-sm-3';
        Integer count = 0;
        for(Integer i=0; i < fieldSize ; i++) {
            pbSection.fields.add(pb.fields[i]);
            count++;
            if(count == 4){
                pb.pbSections.add(pbSection);
                pbSection = new PageBlockSection();
                pbSection.className = 'col-md-3 col-xs-6 col-sm-3';
                count = 0;
            }
        } 
        pb.pbSections.add(pbSection);

    }

    //Checks the schema definition to see if the current field can be viewable or editable by the logged in user
    //Returns true if field is not allowed for view/edit by the user.
    private Boolean fieldNotAllowed(SchemaManager.Field sf) {
        return !sf.fieldDesc.isAccessible();
    }
    
    private void sortAll() {
        layout.tabs.sort();
        for (Tab t : tabMap.values()) {
            t.pageBlocks.sort();
            for (PageBlock pb : t.pageBlocks) {
                pb.fields.sort();
            }
        }
    }
    //Converts custom setting as a local complex data type
    private List<Tab> convertAsTab(List<TabConfig__c> tcList) {
        List<Tab> generatedTabList = new List<Tab>();
        if(tcList != null && tcList.size() > 0){
            for(TabConfig__c tc: tcList){
        Tab tab = new Tab();
        tab.tabId = tc.Id;
        tab.name = tc.StandardTabName__c;
        tab.bodyColumnSize = Integer.valueOf(tc.BodyColumns__c);
        tab.pageBlockOrientation = convertOrientation(tc.PageBlockOrientation__c);
        tab.layoutId = tc.PageLayoutConfig__c;
        tab.sortOrder = tc.SortOrder__c.intValue();
        tab.helpText = tc.HelpText__c;
        tab.active = tc.IsActive__c;
        tab.requiredFieldForSubmit = false;
        tab.requiredFieldForSave = false;
        //tab.hideFor = tc.HideForUser__c;
        //tab.hideContext = tc.HideForContext__c;
        tab.flexTableCount = (Integer)tc.FlexTableCount__c;
        tab.hideDecisionField = tc.HideDecisionField__c;
        boolean callAppUtilsMehtod =(String.isNotBlank(tc.HideForProfile__c) || String.isNotBlank(tc.HideForContext__c) || String.isNotBlank(tc.HideForUser__c)) ? true : false;
        if(tc.HideExpressionJSON__c != null){
            tab.hideExpressionJson = tc.HideExpressionJSON__c;
             tab.hideExpressionFields = tc.HideExpressionFields__c;
        }else if(callAppUtilsMehtod){
            boolean hideTabVal = AppUtils.showHideComponent(isViewLayout,isInternal,isApplicant,tc.HideForProfile__c, recordId, tc.HideForContext__c, tc.HideForUser__c,userProfile, tc.Operator__c);
            tab.hideTab = hideTabVal != null?String.valueOf(hideTabVal):null; 
        }
        tab.headerInstructionText = tc.HeaderInstructionText__c;
        if(!String.isEmpty(tc.HideforQueue__c)){
            layout.queues.addAll(tc.HideforQueue__c.split(';'));    
            tab.queues.addAll(tc.HideforQueue__c.split(';'));
        }
        tab.operator = tc.Operator__c;
        tab.isOverview = (tc.isOverview__c == null || tc.isOverview__c == false) ? false : true;
        tab.isForm = tc.RecordType.DeveloperName == 'Form';
        tab.isCollab = tc.RecordType.DeveloperName == 'Collab';
        tab.isHistory = tc.RecordType.DeveloperName == 'History';
        tab.icon = tc.TabIcon__c;
        tab.skipForExport = tc.skipForExport__c;
                generatedTabList.add(tab);
            }
        }
        return generatedTabList;
    }   
    
    //Converts a field which is represented in Schema manager into page layout field
    private Field convertSchemaManagerField(SchemaManager.Field schemaField, PageBlockDetailConfig__c pbd) {
        if (schemaField.isRelationshipField == false) return null;
        
        Field f = new Field();
        f.fieldAPIName = schemaField.fieldName;
        f.objectAPIName = schemaField.objectName;
      //  f.objectType = schemaField.objectType;
        String reqdBehavior = '';
        if(!String.isEmpty(pbd.RequiredBehavior__c)){
            reqdBehavior = pbd.RequiredBehavior__c;
        }
        f.required = reqdBehavior == 'Required for Save' || !schemaField.fieldDesc.isNillable();
        return f;
    }
    private List<Field> convertFieldSetToFields(Field layoutField, PageBlockDetailConfig__c pbd) {
        List<Field> fields = new List<Field>();
        SchemaManager.Field  schemaField = SchemaManager.getSObjectFieldSet(layoutField.objectAPIName, layoutField.fieldAPIName);
        Integer j=1;
        String relationshipName = getRelationshipName(layoutField.fieldAPIName);
        for (FieldSetMember fsm : schemaField.fieldSetDesc.getFields()) {
            Logger.debug('fsm: ' + fsm);

            Field fieldMember = layoutField.clone();
            fieldMember.fieldAPIName = relationshipName + fsm.getFieldPath();

            SchemaManager.Field sf = SchemaManager.getFieldSchemaResult(layoutField.objectAPIName, fieldMember.fieldAPIName);
            if (fieldNotAllowed(sf)) continue;

            fieldMember.fieldLabel = fsm.getLabel();
            fieldMember.fieldType = 'Field';
            fieldMember.sortOrder2 = j++;  //second level of sorting
            fieldMember.required = fsm.getDBRequired() || fsm.getRequired();
            
            fieldMember.helpText = sf.fieldDesc.getInlineHelpText();
            fieldMember.relationshipField = convertSchemaManagerField(sf, pbd);
            fieldMember.isTextAreaField = sf.fieldDesc.getType() == Schema.DisplayType.TextArea;
            fieldMember.isHiddenField = sf.fieldDesc.getType() == Schema.Displaytype.Boolean;            
            
            fields.add(fieldMember);
        }
        return fields;  
    }
    
    private String getRelationshipName(String fieldName) {
        Integer i = fieldName.lastIndexOf('.');
        if (i == -1) return '';
        String relName = fieldName.substring(0, i+1);        
        return relName;
    }
    
    private static Orientation convertOrientation(String orientationType) {
        //return orientationType == 'Left-Right' ? Orientation.LEFT_RIGHT : Orientation.TOP_DOWN; 
        return Orientation.TOP_DOWN;    //UI-Shrawan-11042015   removed Left-Right orientation
    }
    
     private string stripMergeFields(String originString) {
        String replacedString = originString;
        if(String.isNotEmpty(replacedString)) {
            Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
            Matcher regexMatcher = regex.matcher(replacedString);        
            
            while (regexMatcher.find()){//SOQL/SOSL Injection False +ve         
                String fieldName = regexMatcher.group();
                replacedString = replacedString.replace(fieldName, '');                                      
            }
        }
        
        return replacedString;
    }
    
    /* INNER CLASSES */
      
    /*
        Represents a single layout. Contains list of active tabs
        in the proper sequence as listed on custom setting. 
    */
    global with sharing class Layout {
        //commented variable are not in use
        global transient String layoutId {get; set;}
        global String name {get; set;} // use while submiting a record for approval
        global Boolean isEditLayout {get; set;}  // Cannot make transient required for save behaviour
        global String objectName {get; set;} // includes namespace Cannot make transient required for save behaviour
        global List<Tab> tabs {get; set;}
        global transient String header {get;set;}
        global transient String headerOverride {get;set;}
        //Start User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
        global transient String headerNew{get; set;}
        //End User Story 165576: OSPI - Enhancement - Forms (old and enhanced) and Packages : Form Preview Title should be configurable
        global transient Double completionPercent {get;set;}
        global transient DynamicMessageHolder messages {get;set;}
        global transient String headerDescription {get;set;}
        global transient String pdfRenderType {get;set;}
        global transient String externalHeaderDescription {get;set;}
        global transient Boolean hidePDFDownload {get;set;}
        global transient Boolean hideTakeSnapshot{get;set;}
        global transient string  activeTabId {get;set;}
        global Set<String> queues = new Set<String>();
        global transient boolean hideApprovalComponentInEdit {get;set;}
        global transient boolean ShowCustomButtonsonFooter {get;set;}
        global transient Integer activeTabSize {get;set;}
        global Boolean refreshAllFlexTables {get;set;}
        global Boolean closeOnSave {get;set;}
        global transient String ProgressbarGroupName {get;set;} //added for c:StepProgressbar
        global transient String ViewlayoutMode {get;set;}
        global transient String EditlayoutMode {get;set;}
        public transient String CancelButtonLabel {get;set;}
        public transient String SaveButtonLabel {get;set;}
        public transient Integer allowedCharsForRichTextArea {get;set;}
        public transient Integer warningCharsForRichTextArea {get;set;}
        public transient Integer allowedWordsForRichTextArea {get;set;}
        public transient Integer warningWordsForRichTextArea {get;set;}
        public transient String[] limitEnforceConfigRTA {get;set;}
        public transient String toolBarGroupsConfig {get;set;}
        public transient String onDemandSnapClassification {get;set;}
        global transient Set<String> fieldsToQuery;
        public transient String formId;
        public transient String formParentFieldAPI;
        public transient Boolean RecentlyView;                
        public transient String windowTitle {get;set;}
        public transient Boolean isPrint {get;set;}    
         
        public transient List<PageLayoutActionConfig__c> pageLayoutActions = new List<PageLayoutActionConfig__c>();
        public transient List<LayoutBusinessRuleConfig__c> pageLayoutBizRuleConfigs = new List<LayoutBusinessRuleConfig__c>();
        public Map<String, String> fieldLabelMap = new Map<String, String>();
        global Layout() {
            this.tabs = new List<Tab>();
            this.activeTabSize = 0;            
        }   
    }
    
    /*
        Represents a single tab in a page layout. Contains list of active 
        page blocks in the proper sequence as listed on custom setting.
    */
    public with sharing class Tab implements Comparable {
        //User Story 106073: Flexwind - Provide a visual indicator on the tabs that have required actions - Part 2
        public boolean requiredFieldForSubmit {get;set;}
        //User Story 114651: Internal - Show Visual Indicator for required for save fields
        public boolean requiredFieldForSave {get;set;}
        public String layoutId;
        public String tabId {get; set;}
        public String name {get; set;}
        public String icon {get; set;}
        public Integer bodyColumnSize {get; set;}
        public Orientation pageBlockOrientation {get; set;}
        public Integer flexTableCount {get;set;}
        public transient Integer sortOrder;
        public List<PageBlock> pageBlocks {get; set;}
        public String helpText {get; set;}
        public transient List<String> queues {get;set;}
        public Boolean active {get; set;}
        public String hideTab {get;set;}
        // public transient String hideFor {get;set;}   not in  use
        // public transient String hideContext {get;set;}   not in use
        public String hideDecisionField {get;set;}
        public String hideExpressionJson {get;set;}
        public String hideExpressionFields {get;set;}
        public String headerInstructionText {get; set;}
        public String operator {get; set;}
        public Boolean isHistory {get; set;}
        public Boolean isCollab {get; set;}
        public Boolean isAttachment {get; set;}
        public Boolean isForm {get; set;}
        public boolean isOverview {get;set;}    //UI-Shrawan-10232015   Added for Header overview
        public transient Boolean skipForExport{get;set;}
        public Integer getPageBlockCount() {
            /*if(pageBlocks != null) {
                return pageBlocks.size();
            }
            return 0;*/

            if(pageBlocks != null) {
                Integer totalActivePageBLocks = 0;
                for (PageLayoutConfigHelper.PageBlock block : pageBlocks) {
                    if (block.isHiddenPageBlock || block.hidePageBlock == 'true') continue;
                    totalActivePageBLocks++;
                }
                return totalActivePageBLocks;
            }
            return 0;

        }
//User Story 99487: Flexwind - Provide a visual indicator on the tabs that have required actions
          public Integer getRequiredFieldCount(){
            if(pageBlocks != null) {
                Integer countOfRequiredField = 0;
                for (PageLayoutConfigHelper.PageBlock block : pageBlocks) {
                    for(PageLayoutConfigHelper.Field objFields : block.fields){
                        if(objFields.required == true) 
                            countOfRequiredField ++;
                    }
                }
                return countOfRequiredField;
            }
            return 0;
        }
       
       // public String tabIcon {get;set;}
        public Tab() {
            this.pageBlocks = new List<PageBlock>();
            this.queues = new List<String>();
            this.active = false;
        }

        public Integer compareTo(Object compareTo) {
            Tab t = (Tab) compareTo;
            return sortOrder - t.sortOrder;
        }
        
        public List<List<PageBlock>> getFormattedPageBlocks() {
            List<List<PageBlock>> result = new List<List<PageBlock>>();
            Integer i=0;
            while (true) {
                List<PageBlock> innerList = new List<PageBlock>();
                for (Integer j=0; j<bodyColumnSize; j++) {
                    if (i == pageBlocks.size()) break;
                    PageBlock pb = pageBlocks.get(i);
                   // pb.cellWidth = (bodyColumnSize == 2 && pb.columnSpan == 1) ? '50%' : '100%';
                    innerList.add(pb);
                    i++;
                    if (pb.columnSpan == 2) break;
                    if (i == pageBlocks.size()) break;      
                }
                if (innerList.size() > 0) {
                    result.add(innerList);
                }
                if (i == pageBlocks.size()) break;
            }
            return result;
        }
    }
    
    /*
        Represents a single page block in a tab. Contains list of active
        fields in the proper sequence as listed on custom setting.
    */
    public with sharing class PageBlock implements Comparable {
        public transient String tabId;
        public String pageBlockId {get; set;} //used when submit a record for approval
        //public String name; //not in use
        public String title {get; set;}
        public transient Integer bodyColumnSize {get; set;}
        public transient Integer columnSpan {get; set;}
        // public transient Orientation fieldOrientation {get; set;}   not in use      
        public transient Integer sortOrder {get; set;}
        public List<Field> fields {get; set;}
        public transient List<String> queues {get;set;}
        public List<PageBlockSection> pbSections {get; set;}
        public transient String helpText {get; set;}
       // public transient String cellWidth {get; set;} not in use
        public transient String flexGridId {get;set;}
        public transient String flexGridName{get;set;}
        public transient String parentFlexTableName{get;set;}
        public transient String flexTableId {get;set;}
        public String gridHeaderId {get;set;} // can't make transient required for save behaviour
        public transient String flexTableName {get;set;}
        public transient String chartConfigName {get;set;}
        public String chartConfigId {get;set;} // can't make transient required for save behaviour
        public transient String chartId {get;set;}  
        public transient String chartRecordType {get;set;}
        public transient String captchaFieldAPIName {get;set;}
        public transient String flexHeaderDesc {get; set;}
        // below non-transient variables can't make transient required for save behaviour
        public boolean isApprovalHistoryList {get;set;} 
        public boolean isNotesAttachmentsList {get;set;} 
        public boolean isAttachment {get; set;} 
        public boolean isDigitallySigned {get; set;} 
        public boolean isCollab {get;set;} 
        public boolean isCollabInfo {get;set;} 
    
        public transient boolean isFormTable {get; set;}
        public transient boolean isCommunicationHistoryTable{get;set;}
        public boolean isWBS {get; set;} // can't make transient required for save behaviour
        //public boolean isPackagesTable {get; set;}
        public boolean isMapBlock {get;set;} // can't make transient required for save behaviour
        public transient string picklistStyle {get;set;}
        public transient String mapClassName {get;set;}
        public transient String hideDecisionField {get;set;}
        public transient String hideExpressionJson {get;set;}
        public transient String hideExpressionFields {get;set;}
        public string hidePageBlock {get;set;}  //Cant't make transient used in save

        //below commented fields are not in use
       // public transient string cityFieldAPI {get;set;}
       // public transient string streetFieldAPI {get;set;}
       // public transient string stateFieldAPI {get;set;}
       // public transient boolean isReadOnlyPageBlock {get;set;}
       
        public boolean isHiddenPageBlock {get;set;} //Cant't make transient used in save
        public transient String headerInstructionText {get; set;}
        public transient string attachmentClassifications {get;set;}
        public transient string ShowDisableAttachmentActions {get;set;}
        public boolean isRecordHistory {get;set;} // can't make transient required for save behaviour
        public transient boolean isFieldHistory {get; set;}
        public transient String operator {get; set;}
        public transient String communicationFieldName {get; set;}
        public String skipNavTabName {get; set;}        // for 508 skip tab navigation can't make trasnient used while submiting a record for approval
        public transient String skipNavFlexTableHeaderName {get; set;}
        public transient String skipNavFlexGridHeaderName {get; set;}
        public transient Boolean skipForExport{get;set;} 
        
        public String recordTypeName {get; set;}  //can't make transient used in save 
        public transient Set<String> headerDescMergeFieldSet {get; set;}
        public transient String WorkspaceHierarchy {get; set;}
        public String className {get;set;}
        public DynamicMessageHolder messages {get;set;}
        
        public PageBlock() {
            this.fields = new List<Field>();
            this.pbSections = new List<PageBlockSection>();
           // this.cellWidth = '100%';
           // this.isReadOnlyPageBlock = false;
            this.queues = new List<String>();
            this.isHiddenPageBlock = false;
            this.isRecordHistory = false;
            this.headerDescMergeFieldSet = new Set<String>();
            this.isFieldHistory = false;
            this.isFormTable = false;
            this.className = className;
        }
        
        public Integer compareTo(Object compareTo) {
            PageBlock t = (PageBlock) compareTo;
            return sortOrder - t.sortOrder;
        }
    }
    
    /*
        Represents a single active field in a page block as listed
        in custom setting.
    */
    public with sharing class Field implements Comparable {
      //below commented fields are not in use also below non-transient variable can't make transient used in required for save

        public transient String pageBlockId;
        public transient String fieldId {get;set;}
      //public transient boolean isHeaderOverview{get;set;}
     // public transient boolean isRelationHeader{get;set;}
        public String fieldAPIName;  
        public String fieldLabel {get; set;} 
        public transient String requiredForSubmitByRole {get;set;}
      //public transient String fieldSubLabel {get; set;}
        public Boolean isBlankSpace {get; set;} 
        public transient Boolean skipForExport {get;set;}
        public transient Integer sortOrder {get; set;}
        public transient Integer sortOrder2;
        public String fieldType {get;set;} 
		//Removed Transient keyword Task 100649: LAHSA - Issue with hidden fields on Edit layout
        public  String hideFieldsJSON {get;set;}
        public String dataType {get; set;} 
        public transient String datetimeFormat;
        public transient List<String> queues {get;set;}
        public transient Integer decimalScale {get;set;} 
        public String objectAPIName {get; set;} 
        public Boolean isRelationshipFieldType {get; set;}  
        public transient List<String> referenceNames {get; set;}
      //public transient Integer referenceLevel {get; set;}
        public Boolean required {get; set;}  
        public Boolean requiredForSubmit {get;set;} 
        public String helpText {get; set;}
        public transient String style {get; set;}
        public Integer textAreaRows {get; set;}
        public Integer textAreaColumns {get; set;}  
        public Boolean isTextAreaField {get; set;} //cannot make transient used in while saving of required fields only for data type text area
        public Boolean isHiddenField {get; set;} 
        public transient String hideDecisionField {get;set;}
        public transient String hideExpressionJson {get;set;}
        public transient String hideExpressionFields {get;set;}
        public transient String readOnlyExpressionJson {get;set;}
        public transient String readOnlyExpressionFields {get;set;}
        public transient String readDecisionField {get;set;}
        public transient boolean isRelationShipFieldEmpty {get;set;}
        //public transient string referenceName {get;set;}
        public AlternativeRendering altRen {get; set;} //rendering for checkboxes, radiobuttons, etc
        //The following is applicable only if the fieldAPIName refers to a relationship field (eg: Campaign__r.Finance_Lead__r.Email)
        public Field relationshipField {get; set;}  
        public Boolean isDateField {get; set;}  
        public Boolean isPhoneField {get; set;}  
        public Boolean isDateTimeField {get; set;} 
        public Boolean isTimeField {get; set;}  
        public Boolean isRichTextAreaField {get;set;} 
        public Boolean isReadOnlyField {get; set;}  
        public Boolean ShowLinkasText {get; set;} // used when we submitted a record for appproval
        public String fieldAlignment{get;set;} //cannot make transient used in rich text area field
        public string hideField {get;set;} 
      //  public transient string readField {get;set;}
        public boolean isStaticText {get;set;}
        public string staticText {get;set;} 
        public transient Set<String> staticTextMergeFields;
        /*public Integer allowedWordsForRichTextArea{get;set;}
        public Integer warningWordsForRichTextArea{get;set;}
        public Integer allowedCharsForRichTextArea{get;set;}
        public Integer warningCharsForRichTextArea{get;set;}*/
        public transient string scoreFieldApiName {get;set;}
        public String helpTextPost {get;set;}
        public transient Set<String> helpTextPostMergeFields;
        public transient Map<String,Object> dynamicFieldRender {get;set;}
       // public transient String mapFieldAPIValue {get;set;} // Not used anywhere
        public transient Boolean sourceHandler {get;set;}
        public transient String renderAction {get;set;}
        public String boldTextStyleClass {get;set;} 
        public String fieldValueStyleClass {get;set;}
        public transient String operator {get; set;}
        public transient Boolean hasReadOptions {get; set;}
        public transient string filterCriteria {get;set;}
        public transient string filterCriteriaLwc {get;set;}
        public transient String customLookupModalHeader{get;set;}
      //public transient String pluralNameOfLookupObject{get;set;}
        public Boolean isFieldLevelAttachment{get;set;} 
        public transient String attachmentFieldClassification{get;set;}
        public addressField addressfield{get;set;} // used when we submitted a record for appproval
        public Boolean isFormulaHyperlinkField {get;set;}
        public Boolean isFormulaContainsHtml {get;set;} //B26u98g64 -added new var 
        public Boolean disableSelectALL {get;set;}
        public Boolean isRichTextAreTrue{get; set;}
        public Field() {
            this.isRichTextAreTrue = false;
            this.sortOrder = -1;
            this.sortOrder2 = -1;
            this.fieldLabel = '';
            this.decimalScale  = 0;
            this.requiredForSubmitByRole = '';
            this.required = false;
            this.requiredForSubmit = false;
            this.isRelationShipFieldEmpty = false;
            this.isTextAreaField = false;
            this.isHiddenField = false;
            this.hideDecisionField = '';
            this.readDecisionField ='';
            this.dataType = '';
            this.style = '';
            this.queues = new List<String>();
            this.skipForExport = false;
            this.isDateField  = false;
            this.isPhoneField  = false;
            this.isDateTimeField = false;
            this.isTimeField = false;
            this.isRichTextAreaField = false;
            this.isRelationShipFieldEmpty = false;
            this.isReadOnlyField = false;            
            this.textAreaRows = textAreaRows; // Can change
            this.disableSelectALL = false;
           // this.referenceLevel = 0;
            this.referenceNames = new List<String>();
            this.isFieldLevelAttachment = false;
            this.dynamicFieldRender = new Map<String,Object>();            
            //this.mapFieldAPIValue = JSON.serialize(dynamicFieldRender); 
            this.filterCriteria ='';
            this.sourceHandler = false;           
            this.isFormulaHyperlinkField = false;        
            this.isFormulaContainsHtml = false;      //B26u98g64 - defalut value false 
            if(this.dynamicFieldRender.size() > 0) {
                this.sourceHandler = true;
            }
            this.renderAction = '';
            if (textAreaRows == null || textAreaRows < 1) {
                textAreaRows = 4;
            }
            this.textAreaColumns = textAreaColumns;//Can be moved to constructor
            if (textAreaColumns == null || textAreaColumns < 1) {
                textAreaColumns = 150;
            }
            this.fieldAlignment = 'Horizontal';
            this.helpTextPost = '';
            this.boldTextStyleClass = 'bold-text';
            this.fieldValueStyleClass = 'field-value';
            this.addressfield = new addressfield(); //intialise
        }
        public String getFieldAPIName() {
            return this.fieldAPIName;
        }
        public void setFieldAPIName(String fieldAPIName) {
            this.fieldAPIName = fieldAPIName;
            this.isRelationshipFieldType = false;
            if (fieldAPIName != null) {
                isRelationshipFieldType = fieldAPIName.contains('.');
            }
        }
        public Integer compareTo(Object compareTo) {
            Field t = (Field) compareTo;
            if (sortOrder == t.sortOrder) {
                 return sortOrder2 - t.sortOrder2;
            }
            else {
                //Glen: Is this correct? The sortOrder == t.sortOrder case is not handled. If it is add a comment explaining why since this looks like a bug. 
                return (sortOrder > t.sortOrder ? 1 : -1);
            } 
        }
        public Boolean isRelationshipField() {
                 if(!String.isEmpty(fieldAPIName)){
                    return fieldAPIName.contains('.');
                 }
                 return false;
        }
        
        public String getFieldExpression() {
            String expression = null;
            if (isRelationshipField()) {
                expression = '{!recordMap[\'' + relationshipField.objectAPIName + '\'].' + relationshipField.fieldAPIName + '}';
            }
            else {
                expression = '{!recordMap[\'' + objectAPIName + '\'].' + fieldAPIName + '}'; 
            }            
            return expression;
        }  
        
        public String getAdjustedFieldAPIName() {
            return isRelationshipField() ? relationshipField.fieldAPIName : fieldAPIName;
        }  
        public String getAdjustedObjectAPIName() {
            return isRelationshipField() ? relationshipField.objectAPIName : objectAPIName;
        }
    }
    
    
    public with sharing class AddressField{
        public transient String StreetField { set; get; }
        public transient String CityField { set; get; }
        public transient String StateField { set; get; }
        public transient String ZipCodeField { set; get; }
        public transient String CountryField { set; get; }
        public transient String LatitudeField { set; get; }
        public transient String LongitudeField { set; get; }
        
        public AddressField(){}
        
        public AddressField(String fieldNames, String fieldType )
        {
            if(String.isNotBlank(fieldNames))
            {
                if(fieldType == 'latLang')
                {
                    String[] LatLangFields = fieldNames.split(',');
                    if(LatLangFields != null && LatLangFields.size() == 2)
                    {
                        this.LatitudeField = LatLangFields[0];
                        this.LongitudeField = LatLangFields[1];
                    }
                }
                else if(fieldType == 'isJSON'){
                      String jsonFields = System.JSON.serialize(fieldNames);  
                       
                        AddressField AddresDetails = (AddressField)JSON.deserialize(fieldNames, AddressField.class);  //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
                                              
                        if(AddresDetails!=null){                        
                           this.StreetField =  AddresDetails.StreetField;
                           this.CityField = AddresDetails.CityField;
                           this.StateField = AddresDetails.StateField;
                           this.ZipCodeField = AddresDetails.ZipCodeField;
                           this.CountryField = AddresDetails.CountryField;                           
                        }
                }
                else
                {
                    String[] AddressFields = fieldNames.split(',');
                    if(AddressFields != null && AddressFields.size() == 5)
                    {
                        this.StreetField = AddressFields[0];
                        this.CityField = AddressFields[1];
                        this.StateField = AddressFields[2];
                        this.ZipCodeField = AddressFields[3];
                        this.CountryField = AddressFields[4];
                    }
                     
                }
            }
        }
        
    }
    
    
    /*
        Class to hold the data for the left or right column in a pageblock 
    */
    public with sharing class PageBlockSection {
        public List<Field> fields {get;set;}
        public String className {get;set;} //cannot make transient used in save behaviour
        
        public PageBlockSection(){
            this.fields = new List<Field>();
        }
        
        public PageBlockSection(List<Field> fields, String className){
            this.fields = fields;
            this.className = className;
        }
    }
    
    /*
        Represents an alternative rendering for a field.
        We use this to specify when to us custom controls that salesforce 
        doesn't provide such as a checkbox group or radio buttons
    */
    global with sharing class AlternativeRendering {
        protected DynamicFieldConfig__c altRenConfig;   
        protected DynamicFieldConfigData__mdt altRen;
        global String typex {
            get {                
                return altRen.Type__c;
            }
        }
        global String autoCompleteSobject {
            get {                 
                return altRen.Object__c;
            }
        }
        global String checkBoxAlignment{get; set;}
        global Map<String, String> dbValueMap {get; set;} //dbValue -> displayValue
        global SelectOption[] displayValues {get; private set;}
        global Map<Object,Object> selectMap = new Map<Object,Object>();
        global Map<String,String> sortValueMap = new Map<String,String>();
        
         global AlternativeRendering(DynamicFieldConfig__c cs) {
            checkBoxAlignment = cs.CheckBoxAlignment__c;
            altRenConfig = cs;
            if(dynamicConfigMapByName.get(cs.Name) == null) {
                loadSelectOptions();
                dynamicConfigMapByName.put(cs.Name,this);
            } else {
                AlternativeRendering altRenConfig = dynamicConfigMapByName.get(cs.Name);
                this.dbValueMap = altRenConfig.dbValueMap;
                this.displayValues = altRenConfig.displayValues;
                this.selectMap = altRenConfig.selectMap;   
                this.sortValueMap = altRenConfig.sortValueMap;   
            }
        }
        
        global AlternativeRendering(DynamicFieldConfigData__mdt cs) {
            checkBoxAlignment = cs.CheckBoxAlignment__c;
            altRen = cs;
            if(dynamicConfigMapByName.get(cs.name__c ) == null) {
                loadSelectOptions();
                dynamicConfigMapByName.put(cs.name__c ,this);
            } else {
                AlternativeRendering altRend = dynamicConfigMapByName.get(cs.name__c);
                this.dbValueMap = altRend.dbValueMap;
                this.displayValues = altRend.displayValues;
                this.selectMap = altRend.selectMap;   
                this.sortValueMap = altRend.sortValueMap; 
            }
        }
        
        private void loadSelectOptions() {
            dbValueMap = new Map<String, String>();
            SoqlBuilder2 builder = new SoqlBuilder2()
                            .selectx(string.valueOf(altRen.ReturnField__c))
                            .selectx(string.valueOf(altRen.DisplayField__c))
                            .fromx(string.valueOf(altRen.Object__c));
            if(String.isNotBlank(altRen.SortField__c)) { //if there is a sort field
                builder.selectx(string.valueOf(altRen.SortField__c));
            }
            String soql = builder.toSoql();
            if(String.isNotBlank(altRen.WhereClause__c)) {
                soql += ' WHERE '+ AppUtils.parseWhereClause(altRen.WhereClause__c); //SOQL Injection - False +ve - escapeSingleQuotes Applied on whereClause values using  AppUtils.parseWhereClause method to prevent SOQL injection
            }
            if(String.isNotBlank(altRen.SortField__c)) { //if there is a sort field
                soql += ' Order By '+ string.escapeSingleQuotes(altRen.SortField__c);
            }
            SortableSelectOption[] optionsSort = new SortableSelectOption[0];
            SelectOption[] options = new SelectOption[0];
            try {
                for(sObject sobj : Database.query(soql,AccessLevel.USER_MODE)) {//SOQL Injection - False +ve - Dynamic parts of the query String is escapeSingleQuotes and filterClause value are also escapeSingleQuotes in AppUtils.parseWhereClause method to prevent SOQL Injection
                    String returnValue = String.valueOf(sobj.get(altRen.ReturnField__c));
                    String displayValue = String.valueOf(sobj.get(altRen.DisplayField__c));
                    selectMap.put(returnValue, displayValue);
                    dbValueMap.put(returnValue, displayValue);
                    SelectOption option = new SelectOption(returnValue, displayValue);
                    option.setEscapeItem(false); //B25u60g34 -OSPI - Field Issue - On form in Edit mode Hyperlink is showing HTML tags
                    if(String.isNotBlank(altRen.SortField__c)) { //if there is a sort field
                        Object sortValue = sobj.get(altRen.SortField__c);
                        optionsSort.add(new SortableSelectOption(option, sortValue));
                        sortValueMap.put(returnValue,String.valueOf(sobj.get(altRen.SortField__c))); 
                    } else {
                        options.add(option);
                    }
                }
            } catch(QueryException e) {
                Logger.error(e);
                
                dbValueMap.put('error', AppUtils.handleSystemExceptionMsg(e));
            }
            if(String.isNotBlank(altRen.SortField__c)) { //if there is a sort field
                optionsSort.sort();
                for(SortableSelectOption o : optionsSort) {
                    options.add(o.option);
                }
            }
            displayValues = options;
             
        }
        
    }
    //User Story 120874: Internal - Need global setting to enable/disable CK Editor
    private static Boolean isCkEditorDisable(){
        return FeatureManagement.checkPermission('DisableCKEditor');
    }
    /*
        Used by AlternativeRendering to determine the sort order of the SelectOptions
    */
    class SortableSelectOption implements Comparable{
        public transient Object sortOrder;
        public transient SelectOption option;
        public SortableSelectOption(SelectOption o, Object so) {
            option = o;
            sortOrder = so;
        }
        public Integer compareTo(Object other) {
            return PrimitiveComparator.compare(this.sortOrder, ((SortableSelectOption)other).sortOrder);
        }
    }
    
}