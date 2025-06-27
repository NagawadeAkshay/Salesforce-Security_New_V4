import { LightningElement,wire, track,api } from 'lwc';
import getFlexTableInfo from '@salesforce/apex/FlexGridEnhancedCtrl.getFlexTableInfo';
import getPageRecordsMap from '@salesforce/apex/FlexGridEnhancedCtrl.getPageRecordsMap';
import getFlexGridInfo from '@salesforce/apex/FlexGridEnhancedCtrl.getFlexGridInfo';
import getInstance from '@salesforce/apex/FlexGridEnhancedCtrl.getInstance';
import { CurrentPageReference } from 'lightning/navigation';

//import getFlexTableInfo from '@salesforce/apex/FlexGridEnhancedCtrl.getFlexTableInfo';

export default class FlexGridlwc extends LightningElement {

    @api name; //='TestFlexGridEnhanced';
    @api flexGridType;  //='FlexGrid';
    level=0;
    @api parentRecordId; //= 'a1i4P000004uCVC';
    @api mode;
    paramJson;
    dataparamJsonRecord={};
    initResult={};
    initateGrid = false;
    result;
    parentdetail={};
    @api stringParameters; 
    @api listParameters;
    @api pageBlockId;
	_stringParameters = {};
	@api isModal;

    currentPageReference = null;
    @wire(CurrentPageReference)

    getPageContext(data) {

        if (data) {

            if (data) {

                this.currentPageReference = JSON.parse(JSON.stringify(data));
                try {
                    for (const param in this.currentPageReference.state) {
                        this.currentPageReference.state[param] = window.atob(this.currentPageReference.state[param]);
                    }
                } catch (error) {
            	}

            }

        }

    }


    @wire(getInstance)
    checkInstance({error, data}){
        if (data) {    
            this.isLightning = data;
        } else if (error) {
            console.error(error);
        }
    
    }
    isLightning= false;

