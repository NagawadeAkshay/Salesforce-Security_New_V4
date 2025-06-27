import getPageRecordsMap from '@salesforce/apex/FlexGridEnhancedCtrl.getPageRecordsMap';
import { toplevelActionMap,QuickSearch,handleSortDirection} from './action';
import { getRowGroupingData,evaluateFormulaJSON,getOverAllTotal,getSessionData,setSessionData,getCurrentListViewSessionData,getStandardFieldName,removeDuplicates} from './evaluate';
import { expressionEvaluatorme,parentExpressionEval,isEmpty1,generateRowLevelHideActionMap } from './expressionevaluator'

import updateFlexTableListViewConfig from '@salesforce/apex/FlexTableStickySearchCtrl.updateFlexTableListViewConfig';

var unOrderedRowGroupingFieldList = [];
export function setVariable(lwcFlexTableHandler){

        var ColumnNamesList=[];
        let data= lwcFlexTableHandler.tableMetaData;
        
        ColumnNamesList                 =[...data.FlexTableConfigMap.ColumnNamesList];
        lwcFlexTableHandler.FieldMetaData             =data.FlexTableConfigMap.FieldMetaData;
        lwcFlexTableHandler.DataTableDetailConfigMap  = data.DataTableDetailConfigMap;
        lwcFlexTableHandler.flexTableConfig           = data.FlexTableConfigMap.FlexTableConfig;
        lwcFlexTableHandler.userListViewList          = data.flexTableUserListView;
        lwcFlexTableHandler.FlexTableActionMap         =data.FlexTableActionMap;
        lwcFlexTableHandler.FlexTableId               = data.FlexTableConfigMap.FlexTableConfig.FlexTableId;
        lwcFlexTableHandler.colLength                 = lwcFlexTableHandler.tableMetaData.FlexTableConfigMap.ColumnNamesList.length+1;
        lwcFlexTableHandler.requiredfields            = lwcFlexTableHandler.flexTableConfig.RequiredFields != undefined ? lwcFlexTableHandler.flexTableConfig.RequiredFields.split(',') : undefined;
        lwcFlexTableHandler.displayFieldNames          = data.FlexTableConfigMap.ColumnNamesList;
        lwcFlexTableHandler.currentUserInfo            = lwcFlexTableHandler.initResult.CurrentUserInfo;
        lwcFlexTableHandler.flexGridEnhanced_currentPageURL=window.location.href;
        lwcFlexTableHandler.EnableFilter              = data.FlexTableConfigMap.FlexTableConfig.EnableFilter != undefined ? data.FlexTableConfigMap.FlexTableConfig.EnableFilter : false;
        lwcFlexTableHandler.EnableQuickSearch              = data.FlexTableConfigMap.FlexTableConfig.EnableQuickSearch != undefined ? data.FlexTableConfigMap.FlexTableConfig.EnableQuickSearch : false;
        lwcFlexTableHandler.SObjectName               = data.FlexTableConfigMap.FlexTableConfig.SObjectName  != undefined ? data.FlexTableConfigMap.FlexTableConfig.SObjectName  : ''; 
        lwcFlexTableHandler.hideCheckBoxColumn        =lwcFlexTableHandler.flexTableConfig.EnableRecordSelection === true ? true : false;
        lwcFlexTableHandler.showRowNumberColumn       =lwcFlexTableHandler.flexTableConfig.EnableAutoIndex === true ? true : false;
        lwcFlexTableHandler.defaultSort= lwcFlexTableHandler.flexTableConfig.OrderBy != undefined ? lwcFlexTableHandler.flexTableConfig.OrderBy.split(',') : undefined;
        lwcFlexTableHandler.nameSpace = lwcFlexTableHandler.initResult.NameSpacePrefix;
        lwcFlexTableHandler.EnableExport              =lwcFlexTableHandler.flexTableConfig.EnableExport != undefined ? lwcFlexTableHandler.flexTableConfig.EnableExport : false;
        lwcFlexTableHandler.EnableExportXls            =lwcFlexTableHandler.flexTableConfig.EnableExportXls != undefined ? lwcFlexTableHandler.flexTableConfig.EnableExportXls : false;
        let standardFieldsArr = ['lastmodifiedby','createdby','owner'];
        for(let i=0; i < ColumnNamesList.length; i++) {
            if(standardFieldsArr.includes(ColumnNamesList[i].toLowerCase())){
                let fieldName= getStandardFieldName(ColumnNamesList[i])
                ColumnNamesList[i] = fieldName != '' ? fieldName : ColumnNamesList[i];
            }
                
            if(lwcFlexTableHandler.FieldMetaData && lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]] != undefined &&  lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].DefaultValue != undefined){
                let defaultvalues = {};
                defaultvalues['fieldName'] =ColumnNamesList[i];
                defaultvalues['defaultValue'] = lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].DefaultValue;
                lwcFlexTableHandler.DefaulValuesList.push(defaultvalues);
            }  
           }
        if(data.FlexTableConfigMap.FlexTableConfig.SObjectName == 'ContentNote'){
            lwcFlexTableHandler.SObjectContentNote = true;
        } 
        if(data.FlexTableConfigMap.FlexTableConfig.SObjectName == 'GNT__FormInstance__c'){
            lwcFlexTableHandler.sObjectFormInstance = true;
        } 
        lwcFlexTableHandler.defaultSortDirection = lwcFlexTableHandler.flexTableConfig.SortDirection != undefined ?  lwcFlexTableHandler.flexTableConfig.SortDirection : undefined;
        
      
        if(lwcFlexTableHandler.initResult.ParentRecord != undefined){
            lwcFlexTableHandler.ParentRecord =lwcFlexTableHandler.initResult.ParentRecord;
           
            let ParentrecordList= [];
            ParentrecordList.push(lwcFlexTableHandler.ParentRecord);
            getdatarecords(lwcFlexTableHandler,ParentrecordList,true);
        }
        if(lwcFlexTableHandler.flexTableConfig.EnableAutoIndex == true){
            lwcFlexTableHandler.colLength = lwcFlexTableHandler.colLength + 1;
        }
        if(lwcFlexTableHandler.flexTableConfig.EnableRecordSelection == true){
            lwcFlexTableHandler.colLength = lwcFlexTableHandler.colLength + 1;
        }
        if(lwcFlexTableHandler.initResult.Child1 != undefined || lwcFlexTableHandler.initResult.Child2 != undefined ){
            lwcFlexTableHandler.colLength = lwcFlexTableHandler.colLength + 1;
        }
        if(lwcFlexTableHandler.flexTableConfig.HeaderDescription != undefined && lwcFlexTableHandler.flexTableConfig.HeaderDescription != ''){
                
            lwcFlexTableHandler.ShowHelptextContent = lwcFlexTableHandler.flexTableConfig.HeaderDescription;
            lwcFlexTableHandler.ShowHeaderHelpText = true;
        }
		if(lwcFlexTableHandler.flexTableConfig.SubHeader != undefined && lwcFlexTableHandler.flexTableConfig.SubHeader != ''){
            lwcFlexTableHandler.SubHeaderDescription = lwcFlexTableHandler.flexTableConfig.SubHeader;
            lwcFlexTableHandler.SubHeader = true;
        }

        if(lwcFlexTableHandler.gridLevel == 0){
        
            if(lwcFlexTableHandler.initResult.ParentFlexTable != undefined ){
                lwcFlexTableHandler.tableObjectsMap['Parent'] = lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.SObjectName;
                lwcFlexTableHandler.levelVsTableIdMap['Parent'] = lwcFlexTableHandler.FlexTableId;
                lwcFlexTableHandler.tableObjectIdMap[lwcFlexTableHandler.tableObjectsMap['Parent']] = lwcFlexTableHandler.FlexTableId ;
                lwcFlexTableHandler.tableIdVsObjectAPIMap[lwcFlexTableHandler.FlexTableId] = lwcFlexTableHandler.tableObjectsMap['Parent'];
                lwcFlexTableHandler.queryfieldsMap[lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.QueryFieldsList;
                lwcFlexTableHandler.disableMenu = lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.DisableMenu != undefined ? lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.DisableMenu : false;
                if(lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField != undefined){
                    lwcFlexTableHandler.parentLookupFieldMap[lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField;
                }
                

            }
            if(lwcFlexTableHandler.initResult.Child1 != undefined){
                lwcFlexTableHandler.tableObjectsMap['Child1'] = lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.SObjectName;
                lwcFlexTableHandler.levelVsTableIdMap['Child1'] = lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.FlexTableId;
                lwcFlexTableHandler.queryfieldsMap[lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.QueryFieldsList;
                if(lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField != undefined){
                    lwcFlexTableHandler.parentLookupFieldMap[lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField;                }
    
            }
            if(lwcFlexTableHandler.initResult.Child2 != undefined){
                lwcFlexTableHandler.tableObjectsMap['Child2'] = lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.SObjectName;
                lwcFlexTableHandler.levelVsTableIdMap['Child2'] = lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.FlexTableId;
                lwcFlexTableHandler.queryfieldsMap[lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.QueryFieldsList;
                if(lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField != undefined){
                    lwcFlexTableHandler.parentLookupFieldMap[lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField;
                }
    
            }
            if(lwcFlexTableHandler.initResult.GrandChild1 != undefined){
                lwcFlexTableHandler.tableObjectsMap['GrandChild1'] = lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.SObjectName;
                lwcFlexTableHandler.levelVsTableIdMap['GrandChild1'] = lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.FlexTableId;
                lwcFlexTableHandler.queryfieldsMap[lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.QueryFieldsList;
                if(lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField != undefined){
                    lwcFlexTableHandler.parentLookupFieldMap[lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField;
                }
    
            }
            if(lwcFlexTableHandler.initResult.GrandChild2 != undefined){
                lwcFlexTableHandler.tableObjectsMap['GrandChild2'] = lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.SObjectName;
                lwcFlexTableHandler.levelVsTableIdMap['GrandChild2'] = lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.FlexTableId;
                lwcFlexTableHandler.queryfieldsMap[lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.QueryFieldsList;
                if(lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField != undefined){
                    lwcFlexTableHandler.parentLookupFieldMap[lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.FlexTableId] = lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.ParentTargetLookupField;
                }
    
            }
        }
        
       

        var keyWiseFormulaJSON={};
        if(lwcFlexTableHandler.DataTableDetailConfigMap != undefined ){
            for(var key in lwcFlexTableHandler.DataTableDetailConfigMap){
            let value = lwcFlexTableHandler.DataTableDetailConfigMap[key];
            let keyField    =    lwcFlexTableHandler.DataTableDetailConfigMap[key].DisplayField != undefined  ? key.replace('__c', '__r') + '.' +lwcFlexTableHandler.DataTableDetailConfigMap[key].DisplayField : key;
            let fieldType   =    lwcFlexTableHandler.FieldMetaData[keyField].Type != 'REFERENCE'  ?  lwcFlexTableHandler.FieldMetaData[keyField].Type  : lwcFlexTableHandler.FieldMetaData[keyField].ReferenceFieldInfo.Type;
            let isRowGroupingEnabled = false;
            if(value.EnableRowGrouping){
                unOrderedRowGroupingFieldList.push(key);
                
                 if(value.HideGroupingColumn){
                    lwcFlexTableHandler.visibleColumns.push(key);
                 }
                
                
            }   

                
            if(value.EnableSubTotal === true){
                if((["INTEGER","PERCENT","DOUBLE","CURRENCY"].indexOf(fieldType) != -1)){
                    lwcFlexTableHandler.subTotalEnabledColumn.push(key);
                }
            }

            if(lwcFlexTableHandler.DataTableDetailConfigMap[key] != undefined  && lwcFlexTableHandler.DataTableDetailConfigMap[key].HideColumnJSON != undefined){
                let hideExpressionResult = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(lwcFlexTableHandler.DataTableDetailConfigMap[key].HideColumnJSON), true, true);
                lwcFlexTableHandler.finalParentExpressionEval = undefined;                         
                lwcFlexTableHandler.hideColumnJSONMap[key] = parentExpressionEval(lwcFlexTableHandler,hideExpressionResult);                  
            }

                if(lwcFlexTableHandler.hideColumnJSONMap[key] != undefined){
                    if(lwcFlexTableHandler.hideColumnJSONMap[key] === true){                            
                        for(var i=0;  i< ColumnNamesList.length; i++){
                            if(ColumnNamesList[i] === key){
                                ColumnNamesList.splice(i,1);                                
                            }
                        }
                    }
                }
                if(lwcFlexTableHandler.DataTableDetailConfigMap[key] != undefined  && lwcFlexTableHandler.DataTableDetailConfigMap[key].ReadOnlyColumnJSON != undefined){
                    let hideExpressionResult = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(lwcFlexTableHandler.DataTableDetailConfigMap[key].ReadOnlyColumnJSON), true, true);
                    lwcFlexTableHandler.finalParentExpressionEval = undefined;                         
                    lwcFlexTableHandler.readOnlyColumnJSONMap[key] = parentExpressionEval(lwcFlexTableHandler,hideExpressionResult);   
                }
                if(lwcFlexTableHandler.DataTableDetailConfigMap[key] != undefined  && lwcFlexTableHandler.DataTableDetailConfigMap[key].ReadOnlyCellJSON != undefined){
                    let hideCellExpressionResult = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(lwcFlexTableHandler.DataTableDetailConfigMap[key].ReadOnlyCellJSON), false, false);
                    if(lwcFlexTableHandler.FieldMetaData[keyField].Type == 'REFERENCE'){
                        lwcFlexTableHandler.readOnlyCellJSONMap[getReferenceFieldName(lwcFlexTableHandler,key).toLowerCase()] = hideCellExpressionResult
                    }else{
                        lwcFlexTableHandler.readOnlyCellJSONMap[key] = hideCellExpressionResult; 

                    }  
                       
                }
                if(lwcFlexTableHandler.DataTableDetailConfigMap[key] != undefined && lwcFlexTableHandler.DataTableDetailConfigMap[key].EnableOverAllTotal === true && (["INTEGER","PERCENT","DOUBLE","CURRENCY"].indexOf(fieldType) != -1)){
                    lwcFlexTableHandler.OverAllColumnsFields.push(key);
                }
                
                if(lwcFlexTableHandler.DataTableDetailConfigMap[key] != undefined && lwcFlexTableHandler.DataTableDetailConfigMap[key].FormulaJSON != undefined){
                    
                    keyWiseFormulaJSON[key]= JSON.parse(lwcFlexTableHandler.DataTableDetailConfigMap[key].FormulaJSON);
                    let keyWiseFormulaJSONList = Object.keys(keyWiseFormulaJSON[key]);
                    if(Object.keys(keyWiseFormulaJSON[key]).includes('GRANDTOTAL')){
                        lwcFlexTableHandler.OverAllColumns[key.toLowerCase()] = keyWiseFormulaJSON[key]['GRANDTOTAL'];
                        lwcFlexTableHandler.OverAllColumns['isEdit'] = false;
                        lwcFlexTableHandler.OverAllColumns['isOverAllTotal'] = true;
                         
                    } 

                }
                
                
                if(value.DefaultValue != undefined){
                    let DefaultValue = replaceAllMergeFields(lwcFlexTableHandler,value.DefaultValue)
                    if(lwcFlexTableHandler.FieldMetaData[value.FieldAPIName].Type != 'REFERENCE'){ 
                        let defaultvalues = {};
                        defaultvalues['fieldName'] = value.FieldAPIName;
                        defaultvalues['defaultValue'] = DefaultValue;
                        lwcFlexTableHandler.DefaulValuesList.push(defaultvalues);
    
                    }else{
                    
                        let defaultvalues = {};
                        defaultvalues['fieldName'] = value.FieldAPIName;
                        defaultvalues['defaultValue'] = JSON.parse(DefaultValue).Id != undefined ? JSON.parse(DefaultValue).Id : '';
                        lwcFlexTableHandler.DefaulValuesList.push(defaultvalues);
                    }
              
                }
            }
        }

        lwcFlexTableHandler.FormulaJSON=keyWiseFormulaJSON;
        if(data.FlexTableConfigMap.ColumnNamesList != undefined && data.FlexTableConfigMap.ColumnNamesList.length > 0){
            let fieldNamesList = data.FlexTableConfigMap.ColumnNamesList;
            
            for(let index=0; index < fieldNamesList.length; index++){
                if(unOrderedRowGroupingFieldList.indexOf(fieldNamesList[index]) != -1){
                    let fieldName;
                    if(lwcFlexTableHandler.FieldMetaData[fieldNamesList[index]].Type === 'REFERENCE' ){
                        fieldName=getReferenceFieldName(lwcFlexTableHandler,fieldNamesList[index]);
                    }
                    else {                            
                        fieldName=fieldNamesList[index];                            
                    }
                    lwcFlexTableHandler.rowGroupingFieldList.push(fieldNamesList[index]);
                    //this.sortablecloumnList.push(fieldNamesList[index]);
                }
            }
        }
          
        if(ColumnNamesList.length > 0){
        
            createColumnStructre(lwcFlexTableHandler,ColumnNamesList);
        }
        
        if (ColumnNamesList.length > 5 && lwcFlexTableHandler.gridLevel == 0) {
           
            lwcFlexTableHandler.tableWidth =  "width:"+ (ColumnNamesList.length -1) * 25 +'%;' 
            if (ColumnNamesList.length > 10) {
                lwcFlexTableHandler.dropdownwidth = "width:42px !important;";
            }
        }

        lwcFlexTableHandler.FlexTableFilterListViewList=data.FlexTableFilterListViewList;
        lwcFlexTableHandler.isListViewPresent = checkFilterClause(lwcFlexTableHandler);
            if(lwcFlexTableHandler.userListViewList != undefined && lwcFlexTableHandler.userListViewList != ''){
                let listviewId =  lwcFlexTableHandler.userListViewList[0].FlexTableListView;
                let filterClause ;
                  for (let i = 0; i < lwcFlexTableHandler.FlexTableFilterListViewList.length; i++) {
                    let filterListView = lwcFlexTableHandler.FlexTableFilterListViewList[i];
                    if(filterListView.ListViewId === listviewId){
                        filterClause = filterListView.FilterClause;
                        lwcFlexTableHandler.Header= filterListView.Label != undefined ? filterListView.Label : lwcFlexTableHandler.flexTableConfig.Header != undefined ? lwcFlexTableHandler.flexTableConfig.Header : lwcFlexTableHandler.flexTableConfig.Name;;
                    }
                  }
                  if(filterClause != undefined && filterClause != ''){
                    lwcFlexTableHandler.masterFilterClause = filterClause;
                    if(lwcFlexTableHandler.masterFilterClause != undefined){
                        if(lwcFlexTableHandler.masterFilterClause.includes('parentId')){
                            lwcFlexTableHandler.masterFilterClause = lwcFlexTableHandler.masterFilterClause.replace(new RegExp('{!parentId}', 'g'), escape(lwcFlexTableHandler.parentId));
                    
                        }
                    }
                  }else{
                    lwcFlexTableHandler.masterFilterClause = '';
                  }
            } else{
            		
            	if(!lwcFlexTableHandler.isListViewPresent){
			
                    lwcFlexTableHandler.masterFilterClause =lwcFlexTableHandler.flexTableConfig.FilterCriteria != undefined ? lwcFlexTableHandler.flexTableConfig.FilterCriteria : '';
                    if(lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField != undefined && lwcFlexTableHandler.parentId != undefined ){
                        let appendClause = lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField+' = '+'\''+escape(lwcFlexTableHandler.parentId)+'\'';
                        lwcFlexTableHandler.isParentTargetLookupField = true;
                        (lwcFlexTableHandler.masterFilterClause == '' || lwcFlexTableHandler.masterFilterClause == undefined) ? appendClause :lwcFlexTableHandler.masterFilterClause;
                        lwcFlexTableHandler.masterFilterClause = lwcFlexTableHandler.masterFilterClause.replace(new RegExp('{!parentId}', 'g'), escape(lwcFlexTableHandler.parentId));
                        lwcFlexTableHandler.Header=lwcFlexTableHandler.flexTableConfig.Header != undefined ? lwcFlexTableHandler.flexTableConfig.Header : lwcFlexTableHandler.flexTableConfig.Name;

                    }
                    else{
                        lwcFlexTableHandler.Header=lwcFlexTableHandler.flexTableConfig.Header != undefined ? lwcFlexTableHandler.flexTableConfig.Header : lwcFlexTableHandler.flexTableConfig.Name;
                    }
                
                }   
            }
        lwcFlexTableHandler.CurrentFilterCriteria = lwcFlexTableHandler.masterFilterClause
        lwcFlexTableHandler.masterFilterClause =  replaceAllMergeFields(lwcFlexTableHandler,lwcFlexTableHandler.masterFilterClause);
       //LocalStorage
          let sessionStr = getSessionData(lwcFlexTableHandler);
          lwcFlexTableHandler.initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};
        if(lwcFlexTableHandler.FlexTableActionMap.Row != undefined && lwcFlexTableHandler.FlexTableActionMap.Row.length > 0){
        
            lwcFlexTableHandler.AllRowActions = setActionOrders(lwcFlexTableHandler,lwcFlexTableHandler.FlexTableActionMap.Row);
            if(lwcFlexTableHandler.AllRowActions.length > 0) {
                lwcFlexTableHandler.isRowActionPresent =  true;
               }
        }
            
        getSortData(lwcFlexTableHandler);
        
        if(ColumnNamesList != undefined && ColumnNamesList.length > 0){
            lwcFlexTableHandler.optionsMap['Equal'] = {'label':'equals to', 'value':'='};
            lwcFlexTableHandler.optionsMap['NotEqual'] = {'label':'not equals to', 'value':'!='};
            lwcFlexTableHandler.optionsMap['Greater'] = {'label':'greater than', 'value':'>'};
            lwcFlexTableHandler.optionsMap['Lesser'] = {'label':'less than', 'value':'<'};
            lwcFlexTableHandler.optionsMap['GreaterEq'] = {'label':'greater than or equal to', 'value':'>='};
            lwcFlexTableHandler.optionsMap['LesserEq'] = {'label':'less than or equal to', 'value':'<='};
            lwcFlexTableHandler.optionsMap['Contains'] = {'label':'contains', 'value':'Contains'};
            lwcFlexTableHandler.optionsMap['DoesNotContain'] = {'label':'does not contains', 'value':'DoesNotContain'};
            lwcFlexTableHandler.optionsMap['StartsWith'] = {'label':'starts with', 'value':'StartsWith'};
            lwcFlexTableHandler.optionsMap['EndsWith'] = {'label':'ends with', 'value':'EndsWith'};
            lwcFlexTableHandler.optionsMap['Excludes'] = {'label':'excludes', 'value':'Excludes'};
            lwcFlexTableHandler.optionsMap['Includes'] = {'label':'includes', 'value':'Includes'};
            lwcFlexTableHandler.FieldsOption = CreateFieldOptions(lwcFlexTableHandler,ColumnNamesList);
            getOperatorOptions(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[ColumnNamesList[0]]);
            
        }else{
            lwcFlexTableHandler.filterWarning = 'Advanced filter will not be applicable for '+'<b>'+'Reference and Multi-pickList '+'</b>'+'fields.';
            lwcFlexTableHandler.EnableFilter = false;
        }

        if(lwcFlexTableHandler.flexTableConfig.PageSizes != undefined && lwcFlexTableHandler.flexTableConfig.PageSizes != null){
            lwcFlexTableHandler.pageSizes = lwcFlexTableHandler.flexTableConfig.PageSizes.split(';');
         
            for(let index = 0 ; index < lwcFlexTableHandler.pageSizes.length ; index++){
                
                
                lwcFlexTableHandler.pageSizesMap.push({'value' : lwcFlexTableHandler.pageSizes[index], 'label' : lwcFlexTableHandler.pageSizes[index]});
                if(index === lwcFlexTableHandler.pageSizes.length-1 ){
                    lwcFlexTableHandler.pageSizesMap.push({'value' :  'All', 'label' : 'All'});
                }
            }
        }
        let enhancedSearchText = null;
        let PangeNo = null;
        let pageSize;
        let limitValue;
        let uniqueFields = removeDuplicates(data.FlexTableConfigMap.QueryFieldsList);
        lwcFlexTableHandler.dataparamJsonRecord={
            sObjectName        : data.FlexTableConfigMap.FlexTableConfig.SObjectName,
            queryFieldsList    : uniqueFields,
            enhancedSearchText : enhancedSearchText,
            filterCriteria     : lwcFlexTableHandler.masterFilterClause,
            pageNo             : PangeNo,
            pageSize           : pageSize,
            limitValue         : limitValue,
            sortableColumn     : lwcFlexTableHandler.sortableColumn,
            sortDirection      : lwcFlexTableHandler.sortdirection,
            GroupByCluase      : '',
            parentRecordId     : lwcFlexTableHandler.parentId,
        }; 

        lwcFlexTableHandler.isCollapsed = true;
        lwcFlexTableHandler.collapsedicon = 'utility:up';
        let ifrefesh = false; 
        getdata(lwcFlexTableHandler,ifrefesh);
        if(lwcFlexTableHandler.FlexTableActionMap.Row != undefined && lwcFlexTableHandler.FlexTableActionMap.Row.length > 0){
        
            lwcFlexTableHandler.AllRowActions = setActionOrders(lwcFlexTableHandler,lwcFlexTableHandler.FlexTableActionMap.Row);
        }
       // generateRowLevelHideActionMap(lwcFlexTableHandler);
       if(lwcFlexTableHandler.isRemoveSessioStorage == false){
       
          
        toplevelActionMap(lwcFlexTableHandler,ifrefesh);
   }

}

function getSortData(lwcFlexTableHandler){

    let sortdingrection = lwcFlexTableHandler.flexTableConfig.SortDirection != undefined ? lwcFlexTableHandler.flexTableConfig.SortDirection === 'ASC' ? lwcFlexTableHandler.flexTableConfig.SortDirection: 'DESC NULLS LAST':'ASC';
    let sortdirection = lwcFlexTableHandler.flexTableConfig.SortDirection != undefined ? lwcFlexTableHandler.flexTableConfig.SortDirection : 'ASC';
 
    let sortablecolumnsplit=[];
    let sortableColumn = '' ;
    let sortableColumnList;
    if(lwcFlexTableHandler.rowGroupingFieldList != undefined && lwcFlexTableHandler.rowGroupingFieldList.length > 0){
        
        sortableColumn = lwcFlexTableHandler.rowGroupingFieldList[0] != undefined ? lwcFlexTableHandler.rowGroupingFieldList[0] +' '+ sortdirection : '' ;
        for(let index=1; index < lwcFlexTableHandler.rowGroupingFieldList.length; index++){

            sortableColumn = sortableColumn+','+lwcFlexTableHandler.rowGroupingFieldList[index]+' '+sortdirection;
            
            

            }
            sortableColumnList = sortableColumn;
    }

    if(lwcFlexTableHandler.flexTableConfig.OrderBy != undefined ){
        sortablecolumnsplit = lwcFlexTableHandler.flexTableConfig.OrderBy.split(',');
        if(lwcFlexTableHandler.flexTableConfig.OrderBy.toUpperCase().includes('ASC') || lwcFlexTableHandler.flexTableConfig.OrderBy.toUpperCase().includes('DESC')){
            sortableColumn = sortablecolumnsplit[0] === undefined ? '' : sortableColumn != undefined && sortableColumn != '' ? sortableColumn +','+ sortablecolumnsplit[0] : sortablecolumnsplit[0];
          }else{
              sortableColumn = sortablecolumnsplit[0] === undefined ? '' : sortableColumn != undefined && sortableColumn != '' ? sortableColumn +','+sortablecolumnsplit[0]+' '+lwcFlexTableHandler.flexTableConfig.SortDirection :  sortablecolumnsplit[0]+' '+sortdirection;

          }

          sortableColumnList = sortablecolumnsplit[0] === undefined ? '' : sortablecolumnsplit[0];
          if(lwcFlexTableHandler.flexTableConfig.OrderBy.toUpperCase().includes('ASC') || lwcFlexTableHandler.flexTableConfig.OrderBy.toUpperCase().includes('DESC')){

              sortdirection='';

              for(let index=1; index < sortablecolumnsplit.length; index++){
                  sortableColumn = sortableColumn+','+sortablecolumnsplit[index];
                  sortableColumnList = sortableColumnList+','+sortablecolumnsplit[index];                
              }
          }else{

       // sortableColumn = sortablecolumnsplit[0] === undefined ? sortableColumn : sortablecolumnsplit[0]+' '+sortdingrection ;
        sortableColumnList = sortablecolumnsplit[0] === undefined ? '' : sortablecolumnsplit[0];
        for(let index=1; index < sortablecolumnsplit.length; index++){
            sortableColumn = sortableColumn+','+sortablecolumnsplit[index]+' '+sortdingrection;
            sortableColumnList = sortableColumnList+','+sortablecolumnsplit[index];           
        
        }

        if(lwcFlexTableHandler.flexTableConfig.OrderBy.toUpperCase().includes('ASC') || lwcFlexTableHandler.flexTableConfig.OrderBy.toUpperCase().includes('DESC')){
            sortdirection='';
        }
    }
        
    }else{
        if(sortableColumn === ''){
            sortableColumn='LastModifiedDate '+sortdirection;
            sortableColumnList='LastModifiedDate';
        }
       
    }
    let sortdirectionLabel;
    if(sortdirection === 'ASC'){
        sortdirectionLabel = 'ascending order ';
    }else{
        sortdirectionLabel = 'descending order ';
    }
    lwcFlexTableHandler.SortWay = sortdirection;
    let sortedColumnList = sortableColumn != undefined ? sortableColumn.split(',') : '';
    lwcFlexTableHandler.SorttableColumnList = sortedColumnList;
        
    for(let i=0; i < sortedColumnList.length; i++){
        let orderby = [];
        let label;
        let fieldName = sortedColumnList[i] === 'lastmodifieddate' ? 'LastModifiedDate' : sortedColumnList[i];
        orderby= fieldName.split(' ');
        if(orderby.length > 1){
            fieldName =   orderby[0];  
        }
        if((orderby[1] != undefined && orderby[1].toLowerCase() === 'asc') || (sortdirection!= undefined && sortdirection.toLowerCase() === 'asc')){
            sortdirectionLabel = 'ascending order ';
        }else{
            sortdirectionLabel = 'descending order ';
        }
        lwcFlexTableHandler.SortOrderMessage = lwcFlexTableHandler.SortOrderMessage != undefined ? lwcFlexTableHandler.SortOrderMessage : '';
        
        if(lwcFlexTableHandler.FieldMetaData[fieldName].Type === 'REFERENCE' ){
        
            label = lwcFlexTableHandler.DataTableDetailConfigMap[fieldName] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldName].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldName].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldName].ReferenceFieldInfo.Label : lwcFlexTableHandler.FieldMetaData[fieldName].ReferenceFieldInfo.Label;
            
        }else{
            label = lwcFlexTableHandler.DataTableDetailConfigMap[fieldName] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldName].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldName].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldName].Label  : lwcFlexTableHandler.FieldMetaData[fieldName].Label;

        }
        if(lwcFlexTableHandler.displayFieldNames.includes(fieldName) == false || lwcFlexTableHandler.rowGroupingFieldList.length > 0){
            lwcFlexTableHandler.showSortMsg =true;
            lwcFlexTableHandler.showSortMsgData =true;

        let comma = i === sortedColumnList.length-1 ? '' : ',';
        lwcFlexTableHandler.SortOrderMessage = lwcFlexTableHandler.SortOrderMessage +label+' '+sortdirectionLabel+comma;
        }
        
    }


    lwcFlexTableHandler.SortOrderMessageTitle = lwcFlexTableHandler.SortOrderMessage != undefined ?  lwcFlexTableHandler.SortOrderMessageTitle + lwcFlexTableHandler.SortOrderMessage : lwcFlexTableHandler.SortOrderMessage;
    sortableColumn = sortableColumn != undefined ? sortableColumn + ',Id' : '';
    lwcFlexTableHandler.sortableColumn = sortableColumn;
    lwcFlexTableHandler.sortdirection  = sortdirection;
    if(lwcFlexTableHandler.initSessionData != undefined &&  lwcFlexTableHandler.initSessionData != null){
        if(lwcFlexTableHandler.initSessionData.sortDirection != undefined){
          lwcFlexTableHandler.sortdirection = lwcFlexTableHandler.initSessionData.sortDirection == 'asc' ? 'ASC' : 'DESC NULLS LAST';

          lwcFlexTableHandler.showSortMsg =false;
        }
        if(lwcFlexTableHandler.initSessionData.sortfieldname != undefined){
          let fieldTypeCheck = lwcFlexTableHandler.columns.filter(item => item.fieldName.toLowerCase() === lwcFlexTableHandler.initSessionData.sortfieldname.toLowerCase());
          if( fieldTypeCheck[0].FieldMetaData.Type.toLowerCase() !== 'textarea'){
            lwcFlexTableHandler.sortableColumn  = lwcFlexTableHandler.initSessionData.sortfieldname;
          }
        }
        if(lwcFlexTableHandler.initSessionData.showResetMessage != undefined){
          lwcFlexTableHandler.isResetMessage = lwcFlexTableHandler.initSessionData.showResetMessage;
        }
  }
}

