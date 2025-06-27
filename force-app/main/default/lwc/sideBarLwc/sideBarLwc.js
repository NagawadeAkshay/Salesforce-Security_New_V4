import { LightningElement, wire, track, api } from "lwc";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchComponents from "@salesforce/apex/SidebarEnhancedCtrl.fetchComponents";
//import fetchGlobalSearchConfig from '@salesforce/apex/SidebarEnhancedCtrl.fetchGlobalSearchConfig';
//import fetchSearchTypeAheadRecords from '@salesforce/apex/SidebarEnhancedCtrl.fetchSearchTypeAheadRecords';
import fetchTechSupportLinks from "@salesforce/apex/SidebarEnhancedCtrl.fetchTechSupportLinks";
//import fetchRecentlyViewed from '@salesforce/apex/SidebarEnhancedCtrl.fetchRecentlyViewedWrapper';
import fetchExternalLinks from "@salesforce/apex/SidebarEnhancedCtrl.fetchExternalLinks";
import updateCollapsedState from "@salesforce/apex/SidebarEnhancedCtrl.updateCollapsedState";
import sidebarCss from "@salesforce/resourceUrl/GovGrants";
//import MessageContext from "@salesforce/messageChannel/sidebarToPhaseMessageChannel__c";
//import {MessageContext, publish} from 'lightning/messageService';
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
//import phaseToSidebar from "@salesforce/messageChannel/phaseToSidebar__c";
//import fetchPhaseName from '@salesforce/apex/SidebarEnhancedCtrl.getTabName';
//import fetchPhaseNameFromRecordPage from '@salesforce/apex/SidebarEnhancedCtrl.getTabNameFromRecordPage';
//import currentPhaseNameChannel from '@salesforce/messageChannel/CurrentPhaseName__c';
import {
  subscribe,
  MessageContext,
  APPLICATION_SCOPE,
  unsubscribe,
} from "lightning/messageService";

export default class sideBarLwc extends NavigationMixin(LightningElement) {
  @track Config = {
    cookieTabName: localStorage.getItem("currentPhase"),
    currentPhase: "",
    objName: "",
    loggedInUserProfile: "",
    recordId: "",
    searchResultPage: "",
    urlTabName: "",
  };

  @api phaseName = "GrantorPlanning";

  url;
  //searchTerm;
  //params;
  //isTypeAhead = false;
  //Result;
  //@track options = [];
  CurrentPageReference = "";
  @track components;
  @track collapsedArray;
  @track contents;
  @track headers;
  @track subheaders;
  @track TechSupportLinks = [];
  @track recentlyViewed = [];
  @track ExternalLinks = [];
  closeSectionOnLoad = [];
  loadOpenSection = [];
  collapseicon = false;
  sidebarHeight;
  enableLWC = false;
  tabName;
  SobjectName;

  isLoaded = false;
  disableInLwc;
  isAppPage = false;
  isSubscription = false;

  currentPageName;
  subscription;
  localStorageValue;

  @wire(MessageContext)
  messageContext;

  @wire(CurrentPageReference)
  getPageUrlParam(data) {
    if (data) {
      this.currentPageReference = JSON.parse(JSON.stringify(data));
      try {
        for (const param in this.currentPageReference.attributes) {
          if (param.includes("objectApiName")) {
            this.Config.objName = this.currentPageReference.attributes[param];
          }
          if (param.includes("recordId") || param.includes("recordId")) {
            this.Config.recordId = this.currentPageReference.attributes[param];
          }
        }
        const currentUrlParam =
          this.currentPageReference.state.c__attributes != undefined
            ? JSON.parse(this.currentPageReference.state.c__attributes)
            : this.currentPageReference.state.c__attributes;
        for (const param in currentUrlParam) {
          if (param.includes("phaseName") || param.includes("phase")) {
            this.phaseName = atob(currentUrlParam[param]);
            this.updatedConfig(this.phaseName);
          }
        }
        for (const param in this.currentPageReference.state) {
          if (param.includes("phaseName") || param.includes("phase")) {
            this.phaseName = atob(this.currentPageReference.state[param]);
            this.updatedConfig(this.phaseName);
          }
        }
        if (this.Config.objName || this.Config.recordId) {
          this.isAppPage = false;
        }
        if (this.Config.objName || this.phaseName || this.Config.recordId) {
          this.getComponents();
        }
      } catch (error) {
        console.error("URL entered is invalid::", JSON.stringify(error));
      }
    }
  }

