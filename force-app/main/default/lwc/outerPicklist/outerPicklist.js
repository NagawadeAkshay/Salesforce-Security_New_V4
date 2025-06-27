import { LightningElement, track, api } from 'lwc';
import GOVGRANTS from '@salesforce/resourceUrl/GovGrants';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
 
export default class OuterPicklist extends LightningElement {
    
    
    @api options;
    @api selectedValue;
    @api selectedValues = [];
    @api label;
    @api disabled = false;
    @api multiSelect = false;
    @track value;
    @track values = [];
    @track optionData;
    @track searchString;
    @track noResultMessage;
    @track showDropdown = false;
    @api isChildTable;
    @api uniqueId;
    @api isReadOnly;
    @api
    getTargetElement() {
       return this.template.querySelector('[data-id="pageChange"]');
   }
    connectedCallback() {

            loadStyle(this, GOVGRANTS+ '/Component/CSS/Flexgridlwc.css').then(() => {
            });

        this.showDropdown = false;
        var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
        var value = this.selectedValue ? (JSON.parse(JSON.stringify(this.selectedValue))) : null;
        var values = this.selectedValues ? (JSON.parse(JSON.stringify(this.selectedValues))) : null;
        this.checkData(value,values,optionData);
        /*if(value || values) {
            var searchString;
            var count = 0;
            for(var i = 0; i < optionData.length; i++) {
                if(this.multiSelect) {
                    if(values.includes(optionData[i].value)) {
                        optionData[i].selected = true;
                        count++;
                    }  
                } else {
                    if(optionData[i].value == value) {
                        searchString = optionData[i].label;
                    }
                }
            }
            if(this.multiSelect)
                this.searchString = count + ' Option(s) Selected';
            else
                this.searchString = searchString;
        }
        this.value = value;
        this.values = values;
        this.optionData = optionData;*/
    }


    renderedCallback(){
        if(this.template.querySelector(".dropdown-list-auto"))
        this.OpenDropdown();
    }
    checkData(value,values,optionData){
        
        if(value || values) {
            var searchString;
            var count = 0;
            for(var i = 0; i < optionData.length; i++) {
                if(this.multiSelect) {
                    if(values.includes(optionData[i].value)) {
                        optionData[i].selected = true;
                        count++;
                    }  
                } else {
                    if(optionData[i].value == value) {
                        searchString = optionData[i].label;
                    }
                }
            }
            if(this.multiSelect)
                this.searchString = count + ' Option(s) Selected';
            else
                this.searchString = searchString;
        }
        this.value = value;
        this.values = values;
        this.optionData = optionData;
    }
 
    filterOptions(event) {
        this.searchString = event.target.value;
        if( this.searchString && this.searchString.length > 0 ) {
            this.noResultMessage = '';
            if(this.searchString.length >= 2) {
                var flag = true;
                for(var i = 0; i < this.optionData.length; i++) {
                    if(this.optionData[i].label.toLowerCase().trim().startsWith(this.searchString.toLowerCase().trim())) {
                        this.optionData[i].isVisible = true;
                        flag = false;
                    } else {
                        this.optionData[i].isVisible = false;
                    }
                }
                if(flag) {
                    this.noResultMessage = "No results found for '" + this.searchString + "'";
                }
            }
            this.showDropdown = true;
            this.OpenDropdown();
            
        } else {
            this.showDropdown = false;
        }
    }
 
    selectItem(event) {
        var selectedVal = event.currentTarget.dataset.id;
        if(selectedVal) {
            var count = 0;
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === selectedVal) {
                    if(this.multiSelect) {
                        if(this.values.includes(options[i].value)) {
                            this.values.splice(this.values.indexOf(options[i].value), 1);
                        } else {
                            this.values.push(options[i].value);
                        }
                        options[i].selected = options[i].selected ? false : true;   
                    } else {
                        this.value = options[i].value;
                        this.searchString = options[i].label;
                    }
                }
                if(options[i].selected) {
                    count++;
                }
            }
            this.optionData = options;
            if(this.multiSelect){
                this.searchString = count + ' Option(s) Selected';

                let ev = new CustomEvent('selectoption', {detail:this.values});
                this.dispatchEvent(ev);
            }
                

            if(!this.multiSelect){
                let ev = new CustomEvent('selectoption', {detail:this.value});
                this.dispatchEvent(ev);
            }

            if(this.multiSelect)
                event.preventDefault();
            else
                this.showDropdown = false;
        }
    }

    @api
    setdata(PicklistValues,MultiPicklisstValues,Options){
        
        this.showDropdown = false;
        var optionData = this.options ? (JSON.parse(JSON.stringify(Options))) : null;
        var value = this.selectedValue ? (JSON.parse(JSON.stringify(PicklistValues))) : null;
        var values = this.selectedValues ? (JSON.parse(JSON.stringify(MultiPicklisstValues))) : null;
        this.checkData(value,values,optionData);
    }
 
    showOptions() {
        if(this.disabled == false && this.options) {
            this.noResultMessage = '';
            //this.searchString = '';
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                options[i].isVisible = true;
            }
            if(options.length > 0) {
                this.showDropdown = true;
            }
            this.optionData = options;
        }

        

    }

    OpenDropdown(){
    
        const multiPicklist = this.template.querySelector(".multiPicklist");
        const lookupInputContainer1 = this.template.querySelector(".multiPicklist").getBoundingClientRect().bottom;
        const lookupInputField = this.template.querySelector(".dropdown-list-auto");
        const h = window.innerHeight - lookupInputContainer1;
        
        if (h < 200) {
            if (lookupInputField) {
                lookupInputField.classList.remove("dropdown-top");
                lookupInputField.classList.add("dropdown-bottom");
            }
        } else {
            if (lookupInputField) {
                lookupInputField.classList.remove("dropdown-bottom");
                lookupInputField.classList.add("dropdown-top");
            }
        }

    }
 
    closePill(event) {
        var value = event.currentTarget.name;
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.optionData));
        for(var i = 0; i < options.length; i++) {
            if(options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
            }
            if(options[i].selected) {
                count++;
            }
        }
        this.optionData = options;
        if(this.multiSelect){
            this.searchString = count + ' Option(s) Selected';
            
            let ev = new CustomEvent('selectoption', {detail:this.values});
            this.dispatchEvent(ev);
        }
    }
 
    handleBlur() {
        var previousLabel;
        var count = 0;

        for(var i = 0; i < this.optionData.length; i++) {
            if(this.optionData[i].value === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if(this.optionData[i].selected) {
                count++;
            }
        }

        if(this.multiSelect){
            this.searchString = count + ' Option(s) Selected';
        }else{
            this.searchString = previousLabel;
        }

        this.showDropdown = false;
    }

    handleMouseOut(){
        this.showDropdown = false;
        this.OpenDropdown();
        
    }

    handleMouseIn(){
        this.showDropdown = true;
        this.OpenDropdown();
    }
}