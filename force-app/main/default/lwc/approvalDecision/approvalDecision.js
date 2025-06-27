import { LightningElement, api,wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import confirmModal from "c/confirmModalLwc";
import getReassignmentList from "@salesforce/apex/ApprovalDecisionCtrl.getUserQueueRecordsLightning";
import performAction from "@salesforce/apex/ApprovalDecisionCtrl.submitRecordsLightning";
import generateSnapshotOnApproval from "@salesforce/apex/ApprovalDecisionCtrl.generateSnapshotOnApproval";
import geticons from "@salesforce/apex/AppUtils.getIcons";
import GOVGRANTS from "@salesforce/resourceUrl/GovGrants";
import { loadStyle } from "lightning/platformResourceLoader";
import { subscribe, unsubscribe, publish, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import approvalComponentDecisionHeader from "@salesforce/label/c.ApprovalComponentDecisionHeader";
import DelagtedApprovalComponentDecisionHeader from "@salesforce/label/c.DelagtedApprovalComponentDecisionHeader";

export default class ApprovalDecision extends LightningElement {
    @api recordId;
    @api context;
    @api listValueMap;
    @api keyValueMap;
    @api approvalOptions;
    @api isDelegate;
    @api pageLayoutId;
	@api templateName;
    @api charLimitMap;
    @api messageTimeOut;
    @api messageTimeOutEnabled;
    pageMessageList=[];
    label = approvalComponentDecisionHeader;
    govGrantPleaseWaitIcon = "";
    showSpinner = false;
    selectRessignParams = {};
    selectedReassignId;
    radioButtonOptions = [];
    selectedOption;
    selectedComment;
    chosenUserId;
    ShowComponent = false;
    isReassignSelected = false;
    isCommentsshown = false;
    warningMessage;
    commentRequired;
    errorMessage;
    title;
    subscription = null;
    @wire(MessageContext)
    messageContext;
    
    @api
    get pbTitle() {
        return this.title;
    }

    set pbTitle(value) {
        this.title = value != "" ? value : "Approval Decision";
    }
    optionsToReassign = [];

    handleReassignChange(event) {
        this.selectedReassignId = event.detail.reassignTo;
    }

    connectedCallback() {
       this.subscribeToMessageChannel();
        loadStyle(this, GOVGRANTS + "/Component/CSS/flexviewlayoutLwc.css").then(() => {
        });

        geticons({ strResourceName: "govGrantPleaseWaitIcon" })
            .then((result) => {
                if (result) {
                    this.govGrantPleaseWaitIcon = result;
                }
            })
            .catch((error) => {
            });

        this.selectRessignParams.flexTableParameters = this.keyValueMap;
        this.selectRessignParams.listParameters = this.listValueMap;

        if (this.isDelegate) {
            this.label = this.label + " " + DelagtedApprovalComponentDecisionHeader;
        }

        if (this.approvalOptions) {
            this.approvalOptions.forEach((value) => {
                let tempObj = {};
                tempObj["label"] = value.Label;
                tempObj["value"] = value.Action;
                this.radioButtonOptions.push(tempObj);
                if (value.Action === "Reassign") {
                    this.selectRessignParams.filterClause = value.filterClause;
                    this.selectRessignParams.queueFilterClause = value.QueueFilterClause;
                    this.selectRessignParams.queueOption = value.QueueOption;
                }
            });
        }
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    refreshActions() {
        const payload = {
            source: "LWC-from after Approval Actions",
            data: {
                isApprovalActions: true,
                pageLayoutId: this.pageLayoutId
            }
        };
        publish(this.messageContext, messageChannel, payload);
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

    handleMessage(message) {
        // if(this.layoutId === message.data.pageLayoutId){
        //     this.refreshActions();
        // }
    }

    getReassignmentOptions() {
        this.showSpinner = true;
        return new Promise((resolve) => {
            if (this.optionsToReassign.length > 0) {
                this.showSpinner = false;
                resolve();
            } else {
                getReassignmentList({ paramMap: this.selectRessignParams })
                    .then((data) => {
                        data.SobjList.forEach((value) => {
                            let tempObj = {};
                            tempObj["label"] = value.text;
                            tempObj["value"] = value.id;
                            this.optionsToReassign.push(tempObj);
                        });
                        this.showSpinner = false;
                        resolve();
                    })
                    .catch((error) => {
                        this.showSpinner = false;
                    });
            }
        });
    }

    async handleActionSelection(event) {
        //let selectedOption1;
        this.approvalOptions.forEach((option) => {
            if (option["Action"] == event.detail.value) {
                this.selectedOption = option;
            }
        });

        this.selectedOption.CommentRequired === "true" ? (this.commentRequired = true) : (this.commentRequired = false);

        if (this.selectedOption.Action == "Reassign") {
            await this.getReassignmentOptions();
            this.isReassignSelected = true;
            this.isCommentsshown = true;
        } else {
            this.isReassignSelected = false;
            this.isCommentsshown = true;
        }
    }

    addComment(event) {
        this.selectedComment = event.target.value;
    }

    async handleSubmit(event) {
        if (this.selectedOption == undefined) {
            this.handleError("Please select appropriate action before submitting.");
            return;
        }
        if (this.selectedComment?.length > 4000) {
            this.handleError("Comments: data value too large.");
            return;
        }

        let proceed = await this.forConfirmationMessage(this.selectedOption);
        if (proceed) {
            if (this.selectedOption["Action"] === "Reassign" && !this.selectedReassignId) {
                this.handleError("Please Select user.");
            } else {
                if (this.selectedOption["CommentRequired"] === "true") {
                    if (this.selectedComment != undefined && this.selectedComment != "") {
                        this.performActionApprovalAction();
                    } else {
                        this.errorMessage = "Comments are Required.";
                        this.handleError(this.errorMessage);
                    }
                } else {
                    this.performActionApprovalAction();
                }
            }
        }
    }

    performActionApprovalAction() {
        this.showSpinner = true;
        performAction({ action: this.selectedOption.Action, recordId: this.recordId, comment: this.selectedComment, chosenUsersId: this.selectedReassignId })
            .then((data) => {
                if (data.Success === true) {
                    this.dispatchEvent(new CustomEvent("after_approval_event", { detail: { messages: data.msgList, type: "confirm" } }));
					this.createSnapshot();
                } else if (data.Success === false) {
                    this.dispatchEvent(new CustomEvent("after_approval_event", { detail: { messages: data.Message, type: "error" } }));
                }
                this.showSpinner = false;
                this.refreshActions();
            })
            .catch((error) => {
                this.showSpinner = false;
            });
    }
	
	createSnapshot() {
        generateSnapshotOnApproval({
            parentId: this.recordId,
            templateName: this.templateName,
            flexTableParam: this.keyValueMap,
            listParam: this.listValueMap
        })
            .then((data) => {
                if (data.Success == true) {
                    this.dispatchEvent(new CustomEvent("after_approval_event", { detail: { refreshTabs: true } }));
                } else {
                    this.dispatchEvent(new CustomEvent("after_approval_event", { detail: { messages: data.Message, type: "error" } }));
                }
            })
            .catch((error) => {
            });
    }

    async forConfirmationMessage(selectedOption) {
        if (selectedOption["ConfirmationMessage"]) {
            let title = selectedOption["ConfirmationTitle"] ? selectedOption["ConfirmationTitle"] : "";
            const result = await confirmModal.open({
                message: selectedOption["ConfirmationMessage"],
                label: title,
                size: "small"
            });
            return result;
        }
        return true;
    }

    handleError(errorMessage) {
        const showToastEvent = new ShowToastEvent({ title: "Error", message: errorMessage, variant: "error", duration: 10000 });
        this.dispatchEvent(showToastEvent);
    }
}