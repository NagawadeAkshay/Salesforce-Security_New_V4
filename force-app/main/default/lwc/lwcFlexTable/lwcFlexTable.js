import { LightningElement,wire, track,api } from 'lwc';
import getFlexTableInfo from '@salesforce/apex/FlexGridEnhancedCtrl.getFlexTableInfo';
import getPageRecordsMap from '@salesforce/apex/FlexGridEnhancedCtrl.getPageRecordsMap';
import getFlexGridInfo from '@salesforce/apex/FlexGridEnhancedCtrl.getFlexGridInfo';
import { replaceAllMergeFields,setValues,getdata,setVariable,handlePagination,sortData,getSelectedRows, inithandlemouseup, inithandlemousedown, inithandlemousemove, initpaddingDiff, initgetStyleVal, setMetaData,EnableChild,handleListViewChange, updateOnColumnChange, getLabelForColumns,enableAutoIndex} from './initiate';
import { refreshLayout,checkActionBehavior,createSaveRecordMap, saveRecords,updateRow,/*onNewAction*/checkForConfirmationMsg, editSingleRecord, onClose,updateEditAllAction,QuickSearch,getAdvancedfilterSeachkey,handleRemoveFilter,handleClearFilter,deleterow,addrow ,checkRefreshBehavior,handleMenuActions,handleSortDirection} from './action'
import { getActions,getActionsFromHideActiionMap } from './expressionevaluator'
import TIME_ZONE from '@salesforce/i18n/timeZone';
//import saveRecords from '@salesforce/apex/FileUploadCtrl.saveRecords';
import GOVGRANTS from '@salesforce/resourceUrl/GovGrants';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
//import getmessageTimeOut from '@salesforce/apex/FlexGridEnhancedCtrl.getmessageTimeOut';
//import flexLayoutMessageChannel from '@salesforce/messageChannel/flexLayout__c';
// import { MessageContext} from 'lightning/messageService';
import geticons from '@salesforce/apex/AppUtils.getIcons';
import addNotes from '@salesforce/apex/NotesCtrl.addNotes';
import updateNote from '@salesforce/apex/NotesCtrl.updateNoteRecord';
import addNoteList from '@salesforce/apex/NotesCtrl.addNoteList';
import updateNoteList from '@salesforce/apex/NotesCtrl.updateNoteList';
//import insertContnetNotes from '@salesforce/apex/NotesCtrl.insertContnetNotes';
import { setSessionData,getSessionData} from './evaluate';
import { subscribe, unsubscribe, publish, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import ExternalLibNew from '@salesforce/resourceUrl/ExternalLibNew';
import LightningConfirm from "lightning/confirm";

export default class LwcFlexTable extends LightningElement {


    collapsedicon    = 'utility:down';
	alternativetext ="Expanded"
    Loading          = false;
    @api initResult;
    @api tableMetaData;
    @api gridLevel;
    @api stringParameters; 
    @api listParameters;
    @api mode;
    @api pageBlockId;
    @api isModal;
    flexTableConfig;
    FieldMetaData;
    DataTableDetailConfigMap;
    @track columns=[];
    @track rows =[];
    @track data =[];
    visibleColumns=[];
    isDropdownColumn=false;
    FlexTableFilterListViewList;
    isListViewPresent;
    masterFilterClause;
    Header;
    userListViewList;
    isParentTargetLookupField;
    dataparamJsonRecord;
    @api parentRecordId; //='a1i4P000004uCVC';
    TotalCount;
    timeZone;
    disableMenu = false;
    @track SaveRecordMap = {};
    @track SaveRecordList =[];
    FlexTableId;
    queryfieldsMap={};
    tableObjectsMap={};
    levelVsTableIdMap={};
    tableObjectIdMap={};
    tableIdVsObjectAPIMap={};
    child1MetaData={};
    child2MetaData={};
    colLength;
    level;
    isSave=false;
    saveRecordMap={};
    saveRecordParam={};
    parentLookupFieldMap ={};
    newSaveRecordCount =0;
    editRecordCount = 0;
    @api parentId;
    requiredfields=[];
    @api globalMap={};
    DefaulValuesList=[];
    @api parentDetail;
    child1Detail={};
    child2Detail={};
    FlexTableActionMap;
    rowId;
    @track AllRowActions=[];
    isAction = false;
    @track RowActions;
    Listviews=[];
    dataforQuickSeach = [];
    sortBy;
    sortDirection;
    sortablecloumnList=[];
    newsortcolumns=[];
    SortOrderMessage;
    SortOrderMessageTitle='Records are sorted by ';
    SorttableColumnList;
    SortWay;
    showSortMsg =false;
    displayFieldNames;
    selectedRecords=[];
    recordselection={};
    flexGridEnhanced_currentPageURL;
    query;
    TopAction;
    row;
    currentUserInfo;
    selectedItemValue;
    ModalUrl;
    //isModalUrl;
    searchkey;
    QuickSearchColumnList=[];
    flattenedData;

    Totoalrecords='';
    PageSizeValue;
    enableTotalRecords
    PageSize;

    quicksearchdata;
    totalPages; 
    isFirst=true;
    isLast=false;
    totalRecords;
    currentPage=1;
    filterlist=[];
    firstOnly = true;
    FieldReferenceList=[];
    EnableTotalRecordsCount = false;
    EnablePagination;
    EnableFilter = false;
    EnableQuickSearch  = false;
    FilterClick  = false;
    optionsMap={};
    FieldsOption=[];
    AdvancedFilterFieldApi;
    @track OpratorOption=[];
    loperandValue;
    AdvanceFilterOperatorValue;
    AdvanceFilterOperatorLabel;
    AdvancedFieldInputType;
    textareaCheck = false;
    otherField    = false;
    isPicklist    = false;
    isReference   = false;
    @track AdvancedFilterPicklistMap=[];
    isMultiSelect = false;
    SObjectName;
    AdvancedFilterSObjectFieldName;
    AdvancedFilterSObjectName;
    LookupDisplayFields;
    Advancedfiltervalue;
    AdvancedfiltervalueforLookup;
    @track Advancedfilterlist=[];
    keyIndex=0;
    isApply = false;
    isClear = false;


    Totoalrecords='';
    PageSizeValue;
    enableTotalRecords
    PageSize;
    flattenedData;
    quicksearchdata;
    totalRecords;
    currentPage=1;
    filterlist=[];
    firstOnly = true;
    FieldReferenceList=[];
    EnableTotalRecordsCount = false;
    sorted= false;
    recordSelectedMap=[];
    isSelected =false;
    tempMap=[];
    listOfRows=[];
    @track selectedCons;
    callGetSelectedRows =false;
    hideCheckBoxColumn;
    showRowNumberColumn;
    selectedRecords=[];
    SelectedRecordPagination={};
    SelectedIdPagination={};
    ShowHeaderHelpText= false;
    ShowHelptextContent;
    showToolTip= false;
    fieldLevelshowToolTip = false;/*Bug 367150: Starts */
    @track TopLevelAction = [];
    rowGroupingFieldList =[];
    subTotalEnabledColumn=[];
    //for page size config
    EnablePageSize= false;
    pageSizes;
    pageSizesMap=[];
    FormulaJSON = {};
    OverAllColumnsFields=[];
    OverAllColumns={};
    hideColumnJSONMap={};
    finalParentExpressionEval;
    ParentRecord={};
    expressionFieldsArray=[];
    expressionUserFieldsArray=[];
    expressionParentFieldsArray=[];


	Totoalrecords='';
	ErrorMessage ;
    isErrorMessage = false;
    @api messageTimeOut=5000;
    isSuccessMessage = false;
    SuccessMessage;
    isWarningMessage = false;
    WarningMessage;
    //OpenConfirmationBox=false;
    SubHeader = false;
    SubHeaderDescription;
	govGrantPleaseWaitIcon;
    isLoading = false;
    noRecords= false;
    ShowRecordMessage= false;
    //to Hide actioncolumn
    isRowActionPresent =  false;
	@api tableWidth ="width:100%;";
	childTablewdth;
    dropdownwidth="width:25px !important;";
    EnableParentHideMap={};
    RowLevelhideExpressionResult={};
    SObjectContentNote;
    ApprovalLockedRecordsMap ={};
    @api currentPageReference;
    @api isLightning;
    rowIdList=[];
    isFirstActionClick = false;
    FirstRowClick = {};
    isRequiredfieldMissing = false;
    subscription = null;
    @wire(MessageContext)
    messageContext;
    @track warningMessages = [];
    sObjectFormInstance;
    isRecordOpenMode = false;
    messageTimeOutEnabled = false;
    isRowAction = false;
    readOnlyColumnJSONMap ={};
    showNoAction= false;
	ModalAttribute={};
    isModalFlexLayout = false;
    ModalRecordId;
    ModalHeader;

    //menu action
    menuLevelActions =[];
     isMenuActionPresent = false;
    ///sessionstorage
    mapOfSessionData = {};
    initSessionData ;
    searchText = '';
    isResetMessage = false;
    resetMessage = 'Clicking this Reset Table icon will refresh the table default values'
    selectedListView;
    isResetSuccess = false;
    ResetSuccess = 'Table has been reset.';
    showSortMsgData =false;
    isRemoveSessioStorage = false;
    nameSpace;
    selectedMenuAction;
    disableButton= true;
    EnableExport = false;
    EnableExportXls =false;
    CurrentFilterCriteria;
    readOnlyCellJSONMap = {};
    hideReadOnlyCellMap = {};
    
    isTableHasHorizontalScroll=false;
    isTableAlreadyLoaded=false;
    isTableHasVerticalScroll=false;
    isNeedToCheckVerticalScroll=true;
    openDropDownAtTopSide=false;
    @track openedRecords = new Set();
    @api isChildTable;

    connectedCallback(){
        loadStyle(this, GOVGRANTS+ '/Component/CSS/Flexgridlwc.css').then(() => {
        });
        loadStyle(this, ExternalLibNew + '/FontAwesome/css/font-awesome.min.css').then(() => {
        });
        this.timeZone = TIME_ZONE;
        if(this.initResult.MessageTimeOutEnabled != undefined && this.initResult.MessageTimeOutEnabled != ''){
            this.messageTimeOutEnabled = this.initResult.MessageTimeOutEnabled ;
         }
          if(this.initResult.MessageTimeOut != undefined && this.initResult.MessageTimeOut != ''){
             this.messageTimeOut = this.messageTimeOutEnabled == true ? this.initResult.MessageTimeOut != undefined ? this.initResult.MessageTimeOut : this.messageTimeOut:this.messageTimeOut;
          }
		geticons({strResourceName : 'govGrantPleaseWaitIcon'}).then(result=>{
				
            if(result){
                this.govGrantPleaseWaitIcon = result;
                
            }
        
        }).catch(error => {

        });
        this.isLoading = true;
        setVariable(this);
       
        if(this.gridLevel === 0){
           // this.isSave = true;
        }
        if(this.initResult.GridType == 'FlexTable' || (this.isParentTargetLookupField || this.initResult.FlexGridMetaData.parentFlexTableId ==  this.flexTableConfig.FlexTableId)){
            setMetaData(this); 
            if(this.child1MetaData != undefined || this.child2MetaData != undefined){
                if(this.gridLevel < 2){
                    this.isDropdownColumn = true;
                }
                
            }
          this.level= this.gridLevel + 1;   
        }

        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (this.subscription) {
            return;
        } else {
            this.subscription = subscribe(this.messageContext, messageChannel, (message) => this.handleLmsMessage(message), {
                scope: APPLICATION_SCOPE
            });
        }
    }

    handleLmsMessage(message){
    
        if(message.data.flexTableName != undefined){
            if(message.data.flexTableName == this.initResult?.FlexGridMetaData?.flexGridName || message.data.flexTableName == this.initResult?.ParentFlexTable?.FlexTableConfigMap?.FlexTableConfig?.Name){
                let result = JSON.parse(message.data.result);
                //this.stringParameters = JSON.parse(result.keyValueMap);
                const combinedStringParameter= {...this.stringParameters,...JSON.parse(result.keyValueMap)}
                const combinedListParameter= {...this.listParameters,...JSON.parse(result.listValueMap)}
                this.stringParameters = combinedStringParameter;
                this.listParameters =  combinedListParameter;
                if(this.CurrentFilterCriteria != undefined){
                    let FilterClause = this.CurrentFilterCriteria
                    FilterClause = replaceAllMergeFields(this,FilterClause);
                    this.dataparamJsonRecord.filterCriteria=FilterClause;
                    getdata(this, true);
                }
                
            }
        }

        if(message.data.refreshAllFlexTables == true){
            if(this.gridLevel == 0){
                getdata(this, true);
            }
        }

        if(message.data.closeuploadfile == true && this.isModalFlexLayout == true){
        
            this.isModalFlexLayout = false;
            checkRefreshBehavior(this,this.action);
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    handleCollapsed(){
        this.isCollapsed = !this.isCollapsed;
        if(this.isCollapsed){            
            this.collapsedicon = 'utility:up';
			this.alternativetext="Expanded";
        }else{
            this.collapsedicon = 'utility:down';
            this.alternativetext="Collapse";
        }
    }

    handlemouseup(e) {
        this._tableThColumn = undefined;
        this._tableThInnerDiv = undefined;
        this._pageX = undefined;
        this._tableThWidth = undefined;
    }
 
    handlemousedown(e) {
        if (!this._initWidths) {
            this._initWidths = [];
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            tableThs.forEach(th => {
                this._initWidths.push(th.style.width);
            });
        }
 
        this._tableThColumn = e.target.parentElement;
        this._tableThInnerDiv = e.target.parentElement;
        while (this._tableThColumn.tagName !== "TH") {
            this._tableThColumn = this._tableThColumn.parentNode;
        }
        while (!this._tableThInnerDiv.className.includes("slds-cell-fixed")) {
            this._tableThInnerDiv = this._tableThInnerDiv.parentNode;
        }
        this._pageX = e.pageX;
 
        this._padding = this.paddingDiff(this._tableThColumn);
 
        this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
    }
 
    handlemousemove(e) {
        if (this._tableThColumn && this._tableThColumn.tagName === "TH") {
            this._diffX = e.pageX - this._pageX;
 
            this.template.querySelector("table").style.width = (this.template.querySelector("table") - (this._diffX)) + 'px';
 
            this._tableThColumn.style.width = (this._tableThWidth + this._diffX) + 'px';
            this._tableThInnerDiv.style.width = this._tableThColumn.style.width;
 
            let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
            let tableBodyRows = this.template.querySelectorAll("table tbody tr");
            let tableBodyTds = this.template.querySelectorAll("table tbody .dv-dynamic-width");
            tableBodyRows.forEach(row => {
                let rowTds = row.querySelectorAll(".dv-dynamic-width");
                rowTds.forEach((td, ind) => {
                    rowTds[ind].style.width = tableThs[ind].style.width;
                });
            });
        }
    }

    handlemousemove(event) {
        if (this._columnName != undefined && this._thColName != undefined) {
            //this._colResizedWidth = event.target.style.width;
            this._diffX = event.pageX - this._pageX;
            this._colResizedWidth  = (this._tableThWidth + this._diffX) + 'px';
            
            if (parseInt(this._colResizedWidth) < this.widthMap[this._columnName] && parseInt(this._colResizedWidth) > 50) {
               
                for (let i = 0; i < this.columns.length; i++) {
                    if (this.columns[i].label == this._columnName) {
                        this.columns[i].fixedWidth = 'width:' + this._colResizedWidth + ';max-width:' + this._colResizedWidth + ' !important;min-width:50px;';
                        if (this.columns[i + 1] != undefined) {
                            let updatedWidth = this.widthMap[this.columns[i + 1].label] + (this.widthMap[this._columnName] - parseInt(this._colResizedWidth));
                            this.columns[i + 1].fixedWidth = 'width:' + updatedWidth + 'px;max-width:' + updatedWidth + 'px !important;min-width:50px;';
                        } else {
                            if (this.columns[i - 1] != undefined) {
                                let updatedWidth = this.widthMap[this.columns[i - 1].label] + (this.widthMap[this._columnName] - parseInt(this._colResizedWidth));
                                this.columns[i - 1].fixedWidth = 'width:' + updatedWidth + 'px;max-width:' + updatedWidth + 'px !important;min-width:50px;';
                            }
                        }
                    }
                }
            } else {
                if (this._thColName && this._colResizedWidth != 'auto' && this._colResizedWidth != '' && parseInt(this._colResizedWidth) > 50) {
                    this._thColName.fixedWidth = 'width:' + this._colResizedWidth + ';max-width:' + this._colResizedWidth + ' !important;min-width:50px;';
                }
                const tableTHElement = this.template.querySelectorAll('th')
                if (tableTHElement != undefined) {
                    tableTHElement.forEach(th => {
                        if (th.offsetWidth != undefined) {
                            this.widthMap[th.dataset.id] = th.offsetWidth-12;
                        }
                    })
                }
                
                const tableTagParentDivElement = this.template.querySelector('[data-id="tblViewInnerDiv"]');
                if (tableTagParentDivElement != undefined && tableTagParentDivElement.clientWidth < tableTagParentDivElement.scrollWidth) {
                    tableTagParentDivElement.style.overflowX = 'auto';
                }
            }
        }
    }

    onedit(event){
        updateRow(event.target.dataset.id,'isEdit',this);
        let filters = [...this.template.querySelectorAll('c-fieldlwc')]
            .map(filter => filter.editRecord(event.target.dataset.id));
    }

    onEnableChild(event){
		let width = this.template.querySelector('.tableClass').getBoundingClientRect().width != undefined ? this.template.querySelector('.tableClass').getBoundingClientRect().width-60 : 'auto';
      //  this.childTablewdth = 'width:'+width+'px';
	  this.childTablewdth = 'max-width:100%;';
        EnableChild(event.target.dataset.id,this);
        updateRow(event.target.dataset.id,'EnableChild',this);
       /*if(this.child1MetaData != undefined){
            this.child1Detail['Id'] =  event.target.dataset.id;
        }
        if(this.child1MetaData != undefined){
            this.child2Detail['Id'] =  event.target.dataset.id;
        }*/

        if(this.gridLevel == 0){
            let ChildFlexTable = {};
            ChildFlexTable['Id'] = event.target.dataset.id;
        this.child1Detail[event.target.dataset.id] = ChildFlexTable
          //  this.child1Detail['childFlexTable']['Id'] =  event.target.dataset.id;
        }else if(this.gridLevel == 1){
            let GrandChildFlexTable = {};
            GrandChildFlexTable['Id'] = event.target.dataset.id;
        this.child1Detail['GrandChildFlexTable'] = GrandChildFlexTable
           // this.child1Detail['GrandChildFlexTable']['Id'] =  event.target.dataset.id;
        }
        
       
    }
    /*handledblclickresizable() {
        let tableThs = this.template.querySelectorAll("table thead .dv-dynamic-width");
        let tableBodyRows = this.template.querySelectorAll("table tbody tr");
        tableThs.forEach((th, ind) => {
            th.style.width = this._initWidths[ind];
            th.querySelector(".slds-cell-fixed").style.width = this._initWidths[ind];
        });
        tableBodyRows.forEach(row => {
            let rowTds = row.querySelectorAll(".dv-dynamic-width");
            rowTds.forEach((td, ind) => {
                rowTds[ind].style.width = this._initWidths[ind];
            });
        });
    }*/
 
    /*paddingDiff(col) {
 
        if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
            return 0;
        }
 
        this._padLeft = this.getStyleVal(col, 'padding-left');
        this._padRight = this.getStyleVal(col, 'padding-right');
        return (parseInt(this._padLeft, 10) + parseInt(this._padRight, 10));
 
    }*/

    handledblclickresizable(event){
    
    }

    dummyMethod(){
    
        let filters = [...this.template.querySelectorAll('c-fieldlwc')]
                                    .map(filter => filter.setValues());
    }
    paddingDiff(col) {
        console .log('inside padding');
        if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
            return 0;
        }
 
        this._padLeft = this.getStyleVal(col, 'padding-left');
        this._padRight = this.getStyleVal(col, 'padding-right');
        return (parseInt(this._padRight, 10));
 
    }

    
 
    getStyleVal(elm, css) {
        return (window.getComputedStyle(elm, null).getPropertyValue(css))
    }

    handleMessages(event){
        if(this.gridLevel === 0){
            if(event.detail.isSave == true && event.detail.isNew != undefined && event.detail.isNew== true){
                this.isSave = true;
                this.isNew = true;
            }
            if(event.detail.isSave == true){
                this.isSave = true;
            }
            if(event.detail.isSave == false){
                this.isSave = false;
            }
        
                if(event.detail.isError == true){
                    this.isRequiredfieldMissing = true;
                    this.ShowErrorMessage(event.detail.Message);
                }
        
        }
    
    }
    updateSaveMap(event){
    
        if(this.gridLevel === 0){
            
            createSaveRecordMap(this,event);
        }
       
        
    }

    
    @api
    checkSave(){
        let childTableInstance =this.template.querySelectorAll('c-lwc-flex-table');
        let returndatafromchildtableSave =0; 
        childTableInstance.forEach(childtable => {
         returndatafromchildtableSave = returndatafromchildtableSave + childtable.checkSave();
         });
         if(this.gridLevel == 0 && this.newSaveRecordCount == 0 && this.editRecordCount == 0 && returndatafromchildtableSave  ==0 ){
         
            this.isSave = false
         }else{
            return this.newSaveRecordCount + this.editRecordCount;
         }
      }
      
   @api
    OnSave(){
    
        let childTableInstance =this.template.querySelectorAll('c-lwc-flex-table');

        let SaveRecordMap = {};
        childTableInstance.forEach(childtable => {
            let returndatafromchildtable = childtable.OnSave();
            if(returndatafromchildtable != undefined){
                //let recordlist=[];
                //var =[];
                let keys=Object.keys(returndatafromchildtable);
                for(let i=0; i< keys.length; i++){
                    
                    if(returndatafromchildtable[keys[i]] != undefined){
                    
                        //SaveRecordMap[keys[i]]= returndatafromchildtable[keys[i]];
                        //let recordlist= SaveRecordMap[keys[i]];
                        var mainrecordlist= SaveRecordMap[keys[i]];
                        if(SaveRecordMap[keys[i]] != undefined && SaveRecordMap[keys[i]].length > 0){
                            
                            for(let k=0; k < returndatafromchildtable[keys[i]].length; k++){
                                let value= returndatafromchildtable[keys[i]][k];
                                mainrecordlist.push(value);
                            }
                        }else{
                            mainrecordlist= returndatafromchildtable[keys[i]];
                        }
                        SaveRecordMap[keys[i]]= mainrecordlist;
                        this.saveRecordMap[keys[i]] = mainrecordlist;
                    }
                }
                
            }
           
        });
        //this.saveRecordMap = SaveRecordMap;

        let fieldInstance =this.template.querySelectorAll('c-fieldlwc');
        let title ;
        let noteContent ;
        let recordId ;
		let contentNotes = [];
        let contentNoteRcd = {};
        fieldInstance.forEach(cell => {
            let returncelldata = cell.setSaveRecord();
            if (returncelldata && this.SObjectName == 'ContentNote') {
               
                if (returncelldata != undefined && returncelldata.value != undefined  && returncelldata.value != ''&& (returncelldata.fieldName == 'Content' || returncelldata.fieldName == 'Title')) {
                    recordId = returncelldata.recordId != undefined ? returncelldata.recordId : this.row.id;
                    contentNoteRcd.noteRecordId = recordId;
                    let conNoteArrayRcd = contentNotes.find((data) => data.noteRecordId == recordId);
                    //let conNoteFindIndex = contentNotes.findIndex((data) => data.noteRecordId == recordId);
                   
                    if (conNoteArrayRcd == undefined) {
                        if (returncelldata.fieldName == 'Title') {
                            contentNoteRcd.title = returncelldata.value;
                        }
                        else if (returncelldata.fieldName == 'Content') {
                            contentNoteRcd.contentTxt = returncelldata.value;
                        }
                        // contentNotes.push({ title: title, contentTxt: noteContent, noteRecordId: recordId });
                        contentNotes.push(contentNoteRcd);
                        contentNoteRcd = {};
                    }
                    else {
                        if (returncelldata.fieldName == 'Title') {
                            conNoteArrayRcd.title = returncelldata.value;
                        }
                        else if (returncelldata.fieldName == 'Content') {
                            conNoteArrayRcd.contentTxt = returncelldata.value;
                        }
                    }
                }
                else{                       
                    if(returncelldata != undefined && returncelldata.isRequired === true && (returncelldata.value == undefined  || returncelldata.value == '') ){
                        this.isRequiredfieldMissing = true;
                        if(this.gridLevel == 0){                          
                            this.ShowErrorMessage('Required Fields Missing');
                        }else{
                            let data={};
                            data['isError'] = true;
                            data['Message'] = 'Required Fields Missing';
                            const showmessagesatparent =new CustomEvent('showmessage', {
                                detail: data,
                                bubbles: true,
                                composed: true,
                            });
                            this.dispatchEvent(showmessagesatparent);
                        }
                        return;
                    }
                }
            }else{
                let fieldType;
                if(returncelldata != undefined && returncelldata.value != undefined){
                    fieldType = this.FieldMetaData[returncelldata.fieldName].Type;
                }
                if(returncelldata != undefined && returncelldata.value != undefined && returncelldata.value != ''){
                       createSaveRecordMap(this,returncelldata);
                    }else if(returncelldata != undefined && returncelldata.value != undefined && this.FieldMetaData[returncelldata.fieldName].Type == 'BOOLEAN' && returncelldata.value == false){
                        createSaveRecordMap(this,returncelldata);
                    }else if(returncelldata != undefined && returncelldata.value != undefined && ["INTEGER","PERCENT","DOUBLE","CURRENCY"].indexOf(fieldType) != -1){
                        createSaveRecordMap(this,returncelldata);
                    } 
                    else if(returncelldata != undefined && returncelldata.isRequired === false && (fieldType=='PICKLIST'|| fieldType=='MULTIPICKLIST' || fieldType=='REFERENCE' || fieldType=='STRING' || fieldType=='TEXTAREA')){
                        createSaveRecordMap(this,returncelldata);
                    }
                    else{
                        
                        if(returncelldata != undefined && returncelldata.isRequired === true && returncelldata.value !== ' ' ){
                            this.isRequiredfieldMissing = true;
                            if(this.gridLevel == 0){
                                
                                this.ShowErrorMessage('Required Fields Missing');
                            }else{
                                let data={};
                                data['isError'] = true;
                                data['Message'] = 'Required Fields Missing';
                                const showmessagesatparent =new CustomEvent('showmessage', {
                                    detail: data,
                                    bubbles: true,
                                    composed: true,
                                });
                                this.dispatchEvent(showmessagesatparent);
                            }

                            return;
                        }
                    }
                    if(returncelldata != undefined && returncelldata.value != undefined &&  returncelldata.value === false){
                        createSaveRecordMap(this,returncelldata);
                    }
                    
                
            }
           
        });

        if(this.SObjectName == 'ContentNote' && this.gridLevel == 0 && this.isNew != true && this.isRequiredfieldMissing != true){
            this.isLoading=true;
            //let noteId = recordId != undefined ?recordId : this.row.id;
            // updateNote({title : title,Description : noteContent,noteRecordId :noteId ,parentRecordId : this.parentId}).then(response=>{
            if (contentNotes.length > 0) {
                updateNoteList({ contentNotes: JSON.stringify(contentNotes), parentRecordId: this.parentId }).then(response => {
                    let successMsg;
                    if (response.success === true) {
                        this.editRecordCount = 0;
                        if (this.saveTopAction != undefined) {
                            successMsg = this.saveTopAction != undefined && this.saveTopAction.MessageConfig != undefined ? this.saveTopAction.MessageConfig : 'Record updated successfully!';

                            this.ShowSuccessMessage(successMsg);
                            checkRefreshBehavior(this, this.saveTopAction);
                        } else {
                            this.ShowSuccessMessage('Record updated successfully!');
                            this.firstOnly = true;
                            getdata(this, true);

                        }
                    }
                    else if (response.success === false && response.message != undefined) {
                        this.ShowErrorMessage(response.message);
                    }

                }).catch(error => {
                });
            }
            else{
                this.isSave = false;
                this.editRecordCount = 0;
                this.newSaveRecordCount = 0;
                this.ShowSuccessMessage('Record updated successfully!');
                getdata(this, true);
            }
        }else{
            if(this.SObjectName == 'ContentNote' && this.isNew == true && this.isRequiredfieldMissing != true){
                this.isLoading=true;
                // addNotes({title : title,Description : noteContent,noteRecordId :recordId ,parentRecordId : this.parentId}).then(response=>{
                addNoteList({ contentNotes: JSON.stringify(contentNotes), parentRecordId: this.parentId }).then(response => {
                    let successMsg;
                    if(response.success === true){
                          this.isSave =false;
                          this.newSaveRecordCount--;
                          if(this.saveTopAction != undefined){
                            successMsg = this.saveTopAction!= undefined && this.saveTopAction.MessageConfig !=undefined ? this.saveTopAction.MessageConfig :'Record created successfully!';

                            this.ShowSuccessMessage(successMsg);
                            checkRefreshBehavior(this,this.saveTopAction);
                        }else{
                            this.ShowSuccessMessage('Record created successfully!');
                            this.firstOnly = true;
                            getdata(this,true);
                            this.isNew = false;
                        }
                      }
                      else if(response.success === false && response.message != undefined){
                            this.ShowErrorMessage(response.message);
                       }
                  
                }).catch(error =>{
                    this.ShowErrorMessage(error.body.message);
                });
            }else if(this.gridLevel == 0 && this.SObjectName != 'ContentNote'){
                saveRecords(this);
            }
        }
        this.isRequiredfieldMissing = false;
        return this.saveRecordMap;
        
    }

    @api
    processResponse(response){
    
        if(response.result != undefined){
            
            let updatedMap = response.result[this.tableMetaData.FlexTableConfigMap.FlexTableConfig.FlexTableId];

            if(updatedMap != undefined && updatedMap.updatedRecordsMap != undefined && Object.keys(updatedMap.updatedRecordsMap).length >0){
            
                let keys = Object.keys(updatedMap.updatedRecordsMap);
                for(let i=0; i < keys.length; i++){
                
                    updateRow(updatedMap.updatedRecordsMap[keys[i]].Id,'isEdit',this);
                }
            }
            
    
        }
        
        let filters = [...this.template.querySelectorAll('c-fieldlwc')]
                                        .map(parentTable => parentTable.setValues());

        let unableedit = [...this.template.querySelectorAll('c-lwc-flex-table')]
                                        .map(diableEdit => diableEdit.processResponse(response));
        
    
    }

    OnNew(event){
       // onNewAction(this);
    }

    
    OnClickRowActions(event){
        
        //this.rowId = event.target.dataset.id;
        //let actionId = event.target.dataset.actionid;
        //this.action = event.target.value;
        let action = event.target.value;
		this.isRowAction = true;
        if(action.ActionLocked != true){
            if(action.isClose === true){
                onClose(this);
            }else if(action.isUndo === true){
                editSingleRecord(this,action);
                setValues(this);
                let undoRecord = [...this.template.querySelectorAll('c-fieldlwc')]
                .map(method => method.setValuesOnUndo());
            }else{
                for( let index =0; index < this.FlexTableActionMap.Row.length; index++){
                    if(this.FlexTableActionMap.Row[index].Id === action.Id){
                        if(this.SObjectContentNote && this.FlexTableActionMap.Row[index].StandardAction != undefined && this.FlexTableActionMap.Row[index].StandardAction.toLowerCase() === 'view'){
                            this.isContentNoteView = true;
                            this.isNewOpen = true;
                        }else{
                            this.isContentNoteView = false;
                        }
                        // if(this.ApprovalLockedRecordsMap[this.row.id] === true ){
                                
                        //         if(this.FlexTableActionMap.Row[index].SingleRowEditBehavior != 'Inline' && this.FlexTableActionMap.Row[index].StandardAction != 'Delete'){
                                    
                        //             this.action=this.FlexTableActionMap.Row[index];
                        //         }
                        // }else{
                        
                            this.action=this.FlexTableActionMap.Row[index];
                        //}
                        
                    
                    }
                
                
            }
            if(this.action != undefined){
                checkForConfirmationMsg(this,this.action);
            }
        }
    }
}

    /*get RowActions(){
        
        return this.AllRowActions;

    }*/

    OnClickofMenu(event){
        
        if(event.target != undefined && this.isRowAction == false){
        this.row = event.target.value;
        if(this.row.isNew === true){
            let actionList =[];
            let actionobj = {};
            //actionobj['Id'] = action.Id;
            actionobj['title'] = 'Remove record';
            actionobj['Iconcss'] = 'utility:close';
            actionobj['isClose'] = true;
            actionList.push(actionobj);
            this.RowActions = actionList;
            //this.AllRowActions = actionList;
            this.isAction = true;
        }else if(this.row.isEdit === true){
            let actionList =[];
            let actionobj = {};
            //actionobj['Id'] = action.Id;
            actionobj['title'] = 'Undo';
            actionobj['Iconcss'] = 'utility:undo';
            actionobj['isUndo'] = true;
            actionList.push(actionobj);
            this.RowActions = actionList;
            //this.AllRowActions = actionList;
            this.isAction = true;
        }else{
            
            // if(this.isFirstActionClick === true){
            //     getActionsFromHideActiionMap(this);
            // }else{
            
            //     getActions(this,this.row);
            // }

            if(this.FirstRowClick[this.row.id] === undefined){
                    getActions(this,this.row);
                }else{
                
                    getActionsFromHideActiionMap(this);
                }
        }
    }
    this.isRowAction = false;
    }
    OnClickTopActions(event){
    
        //this.selectedIds = getSelectedDetails(this,this.SelectedIdPagination);
        // const actionId = event.currentTarget.dataset.id;
        // let actionMAp = event.currentTarget.dataset.action;
        // let isEditAll = event.currentTarget.dataset.iseditall;
        this.TopAction = event.target.value;
        let action;
		this.SaveDisable = false;
        
        
            if(this.FlexTableActionMap.Top != undefined){
            for( let index =0; index < this.FlexTableActionMap.Top.length; index++){
                if(this.SObjectContentNote && this.FlexTableActionMap.Top[index].StandardAction == 'View'){
                    this.isContentNoteView = true;
                    this.isNewOpen = true;
                }else{
                    this.isContentNoteView = false;
                    this.noteContent = '';
                }
                if(this.FlexTableActionMap.Top[index].Id === this.TopAction.Id){
                    this.action=this.FlexTableActionMap.Top[index];
                // }
                    }
                }
            }

            if(this.TopAction.isEditAll == true){
                if(this.gridLevel ==0){
                    this.isSave=true;
                    
                }
                if(this.gridLevel ==0 && this.TopAction.Name == 'Undo Edit'){
                    this.isSave=false;
                }
                if(this.gridLevel > 0){
                    let data={};
                                data['isError'] = false;
                                data['isSave'] = this.TopAction.Name == 'Undo Edit' ? false: true;
                                const showmessagesatparent =new CustomEvent('showmessage', {
                                    detail: data,
                                    bubbles: true,
                                    composed: true,
                                });
                                this.dispatchEvent(showmessagesatparent);
                }
                
                updateEditAllAction(this);
            }

            if(this.action != undefined){
            // openUrl(this,action);

            checkForConfirmationMsg(this,this.action);
            }
        }
    

    tableOuterDivScrolled(event){
    
    }
    tableScrolled(event){
    
    }

    handleClick(event){
        ///this.isFirst=true;
      //  this.isLast=false;
      if(this.newSaveRecordCount != 0 || this.editRecordCount != 0){
        this.ConfirmationMessage = 'Please save record before performing any action';
        //this.OpenConfirmationBox = true;
        this.showWarningPopUp(this.ConfirmationMessage);
        this.isRecordOpenMode = true;
    }else{
      if(this.rowGroupingFieldList.length === 0  && this.TotalCount > 0){
        this.sorted = true;
        let fieldLabel = event.target.textContent;
        let fieldName;
        let direction;
        let isSorted ;
        let sortUp;
        let sortDown;
        fieldLabel = fieldLabel.includes('&amp;')?fieldLabel.replaceAll('&amp;', '&'):fieldLabel;
        Object.values(this.columns).forEach(record => {
   
           if(fieldLabel == record.label){ ///first asc sorting
               fieldName  = event.currentTarget.dataset.id;
               if(record.isSorted == false){
                   //record.sortUpClass  = "sortUpClassShow" ;
                   record.isSorted  = true;
                   record.sortUp = true;
                   record.sortDown =false;
                   direction = 'asc';
               }else if(record.isSorted == true && record.sortUp ==true ){//desc sorting
                   //record.sortUpClass  = "sortUpClassShow" ;
                   record.isSorted  = true;
                   record.sortUp = false;
                   record.sortDown =true;
                    direction = 'desc';
               }else{ //2n asc sorting
                   record.isSorted  = true;
                   record.sortUp = true;
                   record.sortDown =false;
                   direction = 'asc';
               }
               sortUp =  record.sortUp;
               isSorted =  record.isSorted;
               sortDown = record.sortDown;
               
               if(event.currentTarget.dataset.id== fieldName && isSorted== true  && fieldName!= 'Sr__No' && sortUp == true ){
                
                this.template.querySelectorAll('[data-id="' + fieldName + '"]')[1].classList.add('showArrow');
                this.template.querySelectorAll('[data-id="' + fieldName + '"]')[1].classList.remove('hideArrow');

                this.template.querySelectorAll('[data-id="' + fieldName + '"]')[2].classList.remove('showArrow');
                this.template.querySelectorAll('[data-id="' + fieldName + '"]')[2].classList.add('hideArrow');

   
                }else if(isSorted== true  && fieldName!= 'Sr__No' && sortDown == true && event.currentTarget.dataset.id== fieldName){
                    this.template.querySelectorAll('[data-id="' + fieldName + '"]')[2].classList.add('showArrow');
                    this.template.querySelectorAll('[data-id="' + fieldName + '"]')[2].classList.remove('hideArrow');
    
                    this.template.querySelectorAll('[data-id="' + fieldName + '"]')[1].classList.remove('showArrow');
                    this.template.querySelectorAll('[data-id="' + fieldName + '"]')[1].classList.add('hideArrow');
   
   
                }
   
            } 
            if(event.currentTarget.dataset.id !== record.fieldName){
               record.isSorted  = false;
               record.sortUp = false;
               record.sortDown =false;
              this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('hideArrow');
              this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('showArrow');

             this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.add('hideArrow');
             this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.remove('showArrow');
   
   
            } 
        });
        let fName = event.currentTarget.dataset.id;
        
           
               
        let sortBY = fieldName.toLowerCase();
        if(sortBY != undefined){
           
           //   for(let i=0; i< this.columns.length; i++){
               //   if(this.columns[i].fieldName === sortBY){
               //       if(this.columns[i].type ==='url'){
                     
               //           if(this.columns[i].typeAttributes != undefined){
                     
               //               this.sortBy = this.columns[i].typeAttributes.label != undefined ? this.columns[i].typeAttributes.label.fieldName!=undefined ? this.columns[i].typeAttributes.label.fieldName : this.columns[i].fieldName : this.columns[i].fieldName;
                                 
               //               if(this.SortDirectionUrlFieldList[this.columns[i].typeAttributes.label.fieldName] != undefined){
                             
               //                   if(this.SortDirectionUrlFieldList[this.columns[i].typeAttributes.label.fieldName] === 'asc'){
                                 
               //                       this.SortDirectionUrlFieldList[this.columns[i].typeAttributes.label.fieldName] = 'desc';
               //                       this.sortDirection = 'desc';
   
               //                   }else{
                                 
               //                       this.SortDirectionUrlFieldList[this.columns[i].typeAttributes.label.fieldName] = 'asc';
               //                       this.sortDirection = 'asc';
               //                   }
               //               }else{
                             
               //                   this.SortDirectionUrlFieldList[this.columns[i].typeAttributes.label.fieldName] = 'asc';
               //                   this.sortDirection = 'asc';
               //               }
               //           }
               //       }else{
                     
                         this.sortBy = fieldName.toLowerCase();
                         this.sortDirection = direction;
                   //   }
                // }
             
          //   }
         
         }
       
         if(this.sortBy != 'sr__no'){
             sortData(this.sortBy, this.sortDirection,'true',this);
         }
         let field=this.sortBy;
        // if(this.sortBy.includes('__r')){
        //    field = this.sortBy.replace('__r', '__c').split('.')[0]
        // }else{
        //    field = this.sortBy;
        // }
        if(this.level ==1 && field!='sr__no'){
           this.isResetMessage = true;
           setSessionData('sortfieldname',field,this);
           setSessionData('sortDirection',this.sortDirection,this);
           setSessionData('showResetMessage',true,this);
        }
        
   
        }
    }
   
       }
       
       handleMouseOver(event){  
   
           let fName = event.currentTarget.dataset.id;
           Object.values(this.columns).forEach(record => {
           
               if(event.currentTarget.dataset.id== record.fieldName && record.isSorted == false && event.currentTarget.dataset.id !== 'Sr__No'){
                record.sortUpClass  = "showArrow" ;
                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('showArrow');
                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('hideArrow');
                } 
            });
       }
       handleMouseLeave(event){
   
           let fName = event.currentTarget.dataset.id;
           Object.values(this.columns).forEach(record => {
           
               if(event.currentTarget.dataset.id== record.fieldName && record.isSorted == false && event.currentTarget.dataset.id !== 'Sr__No'){
                record.sortUpClass  = "showArrow" ;
                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('showArrow');
                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('hideArrow');

                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.add('hideArrow');
                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.remove('showArrow');
               } 
            });
       }
       handleOnselect(event) {
        if(this.newSaveRecordCount != 0 || this.editRecordCount != 0){
            this.ConfirmationMessage = 'Please save record before performing any action';
            //this.OpenConfirmationBox = true;
            this.showWarningPopUp(this.ConfirmationMessage);
            this.isRecordOpenMode = true;
        }else{
            let localStr = getSessionData(this);
            localStr= localStr != null &&  localStr != undefined ? JSON.parse(localStr) : {};
            let fieldName,direction;
            if(localStr != undefined && localStr != null){
                if(localStr.sortDirection != undefined && localStr.sortfieldname != undefined){
                    direction = localStr.sortDirection;
                    fieldName  = localStr.sortfieldname;
                    Object.values(this.columns).forEach(record => {
                
                        if(fieldName.toLowerCase() == record.fieldName.toLowerCase()){ 
                            if(direction.toLowerCase() == 'asc'){
                                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.contains('showArrow') == true ?    this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('showArrow'):'';
                                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('hideArrow');
                            }else{
                                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.remove('showArrow');
                                this.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.add('hideArrow');
                            }
                        }
                    });
            }
                 
            }
        handleListViewChange(event,this);
        }
        
    }

    // CloseModalURL(event){
        
    //     this.isModalUrl = false;
    // }

    OnModalUrlLoad(){
        
        this.isModalLoading = false;
    
    }

    onSearch(event) {
        
        this.searchkey=event.target.value.toUpperCase();
        let searchText = event.target.value;
        if (event.keyCode === 13) {
            this.isLoading = true;
         
          if(this.level ==1){
          setSessionData('quickSearchText',searchText,this);
          setSessionData('showResetMessage',true,this);
          setSessionData('pageNumber',1,this);
          
            this.isResetMessage = true;
           }
          QuickSearch(this,this.searchkey,true);
        }else if( this.searchkey === ''){
			this.isLoading = true;
            if(this.level ==1){
                setSessionData('quickSearchText',searchText,this);
                setSessionData('pageNumber',1,this);
             }
            QuickSearch(this,this.searchkey,true);
        }
          
          
       }

       handlePrevPage(){
        if(this.newSaveRecordCount != 0 || this.editRecordCount != 0){
            this.ConfirmationMessage = 'Please save record before performing any action';
            //this.OpenConfirmationBox = true;
            this.showWarningPopUp(this.ConfirmationMessage);
            this.isRecordOpenMode = true;
        }else{
        this.isLoading = true;
        this.callGetSelectedRows = true;
        if(this.currentPage>1){
            this.currentPage = this.currentPage-1
            if(this.currentPage === 1){
                this.isFirst=true;
            }

            if(this.currentPage < this.totalPages){
                this.isLast=false;
            }
            if(this.level ==1){
                this.isResetMessage = true;
            setSessionData('pageNumber',this.currentPage,this);
            setSessionData('showResetMessage',true,this);
            }
           handlePagination(this);
        }
    }
    }

    handleLast(){
        if(this.newSaveRecordCount != 0 || this.editRecordCount != 0){
            this.ConfirmationMessage = 'Please save record before performing any action';
            //this.OpenConfirmationBox = true;
            this.showWarningPopUp(this.ConfirmationMessage);
            this.isRecordOpenMode = true;
        }else{
            this.isLoading = true;
            this.callGetSelectedRows = true;
            this.currentPage = this.totalPages;
            this.isFirst=false;
            this.isLast=true;
            this.newSaveRecordCount =0;
            if(this.level ==1){
                this.isResetMessage = true;
            setSessionData('pageNumber',this.currentPage,this);
            setSessionData('showResetMessage',true,this);
            }
             handlePagination(this);
        }
    }

    handleFirst(){
        if(this.newSaveRecordCount != 0 || this.editRecordCount != 0){
            this.ConfirmationMessage = 'Please save record before performing any action';
            //this.OpenConfirmationBox = true;
            this.showWarningPopUp(this.ConfirmationMessage);
            this.isRecordOpenMode = true;
        }else{
            this.isLoading = true;
            this.callGetSelectedRows = true;
            this.currentPage = 1
            this.isFirst=true;
            this.isLast=false;
            this.newSaveRecordCount =0;
            if(this.level ==1){
                this.isResetMessage = true;
            setSessionData('pageNumber',this.currentPage,this);
            setSessionData('showResetMessage',true,this);
            }
            handlePagination(this);
        }
    }

    handleNextPage(){
        if(this.newSaveRecordCount != 0 || this.editRecordCount != 0){
            this.ConfirmationMessage = 'Please save record before performing any action';
            //this.OpenConfirmationBox = true;
            this.showWarningPopUp(this.ConfirmationMessage);
            this.isRecordOpenMode = true;
        }else{
        this.isLoading = true;
        this.callGetSelectedRows = true;
        this.newSaveRecordCount =0;
        if(this.currentPage < this.totalPages){
            this.currentPage = this.currentPage+1
            if(this.currentPage > 1){
                this.isFirst=false;
         }

            if(this.currentPage === this.totalPages){
                this.isLast=true;
             }
            
             if(this.level ==1){
                this.isResetMessage = true;
             setSessionData('pageNumber',this.currentPage,this);
             setSessionData('showResetMessage',true,this);
             }
            handlePagination(this);
          
        }
    }
    }

    onFilterClick(event){
        
        this.FilterClick = !this.FilterClick;
        this.isApply = true;
        if(this.FieldsOption != undefined && this.FieldsOption.length > 0){
            this.AdvancedFilterFieldApi =  this.FieldsOption.length > 0 ? this.FieldsOption[0].value : '';
            this.AdvancedFilterFieldLabel = getLabelForColumns(this,this.AdvancedFilterFieldApi);
            updateOnColumnChange(this);
        }
        if(this.OpratorOption != undefined && this.OpratorOption.length > 0){
            this.AdvanceFilterOperatorValue = this.OpratorOption != undefined ? this.OpratorOption[0].value : '';
            this.AdvanceFilterOperatorLabel = this.OpratorOption[0].label;
        }
        
        
    }

    onChangeColumn(event){
        this.AdvancedFilterFieldApi = event.detail;
        
        updateOnColumnChange(this);
    }

    OnChangeOperator(event){
        this.AdvanceFilterOperatorValue = event.detail != undefined ? event.detail : '';
        

        if(this.OpratorOption != undefined){
            for(let i=0; i < this.OpratorOption.length; i++){
                
                if(this.OpratorOption[i].value === event.detail){
                    this.AdvanceFilterOperatorLabel = this.OpratorOption[i].label;
                }
            }
        }

    }

    handleFilterValue(event){
        this.disableButton = false;
        if(this.FieldMetaData[this.AdvancedFilterFieldApi].Type === 'PICKLIST' || this.FieldMetaData[this.AdvancedFilterFieldApi].Type === 'MULTIPICKLIST' ){
            this.Advancedfiltervalue=event.detail;
        }else if(!(this.AdvancedFilterFieldApi.toLowerCase().includes('__r')) && this.FieldMetaData[this.AdvancedFilterFieldApi].Type === 'REFERENCE'){
            this.Advancedfiltervalue=event.detail.data.selectedRecordId;
           this.AdvancedfiltervalueforLookup = event.detail.data.selectedRecordName;
        }else if(event.target.type == 'checkbox' ){
            this.Advancedfiltervalue = event.target.checked == true ? true : false;
        }else{
            this.Advancedfiltervalue=event.target.value;
        }
        
        if(this.Advancedfiltervalue != null && this.Advancedfiltervalue != '' && this.Advancedfiltervalue != undefined){
            this.isApply = true;
            this.isClear = false;
        }
        else{
            //this.inputvalue=true;
        }
        if(this.Advancedfiltervalue == '' && this.FieldMetaData[this.AdvancedFilterFieldApi].Type !== 'BOOLEAN'){
            this.disableButton = true;
        }
    }

    OnApplyFilter(event){
        this.isApply = false;
        this.isClear = true;
        this.disableButton = true;
        getAdvancedfilterSeachkey(this);
        this.Advancedfiltervalue = '';
        this.filtervalue = '';
        //this.AdvanceFilterOperatorValue ='';
        let checkboxIpt =this.template.querySelector('[data-id="checkboxinput"]');
        
        if(checkboxIpt != null && checkboxIpt != undefined && checkboxIpt.type=='checkbox' && checkboxIpt.checked == true ){
            checkboxIpt.checked = false;
        }
    }

    onRemoveFilter(event){
    
        let filterId=event.detail.name;
        handleRemoveFilter(this,filterId);
    }

    onClearFilter(event){
    
        handleClearFilter(this);
    }
    renderedCallback(){
        if(this.callGetSelectedRows == true && this.listOfRows.length > 0 && this.isLoading == false){
            getSelectedRows(this);
          }
    }
    allSelected(event){
        let selectedRows = this.template.querySelectorAll('lightning-input');
        let keyofall;
        for(let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].type === 'checkbox' && event.target.checked == true ) {
                      selectedRows[i].checked = event.target.checked;
                      if(selectedRows[i].dataset.id != null && !this.listOfRows.includes(selectedRows[i].dataset.id))
                      {
                         this.listOfRows.push(selectedRows[i].dataset.id);
                      
                      }
            }else{
                       selectedRows[i].checked = event.target.checked;
                       if(selectedRows[i].dataset.id != null && this.listOfRows.includes(selectedRows[i].dataset.id))
                       {
                        let index = this.listOfRows.indexOf(selectedRows[i].dataset.id);
                        
                            //delete this.listOfRows[index];
                            this.listOfRows = this.listOfRows.filter(function (letter) {
                                return letter !== selectedRows[i].dataset.id;
                            });
                          
                       }
                       
            }
        }
        getSelectedRows(this);
       }
    rowSelected(event){
        this.selectedRows = [];
        this.isSelected = true;
        let row = event.currentTarget.value;
      let id= event.currentTarget.dataset.id;
        if(event.target.checked == true){
            this.listOfRows.push(event.currentTarget.dataset.id);
            getSelectedRows(this);
        }else{
        for (var i = 0; i < this.listOfRows.length; i += 1) {
            if(this.listOfRows[i] != undefined && this.listOfRows[i] == event.currentTarget.dataset.id ){
                const index = this.listOfRows.indexOf(event.currentTarget.dataset.id);
                if (index !== -1) {
                    this.listOfRows.splice(index, 1);
                }
        
            }
        }
        getSelectedRows(this);
        }
        
        
    }
    handleShowToolTip(){
        this.showToolTip = true;
       }
     
       handleToolTip(){
        this.showToolTip = false;
       }
	
	   handleShowToolTipFieldLevel(event){
        let fName = event.currentTarget.dataset.id;
        Object.values(this.columns).forEach(record => {
        
            if(event.currentTarget.dataset.id== record.fieldName){
                record.fieldLevelshowToolTip = true;
            }})
    }
     
       handleToolTipFieldLevel(event){
        let fName = event.currentTarget.dataset.id;
        Object.values(this.columns).forEach(record => {
        
            if(event.currentTarget.dataset.id== record.fieldName){
                record.fieldLevelshowToolTip = false;
            }})
       }
       get options() {

        return this.pageSizesMap;
     }

     handlepagesizechange(event){
        this.isFirst=true;
        this.isLast = false;
        this.pageSize=event.detail;
        this.PageSizeValue = this.pageSize
        this.newSaveRecordCount = 0;
         if(this.PageSizeValue === 'All'){

            this.pageSize = this.TotalCount;
            this.currentPage=1;
            handlePagination(this);
            this.EnablePagination =false;
            if(this.level ==1){
                setSessionData('pageSize',this.PageSizeValue,this);
                setSessionData('pageNumber',this.currentPage,this);
                }
        }else{
            this.currentPage=1;
             handlePagination(this);
             if(this.level ==1){
                setSessionData('pageSize',this.pageSize,this);
                setSessionData('pageNumber',this.currentPage,this); 
                }
               
        }
        if(this.level ==1){
            setSessionData('showResetMessage',true,this);
            this.isResetMessage = true;
        }
        this.isNeedToCheckVerticalScroll=true;
    }
    
	

    OnYes(event){
        
        if( this.isDelete === true){
            deleterow(this,this.action);
        }else if(this.isRecordOpenMode == true){
            //this.OpenConfirmationBox = false;
            
       }
        else if(this.isNew === true){
            addrow(this);
        }else if(this.selectedMenuAction == 'Download as CSV'){
            //this.OpenConfirmationBox = false;
            let d = new Date();
            let n = d.toLocaleDateString()+'__'+d.toLocaleTimeString();
            let listParm =this.listParameters != undefined ? this.listParameters :'';
            let mode = 'application/vnd.ms-excel';
            let namespace = this.nameSpace == null ? "" : this.nameSpace;
            if(this.initResult.GridType == 'FlexGrid'){
            let gridName=this.initResult.FlexGridMetaData.flexGridName;
            let id = this.initResult.ParentRecord != undefined && this.initResult.ParentRecord.Id != undefined ? this.initResult.ParentRecord.Id :  this.parentId;
            let exportPageURL = '';
            if(id === undefined){
             exportPageURL = '/apex/'+namespace+'FlexTableExport?mode='+
            mode+
            '&flexGridName='+
            gridName+
            '&flexGridType=FlexGrid'+
           '&listParm='+
            encodeURIComponent(JSON.stringify(listParm))+
            '&flexTableParam='+
            encodeURIComponent(JSON.stringify(this.stringParameters))+
            '&locale='+n;
            }else{
                exportPageURL = '/apex/'+namespace+'FlexTableExport?mode='+
                mode+
                '&flexGridName='+
                gridName+
                '&flexGridType=FlexGrid&id='+
                id+
                '&listParm='+
                encodeURIComponent(JSON.stringify(listParm))+
                '&flexTableParam='+
                encodeURIComponent(JSON.stringify(this.stringParameters))+
                '&locale='+n;
            }
            window.open(exportPageURL, "_blank");
            }else if(this.initResult.GridType == 'FlexTable'){
                let csvmode = 'application/vnd.ms-excel';
                window.open(encodeURI('/apex/'+namespace+'FlexTableExport?mode='+csvmode+'&flexTableName='+ this.flexTableConfig.Name+'&flexGridType=Data Table Enhanced&listParm='+JSON.stringify(listParm)+'&flexTableParam='+JSON.stringify(this.stringParameters)+'&locale='+n),"_blank");

            }
        }else{
        
            checkActionBehavior(this,this.action);
        
        }

    
       // event.preventDefault();
    }
    
    closeModal(){
        this.ErrorMessage = '';
        this.validity = true;
        //this.OpenConfirmationBox = false;
    }

    ShowSuccessMessage(SuccessMessage){
    
        this.SuccessMessage = SuccessMessage;
		this.isLoading = false;
        this.isErrorMessage = false;
        this.isSuccessMessage = true;
        if(this.messageTimeOutEnabled == true){
            setTimeout(() => {
              this.isSuccessMessage= false; 
              }, this.messageTimeOut);
          }
    }

    ShowErrorMessage(ErrorMessage){
        this.ErrorMessage = ErrorMessage;
        this.isSuccessMessage = false;
        this.isErrorMessage = true;
        this.isLoading = false;
        if(this.messageTimeOutEnabled == true){
            setTimeout(() => {
                  this.isErrorMessage = false; 
              }, this.messageTimeOut);
          }
    }

    ShowWarningMessage(WarningMessage){
        this.WarningMessage = WarningMessage;
        this.isWarningMessage = true;
        this.isLoading = false;
        this.warningMessages.push(this.WarningMessage);
        if(this.messageTimeOutEnabled == true){
            setTimeout(() => {
                this.isWarningMessage = false; 
                this.WarningMessage =[];
            }, this.messageTimeOut);
            }
    
    }

    onManualRefresh(event){
        getdata(this,true);
    }
    removeSessionData(){
        this.isRemoveSessioStorage = true;
        let sessionStr = localStorage.getItem(this.FlexTableId+this.Header) ;
        this.initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};

       for(var i=0; i < this.columns.length; i++){
           if(this.initSessionData.sortfieldname != undefined && this.columns[i].fieldName.toLowerCase == this.initSessionData.sortfieldname.toLowerCase()){
             this.columns[i].sortUpClass = '';
             this.columns[i].sortDownClassShow = '';
           }
         }
         this.initSessionData = {};
         localStorage.removeItem(this.FlexTableId+this.Header);
         const ids = Object.values(this.levelVsTableIdMap).map(value => value.split("'"));
         for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            const matches = ids.some((id) => key.startsWith(id));
             if (matches) {
               localStorage.removeItem(key);
            }
        }
         this.data =[];
         this.selectedListView = this.Header;
         this.Listviews = [];
         this.columns = [];
         this.searchText = '';
         this.subTotalEnabledColumn = [];
		 this.rowGroupingFieldList = [];
         const inputField = this.template.querySelector('[data-id="searchText"]');
         if(inputField != null){
            inputField.value = '';
         }
    
         this.currentPage = 1;
         this.pageSize=this.flexTableConfig.DefaultPageSizeEnhanced != undefined ? this.flexTableConfig.DefaultPageSizeEnhanced.toString() : this.TotalCount;
                   
         this.PageSizeValue = this.flexTableConfig.DefaultPageSizeEnhanced != undefined ? this.flexTableConfig.DefaultPageSizeEnhanced.toString() : this.TotalCount;
         this.isFirst=true;
         this.isLast=false;
         this.pageSizesMap = [];
         this.listOfRows = [];
         this.SortOrderMessageTitle='Records are sorted by ';
         this.SortOrderMessage= '';
         setVariable(this);
         this.selectedListView = '';
         
         
          const childCmp = this.template.querySelector('.combobox');//need to check
         const targetElement = childCmp != null ? childCmp.getTargetElement() : '';
     
     if (targetElement && targetElement != '' ) {
         targetElement.value = this.PageSizeValue;
         
     }
         this.isResetMessage = false;
         this.isResetSuccess = true;
        //this.ShowSuccessMessage('Table has been reset.');
        this.SuccessMessage = 'Table has been reset.';
        this.isLoading = false;
        this.isSuccessMessage = true;
        this.isSave = false;
        this.editRecordCount = 0;
        this.newSaveRecordCount =0;
        setTimeout(() => {
            this.isSuccessMessage= false;
            }, 3000);
     }
     handleOnMenuItem(event){
        let selectedMenuItem = event.detail.value.Name;
        this.selectedMenuAction = event.detail.value.Name;
        if(selectedMenuItem!= undefined && selectedMenuItem=='Refresh'){
            let sessionStr = getSessionData(this);
            this.initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};
            this.firstOnly = true;
            this.isSave = false;
            this.editRecordCount = 0;
            this.newSaveRecordCount
            if(this.gridLevel > 0){
                let data={};
                            data['isError'] = false;
                            data['isSave'] = false;
                            const showmessagesatparent =new CustomEvent('showmessage', {
                                detail: data,
                                bubbles: true,
                                composed: true,
                            });
                            this.dispatchEvent(showmessagesatparent);
            }
            getdata(this,true);

        }else if(selectedMenuItem!= undefined && selectedMenuItem=='Download as PDF'){
            let d = new Date();
            let n = d.toLocaleDateString()+'__'+d.toLocaleTimeString();
            let listParm =this.listParameters != undefined ? this.listParameters :'';
            let mode = 'pdf';
          
            let namespace = this.nameSpace == null ? "" : this.nameSpace;
            if(this.initResult.GridType == 'FlexGrid'){
            let gridName=this.initResult.FlexGridMetaData.flexGridName;
            let id = this.initResult.ParentRecord != undefined && this.initResult.ParentRecord.Id != undefined ? this.initResult.ParentRecord.Id :this.parentId;
            let exportPageURL ='';
            if(this.parentId === undefined){
                exportPageURL =  '/apex/'+namespace+'FlexTableExport?mode='+
                mode+
                '&flexGridName='+
                gridName+
                '&flexGridType=FlexGrid'+
                '&listParm='+
                encodeURIComponent(JSON.stringify(listParm))+
                '&flexTableParam='+
                encodeURIComponent(JSON.stringify(this.stringParameters))+
                '&locale='+n;
            }else{
                exportPageURL = '/apex/'+namespace+'FlexTableExport?mode='+
                mode+
                '&flexGridName='+
                gridName+
                '&flexGridType=FlexGrid&id='+
                id+
                '&listParm='+
                encodeURIComponent(JSON.stringify(listParm))+
                '&flexTableParam='+
                encodeURIComponent(JSON.stringify(this.stringParameters))+
                '&locale='+n;
            }
            window.open(exportPageURL, "_blank");
            }else if(this.initResult.GridType == 'FlexTable'){
                window.open(encodeURI('/apex/'+namespace+'FlexTableExport?mode='+mode+'&flexTableName='+this.flexTableConfig.Name+'&flexGridType=Data Table Enhanced&listParm='+JSON.stringify(listParm)+'&flexTableParam='+JSON.stringify(this.stringParameters)+'&locale='+n),"_blank");

            }
        }else if(selectedMenuItem!= undefined && selectedMenuItem=='Download as CSV'){
           this.ConfirmationMessage = "You may receive a message "+"'The file could be corrupted or unsafe'"+" while opening Excel file. Please ignore it and click 'Yes' to continue when prompted.";
           //this.OpenConfirmationBox = true;
           this.showWarningPopUp(this.ConfirmationMessage);
        }else{
            handleMenuActions(this,event.detail);
        }
     }

  clodeModalFlexlayout(event){
        
        

        if(event.detail.refreshBehaviour != undefined ){
            this.isModalFlexLayout = false;
            if(event.detail.refreshBehaviour ==='Close modal and refresh grid'){
                getdata(this,true);
                
            }else if(event.detail.refreshBehaviour ==='Close modal and refresh all flextables'){
                refreshLayout(this);
            }
        }else{
            
            if(event.detail.modalClose == false){
            
                if(this.action.RefreshBehaviour != undefined){
                    this.isModalFlexLayout = false;
                    checkRefreshBehavior(this,this.action);
                }else{
                    checkRefreshBehavior(this,this.action);
                }
            }else if(event.detail.modalClose == true){
            
                this.isModalFlexLayout = false;
                checkRefreshBehavior(this,this.action);
            }
           
            
        }
    }
    handleErrorMessageCloseClick(event) {
        this.isErrorMessage = false;
       
    }
    handleSuccessMessageCloseClick(event){
        this.isSuccessMessage = false;
    }
    handleWarningMessageCloseClick(event){
          const messageIndex = event.target.dataset.index;
          this.warningMessages = this.warningMessages.filter((_, index) => index !== parseInt(messageIndex));
          if(this.warningMessages.length == 0){
            this.isWarningMessage = false;
          }
    }

    async showWarningPopUp(message) {
        const result = await LightningConfirm.open({
            message: message,
            label: "Confirm",
            theme: "default",
        });
        if(result){
            this.OnYes();
        }else{
            this.closeModal()
        }
        //return result;
    }

    onloadTableWidth(){
        const tableTHElement = this.template.querySelectorAll('th')
        const widthMap ={};
        if(tableTHElement != undefined){
            tableTHElement.forEach(th=>{
                if(th.offsetWidth != undefined && th.offsetWidth > 250 && th.style.maxWidth == '250px'){
                    this.columnDefaultWidthChange = true;
                    widthMap[th.dataset.id] = th.offsetWidth - 12;
                }else{
                    widthMap[th.dataset.id] = th.offsetWidth- 12;
                }
            });
        }
        if(Object.keys(widthMap).length > 0){
            this.columns.forEach(col =>{
                if(col.label != undefined && widthMap[col.label] != undefined && col.label != '#'){
                    if(widthMap[col.label] > 250  && col.configWidth == false){
                        col.fixedWidth= 'width:'+widthMap[col.label]+'px;max-width:'+widthMap[col.label]+'px !important;min-width:50px;';
                    }else{
                        if(col.configWidth == false){
                            col.fixedWidth= 'width:'+'auto'+';max-width:'+250+'px !important;min-width:50px;';      
                        }else{
                            col.fixedWidth= col.fixedWidth+'max-width:'+parseInt(col.fixedWidth.split(':')[1])+'px;min-width:50px;';                    //col.fixedWidth= 'width:'+widthMap[col.label]+'px;max-width:'+250+'px !important';

                        }
                    }
                }
            })
        }
        const tableTagParentDivElement = this.template.querySelector('[data-id="tblViewInnerDiv"]');
        if(this.isDropdownColumn != true && tableTagParentDivElement!=undefined && tableTagParentDivElement.clientWidth== tableTagParentDivElement.scrollWidth){
            //this.columnDefaultWidthChange = true;
            tableTagParentDivElement.style.overflowX='hidden';
        }

        this.isLoading = false;
    }

    updateStyle(event) {
        const tableParentDivElement = this.template.querySelector('[data-id="tblViewInnerDiv"]');
        const tableTagElement = this.template.querySelector('[data-id="table"]');
        const tableCntDivElement = this.template.querySelector('[data-id="cnt-Div"]');
        var enableChild = false;
        if (tableParentDivElement != undefined) {
            var maxSupportedColumns = Math.round((tableParentDivElement.clientWidth - 450) / 60);
        }
        if (this.data && this.data.length>0) {
            let isChildEnabled = this.data.find((dataRcd) => dataRcd.EnableChild == true);
            if (isChildEnabled != undefined) {
                enableChild = true;
            }
        }
        if (this.isNeedToCheckVerticalScroll) {
            if (tableParentDivElement.clientHeight == tableTagElement.clientHeight) {
                this.isTableHasVerticalScroll = false;
            }
            else {
                this.isTableHasVerticalScroll = true;
            }
            this.isNeedToCheckVerticalScroll = false;
        }
        if (this.isTableHasVerticalScroll == false) {
            this.openDropDownAtTopSide=false;
            if (tableTagElement.style.width != '100%' && !this.isTableAlreadyLoaded) {
                this.isTableHasHorizontalScroll = true;
                this.isTableAlreadyLoaded = true;
            }
            if (!this.isTableHasHorizontalScroll) {
                if (event.detail.tablescroll == true) {
                    tableCntDivElement.classList.add("slds-table--header-fixed_container");
                    tableCntDivElement.classList.add("custom-fixed-container");
                    tableParentDivElement.style.overflow = 'auto';
                }
                else if (event.detail.tablescroll == false && enableChild == false) {
                    tableCntDivElement.classList.remove("slds-table--header-fixed_container");
                    tableCntDivElement.classList.remove("custom-fixed-container");
                    tableParentDivElement.style.overflow = 'visible';
                }
                else{
                    tableParentDivElement.scrollTop=tableParentDivElement.scrollHeight;
                }
            }
            else {
                this.columns.forEach(col => {
                    if (col.oriFixedWidth == undefined && col.FieldMetaData) {
                        if (col.FieldMetaData.Type == 'PICKLIST' && !col.fixedWidth) {
                            col.fixedWidth = 'width:170px;'
                        }
                        else if (col.FieldMetaData.Type == 'MULTIPICKLIST' && !col.fixedWidth) {
                            col.fixedWidth = 'width:190px;'
                        }
                        else if (col.FieldMetaData.Type == 'REFERENCE' && !col.fixedWidth) {
                            col.fixedWidth = 'width:190px;'
                        }
                        else if (col.FieldMetaData.Type == 'DATETIME' && !col.fixedWidth) {
                            col.fixedWidth = 'width:250px;'
                        }
                        col.oriFixedWidth = col.fixedWidth;
                    }
                    else if (col.label == '#' && col.fixedWidth) {
                        col.oriFixedWidth = col.fixedWidth;
                    }
                });
                if (event.detail.tablescroll == true) {
                    this.columns.forEach(col => {
                        if (col.oriFixedWidth != undefined) {
                            col.fixedWidth = col.oriFixedWidth;
                        }
                    });
                    tableCntDivElement.classList.add("slds-table--header-fixed_container");
                    tableCntDivElement.classList.add("custom-fixed-container");
                    tableParentDivElement.style.overflow = 'auto';
                }
                else if (event.detail.tablescroll == false && this.columns.length <= maxSupportedColumns && enableChild == false) {
                    this.columns.forEach(col => {
                        if(col.label && event.detail.label && col.label!=event.detail.label && col.label != '#'){
                            col.fixedWidth = 'width:60px!important;'
                        }
                        else {
                            col.fixedWidth = col.oriFixedWidth;
                        }
                    });
                    tableCntDivElement.classList.remove("slds-table--header-fixed_container");
                    tableCntDivElement.classList.remove("custom-fixed-container");
                    tableParentDivElement.style.overflow = 'visible';
                    tableTagElement.style.width = '100%';
                    tableParentDivElement.style.maxWidth = '100%';
                    tableParentDivElement.style.width = '100%';
                }
                else{
                    tableParentDivElement.scrollTop=tableParentDivElement.scrollHeight;
                }
            }
        }
        else if(this.isTableHasVerticalScroll){
            let findTblRcdIdx = this.data.findIndex((result) => result.id == event.detail.tblRecordId);
            let dataLength = this.data.length;
            let tblRecordIndex;
            if (findTblRcdIdx != -1) {          
                tblRecordIndex = findTblRcdIdx;
            } 
            if (dataLength < tblRecordIndex + 5) { //for last 4 records drop down will open at top side
                this.openDropDownAtTopSide = true;
            }
            else {
                this.openDropDownAtTopSide = false;
            } 
          
        }
    }
    
}