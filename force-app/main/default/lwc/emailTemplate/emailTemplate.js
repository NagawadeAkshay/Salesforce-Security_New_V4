import { LightningElement,api,track ,wire} from 'lwc';
import getContactById from '@salesforce/apex/EmailTemplateController.getContactById';
import sendEmail from '@salesforce/apex/EmailTemplateController.sendEmail';
import geticons from '@salesforce/apex/AppUtils.getIcons';
import fetchEmailTemplate from '@salesforce/apex/EmailTemplateCtrl.fetchEmailTemplate';

export default class EmailTemplate extends LightningElement {
    @api editMode = false;
    @track isModalOpen = true;
    @track isLoading = false;
    @track govGrantPleaseWaitIcon;
    @api email;
    @api cc;
    @api showLabel;
    @api emailTemplateName;
    @api target;
    @api targets;
    @api actionInterface;
    @api what;
    @api showCC;
    @api enableAttachment;
    @api bulkMode;
    @api userMode;
    @api closeOnSuccess;
    @api readOnlyTemplate;
    @track subject;
    messageTimeOut;
    messageTimeOutEnabled = false;
    pageMessageList;
    emailBody;
    showBody =true;
    @api recordId;
    contact;

fileUplodaed = false;
maxStringSize = 6000000; //Maximum String size is 6,000,000 characters
maxFileSize = 25000000;//2100000;//2000000;//25000000; //After Base64 Encoding, this is the max file size //25MB
singleFileSize = 1490000; //Single File Size Limit for upload 1.5MB
chunkSize = 950000; //Maximum Javascript Remoting message size is 1,000,000 characters
@track isError = false;
@track errorMessage = '';
@track attachmentName;
@track attachment;
@track fileData = [];
@track isError= false;
messageTimeOut=5000;
showSend = true;
SuccessMessage;
isSuccess=false;
formating = ["font", "size", "bold", "italic", "underline", "strike", "list", "indent", "align", "link",  "clean", "header"];
appliedFormats = {  
    font: 'arial',
    color: '#000000',       
    background: '#000000',
};
@api controllerName;
   connectedCallback(){
        this.editMode = true;
        geticons({strResourceName : 'govGrantPleaseWaitIcon'}).then(result=>{
            if(result){
                this.govGrantPleaseWaitIcon = result;
                this.isLoading = true;
                setTimeout(() => {
                    this.isLoading = false;
                }, this.messageTimeOut);
            }
        });
       getContactById({contactId:this.recordId}).then(res=>{
        if(res){
            this.contact = res.target[0];
            this.messageTimeOutEnabled = res.MessageTimeOutEnabled;

            this.messageTimeOut = this.messageTimeOutEnabled == true && res.MessageTimeOut != undefined ? res.MessageTimeOut : this.messageTimeOut ;
            this.email =  this.contact.Email != undefined ? this.contact.Email : '';
            fetchEmailTemplate({labelShow:'',templateName:this.emailTemplateName,targetId:this.contact.Id,email:this.email}).then(result=>{
                if(result){
                    this.emailBody = result.body != undefined?  result.body.replace(/\n\n/g, '\n') : 'Enter Template Content';
                    this.subject  = result.subject != undefined?  result.subject : 'Enter Subject';
                }
            }).catch(error=>{
            });
        }
       }).catch(error=>{
        });
      

    }
    
    handleInputChange(event) {
        const fieldName = event.target.title.toLowerCase().replace(' ', '_');
        
        this[fieldName] = event.target.value;
    }
   
    handleFileChange(event) {
        this.fileUplodaed = true;
        this.fileData=[];
        const file = event.target.files[0]
        let singleFile;
        var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.attachmentName= file.name;
                this.attachment  = base64;
                singleFile = {
                    'filename': file.name,
                    'base64': base64,
                    'recordId': this.contact.Id,
                    'fileSize': file.size,
                    'type': file.type
                };
                
             
                this.fileData.push(singleFile);
                if (this.singleFileSize < singleFile.fileSize) {
                    
                    this.attachmentSizeError = true;
                    this.ShowErrorMessage('File Size Limit is Exceeded,more than one file is not supported');
                }else{
                    this.attachmentSizeError = false;
                }
                
               
            }
            reader.readAsDataURL(file)
        
        
    }
   

  
       
    handleSendEmail() {
        // Handle send email logic
         if( this.attachmentSizeError == true){
            this.isError = true;
            setTimeout(() => {
                this.isError = false;
              },this.messageTimeOut );
        }else{
        this.isLoading = true;

        sendEmail({emailBody : this.emailBody,email:this.email,ccEmail :this.cc,isBulkMode : 'False',
        fileDetails:this.fileData[0],targetId : this.contact.Id,subject:this.subject,whatId:this.contact.Id,clsName:this.controllerName}).then(
                result => {
                    if (result != null) {
                        this.isLoading = false;
                        if (result.IsSuccess == true) {
                            this.isError = false;
                            this.errorMessage = ''
                            this.showSend = false;
                            this.editMode = false;
                            this.ShowSuccessMessage('Email Send succefully');
                        }else{
                           let errorMessage = result.Message != undefined ? result.Message : 'Error ocurrs while sending email';
                           this.ShowErrorMessage(errorMessage);
                            
                        }
                    }else{
                    }
                })
                this.isLoading = false;
            }
    }

    handleBodyChange(event) {
        this.emailBody = event.target.value;
     }
  
   
    handleErrorMessageCloseClick(event) {
        this.isError = false;
       
    }
    handleSuccessMessageCloseClick(event) {
        this.isSuccess = false;
       
    }
    
    ShowSuccessMessage(SuccessMessage){
    
        this.SuccessMessage = SuccessMessage;
		this.isLoading = false;
        this.isSuccess = true;
        if(this.messageTimeOutEnabled == true){
            setTimeout(() => {
              this.isSuccess= false; 
              }, this.messageTimeOut);
          }
    }

    ShowErrorMessage(ErrorMessage){
        this.errorMessage = ErrorMessage;
        this.isError = true;
        this.isLoading = false;
        if(this.messageTimeOutEnabled == true){
            setTimeout(() => {
                  this.isError = false; 
              }, this.messageTimeOut);
          }
    }
}