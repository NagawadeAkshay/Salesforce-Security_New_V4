import { api, LightningElement, track, wire } from 'lwc';
import fetchNotes1 from '@salesforce/apex/NotesCtrl.fetchNotes1';
import deleteNote from '@salesforce/apex/NotesCtrl.deleteNoteRecord';
import CreateNote from '@salesforce/apex/NotesCtrl.addNotes';
import updateNote from '@salesforce/apex/NotesCtrl.updateNoteRecord';
import getContentNote from '@salesforce/apex/NotesCtrl.getNoteContent';
import viewContentNote from '@salesforce/apex/NotesCtrl.getContentNoteView';
import LOCALE from '@salesforce/i18n/locale';
////import getNotelist from '@salesforce/apex/AccountHelper.getNotelist';
import ExternalLibNew from '@salesforce/resourceUrl/ExternalLibNew';
import { loadStyle } from 'lightning/platformResourceLoader';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//import {refreshApex} from '@salesforce/apex'
import {deleteRecord} from 'lightning/uiRecordApi';
import geticons from '@salesforce/apex/AppUtils.getIcons';

export default class notes extends LightningElement {
    records;
    viewRecord;
    disableRowActions;
    hideDeleteAction;
    hideEditAction;
    hideCreateAction;
    disableRowActions;
    hideRowActions;
    actionConfig;
    @api parentId;
    @api isView;
    @api pblockId;
    @track isCollapsed = false;
    @track totalRecords;
    @track recordCountMessage; 
    @track collapsedicon = 'utility:up';
    @track notesRecords;
    @api recordId;
    @api parentObject;
    errorMessage; 
    checkDesLeninNew;
    checkDesLeniEdit;
    openmodel=false;
    AddNew=false;
    deleterecordid;
    Title;
    TitleInUpdate;
    DescriptionInUpdate;
    Description;
    var1;
    var2;
    var3;
    var4;
    bodyEdit;
    message;
    view=false;
    edit=false;
    viewrecordid;
    editid;
    noteRecord;
    @track bodyValue;
    add;
    editRecord;
    editRecordIdFromModal; 
    @api validity;  // cant remove becuase build gets failed 
    disabled;
    alertMessage = false;
    messageOnUI = '';
    alertMessage = false;   // For Add/Edit Message(On modal)
    alertMessage1 = false; // For Delete Message 
    messageOnUI = '';   // For Add/Edit Message(On modal)
    messageOnUID = '';  // For Delete Message     
	govGrantPleaseWaitIcon;
    @track isLoading = true;
    @track showIcon = false;
    isModalLoading = false;
    formats = [
        'font',
        'size',
        'bold',
        'italic',
        'underline',
        'list',
        'indent',
        'align',
        'link',
        'image',
        'clean',
        'table',
        'header',
    ];
    //valueOfSharingPrivacy = 'Visible to Anyone With Record Access';
    /*get options() {
        return [
            { label: 'None', value: 'None' },
            { label: 'Visible to Anyone With Record Access', value: 'Visible to Anyone With Record Access' },
            { label: 'Private on Records', value: 'Private on Records' },
        ];
    }
    handlePickValChange(event) {
        this.sharingPrivacyValue = event.detail.value;
    }*/ 
   