function createColumnStructre(lwcFlexTableHandler,ColumnNamesList){


    let columndata = [];
   
    if(lwcFlexTableHandler.flexTableConfig.EnableAutoIndex === true && lwcFlexTableHandler.flexTableConfig.EnableAutoIndex != undefined){

        let column={};
        column['label']       = '#';
        column['fieldName']     = 'Sr__No';
        column['fieldType']   = 'text';
        //column['fixedWidth'] = 'width:25px!important';
        column['fixedWidth'] = 'width:40px!important;resize: none;text-align:center;overflow:hidden !important';
        column['sortable']    = false;
        column['isSorted']    = false;
        column['sortUp']  = false;
        column['sortDown']  = false;
        column['sortUpClass']  =  column['sortUp']== false ? "hideArrow" : "showArrow" ;//hidden
        column['sortDownClassShow']  =  column['sortDown']== false ? "hideArrow" : "showArrow" ;//hidden
        column['index'] = true;
        lwcFlexTableHandler.columns.push(column);
               
    }

    let index =  ColumnNamesList.indexOf('Id');
    if (index > -1) {
        ColumnNamesList.splice(index, 1);
    }
    lwcFlexTableHandler.QuickSearchColumnList = ColumnNamesList;
    for(var i=0; i < ColumnNamesList.length; i++){

        if(JSON.stringify(lwcFlexTableHandler.FieldMetaData).includes(ColumnNamesList[i])){

            if(lwcFlexTableHandler.visibleColumns != undefined && lwcFlexTableHandler.visibleColumns.length > 0){
            
                if(!(lwcFlexTableHandler.visibleColumns.includes(ColumnNamesList[i]))){
                    getfielddata(lwcFlexTableHandler,ColumnNamesList[i]);
                }
            }else{
            
                   getfielddata(lwcFlexTableHandler,ColumnNamesList[i]);
            }
        }
    }


}


