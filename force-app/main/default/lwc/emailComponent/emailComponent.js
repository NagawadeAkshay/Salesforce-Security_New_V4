import { LightningElement,track,api } from 'lwc';
import uploadNewValNew from '@salesforce/apex/SendEmailCompCtrl.uploadNewValNew';
import getRecordsNewLWC from '@salesforce/apex/SendEmailCompCtrl.getRecordsNewLWC';
import sendEmailNew from '@salesforce/apex/SendEmailCompCtrl.sendEmailNew';
import getLoadData from '@salesforce/apex/SendEmailCompCtrl.getLoadData';
import getCollabGroupMemberIdsLWC from '@salesforce/apex/SendEmailCompCtrl.getCollabGroupMemberIdsLWC';
import uploadAttachmentFiles from '@salesforce/apex/SendEmailCompCtrl.uploadAttachmentFiles';
import geticons from '@salesforce/apex/AppUtils.getIcons';
export default class EmailComponent extends LightningElement {
   @track isModalOpen = true;
   @track isSelectFilesClick = false;
   @track contentVersionLinkList = [];
   @track isResetClicked = false;
   @track isError = false;
   @track errorMessage = '';
   @track checkboxVal= false;
   
   

   closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

//variables added for Files Attachments
attachmentSizeError = false;
baseURL;
@api recordId;
@track fileData = [];
@track contentData = [];
attachmentList = [];
attachedFileName = [];
filembSize = 0;
newVal = 0;
maxStringSize = 6000000; //Maximum String size is 6,000,000 characters
maxFileSize = 25000000;//2100000;//2000000;//25000000; //After Base64 Encoding, this is the max file size
singleFileSize = 1490000; //Single File Size Limit for upload
chunkSize = 950000; //Maximum Javascript Remoting message size is 1,000,000 characters
positionIndex = 0;
doneUploading = false; // Check Each File completed attachment
finalUploading = false; // Check All File Attachment Completed.
counter = 0; // Checked for File Index
fileCountIndex = 0;
currentAttachBatchSize = 0;

@track percentile = 0;
@track widthPercentage = 'width:0%';

@track finalUploading = false;
@track fileLinkAdded = false;




//

//Email Input
@track items = [];
@track toItems = [];
@track ccItems = [];
@track subject = '';
body = "";
fromAddress = '';
@track files = [];
wantToUploadFile = false;
noEmailError = false;
invalidEmails = false;
searchTerm = "";
searchCCTerm = "";
blurTimeout;
boxClassTO = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
boxClassCC = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
@api opt = [{
    value: 'Internal',
    label: 'Internal'
},{
    value: 'External',
    label: 'External'
},{
    value: 'Groups',
    label: 'Groups'
}]

@api mode;
@api parentId;
@api taskId;
@track sendACopyToMe = false;


toAddressValue;
ccAddressValue;
toAddressValueCount;
ccAddressValueCount;
toOptionCount;
ccOptionCount;
ccCheckboxValue;
selectByValue;
bodyValue;
userType;
objectApiName;
isExternalUser;
results;
emailSent = false;
editMode = true;
invalidSubject = false;
returnMap;

isView = false;
isSend = false;
isReply = false;

@track returnSelectedFiles = [];
originalReturnedFiles = [];
fileBlock = false;
attachBlock = false;
tableName = '';
namespace = '';

//group
grpNamesList=[];
parentGroup;
memberMap={};
memberList = [];

toMemberlist=[];
ccMemberList=[];

//
//new variables
groupResult;
groupResultCC;
groupccResult
selectedRecordIds=[];
selectedccRecordIds=[];
selectedEmails=[];
selectedccEmails = [];
recordIdValMap=[];
recordIdccValMap = [];


ToIds=[];
CCIds=[];
//loading icon

@track govGrantPleaseWaitIcon;
@track isLoading = false;


//OnLoad Function call 
connectedCallback(){

    geticons({strResourceName : 'govGrantPleaseWaitIcon'}).then(result=>{
        if(result){
            this.govGrantPleaseWaitIcon = result;
            this.isLoading = true;
            
        }
    }).catch(error => {
        this.ErrorMessage = error.message;
        this.isErrorMessage = true;
        setTimeout(() => {
            this.isErrorMessage = false;
        }, this.messageTimeOut);
    });
    
    this.getLoadDataFirst();
    if(this.mode==="Reply"||this.mode==="reply"){
        this.isReply = true;
        this.fetchTaskForReply();
    }else if(this.mode==="View"||this.mode==="view"){
        this.isView = true;
        
        this.fetchTaskForReply();
        
    }else if(this.mode==="Send"||this.mode==="send"){
        this.isSend = true;
    }else{
        
    }
          
}

getLoadDataFirst(){

//call load data for initial setup and metadata
getLoadData()
.then(result => {
   
    if (result != null) {
        this.fileBlock = result.fileBlock;
        this.tableName = result.tableName;
        this.namespace = result.namespace;
        this.isExternalUser = result.isExternalUser;
        this.attachBlock = result.attachBlock;
        this.baseURL = result.baseURL;
        this.isLoading = false;
    }else{
        
    }   
})
.catch(error => {
    this.error = error;
    this.isLoading = false;
});	
}


fetchTaskForReply(){	
    // alert("I am getting called");
   
    //here apex call for checking the suggestions
    uploadNewValNew({sendACopyToMe:false,emailSent:false,mode:this.mode,taskId:this.taskId,parentId:this.parentId,emailFieldName:""})
    .then(result => {
        // alert(JSON.stringify(result));
        if (result != null) {
            
            if(this.isView){
                this.editMode = false;
            }else{
                this.editMode = true;
            }
            
            this.returnMap = result;
            
            
            
            this.subject = result.subject;
            this.body = result.body;
            this.fromAddress = result.fromAddress;
            this.toAddress = result.toAddress;
            this.ccAddress = result.ccAddress;
            this.searchTermReply = result.formattedToAddress;
            this.searchCCTermReply = result.formattedCCAddress;
            this.formattedToIds = result.formattedToIds;
            this.formattedCCIds = result.formattedCCIds;

            
            if(result.AttachId){
                for(let index=0; index < result.AttachId.length;index++){
                    //https://ggf-dev18-dev-ed--ggdev18.visualforce.com/sfc/servlet.shepherd/version/download/0684P00000RmCUrQAN
                    let url = this.baseURL+'/sfc/servlet.shepherd/version/download/'+result.AttachId[index].Id;
                    result.AttachId[index].URL = url;
                    
                    
                }
                this.contentData = result.AttachId;
            }
            

            if(result.formattedToAddress == '') {
                this.searchTermReply = result.toAddress;
            } 

            if(result.formattedCCAddress == ''){
                this.searchCCTermReply = result.ccAddress;
            }

            //For Reply to external User
            if(this.isExternalUser){
                if(result.formattedToAddress == '') {
                    this.searchTerm = result.toAddress;
                } 
    
                if(result.formattedCCAddress == ''){
                    this.searchCCTerm = result.ccAddress == undefined ? "": result.ccAddress;
                    //this.searchCCTerm = result.ccAddress;
                }
            }
            



            //

            if(result.formattedToIds != '' && result.formattedToIds != undefined){
                this.selectedRecordIds = [];
                this.selectedGroupIds = [];
                let formattedIds = result.formattedToIds.split(';');
                for(let index=0;index<formattedIds.length;index++){
                    if(formattedIds[index].startsWith('0F9'))
                        this.selectedGroupIds.push(formattedIds[index]);
                    else
                        this.selectedRecordIds.push(formattedIds[index]);
                }
            }
               // $scope.selectedRecordIds = result.formattedToIds.split(';');
            if(result.formattedCCIds != '' && result.formattedCCIds != undefined){
                this.selectedccRecordIds = [];
                this.selectedccGroupIds = [];
                let formattedIds = result.formattedCCIds.split(';');
                for(let index=0;index<formattedIds.length;index++){
                    if(formattedIds[index].startsWith('0F9'))
                        this.selectedccGroupIds.push(formattedIds[index]);
                    else
                        this.selectedccRecordIds.push(formattedIds[index]);
                }
            }



            var splitstoAddress = [];
            var splitsccAddress = [];
            if(this.mode==="View"||this.mode==="view"){
                if(result.formattedToAddress==''){
                    // splitstoAddress = result.toAddress.split(';');
                    this.returnMap.formattedToAddress = result.toAddress;
                }else{
                    // splitstoAddress = result.formattedToAddress.split(';');
                    this.returnMap.formattedToAddress = result.formattedToAddress;
                }
                if(result.formattedCCAddress==''){
                    
                    // splitsccAddress = result.ccAddress.split(';');
                    this.returnMap.formattedCCAddress = result.ccAddress;
                }else{
                    // splitsccAddress = result.formattedCCAddress.split(';');
                    this.returnMap.formattedCCAddress = result.formattedCCAddress;
                }
            }else{
                if(result.formattedToAddress==''){
                    splitstoAddress = result.toAddress.split(';');
                    this.selectedToValues = splitstoAddress;
                }else{
                    splitstoAddress = result.formattedToAddress.split(';');
                    this.selectedToValues = splitstoAddress;
                }
                if(result.formattedCCAddress==''){
                    splitsccAddress = result.ccAddress.split(';');
                    this.selectedCcValues = splitsccAddress;
                }else{
                    splitsccAddress = result.formattedCCAddress.split(';');
                    this.selectedCcValues = splitsccAddress;
                }
            }

            if(result.SendACopyToMe){
                this.checkboxVal = result.SendACopyToMe;
            }
            
            
        }else{
            if(_addressValue.includes('@') && _addressValue.includes('.')){
               // alert('I am having at least one email Id');
                //this.toItems.push(_addressValue);
            }
            
        }   
    })
    .catch(error => {
        this.error = error;
    });	
}

handleAddedFiles(event){

    //this will read the Ids from child component
    const ids = this.template.querySelector('c-flex-table-l-w-c');
    const idValues = ids.callingfromSendEmail();

    if(idValues.length>0){
        this.returnSelectedFiles = idValues;
        this.originalReturnedFiles = idValues;
        this.isSelectFilesClick = false;
        this.fileLinkAdded = true;

        setTimeout(() => {
            this.fileLinkAdded = false; 
        },5000 );
    }else{
        this.returnSelectedFiles = [];
        this.originalReturnedFiles = [];
        this.isSelectFilesClick = false;
        this.fileLinkAdded = false;
    }
    this.template.querySelector(".inputClass").classList.remove('slds-hide');
    // this.template.querySelector('.inputClass').classList.add('slds-show');
}

backToEmailFromFiles(){
    this.isSelectFilesClick = false;
    this.template.querySelector('.inputClass').classList.remove('slds-hide');
}

handleSelectFiles(event){
    this.isSelectFilesClick = true;
    this.template.querySelector('.inputClass').classList.add('slds-hide');
    if(this.returnSelectedFiles.length>0){

    }
}
clearAddedLinks(event){
    this.isSelectFilesClick = true;
    this.template.querySelector('.inputClass').classList.add('slds-hide');

    this.returnSelectedFiles = [];
}
cancelFilePopup(event){
    this.isSelectFilesClick = false;
}

handleRemoveFiles(event){
    var recId = event.currentTarget.dataset.id;
    var returnList = [];
    if(this.returnSelectedFiles.length>0){
        returnList = this.returnSelectedFiles;
        this.returnSelectedFiles = [];
        for(let index=0; index < returnList.length;index++){
            
            if(returnList[index].id==recId){
                returnList.splice(index,1);
            }else{
            }
            
        }
        this.returnSelectedFiles = returnList;

    }


}

handleSendCopyChange(event){
    this.sendACopyToMe = event.target.checked;
    // alert(this.sendACopyToMe);
}
handleToOptionChangeFilter(event){
    this.toOptionCount = event.detail.length;
    if(this.toOptionCount!==undefined && this.toOptionCount>0){
        if(this.toOptionCount===1){
            this.toOptionValue = event.detail[0];
        }else if(this.toOptionCount===2){
            this.toOptionValue = 'Both';
        }
    }else{
        this.toOptionValue = 'None';
    }
    
}
handleCcOptionChangeFilter(event){
    this.ccOptionCount = event.detail.length;
    if(this.ccOptionCount!==undefined && this.ccOptionCount>0){
        if(this.ccOptionCount===1){
            this.ccOptionValue = event.detail[0];
        }else if(this.ccOptionCount===2){
            this.ccOptionValue = 'Both';
        }
    }else{
        this.ccOptionValue = 'None';
    }
    
}

_selectedValues = [];
selectedValuesMap = new Map();

_toSelectedValues = [];
toSelectedValuesMap = new Map();
_ccSelectedValues = [];
ccSelectedValuesMap = new Map();

get selectedToValues() {
    return this._toSelectedValues;
}
get selectedCcValues() {
    return this._ccSelectedValues;
}
set selectedValues(value) {
    this._selectedValues = value;

    const selectedValuesEvent = new CustomEvent("selection", { detail: { selectedValues: this._selectedValues} });
    this.dispatchEvent(selectedValuesEvent);
}

set selectedToValues(value) {
    this._toSelectedValues = value;

    const selectedValuesEvent = new CustomEvent("selection", { detail: { selectedToValues: this._toSelectedValues} });
    this.dispatchEvent(selectedValuesEvent);
}
set selectedCcValues(value) {
    this._ccSelectedValues = value;

    const selectedValuesEvent = new CustomEvent("selection", { detail: { selectedCcValues: this._ccSelectedValues} });
    this.dispatchEvent(selectedValuesEvent);
}

handletoInputChange(event) {
    event.preventDefault();
    
    var searchTermTemp = event.target.value;
    var _addressType = "TO";
    this.searchTerm = searchTermTemp;
    if (searchTermTemp.lastIndexOf(';') != -1)
        searchTermTemp = searchTermTemp.substring(searchTermTemp.lastIndexOf(';') + 1, searchTermTemp.length);
    
    //Call to process the input with filter

    if (searchTermTemp.length < 2) {
       
        this.toItems = [];
        return;
    }
    
    //this.searchTerm = event.target.value;
    this.processSelectionInput(this.toOptionCount,this.toOptionValue,searchTermTemp);
    this.callSearchMethod(this.userType,searchTermTemp,_addressType);
    
   
}
handleEmailList(event){
   if (event.keyCode === 13 || event.keyCode === 40)  {
    this.onToSelect(event) ;    
       }
}
handleEmailListCc(event){
    if (event.keyCode === 13 || event.keyCode === 40)  
    {
       this.onCcSelect(event) ;    
    } 
}

handleccInputChange(event) {
    event.preventDefault();
    
    var searchTermCcTemp = event.target.value;
    var _addressType = "CC";
    this.searchCCTerm = searchTermCcTemp;
    if (searchTermCcTemp.lastIndexOf(';') != -1)
        searchTermCcTemp = searchTermCcTemp.substring(searchTermCcTemp.lastIndexOf(';') + 1, searchTermCcTemp.length);
    
    //Call to process the input with filter

    if (searchTermCcTemp.length < 2) {
        
        this.ccItems = [];
        return;
    }
    
    this.processSelectionInput(this.ccOptionCount,this.ccOptionValue,searchTermCcTemp);
    this.callSearchMethod(this.userType,searchTermCcTemp,_addressType);
}

blurtoggleVisibility ()
{
    this.boxClassCC = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    this.boxClassTO = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
}

//This method will process the filter input and assing values to the properties
processSelectionInput(_optionCount,_optionValue,_addressValue){
    if(_optionValue ==='Both'){
        this.userType = 'User';
        this.searchType = 'Both';
    }else if(_optionValue ==='Internal'){
        this.userType = 'User';
        this.searchType = 'Internal';
    }else if(_optionValue ==='External'){
        this.userType = 'User';
        this.searchType = 'External';
    }else if(_optionValue ==='Groups'){
        this.userType = 'CollaborationGroup';
        this.searchType = 'Groups';
    }else{
        this.userType = 'None';
        this.searchType = 'None';
    }
}
//
//
callSearchMethod(_userType,_addressValue,_addressType){
    
    var parameterMap = {}
    parameterMap['searchString'] = _addressValue;
    parameterMap['fieldBindToTarget'] = 'Email';
    parameterMap['fieldToFilter'] = 'Name';
    parameterMap['objectApiName'] = this.userType;//_userType;
    // parameterMap['objectApiName'] = 'User';
    parameterMap['searchType'] = this.searchType;//_userType;
    parameterMap['selectedRecordIds'] = '';
    //here apex call for checking the suggestions
    getRecordsNewLWC({paramatersMap : parameterMap})
    .then(result => {
        //alert(JSON.stringify(result));
        if (result != null && result.length > 0) {
            var res = []
            result.forEach(element => {
                 
                 if (this.userType == 'CollaborationGroup'){
                    var result1 = { Id: element['id'], Name: element['name'], targetValue: element['collaborationType'], badgeValue: element['memberCount'] };
                    res.push(result1);
                 }else{
                     var result2 = { Id: element['id'], Name: element['name'], Email: element['email'], objType: element['objType'] };
                     res.push(result2);
                 }
                
            });
            if(_addressType ==="TO"){
                this.toItems = res;
                this.boxClassTO =
                 "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open";
        
            }                    
            else{
                this.ccItems = res;
                this.boxClassCC =
                 "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open";
        
            }
                
        }else{
            if(_addressValue.includes('@') && _addressValue.includes('.')){
               // alert('I am having at least one email Id');
                //this.toItems.push(_addressValue);
            }
            if(result.length == 0 && _addressType ==="TO"){
                this.toItems = [];
                this.boxClassTO = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
            }else if(result.length == 0 && _addressType ==="CC"){
                this.boxClassCC =
                "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
                this.ccItems = [];
            }
            
        }   
    })
    .catch(error => {
        this.error = error;
    });
    
}
//

handleBlur() {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.blurTimeout = setTimeout(() => {
        this.boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        const value = this.template.querySelector('input.input').value
        if (value !== undefined && value != null && value !== "") {
            this.selectedValuesMap.set(value, value);
            this.selectedValues = [...this.selectedValuesMap.keys()];
        }

        this.template.querySelector('input.input').value = "";
    }, 300);
}

get hasItems() {
    return this.items.length;
}
get hasToItems() {
    return this.toItems.length;
}
get hasCcItems() {
    return this.ccItems.length;
}

handleKeyPress(event) {
    if (event.keyCode === 13) {
        event.preventDefault(); // Ensure it is only this code that runs

        const value = this.template.querySelector('input.input').value;
        if (value !== undefined && value != null && value !== "") {
            this.selectedValuesMap.set(value, value);
            this.selectedValues = [...this.selectedValuesMap.keys()];
        }
        this.template.querySelector('input.input').value = "";
    }
}

handleToKeyPress(event) {
    if (event.keyCode === 13) {
        event.preventDefault(); // Ensure it is only this code that runs

        const value = this.template.querySelector('input.input').value;
        if (value !== undefined && value != null && value !== "") {
            this.toSelectedValuesMap.set(value, value);
            this.selectedToValues = [...this.toSelectedValuesMap.keys()];
        }
        this.template.querySelector('input.input').value = "";
    }
}
handleCcKeyPress(event) {
    if (event.keyCode === 13) {
        event.preventDefault(); // Ensure it is only this code that runs

        const value = this.template.querySelector('input.inputCC').value;
        if (value !== undefined && value != null && value !== "") {
            this.ccSelectedValuesMap.set(value, value);
            this.selectedCcValues = [...this.ccSelectedValuesMap.keys()];
        }
        this.template.querySelector('input.inputCC').value = "";
    }
}

handleRemove(event) {
    const item = event.target.label;
    this.selectedValuesMap.delete(item);
    this.selectedValues = [...this.selectedValuesMap.keys()];
}
handleToRemove(event) {

  
        
    const item = event.target.label;
    
    if(this.mode=='Reply'||this.mode=='reply'){
        if(this.toSelectedValuesMap.size>0){
            //here I need to write remove logic
            var keyVal = '';
            var dataVal = '';
            
            for (const key of this.toSelectedValuesMap.keys()){
                if(item == key){
                    keyVal = key;
                    dataVal = this.toSelectedValuesMap.get(key);
                    this.toSelectedValuesMap.delete(key);
                }
            }
            
            if(keyVal!=''){
                var newList = [];
                for(let m=0;m<this.selectedToValues.length;m++){
                    var v = this.selectedToValues[m];
                    if(v==keyVal){
                    }else{
                        newList.push(this.selectedToValues[m]);
                    }
                }
                
                this.selectedToValues = newList;
            }
            
              
            // this.selectedToValues = [...this.toSelectedValuesMap.keys()];
            // this.selectedEmails = [...this.toSelectedValuesMap.values()];
            if(dataVal!=''){
                var newList1 = [];
                for(let m=0;m<this.selectedEmails.length;m++){
                    var v = this.selectedEmails[m];
                    if(v==dataVal){
                    }else{
                        newList1.push(this.selectedEmails[m]);
                    }
                }
                
                this.selectedEmails = newList1;
            }

            const tempArray = [];
            this.recordIdValMap.forEach(element => { 
                                        if(element.recordValue==item){

                                                                 }
                                                                    else{
                                                                    tempArray.push(element);
                                                                }});
            this.recordIdValMap = tempArray;
            
        }
        
        
    }else{
        this.toSelectedValuesMap.delete(item);
        this.selectedToValues = [...this.toSelectedValuesMap.keys()];
        this.selectedEmails = [...this.toSelectedValuesMap.values()];
        const tempArray = [];
        this.recordIdValMap.forEach(element => {
                                        if(element.recordValue==item){

                                                                 }
                                                                    else{
                                                                    tempArray.push(element);
                                                                }});
        this.recordIdValMap = tempArray;
       
       
    }
}
handleCcRemove(event) {
   
    const item = event.target.label;
    if(this.mode=='Reply'||this.mode=='reply'){
    
       
        if(this.ccSelectedValuesMap.size>0){
            //here I need to write remove logic
            var keyVal = '';
            var dataVal = '';
            
            for (const key of this.ccSelectedValuesMap.keys()){
                if(item == key){
                    keyVal = key;
                    dataVal = this.ccSelectedValuesMap.get(key);
                    this.ccSelectedValuesMap.delete(key);
                }
            }
           
            
            if(keyVal!=''){
                var newList = [];
                for(let m=0;m<this.selectedCcValues.length;m++){
                    
                    var v = this.selectedCcValues[m];
                   
                    if(v==keyVal){
                       
                    }else{
                       
                        newList.push(this.selectedCcValues[m]);
                    }
                }
                
                
                this.selectedCcValues = newList;
            }
            
              
            // this.selectedToValues = [...this.toSelectedValuesMap.keys()];
            // this.selectedEmails = [...this.toSelectedValuesMap.values()];
            if(dataVal!=''){
                var newList1 = [];
                for(let m=0;m<this.selectedccEmails.length;m++){
                   
                    var v = this.selectedccEmails[m];
                    
                    if(v==dataVal){
                       
                    }else{
                        
                        newList1.push(this.selectedccEmails[m]);
                    }
                }
                
               
                this.selectedccEmails = newList1;
            }

            const tempArray = [];
            this.recordIdccValMap.forEach(element => { 
                                        if(element.recordValue==item){
                                                                 }
                                                                    else{
                                                                    tempArray.push(element);
                                                                }});
            this.recordIdccValMap = tempArray;
        }
        
    }else{
        this.ccSelectedValuesMap.delete(item);
        this.selectedCcValues = [...this.ccSelectedValuesMap.keys()];

        this.selectedccEmails = [...this.ccSelectedValuesMap.values()];

        const tempArray = [];
        this.recordIdccValMap.forEach(element => {
                                        if(element.recordValue==item){

                                                                 }
                                                                    else{
                                                                    tempArray.push(element);
                                                                }});
        this.recordIdccValMap = tempArray;
    }
    
               
    
    
       
   
    
}


onSelect(event) {
    this.template.querySelector('input.input').value = "";
    let ele = event.currentTarget;
    let selectedId = ele.dataset.id;
    let selectedValue = this.items.find((record) => record.Id === selectedId);
    this.selectedValuesMap.set(selectedValue.Email, selectedValue.Name);
    this.selectedValues = [...this.selectedValuesMap.keys()];

    //As a best practise sending selected value to parent and inreturn parent sends the value to @api valueId
    let key = this.uniqueKey;
    const valueSelectedEvent = new CustomEvent("valueselect", {
        detail: { selectedId, key }
    });
    this.dispatchEvent(valueSelectedEvent);

    if (this.blurTimeout) {
        clearTimeout(this.blurTimeout);
    }
    this.boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
}
onToSelect(event) {
    
    var searchTemp = this.template.querySelector('input.input').value;
   
    if (searchTemp.lastIndexOf(';') != -1){
        searchTemp = searchTemp.substring(0,searchTemp.lastIndexOf(';'));
        this.template.querySelector('input.input').value = searchTemp;
    }
    else
        this.template.querySelector('input.input').value = "";
    
    let ele = event.currentTarget;
    let selectedId = ele.dataset.id;

    if(this.searchType ==="Groups")
    {//this code is for Groups
        let parameterMap = {};
        parameterMap['groupId'] = selectedId;
        let selectedToGrp = this.toItems.find((record) => record.Id === selectedId);
        this.toSelectedValuesMap.set(selectedToGrp.Name, selectedToGrp.Id);
        this.groupResult = selectedToGrp;

        getCollabGroupMemberIdsLWC({paramatersMap : parameterMap})
        .then(result => {
            
        if (result != null && result.length > 0) {
            result.forEach(element => {
                 
                element['GroupID']=selectedToGrp.Id;
                element['GroupName']=selectedToGrp.Name;
                
                this.populateSelectedToRecordIds(element);
            });
        }else{
           
        }   
    })
    .catch(error => {
        this.error = error;
    });
    }else{
        let selectedToValue = this.toItems.find((record) => record.Id === selectedId);
        this.toSelectedValuesMap.set(selectedToValue.Name, selectedToValue.Email);
        this.populateSelectedToRecordIds(selectedToValue);
    }


    
    if(this.mode == "Reply"||this.mode == "reply"){
        if(this.toSelectedValuesMap.keys())
        {
            for (let key of this.toSelectedValuesMap.keys()) {
                
                        if(this.selectedToValues.includes(key)){}
                        else{
                            
                            this.selectedToValues.push(key)
                        }
            }
        }
    }else{
        this.selectedToValues = [...this.toSelectedValuesMap.keys()];
    }
    

    //As a best practise sending selected value to parent and inreturn parent sends the value to @api valueId
    let key = this.uniqueKey;
    const valueSelectedEvent = new CustomEvent("valueselect", {
        detail: { selectedId, key }
    });
    this.dispatchEvent(valueSelectedEvent);

    if (this.blurTimeout) {
        clearTimeout(this.blurTimeout);
    }
    this.boxClassTO = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
}
onCcSelect(event) {
// added one comment jkjkjjl

    var searchTempCc = this.template.querySelector('input.inputCC').value;
   
    if (searchTempCc.lastIndexOf(';') != -1){
        searchTempCc = searchTempCc.substring(0,searchTempCc.lastIndexOf(';'));
        this.template.querySelector('input.inputCC').value = searchTempCc;
    }
    else
        this.template.querySelector('input.inputCC').value = "";

    
    let ele = event.currentTarget;
    let selectedId = ele.dataset.id;


    if(this.searchType ==="Groups")
    {//this code is for Groups
        let parameterMap = {};
        parameterMap['groupId'] = selectedId;
        let selectedCcGrp = this.ccItems.find((record) => record.Id === selectedId);
        this.ccSelectedValuesMap.set(selectedCcGrp.Name, selectedCcGrp.Id);
        this.groupResultCC = selectedCcGrp;
        

        getCollabGroupMemberIdsLWC({paramatersMap : parameterMap})
        .then(result => {
        
        if (result != null && result.length > 0) {
            result.forEach(element => {
                 
                
                element['GroupID']=selectedCcGrp.Id;
                element['GroupName']=selectedCcGrp.Name;
                
                this.populateSelectedCcRecordIds(element);
            });
        }else{
           
        }   
    })
    .catch(error => {
        this.error = error;
    });
    }else{
        let selectedCcValue = this.ccItems.find((record) => record.Id === selectedId);
        this.ccSelectedValuesMap.set(selectedCcValue.Name, selectedCcValue.Email);
        this.populateSelectedCcRecordIds(selectedCcValue);
    }


    if(this.mode == "Reply"||this.mode == "reply"){
        if(this.ccSelectedValuesMap.keys())
        {
            for (let key of this.ccSelectedValuesMap.keys()) {
               
                
                       
                        if(this.selectedCcValues.includes(key))
                           {}
                        else{
                           
                            this.selectedCcValues.push(key)
                        }
            }
        }
    }else{
        this.selectedCcValues = [...this.ccSelectedValuesMap.keys()];
    }



    

    //As a best practise sending selected value to parent and inreturn parent sends the value to @api valueId
    let key = this.uniqueKey;
    const valueSelectedEvent = new CustomEvent("valueselect", {
        detail: { selectedId, key }
    });
    this.dispatchEvent(valueSelectedEvent);

    if (this.blurTimeout) {
        clearTimeout(this.blurTimeout);
    }
    this.boxClassCC = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
}

handleSubjectChange(event) {
    this.subject = event.target.value;
    //alert('Subject on Change');
}
handleSubjectValidations(event) {
    this.subject = event.target.value;
    //alert('Subject on Blur');
}

handleBodyChange(event) {
    this.body = event.target.value;
}

validateEmails(emailAddressList) {
    let areEmailsValid;
    if(emailAddressList.length > 1) {
        
        for(let i=0; i<emailAddressList.length; i++){
            const isValid = this.validateEmail(emailAddressList[i]);
            if(!isValid){
                areEmailsValid = isValid;
                return areEmailsValid;
            }else{
                areEmailsValid = isValid;
            }
        }
    }
    else if(emailAddressList.length > 0) {
        areEmailsValid = this.validateEmail(emailAddressList[0]);
    }
    return areEmailsValid;
}

validateEmail(email) {
    
    
    // const res = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()s[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    // var b1 = res.test(String(email).toLowerCase());
    const emailRegx = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i;
    var b2 = emailRegx.test(String(email).toLowerCase());
    return b2;

}

handleReset() {
    this.toAddress = [];
    this.ccAddress = [];
    this.toItems = [];
    this.ccItems = [];
    this.subject = "";
    this.body = "";
    this.selectedCcValues = [];
    this.selectedToValues = [];
    this.files = [];
    this.returnSelectedFiles = [];

    this.toSelectedValuesMap.clear();
    this.ccSelectedValuesMap.clear();
    this.recordIdValMap = [];
    this.recordIdccValMap = [];
    this.selectedRecordIds = [];
    this.selectedEmails = [];
    this.selectedccRecordIds = [];
    this.selectedccEmails = [];
    this.ToIds=[];
    this.CCIds=[];
    
    this.sendACopyToMe = false;
    this.searchTerm = "";
    this.searchCCTerm = "";
    //Reset the Attachments data start
    this.fileData = [];
    this.currentAttachBatchSize = 0;
    this.fileCountIndex = 0;
    this.percentile = 0;
    this.filembSize = 0;
    this.contentData = [];
    this.attachmentList = [];
    this.attachedFileName = [];

    this.widthPercentage = 'width:0%';
    //Reset the Attachments data ends

    this.template.querySelector('lightning-input[data-name="active"]').checked = false; 
    this.template.querySelector('input[data-name="to"]').value = ""; 
    this.template.querySelector('input[data-name="cc"]').value = "";
    //this.template.querySelectorAll("c-email-input").forEach((input) => input.reset());
    // this.template.querySelectorAll("c-send-email-component").forEach((input) => input.value = null);
    const inputsTags = this.template.querySelectorAll('c-send-email-component');
    for (let itemIndex = 0; itemIndex < inputsTags.length; itemIndex++) {
        inputsTags[itemIndex].callingfromEmailComponent(); 
    }

}

populateIds(recordIdValMap,type){
    recordIdValMap.forEach(element => {
        if(type == 'To' && !this.ToIds.includes(element.recordId))
            this.ToIds.push(element.recordId);                    
        if(type == 'CC' && !this.CCIds.includes(element.recordId))                   
            this.CCIds.push(element.recordId);  
    })
}

handleSendEmail() {

    this.isLoading = true;
    this.noEmailError = false;
    this.invalidEmails = false;
    var attrMap = {};
    var ToManuals = [];
    var ccManuals = [];
    var grpToEmails = [];
    var grpNames = [];

    attrMap['isLast'] = false;
    attrMap['mode'] = 'Send';
    attrMap['emailFieldName'] = '';
    attrMap['oldTaskId'] = '';
    if(this.sendACopyToMe==undefined){
        this.sendACopyToMe = false;
    }
    attrMap['sendACopyToMe'] = this.sendACopyToMe;
    attrMap['toAddress'] = '';
    attrMap['ccAddress'] = '';


    if (!this.subject){
        this.isLoading = false;
        this.invalidSubject = true;
        this.errorMessage = 'Please add subject';
        setTimeout(() => {
            this.invalidSubject = false; 
            this.errorMessage = '';
        },5000 );
        return;
    }else{
        if(this.subject.length>229){
            this.isLoading = false;
            this.invalidSubject = true;
            this.errorMessage = 'Please add valid subject';
        setTimeout(() => {
            this.invalidSubject = false; 
        },5000 );
        return;
        }
    }
    if(this.body.length>28000){
        this.isLoading = false;
        this.noEmailError = true;
        this.errorMessage = 'Email body character limit is excceded';
        setTimeout(() => {
            this.noEmailError = false; 
            this.errorMessage = '';
        },5000 );
        return;
    }


    if(this.mode ==='Send' || this.mode ==='send'){
        /* Logic to read manual email address and it into the original ToEmails */
        //To
        if (this.searchTerm !="") {
            var items = this.searchTerm.split(';');
                    
                    for (let itemIndex = 0; itemIndex < items.length; itemIndex++) {
                        if (items[itemIndex].includes('@')) {
                            ToManuals.push(items[itemIndex]);
                        }
                    }
        }
       
        //cc
        if (this.searchCCTerm !="") {
            var items = this.searchCCTerm.split(';');
                    
                    for (let itemIndex = 0; itemIndex < items.length; itemIndex++) {
                        if (items[itemIndex].includes('@')) {
                            ccManuals.push(items[itemIndex]);
                        }
                    }
        }
        /*Logic End*/

        ////this will read data from map and add Ids to the ToIds and CCIds
        if(this.recordIdValMap)
        this.populateIds(this.recordIdValMap,"To");
        if(this.recordIdccValMap)
            this.populateIds(this.recordIdccValMap,"CC");

        attrMap['formattedToAddress'] = '';
        if(this.ToIds.length>0){
            attrMap['formattedToAddress'] =  this.ToIds.join(';');
        }
        attrMap['formattedCCAddress'] = '';
        if(this.CCIds.length>0){
            attrMap['formattedCCAddress'] =  this.CCIds.join(';');
        }

        //

        if(this.toMemberlist.length){
            for(let i=0;i<this.toMemberlist.length;i++){
                grpToEmails.push(this.toMemberlist[i].Member.Email);
                attrMap['formattedToAddress'] = this.toMemberlist[i].GroupID;
                grpNames.push(this.toMemberlist[i].GroupName);
            }
        }
        this.grpNamesList = grpNames;
    }else{
        /* Logic to read manual email address and it into the original ToEmails */
        //To
        if (this.searchTerm !="") {
            var items = this.searchTerm.split(';');
                    
                    for (let itemIndex = 0; itemIndex < items.length; itemIndex++) {
                        if (items[itemIndex].includes('@')) {
                            ToManuals.push(items[itemIndex]);
                        }
                    }
        }
        //cc
        if (this.searchCCTerm !=undefined) {
            var items = this.searchCCTerm.split(';');
                    
                    for (let itemIndex = 0; itemIndex < items.length; itemIndex++) {
                        if (items[itemIndex].includes('@')) {
                            ccManuals.push(items[itemIndex]);
                        }
                    }
        }

        if (this.searchTermReply !=undefined) {
            var items = this.searchTermReply.split(';');
                    
                    for (let itemIndex = 0; itemIndex < items.length; itemIndex++) {
                        if (items[itemIndex].includes('@')) {
                            ToManuals.push(items[itemIndex]);
                        }
                    }
        }
        
        //cc
        if (this.searchCCTermReply !=undefined) {
            var items = this.searchCCTermReply.split(';');
                    
                    for (let itemIndex = 0; itemIndex < items.length; itemIndex++) {
                        if (items[itemIndex].includes('@')) {
                            ccManuals.push(items[itemIndex]);
                        }
                    }
        }
       
        //read Ids
        if(this.recordIdValMap)
            this.populateIds(this.recordIdValMap,"To");
        if(this.recordIdccValMap)
            this.populateIds(this.recordIdccValMap,"CC");

        attrMap['formattedToAddress'] = '';
        if(this.formattedToIds!=undefined){
            var s = this.formattedToIds.split(';');
            for (let itemIndex = 0; itemIndex < s.length; itemIndex++) {
                this.ToIds.push(s[itemIndex]);
            }
            
        }
        //this.ToIds.push(this.formattedToIds);

        if(this.formattedCCIds!=undefined){
            var p = this.formattedCCIds.split(';');
            for (let itemIndex = 0; itemIndex < p.length; itemIndex++) {
                this.CCIds.push(p[itemIndex]);
            }
            
        }
        // this.CCIds.push(this.formattedCCIds);
        if(this.ToIds.length>0){

            attrMap['formattedToAddress'] =  this.ToIds.join(';');
        }
        attrMap['formattedCCAddress'] = '';
        if(this.CCIds.length>0){
            attrMap['formattedCCAddress'] =  this.CCIds.join(';');
        }
        
        if(this.toAddress!=undefined){
            if(this.toAddress.includes(';')){
                var p = this.toAddress.split(';');
                for (let itemIndex = 0; itemIndex < p.length; itemIndex++) {
                    this.selectedEmails.push(p[itemIndex]);
                }
            }else{
                this.selectedEmails.push(this.toAddress);
            }
            
            
        }

        if(this.ccAddress!=undefined){
            if(this.ccAddress.includes(';')){
            var p = this.ccAddress.split(';');
            for (let itemIndex = 0; itemIndex < p.length; itemIndex++) {
                this.selectedccEmails.push(p[itemIndex]);
            }
        }else{
            this.selectedccEmails.push(this.ccAddress);
        }
            
        }

        var tempObj = [];
        
        if(this.selectedEmails!=undefined&&ToManuals!=undefined){
            for(let i=0;i<ToManuals.length;i++){
                if(this.selectedEmails.includes(ToManuals[i])){
                }else{
                    tempObj.push(ToManuals[i]);
                }
            }
            ToManuals= tempObj;
        }

        //remove ccmanuals duplicatess

        var tempObjCC = [];
        
        if(this.selectedccEmails!=undefined&&ccManuals!=undefined){
            for(let i=0;i<ccManuals.length;i++){
                if(this.selectedccEmails.includes(ccManuals[i])){
                }else{
                    tempObjCC.push(ccManuals[i]);
                }
            }
            ccManuals= tempObjCC;
        }
    }

    

//currently Grp Name is coming from To Email list, remove it before validate email from groupNames list
    if (!this.selectedEmails.length > 0 && !ToManuals.length > 0 && !grpToEmails.length) {
        this.noEmailError = true;
        this.isLoading = false;
        this.errorMessage = 'Please add a recipient';
        setTimeout(() => {
            this.noEmailError = false; 
            this.errorMessage = '';
        },5000 );
        return;
    }
    if (!this.validateEmails([...this.selectedEmails, ...this.selectedccEmails, ...ToManuals, ...ccManuals])) {
        this.invalidEmails = true;
        setTimeout(() => {
            this.invalidEmails = false; 
        },5000 );
        return;
    }
    


    //this.parentId = "a1f4P00000CQyrQQAT";
    this.taskId = "";

    for (let itemIndex = 0; itemIndex < this.selectedEmails.length; itemIndex++) {
        if (this.selectedEmails[itemIndex].includes('@')) {
            // attrMap['toAddress'] += this.selectedToValues[itemIndex];
            attrMap['toAddress'] === '' ? attrMap['toAddress'] = this.selectedEmails[itemIndex]:attrMap['toAddress'] += ';' + this.selectedEmails[itemIndex]
        }
    }
    for (let itemIndex = 0; itemIndex < this.selectedccEmails.length; itemIndex++) {
        if (this.selectedccEmails[itemIndex].includes('@')) {
            // attrMap['ccAddress'] += this.selectedCcValues[itemIndex];
            attrMap['ccAddress'] === '' ? attrMap['ccAddress'] = this.selectedccEmails[itemIndex]:attrMap['ccAddress'] += ';' + this.selectedccEmails[itemIndex]
        }
    }
    /*Adding manual email addresses to ToEmails*/
    //To
    for (let itemIndex = 0; itemIndex < ToManuals.length; itemIndex++) {
        if (ToManuals[itemIndex].includes('@')) {
            // attrMap['toAddress'] += this.selectedToValues[itemIndex];
            attrMap['formattedToAddress'] === '' ? attrMap['formattedToAddress'] = ToManuals[itemIndex]:attrMap['formattedToAddress'] += ';' + ToManuals[itemIndex]
            attrMap['toAddress'] === '' ? attrMap['toAddress'] = ToManuals[itemIndex]:attrMap['toAddress'] += ';' + ToManuals[itemIndex]
        }
    }
    //cc
    for (let itemIndex = 0; itemIndex < ccManuals.length; itemIndex++) {
        if (ccManuals[itemIndex].includes('@')) {
            // attrMap['toAddress'] += this.selectedToValues[itemIndex];
            attrMap['formattedCCAddress'] === '' ? attrMap['formattedCCAddress'] = ccManuals[itemIndex]:attrMap['formattedCCAddress'] += ';' + ccManuals[itemIndex]
            attrMap['ccAddress'] === '' ? attrMap['ccAddress'] = ccManuals[itemIndex]:attrMap['ccAddress'] += ';' + ccManuals[itemIndex]
        }
    }

    /*Logic End*/

    /*Adding group email addresses to ToEmails*/
    //To
    for (let itemIndex = 0; itemIndex < grpToEmails.length; itemIndex++) {
        if (grpToEmails[itemIndex].includes('@')) {
            // attrMap['toAddress'] += this.selectedToValues[itemIndex];
            attrMap['toAddress'] === '' ? attrMap['toAddress'] = grpToEmails[itemIndex]:attrMap['toAddress'] += ';' + grpToEmails[itemIndex]
        }
    }
    
    // attrMap['toAddress'] = this.selectedToValues;
    // attrMap['ccAddress'] = this.selectedCcValues;

    
    if(this.returnSelectedFiles.length>0){
        var fileText = 'Links to Additional Attachments (Please find below links to additional attachments other than those attached to this email. Click the filename to view the attachment.):';
        for(let index=0; index < this.returnSelectedFiles.length;index++){
            // if($scope.queryFieldName){
            //     let hrefVal = $scope.contentVersionLinkList[index][$scope.queryFieldName] == undefined ? 'javascript:void(0)': $scope.contentVersionLinkList[index][$scope.queryFieldName];
            //     if($scope.parameterVal)
            //     hrefVal = hrefVal + $scope.parameterVal;
            //     senderDetails += '<br><a href='+encodeURI(hrefVal)+' target="_blank" >'+$scope.contentVersionLinkList[index].Title+'</a>';
            // }else if($scope.contentVersionLinkList[index].ContentUrl){
            //     let hrefVal = $scope.contentVersionLinkList[index].ContentUrl;
            //     senderDetails += '<br><a href='+encodeURI(hrefVal)+' target="_blank" >'+$scope.contentVersionLinkList[index].Title+'</a>';
            // }else{
                let hrefVal = this.returnSelectedFiles[index].id == undefined ? 'javascript:void(0)': this.returnSelectedFiles[index].id;
                fileText += '<br><a href='+'/'+encodeURI(hrefVal)+' target="_blank" >'+this.returnSelectedFiles[index].title+'</a>';
            //}
        }
        attrMap['body'] = fileText + this.body;
    }else{
        attrMap['body'] = this.body;
    }
    attrMap['subject'] = this.subject;

    // Check for Attachment Present..
    if (this.fileData.length>0) {
        attrMap['isAttachNotPresent'] = false;
    } else {
        attrMap['isAttachNotPresent'] = true;
    }
    
    
    //here apex call for checking the suggestions
    sendEmailNew({parentId : this.parentId,taskId:this.taskId,attrMap : attrMap})
    .then(result => {
        // alert(JSON.stringify(result));
        if (result != null) {
            // alert(result);
            
            if (result.IsSuccess == true) {

                if(!this.fileData.length>0){
                    this.editMode = false;
                    this.emailSent = true;
                    this.isLoading = false;
                }
                this.returnMap = result;
                this.currentTaskId = result.TaskId;
                if(result.formattedToAddress==''){
                    // splitstoAddress = result.toAddress.split(';');
                    this.returnMap.formattedToAddress = result.toAddress;
                }else{
                    // splitstoAddress = result.formattedToAddress.split(';');
                    this.returnMap.formattedToAddress = result.formattedToAddress;
                }
                if(result.formattedCCAddress==''){
                    
                    // splitsccAddress = result.ccAddress.split(';');
                    this.returnMap.formattedCCAddress = result.ccAddress;
                }else{
                    // splitsccAddress = result.formattedCCAddress.split(';');
                    if(result.ccAddress.includes(result.fromAddress)&&this.returnMap.sendCopyToMe){
                        this.returnMap.formattedCCAddress = this.returnMap.formattedCCAddress+ ';' +result.fromAddress;
                    }else{
                        this.returnMap.formattedCCAddress = result.formattedCCAddress;
                    }
                    
                }
                
                if(this.returnMap.sendCopyToMe){
                    this.checkboxVal = true;
                }else{
                    this.checkboxVal = false;
                }

                

                

            } else {
                //here need to enter code
                this.invalidSubject = true;
                this.errorMessage = result.ErrorMsg;
                this.isLoading = false;
                setTimeout(() => {
                        this.invalidSubject = false; 
                        this.errorMessage = '';
                },5000 );
            return;
            }
            //Here need to call the Create Attachment logic
            if (this.fileData.length > 0) {
                //add here the map and put that map as argument
                var mapData = {};
                mapData['toAddress'] = result.toAddress;
                mapData['ccAddress'] = result.ccAddress;
                mapData['emailBody'] = result.body;
                mapData['subject'] = result.subject;
                mapData['mode'] = this.mode;
                mapData['parentId'] = this.parentId;
                mapData['taskId'] =  result.TaskId;
                
                this.uploadFileRemote(this.fileData,mapData);
                
            }

            //Attachment logic ends
            
        }else{
            
            
        }   
    })
    .catch(error => {
        this.error = error;
    });

}
toggleFileUpload() {
    this.wantToUploadFile = !this.wantToUploadFile;
}

handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    this.files = [...this.files, ...uploadedFiles];
    this.wantToUploadFile = false;
}

