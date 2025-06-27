import { LightningElement, api, track} from 'lwc';

export default class Fieldlwc extends LightningElement {

    @api record;
    @api fieldName;
    @api fieldType;
    //@api tableMetaData;
    @api tableId;
    @api type;
    @api mode;
    @api fieldMetaData;
    @api timeZone;
    @api fieldConfig;
    @api column;
    //@api gridLevel;
    readonly ;
    @track isView;
    @track options;
    @track showDateTimeDropdown = false;
    @api stringParameters;
    @api listParameters;
    @api communityUrl;
    value;
    label;
    formatter;
   // options;
    formatter;
    step;
    isUrl= false;
    minimumFractionDigit;
    selectedValue;
    selectedValues=[];
    GlobalSaveMap={};
    updatedValue;
    onchange=false;
    fieldnameforevent;
    SobjectApi;
    lookupfieldapi;
    LookupDisplayFields;
    hoverValue
    RenderType;
    filterclause
    showfalse= false;
    showtrue = false;
    @api openDropDownAtTopSide;
    
    connectedCallback(){
        this.showDateTimeDropdown = false;
        this.setValues('');
    }

   /* renderedCallback(){
        this.setValues();
    
    }*/


    @api
    editRecord(recordId){
    
        if(this.record.id === recordId){
            this.setValues();
        }
    }

