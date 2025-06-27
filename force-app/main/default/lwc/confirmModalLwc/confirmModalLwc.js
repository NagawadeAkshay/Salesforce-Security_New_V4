import { api } from "lwc";
import LightningModal from "lightning/modal";
import GOVGRANTS from "@salesforce/resourceUrl/GovGrants";
import { loadStyle } from "lightning/platformResourceLoader";

export default class ConfirmModalLwc extends LightningModal {
    @api label;
    @api message;
    @api enablePromptInputDialog;
    Comment='';

    connectedCallback() {
        loadStyle(this, GOVGRANTS + "/Component/CSS/flexviewlayoutLwc.css").then(() => {
        });
    }

    handleContinueClick() {
        this.close(true);
    }

    handleCancelClick() {
        this.close(false);
    }
}