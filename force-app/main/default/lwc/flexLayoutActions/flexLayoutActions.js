import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import LightningConfirm from "lightning/confirm";
import { CurrentPageReference } from "lightning/navigation";
import { subscribe, unsubscribe, APPLICATION_SCOPE, publish, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
import LightningPrompt from 'lightning/prompt';
import getPageLayoutActions from "@salesforce/apex/FlexLayoutController.getPageLayoutActions";
import actionClassExecute from "@salesforce/apex/FlexLayoutController.actionClassExecute";
import getCommunityBaseUrl from "@salesforce/apex/AppUtils.getCommunityBaseUrl";
import geticons from "@salesforce/apex/AppUtils.getIcons";
import requiredForSubmitOrSave from "@salesforce/apex/FlexLayoutController.requiredForSubmitOrSave";
import validateForms from "@salesforce/apex/DynamicLayoutController.validateFormsLWC";
import updateFormInstancePercentLightning from "@salesforce/apex/DynamicLayoutController.updateFormInstancePercentLightning";
import MyModal from "c/taskSummaryLWC";
import downloadAsPDFLabel from "@salesforce/label/c.DownloadAsPDF";
import onDemandSnapShotHelper from "@salesforce/apex/FlexLayoutController.onDemandSnapShotHelper";

export default class FlexLayoutActions extends NavigationMixin(LightningElement) {
    buttonDisabled = false;
    govGrantPleaseWaitIcon = "";
    @api recId;
    @api pageLayoutWrapper;
    @api context;
    @wire(MessageContext)
    messageContext;
    @track actions;
    @api showDownloadAsPdf;
    @api showSnapshotMenuButton;
    @api enableStepProgressBar;
    actionsMap = {};
    currentActionId;
    pageLayoutActionsString;
    showSpinner = false;
    showMenu = false;
    ModalAttribute = {};
    isModalFlexLayout = false;
    modalRefreshedBehavior;
    ModalRecordId;
    ModalHeader;
    communityBaseUrl = null;
    isCommunitySite = false;

    @wire(CurrentPageReference)
    getPageContext(data) {
        if (data) {
            this.currentPageReference = JSON.parse(JSON.stringify(data));
            try {
                for (const param in this.currentPageReference.state) {
                    if (param.startsWith("c__")) {
                        this.currentPageReference.state[param] = window.atob(this.currentPageReference.state[param]);
                    }
                }
            } catch (error) {
                console.error("URL entered is invalid::", JSON.stringify(error));
            }
        }
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        this.fetchPageLayoutActions(true);
        this.isUserInCommunity();

        geticons({ strResourceName: "govGrantPleaseWaitIcon" })
            .then((result) => {
                if (result) {
                    this.govGrantPleaseWaitIcon = result;
                }
            })
            .catch((error) => {
            });
    }

    isUserInCommunity() {
        getCommunityBaseUrl()
            .then((data) => {
                if (data != null) {
                    this.isCommunitySite = true;
                    this.communityBaseUrl = data;
                }
            })
            .catch((error) => {
            });
    }

    async handleActionButtonClick(event) {
        const eventType = event.currentTarget.dataset.type;
        this.currentActionId = event.target.dataset.id;
        let proceed = await this.forWarningMessage(event);
        if (proceed) {
            if (eventType == "Edit") {
                this.context = "Edit";
                //this.addEditParamFromUrl();
            } else if (eventType == "Save") {
                this.context = "View";
            } else if (eventType == "Cancel") {
                this.context = "View";
                this.removeEditParamFromUrl();
            } else {
                this.context = "View";
            }
            this.showMenu = false;
            for (let action in this.actions) {
                if (this.actions[action].layoutType.includes(this.context)) {
                    this.actions[action].showButton = true;
                } else this.actions[action].showButton = false;
                if (this.actions[action].isMenuButton && this.actions[action].showButton && !this.showMenu) {
                    this.showMenu = true;
                }
            }
            const actionConfig = this.actionsMap[this.currentActionId];
            if (actionConfig.isSubmit) {
                this.buttonDisabled = true;
                this.showSpinner = true;
                requiredForSubmitOrSave({
                    layoutId: this.pageLayoutWrapper.pageLayoutId,
                    recId: this.recId,
                    objectName: this.pageLayoutWrapper.objectName,
                    requiredBehaviour: "Required for Submit",
                    tabsOpenedString: null,
                    pageMessageListString: null,
                    isViewContext: this.context == "Edit" ? false : true
                })
                    .then((data) => {
                        let pageMessageList = JSON.parse(data);
                        if (pageMessageList.length > 0) {
                            const payload = {
                                source: "LWC-from Layout Tabs",
                                data: {
                                    requiredForSubmitError: true,
                                    pageMessageList: pageMessageList,
                                    pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                                }
                            };
                            publish(this.messageContext, messageChannel, payload);
                        } else {
                            const payload = {
                                source: "LWC-from Layout Tabs",
                                data: {
                                    proceedToSubmit: true,
                                    pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                                }
                            };
                            publish(this.messageContext, messageChannel, payload);
                        }
                    })
                    .catch((error) => {
                    });
                const payload = {
                    source: "LWC-from flex header actions",
                    data: {
                        submitCheck: true
                    }
                };
                publish(this.messageContext, messageChannel, payload);
            } else {
                if(actionConfig.EnablePromptInputDialog){
                    this.handlePromptClick(actionConfig);
                }else{
                    this.performAction(actionConfig);
                }
                
            }
            if(actionConfig.actionType == "Custom"){
                const payload = {
                    source: "LWC-from flex header actions",
                    data: actionConfig
                };
                publish(this.messageContext, messageChannel, payload);
            }
        }
    }

    performAction(actionConfig) {
        if (actionConfig.recordTypeName == "Action Class" && actionConfig.actionType == "Custom") {
            this.buttonDisabled = true;
            this.showSpinner = true;
            this.handleActionClassType(actionConfig);
        } //for custom action->action URL
        else if (actionConfig.recordTypeName == "Action URL" && (actionConfig.actionType == "Custom" || actionConfig.actionType == "Back")) {
            this.buttonDisabled = true;
            this.showSpinner = true;
            this.handleActionUrlType(actionConfig);
        } else if (actionConfig.recordTypeName == "Validate" && actionConfig.actionType == "Custom") {

            validateForms({
                formId: this.recId,
                actionConfigId: actionConfig.actionId,
                currentUrl: JSON.stringify(this.currentPageReference)
            })
                .then((response) => {
                    if (response) {
                        let data = JSON.parse(response);
                        if (data.pageMessageList.length > 0) {
                            const handle_page_messages = new CustomEvent("handle_page_messages", {
                                detail: {
                                    pageMessageList: data.pageMessageList,
                                    messageTimeOut: data.messageTimeOut,
                                    messageTimeOutEnabled: data.messageTimeOutEnabled
                                }
                            });
                            this.dispatchEvent(handle_page_messages);
                        }
                    } else {
                    }
                })
                .catch((error) => {
                    this.error = error;
                });
        } else if (actionConfig.actionType == "Edit" || actionConfig.actionType == "Save" || actionConfig.actionType == "Cancel") {
            actionConfig["pageLayoutId"] = this.pageLayoutWrapper.pageLayoutId;
            if (actionConfig.actionType == "Save") {
                this.buttonDisabled = true;
                this.showSpinner = true;
            }
            const payload = {
                source: "LWC-from flex header actions",
                data: actionConfig
            };
           publish(this.messageContext, messageChannel, payload);
        } else if (actionConfig.actionType == "downloadAsPdfMenuButton") {
            let namespace = this.pageLayoutWrapper.nameSpace == null ? "" : this.pageLayoutWrapper.nameSpace;

            let exportPageURL =
                "/apex/" +
                namespace +
                "DynamicLayoutExport?id=" +
                this.recId +
                "&viewTemplateName=" +
                encodeURIComponent(this.pageLayoutWrapper.formName) +
                "&flexTableParam=" +
                encodeURIComponent(this.pageLayoutWrapper.keyValueMap) +
                "&listParm=" +
                `${this.pageLayoutWrapper.listValueMap || ""}` +
                "&packageId=&formTypes=" +
                // JSON.stringify(formTypeJSON) +
                "&mode=pdf";
            window.open(exportPageURL, "_blank");
        } else if (actionConfig.actionType == "snapShotMenuButton") {
            this.buttonDisabled = true;
            this.showSpinner = true;
            onDemandSnapShotHelper({ recId: this.recId, pageLayoutWrapperStr: JSON.stringify(this.pageLayoutWrapper) })
                .then((data) => {
                    const handle_page_messages = new CustomEvent("handle_page_messages", {
                        detail: {
                            pageMessageList: [JSON.parse(data)]
                        }
                    });
                    this.dispatchEvent(handle_page_messages);
                    this.buttonDisabled = false;
                    this.showSpinner = false;
                })
                .catch((error) => {
                });
        } else {
            console.error("Invalid Configuration of PageLayoutAction");
        }
    }

    async fetchPageLayoutActions(isFirstCall = false) {
        return new Promise((resolve) => {
            let isFormLayout = this.currentPageReference?.state?.c__formInstanceId ? true : false;

            let formParentId = this.currentPageReference?.state?.c__parentId;

            getPageLayoutActions({
                pageLayoutWrapperString: JSON.stringify(this.pageLayoutWrapper),
                pageLayoutActionsString: this.pageLayoutActionsString,
                isFirstCall: isFirstCall,

                context: this.context,

                isFormLayout: isFormLayout,

                formParentId: formParentId
            })
                .then((data) => {
                    this.actions = JSON.parse(data[0]);
                    this.pageLayoutActionsString = data[1];
                    
                    if (this.enableStepProgressBar) {
                        let headerButtons = this.actions.filter(
                            (action) => action.isHeaderButton == true && action.actionId != "Save" && action.actionId != "Cancel"
                        );
                        if (headerButtons.length > 2) {
                            headerButtons.slice(2).forEach((action) => {
                                action.isHeaderButton = false;
                                action.isMenuButton = true;
                            });
                        }
                    }
                    if (this.showDownloadAsPdf) {
                        const downloadAsPdfButtonWrapper = {
                            warningMessage: null,
                            toolTipText: null,
                            standardActionType: null,
                            skipRollbackLogic: false,
                            showIconOnly: false,
                            showButton: null,
                            recordTypeName: null,
                            layoutType: "View",
                            isSubmit: false,
                            isMenuButton: true,
                            isHeaderButton: false,
                            iconCss: "utility:pdf_ext",
                            actionUrl: null,
                            actionType: "downloadAsPdfMenuButton",
                            actionName: downloadAsPDFLabel,
                            actionId: downloadAsPDFLabel,
                            actionClass: null,
                            actionBehavior: null
                        };
                        this.actions.push(downloadAsPdfButtonWrapper);
                    }
                    if (this.showSnapshotMenuButton) {
                        const snapshotMenuButton = {
                            warningMessage:
                                "You are attempting to take a snapshot of the current record. The PDF will be attached in Snapshot History. Do you want to proceed?",
                            toolTipText: null,
                            standardActionType: null,
                            skipRollbackLogic: false,
                            showIconOnly: false,
                            showButton: null,
                            recordTypeName: null,
                            layoutType: "View",
                            isSubmit: false,
                            isMenuButton: true,
                            isHeaderButton: false,
                            iconCss: "utility:photo",
                            actionUrl: null,
                            actionType: "snapShotMenuButton",
                            actionName: "Take Snapshot",
                            actionId: "snapShotMenuButton",
                            actionClass: null,
                            actionBehavior: null
                        };

                        this.actions.push(snapshotMenuButton);
                    }
                    //for actions
                    this.showMenu = false;
                    for (let actionVal in this.actions) {
                        if (this.actions[actionVal].showButton == null) {
                            if (this.actions[actionVal].layoutType.includes(this.context)) {
                                this.actions[actionVal].showButton = true;
                            } else this.actions[actionVal].showButton = false;
                        }
                        if (this.actions[actionVal].isMenuButton && this.actions[actionVal].showButton && !this.showMenu) {
                            this.showMenu = true;
                        }
                        this.actionsMap[this.actions[actionVal].actionId] = this.actions[actionVal];
                    }
                    resolve();
                })
                .catch((error) => {
                    console.error("error while fetch action's", JSON.stringify(error));
                });
        });
    }

    async handleActionClassType(actionConfig) {
        actionClassExecute({
            actionConfigString: JSON.stringify(actionConfig),
            recId: this.recId,
            currentUrl: JSON.stringify(this.currentPageReference),
            keyValueMap: this.pageLayoutWrapper.keyValueMap,
            listValueMap: this.pageLayoutWrapper.listValueMap,
            formName: this.pageLayoutWrapper.formName
        })
            .then(async (data) => {
                let payload = {
                    source: "LWC-from flex actions after class execution",
                    data: {
                        refreshStepProgressBar: true,
                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                    }
                };
               publish(this.messageContext, messageChannel, payload);
                let response;
                if (this.isJsonString(data)) {
                    response = JSON.parse(data);
                    if (response.redirectUrl) {
                        if (this.isCommunitySite) {
                            response.redirectUrl = this.convertUrlToCommunitySite(response.redirectUrl);
                        }
                        response.redirectUrl = this.encodeUrlParams(response.redirectUrl);
                        if (response.actionBehavior == "Open in new window") {
                            window.open(response.redirectUrl, "Action URL", "popup");
                        } else if (response.actionBehavior == "Open in new tab") {
                            window.open(response.redirectUrl, "_blank");
                        } else if (response.actionBehavior == "Open in overlay") {
                            //window.alert("work in progress!!");
                            window.open(response.redirectUrl, "_blank");
                        } else {
                            window.open(response.redirectUrl, "_self");
                        }
                        //}
                    }
                } else {
                    response = {};
                    response.pageMessageList = [{ messageType: "Error", messageBody: data }];
                }
                await this.fetchPageLayoutActions();
                await notifyRecordUpdateAvailable([{ recordId: this.pageLayoutWrapper.recordId }]);
				payload = {
                    source: "LWC-from Actions.js after action class execution",
                    data: {
                        refreshEntirePage: true,
                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                    }
                };
               publish(this.messageContext, messageChannel, payload);
                if (response.pageMessageList.length > 0) {
                    const handle_page_messages = new CustomEvent("handle_page_messages", {
                        detail: {
                            pageMessageList: response.pageMessageList
                        }
                    });
                    this.dispatchEvent(handle_page_messages);
                }
                this.buttonDisabled = false;
                this.showSpinner = false;
            })
            .catch((error) => {
                this.showToast("Execution Failed!", "Please Contact Administrator.", "error");
                this.buttonDisabled = false;
                this.showSpinner = false;
            });
    }

    replaceAllMergeFields(urlParms) {
        
        if(this.currentPageReference?.attributes?.recordId !== undefined){
            urlParms = urlParms.replaceAll("{!Id}", this.currentPageReference.attributes.recordId);
        }
        if (this.pageLayoutWrapper.keyValueMap !== undefined) {
            urlParms = this.replaceStringParamters(JSON.parse(this.pageLayoutWrapper.keyValueMap), urlParms);
        }
        if (this.pageLayoutWrapper.listValueMap !== undefined) {
            urlParms = this.replaceListParamters(JSON.parse(this.pageLayoutWrapper.listValueMap), urlParms);
        }
        return urlParms;
    }
    replaceStringParamters(keyValueMap, urlParms) {
        if (keyValueMap != undefined && keyValueMap != "" && urlParms != null) {
            Object.keys(keyValueMap).forEach((key) => {
                let value = keyValueMap[key];
                if (typeof urlParms === "string" && urlParms.indexOf("{!" + key + "}") != -1) {
                    if (typeof value === "object") {
                        urlParms = urlParms.replaceAll("{!" + key + "}", "('" + value.join("','") + "')");
                    } else {
                        urlParms = urlParms.replaceAll("{!" + key + "}", value);
                    }
                }
            });
        }
        return urlParms;
    }

    replaceListParamters(listValueMap, urlParms) {
        if (listValueMap != undefined && listValueMap != "" && urlParms != null) {
            Object.keys(listValueMap).forEach((key) => {
                let value = listValueMap[key];
                if (typeof urlParms === "string" && urlParms.indexOf("{!" + key + "}") != -1) {
                    urlParms = urlParms.replaceAll("{!" + key + "}", "('" + value.join("','") + "')");
                }
            });
        }
        return urlParms;
    }

    handleActionUrlType(actionConfig) {
        actionConfig.actionUrl = this.encodeUrlParams(actionConfig.actionUrl);
        if (this.isCommunitySite && !this.isJsonString(actionConfig.actionUrl)) {
            actionConfig.actionUrl = this.convertUrlToCommunitySite(actionConfig.actionUrl);
        }
        if (actionConfig.actionBehavior == "Open in new window") {
            window.open(actionConfig.actionUrl, "Action URL", "popup");
        } else if (actionConfig.actionBehavior == "Open in new tab") {
            window.open(actionConfig.actionUrl, "_blank");
        } else if (actionConfig.actionBehavior == "Open in overlay") {
            if (actionConfig.actionUrl != undefined) {
                this.ModalAttribute = this.isJsonString(actionConfig.actionUrl) === false ? undefined : JSON.parse(actionConfig.actionUrl);
            } else {
                this.ModalAttribute = undefined;
            }
            if (this.ModalAttribute != undefined && this.ModalAttribute["urlParams"] != undefined) {
                this.ModalAttribute["urlParams"] = this.replaceAllMergeFields(this.ModalAttribute["urlParams"]);
            }
            this.ModalAttribute["govGrantPleaseWaitIcon"] = this.ModalAttribute != undefined ? this.govGrantPleaseWaitIcon : undefined;

            if (this.ModalAttribute != undefined && this.context != undefined &&  this.ModalAttribute?.parentPageContext === undefined) {
                this.ModalAttribute["parentPageContext"] = this.context;
            }
            this.ModalAttribute["isLayout"] = this.ModalAttribute != undefined ? true : undefined;
            this.ModalHeader = actionConfig.ModalTitle;
            this.ModalAttribute["isTableRefreshAvailable"] = false;
            this.isModalFlexLayout = true;
            this.modalRefreshedBehavior = actionConfig.refreshBehaviour;
        } else {
            window.open(actionConfig.actionUrl, "_self");
        }
        this.buttonDisabled = false;
        this.showSpinner = false;
    }

    handlePromptClick(actionConfig) {
        LightningPrompt.open({
            message: actionConfig.PromptDialogText,
            label: actionConfig.PromptDailogHeader
        }).then((result) => {
            if(result !== null){
                if(result.length == 0){
                    alert("Please Enter Comments");
                    this.buttonDisabled = false;
                    this.showSpinner = false;
                    this.handlePromptClick(actionConfig);
                }else{
                    actionConfig.promptVal = result;
                    this.performAction(actionConfig)
                }
                
            }else{
                this.buttonDisabled = false;
                this.showSpinner = false;
            }
        });
    }

    async handleMessage(message) {
        if (this.pageLayoutWrapper?.pageLayoutId === message.data.pageLayoutId) {
            if (message.data.isSaved == true) {
                this.buttonDisabled = false;
                await this.fetchPageLayoutActions();
                this.removeEditParamFromUrl();
                this.showSpinner = false;

                const payload = {
                    source: "LWC-from flex actions after save",
                    data: {
                        refreshStepProgressBar: true,
                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                    }
                };
                publish(this.messageContext, messageChannel, payload);
                //remove previous error msgs
                const handle_page_messages = new CustomEvent("handle_page_messages", {
                    detail: {
                        pageMessageList: null
                    }
                });
                this.dispatchEvent(handle_page_messages);
            }
            if (message.data.isApprovalActions == true) {
                this.buttonDisabled = false;
                await this.fetchPageLayoutActions();
                this.showSpinner = false;
            }
            if (message.data.isSaved == false) {
                this.buttonDisabled = false;
                this.context = "Edit";
                this.showMenu = false;
                for (let action in this.actions) {
                    if (this.actions[action].layoutType.includes(this.context)) {
                        this.actions[action].showButton = true;
                    } else this.actions[action].showButton = false;
                    if (this.actions[action].isMenuButton && this.actions[action].showButton && !this.showMenu) {
                        this.showMenu = true;
                    }
                }
                this.showSpinner = false;
                const handle_page_messages = new CustomEvent("handle_page_messages", {
                    detail: {
                        pageMessageList: message.data.pageMessageList
                    }
                });
                this.dispatchEvent(handle_page_messages);
            }
            if (message.data.requiredForSaveError) {
                this.context = "Edit";
                this.buttonDisabled = false;
                this.showMenu = false;
                for (let action in this.actions) {
                    if (this.actions[action].layoutType.includes(this.context)) {
                        this.actions[action].showButton = true;
                    } else this.actions[action].showButton = false;
                    if (this.actions[action].isMenuButton && this.actions[action].showButton && !this.showMenu) {
                        this.showMenu = true;
                    }
                }
                this.showSpinner = false;
                const handle_page_messages = new CustomEvent("handle_page_messages", {
                    detail: {
                        pageMessageList: message.data.pageMessageList
                    }
                });
                this.dispatchEvent(handle_page_messages);
            }
            if (message.data.requiredForSubmitError) {
                this.buttonDisabled = false;
                this.showSpinner = false;
                const handle_page_messages = new CustomEvent("handle_page_messages", {
                    detail: {
                        pageMessageList: message.data.pageMessageList
                    }
                });
                this.dispatchEvent(handle_page_messages);
            }
            if (message.data.proceedToSubmit == true) {
                if(this.actionsMap[this.currentActionId].EnablePromptInputDialog){
                    this.handlePromptClick(this.actionsMap[this.currentActionId]);
                }else{
                    this.performAction(this.actionsMap[this.currentActionId]);
                }
                
            }
            if (message.data.errorWhileSave == false) {
                updateFormInstancePercentLightning({
                    formRecordId: this.recId
                })
                    .then((data) => {
                    })
                    .catch((error) => {
                    });
            }
        }
        if (message.data.refreshEntirePage){
            await this.fetchPageLayoutActions();
        }
    }

    async showWarningPopUp(message) {
        const result = await LightningConfirm.open({
            message: message,
            label: "Confirm",
            theme: "default"
        });
        return result;
    }

    async forWarningMessage(event) {
        const actionConfig = this.actionsMap[event.target.dataset.id];
        if (actionConfig.warningMessage) {
            const result = await this.showWarningPopUp(actionConfig.warningMessage);
            return result;
        }
        return true;
    }

    showToast(title, message = " ", variant = "info") {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
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

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    encodeUrlParams(url) {
        try {
            if (url.includes("?")) {
                let urlStrings = url.split("?");
                let params = urlStrings[1].split("&");
                let encodedParams = [];

                params.forEach((param) => {
                    let paramStrings = param.split("=");
                    encodedParams.push(paramStrings[0] + "=" + window.btoa(paramStrings[1]));
                });

                encodedParams = encodedParams.join("&");
                let encodedUrl = urlStrings[0] + "?" + encodedParams;
                return encodedUrl;
            } else {
                return url;
            }
        } catch (error) {
            return null;
        }
    }

    removeEditParamFromUrl() {
        let url = window.location.href;
        const urlObj = new URL(url);
        urlObj.searchParams.delete("c__Mode");
        url = urlObj.toString();
        window.history.replaceState({}, "", url);
    }

    isJsonString(str) {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
    }

    clodeModalFlexlayout(event) {
        this.isModalFlexLayout = false;
        if(this.modalRefreshedBehavior === 'Refresh the entire page'){
            const payload = {
                data: {
                    refreshEntirePage : true,
                    pageLayoutId : '' 
                }
            };
            publish(this.messageContext, messageChannel, payload);
        }
    }

    convertUrlToCommunitySite(url) {
        try {
            //record detail page
            if (url.toLowerCase().includes("/lightning/r/")) {
                let splittedUrl = url.split("/lightning/r/")[1];
                let recId = splittedUrl.split("/", 2)[1];
                let urlParams = splittedUrl.split("/view")[1];
                return this.communityBaseUrl + "/detail/" + recId + urlParams;
            } else if (url.toLowerCase().includes("/lightning/n/")) {
                //for flexi page type
                let splittedUrl = url.split("/lightning/n")[1];
                return this.communityBaseUrl + splittedUrl;
            } else {
                //other urls like--> /sfc/servlet.shepherd/version/download/{!rowId}
                return this.communityBaseUrl + url;
            }
        } catch (error) {
            console.error("URL entered is invalid::", JSON.stringify(error));
            return this.communityBaseUrl;
        }
    }
    // addEditParamFromUrl() {
    //     let url = window.location.href;
    //     window.history.replaceState({}, "", url);
    // }
}