  connectedCallback() {
    loadStyle(this, sidebarCss + "/Component/CSS/sidebarCss.css").then(() => {
    });
    this.localStorageValue = localStorage.getItem("UnmanagedValue");
    this.isAppPage = true;
    this.getPageNameFromUrl();
    this.isSubscription = false;
    this.subscribeToMessageChannel();
    if (this.Config.objName || this.Config.recordId) {
      this.isAppPage = false;
    }
    this.getComponents();
  }

  getPageNameFromUrl() {
    if (this.currentPageReference) {
      this.currentPageName = this.currentPageReference.attributes.apiName;
      this.tabName =
        this.currentPageReference.attributes.apiName == "" ||
        this.currentPageReference.attributes.apiName == undefined
          ? this.currentPageReference.attributes.name
          : this.currentPageReference.attributes.apiName;
      if (!this.Config.objName && !this.Config.recordId) {
        localStorage.setItem("lastPageName", this.tabName);
      }
    }
  }

  subscribeToMessageChannel() {
    if (this.phaseName) {
      this.updatedConfig(this.phaseName);
      if (this.Config.currentPhase && this.Config.urlTabName) {
        this.getComponents();
      }
    }
    // if (this.messageContext) {
    //     this.subscription = subscribe(this.messageContext, currentPhaseNameChannel, (message) => {
    //         this.handleMessage(message.message);
    //         if(message.pageName != '' && message.pageName != null && (this.tabName  == '' || this.tabName  == undefined)){
    //             this.tabName = message.pageName
    //         }

    //     }, { scope: APPLICATION_SCOPE });
    // }
  }

  handleMessage(message) {
    const phaseName = message;
    if (phaseName) {
      localStorage.setItem(phaseName, this.tabName);
      localStorage.setItem("currentPhase", phaseName);
      this.updatedConfig(message);
      this.isSubscription = true;
    }
    if (this.Config.currentPhase && this.Config.urlTabName) {
      this.getComponents();
    }
  }

  updatedConfig(phase) {
    this.Config.currentPhase = phase;
    this.Config.urlTabName = phase;
  }

  renderedCallback() {
    if (this.isLoaded) this.Expanded();

    this.template.querySelectorAll("ul").forEach((item) => {
      if (
        item.id != null &&
        item.id.replace(/-0$/, "") == localStorage.getItem("myId")
      )
        item.classList.add("lastSelectedSideBarLink");
    });
    const sidebarHeight = window.innerHeight;
    this.sidebarHeight = "height:" + sidebarHeight + "px;";
  }

  Expanded() {
    this.closeSectionOnLoad.forEach((key) => {
      const AccordionSection = this.template.querySelector(
        "section[data-my-id=" + key + "]"
      );
      const Button = this.template.querySelector(
        "button[data-my-id=" + key + "]"
      );
      if (AccordionSection != null) {
        AccordionSection.classList.remove("slds-is-open");
        AccordionSection.classList.add("slds-is-close");
      }
    });

    // this.loadOpenSection.forEach(key=>{
    //     if(key == 'recentlyviewed'|| key == 'externallinks'||key == 'technicalsupport'){
    //         this.getLinks(key);
    //    }
    // })
    this.isLoaded = false;
  }

  getIconHTML(componentType) {
    switch (componentType) {
      case "activity":
        return "utility:priority";
        break;
      case "analytics":
        return "utility:priority";
        break;
      case "collab":
        return "utility:anywhere_chat";
        break;
      case "task":
        return "utility:task";
        break;
      case "recentlyviewed":
        return "utility:clock";
        break;
      case "search":
        return "utility:search";
        break;
      case "externallinks":
        return "utility:knowledge_smart_link";
        break;
      case "technicalsupport":
        return "utility:maintenance_plan";
        break;
      default:
        return "";
    }
  }