    @api
    setValues(){
        
        this.fieldnameforevent = this.fieldName;
        //this.record = [...this.record];
        this.isView = this.record['isEdit'] === false ? true : this.column.readOnly == true ? true:false;
        this.isEdit = this.record['isEdit'] === true ? this.column.isReference === true ? false : true : true;
        if((this.column.readOnly == false && this.isEdit == true ) || this.isView == true ){
        if(this.fieldType != undefined && this.fieldType != '' && this.record != undefined && this.record != ''){
        
            switch(this.fieldType){
                case 'text' :
                    this.isText = true;
                    this.value  = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';

                    break;
                case 'number' :
                    this.isNumber = true;
                    //this.type = 'number';
                    this.value    = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    this.minimumFractionDigit = this.column.isReference === true ? this.fieldMetaData.ReferenceFieldInfo.Scale : this.fieldMetaData.Scale;

                    break;
                case 'percent':
                    this.formatter = 'percent';
                    //this.type = 'number';
                    this.isNumber = true;
                    if(this.record.isEdit === false){
                        this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] / 100 : '';
                        this.minimumFractionDigit = this.column.isReference === true ? this.fieldMetaData.ReferenceFieldInfo.Scale :this.fieldMetaData.Scale;
                    
                    }else{
                    
                        this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                        this.minimumFractionDigit =this.column.isReference === true ? this.fieldMetaData.ReferenceFieldInfo.Scale : this.fieldMetaData.Scale;
                    
                    }
                    
                    break;

                case 'currency' :
                    this.formatter = 'currency';
                    //this.type = 'number';
                    this.isNumber = true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    this.minimumFractionDigit = this.column.isReference === true ? this.fieldMetaData.ReferenceFieldInfo.Scale :this.fieldMetaData.Scale;
                    break;

                case 'url' :
                    if(this.record.isEdit === true){
                        if(this.column.isLookup === true){
                            if(this.record.isNew === true){
                                if(this.fieldConfig != undefined){
                                    if(this.fieldConfig.DefaultValue != undefined){
                                        let defaultVavue = JSON.parse(this.fieldConfig.DefaultValue);
                                        this.onloadid = defaultVavue.Id != undefined ? defaultVavue.Id : undefined;

                                    }
                                }
                            }else{
                                this.onloadid = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase().replace('.name','.id')]:'';

                            }
                            this.SobjectApi = this.column.SobjectName;
                            this.lookupfieldapi = this.column.FieldMetaData.ReferenceFieldInfo.Name;
                            this.LookupDisplayFields = this.column.lookupDetails.DisplayLookupFields != undefined ? this.column.lookupDetails.DisplayLookupFields : '';
                            this.filterclause = this.fieldConfig != undefined ? this.fieldConfig.WhereClause != undefined ? this.fieldConfig.WhereClause : '' : '';
                            //this.RenderType = this.fieldConfig != undefined ? this.fieldConfig.RenderType != undefined ? this.fieldConfig.RenderType ==='Autosuggest' ? true : false : false;
                           
                        }else{
                            if(this.isEdit === false){
                            
                                // this.isUrl=true;
                                // this.label = this.record[this.fieldName.toLowerCase()];
                            }else if(this.isEdit === true){
                            
                                // this.isUrl=false;
                             this.isText = true;
                            this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : undefined;

                            }
                        
                        }
                    }else if(this.record[this.fieldName.toLowerCase()] != undefined && this.record['isTotal'] != undefined && this.record['isTotal'] == true){
                        this.isText = true;
                        this.value  = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';

                    }else{
                    
                        this.isUrl=true;
                       
                        this.label = this.record[this.fieldName.toLowerCase()];
                    }
                   
                    break;

                case 'date' :
                    this.isDateTime =true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    break;
                case 'date-local' :
                    this.isDate =true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    
                    break;
                case 'base64' :
                    
                    if(this.fieldConfig != undefined && this.fieldConfig.EscapeHtml === true){
                    this.isbase64 =true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    if(this.value === '<p></p>' && this.fieldName.toLowerCase() == 'content' ){
                        this.value = '';   
                    }
                    if(this.value != undefined){
                        this.hoverValue = this.value.toString().replace(/<[^>]*>/g,''); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                    }
                }else if(this.fieldMetaData.Type === 'TEXTAREA' && this.isEdit=== true){
                    this.isbase64 =true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    if(this.value != undefined){
                        this.hoverValue = this.value.toString().replace(/<[^>]*>/g,''); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                    }
                }else{
                    this.isText = true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    if(this.value === '<p></p>' && this.fieldName.toLowerCase() == 'content' ){
                        this.value = '';   
             		}
                }
                    
                    break;
                case 'boolean' :
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : undefined;
                    if(this.value === true){
                        this.showtrue = true;
                    }else if(this.value === false){
                        this.showfalse = true;
                    }
                    this.isboolean = true;
                    break;
                case 'picklist' :
                    if(this.isView === true){
                        this.isText = true;
                        this.isPickList = false;
                        if(this.fieldMetaData.Type == 'REFERENCE'){
                            this.value =  this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.FieldPicklistValueLabelMap != undefined && this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.FieldPicklistValueLabelMap[this.record[this.fieldName.toLowerCase()]] != undefined ? this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.FieldPicklistValueLabelMap[this.record[this.fieldName.toLowerCase()]] : this.record[this.fieldName.toLowerCase()];

                        }else{
                        
                            this.value =  this.fieldMetaData.PickListFieldInfo.FieldPicklistValueLabelMap != undefined && this.fieldMetaData.PickListFieldInfo.FieldPicklistValueLabelMap[this.record[this.fieldName.toLowerCase()]] != undefined ? this.fieldMetaData.PickListFieldInfo.FieldPicklistValueLabelMap[this.record[this.fieldName.toLowerCase()]] : this.record[this.fieldName.toLowerCase()];;

                        }
                    }else{
                        this.isText = false;
                        this.isPickList = true;
                        this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : undefined;
                        this.options = this.getPicklistOptions();
                    }
                    
                    break;
                 case 'combobox':
                            if (this.record.isEdit === false) {
                                this.isText = true;
                                this.isCombobox = false;
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : undefined;
                            } else {
                                this.isText = false;
                                this.isCombobox = true;
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : undefined;
                                this.options = this.getPicklistOptions();
                            }
    
                 break;
                case 'email' :
                    this.isemail = true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    break;
                case 'phone' :
                    this.isPhone = true;
                    this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                    break;
                case 'multipicklist' :
                    if(this.record.isEdit === false){
                        this.isText = true;
                        if(this.column.isReference === true){
                            this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';

                        }else{
                            this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.getPickListValues(this.record[this.fieldName.toLowerCase()]) : '';

                        }
                    }else{
                        this.isText = false;
                        this.isMultiPicklist = true;
                        this.selectedValues = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()].split(';') : [];
                        if(this.column.isReference === false){
                        this.options = this.getPicklistOptions();
                        }
                    }
                    break;
                    case 'formula' :
                        let type;
                        if(this.fieldMetaData.Type =='REFERENCE'){
                         type = this.fieldMetaData.ReferenceFieldInfo.Type;
                        }else{
                            type = this.fieldMetaData.Type;
                        }
                        switch(type.toLowerCase()){
                            case 'currency' :
                                this.formatter = 'currency';
                                this.isNumber = true;
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                                this.minimumFractionDigit = this.column.isReference === true ? this.fieldMetaData.ReferenceFieldInfo.Scale : this.fieldMetaData.Scale;
                                this.isView = true;
                                break;
                            case 'boolean' :
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : undefined;
                                this.isboolean = this.value === true || this.value === false ? true : false;
                                if(this.value === true){
                                    this.showtrue = true;
                                }else if(this.value === false){
                                    this.showfalse = true;
                                }
                                this.isView = true;
                                 break;
                            case 'number' :
                            case 'double' :
                                this.isNumber = true;
                                this.value    = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                                this.minimumFractionDigit = this.column.isReference === true ? this.fieldMetaData.ReferenceFieldInfo.Scale  : this.fieldMetaData.Scale;
                                this.isView = true;
                                break;
                            case 'percent' :   
                                this.formatter = 'percent';
                                this.isNumber = true;
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] / 100 : '';
                                this.minimumFractionDigit = this.column.isReference === true ?  this.fieldMetaData.ReferenceFieldInfo.Scale : this.fieldMetaData.Scale;
                                this.isView = true;
                                break;
                            case 'date' :
                                this.isDate =true;
                          
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                               
                                this.isView = true;
                                break;
                                
                            case 'datetime':
                                this.isDateTime =true;
                                this.isView = true;
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                                break;
                            default:
                                this.isformula = true;
                                this.value = this.record[this.fieldName.toLowerCase()] != undefined ? this.record[this.fieldName.toLowerCase()] : '';
                                this.isView = true;
                                break;
                                            
                        }
                   
                   
            }
            if(this.record.isNew){
               // this.value= this.fieldConfig.DefaultValue != undefined ? this.fieldConfig.DefaultValue : this.value;
            }       
        }
    }
    
    }


    getPicklistOptions(){
    
        let options =[];
        if(this.fieldMetaData.Type == 'REFERENCE'){
            if(this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.PickListKeyValueMapList != undefined){
            
                for(let i=0; i < this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.PickListKeyValueMapList.length; i++){
                    let valuemapNew={};
                    let valueMap = this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.PickListKeyValueMapList[i];
                    valuemapNew['label'] = valueMap.Label;
                    valuemapNew['value'] = valueMap.Value;
                    options.push(valuemapNew);
                }
            }
        }else{
            if(this.fieldMetaData.PickListFieldInfo.PickListKeyValueMapList != undefined){
            
                for(let i=0; i < this.fieldMetaData.PickListFieldInfo.PickListKeyValueMapList.length; i++){
                    let valuemapNew={};
                    let valueMap = this.fieldMetaData.PickListFieldInfo.PickListKeyValueMapList[i];
                    valuemapNew['label'] = valueMap.Label;
                    valuemapNew['value'] = valueMap.Value;
                    options.push(valuemapNew);
                }
            }
        }
       

        return options;
    }

    getPickListValues(value){
    
        let valueLabel='';
        if(value != undefined){
            let valueApiList = value.split(';');

            if(valueApiList != undefined && valueApiList.length > 0){
                
                for(let i=0; i < valueApiList.length; i++){
                    
                    valueLabel= this.fieldMetaData.Type == 'REFERENCE' ? valueLabel + this.fieldMetaData.ReferenceFieldInfo.PickListFieldInfo.FieldPicklistValueLabelMap[valueApiList[i]] + ';' :valueLabel + this.fieldMetaData.PickListFieldInfo.FieldPicklistValueLabelMap[valueApiList[i]] + ';';
                }
            }
        }

        return valueLabel;
    }

    handleInputChange(event){
        let value = event.detail.value;
        this.updatedValue =event.detail.value;
        this.fieldnameforevent = this.fieldName;
        this.onchange = true; 

        //this.setSaveRecord(value);
        //this.GlobalSaveMap[this.fieldName] = value;
    
    }

    @api
    setValuesOnUndo(){
        
        let value = this.value;
        this.updatedValue =value;
        this.fieldnameforevent = this.fieldName;
        //this.onchange = true; 
    }

    handleBooleanChange(event) {
        let value = event.target.checked; 
        this.updatedValue =event.target.checked;
        this.fieldnameforevent = this.fieldName;
        this.onchange = true;        
       // this.setSaveRecord(value);
        //this.GlobalSaveMap[this.fieldName] = value;
    }

    handleSelectOption(event){
        //this.updatedValue =event.detail;
        this.onchange = true;
        this.fieldnameforevent = this.fieldName;
        this.updatedValue='';
        if(this.fieldType == 'multipicklist'){
            for(let i=0; i < event.detail.length; i++){
                this.updatedValue =this.updatedValue+event.detail[i]+';';
            }     
            
        }else if(this.fieldType == 'picklist'){
        
            this.updatedValue=event.detail;
        } else if (this.fieldType == 'combobox') {
            this.updatedValue = event.detail;
        }
        //this.setSaveRecord(value);
    }
    /*setSaveRecord(value){
        let data={};
        data['recordId'] = this.record.id;
        data['value'] = value;
        data['fieldName'] = this.fieldName;
        //data['querryfields'] = this.tableMetaData.FlexTableConfigMap.QueryFieldsList;
        data['flexTableId']  =this.tableId;          //'a0P4P00000aOIhWUAW';//this.tableMetaData.FlexTableConfigMap.FlexTableConfig.FlexTableId;
       /* if(this.gridLevel === 0){
            const editevent =new CustomEvent('editrecord', {
                detail: data,
               // bubbles: false,
                //composed: false
            });
            this.dispatchEvent(editevent);
        
        }else if(this.gridLevel === 1){*/
        
           /* const editevent =new CustomEvent('childevent', {
                detail: data,
                bubbles: true,
                composed: true,
            });
            this.dispatchEvent(editevent);
        
       // }
       
    }*/

    @api
    setSaveRecord(){

        if(this.isView === false && this.column.isReference === false && (this.onchange === true || this.record.isNew === true || this.column?.isRequired)){
            var data={};
            data['recordId'] = this.record.id;
            data['value'] = this.updatedValue != undefined ? this.updatedValue : this.value;
            data['fieldName'] = this.fieldnameforevent;
            //data['querryfields'] = this.tableMetaData.FlexTableConfigMap.QueryFieldsList;
            data['flexTableId']  =this.tableId;          //'a0P4P00000aOIhWUAW';//this.tableMetaData.FlexTableConfigMap.FlexTableConfig.FlexTableId;
            data['isRequired'] = this.column.isRequired != undefined ? this.column.isRequired : false;
            return data;
        
        }

   
    }
           
       
    handlelookupvalue(event){

        if(Object.keys(event.detail.data).length > 0){
            
            this.updatedValue = event.detail.data.selectedRecordId != undefined && event.detail.data.selectedRecordId != '' ? event.detail.data.selectedRecordId : '';
            this.fieldnameforevent = event.detail.data.selectedRecordApiName != undefined && event.detail.data.selectedRecordApiName != '' ? event.detail.data.selectedRecordApiName : '';
            this.onchange = true;
        }
    } 
    handleDateTimeOnBlur(){
        this.showDateTimeDropdown =false;
    }
    handleDateTimeParentDivClick(event) {
        event.stopPropagation();
        return false;
    }
    handleDateTimeMouseOut() {
        if (this.showDateTimeDropdown == false && this.record && this.column) {
            this.dispatchEvent(new CustomEvent('updatestyle', {
                bubbles: true, composed: true,
                detail: {
                    tablescroll: true,
                    tblRecordId:this.record.id,
                    label:this.column.label
                }
            }));
        }
    }
    handleDateTimeMouseIn() {
        this.showDateTimeDropdown =true;
        if (this.record && this.column) {
            this.dispatchEvent(new CustomEvent('updatestyle', {
                bubbles: true, composed: true,
                detail: {
                    tablescroll: false,
                    tblRecordId: this.record.id,
                    label: this.column.label
                }
            }));
        }
    }
    
}