function getfielddata(lwcFlexTableHandler,fieldname){
    let standardFieldsArr = ['recordtypeid','lastmodifiedbyid','createdbyid','ownerid','createddate','lastmodifieddate'];
    let column ={};
    column['label'] = lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldname].Label  : lwcFlexTableHandler.FieldMetaData[fieldname].Label;
    column['sortable']    = true;
    column['fixedWidth'] = '';
    column['FieldMetaData'] = lwcFlexTableHandler.FieldMetaData[fieldname];
    column['Detailconfig'] = lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] : undefined;
    column['SobjectName'] = lwcFlexTableHandler.tableMetaData.FlexTableConfigMap.FlexTableConfig.SObjectName;
    column['index']  = fieldname == 'sr__no'? true:false;
    column['readOnly'] = lwcFlexTableHandler.readOnlyColumnJSONMap[fieldname] != undefined && lwcFlexTableHandler.readOnlyColumnJSONMap[fieldname] == true ?true :false;
    column['ShowHelpText'] = lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].HelpText != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].HelpText : undefined  : undefined;
    column['fieldLevelshowToolTip'] = false;/*Bug 367150:*/
    if(lwcFlexTableHandler.requiredfields != undefined && lwcFlexTableHandler.requiredfields.length >0 && lwcFlexTableHandler.requiredfields.includes(fieldname)){
        column['isRequired'] = lwcFlexTableHandler.requiredfields.includes(fieldname)  ? true  : false;
    }
    else if(lwcFlexTableHandler.FieldMetaData[fieldname]!=undefined){
        column['isRequired'] = lwcFlexTableHandler.FieldMetaData[fieldname].IsRequired && lwcFlexTableHandler.FieldMetaData[fieldname].IsUpdateable ? true:false;
    }
    if(standardFieldsArr.includes(fieldname.toLowerCase()))
    {
        column['readOnly']  = true;
    }
    if(lwcFlexTableHandler.defaultSort != undefined && lwcFlexTableHandler.defaultSort.length > 1 ){
        let sortColumm = [];
        for(var i=0;i < lwcFlexTableHandler.defaultSort.length ;i++){
            if(lwcFlexTableHandler.defaultSort[i].includes(fieldname) && lwcFlexTableHandler.defaultSort[i].split(' ')[0].toLowerCase() === fieldname.toLowerCase()){
                sortColumm = lwcFlexTableHandler.defaultSort[i].split(' '); 
                let direction;
                    if(sortColumm[1] == undefined){
                        direction = lwcFlexTableHandler.defaultSortDirection != undefined ? lwcFlexTableHandler.defaultSortDirection : 'asc';
                    }else{
                        direction = sortColumm[1];
                    }
                    column['isSorted'] = true;
                    column['sortUp'] =direction.toLowerCase() == 'asc' ? true: false;
                    column['sortDown'] =direction.toLowerCase() == 'desc' ? true: false;
                    column['sortUpClass']  = direction.toLowerCase() == 'asc'   ? "showArrow" : "hideArrow" ;//hidden asc arrow
                    column['sortDownClassShow']  =direction.toLowerCase() == 'desc'  ? "showArrow" : "hideArrow" ;//hidden desc arrow
                     break;              
            }else{
            column['isSorted'] = false;
            column['sortUp'] = false;
            column['sortDown'] =false;
            column['sortUpClass']  =  column['sortUp']== false ? "hideArrow" : "showArrow" ;//hidden
            column['sortDownClassShow']  =  column['sortDown']== false ? "hideArrow" : "showArrow" ;//hidden
        }
        }
    }else if(lwcFlexTableHandler.defaultSort != undefined  && lwcFlexTableHandler.defaultSort[0].includes(fieldname)){///order by contains single field
            column['isSorted'] = true;
           if(lwcFlexTableHandler.defaultSortDirection != undefined){
            column['sortUp'] = lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'asc' ? true: false;
            column['sortDown'] =lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'desc' ? true: false;
            column['sortUpClass']  = lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'asc'  ? "showArrow" : "hideArrow " ;//hidden asc arrow
            column['sortDownClassShow']  = lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'desc' ? "showArrow" : "hideArrow" ;//hidden desc arrow
     }else{
        column['isSorted'] = true;
        column['sortUp'] = true;
        column['sortDown'] =false;
        column['sortUpClass']  =  column['sortUp']== false ? "hideArrow" : "showArrow" ;//hidden
        column['sortDownClassShow']  =  column['sortDown']== false ? "hideArrow" : "showArrow" ;//hidden
    }
    }else if(unOrderedRowGroupingFieldList != undefined && unOrderedRowGroupingFieldList.length > 0 && unOrderedRowGroupingFieldList.includes(fieldname)){
        column['isSorted'] = true;//check
        if(lwcFlexTableHandler.defaultSortDirection != undefined){
            column['sortUp'] = lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'asc' ? true: false;
            column['sortDown'] =lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'desc' ? true: false;
            column['sortUpClass']  = lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'asc'  ? "showArrow" : "hideArrow " ;//hidden asc arrow
            column['sortDownClassShow']  = lwcFlexTableHandler.defaultSortDirection.toLowerCase() == 'desc' ? "showArrow" : "hideArrow" ;//hidden desc arrow
        }else{
            column['isSorted'] = true;
            column['sortUp'] = true;
            column['sortDown'] =false;
            column['sortUpClass']  =  column['sortUp']== false ? "hideArrow" : "showArrow" ;//hidden
            column['sortDownClassShow']  =  column['sortDown']== false ? "hideArrow" : "showArrow" ;//hidden
        }
    }else{
        column['isSorted'] = false;
        column['sortUp'] = false;
        column['sortDown'] =false;
        column['sortUpClass']  =  column['sortUp']== false ? "hideArrow" : "showArrow" ;//hidden
        column['sortDownClassShow']  =  column['sortDown']== false ? "hideArrow" : "showArrow" ;//hidden
    } 
    if(lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo!=undefined && !lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.IsUpdateable){
        column['readOnly'] = true;
    }
        if(lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'REFERENCE' ){
            column['label'] = lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Label : lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Label;
            column['isReference'] =  true;
            column['lookupDetails'] =  lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo != undefined ? lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.lookupDetails[0] : '';
            if(fieldname.toLowerCase().includes('.name')  || lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'REFERENCE'){
                if(!(fieldname.toLowerCase().includes('__r')) && lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'REFERENCE'){
                    column['isLookup'] = true;
                    column['isReference'] =  false;
                }
                if(lwcFlexTableHandler.flexTableConfig.EnableHyperLinkAsText === false){
                    let fieldReferenceName =getReferenceFieldName(lwcFlexTableHandler,fieldname).toLowerCase();
                    
                    column['fieldType'] = 'url';
                    column['fieldName'] =  fieldReferenceName;
                    
                }else{
                    column['fieldType']='text';
                    column['label'] = lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Label : lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Label;
                    column['fieldName'] =  getReferenceFieldName(lwcFlexTableHandler,fieldname).toLowerCase();
                }            
            }else if(lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type != 'CURRENCY' && lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.IsFormulaField == true && lwcFlexTableHandler.DataTableDetailConfigMap[fieldname] != undefined && lwcFlexTableHandler.DataTableDetailConfigMap[fieldname].EscapeHtml == true){

                column['fieldType'] = 'base64';
                column['fieldName'] = fieldname;
           }else if( lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'TEXTAREA' || lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'STRING'){
               column['fixedWidth'] = 'width:170px !important;';
               column['fieldType'] = 'text';
               column['fieldName'] = fieldname;               
            }
            else if(lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'DOUBLE'){
                column['fieldType'] = 'number';
                column['fieldName'] = fieldname;
            }else if(lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'DATE'){
                column['fieldType'] = 'date-local';
                column['fieldName'] = fieldname;;
            }else if( lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'DATETIME'){
                column['fieldType'] = 'date';
                column['fieldName'] = fieldname;
            }else if( lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'BOOLEAN'){
                column['fieldType'] = 'boolean';
                column['fieldName'] = fieldname;              
           }else if(lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.IsFormulaField == true ){
            column['fieldType'] = 'formula';
            column['fieldName'] = fieldname;
            column['fixedWidth'] =lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'STRING'?'width:170px !important;': '';
           }
           else if( lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type === 'STRING'){
            column['fieldType'] = 'text';
            column['fieldName'] = fieldname;
            column['fixedWidth'] = 'width:170px !important;';
            }else{
                column['fieldType']=lwcFlexTableHandler.FieldMetaData[fieldname].ReferenceFieldInfo.Type.toLowerCase();
                column['fieldName'] = fieldname;
            }
            

        }else if(lwcFlexTableHandler.FieldMetaData[fieldname].IsFormulaField == true){
            column['fieldType'] = 'formula';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
            column['fixedWidth'] =lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'STRING'?'width:170px !important;': '';
        }
         else if( lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'STRING'){
            column['fieldType'] = 'text';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
            column['fixedWidth'] = 'width:170px !important;';
        }
      else if( lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'TEXTAREA'  ){
            column['fieldType'] = 'base64';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
            column['fixedWidth'] = 'width:170px !important;';
        }
        else if(lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'DOUBLE' )//lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'PERCENT'
        {
            column['fieldType'] = 'number';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
        }else if(lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'DATE'){
            column['fieldType'] = 'date-local';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
        }else if( lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'DATETIME'){
            column['fieldType'] = 'date';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
        }else if( lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'BOOLEAN'){
            column['fieldType'] = 'boolean';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;           
        }else if( lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'BASE64'){
            column['fixedWidth'] =  'width:170px !important;';
            column['fieldType'] = 'base64';
            column['fieldName'] = fieldname;
            column['isReference'] =  false;
        } else{
            column['fieldType']=lwcFlexTableHandler.FieldMetaData[fieldname].Type.toLowerCase();
            column['fieldName'] = fieldname;
            column['isReference'] =  false;            
        }         
        lwcFlexTableHandler.columns.push(column);    
}

