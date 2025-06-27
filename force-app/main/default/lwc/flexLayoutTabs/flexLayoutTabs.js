import { LightningElement, api, track, wire } from "lwc";
import { subscribe, unsubscribe, publish, APPLICATION_SCOPE, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import getPageLayoutTabs from "@salesforce/apex/FlexLayoutController.getPageLayoutTabs";
import requiredForSubmitOrSave from "@salesforce/apex/FlexLayoutController.requiredForSubmitOrSave";
import saveForGuestUser from "@salesforce/apex/SystemContextMethodsHelper.saveForGuestUser";
import GOVGRANTS from "@salesforce/resourceUrl/GovGrants";
import initiateAutoSnapshot from "@salesforce/apex/FlexLayoutController.initiateAutoSnapshot";
import getAutoSnapshotFieldValue from "@salesforce/apex/FlexLayoutController.getAutoSnapshotFieldValue";
import { loadStyle } from "lightning/platformResourceLoader";
import userId from "@salesforce/user/Id";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class FlexLayoutTabs extends LightningElement {
    @api
    pageLayoutWrapper;
    @api
    isView;
    @api activeTabId;
    @api activeTabName;
    @wire(MessageContext)
    messageContext;
    @track
    tabsDetail;
    pageLayoutTabsString;
    @track _pageLayoutWrapper={}
    pageMessageList = [];
    tabsOpened = new Set();
    validationReceivedFromTabs = 0;
    guestTabReceivedToSave = 0;
    recordObject = {}
    savedTabs = 0;
    saveError = false;
    proceedToSave = true;
    proceedToSubmit = true;
    //activeTabId;
    showTabs = true;
    objectApiName
     @api isFromModal;
    @api openDropDownAtTopSide;
    @api firstLoad;
    autoSnapshotFieldValue;
    @track fieldApiNameMap ={};
    @track fieldDataTypeMap = {};
    //we get the api names of the fields
    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    getObjectInfo({ error, data }) {
        if (data) {
            this.fieldApiNameMap = {};
            for (let key in data.fields) {
                if (data.fields.hasOwnProperty(key)) {
                    this.fieldApiNameMap[key.toLowerCase()] = key;  
                    this.fieldDataTypeMap[key] = data.fields[key].dataType;
                }   
            }

          
        }
        else if (error) {
            this.fieldApiNameMap = {};
        }
    }

    async connectedCallback() {
        this.objectApiName = this.pageLayoutWrapper.objectName ? this.pageLayoutWrapper.objectName : this.objectApiName ;
        this.subscribeToMessageChannel();
        await this.fetchTabDetails(true);
        const tabAvailable = this.tabsDetail.find((tab) => tab.id == this.activeTabId);
        if (!tabAvailable) {
            this.activeTabId = undefined;
            this.showTabs = false;
            setTimeout(() => {
                this.showTabs = true;
            }, 0);
        }

        if (this.activeTabName && this.firstLoad) {
            let tabAvailable = this.tabsDetail.find((tab) => tab.tabName == this.activeTabName);
            if (!tabAvailable) {
                this.activeTabId = undefined;
                this.showTabs = false;
                setTimeout(() => {
                    this.showTabs = true;
                }, 0);
            } else {
                this.activeTabId = tabAvailable.id;
                this.showTabs = false;
                setTimeout(() => {
                    this.showTabs = true;
                }, 0);
            }
        }

        loadStyle(this, GOVGRANTS + "/Component/CSS/flexviewlayoutLwc.css").then(() => {
        });
    }

    async fetchTabDetails(isFirstCall = false) {
        getAutoSnapshotFieldValue({
            recId: this.pageLayoutWrapper.recordId,
            ObjectName: this.pageLayoutWrapper.objectName,
            fieldApiName: this.pageLayoutWrapper.autoSnapShotFieldAPIName
        })
            .then((data) => {
                this.autoSnapshotFieldValue = data;
            })
            .catch((error) => {
            });
        this.showTabs = false;
        this.tabsOpened.clear();
        return new Promise((resolve) => {
            getPageLayoutTabs({
                pageLayoutId: this.pageLayoutWrapper.pageLayoutId,
                objectName: this.pageLayoutWrapper.objectName,
                recId: this.pageLayoutWrapper.recordId,
                pageLayoutTabsString: this.pageLayoutTabsString,
                isFirstCall: isFirstCall,
                isViewContext: this.isView
            })
                .then((data) => {
                    this.tabsDetail = JSON.parse(data[0]);
                    this.pageLayoutTabsString = data[1];
                    if (!this.isView) {
                        this.tabsOpened.forEach((tabOpen) => {
                            const tabAvailable = this.tabsDetail.find((tab) => tab.id == tabOpen);
                            if (!tabAvailable) {
                                this.tabsOpened.delete(tabOpen);
                            }
                        });
                    }
                    this.showTabs = true;
                    resolve();
                    this._pageLayoutWrapper= JSON.parse(JSON.stringify(this.pageLayoutWrapper))
                    this._pageLayoutWrapper['fieldApiNameMap'] = this.fieldApiNameMap
                })
                .catch((error) => {
                    this.showTabs = true;
                });
        });
    }

    handleMessage(message) {
        if (this.pageLayoutWrapper?.pageLayoutId === message.data.pageLayoutId) {
            if (message.data.refreshTabsDetail) {
                this.isView = message.data.isView;
                this.fetchTabDetails();
            }
            if (message.data.errorWhileSave == false) {
                this.checkAllTabsSaved(true);
            }
            if (message.data.errorWhileSave == true) {
                this.saveError = true;
                this.checkAllTabsSaved(message.data.pageMessageList);
            }
        }
    }

    tabLoaded(event) {
        this.tabsOpened.add(event.detail.Id);
    }

    checkAllTabsSaved(errorMessageList = []) {
        this.savedTabs += 1;
        if (errorMessageList.length > 0) {
            this.pageMessageList.push(...errorMessageList);
        }
        if (this.savedTabs == this.tabsOpened.size && this.saveError == false) {
            const payload = {
                source: "LWC-from tabs",
                data: {
                    isSaved: true,
                    activeTabId: this.activeTabId,
                    pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                }
            };
            //calling this for auto snapshot
            this.proceedForAutoSnapshot();
            publish(this.messageContext, messageChannel, payload);
            this.savedTabs = 0;
            this.saveError = false;
            this.pageMessageList = [];
        } else if (this.savedTabs == this.tabsOpened.size && this.saveError == true) {
            const payload = {
                source: "LWC-from tabs",
                data: {
                    isSaved: false,
                    pageMessageList: this.pageMessageList,
                    pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                }
            };
            publish(this.messageContext, messageChannel, payload);
            this.savedTabs = 0;
            this.saveError = false;
            this.pageMessageList = [];
        }
    }

    async proceedForAutoSnapshot() {
        return new Promise((resolve) => {
            let currFieldValue = this.autoSnapshotFieldValue;
            initiateAutoSnapshot({
                recId: this.pageLayoutWrapper.recordId,
                keyValueMap: this.pageLayoutWrapper.keyValueMap,
                listParams: this.pageLayoutWrapper.listValueMap,
                fieldValue: currFieldValue
            })
                .then((data) => {
                    resolve();
                })
                .catch((error) => {
                    resolve();
                });
        });
    }

    handleSaveEvent(event) {
        this.validationReceivedFromTabs += 1;
        if (event.detail.requiredForSaveError) {
            let tabName = this.tabsDetail.find((tab) => tab.id == event.detail.tabId).tabName;
            event.detail.fieldLabelList.forEach((field) => {
                this.pageMessageList.push({
                    messageType: "error",
                    messageBody: `${field} is required to save under ${tabName}`
                });
            });

            event.detail.invalidUrlFieldList.forEach((field) => {
                this.pageMessageList.push({
                    messageType: "error",
                    messageBody: `${field} : Please enter valid URL value`
                });
            });
            this.proceedToSave = false;
        }
        if (this.validationReceivedFromTabs == this.tabsOpened.size) {
            if (this.tabsOpened.size != this.tabsDetail.length) {
                requiredForSubmitOrSave({
                    layoutId: this.pageLayoutWrapper.pageLayoutId,
                    recId: this.pageLayoutWrapper.recordId,
                    objectName: this.pageLayoutWrapper.objectName,
                    requiredBehaviour: "Required for Save",
                    tabsOpenedString: JSON.stringify([...this.tabsOpened]),
                    pageMessageListString: JSON.stringify(this.pageMessageList),
                    isViewContext: this.isView
                })
                    .then((data) => {
                        let pageMessageList = JSON.parse(data);
                        if (pageMessageList.length > 0) {
                            const payload = {
                                source: "LWC-from Layout Tabs",
                                data: {
                                    requiredForSaveError: true,
                                    pageMessageList: pageMessageList,
                                    pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                                }
                            };
                           publish(this.messageContext, messageChannel, payload);
                        } else {
                            if (event.detail.isModalSave) {
                                const payload = {
                                    source: "LWC-from Layout Tabs",
                                    data: {
                                        modalProceedToSave: true,
                                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                                    }
                                };
                               publish(this.messageContext, messageChannel, payload);
                            } else if (event.detail.isModalContinue) {
                                const payload = {
                                    source: "LWC-from Layout Tabs",
                                    data: {
                                        modalProceedToContinue: true,
                                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                                    }
                                };
                              publish(this.messageContext, messageChannel, payload);
                            } else {
                                const payload = {
                                    source: "LWC-from Layout Tabs",
                                    data: {
                                        proceedToSave: true,
                                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                                    }
                                };
                              publish(this.messageContext, messageChannel, payload);
                            }
                        }
                        this.validationReceivedFromTabs = 0;
                        this.proceedToSave = true;
                        this.pageMessageList = [];
                    })
                    .catch((error) => {
                    });
            } else {
                if (this.proceedToSave == true) {
                    if (event.detail.isModalSave) {
                        const payload = {
                            source: "LWC-from Layout Tabs",
                            data: {
                                modalProceedToSave: true,
                                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                            }
                        };
                       publish(this.messageContext, messageChannel, payload);
                    } else if (event.detail.isModalContinue) {
                        const payload = {
                            source: "LWC-from Layout Tabs",
                            data: {
                                modalProceedToContinue: true,
                                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                            }
                        };
                      publish(this.messageContext, messageChannel, payload);
                    } else {
                        const payload = {
                            source: "LWC-from Layout Tabs",
                            data: {
                                proceedToSave: true,
                                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                            }
                        };
                       publish(this.messageContext, messageChannel, payload);
                    }
                } else {
                    const payload = {
                        source: "LWC-from Layout Tabs",
                        data: {
                            requiredForSaveError: true,
                            pageMessageList: this.pageMessageList,
                            pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                        }
                    };
                   publish(this.messageContext, messageChannel, payload);
                }
                this.validationReceivedFromTabs = 0;
                this.proceedToSave = true;
                this.pageMessageList = [];
            }
        }
    }

    handleGuestSave(event){
        this.guestTabReceivedToSave +=1;
        let currentRecorcObj = event.detail.recordObject;
        this.recordObject = {...this.recordObject,...currentRecorcObj}        
        if(this.guestTabReceivedToSave == this.tabsOpened.size){
            for(const key in this.recordObject){
                if(this.fieldDataTypeMap[key].toLowerCase()=='date')
                {
                    let str = this.recordObject[key];
                    this.recordObject[key] = str?.split(' ')?.[0];
                }
            }
            saveForGuestUser(
                {   objectName:this.pageLayoutWrapper.objectName,
                    recId:this.pageLayoutWrapper.recordId,
                    jsonStr:JSON.stringify(this.recordObject)
                }).then(data=>{
                    if(data==null){
                        //save success
                        const payload = {
                            source: "LWC-from tabs",
                            data: {
                                isSaved: true,
                                activeTabId: this.activeTabId,
                                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                            }
                        };
                       publish(this.messageContext, messageChannel, payload);
                    }else{
                        let pageMessageList = [{messageType: "error",messageBody: data}];
                        const payload = {
                            source: "LWC-from tabs",
                            data: {
                                isSaved: false,
                                pageMessageList: pageMessageList,
                                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                            }
                        };
                      publish(this.messageContext, messageChannel, payload);
                    }
                    this.guestTabReceivedToSave = 0
                    this.recordObject = {};
                }).catch(error=>{
                    let pageMessageList = [{messageType: "error",messageBody: JSON.stringify(error)}];
                    const payload = {
                        source: "LWC-from tabs",
                        data: {
                            isSaved: false,
                            pageMessageList: pageMessageList,
                            pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                        }
                    };
                    publish(this.messageContext, messageChannel, payload);
                    this.guestTabReceivedToSave = 0
                    this.recordObject = {};
                });
        }
    }

    handleSubmitEvent(event) {
        this.validationReceivedFromTabs += 1;
        if (event.detail.requiredForSubmitError) {
            let tabName = this.tabsDetail.find((tab) => tab.id == event.detail.tabId).tabName;
            event.detail.fieldList.forEach((field) => {
                this.pageMessageList.push({
                    messageType: "error",
                    messageBody: `${field} is required to submit under ${tabName}.`
                });
            });

            this.proceedToSubmit = false;
        }
        if (this.validationReceivedFromTabs == this.tabsOpened.size) {
            if (this.proceedToSubmit == true) {
                const payload = {
                    source: "LWC-from Layout Tabs",
                    data: {
                        proceedToSubmit: true,
                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                    }
                };
                publish(this.messageContext, messageChannel, payload);
            } else {
                const payload = {
                    source: "LWC-from Layout Tabs",
                    data: {
                        requiredForSubmitError: true,
                        pageMessageList: this.pageMessageList,
                        pageLayoutId: this.pageLayoutWrapper.pageLayoutId
                    }
                };
                publish(this.messageContext, messageChannel, payload);
            }
            this.validationReceivedFromTabs = 0;
            this.proceedToSubmit = true;
            this.pageMessageList = [];
        }
    }

    handleActiveTab(event) {
        this.activeTabId = event.target.value;
        localStorage.setItem(`tabOpened_${this.pageLayoutWrapper.recordId}_${userId}`, event.target.value);
        const payload = {
            source: "LWC-from tabs",
            data: {
                tabChanged: true,                    
                pageLayoutId: this.pageLayoutWrapper.pageLayoutId
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

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}