@api reset() {
    this.selectedValuesMap = new Map();
    this.selectedValues = [];
}

@api validate() {
    this.template.querySelector('input').reportValidity();
    const isValid = this.template.querySelector('input').checkValidity();
    return isValid;
}

populateSelectedToRecordIds(data){
    var result = {};
    var selectedId = '';
    var selectedValue = '';
    var selectedLabel = '';
    var selectedEmail = '';
    if(this.searchType ==="Groups"){
        result = this.groupResult;
        selectedValue = result.Id;
        selectedId = data.MemberId;
        
        selectedEmail = data.Member.Email;
    }else{
        this.isUserCheck = true;
        result = data;
        selectedValue = result.Name;//this is coming empty
        selectedId = data.Id;
        selectedEmail = data.Email;
    }
    selectedLabel = result.Name;
    if (selectedId != null && selectedValue != null) {
        if (this.searchType ==="Groups")
            this.recordIdValMap.push({ 'recordId': selectedValue, 'recordValue': selectedLabel });
        else {
            this.recordIdValMap.push({ 'recordId': selectedId, 'recordValue': selectedValue });
            this.results = [];
        }

        if (!this.selectedRecordIds.includes(selectedId))
            this.selectedRecordIds.push(selectedId);

        if (!this.selectedEmails.includes(selectedEmail))
            this.selectedEmails.push(selectedEmail);

        // if ($scope.searchItem.value.includes(';')) {
        //     if ($scope.isUserCheck)
        //         $scope.searchItem.value = searchItem;
        // }
        // else
        //     $scope.searchItem.value = '' + searchItem;
    }

}

