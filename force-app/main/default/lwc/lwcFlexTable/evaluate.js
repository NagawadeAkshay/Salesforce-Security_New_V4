import { getReferenceFieldName,sortData} from './initiate';
import {handleSortDirection,QuickSearch} from './action'
export function getRowGroupingData(lwcFlexTableHandler,data){

    var oldrecord;
    var newdata=[];
    var recordlabelmap={};
    var columndata = lwcFlexTableHandler.showRowNumberColumn === true  ? lwcFlexTableHandler.columns[1] : lwcFlexTableHandler.columns[0];
   
    var newrecord;
    var row;

    for(let i=0; i < lwcFlexTableHandler.PaginatedData.length+1; i++){

        if(lwcFlexTableHandler.PaginatedData[i] === undefined){
            continue;
        }

        row = lwcFlexTableHandler.PaginatedData[i];
        newrecord = lwcFlexTableHandler.PaginatedData[i+1];
        let subtotalrecordlist = [];

        for(let j=0; j < lwcFlexTableHandler.rowGroupingFieldList.length; j++){
        
            let record={};
            let field = lwcFlexTableHandler.rowGroupingFieldList[j];
            let value = row[field.toLowerCase()];
           
            let showvalue;
            let subtotalshowvalue;
            let label;
            let SubTotalLabel;

            if(lwcFlexTableHandler.FieldMetaData[field].Type === 'REFERENCE' ){
              
                label = lwcFlexTableHandler.DataTableDetailConfigMap[field] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[field].ReferenceFieldInfo.Label : lwcFlexTableHandler.FieldMetaData[field].ReferenceFieldInfo.Label;
               
                value = row[getReferenceFieldName(lwcFlexTableHandler,field).toLowerCase()];
            
               
                SubTotalLabel = label != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].SubTotalLabel != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].SubTotalLabel+'-'+label : label : lwcFlexTableHandler.DataTableDetailConfigMap[field];
                showvalue = value != undefined ? value : '-';
                subtotalshowvalue = value != undefined ? value : '-';
                field= getReferenceFieldName(lwcFlexTableHandler,field);
            }else{
             
                label = lwcFlexTableHandler.DataTableDetailConfigMap[field] != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].FieldLabelOverride != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].FieldLabelOverride : lwcFlexTableHandler.FieldMetaData[field].Label  : lwcFlexTableHandler.FieldMetaData[field].Label;
                //SubTotalLabel = label != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].SubTotalLabel != undefined ? lwcFlexTableHandler.DataTableDetailConfigMap[field].SubTotalLabel+'-'+label : label : lwcFlexTableHandler.DataTableDetailConfigMap[field];
                if(label != undefined){
                    
                    if(lwcFlexTableHandler.DataTableDetailConfigMap[field] != undefined){

                        if(lwcFlexTableHandler.DataTableDetailConfigMap[field].SubTotalLabel != undefined){
                        
                            SubTotalLabel = lwcFlexTableHandler.DataTableDetailConfigMap[field].SubTotalLabel+'-'+label;
                        }else{
                            SubTotalLabel = label;
                        
                        }
                    }else{
                    
                        SubTotalLabel = label;
                    }
                }else{
                
                    SubTotalLabel=' ';
                }

                if(lwcFlexTableHandler.FieldMetaData[field].Type === 'PERCENT' ){
                
                    let fieldvalue;
                    if(value != undefined){
                        fieldvalue = value * 100;
                        fieldvalue = fieldvalue.toFixed(lwcFlexTableHandler.FieldMetaData[field].Scale);
                        
                    //fieldvalue = value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
                    }

                    showvalue = fieldvalue != undefined ? fieldvalue +'%' : '-';
                    subtotalshowvalue = fieldvalue != undefined ? fieldvalue  : '-';
                }else if(lwcFlexTableHandler.FieldMetaData[field].Type === 'CURRENCY'){
                
                    let fieldvalue;
                    if(value != undefined){
                        
                        fieldvalue = value.toFixed(lwcFlexTableHandler.FieldMetaData[field].Scale);
                        fieldvalue = fieldvalue.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                        }
                        showvalue = fieldvalue != undefined ? '$'+fieldvalue : '-';
                        subtotalshowvalue = fieldvalue != undefined ? fieldvalue : '-';
                
                }else if(lwcFlexTableHandler.FieldMetaData[field].Type === 'INTEGER' || lwcFlexTableHandler.FieldMetaData[field].Type === 'DOUBLE'){
                
                     let fieldvalue;
                    if(value != undefined){
                    
                        fieldvalue = value.toFixed(lwcFlexTableHandler.FieldMetaData[field].Scale);
                        fieldvalue = fieldvalue.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                        }
                        showvalue = fieldvalue != undefined ? fieldvalue : '-';
                        subtotalshowvalue = fieldvalue != undefined ? fieldvalue : '-';
                
                }else if(lwcFlexTableHandler.FieldMetaData[field].Type === 'DATE'){
                
                    let fieldvalue;
                    if(value != undefined){
                    
                        let valuelabelsplit=value.split('-');
                        fieldvalue = valuelabelsplit[1]+'/'+valuelabelsplit[2]+'/'+valuelabelsplit[0];
                        //value = value.toFixed(lwcFlexTableHandler.FieldMetaData[field].Scale);
                        //value = value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
                        }
                        showvalue = fieldvalue != undefined ? fieldvalue : '-';
                        subtotalshowvalue = fieldvalue != undefined ? fieldvalue : '-';
                
                }else if(lwcFlexTableHandler.FieldMetaData[field].Type === 'DATETIME'){
                
                    let fieldvalue;
                    if(value != undefined){
                    
                        //const laDate = changeTimeZone(value, 'America/Los_Angeles');
                        const myDate =new Date(value);;
                        const time = new Date(value).toLocaleTimeString('en',{ timeStyle: 'short', hour12: true, timeZone: lwcFlexTableHandler.timeZone });
                        
                        let year = myDate.getFullYear();
                        let month = myDate.getMonth()+1;
                        let dt = myDate.getDate();

                        fieldvalue = month + '/'+dt+'/'+year+' '+time;
                        }
                        showvalue = fieldvalue != undefined ? fieldvalue : '-';
                        subtotalshowvalue = fieldvalue != undefined ? fieldvalue : '-';
                
                }else {
                
                    if(value != undefined){
                    
                        //const laDate = changeTimeZone(value, 'America/Los_Angeles');

                        }
                        showvalue = value != undefined ? value : '-';
                        subtotalshowvalue = value != undefined ? value : '-';
                
                }
                
            }

            if(i === 0){
                record['RowEnabledLabel'] = label+' : '+showvalue;
                record['isRowEnabled'] = true;
                record['isEdit'] = false;
                record['display'] = 'visibility : hidden;';
                record['subTotal'] = 'background-color: #e9f0fc; color: #2300a9;font-weight: 700;';
                newdata.push(record); 
            }else{
                if(oldrecord[field.toLowerCase()] != value){
                    record['RowEnabledLabel'] = label+' : '+showvalue;
                    record['isEdit'] = false;
                    record['isRowEnabled'] = true;
                    record['display'] = 'visibility : hidden;';
                    record['subTotal'] = 'background-color: #e9f0fc; color: #2300a9;font-weight: 700;';
                    newdata.push(record); 
                }
            }

            if(newrecord != undefined ){
                if(newrecord[field.toLowerCase()] != value){
                    let subtotalrecord = {};
                    subtotalrecord[columndata.fieldName.toLowerCase()] = SubTotalLabel+' : '+subtotalshowvalue;
                    subtotalrecord['isEdit'] = false;
                    subtotalrecord['isSubTotalEnabled'] = true;
                    subtotalrecord['display'] = 'visibility : hidden;';
                    subtotalrecord['subTotal'] = 'background-color: #e1fbe5;color: #215e3c;font-weight: 700;';
                    subtotalrecordlist.push(subtotalrecord)
                }
            }else{
                let subtotalrecord = {};
                    subtotalrecord[columndata.fieldName.toLowerCase()] = SubTotalLabel+' : '+subtotalshowvalue;
                    subtotalrecord['isEdit'] = false;
                    subtotalrecord['isSubTotalEnabled'] = true;
                    subtotalrecord['display'] = 'visibility : hidden;';
                    subtotalrecord['subTotal'] = 'background-color: #e1fbe5;color: #215e3c;font-weight: 700;';
                    subtotalrecordlist.push(subtotalrecord);
            }
            recordlabelmap[label+' : '+showvalue] = SubTotalLabel+' : '+subtotalshowvalue;
        }

        oldrecord = row;
        newdata.push(row);
        if(subtotalrecordlist.length > 0 && lwcFlexTableHandler.subTotalEnabledColumn != undefined && lwcFlexTableHandler.subTotalEnabledColumn.length > 0){
            for (let j=subtotalrecordlist.length-1; j >= 0 ; j--){
                newdata.push(subtotalrecordlist[j]);
            }    
        }
    }

    lwcFlexTableHandler.PaginatedData=newdata;
    
    let countMap={};
    let LableMap={};
    if(lwcFlexTableHandler.subTotalEnabledColumn != undefined && lwcFlexTableHandler.subTotalEnabledColumn.length > 0){


    
        for(let i=0; i < lwcFlexTableHandler.PaginatedData.length; i++){

            if(lwcFlexTableHandler.PaginatedData[i].isRowEnabled === true){
                
                for(let j=0; j < lwcFlexTableHandler.subTotalEnabledColumn.length; j++){
                    
                    countMap[lwcFlexTableHandler.subTotalEnabledColumn[j]] = 0;

                }
                let tempmap = {...countMap};
                LableMap[recordlabelmap[lwcFlexTableHandler.PaginatedData[i].RowEnabledLabel]] = tempmap;
            }
        
            if(lwcFlexTableHandler.PaginatedData[i].isRowEnabled != true && lwcFlexTableHandler.PaginatedData[i].isSubTotalEnabled != true){
                
                for(let j=0; j < lwcFlexTableHandler.subTotalEnabledColumn.length; j++){
                    
                    countMap[lwcFlexTableHandler.subTotalEnabledColumn[j]] = countMap[lwcFlexTableHandler.subTotalEnabledColumn[j]] != undefined ?  lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] != undefined ? countMap[lwcFlexTableHandler.subTotalEnabledColumn[j]] + lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] : 0: lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] != undefined ? lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] : 0;

                   /* if(countMap[lwcFlexTableHandler.subTotalEnabledColumn[j]] != undefined ){
                    
                    }*/

                    for(let k=0; k < Object.keys(LableMap).length; k++ ){
                    
                        let key = Object.keys(LableMap)[k];
                        //countMap = LableMap[key];

                        //LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]] = LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]] != undefined ?  lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] != undefined ? LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]] + lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] : 0: lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] != undefined ? lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] : 0;

                        if(LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]] != undefined){
                        
                            if(lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] != undefined){
                                
                            LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]] = LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]] + lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()];
                            }
                        }else{
                            if(lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] != undefined){
                                LableMap[key][lwcFlexTableHandler.subTotalEnabledColumn[j]]=lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()];
                            }
                        }

                    }

                    
                }
            }
            if(lwcFlexTableHandler.PaginatedData[i].isSubTotalEnabled === true){
                
                for(let j=0; j < lwcFlexTableHandler.subTotalEnabledColumn.length; j++){
                    
                    lwcFlexTableHandler.PaginatedData[i][lwcFlexTableHandler.subTotalEnabledColumn[j].toLowerCase()] = LableMap[lwcFlexTableHandler.PaginatedData[i][columndata.fieldName.toLowerCase()]][lwcFlexTableHandler.subTotalEnabledColumn[j]];                }
            }
        }
    }

}

