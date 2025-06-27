import { LightningElement, wire, track, api } from 'lwc';
import LightningModal from 'lightning/modal';
import getPageTemplateDetailsForModal from '@salesforce/apex/FlexLayoutController.getPageTemplateDetailsForModal';
import getLayoutOnLoadDetails from '@salesforce/apex/FlexLayoutController.getLayoutOnLoadDetailsForModal';
import getmergeFiields from '@salesforce/apex/FlexLayoutController.getmergeFiields';
import geticons from "@salesforce/apex/AppUtils.getIcons";
import getCommunityBaseUrl from "@salesforce/apex/AppUtils.getCommunityBaseUrl";
import { subscribe, unsubscribe, APPLICATION_SCOPE, publish, MessageContext } from "lightning/messageService";
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import modalTemplate from './modalFlexLayout.html';
export default class ModalFlexLayout extends LightningElement {
    @api recordId;
    @api modalAttribute;
    @api controllerName;
    @api sOjectName;
    @api modalHeader;
    @api modalWidth;
    govGrantPleaseWaitIcon = "";
    showSpinner = false;
    isModal = false;
	isModalLoading = false;
    isModalLoading = false;
    pageLayoutName;
    keyValueMap={};
    listValueMap;
    @track pageLayoutWrapper;
    defaultValueMap={};
    isView = true;
    currentPageReference;
    isFlexTable = false;
    FlexTableName;
    FlexGridName;
    isLayout = false;
    pageMessageList=[];
    messageTimeOut;
    messageTimeOutEnabled;
    @wire(MessageContext)
    messageContext;
    inputdata;
	componentType
    modalAttributeClone;
    mode = false;
    isSaveAndContinue = false;
    customActionShow = false;
    context = "Edit";

    isFlow = false;
    flowName;
    flowParams = [];
    _pageLayoutWrapperHolder;

    isHeaderTabAvaiable = false;
    isModalcall = true;
    isCommunitySite = false;
    communityBaseUrl = null;
    isPageMessageHasError=false;

    connectedCallback(){
        document.body.style.overflow = 'hidden';
		this.govGrantPleaseWaitIcon = this.modalAttribute.govGrantPleaseWaitIcon;
        this.isModalLoading = true;
        this.subscribeToMessageChannel();
        this.isUserInCommunity();
        this.fetchDeatils();

       
    }


    renderedCallback(){
        const inputBox = this.template.querySelector('.modalSection');
        inputBox.focus();
    }

    render(){
        this.handleTabSwitch();
        return modalTemplate;
    }

    handleTabSwitch(){
        const modalcontainer = this.template.querySelector('.modalcontainer');
        if(modalcontainer != null && this.modalAttribute != undefined && this.modalAttribute.flowName != undefined){
            modalcontainer.classList.add('nooverlapdropdown');
            modalcontainer.classList.remove('overlapdropdown');
        }else{
            if (modalcontainer) {
                setTimeout(() => {
                    const elemHeight = modalcontainer.offsetHeight;
                    if(elemHeight<480){
                        modalcontainer.classList.add('overlapdropdown');
                        modalcontainer.classList.remove('nooverlapdropdown');
                    }
                    else{
                        modalcontainer.classList.add('nooverlapdropdown');
                        modalcontainer.classList.remove('overlapdropdown');
                    }
                }, 6000);
            }
        }
    }
    