export function getReferenceFieldName(lwcFlexTableHandler,fieldName){

    //lwcFlexTableHandler.isReadOnlyField = false;
    if (lwcFlexTableHandler.FieldMetaData != undefined && fieldName != undefined) {        
        if (lwcFlexTableHandler.FieldMetaData[fieldName] != undefined &&
            lwcFlexTableHandler.FieldMetaData[fieldName].Type === 'REFERENCE') {
            let refIdField = '';
            //Original Display Field Name
            let orgFieldName = fieldName;
            refIdField = fieldName;               
            if (fieldName.indexOf('.') === -1) {
                if (fieldName.indexOf('__c') === -1) {
                    refIdField = fieldName + '.Id';
                } else {
                    refIdField = fieldName.replace('__c', '__r.Id');
                }
            }                    
            let strDisplayField = (lwcFlexTableHandler.DataTableDetailConfigMap[fieldName] && lwcFlexTableHandler.DataTableDetailConfigMap[fieldName].DisplayField) 
                                    ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldName].DisplayField 
                                    : undefined;
            if(strDisplayField) {
                let refField = '';
                if (fieldName.indexOf('__c') === -1) {
                   // refField = $scope.fieldName + '.';   
                   refField =validateStandardRefFields(fieldName) + '.';                       
                }
                 else {
                    refField = fieldName.replace('__c', '__r.');
                }
                refField = refField + strDisplayField;                   
                fieldName = refField;              
            } else {
                let refField = fieldName;
                if (refField.indexOf('.') === -1) {
                    switch(refField.toLowerCase()){
                        case 'lastmodifiedbyid':
                            fieldName = 'LastModifiedBy.Name';
                            break;
                        case 'createdbyid':
                            fieldName = 'CreatedBy.Name';
                            break;
                        case 'recordtypeid':
                            fieldName = 'RecordType.Name';
                            break;
                        case 'ownerid':
                            fieldName = 'Owner.Name';
                        break;
                        case 'parentid':
                            fieldName = 'Parent.Name';
                        break;
                        case 'accountid':
                            fieldName = 'Account.Name';
                        break;
                        default:
                            if (fieldName.indexOf('__c') === -1) {
                                refField = fieldName + '.Name';
                            } else {
                                refField = fieldName.replace('__c', '__r.Name');
                            }
                            fieldName = refField;                                
                    }
                } 

            }              
           
        }
    }
    return fieldName;

}

export function inithandlemouseup(lwcFlexTableHandler,e){

        lwcFlexTableHandler._tableThColumn = undefined;
        lwcFlexTableHandler._tableThInnerDiv = undefined;
        lwcFlexTableHandler._pageX = undefined;
        lwcFlexTableHandler._tableThWidth = undefined;
}

export function inithandlemousedown(lwcFlexTableHandler,e){

        if (!lwcFlexTableHandler._initWidths) {
            lwcFlexTableHandler._initWidths = [];
            let tableThs = lwcFlexTableHandler.template.querySelectorAll("table thead .dv-dynamic-width");
            tableThs.forEach(th => {
                lwcFlexTableHandler._initWidths.push(th.style.width);
            });
        }
 
        lwcFlexTableHandler._tableThColumn = e.target.parentElement;
        lwcFlexTableHandler._tableThInnerDiv = e.target.parentElement;
        while (lwcFlexTableHandler._tableThColumn.tagName !== "TH") {
            lwcFlexTableHandler._tableThColumn = lwcFlexTableHandler._tableThColumn.parentNode;
        }
        while (!lwcFlexTableHandler._tableThInnerDiv.className.includes("slds-cell-fixed1")) {
            lwcFlexTableHandler._tableThInnerDiv = lwcFlexTableHandler._tableThInnerDiv.parentNode;
        }
        lwcFlexTableHandler._pageX = e.pageX;
 
        lwcFlexTableHandler._padding = lwcFlexTableHandler.paddingDiff(lwcFlexTableHandler._tableThColumn);
 
        lwcFlexTableHandler._tableThWidth = lwcFlexTableHandler._tableThColumn.offsetWidth - lwcFlexTableHandler._padding;
}


