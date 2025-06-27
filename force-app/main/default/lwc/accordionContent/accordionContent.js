import { LightningElement,api,track,wire } from 'lwc';
import MessageSend from "@salesforce/messageChannel/flexLayout__c";
import {MessageContext, publish} from 'lightning/messageService';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import getCommunitySiteUser from '@salesforce/apex/SidebarEnhancedCtrl.isCommunitySiteUser';

export default class AccordionContent extends NavigationMixin(LightningElement) {
    @api content;
    @api enableLwc;
    @api tabName;
    @api appPage = false;
    isReceipient = false;
    
   @wire(MessageContext)
    context
    
    @wire(getCommunitySiteUser)
    isCommunitySiteUser;
    
 
    //Generic Navigation function
    handleRedirection(event){
       let url = event.target.dataset.url;
        let target = event.target.dataset.target;
        localStorage.setItem('myId', event.target.dataset.item);
        window.open(url,target)
    }

    RedirectionTabletype(event){
        if (this.isCommunitySiteUser.data) {
            this.isReceipient = true
        }
        let newWindow = event.target.dataset.newwindow;
        if(this.appPage){
            if(newWindow == 'true')
                this.handleLwcRedirection(event) //NavigationMixin 
            else
                this.handlephaseRedirection(event) //LMS
        }else{
            this.handleLwcRedirection(event)
        }
    }

    RedirectionURL(event){
        if (this.isCommunitySiteUser.data) {
            this.isReceipient = true
        }
        let url = event.target.dataset.url;
        if(this.appPage){ // In phase => true
            this.handleRedirectionURL(event);
        }else{
            if(url.startsWith('/lightning/')){
                this.handleRedirection(event);
            }else{
                this.RedirectionURLonRecord(event)
            }   
        }      
    }

    //handle URL 
    handleRedirectionURL(event){
        let newWindow = event.target.dataset.newwindow;
        let url = event.target.dataset.url;
        if(url.startsWith('/lightning/')  || url.startsWith('/recipient/')){
            this.handleRedirection(event);
        }   
        if(this.appPage){ // In phase => true
            localStorage.setItem('myId', event.target.dataset.item);
            if((!url.startsWith('/lightning/')  || !url.startsWith('/recipient/')) && newWindow == 'true'){  //check paramURL for Phase
                this.RedirectionURLonRecord(event);
            }else{
                this.publishMessage(url);
            }
        }else{ // Record Page
            this.RedirectionURLonRecord(event);
        }
    }

    RedirectionURLonRecord(event){
let url = event.target.dataset.url;
        let target = event.target.dataset.target;
        this.tabName = (this.tabName != '' && this.tabName != null) ? this.tabName : localStorage.getItem(localStorage.getItem('currentPhase'));
		this.tabName = (this.tabName != '' && this.tabName != null) ? this.tabName : localStorage.getItem('lastPageName');
        let pageType =  this.isReceipient ? 'comm__namedPage' : 'standard__navItemPage';
        const attributes =  {
            tabName : btoa(this.tabName),
            URL : url
        };
          let pageReference;
        if(this.isReceipient){
            pageReference = {
                type: pageType,
                attributes : {
                    name : this.tabName 
                },
                state: {
                    c__attributes : JSON.stringify(attributes)
                }
            }
        }else {
            pageReference = {
                type: pageType,
                attributes : {
                apiName : this.tabName
                },
                state: {
                    c__attributes : JSON.stringify(attributes)
                }
            }
        }
        this[NavigationMixin.GenerateUrl](pageReference).then(url => {
            window.open(url, target);
        });
    }



    handleLwcRedirection(event){
         let flextable = event.target.dataset.tablename;
        let type = event.target.dataset.recordtype;
        let target = event.target.dataset.target;
        let strParameter = event.target.dataset.stringparam;
        this.tabName = (this.tabName != '' && this.tabName != null) ? this.tabName : localStorage.getItem(localStorage.getItem('currentPhase'));
        this.tabName = (this.tabName != '' && this.tabName != null) ? this.tabName : localStorage.getItem('lastPageName');
        localStorage.setItem('myId', event.target.dataset.item);

        let pageType =  this.isReceipient ? 'comm__namedPage' : 'standard__navItemPage';

       // let url = window.location.hostname + '/lightning/n/'+ this.tabName   //+'Planning'
        const attributes =  {
            tabName : btoa(this.tabName),
            tableName: btoa(flextable),
            tableType: btoa(type),
            showTable: true,
            strParameter:btoa(strParameter),
            phase : localStorage.getItem('currentPhase')
        };
        let pageReference;
        if(this.isReceipient){
            pageReference= {
                type: pageType,
                attributes : {
                  name : this.tabName 
                },
                state: {
                    c__attributes : JSON.stringify(attributes)
                }
            }
        }else {
            pageReference = {
                type: pageType,
                attributes : {
                apiName : this.tabName
                },
                state: {
                    c__attributes : JSON.stringify(attributes)
                }
            }
        }
        this[NavigationMixin.GenerateUrl](pageReference).then(url => {
            window.open(url, target);
        });
    }

    handlephaseRedirection(event){
        let flextable = event.target.dataset.tablename;
        let type = event.target.dataset.recordtype;
        let strParameter = event.target.dataset.stringparam;
        localStorage.setItem('myId', event.target.dataset.item);
        const message={
            data:{
                flextable:flextable,
                Type:type,
                showTable:true,
                strParameter:strParameter
            }
        }
        
        publish(this.context, MessageSend, message);
    }
    
     publishMessage(url){
        const message={
            data:{
                URL : url
            }
        }
        publish(this.context, MessageSend, message);
    }
}