    fetchDeatils(){
		this.modalAttributeClone = {...this.modalAttribute};
        if(this.modalAttribute.urlParams != undefined && this.modalAttribute.flowName == undefined){
            this.covertUrlParmsIntoMap(); 
        }

        if(this.recordId != undefined){
            this.modalAttributeClone['recordId'] = this.recordId; 
        }
     
        getPageTemplateDetailsForModal({modalAttribute : JSON.stringify(this.modalAttributeClone),sOjectName : this.sOjectName}).then(result=>{
                
            let dataObject = JSON.parse(result);
            if(dataObject.pageMessageList!=undefined && dataObject.pageMessageList.length>0){
                let errorMessage = dataObject.pageMessageList.find((data) => data.messageType == 'error');
                if (errorMessage != undefined) {
                   this.isPageMessageHasError=true;
                }
            }
            if (dataObject.isError || this.isPageMessageHasError) {
                this.isModalLoading = false;
                if(dataObject.errorMessage){
                   console.error(dataObject.errorMessage);
                }
                if (dataObject.pageMessageList && dataObject.pageMessageList.length > 0) {
                    this.pageMessageList = dataObject.pageMessageList;
                    this.messageTimeOut = dataObject.messageTimeOut;
                    this.messageTimeOutEnabled = dataObject.messageTimeOutEnabled;
                }
            } else{
                if (dataObject.pageMessageList && dataObject.pageMessageList.length > 0) {
                    this.pageMessageList = dataObject.pageMessageList;
                    this.messageTimeOut = dataObject.messageTimeOut;
                    this.messageTimeOutEnabled = dataObject.messageTimeOutEnabled;
                }
                this._pageLayoutWrapperHolder = dataObject;
                if(this.modalAttribute != undefined && this.modalAttribute.urlParams != undefined){
                        
                    if(this.modalAttribute.urlParams.indexOf('mode=Edit') != -1 || this.modalAttribute.urlParams.indexOf('mode=edit') != -1){
                        this.mode = false;
                    }else if(this.modalAttribute.urlParams.indexOf('mode=View') != -1 || this.modalAttribute.urlParams.indexOf('mode=view') != -1){
                        this.mode = true;
                        this.context = "View";
                    }else{
                        this.mode = false;
                    }
                }
                
                if(dataObject.recordId != undefined){
                    this.recordId = dataObject.recordId;
                }
                this.pageLayoutName = dataObject.modalAttributeMap.PageTemplate;
                this.keyValueMap = dataObject.keyValueMap != undefined ? JSON.parse(dataObject.keyValueMap) : {};
                this.listValueMap = dataObject.listValueMap != undefined ? JSON.parse(dataObject.listValueMap) : undefined;
                this.defaultValueMap = dataObject.listDefaultValues != undefined ? dataObject.listDefaultValues : undefined;
                if(this.modalAttributeClone.urlParams != undefined && this.modalAttribute.flowName == undefined){
                
                    this.mergeKeyValueMap();
                }
                
                if(dataObject.modalAttributeMap.FlexTableName != undefined){
                    this.isFlexTable = true;
                    this.componentType = 'FlexTable';
                    this.FlexTableName = dataObject.modalAttributeMap.FlexTableName;
                    this.isModalLoading = false;
                    this.showButton = false;                
                }else if(dataObject.modalAttributeMap.FlexGridName != undefined){
                     this.isFlexTable = true;
                    this.componentType = 'FlexGrid';
                    this.FlexTableName = dataObject.modalAttributeMap.FlexGridName;
                	this.showButton = false;
                	this.isModalLoading = false;
                }else if(dataObject.modalAttributeMap.flowName!= undefined){
                    this.isFlow = true;
                    this.flowName = dataObject.modalAttributeMap.flowName;
                    if(this.modalAttribute.urlParams != undefined){
                        this.flowParams = this.modalAttribute.urlParams;
                    }
                    this.isModalLoading = false;
                }else{
					this.isLayout = true;
                    this.getLayoutDetails(dataObject.modalAttributeMap.PageTemplate[0],this.mode,this.recordId);   
                    
                }
            }
        
        }).catch(error=>{
            this.isModal = false;
            this.isModalLoading = false;
            console.error('error---'+JSON.stringify(error));
        })
        
    }


