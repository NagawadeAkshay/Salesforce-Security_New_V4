import { LightningElement, wire, track, api } from 'lwc';

export default class TaskSummaryLWC extends LightningElement {
    @api recordId;
    @api modalAttribute;
    @api controllerName;
    @api sOjectName;
    @api modalHeader;
     
}