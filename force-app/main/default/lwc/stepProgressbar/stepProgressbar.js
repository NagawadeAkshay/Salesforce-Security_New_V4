import { LightningElement, wire, track, api } from "lwc";
import Stepprogressbarlwc from "@salesforce/resourceUrl/GovGrants";
import { loadStyle } from "lightning/platformResourceLoader";
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import { CurrentPageReference } from "lightning/navigation";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import getPageTemplateDetails from "@salesforce/apex/FlexLayoutController.getPageTemplateDetails";
import getProgressBarAndHeaderInst from "@salesforce/apex/FlexLayoutController.getProgressBarAndHeaderInst";
import fetchorderedList from "@salesforce/apex/StepProgressbarCtrl.fetchorderedListLwc";
export default class StepProgressbar extends LightningElement {
    pageTemplateId = "";
    currentPageReference = "";
    showConfigError = false;
    resultList = [];
    currentStatus;
    isData = false;
    @api sobjectName;
    @api groupName;
    @api recordId;
    @api showAllStages;
    @wire(MessageContext)
    messageContext;
    error = false;
    keyisHistroy = false;
    keyCreatedBy;
    styleClass;
    keyCreatedDate;

    //variables for 3 stages path
    @track resultListForUI = [];
    currentStepIdx;
    firstStepIdx;
    lastStepIdx;
    isDisablePreviousBtn = false;
    isDisableNextBtn = false;
    showPreNxtButton=true;

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

    connectedCallback() {
        this.subscribeToMessageChannel();
        loadStyle(this, Stepprogressbarlwc + "/Component/CSS/Stepprogressbarlwc.css").then(() => {
        });

        if (!this.groupName || !this.sobjectName) {
            getPageTemplateDetails({
                recId: this.recordId,
                templateName: null,
                urlVal: JSON.stringify(this.currentPageReference)
            })
                .then((data) => {
                    let dataObject = JSON.parse(data);
                    if (dataObject.isError) {
                        console.error(dataObject.errorMessage);
                        this.showConfigError = true;
                    } else {
                        this.pageTemplateId = dataObject.pageLayoutId;
                        return getProgressBarAndHeaderInst({
                            templateId: this.pageTemplateId,
                            recId: this.recordId
                        });
                    }
                })
                .then((data) => {
                    let dataObject = JSON.parse(data);
                    if (dataObject.isError) {
                        console.error(dataObject.errorMessage);
                        this.showConfigError = true;
                    } else {
                        this.sobjectName = dataObject.objectName;
                        this.groupName = dataObject.stepProgressGroupName;
                        this.fetchOrderedList();
                    }
                })
                .catch((error) => {
                    console.error("error step progress bar", JSON.stringify(error));
                    this.showConfigError = true;
                });
        } else {
            this.fetchOrderedList();
        }
    }