export function inithandlemousemove(lwcFlexTableHandler,e){

        if (lwcFlexTableHandler._tableThColumn && lwcFlexTableHandler._tableThColumn.tagName === "TH") {
            lwcFlexTableHandler._diffX = e.pageX - lwcFlexTableHandler._pageX;
 
            let minWidth = (lwcFlexTableHandler._tableThWidth + lwcFlexTableHandler._diffX);

            if( minWidth > 70){
            lwcFlexTableHandler.template.querySelector("table").style.width = (lwcFlexTableHandler.template.querySelector("table") - (lwcFlexTableHandler._diffX)) + 'px';
    
            }
            //lwcFlexTableHandler.template.querySelector("table").style.width = (lwcFlexTableHandler.template.querySelector("table") - (lwcFlexTableHandler._diffX)) + 'px';
           

            if( minWidth > 70){
                lwcFlexTableHandler._tableThColumn.style.width = (lwcFlexTableHandler._tableThWidth + lwcFlexTableHandler._diffX) + 'px';
                lwcFlexTableHandler._tableThInnerDiv.style.width = lwcFlexTableHandler._tableThColumn.style.width;
            }
            let tableThs = lwcFlexTableHandler.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = lwcFlexTableHandler.template.querySelectorAll("table tbody tr");
            let tableBodyTds = lwcFlexTableHandler.template.querySelectorAll("table tbody .dv-dynamic-width");
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
}

export function inithandledblclickresizable(lwcFlexTableHandler,e){

        let tableThs = lwcFlexTableHandler.template.querySelectorAll("table thead .dv-dynamic-width");
        let tableBodyRows = lwcFlexTableHandler.template.querySelectorAll("table tbody tr");
        tableThs.forEach((th, ind) => {
            th.style.width = lwcFlexTableHandler._initWidths[ind];
            th.querySelector(".slds-cell-fixed1").style.width = lwcFlexTableHandler._initWidths[ind];
        });
        tableBodyRows.forEach(row => {
            let rowTds = row.querySelectorAll(".dv-dynamic-width");
            rowTds.forEach((td, ind) => {
                rowTds[ind].style.width = lwcFlexTableHandler._initWidths[ind];
            });
        });
}

export function initpaddingDiff(lwcFlexTableHandler,col){

    if (lwcFlexTableHandler.getStyleVal(col, 'box-sizing') === 'border-box') {
        return 0;
    }

    lwcFlexTableHandler._padLeft = lwcFlexTableHandler.getStyleVal(col, 'padding-left');
    lwcFlexTableHandler._padRight = lwcFlexTableHandler.getStyleVal(col, 'padding-right');
    return (parseInt(lwcFlexTableHandler._padLeft, 10) + parseInt(lwcFlexTableHandler._padRight, 10));
}

export function initgetStyleVal(lwcFlexTableHandler,elm,css){

    return (window.getComputedStyle(elm, null).getPropertyValue(css))
}

export function checkFilterClause(lwcFlexTableHandler){
    let isMasterViewPresent = false;
    let listViewCount = 0;
    let masterListCount = 0;
    let isFilterClausePresent = false;
    let activeListWithoutFilterClause=false;
    let isFilterClausePresentWithMaster = false;
    let isActiveWithoutMaster = 0;
    let activeListFilterClause = '';
    lwcFlexTableHandler.isParentTargetLookupField = false;
    if (lwcFlexTableHandler.FlexTableFilterListViewList.length < 1) {
        return isMasterViewPresent;
    }
    for (let i = 0; i < lwcFlexTableHandler.FlexTableFilterListViewList.length; i++) {
        let filterListView = lwcFlexTableHandler.FlexTableFilterListViewList[i];
        if (filterListView.IsActive === true) {
            listViewCount++;
			lwcFlexTableHandler.Listviews.push(filterListView);
            if (filterListView.FilterClause != undefined) {
                isFilterClausePresent = true;
                if (filterListView.IsMasterView === true) {
                    isMasterViewPresent = true;
                    masterListCount++;
                    isFilterClausePresentWithMaster = true;
                    lwcFlexTableHandler.masterFilterClause = filterListView.FilterClause;
                    lwcFlexTableHandler.Header= filterListView.Label != undefined ? filterListView.Label : lwcFlexTableHandler.flexTableConfig.Header != undefined ? lwcFlexTableHandler.flexTableConfig.Header:lwcFlexTableHandler.flexTableConfig.Name;
                    if (lwcFlexTableHandler.parentId != undefined) {
                        if (lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField != undefined) {
                            lwcFlexTableHandler.isParentTargetLookupField = true;
                            let appendClause = lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField + ' = ' + '\'' + escape(lwcFlexTableHandler.parentId) + '\'';
                            if (lwcFlexTableHandler.masterFilterClause != undefined) {
                                if(lwcFlexTableHandler.parentId.length >= 15){
                                    lwcFlexTableHandler.masterFilterClause = lwcFlexTableHandler.masterFilterClause.replace(new RegExp('{!parentId}', 'g'), escape(lwcFlexTableHandler.parentId));
                                } else {
                                    lwcFlexTableHandler.masterFilterClause = lwcFlexTableHandler.masterFilterClause.replace(new RegExp('{!parentId}', 'g'), '{{' + escape(lwcFlexTableHandler.parentId) + '}}');
                                }
                            } else {
                                lwcFlexTableHandler.masterFilterClause = appendClause;
                            }
                        }else {
                            lwcFlexTableHandler.isParentTargetLookupField = false;
                          
                        }
                    }
                } else {
                    
                    activeListFilterClause = filterListView.FilterClause;
                
                    isActiveWithoutMaster++;
                    lwcFlexTableHandler.Header= lwcFlexTableHandler.Header != undefined ? lwcFlexTableHandler.Header : filterListView.Label != undefined ? filterListView.Label : lwcFlexTableHandler.flexTableConfig.Header != undefined ? lwcFlexTableHandler.flexTableConfig.Header : lwcFlexTableHandler.flexTableConfig.Name;
                
                }
            }else {
                activeListWithoutFilterClause=true;
                if (filterListView.IsMasterView === true) {
                    isMasterViewPresent = true;
                    masterListCount++;
                    lwcFlexTableHandler.Header=filterListView.Label;
                }
            }
        }
    }
    if(listViewCount === 1) {
        if(isFilterClausePresentWithMaster === false && masterListCount > 0){
            lwcFlexTableHandler.masterFilterClause = 'Id = null';
            lwcFlexTableHandler.ShowWarningMessage('Master list view must have a Filter Criteria');
			
        }else{
            if(isFilterClausePresent === false){
                lwcFlexTableHandler.masterFilterClause = 'Id = null';
                lwcFlexTableHandler.ShowWarningMessage('Active list view must have a Filter Criteria')
				
            }
        }
        if (isActiveWithoutMaster === 1 ) {
            lwcFlexTableHandler.masterFilterClause = activeListFilterClause;
            if (lwcFlexTableHandler.parentId != undefined) {
                if (lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField != undefined) {
                    lwcFlexTableHandler.isParentTargetLookupField = true;
                    let appendClause = lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField + ' = ' + '\'' + escape(lwcFlexTableHandler.parentId) + '\'';
                    if (lwcFlexTableHandler.masterFilterClause != undefined) {
                        if(lwcFlexTableHandler.parentId.length >= 15){
                            lwcFlexTableHandler.masterFilterClause = lwcFlexTableHandler.masterFilterClause.replace(new RegExp('{!parentId}', 'g'), escape(lwcFlexTableHandler.parentId));
                        } else {
                            lwcFlexTableHandler.masterFilterClause = lwcFlexTableHandler.masterFilterClause.replace(new RegExp('{!parentId}', 'g'), '{{' + escape(lwcFlexTableHandler.parentId) + '}}');
                        }
                    } else {
                        lwcFlexTableHandler.masterFilterClause = appendClause;
                    }
                }else {
                    lwcFlexTableHandler.isParentTargetLookupField = false;
                  
                }
            }
            return true;
        }
    }
    if (listViewCount > 1) {
		if(activeListWithoutFilterClause==true){
            lwcFlexTableHandler.masterFilterClause = 'Id = null';
            lwcFlexTableHandler.ShowWarningMessage('Active list view must have a Filter Criteria');
        }
        if ((isMasterViewPresent === false && isFilterClausePresentWithMaster === false) && (isFilterClausePresent === false)) {
            lwcFlexTableHandler.masterFilterClause = 'Id = null';
            lwcFlexTableHandler.ShowWarningMessage('All Active List views must have filter criteria. Among all, one list view should be Active and marked as a Master List View')
        }
        if (isMasterViewPresent === false) {
            lwcFlexTableHandler.masterFilterClause = 'Id = null';
            lwcFlexTableHandler.ShowWarningMessage('Atleast one list view should be marked as a Master List View')
			
        }else{
            if (isFilterClausePresentWithMaster === false) {
                lwcFlexTableHandler.masterFilterClause = 'Id = null';
                lwcFlexTableHandler.ShowWarningMessage('Master list view must have a Filter Criteria')
            }
        }
        if (isFilterClausePresent === false || activeListWithoutFilterClause === true) {
            lwcFlexTableHandler.masterFilterClause = 'Id = null';
        }
    }
    if (masterListCount > 1 && listViewCount > 1) {
        lwcFlexTableHandler.masterFilterClause = 'Id = null';
        lwcFlexTableHandler.ShowWarningMessage('Two Master List Views are not allowed')
    }
    if (listViewCount > 1) {
        lwcFlexTableHandler.showListViewDropDown = true;
    }
    return isFilterClausePresentWithMaster;
}

export function replaceAllMergeFields(lwcFlexTableHandler,filterString){
    filterString = replaceStringParamters(lwcFlexTableHandler,filterString);
    filterString = replaceListParamters(lwcFlexTableHandler,filterString);
    return filterString;
}

export function replaceStringParamters(lwcFlexTableHandler,filterString){

    if(lwcFlexTableHandler.stringParameters != undefined && lwcFlexTableHandler.stringParameters != '' && filterString != null){

            Object.keys(lwcFlexTableHandler.stringParameters).forEach(key=>{
                let value=lwcFlexTableHandler.stringParameters[key];
                if( (typeof filterString === 'string') && filterString.indexOf('{!'+key+'}') != -1){
                    if (value !== null && typeof value === "object" && filterString.includes("'{!")) {
                        filterString = filterString.replaceAll("'{!" + key + "}'", "('" + value.join("','") + "')");
                    } else if(value !== null && typeof value === "object" && filterString.includes("{!")){
                        filterString = filterString.replaceAll("{!" + key + "}", "('" + value.join("','") + "')");
                    }else {
                        filterString = filterString.replaceAll("{!" + key + "}", value);
                    }
                }
            });
   }
   return filterString;
}


export function replaceListParamters(lwcFlexTableHandler,filterString){
    if(lwcFlexTableHandler.listParameters != undefined &&
        lwcFlexTableHandler.listParameters != '' &&
        filterString != null){
            Object.keys(lwcFlexTableHandler.listParameters).forEach(key=>{
                let value=lwcFlexTableHandler.listParameters[key];
                if( (typeof filterString === 'string') && filterString.indexOf('{!'+key+'}') != -1){
                    if (value !== null && typeof value === "object" && filterString.includes("'{!")) {
                        filterString = filterString.replaceAll("'{!" + key + "}'", "('" + value.join("','") + "')");
                    } else if(value !== null && typeof value === "object" && filterString.includes("{!")){
                        filterString = filterString.replaceAll("{!" + key + "}", "('" + value.join("','") + "')");
                    }
                  //  filterString = filterString.replaceAll("{!" + key + "}", "('" + value.join("','") + "')");   
                }
            });
      
     
   }
   return filterString;
}


export function getdata(lwcFlexTableHandler,ifrefesh){

    var OverAllColumns=[];

    getPageRecordsMap({strRecordsParams : JSON.stringify(lwcFlexTableHandler.dataparamJsonRecord)}).then(response=>{
        if(response.Success === true){
             lwcFlexTableHandler.query= response.query != undefined ? response.query : undefined;
             if(response.RecordsList){
                lwcFlexTableHandler.allData=response.RecordsList;
                lwcFlexTableHandler.TotalCount= lwcFlexTableHandler.allData.length;
                lwcFlexTableHandler.ApprovalLockedRecordsMap = response.ApprovalLockedRecordsMap;
                
                if(lwcFlexTableHandler.TotalCount > 0){
                    lwcFlexTableHandler.enableTotalRecords = lwcFlexTableHandler.flexTableConfig.EnableTotalRecordsCount === true ? true : false;
                    lwcFlexTableHandler.EnablePagination =lwcFlexTableHandler.PageSizeValue > lwcFlexTableHandler.TotalCount  ?  false : true;
                    lwcFlexTableHandler.Totoalrecords = 'Total Records: ' + lwcFlexTableHandler.TotalCount;
                    lwcFlexTableHandler.noRecords = false;
                    lwcFlexTableHandler.ShowRecordMessage =true;
                    let fname;
                    getdatarecords(lwcFlexTableHandler,lwcFlexTableHandler.allData,false);
                    lwcFlexTableHandler.pageSize=lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
                    lwcFlexTableHandler.PageSizeValue = lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
                    
                    
                    if(lwcFlexTableHandler.flexTableConfig.EnablePageSize === true){
                        
                        lwcFlexTableHandler.EnablePageSize =  lwcFlexTableHandler.PageSizeValue >= lwcFlexTableHandler.TotalCount  ?  false : true;
                    }else{
                        lwcFlexTableHandler.EnablePageSize = false;
                    }
                    if(lwcFlexTableHandler.initSessionData != undefined &&  lwcFlexTableHandler.initSessionData != null
                        && lwcFlexTableHandler.initSessionData.sortDirection != undefined && lwcFlexTableHandler.initSessionData.sortfieldname != undefined
                          && lwcFlexTableHandler.level==1){
                               let fieldname;
                                     if(lwcFlexTableHandler.initSessionData.sortDirection != undefined){
                                       lwcFlexTableHandler.SortWay = lwcFlexTableHandler.initSessionData.sortDirection;
                                     }
                                     if(lwcFlexTableHandler.initSessionData.sortfieldname != undefined){
                                       fieldname = lwcFlexTableHandler.initSessionData.sortfieldname;
                                       
                                     sortData(fieldname,lwcFlexTableHandler.SortWay.toLowerCase(),false,lwcFlexTableHandler);
                                     handleSortDirection(lwcFlexTableHandler,fieldname,lwcFlexTableHandler.SortWay.toLowerCase());
                                     lwcFlexTableHandler.flattenedData= lwcFlexTableHandler.quicksearchdata;
                                     lwcFlexTableHandler.data = lwcFlexTableHandler.flattenedData;
                                     }

                               }
                             
                           
                        
                   if(lwcFlexTableHandler.initSessionData != undefined &&  lwcFlexTableHandler.initSessionData != null && lwcFlexTableHandler.level==1){
                        if(lwcFlexTableHandler.initSessionData.pageSize != undefined){
                           if(lwcFlexTableHandler.initSessionData.pageSize == 'All'){
                               lwcFlexTableHandler.pageSize = lwcFlexTableHandler.TotalCount;
                               lwcFlexTableHandler.PageSizeValue ='All' ;
                           }else{
                               lwcFlexTableHandler.pageSize = lwcFlexTableHandler.initSessionData.pageSize;
                               lwcFlexTableHandler.PageSizeValue =lwcFlexTableHandler.pageSize ; 
                           }
                           
                         }
                         if(lwcFlexTableHandler.initSessionData.pageNumber != undefined){
                           lwcFlexTableHandler.currentPage = lwcFlexTableHandler.initSessionData.pageNumber;
                         }
                         if(lwcFlexTableHandler.initSessionData.quickSearchText != undefined && lwcFlexTableHandler.initSessionData.quickSearchText != ''){
                           let quickSearchText = lwcFlexTableHandler.initSessionData.quickSearchText;
                           lwcFlexTableHandler.searchText = quickSearchText;//need to remove 
                           QuickSearch(lwcFlexTableHandler,quickSearchText.toUpperCase(),false);
                         }
                         
                   }
                    handlePagination(lwcFlexTableHandler);
                  
                }else{
                
                    lwcFlexTableHandler.data = [];
                    lwcFlexTableHandler.Totoalrecords = '';
                    lwcFlexTableHandler.noRecords = true;
                    lwcFlexTableHandler.EnablePageSize = false;
                    lwcFlexTableHandler.EnablePagination =false;
                    lwcFlexTableHandler.EnableTotalRecordsCount = false;
                    lwcFlexTableHandler.End = 0;
                    lwcFlexTableHandler.ShowRecordMessage =false;
                    lwcFlexTableHandler.Start= lwcFlexTableHandler.currentPage;
					lwcFlexTableHandler.isLoading = false;

                }
             }

        }else{
        
            lwcFlexTableHandler.data = [];
            lwcFlexTableHandler.noRecords = true;
            lwcFlexTableHandler.EnablePageSize = false;
            lwcFlexTableHandler.ShowRecordMessage =false;
            lwcFlexTableHandler.EnablePagination= false;
            lwcFlexTableHandler.isLoading = false;

            lwcFlexTableHandler.ShowErrorMessage(response.Message);
        }

        }).catch(error => {
            if(error.body != undefined && error.body.message != undefined ){
                lwcFlexTableHandler.ShowErrorMessage(error.body.message);
            }else{
               lwcFlexTableHandler.ShowErrorMessage(error.message);
            }

        });

}

export function getdatarecords(lwcFlexTableHandler,data,isparentRecord){

    let contactsArray = [];
        
                    for(let row of data){
        
                        const flattenedRow = {}
                        
                        let rowkeys=Object.keys(row);
                        rowkeys.forEach((rowkey)=>{
        
                            const singleNodeValue=row[rowkey];
        
                            if(singleNodeValue.constructor === Object){
                                let rowkeysecond=Object.keys(singleNodeValue);
                                rowkeysecond.forEach((rowkeySecond)=>{

                                    const secondLevelNode=singleNodeValue[rowkeySecond];
                                    if(secondLevelNode.constructor === Object){

                                        let rowkeythird = Object.keys(secondLevelNode);
                                        rowkeythird.forEach((rowkeyThird)=>{
                                            
                                            const thirdlevelNode = secondLevelNode[rowkeyThird];
                                            if(thirdlevelNode.constructor === Object){

                                                let rowkeyfourth = Object.keys(thirdlevelNode);

                                                rowkeyfourth.forEach((rowkeyFouth) =>{

                                                    const fourthlevelNode = thirdlevelNode[rowkeyFouth];

                                                    if(fourthlevelNode.constructor === Object){

                                                        let rowkeyfifth = Object.keys(fourthlevelNode);

                                                        rowkeyfifth.forEach((rowkeyFifth) =>{

                                                            const fifthlevelNode = fourthlevelNode[rowkeyFifth];
                                                            
                                                            if(fifthlevelNode.constructor === Object){

                                                                _flattenLevelFifth(fourthlevelNode,flattenedRow,rowkey,rowkeySecond,rowkeyThird,rowkeyFouth,rowkeyFifth);
                                                            }
                                                        });
                                                        _flattenLevelFourth(fourthlevelNode,flattenedRow,rowkey,rowkeySecond,rowkeyThird,rowkeyFouth);
                                                    }
                                                });
                                                _flattenLevelThree(thirdlevelNode,flattenedRow,rowkey,rowkeySecond,rowkeyThird);
                                            }
                                        });
                                        _flattenLevelTwo(secondLevelNode,flattenedRow,rowkey,rowkeySecond);
                                    }
                                    
                                });
                                _flatten(singleNodeValue, flattenedRow, rowkey);
                            }else{
                                flattenedRow[rowkey.toLowerCase()] = singleNodeValue;
                            }
                        });
        
                        contactsArray.push(flattenedRow);
        
                    }
                    if(isparentRecord === true){
                        lwcFlexTableHandler.ParentRecord = contactsArray[0];
                    }else{
                        
                         lwcFlexTableHandler.flattenedData= contactsArray;
                         lwcFlexTableHandler.quicksearchdata = contactsArray;
                         lwcFlexTableHandler.dataforQuickSeach = contactsArray;
                        ProcessData(lwcFlexTableHandler);
                        if(lwcFlexTableHandler.OverAllColumnsFields != undefined && lwcFlexTableHandler.OverAllColumnsFields.length > 0 && lwcFlexTableHandler.TotalCount > 0){
                            getOverAllTotal(lwcFlexTableHandler,lwcFlexTableHandler.flattenedData);
                        }
						generateRowLevelHideActionMap(lwcFlexTableHandler);
                    }
                
}

export function _flatten(nodeValue, flattenedRow, nodeName){       
    let rowKeys = Object.keys(nodeValue);
    rowKeys.forEach((key) => {
        let finalKey = nodeName + '.'+ key;
        flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
    })
}

export function _flattenLevelTwo(nodeValue, flattenedRow, nodeName,nodekeysecond){

    let rowKeys = Object.keys(nodeValue);
    rowKeys.forEach((key) => {
        let finalKey = nodeName + '.'+ nodekeysecond+'.'+key;
        flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
    })
}

export function _flattenLevelThree(nodeValue, flattenedRow, nodeName,nodekeysecond,nodekeythird){

    let rowKeys = Object.keys(nodeValue);
    rowKeys.forEach((key) => {
        let finalKey = nodeName+'.'+ nodekeysecond+'.'+nodekeythird+'.'+key;
        flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
    })
}

export function _flattenLevelFourth(nodeValue, flattenedRow, nodeName,nodekeysecond,nodekeythird,nodekeyfourth){

    let rowKeys = Object.keys(nodeValue);
    rowKeys.forEach((key) => {
        let finalKey = nodeName+'.'+ nodekeysecond+'.'+nodekeythird+'.'+nodekeyfourth+'.'+key;
        flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
    })
}

export function _flattenLevelFifth(nodeValue, flattenedRow, nodeName,nodekeysecond,nodekeythird,nodekeyfourth,nodekeyfifth){

    let rowKeys = Object.keys(nodeValue);
    rowKeys.forEach((key) => {
        let finalKey = nodeName+'.'+ nodekeysecond+'.'+nodekeythird+'.'+nodekeyfourth+'.'+nodekeyfifth+'.'+key;
        flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
    })
}

export function ProcessData(lwcFlexTableHandler){
    let sessionStr = getSessionData(lwcFlexTableHandler);
    let openedChildRecords;
    lwcFlexTableHandler.initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};
    if(lwcFlexTableHandler.initSessionData.enableChild != undefined)
    {
        openedChildRecords = new Set(JSON.parse(lwcFlexTableHandler.initSessionData.enableChild));
    }

    if(lwcFlexTableHandler.quicksearchdata.length > 0){
        for(let i=0; i < lwcFlexTableHandler.quicksearchdata.length; i++){
            
            lwcFlexTableHandler.quicksearchdata[i]['rowSelection'] = lwcFlexTableHandler.hideCheckBoxColumn == true?true:false;
            lwcFlexTableHandler.quicksearchdata[i]['isEdit'] = false;
            lwcFlexTableHandler.quicksearchdata[i]['EnableChild'] = openedChildRecords != undefined && openedChildRecords.has(lwcFlexTableHandler.quicksearchdata[i].id) ==true? true :false;
            lwcFlexTableHandler.quicksearchdata[i]['ExtendIcon'] = openedChildRecords != undefined && openedChildRecords.has(lwcFlexTableHandler.quicksearchdata[i].id) ==true? 'utility:chevrondown': 'utility:chevronright';
            lwcFlexTableHandler.quicksearchdata[i]['isAction'] = lwcFlexTableHandler.quicksearchdata[i]['isAction'] = lwcFlexTableHandler.isRowActionPresent == true ? true : false;
            lwcFlexTableHandler.quicksearchdata[i]['showChildIcon'] = true;
        }
    }
}