export function evaluateFormulaJSON(lwcFlexTableHandler){


       



         
        
        let recordsCount = lwcFlexTableHandler.PaginatedData.length;
        lwcFlexTableHandler.PaginatedSubtotalData=lwcFlexTableHandler.PaginatedData;
        let subtotalindex;
        var totalRow = {};
        
        if(lwcFlexTableHandler.FormulaJSON && !isEmpty(lwcFlexTableHandler,lwcFlexTableHandler.FormulaJSON) && lwcFlexTableHandler.subTotalEnabledColumn.length === 0 && lwcFlexTableHandler.TotalCount > 0){
            for(let index = 0; index < lwcFlexTableHandler.PaginatedData.length; index++){
                let SubTotalRowIndex = index + 1;
                
                let newRow = {};
                let isExisting = {};
                isExisting[SubTotalRowIndex] = false; 
                lwcFlexTableHandler.subTotalMap =  lwcFlexTableHandler.subTotalMap != undefined ? lwcFlexTableHandler.subTotalMap : {};
               
                Object.keys(lwcFlexTableHandler.FormulaJSON).forEach(rowField => {

                    if(lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex] != undefined){
                        lwcFlexTableHandler.subTotalMap[SubTotalRowIndex] = lwcFlexTableHandler.subTotalMap[SubTotalRowIndex] != undefined ? lwcFlexTableHandler.subTotalMap[SubTotalRowIndex] : {};
                        if(lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex].indexOf('r.f[') === -1){ 
                            newRow[rowField.toLowerCase()] = lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex];
                            newRow['isSubTotal'] = true;
                            newRow['isAction'] = true;
                            newRow['display'] = 'visibility : hidden;';
                            newRow['isEdit'] = false;
                        }
                        else{
							newRow['display'] = 'visibility : hidden;';
                            let fieldValueList = '';
                            let evaluateFormulaFlag = true;
                            if(!isEmpty(lwcFlexTableHandler,lwcFlexTableHandler.FormulaJSON[rowField]) && lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex] != undefined) { 
                               
                                fieldValueList = lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex].replace(new RegExp('r.f\\[', 'g'), '').replace(new RegExp('r.f\\[', 'g'), '').replace(new RegExp('\\]', 'g'), '' ).split(/(\-|\+)/g);

                                

                                let isMasked = false;
                                    for(let index = 0; index < fieldValueList.length; index++){
                                        let rowIndex = fieldValueList[index];
                                        if(rowIndex === '+' || rowIndex === '-'){
                                            continue;
                                        }
                                        if(lwcFlexTableHandler.PaginatedData[rowIndex.toLowerCase()] != undefined && lwcFlexTableHandler.PaginatedData[rowIndex][rowField.toLowerCase()] != undefined && ((lwcFlexTableHandler.PaginatedData[rowIndex].isSubTotal != undefined && lwcFlexTableHandler.PaginatedData[rowIndex].isSubTotal))){
                                            isMasked = true;    
                                            lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex] = lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex].replace(new RegExp('r.f\\['+rowIndex+'\\]', 'g'), '').replace(/(^(\+|\-))|((\-|\+)$)/g, '').replace(/(\-\+)|(\-\-)/g, '-').replace(/(\+\+)|(\+\-)/g, '+'); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                                        } else {
                                            isMasked = false;
                                        }
                                        lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex] = (lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex] === '' && isMasked) ? lwcFlexTableHandler.maskValue : lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex];
                                    }
                            }

                            // handle refernce field 
                            let keyField;

                            if(lwcFlexTableHandler.FieldMetaData[rowField].Type === 'REFERENCE' && lwcFlexTableHandler.DataTableDetailConfigMap[rowField] != undefined){
                                keyField = lwcFlexTableHandler.DataTableDetailConfigMap[rowField].DisplayField!= undefined? rowField.replace('__c', '__r') + '.' + lwcFlexTableHandler.DataTableDetailConfigMap[rowField].DisplayField : rowField;
                                let fieldType = lwcFlexTableHandler.FieldMetaData[keyField].Type != 'REFERENCE' ? lwcFlexTableHandler.FieldMetaData[keyField].Type : lwcFlexTableHandler.FieldMetaData[keyField].ReferenceFieldInfo.Type;
                                if(fieldType != 'INTEGER' &&
                                    fieldType != 'CURRENCY' &&
                                    fieldType != 'PERCENT' &&
                                    fieldType != 'DOUBLE' ){
                                        evaluateFormulaFlag = false
                                }
                            }else{
                                keyField = rowField;
                            }

                            if(evaluateFormulaFlag){ 
                                let Operator='+';
                                let CalculatedAmount=0;
                                if(fieldValueList != undefined){
                                for(let index = 0; index < fieldValueList.length; index++){
                                    let rowIndex = fieldValueList[index];
                                    if(rowIndex ===undefined){
                                        continue;
                                    }
                                    if(rowIndex === '+' || rowIndex === '-'){
                                        Operator=rowIndex;
                                    }else{
                                        if(Operator === '+'){
                                            let  vad=subtotalfieldvalue(lwcFlexTableHandler.PaginatedData,rowIndex,rowField); //lwcFlexTableHandler.PaginatedData[parseInt(rowIndex)][rowField.toLowerCase()] != undefined ? lwcFlexTableHandler.PaginatedData[parseInt(rowIndex)][rowField.toLowerCase()] : 0;
                                            

                                            CalculatedAmount=CalculatedAmount + vad;
                                        }
                                        if(Operator === '-'){
                                            let  vad1= subtotalfieldvalue(lwcFlexTableHandler.PaginatedData,rowIndex,rowField);  //lwcFlexTableHandler.PaginatedData[parseInt(rowIndex)][rowField.toLowerCase()] != undefined ? lwcFlexTableHandler.PaginatedData[parseInt(rowIndex)][rowField.toLowerCase()] : 0;
                                            CalculatedAmount=CalculatedAmount - vad1;
                                        }
                                    }

                                    
                                }
                                }

                                /*var splittedFormula = lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex].split('+');
                                var newFormula = '0';

                                for(let i = 0; i < splittedFormula.length; i++){
                                    let splitPart = splittedFormula[i];
                                    newFormula = newFormula + '+(' + splitPart + ' ? ' + splitPart + ' : 0)';
                                }
                                lwcFlexTableHandler.FormulaJSON[rowField][SubTotalRowIndex] =  newFormula;*/
                                newRow[rowField.toLowerCase()] =  CalculatedAmount;
                                newRow['isSubTotal'] = true;
                                newRow['isEdit'] = false;
                                /*let refSplitField = keyField.split('.')[0];
                                newRow[rowField.toLowerCase()] = newRow[rowField.toLowerCase()].replace(keyField + ' ?', refSplitField + ' ?');
                                newRow['isSubTotal'] = true;
                                */
                                Object.keys(lwcFlexTableHandler.subTotalMap).forEach(SubTotalRowId =>{
                                    let subTotalMapDetail= lwcFlexTableHandler.subTotalMap[SubTotalRowId];

                                   /* if(newRow[rowField.toLowerCase()].indexOf('lwcFlexTableHandler.PaginatedData['+SubTotalRowId+'].' + rowField.toLowerCase()) != -1){
                                        let subTotalValue = 'lwcFlexTableHandler.PaginatedData['+SubTotalRowId+'].' + rowField.toLowerCase();
                                        if(lwcFlexTableHandler.subTotalMap[SubTotalRowId][rowField.toLowerCase()] != undefined){
                                            newRow[rowField.toLowerCase()] = newRow[rowField.toLowerCase()].replace(subTotalValue, lwcFlexTableHandler.subTotalMap[SubTotalRowId][rowField.toLowerCase()]);
                                        }
                                    } else{
                                        if(newRow[rowField.toLowerCase()].indexOf('lwcFlexTableHandler.PaginatedData[') === -1 && newRow[rowField.toLowerCase()].match(new RegExp("0", "g")) != null && newRow[rowField.toLowerCase()].match(new RegExp("0", "g")).length == fieldValueList.length){
                                            newRow[rowField.toLowerCase()] = lwcFlexTableHandler.maskValue;
                                        }
                                    }*/
                                });
                                lwcFlexTableHandler.subTotalMap[SubTotalRowIndex][rowField] = (newRow[rowField.toLowerCase()]);
                            }

                        }
                        if(isExisting[subtotalindex] ){
                            lwcFlexTableHandler.PaginatedData[subtotalindex] = newRow;
                        }
                        else{
                            let SubTotalRowIndexforgrouping=0;
                            let temp=0;
                            for(let j=0; j < lwcFlexTableHandler.PaginatedData.length; j++){

                                if(lwcFlexTableHandler.PaginatedData[j].isRowEnabled != true && lwcFlexTableHandler.PaginatedData[j].isSubTotalEnabled != true && lwcFlexTableHandler.PaginatedData[j].isSubTotal != true){

                                    
                                
                                    if(temp === SubTotalRowIndex){
                                        break;
                                    }
                                    temp= temp +1;
                                    SubTotalRowIndexforgrouping = SubTotalRowIndexforgrouping + 1;
                                    if(temp === SubTotalRowIndex){
                                        break;
                                    }
                                }else{
                                   
                                    if(lwcFlexTableHandler.PaginatedData[j].isRowEnabled != true && lwcFlexTableHandler.PaginatedData[j].isSubTotalEnabled != true && lwcFlexTableHandler.PaginatedData[j].isSubTotal != true){
                                        if(temp === SubTotalRowIndex){
                                            break;
                                        }
                                    }
                                    SubTotalRowIndexforgrouping = SubTotalRowIndexforgrouping + 1;
                                    
                                }
                            }
                            subtotalindex = SubTotalRowIndexforgrouping != undefined ? SubTotalRowIndexforgrouping : SubTotalRowIndex;
                            if(temp === SubTotalRowIndex){
                                
                                lwcFlexTableHandler.PaginatedData.splice(SubTotalRowIndexforgrouping, 0, newRow);
                            }
                            isExisting[subtotalindex] = true
                            newRow = lwcFlexTableHandler.PaginatedData[subtotalindex];
                          
                        }
                    }
                    newRow = newRow != undefined ? newRow : {};
                  });

                
                  
            }
        }

        let recordsListLength = lwcFlexTableHandler.PaginatedData.length;
        let total=0;
        if(lwcFlexTableHandler.TotalCount > 0){
        Object.keys(lwcFlexTableHandler.FormulaJSON).forEach(rowField =>{
            let type;
            let fieldName;
            let label;
            if(lwcFlexTableHandler.FieldMetaData[rowField].Type === 'REFERENCE' ){
                type='text';

                fieldName=getReferenceFieldName(lwcFlexTableHandler,rowField);
                label = lwcFlexTableHandler.FieldMetaData[rowField].ReferenceFieldInfo.Label;
            }
            else{
                fieldName=rowField;
            }
            let jsonValue=lwcFlexTableHandler.FormulaJSON[rowField];
            if(jsonValue['LASTROW'] != undefined){
                lwcFlexTableHandler.PaginatedData[recordsListLength -1] != undefined && lwcFlexTableHandler.PaginatedData[recordsListLength -1].isTotal != undefined && lwcFlexTableHandler.PaginatedData[recordsListLength -1].isTotal ? lwcFlexTableHandler.PaginatedData.pop() :  '';
                totalRow[fieldName.toLowerCase()] = {};
                let temRefField =[];
                if(fieldName.indexOf('.')!= -1){
                    temRefField = fieldName.split('.');
                }
                if(jsonValue['LASTROW'].indexOf('(1:N)') != -1){

                    
                    total =0;
                    for(let i=0; i < lwcFlexTableHandler.PaginatedSubtotalData.length; i++){
                        if(lwcFlexTableHandler.PaginatedSubtotalData != undefined  && lwcFlexTableHandler.PaginatedSubtotalData[i][fieldName.toLowerCase()] != undefined && lwcFlexTableHandler.PaginatedSubtotalData[i].isSubTotal != true && lwcFlexTableHandler.PaginatedSubtotalData[i].isRowEnabled != true && lwcFlexTableHandler.PaginatedSubtotalData[i].isSubTotalEnabled != true){
                            total=total + lwcFlexTableHandler.PaginatedSubtotalData[i][fieldName.toLowerCase()];
                        } 
                    }

                    
                    (!isEmpty(lwcFlexTableHandler,totalRow[fieldName.toLowerCase()])) ? totalRow[fieldName] = totalRow[fieldName].replace(/\+$/, "") : totalRow[fieldName.toLowerCase()] = total; 
                  
                }
                else if(jsonValue['LASTROW'].indexOf('r.f[') === -1 && jsonValue['LASTROW'].indexOf('(1:N))') === -1){
                    totalRow[fieldName.toLowerCase()] = jsonValue['LASTROW'];
                 
                }
            }
            let maskCount = 0;
           

        });
    }
       
        if(!isEmpty(lwcFlexTableHandler,totalRow) && lwcFlexTableHandler.TotalCount > 0) {
            totalRow['isBold'] ="boldText";
            totalRow['isTotal'] = true;
            totalRow['isEdit']  = false;
            totalRow['display'] = 'visibility : hidden;';
           
            lwcFlexTableHandler.PaginatedData.push(totalRow);
        }
    
}

