import { LightningElement, wire, track, api } from 'lwc';
export default class FlexTableLWC extends LightningElement {

	
	@api recordId;
	@api mode;
    @api flexTableParameters;
    @api name; //='ApplicationBudgetCategoriesbyBudgetPeriodFormPD';
    @api flexGridType ='FlexTable';
    @api parentId;
    @api parentRecordId; 
    @api messageTimeOut=5000;
    @api stringParameters; 
    @api listParameters;

}