    connectedCallback(){
      
        loadStyle(this, ExternalLibNew + '/FontAwesome/css/font-awesome.min.css').then(() => {
        });      
		 geticons({strResourceName : 'govGrantPleaseWaitIcon'})
		   .then(result=>{
            if(result){
                this.govGrantPleaseWaitIcon = result;
				this.isLoading = false;
                    this.showIcon = true;
                    this.fetchNotesRecords();
                    setTimeout(() => {
                        this.showIcon = false;
                    }, 1000);
                }
            }).catch(error => {
                this.ErrorMessage = error.message;
                this.isLoading = false;
                this.isErrorMessage = true;
                setTimeout(() => {
                    this.isErrorMessage = false; 
                    }, this.messageTimeOut);
            });
    }
    fetchNotesRecords(){
        this.parentObject = this.recordId; 
        this.pblockId = this.pblockId;
       
        this.isView = true;
        fetchNotes1({parentObjectIds : this.parentObject,pbId : this.pblockId,isView : this.isView})
        .then(result => {
            if(result != undefined){
            this.notesRecords = result;
           
            
                if(result.ActionConfig != undefined){
                    this.actionConfig = result.ActionConfig;
                    for(var action in result.ActionConfig){
                		if(action=='Edit'){
                            this.hideEditAction = result.ActionConfig[action].hideAction;
                        }else if(action=='Delete'){
                            this.hideDeleteAction = result.ActionConfig[action].hideAction;
                        }else if(action=='Create' ){
                            this.hideCreateAction = result.ActionConfig[action].hideAction;
                		}
            		}
                }
            let rows = [];
                if(result.NoteList != undefined){
                    let dataNote = JSON.parse(result.NoteList);
            for ( let i = 0; i <dataNote.length; i++ ) {               
                let row = dataNote[ i ]; 
                rows.push( row );
            }
                }
            this.records = rows;
            this.error = undefined;
            this.totalRecords = rows.length;

            if(this.totalRecords == 0){
                this.recordCountMessage = 'No Records Found';
            }else{
                this.recordCountMessage  = 'Total Records : '+this.totalRecords;
            }

            }else{
                this.record = result;
            }
			this.isLoading = false;
        })
        .catch(error => {
            this.error = error;
            this.isLoading = false;
        });
    }
    handleEditOnLoad(event){
		this.isModalLoading = true;
        let record = event.detail.records;
        let fields = record[this.editid].fields;
        getContentNote({noteId : this.editid})
        .then(result => {
            this.bodyEdit = result;
            this.bodyValue = this.bodyEdit;
            this.bodyEdit = '';
			this.isModalLoading = true;
        })
        .catch(error => {
            this.error = error;
        });
    }


    confirmAndDelete(event){
        this.openmodel=true;
        this.deleterecordid=event.target.dataset.id;
    }

    deleteRecord(event){
        this.deleteNoteRec(this.deleterecordid);
        this.openmodel=false;
    }

    closeModal(){
        this.openmodel=false;
        this.AddNew=false;
        this.viewRecord = '';
        this.editRecord = '';
        this.errorMessage = '';
        this.validity = true;
    }
 
    openNewModal(){
		this.isModalLoading = true;
        this.AddNew=true;
        this.add=true;
        //this.valueOfSharingPrivacy = 'Visible to Anyone With Record Access';
        this.view=false;
        this.edit=false;
        this.validity = true;  //added to change color of description to blue on modal load 
		this.isModalLoading = false;
    }

    deleteNoteRec(notId){	
        deleteNote({noteId:notId})
            .then(result => {
				this.showIcon = true;
                if(result){
                    //this.showToast();
                    this.alertMessage1 = true;
                    this.messageOnUID = 'Note deleted successfully.';
                    setTimeout(() => { 
                   		this.fetchNotesRecords();
                        this.showIcon = false;
                        this.alertMessage1 = false;
                    },3000);
                    /** added this because when we delete last note record value of record which we added last 
                     * time stored in this var and then when after deleting all note record, when we try to 
                     * add new note record it take value of last saved record and update that in current record 
                     */
                    this.var1 = '';
                    this.var2 = '';
                }              
            })
            .catch(error => {
                this.error = error;
            });
    }
    
    showToast() {
        const event = new ShowToastEvent({
        title: 'Success',
        variant : 'success',
        message:'Note is deleted'
        });
        this.dispatchEvent(event);
      }
    handleCollapsed(){
        this.isCollapsed = !this.isCollapsed;
        if(this.isCollapsed){            
            this.collapsedicon = 'utility:down';
        }else{
            this.collapsedicon = 'utility:up';
        }
    }
    
