import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { subscribe, unsubscribe, APPLICATION_SCOPE, publish, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import getPageBlockDetails from "@salesforce/apex/FlexLayoutController.getPageBlockDetails";
import validateURLFormat from "@salesforce/apex/AppUtils.validateURLFormat";
import geticons from "@salesforce/apex/AppUtils.getIcons";
import isGuestUser from "@salesforce/user/isGuest";

export default class PageBlockSection extends LightningElement {
    @api
    pageLayoutWrapper;
    @api
    tabId;
    @api
    isView;
    @api
    showPageBlockTitle;
    @wire(MessageContext)
    messageContext;
    pageBlockConfigString;
    collapsedicon = "utility:up";
    isCollapsed = false;
    @track
    pageBlocks;
    pageBlockInHeader = false;
    showSpinner = false;
    showConfigError = false;
    errorOnSave = false;
    errorMessageList = [];
	systemInformationFields = ["CreatedById", "CreatedDate", "LastModifiedById", "LastModifiedDate"];

    govGrantPleaseWaitIcon = "";
    @api isFromModal;
    @api openDropDownAtTopSide;
    @api isHeaderOverview;
    get isHeader(){
        return this.isHeaderOverview === "true" ? true : false;
    }
    currentlyProcessedForms = 0;
    totalFormCount = 0;
    showPhoneField = true;
    isSavePressed = false;
    recordTypeId;
    isGuest = isGuestUser;
    skipValidationForFields = new Set();
    get mode() {
        if (this.isView == true) {
            return "view";
        } else {
            return "edit";
        }
    }

    get recordEditFormId(){
       
        return this.isGuest ? null : this.pageLayoutWrapper?.recordId;
    }

    connectedCallback() {
       

        if (typeof this.isView !== "boolean") {
            this.isView = this.isView === "true";
        }

        if (!this.showPageBlockTitle) {
            this.pageBlockInHeader = true;
        }

        if (!this.pageBlockInHeader) {
            this.showSpinner = true;
        }

        this.fetchPageBlockData(true);
        this.subscribeToMessageChannel();

        geticons({ strResourceName: "govGrantPleaseWaitIcon" })
            .then((result) => {
                if (result) {
                    this.govGrantPleaseWaitIcon = result;
                }
            })
            .catch((error) => {
            });

        this.dispatchEvent(new CustomEvent("tab_loaded", { detail: { Id: this.tabId } }));
        const payload = {
            source: "LWC-from Page Block Section",
            data: {
                isModalShowSpinner : false,
                pageLayoutId : this.pageLayoutWrapper.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
    }

    fetchPageBlockData(isFirstCall = false) {
        getPageBlockDetails({
            tabId: this.tabId,
            recId: this.pageLayoutWrapper.recordId,
            objectName: this.pageLayoutWrapper.objectName,
            isViewContext: this.isView,
            pageBlockConfigString: this.pageBlockConfigString,
            isFirstCall: isFirstCall
        })
            .then((data) => {
                let dataObject = JSON.parse(data[0]);
                if (dataObject.isError) {
                    console.error(dataObject.errorMessage);
                    this.showConfigError = true;
                } else {
                    this.pageBlocks = JSON.parse(data[0]);
                    this.pageBlockConfigString = data[1];
                    this.totalFormCount = 0;
					let fieldsWithDefaultValue = [];

                    this.pageLayoutWrapper?.defaultValueMap?.forEach((ele) => {

                        if(ele.fieldAPIName === 'RecordTypeId'){
                            this.recordTypeId = ele.defaultValue;
                        }
                        fieldsWithDefaultValue.push(ele.fieldAPIName);
                    });

                    if(this.pageLayoutWrapper.inputdata != undefined){
                        if(Object.keys(this.pageLayoutWrapper.inputdata).length >0){
                            
                            for(let i=0; i < Object.values(this.pageLayoutWrapper.inputdata).length; i++){
                                                    
                                fieldsWithDefaultValue.push(Object.values(this.pageLayoutWrapper.inputdata)[i]);
                            }    
                        }
                    }
                        
                    
                    for (const element in this.pageBlocks) {
                        if (this.pageBlocks[element].isFields) {
                            this.totalFormCount++;
                            for (const field in this.pageBlocks[element].fieldConfigs) {
								if (
                                    fieldsWithDefaultValue.length > 0 &&
                                    fieldsWithDefaultValue.includes(this.pageBlocks[element].fieldConfigs[field].fieldAPIName) &&
                                    this.pageBlocks[element].fieldConfigs[field].readOnly
                                ) {
                                    this.pageBlocks[element].fieldConfigs[field].readOnly = false;
                                    this.pageBlocks[element].fieldConfigs[field].isDisabled = true;
                                    if(this.pageLayoutWrapper?.recordId != undefined && this.pageBlocks[element].fieldConfigs[field].isLookUpField == true ){
                                        this.pageBlocks[element].fieldConfigs[field].readOnly = true;
                                    }else{
                                        if(this.pageBlocks[element].fieldConfigs[field].isLookUpField == true ){
                                            this.pageBlocks[element].fieldConfigs[field].isLookUpField = false;
                                        }
                                    }
                                }

                                //for rich text-calculating char and word count

                                if(this.pageBlocks[element].fieldConfigs[field].isLookUpField == true){
                                    if(this.pageLayoutWrapper.defaultValueMap != undefined && Object.keys(this.pageLayoutWrapper.defaultValueMap).length > 0){
                                        
                                        for(let i=0; i < Object.values(this.pageLayoutWrapper.defaultValueMap).length; i++){
                                                
                                            let key = Object.values(this.pageLayoutWrapper.defaultValueMap)[i];
                                                if(key.defaultValue != undefined){
                                                    if(this.pageBlocks[element].fieldConfigs[field].fieldAPIName == key.fieldAPIName){
                                                    this.pageBlocks[element].fieldConfigs[field].fieldValue = key.defaultValue
                                                    }
                                                }
                                        }    
                                                        
                                    }
                                    if(this.pageLayoutWrapper.inputdata != undefined && Object.keys(this.pageLayoutWrapper.inputdata).length > 0){
                            
                                        for(let i=0; i < Object.keys(this.pageLayoutWrapper.inputdata).length; i++){
                                                            
                                            let key = Object.keys(this.pageLayoutWrapper.inputdata)[i];
                                            if(this.pageLayoutWrapper.inputdata[key] != undefined){
                                                if(this.pageBlocks[element].fieldConfigs[field].fieldAPIName == key){
                                                    this.pageBlocks[element].fieldConfigs[field].fieldValue = this.pageLayoutWrapper.inputdata[key];
                                                }        
                                            }
                                        }
                                    }
                                }

                                if(this.pageBlocks[element].fieldConfigs[field].IsUpdateable == false && this.pageBlocks[element].fieldConfigs[field].isLookUpField == true){
                                    
                                    this.pageBlocks[element].fieldConfigs[field].readOnly = false;
                                    this.pageBlocks[element].fieldConfigs[field].isDisabled = true;
                                    this.pageBlocks[element].fieldConfigs[field].isLookUpField = false;
                                }

                                if (this.pageBlocks[element].fieldConfigs[field].isRichTextFieldType == true) {
                                    this.pageBlocks[element].fieldConfigs[field].render = true;
                                    const fieldValue = this.pageBlocks[element].fieldConfigs[field].fieldValue;

                                    if (this.pageLayoutWrapper.showCharLimit) {
                                        fieldValue
                                            ? (this.pageBlocks[element].fieldConfigs[field].charLength = fieldValue.replace(/<(.|\n)*?>/g, "").length) //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                                            : (this.pageBlocks[element].fieldConfigs[field].charLength = 0);
                                        this.pageBlocks[element].fieldConfigs[field].charactersLeft =
                                            this.pageLayoutWrapper.allowedCharsForRichTextArea - this.pageBlocks[element].fieldConfigs[field].charLength;
                                    }
                                    

                                    if (this.pageLayoutWrapper.showWordLimit) {
                                        fieldValue
                                            ? (this.pageBlocks[element].fieldConfigs[field].wordLength = fieldValue
                                                  .replace(/<(.|\n)*?>/g, "") //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                                                  .split(" ").length)
                                            : (this.pageBlocks[element].fieldConfigs[field].wordLength = 0);
                                        this.pageBlocks[element].fieldConfigs[field].wordsLeft =
                                            this.pageLayoutWrapper.allowedWordsForRichTextArea - this.pageBlocks[element].fieldConfigs[field].wordLength;
                                    }
                                }

                                if(this.pageBlocks[element].fieldConfigs[field].isCheckBox){
                                    this.pageBlocks[element].fieldConfigs[field].fieldValue = (this.pageBlocks[element].fieldConfigs[field].fieldValue === 'true');
                                }

                                if (this.systemInformationFields.includes(this.pageBlocks[element].fieldConfigs[field].fieldAPIName) 
                                ) {
                                    this.pageBlocks[element].fieldConfigs[field].readOnly = true;
                                }
                            }
                        }
                        // let bannerMessages = this.pageBlocks[element].pageMessageList;
                        // bannerMessages?.forEach((message) => {
                        //     if (!message.messageTimeOut) {
                        //         message.messageTimeOut = this.messageTimeOut;
                        //     }
                        //     message.messageTimeOutEnabled = message.messageTimeOut ? true : false;
                        //     message.messageList = [{ messageType: message.messageType, messageBody: message.messageBody }];
                        // });

                        // this.pageBlocks[element].bannerMessages = bannerMessages;
                    }
                    this.showSpinner = false;
                }
            })
            .catch((error) => {
                this.pageBlocks = null;
                this.showSpinner = false;
                console.error("From fetchData of PageBlockSection", JSON.stringify(error));
            });
    }

    renderedCallback() {
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    if (this.pageBlocks[element].fieldConfigs[field].hideFieldsJSON) {
                        const fieldWrapper = this.pageBlocks[element].fieldConfigs[field];
                        let jsonData = JSON.parse(fieldWrapper.hideFieldsJSON);
                        let fieldValue = fieldWrapper.fieldValue;
                        for (let i = 0; i < jsonData.length; i++) {
                            let operator = jsonData[i].Operator;
                            let fieldToHide = jsonData[i].FieldToHide;
                            let hideVal = jsonData[i].FieldValue;
                            let action = jsonData[i].Action;
                            if (action == null || action == "hide") {
                                this.hideField(operator, fieldValue, fieldToHide, hideVal);
                            }
                        }
                    }
                }
            }
        }
    }
    
    

    handleCollapsed(event) {
        let pgBlockId = event.currentTarget.dataset.id;
        this.template.querySelectorAll(".page-block").forEach((element) => {
            if (element.getAttribute("data-id") == pgBlockId) {
                element.classList.toggle("hide");
            }
        });
        this.template.querySelectorAll(".utility-icon").forEach((element) => {
            if (element.getAttribute("data-id") == pgBlockId) {
                element.classList.toggle("hide");
            }
        });
    }
    
    async formatPhoneNumber(event) {
        return new Promise((resolve) => {
            let phoneNumberString = event.target.value;
            if (phoneNumberString.replace(/[^0-9]+/g, "").length == 10) {
                phoneNumberString = phoneNumberString.replace(/\D/g, "");
                let char = { 0: "(", 3: ") ", 6: "-" };
                let formattedPhoneNumber = "";
                for (let i = 0; i < phoneNumberString.length; i++) {
                    formattedPhoneNumber += (char[i] || "") + phoneNumberString[i];
                }
                phoneNumberString = formattedPhoneNumber;
            }
            for (const element in this.pageBlocks) {
                if (this.pageBlocks[element].isFields) {
                    for (const field in this.pageBlocks[element].fieldConfigs) {
                        const fieldWrapper = this.pageBlocks[element].fieldConfigs[field];
                        if (fieldWrapper.pageBlockDetailId == event.currentTarget.dataset.id) {
                            this.pageBlocks[element].fieldConfigs[field].fieldValue = phoneNumberString;
                            break;
                        }
                    }
                }
            }
            this.showPhoneField = false;
            this.showPhoneField = true;
            resolve();
        });
    }
    
        handleOnLoad(){
    
            const inputFields = this.template.querySelectorAll(
                'lightning-input-field'
            );

            //if(this.isNew === true){
                if(inputFields != undefined ){

                   
                
                        inputFields.forEach(field => {

                            if(this.pageLayoutWrapper.defaultValueMap != undefined){

                                if(Object.keys(this.pageLayoutWrapper.defaultValueMap).length > 0){
                                    for(let i=0; i < Object.values(this.pageLayoutWrapper.defaultValueMap).length; i++){
                        
                                        let key = Object.values(this.pageLayoutWrapper.defaultValueMap)[i];
                                        if(key.defaultValue != undefined && field.fieldName != undefined &&  key.fieldAPIName != undefined){
                                            if(field.fieldName.toLowerCase() == key.fieldAPIName.toLowerCase())
                                            field.value = key.defaultValue
                                        }
                                    }
                                }
                            }

                        if(this.pageLayoutWrapper.inputdata != undefined){
                        
                            for(let i=0; i < Object.keys(this.pageLayoutWrapper.inputdata).length; i++){
                                
                                let key = Object.keys(this.pageLayoutWrapper.inputdata)[i];
                                if(this.pageLayoutWrapper.inputdata[key] != undefined){
                                    if(field.fieldName == key)
                                    field.value = this.pageLayoutWrapper.inputdata[key];
                                }
                            }
                        }
                        
                    
                    });
                }
    
    }

    async handleMessage(message) {
        if(this.pageLayoutWrapper?.pageLayoutId === message.data.pageLayoutId){
            if (!this.pageBlockInHeader) {
                if (message.data.actionType == "Save") {
                    //this.showSpinner = true;//
                    this.isSavePressed = true;
                    this.handleSaveClick(false,false);
                    
                }else if(message.data.actionType == "ModalSave"){
                    this.handleSaveClick(true,false);
                }else if(message.data.actionType == "ModalContinue"){
                    this.handleSaveClick(false,true);
                }else if (message.data.isSaved) {
                    this.showSpinner = false;
                } else if (message.data.isSaved == false) {
                    this.errorOnSave = true;
                } else if (message.data.proceedToSave) {
                    this.proceedToSave();
                } else if (message.data.refreshPgBlocks) {
                    this.isView = message.data.isView;
                    this.showSpinner = true;
                    this.fetchPageBlockData();
                } else if (message.data.submitCheck) {
                    this.handleSubmitValidation();
                }else if(message.data.modalProceedToSave){
                    this.isSavePressed = true;
                    this.saveModalData();
                }else if(message.data.modalProceedToContinue){
                    this.isSavePressed = true;
                    this.modalOnContinue();
                }
            } else if (this.pageBlockInHeader && message.data.refreshPgBlocks) {
                await notifyRecordUpdateAvailable([{ recordId: this.pageLayoutWrapper.recordId }]);
            }
        }    
    }


    modalOnContinue(){
    
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        let inputdata={}
        let isinutdata=false;
        if(inputFields != undefined){
            inputFields.forEach(input => {
            if(input.fieldName != undefined && input.value){
                inputdata[input.fieldName] = input.value;
            }
            });
        }
        
        const payload = {
            source: "LWC-from Page Block Section Modal input",
            data: {
                inputdata: inputdata,
                pageLayoutId : this.pageLayoutWrapper.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
    }

    saveModalData(){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if(inputFields != undefined && this.pageLayoutWrapper.inputdata != undefined){
            var fields = {};
            if(this.pageLayoutWrapper.defaultValueMap != undefined){
            
                if(Object.keys(this.pageLayoutWrapper.defaultValueMap).length > 0){
                    for(let i=0; i < Object.values(this.pageLayoutWrapper.defaultValueMap).length; i++){
        
                        let key = Object.values(this.pageLayoutWrapper.defaultValueMap)[i];
                        if(key.defaultValue != undefined){
                            fields[this.pageLayoutWrapper.fieldApiNameMap[key.fieldAPIName.toLowerCase()]] = key.defaultValue;
                        }
                    }
                }
            }
            
            Object.keys(this.pageLayoutWrapper.inputdata).forEach(input => {
                if(input != undefined && this.pageLayoutWrapper.inputdata[input] != undefined){
                    fields[input] = this.pageLayoutWrapper.inputdata[input];
                }
            });

            inputFields.forEach(input => {
                if(input.fieldName != undefined && input.value){
                    fields[input.fieldName] = input.value;
                }
            });
            this.template.querySelector("lightning-record-edit-form").submit(fields)
        }else{
            var fields = {};
            if(this.pageLayoutWrapper.defaultValueMap != undefined){
            
                if(Object.keys(this.pageLayoutWrapper.defaultValueMap).length > 0){
                    for(let i=0; i < Object.values(this.pageLayoutWrapper.defaultValueMap).length; i++){
        
                        let key = Object.values(this.pageLayoutWrapper.defaultValueMap)[i];
                        if(key.defaultValue != undefined){
                            fields[this.pageLayoutWrapper.fieldApiNameMap[key.fieldAPIName.toLowerCase()]] = key.defaultValue;
                        }
                    }
                }
            }
            if(inputFields != undefined){
                //this.proceedToSave();

                inputFields.forEach(input => {
                    if(input.fieldName != undefined && input.value){
                        fields[input.fieldName] = input.value;
                    }
                });

            }
            if(Object.keys(fields).length > 0){
                this.template.querySelector("lightning-record-edit-form").submit(fields)
            }else{
                if(this.pageLayoutWrapper?.recordId != undefined){
                    this.template.querySelector("lightning-record-edit-form").submit(fields)
                }
            }
        }
    }

    async handleSaveClick(isModalSave,isModalContinue) {
        this.errorOnSave = false;
        this.currentlyProcessedForms = 0;
        let validationError = false;
        let fieldLabelList = [];
        let invalidUrlFieldList = [];

        this.template.querySelectorAll("lightning-input-field[data-save='true']").forEach((element) => {
            let valueHasOnlyWhiteSpaces = false;
            if (typeof element.value == "string")
                valueHasOnlyWhiteSpaces = element.value ? (element.value.replace(/\s/g, "").length == 0 ? true : false) : false;
            if (!element.value || valueHasOnlyWhiteSpaces) {
                if(!this.skipValidationForFields.has(element.getAttribute("data-field_api_name"))){
                    fieldLabelList.push(element.getAttribute("data-label"));
                    validationError = true;
                }
            }
        });

        let urlTypeFields = this.template.querySelectorAll("lightning-input-field[data-url_type='true']");
        for (let element of urlTypeFields) {
            let isUrlValid = await this.checkUrlValidation(element.value);
            if (isUrlValid == false) {
                invalidUrlFieldList.push(element.getAttribute("data-label"));
                validationError = true;
            }
        }

        if (validationError) {
            this.dispatchEvent(
                new CustomEvent("save_check", {
                    detail: {
                        requiredForSaveError: true,
                        fieldLabelList: fieldLabelList,
                        tabId: this.tabId,
                        invalidUrlFieldList: invalidUrlFieldList,
                        isModalSave : isModalSave,
                        isModalContinue : isModalContinue
                    }
                })
            );
        } else {
            this.dispatchEvent(new CustomEvent("save_check", { detail: { requiredForSaveError: false, isModalSave : isModalSave, isModalContinue : isModalContinue} }));
        }
    }

    handleSubmitValidation() {
        let noValidationError = true;
        let fieldList = [];
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    const fieldDetails = this.pageBlocks[element].fieldConfigs[field];
                    if (fieldDetails.requiredToSubmit == true && fieldDetails.fieldValue == null) {
                        if(!this.skipValidationForFields.has(element.getAttribute("data-field_api_name"))){
                            fieldList.push(fieldDetails.label);
                            noValidationError = false;
                        }
                    }
                }
            }
        }
        if (noValidationError == false) {
            this.dispatchEvent(
                new CustomEvent("submit_check", {
                    detail: {
                        requiredForSubmitError: true,
                        fieldList: fieldList,
                        tabId: this.tabId
                    }
                })
            );
        } else {
            this.dispatchEvent(new CustomEvent("save_check", { detail: { requiredForSaveError: false } }));
        }
    }

    proceedToSave() {
        if(isGuestUser){
            let recordObject = {};
            this.template.querySelectorAll("lightning-input-field").forEach((element)=>{
                let fieldApiName = element.getAttribute("data-field_api_name");
                recordObject[fieldApiName] = element.value;
            })
            this.dispatchEvent(new CustomEvent("guest_save",{detail:{recordObject:recordObject}}));
        }else{
            this.template.querySelectorAll("lightning-record-edit-form").forEach((element) => {
                element.submit();
            });
        }
    }

    async handleSuccess(event) {
        if(this.isSavePressed == true){
            this.currentlyProcessedForms++;
            this.publishSaveSuccessful(event.detail.id);
            this.isSavePressed = false;
        }
        
        // if (this.currentlyProcessedForms == this.totalFormCount && this.errorOnSave == false) {
          
        // } else if (this.currentlyProcessedForms == this.totalFormCount && this.errorOnSave == true) {
        //     this.publishErrors();
        // }
    }

    handleError(event) {
        this.currentlyProcessedForms++;
        this.errorOnSave = true;

        let errorMessage = event?.detail?.detail;
        if (errorMessage?.length > 0) {
            this.errorMessageList.push({ messageType: "error", messageBody: errorMessage });
        }

        let fieldErrors = event?.detail?.output?.fieldErrors;
        if (fieldErrors) {
            for (let fieldError in fieldErrors) {
				let existingMsgIndex = this.errorMessageList.findIndex((error) => error.messageBody.startsWith(fieldErrors[fieldError]?.[0]?.fieldLabel));
                if (existingMsgIndex != -1) {
                    this.errorMessageList.splice(existingMsgIndex, 1);
                }
                if (fieldErrors[fieldError]?.[0]?.message.startsWith(fieldErrors[fieldError]?.[0]?.fieldLabel)) {
                    errorMessage = fieldErrors[fieldError]?.[0]?.message + " ";
                } else {
                    // errorMessage = fieldErrors[fieldError]?.[0]?.fieldLabel + "-" + fieldErrors[fieldError]?.[0]?.message + " ";
                    errorMessage = fieldErrors[fieldError]?.[0]?.message;
                }
                if (fieldErrors[fieldError]?.[0].errorCode == "STRING_TOO_LONG") {
                    let splittedMsg = errorMessage.split(":");
                    if (splittedMsg.length > 2) {
                        errorMessage = `${splittedMsg[0].trim()}:${splittedMsg[1].trim()} `;
                    }
                    let max_length;
                    //to extract max length
                    let startIndex = splittedMsg[splittedMsg.length - 1].indexOf("(max length");
                    let endIndex;
                    if (startIndex != -1) {
                        endIndex = splittedMsg[splittedMsg.length - 1].indexOf(")", startIndex);
                        if (endIndex != -1) {
                            max_length = splittedMsg[splittedMsg.length - 1].slice(startIndex, endIndex + 1);
                            errorMessage = errorMessage + max_length;
                        }
                    }
                }
                let existingErrorMsgRcd = this.errorMessageList.find((data) => data.messageBody == errorMessage);
                if (existingErrorMsgRcd == undefined) {
                    this.errorMessageList.push({ messageType: "error", messageBody: errorMessage });
                }
            }
        }

        this.publishErrors();
    }

    publishErrors() {
        const payload = {
            source: "LWC-from Page Block Section",
            data: {
                errorWhileSave: true,
                pageMessageList: this.errorMessageList,
                pageLayoutId : this.pageLayoutWrapper.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
        this.errorMessageList = [];
        this.showSpinner = false;
    }

    publishSaveSuccessful(id) {
        const payload = {
            source: "LWC-from Page Block Section",
            data: {
                recordId: id,
                errorWhileSave: false,
                pageLayoutId : this.pageLayoutWrapper.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
        this.showSpinner = false;
    }

    handleRichText(event) {
        const value = event.target.value;
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    const fieldWrapper = this.pageBlocks[element].fieldConfigs[field];
                    if (fieldWrapper.isRichTextFieldType && fieldWrapper.pageBlockDetailId == event.currentTarget.dataset.id) {
                        if (this.pageLayoutWrapper.showCharLimit) {
                            const currentCharLength = value.replace(/<(.|\n)*?>/g, "").length; //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                            if (currentCharLength <= this.pageLayoutWrapper.allowedCharsForRichTextArea) {
                                this.pageBlocks[element].fieldConfigs[field].fieldValue = value;
                                this.pageBlocks[element].fieldConfigs[field].charLength = currentCharLength;
                                this.pageBlocks[element].fieldConfigs[field].charactersLeft =
                                    this.pageLayoutWrapper.allowedCharsForRichTextArea - currentCharLength;

                                if (this.pageLayoutWrapper.showCharLimitWarning) {
                                    if (currentCharLength >= this.pageLayoutWrapper.warningCharsForRichTextArea) {
                                        this.toggleWarningClass(true, this.pageBlocks[element].fieldConfigs[field].pageBlockDetailId, true);
                                        if (currentCharLength == this.pageLayoutWrapper.allowedCharsForRichTextArea) {
                                            this.toggleWarningClass(true, this.pageBlocks[element].fieldConfigs[field].pageBlockDetailId, true, true);
                                        }
                                    } else {
                                        this.toggleWarningClass(false, this.pageBlocks[element].fieldConfigs[field].pageBlockDetailId, true);
                                    }
                                }
                            } else {

                                this.pageBlocks[element].fieldConfigs[field].render = false;
                                setTimeout(() => {
                                    this.pageBlocks[element].fieldConfigs[field].render = true;
                                }, 0);

                                const event = new ShowToastEvent({
                                    title: "Error",
                                    message: "Character Limit exceeded",
                                    variant: "error"
                                });
                                this.dispatchEvent(event);
                            }
                        }

                        if (this.pageLayoutWrapper.showWordLimit) {
                            const currentWordLength = value.replace(/<(.|\n)*?>/g, "").split(" ").length; //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                            if (currentWordLength <= this.pageLayoutWrapper.allowedWordsForRichTextArea) {
                                this.pageBlocks[element].fieldConfigs[field].fieldValue = value;
                                this.pageBlocks[element].fieldConfigs[field].wordLength = currentWordLength;
                                this.pageBlocks[element].fieldConfigs[field].wordsLeft = this.pageLayoutWrapper.allowedWordsForRichTextArea - currentWordLength;

                                if (this.pageLayoutWrapper.showWordLimitWarning) {
                                    if (currentWordLength >= this.pageLayoutWrapper.warningWordsForRichTextArea){
                                        this.toggleWarningClass(true, this.pageBlocks[element].fieldConfigs[field].pageBlockDetailId, false);
                                        if (currentWordLength == this.pageLayoutWrapper.allowedWordsForRichTextArea) {
                                            this.toggleWarningClass(true, this.pageBlocks[element].fieldConfigs[field].pageBlockDetailId, false, true);
                                        }
                                    } else {
                                        this.toggleWarningClass(false, this.pageBlocks[element].fieldConfigs[field].pageBlockDetailId, false);
                                    }   
                                }

                            } else {
                                
                                this.pageBlocks[element].fieldConfigs[field].render = false;
                                setTimeout(() => {
                                    this.pageBlocks[element].fieldConfigs[field].render = true;
                                }, 0);

                                const event = new ShowToastEvent({
                                    title: "Error",
                                    message: "Word Limit exceeded",
                                    variant: "error"
                                });
                                this.dispatchEvent(event);
                            }
                        }
                        break;
                    }
                }
            }
        }
    }

    toggleWarningClass(addWarningClass, pageBlockDetailId, isCharWarning, isLimitReached = false) {
        let element;
        if (isCharWarning) {
            element = this.template.querySelector(`span[data-id=${pageBlockDetailId}][data-chars="true"]`);
        } else {
            element = this.template.querySelector(`span[data-id=${pageBlockDetailId}][data-words="true"]`);
        }
        if (addWarningClass && isLimitReached) {
            element.classList.add("rich-text-limit-reached");
        } else if (addWarningClass) {
            element.classList.remove("rich-text-limit-reached");
            element.classList.add("rich-text-with-warning");
        } else {
            element.classList.remove("rich-text-limit-reached");
            element.classList.remove("rich-text-with-warning");
        }
    }

    handleChangeInTextArea(event) {
        const value = event.target.value;
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    const fieldWrapper = this.pageBlocks[element].fieldConfigs[field];
                    if (fieldWrapper.isRichTextFieldType && fieldWrapper.pageBlockDetailId == event.currentTarget.dataset.id) {
                        this.pageBlocks[element].fieldConfigs[field].fieldValue = value;
                    }
                }
            }
        }
    }

    handlelookupvalue(event) {
        const eventDetails = event.detail.data;
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    if (
                        this.pageBlocks[element].fieldConfigs[field].isLookUpField &&
                        this.pageBlocks[element].fieldConfigs[field].fieldAPIName == String(eventDetails.selectedRecordApiName)
                    ) {
                        this.pageBlocks[element].fieldConfigs[field].fieldValue = eventDetails.selectedRecordId;
                    }
                }
            }
        }
    }

    async handleFieldValueChange(event) {
        const fieldValue = event.target.value;
        if (event.currentTarget.dataset.hide_fields_json) {
            for (const element in this.pageBlocks) {
                if (this.pageBlocks[element].isFields) {
                    for (const field in this.pageBlocks[element].fieldConfigs) {
                        const fieldWrapper = this.pageBlocks[element].fieldConfigs[field];
                        if (fieldWrapper.pageBlockDetailId == event.currentTarget.dataset.id) {
                            this.pageBlocks[element].fieldConfigs[field].fieldValue = fieldValue;
                            let jsonData = JSON.parse(fieldWrapper.hideFieldsJSON);
                            let fieldsToDisable = new Set();
                            let fieldsToEnable = new Set();
                            for (let i = 0; i < jsonData.length; i++) {
                                let operator = jsonData[i].Operator;
                                let fieldToHide = jsonData[i].FieldToHide;
                                let hideVal = jsonData[i].FieldValue;
                                let action = jsonData[i].Action;
                                if (action == "blank") {
                                    this.blankField(operator, fieldValue, fieldToHide, hideVal);
                                } else if (action == "disabled" || action == "hardDisabled") {
                                    const fieldToDisableEnable = this.disabledField(operator, fieldValue, fieldToHide, hideVal);
                                    fieldsToDisable = new Set([...fieldsToDisable, ...fieldToDisableEnable[0]]);
                                    fieldsToEnable = new Set([...fieldsToEnable, ...fieldToDisableEnable[1]]);
                                } else {
                                    this.hideField(operator, fieldValue, fieldToHide, hideVal);
                                }
                            }
                            this.toggleFieldEnableOrDisable(fieldsToDisable, fieldsToEnable);
                        }
                    }
                }
            }
        }
        if (event.currentTarget.dataset.phone == "true") {
            await this.formatPhoneNumber(event);
        }
    }

    hideField(operator, fieldValue, fieldToHide, hideVal) {
        if (operator == "==") {
            if (fieldValue === hideVal) {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => element.classList.add("slds-hide"));
                this.skipValidationForFields.add(fieldToHide);
            } else {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => element.classList.remove("slds-hide"));
                this.skipValidationForFields.delete(fieldToHide);
            }
        } else if (operator == "!=") {
            if (fieldValue != hideVal) {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => element.classList.add("slds-hide"));
                this.skipValidationForFields.add(fieldToHide);
            } else {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => element.classList.remove("slds-hide"));
                this.skipValidationForFields.delete(fieldToHide);
            }
        } else if (operator == "IN") {
            let splitFields = hideVal.split(",");
            if (splitFields.includes(fieldValue) == true) {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => {
                    element.classList.add("slds-hide");
                    this.skipValidationForFields.add(fieldToHide);
                });
            } else {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => {
                    element.classList.remove("slds-hide");
                    this.skipValidationForFields.delete(fieldToHide);
                });
            }
        } else if (operator == "NOT IN") {
            let splitFields = hideVal.split(",");
            if (splitFields.includes(fieldValue) == false) {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => {
                    element.classList.add("slds-hide");
                    this.skipValidationForFields.add(fieldToHide);
                });
                //elements.forEach((element) => element.classList.add("slds-hide"));
            } else {
                const elements = this.template.querySelectorAll(`div[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => {
                    element.classList.remove("slds-hide");
                    this.skipValidationForFields.delete(fieldToHide);
                });
            }
        }
    }

    blankField(operator, fieldValue, fieldToHide, hideVal) {
        let isCheckBox = false;
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    if (this.pageBlocks[element].fieldConfigs[field].fieldAPIName == fieldToHide) {
                        isCheckBox = this.pageBlocks[element].fieldConfigs[field].isCheckBox;
                        break;
                    }
                }
            }
        }

        if (operator == "==") {
            if (fieldValue === hideVal) {
                const elements = this.template.querySelectorAll(`lightning-input-field[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => (isCheckBox ? (element.value = false) : (element.value = "")));
            }
        } else if (operator == "!=") {
            if (fieldValue != hideVal) {
                const elements = this.template.querySelectorAll(`lightning-input-field[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => (isCheckBox ? (element.value = false) : (element.value = "")));
            }
        } else if (operator == "IN") {
            let splitFields = hideVal.split(",");
            if (splitFields.includes(fieldValue) == true) {
                const elements = this.template.querySelectorAll(`lightning-input-field[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => (isCheckBox ? (element.value = false) : (element.value = "")));
            }
        } else if (operator == "NOT IN") {
            let splitFields = hideVal.split(",");
            if (splitFields.includes(fieldValue) == false) {
                const elements = this.template.querySelectorAll(`lightning-input-field[data-field_api_name=${fieldToHide}]`);
                elements.forEach((element) => (isCheckBox ? (element.value = false) : (element.value = "")));
            }
        }
    }

    disabledField(operator, fieldValue, fieldToHide, hideVal) {
        let fieldsToDisable = new Set();
        let fieldsToEnable = new Set();

        fieldValue = fieldValue != undefined && fieldValue != "" ? fieldValue.toLowerCase() : fieldValue;
        hideVal = hideVal != undefined && hideVal != "" ? hideVal.toLowerCase() : hideVal;
        if (operator == "==") {
            if (fieldValue === hideVal) {
                fieldsToDisable.add(fieldToHide);
            } else {
                fieldsToEnable.add(fieldToHide);
            }
        } else if (operator == "!=") {
            if (fieldValue != hideVal) {
                fieldsToDisable.add(fieldToHide);
            } else {
                fieldsToEnable.add(fieldToHide);
            }
        } else if (operator == "IN") {
            let splitFields = hideVal.split(",");
            if (splitFields.includes(fieldValue) == true) {
                fieldsToDisable.add(fieldToHide);
            } else {
                fieldsToEnable.add(fieldToHide);
            }
        } else if (operator == "NOT IN") {
            let splitFields = hideVal.split(",");
            if (splitFields.includes(fieldValue) == false) {
                fieldsToDisable.add(fieldToHide);
            } else {
                fieldsToEnable.add(fieldToHide);
            }
        }

        return [fieldsToDisable, fieldsToEnable];
    }

    toggleFieldEnableOrDisable(fieldsToDisable, fieldsToEnable) {
        for (const element in this.pageBlocks) {
            if (this.pageBlocks[element].isFields) {
                for (const field in this.pageBlocks[element].fieldConfigs) {
                    if (fieldsToDisable.has(this.pageBlocks[element].fieldConfigs[field].fieldAPIName)) {
                        this.pageBlocks[element].fieldConfigs[field].isDisabled = true;
                    } else if (fieldsToEnable.has(this.pageBlocks[element].fieldConfigs[field].fieldAPIName)) {
                        this.pageBlocks[element].fieldConfigs[field].isDisabled = false;
                    }
                }
            }
        }
    }

    async checkUrlValidation(url) {
        return new Promise((resolve) => {
            validateURLFormat({ url: url })
                .then((data) => {
                    resolve(data);
                })
                .catch((error) => {
                    resolve(true);
                });
        });
    }

    subscribeToMessageChannel() {
        if (this.subscription) {
            return;
        } else {
            this.subscription = subscribe(this.messageContext, messageChannel, (message) => this.handleMessage(message), {
                scope: APPLICATION_SCOPE
            });
        }
    }

    handleAlternateSelectValue(event) {
        const selectedValue = event.detail.selectedValue;
        const identifier = event.detail.fieldApiName;
        const textInputField = this.template.querySelector('lightning-input-field[data-recid='+identifier+']');
        if (textInputField) {
            textInputField.value = selectedValue;
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}