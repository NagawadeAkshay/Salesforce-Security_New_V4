import { LightningElement, api,wire, track} from 'lwc';
import geticons from '@salesforce/apex/AppUtils.getIcons'


export default class Spinner extends LightningElement {

    showSpinner;
    @api govGrantPleaseWaitIcon;
    @api isModal;
    SpinnerClass;
    
    error;  
    connectedCallback(){


            if(this.isModal === true){
                this.SpinnerClass ='spinner-overlay';
            }else{
                
                this.SpinnerClass ='rowLevelOverlay1';
            }
            this.showSpinner = true;
        
    }
    get show(){
        return this.showSpinner;
    }
    @api
    set show(show){ 
        this.showSpinner = show;
    }

}