populateSelectedCcRecordIds(data){
    var ccresult = {};
    var ccselectedId = '';
    var ccselectedValue = '';
    var ccselectedLabel = '';
    var ccselectedEmail = '';

    if(this.searchType ==="Groups"){
        ccresult = this.groupResultCC;
        ccselectedValue = ccresult.Id;
        ccselectedId = data.MemberId;
        
        ccselectedEmail = data.Member.Email;
    }else{
        this.isUserCheck = true;
        ccresult = data;
        ccselectedValue = ccresult.Name;//this is coming empty
        ccselectedId = data.Id;
        ccselectedEmail = data.Email;
    }
    ccselectedLabel = ccresult.Name;
    if (ccselectedId != null && ccselectedValue != null) {
        if (this.searchType ==="Groups")
            this.recordIdccValMap.push({ 'recordId': ccselectedValue, 'recordValue': ccselectedLabel });
        else {
            this.recordIdccValMap.push({ 'recordId': ccselectedId, 'recordValue': ccselectedValue });
            this.results = [];
        }

        if (!this.selectedccRecordIds.includes(ccselectedId))
            this.selectedccRecordIds.push(ccselectedId);

        if (!this.selectedccEmails.includes(ccselectedEmail))
            this.selectedccEmails.push(ccselectedEmail);

        // if ($scope.searchItem.value.includes(';')) {
        //     if ($scope.isUserCheck)
        //         $scope.searchItem.value = searchItem;
        // }
        // else
        //     $scope.searchItem.value = '' + searchItem;
    }

}