    titleCH(event){
        this.var1=event.target.value;
    }

    descriptionCH(event){
        this.var2=event.target.value;
    }

   
    handleNoteCreated(){
    }

    handleCreateNote(){
		this.isModalLoading = true;
        this.Title=this.var1;
        this.Description=this.var2;
 		this.disabled = true;
        
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        this.checkDesLeninNew = this.var2;
        if(isInputsCorrect == false){
            this.disabled = false;
            this.isModalLoading = false;
        }
        if(this.checkDesLeninNew != undefined){
            if(this.checkDesLeninNew.replace(/(<([^>]+)>)/gi, "").length > 32000){ //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                this.validity = false;
                this.errorMessage = "You have exceeded the max length";
                this.disabled = false;
            }else if(this.checkDesLeninNew == undefined || this.checkDesLeninNew.length == 0){ //this.checkDesLeninNew.replace(/(<([^>]+)>)/gi, "").length <= 0  && 
                this.validity = false;
                this.errorMessage = "Please enter value in Description field";
                this.disabled = false;
            }else{
                this.validity = true;
            }
        }else{
            this.validity = false;
            this.errorMessage = "Please enter value in Description field";
            this.disabled = false;
        }

       /* if(this.checkDesLeninNew.replace(/(<([^>]+)>)/gi, "").length <= 0  && this.checkDesLeninNew != undefined){
                this.validity = false;
                this.errorMessage = "Please enter value in Description field";
        }else{
            this.validity = true;
        }*/ 

         if(!this.validity){
            this.isModalLoading = false;
        }
        if(this.validity == true){
       // this.var1='';
           
       
        this.validity = true;
          
	        if (isInputsCorrect) {
	            if((this.Title != null && this.Title != '')  && (this.Description != null && this.Description != '')){
	                CreateNote({title : this.Title,Description : this.Description,parentRecordId : this.recordId}).then(response=>{
	                    if(response){
	                        //this.showToastMessage('Success','Note Created Sucessfully !','success')
							this.alertMessage = true;
                            setTimeout(() => {
                                this.AddNew= false; 
                            }, 3000);
							this.isModalLoading = false;
	                        this.messageOnUI = 'Note created successfully.';
                            this.var2='';
	                        setTimeout(() => { 
	                            this.showIcon = true;
                                this.fetchNotesRecords();
                                this.showIcon = false;
	                            this.alertMessage = false;
	                            this.disabled = false; 
	                         },1000);
	                    }
	                    else{
	                        this.AddNew=false;
	                    }
	                }).catch(error =>{
	                    this.error=error;
	                });
	            }
	            else{
	              
	            }
        	}
    	}
    }
    titleChangeInEdit(event){
        this.var3 = event.target.value;
    }
    descriptionChangeInEdit(event){
        this.var4 = event.target.value;
    }
    handleUpdateNote(event){
		this.isModalLoading = true;
        this.TitleInUpdate=this.var3;
        this.DescriptionInUpdate=this.var4;
      

        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
        
        if(isInputsCorrect == false){
            event.preventDefault();
            this.isModalLoading = false;
        }
        this.checkDesLeniEdit = this.var4;

        if(this.checkDesLeniEdit != undefined){
            if(this.checkDesLeniEdit.replace(/(<([^>]+)>)/gi, "").length > 32000){ //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                this.validity = false;
                this.errorMessage = "You have exceeded the max length";
            }else if(this.checkDesLeniEdit.length == 0  || this.checkDesLeniEdit == undefined){
                this.validity = false;
                this.errorMessage = "Please enter value in Description field";
            }else{
                this.validity = true;
            }
        }else{
            this.validity = false;
            this.errorMessage = "Please enter value in Description field";
        }

        if(!this.validity){
            event.preventDefault();
            this.isModalLoading = false;
        }
        if(this.validity == true){
       // this.var3='';
       // this.var4='';
       
        this.validity = true;

        if (isInputsCorrect) {
            if((this.TitleInUpdate != null && this.TitleInUpdate != '')  && (this.DescriptionInUpdate != null && this.DescriptionInUpdate != '')){
                updateNote({title : this.TitleInUpdate,Description : this.DescriptionInUpdate,noteRecordId : this.editRecordIdFromModal,parentRecordId : this.recordId}).then(response=>{
                    if(response){
                        this.var4 = '';
                        //this.showToastMessage('Success','Note Created Sucessfully !','success')
						this.alertMessage = true;
                        //After Update, Modal will be closed after showing Success Message
                        setTimeout(() => {
                            this.AddNew= false; 
                        }, 2000);
						this.isModalLoading = false;
                        this.messageOnUI = 'Note updated successfully.';
                        setTimeout(() => { 
                        	this.showIcon = true;
                            this.fetchNotesRecords();
                            this.showIcon = false;
                            this.alertMessage = false;
                         },2000);
                    }
                    else{
                        this.AddNew=false;
                    }
                    window.stop();
                }).catch(error =>{
                    this.error=error;
                    window.stop();
                });
            }
            else{
                }
            }
        }
    }