  // async getLinks(linkType) {
  //     switch(linkType) {
  //     	// case 'recentlyviewed' :
  //         //     if(this.recentlyViewed.length === 0)
  //         //         await this.getRecentlyViewed();
  //         //     break;
  // 		case 'externallinks' :
  //             if(this.ExternalLinks.length === 0)
  //                await this.getExternal();
  // 			break;
  // 		case 'technicalsupport' :
  //             if(this.TechSupportLinks.length === 0)
  //                 await this.getTechSupportLinks();
  // 			break;
  //         default: return '';
  // 	}
  // };

  getComponents() {
    fetchComponents({ parameterMap: this.Config })
      .then((data) => {
        if (
          Object.keys(data).length > 0 &&
          (this.components == undefined ||
            this.Config.urlTabName ==
              JSON.parse(JSON.stringify(data)).currentPhase)
        ) {
          let myMap = JSON.parse(JSON.stringify(data));
          this.components = myMap.components;
          this.collapsedArray = myMap.collapsedArray;
          this.contents = myMap.contents;
          this.headers = myMap.headers;
          this.subheaders = myMap.subheaders;
          //this.Config.currentPhase = myMap.currentPhase;
          this.enableLWC = myMap.isEnableLWC;
          this.Config.loggedInUserProfile = myMap.loggedInUserProfile;
          if (
            myMap.currentPhase &&
            myMap.currentPhase !== null &&
            myMap.currentPhase !== undefined
          ) {
            if (this.Config.objName || this.Config.recordId)
              localStorage.setItem("currentPhase", myMap.currentPhase);
          }
          //this.Config.searchResultPage = myMap.searchResultPage; //need to check

          if (Array.isArray(this.components)) {
            for (var com of this.components) {
              com.iconCss = this.getIconHTML(com.name);
              com.type = "component";
              if (Array.isArray(this.collapsedArray)) {
                if (
                  this.collapsedArray.indexOf(com.id) !== -1 &&
                  this.collapsedArray.includes(com.id)
                )
                  this.closeSectionOnLoad.push(com.name);
                else this.loadOpenSection.push(com.name);
              }
              if (com.name == "search") {
                if (this.enableLWC) {
                  com.disableInLwc = true;
                } else {
                  com.isSearch = true;
                }
              } else if (com.name == "recentlyviewed") {
                if (this.enableLWC) {
                  com.disableInLwc = true;
                } else {
                  com.isRecentlyViewed = true;
                }
              } else if (com.name == "externallinks") {
                com.isExternalLinks = true;
                this.getExternal();
              } else if (com.name == "technicalsupport") {
                com.isTechnicalsupport = true;
                this.getTechSupportLinks();
              }
              if (
                com.name == "task" ||
                com.name == "activity" ||
                com.name == "analytics"
              ) {
                com = this.getContent(com);
                com.isHeader = true;
              }
            }
          }
          if ((this.components != "") & (this.components != undefined))
            this.components.sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
          this.isLoaded = true;
        }
      })
      .catch((error) => {
        this.error = error;
      });
  }

