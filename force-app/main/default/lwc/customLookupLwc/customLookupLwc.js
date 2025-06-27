import { LightningElement, api, wire } from "lwc";
import fetchLookupData from "@salesforce/apex/CustomLookupLwcController.fetchLookupData";
import fetchDefaultRecord from "@salesforce/apex/CustomLookupLwcController.fetchDefaultRecord";
const DELAY = 100; // dealy apex callout timing in miliseconds  GovGrants
export default class CustomLookupLwc extends LightningElement {
    @api placeholder;
    @api sObjectApiName;
    @api lookupfieldName;
    @api fieldsName;
    @api recordId;
    @api availableRecordId;
    @api pageBlockDetailId;
    @api stringParameters;
    @api listParameters;
    @api filterClause;
    //
    @api sendValueVfToLwc; 
    @api dateFormatHolder;
    @api dateTimeFormatHolder;
    @api isAutoSuggest;
    showDropdown = false;
    @api record;
    @api column;
    @api isFieldDisabled ;
    //
    quicksearchdata = [];
    finalResultMap = [];
    hasRecords = true;
    isSelectedValue = false;
    fieldNameDisplay = [];
    isDataLoad = false;
    fieldTypeMap = [];
    scaleMap = [];
    resultMap = [];
    searchKey = ""; // to store input field value
    isSearchLoading = false; // to control loading spinner
    delayTimeout;
    selectedRecord = {}; // to store selected lookup record in object formate
    userTimeZone = 0;
    userLocale;
    timeZone;
    lookupDisiplayFieldName;
    outSideClickHandler;
    @api openDropDownAtTopSide;
    showDropdownContent=false;
    @api isFromModal;
    // initial function to populate default selected lookup record if defaultRecordId provided