export function setMetaData(lwcFlexTableHandler){

    if(lwcFlexTableHandler.gridLevel == 0){
        if(lwcFlexTableHandler.initResult.Child1 != undefined){
            lwcFlexTableHandler.child1MetaData = lwcFlexTableHandler.initResult.Child1;   
        }else{
            lwcFlexTableHandler.child1MetaData = undefined;
        }
        if(lwcFlexTableHandler.initResult.Child2 != undefined){
            lwcFlexTableHandler.child2MetaData = lwcFlexTableHandler.initResult.Child2;   
        }else{
            lwcFlexTableHandler.child2MetaData = undefined;
        }
    }
    if(lwcFlexTableHandler.gridLevel >= 1 && lwcFlexTableHandler.gridLevel <= 2){
        if(lwcFlexTableHandler.initResult.GrandChild1 != undefined){
            lwcFlexTableHandler.child1MetaData = lwcFlexTableHandler.initResult.GrandChild1;   
        }else{
            lwcFlexTableHandler.child1MetaData = undefined;
        }
        if(lwcFlexTableHandler.initResult.GrandChild2 != undefined){
            lwcFlexTableHandler.child2MetaData = lwcFlexTableHandler.initResult.GrandChild2;   
        }else{
            lwcFlexTableHandler.child2MetaData = undefined;
        }
    }
    // Once all the variables and metadata is set, let's initialize the Loki DB instance with flex table name
   // DataBaseService.initializeLokiDB($scope.flexTableConfig.Name,$scope.tableCommunicator); 
}

export function EnableChild(id,lwcFlexTableHandler){

   
    if(id != undefined){
        for(let i=0; i < lwcFlexTableHandler.data.length; i++){
            
            if(lwcFlexTableHandler.data[i].id === id){
                lwcFlexTableHandler.data[i].ExtendIcon = lwcFlexTableHandler.data[i].ExtendIcon != undefined ? lwcFlexTableHandler.data[i].ExtendIcon === 'utility:chevronright' ? 'utility:chevrondown' : 'utility:chevronright' : '';
                if(lwcFlexTableHandler.data[i].ExtendIcon != '' && lwcFlexTableHandler.data[i].ExtendIcon == 'utility:chevrondown'){
                    lwcFlexTableHandler.openedRecords.add(lwcFlexTableHandler.data[i].id);
                    setSessionData('enableChild',lwcFlexTableHandler.openedRecords ,lwcFlexTableHandler);
                    if(lwcFlexTableHandler.level ==1){
                        setSessionData('showResetMessage',true,lwcFlexTableHandler);
                        lwcFlexTableHandler.isResetMessage = true;
                    }

                }else if(lwcFlexTableHandler.data[i].ExtendIcon != '' && lwcFlexTableHandler.data[i].ExtendIcon == 'utility:chevronright'){
                    lwcFlexTableHandler.openedRecords.delete(lwcFlexTableHandler.data[i].id);
                    setSessionData('enableChild',lwcFlexTableHandler.openedRecords ,lwcFlexTableHandler);
                    if(lwcFlexTableHandler.level ==1){
                        setSessionData('showResetMessage',true,lwcFlexTableHandler);
                        lwcFlexTableHandler.isResetMessage = true;
                    }
                }
            }
        }
    }
}

function getDefaultValues(lwcFlexTableHandler,value){

    let defaultvalues={};
                if(lwcFlexTableHandler.FieldMetaData[value.FieldAPIName].Type != 'REFERENCE'){ 
                defaultvalues['fieldName'] = value.FieldAPIName;
                defaultvalues['defaultValue'] = value.DefaultValue;

                }
    return defaultvalues;

}

