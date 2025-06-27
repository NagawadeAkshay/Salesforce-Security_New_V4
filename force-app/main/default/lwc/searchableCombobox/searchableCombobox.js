import { LightningElement, api, track } from "lwc";
import GOVGRANTS from "@salesforce/resourceUrl/GovGrants";
import { loadStyle } from "lightning/platformResourceLoader";

export default class SearchableCombobox extends LightningElement {
    isOpen = false;
    highlightCounter = null;
    _value = "";
    selectedId = "";
    @api messageWhenInvalid = "Please select a value";
    @api required = false;

    @api label = "";

    @track _options;

    @api
    get options() {
        return this._options;
    }

    set options(val) {
        this._options = val || [];
    }

    get tempOptions() {
        let options = this.options;
        if (this._value) {
            options = this.options.filter((op) => op.label.toLowerCase().includes(this._value.toLowerCase()));
        }
        return this.highLightOption(options);
    }

    get isInvalid() {
        return this.required && !this._value;
    }

    get formElementClasses() {
        let classes = "slds-form-element";
        if (this.isInvalid) {
            classes += " slds-has-error";
        }
        return classes;
    }

    connectedCallback() {
        loadStyle(this, GOVGRANTS + "/Component/CSS/flexviewlayoutLwc.css").then(() => {
        });
    }

    handleChange(event) {
        if (this.selectedId) {
            this.selectedId = "";
            this.dispactchSelectedId();
        }
        this._value = event.target.value;
    }

    handleInput(event) {
        this.isOpen = true;
    }

    dispactchSelectedId() {
        this.dispatchEvent(new CustomEvent("selected_id", { detail: { reassignTo: this.selectedId } }));
    }

    get classes() {
        let classes = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click";
        if (this.isOpen) {
            return classes + " slds-is-open";
        }
        return classes;
    }

    get inputClasses() {
        let inputClasses = "reassign-input-field slds-input slds-combobox__input";
        if (this.isOpen) {
            return inputClasses + " slds-has-focus";
        }
        return inputClasses;
    }

    allowBlur() {
        this._cancelBlur = false;
    }

    cancelBlur() {
        this._cancelBlur = true;
    }

    handleDropdownMouseDown(event) {
        const mainButton = 0;
        if (event.button === mainButton) {
            this.cancelBlur();
        }
    }

    handleDropdownMouseUp() {
        this.allowBlur();
    }

    handleDropdownMouseLeave() {
        if (!this._inputHasFocus) {
            this.showList = false;
        }
    }

    handleBlur() {
        this._inputHasFocus = false;
        if (this._cancelBlur) {
            return;
        }
        this.isOpen = false;

        this.highlightCounter = null;
        this.dispatchEvent(new CustomEvent("blur"));
    }

    handleFocus() {
        this._inputHasFocus = true;
        this.isOpen = true;
        this.highlightCounter = null;
        this.dispatchEvent(new CustomEvent("focus"));
    }

    handleSelect(event) {
        this.isOpen = false;
        this.allowBlur();
        this._value = event.currentTarget.dataset.label;
        this.selectedId = event.currentTarget.dataset.value;
        this.dispactchSelectedId();
    }

    highLightOption(options) {
        let classes = "slds-media slds-listbox__option slds-listbox__option_plain slds-media_small";

        return options.map((option, index) => {
            let cs = classes;
            let focused = "";
            if (index === this.highlightCounter) {
                cs = classes + " slds-has-focus";
                focused = "yes";
            }
            return { classes: cs, focused, ...option };
        });
    }

    renderedCallback() {
        this.template.querySelector("[data-focused='yes']")?.scrollIntoView();
    }
}