    onEdit(event){
		this.isModalLoading = true;
        this.AddNew=true;
        this.edit=true;
        this.editid=event.target.dataset.id;
        //this.var3 = 
        this.errorMessage = '';
        this.editRecordIdFromModal =this.editid; 
        this.add=false;
        this.view=false;
        this.viewrecordid = event.target.dataset.id //BUG 193581 Point 8 - value set for viewrecordid so that once record saved this id will be use to show record
        viewContentNote({noteId:this.editid})
            .then(result => {
                if(result){
                    let dataNote = JSON.parse(result.enhancedNote);
                    let rows = [];
                    for ( let i = 0; i <dataNote.length; i++ ) {               
                        let row = dataNote[ i ]; 
                        this.var3 = row.note.Title;
                        this.var4 = row.strNotes;
                        //this.valueOfSharingPrivacy = row.note.SharingPrivacy == 'P' ? 'Private on Records' : 'Visible to Anyone With Record Access';
                        rows.push( row );
                    }
                    this.editRecord = rows;
            		this.isModalLoading = false;       
                }              
            })
            .catch(error => {
                this.error = error;
            });
    }
    showToastMessage(title,message,variant){
        const event = new ShowToastEvent({
            title:title ,
            variant :variant ,
            message:message
            });   
        this.dispatchEvent(event);
    }

    onView(event){
		this.isModalLoading = true;
        this.viewrecordid= event.target.dataset.id;
        this.AddNew=true;
        this.view=true;
        this.add=false;
        this.edit=false;
        viewContentNote({noteId:this.viewrecordid})
            .then(result => {
                if(result){
                    let dataNote = JSON.parse(result.enhancedNote);
                    let rows = [];
                    for ( let i = 0; i <dataNote.length; i++ ) {               
                        let row = dataNote[ i ]; 
                        rows.push( row );
    }

                    this.viewRecord = rows;
                   
                }              
				this.isModalLoading = false; 
            })
            .catch(error => {
                this.error = error;
            });
    }
   

    bodyOnChange(event){
        this.bodyEdit = event.target.value;
    }
/* BUG 193581 - Once record is edited successfully handleSuccess will get call to avoid closing of modal added var below  */
    handleSuccess(event){
       // this.Description= this.bodyEdit;
        //this.bodyEdit='';
      //  this.Description = event.target.value;
        this.showToastMessage('Success','Note Updated Sucessfully !','success');
        this.AddNew=false;  // BUG 193581 Point 8 - Commented 
        // this.AddNew=true;
        this.view=true;
        this.edit=false;
        this.showIcon = true;
        this.fetchNotesRecords(); //Added once data is saved from edit modal this will refresh the backend to show updated data
        this.showIcon = false;
    }
}