import { LightningElement, api, track, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import getPageTemplateDetails from "@salesforce/apex/FlexLayoutController.getPageTemplateDetails";
import getProgressBarAndHeaderInst from "@salesforce/apex/FlexLayoutController.getProgressBarAndHeaderInst";

export default class LayoutHeaderInstructions extends LightningElement {
    @api headerInstructions;
    @api recordId;
    currentPageReference = "";
    pageTemplateId = "";
    showConfigError = false;
    instructionString;
    visiblePart;
    hiddenPart;
    @track
    showTextLabel = "...view more";
    displayShowMoreButton = true;

    @wire(CurrentPageReference)
    getPageContext(data) {
        if (data) {
            this.currentPageReference = JSON.parse(JSON.stringify(data));
            try {
                for (const param in this.currentPageReference.state) {
                    if (param.startsWith("c__")) {
                        this.currentPageReference.state[param] = window.atob(this.currentPageReference.state[param]);
                    }
                }
                
            } catch (error) {
                console.error("URL entered is invalid::", JSON.stringify(error));
            }
            if (this.currentPageReference.state.c__Mode && this.currentPageReference.state.c__Mode == "edit") {
                this.context = "Edit";
            }
        }
    }

    connectedCallback() {
        if (!this.headerInstructions) {
            getPageTemplateDetails({
                recId: this.recordId,
                templateName: null,
                urlVal: JSON.stringify(this.currentPageReference)
            })
                .then((data) => {
                    let dataObject = JSON.parse(data);
                    if (dataObject.isError) {
                        console.error(dataObject.errorMessage);
                        this.showConfigError = true;
                    } else {
                        this.pageTemplateId = dataObject.pageLayoutId;
                        return getProgressBarAndHeaderInst({
                            templateId: this.pageTemplateId,
                            recId: this.recordId
                        });
                    }
                })
                .then((data) => {
                    let dataObject = JSON.parse(data);
                    if (dataObject.isError) {
                        console.error(dataObject.errorMessage);
                        this.showConfigError = true;
                    } else {
                        if (dataObject.headerInstructions) {
                            this.headerInstructions = dataObject.headerInstructions;
                            this.processHeaderInstructionsString();
                        } else {
                            this.showConfigError = false;
                        }
                    }
                })
                .catch((error) => {
                    console.error("error in ccb of header instructions", JSON.stringify(error));
                    this.showConfigError = true;
                });
        } else {
            this.processHeaderInstructionsString();
        }
    }

    processHeaderInstructionsString() {
        if (this.headerInstructions.length < 200) {
            this.displayShowMoreButton = false;
            this.instructionString = this.headerInstructions;
        } else {
            this.visiblePart = this.headerInstructions.slice(0, 200);
            this.hiddenPart = this.headerInstructions.slice(200);
            this.instructionString = this.visiblePart;
        }
    }

    headerInstructionClickHandler() {
        if (this.showTextLabel == "...view more") {
            const element = this.template.querySelector(".header-Instruction-text");
            element.classList.remove("show-less");
            element.classList.add("show-more");
            this.showTextLabel = "...view less";
            this.instructionString = this.visiblePart + this.hiddenPart;
        } else {
            const element = this.template.querySelector(".header-Instruction-text");
            element.classList.remove("show-more");
            element.classList.add("show-less");
            this.showTextLabel = "...view more";
            this.instructionString = this.visiblePart;
        }
    }
}