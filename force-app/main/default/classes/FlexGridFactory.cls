/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-20-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class FlexGridFactory{


        public static String getFlexGridInfoFields(){
            String flexGridInfoFields = 'Id,Name,'+
                                        'Child1FlexTable__r.Name, '+
                                        'Child2FlexTable__c, '+
                                        'GrandChild1FlexTable__c, '+
                                        'GrandChild2FlexTable__c, '+
                                        'RecordType.Name, ';
            List<String> flexTableFieldList = getFlexTableFields();
            for(String flexTableField: flexTableFieldList){
                flexGridInfoFields += 'ParentFlexTable__r.'+flexTableField+',';
            }
            flexGridInfoFields.removeEnd(',');                           
            return flexGridInfoFields;
        }


        public static List<String> getFlexTableFields(){
            List<String> fieldList = new List<String>();
            fieldList.add('ActionDisplayType__c');
            fieldList.add('Name');
            fieldList.add('HelpConfig__c');
            fieldList.add('FieldNames__c');
            fieldList.add('Additionalcolumns__c');
            fieldList.add('SobjectConfig__r.Name');
            fieldList.add('DefaultPageSize__c');
            fieldList.add('DefaultPageSizeEnhanced__c');
            fieldList.add('FilterCriteria__c');
            fieldList.add('OrderBy__c');
            fieldList.add('Sort_Direction__c');
            fieldList.add('Header__c');
            fieldList.add('EnableRecordSelection__c');
            fieldList.add('RecordSelectionColumnHeader__c');
            fieldList.add('EnableExport__c');
            fieldList.add('EnableExportXls__c');
            fieldList.add('EnableDataImportExport__c');
            fieldList.add('EnableHyperLinkAsText__c');
            fieldList.add('EnableHelp__c');
            fieldList.add('DisableMenu__c');
            fieldList.add('SubHeaderText__c');
            fieldList.add('ShowHeaderPanel__c');
            fieldList.add('EnableIndexBar__c');
            fieldList.add('EnablePagination__c');
            fieldList.add('EnablePageSize__c');
            fieldList.add('SubTotalEvaluatorJSON__c');
            fieldList.add('EnableAutoIndex__c');
            fieldList.add('AutoIndexBehaviour__c');
            fieldList.add('EnableTotalRecordsCount__c');
            fieldList.add('EnableFilter__c');
            fieldList.add('EnableQuickSearch__c');
            fieldList.add('QuickSearchBehaviour__c');
            fieldList.add('ParentTargetLookupField__c');
            fieldList.add('HeaderDescription__c');
            fieldList.add('HideRecordSelectionDecisionField__c');
            fieldList.add('ShowHideDisabledAction__c');
            fieldList.add('MassEditableGridConfigJSON__c');
            fieldList.add('RecordSelectionColumnPosition__c');
            fieldList.add('ReadOnlyFields__c');
            fieldList.add('RequiredFields__c');
            fieldList.add('StickySearchPlaceHolderText__c');
            fieldList.add('StickySearchFieldApiName__c');
            fieldList.add('EnableTotalColumn__c');
            fieldList.add('RecordTypeId');
            fieldList.add('RecordType.Name');
            fieldList.add('RecordType.DeveloperName');
            fieldList.add('RowGroupingFieldsJSON__c');
            fieldList.add('BudgetGridEditCondition__c');
            fieldList.add('EnableTotalRow__c');
            fieldList.add('TotalRowLabel__c');
            fieldList.add('HideColumnsText__c');
            fieldList.add('ReadOnlyFieldsJSON__c');
            fieldList.add('ColumnGroupingFieldJSON__c');
            fieldList.add('SummarizableField__c');
            fieldList.add('EnableGroupedSubTotalRow__c');
			fieldList.add('SkipFieldsForExport__c');
            fieldList.add('Disable_sort_order__c');
            return fieldList;
        }


        public static String getDataTableDetailFields(){
            String fieldMetadataFields = ' EnableTotal__c,'+
                                         ' EnableRowGrouping__c,'+
                                         ' EnableSubTotal__c,' +
                                         ' EnableColumnSubtotalPercentage__c,'+
                                         ' ColumnSubtotalPercentageJSON__c, '+
                                         ' EnableOverAllTotal__c,' +
                                         ' EnableEditDisplayField__c,' +
                                         ' SubTotalLabel__c,'+
                                         ' EscapeHtml__c,'+
                                         ' FieldAPIName__c,'+
                                         ' FieldLabelOverride__c,'+
                                         ' FieldWidthEnhanced__c,'+
                                         ' WhereClause__c,'+
                                         ' DefaultValue__c,'+
                                         ' RenderType__c,'+
                                         ' HelpText__c,'+
                                         ' DisplayFields__c,'+
                                         ' HideCellJSON__c,'+
                                         ' HideColumnJSON__c,'+
                                         ' HideGroupingColumn__c,'+
                                         ' ReadOnlyCellJSON__c,'+
                                         ' ReadOnlyColumnJSON__c,'+
                                         ' StyleAttribute__c,'+
                                         ' StyleClass__c,' + 
                                         ' Formula__c,' + 
                                         ' ShowLinkAsText__c,' + //new field added
                                         ' Enable_Text_Wrapping__c,' + //new field added
                                         ' FormulaJSON__c,'+
                                         ' DecimalPlaces__c,' ;//+ 
                                        // ' DisableSortOrder__c';
            return fieldMetadataFields;
        }

        
        public static String getFlexTableActionConfigFields(){
            String fieldMetadataFields = 'id, Name, RecordTypeId,' +
                                         ' ActionBehavior__c,' +
                                         ' ActionClass__c,' +
                                         ' ActionURL__c,' +
                                         ' ActionURLLong__c,' + 
                                         ' ActionURLLongLWC__c,'+
                                         ' ButtonHelpText__c,' + 
                                         ' DataTableConfig__c,' + 
                                         ' DisplayArea__c,' + 
                                         ' WhereToOpen__c,' + 
                                         ' HeaderActionDisplayType__c,' + 
                                         ' HideDecisionField__c,' + 
                                         ' HideExpressionFields__c,' + 
                                         ' HideExpressionJSON__c,' + 
                                         ' EnableParentHideLogic__c,' +
                                         ' HideForProfile__c,' + 
                                         ' HideForRole__c,' + 
                                         ' HideForUser__c,' + 
                                         ' HideOperator__c,' +
                                         ' EditableRows__c,' +
                                         ' SingleRowEditBehavior__c,' +
                                         ' IconCSS__c,' + 
                                         ' Location__c,' + 
                                         ' ModalHeight__c,' +
                                         ' ModalTitle__c,' + 
                                         ' ModalWidth__c,' + 
                                         ' RefreshBehavior__c,' + 
                                         ' Sequence__c,' + 
                                         ' SobjectActionConfig__c,' + 
                						 ' SobjectActionConfig__r.HideExpressionJSON__c ,' + 
                                         ' SobjectActionConfig__r.HideExpressionFields__c ,' + 
                                         ' ShowConfirmationBox__c,' +
                                         ' ConfirmationMessage__c,' +
                                         ' StandardAction__c,' +
                                         ' MessageConfig__r.MessageRich__c,'+
                                         ' SkipRollbackLogic__c';
                                         // FROM DataTableAction__c
            return fieldMetadataFields;
        }

        public static String getFlexTableFilterListView(){
            String filterListViewFields = 'Id, '+
                                          'FilterClause__c, '+
                                          'IsActive__c, '+
                                          'IsDefault__c, '+
                                          'IsMasterView__c, '+
                                          'ShowInPDF__c, '+
                                          'InternalUniqueID__c, '+
                                          'Label__c, '+
                                          'FlexTableConfig__c';
            return  filterListViewFields;
        } 

          public static String getFlexTableUserListView(){
            String filterUserListViewFields = 'Id, '+
                                            'FlexTableConfig__c, '+
                                            'FlexTableListViewConfig__c, '+
                                            'User__c, '+
                                            'Name';
                return  filterUserListViewFields;
        }
       	public static String getFlexTableLookupDetails(){
            String flexTablelookupfields  = 'Id, '+
                                          'Name, '+
                                          'DisplayFieldsAPIName__c';
            return  flexTablelookupfields;
        } 

    }