    fetchOrderedList() {
        fetchorderedList({ sobjectName: this.sobjectName, groupName: this.groupName, recordId: this.recordId })
            .then((data) => {
                if (data) {
                    this.currentStatus = data.currentStatus[0];
                    this.resultList = JSON.parse(JSON.stringify(data.resultList));
                    if (this.resultList) {
                        this.resultList.forEach((item) => (item["isHistroy"] = false));
                    }
                    for (let i = 0; i < data.resultList.length; i++) {
                        if (data.history[0][data.resultList[i].picklistVal]) {
                            this.resultList[i].isHistroy = true;
                            if (data.history[0][data.resultList[i].picklistVal] != undefined) {
                                this.resultList[i].CreatedBy = data.history[0][data.resultList[i].picklistVal].CreatedBy;
                                const date1 = new Date(data.history[0][data.resultList[i].picklistVal].CreatedDate);
                                const formattedDate = date1.toLocaleString(data.locale[0].replace("_", "-"), {
                                    day: "numeric",
                                    month: "numeric",
                                    year: "numeric",
                                    hour: "numeric",
                                    minute: "2-digit",
                                    timeZone: data.timeZone[0]
                                });
                                this.resultList[i].CreatedDate = formattedDate;
                            }
                        }
                        this.resultList[i].styleClass = "ModelTooltip" + this.resultList[i].picklistVal.replaceAll(" ", "_");
                        this.resultList[i].hasError = this.resultList[i].clrCode == 3 ? true : false;
                        if (this.resultList[i].CreatedBy && this.resultList[i].CreatedDate) {
                        //     this.resultList[i].title = `By: ${this.resultList[i].CreatedBy} ,Date: ${this.resultList[i].CreatedDate}`;
                        // } else {
                        //     this.resultList[i].title = "";
                        // }
                        this.resultList[i].title = this.resultList[i].displayName + "\u000d" +`By: ${this.resultList[i].CreatedBy}, Date: ${this.resultList[i].CreatedDate}`;
                        } else {
                            this.resultList[i].title = this.resultList[i].displayName;
                        }
                    }
                    this.isData = true;

                    //for make resultlist for UI (for 3 stages path)
                    if (this.resultList.length > 0 && this.showAllStages==false) {                     
                        this.resultListForUI=[];
                        
                        let currentStepIdx = this.resultList.findIndex((result) => result.picklistVal == this.currentStatus);
                        if(currentStepIdx != -1){
                            this.currentStepIdx = currentStepIdx;
                        }
                        if (this.currentStepIdx == 0) {
                            this.firstStepIdx = this.currentStepIdx;
                            this.lastStepIdx = this.currentStepIdx + 2;
                        }
                        else if (this.currentStepIdx == this.resultList.length - 1) {
                            this.firstStepIdx = this.resultList.length - 3;
                            this.lastStepIdx = this.currentStepIdx;
                        }
                        else {
                            this.firstStepIdx = this.currentStepIdx - 1;
                            this.lastStepIdx = this.currentStepIdx + 1;
                        }

                        for (let i = 0; i < this.resultList.length; i++) {
                            if (this.currentStepIdx == i) {
                                this.resultList[i].isCurrent = true;
                            }
                            else if (i < this.currentStepIdx) {
                                this.resultList[i].isCompleted = true;
                            }
                            else if (i > this.currentStepIdx) {
                                this.resultList[i].isUpcoming = true;
                            }
                            if (i >= this.firstStepIdx && i <= this.lastStepIdx) {
                                this.resultListForUI.push(this.resultList[i]);
                            }
                        }
                        this.isDisablePreviousBtn = this.firstStepIdx == 0 ? true : false;
                        this.isDisableNextBtn = this.lastStepIdx == this.resultList.length - 1 ? true : false;
                        this.showPreNxtButton= this.resultList.length > 3 ? true:false;
                    }
                    if (this.resultList && this.showAllStages) {
                        this.dispatchEvent(new CustomEvent('updateheaderprogbarstyle', {
                            detail: {
                                stagesLength: this.resultList.length
                            }
                        }));
                    }
                }
            })
            .catch((error) => {
                this.error = error;
                this.showConfigError = true;
            });
    }

    handleMessage(message) {
        if (message.data.refreshStepProgressBar) {
            this.fetchOrderedList();
        }
    }

    showPreviousStep(event) {
        if (this.firstStepIdx > 0) {
            this.resultListForUI.pop(); //for remove last record
            this.lastStepIdx--;
            this.firstStepIdx--;
            this.resultListForUI.unshift(this.resultList[this.firstStepIdx]); //for add element at top
            this.isDisablePreviousBtn = this.firstStepIdx == 0 ? true : false;
            this.isDisableNextBtn = this.lastStepIdx == this.resultList.length - 1 ? true : false;
        }
    }
    showNextStep(event) {
        if (this.lastStepIdx < this.resultList.length - 1) {
            this.resultListForUI.shift(); //for remove first record
            this.lastStepIdx++;
            this.firstStepIdx++;
            this.resultListForUI.push(this.resultList[this.lastStepIdx]);
            this.isDisablePreviousBtn = this.firstStepIdx == 0 ? true : false;
            this.isDisableNextBtn = this.lastStepIdx == this.resultList.length - 1 ? true : false;
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