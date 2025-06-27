/* This class use to export Pdf of EnhancedGrid
*/

public with sharing class EnhancedGridExportCtrl {
    private transient boolean initialize; 
    public String flexGridType{get;set;}
    public String mode{get;set;}
    public Id parentRecordId1 {get;set;}
    public Integer level1{get;set;}
    public Map<String, Boolean> isTableAvailableMap{get;set;}
   public Id sessionListViewId {get;set;}

    public String flexGridName{get;
        set{
            flexGridName = value;

            if(initialize == null && mode=='application/vnd.ms-excel' && flexGridType != null){ 
                getGridData();
                initialize = true; 
            }
        }
    }

    public String userDateFormat{
        get{
            return AppUtils.getUserDateFormat();
        }set;
    }
    public String userDateTimeFormat{
        get{
            return AppUtils.getUserDateTimeFormat();
        }set;
    }
    public String userTimeFormat{
        get{
            return AppUtils.getUserTimeZoneFormat();
        }set;
    }
    Set<String> parentTableFieldAPISet=new Set<String>();
    public transient List<String> parentTableFieldAPIList{get;set;}
    public transient List<String> childTableFieldAPIList{get;set;}
    public transient List<String> child2TableFieldAPIList{get;set;}
    public transient List<String> grandchildTableFieldAPIList{get;set;}
    public transient List<String> grandchild2TableFieldAPIList{get;set;}
    public transient Map<String,String> parentFieldInfoMap{get;set;}
    public transient Map<String,List<DataTableDetailConfig__c>> dataTableDetailConfigMap;
    private transient Map<String, Object> mergeFieldsKeyValueMap;
    public transient List<Sobject> parentRecords {get;set;}
    public transient List<Sobject> parentRecordsWithAllFields {get;set;}
    private Integer parentFieldCount = 0;
    private Integer childColumnCount = 0;
    private Integer child2ColumnCount = 0;
    private Boolean isChild1GrandChild2Table = false;
    private String maskValue = '*****';
    public Map<Id,List<Sobject>> childRecordsMap = new Map<Id,List<Sobject>>();
    public Map<Id,List<Sobject>> childRecordsMap2 = new Map<Id,List<Sobject>>();
    FlexTableCtrl getMergefieldObj= new FlexTableCtrl();
    private transient Map<String,String> massEditableGridConfigMap;
    public transient Boolean isCPULimitExceded{get;set;}
    public transient Component.Apex.OutputPanel body;
    private transient String html = '';
    private transient Sobject parentRecord;
    private set<string> setParentObjectFields = new set<string>();
    public transient List<FlexGridConfig__c> flexGridInfo;
    public transient String childTableHeaderName{get; set{
                childTableHeaderName = value;
                if(childTableHeaderName == null){
                    childTableHeaderName = '';
                }
            }
        }
        public transient String child2TableHeaderName{get; set{
                child2TableHeaderName = value;
                if(child2TableHeaderName == null){
                    child2TableHeaderName = '';
                }
            }
        }
    public transient String parentHeaderLabel{get; set{
                parentHeaderLabel = value;
                if(parentHeaderLabel == null){
                    parentHeaderLabel = '';
                }
            }
        }
     public transient String grandchildTableHeaderName{get; set{
                grandchildTableHeaderName = value;
                if(grandchildTableHeaderName == null){
                    grandchildTableHeaderName = '';
                }
            }
        }
        public transient String grandchild2TableHeaderName{get; set{
                grandchild2TableHeaderName = value;
                if(grandchild2TableHeaderName == null){
                    grandchild2TableHeaderName = '';
                }
            }
        }
    Map<string, Object> paramMap = new Map<string, Object>();
    Map<string, Object> paramRecordMap = new Map<string, Object>();
    Map<String,String> parentHideCellMap = new Map<String,String>();
    Map<String,String> Child1HideCellMap = new Map<String,String>();
    Map<String,String> grandChild1HideCellMap = new Map<String,String>();
    Map<String,String> Child2HideCellMap = new Map<String,String>();
    Map<String,String> grandChild2HideCellMap = new Map<String,String>();
    Map<String,String> parentHideColumnMap = new Map<String,String>();
    Map<String,String> Child1HideColumnMap = new Map<String,String>();
    Map<String,String> Child2HideColumnMap = new Map<String,String>();
    Map<String,String> grandChild1HideColumnMap = new Map<String,String>();
    Map<String,String> grandChild2HideColumnMap = new Map<String,String>();
    Map<String,String> tableHeaderMap = new Map<String,String>();
    Map<string, Object> flexGridInfoMap = new Map<string, Object>();
    Map<string, Object> flexGridInfoMapTemp = new Map<string, Object>();
    Map<string, Object> flexTableMetaData = new Map<string, Object>();
    Map<String,sObject> tableWithParentRecord = new Map<String,sObject>();
    FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();
    private Map<Id, List<SObject>> grandChildRecordsByParentId = new Map<Id, List<SObject>>();
    private Map<Id, List<SObject>> grandChild2RecordsByParentId = new Map<Id, List<SObject>>();
    public transient String currencySymbol;

       
    //variables for CSV
    public transient List<RecordWrapper> listRecords {get;set;}
    public transient Map<Id,List<recordWrapper>> child1RecordsMap {get;set;}
    public transient Map<Id,List<recordWrapper>> child2RecordsMap {get;set;}
    public transient Map<Id,List<recordWrapper>> grandChildRecordsMap {get;set;}
    public transient Map<Id,List<recordWrapper>> grandChild2RecordsMap {get;set;}
    public transient Map<String,String> recordWrapper{get;set;}
    public transient Map<String,String> child1FieldInfoMap{get;set;}
    public transient Map<String,String> child2FieldInfoMap{get;set;}
    public transient Map<String,String> grandChildFieldInfoMap{get;set;}
     public transient Map<String,String> grandChild2FieldInfoMap{get;set;}
    
    public transient Integer enableRowIndexParent{get;set;}
    public transient String parentRowLabelIndex{get;set;} 
    public transient Boolean enableRowIndexChild1{get;set;}
    public transient Boolean enableRowIndexChild2{get;set;}
    public transient String child1RowLabelIndex{get;set;} 
    public transient Boolean enableRowIndexGrandChild{get;set;}
    public transient String child2RowLabelIndex{get;set;} 
    public transient Boolean enableRowIndexGrandChild2{get;set;}
    public transient String grandchildRowLabelIndex{get;set;}
    public transient String grandchild2RowLabelIndex{get;set;}

    public transient Map<String, Map<String, String>> overAllTotalMap{get;set;}
    public transient Map<String, Map<String, Boolean>>levelVsColumnEnableOverAllTotal{get;set;}
    public transient Map<String, Map<String,Map<String, String>>> childOverAllTotalMap{get;set;}
    private transient Map<String, String> levelVsTableIdMap = new Map<String, String>();
    private transient Map<String,Map<String,String>> parenIdVSfieldoverAllTotalMap = new Map<String,Map<String, String>>();
    private transient Map<String,Map<String,String>> levelVsFieldVsDataTypeMap = new Map<String,Map<String, String>>();
    private transient Map<String,Map<String,List<String>>> levelVsFieldVsHideCellIdMap = new Map<String,Map<String, List<String>>>();
    public transient Map<String, Map<String,Map<String, String>>> levelVsFieldVsOverallLabelMap{get;set;}
     
    private Map<String, String> userFieldsToQueryMap = new Map<String, String>();
    private Map<String, String> acctFieldsToQueryMap = new Map<String, String>();
    private Map<String, String> userMergeFieldsValueMap = new Map<String, String>();
    private Map<String, String> acctMergeFieldsValueMap = new Map<String, String>();
    public transient Map<String, List<DataTableDetailConfig__c>> mapLevelWiseDataTableDetails = new Map<String, List<DataTableDetailConfig__c>>();
    public transient Map<String, List<FlexTableFilterListViewConfig__c>> mapLevelWiseListViews = new Map<String, List<FlexTableFilterListViewConfig__c>>();
    Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigInfoMap = new  Map< String, FlexGridEnhancedUtility.DataTableDetailInfo>();
    Map< String, FlexGridEnhancedUtility.FlexTableListFilterListView> dataTableListViewConfigInfoMap = new  Map< String, FlexGridEnhancedUtility.FlexTableListFilterListView>();
    public static List<XSSSanitization__mdt> lstMetadata;
    public static List<String> xssSanitizeStr = new List<String>();
    public Integer sizeOfParentList { get { return overAllTotalMap.get('ParentFlexTable')!= null ? overAllTotalMap.get('ParentFlexTable').size() :0; } } 
    static{     
        lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues']; //NOPMD CRUD - False +ve - this is metadata will not check permission here 
        if(!lstMetadata.isempty())            
            xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c) ? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();        
    }
    User userDetails;
    Account accountDetails;
     Set<String> standerdFields = new Set<String>{'RecordTypeId','ContentDocumentId','LinkedEntityId','LastModifiedById','CreatedById','LinkedEntityId','CollaborationGroupId','MemberId','RequesterId','OwnerId','ParentId','ProfileId'};

    public EnhancedGridExportCtrl(){        
        isTableAvailableMap = new Map<String, Boolean>();
        isTableAvailableMap.put('child1',false);
        isTableAvailableMap.put('grandChild1',false);
        isTableAvailableMap.put('child2',false);
        isTableAvailableMap.put('grandChild2',false);
        overAllTotalMap = new Map<String, Map<String, String>>();
        levelVsColumnEnableOverAllTotal = new Map<String, Map<String, Boolean>>();
        childOverAllTotalMap = new Map<String, Map<String,Map<String, String>>>();
        levelVsFieldVsOverallLabelMap = new Map<String, Map<String,Map<String, String>>>();
    }

        // THIS METHOD CALL FIRST
        public Component.Apex.OutputPanel getGridData() {
            body = new Component.Apex.OutputPanel();
            isCPULimitExceded = false;
            paramMap = new Map<string, Object>();
            getMergFieldData();
            getConfigData();
            getParentData();
            getChildRecords();
            getGrandChildRecords();
           //
            return renderGrid();
        }
        
        //create paramJSON
        private void getConfigData(){
            parentFieldInfoMap = new  Map<String,String>();         
            dataTableDetailConfigMap = new Map<String,List<DataTableDetailConfig__c>>();
            massEditableGridConfigMap = new Map<String,String>();
           
            paramMap.put('Name',flexGridName);
            paramMap.put('flexGridType',flexGridType);
            paramMap.put('mode',mode);
            paramMap.put('level',level1);
            paramMap.put('parentRecordId',parentRecordId1);
            string paramMapJson = JSON.serialize(paramMap);

            currencySymbol = AppUtils.getLocaleCurrencySymbol();
           // currencySymbol = currencySymbol.escapeEcmaScript().unescapeUnicode();  
            currencySymbol = String.escapeSingleQuotes(currencySymbol);  
            String flexGridName = String.escapeSingleQuotes(flexGridName);
            String query = ' SELECT Id, Name, RecordType.Name, Child1RelationshipName__c, Child2RelationshipName__c, GrandChild1RelationshipName__c, GrandChild2RelationshipName__c, ' +

                ' ParentFlexTable__r.Name, ParentFlexTable__r.DisableMenu__c, ParentFlexTable__r.EnableHelp__c, ' +
                ' ParentFlexTable__r.HelpConfig__c, ParentFlexTable__r.FieldNames__c, ' +
                ' ParentFlexTable__r.EnableQuickSearch__c, ParentFlexTable__r.SobjectConfig__r.Name, ' +
                ' ParentFlexTable__r.DefaultPageSize__c, ParentFlexTable__r.DefaultPageSizeEnhanced__c, ' +
                ' ParentFlexTable__r.FilterCriteria__c, ParentFlexTable__r.OrderBy__c, ' +
                ' ParentFlexTable__r.Sort_Direction__c,  ParentFlexTable__r.EnableDataImportExport__c,' +
                ' ParentFlexTable__r.Header__c, ParentFlexTable__r.EnableExport__c, ParentFlexTable__r.EnableExportXls__c, ParentFlexTable__r.PDFRenderType__c, ' +
                ' ParentFlexTable__r.SubHeaderText__c, ParentFlexTable__r.ShowHeaderPanel__c, ' +
                ' ParentFlexTable__r.EnableIndexBar__c, ParentFlexTable__r.EnablePagination__c, ParentFlexTable__r.EnableHyperLinkAsText__c,' +
                ' ParentFlexTable__r.EnablePageSize__c, ParentFlexTable__r.EnableGroupedSubTotalRow__c,  ' +
                ' ParentFlexTable__r.EnableAutoIndex__c, ParentFlexTable__r.AutoIndexBehaviour__c, ' +
                ' ParentFlexTable__r.EnableTotalRecordsCount__c, ParentFlexTable__r.EnableFilter__c, ' +
                ' ParentFlexTable__r.ParentTargetLookupField__c, ParentFlexTable__r.HeaderDescription__c, ' +
                ' ParentFlexTable__r.EnableTotalColumn__c, ParentFlexTable__r.RecordTypeId, ' +
                ' ParentFlexTable__r.RecordType.Name, ParentFlexTable__r.RecordType.DeveloperName, ' +
                ' ParentFlexTable__r.EnableTotalRow__c, ParentFlexTable__r.EnableRecordSelection__c, ParentFlexTable__r.RecordSelectionColumnHeader__c, ' + 
                ' ParentFlexTable__r.RecordSelectionColumnPosition__c, ParentFlexTable__r.RequiredFields__c, ParentFlexTable__r.ShowHideDisabledAction__c,ParentFlexTable__r.SkipFieldsForExport__c,ParentFlexTable__r.Disable_sort_order__c, ' +

                ' Child1FlexTable__r.Name, Child1FlexTable__r.DisableMenu__c, Child1FlexTable__r.EnableHelp__c, ' +
                ' Child1FlexTable__r.HelpConfig__c, Child1FlexTable__r.FieldNames__c, ' +
                ' Child1FlexTable__r.EnableQuickSearch__c, Child1FlexTable__r.SobjectConfig__r.Name, ' +
                ' Child1FlexTable__r.DefaultPageSize__c, Child1FlexTable__r.DefaultPageSizeEnhanced__c, ' +
                ' Child1FlexTable__r.FilterCriteria__c, Child1FlexTable__r.OrderBy__c, ' +
                ' Child1FlexTable__r.Sort_Direction__c,  Child1FlexTable__r.EnableDataImportExport__c,' +
                ' Child1FlexTable__r.Header__c, Child1FlexTable__r.EnableExport__c, Child1FlexTable__r.EnableExportXls__c, Child1FlexTable__r.PDFRenderType__c, ' +
                ' Child1FlexTable__r.SubHeaderText__c, Child1FlexTable__r.ShowHeaderPanel__c, ' +
                ' Child1FlexTable__r.EnableIndexBar__c, Child1FlexTable__r.EnablePagination__c,  Child1FlexTable__r.EnableHyperLinkAsText__c,' +
                ' Child1FlexTable__r.EnablePageSize__c, Child1FlexTable__r.EnableGroupedSubTotalRow__c, ' +
                ' Child1FlexTable__r.EnableAutoIndex__c, Child1FlexTable__r.AutoIndexBehaviour__c, ' +
                ' Child1FlexTable__r.EnableTotalRecordsCount__c, Child1FlexTable__r.EnableFilter__c, ' +
                ' Child1FlexTable__r.ParentTargetLookupField__c, Child1FlexTable__r.HeaderDescription__c, ' +
                ' Child1FlexTable__r.EnableTotalColumn__c, Child1FlexTable__r.RecordTypeId, ' +
                ' Child1FlexTable__r.RecordType.Name, Child1FlexTable__r.RecordType.DeveloperName, ' +
                ' Child1FlexTable__r.EnableTotalRow__c, Child1FlexTable__r.EnableRecordSelection__c, Child1FlexTable__r.RecordSelectionColumnHeader__c, ' + 
                ' Child1FlexTable__r.RecordSelectionColumnPosition__c, Child1FlexTable__r.RequiredFields__c, Child1FlexTable__r.ShowHideDisabledAction__c,Child1FlexTable__r.SkipFieldsForExport__c,Child1FlexTable__r.Disable_sort_order__c, ' +

                ' Child2FlexTable__r.Name, Child2FlexTable__r.DisableMenu__c, Child2FlexTable__r.EnableHelp__c, ' +
                ' Child2FlexTable__r.HelpConfig__c, Child2FlexTable__r.FieldNames__c, ' +
                ' Child2FlexTable__r.EnableQuickSearch__c, Child2FlexTable__r.SobjectConfig__r.Name, ' +
                ' Child2FlexTable__r.DefaultPageSize__c, Child2FlexTable__r.DefaultPageSizeEnhanced__c, ' +
                ' Child2FlexTable__r.FilterCriteria__c, Child2FlexTable__r.OrderBy__c, ' +
                ' Child2FlexTable__r.Sort_Direction__c,  Child2FlexTable__r.EnableDataImportExport__c,' +
                ' Child2FlexTable__r.Header__c, Child2FlexTable__r.EnableExport__c, Child2FlexTable__r.EnableExportXls__c, Child2FlexTable__r.PDFRenderType__c, ' +
                ' Child2FlexTable__r.SubHeaderText__c, Child2FlexTable__r.ShowHeaderPanel__c, ' +
                ' Child2FlexTable__r.EnableIndexBar__c, Child2FlexTable__r.EnablePagination__c,  Child2FlexTable__r.EnableHyperLinkAsText__c,' +
                ' Child2FlexTable__r.EnablePageSize__c, Child2FlexTable__r.EnableGroupedSubTotalRow__c, ' +
                ' Child2FlexTable__r.EnableAutoIndex__c, Child2FlexTable__r.AutoIndexBehaviour__c, ' +
                ' Child2FlexTable__r.EnableTotalRecordsCount__c, Child2FlexTable__r.EnableFilter__c, ' +
                ' Child2FlexTable__r.ParentTargetLookupField__c, Child2FlexTable__r.HeaderDescription__c, ' +
                ' Child2FlexTable__r.EnableTotalColumn__c, Child2FlexTable__r.RecordTypeId, ' +
                ' Child2FlexTable__r.RecordType.Name, Child2FlexTable__r.RecordType.DeveloperName, ' +
                ' Child2FlexTable__r.EnableTotalRow__c, Child2FlexTable__r.EnableRecordSelection__c, Child2FlexTable__r.RecordSelectionColumnHeader__c, ' + 
                ' Child2FlexTable__r.RecordSelectionColumnPosition__c, Child2FlexTable__r.RequiredFields__c, Child2FlexTable__r.ShowHideDisabledAction__c,Child2FlexTable__r.SkipFieldsForExport__c,Child2FlexTable__r.Disable_sort_order__c, ' +

                ' GrandChild1FlexTable__r.Name, GrandChild1FlexTable__r.DisableMenu__c, GrandChild1FlexTable__r.EnableHelp__c, ' +
                ' GrandChild1FlexTable__r.HelpConfig__c, GrandChild1FlexTable__r.FieldNames__c, ' +
                ' GrandChild1FlexTable__r.EnableQuickSearch__c, GrandChild1FlexTable__r.SobjectConfig__r.Name, ' +
                ' GrandChild1FlexTable__r.DefaultPageSize__c, GrandChild1FlexTable__r.DefaultPageSizeEnhanced__c, ' +
                ' GrandChild1FlexTable__r.FilterCriteria__c, GrandChild1FlexTable__r.OrderBy__c, ' +
                ' GrandChild1FlexTable__r.Sort_Direction__c,  GrandChild1FlexTable__r.EnableDataImportExport__c,' +
                ' GrandChild1FlexTable__r.Header__c, GrandChild1FlexTable__r.EnableExport__c, GrandChild1FlexTable__r.EnableExportXls__c, GrandChild1FlexTable__r.PDFRenderType__c, ' +
                ' GrandChild1FlexTable__r.SubHeaderText__c, GrandChild1FlexTable__r.ShowHeaderPanel__c, ' +
                ' GrandChild1FlexTable__r.EnableIndexBar__c, GrandChild1FlexTable__r.EnablePagination__c,  GrandChild1FlexTable__r.EnableHyperLinkAsText__c,' +
                ' GrandChild1FlexTable__r.EnablePageSize__c, GrandChild1FlexTable__r.EnableGroupedSubTotalRow__c, ' +
                ' GrandChild1FlexTable__r.EnableAutoIndex__c, GrandChild1FlexTable__r.AutoIndexBehaviour__c, ' +
                ' GrandChild1FlexTable__r.EnableTotalRecordsCount__c, GrandChild1FlexTable__r.EnableFilter__c, ' +
                ' GrandChild1FlexTable__r.ParentTargetLookupField__c, GrandChild1FlexTable__r.HeaderDescription__c, ' +
                ' GrandChild1FlexTable__r.EnableTotalColumn__c, GrandChild1FlexTable__r.RecordTypeId, ' +
                ' GrandChild1FlexTable__r.RecordType.Name, GrandChild1FlexTable__r.RecordType.DeveloperName, ' +
                ' GrandChild1FlexTable__r.EnableTotalRow__c, GrandChild1FlexTable__r.EnableRecordSelection__c, GrandChild1FlexTable__r.RecordSelectionColumnHeader__c, ' + 
                ' GrandChild1FlexTable__r.RecordSelectionColumnPosition__c, GrandChild1FlexTable__r.RequiredFields__c, GrandChild1FlexTable__r.ShowHideDisabledAction__c,GrandChild1FlexTable__r.SkipFieldsForExport__c,GrandChild1FlexTable__r.Disable_sort_order__c, ' +

                ' GrandChild2FlexTable__r.Name, GrandChild2FlexTable__r.DisableMenu__c, GrandChild2FlexTable__r.EnableHelp__c, ' +
                ' GrandChild2FlexTable__r.HelpConfig__c, GrandChild2FlexTable__r.FieldNames__c, ' +
                ' GrandChild2FlexTable__r.EnableQuickSearch__c, GrandChild2FlexTable__r.SobjectConfig__r.Name, ' +
                ' GrandChild2FlexTable__r.DefaultPageSize__c, GrandChild2FlexTable__r.DefaultPageSizeEnhanced__c, ' +
                ' GrandChild2FlexTable__r.FilterCriteria__c, GrandChild2FlexTable__r.OrderBy__c, ' +
                ' GrandChild2FlexTable__r.Sort_Direction__c,  GrandChild2FlexTable__r.EnableDataImportExport__c,' +
                ' GrandChild2FlexTable__r.Header__c, GrandChild2FlexTable__r.EnableExport__c, GrandChild2FlexTable__r.EnableExportXls__c, GrandChild2FlexTable__r.PDFRenderType__c, ' +
                ' GrandChild2FlexTable__r.SubHeaderText__c, GrandChild2FlexTable__r.ShowHeaderPanel__c, ' +
                ' GrandChild2FlexTable__r.EnableIndexBar__c, GrandChild2FlexTable__r.EnablePagination__c,  GrandChild2FlexTable__r.EnableHyperLinkAsText__c,' +
                ' GrandChild2FlexTable__r.EnablePageSize__c, GrandChild2FlexTable__r.EnableGroupedSubTotalRow__c, ' +               
                ' GrandChild2FlexTable__r.EnableAutoIndex__c, GrandChild2FlexTable__r.AutoIndexBehaviour__c, ' +
                ' GrandChild2FlexTable__r.EnableTotalRecordsCount__c, GrandChild2FlexTable__r.EnableFilter__c, ' +
                ' GrandChild2FlexTable__r.ParentTargetLookupField__c, GrandChild2FlexTable__r.HeaderDescription__c, ' +
                ' GrandChild2FlexTable__r.EnableTotalColumn__c, GrandChild2FlexTable__r.RecordTypeId, ' +
                ' GrandChild2FlexTable__r.RecordType.Name, GrandChild2FlexTable__r.RecordType.DeveloperName, ' +
                ' GrandChild2FlexTable__r.EnableTotalRow__c, GrandChild2FlexTable__r.EnableRecordSelection__c, GrandChild2FlexTable__r.RecordSelectionColumnHeader__c, ' +  
                ' GrandChild2FlexTable__r.RecordSelectionColumnPosition__c, GrandChild2FlexTable__r.RequiredFields__c, GrandChild2FlexTable__r.ShowHideDisabledAction__c,GrandChild2FlexTable__r.SkipFieldsForExport__c,GrandChild2FlexTable__r.Disable_sort_order__c ' +

            ' FROM FlexGridConfig__c WHERE Name = :flexGridName Limit 1';

            flexGridInfo = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE);
           
            tableHeaderMap.put('ParentFlexTable',flexGridInfo[0].ParentFlexTable__r.Header__c);
            tableHeaderMap.put('Child1',flexGridInfo[0].Child1FlexTable__r.Header__c);
            tableHeaderMap.put('Child2',flexGridInfo[0].Child2FlexTable__r.Header__c);
            tableHeaderMap.put('GrandChild1',flexGridInfo[0].GrandChild1FlexTable__r.Header__c);
            tableHeaderMap.put('GrandChild2',flexGridInfo[0].GrandChild2FlexTable__r.Header__c);


            Map<String, Object> flexTableConfigInfoInnerMap = new Map<String, Object>();
            Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigInfoMap = new  Map< String, FlexGridEnhancedUtility.DataTableDetailInfo>();


            Set<Id> flexTableIds = new Set<Id>();
            List<String> lstFlexDataConfigFilterCriteria = new List<string>();

            if(flexGridInfo[0].ParentFlexTable__c != null){
                flexTableIds.add(flexGridInfo[0].ParentFlexTable__c);
                if(flexGridInfo[0].ParentFlexTable__r.FilterCriteria__c != null){
                    lstFlexDataConfigFilterCriteria.add(flexGridInfo[0].ParentFlexTable__r.FilterCriteria__c);
                }
                dataTableDetailConfigInfoMap.put(flexGridInfo[0].ParentFlexTable__c, null);
                dataTableListViewConfigInfoMap.put(flexGridInfo[0].ParentFlexTable__c, null);
                levelVsTableIdMap.put('ParentFlexTable',flexGridInfo[0].ParentFlexTable__c);                
            }
            if(flexGridInfo[0].Child1FlexTable__c != null){
                flexTableIds.add(flexGridInfo[0].Child1FlexTable__c);
                if(flexGridInfo[0].Child1FlexTable__r.FilterCriteria__c != null){
                    lstFlexDataConfigFilterCriteria.add(flexGridInfo[0].Child1FlexTable__r.FilterCriteria__c);
                }
                dataTableDetailConfigInfoMap.put(flexGridInfo[0].Child1FlexTable__c, null);
                dataTableListViewConfigInfoMap.put(flexGridInfo[0].Child1FlexTable__c, null);
                levelVsTableIdMap.put('Child1',flexGridInfo[0].Child1FlexTable__c); 
            }
            if(flexGridInfo[0].Child2FlexTable__c != null){
                flexTableIds.add(flexGridInfo[0].Child2FlexTable__c);
                if(flexGridInfo[0].Child2FlexTable__r.FilterCriteria__c != null){
                    lstFlexDataConfigFilterCriteria.add(flexGridInfo[0].Child2FlexTable__r.FilterCriteria__c);
                }
                dataTableDetailConfigInfoMap.put(flexGridInfo[0].Child2FlexTable__c, null);
                dataTableListViewConfigInfoMap.put(flexGridInfo[0].Child2FlexTable__c, null);
                levelVsTableIdMap.put('Child2',flexGridInfo[0].Child2FlexTable__c); 
            }
            if(flexGridInfo[0].GrandChild1FlexTable__c != null){
                flexTableIds.add(flexGridInfo[0].GrandChild1FlexTable__c);
                if(flexGridInfo[0].GrandChild1FlexTable__r.FilterCriteria__c != null){
                    lstFlexDataConfigFilterCriteria.add(flexGridInfo[0].GrandChild1FlexTable__r.FilterCriteria__c);
                }
                dataTableDetailConfigInfoMap.put(flexGridInfo[0].GrandChild1FlexTable__c, null);
                dataTableListViewConfigInfoMap.put(flexGridInfo[0].GrandChild1FlexTable__c, null);
                levelVsTableIdMap.put('GrandChild1',flexGridInfo[0].GrandChild1FlexTable__c); 
            }
            if(flexGridInfo[0].GrandChild2FlexTable__c != null){
                flexTableIds.add(flexGridInfo[0].GrandChild2FlexTable__c);
                if(flexGridInfo[0].GrandChild2FlexTable__r.FilterCriteria__c != null){
                    lstFlexDataConfigFilterCriteria.add(flexGridInfo[0].GrandChild2FlexTable__r.FilterCriteria__c);
                }
                dataTableDetailConfigInfoMap.put(flexGridInfo[0].GrandChild2FlexTable__c, null);
                dataTableListViewConfigInfoMap.put(flexGridInfo[0].GrandChild2FlexTable__c, null);
                levelVsTableIdMap.put('GrandChild2',flexGridInfo[0].GrandChild2FlexTable__c); 
            }


            String strDataTableDetailConfigFields   =   ' FlexTableConfig__c, EnableTotal__c, EnableRowGrouping__c, EnableSubTotal__c, EnableOverAllTotal__c, EnableEditDisplayField__c,SubTotalLabel__c, EscapeHtml__c, FieldAPIName__c, '+
                                                        ' FieldWidthEnhanced__c, WhereClause__c, DefaultValue__c, RenderType__c, HelpText__c, DisplayFields__c, HideCellJSON__c, HideColumnJSON__c, '+
                                                        ' FieldLabelOverride__c ,HideGroupingColumn__c, ReadOnlyCellJSON__c, ReadOnlyColumnJSON__c, StyleAttribute__c, StyleClass__c, Formula__c, FormulaJSON__c,ShowLinkAsText__c,Enable_Text_Wrapping__c,EnableColumnSubtotalPercentage__c, ColumnSubtotalPercentageJSON__c,DecimalPlaces__c';//,  DisableSortOrder__c';

            List<DataTableDetailConfig__c> lstDataTableDetailConfig = (List<DataTableDetailConfig__c> )new QueryBuilder()
                                                                                .addFields(strDataTableDetailConfigFields)
                                                                                .setsObject('DataTableDetailConfig__c')
                                                                                .addFilter('FlexTableConfig__c IN (\'' + String.join(new List<Id>(flexTableIds),'\',\'')+ '\')')
                                                                                .createQuery()
                                                                                .execute();



            String strListViewFields  = 'Id, FilterClause__c, IsActive__c, IsDefault__c, IsMasterView__c, ShowInPDF__c, InternalUniqueID__c, Label__c, FlexTableConfig__c';


            List<FlexTableFilterListViewConfig__c> lstFlexTableFilterListView = (List<FlexTableFilterListViewConfig__c> )new QueryBuilder()
                                                                                .addFields(strListViewFields)
                                                                                .setsObject('FlexTableFilterListViewConfig__c')
                                                                                .addFilter('FlexTableConfig__c IN (\'' + String.join(new List<Id>(flexTableIds),'\',\'')+ '\')')
                                                                                .createQuery()
                                                                                .execute();


            
            


            if(!lstFlexDataConfigFilterCriteria.isEmpty()){
                for(String filterCriteria : lstFlexDataConfigFilterCriteria){
                    Map<String, Map<String, String>> userAccountfieldsMap = getUserAccountfieldsMap(filterCriteria);
                    userFieldsToQueryMap = userAccountfieldsMap.get('User');
                    acctFieldsToQueryMap = userAccountfieldsMap.get('Account');

                }
            }
            
            if(!lstDataTableDetailConfig.isEmpty()){
                for(DataTableDetailConfig__c dataTableDetailConfig : lstDataTableDetailConfig){
                    if(dataTableDetailConfig.WhereClause__c != null){
                        Map<String, Map<String, String>> userAccountfieldsMap = getUserAccountfieldsMap(dataTableDetailConfig.WhereClause__c);
                        userFieldsToQueryMap.putAll(userAccountfieldsMap.get('User'));
                        acctFieldsToQueryMap.putAll(userAccountfieldsMap.get('Account'));
                    }
                    for(String tableId : dataTableDetailConfigInfoMap.keySet()){
                        Map<String,String> overAllTotalFieldsMap= new Map<String,String>();
                        if(dataTableDetailConfig.FlexTableConfig__c == tableId){
                            List<DataTableDetailConfig__c> lstTableDetails = new List<DataTableDetailConfig__c>();
                            if(mapLevelWiseDataTableDetails.get(tableId) != null){
                                lstTableDetails = mapLevelWiseDataTableDetails.get(tableId);
                            }
                            if(mapLevelWiseDataTableDetails.size() <= 0 && mapLevelWiseDataTableDetails.get(tableId) == null){
                                lstTableDetails.add(dataTableDetailConfig);
                                mapLevelWiseDataTableDetails.put(tableId , lstTableDetails);
                            } else {
                                lstTableDetails.add(dataTableDetailConfig);
                                mapLevelWiseDataTableDetails.put(tableId , lstTableDetails);
                            }
                            if(dataTableDetailConfig.EnableOverAllTotal__c == true){
                               
                                if(overAllTotalFieldsMap.get(dataTableDetailConfig.FieldAPIName__c) == null){
                                    overAllTotalFieldsMap.put( dataTableDetailConfig.FieldAPIName__c,'');
                                }
                                if(overAllTotalMap.get(tableId) == null){
                                    overAllTotalMap.put(tableId, overAllTotalFieldsMap);
                                }    else    {
                                    overAllTotalFieldsMap = overAllTotalMap.get(tableId);
                                    overAllTotalFieldsMap.put( dataTableDetailConfig.FieldAPIName__c,'');
                                    overAllTotalMap.put(tableId, overAllTotalFieldsMap);
                                }

                            }
                        }
                    }                
                }
            }
            if(!lstFlexTableFilterListView.isEmpty()){
                for(FlexTableFilterListViewConfig__c flexTableFilterListView : lstFlexTableFilterListView){
                    if(flexTableFilterListView.FilterClause__c != null){
                        Map<String, Map<String, String>> userAccountfieldsMap = getUserAccountfieldsMap(flexTableFilterListView.FilterClause__c);

                        userFieldsToQueryMap.putAll(userAccountfieldsMap.get('User'));
                        acctFieldsToQueryMap.putAll(userAccountfieldsMap.get('Account'));
                    }
                    
                    for(String tableId : dataTableListViewConfigInfoMap.keySet()){
                        if(flexTableFilterListView.FlexTableConfig__c == tableId){

                            List<FlexTableFilterListViewConfig__c> lstTableListViews = new List<FlexTableFilterListViewConfig__c>();
                            if(mapLevelWiseListViews.get(tableId) != null){
                                lstTableListViews = mapLevelWiseListViews.get(tableId);
                            }
                            lstTableListViews.add(flexTableFilterListView);
                            mapLevelWiseListViews.put(tableId , lstTableListViews);                            
                        }
                    }
                }
            }

            // User userDetails;
            // Account accountDetails;
            if(userFieldsToQueryMap.size() > 0) {
                Id userInfoId = UserInfo.getUserId();
                Id userOrgId = UserInfo.getOrganizationId();
                String userQuery = 'SELECT '+ String.escapeSingleQuotes(String.join(userFieldsToQueryMap.values(), ',')) + ' FROM User WHERE Id =: userInfoId';
                userDetails = Database.query(String.escapeSingleQuotes(userQuery), AccessLevel.USER_MODE);
                if(acctFieldsToQueryMap.size() > 0 && userDetails != null && userDetails.OrganizationId__c != null) {
                    String accQuery = 'SELECT '+ String.escapeSingleQuotes(String.join(acctFieldsToQueryMap.values(), ',')) + ' FROM Account WHERE Id =:userOrgId';
                    List<Account> lstAcccounts = Database.query(String.escapeSingleQuotes(accQuery), AccessLevel.USER_MODE);
                    accountDetails = lstAcccounts[0];

                    if(!lstAcccounts.isEmpty()){
                        for(String strMergeField : acctFieldsToQueryMap.keySet()) {
                            Object fieldValue = AppUtils.getFieldValue(accountDetails, acctFieldsToQueryMap.get(strMergeField));
                            acctMergeFieldsValueMap.put(strMergeField, String.valueOf(fieldValue));
                        }
                    }
                }

                if(userDetails != null ) {
                    for(String strMergeField : userFieldsToQueryMap.keySet()) {
                        Object fieldValue = AppUtils.getFieldValue(userDetails, userFieldsToQueryMap.get(strMergeField));
                        userMergeFieldsValueMap.put(strMergeField, String.valueOf(fieldValue));
                    }
                }
            }

            //for(FlexTableFilterListViewConfig__c flexTableFilterListView : lstFlexTableFilterListView){

   //             FlexGridEnhancedUtility.FlexTableListFilterListView flexListView = new FlexGridEnhancedUtility.FlexTableListFilterListView(flexTableFilterListView);
   //             if (flexListView.FilterClause != null){
   //                 flexListView.FilterClause = replaceAllMergeFields(flexListView.FilterClause,initParams);
   //             }

   //             flexTableFilterListViewList.add(flexListview);
   //         }

   //         flexTableConfigData.FlexTableFilterListViewList



            if(flexGridInfo[0].ParentFlexTable__c != null){
                List<DataTableConfig__c> dataTableConfigParentList = new List<DataTableConfig__c>();
                flexGridInfoMap.put('GridType','FlexGrid');
                DataTableConfig__c flexTableConfigRecord = flexGridInfo[0].ParentFlexTable__r;
                dataTableConfigParentList.add(flexTableConfigRecord);
                FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();
                getFlexTableConfigData(dataTableConfigParentList, 'ParentFlexTable', userDetails, accountDetails);

                FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexTableConfigRecord, false);
                if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                    flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria, parentRecordId1, userDetails, accountDetails);
                }

                flexTableConfigInfoInnerMap.put('FlexTableConfig', flexDataConfig);
                flexTableConfigInfoInnerMap.put('ColumnNamesList', flexTableConfigRecord.FieldNames__c);
                Schema.SObjectType dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexTableConfigRecord.SobjectConfig__r.Name);
                //flexGridInfoMapTemp.put('ParentFlexTable', flexTableConfigInfoInnerMap);
                flexTableConfigInfoInnerMap = new Map<String, Object>();               
                flexTableConfigData = (FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get('ParentFlexTable');

                if(parentRecordId1 != null && String.valueOf(parentRecordId1) != ''){
                    setParentObjectFields.addAll(flexGridEnhancedHelper.getParentObjectFields(parentRecordId1,null,flexTableConfigData.DataTableDetailConfigMap,flexGridInfoMap));
                }
            }  else  {
				///////////////////////////////////////////////////////////
				//														 //
				///////////           Throw Exception           ///////////
				//														 //
				///////////////////////////////////////////////////////////
            
            }
            if(flexGridInfo[0].Child1FlexTable__c != null){
                List<DataTableConfig__c> dataTableConfigCH1ist = new List<DataTableConfig__c>();
                DataTableConfig__c flexTableConfigRecord = flexGridInfo[0].Child1FlexTable__r;
                dataTableConfigCH1ist.add(flexTableConfigRecord);
                FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();
                getFlexTableConfigData(dataTableConfigCH1ist, 'Child1', userDetails, accountDetails);

                FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexGridInfo[0].Child1FlexTable__r, false);
                if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                    flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria, parentRecordId1, userDetails, accountDetails);
                }

                flexTableConfigInfoInnerMap.put('FlexTableConfig', flexGridInfo[0].Child1FlexTable__r);
                flexTableConfigInfoInnerMap.put('ColumnNamesList', flexGridInfo[0].Child1FlexTable__r.FieldNames__c);
                Schema.SObjectType dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name);
                //flexGridInfoMap.put('Child1', flexTableConfigInfoInnerMap);
                flexTableConfigInfoInnerMap = new Map<String, Object>();
                flexTableConfigData = (FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get('Child1');
                if(parentRecordId1 != null && String.valueOf(parentRecordId1) != ''){
                    setParentObjectFields.addAll(flexGridEnhancedHelper.getParentObjectFields(parentRecordId1,null,flexTableConfigData.DataTableDetailConfigMap,flexGridInfoMap));
                }
            }
            if(flexGridInfo[0].Child2FlexTable__c != null){
                List<DataTableConfig__c> dataTableConfigCH2ist = new List<DataTableConfig__c>();
                DataTableConfig__c flexTableConfigRecord = flexGridInfo[0].Child2FlexTable__r;
                dataTableConfigCH2ist.add(flexTableConfigRecord);
                FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();
                getFlexTableConfigData(dataTableConfigCH2ist, 'Child2', userDetails, accountDetails);

                FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexGridInfo[0].Child2FlexTable__r, false);
                if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                    flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria, parentRecordId1, userDetails, accountDetails);
                }

                flexTableConfigInfoInnerMap.put('FlexTableConfig', flexGridInfo[0].Child2FlexTable__r);
                flexTableConfigInfoInnerMap.put('ColumnNamesList', flexGridInfo[0].Child2FlexTable__r.FieldNames__c);
                Schema.SObjectType dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name);
                //flexGridInfoMap.put('Child2', flexTableConfigInfoInnerMap);
                flexTableConfigInfoInnerMap = new Map<String, Object>();
                flexTableConfigData = (FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get('Child2');
                if(parentRecordId1 != null && String.valueOf(parentRecordId1) != ''){
                    setParentObjectFields.addAll(flexGridEnhancedHelper.getParentObjectFields(parentRecordId1,null,flexTableConfigData.DataTableDetailConfigMap,flexGridInfoMap));
                }
            }
            if(flexGridInfo[0].GrandChild1FlexTable__c != null){
                List<DataTableConfig__c> dataTableConfigGH1ist = new List<DataTableConfig__c>();
                DataTableConfig__c flexTableConfigRecord = flexGridInfo[0].GrandChild1FlexTable__r;
                dataTableConfigGH1ist.add(flexTableConfigRecord);
                FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();
                getFlexTableConfigData(dataTableConfigGH1ist, 'GrandChild1', userDetails, accountDetails);

                FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexGridInfo[0].GrandChild1FlexTable__r, false);
                if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                    flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria, parentRecordId1, userDetails, accountDetails);
                }

                flexTableConfigInfoInnerMap.put('FlexTableConfig', flexGridInfo[0].GrandChild1FlexTable__r);
                flexTableConfigInfoInnerMap.put('ColumnNamesList', flexGridInfo[0].GrandChild1FlexTable__r.FieldNames__c);
                Schema.SObjectType dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name);
                //flexGridInfoMap.put('GrandChild1', flexTableConfigInfoInnerMap);
                flexTableConfigInfoInnerMap = new Map<String, Object>();
                flexTableConfigData = (FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get('GrandChild1');
                if(parentRecordId1 != null && String.valueOf(parentRecordId1) != ''){
                 setParentObjectFields.addAll(flexGridEnhancedHelper.getParentObjectFields(parentRecordId1,null,flexTableConfigData.DataTableDetailConfigMap,flexGridInfoMap));
                } 
            }
            if(flexGridInfo[0].GrandChild2FlexTable__c != null){
                List<DataTableConfig__c> dataTableConfigGH2ist = new List<DataTableConfig__c>();
                DataTableConfig__c flexTableConfigRecord = flexGridInfo[0].GrandChild2FlexTable__r;
                dataTableConfigGH2ist.add(flexTableConfigRecord);
                FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();
                getFlexTableConfigData(dataTableConfigGH2ist, 'GrandChild2', userDetails, accountDetails);

                FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexGridInfo[0].GrandChild2FlexTable__r, false);
                if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                    flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria, parentRecordId1, userDetails, accountDetails);
                }

                flexTableConfigInfoInnerMap.put('FlexTableConfig', flexGridInfo[0].GrandChild2FlexTable__r);
                flexTableConfigInfoInnerMap.put('ColumnNamesList', flexGridInfo[0].GrandChild2FlexTable__r.FieldNames__c);
                Schema.SObjectType dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name);
                //flexGridInfoMap.put('GrandChild2', flexTableConfigInfoInnerMap);
                flexTableConfigInfoInnerMap = new Map<String, Object>();
                flexTableConfigData = (FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get('GrandChild2');
                if(parentRecordId1 != null && String.valueOf(parentRecordId1) != ''){
                    setParentObjectFields.addAll(flexGridEnhancedHelper.getParentObjectFields(parentRecordId1,null,flexTableConfigData.DataTableDetailConfigMap,flexGridInfoMap));
                }
            }
            // get  parent record 
            if(parentRecordId1 != null && String.valueOf(parentRecordId1) != ''){
                parentRecord = flexGridEnhancedHelper.getParentRecord(parentRecordId1, setParentObjectFields, flexGridInfoMap);
            }


            //	Get the NameSpace prefix
            FlexGridEnhancedUtility.FlexGridConfigMetaData flexGridWrapper =new FlexGridEnhancedUtility.FlexGridConfigMetaData(flexGridInfo[0]);
            flexGridInfoMap.put('NameSpacePrefix', AppUtils.getNamespacePrefix());
            flexGridInfoMap.put('FlexGridMetaData',flexGridWrapper);
            flexGridInfoMap.put('IsSpreadSheet',flexGridWrapper.IsSpreadSheet);
            
            parentHeaderLabel=flexGridInfo[0].ParentFlexTable__r.Header__c;
            parentFieldInfoMap = getFieldMetadata(flexGridInfo[0].ParentFlexTable__r,'ParentFlexTable');
            parentTableFieldAPIList = new List<String>();
           
            if(flexGridInfo[0].ParentFlexTable__r.FieldNames__c!= null){
                
                parentTableFieldAPIList =flexGridInfo[0].ParentFlexTable__r.FieldNames__c.Split(',');
            }
                  paramRecordMap=getFlexTableConfigMap('ParentFlexTable');   
                 getFlexTableMetaData();
            //flexGridInfoMap= flexGridInfoMap;
        }

        private List<FlexGridEnhancedUtility.FlexTableListFilterListView> getFlexTableFilterListView(String flexTableId, User userDetails, Account accountDetails){
            List<FlexGridEnhancedUtility.FlexTableListFilterListView> flexTableFilterListViewList = new List<FlexGridEnhancedUtility.FlexTableListFilterListView>();
            List<FlexTableFilterListViewConfig__c> flexTableFilterListViewLists = new List<FlexTableFilterListViewConfig__c>();
            if(FlexTableFilterListViewConfig__c.sObjectType.getDescribe().isAccessible() == true) {
                flexTableFilterListViewLists = mapLevelWiseListViews.get(flexTableId);
                if(flexTableFilterListViewLists != null && flexTableFilterListViewLists.size() > 0){
                    for(FlexTableFilterListViewConfig__c flexTableFilterListView :flexTableFilterListViewLists){

                        FlexGridEnhancedUtility.FlexTableListFilterListView flexListView = new FlexGridEnhancedUtility.FlexTableListFilterListView(flexTableFilterListView);
                        if (flexListView.FilterClause != null){
                            flexListView.FilterClause = replaceAllMergeFields(flexListView.FilterClause,parentRecordId1, userDetails, accountDetails);
                        }

                        flexTableFilterListViewList.add(flexListview);
                    }
                }
            }
            return  flexTableFilterListViewList;
        }

        private Map< String, FlexGridEnhancedUtility.DataTableDetailInfo>  getDataTableDetailConfig(String flexTableId, User userDetails, Account accountDetails){
            Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap = new  Map< String, FlexGridEnhancedUtility.DataTableDetailInfo>();
            if(DataTableDetailConfig__c.sObjectType.getDescribe().isAccessible() == true) {
                List<DataTableDetailConfig__c> dataTableDetailConfigObjList = mapLevelWiseDataTableDetails.get(flexTableId);

                if(dataTableDetailConfigObjList != null && dataTableDetailConfigObjList.size() > 0){
                    for(DataTableDetailConfig__c obj:dataTableDetailConfigObjList){
                        FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetailInfo = new FlexGridEnhancedUtility.DataTableDetailInfo(obj);
                        if(dataTableDetailInfo.WhereClause != null){
                          dataTableDetailInfo.WhereClause = replaceAllMergeFields(dataTableDetailInfo.WhereClause,parentRecordId1, userDetails, accountDetails);
                        }
                        DataTableDetailConfigMap.put(obj.fieldApiName__c, dataTableDetailInfo);
                    }
                }

            }
            return dataTableDetailConfigMap;
        }
        
        private Map<String, Object> getTableMetaData(FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData, DataTableConfig__c flexTableConfig){
            Map<String, Object> flexTableConfigMap = new Map<String, Object>();
            Schema.SObjectType dataTableObjectType = SchemaManager.getSObjectTypeFromName(flexTableConfig.SobjectConfig__r.Name);
            // 1. _______________________________________
            if(flexTableConfig.SobjectConfig__r.Name.containsIgnoreCase('__History')){
                //  Review: Logic for HistoryTable Remaining
            }
            Map<String,Object> fieldInfoMap = new Map<String,Object>();
            // 2. returns the map of flexTableConfigData wrapper class
            if(dataTableObjectType != null){
                Map<String, Object> fieldMetaDataMap = new Map<String, Object>();
                fieldMetaDataMap = getFieldSchemaMetadata(flexTableConfig, dataTableObjectType, flexTableConfigData.dataTableDetailConfigMap);
                flexTableConfigMap.put('FieldMetaData', fieldMetaDataMap.get('FieldMetaData'));
                flexTableConfigMap.put('ColumnNamesList', fieldMetaDataMap.get('ColumnNamesList'));
                flexTableConfigMap.put('QueryFieldsList', fieldMetaDataMap.get('QueryFieldsList'));
                FlexGridEnhancedUtility.FlexTableConfig flexDataConfig = new  FlexGridEnhancedUtility.FlexTableConfig(flexTableConfig, false);
                if(flexDataConfig.FilterCriteria != null && flexDataConfig.FilterCriteria != ''){
                    flexDataConfig.FilterCriteria  = replaceAllMergeFields(flexDataConfig.FilterCriteria, parentRecordId1, userDetails, accountDetails);
                }
                flexTableConfigMap.put('FlexTableConfig',flexDataConfig);
            }
            return flexTableConfigMap;
        }