  getContent(com) {
    let header = [];
    for (var head of this.headers) {
      if (com.name === head.groupName) {
        if (Array.isArray(this.subheaders[head.id])) {
          head["subHeaders"] = this.subheaders[head.id];
          head.subHeaders.forEach((subHead) => {
            if (Array.isArray(this.contents[subHead.id])) {
              this.contents[subHead.id].forEach((item) => {
                item.NewWindow = item.isNewWindow == true ? "_blank" : "_Self";
                item.RecordType =
                  item.RecordType == "Flex Table Enhanced" ||
                  item.RecordType == "Flex Table"
                    ? "FlexTable"
                    : item.RecordType == "Flex Grid Enhanced"
                    ? "FlexGrid"
                    : item.RecordType;
                item.isLightningURL =
                  item.RecordType == "URL" &&
                  (item.lightningUrl != "" || item.lightningUrl != undefined)
                    ? true
                    : false;
                item.lightningUrl =
                  item.lightningUrl != "" && item.lightningUrl != undefined
                    ? this.EncodeLink(item.lightningUrl)
                    : item.lightningUrl;
              });
              subHead["contents"] = this.contents[subHead.id];
            }
          });
        }
        head["subHeaders"].sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
        head["subHeaders"][0].contents.sort((e, t) =>
          e.sequence > t.sequence ? 1 : -1
        );
        header.push(head);
        if (Array.isArray(this.collapsedArray)) {
          if (
            this.collapsedArray.indexOf(head.id) !== -1 &&
            this.collapsedArray.includes(head.id)
          ) {
            this.closeSectionOnLoad.push(head.id);
          }
        }
      }
    }
    com["header"] = header;
    com.isAvialable = com.header.length == 0 ? true : false;
    com["header"].sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
    return com;
  }

  EncodeLink(link) {
    if (!link.includes("ft") && !link.includes("fg")) {
      if (link.includes("phaseName") || link.includes("phase")) {
        let uncodedLink = link.split("=");
        return uncodedLink[0] + "=" + btoa(uncodedLink[1]);
      }
    }
    let encodedLink;
    let uncodedLink = link.split("&");
    uncodedLink.forEach((key) => {
      let str = key.split("=");
      if (encodedLink == null && encodedLink == undefined)
        encodedLink = str[0] + "=" + btoa(str[1]);
      else encodedLink += "&" + str[0] + "=" + btoa(str[1]);
    });
    return encodedLink;
  }
  //
  getTechSupportLinks() {
    return new Promise((resolve) => {
      fetchTechSupportLinks({ parameterMap: this.Config })
        .then((result) => {
          if (result) {
            this.TechSupportLinks = JSON.parse(JSON.stringify(result));
            let sequence = "";
            let openInNew = "";
            let URL = "";
            this.TechSupportLinks.forEach((item) => {
              let openIn = "_Self";
              openInNew =
                openInNew != ""
                  ? openInNew
                  : Object.keys(item).find((key) =>
                      key.includes("OpenNewWindow")
                    );
              if (this.enableLWC) {
                URL =
                  URL != ""
                    ? URL
                    : Object.keys(item).find((key) =>
                        key.includes("Target_URL__c")
                      );
              } else {
                URL =
                  URL != ""
                    ? URL
                    : Object.keys(item).find((key) => key.includes("URL__c"));
              }
              sequence =
                sequence != ""
                  ? sequence
                  : Object.keys(item).find((key) => key.includes("Sequence"));
              if (item[openInNew] === true) openIn = "_blank";
              if (item[URL] != "" && item[URL] != undefined)
                item["URL"] = item[URL];
              item["OpenNewWindow"] = openIn;
            });
            this.TechSupportLinks.sort((a, b) =>
              a[sequence] > b[sequence] ? 1 : -1
            );
            window.console.table(this.TechSupportLinks);
          }
          resolve();
        })
        .catch((error) => {
          this.error = error;
        });
    });
  }
  /* getRecentlyViewed(){
        return new Promise(resolve=>{
            fetchRecentlyViewed({parameterMap: this.Config})
            .then(result=>{
                if (result){
                    this.recentlyViewed = JSON.parse(JSON.stringify(result));
                    this.recentlyViewed.forEach((element) => {
                        if(element.RecordId != null && element.RecordId != undefined)
                            element.RecordId = '/'+ element.RecordId;
                    });             
                }
                resolve();
            })
            .catch(error => {
                this.error = error;
            })
            })
    }*/

