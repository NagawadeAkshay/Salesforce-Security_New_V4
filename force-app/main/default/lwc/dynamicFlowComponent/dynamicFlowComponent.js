import { LightningElement, api } from "lwc";

export default class DynamicFlowComponent extends LightningElement {
    @api flowName;
    @api params = [];

    renderedCallback() {
        this.template.querySelector("lightning-flow").startFlow(this.flowName, this.params);
    }

    handleStatusChange(event) {
    }
}