    connectedCallback(){
        if(this._isJsonString(this.stringParameters)){
            this.stringParameters = JSON.parse(this.stringParameters);
        }
        if(this._isJsonString(this.listParameters)){
            this.listParameters = JSON.parse(this.listParameters);
        }

        if (this.stringParameters != undefined) {
            this._stringParameters = { ...this.stringParameters };
            this._stringParameters["pageBlockId"] = this.pageBlockId;
        } else {
            this._stringParameters["pageBlockId"] = this.pageBlockId;
        }
    
        this.paramJson={
            Name : this.name,
            flexGridType : this.flexGridType,
            level : this.level,
            parentRecordId : this.parentRecordId,
        };

        let srtingparameterMap ={};
            if(typeof this.stringParameters === 'string'){

                let stringParameterscommaseperatedstring =this.stringParameters != undefined ?  this.stringParameters.replace('"','') : this.stringParameters; //False +ve for incomplete - sanitization - as we are not using this for sanitization
                stringParameterscommaseperatedstring     = stringParameterscommaseperatedstring != undefined ? stringParameterscommaseperatedstring.replace('}','') : stringParameterscommaseperatedstring; //False +ve for incomplete - sanitization - as we are not using this for sanitization
                stringParameterscommaseperatedstring     = stringParameterscommaseperatedstring != undefined ? stringParameterscommaseperatedstring.replace('{','') : stringParameterscommaseperatedstring; //False +ve for incomplete - sanitization - as we are not using this for sanitization
    
                let afterStr = stringParameterscommaseperatedstring != undefined ? stringParameterscommaseperatedstring.split(',') : stringParameterscommaseperatedstring;
            
                let subStr = " ";
                let isList = false
                afterStr.forEach(item =>{
                    if(!isList && !item.includes('[') ){
                        subStr +=','+item
                    }else if(!isList && item.includes('[')  ){
                        if(item.includes(']')){
                        
                            subStr +=','+item
                            isList = false;
                        }
                        
                    } else if(isList && !item.includes(']')){
                        subStr +='/'+item
                    }else{
                        // subStr +='/'+item
                        // isList = false;

                        if(!isList){

                            subStr +=','+item;
        
                        }else{
        
                            subStr +='/'+item
        
                            isList = false;
                        }                    
                     }
                })

                let srtingparameterMap ={};
                let stringparamList = subStr.split(',').slice(1);
                 if(stringparamList != undefined && stringparamList.length > 0){
                    stringparamList.forEach(key=>{
                        let keyValueList = key.split(':');
                        if(keyValueList[1] != undefined && (keyValueList[1].includes('/') || keyValueList[1].includes('['))){
                          keyValueList[1] =  keyValueList[1].replaceAll('/',',');
                          keyValueList[1] =  keyValueList[1].replace(/'/g, '');
                          keyValueList[1] =  keyValueList[1].replace('[',''); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                          keyValueList[1] =  keyValueList[1].replace(']',''); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                          srtingparameterMap[keyValueList[0]] = keyValueList[1] != undefined ? keyValueList[1].split(',') : keyValueList[1];
                        }else{
                        
                            srtingparameterMap[keyValueList[0]] = keyValueList[1];
                        }
              
                    });
              
                }
                this.stringParameters = srtingparameterMap;

            }
        
        if(typeof this.listParameters === 'string'){
            this.listParameters =this.listParameters != undefined ?  this.listParameters.replace('"','') : this.listParameters; //False +ve for incomplete - sanitization - as we are not using this for sanitization
            this.listParameters = this.listParameters != undefined ? this.listParameters.replace('}','') : this.listParameters; //False +ve for incomplete - sanitization - as we are not using this for sanitization
            this.listParameters = this.listParameters != undefined ? this.listParameters.replace('{','') : this.listParameters; //False +ve for incomplete - sanitization - as we are not using this for sanitization
            let paramlist = this.listParameters != undefined ? this.listParameters.split('],') : this.listParameters;
            let parameterMap ={};
            if(this.listParameters != undefined && this.listParameters.length > 0){
                paramlist.forEach(key=>{
                    let keyValueList = key.split(':');
                    keyValueList[1] =  keyValueList[1].replace('[',''); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    keyValueList[1] =  keyValueList[1].replace(']',''); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                    let valueList = keyValueList[1] != undefined ? keyValueList[1].split(',') : keyValueList[1];
                    parameterMap[keyValueList[0]] = valueList;

                });
            }
            this.listParameters= parameterMap;
        }
        

       /*if(this.isLightning === false){
        
        var Id;
        let  url = window.location.href;
        if(url.includes('?')){
        
            Id = this.getParameterByName('id',url);
        }else{
            let urlcheck = url.split('.com/') ;
            Id =  urlcheck[1];
        
        }

        if(Id != undefined && (Id.length === 15 || Id.length === 18) && this.parentRecordId === undefined){
       
            this.paramJson.parentRecordId = Id;
            this.parentRecordId = Id;
        }
    }else{*/
        if(this.parentRecordId != undefined && this.parentRecordId != ''){
            this.paramJson.parentRecordId = this.parentRecordId;
            this.parentRecordId = this.parentRecordId;
        }else{
        
             this.paramJson.parentRecordId = null;
         }
    
    
    //}
        if(this.flexGridType === 'FlexGrid'){
        getFlexGridInfo({strJSONParams : JSON.stringify(this.paramJson)}).then(result=>{
            
            if(result.Success === true){
                let data=JSON.parse(JSON.stringify(result));
                this.result = JSON.parse(JSON.stringify(result));
                //let ColumnNamesList                =data.ParentFlexTable.FlexTableConfigMap.ColumnNamesList;
                //this.FieldMetaData             =data.ParentFlexTable.FlexTableConfigMap.FieldMetaData;
                //this.DataTableDetailConfigMap  = data.ParentFlexTable.DataTableDetailConfigMap;
                //this.flexTableConfig           =data.ParentFlexTable.FlexTableConfigMap.FlexTableConfig;
                
                
                if(data.ParentFlexTable != undefined){
                    let ParentFlexTable = {};
                    ParentFlexTable['Id'] = this.parentRecordId;
                    this.initResult.ParentFlexTable = data.ParentFlexTable;
                    //this.initResult.ParentFlexTable.parentflexTableId = this.parentRecordId
                    this.parentdetail['ParentFlexTable'] = ParentFlexTable
                }
                if(data.Child1 != undefined){
                    this.initResult.Child1 = data.Child1;
                }
                if(data.Child2 != undefined){
                    this.initResult.Child2 = data.Child2;
                }
                if(data.GrandChild1 != undefined){
                    this.initResult.GrandChild1 = data.GrandChild1;
                }
                if(data.GrandChild2 != undefined){
                    this.initResult.GrandChild2 = data.GrandChild2;
                }
                this.initateGrid = true;
               
            }else{
                
            }
        }).catch(error => {
            console.error('Errro  '+error)
        });
    }
    else{
    
        getFlexTableInfo({strJSONParams : JSON.stringify(this.paramJson)}).then(result=>{
            
            if(result.Success === true){
                let data=JSON.parse(JSON.stringify(result));
                this.result = JSON.parse(JSON.stringify(result));
                //let ColumnNamesList                =data.ParentFlexTable.FlexTableConfigMap.ColumnNamesList;
                //this.FieldMetaData             =data.ParentFlexTable.FlexTableConfigMap.FieldMetaData;
                //this.DataTableDetailConfigMap  = data.ParentFlexTable.DataTableDetailConfigMap;
                //this.flexTableConfig           =data.ParentFlexTable.FlexTableConfigMap.FlexTableConfig;
                
                
                if(data.ParentFlexTable != undefined){
                    let ParentFlexTable = {};
                    ParentFlexTable['Id'] = this.parentRecordId;
                    this.initResult.ParentFlexTable = data.ParentFlexTable;
                    //this.initResult.ParentFlexTable.parentflexTableId = this.parentRecordId
                    this.parentdetail['ParentFlexTable'] = ParentFlexTable
                }
                if(data.Child1 != undefined){
                    this.initResult.Child1 = data.Child1;
                }
                if(data.Child2 != undefined){
                    this.initResult.Child2 = data.Child2;
                }
                if(data.GrandChild1 != undefined){
                    this.initResult.GrandChild1 = data.GrandChild1;
                }
                if(data.GrandChild2 != undefined){
                    this.initResult.GrandChild2 = data.GrandChild2;
                }
                this.initateGrid = true;
               
            }else{
            }
        }).catch(error => {
            console.error('Errro  '+error)
        });
    }
    }
    getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"), //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
            results = regex.exec(url);
            if(results === null){
            
                regex = new RegExp("[?&]" + 'Id' + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            }
           
            
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    _isJsonString(str) {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
    }
}