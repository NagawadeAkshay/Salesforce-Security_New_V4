import { LightningElement,api, track } from 'lwc';

export default class AlternateRendering extends LightningElement {
    @api fieldApiName;
    @api fieldDetails;
    @api type;
    @api mode;
    @api value;
    @api hideSelectAll;


    @track checkboxValues = [];
    isUpdatedCheckboxValue = false; 
    @track radioValue
    isUpdatedRadioValue = false; 
    @track checkBoxOptions = [];//checkbox
    @track radioOptions = [];

    connectedCallback(){
    }

    get checkBoxOption(){
        let displayMap = JSON.parse(this.fieldDetails.altRenderDisplayValue);
        this.checkBoxOptions =[];
        if(this.type?.toLowerCase() === 'checkbox' && !this.mode && Object.keys(displayMap).length > 1 && this.hideSelectAll === false && !this.fieldDetails.isPicklistTypeField){
            this.checkBoxOptions = [{label:'Select/Unselect All', value:'selectAll'}];
        }
        for (let key in displayMap) {
            this.checkBoxOptions.push({ label: displayMap[key], value: key }); 
        }
        
        let sortOrder = JSON.parse(this.fieldDetails.altRenderSortOrderMap);
        this.checkBoxOptions.sort((a, b) => {
            return sortOrder[a.value] - sortOrder[b.value];
        });
        return this.checkBoxOptions;
    }

    get radioOption() {
        let displayMap = JSON.parse(this.fieldDetails.altRenderDisplayValue);
        this.radioOptions = [];

         for (let key in displayMap) {
            this.radioOptions.push({ label: displayMap[key], value: key }); 
        }
        
        let sortOrder = JSON.parse(this.fieldDetails.altRenderSortOrderMap);
        this.radioOptions.sort((a, b) => {
            return sortOrder[a.value] - sortOrder[b.value];
        });
        return this.radioOptions;
    }

    get selectedValues(){
        if(this.isUpdatedCheckboxValue){
            return this.checkboxValues;
        }
        return  JSON.parse(this.value)?.[this.fieldApiName] != null ? JSON.parse(this.value)?.[this.fieldApiName].split(';') : [];
    }
    
    get radioValueSelect(){
        if(this.isUpdatedRadioValue){
            return this.radioValue;
        }
        return JSON.parse(this.value)?.[this.fieldApiName] != null ? JSON.parse(this.value)?.[this.fieldApiName] : '';
    }

    get isCheckbox(){
        return this.type?.toLowerCase() === 'checkbox';
    }

    get isRadio(){
        return this.type?.toLowerCase() === 'radio';
    }

    handleChange(event) {
        const selectedValue = event.detail.value;
        this.isUpdatedCheckboxValue = false;
        if (selectedValue && Array.isArray(selectedValue)) {
            let updatedValues;
            if(this.fieldDetails.isPicklistTypeField){
                updatedValues= selectedValue.filter(item => item !== this.checkboxValues[0]);
                this.checkboxValues = updatedValues;
                this.isUpdatedCheckboxValue = true;
            }else{
                if( this.checkBoxOptions.length == this.checkboxValues.length + 2){
                    updatedValues = selectedValue.filter(value => value !== 'selectAll');
                }else if (selectedValue.includes('selectAll')) {
                    if(selectedValue.length === this.checkBoxOptions.length - 1){
                        updatedValues = selectedValue.filter(value => value !== 'selectAll');
                    }else{
                        updatedValues = this.checkBoxOptions.map(option => option.value);
                    }
                }else if (selectedValue.length === this.checkBoxOptions.length - 1 &&  this.hideSelectAll === false) {
                    updatedValues = [];
                } else {
                    updatedValues = selectedValue.filter(value => value !== 'selectAll');
                }
                this.checkboxValues = updatedValues;
                this.isUpdatedCheckboxValue = true;
            }

            const detail = { selectedValue: updatedValues.filter(value => value !== 'selectAll').join(';'),
                        fieldApiName : this.fieldApiName}

            this.dispatchCustomEvent('selectvalue',detail);
        }else {
            console.error('Selected value is not an array or is undefined:', selectedValue);
        }
    }

    dispatchCustomEvent(eventName, detail) {
        const customEvent = new CustomEvent(eventName, { detail });
        this.dispatchEvent(customEvent);
    }

    handleRadioChange(event) {
        this.radioValue = event.detail.value;
        this.isUpdatedRadioValue = true;
        const selectValueEvent = new CustomEvent('selectvalue', {
            detail: { selectedValue: this.radioValue, fieldApiName: this.fieldApiName }
        });
        this.dispatchEvent(selectValueEvent);
    }

}