populateSelectedToRecordIdsOld(rec){




if(this.parentGroup===undefined){

    this.memberMap['memberId']=rec.Member.Id;
    this.memberMap['member']=rec.Member.Email;
    this.memberList.push(this.memberMap);
    var dummyMap = {};
    dummyMap[rec.Id]=this.memberList;
    this.parentGroup = dummyMap;
    
    
}else{
    
    var tempArray = this.parentGroup[rec.Id];
    var tempMap = {};
    tempMap['memberId']=rec.Member.Id;
    tempMap['member']=rec.Member.Email;
    tempArray.push(tempMap);
    this.parentGroup[rec.Id] = tempArray;
}


// toresult = {};
// toselectedId = '';
// selectedValueGrp = '';
// selectedLabel = '';
// selectedEmail = '';





//

}

//new methods added for File Attachments 


    openfileUpload(event) {
        const file = event.target.files[0]
        let singleFile;

        this.fileCountIndex++;
        if(this.fileCountIndex>10){
            this.fileCountIndex--;
            this.attachmentSizeError = true;
            this.errorMessage = 'Do not attach more than 10 Files, Attachment limit is Exceeded.';
            setTimeout(() => {
                this.attachmentSizeError = false;
                this.errorMessage = '';
            },5000 );
        }else{
            


            var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                singleFile = {
                    'filename': file.name,
                    'base64': base64,
                    'recordId': this.recordId,
                    'fileSize': file.size,
                    'type': file.type
                };
                
                this.createAttachTable(singleFile);//checking duplicates and sizees limitations
               
            }
            reader.readAsDataURL(file)
        }
        
    }

    //method to call backend logic of Upload files 
    uploadFileRemote(fileDetails,mapData){
        
        var loopLimit = this.fileData.length - 1;
        if(this.counter<loopLimit){
            mapData['UploadDone'] =  false;
        }
        if(this.counter == loopLimit){
            mapData['UploadDone'] =  true;
        }
        uploadAttachmentFiles({mapData : mapData,fileDetails : fileDetails[this.counter]})
        .then(result => {
        //alert(JSON.stringify(result));
            if (result != null) {
                // alert(result);
                
                if (result.IsSuccess == true) {
                        if(result.isUploadDone){
                        this.editMode = false;
                        this.emailSent = true;
                        this.isLoading = false;
                        
                            if(result.AttachId.length){
                                for(let index=0; index < result.AttachId.length;index++){
                                    //https://ggf-dev18-dev-ed--ggdev18.visualforce.com/sfc/servlet.shepherd/version/download/0684P00000RmCUrQAN
                                    let url = this.baseURL+'/sfc/servlet.shepherd/version/download/'+result.AttachId[index].Id;
                                    result.AttachId[index].URL = url;
                                    
                                    
                                }
                            }
                            this.contentData = result.AttachId;
                        }else{
                            this.counter = this.counter +1;
                            this.uploadFileRemote(fileDetails,mapData);
                        }
                
                }else {
                    //here need to enter code
                    this.attachmentSizeError = true;
                    this.errorMessage = result.ErrorMsg;
                    setTimeout(() => {
                            this.attachmentSizeError = false; 
                            this.errorMessage = '';
                    },5000 );
                return;
                }
            }
        })
        .catch(error => {
            
            this.attachmentSizeError = true;
            this.errorMessage =error.body.message +'Try with smaller size of attachments';
            setTimeout(() => {
                this.attachmentSizeError = false;
                this.errorMessage = '';
            },5000 );
        });
        
    }
    checkDuplicateFile(singleFile){
       
        if(this.fileData.length){
            for(let i=0;i<this.fileData.length;i++){
                
            }
        }
    }

    handleRemoveAttachmentFiles(event){
        var newData = [];
        var tempSize;
       
        var recName = event.currentTarget.dataset.id;
        for(let l=0;l<this.fileData.length;l++){
            var v = this.fileData[l];
            if(v.filename==recName){
                tempSize = v.fileSize;
            }else{
                newData.push(this.fileData[l]);
            }
        }
        this.currentAttachBatchSize = this.currentAttachBatchSize - tempSize;
        this.filembSize = this.currentAttachBatchSize / 1000000;
        this.filembSize = (Math.round(this.filembSize * 100) / 100).toFixed(2);
        this.newVal = this.currentAttachBatchSize / this.maxFileSize * 100;

        

        this.fileData = newData;
        var newList = [];
        for(let m=0;m<this.attachedFileName.length;m++){
            var v = this.attachedFileName[m];
            if(v==recName){
            }else{
                newList.push(this.attachedFileName[m]);
            }
        }
        
        this.attachedFileName = newList;
        this.fileCountIndex--;
        this.provideProgressDetail(this.newVal, this.filembSize);
       

    }

    createAttachTable(singleFile) {
        var checkFileDuplicate = false;
        var fName = singleFile.filename;
        if (this.attachedFileName.indexOf(fName) !== -1) {
            checkFileDuplicate = true;
        }
        
        // To Check Duplicate File Name Value..
        if (checkFileDuplicate) {
            
            this.fileCountIndex--;
            this.attachmentSizeError = true;
            this.errorMessage = 'File with this name already exist.';
            setTimeout(() => {
                this.attachmentSizeError = false;
                this.errorMessage = '';
            },5000 );
        } else {
            
                if (this.currentAttachBatchSize == undefined || this.currentAttachBatchSize == 0) {
                    this.currentAttachBatchSize = 0 + singleFile.fileSize;
                } else {
                    this.currentAttachBatchSize = this.currentAttachBatchSize + singleFile.fileSize;
                }

                // Check if File Size Exceed Attachments Limits.
                if (this.maxFileSize <= this.currentAttachBatchSize) {
                    
                    this.fileCountIndex--;
                    this.currentAttachBatchSize = this.currentAttachBatchSize - singleFile.fileSize;
                    this.attachmentSizeError = true;
                    this.errorMessage = 'Total File Size Limit is Exceeded';
                    setTimeout(() => {
                        this.attachmentSizeError = false; 
                        this.errorMessage = '';
                    },5000 );
                } else if (this.singleFileSize < singleFile.fileSize) {
                    
                    this.fileCountIndex--;
                    this.currentAttachBatchSize = this.currentAttachBatchSize - singleFile.fileSize;
                    this.attachmentSizeError = true;
                    this.errorMessage = 'Single File Size Limit is Exceeded';
                    setTimeout(() => {
                        this.attachmentSizeError = false; 
                        this.errorMessage = '';
                    },5000 );
                }
                else {
                    this.filembSize = this.currentAttachBatchSize / 1000000;
                    this.filembSize = (Math.round(this.filembSize * 100) / 100).toFixed(2);
                    if (this.maxFileSize == singleFile.fileSize) {
                        // $scope.progreescolor = 'red';
                    } else {
                        // $scope.progreescolor = 'green';
                    }
                    
                    this.attachedFileName.push(singleFile.filename);
                    this.fileData.push(singleFile);
                    // this.attachmentList.push(att);
                    this.newVal = this.currentAttachBatchSize / this.maxFileSize * 100;

                            // call progress details
                            this.provideProgressDetail(this.newVal, this.filembSize);

                    
                }
            
        }

    }
    provideProgressDetail(newVal, filembSize){
        this.percentile = newVal;
        this.widthPercentage = 'width:'+newVal +'%';
    }


}