/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



        //getFieldSchemaMetadata
    /*
        Description : Provides All the Information related to Fields.
    */
    private Map<String,Object> getFieldSchemaMetadata(DataTableConfig__c flexTableConfig,Schema.SObjectType dataTableObjectType, Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap) {
        Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
        Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
        Map<String, Object> retVal = new Map<String, Object>();
        Map<String, Object> fieldMetaData = new Map<String, Object>();
        Set<String> displayFieldsSet = new Set<String>(flexTableConfig.FieldNames__c.split(',',-1));
        Set<String> queryFieldsSet = new Set<String>();
        Set<String> tempQueryFieldsSet = new Set<String>();
        Set<String> additionalRefFieldSet = new Set<String>();       
        List<String> stdObject = new List<String>();
        stdObject.add('ContentDocument');
        stdObject.add('ContentDocumentLink');
        stdObject.add('ContentVersion');
        stdObject.add('CollaborationGroupMember');
        stdObject.add('CollaborationGroupMemberRequest');
        queryFieldsSet.add('Id');

        queryFieldsSet.addAll(displayFieldsSet);
        queryFieldsSet = addQueryFields(queryFieldsSet, dataTableDetailConfigMap,flexTableConfig,stdObject);


        for(String fieldName:queryFieldsSet){
            fieldName = fieldName.trim();
            if(fieldName.containsIgnoreCase(' Desc')){
                fieldName = fieldName.removeEndIgnoreCase(' Desc').trim();
            }
            if(fieldName.containsIgnoreCase(' Asc')){
                fieldName = fieldName.removeEndIgnoreCase(' Asc').trim();
            }

            fieldName = getStandardFieldName(fieldName);
            String actualRelationshipField = removeRelationship(fieldName).trim();
            if(dataObjectFieldsMap.get(actualRelationshipField) == null && dataObjectFieldsMap.get(actualRelationshipField).getDescribe() == null){
                throw new CustomExceptions.InputDataException(fieldName + ' field is not defined on ' + flexTableConfig.SobjectConfig__r.Name);
            }
            Schema.DescribeFieldResult fieldDescribe = dataObjectFieldsMap.get(actualRelationshipField.toLowerCase()).getDescribe();
            FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper = new FlexGridEnhancedUtility.FieldDescribe(fieldDescribe);
            if( fieldName != 'Id' && ((fieldDescribeWrapper.Type == 'REFERENCE' && fieldName.containsNone('.')) || (fieldName.endsWith('Id'))) ){
                if(fieldName == 'RecordTypeId'){
                    additionalRefFieldSet.add('RecordType.Name');
                }else{
                   /* if(!stdObject.contains(flexTableConfig.SobjectConfig__r.Name)){
                         additionalRefFieldSet.add(fieldName.replace('__c','__r')+'.Name');
                    }*/
                    addAdditionalField(fieldName,additionalRefFieldSet);

                }
            }
            FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetailWrapper = dataTableDetailConfigMap.get(fieldName) != null ? dataTableDetailConfigMap.get(fieldName) : null;
            processFieldData(fieldName, fieldDescribe, fieldDescribeWrapper, dataTableDetailWrapper, dataObjectFieldsMap, dataTableObjectType, fieldMetaData);
            if(fieldDescribeWrapper.Type == 'REFERENCE'){
                fieldName = validateStandardRefFields(fieldName);
            }
            tempQueryFieldsSet.add(fieldName);
        }
        queryFieldsSet.clear();
        queryFieldsSet.addAll(tempQueryFieldsSet);
        queryFieldsSet.addAll(additionalRefFieldSet);
        retVal.put('FieldMetaData',fieldMetaData);
        retVal.put('ColumnNamesList',displayFieldsSet);
        retVal.put('QueryFieldsList',queryFieldsSet);
        return retVal;
    }

    /*
        Description : This method handle the creation of MetaData for each Type of Field.
    */
     private void processFieldData(String fieldName, Schema.DescribeFieldResult fieldDescribe,
                                  FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper,
                                  FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetailWrapper,
                                  Map<String,Schema.SObjectField> dataObjectFieldsMap,
                                  Schema.SObjectType dataTableObjectType, Map<String, Object> fieldMetaDataMap){

        //Get the Info of Reference Field
        if(fieldDescribe.getType() == Schema.DisplayType.Reference) {
            fieldDescribeWrapper.ReferenceFieldInfo = getRefFieldMetadata(dataTableObjectType, fieldName, dataTableDetailWrapper);
        }
        //Get the Info of PickList Field
        else if(fieldDescribe.getType() == Schema.DisplayType.Picklist || fieldDescribe.getType() == Schema.DisplayType.MultiPicklist){
            fieldDescribeWrapper.PickListFieldInfo = getPickListInfo(fieldDescribe, fieldDescribeWrapper);
        }
        if(fieldDescribeWrapper.Type == 'REFERENCE'){
            fieldName = validateStandardRefFields(fieldName);
            if(fieldName == 'RecordTypeId'){
                fieldName = 'RecordType';
            }
        }

        fieldMetaDataMap.put(fieldName,fieldDescribeWrapper);
    }

    /*
    Description: Check the References field level and return the related reference object and
                 field name in Map.
    */

    private Map<String,Object> processReferenceField(Schema.SObjectType sObjectType, String fieldName){
        Map <String, Object> referenceFieldInfoMap = new Map<String, Object>();
        // Splitting the fieldName withn '.' as Reference Fields always have '.'
        List<String> splitFieldsList = fieldName.split('\\.',-1);
        Integer length = splitFieldsList.size();
        String referenceField = fieldName;
        // if length > 1 it means Reference Field is multi levele Reference Fields
        if(length > 1){
            for(String splittedField : splitFieldsList){
                splittedField = splittedField .replace('__r','__c');
                referenceField = splittedField;
                if(!splittedField.equalsIgnoreCase('Name') && !splittedField.endsWithIgnoreCase('Id') && splittedField.containsNone('__c')){
                    //splittedField = splittedField + 'Id';
                    splittedField = getStandardFieldName(splittedField);
                }
                if(!(splittedField.equals(splitFieldsList[length-1]))){
                    Schema.DescribeSObjectResult dataTableObjectResult = sObjectType.getDescribe();
                    Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
                    Schema.SObjectField sobjfield= dataObjectFieldsMap.get(splittedField);
                    Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();
                    List<Schema.SObjectType> sobjTypeList = fieldDescribe.getReferenceTo();
                    sObjectType  = sobjTypeList [0];
                }
            }
        }
        referenceFieldInfoMap.put('ReferencedObject', sObjectType);
        referenceFieldInfoMap.put('ReferencedField', referenceField);
        return referenceFieldInfoMap;
    }


    /*
        Description : add the Field in QueryList if its not in fieldNames and present in DataTableDetail's DisplayField.
    */
    private Set<String> addQueryFields(Set<String> queryFieldsSet, Map< String, FlexGridEnhancedUtility.DataTableDetailInfo> dataTableDetailConfigMap, DataTableConfig__c flexTableConfig ,List<String> stdObject){
        if(!stdObject.contains(flexTableConfig.SobjectConfig__r.Name)){
            queryFieldsSet.add('LastModifiedDate');
        }
        if(String.isNotEmpty(flexTableConfig.OrderBy__c)){
            queryFieldsSet.addAll(new set<string>(flexTableConfig.OrderBy__c.split(',')));
        }

        for(String  fieldAPIName:dataTableDetailConfigMap.keySet()){
            if(fieldAPIName != null){
                // 1. Add DisplayField in query.
                FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetail  =  dataTableDetailConfigMap.get(fieldAPIName);
                if(!queryFieldsSet.contains(fieldAPIName)){
                    queryFieldsSet.add(fieldAPIName);
                }
                String field = dataTableDetail.DisplayField;
                if(String.isNotEmpty(field)){
                    String refField = fieldAPIName.replace('__c','__r');
                    field = refField+'.'+field;
                    if(!queryFieldsSet.contains(field)){
                        queryFieldsSet.add(field);
                    }
                }
            }
        }
        return queryFieldsSet;
    }

     private void addAdditionalField(String fieldName,Set<String> additionalRefFieldSet){
        String field = fieldName.toLowerCase();
        switch on field{
            when 'lastmodifiedbyid','lastmodifiedbyid.id'{
                additionalRefFieldSet.add('LastModifiedBy.Name');
            }
            when 'createdbyid','createdbyid.id'{
                additionalRefFieldSet.add('CreatedBy.Name');
            }
            when 'recordtypeid','recordtypeid.id'{
                additionalRefFieldSet.add('RecordType.Name');
            }
            when 'accountid','accountid.id','account'{
                additionalRefFieldSet.add('Account.Name');
            }
            when 'ownerid','ownerid.id'{
                additionalRefFieldSet.add('Owner.Name');
            }
            when 'parentid','parentid.id'{
                additionalRefFieldSet.add('Parent.Name');
            } 
            when else{
                if(field.containsNone('.')){
                    additionalRefFieldSet.add(fieldName.replace('__c','__r')+'.Name');   
                }else{
                    if(field.contains('.')){
                        String[] splittedFields = field.split('\\.');
                         if(splittedFields.size() > 1 && (field.endsWithIgnoreCase('.Id') || field.endsWithIgnoreCase('Id.Id'))){
                            if(field.endsWithIgnoreCase('Id.Id')){
                                fieldName = field.replace('id.id', '.Name');
                            } else if(field.endsWithIgnoreCase('.Id')){
                                fieldName = field.replace('.id', '.Name');
                            }
                            additionalRefFieldSet.add(fieldName);
                        } 
                    }
                }
            }
        }   
    }

    
    /*
        Description : get the Standard Field API Name
    */
    private String getStandardFieldName(String fieldName){
        List<String> splitFields = fieldName.split('\\.',-1);
        List<String> resultList = new List<String>();
            for(String splittedFieldName : splitFields){
                splittedFieldName = splittedFieldName.equalsIgnoreCase('Owner') ? 'OwnerId' :
                splittedFieldName.equalsIgnoreCase('CreatedBy') ? 'CreatedById' :
                splittedFieldName.equalsIgnoreCase('What') ? 'WhatId' :
                splittedFieldName.equalsIgnoreCase('LastModifiedBy') ? 'LastModifiedById' :
                splittedFieldName.equalsIgnoreCase('Parent') ? 'ParentId' :
                splittedFieldName.equalsIgnoreCase('Actor') ? 'ActorId' :
                splittedFieldName.equalsIgnoreCase('Group') ? 'GroupId' :
                splittedFieldName.equalsIgnoreCase('ProcessInstance') ? 'ProcessInstanceId' :
                splittedFieldName.equalsIgnoreCase('SetupOwner') ? 'SetupOwnerId' :
                splittedFieldName.equalsIgnoreCase('Contact') ? 'ContactId' :
                  splittedFieldName.equalsIgnoreCase('Account') ? 'AccountId' :
                splittedFieldName.equalsIgnoreCase('RecordType') ? 'RecordTypeId' :
                splittedFieldName.equalsIgnoreCase('ContentDocument') ? 'ContentDocumentId' :
                splittedFieldName.equalsIgnoreCase('LinkedEntity') ? 'LinkedEntityId' :
                splittedFieldName.equalsIgnoreCase('ContentVersion') ? 'ContentVersionId' :
                splittedFieldName.equalsIgnoreCase('CollaborationGroup') ? 'CollaborationGroupId' :
                splittedFieldName.equalsIgnoreCase('Member') ? 'MemberId' :
                splittedFieldName.equalsIgnoreCase('Requester') ? 'RequesterId' :
                splittedFieldName;
                resultList.add(splittedFieldName);
            }
        fieldName = String.join(resultList,'.');
        return fieldName;
    }

    private String validateStandardRefFields(String fieldName){
        if(fieldName.contains('RecordTypeId.')){
            fieldName = fieldName.replace('RecordTypeId','RecordType');
        }
        if(fieldName.contains('ContentDocumentId.')){
            fieldName = fieldName.replace('ContentDocumentId','ContentDocument');
        }
        if(fieldName.contains('LinkedEntityId.')){
            fieldName = fieldName.replace('LinkedEntityId','LinkedEntity');
        }
        if(fieldName.contains('LastModifiedById.')){
            fieldName = fieldName.replace('LastModifiedById','LastModifiedBy');
        }
        if(fieldName.contains('CreatedById.')){
            fieldName = fieldName.replace('CreatedById','CreatedBy');
        }
        if(fieldName.contains('LinkedEntityId.')){
            fieldName = fieldName.replace('LinkedEntityId','LinkedEntity');
        }
        if(fieldName.contains('CollaborationGroupId.')){
            fieldName = fieldName.replace('CollaborationGroupId','CollaborationGroup');
        }
        if(fieldName.contains('MemberId.')){
            fieldName = fieldName.replace('MemberId','Member');
        }
        if(fieldName.contains('RequesterId.')){
            fieldName = fieldName.replace('RequesterId','Requester');
        }
        if(fieldName.contains('OwnerId.')){
            fieldName = fieldName.replace('OwnerId','Owner');
        }
        if(fieldName.contains('ParentId.')){
            fieldName = fieldName.replace('ParentId','Parent');
        }
        if(fieldName.contains('ProfileId.')){
            fieldName = fieldName.replace('ProfileId','Profile');
        }
        if(fieldName.contains('AccountId.')){
            fieldName = fieldName.replace('AccountId','Account');
        }
        return fieldName;
    }

    
    /*
        Description : replace the __r for Reference Field to __c to get the actual field name instead of its relationship name
    */
    private String removeRelationship(String relationshipField){
        relationshipField = relationshipField.replace('__r','__c');
        List<String> relationshipFieldList = relationshipField.split('\\.');
        relationshipField = relationshipFieldList[0];
        return relationshipField;
    }

    /*
        Descritpion :   Provide MetaData for REFERENCE fields.
    */
    public FlexGridEnhancedUtility.FieldDescribe getRefFieldMetadata(Schema.SObjectType sobjectType,String fieldName, FlexGridEnhancedUtility.DataTableDetailInfo dataTableDetail) {
        Map<String, Object> referenceFieldInfoMap = processReferenceField( sobjectType, fieldName);
        FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper = new FlexGridEnhancedUtility.FieldDescribe ();
        Schema.SObjectType referencedObject = (Schema.SObjectType)referenceFieldInfoMap.get('ReferencedObject');
        String referencedFieldName = String.valueOf(referenceFieldInfoMap.get('ReferencedField'));
        Schema.DescribeSObjectResult sObjDescribe = referencedObject.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = sObjDescribe.fields.getMap();
        Schema.SObjectField sObjField = fieldsMap.get(referencedFieldName);
        if(sObjField == null){
            throw new CustomExceptions.InputDataException(referencedFieldName + ' field is not defined on ' + referencedObject);
        }
        Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();
        Map<String, Object> retVal = new Map<String, Object>();
        String csfieldName = referencedObject+'.'+referencedFieldName;
        String fieldLabel = null;
        String fieldLabelOverride =null;
        fieldLabel = getStandardFieldLabel(fieldDescribe.getLabel());
        if(dataTableDetail != null && dataTableDetail.FieldLabelOverride != null) {
            fieldLabel = dataTableDetail.FieldLabelOverride;
        }
        fieldDescribeWrapper.Label = fieldLabel;
        fieldDescribeWrapper.Name = referencedFieldName;
        fieldDescribeWrapper.Type = String.valueOf(fieldDescribe.Type);
        fieldDescribeWrapper.IsFilterable = fieldDescribe.isFilterable();
        fieldDescribeWrapper.IsUpdateable = Boolean.valueOf(fieldDescribe.isUpdateable());
        fieldDescribeWrapper.IsUpdateable = fieldDescribe.isAutoNumber();
        fieldDescribeWrapper.IsFormulaField = fieldDescribe.isCalculated();
        fieldDescribeWrapper.FieldPath = fieldName;
        fieldDescribeWrapper.Scale = fieldDescribe.Scale;
        if(fieldDescribe.getType()+'' == 'PICKLIST'){
            List<String> pickListOptions = new List<String>();
            Map<String, Object> pickListInfoMap = new Map<String, Object>();
            List<Map<String,String>> pickListKeyValueMapList = new List<Map<String,String>>();
            Map<String,String> pickListKeyValueMap = new Map<String,String>();
            Map<String,String> fieldPickListValueLabelMap = new Map<String,String>();
            
            for(Schema.PicklistEntry pe:fieldDescribe.getPicklistValues()){
                    pickListOptions.add(pe.getLabel()+'');
                    pickListKeyValueMap = new Map<String,String>();
                    pickListKeyValueMap.put('Label',pe.getLabel()+'');
                    pickListKeyValueMap.put('Value',pe.getValue()+'');
                    pickListKeyValueMapList.add(pickListKeyValueMap);
                    fieldPickListValueLabelMap.put(pe.getValue()+'',pe.getLabel()+'');

            }
            pickListInfoMap.put('PicklistValues',pickListOptions);
            pickListInfoMap.put('PickListKeyValueMapList',pickListKeyValueMapList);
            pickListInfoMap.put('FieldPicklistValueLabelMap',fieldPickListValueLabelMap);
            fieldDescribeWrapper.PicklistValues = pickListOptions;
            fieldDescribeWrapper.PickListFieldInfo= pickListInfoMap;
        }

        return fieldDescribeWrapper;
    } 

    /*
        Description : get the Standard Field Label
    */
    private String getStandardFieldLabel(String fieldLabel){
        fieldLabel = (fieldLabel.equalsIgnoreCase('CreatedById')) ? Label.CreatedBy :
                                (fieldLabel.equalsIgnoreCase('LastModifiedById')) ? Label.LastModifiedBy :
                                (fieldLabel.equalsIgnoreCase('ContactId')) ? Label.Contact :
                                (fieldLabel.equalsIgnoreCase('OwnerId')) ? Label.AssignedTo :
                                (fieldLabel.equalsIgnoreCase('RecordTypeId')) ? Label.RecordType :
                                (fieldLabel.equalsIgnoreCase('ActivityDate')) ? Label.DueDate :
                                fieldLabel;
        return fieldLabel;
    }

    private Map<String, Object>  getPickListInfo(Schema.DescribeFieldResult flexGriFieldDescribe, FlexGridEnhancedUtility.FieldDescribe fieldDescribeWrapper){
        Map<String, Object> pickListInfoMap = new Map<String, Object>();
        List<String> pickListOptions = new List<String>();
        List<Map<String,String>> pickListKeyValueMapList = new List<Map<String,String>>();
        Map<String,String> fieldPickListValueLabelMap = new Map<String,String>();
        Map<String,String> pickListKeyValueMap = new Map<String,String>();
        //pickListKeyValueMap.put('Label','--None--');
        //pickListKeyValueMap.put('Value',null);
        //pickListKeyValueMapList.add(pickListKeyValueMap);
        for(Schema.PicklistEntry pe:flexGriFieldDescribe.getPicklistValues()){
            pickListOptions.add(pe.getLabel()+'');
            pickListKeyValueMap = new Map<String,String>();
            pickListKeyValueMap.put('Label',pe.getLabel()+'');
            pickListKeyValueMap.put('Value',pe.getValue()+'');
            pickListKeyValueMapList.add(pickListKeyValueMap);
            fieldPickListValueLabelMap.put(pe.getValue()+'',pe.getLabel()+'');
        }
        pickListInfoMap.put('PicklistValues',pickListOptions);
        pickListInfoMap.put('PickListKeyValueMapList',pickListKeyValueMapList);
        pickListInfoMap.put('FieldPicklistValueLabelMap',fieldPickListValueLabelMap);
        return pickListInfoMap;
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////



        private void getFlexTableConfigData(List<DataTableConfig__c> flexTableConfigList, String flexTableLevel, User userDetails, Account accountDetails){

            if(flexTableConfigList != null && flexTableConfigList.size() > 0){
                for(DataTableConfig__c flexTableConfig: flexTableConfigList){
            FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData = new FlexGridEnhancedUtility.FlexTableConfigData();

            flexTableConfigData.DataTableDetailConfigMap = getDataTableDetailConfig(flexTableConfig.Id, userDetails, accountDetails);

            // 3. return Map of FlexTableFilterListView Configs
            flexTableConfigData.FlexTableFilterListViewList = getFlexTableFilterListView(flexTableConfig.Id, userDetails, accountDetails);
             // 4. map of display fields and its metadata info
            flexTableConfigData.FlexTableConfigMap = getTableMetaData(flexTableConfigData,flexTableConfig);
            // 5. returns all the config data for flex table
            flexGridInfoMap.put(flexTableLevel,flexTableConfigData);
        }
            }
        }



        private Map<String, Map<String, String>> getUserAccountfieldsMap(String filterString) {
            Map<String, Map<String, String>> userAccountfieldsMap = new Map<String, Map<String, String>>();
            Map<String, String> userFieldsMap = new Map<String, String>();
            Map<String, String> acctFieldsMap = new Map<String, String>();
            
            //String filterString = flexTableFilterListView.FilterClause__c;
            if(filterString != null){                   
                Pattern regexForExtractingUserFields = Pattern.compile('\\{!((U|u)(S|s)(E|e)(R|r)\\.[a-zA-Z0-9\\.\\_]+)\\}');
                Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(filterString);
                
                while (regexMatcherForExtractingUserTokens.find()){
                    String userToken = regexMatcherForExtractingUserTokens.group();
                    
                    if(userToken != null && userToken.length() > 7) {
                        String userTokenAfterRemove = userToken.substring(2,userToken.length()-1);
                        List<String> userSplitField = userTokenAfterRemove.split('\\.', 2);
                        userFieldsMap.put(userToken, userSplitField[1]);
                    }
                }
                
                Pattern regexForExtractingAccountFields = Pattern.compile('\\{!(Account\\.[a-zA-Z0-9\\.\\_]+)\\}');
                Matcher regexMatcherForExtractingAccountTokens = regexForExtractingAccountFields.matcher(filterString);

                while (regexMatcherForExtractingAccountTokens.find()){
                    String accountToken = regexMatcherForExtractingAccountTokens.group();

                    if(accountToken != null && accountToken.length() > 7) {
                        String accountTokenAfterRemove = accountToken.substring(2,accountToken.length()-1);
                        List<String> accountSplitField = accountTokenAfterRemove.split('\\.', 2);
                        acctFieldsMap.put(accountToken, accountSplitField[1]);
                    }
                }
            }

            userAccountfieldsMap.put('User', userFieldsMap);
            userAccountfieldsMap.put('Account', acctFieldsMap);

            return userAccountfieldsMap;
        }



        private String replaceAllMergeFields(String filterString, String parentRecordId, User userDetails, Account accountDetails){
            
            if(userDetails != null && userFieldsToQueryMap.size() > 0){
                for(String strMergeField : userFieldsToQueryMap.keySet()) {
                    String fieldValue = userMergeFieldsValueMap.get(strMergeField);
                    if(fieldValue != null) {
                        filterString = filterString.replace(strMergeField, String.escapeSingleQuotes(fieldValue));
                    } else {
                        filterString = filterString.replace(strMergeField, '');
                    }
                }
            }

            if(accountDetails != null && acctFieldsToQueryMap.size() > 0){
                for(String strMergeField : acctFieldsToQueryMap.keySet()) {
                    String fieldValue = acctMergeFieldsValueMap.get(strMergeField);
                    if(fieldValue != null) {
                        filterString = filterString.replace(strMergeField, String.escapeSingleQuotes(fieldValue));
                    } else {
                        filterString = filterString.replace(strMergeField, '');
                    }
                }
            }

            if (parentRecordId != null && parentRecordId != ''){
                filterString = AppUtils.replaceRecordMergeFields(filterString, String.escapeSingleQuotes(parentRecordId));
            }
            return filterString;
        }

          // get config of table 
        Map<string, Object> getFlexTableConfigMap(String level){
            FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
            
            // get all required value for query 
            Map <String, Object> FlexTableConfigMap=flexTableConfigData.FlexTableConfigMap;

            FlexGridEnhancedUtility.FlexTableConfig FlexTableConfigObj=(FlexGridEnhancedUtility.FlexTableConfig)FlexTableConfigMap.get('FlexTableConfig');
            Map<string, Object> flextableconfig = new Map<string, Object>();
            // create pramJson to pass getPageRecords() of helper
            if(!String.isEmpty(FlexTableConfigObj.OrderBy) && FlexTableConfigObj.OrderBy.contains(',')){
                FlexTableConfigObj.SortDirection='';
            }
            if(String.isBlank((String)FlexTableConfigObj.OrderBy)){
                FlexTableConfigObj.OrderBy = 'LastModifiedDate';
            }
            flextableconfig.put('sObjectName',FlexTableConfigObj.SObjectName);
            flextableconfig.put('queryFieldsList',FlexTableConfigMap.get('QueryFieldsList'));
            flextableconfig.put('filterCriteria',getFilterClause(level));
            flextableconfig.put('sortDirection',FlexTableConfigObj.SortDirection);
            // if(!FlexTableConfigObj.OrderBy.containsIgnoreCase('desc')){
            //     flextableconfig.put('sortableColumn',FlexTableConfigObj.OrderBy +' , Id');
            // }else{
            flextableconfig.put('sortableColumn',FlexTableConfigObj.OrderBy);
           // }            
            flextableconfig.put('hideDecisionFields',null);
            flextableconfig.put('pageNumber',1);
            flextableconfig.put('pageSize',null);
            flextableconfig.put('offSet',null);
            String exportLimit = KeyValueHolderHelper.getTextValue('childGridExportLimit');
            if(String.isNotBlank(exportLimit)) {
                flextableconfig.put('limitValue', Integer.valueOf(exportLimit)); 
            } else {
                flextableconfig.put('limitValue',999); 
            }
            flextableconfig.put('GroupByCluase',null);
            flextableconfig.put('parentRecordId',parentRecordId1);

            return flextableconfig;
        }

        // retuen map of level and its metadata
       
       void getFlexTableMetaData(){

            for (String key : flexGridInfoMap.keySet()){
                Map<String, boolean> columnNameVsEnableOverallToatal= new Map<String, boolean>();
                Map<string, Map<string, string>> fieldVsFormulaJsonMap = new Map<string, Map<string, string>>();
                if(key=='ParentFlexTable' || key=='Child1' || key=='Child2' || key=='GrandChild1' || key=='GrandChild2'){     
                    FlexGridEnhancedUtility.FlexTableConfigData configData = (FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(key);   
                    Map <String, Object> FlexTableConfigMapVar=configData.FlexTableConfigMap; 
                    Object metaData=FlexTableConfigMapVar.get('FieldMetaData');
                    flexTableMetaData.put(key,metaData);
                    tableWithParentRecord.put(key,configData.ParentRecord);
					Map<String,String> columnNameVsDataType = new Map<String,String>();
                    Set<String> ColumnNamesList=(Set<String>)FlexTableConfigMapVar.get('ColumnNamesList');                    
                    for(String columnName: ColumnNamesList){
                        Boolean isReferenceField;
                        String referanceFieldAPIName;
                        if(columnName.containsIgnoreCase('.')){ 

                            isReferenceField=true;  
                            referanceFieldAPIName= columnName;     
                            
                        }
                        Map<String,String> formulaJSONMap = new Map<String,String>();
                        if(configData.DataTableDetailConfigMap.get(columnName)!=null){
                           columnNameVsEnableOverallToatal.put(columnName,configData.DataTableDetailConfigMap.get(columnName).EnableOverAllTotal); 
                            if(configData.DataTableDetailConfigMap.get(columnName).Formula !=null && configData.DataTableDetailConfigMap.get(columnName).Formula.containsIgnoreCase('GRANDTOTAL')){
                                Map<String,Object> formulaMap = (Map<string, Object>)JSON.deserializeUntyped(configData.DataTableDetailConfigMap.get(columnName).Formula);
                                if(formulaMap.get('GRANDTOTAL')!=null){
                                    String text=(String)formulaMap.get('GRANDTOTAL');
                                    if(text.equals('SUM()')){
                                        text = '';
                                    }else{
                                        text = text.substringBetween('TEXT(',')');
                                        if(text==null){
                                             text = '';
                                        }
                                    }
                                    formulaJSONMap.put('GRANDTOTAL',text);                                    
                                }                            
                            }else{
                                formulaJSONMap.put('GRANDTOTAL','false');                       
                            }
                            // get colounnm and its data type   
                            if(configData.DataTableDetailConfigMap.get(columnName).DisplayField !=null){
                                string displayFieldAPI = columnName.replace('__c', '__r') + '.' + configData.DataTableDetailConfigMap.get(columnName).DisplayField;
                                columnNameVsDataType.put(columnName,(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(key)).get(displayFieldAPI)).ReferenceFieldInfo.Type);
                            }else{
                                if(isReferenceField== true){
                                     columnNameVsDataType.put(columnName,(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(key)).get(referanceFieldAPIName)).ReferenceFieldInfo.Type);
                               
                                }else{
                                    columnNameVsDataType.put(columnName,(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(key)).get(columnName)).Type);
                                }
                            }

                        }else{
                            columnNameVsEnableOverallToatal.put(columnName.trim(),false);
                            formulaJSONMap.put('GRANDTOTAL','false');
                            if(isReferenceField== true){
                                columnNameVsDataType.put(columnName,(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(key)).get(referanceFieldAPIName)).ReferenceFieldInfo.Type);
                            }else{
                                columnNameVsDataType.put(columnName,(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(key)).get(columnName)).Type);
                            }
                        }                                               
                        fieldVsFormulaJsonMap.put(columnName,formulaJSONMap);
                    }
                    levelVsFieldVsHideCellIdMap.put(key,new Map<String,List<String>>());
                    overAllTotalMap.put(key,new Map<String,String>());
                    levelVsFieldVsOverallLabelMap.put(key,fieldVsFormulaJsonMap);
                    levelVsFieldVsDataTypeMap.put(key,columnNameVsDataType);
                }
                levelVsColumnEnableOverAllTotal.put(key,columnNameVsEnableOverallToatal);
            }
           //return flexTableMetaData;
        }

        private void getMergFieldData(){
            String keyValueMapString = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('flexTableParam'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            String listKeyValueMapString = SFDCEncoder.sanitizeJSON(ApexPages.currentPage().getParameters().get('listParm')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            String recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('id')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            
            mergeFieldsKeyValueMap = new Map<String, Object>();
           if(!String.isEmpty(keyValueMapString)){   
                keyValueMapString = EncodingUtil.urlDecode(keyValueMapString,'UTF-8');                                          
                mergeFieldsKeyValueMap.putAll((Map<string,object>)JSON.deserializeUntyped(keyValueMapString));            
            }
            if(!String.isEmpty(listKeyValueMapString) ){
            	listKeyValueMapString =  EncodingUtil.urlDecode(listKeyValueMapString,'UTF-8');
                mergeFieldsKeyValueMap.putAll((Map<string,object>)JSON.deserializeUntyped(listKeyValueMapString));
            }
            
    
            if(FlexLayoutPrintGenerator.isFormSelected) {
                mergeFieldsKeyValueMap.put('parentId', recordId);
                mergeFieldsKeyValueMap.put('recordId', (String)FlexLayoutPrintGenerator.selectedLayoutHolder.formRecordMap.get(FlexLayoutPrintGenerator.selectedLayotId).get('Id'));
                mergeFieldsKeyValueMap.put('RecordId', (String)FlexLayoutPrintGenerator.selectedLayoutHolder.formRecordMap.get(FlexLayoutPrintGenerator.selectedLayotId).get('Id'));
            }  else {
                mergeFieldsKeyValueMap.put('RecordId', recordId);
            }  
        }

        // This method check all List view of table for showInPdf and return filter clause
        String getFilterClause(String level){
            Boolean noShowInPdf = false;
            Integer showInPdfCnt=0;
            Integer activeListViewCnt= 0;
            Boolean isMasterPresent=false;
            String filterClause='';
			String listViewLabel='';
            String masterListViewLabel='';
             String relationshipField='';
            String masterFilterClause='';
            String activeListFilterClause='';
            String activeListViewLabel='';
            FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
            List<FlexGridEnhancedUtility.FlexTableListFilterListView> FlexTableFilterListViewList=flexTableConfigData.FlexTableFilterListViewList;
            Map <String, Object> FlexTableConfigMap=flexTableConfigData.FlexTableConfigMap;
            FlexGridEnhancedUtility.FlexTableConfig FlexTableConfigObj=(FlexGridEnhancedUtility.FlexTableConfig)FlexTableConfigMap.get('FlexTableConfig');
            Id FlexTableConfigId =FlexTableConfigObj.FlexTableId;
            String userListViewFilterClause;
            String userListViewLabel;
            String currentUserId = UserInfo.getUserId();
            List<FlexTableListViewUserConfig__c> lstFlexTableFilterUserListView = New List<FlexTableListViewUserConfig__c>();
            if(FlexTableConfigId != null){
               lstFlexTableFilterUserListView =[SELECT Id,Name,User__c,FlexTableListViewConfig__r.FilterClause__c,FlexTableListViewConfig__r.Label__c FROM FlexTableListViewUserConfig__c WHERE User__c = :currentUserId and FlexTableConfig__r.id =:FlexTableConfigId WITH USER_MODE  ORDER BY LastModifiedDate   LIMIT 1];

            }
            if(sessionListViewId != null){
                for(Integer i=0;i<FlexTableFilterListViewList.size();i++){
                    if(FlexTableFilterListViewList[i].IsActive && FlexTableFilterListViewList[i].ListViewId == sessionListViewId){
                       userListViewFilterClause = FlexTableFilterListViewList[i].FilterClause;
                        userListViewLabel = FlexTableFilterListViewList[i].Label; 
                    }
                }
            }else{

            
           if(lstFlexTableFilterUserListView.size() > 0) {
                for(FlexTableListViewUserConfig__c listViewUser : lstFlexTableFilterUserListView) {
                    if(listViewUser.FlexTableListViewConfig__r.FilterClause__c != Null) {
                        userListViewFilterClause = listViewUser.FlexTableListViewConfig__r.FilterClause__c;
                        userListViewLabel = listViewUser.FlexTableListViewConfig__r.Label__c;
                     }
                }                                                          
            }
        }
            if(level=='Child1'){
                if(flexGridInfo[0].Child1FlexTable__r.ParentTargetLookupField__c!=null){
                relationshipField = flexGridInfo[0].Child1FlexTable__r.ParentTargetLookupField__c;
                filterClause= relationshipField+' in:parentTargetField';
                 }
             }
             if(level=='Child2'){
                if(flexGridInfo[0].Child2FlexTable__r.ParentTargetLookupField__c!=null){
                relationshipField = flexGridInfo[0].Child2FlexTable__r.ParentTargetLookupField__c;
                filterClause= relationshipField+' in:parentTargetField';
                 }
             }
             if(level=='GrandChild1'){
                if(flexGridInfo[0].GrandChild1FlexTable__r.ParentTargetLookupField__c!=null){
                relationshipField = flexGridInfo[0].GrandChild1FlexTable__r.ParentTargetLookupField__c;
                filterClause= relationshipField+' in:parentTargetField';
                 }
             }
              if(level=='GrandChild2'){
                if(flexGridInfo[0].GrandChild2FlexTable__r.ParentTargetLookupField__c!=null){
                relationshipField = flexGridInfo[0].GrandChild2FlexTable__r.ParentTargetLookupField__c;
                filterClause= relationshipField+' in:parentTargetField';
                 }
             } 
            for(Integer i=0;i<FlexTableFilterListViewList.size();i++){
                if(FlexTableFilterListViewList[i].IsActive){   
                    activeListViewCnt++;
                    if(FlexTableFilterListViewList[i].ShowInPdf){
                        showInPdfCnt++;
                        if(level!='ParentFlexTable'){
                            filterClause+= ' and'+' '+FlexTableFilterListViewList[i].FilterClause;
                        }else{
                            filterClause+= FlexTableFilterListViewList[i].FilterClause;
                       }
                       listViewLabel=FlexTableFilterListViewList[i].Label;
                       tableHeaderMap.put(level,listViewLabel);
                    }
                    if(FlexTableFilterListViewList[i].IsMasterView){
                        masterFilterClause=FlexTableFilterListViewList[i].FilterClause; 
                        masterListViewLabel=FlexTableFilterListViewList[i].Label;   
                        isMasterPresent=true;                         
                    }else{
                       activeListFilterClause=FlexTableFilterListViewList[i].FilterClause;
                       activeListViewLabel= FlexTableFilterListViewList[i].Label;
                    }
                }                   
            }
            if(FlexTableFilterListViewList.size()<1 || activeListViewCnt<1 || (activeListViewCnt>1 && isMasterPresent==false && showInPdfCnt<1)){
                if(level!='ParentFlexTable' && FlexTableConfigObj.FilterCriteria!=null){
                    if(userListViewFilterClause!= null && showInPdfCnt<1){
                        filterClause=' and'+' '+userListViewFilterClause;
                        masterListViewLabel=userListViewLabel;  
                    }else{
                        filterClause+= ' and'+' '+FlexTableConfigObj.FilterCriteria;
                    }
                    }else{
                        if(userListViewFilterClause!= null && showInPdfCnt<1){
                            filterClause= userListViewFilterClause;
                            masterListViewLabel=userListViewLabel;  
                    }else{
                        filterClause= FlexTableConfigObj.FilterCriteria;

                        }
                }
            }else{
                if(showInPdfCnt>1 || showInPdfCnt<1){             
                  
                     if(level!='ParentFlexTable'){
                         if(userListViewFilterClause!= null && showInPdfCnt<1){
                            filterClause= relationshipField+' in:parentTargetField and'+' '+userListViewFilterClause;
                            masterListViewLabel=userListViewLabel;  
                        }else{
                         filterClause= relationshipField+' in:parentTargetField and'+' '+masterFilterClause;
                        }
                     }else{
                         if(userListViewFilterClause!= null && showInPdfCnt<1){
                            filterClause= userListViewFilterClause;
                            masterListViewLabel=userListViewLabel;  
                     }else{
                         filterClause= masterFilterClause;
                     }
                     }
                     tableHeaderMap.put(level,masterListViewLabel);
                }
                if(activeListViewCnt==1 && isMasterPresent==false){
                    if(level!='ParentFlexTable'){
                         filterClause= relationshipField+' in:parentTargetField and'+' '+activeListFilterClause;
                     }else{
                         filterClause=activeListFilterClause;
                     }
                     tableHeaderMap.put(level,activeListViewLabel);                   
                }
               
            }
            if(filterClause != null && filterClause.contains('{!parentId}')){
                if(level!='ParentFlexTable'){
                        
                        //filterClause= filterClause.replace('=\'{!parentId}\'',' in:parentTargetField'); 
                        filterClause=filterClause.replaceAll('\\{!parentId\\}', 'parentId');
                        Pattern regexForExtractingTokens = Pattern.compile('=( )*\'parentId\''); 
                        Matcher regexMatcherForExtractingTokens = regexForExtractingTokens.matcher(filterClause);
                        while (regexMatcherForExtractingTokens.find()){         
                            String operatorToken = regexMatcherForExtractingTokens.group();
                            //it should contain space
                        filterClause= regexMatcherForExtractingTokens.replaceAll(' in:parentTargetField'); 
                    }
                }            
            }

            if(filterClause != null){
                filterClause=getMergefieldObj.getFilterClauseString(filterClause, mergeFieldsKeyValueMap,false);
            }            
         
            return filterClause;
        }

        // remove hide coloumn from api list
       /* Set<string> removeHideColumn(List<String >tableFieldAPIList,sObject record,Map<String,String> hideColumnMap){
             Set<String> tableFieldAPISet= new Set<String>();
            tableFieldAPISet.addAll(tableFieldAPIList);
           
            for(String apiName:tableFieldAPISet){
                if(hideColumnMap.get(apiName)!=null && record!=null){
                    ExpressionJSONEvaluator.recordMap = new  Map<String,sObject>();
                    Boolean expressionResult=  ExpressionJSONEvaluator.evaluateExpression(hideColumnMap.get(apiName), record, ' ');
                    if(expressionResult){
                       tableFieldAPISet.remove(apiName);
                    }                           
                }
            }
            
            return tableFieldAPISet;
        }*/
        Set<string> removeHideColumn(List<String >tableFieldAPIList,sObject record,Map<String,String> hideColumnMap ,Map<String,Boolean> parentHideGroupingColumns){
            Set<String> tableFieldAPISet= new Set<String>();
           tableFieldAPISet.addAll(tableFieldAPIList);
           for(String apiName:tableFieldAPISet){
               if(hideColumnMap.get(apiName)!=null && record!=null){
                   ExpressionJSONEvaluator.recordMap = new  Map<String,sObject>();
                   Boolean expressionResult=  ExpressionJSONEvaluator.evaluateExpression(hideColumnMap.get(apiName), record, ' ');
                   if(expressionResult){
                      tableFieldAPISet.remove(apiName);
                   }                           
               }
               if(parentHideGroupingColumns.get(apiName) == true && record!=null ){
                    tableFieldAPISet.remove(apiName);
               }
           }
           return tableFieldAPISet;
       }

        // Replace Parentid mearge field with value
        private String replaceParentMergeField(String filterString, FlexGridEnhancedUtility.InitParams initParams){
            if(filterString.contains('{!parentId}')){
                filterString.replace('{!parentId}',parentRecordId1);
            }
            return filterString;
        }

       

        // this method use to render parent table of grid
        private Component.Apex.OutputPanel renderGrid() {
        // Render on Pdf Type for Grid. 
        Boolean isParent = true;
        String renderType = 'Parent';
        List<Sobject> sobjVal = new List<Sobject>();
        if(flexGridInfo[0].ParentFlexTable__r.PDFRenderType__c != 'Block' && mode =='pdf'){
        parentHeaderLabel=tableHeaderMap.get('ParentFlexTable');
           return renderTable(parentHeaderLabel, flexGridInfo[0].ParentFlexTable__r.FieldNames__c, null, null, renderType); 
        }else{
             return renderBlock(parentHeaderLabel, flexGridInfo[0].ParentFlexTable__r.FieldNames__c, null, null, renderType);
           // return null;
        }
        }

        // this method use to render child table of grid
        public void renderChildTable(SObject sobj, String type) {
            Boolean isParent = false;
           if(type=='Child'){
                String renderType = 'Child';
                if(childRecordsMap.get(sobj.Id) != Null && childRecordsMap.get(sobj.Id).size() > 0) {
                     renderTable(tableHeaderMap.get('Child1'), flexGridInfo[0].Child1FlexTable__r.FieldNames__c, sobj, flexGridInfo[0].Child1RelationshipName__c, renderType);      
                }

            }else{
                 String renderType = 'Child2';
                if(child2RecordsMap.get(sobj.Id) != Null && child2RecordsMap.get(sobj.Id).size() > 0) {
                     renderTable(tableHeaderMap.get('Child2'), flexGridInfo[0].Child2FlexTable__r.FieldNames__c, sobj, flexGridInfo[0].Child2RelationshipName__c, renderType);      
                }

            } 
        }
        public void renderGrandChild(SObject sobj, String type) {
      
            if(type=='GrandChild'){
                String renderType = 'GrandChild';
                if( grandChildRecordsByParentId.get(sobj.Id) != Null && grandChildRecordsByParentId.get(sobj.Id).size() > 0) {
                   renderTable(tableHeaderMap.get('GrandChild1'), flexGridInfo[0].GrandChild1FlexTable__r.FieldNames__c, sobj,  flexGridInfo[0].GrandChild1RelationshipName__c, renderType);
                }
            }else{
                String renderType = 'GrandChild2';
                if( grandChild2RecordsByParentId.get(sobj.Id) != Null && grandChild2RecordsByParentId.get(sobj.Id).size() > 0) {
                    renderTable(tableHeaderMap.get('GrandChild2'), flexGridInfo[0].GrandChild2FlexTable__r.FieldNames__c, sobj,  flexGridInfo[0].GrandChild2RelationshipName__c, renderType);
                }

            }
        //Child1 List Display End.
        }

         // get parent data
         private void getParentData(){
            string paramParentMapJson = JSON.serialize(paramRecordMap);
            //parentRecords= obj.getPageRecords(paramParentMapJson);
            parentHideColumnMap=getHideColumnJSONMap('ParentFlexTable');
            parentHideCellMap=getHideCellJSONMap('ParentFlexTable');
            String fields;
            Set<String> fildsSet=new Set<String>();
            for (String key : parentHideCellMap.keySet()) {
                if(parentHideCellMap.get(key)!=null){
                    fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(parentHideCellMap.get(key));
                    if(fields != null && fields != ''){
                    String[] feildsArray = fields.split(',');
                    fildsSet.addall(feildsArray);
                }
                }
    
            }

            // fetch records with all fields
            set<String> parentQueyyFields = (set<String>)paramRecordMap.get('queryFieldsList');
            fildsSet.addall(parentQueyyFields);
            paramRecordMap.put('queryFieldsList',fildsSet);
            paramParentMapJson = JSON.serialize(paramRecordMap);
            // create FlexGridEnhancedHelper objects
            FlexGridEnhancedHelper obj=new FlexGridEnhancedHelper();
            parentRecordsWithAllFields= obj.getPageRecords(paramParentMapJson);
            // remove hide column
            parentTableFieldAPISet=removeHideColumn(parentTableFieldAPIList,parentRecord,parentHideColumnMap,getHideGroupingColumnsMap('ParentFlexTable'));
            parentTableFieldAPIList.clear();
            parentTableFieldAPISet = removeSkipForExportColumn(String.valueOf(flexGridInfo[0].ParentFlexTable__r.SkipFieldsForExport__c) , parentTableFieldAPISet);
            parentTableFieldAPIList.addAll(parentTableFieldAPISet);
           

            child1RecordsMap = new Map<Id,List<recordWrapper>>();
            child2RecordsMap = new Map<Id,List<recordWrapper>>(); 
            //if(mode!='pdf'){
             renderCSVParentRecod(parentRecordsWithAllFields,'ParentFlexTable',parentHideCellMap);
            //    }
            }
        
        // render data for cvs file
        void renderCSVParentRecod(List<Sobject> records,String level,Map<String,String> parentHideCellMap){
            if(records.size() > 0 ) {
                listRecords = new List<recordWrapper>();
                   //Check for Auto Index
                if(flexGridInfo[0].ParentFlexTable__r.EnableAutoIndex__c != null){
                      enableRowIndexParent = 1;
                      parentRowLabelIndex = massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                }else{
                      enableRowIndexParent = 0;
                }
                    

                if(flexGridInfo[0].Child1FlexTable__r.EnableAutoIndex__c == true){
                    enableRowIndexChild1 = true;
                    child1RowLabelIndex = massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                }else{
                    enableRowIndexChild1 = false;
                }
                if(flexGridInfo[0].Child2FlexTable__r.EnableAutoIndex__c == true){
                    enableRowIndexChild2 = true;
                    child1RowLabelIndex = massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                }else{
                    enableRowIndexChild2 = false;
                }

                if(flexGridInfo[0].GrandChild1FlexTable__r.EnableAutoIndex__c == true){
                     enableRowIndexGrandChild = true;
                     grandchildRowLabelIndex = massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                }else{
                     enableRowIndexGrandChild = false;
                }
                 if(flexGridInfo[0].GrandChild2FlexTable__r.EnableAutoIndex__c == true){
                     enableRowIndexGrandChild2 = true;
                     grandchild2RowLabelIndex = massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                }else{
                     enableRowIndexGrandChild2 = false;
                }

             Set<String> parentKeySet = parentFieldInfoMap.keySet(); 
             
             // Maintain Auto Index
             Integer parentIndex = 1;
             Integer child1Index =1;
             Integer child2Index =1;


                for(Sobject s : parentRecordsWithAllFields) { 
                    Map<String,String> sObjMap = new Map<String,String>();
                    if(parentKeySet.size() > 0){
                        for(String pAPIName :parentKeySet){ 
                            if(!pAPIName.equalsIgnoreCase('fieldMetaDataConfig')){  
                               sObjMap.put(pAPIName.trim(),renderFieldValue(s,pAPIName.trim(),level,parentHideCellMap));
                            }
                        }
                    }
                
              
                    listRecords.add(new recordWrapper(s,parentIndex++,sObjMap));               
                   
                    // Instalize Child Record Map
                    child1RecordsMap.put(s.Id, new List<recordWrapper>());
                    child2RecordsMap.put(s.Id, new List<recordWrapper>());
                    childRecordsMap.put(s.id,null);
                    childRecordsMap2.put(s.id,null);  
                }
                getOverAllTotal(parentRecordsWithAllFields,'ParentFlexTable');
             }
        }   
        

        private String renderFieldValue(Sobject record, String field, String level, Map<String,String> hideCellMap) {
            Sobject intRecord = record;
            String result = '';
            boolean isReferenceField=false; 
            String referanceFieldAPIName = '';         
            if(field.containsIgnoreCase('.')){ 

                isReferenceField=true;  
                referanceFieldAPIName= field;     
                List<String> colSplit = field.split('\\.',-1);          
                Integer i = 0;                  
                do{
                    String fieldAPiName = colSplit[i++];           
                    if(intRecord != null && fieldAPiName!= 'Id'){
                        intRecord = intRecord.getSobject(fieldAPiName);
                        
                    }
                }while(i < colSplit.size() - 1);  
                field = colSplit[i];
            }
          
            if(intRecord != null && field != null) {

                String objectName = intRecord.getSObjectType().getDescribe().getName();
                if((field == 'Id' || field.equalsIgnoreCase('Title')) && (objectName == 'ContentVersion' || objectName == 'ContentDocument')){
                    // result = '<a href="/servlet/servlet.FileDownload?file=' + intRecord.get('Id') + '"  target="_blank" styleClass="btn" class="tableRowLinks" title="' + intRecord.get('Title') + '">' + intRecord.get('Title') + '</a>';
                    //User Story 134154: Internal - Remove Hyperlink of file in Download as PDF and Snapshot
                    //String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() +'/' + intRecord.get('Id');
                    //result = '<a href="' + fullFileURL + '?isdtp=vw"  target="_blank" styleClass="btn" class="tableRowLinks" title="' + intRecord.get('Title') + '">' + intRecord.get('Title') + '</a>';
                    result = (String) intRecord.get('Title');
                    return result;
                }

                if(field == 'Id' ){
                  result = (String)intRecord.get('Name'); 
                  return result;
                }
                if(standerdFields.contains(field)){
                    if((String)intRecord.get(field) != null){
                        result = (String)intRecord.getSObject(field.toLowerCase().replace('id','')).get('Name');
                        return result;
                    }
                    return '';
                }
                String fielddataType;
                Integer scale;
                FlexGridEnhancedUtility.FieldDescribe fieldDesc;
                try {
                        fieldDesc= new FlexGridEnhancedUtility.FieldDescribe();

                       // fielddataType = intRecord.getSobjectType().getDescribe().fields.getMap().get(field.toLowerCase()).getDescribe().getType();
                       if(isReferenceField== true){
                           fieldDesc = ((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(referanceFieldAPIName)).ReferenceFieldInfo;
                           
                        }else{
                            fieldDesc = ((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field));
                        }

                        fielddataType = fieldDesc.Type;
                        
                        if((new set<String>{'INTEGER','PERCENT','DOUBLE','CURRENCY'}).contains(fielddataType)){
                            scale = fieldDesc.Scale;
                        }
                       
                    /*    if(fieldDesc.ReferenceFieldInfo!= null){
                        }else{
                         fielddataType = fieldDesc.Type;
                        } */
                } catch(Exception ex) {
                    System.debug(ex.getMessage() + ' : Stack ' + ex.getStackTraceString() + '  :  @   ' + ex.getLineNumber());
                    throw new CustomExceptions.InputDataException('Field not found ' + field + ' for sobject  ' + intRecord);
                }
              
                if(hideCellMap.get(field)!=null){
                
                    ExpressionJSONEvaluator.recordMap = new  Map<String,sObject>();
                    Boolean expResult=  ExpressionJSONEvaluator.evaluateExpression(hideCellMap.get(field), intRecord, ' ');
                    if(expResult){
                        Map<String,List<String>> fieldVsIdMap=new  Map<String,List<String>>();
                        fieldVsIdMap=levelVsFieldVsHideCellIdMap.get(level);
                        if(!fieldVsIdMap.keySet().contains(field)){
                           fieldVsIdMap.put(field,new List<String>());
                        }
                        List<String> hideRecordIdList=fieldVsIdMap.get(field);
                        hideRecordIdList.add(intRecord.Id);
                        fieldVsIdMap.put(field,hideRecordIdList);
                        levelVsFieldVsHideCellIdMap.put(level,fieldVsIdMap);
                        result=maskValue;
                        return result;
                    }
                }
              
                if(fielddataType.equalsIgnoreCase('DateTime')){
                    if(String.valueOf(intRecord.get(field)) != null){
                        result = Datetime.valueOf(intRecord.get(field)).format(userDateTimeFormat);//format('MM/dd/YYYY HH:mm:ss'); 
                    } 
                }else if(fielddataType.equalsIgnoreCase('Date')){
                    if(String.valueOf(intRecord.get(field)) != null){
                        result = Datetime.valueOf(intRecord.get(field)+'').format(userDateFormat);  //formatGmt('MM/dd/YYYY'); 
                    } 
                }else if(fielddataType.equalsIgnoreCase('Time')){
                    if(String.valueOf(intRecord.get(field)) != null){
                        result = Datetime.newInstance(Date.today(),(Time)intRecord.get(field) ).format(userTimeFormat);
                    } 
                }else if(fielddataType.equalsIgnoreCase('CURRENCY')){
                    String fieldValue = String.valueOf(intRecord.get(field));
                   
                    if(fieldValue != null){
                        if(fieldValue.startsWithIgnoreCase('-')){
                            result = '('+ currencySymbol + getTwoDecimalsValue(fieldValue,scale).remove('-') + ')';
                        } else {
                            result = currencySymbol + getTwoDecimalsValue(fieldValue,scale);
                        } 

                    }                
                }else if(fielddataType.equalsIgnoreCase('Double')){
                   string fieldValue = String.valueOf(intRecord.get(field));
                    if(fieldValue != null){
                        if(fieldValue.startsWithIgnoreCase('-')){
                            result = '('+ fieldValue.remove('-') + ')';
                        } else {
                            result = fieldValue;
                        } 
                    } 
                }else if(fielddataType.equalsIgnoreCase('PERCENT')){
                    string fieldValue = String.valueOf(intRecord.get(field));
                    if(fieldValue != null){
                        result = getTwoDecimalsValue(fieldValue,scale)+ ' %'; 
                    } 
                }else if(fielddataType.equalsIgnoreCase('PICKLIST')){
                    string fieldValue = String.valueOf(intRecord.get(field));
                    String pickListLabel;
                    if(fieldDesc != null && fieldDesc.PickListFieldInfo != null){
                         Map<String,String> picklistLableValueMAp = (Map<String,String>)fieldDesc.PickListFieldInfo.get('FieldPicklistValueLabelMap');
                         pickListLabel = picklistLableValueMAp.get(fieldValue);
                    }                   
                    result = pickListLabel != null ? pickListLabel : fieldValue;
                }else if(fielddataType.equalsIgnoreCase('MULTIPICKLIST')){
                    string fieldValue = String.valueOf(intRecord.get(field));         
                    string[] multiValue;
                    multiValue = fieldValue != null ? fieldValue.split(';') : null;
                    String pickListLabel;
                    if(fieldDesc != null && fieldDesc.PickListFieldInfo != null){
                        Map<String,String> picklistLableValueMAp = (Map<String,String>)fieldDesc.PickListFieldInfo.get('FieldPicklistValueLabelMap');
                        if(multiValue != null){
                            for(string val : multiValue){
                                pickListLabel = (String.isBlank(pickListLabel)) ? picklistLableValueMap.get(val) : (pickListLabel+';'+picklistLableValueMap.get(val));
                            }
                        }
                    }
                    result = pickListLabel != null ? pickListLabel : fieldValue;
                }else if(fielddataType.equalsIgnoreCase('Reference')){
                    String displayField= 'Name';
                    FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
                        for(String feildName:flexTableConfigData.DataTableDetailConfigMap.keySet()){
                            if(feildName.equalsIgnoreCase(field)){
                                if(flexTableConfigData.DataTableDetailConfigMap!=null){          
                                    Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> DataTableDetailConfigMap=flexTableConfigData.DataTableDetailConfigMap;
                                    if(DataTableDetailConfigMap.get(field).DisplayField!=null){
                                        displayField=DataTableDetailConfigMap.get(field).DisplayField;
                                    }
                                } 
                            }
                            
                        }                   

                    if(isReferenceField != true){
                        field = field.replace('__c','__r');
                        if(intRecord != null){
                            //intRecord = intRecord.getSobject(field);
                            if(standerdFields.contains(field)){
                                result = (Id)intRecord.get(field);                            
                                return result;
                            } else {
                                intRecord = intRecord.getSobject(field);
                            }
                        }                    

                        if(intRecord != null){
                            result = String.valueOf(intRecord.get(displayField));
                        }
                    } else {
                        if(String.valueOf(intRecord.get(field)) != null){
                            // Retrive Through Sobject Value of Refrence Field and display Name instead Id. 
                            Schema.DescribeSObjectResult sObjDescribe = intRecord.getSObjectType().getDescribe();
                            Map<String, Schema.SObjectField> fieldsMap = sObjDescribe.fields.getMap();
                         
                            Schema.SObjectField sObjField = fieldsMap.get(field);
                            if(sObjField == null){
                                throw new CustomExceptions.InputDataException(field + ' field is not defined on ' + record);
                            }
                             
                          /*  Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();  
                            String rfName = sObjField.getDescribe().getRelationshipName();
                           // rfName = rfName.replace('__c','__r.Name');
                           // rfName = rfname+'.Name';
                           // result =(String) intRecord.getSobject(rfName).get('Name');*/
                           result =String.ValueOf(intRecord.get(field));
                        }
                    }
                }else{
                    if(String.valueOf(intRecord.get(field)) != null){
                        String regex = '((https?:\\/\\/\\S+)|(www\\.[a-zA-Z0-9-]+\\.[a-z]{2,})(\\/\\S*)?|(\\<a\\s+href=\\"[^"]*\\".*?>.*?<\\/a>))';
                        Pattern MyPattern = Pattern.compile(regex);
                        Matcher MyMatcher = MyPattern.matcher(String.valueOf(intRecord.get(field)));
                        Pattern spacePattern = Pattern.compile('\\s+');
                        if(MyMatcher.find()){
                            result = addNewLineEvery50Chars(String.ValueOf(intRecord.get(field)));
                        }else if(!spacePattern.matcher(String.ValueOf(intRecord.get(field))).find() && String.ValueOf(intRecord.get(field)).length() > 50){//Return false when no space in text
                          // result = String.isNotBlank(String.ValueOf(intRecord.get(field))) ? FlexTableExportCtrl.addDivTagAfterEvery50Chars(String.ValueOf(intRecord.get(field))) : String.ValueOf(intRecord.get(field)); 
                        }else{
                            result =String.valueOf(intRecord.get(field)) != null ? SFDCEncoder.EncodeRichText(String.valueOf(intRecord.get(field)),xssSanitizeStr) : '';                            
                        }
                    }else{
                        result =String.valueOf(intRecord.get(field)) != null ? SFDCEncoder.EncodeRichText(String.valueOf(intRecord.get(field)),xssSanitizeStr) : '';                            
                    }
                }  
            }
            result = (result == null) ? '' : result;
            return result;
        }

public String addNewLineEvery50Chars(String inputStr) {
         String regex = '((https?:\\/\\/\\S+)|(www\\.[a-zA-Z0-9-]+\\.[a-z]{2,})(\\/\\S*)?|(\\<a\\s+href=\\"[^"]*\\".*?>.*?<\\/a>))';
         String htmlTagRegex = '<[^>]+>';
    
        String result = '';
        Integer currentIndex = 0;
    
        Matcher urlMatcher = Pattern.compile(regex).matcher(inputStr);
    
        while (urlMatcher.find()) {
            Integer start = urlMatcher.start();
            Integer endIndex = urlMatcher.end();
    
            while ((start - currentIndex) > 50) {
                result += inputStr.substring(currentIndex, currentIndex + 50)
                        + '<a style="overflow-wrap: break-word;word-wrap: break-word;white-space:pre-line;word-break: break-all;display:inline;cursor: pointer!important; ignoreWrapStyle" ></a>';
                currentIndex += 50;
            }
    
            result += inputStr.substring(currentIndex, start);
    
            String matchedUrl = inputStr.substring(start, endIndex);
            if (matchedUrl.startsWith('http')) {
                String href = matchedUrl.replaceAll(htmlTagRegex, '');
    
                result += '<a href="' + href + '" style="overflow-wrap: break-word;word-wrap: break-word;white-space:pre-line;word-break: break-all;display:inline;cursor: pointer!important; ignoreWrapStyle">';
    
                for (Integer i = 0; i < href.length(); i += 50) {
                    if (i + 50 <= href.length()) {
                        result += href.substring(i, i + 50) + '<a style="overflow-wrap: break-word;word-wrap: break-word;white-space:pre-line;word-break: break-all;display:inline;cursor: pointer!important; ignoreWrapStyle"></a>';
                    } else {
                        result += href.substring(i);
                    }
                }
    
                result += '</a>'; // Close the main anchor tag
            } else if (matchedUrl.startsWith('<a ')) {
                Matcher anchorMatcher = Pattern.compile('\\<a\\s+href=\\"([^"]*)\\".*?>(.*?)<\\/a>').matcher(matchedUrl);
                if (anchorMatcher.find()) {
                    String href = anchorMatcher.group(1);
                    String linkText = anchorMatcher.group(2);
    
                    href = href.replaceAll(htmlTagRegex, '');
    
                    result += '<a href="' + href + '" style="overflow-wrap: break-word;word-wrap: break-word;white-space:pre-line;word-break: break-all;display:inline;cursor: pointer!important; ignoreWrapStyle">';
    
                    for (Integer i = 0; i < linkText.length(); i += 50) {
                        if (i + 50 <= linkText.length()) {
                            result += linkText.substring(i, i + 50) + '<a style="overflow-wrap: break-word;word-wrap: break-word;white-space:pre-line;word-break: break-all;display:inline;cursor: pointer!important; ignoreWrapStyle"></a>';
                        } else {
                            result += linkText.substring(i);
                        }
                    }
    
                    result += '</a>'; 
                }
            }
    
            currentIndex = endIndex;
        }
    
        while ((inputStr.length() - currentIndex) > 50) {
            result += inputStr.substring(currentIndex, currentIndex + 50)
                    + '<a style="overflow-wrap: break-word;word-wrap: break-word;white-space:pre-line;word-break: break-all;display:inline;cursor: pointer!important; ignoreWrapStyle"></a>';
            currentIndex += 50;
        }
    
        result += inputStr.substring(currentIndex);
    
        return result;
    }               // this method use to render table
        private Component.Apex.OutputPanel renderTable(String ParentTableHeader, String fieldNames, Sobject sobjVal, String relationshipName, String renderType){
           Boolean overAllLable=true;
            if(renderType == 'Parent'){
                if(ParentTableHeader != null) {
                     html += '<div class="flexTableHeader">' + ParentTableHeader + '</div>';
                }
                html += '<div>'+'<table width="100%" border="1" cellspacing="0" cellpadding="0" class="orgtable parent"'+
                            'style="width:100%;border-collapse: collapse;">';
                if(parentTableFieldAPIList.size() > 0 ){
                    html += '<tr>';
                    if(flexGridInfo[0].ParentFlexTable__r.EnableAutoIndex__c == true){
                        html += '<th>';
                        html += massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                        html += '</th>';
                        parentFieldCount++;
                    }
                    for(String pAPI : parentTableFieldAPIList) {
                        if(pAPI != 'Id') {
                            String dataType = levelVsFieldVsDataTypeMap.get('ParentFlexTable').get(pAPI);
                            if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                 html += '<th style="text-align: right;">';
                            }else{
                                 html += '<th>';}
                            html +=parentFieldInfoMap.get(pAPI.trim());
                            html += '</th>';
                            parentFieldCount++;
                        }
                    }  
                    html += ' </tr>';
                }
               
                Integer index1 = 1;
                for(Sobject sobj : parentRecordsWithAllFields) {
                    if(parentTableFieldAPIList.size() > 0 ){
                     html += '<tr>';  
                      if(flexGridInfo[0].ParentFlexTable__r.EnableAutoIndex__c == true) {
                        html += '<td>';                
                        html += index1;
                        html += '</td>';
                        index1++;
                    }     
                    for(String pAPI : parentTableFieldAPIList) { 
                        if(pAPI != 'Id') {    
                        String dataType = levelVsFieldVsDataTypeMap.get('ParentFlexTable').get(pAPI);
                            if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                    html += '<td style="text-align: right;">';
                            }else{
                                    html += '<td>';
                            }
                            addHTMLToBody();
                            html += renderFieldValue(sobj, pAPI.trim(),'ParentFlexTable',parentHideCellMap );
                            html += '</td>';
                        }
                    }
                    html += '</tr>';
                    html += '<tr>';
                    html += '<td colspan="'+ parentFieldCount+'">';
                        if(flexGridInfo[0].Child1FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].Child1FlexTable__r.PDFRenderType__c)){
                           renderChildTable(sobj,'Child');
                        } 
                        if(flexGridInfo[0].Child2FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].Child2FlexTable__r.PDFRenderType__c)){
                           renderChildTable(sobj,'Child2');
                        } 
                    
                    html += '</td>';         
                    html += '</tr>';   
                    }         
                }
                if((overAllTotalMap.get('ParentFlexTable')!=null || levelVsFieldVsOverallLabelMap.get('ParentFlexTable')!=null ) && parentTableFieldAPIList.size() > 0 ){
                    html +='<tr>';
					if(flexGridInfo[0].ParentFlexTable__r.EnableAutoIndex__c == true) {
                        html += '<th>';                
                        html += '</th>';
                    }
                    for(String pAPI : parentTableFieldAPIList) {
                        if(pAPI != 'Id') {
                            html += '<th style="text-align: right;">';
                            if( overAllTotalMap.get('ParentFlexTable') !=null && overAllTotalMap.get('ParentFlexTable').get(pAPI)!=null){
                                html += overAllTotalMap.get('ParentFlexTable').get(pAPI);    
                            }
                            if( levelVsFieldVsOverallLabelMap.get('ParentFlexTable').get(pAPI).get('GRANDTOTAL')!= 'false'){
                                html += levelVsFieldVsOverallLabelMap.get('ParentFlexTable').get(pAPI).get('GRANDTOTAL');    
                            }                         
                            html += '</th>';
                            parentFieldCount++;
                        }                        
                    } 
                    html += ' </tr>';
                }
                html += '</table></div>';
                addHTMLToBody();
            }else if(renderType == 'Child'){
                if(childTableHeaderName != null && flexGridInfo[0].Child1FlexTable__r.ShowHeaderPanel__c != false) {
                     html += '<div class="flexTableHeader">' + childTableHeaderName + '</div>';
                }
                overAllLable = true;
                html += '<table width="100%" border="1" cellspacing="0" cellpadding="0" class="orgtable child" style="width:100%;border-collapse: collapse;">';
               if(childTableFieldAPIList.size() > 0 ){
                html += '<tr bgcolor="red">';
                if(flexGridInfo[0].Child1FlexTable__r.EnableAutoIndex__c == true){
                    html += '<th>';
                    html += massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                    html += '</th>';
                }
                for(String c1API : childTableFieldAPIList) {
                    if(c1API != 'Id') {
                        String dataType = levelVsFieldVsDataTypeMap.get('Child1').get(c1API);
                        if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                            html += '<th style="text-align: right;">';
                        }else{
                            html += '<th>';
                        }
                        addHTMLToBody();
                        html += child1FieldInfoMap.get(c1API.trim());
                        html += '</th>';
                        childColumnCount++;
                    }
                }
                
                html += '</tr>';
               }
                Integer index2 =1;
                if(childRecordsMap.get(sobjVal.Id) != Null) {
                    for(Sobject sobjChild1 : childRecordsMap.get(sobjVal.Id)) {
                        if(childTableFieldAPIList.size() > 0 ){

                       
                        html += '<tr>';
                         if(flexGridInfo[0].Child1FlexTable__r.EnableAutoIndex__c == true) {
                            html += '<td>';                
                            html += index2;
                            html += '</td>';
                            index2++;
                        }
                        /**End here */
                        for(String c1API : childTableFieldAPIList) {
                            if(c1API != 'Id') {                                
                               String dataType = levelVsFieldVsDataTypeMap.get('Child1').get(c1API);
                               if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                     html += '<td style="text-align: right;">';
                                }else{
                                    html += '<td>';
                                }                    
                                addHTMLToBody();
                                html += renderFieldValue(sobjChild1,c1API.trim(),'Child1',Child1HideCellMap);
                                html += '</td>';
                             }
                        }
                        html += '</tr>';
                        if(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c)){
                            renderGrandChild(sobjChild1,'GrandChild');
                        }
                        if(flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c)){
							isChild1GrandChild2Table = true;
                            renderGrandChild(sobjChild1,'GrandChild2');
							isChild1GrandChild2Table = false;
                        } 
                    }                      
                    }
                }
                //getOverAllTotal(childRecordsMap.get(sobjVal.Id),'Child1',sobjVal.Id);
                if(childOverAllTotalMap.get('Child1')!=null && childTableFieldAPIList.size() > 0 ){
                    html +='<tr>';
                    if(flexGridInfo[0].Child1FlexTable__r.EnableAutoIndex__c == true) {
                        html += '<th>'; 
                        html += '</th>';
                    }
                    for(String pAPI : childTableFieldAPIList) {
                        if(pAPI != 'Id') {
                            html += '<th style="text-align: right;">';
                            if(childOverAllTotalMap.get('Child1') !=null && childOverAllTotalMap.get('Child1').get(sobjVal.Id)!=null && childOverAllTotalMap.get('Child1').get(sobjVal.Id).get(pAPI)!=null) {
                                html += childOverAllTotalMap.get('Child1').get(sobjVal.Id).get(pAPI);    
                            }
                            if( levelVsFieldVsOverallLabelMap.get('Child1').get(pAPI).get('GRANDTOTAL')!= 'false'){
                                 html += levelVsFieldVsOverallLabelMap.get('Child1').get(pAPI).get('GRANDTOTAL');    
                            }                         
                            html += '</th>';
                            parentFieldCount++;
                        }
                    }                  
                    html += ' </tr>'; 
                }               
                html += '</table>';  
            
                addHTMLToBody();
            }else if(renderType =='GrandChild'){   
                overAllLable = true;
                if(fieldNames !=null){
                    grandchildTableFieldAPIList = fieldNames.Split(',');
                }
                if(flexGridInfo[0].Child1FlexTable__r.PDFRenderType__c != 'Block' && flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c)) {
                     html += '<tr><td colspan="'+ childColumnCount+'">';
                } 
                 if(grandchildTableHeaderName != null && flexGridInfo[0].GrandChild1FlexTable__r.ShowHeaderPanel__c != false) {
                     html += '<div class="flexTableHeader">' + grandchildTableHeaderName + '</div>';
                }
                html +='<table width="100%" border="1" cellspacing="0" cellpadding="0" class="orgtable child" style="width:100%;border-collapse: collapse;">';
               if(grandchildTableFieldAPIList.size() > 0){

                html += '<tr>';
                Integer grandChildColumnCount = 0;
                if(flexGridInfo[0].GrandChild1FlexTable__r.EnableAutoIndex__c == true){
                    html += '<th>';
                    html += massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                    html += '</th>';
                }
                for(String c1API : grandchildTableFieldAPIList) {
                    if(c1API != 'Id') {
                        String dataType = levelVsFieldVsDataTypeMap.get('GrandChild1').get(c1API);
                        if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                html += '<th style="text-align: right;">';
                        }else{
                                html += '<th>';
                        }
                        html += grandChildFieldInfoMap.get(c1API.trim());
                        html += '</th>';
                        grandChildColumnCount++;
                    }
                }
                 html += '</tr>'; 
            }
                 Integer cnt=0; 
                 Integer index3 = 1;
                for(Sobject sobjChild1 : grandChildRecordsByParentId.get(sobjVal.Id)) {
                    if(grandchildTableFieldAPIList.size() > 0 ){
                    html += '<tr>';
                    cnt++;    
                     if(flexGridInfo[0].GrandChild1FlexTable__r.EnableAutoIndex__c == true) {
                        html += '<td>';                
                        html += index3;
                        html += '</td>';
                        index3++;
                    }
                    /**End here */
                    for(String c1API : grandchildTableFieldAPIList) {
                        if(c1API != 'Id') {
                            String dataType = levelVsFieldVsDataTypeMap.get('GrandChild1').get(c1API);
                            if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                html += '<td style="text-align: right;">';
                            }else{
                                html += '<td>';
                            }                   
                            addHTMLToBody();        
                            html += renderFieldValue(sobjChild1,c1API.trim(),'GrandChild1',grandChild1HideCellMap);
                            html += '</td>';
                        }
                    }
                    html += '</tr>'; 
                } 
                }               
                if(childOverAllTotalMap.get('GrandChild1')!=null && grandchildTableFieldAPIList.size() > 0 ){     
                    html +='<tr>';
                    if(flexGridInfo[0].GrandChild1FlexTable__r.EnableAutoIndex__c == true) {
                        html += '<th>'; 
                        html += '</th>';
                    }
                    for(String pAPI : grandchildTableFieldAPIList) {
                        if(pAPI != 'Id') {
                            html += '<th style="text-align: right;">';
                            if(childOverAllTotalMap.get('GrandChild1') !=null && childOverAllTotalMap.get('GrandChild1').get(sobjVal.Id)!=null && childOverAllTotalMap.get('GrandChild1').get(sobjVal.Id).get(pAPI)!=null) {
                                html += childOverAllTotalMap.get('GrandChild1').get(sobjVal.Id).get(pAPI);    
                            }
                            if( levelVsFieldVsOverallLabelMap.get('GrandChild1').get(pAPI).get('GRANDTOTAL')!= 'false'){
                                 html += levelVsFieldVsOverallLabelMap.get('GrandChild1').get(pAPI).get('GRANDTOTAL');    
                            }                       
                            html += '</th>';
                            parentFieldCount++;
                        }
                    }
                     html += ' </tr>'; 
                }                     
                    html += '</table>';
                if(flexGridInfo[0].Child1FlexTable__r.PDFRenderType__c != 'Block' && flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c != 'Block' ){
                 html += '</td></tr>';  
                }
                addHTMLToBody();
            }else if(renderType == 'Child2'){
                if(child2TableHeaderName != null && flexGridInfo[0].Child2FlexTable__r.ShowHeaderPanel__c != false) {
                     html += '<div class="flexTableHeader">' + child2TableHeaderName + '</div>';
                }
                overAllLable = true;
                html += '<table width="100%" border="1" cellspacing="0" cellpadding="0" class="orgtable child" style="width:100%;border-collapse: collapse;">';
               if(child2TableFieldAPIList.size() > 0 ){
                html += '<tr bgcolor="red">';
                if(flexGridInfo[0].Child2FlexTable__r.EnableAutoIndex__c == true){
                    html += '<th>';
                    html += massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                    html += '</th>';
                }
                for(String c1API : child2TableFieldAPIList) {
                    if(c1API != 'Id') {
                        String dataType = levelVsFieldVsDataTypeMap.get('Child2').get(c1API);
                        if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                             html += '<th style="text-align: right;">';
                        }else{
                             html += '<th>';
                        }
                        addHTMLToBody();
                        html += child2FieldInfoMap.get(c1API.trim());
                        html += '</th>';
                        child2ColumnCount++;
                    }
                }
                html += '</tr>';
            }
                Integer index4 = 1;
            if(childRecordsMap2.get(sobjVal.Id) != Null) {
                for(Sobject sobjChild2 : childRecordsMap2.get(sobjVal.Id)) {
                    if(child2TableFieldAPIList.size() > 0 ){
                    html += '<tr>';
                     if(flexGridInfo[0].Child2FlexTable__r.EnableAutoIndex__c == true) {
                        html += '<td>';                
                        html += index4;
                        html += '</td>';
                        index4++;
                    }
                    /**End here */
                    for(String c1API : child2TableFieldAPIList) {
                        if(c1API != 'Id') {
                             String dataType = levelVsFieldVsDataTypeMap.get('Child2').get(c1API);
                            if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                 html += '<td style="text-align: right;">';
                            }else{
                                 html += '<td>';
                            }                   
                            addHTMLToBody();
                            html += renderFieldValue(sobjChild2,c1API.trim(),'Child2',Child2HideCellMap);
                            html += '</td>';
                        }
                    }
                    html += '</tr>';
                    if(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c)){
                        renderGrandChild(sobjChild2,'GrandChild');
                    }
                    if(flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c)){
                         renderGrandChild(sobjChild2,'GrandChild2');
                   } else {
                     if(flexGridInfo[0].GrandChild2FlexTable__c != Null && grandChildRecordsByParentId.get((String)sobjChild2.get('Id')) != Null ){
                           html += '<tr>';
                           html += '<td colspan="'+child2ColumnCount+'">';
                           renderGrandChild(sobjChild2,'GrandChild2');
                           html += '</td>';
                           html += '</tr>';
                      }
                    }
                
                }
            }

                }
                if(childOverAllTotalMap.get('Child2')!=null && child2TableFieldAPIList.size() >0 ){  
                    html +='<tr>';
                    if(flexGridInfo[0].Child2FlexTable__r.EnableAutoIndex__c == true) {
                        html += '<th>'; 
                        html += '</th>';
                    }
                        for(String pAPI : child2TableFieldAPIList) {
                            if(pAPI != 'Id') {
                                html += '<th style="text-align: right;">';
                                if(childOverAllTotalMap.get('Child2') !=null && childOverAllTotalMap.get('Child2').get(sobjVal.Id)!=null && childOverAllTotalMap.get('Child2').get(sobjVal.Id).get(pAPI)!=null) {
                                    html += childOverAllTotalMap.get('Child2').get(sobjVal.Id).get(pAPI);    
                                }                        
                                if( levelVsFieldVsOverallLabelMap.get('Child2').get(pAPI).get('GRANDTOTAL')!= 'false'){
                                    html += levelVsFieldVsOverallLabelMap.get('Child2').get(pAPI).get('GRANDTOTAL');    
                                }
                                html += '</th>';
                                parentFieldCount++;
                            }                        
                        }
                    html += ' </tr>';
                }   
                html += '</table>';  
            
                addHTMLToBody();
            }else if(renderType =='GrandChild2'){
                overAllLable = true;
                if(fieldNames !=null){
                    grandchild2TableFieldAPIList = fieldNames.Split(',');
                }
                Integer collSpan  = 0;
                if(isChild1GrandChild2Table == true){
                    collSpan = childColumnCount;
                }else{
                    collSpan = child2ColumnCount;
                }
                if(flexGridInfo[0].Child2FlexTable__r.PDFRenderType__c != 'Block' && flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c != 'Block' || String.isEmpty(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c) ) {
                     html += '<tr><td colspan="'+ collSpan+'">';
                }
                if(grandchild2TableHeaderName != null && flexGridInfo[0].GrandChild2FlexTable__r.ShowHeaderPanel__c != false) {
                     html += '<div class="flexTableHeader">' + grandchild2TableHeaderName + '</div>';
                } 
                html +='<table width="100%" border="1" cellspacing="0" cellpadding="0" class="orgtable child" style="width:100%;border-collapse: collapse;">';
               if(grandchild2TableFieldAPIList.size() > 0 ){
                html += '<tr>';
                 if(flexGridInfo[0].GrandChild2FlexTable__r.EnableAutoIndex__c == true){
                    html += '<th>';
                    html += massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') != null ? massEditableGridConfigMap.get('AutoIndexColumnHeaderLabel') : '#';
                    html += '</th>';
                }
                Integer grandChild2ColumnCount = 0;
                   for(String c1API : grandchild2TableFieldAPIList) {
                       if(c1API != 'Id') {
                           String dataType = levelVsFieldVsDataTypeMap.get('GrandChild2').get(c1API);
                            if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                 html += '<th style="text-align: right;">';
                            }else{
                                 html += '<th>';
                            }
                           html += grandChild2FieldInfoMap.get(c1API.trim());
                           html += '</th>';
                           grandChild2ColumnCount++;
                       }
                   }
                 html += '</tr>'; 
                }
                 Integer cnt=0; 
                 Integer index5 = 1;
                for(Sobject sobjChild2 : grandChild2RecordsByParentId.get(sobjVal.Id)) {
                         
                 //     if(cnt<(grandChild2RecordsByParentId.get(sobjVal.Id).size()/2)){
                    html += '<tr>';
                    cnt++; 
                    if(grandchild2TableFieldAPIList.size() > 0 ){
                    if(flexGridInfo[0].GrandChild2FlexTable__r.EnableAutoIndex__c == true){
                        html += '<td>';                
                        html += index5;
                        html += '</td>';
                        index5++;
                    }
                    for(String c1API : grandchild2TableFieldAPIList) {
                        if(c1API != 'Id') {
                            String dataType = levelVsFieldVsDataTypeMap.get('GrandChild2').get(c1API);
                            if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                                 html += '<td style="text-align: right;">';
                            }else{
                                 html += '<td>';
                            }                    
                            addHTMLToBody();        
                            html += renderFieldValue(sobjChild2,c1API.trim(),'GrandChild2',grandChild2HideCellMap);
                            html += '</td>';
                        }
                    }
                    html += '</tr>';  
                }
            }  
                  //  } 
                  
                if(childOverAllTotalMap.get('GrandChild2')!=null && grandchild2TableFieldAPIList.size() > 0 ){
                    html +='<tr>';
                    if(flexGridInfo[0].GrandChild2FlexTable__r.EnableAutoIndex__c == true){
                        html += '<th>';  
                        html += '</th>';
                    }
                    for(String pAPI : grandchild2TableFieldAPIList) {
                        if(pAPI != 'Id') {
                            html += '<th style="text-align: right;">';
                            if(childOverAllTotalMap.get('GrandChild2') !=null && childOverAllTotalMap.get('GrandChild2').get(sobjVal.Id)!=null && childOverAllTotalMap.get('GrandChild2').get(sobjVal.Id).get(pAPI)!=null) {
                                html += childOverAllTotalMap.get('GrandChild2').get(sobjVal.Id).get(pAPI);    
                            } 
                            if( levelVsFieldVsOverallLabelMap.get('GrandChild2').get(pAPI).get('GRANDTOTAL')!= 'false'){
                                 html += levelVsFieldVsOverallLabelMap.get('GrandChild2').get(pAPI).get('GRANDTOTAL');    
                            }                      
                            html += '</th>';
                            parentFieldCount++;
                        }
                    }  
                    html += ' </tr>';
                }
                    html += '</table>';
                if(flexGridInfo[0].Child2FlexTable__r.PDFRenderType__c != 'Block' && flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c != 'Block' ){
                 html += '</td></tr>';  
                }
                addHTMLToBody();
            }
             return body;
        }
        
        // this method use to render Block
        private Component.Apex.OutputPanel renderBlock(String ParentTableHeader, String fieldNames, Sobject sobjVal, String relationshipName, String renderType){
            Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel();
            
                if(renderType == 'Parent'){
                
                    if(ParentTableHeader != null) {
                                html += '<div class="flexTableHeader">' + ParentTableHeader + '</div>';
                }
                        
                html += '<div style="margin-bottom:10px;">';  
                for(Sobject sobj : parentRecordsWithAllFields) {
                        html += '<div class="1" style="border:1px solid #ccc; padding: 15px">';
                        for(String pAPI : parentTableFieldAPIList) {
                            if(pAPI != 'Id') {
                                
                                html += '<div style="margin-bottom:5px;"><b style="margin-right:10px;">';
                                html +=  parentFieldInfoMap.get(pAPI.trim());
                                html += ':</b> ';
                                html += '<span>';
                                html += renderFieldValue(sobj, pAPI.trim(),'ParentFlexTable',parentHideCellMap );
                                html += '</span></div>';  
                            }
                         }  
                        //render Child table Block
                        if(flexGridInfo[0].Child1FlexTable__r.PDFRenderType__c == 'Block' || String.isEmpty(flexGridInfo[0].Child1FlexTable__r.PDFRenderType__c)){
                           renderChildBlock(sobj,'Child');
                        } 
                        if(flexGridInfo[0].Child2FlexTable__r.PDFRenderType__c == 'Block' || String.isEmpty(flexGridInfo[0].Child2FlexTable__r.PDFRenderType__c)){
                           renderChildBlock(sobj,'Child2');
                        } 
                       
                    html += '</div>';  
 
                }
                 
                html += '</div>';  
                addHTMLToBody();   
                         
            }else if(renderType == 'Child'){
				if(childTableHeaderName != null) {
                    html += '<div class="flexTableHeader">' + childTableHeaderName + '</div>';
                }     
                html += '<div style="margin-bottom:10px;">';  
				if(childRecordsMap.get(sobjVal.Id) != Null) {
					for(Sobject sobjChild1 : childRecordsMap.get(sobjVal.Id)) {
                        html += '<div class="1" style="border:1px solid #ccc; padding: 15px">';
                        for(String c1API : childTableFieldAPIList) {
                            if(c1API != 'Id') {
                                system.debug('c1API--'+c1API);
                                html += '<div style="margin-bottom:5px;"><b style="margin-right:10px;">';
                                html +=  child1FieldInfoMap.get(c1API.trim());
                                html += ':</b> ';
                                html += '<span>';
                                html += renderFieldValue(sobjChild1,c1API.trim(),'Child1',Child1HideCellMap);
                                html += '</span></div>';  
                            }
                        }
                        if(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c == 'Block' || String.isEmpty(flexGridInfo[0].GrandChild1FlexTable__r.PDFRenderType__c)){
                             renderGrandChildBlock(sobjChild1,'GrandChild');
                        }  
                        html += '</div>';   
                    }
				 }
                
                html += '</div>';  
                addHTMLToBody();   
			}else if(renderType =='GrandChild'){ 
                if(grandchildTableHeaderName != null) {
                    html += '<div class="flexTableHeader">' + grandchildTableHeaderName + '</div>';
                }
                        
                html += '<div style="margin-bottom:10px;">';  
				if(grandChildRecordsByParentId.get(sobjVal.Id) != Null) {
					for(Sobject sobjChild1 : grandChildRecordsByParentId.get(sobjVal.Id)) {
                        html += '<div class="1" style="border:1px solid #ccc; padding: 15px">';
                        for(String c1API : grandchildTableFieldAPIList) {
                            if(c1API != 'Id') {
                                
                                html += '<div style="margin-bottom:5px;"><b style="margin-right:10px;">';
                                html +=  grandChildFieldInfoMap.get(c1API.trim());
                                html += ':</b> ';
                                html += '<span>';
                                html += renderFieldValue(sobjChild1,c1API.trim(),'GrandChild1',grandChild1HideCellMap);
                                html += '</span></div>';  
                            }
                        }
                        html += '</div>';   
                    }
				}
                
                html += '</div>';  
                addHTMLToBody();   
		    }else if(renderType == 'Child2') {
                if(child2TableHeaderName != null) {
                     html += '<div class="flexTableHeader">' + child2TableHeaderName + '</div>';
                }
                        
                html += '<div style="margin-bottom:10px;">';  
				if(childRecordsMap2.get(sobjVal.Id) != Null) {
					for(Sobject sobjChild2 : childRecordsMap2.get(sobjVal.Id)) {
                        html += '<div class="1" style="border:1px solid #ccc; padding: 15px">';
                        for(String c1API : child2TableFieldAPIList) {
                            if(c1API != 'Id') {
                                
                                html += '<div style="margin-bottom:5px;"><b style="margin-right:10px;">';
                                html +=  child2FieldInfoMap.get(c1API.trim());
                                html += ':</b> ';
                                html += '<span>';
                                html += renderFieldValue(sobjChild2,c1API.trim(),'Child2',Child2HideCellMap);
                                html += '</span></div>';  
                            }
                        }
                        if(flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c == 'Block' || String.isEmpty(flexGridInfo[0].GrandChild2FlexTable__r.PDFRenderType__c)){
                         renderGrandChildBlock(sobjChild2,'GrandChild2');
                        } else {
                            if(flexGridInfo[0].GrandChild2FlexTable__c != Null && grandChildRecordsByParentId.get((String)sobjChild2.get('Id')) != Null ){
                                 renderGrandChildBlock(sobjChild2,'GrandChild2');
                            }
                        }
                        html += '</div>';   
                    }
				}
                
                html += '</div>';  
                addHTMLToBody();   
		    }else if(renderType =='GrandChild2'){
                if(grandchild2TableHeaderName != null) {
                    html += '<div class="flexTableHeader">' + grandchild2TableHeaderName + '</div>';
                }
                        
                html += '<div style="margin-bottom:10px;">';  
			    if(grandChild2RecordsByParentId.get(sobjVal.Id) != Null) {
					for(Sobject sobjChild2 : grandChild2RecordsByParentId.get(sobjVal.Id)) {
                        html += '<div class="1" style="border:1px solid #ccc; padding: 15px">';
                        for(String c1API : grandchild2TableFieldAPIList) {
                            if(c1API != 'Id') {
                                
                                html += '<div style="margin-bottom:5px;"><b style="margin-right:10px;">';
                                html +=  grandChild2FieldInfoMap.get(c1API.trim());
                                html += ':</b> ';
                                html += '<span>';
                                html += renderFieldValue(sobjChild2,c1API.trim(),'GrandChild2',grandChild2HideCellMap);
                                html += '</span></div>';  
                            }
                        }
                        html += '</div>';   
                     }
				 }
                
                html += '</div>';  
                addHTMLToBody();   
		     }

            else{
                    html += '<div colspan="" style="text-align:center"> No Records found.</div>'; 
                } 
                return body;    
        }
      
        public void renderChildBlock(SObject sobj, String type) {
           Boolean isParent = false;
           if(type=='Child'){
                String renderType = 'Child';
                if(childRecordsMap.get(sobj.Id) != Null && childRecordsMap.get(sobj.Id).size() > 0) {
                     renderBlock(tableHeaderMap.get('Child1'), flexGridInfo[0].Child1FlexTable__r.FieldNames__c, sobj, flexGridInfo[0].Child1RelationshipName__c, renderType);      
                }

            }else{
                 String renderType = 'Child2';
                if(child2RecordsMap.get(sobj.Id) != Null && child2RecordsMap.get(sobj.Id).size() > 0) {
                     renderBlock(tableHeaderMap.get('Child2'), flexGridInfo[0].Child2FlexTable__r.FieldNames__c, sobj, flexGridInfo[0].Child2RelationshipName__c, renderType);      
                }

            } 
        }
		
        public void renderGrandChildBlock(SObject sobj, String type) {
      
            if(type=='GrandChild'){
                String renderType = 'GrandChild';
                if( grandChildRecordsByParentId.get(sobj.Id) != Null && grandChildRecordsByParentId.get(sobj.Id).size() > 0) {
                   renderBlock(tableHeaderMap.get('GrandChild1'), flexGridInfo[0].GrandChild1FlexTable__r.FieldNames__c, sobj,  flexGridInfo[0].GrandChild1RelationshipName__c, renderType);
                }
            }else{
                 String renderType = 'GrandChild2';
                if( grandChild2RecordsByParentId.get(sobj.Id) != Null && grandChild2RecordsByParentId.get(sobj.Id).size() > 0) {
                    renderBlock(tableHeaderMap.get('GrandChild2'), flexGridInfo[0].GrandChild2FlexTable__r.FieldNames__c, sobj,  flexGridInfo[0].GrandChild2RelationshipName__c, renderType);
                }

            }
        }
             
            // add html string in html body
        private void addHTMLToBody() {
        if (String.isNotEmpty(html)) {
            body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
            html = '';
        }       
    }
    // get child table records depeds on mode
    private void getChildRecords() {
     childTableFieldAPIList = new List<String>(); 
     child1FieldInfoMap = new  Map<String,String>();
     child2FieldInfoMap = new  Map<String,String>();
     grandchildRecordsMap = new Map<Id,List<recordWrapper>>(); 
     grandchild2RecordsMap = new Map<Id,List<recordWrapper>>(); 
    /*  if(mode !='application/vnd.ms-excel'){
        //getChildRecordForPDF();
      }else{
        getChildRecordForCSV();  
      }   */
      getChildRecordForCSV(); 
    }

    // get grandchild table records depeds on mode
    private void getGrandChildRecords() {
        grandchildTableFieldAPIList = new List<String>(); 
        grandchildTableHeaderName = tableHeaderMap.get('GrandChild1');
        grandchild2TableHeaderName = tableHeaderMap.get('GrandChild2');        
      
        getGrandChildRecordsCSV();
       
    }
    // get records of child tables
    private void getChildRecordForCSV() {
       
        Set<String> child1KeySet = new Set<String>();
        Set<String> child2KeySet = new Set<String>();
        contentFilterRecord child1ContentFilter;
        contentFilterRecord child2ContentFilter;
         
        if(flexGridInfo[0].Child1FlexTable__c != null) {            
            isTableAvailableMap.put('child1',true);
            String relationshipField = flexGridInfo[0].Child1FlexTable__r.ParentTargetLookupField__c;
            List<String> parentTargetField = new List<String>();
            for(Sobject sobj : parentRecordsWithAllFields) {
                parentTargetField.add((String)sobj.get('Id'));
            }
            if(parentTargetField.size() > 0){
                child1FieldInfoMap = getFieldMetadata(flexGridInfo[0].Child1FlexTable__r,'Child1');
                child1KeySet = child1FieldInfoMap.keySet();
                String filterClause=getFilterClause('Child1');
                
                if(filterclause != Null) { 
                    String parentFieldName = filterClause.split('in:parentTargetField')[0];
                    Set<String> childTableFieldAPISet = new Set<String>();
                    childTableFieldAPIList=flexGridInfo[0].Child1FlexTable__r.FieldNames__c.split(',');
                    childTableFieldAPISet.addAll(flexGridInfo[0].Child1FlexTable__r.FieldNames__c.split(','));
                    childTableFieldAPISet.add(parentFieldName.trim());
                    for(String flStr:childTableFieldAPISet){
                        if(!flStr.contains('.')){
                            SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name ,flStr.trim());
                            if(fld.fieldDesc.getType() == Schema.DisplayType.reference){
                                String frFld = fld.fieldDesc.getName();
                                String refField = frFld.replace('__c', '__r.Name');
                                childTableFieldAPISet.add(refField);
                            }
                        }
                    }
                    List<String> fieldList = new List<String>();
                    fieldList.AddAll(childTableFieldAPISet);
                    String flds = String.join(fieldList, ', ');
                   
                    Map<string, Object> paramRecordChildMap = new Map<string, Object>();
                    paramRecordChildMap=getFlexTableConfigMap('Child1');
                    String order=(String)paramRecordChildMap.get('sortableColumn');                   
                    String sortDirection=(String)paramRecordChildMap.get('sortDirection');
                    // create qurey for get all data with all fields 
                    Child1HideColumnMap=getHideColumnJSONMap('Child1');
                    Child1HideCellMap=getHideCellJSONMap('Child1');
                    String fields;
                    Set<String> fildsSet=new Set<String>();
                    for (String key : Child1HideCellMap.keySet()) {
                        if(Child1HideCellMap.get(key)!=null){
                            fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(Child1HideCellMap.get(key));
                            if(fields != null && fields != ''){
                                String[] feildsArray = fields.split(',');
                                fildsSet.addall(feildsArray);
                            }   
                        }
                    }

                     // fetch records with all fields
            
                    fildsSet.addall(fieldList);
                    set<String> child1QueyyFields = (set<String>)paramRecordChildMap.get('queryFieldsList');
                    fildsSet.addall(child1QueyyFields);
                    List<String> temp=new List<String>();
                    temp.addall(fildsSet);
                    String fldsAll = String.join(temp, ', ');
                    if(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        child1ContentFilter = contentFilter(parentTargetField);                       
                    }
                    String query1;
                    if(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(child1ContentFilter.ContentVersionFilter); 
                        System.debug('If '+query1);
                    }else{
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(filterClause); 
                    //     System.debug('Else '+query1);
                    }
                                     
                    if(order!=null){
                        if(order.contains(',')){
                           sortDirection=null;
                        }
                        query1 += ' ORDER BY ' + String.escapeSingleQuotes(order);
                        if(sortDirection!=null){
                            query1 += ' ' + String.escapeSingleQuotes(sortDirection);
                        }
                    }
                    String exportLimit = KeyValueHolderHelper.getTextValue('childGridExportLimit');
                    if(String.isNotBlank(exportLimit)) {
                        query1 += ' LIMIT ' + Integer.valueOf(exportLimit);// query1 += ' LIMIT ' + exportLimit;//
                    } else {
                        query1 +=' Limit 1000';
                    }

                    Schema.SObjectType checkObjectType = SchemaManager.getSObjectTypeFromName(String.escapeSingleQuotes(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name));
                    List<SObject> sobjsWithAllFields = new List<SObject>();
                    try{
                        sobjsWithAllFields = Database.query(query1 , AccessLevel.USER_MODE);//NOPMD SOQL Injection - False +ve - Dynamic parts of the query String is escapeSingleQuotes and filterClause value are also escapeSingleQuotes in AppUtils.parseWhereClause method
                        for(Sobject sObj : sobjsWithAllFields){
                            String idValue;
                            if(flexGridInfo[0].Child1FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                                idValue = child1ContentFilter.ContentVersionParentIdsMap.get(String.valueOf(sObj.get('contentDocumentId'))); 
                            }else{
                                idValue = handleRefrencesFieldValue(sObj,parentFieldName.trim());
                            }
                            Map<String,String> sChild1ObjMap = new Map<String,String>();
                            if(child1KeySet.size() > 0){
                               for(String childFieldApi : child1KeySet){
                                 if(!childFieldApi.equalsIgnoreCase('fieldMetaDataConfig')){
                                     sChild1ObjMap.put(childFieldApi,renderFieldValue(sObj,childFieldApi.trim(),'Child1',Child1HideCellMap));    
                                    }
                                }
                            }
                            integer intchild1Index=child1RecordsMap.get(idValue).size();
                                    intchild1Index=intchild1Index+1;
                          child1RecordsMap.get(idValue).add( new recordWrapper(sObj,intchild1Index++,sChild1ObjMap) );
                         //}
                         //    //temporary added
                         //for(SObject sobj : sobjsWithAllFields) {
                            //string idValue =handleRefrencesFieldValue(s,parentFieldName.trim());                            
                            if(childRecordsMap.get(idValue) == null){
                                childRecordsMap.put(idValue, new List<SObject>());
                            }
                            childRecordsMap.get(idValue).add(sObj);
                            //childOverAllTotalMap.get('Child1').get(idValue).put(sobj.get(0))
                            grandChildRecordsMap.put(sObj.Id, new List<recordWrapper>());
                            grandChild2RecordsMap.put(sObj.Id, new List<recordWrapper>());
                            grandChildRecordsByParentId.put(sObj.Id,null);
                            grandChild2RecordsByParentId.put(sObj.Id,null);
                         }
                         // remove hide columns
                       Set<String> childFieldAPISet=removeHideColumn(childTableFieldAPIList,parentRecord,Child1HideColumnMap,getHideGroupingColumnsMap('Child1'));
                        childTableFieldAPIList.clear();
                        childFieldAPISet = removeSkipForExportColumn(String.valueOf(flexGridInfo[0].Child1FlexTable__r.SkipFieldsForExport__c) , childFieldAPISet);
                        childTableFieldAPIList.addAll(childFieldAPISet);
                        childTableHeaderName = tableHeaderMap.get('Child1');
                       
                        createChildOverAllTotalMap(childRecordsMap,'Child1');
                     } catch(Exception ex) {
                        System.debug(ex.getMessage() + ' : Stack ' + ex.getStackTraceString() + '  :  @   ' + ex.getLineNumber());
                        //throw new CustomExceptions.SOQLException(AppUtils.handleSystemExceptionMsg(ex.getMessage()) + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                        throw new CustomExceptions.SOQLException(AppUtils.handleSystemExceptionMsg(ex) + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                     }
                }
            }
        }

        //get records of Child2 table
        if(flexGridInfo[0].Child2FlexTable__c != null) {            
            isTableAvailableMap.put('child2',true);
           
            String relationshipField = flexGridInfo[0].Child2FlexTable__r.ParentTargetLookupField__c;
            List<String> parentTargetField = new List<String>();
            for(Sobject sobj : parentRecordsWithAllFields) {
                parentTargetField.add((String)sobj.get('Id'));
            }
            if(parentTargetField.size() > 0){
                child2FieldInfoMap = getFieldMetadata(flexGridInfo[0].Child2FlexTable__r,'Child2');
                child2KeySet = child2FieldInfoMap.keySet();
                String filterClause=getFilterClause('Child2');
                
                if(filterclause != Null) { 
                    String parentFieldName = filterClause.split('in:parentTargetField')[0];
                    Set<String> child2TableFieldAPISet = new Set<String>();
                    child2TableFieldAPIList=flexGridInfo[0].Child2FlexTable__r.FieldNames__c.split(',');
                    child2TableFieldAPISet.addAll(flexGridInfo[0].Child2FlexTable__r.FieldNames__c.split(','));
                    child2TableFieldAPISet.add(parentFieldName.trim());
                    for(String flStr:child2TableFieldAPISet){
                        if(!flStr.contains('.')){
                       SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name,flStr.trim());
                       if(fld.fieldDesc.getType() == Schema.DisplayType.reference){
                            String frFld = fld.fieldDesc.getName();
                            String refField = frFld.replace('__c', '__r.Name');
                            child2TableFieldAPISet.add(refField);
                            }
                        }
                    }
                    List<String> fieldList = new List<String>();
                    fieldList.AddAll(child2TableFieldAPISet);
                    String flds = String.join(fieldList, ', ');
                   
                    Map<string, Object> paramRecordChildMap = new Map<string, Object>();
                    paramRecordChildMap=getFlexTableConfigMap('Child2');
                    String order=(String)paramRecordChildMap.get('sortableColumn');
                    String sortDirection=(String)paramRecordChildMap.get('sortDirection');
                    
                    //String query = 'SELECT ' + flexGridInfo[0].GrandChild1FlexTable__r.FieldNames__c +','+ parentFieldName + ' from ' + flexGridInfo[0].ParentFlexTable__r.SobjectConfig__r.Name + ' where ' + filteClause;
                    
                     // create qurey for get all data with all fields
                    Child2HideColumnMap=getHideColumnJSONMap('Child2');
                    Child2HideCellMap=getHideCellJSONMap('Child2');
                    String fields;
                    Set<String> fildsSet=new Set<String>();
                    for (String key : Child2HideCellMap.keySet()) {
                        if(Child2HideCellMap.get(key)!=null){
                            fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(Child2HideCellMap.get(key));
                            if(fields != null && fields != ''){
                                String[] feildsArray = fields.split(',');
                                fildsSet.addall(feildsArray);
                            }                               
                        }
                    }

                     // fetch records with all fields
                     set<String> child2QueyyFields = (set<String>)paramRecordChildMap.get('queryFieldsList');
                     fildsSet.addall(child2QueyyFields);
                    fildsSet.addall(fieldList);
                    List<String> feildsList=new List<String>();
                    feildsList.addall(fildsSet);
                    String fldsAll = String.join(feildsList, ', ');
                    if(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        child2ContentFilter = contentFilter(parentTargetField);                        
                    }
                    String query1;
                    if(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(child2ContentFilter.ContentVersionFilter); 
                    }else{
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(filterClause); 
                    }
                    if(order!=null){
                        if(order.contains(',')){
                           sortDirection=null;
                        }
                        query1 += ' ORDER BY ' + String.escapeSingleQuotes(order);
                        if(sortDirection!=null){
                            query1 += ' ' + String.escapeSingleQuotes(sortDirection);
                        }
                    }
                    String exportLimit = KeyValueHolderHelper.getTextValue('childGridExportLimit');
                    if(String.isNotBlank(exportLimit)) {
                        query1 += ' LIMIT ' +  Integer.valueOf(exportLimit);
                    } else {
                        query1 +=' Limit 1000';
                    }
                    Schema.SObjectType checkObjectType = SchemaManager.getSObjectTypeFromName(String.escapeSingleQuotes(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name));
                    List<SObject> sobjsWithAllFields = new List<SObject>();
                     try{
                        sobjsWithAllFields = Database.query(query1, AccessLevel.USER_MODE); //NOPMD SOQL Injection - False +ve - Dynamic parts of the query String is escapeSingleQuotes and filterClause value are also escapeSingleQuotes in AppUtils.parseWhereClause method
                        for(Sobject sObj : sobjsWithAllFields){
                            String idValue;
                            if(flexGridInfo[0].Child2FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                                idValue = child2ContentFilter.ContentVersionParentIdsMap.get(String.valueOf(sObj.get('contentDocumentId'))); 
                            }else{
                                idValue = handleRefrencesFieldValue(sObj,parentFieldName.trim());
                            }
                            Map<String,String> sChild2ObjMap = new Map<String,String>();
                            if(child2KeySet.size() > 0){
                               for(String childFieldApi : child2KeySet){
                                    if(!childFieldApi.equalsIgnoreCase('fieldMetaDataConfig')){
                                     sChild2ObjMap.put(childFieldApi,renderFieldValue(sObj,childFieldApi.trim(),'Child2',Child2HideCellMap));    
                                    }
                                }
                            }
                            integer intchild2Index=child2RecordsMap.get(idValue).size();
                                    intchild2Index=intchild2Index+1;
                          child2RecordsMap.get(idValue).add( new recordWrapper(sObj,intchild2Index++,sChild2ObjMap) );
                        // }
                             //temporary added
                         //for(SObject sobj : sobjsWithAllFields) {
                         //   string idValue =handleRefrencesFieldValue(sobj,parentFieldName.trim());                            
                            if(childRecordsMap2.get(idValue) == null){
                                childRecordsMap2.put(idValue, new List<SObject>());
                            }
                            childRecordsMap2.get(idValue).add(sobj);
                            grandChild2RecordsMap.put(sobj.Id, new List<recordWrapper>());
                            grandChild2RecordsByParentId.put(sObj.Id,null);
                         } 
                          // remove hide columns
                        Set<String> child2FieldAPISet=removeHideColumn(child2TableFieldAPIList,parentRecord,Child2HideColumnMap ,getHideGroupingColumnsMap('Child2'));
                        child2TableFieldAPIList.clear();
                        child2FieldAPISet = removeSkipForExportColumn(String.valueOf(flexGridInfo[0].Child2FlexTable__r.SkipFieldsForExport__c) , child2FieldAPISet);
                        child2TableFieldAPIList.addAll(child2FieldAPISet);
                        child2TableHeaderName = tableHeaderMap.get('Child2'); 
                        createChildOverAllTotalMap(childRecordsMap2,'Child2');
                        //getOverAllTotal(sobjsWithAllFields,'Child2');  
                     } catch(Exception ex) {
                         System.debug(ex.getMessage() + ' : Stack ' + ex.getStackTraceString() + '  :  @   ' + ex.getLineNumber());
                        //throw new CustomExceptions.SOQLException(AppUtils.handleSystemExceptionMsg(ex.getMessage()) + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                        throw new CustomExceptions.SOQLException(AppUtils.handleSystemExceptionMsg(ex) + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                     }
                }
            }
        }

    }

    public contentFilterRecord contentFilter(List<String> parentTargetField){
        contentFilterRecord wrapper = new contentFilterRecord();
        List<String> ContentDocumentIDList = new List<String>();
        String filterStr = '(\'' + String.join(parentTargetField, '\',\'') +'\')';
        String query = 'SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN ' + AppUtils.parseWhereClause(filterStr);
        List<ContentDocumentLink> cDLink = Database.query(query, AccessLevel.USER_MODE); //NOPMD SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of filterClause
        for(ContentDocumentLink cDLinkVar: cDLink){
            ContentDocumentIDList.add(String.escapeSingleQuotes(cDLinkVar.ContentDocumentId));
            wrapper.ContentVersionParentIdsMap.put(cDLinkVar.ContentDocumentId,cDLinkVar.LinkedEntityId);
        }
        String ContentDocLinkIds = 'ContentDocumentId in '+ '(\'' + String.join(ContentDocumentIDList, '\',\'') +'\')'; 
        wrapper.ContentVersionFilter = ContentDocLinkIds;
        if(String.isBlank(wrapper.ContentVersionFilter)){
            return new contentFilterRecord(); 
        }
        return wrapper;
    }

    public class contentFilterRecord{
        public Map<String,String> ContentVersionParentIdsMap;
        public String ContentVersionFilter;

        public contentFilterRecord() {
            this.ContentVersionParentIdsMap = new Map<String,String>();
            this.ContentVersionFilter = '';
        }
    }

   private void getGrandChildRecordsCSV() {
        List<recordWrapper> grandChildListRecords = new List<recordWrapper>(); 
        Set<String> grandChildKeySet = new Set<String>();
         Set<String> grandChild2KeySet = new Set<String>();
		contentFilterRecord grandChild1ContentFilter;
        contentFilterRecord grandChild2ContentFilter;
        if(flexGridInfo[0].Child1FlexTable__c != null && flexGridInfo[0].GrandChild1FlexTable__c != null) {
            isTableAvailableMap.put('grandChild1',true);                
            String relationshipField = flexGridInfo[0].GrandChild1FlexTable__r.ParentTargetLookupField__c;
           
            List<String> parentTargetField = new List<String>();
            for(String parentRecId : childRecordsMap.keySet()) {
                if(childRecordsMap.get(parentRecId)!=null){
                    for(SObject sobj : childRecordsMap.get(parentRecId)) {
                      parentTargetField.add((String)sobj.get('Id'));
                    }
                }
            }

            if(parentTargetField.size() > 0) {
                grandChildFieldInfoMap = getFieldMetadata(flexGridInfo[0].GrandChild1FlexTable__r,'GrandChild1');
                grandChildKeySet = grandChildFieldInfoMap.keySet();
                String filterClause=getFilterClause('GrandChild1');
                if(filterClause != Null) { 
                    String parentFieldName = filterClause.split('in:parentTargetField')[0];
                    Set<String> grandchildTableFieldAPISet = new Set<String>();
                    grandchildTableFieldAPIList=flexGridInfo[0].GrandChild1FlexTable__r.FieldNames__c.split(',');
                   // grandchildTableFieldAPISet.addAll(flexGridInfo[0].GrandChild1FlexTable__r.FieldNames__c.split(','));
                    grandchildTableFieldAPISet.add(parentFieldName.trim());
                    for(String flStr:grandchildTableFieldAPISet){
                       if(!flStr.contains('.')){
                            SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name,flStr.trim());
                            if(fld.fieldDesc.getType() == Schema.DisplayType.reference){
                                String frFld = fld.fieldDesc.getName();
                                String refField = frFld.replace('__c', '__r.Name');
                                grandchildTableFieldAPISet.add(refField);
                            }
                        } 
                    } 
                  
                    List<String> temp=new List<String>();
                    List<String> fldList = new List<String>();
                    fldList.AddAll(grandchildTableFieldAPISet);
                    String flds = String.join(fldList, ', ');
                    Map<string, Object> paramRecordChildMap = new Map<string, Object>();
                    paramRecordChildMap=getFlexTableConfigMap('GrandChild1');
                    String order=(String)paramRecordChildMap.get('sortableColumn');
                    String sortDirection=(String)paramRecordChildMap.get('sortDirection');

                    // create qurey for get all data with all fields 
                    grandChild1HideColumnMap=getHideColumnJSONMap('GrandChild1');
                    grandChild1HideCellMap=getHideCellJSONMap('GrandChild1');
                    String fields;
                    Set<String> fildsSet=new Set<String>();
                    for (String key : grandChild1HideCellMap.keySet()) {
                        if(grandChild1HideCellMap.get(key)!=null){
                            fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(grandChild1HideCellMap.get(key));
                            if(fields != null && fields != ''){
                            String[] tempList = fields.split(',');
                            fildsSet.addall(tempList);
                        }
                    }
                    }

                     // fetch records with all fields
                     set<String> grantchild1QueyyFields = (set<String>)paramRecordChildMap.get('queryFieldsList');
                     fildsSet.addall(grantchild1QueyyFields);
                    fildsSet.addall(fldList);
                    temp.addall(fildsSet);
                    String fldsAll = String.join(temp, ', ');
                    if(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        grandChild1ContentFilter = contentFilter(parentTargetField);                        
                    }
                    String query1;
                    if(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(grandChild1ContentFilter.ContentVersionFilter); 
                    }else{
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(filterClause); 
                    }
                    if(order!=null){
                        if(order.contains(',')){
                           sortDirection=null;
                        }
                        query1 += ' ORDER BY ' + String.escapeSingleQuotes(order);
                        if(sortDirection!=null){
                            query1 += ' ' + String.escapeSingleQuotes(sortDirection);
                        
                        }
                     }
                     String exportLimit = KeyValueHolderHelper.getTextValue('childGridExportLimit');
                    if(String.isNotBlank(exportLimit)) {
                        query1 += ' LIMIT ' + Integer.valueOf(exportLimit);
                    } else {
                        query1 +=' Limit 1000';
                    }
                    List<SObject> sobjsWithAllFields = new List<SObject>();
                    List<SObject> sobjs = new List<SObject>();
                    try {
                        sobjsWithAllFields = Database.query(query1 , AccessLevel.USER_MODE); //NOPMD SOQL Injection - False +ve - Dynamic parts of the query String is escapeSingleQuotes and filterClause value are also escapeSingleQuotes in AppUtils.parseWhereClause method
                        for(SObject sobj : sobjsWithAllFields) {
                            String idValue;
                            if(flexGridInfo[0].GrandChild1FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                                idValue = grandChild1ContentFilter.ContentVersionParentIdsMap.get(String.valueOf(sObj.get('contentDocumentId'))); 
                            }else{
                                idValue = handleRefrencesFieldValue(sObj,parentFieldName.trim());
                            }
                            if(grandChildRecordsByParentId.get(idValue) == null){
                                grandChildRecordsByParentId.put(idValue, new List<SObject>());
                            }
                            grandChildRecordsByParentId.get(idValue).add(sobj);

                            Map<String,String> sChild1ObjMap = new Map<String,String>();
                            if(grandChildKeySet.size() > 0){
                                for(String childFieldApi : grandChildKeySet){
                                    if(!childFieldApi.equalsIgnoreCase('fieldMetaDataConfig')){
                                        sChild1ObjMap.put(childFieldApi,renderFieldValue(sobj,childFieldApi.trim(),'GrandChild1',grandChild1HideCellMap));
                                    }
                                }
                            }
                            
                            if(grandChildRecordsMap.get(idValue) == null) {
                                grandChildRecordsMap.put(idValue, new List<recordWrapper>());
                            }
                            integer intgrandchildIndex=grandChildRecordsMap.get(idValue).size();
                            intgrandchildIndex=intgrandchildIndex+1;
                            grandChildRecordsMap.get(idValue).add( new recordWrapper(sObj,intgrandchildIndex, sChild1ObjMap) );
                        }  
                        // remove hide columns
                       Set<String> grandchild1TableFieldAPISet=removeHideColumn(grandchildTableFieldAPIList,parentRecord,grandChild1HideColumnMap,getHideGroupingColumnsMap('GrandChild1'));
                        grandchildTableFieldAPIList.clear();
                        grandchild1TableFieldAPISet = removeSkipForExportColumn(String.valueOf(flexGridInfo[0].GrandChild1FlexTable__r.SkipFieldsForExport__c) , grandchild1TableFieldAPISet);
                        grandchildTableFieldAPIList.addAll(grandchild1TableFieldAPISet); 
                        grandchildTableHeaderName=tableHeaderMap.get('GrandChild1');
                        createChildOverAllTotalMap(grandChildRecordsByParentId,'GrandChild1');

                       // getOverAllTotal(sobjsWithAllFields,'GrandChild1');                      
                    } catch(Exception ex) {
                         System.debug(ex.getMessage() + ' : Stack ' + ex.getStackTraceString() + '  :  @   ' + ex.getLineNumber());
                            //throw new CustomExceptions.SOQLException(ex.getLineNumber() + AppUtils.handleSystemExceptionMsg(ex.getMessage()) + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                            throw new CustomExceptions.SOQLException(ex.getLineNumber() + AppUtils.handleSystemExceptionMsg(ex) + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                    }                                    
                }
            }
        }

        if(flexGridInfo[0].GrandChild2FlexTable__c != null) {
            isTableAvailableMap.put('grandChild2',true);
            String relationshipField = flexGridInfo[0].GrandChild2FlexTable__r.ParentTargetLookupField__c;            
            List<String> parentTargetField = new List<String>();
            for(String parentRecId : childRecordsMap2.keySet()) {
                if(childRecordsMap2.get(parentRecId)!=null){
                    for(SObject sobj : childRecordsMap2.get(parentRecId)) {
                        parentTargetField.add((String)sobj.get('Id'));
                    }
                }else{
                    for(String parentRecId1 : childRecordsMap.keySet()) {
                        if(childRecordsMap.get(parentRecId1)!=null){
                            for(SObject sobj : childRecordsMap.get(parentRecId1)) {
                                parentTargetField.add((String)sobj.get('Id'));
                            }
                        }
                    }
                }
                        
            }
            
            if(parentTargetField.size() > 0) {
                grandChild2FieldInfoMap = getFieldMetadata(flexGridInfo[0].GrandChild2FlexTable__r,'GrandChild2');
                grandChild2KeySet = grandChild2FieldInfoMap.keySet();
                String filterClause=getFilterClause('GrandChild2');
                if(filterClause != Null) { 
                    String parentFieldName = filterClause.split('in:parentTargetField')[0];
                    Set<String> grandchild2TableFieldAPISet = new Set<String>();
                    grandchild2TableFieldAPIList=flexGridInfo[0].GrandChild2FlexTable__r.FieldNames__c.split(',');
                    grandchild2TableFieldAPISet.addAll(grandchild2TableFieldAPIList);
                    grandchild2TableFieldAPISet.add(parentFieldName.trim());
                    
                    for(String flStr:grandchild2TableFieldAPISet){
                       if(!flStr.contains('.')){
                            SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name,flStr.trim());
                            if(fld.fieldDesc.getType() == Schema.DisplayType.reference){
                                String frFld = fld.fieldDesc.getName();
                                String refField = frFld.replace('__c', '__r.Name');
                                grandchild2TableFieldAPISet.add(refField);
                            }
                        } 
                    } 
                    List<String> fldList = new List<String>();
                    fldList.AddAll(grandchild2TableFieldAPISet);
                    String flds = String.join(fldList, ', ');
                    Map<string, Object> paramRecordChildMap = new Map<string, Object>();
                    paramRecordChildMap=getFlexTableConfigMap('GrandChild2');
                    String order=(String)paramRecordChildMap.get('sortableColumn');
                    String sortDirection=(String)paramRecordChildMap.get('sortDirection');

                     // create qurey for get all data with all fields 
                    grandChild2HideColumnMap=getHideColumnJSONMap('GrandChild2');
                    grandChild2HideCellMap=getHideCellJSONMap('GrandChild2');
                    String fields;
                    Set<String> fildsSet=new Set<String>();
                    for (String key : grandChild2HideCellMap.keySet()) {
                        if(grandChild2HideCellMap.get(key)!=null){
                            fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(grandChild2HideCellMap.get(key));
                            if(fields != null && fields != ''){
                            String[] tempList = fields.split(',');
                            fildsSet.addall(tempList);
                            }
                        }
                    }

                     // fetch records with all fields
                    
                    fildsSet.addall(fldList);
                    List<String> temp=new List<String>();
                    
                    temp.addall(fildsSet);
                    String fldsAll = String.join(temp, ', ');
                    if(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        grandChild2ContentFilter = contentFilter(parentTargetField);                        
                    }
                    String query1;
                    if(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(grandChild2ContentFilter.ContentVersionFilter); 
                    }else{
                        query1 = 'SELECT ' + String.escapeSingleQuotes(fldsAll) +' from ' + String.escapeSingleQuotes(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name) + ' where ' + AppUtils.parseWhereClause(filterClause); 
                    }
                    if(order!=null){
                        if(order.contains(',')){
                           sortDirection=null;
                        }
                        query1 += ' ORDER BY ' + String.escapeSingleQuotes(order);
                        if(sortDirection!=null){
                            query1 += ' ' + String.escapeSingleQuotes(sortDirection);
                         }
                       
                     }
                     String exportLimit = KeyValueHolderHelper.getTextValue('childGridExportLimit');
                    if(String.isNotBlank(exportLimit)) {
                        query1 += ' LIMIT ' + Integer.valueOf(exportLimit);
                    } else {
                        query1 +=' Limit 1000';
                    }
                    List<SObject> sobjsWithAllFields = new List<SObject>();
                    try {
                        sobjsWithAllFields = Database.query(query1 , AccessLevel.USER_MODE); //NOPMD SOQL Injection - False +ve - Dynamic parts of the query String is escapeSingleQuotes and filterClause value are also escapeSingleQuotes in AppUtils.parseWhereClause method
                        for(SObject sobj : sobjsWithAllFields) {
                            String idValue;
                            if(flexGridInfo[0].GrandChild2FlexTable__r.SobjectConfig__r.Name == 'ContentVersion'){
                                idValue = grandChild2ContentFilter.ContentVersionParentIdsMap.get(String.valueOf(sObj.get('contentDocumentId'))); 
                            }else{
                                idValue = handleRefrencesFieldValue(sObj,parentFieldName.trim());
                            }
                            if(grandChild2RecordsByParentId.get(idValue) == null){
                                grandChild2RecordsByParentId.put(idValue, new List<SObject>());
                            }
                            grandChild2RecordsByParentId.get(idValue).add(sobj);
                        //}
                        //for(Sobject s : sobjsWithAllFields){
                           
                        //    string idValue =handleRefrencesFieldValue(s,parentFieldName.trim());
                            Map<String,String> sChild2ObjMap = new Map<String,String>();
                            if(grandChild2KeySet.size() > 0){
                                for(String childFieldApi : grandChild2KeySet){
                                    if(!childFieldApi.equalsIgnoreCase('fieldMetaDataConfig')){
                                        sChild2ObjMap.put(childFieldApi,renderFieldValue(sobj,childFieldApi.trim(),'GrandChild2', grandChild2HideCellMap));
                                    }
                                }
                            }
                            
                            if(grandChild2RecordsMap.get(idValue) == null) {
                                grandChild2RecordsMap.put(idValue, new List<recordWrapper>());
                            }
                            integer intgrandchild2Index=grandChild2RecordsMap.get(idValue).size();
                            intgrandchild2Index=intgrandchild2Index+1;
                            grandChild2RecordsMap.get(idValue).add( new recordWrapper(sObj,intgrandchild2Index, sChild2ObjMap) );
                        }  
                        // remove hide columns
                        Set<String> grandchild2FieldAPISet=removeHideColumn(grandchild2TableFieldAPIList,parentRecord,grandChild2HideColumnMap,getHideGroupingColumnsMap('GrandChild2'));
                        grandchild2TableFieldAPIList.clear();
                        grandchild2FieldAPISet = removeSkipForExportColumn(String.valueOf(flexGridInfo[0].GrandChild2FlexTable__r.SkipFieldsForExport__c) , grandchild2FieldAPISet);
                        grandchild2TableFieldAPIList.addAll(grandchild2FieldAPISet);
                        grandchild2TableHeaderName=tableHeaderMap.get('GrandChild2');
                        createChildOverAllTotalMap(grandChild2RecordsByParentId,'GrandChild2');
                       // getOverAllTotal(sobjsWithAllFields,'GrandChild2');
                    } catch(Exception ex) {
                         System.debug(ex.getMessage() + ' : Stack ' + ex.getStackTraceString() + '  :  @   ' + ex.getLineNumber());
                            throw new CustomExceptions.SOQLException(ex.getLineNumber() + ex.getMessage() + ' : Query - ' + query1 + ':flexGridInfo:' + flexGridInfo);
                    }                                    
                }
            }
        }
    }
 
    private String getRefrenceFieldMetadata(Schema.SObjectType objectName,String refFieldName,String fieldName){
    Schema.DescribeSObjectResult sObjDescribe = objectName.getDescribe();
    Map<String, Schema.SObjectField> fieldsMap = sObjDescribe.fields.getMap();
        Schema.SObjectField sObjField = fieldsMap.get(refFieldName);
        if(sObjField == null){
            throw new CustomExceptions.InputDataException(fieldName + ' field is not defined on ' + objectName);
        } 

        Schema.DescribeFieldResult fieldDescribe = sObjField.getDescribe();
        String fieldLabel = null;
        fieldLabel = (fieldName.contains('CreatedById')) ? Label.CreatedBy :
                                (fieldName.contains('LastModifiedById')) ? Label.LastModifiedBy :
                                (fieldName.contains('ContactId')) ? Label.Contact :
                                (fieldName.contains('OwnerId')) ? Label.AssignedTo :
                                (fieldName.contains('RecordTypeId')) ? Label.RecordType :
                                (fieldName.contains('ActivityDate')) ? Label.DueDate :
                                fieldLabel;
        if(fieldLabel == null){
            fieldLabel = fieldDescribe.getLabel()+''; 
        }                      

        return fieldLabel;  
    }

    //
    private String handleRefrencesFieldValue(Sobject sobj, String parentFieldName){
         string relationshipFieldApiName = parentFieldName.trim();
         string idValue = '';
        /* This Code Block check for relationship being present in Filter Clause
           Example : Test__r.Trr__r.IdVal__c
        */
        if(relationshipFieldApiName.contains('.')) {
            Object value = AppUtils.getFieldValue(sobj, relationshipFieldApiName);
            idValue = String.valueOf(value);
        } else {
            idValue = String.valueOf(sobj.get(relationshipFieldApiName));
        }
        return idValue;
    }

    //get Hide column JSON MAp
     private Map<String,String> getHideColumnJSONMap(String level){
        Map<String, String> hideColumnJSON = new Map<String, String>();
       
        FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
        if(flexTableConfigData.DataTableDetailConfigMap!=null){          
        // get flex table details config
        Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> DataTableDetailConfigMap=flexTableConfigData.DataTableDetailConfigMap;
       
            for(String str:DataTableDetailConfigMap.keySet()){
                if(DataTableDetailConfigMap.get(str).HideColumnJSON!=null){
                    hideColumnJSON.put(str,DataTableDetailConfigMap.get(str).HideColumnJSON);
                }

                
            }
        }
        return hideColumnJSON;
    }

    //get Hide Cell JSON MAp
     private Map<String,String> getHideCellJSONMap(String level){
        Map<String, String> hideCellJSON = new Map<String, String>();
       
        FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
        if(flexTableConfigData.DataTableDetailConfigMap!=null){          
        // get flex table details config
        Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> DataTableDetailConfigMap=flexTableConfigData.DataTableDetailConfigMap;
       
            for(String str:DataTableDetailConfigMap.keySet()){
                if(DataTableDetailConfigMap.get(str).HideCellJSON!=null){
                    hideCellJSON.put(str,DataTableDetailConfigMap.get(str).HideCellJSON);
                }
            }
        }
        return hideCellJSON;
    }

    private Map<String,Boolean> getHideGroupingColumnsMap(String level){
        Map<String, Boolean> hideGroupingColumns = new Map<String, Boolean>();
        FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
        if(flexTableConfigData.DataTableDetailConfigMap!=null){          
        Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> DataTableDetailConfigMap=flexTableConfigData.DataTableDetailConfigMap;
            for(String str:DataTableDetailConfigMap.keySet()){
                if(DataTableDetailConfigMap.get(str).HideGroupingColumn == true && DataTableDetailConfigMap.get(str).EnableRowGrouping == true){
                    hideGroupingColumns.put(str,true);
                }
            }
        }
        return hideGroupingColumns;
    }
   

    // return map of table field's API name with label 
    private Map<String,String> getFieldMetadata(DataTableConfig__c dataTableConfigObj, String level){
        Map<String, String> fieldLabelOverride = new Map<String, String>();
        Schema.SObjectType dataTableObjectType;
        FlexGridEnhancedUtility.FlexTableConfigData flexTableConfigData =(FlexGridEnhancedUtility.FlexTableConfigData)flexGridInfoMap.get(level);
        if(flexTableConfigData != null && flexTableConfigData.DataTableDetailConfigMap!=null){          
        // get flex table details config
        Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> DataTableDetailConfigMap=flexTableConfigData.DataTableDetailConfigMap;
            for(String str:DataTableDetailConfigMap.keySet()){
                if(DataTableDetailConfigMap.get(str).FieldLabelOverride!=null){
                    fieldLabelOverride.put(str,DataTableDetailConfigMap.get(str).FieldLabelOverride);
                }
            }
        }
        Map<String,String> fieldLabelMap = new Map<String,String>();
        List<String> fieldAPIName = new List<String>();
        fieldAPIName = dataTableConfigObj.FieldNames__c.split(',');
        String SObjectName = dataTableConfigObj.SobjectConfig__r.Name;       
        dataTableObjectType = SchemaManager.getSObjectTypeFromName(SObjectName);
        Schema.DescribeSObjectResult dataTableObjectResult = dataTableObjectType.getDescribe();
        Map<String,Schema.SObjectField> dataObjectFieldsMap = dataTableObjectResult.fields.getMap();
        for(String field : fieldAPIName) {
            SchemaManager.Field fld = SchemaManager.getFieldSchemaResult(dataTableConfigObj.SobjectConfig__r.Name,field.trim());
            String fieldLabel='';
            String  fieldName = field; 
            if(field != 'Id') {
                // Handle Refrence Metadata Fields Label...
                if(fieldLabelOverride.get(field)==null && fld.fieldDesc.getType() == Schema.DisplayType.reference && fieldName.contains('__r')){
                    Schema.SObjectType referenceObject = dataTableObjectType ;
                    if(fieldName.endsWithIgnoreCase('id') && !fieldName.equalsIgnoreCase('whatid')) {
                        fieldName = fieldName.removeEndIgnoreCase('id');
                        fieldName = fieldName + '.Name';                         
                    }
                    //Split the field string using ".", because this is a reference field so it definitely has a "." in  it, if not refer else part
                    List<String> splitRefField = fieldName.split('\\.',-1);
                    if(splitRefField.size() == 1 ){                     
                        fieldName = fieldName.replace('__c','__r');
                        fieldName += '.Name';
                    }
                    splitRefField = fieldName.split('\\.',-1);
                    String refFieldName =field;
                    if(splitRefField.size() > 1){
                        Map<String, Schema.SObjectField> referenceFieldsMap = new Map<String, Schema.SObjectField>();
                        referenceFieldsMap = dataObjectFieldsMap;
                        for(String splittedField:splitRefField){
                            refFieldName = splittedField;
                           if(splittedField.contains('__r')){
                                splittedField= (splittedField.containsIgnoreCase('__r') ? splittedField.replace('__r','__c'):splittedField +'Id'); 
                                Schema.DescribeFieldResult reffieldDescribe = referenceFieldsMap.get(splittedField.toLowerCase()+'').getDescribe();     
                                referenceObject = reffieldDescribe.getReferenceTo().get(0);  
                            }
                        }
                    }
                    fieldLabel = getRefrenceFieldMetadata(referenceObject,refFieldName,fieldName);
                    fieldLabelMap.put(field,fieldLabel);
                }else{
                    fieldLabel = fld.fieldDesc.getLabel()+'';
                    fieldLabel = (field.contains('CreatedById')) ? Label.CreatedBy :
                                (field.contains('LastModifiedById')) ? Label.LastModifiedBy :
                                (field.contains('ContactId')) ? Label.Contact :
                                (field.contains('OwnerId')) ? Label.AssignedTo :
                                (field.contains('RecordTypeId')) ? Label.RecordType :
                                (field.contains('ActivityDate')) ? Label.DueDate :
                                fieldLabel; // replace equalsIgnoreCase with contains
                    if(fieldLabelOverride.get(field) != null) {
                        fieldLabel = fieldLabelOverride.get(field);
                    }
                    fieldLabelMap.put(field,fieldLabel);
                }
            }
        }
        return fieldLabelMap;
    }

    private String getTwoDecimalsValue(String fieldValue,Integer scale){
        if(scale>2){
            scale=2;
        }
        Decimal decimalValue = Decimal.valueOf(fieldValue);
        decimalValue = decimalValue.setScale(scale, RoundingMode.CEILING);
        fieldValue = decimalValue.format();
        String[] decimalString = fieldValue.split('\\.');
        if(decimalString.size()==1 && scale > 0){
            if(scale==1){
                 fieldValue=fieldValue+'.0';  
            }else{
                if(scale>1){
                  fieldValue=fieldValue+'.00';  
                }
            }            
        }else{
            if(decimalString.size()>1){
                if(decimalString[1].length() < scale){
                    if(decimalString[1].length()==1){                                
                        fieldValue=fieldValue+'0';
                    }
                }else{
                    if(scale!=0){
                         fieldValue=decimalString[0] + '.'+decimalString[1].substring(0,scale);  
                    }else{
                        fieldValue=decimalString[0];
                    }                 
                }
            }                    
        }                   
        return fieldValue;      
    }

    private void getOverAllTotal(list<sObject> recordList, String level){
        String tableid =levelVsTableIdMap.get(level);
        if(overAllTotalMap.get(tableid)!= null){
            Map<String,String> fieldVsOverAllTotal =overAllTotalMap.get(tableid);
            //for(String field : fieldVsOverAllTotal.keySet()){
            for(String field : parentTableFieldAPIList){
                //String dataType=(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field)).Type;
                   String dataType = levelVsFieldVsDataTypeMap.get(level).get(field);
                if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                    Double sum = 0;
                    if(fieldVsOverAllTotal.keySet().contains(field)){
                        for(sObject record : recordList){                           
                            if(levelVsFieldVsHideCellIdMap.get(level).keySet().contains(field)){
                                if(!levelVsFieldVsHideCellIdMap.get(level).get(field).contains(record.Id)){
                                    if(record.get(field) != null){
                                        sum += (Double)record.get(field);
                                    }
                                }
                            }else{                                
                                if(field.containsIgnoreCase('.')){  
                                    String refField;                                     
                                    List<String> colSplit = field.split('\\.',-1);          
                                    Integer i = 0;    
                                    String fieldAPiName;    
                                    String originalField;        
                                    do{
                                        fieldAPiName = colSplit[i++];  
                                        if(fieldAPiName.contains('__r')){
                                            originalField = fieldAPiName.replace('__r','__c');
                                        } 
                                    }while(i < colSplit.size() - 1);  
                                    refField = colSplit[i];
                                    if(record != null && fieldAPiName!= 'Id' && record.get(originalField)!=null){
                                        record = record.getSobject(fieldAPiName);
                                        if( record.get(refField) != null){
                                            sum += (Double)record.get(refField);
                                        }
                                    }
                                }else{
                                    if(record.get(field) != null){                                        
                                        sum += (Double)record.get(field);
                                    }
                                } 
                            }                            
                        }
                        Integer scale;       
                        if(field.contains('.')){
                            scale=((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field)).ReferenceFieldInfo.Scale;
                        }else{
                            scale=((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field)).Scale;                        
                        }
                        String sumString;
                        if(dataType !='DOUBLE'){
                            sumString = getTwoDecimalsValue(String.valueOf(sum),scale);
                        }else{
                            sumString = String.valueOf(sum);
                        }  
                        if(dataType=='CURRENCY'){
                             if(sumString.startsWithIgnoreCase('-')){
                                sumString = '('+ currencySymbol + sumString.remove('-') + ')';
                            } else {
                                 sumString = currencySymbol + sumString;
                            }  
                        }
                        if(dataType=='DOUBLE'){
                             if(sumString.startsWithIgnoreCase('-')){
                                sumString = '('+  sumString.remove('-') + ')';
                            } 
                        }
                        if(dataType=='PERCENT'){
                            sumString=sumString + '%';
                        }                            
                        fieldVsOverAllTotal.put(field,sumString);
                    } else {
                        fieldVsOverAllTotal.put(field,'');
                    }
                }
            }
            overAllTotalMap.put(level,fieldVsOverAllTotal);
        } 
    }

    private void getOverAllTotal(list<sObject> recordList, String level, String parentId){
        String tableid =levelVsTableIdMap.get(level);
        if(overAllTotalMap.get(tableid)!= null){ 
            Map<String,String> fieldVsOverAllTotal = overAllTotalMap.get(tableid);
            for(String field : fieldVsOverAllTotal.keySet()){
               // String dataType=(String)((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field)).Type;
                String dataType=levelVsFieldVsDataTypeMap.get(level).get(field);
                if(dataType=='INTEGER' || dataType=='CURRENCY' || dataType=='PERCENT' || dataType=='DOUBLE'){
                    Double sum = 0;
                    if(fieldVsOverAllTotal.keySet().contains(field)){
                        if(recordList!=null){
                            for(sObject record : recordList){
                                if(levelVsFieldVsHideCellIdMap.get(level).keySet().contains(field)){
                                    if(!levelVsFieldVsHideCellIdMap.get(level).get(field).contains(record.Id)){
                                        if(record.get(field) != null){
                                            sum += (Double)record.get(field);
                                        }
                                    }
                                }else{                                
                                    if(field.containsIgnoreCase('.')){  
                                        String refField;                                     
                                        List<String> colSplit = field.split('\\.',-1);          
                                        Integer i = 0;    
                                        String fieldAPiName;    
                                        String originalField;        
                                        do{
                                            fieldAPiName = colSplit[i++];  
                                            if(fieldAPiName.contains('__r')){
                                                originalField = fieldAPiName.replace('__r','__c');
                                            } 
                                        }while(i < colSplit.size() - 1);  
                                        refField = colSplit[i];
                                        if(record != null && fieldAPiName!= 'Id' && record.get(originalField)!=null){
                                            record = record.getSobject(fieldAPiName);
                                            if( record.get(refField) != null){
                                                sum += (Double)record.get(refField);
                                            }
                                        }
                                    }else{
                                        if(record.get(field) != null){                                        
                                            sum += (Double)record.get(field);
                                        }
                                    } 
                                }                               
                            }
                        }
                        Integer scale;       
                        if(field.contains('.')){
                            scale=((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field)).ReferenceFieldInfo.Scale;
                        }else{
                            scale=((FlexGridEnhancedUtility.FieldDescribe)((Map<String, Object>)flexTableMetaData.get(level)).get(field)).Scale;                        
                        }
                        String sumString;
                        if(dataType !='DOUBLE'){
                            sumString = getTwoDecimalsValue(String.valueOf(sum),scale);
                        }else{
                            sumString = String.valueOf(sum);
                        }                        
                        if(dataType=='CURRENCY'){
                            if(sumString.startsWithIgnoreCase('-')){
                                sumString = '('+ currencySymbol + sumString.remove('-') + ')';
                            } else {
                                sumString = currencySymbol + sumString;
                            }  
                        }
                        if(dataType=='DOUBLE'){
                                if(sumString.startsWithIgnoreCase('-')){
                                    sumString = '('+  sumString.remove('-') + ')';
                                } 
                            }
                        if(dataType=='PERCENT'){
                            sumString=sumString + '%';
                        }  
                        fieldVsOverAllTotal.put(field,sumString);
                    } else {
                        fieldVsOverAllTotal.put(field,'');
                    }
                }
            }
            Map<string, string> tempForfieldVsOverAllTotalMap = new Map<string, string>();
            tempForfieldVsOverAllTotalMap.putall(fieldVsOverAllTotal);
            parenIdVSfieldoverAllTotalMap.put(parentId,tempForfieldVsOverAllTotalMap);
            if(parenIdVSfieldoverAllTotalMap!=null){
                Map<string, Map<string, string>> tempForparenIdVSfieldoverAllTotalMap = new Map<string, Map<string, string>>();
                tempForparenIdVSfieldoverAllTotalMap.putall(parenIdVSfieldoverAllTotalMap);
                childOverAllTotalMap.put(level,tempForparenIdVSfieldoverAllTotalMap);     
            }  
        }   
    }
    private void createChildOverAllTotalMap(Map<Id,List<SObject>> recordMap,String level){
        for(Id parentId:recordMap.keyset()){
            List<sObject> recordList=recordMap.get(parentId);            
            getOverAllTotal(recordList,level,parentId); 
        }
    }      
	private Set<string> removeSkipForExportColumn(String skipForExportFields , Set<String> tableFieldAPISet){
        if(skipForExportFields != null  ){
            for(String fieldApiName :skipForExportFields.split(',')){
                if(tableFieldAPISet.contains(fieldApiName)){
                    tableFieldAPISet.remove(fieldApiName);
                }
            }
        }
        return tableFieldAPISet;
   }		

    public class RecordWrapper {
        public Boolean isSubtotal {get;set;}
        public Map<String,Map<String,String>> recordSubTotal {get;set;}
        public Sobject record {get;set;}
        public Integer index {get;set;}
        public Map<String,String> sObjMap {get;set;}

        public RecordWrapper(Sobject record, Integer index,Map<String,String> sObjMap) {
            this.sObjMap = new Map<String,String>();
            this.record = record;
            this.isSubtotal = false;
            this.index = index;
            this.sObjMap = sObjMap; 
        }

        public RecordWrapper(Sobject record) {
            this.record = record;
            this.isSubtotal = false;
        }

        public RecordWrapper(Boolean b, Map<String,Map<String,String>> rec) { 
            this.recordSubTotal = rec;
            this.isSubtotal = b;
        }
    }
}