import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";

export default class ReferenceField extends LightningElement {
    @api
    mode;
    @api
    fieldDetails;
    @api
    fieldInHeader;
    @wire(MessageContext)
    messageContext;

    get isView() {
        return this.mode == "view" ? true : false;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
       
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

    handleMessage(message) {
        if (!this.fieldInHeader) {
            if (message.data.actionType == "Save") {
                this.handleSaveClick();
            }
        }
    }

    handleSaveClick() {
        this.template.querySelectorAll("lightning-record-edit-form").forEach((element) => {
            element.submit();
        });
    }

    handleError(event) {
        let errorMessage =
            (event.detail.message !== null) & (event.detail.message !== undefined)
                ? JSON.stringify(event.detail.message)
                : "Error encountered while saving the record.Please try again.";
        const showToastEvent = new ShowToastEvent({
            title: "Error",
            message: errorMessage,
            variant: "error",
            duration: 10000
        });
        this.dispatchEvent(showToastEvent);
    }

    handleSuccess(event){
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}