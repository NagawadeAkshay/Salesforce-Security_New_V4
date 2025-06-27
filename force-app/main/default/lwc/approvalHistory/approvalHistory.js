import { api, LightningElement, wire, track } from 'lwc';
import fetchApprovalHistory from '@salesforce/apex/ApprovalHistoryCtrl.fetchApprovalHistory';
import geticons from '@salesforce/apex/AppUtils.getIcons';

export default class ApprovalHistory extends LightningElement {
    @api recordId;
    @track showApprovalHistory = true
    @track approvalHistory = [];
    @track errorMessage
    @track isAutomated = false
    @track isAutomatedStatus;
    records;
	govGrantPleaseWaitIcon;
    @track isLoading = true;
    @track showIcon = false;

    connectedCallback(){
        geticons({strResourceName : 'govGrantPleaseWaitIcon'})
        .then(result=>{
            if(result){
                this.govGrantPleaseWaitIcon = result;
                this.showIcon = true;
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
    @wire(fetchApprovalHistory, { recordId: '$recordId' })
    approvalHistoryResponse(result) {
        if(result.data) {
             let approvalData = result.data.approvalHistory.approvals.map(item=>{
                
                let overallStatus = 'Started'
                let styleclass2;
                let stepName = ''
                if(item.listOfSteps[0].stepStatus != 'Started' && item.listOfSteps[0].pIHistory.ProcessNode != null && item.listOfSteps[0].pIHistory.ProcessNode.Name != null ){
                    if(item.listOfSteps[0].stepStatus =='Removed'){
                        stepName = 'Approval Request Recalled'
                    }else{
                        overallStatus = 'Pending';
                        stepName = 'Step : ' + item.listOfSteps[0].pIHistory.ProcessNode.Name + (item.listOfSteps[0].stepStatus=='Pending' ? (' (Pending for approval) ') : '')
                    }
                }else{
                    stepName = 'Approval Request Submitted'
                }

                
                if(item.listOfSteps[0].stepStatus != 'Started' && item.listOfSteps[0].stepStatus != 'NoResponse'){
                    if(item.listOfSteps[0].stepStatus =='Removed'){
                        overallStatus = 'Sent Back'
                    }else{
                        overallStatus = item.listOfSteps[0].stepStatus
                    }
                }

                if(item.listOfSteps[0].stepStatus == 'Rejected' ){
                    styleclass2 =  "font-size: 13px; padding-left:10px; color:#AD0000; font-weight:700;";
                }
                if(item.listOfSteps[0].stepStatus == 'Removed' ){
                    styleclass2 =  "font-size: 13px; padding-left:10px; color:#0017C8; font-weight:700;";
                }
                if(item.listOfSteps[0].stepStatus == 'Approved' ){
                    styleclass2 =  "font-size: 13px; padding-left:10px; color:#047A00; font-weight:700;";
                }
                if(item.listOfSteps[0].stepStatus == 'Pending' ){
                    styleclass2 =  "font-size: 13px; padding-left:10px; color:#0017C8; font-weight:700;";
                }

                return {...item,
                    "stepName":stepName,
                    "overAllStatus":overallStatus,
                    "isNotStarted" : overallStatus == 'Started' ? false : true,
                    "styleClass": styleclass2//item.listOfSteps[0].overAllStatus == 'Rejected' ? "background-color: #f18787; padding-left: 10px; font-size: 13px;" : "background-color: #a3ffb9; padding-left: 10px; padding-left:10px; font-size: 13px;",
                    
                    //"styleClass": overallStatus == 'Sent Back' ? "background-color: #bdb9b9; font-size: 13px;" : "background-color: #a3ffb9; font-size: 13px;"
                   //"styleClass": overallStatus == 'Pending' ? "background-color: #bdb9b9; font-size: 13px;" : "background-color: #83fcab; font-size: 13px;"

                }
            })

            this.approvalHistory = approvalData
			this.isLoading = false;
			setTimeout(() => {
                this.showIcon = false;
                }, 1000);
            if(approvalData.length == 0){
                this.errorMessage = 'No Records Found';
                //"styleClass": "background-color: #bdb9b9; font-size: 13px;"

            }
        }
        if(result.error){
            this.errorMessage = result.error.body.message
			this.isLoading = false;
            this.showIcon = false;
        }
    }

    get getToggleIcon(){
        return this.showApprovalHistory ? "utility:up" : "utility:down"
    }
    handleToggle(){
        this.showApprovalHistory = !this.showApprovalHistory;
    }

}