  getExternal() {
    return new Promise((resolve) => {
      fetchExternalLinks({ parameterMap: this.Config })
        .then((result) => {
          if (result) {
            this.ExternalLinks = JSON.parse(JSON.stringify(result));
            let sequence = "";
            let openInNew = "";
            let URL = "";
            this.ExternalLinks.forEach((item) => {
              let openIn = "_Self";
              openInNew =
                openInNew != ""
                  ? openInNew
                  : Object.keys(item).find((key) =>
                      key.includes("OpenNewWindow")
                    );
              sequence =
                sequence != ""
                  ? sequence
                  : Object.keys(item).find((key) => key.includes("Sequence"));
              if (this.enableLWC) {
                URL =
                  URL != ""
                    ? URL
                    : Object.keys(item).find((key) =>
                        key.includes("Target_URL__c")
                      );
              } else {
                URL =
                  URL != ""
                    ? URL
                    : Object.keys(item).find((key) => key.includes("URL__c"));
              }
              if (item[openInNew] === true) openIn = "_blank";
              if (item[URL] != "" && item[URL] != undefined)
                item["URL"] = item[URL];
              item["OpenNewWindow"] = openIn;
            });
            this.ExternalLinks.sort((a, b) =>
              a[sequence] > b[sequence] ? 1 : -1
            );
          }
          resolve();
        })
        .catch((error) => {
        });
    });
  }
  //Generic Navigation function to use for technical link and phase links
  handleRedirection(event) {
    let url = event.target.dataset.url;
    let target = event.target.dataset.target;
    localStorage.setItem("myId", event.target.dataset.item);
    ``;
    window.open(url, target);
  }

  /* //Global Search Method//
    //fetching Search Object List 
    @wire(fetchGlobalSearchConfig, {parameterMap: '$Config' }) 
    fetchGlobalSearchConfig({error,data}){
        if (data) {
            let option =JSON.parse(JSON.stringify(data));
            this.isTypeAhead = option.isTypeAhead;
            let arr =[];
            let ObjList
            Object.keys(option.sobjects).forEach(key =>{
                let listOptions = {label: option.sobjects[key].label, value: option.sobjects[key].name, 'sequence': option.sobjects[key].sequence, 'recordType': option.sobjects[key].recordType }; 
                arr.push(listOptions);      
            });
            Object.keys(arr).forEach(key =>{
                if(arr[key].value != '')
                    ObjList = (ObjList == undefined) ? arr[key].value : (ObjList + ',' + arr[key].value);
            });
            if(arr != '' && arr != undefined)
                arr.sort((a,b) => (a.sequence  > b.sequence) ? 1 : (a.sequence  < b.sequence) ? -1 : 0);       
            this.optionValue = ObjList;
            arr.unshift({label : 'All', value : this.optionValue});
            this.options = arr;
        }else if (error) {
            this.error = error;
        }
    }
    handleClearButtonClick(){
        this.searchValue = '';
    }    
    //Type ahead drop down change to imperative
    SearchTypeAheadRecords(){
        fetchSearchTypeAheadRecords({parameterMap : this.params})
        .then(data=>{
            this.Result = JSON.parse(JSON.stringify(data));
        }).catch(error => {
        })
    }
    
    //Combobox Options
    get option1() {
        return this.options;
    }
    //Search Box value change
    handleChange(event) {
        this.optionValue = event.detail.value;
    }
    // Search Value URL building
    searchKeyword(event){
        this.searchTerm = event.detail.value;
        if(this.searchTerm != undefined && this.searchTerm.replace(/[^A-Z0-9]/gi, "").length > 1){
            this.params = {
                'searchTerm': this.searchTerm,
                'objectName':  this.optionValue,
                'recordType': ''
            }
            this.SearchTypeAheadRecords();
        }
        this.Result = '';
        this.url = this.Config['searchResultPage'] +'&searchText='+this.searchTerm +'&searchObject='+this.optionValue;
    }
    //Navigating to Search page
    globalSearchButton(){
        if(this.searchTerm != undefined && this.searchTerm.replace(/[^A-Z0-9]/gi, "").length > 1){
            window.location.href = this.url;
        }else{
            // const event = new ShowToastEvent({
            //     title: '',
            //     message: 'Please enter at least 2 characters to search.',
            //     variant: 'warn'
            // });
            // this.dispatchEvent(event);
            window.alert('Please enter at least 2 characters to search.');
        }
    }
    
    globalSearchButton(){
        if(this.searchTerm != undefined && this.searchTerm.replace(/[^A-Z0-9]/gi, "").length > 1){
            this[NavigationMixin.GenerateUrl]({
                    type: 'standard__webPage',
                    attributes: {
                        url: this.url
                    }
                }).then(generatedUrl => {
                    window.open(generatedUrl);
            });
        }else{
            const event = new ShowToastEvent({
                title: '',
                message: 'Please enter at least 2 characters to search.',
                variant: 'warn'
            });
            this.dispatchEvent(event);
        }
    }
    //Select TypeAhead Value and redirect
    selectValue(event){
        this.searchValue = event.currentTarget.dataset.name;
        let recordId = event.currentTarget.dataset.id;
        this.Result = '';
        this.url = '';
        this.url +='/'+ recordId;
        this.globalSearchButton();
    }
    */