    getLayoutDetails(pageTemplateName,isViewContext,recId){
    
        getLayoutOnLoadDetails({templateName : pageTemplateName,recId : recId,isViewContext : isViewContext}).then(response=>{
                         
            let pageTemplateDetails = JSON.parse(response);
            if (pageTemplateDetails.isError) {
                console.error(pageTemplateDetails.errorMessage);
                //this.showConfigError = true;
            } else{
                
                this.pageLayoutWrapper = JSON.parse(response);
                this.updateModalHeader();
                this.pageLayoutWrapper.keyValueMap = JSON.stringify(this.keyValueMap);
                this.pageLayoutWrapper.listValueMap = JSON.stringify(this.listValueMap);
                this.pageLayoutWrapper.defaultValueMap = this.defaultValueMap;
                this.pageLayoutWrapper.recordId  = this.recordId
                this.pageLayoutWrapper.inputdata =  this.inputdata;
                 //rich text area
                this.pageLayoutWrapper.allowedCharsForRichTextArea = this._pageLayoutWrapperHolder.allowedCharsForRichTextArea;
                this.pageLayoutWrapper.warningCharsForRichTextArea = this._pageLayoutWrapperHolder.warningCharsForRichTextArea;
                this.pageLayoutWrapper.allowedWordsForRichTextArea = this._pageLayoutWrapperHolder.allowedWordsForRichTextArea;
                this.pageLayoutWrapper.warningWordsForRichTextArea = this._pageLayoutWrapperHolder.warningWordsForRichTextArea;
                this.pageLayoutWrapper.showCharLimit = this._pageLayoutWrapperHolder.showCharLimit;
                this.pageLayoutWrapper.showCharLimitWarning = this._pageLayoutWrapperHolder.showCharLimitWarning;
                this.pageLayoutWrapper.showWordLimit = this._pageLayoutWrapperHolder.showWordLimit;
                this.pageLayoutWrapper.showWordLimitWarning = this._pageLayoutWrapperHolder.showWordLimitWarning;
                this.isModal = true;
                this.isHeaderTabAvaiable = this.pageLayoutWrapper.isHeaderTabAvaiable;
                if(this.mode){
                    this.showButton = false;
                }else{
                    this.showButton = true;
                }
               
                if(this.pageLayoutWrapper.redirectLogic != undefined){
                    if(this.pageLayoutWrapper.redirectLogic == 'Save'){
                        this.ActionLabel = 'Save';
                    }else if(this.pageLayoutWrapper.redirectLogic == 'Continue'){
                        this.ActionLabel = 'Continue'; 
                    }else if(this.pageLayoutWrapper.redirectLogic == 'Continue And Close Modal'){
                        this.ActionLabel = 'Continue'; 
                    }else if(this.pageLayoutWrapper.redirectLogic == 'Save and Continue'){
                        this.ActionLabel = this.pageLayoutWrapper.labelOverrideSaveandContinue != undefined ? this.pageLayoutWrapper.labelOverrideSaveandContinue : this.pageLayoutWrapper.redirectLogic;
                    }else if(this.pageLayoutWrapper.redirectLogic == 'Save and Close Modal'){
                        this.ActionLabel = this.pageLayoutWrapper.labelOverrideSaveandClose != undefined ? this.pageLayoutWrapper.labelOverrideSaveandClose : this.pageLayoutWrapper.redirectLogic;
                    }else{
                        this.ActionLabel = this.pageLayoutWrapper.redirectLogic;
                    }
                }else{
                    this.ActionLabel ='Save';
                } 

                if(this.context == 'View' && !this.isHeaderTabAvaiable){
                    this.customActionShow = true;
                }
                
            }
        }).catch(error=>{
            this.isModal = false;
            console.error('error---'+JSON.stringify(error));
        })
    }

    
    covertUrlParmsIntoMap(){
        let attributeMap = {};
        let urlParamsMap = {};
        let urlParams = this.modalAttribute.urlParams;
        if(urlParams != undefined){
            let paramsSplitStr = urlParams.split('&');
            for(let str of paramsSplitStr){
                let attributeStr = str.split('=')
                attributeMap[attributeStr[0]] = attributeStr[1];
            }
           // urlParamsMap.attributes = attributeMap;
           // this.modalAttributeClone.urlParams = JSON.stringify(urlParamsMap);
        }

        if(this.inputdata != undefined){
            let keys = Object.keys(this.inputdata);
            for(let i=0; i < keys.length; i++){
                attributeMap[keys[i]] = this.inputdata[keys[i]];
            }
        }
        urlParamsMap.attributes = attributeMap;
        if(urlParamsMap.attributes['id'] != undefined){
            this.recordId = urlParamsMap.attributes['id'];
        }
        this.modalAttributeClone.urlParams = JSON.stringify(urlParamsMap);
        
    }


