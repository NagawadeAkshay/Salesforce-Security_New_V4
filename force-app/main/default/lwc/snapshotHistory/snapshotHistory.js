import { LightningElement ,wire,track,api} from 'lwc';
import fetchAttachments from '@salesforce/apex/AttachmentsCtrl.fetchAttachments1';
import geticons from '@salesforce/apex/AppUtils.getIcons';
// Import custom labels
// import AttachmentFileName from '@salesforce/label/c.AttachmentFileName';
// import AttachmentDateTaken from '@salesforce/label/c.AttachmentDateTaken';
// import AttachmentTakenBy from '@salesforce/label/c.AttachmentTakenBy';
export default class SnapshotHistory extends LightningElement {
    records;
    @api parentId;
    @api pblockId;
    @api
    get pbTitle() {}
    set pbTitle(value) {
        this.title = value != null && value != "" ? value : "Snapshot History";
    }
    @api isView;
    isView1 = true;
    @api loadConfigData = false;
    @api isDigiSign = false;
    @api isHistory;
    isHistory1 = true
    noRecords = false;
    @track totalRecords;
    @track isCollapsed =false;
    @track collapsedicon = 'utility:up';
	alternativetext ="Expanded"
    showLoadingIcon = false;
    isLoading = true;
    // label = {
    //     AttachmentFileName,
    //     AttachmentDateTaken,
    //     AttachmentTakenBy,
    // };
    connectedCallback(){       
        geticons({strResourceName : 'govGrantPleaseWaitIcon'}).then(result=>{        
            if(result){
                this.govGrantPleaseWaitIcon = result;
        this.showLoadingIcon = true;   
        this.fetchRecords();
        setTimeout(() => {
        this.showLoadingIcon = false;  
         },1000);
            }else{
                this.fetchRecords();
            }       
        }).catch(error => {    
            this.error = error.message;  
            this.isLoading = false;         
        });       
      //  this.showLoadingIcon = true;   
       
       
         
    }
   
    // @wire( fetchAttachments, {parentObjectIds:'$parentId',pblockId:'$pblockId',isView:'$isView',loadConfigData:'$loadConfigData',isDigiSign:'$isDigiSign',isHistory:'$isHistory'})  
    // wiredAttachment( { error, data } ) {
    //     if (data) {
    //         this.records = JSON.parse( JSON.stringify( data.AttachmentList ) );
    //         if(this.records){
    //             this.records.forEach(item => item['AttachmentURL'] = '/servlet/servlet.FileDownload?file=' +item['attachmentId'] );                
    //         }            
    //         this.totalRecords = this.records.length;
    //         this.error = undefined;
    //     } else if ( error ) {
    //         this.error = error;
    //         this.records = undefined;
    //     }
    // }  
    fetchRecords(){
        fetchAttachments({parentObjectIds:this.parentId,pblockId:this.pblockId,isView:this.isView1,loadConfigData:this.loadConfigData,isDigiSign:this.isDigiSign,isHistory:this.isHistory1})
        .then(result => {
            this.records = JSON.parse( JSON.stringify( result.AttachmentList ) );
            if(this.records){
                this.records.forEach(item => item['AttachmentURL'] = '/servlet/servlet.FileDownload?file=' +item['attachmentId'] );                
            }
            this.totalRecords = this.records.length;
            if(this.totalRecords === 0){
                this.totalRecords = 'No Records Found';
            }else{
                this.totalRecords = 'Total Records : '+this.records.length;
            }
            this.error = undefined;
            this.isLoading = false;
        })
        .catch(error => {
            this.error = error;
            this.isLoading = false;
        });
    }  
    handleCollapsed(){
        this.isCollapsed = !this.isCollapsed;
        if(this.isCollapsed){
            this.collapsedicon = 'utility:down';
			this.alternativetext="Collapse";
        }else{
            this.collapsedicon = 'utility:up';
			this.alternativetext="Expanded";
            // fetchAttachments({parentObjectIds:this.parentId,pblockId:this.pblockId,isView:this.isView,loadConfigData:this.loadConfigData,isDigiSign:this.isDigiSign,isHistory:this.isHistory})
            //     .then(result => {
                
            //         let tempRows = JSON.parse( JSON.stringify( result.AttachmentList ) );
            //         let rows = [];
            //         for ( let i = 0; i <tempRows.length; i++ ) {               
            //             let row = tempRows[ i ];
            //             row.hrefVal = "/servlet/servlet.FileDownload?file=" +tempRows[i].attachmentId;               
            //             rows.push( row );
            //         }
            //         if(rows.length > 0){
            //             this.records = rows;
            //             this.initialRecords = rows;
            //             this.totalRecords = rows.length;
            //         }                    
            //         this.error = undefined;
            //     })
            //     .catch(error => {
            //         this.error = error;
            //     });
        }
    }

}