export function isEmpty(lwcFlexTableHandler,obj) {
  
    //return Object.keys(obj).length === 0;
    let keyset=Object.keys(obj);
    
    if(keyset.length === 0 && obj.constructor === Object){
        return true;
    }
    return false;
}

export function subtotalfieldvalue(data,rowindex,fieldname){

    let count=0;
    let finalvalue;
    for(let i=0; i < data.length; i++){
    
        if(data[i].isTotal != true && data[i].isRowEnabled != true && data[i].isSubTotal != true && data[i].isSubTotalEnabled != true){
            
            if(count === parseInt(rowindex)){
                
                finalvalue = data[i][fieldname.toLowerCase()] != undefined ?  data[i][fieldname.toLowerCase()] : 0;
               
                break;
            }
            count = count + 1;
        }    
    }

    return finalvalue;
}


export function getOverAllTotal(lwcFlexTableHandler,data){

    let OverallColumn={};
                
                if(lwcFlexTableHandler.OverAllColumnsFields != undefined && lwcFlexTableHandler.OverAllColumnsFields.length > 0){
                    lwcFlexTableHandler.OverAllColumnsFields.forEach(OverallField =>{

                  
                    let overalltotal=0;
                    data.forEach(row =>{
                       
                        if(row.isSubTotal != true && row.isSubTotalEnabled != true && row.isRowEnabled != true){
                            if(row[OverallField.toLowerCase()] != null && row[OverallField.toLowerCase()] != undefined && row[OverallField.toLowerCase()] != '' ){

                                overalltotal=overalltotal + row[OverallField.toLowerCase()];
                               
                                
                            }
                          
                            lwcFlexTableHandler.OverAllColumns[OverallField.toLowerCase()]= overalltotal;
                            lwcFlexTableHandler.OverAllColumns['isOverAllTotal'] =true;
                            lwcFlexTableHandler.OverAllColumns['isEdit']  =false;
                            lwcFlexTableHandler.OverAllColumns['display'] = 'visibility : hidden;';
                            lwcFlexTableHandler.OverAllColumns['subTotal'] = 'color: #000;font-weight: 700;';
                        }
                    });
                });
                //lwcFlexTableHandler.OverAllColumns=OverallColumn;
                }

}
export function setSessionData(key,value,lwcFlexTableHandler){
    let sessionKey = lwcFlexTableHandler.FlexTableId + lwcFlexTableHandler.Header;
    let sessionDataStr = localStorage.getItem(sessionKey);//need to
    lwcFlexTableHandler.mapOfSessionData = JSON.parse(sessionDataStr) != null ?  JSON.parse(sessionDataStr) : {} ;
    if (sessionDataStr && sessionDataStr != undefined && sessionDataStr != '') {
       
       
    }
       switch(key){
            case 'sortfieldname':
                lwcFlexTableHandler.mapOfSessionData[key] =value ;  
                break;
            case 'sortDirection':
                    lwcFlexTableHandler.mapOfSessionData[key] =value ;  
                    break;  
            case 'pageNumber':
                lwcFlexTableHandler.mapOfSessionData[key] =value ;  
                break;
            case 'pageSize':
                    lwcFlexTableHandler.mapOfSessionData[key] =value ;  
                    break;
            case 'quickSearchText':
                lwcFlexTableHandler.mapOfSessionData[key] =value ;  
                break;
            case 'showResetMessage':
                    lwcFlexTableHandler.mapOfSessionData[key] =true ;  
                    break;
            case 'selectedListiew':
                lwcFlexTableHandler.mapOfSessionData[key] =value ;  
                break;
            case 'enableChild':
               lwcFlexTableHandler.mapOfSessionData[key] =JSON.stringify(Array.from(value)); 
                break;
       
    }
 localStorage.setItem(sessionKey,JSON.stringify(lwcFlexTableHandler.mapOfSessionData));
}
export function getSessionData(lwcFlexTableHandler){
    return localStorage.getItem(lwcFlexTableHandler.FlexTableId+lwcFlexTableHandler.Header);
}
export function getCurrentListViewSessionData(lwcFlexTableHandler){
    let sessionStr = getSessionData(lwcFlexTableHandler);
    lwcFlexTableHandler.initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};
    if(lwcFlexTableHandler.initSessionData != undefined &&  lwcFlexTableHandler.initSessionData != null && Object.keys(lwcFlexTableHandler.initSessionData).length != 0 ){
                    
        if(lwcFlexTableHandler.initSessionData.pageSize != undefined){
            if(lwcFlexTableHandler.initSessionData.pageSize == 'All'){
                lwcFlexTableHandler.pageSize = lwcFlexTableHandler.TotalCount;
                lwcFlexTableHandler.PageSizeValue ='All' ;
            }else{
                lwcFlexTableHandler.pageSize = lwcFlexTableHandler.initSessionData.pageSize;
                lwcFlexTableHandler.PageSizeValue =lwcFlexTableHandler.pageSize ; 
            }
          const childCmp = lwcFlexTableHandler.template.querySelector('.combobox');
          const targetElement = childCmp != null ? childCmp.getTargetElement() : null;
        
        if (targetElement!= null) {
            targetElement.value = lwcFlexTableHandler.PageSizeValue;
        }else{
            lwcFlexTableHandler.PageSizeValue =  lwcFlexTableHandler.PageSizeValue;

        }
        }else{
          lwcFlexTableHandler.pageSize=lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
        
          lwcFlexTableHandler.PageSizeValue = lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
          const childCmp = lwcFlexTableHandler.template.querySelector('.combobox');
          const targetElement = childCmp != null ? childCmp.getTargetElement() : null;
      
      if (targetElement != null) {
        
          targetElement.value = lwcFlexTableHandler.PageSizeValue;
      }
        }
        if(lwcFlexTableHandler.initSessionData.pageNumber != undefined){
          lwcFlexTableHandler.currentPage = lwcFlexTableHandler.initSessionData.pageNumber;
        }
        if(lwcFlexTableHandler.initSessionData.quickSearchText != undefined && lwcFlexTableHandler.initSessionData.quickSearchText != ''){
          let quickSearchText = lwcFlexTableHandler.initSessionData.quickSearchText;
          lwcFlexTableHandler.searchText = quickSearchText;
          QuickSearch(lwcFlexTableHandler,quickSearchText.toUpperCase(),false);
        }else{
            lwcFlexTableHandler.searchText = '';
            const inputField = lwcFlexTableHandler.template.querySelector('[data-id="searchText"]');//to remove search text fom input
            inputField.value = '';
        }
        if(lwcFlexTableHandler.initSessionData.showResetMessage != undefined){
          lwcFlexTableHandler.isResetMessage = lwcFlexTableHandler.initSessionData.showResetMessage;
        }else{
            lwcFlexTableHandler.isResetMessage = false;
        }
        let sortDirection;
        let fieldname;
         if(lwcFlexTableHandler.initSessionData.sortDirection != undefined){
            sortDirection = lwcFlexTableHandler.initSessionData.sortDirection;
          }
          if(lwcFlexTableHandler.initSessionData.sortfieldname != undefined){
            lwcFlexTableHandler.showSortMsg = false;
            fieldname = lwcFlexTableHandler.initSessionData.sortfieldname;
            sortData(fieldname,sortDirection.toLowerCase(),false,lwcFlexTableHandler);
            //lwcFlexTableHandler.flattenedData= lwcFlexTableHandler.quicksearchdata;
            lwcFlexTableHandler.data = lwcFlexTableHandler.quicksearchdata;
            handleSortDirection(lwcFlexTableHandler,fieldname,sortDirection.toLowerCase());
          }
  }else{
    lwcFlexTableHandler.searchText = '';
    const inputField = lwcFlexTableHandler.template.querySelector('[data-id="searchText"]');
    inputField.value = '';//to remove search text fom input
    lwcFlexTableHandler.isResetMessage = false;//hide reset message
    lwcFlexTableHandler.pageSize=lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
        
    lwcFlexTableHandler.PageSizeValue = lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced != undefined ? lwcFlexTableHandler.flexTableConfig.DefaultPageSizeEnhanced.toString() : lwcFlexTableHandler.TotalCount;
    const childCmp = lwcFlexTableHandler.template.querySelector('.combobox');
    const targetElement = childCmp != null ? childCmp.getTargetElement() : null;
    lwcFlexTableHandler.showSortMsg = lwcFlexTableHandler.showSortMsgData ;
    //handleSortDirectionDefault(lwcFlexTableHandler)
     if (targetElement!= null) {
    targetElement.value = lwcFlexTableHandler.PageSizeValue;
   }else{
    lwcFlexTableHandler.PageSizeValue =  lwcFlexTableHandler.PageSizeValue;
    }

  }
}
export function getStandardFieldName(refField){
    let fieldName ='';
    switch(refField.toLowerCase()){
        case 'lastmodifiedby':
            fieldName =  'LastModifiedById';  
            break;
        case 'createdby':
            fieldName =  'CreatedById';  
                break;  
        case 'owner':
            fieldName =  'OwnerId';  
            break;
     
   
}
return fieldName;
}
export function removeDuplicates(queryFields) {
    const uniqueSet = new Set();
    const result = [];

    for (const field of queryFields) {
        const lowercaseField = field.toLowerCase();
        if (!uniqueSet.has(lowercaseField)) {
            uniqueSet.add(lowercaseField);
            result.push(field);
        }
    }

    return result;
}