export function setActionOrders(lwcFlexTableHandler, actionList){

    let AllActions=[];
    if(lwcFlexTableHandler.FlexTableActionMap != undefined && actionList !=undefined ){
        
    

        for(let i=0; i < actionList.length; i++){
            let allActions={};
            let action=actionList[i];
            let Sequence = actionList[i].Sequence != undefined ? actionList[i].Sequence : undefined;
         
            if(Sequence != undefined){
            
                if(AllActions != undefined && AllActions.length > 0){
                
                    for(let k=0; k < AllActions.length; k++){
                    
                        if(AllActions[k].Sequence > Sequence){
                            
                            allActions['Id'] = action.Id;
                            allActions['Name'] = action.Name;
                            allActions['Iconcss'] = action != undefined ? action.IconCSS : '';
                            allActions['Sequence'] = Sequence;
                            allActions['HideExpressionJSON'] = action.HideExpressionJSON;
                            allActions['ButtonHelpText'] = action.ButtonHelpText != undefined ?action.ButtonHelpText :action.Name;
							allActions['title'] = action.Name;
                            if(action.ActionBehavior === 'EditRecord'){
                                if(action.EditableRows === 'SingleRow'){
                                
                                    if(action.SingleRowEditBehavior === 'Inline'){
                                        allActions['isEdit'] = true;
                                    }
                                }
                            }
                            if(action.StandardAction === 'Delete'){
                        
                                allActions['isDelete'] = true;
                            
                            }
                            if(action.ActionBehavior === 'EditMultipleRecords'){
                                if(action.EditableRows === 'AllRows'){
                                    allActions['isEditAll'] = true;
                                }
                            
                            }
                            AllActions.splice(k, 0, allActions);
                            break;

                        }else{
                            
                            if( k === AllActions.length-1){
                            
                                allActions['Id'] = action.Id;
                                allActions['Name'] = action.Name;
                                allActions['Iconcss'] = action != undefined ? action.IconCSS : '';
                                allActions['Sequence'] = Sequence;
                                allActions['HideExpressionJSON'] = action.HideExpressionJSON;
                                allActions['ButtonHelpText'] = action.ButtonHelpText != undefined ?action.ButtonHelpText :action.Name;
								allActions['title'] = action.Name;
                                if(action.ActionBehavior === 'EditRecord'){
                                    if(action.EditableRows === 'SingleRow'){
                                    
                                        if(action.SingleRowEditBehavior === 'Inline'){
                                            allActions['isEdit'] = true;
                                        }
                                    }
                                }
                                if(action.StandardAction === 'Delete'){
                        
                                    allActions['isDelete'] = true;
                                
                                }
                                if(action.ActionBehavior === 'EditMultipleRecords'){
                                    if(action.EditableRows === 'AllRows'){
                                        allActions['isEditAll'] = true;
                                    }
                                
                                }
                                AllActions.push(allActions);
                                break;
                            }
                        }
                    
                    }
                
                }else{
                
                        allActions['Id'] = action.Id;
                        allActions['Name'] = action.Name;
                        allActions['Iconcss'] = action != undefined ? action.IconCSS : '';
                        allActions['Sequence'] = Sequence;
                        allActions['HideExpressionJSON'] = action.HideExpressionJSON;
                        allActions['ButtonHelpText'] = action.ButtonHelpText != undefined ?action.ButtonHelpText :action.Name;
						allActions['title'] = action.Name;
                        if(action.ActionBehavior === 'EditRecord'){
                            if(action.EditableRows === 'SingleRow'){
                            
                                if(action.SingleRowEditBehavior === 'Inline'){
                                    allActions['isEdit'] = true;
                                }
                            }
                        }
                        if(action.StandardAction === 'Delete'){
                        
                            allActions['isDelete'] = true;
                        
                        }
                        if(action.ActionBehavior === 'EditMultipleRecords'){
                            if(action.EditableRows === 'AllRows'){
                                allActions['isEditAll'] = true;
                            }
                        
                        }
                        AllActions.push(allActions);
                }
            
            }

            
        }

        if(actionList.length > AllActions.length){
            for(let k=0; k < actionList.length ; k++){
                let allActions={};
                if( actionList[k].Sequence ===undefined){
                    let action=actionList[k];
                    allActions['Id'] = action.Id;
                    allActions['Name'] = action.Name;
                    allActions['Iconcss'] = action != undefined ? action.IconCSS : '';
                    allActions['HideExpressionJSON'] = action.HideExpressionJSON;
                    allActions['ButtonHelpText'] = action.ButtonHelpText != undefined ?action.ButtonHelpText :action.Name;
					allActions['title'] = action.Name;
                    if(action.ActionBehavior === 'EditRecord'){
                        if(action.EditableRows === 'SingleRow'){
                        
                            if(action.SingleRowEditBehavior === 'Inline'){
                                allActions['isEdit'] = true;
                            }
                        }
                    }
                    if(action.StandardAction === 'Delete'){
                        
                            allActions['isDelete'] = true;
                        
                    }
                    if(action.ActionBehavior === 'EditMultipleRecords'){
                        if(action.EditableRows === 'AllRows'){
                            allActions['isEditAll'] = true;
                        }
                    
                    }
                    AllActions.push(allActions);
                }

            }
        }

        
    }

    return AllActions;

}
export function handleListViewChange(event ,lwcFlexTableHandler){
    lwcFlexTableHandler.selectedItemValue = event.detail.value;
    lwcFlexTableHandler.Header=lwcFlexTableHandler.selectedItemValue.Label;
    updateFlexTableListViewConfig({flexTableId:lwcFlexTableHandler.FlexTableId,userId:lwcFlexTableHandler.initResult.CurrentUserInfo.UserInfo.Id,updatedHeaderLabel:lwcFlexTableHandler.selectedItemValue.Label}).then(result=>{
        if(result){
       }
        }).catch(error=>{
			lwcFlexTableHandler.ShowErrorMessage(error.message);
         });
    let FilterClause='';
    for(var j=0;j < lwcFlexTableHandler.FlexTableFilterListViewList.length; j++){
        
        if(lwcFlexTableHandler.selectedItemValue.Label === lwcFlexTableHandler.FlexTableFilterListViewList[j].Label){
            FilterClause=lwcFlexTableHandler.FlexTableFilterListViewList[j].FilterClause;
        }
    }

   
    lwcFlexTableHandler.CurrentFilterCriteria = FilterClause
    FilterClause = replaceAllMergeFields(lwcFlexTableHandler,FilterClause);
    if(FilterClause != undefined){
        if(FilterClause.includes('parentId')){
            FilterClause = FilterClause.replace(new RegExp('{!parentId}', 'g'), escape(lwcFlexTableHandler.parentId));
    
        }
    }
    
    lwcFlexTableHandler.dataparamJsonRecord.filterCriteria=FilterClause;
    getPageRecordsMap({strRecordsParams : JSON.stringify(lwcFlexTableHandler.dataparamJsonRecord)}).then(response=>{
        if(response.Success === true){
             lwcFlexTableHandler.isRecordOpenMode = false;
             if(response.RecordsList){
                lwcFlexTableHandler.allData=response.RecordsList;
                lwcFlexTableHandler.TotalCount= lwcFlexTableHandler.allData.length;
                lwcFlexTableHandler.ApprovalLockedRecordsMap = response.ApprovalLockedRecordsMap;
                //lwcFlexTableHandler.ApprovalLockedRecordsMap = {'a1F4P0000075MGVUA2' : true};
                lwcFlexTableHandler.currentPage=1;
                if(lwcFlexTableHandler.TotalCount > 0){
                    lwcFlexTableHandler.isFirst  = true;
                    lwcFlexTableHandler.isLast  = false;
                    lwcFlexTableHandler.noRecords = false;
                    getdatarecords(lwcFlexTableHandler,lwcFlexTableHandler.allData,false);
                    getCurrentListViewSessionData(lwcFlexTableHandler)
                    lwcFlexTableHandler.EnablePageSize = lwcFlexTableHandler.flexTableConfig.EnablePageSize === true ? lwcFlexTableHandler.PageSizeValue > lwcFlexTableHandler.TotalCount  ?  false : true : false;
                    lwcFlexTableHandler.EnablePagination =lwcFlexTableHandler.PageSizeValue > lwcFlexTableHandler.TotalCount  ?  false : true;
					lwcFlexTableHandler.ShowRecordMessage =true;
                    lwcFlexTableHandler.End = 0;
                    lwcFlexTableHandler.Start= lwcFlexTableHandler.currentPage;
                    lwcFlexTableHandler.datatableHeight='height: 430px;';
					lwcFlexTableHandler.Totoalrecords = 'Total Records: ' + lwcFlexTableHandler.TotalCount;
                    lwcFlexTableHandler.firstOnly = true;
				//	lwcFlexTableHandler.pageSize=lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
                  // lwcFlexTableHandler.PageSizeValue = lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;                   
                    // getdatarecords(lwcFlexTableHandler,lwcFlexTableHandler.allData,false);
                    handlePagination(lwcFlexTableHandler);
                   }else{
                    lwcFlexTableHandler.Totoalrecords = '';
                    lwcFlexTableHandler.noRecords = true;
                    lwcFlexTableHandler.EnablePageSize = false;
                    lwcFlexTableHandler.EnablePagination =false;
                    lwcFlexTableHandler.ShowRecordMessage =false;
                    lwcFlexTableHandler.End = 0;
                    lwcFlexTableHandler.Start= lwcFlexTableHandler.currentPage;
                    lwcFlexTableHandler.data = [];
                    lwcFlexTableHandler.isLoading = false;
                    lwcFlexTableHandler.dynamicClass ='height:auto;'
                  }
             }

        }else{
            lwcFlexTableHandler.isRecordOpenMode = false;
            lwcFlexTableHandler.data = [];
            lwcFlexTableHandler.noRecords = true;
            //lwcFlexTableHandler.datatableHeight='height: auto;';
            lwcFlexTableHandler.EnablePageSize = false;
            lwcFlexTableHandler.ShowRecordMessage =false;
            lwcFlexTableHandler.EnablePagination= false;
            lwcFlexTableHandler.isLoading = false;
            lwcFlexTableHandler.dynamicClass ='height:auto;'
            }

        }).catch(error => {
            lwcFlexTableHandler.ShowErrorMessage(error.message);
             });
             if(lwcFlexTableHandler.level ==1){
                setSessionData('selectedListView',lwcFlexTableHandler.Header,lwcFlexTableHandler);
                }
}
export function sortData(fieldname, direction,check,lwcFlexTableHandler) {
    let parseData=JSON.parse(JSON.stringify(lwcFlexTableHandler.quicksearchdata));
    lwcFlexTableHandler.showSortMsg =false;
   
  
    
    
    let isReverse = direction === 'asc' ? 1 : -1;

    //this.sortedColumn = colName;

    // sort the data
    parseData = JSON.parse( JSON.stringify( lwcFlexTableHandler.quicksearchdata ) ).sort( ( a, b ) => {
       // a = a[ fieldname ] ? a[ fieldname ].toLowerCase() : ''; // Handle null values
        
        a = a[ fieldname ] ? (typeof a[ fieldname ] === 'string' ? a[ fieldname ] .toLowerCase() : a[ fieldname ] )  : ''; // Handle null values
        b = b[ fieldname ] ? (typeof b[ fieldname ] === 'string' ? b[ fieldname ] .toLowerCase() : b[ fieldname ] )  : '';
        return a > b ? 1 * isReverse : -1 * isReverse;
    });;
    
    lwcFlexTableHandler.quicksearchdata = parseData;
    
    
  
     if(check === 'true'){
       handlePagination(lwcFlexTableHandler);
     }
    //else{
    //     return this.quicksearchdata;
    // }
    
} 
export function handlePagination(lwcFlexTableHandler){

    let Pages=[];
    lwcFlexTableHandler.totalRecords = lwcFlexTableHandler.quicksearchdata.length;
    lwcFlexTableHandler.totalPages=Math.ceil(lwcFlexTableHandler.totalRecords / lwcFlexTableHandler.pageSize);
    if(lwcFlexTableHandler.currentPage >  lwcFlexTableHandler.totalPages ){ lwcFlexTableHandler.currentPage = lwcFlexTableHandler.totalPages ;}
    if(lwcFlexTableHandler.flexTableConfig.EnablePagination === false){
        lwcFlexTableHandler.EnablePagination = false;
    }else{
        if( lwcFlexTableHandler.filterlist.length > 0 ){
            if(lwcFlexTableHandler.totalPages < 1|| lwcFlexTableHandler.totalRecords <= lwcFlexTableHandler.pageSize){
                lwcFlexTableHandler.EnablePagination = false;
            }else{
                lwcFlexTableHandler.EnablePagination = true;
            }
        }else{
            if(lwcFlexTableHandler.totalPages < 1 || lwcFlexTableHandler.totalRecords <= lwcFlexTableHandler.pageSize){
                lwcFlexTableHandler.EnablePagination = false;
            }else{
                lwcFlexTableHandler.EnablePagination = true;
            }
        }
    }
  
    const start = (lwcFlexTableHandler.currentPage-1) * lwcFlexTableHandler.pageSize;
    const end   = lwcFlexTableHandler.currentPage * lwcFlexTableHandler.pageSize;
    lwcFlexTableHandler.Start = start +1;
    lwcFlexTableHandler.End  = end;

   
    lwcFlexTableHandler.PaginatedData  = lwcFlexTableHandler.quicksearchdata.slice(start,end);
    if(lwcFlexTableHandler.PaginatedData.length > 9 ){
        lwcFlexTableHandler.dynamicClass ='height:350px;'
        } 
     else {
        lwcFlexTableHandler.dynamicClass ='height:auto;'
     }
    lwcFlexTableHandler.End  = lwcFlexTableHandler.Start + lwcFlexTableHandler.PaginatedData.length-1
    if(lwcFlexTableHandler.rowGroupingFieldList != undefined && lwcFlexTableHandler.rowGroupingFieldList.length > 0 && lwcFlexTableHandler.TotalCount > 0){
        getRowGroupingData(lwcFlexTableHandler);
    }
    evaluateFormulaJSON(lwcFlexTableHandler);
    if(lwcFlexTableHandler.OverAllColumnsFields != undefined &&  lwcFlexTableHandler.OverAllColumnsFields.length > 0 && lwcFlexTableHandler.TotalCount > 0){
        //getOverAllTotal(lwcFlexTableHandler,lwcFlexTableHandler.flattenedData);
            lwcFlexTableHandler.PaginatedData.splice(lwcFlexTableHandler.PaginatedData.length,0,lwcFlexTableHandler.OverAllColumns);
    }
    if(lwcFlexTableHandler.showRowNumberColumn === true){
        enableAutoIndex(lwcFlexTableHandler,lwcFlexTableHandler.PaginatedData);
    }
     //lwcFlexTableHandler.End = lwcFlexTableHandler.Start + lwcFlexTableHandler.PaginatedData.length-1;
     lwcFlexTableHandler.firstOnly = false;
     lwcFlexTableHandler.data = [];
     setTimeout(() => {
        lwcFlexTableHandler.data=lwcFlexTableHandler.PaginatedData;
        lwcFlexTableHandler.isLoading = false;
    }, 1);
    if(lwcFlexTableHandler.currentPage <= lwcFlexTableHandler.totalPages){
        if(lwcFlexTableHandler.currentPage > 1){
            lwcFlexTableHandler.isFirst=false;
        }

    }
    if(lwcFlexTableHandler.currentPage === lwcFlexTableHandler.totalPages){
        lwcFlexTableHandler.isLast=true;
    }else{
        if(lwcFlexTableHandler.currentPage == 1){
            lwcFlexTableHandler.isFirst=true;
            lwcFlexTableHandler.isLast=false;
        }else{
            lwcFlexTableHandler.isLast=false;
        }
       
    }
    setValues(lwcFlexTableHandler)

            
  
}

export function setValues(lwcFlexTableHandler){
    lwcFlexTableHandler.isDelete = false;
    lwcFlexTableHandler.isNew    = false;
    if(lwcFlexTableHandler.newSaveRecordCount == 0 && lwcFlexTableHandler.editRecordCount == 0){
        lwcFlexTableHandler.isSave = false;
        lwcFlexTableHandler.EnableFilter   = lwcFlexTableHandler.flexTableConfig.EnableFilter != undefined ? lwcFlexTableHandler.flexTableConfig.EnableFilter : false;
        lwcFlexTableHandler.EnableQuickSearch   = lwcFlexTableHandler.flexTableConfig.EnableQuickSearch != undefined ? lwcFlexTableHandler.flexTableConfig.EnableQuickSearch : false;
        lwcFlexTableHandler.EnablePageSize = lwcFlexTableHandler.flexTableConfig.EnablePageSize === true ?  lwcFlexTableHandler.TotalCount >= lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() ? true: false: false; // BUG 377243
        lwcFlexTableHandler.isRecordOpenMode =false;
    }
    if(lwcFlexTableHandler.gridLevel > 0 && lwcFlexTableHandler.newSaveRecordCount == 0 && lwcFlexTableHandler.editRecordCount == 0){
        let data={};
                    data['isError'] = false;
                    data['isSave'] = false;
                    const showmessagesatparent =new CustomEvent('showmessage', {
                        detail: data,
                        bubbles: true,
                        composed: true,
                    });
                    lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
    }

}

