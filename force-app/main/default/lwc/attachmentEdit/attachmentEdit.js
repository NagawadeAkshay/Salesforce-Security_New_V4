import { LightningElement,wire,api, track } from 'lwc';
import getAttachmentDetails from '@salesforce/apex/AttachmentEditCtrl.getAttachmentDetails';
import updateAttachment from '@salesforce/apex/AttachmentEditCtrl.updateAttachmentLWC';
import processSelected from '@salesforce/apex/AttachmentEditCtrl.processSelectedLWC';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import geticons from '@salesforce/apex/AppUtils.getIcons';
export default class AttachmentEdit extends LightningElement {
    enableWorkspace =true;
    renderWorkSpace = true;
    attachmentExtension;
    classificationsOptions;
    description;
    wrapFieldsList;
    saveBehaviour;
    isUlFromWorkspace;
    wrapAttachmentList;
    selectedValue;
    save;
    editAttachment;
    saveAndClose;
    @api attachmentId;
    @api parentId;
    @api classification;
    @api pageblockId;
    @api attachTableType;
    @api govGrantPleaseWaitIcon;
    obj = {};
    filebody;
    fileName;
    editAlert = false;
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
	 this.handleModalLoad(true);
      if(this.govGrantPleaseWaitIcon == undefined){
      geticons({strResourceName : 'govGrantPleaseWaitIcon'}).then(result=>{        
            if(result ){
             this.govGrantPleaseWaitIcon = result;             
         }        
     }).catch(error => {    
         this.error = error.message;           
     });     
      }          
        this.getDetails();
    
    } 
  
    getDetails(){
        getAttachmentDetails({attachmentId:this.attachmentId,parentId:this.parentId,pageblockId:this.pageblockId,classificationVal:this.parentId,attachTableType:this.attachTableType})
        .then(result => {            
            this.renderWorkSpace = result.renderWorkSpace;
            this.enableWorkspace = !result.hideWorkSpace && result.renderWorkSpace;   
            this.classificationsOptions = result.classificationsOptions.map( objPL => {
               return {
                   label: `${objPL}`,
                   value: `${objPL}`
               };
            }); 
            
            this.selectedValue =result.attachmentClassifiction;
            this.editAttachment = result.editAttachment;
            this.description = result.editAttachment.Description;
            this.filebody = result.editAttachment.Body;
            this.fileName = result.editAttachment.Name;
            this.wrapAttachmentList = result.attachmentList;
            this.wrapFieldsList = result.wrapFieldsList;
            this.saveAndClose = result.saveBehaviourForLwc == 'Save and Close Modal'? true : false;
            this.save = this.saveAndClose ? false : true;
            setTimeout(() => { 
              // this.isModalLoading = false;
			  this.handleModalLoad(false);
            },1000);
           
        })
        .catch(error => {
            this.error = error;   
            //this.isModalLoading = false;
			this.handleModalLoad(false);
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
              'recordId': this.editAttachment.Id
          }
          this.filebody = this.fileData.base64;
          this.fileName = this.fileData.filename;
      }
      this.isFileUpdated = true;
      reader.readAsDataURL(file)
  }
   @api
   updateAttachment1(){     
       // Create the recordInput object
       if(this.selectedValue == undefined || this.selectedValue == ''){
         this.fileValidation = true;  
         this.errorMessage = 'Please select type.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 5000);
        return;
      }
      if(this.description == undefined || this.description == ''){
         this.fileValidation = true;  
         this.errorMessage = 'Please enter value in description field.';
         setTimeout(() => {
            this.fileValidation = false;  
            
        }, 5000);
        return;
      }
     // this.isModalLoading = true;
	 this.handleModalLoad(true);
       this.obj['Id'] = this.editAttachment.Id;
       this.obj['Description'] = this.description;  
       this.obj['Body'] = this.filebody != undefined ? this.filebody:'';   
       this.obj['Name'] = this.fileName != undefined ? this.fileName:this.editAttachment.Name;    
       this.obj['ParentId'] = this.editAttachment.ParentId;
      updateAttachment({id: this.editAttachment.Id,editAttachmentLWC: this.obj,classification: this.selectedValue,isFileUpdated:this.isFileUpdated}).then(result=>{        
         // const toastEvent = new ShowToastEvent({
         //    title:'Success!',
         //    message:'Attachement edited successfully.',
         //    variant:'success'
         // });
         // this.dispatchEvent(toastEvent);   
         this.editAlert = true; 
         setTimeout(() => {
            this.editAlert = false;  
            //this.isModalLoading = false;
			this.handleModalLoad(false);
            
        }, 5000);
      }).catch(error=>{
         this.error= error;
         //this.isModalLoading = false;
		 this.handleModalLoad(false);
      });
   }
   editMessage(){
      this.editAlert = false; 
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
     this.handleModalLoad(true);
      processSelected({selectedAttachments: this.selectedAttachmentId,parentId: this.parentId,attachmentId:this.editAttachment.Id}).then(result=>{        
         // const toastEvent = new ShowToastEvent({
         //    title:'Success!',
         //    message:'Attachement added successfully.',
         //    variant:'success'
         // });
         // this.dispatchEvent(toastEvent);     
         this.editAlert = true; 
         setTimeout(() => {
            this.editAlert = false;  
           //this.isModalLoading = false;
		     this.handleModalLoad(false);
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

 handleModalLoad(isLoad){
   const custEvent = new CustomEvent(
      'modalloading', {
          detail: isLoad 
      });
  this.dispatchEvent(custEvent);
}


}