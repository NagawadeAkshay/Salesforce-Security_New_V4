import { LightningElement, wire, api } from "lwc";
import getPageTemplateDetails from "@salesforce/apex/FlexLayoutController.getPageTemplateDetails";
import getLayoutOnLoadDetails from "@salesforce/apex/FlexLayoutController.getLayoutOnLoadDetails";
import { CurrentPageReference } from "lightning/navigation";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import { subscribe, unsubscribe, publish, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import GOVGRANTS from "@salesforce/resourceUrl/GovGrants";
import { loadStyle } from "lightning/platformResourceLoader";
import getCommunityBaseUrl from "@salesforce/apex/AppUtils.getCommunityBaseUrl";
import getSOBjectLabel from "@salesforce/apex/AppUtils.getSOBjectLabel";
import userId from "@salesforce/user/Id";
import isGuestUser from "@salesforce/user/isGuest";
// import flexLayoutTemp from '@salesforce/resourceUrl/flexLayout';

export default class FlexLayout extends LightningElement {
    pageLayoutWrapper;
    _pageLayoutWrapperHolder;
    isView = true;
    showConfigError = false;
    @api context = "";
    @api recordId;
    @api guestRecordId;
    @api pageTemplateName;
    @api pageData;
    @api isLastStep;
    @api isSplitView = false;
    pageTemplateId = "";
    subscription = null;
    @wire(MessageContext)
    messageContext;
    keyValueMap = {};
    listValueMap;
    pageTemplateDetailsResponse;
    showTabs = true;
    activeTabId;
    communityBaseUrl = null;
    isCommunitySite = false;
    browserTitle;
    activeTabName;
    firstCallToTabs = false;

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
            }
            if (this.currentPageReference.state.c__Mode && this.currentPageReference.state.c__Mode == "edit") {
                this.context = "Edit";
            }
        }
    }
    
    renderedCallback() {
        if (this.isView) document.title = this.browserTitle + " View";
        else document.title = this.browserTitle + " Edit";
    }

    async connectedCallback() {
        this.recordId = isGuestUser ? (this.guestRecordId ? this.guestRecordId : this.recordId) : this.recordId;
        if (sessionStorage.getItem(`currentUrl_${this.recordId}_${userId}`) == null) {
            sessionStorage.setItem(`currentUrl_${this.recordId}_${userId}`, window.location.href);
        } else {
            if (window.location.href !== sessionStorage.getItem(`currentUrl_${this.recordId}_${userId}`)) {
                sessionStorage.removeItem(`currentContext_${this.recordId}_${userId}`);
                sessionStorage.setItem(`currentUrl_${this.recordId}_${userId}`, window.location.href);
            }
        }
        if (sessionStorage.getItem(`currentContext_${this.recordId}_${userId}`) == null) {
            if (this.context == "Edit") {
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, this.context);
            } else {
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "View");
            }
        }
        let context = sessionStorage.getItem(`currentContext_${this.recordId}_${userId}`);
        if (context == "View") {
            this.isView = true;
        } else {
            this.isView = false;
        }
        getSOBjectLabel({ recordId: this.recordId })
            .then(result => {
                this.browserTitle = result;
            })
            .catch(error => {
                console.error('Error retrieving object label:', error);
            });
        // if (this.context == "Edit") {
        //     this.isView = false;
        // }

        loadStyle(this, GOVGRANTS + "/Component/CSS/flexviewlayoutLwc.css").then(() => {
        });

        if (this.currentPageReference.state.c__tabName) {
            this.activeTabName = this.currentPageReference.state.c__tabName;
            //this.removetabNameParamFromUrl();
        } else {
            let previousTabId = localStorage.getItem(`tabOpened_${this.recordId}_${userId}`);
            this.activeTabId = previousTabId != null ? previousTabId : undefined;
        }

         await this.isUserInCommunity();

        getPageTemplateDetails({
            recId: this.recordId,
            templateName: this.pageTemplateName,
            urlVal: JSON.stringify(this.currentPageReference)
        })
            .then((data) => {
                let dataObject = this.isJsonString(data) ? JSON.parse(data) : data;
                if (dataObject.isError) {
                    console.error(dataObject.errorMessage);
                    this.showConfigError = true;
                } else if (dataObject.redirectUrl) {
                    this.showConfigError = false;
                    if (this.isCommunitySite) {
                        window.open(this.convertUrlToCommunitySite(dataObject.redirectUrl), "_self");
                    } else {
                        window.open(dataObject.redirectUrl, "_self");
                    }
                } else {
                    if (dataObject?.hasRecordEditAccess != null && !isGuestUser && !dataObject?.hasRecordEditAccess && this.context == "Edit") {
                        this.isView = true;
                        this.context = "View";
                        sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "View");
                    }
                    this._pageLayoutWrapperHolder = dataObject;
                    //this.pageTemplateName = dataObject.pageLayoutName;
                    this.pageTemplateId = dataObject.pageLayoutId;
                    this.keyValueMap = JSON.parse(dataObject.keyValueMap);
                    this.listValueMap = JSON.parse(dataObject.listValueMap);

                    return getLayoutOnLoadDetails({
                        templateId: this.pageTemplateId,
                        recId: this.recordId,
                        isViewContext: this.isView
                    });
                }
            })
            .then((data) => {
                if (data != undefined) {
                    this.pageLayoutWrapper = JSON.parse(data);
                    this.pageLayoutWrapper.keyValueMap = this.keyValueMap;
                    this.pageLayoutWrapper.listValueMap = this.listValueMap;
                    this.pageLayoutWrapper.allowedCharsForRichTextArea = this._pageLayoutWrapperHolder.allowedCharsForRichTextArea;
                    this.pageLayoutWrapper.warningCharsForRichTextArea = this._pageLayoutWrapperHolder.warningCharsForRichTextArea;
                    this.pageLayoutWrapper.allowedWordsForRichTextArea = this._pageLayoutWrapperHolder.allowedWordsForRichTextArea;
                    this.pageLayoutWrapper.warningWordsForRichTextArea = this._pageLayoutWrapperHolder.warningWordsForRichTextArea;
                    this.pageLayoutWrapper.showCharLimit = this._pageLayoutWrapperHolder.showCharLimit;
                    this.pageLayoutWrapper.showCharLimitWarning = this._pageLayoutWrapperHolder.showCharLimitWarning;
                    this.pageLayoutWrapper.showWordLimit = this._pageLayoutWrapperHolder.showWordLimit;
                    this.pageLayoutWrapper.showWordLimitWarning = this._pageLayoutWrapperHolder.showWordLimitWarning;
                    this.pageLayoutWrapper.autoSnapShotFieldAPIName = this._pageLayoutWrapperHolder.autoSnapShotFieldAPIName;

                    this.firstCallToTabs = true;
                }
            })
            .catch((error) => {
                console.error("error in ccb", JSON.stringify(error));
                this.showConfigError = true;
            });

        this.subscribeToMessageChannel();
    }

    handleMessage(message) {
        if (this.pageLayoutWrapper?.pageLayoutId === message.data.pageLayoutId) {
            if (message.data.actionType == "Edit") {
                this.isView = false;
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "Edit");
                this.refreshTabsDetail(this.isView);
                this.refreshPgBlocks(this.isView);
            } else if (message.data.actionType == "Save") {
                this.showSpinner = true;
            } else if (message.data.actionType == "Cancel") {
                this.isView = true;
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "View");
                this.refreshTabsDetail(this.isView);
                this.refreshPgBlocks(this.isView);
            } else if (message.data.isSaved) {
                this.isView = true;
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "View");
                this.showTabs = false;
                this.activeTabId = message.data.activeTabId;
                //this.showTabs = true;
                setTimeout(() => {
                    this.showTabs = true;
                }, 0);
                // this.refreshTabsDetail(this.isView);
                //this.refreshPgBlocks(this.isView);
            } else if (message.data.refreshEntirePage) {
                this.refreshTabsDetail(this.isView);
                this.refreshStepProgressBar();
            }
        } else if (message.data.refreshEntirePage) {
            this.refreshTabsDetail(this.isView);
            this.refreshStepProgressBar();
        }
    }

    refreshTabsDetail(isView) {
        this.firstCallToTabs = false;
        const payload = {
            data: {
                refreshTabsDetail: true,
                isView: isView,
                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
    }

    async isUserInCommunity() {
        return new Promise((resolve) => {
            getCommunityBaseUrl()
                .then((data) => {
                    if (data != null) {
                        this.isCommunitySite = true;
                        this.communityBaseUrl = data;
                    }
                    resolve();
                })
                .catch((error) => {
                    resolve();
                });
        });
    }

    refreshPgBlocks(isView) {
        const payload = {
            data: {
                refreshPgBlocks: true,
                isView: isView,
                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
    }

    refreshStepProgressBar() {
        const payload = {
            source: "LWC-from headeroverview after approvalComponent action",
            data: {
                refreshStepProgressBar: true
            }
        };
        publish(this.messageContext, messageChannel, payload);
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

    isJsonString(str) {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
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
}