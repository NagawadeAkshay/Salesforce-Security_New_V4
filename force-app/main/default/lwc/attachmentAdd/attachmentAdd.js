import { LightningElement,wire,api, track } from 'lwc';
import getAttachmentDetails1 from '@salesforce/apex/AttachmentEditCtrl.getAttachmentDetails';
import addAttachment from '@salesforce/apex/AttachmentEditCtrl.updateAttachmentLWC';
import processSelected from '@salesforce/apex/AttachmentEditCtrl.processSelectedLWC';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import geticons from '@salesforce/apex/AppUtils.getIcons';
export default class AttachmentAdd extends LightningElement {
    enableWorkspace =true;
    renderWorkSpace = true;
    classificationsOptions;
    description;
    wrapFieldsList;
    saveBehaviour;
    isUlFromWorkspace;
    wrapAttachmentList;
    selectedValue;
    selectedAttachmentId =[];
    save;
    editAttachment;
    saveAndClose;    
    @api parentId;
    @api classification;
    @api pageblockId;
    @api attachTableType;
    obj = {};
    filebody;
    fileName;
    sucessAlert =false;
    fileValidation =false;
    isFileUpdated = false;
    errorMessage;
    isModalLoading = false;
    lstColumns = [       
      {label: 'Name', fieldName: 'Name', type: 'text'},
      {label: 'Description', fieldName: 'Description', type: 'text'},
      {label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date',typeAttributes: {
         day: 'numeric',
         month: 'numeric',
         year: 'numeric',
         hour: '2-digit',
         minute: '2-digit',
         second: '2-digit',
         hour12: true
      }}
  ];
  
   connectedCallback(){       
     // this.isModalLoading = true;
      geticons({strResourceName : 'govGrantPleaseWaitIcon'}).then(result=>{        
         if(result){
             this.govGrantPleaseWaitIcon = result;             
         }        
     }).catch(error => {    
         this.error = error.message;           
     }); 
        
      this.getDetails();
     // this.isModalLoading = false; 
	  this.handleModalLoad1(false);
   } 
   
   getDetails(){
      getAttachmentDetails1({attachmentId:'',parentId:this.parentId,pageblockId:this.pageblockId,classificationVal:this.parentId,attachTableType:this.attachTableType})
      .then(result => {  
         this.renderWorkSpace = result.renderWorkSpace;
         this.enableWorkspace = !result.hideWorkSpace && result.renderWorkSpace;   
         this.classificationsOptions = result.classificationsOptions.map( objPL => {
               return {
                   label: `${objPL}`,
                   value: `${objPL}`
               };
            }); 
            
         this.selectedValue =result.attachmentClassifiction != undefined ? result.attachmentClassifiction[0] :result.attachmentClassifiction;
         this.editAttachment = result.editAttachment;           
         this.wrapAttachmentList = result.attachmentList;
         this.wrapFieldsList = result.wrapFieldsList;
         this.saveAndClose = result.saveBehaviourForLwc == 'Save and Close Modal'? true : false;
            this.save = this.saveAndClose ? false : true;
        
      })
      .catch(error => {
          this.error = error;
      });
     }
   handleChange(event) {
      this.selectedValue = event.detail.value;
   }
   descriptionChange(event){
      this.description = event.detail.value;
   }
   openfileUpload(event) {
      const file = event.target.files[0]
      var reader = new FileReader()
      reader.onload = () => {
          var base64 = reader.result.split(',')[1]
          this.fileData = {
              'filename': file.name,
              'base64': base64,
             
          }
          this.filebody = this.fileData.base64;
          this.fileName = this.fileData.filename;
      }
      this.isFileUpdated = true;
      reader.readAsDataURL(file)
  }
   @api
  addAttachment(){     
       // Create the recordInput object
       if( this.filebody == undefined){
         this.fileValidation = true;  
         this.errorMessage = 'File should not be blank.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 5000);
        return;
       }
       if(this.fileName == undefined || this.fileName == ''){
         this.fileValidation = true;  
         this.errorMessage = 'Please select file.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 10000);
        return;
      }
      if(this.selectedValue == undefined || this.selectedValue == ''){
         this.fileValidation = true;  
         this.errorMessage = 'Please select type.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 10000);
        return;
      }
      if(this.description == undefined || this.description == ''){
         this.fileValidation = true;  
         this.errorMessage = 'Please enter value in description field.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 10000);
        return;
      }
    //  this.isModalLoading = true;
	   this.handleModalLoad1(true);
       this.obj['Description'] = this.description;  
       this.obj['Body'] = this.filebody != undefined ? this.filebody:this.editAttachment.Body;   
       this.obj['Name'] = this.fileName != undefined ? this.fileName:this.editAttachment.Name;    
       this.obj['ParentId'] = this.parentId;
      
      addAttachment({Id: '',editAttachmentLWC: this.obj,classification: this.selectedValue,isFileUpdated: this.isFileUpdated}).then(result=>{        
         // const toastEvent = new ShowToastEvent({
         //    title:'Success!',
         //    message:'Attachement added successfully.',
         //    variant:'success'
         // });         
         // this.dispatchEvent(toastEvent); 
         if(result.isSucess){
         this.sucessAlert = true;  
         setTimeout(() => {
                 
              // this.isModalLoading = false;
			    this.handleModalLoad1(false);
            
        }, 5000);
           setTimeout(() => {
            this.sucessAlert = false;  
                       
            }, 10000);
        this.description = '';
        this.selectedValue ='';
        this.fileName = '';
         }else{
            this.fileValidation = true;  
             this.errorMessage = result.Error; 
             setTimeout(() => {
               this.fileValidation = false;  
              // this.isModalLoading = false;
                this.handleModalLoad1(false);
           }, 5000);
         }
        
      }).catch(error=>{
         this.error= error;
         this.fileValidation = true;  
         this.errorMessage = error; 
         setTimeout(() => {
            this.fileValidation = false;  
           // this.isModalLoading = false;
		    this.handleModalLoad1(false);
        }, 5000);
      });
   }
   closeMessage(){
      this.sucessAlert = false;  
   }

   @api
   addAttachmentCloseModal(){
      addAttachmentCloseModal().then(result=>{
         if(result.Success){
            // const toastEvent = new ShowToastEvent({
            //     title:'Success!',
            //     message:'Attachement added successfully.',
            //     variant:'success'
            // });
            // this.dispatchEvent(toastEvent);          
            this.sucessAlter = true;    
         }
      }).catch(error=>{
         this.error= error;
      });
   }
   @api
   processSelected(){
      if(this.selectedAttachmentId == undefined || this.selectedAttachmentId.length == 0){
         this.fileValidation = true;  
         this.errorMessage = 'Please select file.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 5000);
        return;
      }
     // this.isModalLoading = true;
	   this.handleModalLoad1(true);
      processSelected({selectedAttachments: this.selectedAttachmentId,parentId: this.parentId}).then(result=>{        
         // const toastEvent = new ShowToastEvent({
         //    title:'Success!',
         //    message:'Attachement added successfully.',
         //    variant:'success'
         // });
         
         // this.dispatchEvent(toastEvent);    
         this.sucessAlert = true;   
         setTimeout(() => {
           // this.isModalLoading = false;
			 this.handleModalLoad1(false);
        }, 500);
         setTimeout(() => {
            this.sucessAlert = false;  
            
        }, 4000);
      }).catch(error=>{
         this.error= error;
      });
   }
   
   handleRowSelection(event){
      const selectedRows = event.detail.selectedRows;
      this.selectedAttachmentId =[];
    // Display that fieldName of the selected rows
    for (let i = 0; i < selectedRows.length; i++){       
         this.selectedAttachmentId.push(selectedRows[i].Id);
    }
   } 
   handleActive(event) {      

      if(event.target.value == 'Upload file from workspace') {
         this.uploadFromWorkSpace = true;
      }else{
         this.uploadFromWorkSpace = false;
      }      
      event.preventDefault();
      const selectEvent = new CustomEvent('handletab', {
          detail: this.uploadFromWorkSpace
      });
     this.dispatchEvent(selectEvent);
   }
   
   handleModalLoad1(isLoad){
      const custEvent = new CustomEvent(
         'modalloading', {
             detail: isLoad 
         });
     this.dispatchEvent(custEvent);
   }
   
}