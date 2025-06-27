import { LightningElement, api, track, wire } from "lwc";
import parseErrorMessageList from "@salesforce/apex/AppUtils.parseErrorMessageList";
import { subscribe, unsubscribe, APPLICATION_SCOPE, publish, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";

export default class FlexLayoutPageMessages extends LightningElement {
    pageMessageSetConfirm = new Set();
    pageMessageSetError = new Set();
    pageMessageSetInfo = new Set();
    pageMessageSetWarning = new Set();
    showConfirmMessages = false;
    showErrorMessages = false;
    showInfoMessages = false;
    showWarningMessages = false;
    @wire(MessageContext)
    messageContext;
    pageMessage = new Set();
    @track
    pageMessages = [];
    showMessages = false;
    stickypagemsg = "";
    callToParseMsg = false;
    @api enableStickyPageMessages;
    @api enablePageMessages;
    @api messageTimeOut;
    @api messageTimeOutEnabled;
    @api isBannerMsg;
    @api
    get pageMessageList() {
        return this._pageMessageList;
    }
    set pageMessageList(value) {
        return new Promise(async (resolve) => {
            this.callToParseMsg = false;
            this.handleMessageCloseClick();
            this._pageMessageList = value;
            if (this._pageMessageList) {
                this._pageMessageList = this._pageMessageList.filter((message) => message.messageBody !== "");
                this.callToParseMsg = this._pageMessageList.some(
                    (message) =>
                        message.messageType.toLowerCase() == "error" ||
                        message.messageType.toLowerCase() == "fatal" ||
                        message.messageType.toLowerCase() == "danger"
                );
                await this.addPageMessage(this._pageMessageList);
                this.showAvailablePageMessages();
                this.hideAvailablePageMessages();
                resolve();
            }
        });
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
        if (!this.enablePageMessages && this.enableStickyPageMessages) {
            this.stickypagemsg = "pagemsg";
        }
    }

    async addPageMessage(pageMessageList) {
        //clearing old messages
        this.pageMessageSetConfirm.clear();
        this.pageMessageSetError.clear();
        this.pageMessageSetWarning.clear();
        this.pageMessageSetInfo.clear();

        let pageMessageSet = new Set();
        if (this.callToParseMsg) {
            pageMessageList = await this.parseException(pageMessageList);
        }

        for (const pgMessage of pageMessageList) {
            if (!pageMessageSet.has(pgMessage.messageBody)) {
                pageMessageSet.add(pgMessage.messageBody);
                if (pgMessage.messageType.toLowerCase() == "confirm" || pgMessage.messageType.toLowerCase() == "success") {
                    this.pageMessageSetConfirm.add(pgMessage.messageBody);
                } else if (
                    pgMessage.messageType.toLowerCase() == "error" ||
                    pgMessage.messageType.toLowerCase() == "fatal" ||
                    pgMessage.messageType.toLowerCase() == "danger"
                ) {
                    this.pageMessageSetError.add(pgMessage.messageBody);
                } else if (pgMessage.messageType.toLowerCase() == "warning" || pgMessage.messageType.toLowerCase() == "alert") {
                    this.pageMessageSetWarning.add(pgMessage.messageBody);
                } else {
                    this.pageMessageSetInfo.add(pgMessage.messageBody);
                }
            }
        }
    }

    showAvailablePageMessages() {
        if (this.pageMessageSetConfirm.size > 0) {
            this.showMessages = true;
            let messageEntry = { classType: "page-message-confirm", pageMessageList: this.pageMessageSetConfirm };
            this.pageMessages.push(messageEntry);
        }
        if (this.pageMessageSetError.size > 0) {
            this.showMessages = true;
            let messageEntry1 = { classType: "page-message-error", pageMessageList: this.pageMessageSetError };
            this.pageMessages.push(messageEntry1);
        }
        if (this.pageMessageSetInfo.size > 0) {
            this.showMessages = true;
            let messageEntry2 = { classType: "page-message-info", pageMessageList: this.pageMessageSetInfo };
            this.pageMessages.push(messageEntry2);
        }
        if (this.pageMessageSetWarning.size > 0) {
            this.showMessages = true;
            let messageEntry3 = { classType: "page-message-warning", pageMessageList: this.pageMessageSetWarning };
            this.pageMessages.push(messageEntry3);
        }
    }

    hideAvailablePageMessages() {
        if (this.messageTimeOutEnabled) {
            if (!this.messageTimeOut) {
                this.messageTimeOut = 4000;
            }

            setTimeout(() => {
                this.showMessages = false;
                this.pageMessage.clear();
            }, this.messageTimeOut);
        }
    }

    handleMessageCloseClick(event) {
        if (event) {
            const index = event.target.dataset.index;
            this.pageMessages.splice(index, 1);
            this.pageMessages = [...this.pageMessages];
        } else {
            this.pageMessages = [];
        }
    }

    async parseException(pageMessageList) {
        return new Promise((resolve) => {
            parseErrorMessageList({ pageMessageListString: JSON.stringify(pageMessageList) })
                .then((data) => {
                    resolve(JSON.parse(data));
                })
                .catch((error) => {
                    console.error("error while parsing exception", JSON.stringify(error));
                    resolve(messageBody);
                });
        });
    }

    handleMessage(message) {
        if (message.data.showPageMessage && !this.isBannerMsg) {
            this.messageTimeOut = message.data.messageTimeOut;
            this.messageTimeOutEnabled = message.data.messageTimeOutEnabled;
            this.pageMessageList = message.data.pageMessageList;
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

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}