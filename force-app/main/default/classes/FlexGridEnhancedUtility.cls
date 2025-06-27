/**
*************************************************
Audit History
*************************************************
2018-06-06     Shantanu Gadhe         Created 
*************************************************
**/
public with sharing  class FlexGridEnhancedUtility {

    public with sharing class InitParams{
        // 1. Intial
        @AuraEnabled public String flexGridName{get;set;}
        @AuraEnabled public String flexGridType{get;set;}
        @AuraEnabled public Integer level{get;set;}
        @AuraEnabled public Id parentRecordId {get;set;}

        public InitParams(String paramJson){
            Map<String,Object> paramsMap = (Map<string, Object>)JSON.deserializeUntyped(paramJson);
            this.flexGridName = String.valueOf(paramsMap.get('Name'));
            this.flexGridType =String.valueOf(paramsMap.get('flexGridType'));
            this.level = Integer.valueOf(paramsMap.get('level'));
            String parentRecordId = String.valueOf(paramsMap.get('parentRecordId'));
            if(String.isNotEmpty(parentRecordId)){
                this.parentRecordId = Id.valueOf(parentRecordId);   
            }
            
        }
    }

    public with sharing class RecordParams{
       @AuraEnabled public String sObjectName {get;set;}
       @AuraEnabled public List<String> queryFieldsList {get;set;}
       @AuraEnabled public String filterCriteria {get;set;}
       @AuraEnabled public Integer pageNumber{get;set;}
       @AuraEnabled public Integer pageSize{get;set;}
       @AuraEnabled public Integer limitValue {get;set;}
       @AuraEnabled public String hideDecisionFields {get;set;}        
       @AuraEnabled public String sortableColumn {get;set;}
       @AuraEnabled public String sortDirection {get;set;}
       @AuraEnabled public String GroupByCluase {get;set;}
       @AuraEnabled public Id parentRecordId {get;set;}
       @AuraEnabled public String enhancedSearchText {get;set;}
	   @AuraEnabled public String updatdFlexHeader{get;set;}
       @AuraEnabled public Id flexTableId{get;set;}


        public RecordParams(String paramJson){
            Map<String,Object> paramsMap = (Map<string, Object>)JSON.deserializeUntyped(paramJson);
            this.sObjectName = String.valueOf(paramsMap.get('sObjectName'));
			this.updatdFlexHeader = String.valueOf(paramsMap.get('updatdFlexHeader'));
            this.flexTableId = (Id)String.valueOf(paramsMap.get('FlexTableId'));           
            List<object> querFieldsObjectList = (List<Object>)paramsMap.get('queryFieldsList');
            enhancedSearchText = String.valueOf(paramsMap.get('enhancedSearchText'));
            queryFieldsList = new List<String>();
            if(String.isNotEmpty(enhancedSearchText)){
                this.enhancedSearchText = enhancedSearchText;   
            }
            for(Object obj : querFieldsObjectList){
                if(obj != null){
                    String strField = (String)obj;
                    queryFieldsList.add(strField);
                }
            }
            this.filterCriteria = String.valueOf(paramsMap.get('filterCriteria'));
            this.pageNumber = Integer.valueOf(paramsMap.get('pageNo'));
            this.pageSize = Integer.valueOf(paramsMap.get('pageSize'));
            this.limitValue = Integer.valueOf(paramsMap.get('limitValue'));
            this.sortableColumn = String.valueOf(paramsMap.get('sortableColumn'));
            this.sortDirection = String.valueOf(paramsMap.get('sortDirection'));
            this.GroupByCluase = String.valueOf(paramsMap.get('GroupByCluase'));
            String parentRecordId = String.valueOf(paramsMap.get('parentRecordId'));
            if(String.isNotEmpty(parentRecordId)){
                this.parentRecordId = Id.valueOf(parentRecordId);   
            }
        }
    }

    public with sharing class FlexGridConfigMetaData{
       @AuraEnabled public Id flexGridId;
       @AuraEnabled public String flexGridName;
       @AuraEnabled public Id parentFlexTableId;
       @AuraEnabled public Boolean IsSpreadSheet;
       @AuraEnabled public String RecordTypeName;
       
        @AuraEnabled public sObject ParentRecord;       
        @AuraEnabled public String ParentRecordTypeName;
        public FlexGridConfigMetaData(FlexGridConfig__c flexGridConfig){
            this.flexGridId = flexGridConfig.Id;
            this.flexGridName = flexGridConfig.Name;
            this.parentFlexTableId = flexGridConfig.ParentFlexTable__c;
            this.IsSpreadSheet = 'SpreadSheet'.equalsIgnoreCase(flexGridConfig.RecordType.Name) ? true : false;
            this.RecordTypeName = flexGridConfig.RecordType.Name;
        }
    }
    public with sharing class FlexTableConfigData{

       @AuraEnabled public DataTableConfig__c FlexTableConfig;        
      @AuraEnabled  public Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>> FlexTableActionMap;
       @AuraEnabled public Map <String, Object> FlexTableConfigMap;
      @AuraEnabled  public Object FieldMetaData;
       @AuraEnabled public List<FlexGridEnhancedUtility.FlexTableListFilterListView> FlexTableFilterListViewList;
       @AuraEnabled public Map<String , FlexGridEnhancedUtility.DataTableDetailInfo> DataTableDetailConfigMap;
       @AuraEnabled public sObject ParentRecord;       
        @AuraEnabled public String ParentRecordTypeName;
        @AuraEnabled public List<FlexGridEnhancedUtility.FlexTableUserListView> flexTableUserListView;
        @AuraEnabled public List<FlexGridEnhancedUtility.FlexTableLookupDetail> lookupDetails;
        public Set<String> ColumnNamesList;
        public Set<String> QueryFieldsList;
        public FlexTableConfigData(){
            
        }
        public FlexTableConfigData(Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>> flexTableActionMap){
            this.FlexTableActionMap = flexTableActionMap;
        }
        public FlexTableConfigData(List<FlexGridEnhancedUtility.FlexTableListFilterListView> flexTableFilterListViewList){
            this.FlexTableFilterListViewList = flexTableFilterListViewList;
        }
        public FlexTableConfigData(List<FlexGridEnhancedUtility.FlexTableUserListView> flexTableUserListView){
            this.flexTableUserListView = flexTableUserListView;
        }
        public FlexTableConfigData(List<FlexGridEnhancedUtility.FlexTableLookupDetail> lookupDetails){
            this.lookupDetails = lookupDetails;
        }
    }

    public with sharing class FlexTableConfig{
       @AuraEnabled public Id FlexTableId;
       @AuraEnabled public String Name ;
       @AuraEnabled public RecordType RecordType ;
       @AuraEnabled public String RecordTypeId ;
       @AuraEnabled public Integer DefaultPageSize ;
       @AuraEnabled public Integer DefaultPageSizeEnhanced ;
       @AuraEnabled public Boolean DisableMenu ;
       @AuraEnabled public Boolean EnableAutoIndex ;
       @AuraEnabled public String AutoIndexBehaviour;
       @AuraEnabled public Boolean EnableExport ;
       @AuraEnabled public Boolean EnableExportXls ;       
       @AuraEnabled public Boolean EnableDataImportExport ;
       @AuraEnabled public Boolean EnableHyperLinkAsText ;
       @AuraEnabled public Boolean EnableFilter ;
       @AuraEnabled public Boolean EnableHelp ;
       @AuraEnabled public Boolean EnableIndexBar ;
       @AuraEnabled public Boolean EnablePageSize ;
       @AuraEnabled public Boolean EnablePagination ;
       @AuraEnabled public Boolean EnableQuickSearch ;
       @AuraEnabled public Boolean EnableRecordSelection ;
       @AuraEnabled public Boolean EnableTotalColumn ;
       @AuraEnabled public Boolean EnableTotalRecordsCount ;
       @AuraEnabled public String FilterCriteria;
       @AuraEnabled public String  RecordSelectionColumnHeader;
       @AuraEnabled public String ShowHideDisabledAction;
       @AuraEnabled public Boolean EnableTotalRow ;
       @AuraEnabled public Boolean ShowHeaderPanel;
       @AuraEnabled public String HeaderDescription;
       @AuraEnabled public String ParentTargetLookupField;
       @AuraEnabled public String FieldNames ;
       @AuraEnabled public String RequiredFields ;
       @AuraEnabled public String Header ;
       @AuraEnabled public String SubHeader;
       @AuraEnabled public String RecordSelectionColumnPosition ;
       @AuraEnabled public String SObjectName ;
       @AuraEnabled public String SortDirection ;
       @AuraEnabled public String OrderBy;
       @AuraEnabled public String PageSizes;
       @AuraEnabled public Integer MaxRecordsCount;
       @AuraEnabled public String HelpConfig;
       @AuraEnabled public String HelpDocId;
       @AuraEnabled public Boolean IsSpreadSheet;
        @AuraEnabled public Boolean EnableGroupedSubTotalRow;
		@AuraEnabled public String SkipFieldsForExport;

        public FlexTableConfig(){ }

        public FlexTableConfig(DataTableConfig__c dataTableConfig,Boolean isGridSpreadSheet){ 
            this.IsSpreadSheet = 'SpreadSheet'.equalsIgnoreCase(dataTableConfig.RecordType.Name) || isGridSpreadSheet ? true : false;
            this.FlexTableId = dataTableConfig.Id;
            this.Name = dataTableConfig.Name ;
            this.RecordType = dataTableConfig.RecordType ;
            this.RecordTypeId = dataTableConfig.RecordTypeId ;
            this.DefaultPageSize = Integer.valueOf((dataTableConfig.DefaultPageSize__c == null ? KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSize',true) : dataTableConfig.DefaultPageSize__c));
            this.DefaultPageSizeEnhanced = dataTableConfig.DefaultPageSizeEnhanced__c == null ? KeyValueStoreHelper.getIntegerValue('FlexTableDefaultPageSize',true) :  Integer.valueOf(dataTableConfig.DefaultPageSizeEnhanced__c);
            this.DisableMenu = dataTableConfig.DisableMenu__c;
            this.EnableAutoIndex = dataTableConfig.EnableAutoIndex__c;
            this.AutoIndexBehaviour = dataTableConfig.AutoIndexBehaviour__c;
            this.EnableExport = dataTableConfig.EnableExport__c;
            this.EnableExportXls = dataTableConfig.EnableExportXls__c;
            this.EnableDataImportExport = dataTableConfig.EnableDataImportExport__c;
            this.EnableFilter = dataTableConfig.EnableFilter__c && !this.isSpreadSheet;
            this.EnableHelp = dataTableConfig.EnableHelp__c;
            this.EnableIndexBar = dataTableConfig.EnableIndexBar__c;
            this.EnablePageSize = dataTableConfig.EnablePageSize__c && !this.isSpreadSheet;
            this.EnablePagination = dataTableConfig.EnablePagination__c && !this.isSpreadSheet;
            this.EnableQuickSearch = dataTableConfig.EnableQuickSearch__c && !this.isSpreadSheet;
            this.EnableRecordSelection = dataTableConfig.EnableRecordSelection__c;
            this.EnableTotalColumn = dataTableConfig.EnableTotalColumn__c;
            this.EnableTotalRecordsCount = dataTableConfig.EnableTotalRecordsCount__c;
            this.EnableHyperLinkAsText = dataTableConfig.EnableHyperLinkAsText__c; 
            this.FilterCriteria = dataTableConfig.FilterCriteria__c;
            this.RecordSelectionColumnHeader = dataTableConfig.RecordSelectionColumnHeader__c;
            this.ShowHideDisabledAction = dataTableConfig.ShowHideDisabledAction__c;
            this.EnableTotalRow = dataTableConfig.EnableTotalRow__c;
            this.ShowHeaderPanel = dataTableConfig.ShowHeaderPanel__c;
            this.HeaderDescription = dataTableConfig.HeaderDescription__c;
            this.FieldNames = dataTableConfig.FieldNames__c;
            this.RequiredFields = dataTableConfig.RequiredFields__c;
            this.Header = dataTableConfig.Header__c;
            this.HelpConfig = dataTableConfig.HelpConfig__c;
            this.SubHeader = dataTableConfig.SubHeaderText__c;
            this.RecordSelectionColumnPosition = dataTableConfig.RecordSelectionColumnPosition__c;
            this.ParentTargetLookupField = dataTableConfig.ParentTargetLookupField__c;
            this.SObjectName = dataTableConfig.SobjectConfig__r.Name;
            this.SortDirection = dataTableConfig.Sort_Direction__c;
            this.OrderBy = dataTableConfig.OrderBy__c;
            this.MaxRecordsCount = KeyValueStoreHelper.getIntegerValue('FlexTableMaxRecordsCount',true);
            this.PageSizes =  KeyValueStoreHelper.getTextValue('FlexTablePageSizeOptions',true)+'';            
            this.EnableGroupedSubTotalRow = dataTableConfig.EnableGroupedSubTotalRow__c;  
			this.SkipFieldsForExport = dataTableConfig.SkipFieldsForExport__c;
        }
    }


    public with sharing class FlexTableActionConfig{
       @AuraEnabled public String Id;
      @AuraEnabled  public String Name;
      @AuraEnabled  public String RecordTypeId;
      @AuraEnabled  public String RecordTypeName;
      @AuraEnabled  public String ActionBehavior;
      @AuraEnabled  public String ActionURL;
      @AuraEnabled  public String ActionURLLong;
      @AuraEnabled  public String ActionURLLongLWC;
      @AuraEnabled  public String ActionClass;
      @AuraEnabled public String ButtonHelpText;
      @AuraEnabled  public String DataTableConfig;
      @AuraEnabled public Boolean EnableParentHideLogic;
      @AuraEnabled  public String DisplayArea;
      @AuraEnabled  public String WhereToOpen;
      @AuraEnabled  public String IconCSS;
       @AuraEnabled public String Location;
      @AuraEnabled  public Decimal ModalHeight;
       @AuraEnabled public Decimal ModalWidth;
      @AuraEnabled  public String ModalTitle;
      @AuraEnabled  public Decimal Sequence;
      @AuraEnabled  public String StandardAction;
      @AuraEnabled  public Boolean HideAction;
      @AuraEnabled  public String HideDecisionField; 
      @AuraEnabled  public String SingleRowEditBehavior;
      @AuraEnabled  public String EditableRows;
       @AuraEnabled public String HeaderActionDisplayType;       
      @AuraEnabled  public String HideOperator;
       @AuraEnabled public String HideExpressionJSON;
         @AuraEnabled public String HideExpressionFields;
       @AuraEnabled public String RefreshBehaviour;
       @AuraEnabled public Boolean ShowConfirmationBox; 
       @AuraEnabled public String ConfirmationMessage;
       @AuraEnabled public Boolean SkipRollbackLogic;
		@AuraEnabled public String  MessageConfig;

        public FlexTableActionConfig(){}

        public FlexTableActionConfig(DataTableAction__c flexTableAction){
            this.Id = flexTableAction.Id;
            this.Name = flexTableAction.Name;
            this.RecordTypeId = flexTableAction.RecordTypeId;
            this.RecordTypeName = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosById().get(this.RecordTypeId).getname();
            this.ActionBehavior = flexTableAction.ActionBehavior__c;
            this.ActionURL = flexTableAction.ActionURL__c;
            this.ActionURLLong = flexTableAction.ActionURLLong__c;
            this.ActionURLLongLWC = flexTableAction.ActionURLLongLWC__c;
            this.ActionClass = flexTableAction.ActionClass__c;
            this.ButtonHelpText = flexTableAction.ButtonHelpText__c;
            this.DataTableConfig = flexTableAction.DataTableConfig__c;
            this.WhereToOpen = flexTableAction.WhereToOpen__c;
            this.SingleRowEditBehavior = flexTableAction.SingleRowEditBehavior__c;
            this.EnableParentHideLogic = flexTableAction.EnableParentHideLogic__c;
            this.EditableRows = flexTableAction.EditableRows__c;
            this.DisplayArea = flexTableAction.DisplayArea__c;
            this.HeaderActionDisplayType = flexTableAction.HeaderActionDisplayType__c;
            this.IconCSS = flexTableAction.IconCSS__c;
            this.Location = flexTableAction.Location__c;
            this.ModalHeight = flexTableAction.ModalHeight__c;
            this.ModalWidth = flexTableAction.ModalWidth__c;
            this.ModalTitle = flexTableAction.ModalTitle__c;
            this.Sequence = flexTableAction.Sequence__c;
            this.StandardAction = flexTableAction.StandardAction__c;
            this.HideDecisionField = flexTableAction.HideDecisionField__c;
            this.HideOperator = flexTableAction.HideOperator__c;
            if(flexTableAction.SobjectActionConfig__c != null)
            {
                if(flexTableAction.SobjectActionConfig__r.HideExpressionFields__c != null){
                
                    this.HideExpressionJSON = flexTableAction.SobjectActionConfig__r.HideExpressionJSON__c;
                }else{
                
                    this.HideExpressionJSON = flexTableAction.HideExpressionJSON__c;

                }
                this.HideExpressionFields = flexTableAction.SobjectActionConfig__r.HideExpressionFields__c;

            }
            else{
                this.HideExpressionFields = flexTableAction.HideExpressionFields__c;
              this.HideExpressionJSON = flexTableAction.HideExpressionJSON__c;
            }
            this.RefreshBehaviour = flexTableAction.RefreshBehavior__c;
            this.ShowConfirmationBox = flexTableAction.ShowConfirmationBox__c;
            this.MessageConfig = flextableAction.MessageConfig__r.MessageRich__c;
            this.ConfirmationMessage = flexTableAction.ConfirmationMessage__c;
            this.SkipRollbackLogic = flexTableAction.SkipRollbackLogic__c;
        }

        public DataTableAction__c FlexTableActionToObject(FlexTableActionConfig flexTableAction){
            DataTableAction__c actionConfig = new DataTableAction__c();
            actionConfig.Id = flexTableAction.Id;
            actionConfig.Name = flexTableAction.Name;
            actionConfig.RecordTypeId = flexTableAction.RecordTypeId;
            actionConfig.ActionBehavior__c = flexTableAction.ActionBehavior;
            actionConfig.ActionURL__c = flexTableAction.ActionURL;
            actionConfig.ActionURLLong__c = flexTableAction.ActionURLLong;
            actionConfig.ActionURLLongLWC__c = flexTableAction.ActionURLLongLWC;
            actionConfig.ActionClass__c = flexTableAction.ActionClass;

            //actionConfig.DataTableConfig__c = (Id)flexTableAction.DataTableConfig;
            actionConfig.DisplayArea__c = flexTableAction.DisplayArea;
            actionConfig.IconCSS__c = flexTableAction.IconCSS;
            actionConfig.Location__c = flexTableAction.Location;
            actionConfig.ModalHeight__c = flexTableAction.ModalHeight;
            actionConfig.ModalWidth__c = flexTableAction.ModalWidth;
            actionConfig.ModalTitle__c = flexTableAction.ModalTitle;
            actionConfig.Sequence__c = flexTableAction.Sequence;
            actionConfig.StandardAction__c = flexTableAction.StandardAction;
            actionConfig.HideDecisionField__c = flexTableAction.HideDecisionField;
            actionConfig.HideOperator__c = flexTableAction.HideOperator;                        
            actionConfig.HideExpressionJSON__c = flexTableAction.HideExpressionJSON; 
            actionConfig.ShowConfirmationBox__c = flexTableAction.ShowConfirmationBox;
            actionConfig.ConfirmationMessage__c = flexTableAction.ConfirmationMessage;
            actionConfig.SkipRollbackLogic__c = flexTableAction.SkipRollbackLogic;
            return actionConfig;
        }
    }

    public with sharing class DataTableDetailInfo{
        @AuraEnabled public Id Id;
       @AuraEnabled public String RenderType;
        @AuraEnabled public String FieldAPIName;
       @AuraEnabled public String FieldLabelOverride;
       @AuraEnabled public String WhereClause;
       @AuraEnabled public String DefaultValue;
       @AuraEnabled public String DisplayField;
       @AuraEnabled public String SubTotalLabel;
       @AuraEnabled public String HelpText;
       @AuraEnabled public Boolean EnableRowGrouping;
       @AuraEnabled public Boolean EnableTotal;
       @AuraEnabled public Boolean EnableColumnSubtotalPercentage;
       @AuraEnabled public String ColumnSubtotalPercentageJSON;
       @AuraEnabled public Boolean EnableSubTotal;
       @AuraEnabled public Boolean EnableOverAllTotal;
       @AuraEnabled public Boolean EnableEditDisplayField;
       @AuraEnabled public Boolean EscapeHtml;
       @AuraEnabled public String FieldWidth;
       @AuraEnabled public String HideCellJSON;
       @AuraEnabled public String HideColumnJSON;
       @AuraEnabled public String ReadOnlyCellJSON;
       @AuraEnabled public String ReadOnlyColumnJSON;
       @AuraEnabled public String StyleAttribute;
       @AuraEnabled public String StyleClass;
       @AuraEnabled public String Formula;
       @AuraEnabled public String FormulaJSON;
       @AuraEnabled public Boolean HideGroupingColumn;
       @AuraEnabled public Boolean ShowLinkAsText;

        public DataTableDetailInfo(DataTableDetailConfig__c dataTableDetailInfo){
            this.Id = dataTableDetailInfo.Id;
            this.DefaultValue = dataTableDetailInfo.DefaultValue__c;
            this.RenderType = dataTableDetailInfo.RenderType__c;
            this.FieldAPIName = dataTableDetailInfo.FieldAPIName__c;
            this.FieldLabelOverride = dataTableDetailInfo.FieldLabelOverride__c;
            this.WhereClause = dataTableDetailInfo.WhereClause__c;
            this.EnableTotal = dataTableDetailInfo.EnableTotal__c;
            this.EnableColumnSubtotalPercentage = dataTableDetailInfo.EnableColumnSubtotalPercentage__c;            
            this.ColumnSubtotalPercentageJSON = dataTableDetailInfo.ColumnSubtotalPercentageJSON__c;
            this.EnableSubTotal = dataTableDetailInfo.EnableSubTotal__c;
            this.EnableOverAllTotal = dataTableDetailInfo.EnableOverAllTotal__c;
            this.EnableEditDisplayField = dataTableDetailInfo.EnableEditDisplayField__c;
            this.EscapeHtml = dataTableDetailInfo.EscapeHtml__c;
            this.DisplayField = dataTableDetailInfo.DisplayFields__c;
            this.FieldWidth = dataTableDetailInfo.FieldWidthEnhanced__c;
            this.SubTotalLabel = dataTableDetailInfo.SubTotalLabel__c;
            this.HelpText = dataTableDetailInfo.HelpText__c;
            this.EnableRowGrouping = dataTableDetailInfo.EnableRowGrouping__c;
            this.HideCellJSON = dataTableDetailInfo.HideCellJSON__c;
            this.HideColumnJSON = dataTableDetailInfo.HideColumnJSON__c;
            this.ReadOnlyCellJSON = dataTableDetailInfo.ReadOnlyCellJSON__c;
            this.ReadOnlyColumnJSON = dataTableDetailInfo.ReadOnlyColumnJSON__c;  
            this.StyleAttribute = dataTableDetailInfo.StyleAttribute__c;
            this.StyleClass = dataTableDetailInfo.StyleClass__c;
            this.Formula = dataTableDetailInfo.Formula__c;
            this.FormulaJSON = dataTableDetailInfo.FormulaJSON__c;
            this.HideGroupingColumn = dataTableDetailInfo.HideGroupingColumn__c;
            this.ShowLinkAsText = dataTableDetailInfo.ShowLinkAsText__c;
        }
    }
    public with sharing class FlexTableListFilterListView{
       @AuraEnabled public Id ListViewId;
       @AuraEnabled public String FilterClause;
       @AuraEnabled public Boolean IsActive;
       @AuraEnabled public Boolean IsDefault;
       @AuraEnabled public String Label;
       @AuraEnabled public Boolean ShowInPdf;
       @AuraEnabled public Boolean IsMasterView;
       @AuraEnabled public String InternalUniqueId;
       @AuraEnabled public Boolean IsUserListView;

        public  FlexTableListFilterListView(FlexTableFilterListViewConfig__c flexTableFilterListViewConfig){
            this.ListViewId = flexTableFilterListViewConfig.Id;
            this.FilterClause = flexTableFilterListViewConfig.FilterClause__c;
            this.IsActive = flexTableFilterListViewConfig.IsActive__c;
            this.IsDefault = flexTableFilterListViewConfig.IsDefault__c;
            this.IsMasterView = flexTableFilterListViewConfig.IsMasterView__c;
            this.ShowInPdf = flexTableFilterListViewConfig.ShowInPDF__c;
            this.InternalUniqueId = flexTableFilterListViewConfig.InternalUniqueID__c;
            this.Label = flexTableFilterListViewConfig.Label__c;
        }
    }

    public with sharing class FieldDescribe{
       @AuraEnabled public String Name;
       @AuraEnabled public String DefaultValue;
       @AuraEnabled public String DefaultValueFormula;
       @AuraEnabled public String Type;
       @AuraEnabled public String Label;
       @AuraEnabled public Boolean IsNillable;
       @AuraEnabled public Boolean IsCreateable;
       @AuraEnabled public Boolean IsUpdateable;
       @AuraEnabled public Integer fieldLength;
       @AuraEnabled public Integer PrecisionLength;
       @AuraEnabled public Integer ScaleLength;
       @AuraEnabled public String ColumnWidth;
       @AuraEnabled public String Reference;
       @AuraEnabled public String FieldDisplay;
       @AuraEnabled public Boolean IsFormulaField;        
       @AuraEnabled public Boolean IsFilterable;
       @AuraEnabled public Boolean IsLookup;
       @AuraEnabled public Boolean EscapeHtml;
       @AuraEnabled public String FieldPath;
       @AuraEnabled public Integer Scale;
       @AuraEnabled public Boolean IsAutoNumber;
       @AuraEnabled public String ReferenceTo;
       @AuraEnabled public FieldDescribe ReferenceFieldInfo;
       @AuraEnabled public Map <String, Object> PickListFieldInfo;
       @AuraEnabled public List<String> PicklistValues;
       @AuraEnabled public List<FlexGridEnhancedUtility.FlexTableLookupDetail> lookupDetails;
       @AuraEnabled public Boolean IsRequired;
        public FieldDescribe(){
        }

        public FieldDescribe(Schema.DescribeFieldResult fieldDescribe){
            this.IsUpdateable = fieldDescribe.isUpdateable();
            this.fieldLength = fieldDescribe.getLength();
            this.PrecisionLength = fieldDescribe.getPrecision();
            this.ScaleLength = fieldDescribe.getScale();
            this.DefaultValue = String.valueOf(fieldDescribe.getDefaultValue());
            this.Type = String.valueOf(fieldDescribe.getType());
            this.DefaultValueFormula = String.valueOf(fieldDescribe.getDefaultValueFormula());
            this.IsNillable = fieldDescribe.isNillable();
            this.IsFormulaField = fieldDescribe.isCalculated();
            this.IsAutoNumber = fieldDescribe.isAutoNumber();
            this.IsCreateable = fieldDescribe.isCreateable();
            this.Name = fieldDescribe.getName();
            this.Label = fieldDescribe.getLabel();
            this.Scale = fieldDescribe.getScale();
            
            if(fieldDescribe.getReferenceTo().size() > 0){
                this.ReferenceTo = fieldDescribe.getReferenceTo()[0].getDescribe().getName();
            }
            this.IsRequired = !fieldDescribe.isNillable() && !fieldDescribe.isDefaultedOnCreate();
        }
        public FieldDescribe(List<FlexGridEnhancedUtility.FlexTableLookupDetail> lookupDetails){
            this.lookupDetails = lookupDetails;
        }
        
        
    }
    
    public with sharing class LookupData{
       @AuraEnabled public String id;
       @AuraEnabled public String text;
        
        public LookupData(Object id, Object text){
            this.id = String.valueOf(id);
            this.text = String.valueOf(text);
        }
    }
	
	 public with sharing class FlexTableUserListView{
       @AuraEnabled public Id UserListViewId;
       @AuraEnabled public Id FlexTableListView;
       @AuraEnabled public Id FlexTableId;
       @AuraEnabled public Id UserId;



       public  FlexTableUserListView(FlexTableListViewUserConfig__c flexTableFilterListViewUserConfig){
            this.UserListViewId = flexTableFilterListViewUserConfig.Id;
            this.FlexTableListView = flexTableFilterListViewUserConfig.FlexTableListViewConfig__c;
            this.FlexTableId = flexTableFilterListViewUserConfig.FlexTableConfig__c;
            this.UserId = flexTableFilterListViewUserConfig.User__c;
        }
    }
	public with sharing class FlexTableLookupDetail{
        @AuraEnabled public Id SObjectconfigId;
        @AuraEnabled public String Name ;
        @AuraEnabled public String DisplayLookupFields;
        //@AuraEnabled public Id UserId;
 
 
 
        public  FlexTableLookupDetail(SobjectConfig__c flexTableLookupDetails){
             this.SObjectconfigId = flexTableLookupDetails.Id;
             this.Name = flexTableLookupDetails.Name;
             this.DisplayLookupFields = flexTableLookupDetails.DisplayFieldsAPIName__c;
             
         }
     }
}