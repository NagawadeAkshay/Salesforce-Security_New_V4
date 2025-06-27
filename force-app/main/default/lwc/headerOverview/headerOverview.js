import { LightningElement, api, track, wire } from "lwc";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";
import { subscribe, unsubscribe, publish, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import getPageTemplateDetails from "@salesforce/apex/FlexLayoutController.getPageTemplateDetails";
import getHeaderDetails from "@salesforce/apex/FlexLayoutController.getHeaderDetails";
import getApprovalOptions from "@salesforce/apex/ApprovalDecisionCtrl.getApprovalOptionsLightning";
import GOVGRANTS from "@salesforce/resourceUrl/GovGrants";
import { loadStyle } from "lightning/platformResourceLoader";
import getCommunityBaseUrl from "@salesforce/apex/AppUtils.getCommunityBaseUrl";
import userId from "@salesforce/user/Id";
import isGuestUser from "@salesforce/user/isGuest";

export default class HeaderOverview extends NavigationMixin(LightningElement) {
    @api showStepProgressBar;
    @api showHeaderInstructions;
    @api enableStepProgressBar;
    @api enableHeaderInstructions;
    @api enablePageMessages;
    @api enableStickyHeader;
    @api pageLayoutWrapper;
    @api recordId;
    @api guestRecordId;
    @api isModal;
    @api showAllStages;
    @api pageTemplateName;
    @api isSplitView = false;

    isView = true;
    @wire(MessageContext)
    messageContext;
    @api context = "View";
    headerTabId;
    //pageLayoutName = "";
    pageTemplateId = "";
    showConfigError = false;
    hasHeaderInstructions = false;
    headerUpperTitle = "";
    headerLowerTitle = "";
    currentPageReference = "";
    pageMessageList;
    messageTimeOut;
    messageTimeOutEnabled;
    bannerPageMessages;
    showBannerPageMessages;
    isBannerMsg = false;
    keyValueMap = {};
    listValueMap;
    formName;
    nameSpace;
    recordSendToowner = false;
    approvalDecisionMessage = "";
    showApprovalComponent = false;
    isDelegate = false;
    approvalOptions;
    isTabAvailable = false;
    communityBaseUrl = null;
    isCommunitySite = false;

    get actionButtonClass() {
        if (this.enableStepProgressBar && this.pageLayoutWrapper.stepProgressGroupName) {
            return "slds-col slds-size_2-of-7";
        } else {
            return "slds-col slds-size_3-of-7";
        }
    }

    get pageTitleClass() {
        if (this.enableStepProgressBar && this.pageLayoutWrapper.stepProgressGroupName) {
            return "slds-col slds-size_2-of-7 slds-page-header__col-title";
        } else {
            return "slds-col slds-size_4-of-7 slds-page-header__col-title";
        }
    }

    get pageHeaderClass() {
        if (this.enableStickyHeader) {
            return "slds-page-header__row header-row-padding headerposition";
        } else {
            return "slds-page-header__row header-row-padding ";
        }
    }

    get pageBlockSectionClass() {
        if (this.enableStickyHeader) {
            return "pageblksect";
        } else {
            return "";
        }
    }

    get topPageHeaderClass(){
        if(!this.isTabAvailable){
            return "slds-page-header header-overview-padd tabsection-padd"
        }else{
            return "slds-page-header header-overview-padd";
        }
    }

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
            if (this.currentPageReference.state.c__Mode && this.currentPageReference.state.c__Mode == "edit") {
                this.context = "Edit";
            }
        }
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
            this.context = "View";
        } else {
            this.isView = false;
            this.context = "Edit";
        }
        this.subscribeToMessageChannel();
        loadStyle(this, GOVGRANTS + "/Component/CSS/flexviewlayoutLwc.css").then(() => {
        });

        await this.isUserInCommunity();

        //  this.headerTabId = 'a1A1K000007AXNo';
        if (this.pageLayoutWrapper != undefined) {
            getHeaderDetails({
                templateId: this.pageLayoutWrapper.pageLayoutId,
                recId: this.recordId,
                keyValueMapString: this.pageLayoutWrapper.keyValueMap,
                isViewContext: this.context == "Edit" ? false : true
            })
                .then((data) => {
                    let dataObject = JSON.parse(data);
                    if (dataObject.isError) {
                        console.error(dataObject.errorMessage);
                        this.showConfigError = true;
                        this.isModal = this.isModal != true ? false : true;
                    } else {
                        this.pageLayoutWrapper = dataObject;
                        this.pageLayoutWrapper.formName = this.formName;
                        this.pageLayoutWrapper.nameSpace = this.nameSpace;
                        this.pageLayoutWrapper.keyValueMap = this.keyValueMap;
                        this.pageLayoutWrapper.listValueMap = this.listValueMap;
                        this.bannerPageMessages = dataObject.pageMessageList;
                        this.showBannerPageMessages = this.bannerPageMessages.length>0 ? true : false;
                        this.bannerPageMessages?.forEach((message) => {
                            message.messageTimeOutEnabled = message.messageTimeOut ? true : false;
                            message.messageList = [{ messageType: message.messageType, messageBody: message.messageBody }];
                            this.isBannerMsg = true;
                        });
                        if (this.pageLayoutWrapper.tabs) {
                            this.headerTabId = this.pageLayoutWrapper.tabs[0].id;
                            this.isTabAvailable = true;
                            if (this.pageLayoutWrapper.headerTitle) {
                                this.headerUpperTitle = this.pageLayoutWrapper.headerTitle.splice(0, 1);
                                this.headerLowerTitle = this.pageLayoutWrapper.headerTitle.splice(0);
                            }
                            if (this.pageLayoutWrapper.headerInstructions) {
                                this.hasHeaderInstructions = true;
                            }
                        } else {
                            this.pageLayoutWrapper = null;
                            this.headerTabId = null;
                            this.showConfigError = true;
                            this.isModal = this.isModal != true ? false : true;
                        }
                    }
                })
                .catch((error) => {
                    this.ErrorMessage = error;
                });
        } else {
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
                        this.isModal = this.isModal != true ? false : true;
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
                        //this.pageLayoutName = dataObject.pageLayoutName;
                        this.pageTemplateId = dataObject.pageLayoutId;
                        this.formName = dataObject.formName;
                        this.nameSpace = dataObject.nameSpace;
                        this.keyValueMap = dataObject.keyValueMap;
                        this.listValueMap = dataObject.listValueMap;
                        this.messageTimeOut = dataObject.messageTimeOut;
                        this.messageTimeOutEnabled = dataObject.messageTimeOutEnabled;
                        if (dataObject.pageMessageList && dataObject.pageMessageList.length > 0) {
                            this.pageMessageList = dataObject.pageMessageList;
                            if (!this.enablePageMessages) {
                                this.publishPageMessages();
                            }
                        }
                        return getHeaderDetails({
                            templateId: this.pageTemplateId,
                            recId: this.recordId,
                            keyValueMapString: this.keyValueMap,
                            isViewContext: this.context == "Edit" ? false : true
                        });
                    }
                })
                .then((data) => {
                    let dataObject = this.isJsonString(data) ? JSON.parse(data) : data;
                    if (dataObject != undefined) {
                        if (dataObject.isError) {
                            console.error(dataObject.errorMessage);
                            this.showConfigError = true;
                            this.isModal = this.isModal != true ? false : true;
                        } else {
                            this.pageLayoutWrapper = dataObject;
                            this.pageLayoutWrapper.formName = this.formName;
                            this.pageLayoutWrapper.nameSpace = this.nameSpace;
                            this.pageLayoutWrapper.keyValueMap = this.keyValueMap;
                            this.pageLayoutWrapper.listValueMap = this.listValueMap;
                            this.bannerPageMessages = dataObject.pageMessageList;
                            this.showBannerPageMessages = this.bannerPageMessages.length>0 ? true : false;
                            this.bannerPageMessages?.forEach((message) => {
                                message.messageTimeOutEnabled = message.messageTimeOut ? true : false;
                                message.messageList = [{ messageType: message.messageType, messageBody: message.messageBody }];
                                this.isBannerMsg = true;
                            });
                            if (this.pageLayoutWrapper.tabs) {
                                this.headerTabId = this.pageLayoutWrapper.tabs[0].id;
                                this.isTabAvailable = true;
                                if (this.pageLayoutWrapper.headerTitle) {
                                    this.headerUpperTitle = this.pageLayoutWrapper.headerTitle.splice(0, 1);
                                    this.headerLowerTitle = this.pageLayoutWrapper.headerTitle.splice(0);
                                }
                                if (this.pageLayoutWrapper.headerInstructions) {
                                    this.hasHeaderInstructions = true;
                                }
                            } else {
                                if (this.pageLayoutWrapper.headerTitle) {
                                    this.headerUpperTitle = this.pageLayoutWrapper.headerTitle.splice(0, 1);
                                    this.headerLowerTitle = this.pageLayoutWrapper.headerTitle.splice(0);
                                }
                                if (this.pageLayoutWrapper.headerInstructions) {
                                    this.hasHeaderInstructions = true;
                                }
                                this.isModal = this.isModal != true ? false : true;
                            }
                        }
                    }
                })
                .catch((error) => {
                    console.error("error header's in ccb", JSON.stringify(error));
                    this.showConfigError = true;
                    this.isModal = this.isModal != true ? false : true;
                });
        }
        this.getApprovalDecisionComponentDetails();
    }

    getApprovalDecisionComponentDetails() {
        getApprovalOptions({ recordId: this.recordId, layoutContext: this.context })
            .then((data) => {
                if (data.recordSendToowner) {
                    this.recordSendToowner = true;
                    this.approvalDecisionMessage = "" + data.msgList;
                }
                this.showApprovalComponent = data.RenderComponent;
                this.approvalOptions = data.Options;
                this.isDelegate = data.IsDelegate;
                if (this.isDelegate) {
                    this.approvalOptions.forEach((value) => {
                        if (value.Action === "Reassign") {
                            this.approvalOptions.splice(this.approvalOptions.indexOf(value), 1);
                        }
                    });
                }
            })
            .catch((error) => {
            });
    }

    setPageMessages(event) {
        this.pageMessageList = event.detail.pageMessageList;
        if (!this.enablePageMessages) {
            this.publishPageMessages();
        }
        // this.messageTimeOut = event.detail.messageTimeOut;
        // this.messageTimeOutEnabled = event.detail.messageTimeOutEnabled;
    }

    handleMessage(message) {
        if (this.pageLayoutWrapper?.pageLayoutId === message.data.pageLayoutId) {
            if (message.data.actionType == "Edit") {
                this.isView = false;
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "Edit");
            } else if (message.data.actionType == "Cancel") {
                this.isView = true;
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "View");
            } else if (message.data.isSaved) {
                this.isView = true;
                sessionStorage.setItem(`currentContext_${this.recordId}_${userId}`, "View");
                this.refreshHeaderTitle();
            }
        }
    }

    refreshHeaderTitle() {
        getHeaderDetails({
            templateId: this.pageTemplateId,
            recId: this.recordId,
            keyValueMapString: this.keyValueMap,
            isViewContext: this.context == "Edit" ? false : true
        })
            .then((data) => {
                let dataObject = this.isJsonString(data) ? JSON.parse(data) : data;
                if (dataObject != undefined) {
                    if (dataObject.isError) {
                        console.error(dataObject.errorMessage);
                        this.showConfigError = true;
                        this.isModal = this.isModal != true ? false : true;
                    } else {
                        if (dataObject.headerTitle) {
                            this.headerUpperTitle = dataObject.headerTitle.splice(0, 1);
                            this.headerLowerTitle = dataObject.headerTitle.splice(0);
                        }
                    }
                }
            })
            .catch((error) => {
            });
    }

    async refreshApprovalComponent(event) {
        if (event.detail.refreshTabs) {
            const payload = {
                source: "LWC-from headeroverview after approval snapshot",
                data: {
                    refreshTabsDetail: true,
                    isView: this.isView
                }
            };
           publish(this.messageContext, messageChannel, payload);
        } else {
            let pageMessages = [];
            if (typeof event.detail.messages === "string") {
                pageMessages.push({ messageType: event.detail.type, messageBody: event.detail.messages });
            } else {
                event.detail.messages.forEach((msg) => {
                    pageMessages.push({ messageType: event.detail.type, messageBody: msg });
                });
            }
            this.pageMessageList = pageMessages;
            this.messageTimeOutEnabled = true;
            if (!this.enablePageMessages) {
                this.publishPageMessages();
            }
            this.getApprovalDecisionComponentDetails();
            const payload = {
                source: "LWC-from headeroverview after approvalComponent action",
                data: {
                    refreshEntirePage: true,
                    pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                }
            };
            publish(this.messageContext, messageChannel, payload);
            await notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
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

    subscribeToMessageChannel() {
        if (this.subscription) {
            return;
        } else {
            this.subscription = subscribe(this.messageContext, messageChannel, (message) => this.handleMessage(message), {
                scope: APPLICATION_SCOPE
            });
        }
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

    isJsonString(str) {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    publishPageMessages() {
        const payload = {
            source: "LWC-from header overview",
            data: {
                showPageMessage: true,
                pageMessageList: this.pageMessageList,
                messageTimeOut: this.messageTimeOut,
                messageTimeOutEnabled: this.messageTimeOutEnabled
            }
        };
        publish(this.messageContext, messageChannel, payload);
    }

    onUpdateHeaderProgbarStyle(event) {
        if (this.enableStepProgressBar && this.pageLayoutWrapper.stepProgressGroupName) {
            const progressbarDivElement = this.template.querySelector('[data-id="progressbarDiv"]');
            // if (this.showAllStages) {
            //     progressbarDivElement.style.display = 'inline-block';
            // }
            if (event.detail.stagesLength >= 6) {
                const extraLenghtCount = event.detail.stagesLength - 6; // 6 means default length of progressbar div
                const scaleValue = (0.1 * (10 - extraLenghtCount)) - 0.09; // 10 means 100% scale
                progressbarDivElement.style.transform = 'scale(' + scaleValue + ')';
                progressbarDivElement.style.transformOrigin = 'left top';
                if (this.showAllStages) {
                    progressbarDivElement.style.display = 'inline-block';
                }
            }
        }
    }
}