    connectedCallback() {
        document.addEventListener('click', this.outSideClickHandler = this.close.bind(this));
        if (this.filterClause == "" || this.filterClause == undefined) {
            this.filterClause = "Id != null";
        }
        if(this._isJsonString(this.stringParameters)){
            this.stringParameters = JSON.parse(this.stringParameters);
        }
        if(this._isJsonString(this.listParameters)){
            this.listParameters = JSON.parse(this.listParameters);
        }
        this.showDropdown = false;
        //--------------------------------------------------------------------------------------------------------------------------------------------//
        if (typeof this.stringParameters === "string") {
            this.listParameters;
            let stringParameterscommaseperatedstring = this.stringParameters != undefined ? this.stringParameters.replace('"', "") : this.stringParameters; //False +ve for incomplete - sanitization - as we are not using this for sanitization
            stringParameterscommaseperatedstring =
                stringParameterscommaseperatedstring != undefined
                    ? stringParameterscommaseperatedstring.replace("}", "") //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    : stringParameterscommaseperatedstring;
            stringParameterscommaseperatedstring =
                stringParameterscommaseperatedstring != undefined
                    ? stringParameterscommaseperatedstring.replace("{", "") //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    : stringParameterscommaseperatedstring;
            let stringparamList =
                stringParameterscommaseperatedstring != undefined ? stringParameterscommaseperatedstring.split(",") : stringParameterscommaseperatedstring;
            let subStringForList = " ";
            let isStringContainsList = false;
            if (stringparamList != undefined && stringparamList.length > 0) {
                stringparamList.forEach((item) => {
                    if (!isStringContainsList && !item.includes("[")) {
                        subStringForList += "," + item;
                    } else if (!isStringContainsList && item.includes("[") && item.includes("]")) {
                        subStringForList += "," + item;
                        isStringContainsList = false;
                    } else if (!isStringContainsList && item.includes("[")) {
                        subStringForList += "," + item;
                        isStringContainsList = true;
                    } else if (isStringContainsList && !item.includes("]")) {
                        subStringForList += "/" + item;
                    } else {
                        if (!isStringContainsList) {
                            subStringForList += "," + item;
                        } else {
                            subStringForList += "/" + item;
                            isStringContainsList = false;
                        }
                    }
                });
            }
            
            let srtingparameterMap = {};
            stringparamList = subStringForList.split(",").slice(1);
            if (stringparamList != undefined && stringparamList.length > 0) {
                stringparamList.forEach((key) => {
                    let keyValueList = key.split(":");
                    if (keyValueList[1] != undefined && (keyValueList[1].includes("/") || keyValueList[1].includes("["))) {
                        keyValueList[1] = keyValueList[1].replaceAll("/", ",");
                        keyValueList[1] = keyValueList[1].replace(/'/g, "");
                        keyValueList[1] = keyValueList[1].replace("[", ""); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                        keyValueList[1] = keyValueList[1].replace("]", ""); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                        srtingparameterMap[keyValueList[0]] = keyValueList[1] != undefined ? keyValueList[1].split(",") : keyValueList[1];
                    } else {
                        srtingparameterMap[keyValueList[0]] = keyValueList[1];
                    }
                });
            }
            this.stringParameters = srtingparameterMap;
        }
        //--------------------------------------------------------------------------------------------------------------------------------------------------//
        if (typeof this.listParameters === "string") {
            let stringParameterscommaseperatedstring1 = this.listParameters != undefined ? this.listParameters.replace('"', "") : this.listParameters; //False +ve for incomplete - sanitization - as we are not using this for sanitization
            stringParameterscommaseperatedstring1 =
                stringParameterscommaseperatedstring1 != undefined
                    ? stringParameterscommaseperatedstring1.replace("}", "") //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    : stringParameterscommaseperatedstring1;
            stringParameterscommaseperatedstring1 =
                stringParameterscommaseperatedstring1 != undefined
                    ? stringParameterscommaseperatedstring1.replace("{", "") //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    : stringParameterscommaseperatedstring1;

            let listParametersList =
                stringParameterscommaseperatedstring1 != undefined ? stringParameterscommaseperatedstring1.split("],") : stringParameterscommaseperatedstring1;
            let listParametersListMap = {};
            if (listParametersList != undefined && listParametersList.length > 0) {
                listParametersList.forEach((key) => {
                    let keyValueList = key.split(":");
                    keyValueList[1] = keyValueList[1].replace("[", ""); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    keyValueList[1] = keyValueList[1].replace("]", ""); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    let valueList = keyValueList[1] != undefined ? keyValueList[1].split(",") : keyValueList[1];
                    listParametersListMap[keyValueList[0]] = valueList;
                });
            }
            this.listParameters = listParametersListMap;
        }
        //--------------------------------------------------------------------------------------------------------------------------//
        this.filterClause = this.filterClause.replaceAll(":", "=");
        this.filterClause = this._replaceAllMergeFields(this.filterClause);

        //----------------------------------------------------------------------------------------------------------------------------//
        if (this.availableRecordId != undefined) {
            fetchDefaultRecord({
                sObjectApiName: this.sObjectApiName,
                lookupfieldName: this.lookupfieldName,
                availableRecordId: this.availableRecordId

            }).then((result) => {
                    if (result != null) {
                        this.isSelectedValue = true;
                        this.selectedRecord = result;
                        this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
                    }
                }).catch((error) => {
                    this.error = error;
                    this.selectedRecord = {};
                });
        }
    }

    //------------------------------------------END Connected Call Back---------------------------------------------------------------------------------------//
    fetchData() {
        fetchLookupData({
            searchKey: this.searchKey,
            sObjectApiName: this.sObjectApiName,
            fieldsName: this.fieldsName,
            lookupfieldName: this.lookupfieldName,
            filterClause: this.filterClause,
            pageBlockDetailId: this.pageBlockDetailId

        }).then((result) => {
                this.isSearchLoading = false;
                if (result) {
                    this.hasRecords = result.sObjectList.length == 0 ? false : true;
                    this.userLocale = result.userLocale;
                    this.timeZone = result.timeZone;
                    if (!this.isDataLoad) {
                        for (let key in result.fieldLableMap) {
                            this.fieldNameDisplay.push({ value: result.fieldLableMap[key], key: key });
                        }
                        for (let key in result.fieldDataTypeMap) {
                            this.fieldTypeMap.push({ value: result.fieldDataTypeMap[key], key: key });
                        }
                        for (let key in result.scaleMap) {
                            this.scaleMap.push({ value: result.scaleMap[key], key: key });
                        }
                    }
                    
                    this.isDataLoad = true;
                    this.quicksearchdata = this.getDataRecords(result.sObjectList);

                    if (this.quicksearchdata) {
                        for (let recordNo = 0; recordNo < this.quicksearchdata.length; recordNo++) {
                            let singleRecord = this.quicksearchdata[recordNo];
                            let singleRecordArray = [];
                            for (let fieldNameIndex = 0; fieldNameIndex < this.fieldNameDisplay.length; fieldNameIndex++) {
                                let fieldNameInList = this.fieldNameDisplay[fieldNameIndex].key;
                                if (JSON.stringify(singleRecord[fieldNameInList]) == undefined) {
                                    singleRecordArray.push({ value: null, key: fieldNameInList });
                                } else {
                                    let type = this.fieldTypeMap[fieldNameIndex].value;
                                    let scale = this.scaleMap[fieldNameIndex].value;
                                    if (type == "CURRENCY") {
                                        let result = this._noFractionCurrency(singleRecord[fieldNameInList], scale, "$", true, type);
                                        singleRecordArray.push({ value: result, key: fieldNameInList });
                                    } else if (type == "PERCENT" || type == "DOUBLE" || type == "INTEGER") {
                                        let result = this._noFractionCurrency(singleRecord[fieldNameInList], scale, "$", true, type);
                                        singleRecordArray.push({ value: result, key: fieldNameInList });
                                    } else if (type == "DATETIME") {
                                        const d = new Date(singleRecord[fieldNameInList]);
                                        let date = this._formatLocalDate(d);
                                        singleRecordArray.push({ value: date, key: fieldNameInList });
                                    } else if (type == "DATE") {
                                        const d = new Date(singleRecord[fieldNameInList]);
                                        let date = this._formatLocalDt(d);
                                        singleRecordArray.push({ value: date, key: fieldNameInList });
                                    } else {
                                        if (type == "STRING"){
                                            let removedHtmlTag = singleRecord[fieldNameInList].replace(/<[^>]*>/g, '') //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                                            singleRecordArray.push({ value: removedHtmlTag, key: fieldNameInList });
                                        }else{
                                            singleRecordArray.push({ value: singleRecord[fieldNameInList], key: fieldNameInList });
                                        }
                                    }
                                }
                            }
                            this.resultMap.push({ value: singleRecordArray, key: singleRecord["id"] });
                        }
                    }
                    
                    this.finalResultMap =this.resultMap;
                    this.resultMap = [];
                    this.showDropdownContent = this.finalResultMap.length > 0 ? true : false;
                }
            })
            .catch((error) => {
            });
    }
    //------------------------------------------END fetchData Method---------------------------------------------------------------------------------------//

    handleKeyChange(event) {
        this.isSearchLoading = true;
        const searchKey = event.target.value;
        this.searchKey = searchKey;
        this.showDropdown = false;
        this.fetchData();
        this.OpenTable(event);
    }
    //--------------------------------------------------------------------------------------------------------------------------//

    toggleResult1(event) {
        this.isSearchLoading = true;
        this.fetchData();
        this.OpenTable(event);
        this.handleMouseIn();
    }
    //--------------------------------------------------------------------------------------------------------------------------//
    OpenTable(event) {
        //const lookupInputContainer = this.template.querySelector(".lookupInputContainer");
        // const lookupInputContainer1 = this.template.querySelector(".lookupInputContainer").getBoundingClientRect().bottom;
        // const lookupInputField = this.template.querySelector(".dropdown-auto1");
        // const h = window.innerHeight - lookupInputContainer1;
        // if (h < 200) {
        //     if (lookupInputField) {
        //         lookupInputField.classList.remove("dropdown-top");
        //         lookupInputField.classList.add("dropdown-bottom");
        //     }
        // } else {
        //     if (lookupInputField) {
        //         lookupInputField.classList.remove("dropdown-bottom");
        //         lookupInputField.classList.add("dropdown-top");
        //     }
        // }
       // const clsList = lookupInputContainer.classList;

       const lookupDropDownDivElement = this.template.querySelector('[data-id="lookup-dropdown"]');
       if (lookupDropDownDivElement) {
           if (this.openDropDownAtTopSide) {
               lookupDropDownDivElement.style.bottom='100%';
               lookupDropDownDivElement.style.top='auto';
           }
           else {
               lookupDropDownDivElement.style.top='100%';
               lookupDropDownDivElement.style.bottom='auto';
           }       
       }

        if (event != undefined && event.target!=undefined) {
            const whichEvent = event.target.getAttribute("data-source");
            if (whichEvent) {
            switch (whichEvent) {
                case "searchInputField":
                   // clsList.add("slds-is-open");
                    this.showDropdown = true;
                    break;
                case "lookupContainer":
                  //  clsList.remove("slds-is-open");
                    this.showDropdown = false;
                    break;
            }
        }
        }

      
    }
    handleBlur() {
        this.showDropdown = false;
        this.handleMouseOut();
    }
    disconnectedCallback() {
        document.removeEventListener('click', this.outSideClickHandler);
    }
    handleParentDivClick(event) {
        event.stopPropagation();
        return false;
    }
    close() {
        this.showDropdown = false;
        this.handleMouseOut();
    }
    handleMouseOut(event) {
        // const lookupInputContainer = this.template.querySelector(".lookupInputContainer");
        // const clsList = lookupInputContainer.classList;
        // const whichEvent = event.target.getAttribute("data-source");
        // switch (whichEvent) {
        //     case "searchInputField":
        //         clsList.add("slds-is-open");
        //         break;
        //     case "lookupContainer":
        //         clsList.remove("slds-is-open");
        //         break;
        // }
       // this.OpenTable(event);
        if (this.showDropdown == false && this.record && this.column) {
            this.dispatchEvent(new CustomEvent('updatestyle', {
                bubbles: true,
                detail: {
                    tablescroll: true,
                    tblRecordId:this.record.id,
                    label:this.column.label
                }
            }));
        }
    }
    handleMouseIn(event) {
        const sldsCombobox1 = this.template.querySelector(".dropdown-auto1");
        if (sldsCombobox1) {
        sldsCombobox1.classList.add("slds-show");
        sldsCombobox1.classList.remove("slds-hide");
        }
        
        this.OpenTable(event);
        this.showDropdown = true;
        if (this.record && this.column) {
            this.dispatchEvent(new CustomEvent('updatestyle', {
                bubbles: true, composed: true,
                detail: {
                    tablescroll: false,
                    tblRecordId: this.record.id,
                    label: this.column.label
                }
            }));
    }
    }

    handleMouseEnter(){
        this.showDropdownContent=false;
    }
    //--------------------------------------------------------------------------------------------------------------------------//

    handleRemove(event) {
        this.searchKey = "";
        this.selectedRecord = {};
        const searchBoxWrapper = this.template.querySelector(".searchBoxWrapper");
        searchBoxWrapper.classList.remove("slds-hide");
        searchBoxWrapper.classList.add("slds-show");
        const pillDiv = this.template.querySelector(".pillDiv");
        pillDiv.classList.remove("slds-show");
        pillDiv.classList.add("slds-hide");
        const selectedRecordSendToVf = {
            selectedRecordId: "",
            selectedRecordApiName: this.lookupfieldName
        };
        this.dispatchEvent(
            new CustomEvent("selectedrecord", {
                detail: { data: selectedRecordSendToVf },
                bubbles: false,
                composed: false
            })
        );
        event.preventDefault();
        this.handleMouseIn();
    }

    //--------------------------------------------------------------------------------------------------------------------------//

    handelSelectedRecord(event) {
        this.isSelectedValue = false;
        let objId = event.target.getAttribute("data-recid");
        this.selectedRecord = this.quicksearchdata.find((data) => data.id === objId);
        this.handelSelectRecordHelper(); 
        const selectedRecordSendToVf = {
            selectedRecordId: objId,
            selectedRecordName : this.selectedRecord.name,
            selectedRecordApiName: this.lookupfieldName
        };
        this.dispatchEvent(
            new CustomEvent("selectedrecord", {
                detail: { data: selectedRecordSendToVf },
                bubbles: false,
                composed: false
            })
        );

        this.lookupDisiplayFieldName = "loading....";
        this.delayTimeout = setTimeout(() => {
            this.lookupDisiplayFieldName = this.selectedRecord.name;
            this.showDropdown = false;
            const lookupTable = this.template.querySelector('[data-id="lookup-dropdown"]');
            lookupTable.classList.add("slds-hide"); 
        }, 1000);
    }
    //--------------------------------------------------------------------------------------------------------------------------//

    handleonkeyup(event){
        if (event.keyCode === 13) {
            this.handelSelectedRecord(event);
        }
             }
    //--------------------------------------------------------------------------------------------------------------------------//

    handelSelectRecordHelper() {
        this.template.querySelector(".lookupInputContainer").classList.remove("slds-is-open");
        const searchBoxWrapper = this.template.querySelector(".searchBoxWrapper");
        searchBoxWrapper.classList.remove("slds-show");
        searchBoxWrapper.classList.add("slds-hide");
        const pillDiv = this.template.querySelector(".pillDiv");
        pillDiv.classList.remove("slds-hide");
        pillDiv.classList.add("slds-show");
        this.showDropdown = false;
    }

    //--------------------------------------------------------------------------------------------------------------------------//

    lookupUpdatehandler(value) {
        const oEvent = new CustomEvent("lookupupdate", {
            detail: { selectedRecord: value }
        });
        this.dispatchEvent(oEvent);
    }
    //--------------------------------------------------------------------------------------------------------------------------//
    
    // Data Formating Method
    getDataRecords(data) {
        let contactsArray = [];
        for (let row of data) {
            const flattenedRow = {};
            let rowkeys = Object.keys(row);
            rowkeys.forEach((rowkey) => {
                const singleNodeValue = row[rowkey];
                if (singleNodeValue.constructor === Object) {
                    let rowkeysecond = Object.keys(singleNodeValue);
                    rowkeysecond.forEach((rowkeySecond) => {
                        const secondLevelNode = singleNodeValue[rowkeySecond];
                        if (secondLevelNode.constructor === Object) {
                            let rowkeythird = Object.keys(secondLevelNode);
                            rowkeythird.forEach((rowkeyThird) => {
                                const thirdlevelNode = secondLevelNode[rowkeyThird];
                                if (thirdlevelNode.constructor === Object) {
                                    let rowkeyfourth = Object.keys(thirdlevelNode);
                                    rowkeyfourth.forEach((rowkeyFouth) => {
                                        const fourthlevelNode = thirdlevelNode[rowkeyFouth];
                                        if (fourthlevelNode.constructor === Object) {
                                            let rowkeyfifth = Object.keys(fourthlevelNode);
                                            rowkeyfifth.forEach((rowkeyFifth) => {
                                                const fifthlevelNode = fourthlevelNode[rowkeyFifth];
                                                if (fifthlevelNode.constructor === Object) {
                                                    this._flattenLevelFifth(
                                                        fourthlevelNode,
                                                        flattenedRow,
                                                        rowkey,
                                                        rowkeySecond,
                                                        rowkeyThird,
                                                        rowkeyFouth,
                                                        rowkeyFifth
                                                    );
                                                }
                                            });
                                            this._flattenLevelFourth(fourthlevelNode, flattenedRow, rowkey, rowkeySecond, rowkeyThird, rowkeyFouth);
                                        }
                                    });
                                    this._flattenLevelThree(thirdlevelNode, flattenedRow, rowkey, rowkeySecond, rowkeyThird);
                                }
                            });
                            this._flattenLevelTwo(secondLevelNode, flattenedRow, rowkey, rowkeySecond);
                        }
                    });
                    this._flatten(singleNodeValue, flattenedRow, rowkey);
                } else {
                    flattenedRow[rowkey.toLowerCase()] = singleNodeValue;
                }
            });
            contactsArray.push(flattenedRow);
        }
        return contactsArray;
    }

    //--------------------------------------- END Data Formating Method--------------------------------------------------------------------//

    _flatten = (nodeValue, flattenedRow, nodeName) => {
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + "." + key;
            flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
        });
    };
    //---------------------------------------------------------------------------------------------------------//
    _flattenLevelTwo = (nodeValue, flattenedRow, nodeName, nodekeysecond) => {
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + "." + nodekeysecond + "." + key;
            flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
        });
    };
    //---------------------------------------------------------------------------------------------------------//
    _flattenLevelThree = (nodeValue, flattenedRow, nodeName, nodekeysecond, nodekeythird) => {
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + "." + nodekeysecond + "." + nodekeythird + "." + key;
            flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
        });
    };
    //---------------------------------------------------------------------------------------------------------//
    _flattenLevelFourth = (nodeValue, flattenedRow, nodeName, nodekeysecond, nodekeythird, nodekeyfourth) => {
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + "." + nodekeysecond + "." + nodekeythird + "." + nodekeyfourth + "." + key;
            flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
        });
    };
    //---------------------------------------------------------------------------------------------------------//
    _flattenLevelFifth = (nodeValue, flattenedRow, nodeName, nodekeysecond, nodekeythird, nodekeyfourth, nodekeyfifth) => {
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + "." + nodekeysecond + "." + nodekeythird + "." + nodekeyfourth + "." + nodekeyfifth + "." + key;
            flattenedRow[finalKey.toLowerCase()] = nodeValue[key];
        });
    };
    //---------------------------------------------------------------------------------------------------------//
    _noFractionCurrency(amount, scale, currencySymbol, isField, fieldType) {
        if (amount == undefined || isNaN(amount)) {
            return "";
        }
        if (parseFloat(amount) == 0) {
            amount = 0.0;
        }
        let isPercent = false;
        let amountStringValue = amount.toString();
        let decimalRegex = /(\d{0,})(\.(\d{1,})?)?/g;
        let decimalPartMatches = decimalRegex.exec(amountStringValue);
        if (fieldType == "PERCENT") {
            isPercent = true;
        }
        amount = parseFloat(amount).toFixed(scale);
        let tempAmountFormat = amount;
        let currLocaleSymbol;
        if (currLocaleSymbol == undefined) {
            currLocaleSymbol = currencySymbol;
        }

        if (fieldType != "DOUBLE") {
            tempAmountFormat = currLocaleSymbol + tempAmountFormat;
        }

        if (isField && scale == 2) {
            tempAmountFormat = amount;
        }

        if (fieldType == "DOUBLE") {
            tempAmountFormat = tempAmountFormat.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
        }

        if (fieldType == "CURRENCY") {
            tempAmountFormat = amount;
            if (tempAmountFormat.toString().indexOf(currLocaleSymbol) == currLocaleSymbol) {
                tempAmountFormat = tempAmountFormat.replace(currLocaleSymbol, "");
            }
            tempAmountFormat = currLocaleSymbol + tempAmountFormat.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        if (isPercent) {
            if (amountStringValue.includes(".")) {
                let lpart = amountStringValue.substring(0, amountStringValue.indexOf("."));
                let rpart = amountStringValue.substring(amountStringValue.indexOf("."), amountStringValue.length);
                tempAmountFormat = lpart + rpart.substring(0, scale + 1);
            } else {
                tempAmountFormat = amountStringValue;
            }

            if (!tempAmountFormat.includes("%")) {
                tempAmountFormat = tempAmountFormat + "%";
            }
        }

        if (tempAmountFormat.includes("-")) {
            tempAmountFormat = tempAmountFormat.replace("-", "");
            tempAmountFormat = "(" + tempAmountFormat + ")";
        }
        return tempAmountFormat.toString();
    }

    //---------------------------------------------------------------------------------------------------------//
    _formatLocalDt(dateObj) {
        this.userLocale = this.userLocale.replace("_", "-");
        const str = dateObj.toLocaleDateString(this.userLocale, { timeZone: this.timeZone });
        return str;
    }
    //---------------------------------------------------------------------------------------------------------//
    _formatLocalDate(dateObj) {
        this.userLocale = this.userLocale.replace("_", "-");
        const str = dateObj.toLocaleString(this.userLocale, { timeZone: this.timeZone });
        return str;
    }
    //---------------------------------------------------------------------------------------------------------//
    _replaceStringParamters(stringParameters, filterString) {
        if (stringParameters != undefined && stringParameters != "" && filterString != null) {
            Object.keys(stringParameters).forEach((key) => {
                let value = stringParameters[key];
                if (typeof filterString === "string" && filterString.indexOf("{!" + key + "}") != -1) {
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
    //---------------------------------------------------------------------------------------------------------//
    _replaceListParamters(listParameters, filterString) {

        if (listParameters != undefined && listParameters != "" && filterString != null) {
            Object.keys(listParameters).forEach((key) => {
                let value = listParameters[key];
                if (typeof filterString === "string" && filterString.indexOf("{!" + key + "}") != -1) {
                    if (typeof value === "object" && filterString.includes("'{!")) {
                        filterString = filterString.replaceAll("'{!" + key + "}'", "('" + value.join("','") + "')");
                    } else {
                        filterString = filterString.replaceAll("{!" + key + "}", "('" + value.join("','") + "')");
                    }
                }
            });
        }
        return filterString;
    }
    //---------------------------------------------------------------------------------------------------------//

    _replaceAllMergeFields(filterString) {
        filterString = this._replaceStringParamters(this.stringParameters, filterString);
        filterString = this._replaceListParamters(this.listParameters, filterString);
        return filterString;
    }

    _isJsonString(str) {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
    }
}