    mergeKeyValueMap(){
    
        let urlMap = JSON.parse(this.modalAttributeClone.urlParams);
        let urlMapKeyList = Object.keys(urlMap.attributes);
        for(let i=0; i < urlMapKeyList.length ; i++){
        
            this.keyValueMap[urlMapKeyList[i]] = urlMap.attributes[urlMapKeyList[i]];
        }

    }

    onClickOfAction(event){
    
        if(this.pageLayoutWrapper.redirectLogic == null || this.pageLayoutWrapper.redirectLogic == undefined || this.pageLayoutWrapper.redirectLogic == 'Save'
            || this.pageLayoutWrapper.redirectLogic == 'Save and Close Modal' || this.pageLayoutWrapper.redirectLogic == 'Save and Continue'){
        
            
            this.isModalLoading = true;    
            let actionConfig ={};
            actionConfig['actionType'] = 'ModalSave';
            actionConfig['pageLayoutId'] = this.pageLayoutWrapper.pageLayoutId;

            const payload = {
                source: "LWC-from modal actions",
                data: actionConfig
            };
            publish(this.messageContext, messageChannel, payload); 
        }else if(this.pageLayoutWrapper.redirectLogic == 'Continue'){

            let actionConfig ={};
            actionConfig['actionType'] = 'ModalContinue';
            actionConfig['pageLayoutId'] = this.pageLayoutWrapper.pageLayoutId;

            const payload = {
                source: "LWC-from modal actions",
                data: actionConfig
            };
            publish(this.messageContext, messageChannel, payload);
            
        
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
        document.body.style.overflow = 'visible';
    }
        
    handleMessage(message){
        if(this.pageLayoutWrapper?.pageLayoutId === message.data.pageLayoutId){
    
            if (message.data.errorWhileSave == false && message.data.recordId) {
                if(this.pageLayoutWrapper.redirectLogic == 'Save' || this.pageLayoutWrapper.redirectLogic === undefined || this.pageLayoutWrapper.redirectLogic === null ){
                    this.pageLayoutWrapper.recordId = message.data.recordId;
                    this.recordId = message.data.recordId;
                    this.mode = true;
                    this.showButton = false;
                    this.context = 'View';
                    if(!this.isHeaderTabAvaiable){
                        this.customActionShow = true;
                    }
                    this.isModalLoading = false;
                    this.pageMessageList = [];
                    if(!this.modalAttribute?.isLayout && this.modalAttribute?.isTableRefreshAvailable){
                        this.isModal = false;
                        this.closeModal(false)
                    }
                    
                }
                else if(this.pageLayoutWrapper.redirectLogic == 'Save and Close Modal'){
                    if(this.modalAttribute?.parentPageContext == "View"){
                        this.navigateToViewPage(message.data.recordId);
                    }else{
                        this.navigateToEditPage(message.data.recordId);
                    }
                }else if(this.pageLayoutWrapper.redirectLogic == 'Save and Continue'){
                   // Bug 395325: after save and continue the mode of the second layout (In case of Table Action)
                    if(this.modalAttribute?.isLayout != true){
                        if(this.modalAttribute?.parentPageContext == "View"){
                            this.recordId = message.data.recordId;
                            this.isModal = false;
                            this.isSaveAndContinue = true;
                            this.showButton = false;
                            this.isModalLoading = false;  
                            this.ContextOnSaveAndContinue ="View";                 
                        }else{
                            this.recordId = message.data.recordId; 
                            this.isModal = false;
                            this.isSaveAndContinue = true;
                            this.showButton = false;
                            this.isModalLoading = false; 
                            this.ContextOnSaveAndContinue ="Edit";                    
                        }
                    
                        }else{

                        this.recordId = message.data.recordId; 
                        this.isModal = false;
                        this.isSaveAndContinue = true;
                        this.showButton = false;
                        this.isModalLoading = false; 
                        this.ContextOnSaveAndContinue ="Edit";   
                    }
                }
            }else if(message.data.requiredForSaveError){
                this.pageMessageList = message.data.pageMessageList;
                this.isModalLoading = false;
            }else if(message.data.inputdata != undefined){
                if(this.pageLayoutWrapper.redirectLogic == 'Continue'){
                        

                        if(this.pageLayoutName.length > 1){
                            this.isModal = false;
                            this.inputdata = message.data.inputdata;
                            this.isModalLoading = true;
                            this.getLayoutDetails(this.pageLayoutName[1]);
                        }else{
                            this.isModal = false;
                            this.inputdata = message.data.inputdata;
                            this.isModalLoading = true;
                            this.fetchDeatils();
                        }
                        
                    
                }
            }else if(message.data.isModalShowSpinner === false){
                    this.isModalLoading = false;
            }else if(message.data.errorWhileSave === true){
                this.pageMessageList = message.data.pageMessageList;
                this.isModalLoading = false;
                
            }else if (message.data.actionType == "Edit") {
                this.customActionShow = false;
                this.mode = false;
                this.showButton = true;
            }
            
        }
        if(message.data.tabChanged){
            this.handleTabSwitch();
        }    
    }
    
    navigateToViewPage(recordId) {
        if(this.isCommunitySite){
            window.open(this.communityBaseUrl + '/detail/' +recordId,'_self');
        }else{
            window.open('/lightning/r/'+this.sOjectName+'/'+recordId+'/view','_self');
        }
    }

    navigateToEditPage(recordId) {
        if(this.isCommunitySite){
            window.open(this.communityBaseUrl + '/detail/' +recordId+'?c__Mode=ZWRpdA==','_self');
        }else{
            window.open('/lightning/r/'+this.sOjectName+'/'+recordId+'/view?c__Mode=ZWRpdA==','_self');
        }
    }

    setPageMessages(event) {
        this.pageMessageList = event.detail.pageMessageList;
    }

    closeModal(ismodalclose){
        this.unsubscribeToMessageChannel();
        this.dispatchEvent(
            new CustomEvent("modal_close", {
                detail: {
                    modalClose: ismodalclose,
                   
                }
            })
        );
    }

    handleCloseModal(){
    
        this.closeModal(true);
    }

    handleModalRefresh(event){
    
        if(event.detail.refreshBehaviour != undefined ){
            
            // if(event.detail.refreshBehaviour ==='Close modal and refresh grid'){
            //     getdata(this,true);
                
            // }else if(event.detail.refreshBehaviour ==='Close modal and refresh all flextables'){
            //     refreshLayout(this);
            // }
            // this.isFlexTable = false;
            // this.isModalLoading = true;
            // this.fetchDeatils();

            if(this._pageLayoutWrapperHolder.ApexClass != undefined){
            
                if(this.recordId != undefined){
                    this.modalAttributeClone['recordId'] = this.recordId; 
                }

                getmergeFiields({modalAttribute : JSON.stringify(this.modalAttributeClone), unMangedControllerName : this._pageLayoutWrapperHolder.ApexClass}).then(result =>{
                
                    if(result){
                        let param ={};
                        param['flexTableName'] = this.FlexTableName;
                        param['result']  = result;
                        const payload = {
                            source: "LWC-from modal actions",
                            data: param
                        };
                        publish(this.messageContext, messageChannel, payload); 
                    }
                }).catch(error=>{
                    this.isModal = false;
                    console.error('error---'+JSON.stringify(error));
                })

            }
        }
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

    updateModalHeader(){
        if(this.recordId == null && this.modalHeader == null){
            if(this.pageLayoutWrapper?.createHeaderOverride != null){
                this.modalHeader = this.pageLayoutWrapper.createHeaderOverride;
            }else if(this.pageLayoutWrapper?.headerTitle != null){
                this.modalHeader = this.pageLayoutWrapper.headerTitle;
            }else if(this.pageLayoutWrapper.headerNew != null){
                this.modalHeader = this.pageLayoutWrapper.headerNew
            }else{
            }
        }else{
            if(this.modalHeader == null && this.pageLayoutWrapper?.headerTitle != null){
                this.modalHeader = this.pageLayoutWrapper?.headerTitle;
            }
           
        }

    }
 
}