  async collapseButton(event) {
    if (this.collapseicon == true) return null;
    let dataId = event.currentTarget.dataset.id;
    let iscollapsed = false;
    let id, type;
    // if(dataId == 'recentlyviewed'|| dataId == 'externallinks'||dataId == 'technicalsupport'){
    //     await this.getLinks(dataId);
    // }
    this.components.forEach((item) => {
      if (item.name == dataId) {
        id = item.id != "" ? item.id : "";
        type = item.type != "" ? item.type : "header";
      }
    });
    if ((id == "" || id == undefined) && (type == "" || type == undefined)) {
      this.headers.forEach((item) => {
        if ((item.id != "") & (item.id == dataId)) {
          id = item.id;
          type = "header";
        }
      });
    }
    const AccordionSection = this.template.querySelector(
      "section[data-my-id=" + dataId + "]"
    );
    const Button = this.template.querySelector(
      "button[data-my-id=" + dataId + "]"
    );
    const AccordionContent = this.template.querySelector(
      "div[data-my-id=" + dataId + "]"
    );
    if (AccordionSection.classList.contains("slds-is-open")) {
      AccordionSection.classList.remove("slds-is-open");
      AccordionSection.classList.add("slds-is-close");
      Button.setAttribute("aria-expanded", false);
      iscollapsed = true;
    } else {
      AccordionSection.classList.remove("slds-is-close");
      AccordionSection.classList.add("slds-is-open");
      Button.setAttribute("aria-expanded", true);
      iscollapsed = false;
      if (AccordionContent != "" && AccordionContent != undefined)
        AccordionContent.removeAttribute("hidden");
    }
    this.updateCollapsedState(id, type, iscollapsed);
  }

  togglePanel() {
    let leftPanel = this.template.querySelector("div[data-my-id=leftPanel]");

    if (leftPanel.classList.contains("slds-is-open")) {
      this.collapseicon = true;
      leftPanel.classList.remove("slds-is-open");
      leftPanel.classList.remove("open-panel");
      leftPanel.classList.add("slds-is-closed");
      leftPanel.classList.add("close-panel");
    } else {
      this.collapseicon = false;
      leftPanel.classList.add("slds-is-open");
      leftPanel.classList.add("open-panel");
      leftPanel.classList.remove("slds-is-closed");
      leftPanel.classList.remove("close-panel");
    }
  }

  updateCollapsedState(id, type, isCollapsed) {
    updateCollapsedState({ id: id, type: type, isCollapsed: isCollapsed })
      .then((result) => {})
      .catch((error) => {
      });
  }

  unsubscribeToMessageChannel() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel();
  }
  // navigateToRecentlyViewed(event) {
  //     let recordId = event.target.dataset.item;
  //     recordId = recordId.replace('/','')
  //     let objName = event.target.dataset.obj;
  //     this[NavigationMixin.Navigate]({
  //         type: 'standard__recordPage',
  //         attributes: {
  //             recordId: recordId,
  //             objectApiName: objName,
  //             actionName: 'view'
  //         }
  //     });
  // }
}