export function CreateFieldOptions(lwcFlexTableHandler,ColumnNamesList){

    let fieldoption =[];
    for(var i=0; i < ColumnNamesList.length; i++){
        
         if(JSON.stringify(lwcFlexTableHandler.FieldMetaData).includes(ColumnNamesList[i])){
             let type;
             let fieldvaluemap={};
             let value= ColumnNamesList[i].indexOf('__c') ? ColumnNamesList[i].replace('__c','') : ColumnNamesList[i].indexOf('__c');
             //value = value.replace(/[^a-zA-Z ]/g, '');
             if(lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].Type === 'REFERENCE' ){
                
                if(lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].ReferenceFieldInfo != undefined ){
                    
                    fieldvaluemap['label']=lwcFlexTableHandler.DataTableDetailConfigMap[ColumnNamesList[i]] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[ColumnNamesList[i]].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[ColumnNamesList[i]].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].ReferenceFieldInfo.Label : lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].ReferenceFieldInfo.Label;
                    fieldvaluemap['value']=ColumnNamesList[i]; //value.toLowerCase() + '_t';
                    fieldvaluemap['apiname']=ColumnNamesList[i];
                    fieldoption.push(fieldvaluemap);
                }
            }
            else{
             fieldvaluemap['label']=lwcFlexTableHandler.DataTableDetailConfigMap[ColumnNamesList[i]] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[ColumnNamesList[i]].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[ColumnNamesList[i]].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].Label  : lwcFlexTableHandler.FieldMetaData[ColumnNamesList[i]].Label;
             //fieldvaluemap['value']=lwcFlexTableHandler.ColumnNamesList[i];
             fieldvaluemap['value']=ColumnNamesList[i]; //value.toLowerCase() +'_t';
             fieldvaluemap['apiname']=ColumnNamesList[i];
             fieldoption.push(fieldvaluemap);
            }
         }
    }

    return fieldoption;
}

export function getLabelForColumns(lwcFlexTableHandler,fieldApiName){

    let label;
    if(lwcFlexTableHandler.FieldMetaData[fieldApiName].Type === 'REFERENCE' ){
                
        if(lwcFlexTableHandler.FieldMetaData[fieldApiName].ReferenceFieldInfo != undefined ){
            
            label=lwcFlexTableHandler.DataTableDetailConfigMap[fieldApiName] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldApiName].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldApiName].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldApiName].ReferenceFieldInfo.Label : lwcFlexTableHandler.FieldMetaData[fieldApiName].ReferenceFieldInfo.Label;
            
        }
    }
    else{
        label=lwcFlexTableHandler.DataTableDetailConfigMap[fieldApiName] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldApiName].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[fieldApiName].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[fieldApiName].Label  : lwcFlexTableHandler.FieldMetaData[fieldApiName].Label;
    
    }

    return label;
 
}

export function updateOnColumnChange(lwcFlexTableHandler){

    lwcFlexTableHandler.AdvancedFilterFieldLabel = getLabelForColumns(lwcFlexTableHandler,lwcFlexTableHandler.AdvancedFilterFieldApi);
    resetAdvancedFilterValue(lwcFlexTableHandler);
    setInputTypeofColumnName(lwcFlexTableHandler);

}



export function getOperatorOptions(lwcFlexTableHandler,columnInfo){

    if(columnInfo != undefined){
        setInputFilterOptions(lwcFlexTableHandler,columnInfo);
 }

}

export function setInputFilterOptions(lwcFlexTableHandler,columnInfo){

    if( columnInfo.Type === 'DATE' || columnInfo.Type=== 'CURRENCY' || 
        columnInfo.Type === 'DOUBLE' || columnInfo.Type === 'INTEGER' || 
        columnInfo.Type === 'PERCENT' || columnInfo.Type === 'DATETIME') {

         let options = ['Equal','Greater','Lesser','GreaterEq','LesserEq'];      
         lwcFlexTableHandler.OperatorValue = getOperator(lwcFlexTableHandler,options); 
         
 }
 else if(columnInfo.Type === 'STRING'   || columnInfo.Type === 'URL'
         || columnInfo.Type === 'EMAIL' || columnInfo.Type ==='PHONE'
         || columnInfo.Type === 'COMBOBOX' || columnInfo.Type === 'TEXTAREA') {
        
         let options = ['Contains','DoesNotContain','StartsWith','EndsWith'];      
         getOperator(lwcFlexTableHandler,options);

 }
 else if(columnInfo.Type === 'BOOLEAN' || columnInfo.Type === 'RADIO'){

     let options = ['Equal','NotEqual'];      
     getOperator(lwcFlexTableHandler,options);

 }
 else if(columnInfo.Type === 'MULTIPICKLIST') {

     let options = ['Includes','Excludes'];
     getOperator(lwcFlexTableHandler,options);

 }
 else if(columnInfo.Type === 'PICKLIST') {

     let options = ['Equal','NotEqual'];
     let picklistValues = columnInfo.PickListFieldInfo.PicklistValues;
     getOperator(lwcFlexTableHandler,options);

 }
 else if(columnInfo.Type === 'REFERENCE') {
     let options = ['Equal','NotEqual'];
     getOperator(lwcFlexTableHandler,options);
 }
}

function getOperator(lwcFlexTableHandler,optionsList){
    let options =  [];
    for(var i=0 ; i<optionsList.length; i++){
        lwcFlexTableHandler.OpratorOption.push(lwcFlexTableHandler.optionsMap[optionsList[i]]);
    }
    return options;
}


function setInputTypeofColumnName(lwcFlexTableHandler){

    let standardFieldsArr = ['accountid','recordtypeid','lastmodifiedbyid','createdbyid','ownerid','parentid'];

    if(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Type === 'REFERENCE' ){
        // lwcFlexTableHandler.textareaCheck = false;
        // lwcFlexTableHandler.formulafieldcheck= false;
        // lwcFlexTableHandler.otherField = true;    
        if(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo != undefined ){
            let fieldpath=lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.FieldPath.split('.');
            if(fieldpath.length > 1){

                if(fieldpath[fieldpath.length - 1] ){

                    if(fieldpath[fieldpath.length - 2].includes('__r')){
                        lwcFlexTableHandler.AdvancedFilterSobjectName=fieldpath[fieldpath.length - 2].replace('__r', '__c');
                        lwcFlexTableHandler.AdvancedFilterSObjectFieldName=lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.Name;
                    }else{
                        if(standardFieldsArr.includes(fieldpath[fieldpath.length - 2].toLowerCase())){
                            lwcFlexTableHandler.AdvancedFilterSobjectName = lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceTo;
                            lwcFlexTableHandler.AdvancedFilterSObjectFieldName=lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.Name;

                        }
                    }
                }
            }
            else{
                //lwcFlexTableHandler.isReference = true;
                lwcFlexTableHandler.AdvancedFilterSObjectName=lwcFlexTableHandler.SObjectName;
                lwcFlexTableHandler.AdvancedFilterSObjectFieldName=lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Name;
            }
            if(!(lwcFlexTableHandler.AdvancedFilterFieldApi.toLowerCase().includes('__r')) && lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.Type === 'REFERENCE'){
                lwcFlexTableHandler.isReference = true;
                lwcFlexTableHandler.LookupDisplayFields = lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo != undefined && lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.lookupDetails != undefined ? lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.lookupDetails[0].DisplayLookupFields : '';;
            }else{
            
                CheckDataType(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.Type,lwcFlexTableHandler.AdvancedFilterFieldApi);

            
            }
            lwcFlexTableHandler.SfieldName=lwcFlexTableHandler.AdvancedFilterFieldApi;
            
            lwcFlexTableHandler.OpratorOption=[];
            getOperatorOptions(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo);
            lwcFlexTableHandler.template.querySelectorAll('c-outer-picklist').forEach(element => {
                if(element.name === 'operatorpicklist'){
                    element.setdata(lwcFlexTableHandler.OpratorOption[0].value,null,lwcFlexTableHandler.OpratorOption);
                }
                
           });
            //lwcFlexTableHandler.OperatorValue=lwcFlexTableHandler.OpratorOptions != undefined ? lwcFlexTableHandler.OpratorOptions[0].value : '';
            
        }
    }else {

        CheckDataType(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Type,lwcFlexTableHandler.AdvancedFilterFieldApi)
        lwcFlexTableHandler.OpratorOption=[];
        getOperatorOptions(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi]);

        lwcFlexTableHandler.template.querySelectorAll('c-outer-picklist').forEach(element => {
            if(element.name === 'operatorpicklist'){
                element.setdata(lwcFlexTableHandler.OpratorOption[0].value,null,lwcFlexTableHandler.OpratorOption);
            }
            
       });
    }

    lwcFlexTableHandler.AdvanceFilterOperatorValue = lwcFlexTableHandler.OpratorOption != undefined ? lwcFlexTableHandler.OpratorOption[0].value : '';
    lwcFlexTableHandler.AdvanceFilterOperatorLabel = lwcFlexTableHandler.OpratorOption[0].label;


}

function CheckDataType(lwcFlexTableHandler,fieldType,fieldName){

    if(fieldType === 'TEXTAREA'){
    
        lwcFlexTableHandler.textareaCheck = true;
    }else if(fieldType === 'MULTIPICKLIST' || fieldType === 'PICKLIST'){
            lwcFlexTableHandler.isPicklist = true;
            lwcFlexTableHandler.AdvancedFilterPicklistMap = getPicklistOptions(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].PickListFieldInfo.PickListKeyValueMapList);
            lwcFlexTableHandler.isMultiSelect =  fieldType === 'MULTIPICKLIST'  ? true  : false;
            
    }else{
        lwcFlexTableHandler.otherField = true;
        if( fieldType === 'STRING'){
            lwcFlexTableHandler.AdvancedFieldInputType ='text';
        }
        
        else if(fieldType === 'DOUBLE'  || fieldType === 'CURRENCY' || fieldType === 'PERCENT')//lwcFlexTableHandler.FieldMetaData[fieldname].Type === 'PERCENT'
        {
            lwcFlexTableHandler.AdvancedFieldInputType ='number';

        }else if(fieldType === 'DATE'){
            lwcFlexTableHandler.AdvancedFieldInputType ='date';

        }else if( fieldType === 'DATETIME'){
            lwcFlexTableHandler.AdvancedFieldInputType ='datetime';

        }else if( fieldType === 'BOOLEAN'){
            lwcFlexTableHandler.AdvancedFieldInputType ='checkbox'; 
           
        }else{
            lwcFlexTableHandler.AdvancedFieldInputType = fieldType.toLowerCase();
        }
        
    }

}

function resetAdvancedFilterValue(lwcFlexTableHandler){

    lwcFlexTableHandler.textareaCheck = false;
    lwcFlexTableHandler.otherField    = false;
    lwcFlexTableHandler.isPicklist    = false;
    lwcFlexTableHandler.isReference   = false;
}

function getPicklistOptions(picklistMap){
    
    let options =[];
    if(picklistMap != undefined){
        
        for(let i=0; i < picklistMap.length; i++){
            let valuemapNew={};
            let valueMap = picklistMap[i];
            valuemapNew['label'] = valueMap.Label;
            valuemapNew['value'] = valueMap.Value;
            options.push(valuemapNew);
        }
    }

    return options;
}
export function enableAutoIndex(lwcFlexTableHandler,data){

    var start = (lwcFlexTableHandler.currentPage-1) * lwcFlexTableHandler.pageSize;
    const end   = lwcFlexTableHandler.currentPage * lwcFlexTableHandler.pageSize;
   
    let value;
    for(let i=0; i < data.length; i++){

        if(lwcFlexTableHandler.flexTableConfig.AutoIndexBehaviour === 'ExcludeComputedRows'){
           if(data[i].isTotal != true && data[i].isRowEnabled != true && data[i].isSubTotal != true && data[i].isSubTotalEnabled != true && data[i].isOverAllTotal != true){
            value= start + 1;
                data[i]['sr__no'] = value.toString();
                start= start + 1;
            }
        }else{
            if(data[i].isOverAllTotal != true && data[i].isRowEnabled != true && data[i].isTotal != true){
                value= start + 1;
                data[i]['sr__no'] = value.toString();
                start= start + 1;
            }
        
        }
    }

    lwcFlexTableHandler.PaginatedData = data;
}
export function getSelectedRows(lwcFlexTableHandler){
    lwcFlexTableHandler.callGetSelectedRows = false;
    lwcFlexTableHandler.selectedCons = [];
    let selectedRows = lwcFlexTableHandler.template.querySelectorAll('lightning-input');
    let allSelected=  true;
    let index;
    let tempRecord = Object.assign({},lwcFlexTableHandler.SelectedIdPagination[lwcFlexTableHandler.currentPage]); //cloning object  
    // based on selected row getting values of the contact

    if(lwcFlexTableHandler.listOfRows.length == 0 && lwcFlexTableHandler.listOfRows == undefined){
          lwcFlexTableHandler.recordselection= {};
    }
    for(let i = 0; i < selectedRows.length; i++) {
       if(selectedRows[i].dataset.id == undefined && selectedRows[i].type === 'checkbox' && selectedRows[i].classList.contains('allSelect')){
              index = i;
       }
        if(lwcFlexTableHandler.listOfRows.includes(selectedRows[i].dataset.id) && selectedRows[i].type === 'checkbox') {
            selectedRows[i].checked = true;
            lwcFlexTableHandler.recordselection[selectedRows[i].dataset.id] = true;
            lwcFlexTableHandler.selectedCons.push({
                Name: selectedRows[i].value,
                Id: selectedRows[i].dataset.id
            })
        }else if(selectedRows[i].dataset.id != undefined && selectedRows[i].type === 'checkbox'){
               allSelected =false;
               lwcFlexTableHandler.recordselection[selectedRows[i].dataset.id] = false;
        }

    }
    if(index != undefined && selectedRows[index] != undefined){
        selectedRows[index].checked = allSelected;
    }

}