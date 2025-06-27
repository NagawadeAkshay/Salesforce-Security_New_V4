import SaveGridData from '@salesforce/apex/FlexGridEnhancedCtrl.saveRecords';
//import UserPreferencesDisableFileShareNotificationsForApi from '@salesforce/schema/User.UserPreferencesDisableFileShareNotificationsForApi';
import deleteRecords from '@salesforce/apex/FlexGridEnhancedCtrl.deleteRecords';
import executeClas from '@salesforce/apex/FlexGridEnhancedCtrl.executeClass';
import { getSelectedRows,setActionOrders,replaceStringParamters,replaceListParamters,getReferenceFieldName,getOperatorOptions,updateOnColumnChange,getLabelForColumns,handlePagination,getdata} from './initiate';
import { processExpression,expressionEvaluatorme,parentExpressionEval,isEmpty1 } from './expressionevaluator'
import messageChannel from "@salesforce/messageChannel/flexLayout__c";
import {publish} from 'lightning/messageService';
import formDetails from '@salesforce/apex/DynamicPageCtrl.getformDetailsLWC';
import { setSessionData,getSessionData } from './evaluate';
export function createSaveRecordMap(lwcFlexTableHandler,returncelldata){

 
    

  
    if(lwcFlexTableHandler.saveRecordMap != undefined){
    
        if(lwcFlexTableHandler.saveRecordMap[returncelldata.flexTableId] === undefined){
            let saveresult=[];
            lwcFlexTableHandler.saveRecordMap[returncelldata.flexTableId] = getsaveresult(lwcFlexTableHandler,returncelldata,saveresult);
        }else{
        
            lwcFlexTableHandler.saveRecordMap[returncelldata.flexTableId] = getsaveresult(lwcFlexTableHandler,returncelldata,lwcFlexTableHandler.saveRecordMap[returncelldata.flexTableId]);
        }
    }

    //lwcFlexTableHandler.queryfieldsMap[event.detail.flexTableId] = event.detail.querryfields;

   

}

function getsaveresult(lwcFlexTableHandler,returncelldata,saveresult){

    let ispresent = false;
    let record={};
      if(saveresult != undefined ){
        
        for(let i=0; i < saveresult.length; i++){
        
            if(saveresult[i].Id === returncelldata.recordId){
            
                saveresult[i]['Id'] = returncelldata.recordId;
                if(lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "CURRENCY"
                 || lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "INTEGER"
                 || lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "DOUBLE"
                 || lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "PERCENT" ){
 
                let fieldValue = returncelldata.value;
                fieldValue =  parseFloat(fieldValue);
                saveresult[i][returncelldata.fieldName]  = fieldValue;
               
            }else{
                saveresult[i][returncelldata.fieldName] = returncelldata.value;
            }
                ispresent = true;
            }
        }

        if(ispresent === false){
        
            record['Id'] = returncelldata.recordId;
            if(lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "CURRENCY"
            || lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "INTEGER"
            || lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "DOUBLE"
            || lwcFlexTableHandler.FieldMetaData[returncelldata.fieldName].Type == "PERCENT"){
 
                let fieldValue = returncelldata.value;
                fieldValue =  parseFloat(fieldValue);
                record[returncelldata.fieldName] = fieldValue;
               
            }else{
              record[returncelldata.fieldName] = returncelldata.value;
            }
            saveresult.push(record)
        }
    }

    return saveresult;

}

export function saveRecords(lwcFlexTableHandler){

    let successMsg;
    if(lwcFlexTableHandler.isRequiredfieldMissing != true){
    
        let saveRecordParam={
            saveRecordsMap  : lwcFlexTableHandler.saveRecordMap,
            tableObjectsMap :lwcFlexTableHandler.tableObjectsMap,
            levelVsTableIdMap : lwcFlexTableHandler.levelVsTableIdMap,
            parentLookupFieldMap : lwcFlexTableHandler.parentLookupFieldMap,
            queryfieldsMap : lwcFlexTableHandler.queryfieldsMap
        };

        lwcFlexTableHandler.isLoading = true;
        SaveGridData({saveRecordsJSON : JSON.stringify(saveRecordParam)}).then(response=>{
            
            if(response.Success === true){
                lwcFlexTableHandler.isSave=false;
                lwcFlexTableHandler.isRecordOpenMode = false;
                lwcFlexTableHandler.newSaveRecordCount = 0;
                lwcFlexTableHandler.editRecordCount = 0;
                if(lwcFlexTableHandler.isNew === true){
                    
                    lwcFlexTableHandler.saveRecordMap = {};
                    successMsg = lwcFlexTableHandler.saveTopAction!= undefined && lwcFlexTableHandler.saveTopAction.MessageConfig !=undefined ? lwcFlexTableHandler.saveTopAction.MessageConfig :'Saved successfully!';
                    lwcFlexTableHandler.ShowSuccessMessage(successMsg);
                }else{
                    lwcFlexTableHandler.saveRecordMap = {};
                    successMsg = lwcFlexTableHandler.saveTopAction!= undefined && lwcFlexTableHandler.saveTopAction.MessageConfig !=undefined ? lwcFlexTableHandler.saveTopAction.MessageConfig :'Saved successfully!';

                    lwcFlexTableHandler.ShowSuccessMessage(successMsg);
                }
                
                if(lwcFlexTableHandler.saveTopAction != undefined){
                    checkRefreshBehavior(lwcFlexTableHandler,lwcFlexTableHandler.saveTopAction);
                }else{
                    lwcFlexTableHandler.firstOnly = true;
                    getdata(lwcFlexTableHandler,true);
                    lwcFlexTableHandler.isNew = false;
                }
                if(lwcFlexTableHandler.TopAction!= undefined && lwcFlexTableHandler.TopAction.isEditAll == true){
                    lwcFlexTableHandler.editRecordCount = 0;
                    for(let i=0; i< lwcFlexTableHandler.TopLevelAction.length; i++){
    
                        if(lwcFlexTableHandler.TopLevelAction[i].isEditAll == true){
                        
                            lwcFlexTableHandler.TopLevelAction[i]['Name'] = lwcFlexTableHandler.TopLevelAction[i].Name == 'Undo Edit' ? lwcFlexTableHandler.TopLevelAction[i]['ActionName']  : lwcFlexTableHandler.action.Name;
                        }
                    }
                }
                
            }else if(response.Success === false){
                lwcFlexTableHandler.isRecordOpenMode = false;
                if(response.Message != undefined){
                    let msg = parseExceptionMessage(response.Message);
                    lwcFlexTableHandler.ShowErrorMessage(msg);
                }

            }
        
        }).catch(error => {
           lwcFlexTableHandler.ShowErrorMessage(error.body.message);
     });

    }
    lwcFlexTableHandler.isRequiredfieldMissing = false;
}



function processResponse(response,lwcFlexTableHandler){

    if(response.result != undefined){
            
        let keys = Object.keys(response.result);
        if(keys != undefined && keys.length > 0){
        
            for(let i=0; i < keys.length; i++){
            
                let updateList = Object.keys(response.result[keys[i]].updatedRecordsMap);

                if(updateList != undefined && updateList.length > 0){
                
                    for(let k=0; k < updateList.length; k++){
                    
                        updateRow(updateList[k],'isEdit',lwcFlexTableHandler);
                        
                    }
                
                }
            }
        }

    }
    let filters = [...lwcFlexTableHandler.template.querySelectorAll('c-fieldlwc')]
                                    .map(filter => filter.setValues());
    
}


export function updateRow(id,key,lwcFlexTableHandler){
    let isUndo= false;
    //let id=event.target.dataset.id;
    if(id != undefined){
        for(let i=0; i < lwcFlexTableHandler.data.length; i++){
            
            if(lwcFlexTableHandler.data[i].id === id){
                //lwcFlexTableHandler.data[i][key] = lwcFlexTableHandler.data[i][key] != undefined ? lwcFlexTableHandler.data[i][key] === true ? false : true : true;

                if(lwcFlexTableHandler.data[i][key] != undefined){
                
                    if(lwcFlexTableHandler.data[i][key] === true ){
                    
                        lwcFlexTableHandler.data[i][key] = false;
                        if(key != 'EnableChild'){
                        lwcFlexTableHandler.editRecordCount--;
                        }
                        if(key == 'isEdit'){
                        isUndo = true;
                        }
                    }else{
                    
                        lwcFlexTableHandler.data[i][key] = true;
                        if(key != 'EnableChild'){
                        lwcFlexTableHandler.editRecordCount++;
                    }
                    }
                }else{
                    lwcFlexTableHandler.data[i][key] = true;
                    if(key != 'EnableChild'){
                    lwcFlexTableHandler.editRecordCoun++;
                    }
                }
            }
        }
        if(isUndo == true && key == 'isEdit'){
            //let saveRecordArray =  lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] !=  undefined ?lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] :{} ;
            if(lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] !=  undefined){
            
                for(let i=0; i < lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId].length; i++){
                if(lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId][i].Id == id){
                
                    lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId].splice(i);
                }
                }
                //lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] = saveRecordArray;
            }
         }
    }
    

   
}

export function addrow(lwcFlexTableHandler){

    //lwcFlexTableHandler.OpenConfirmationBox = false; 
    let newrecord ={}
    newrecord['id'] = getUniqueId(lwcFlexTableHandler);
    newrecord['isEdit'] = true;
    newrecord['ExtendIcon'] = 'utility:down';
    newrecord['isNew'] = true;
    newrecord['isAction'] = true;
    newrecord['display'] = 'visibility : hidden;';
    

    let saverecordmap={};
    saverecordmap['Id']  = newrecord.id;
    if(lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField != undefined && lwcFlexTableHandler.parentId != undefined){
    
        newrecord[lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField] = lwcFlexTableHandler.parentId;
        saverecordmap[lwcFlexTableHandler.flexTableConfig.ParentTargetLookupField] = lwcFlexTableHandler.parentId;
    }

    if(lwcFlexTableHandler.DefaulValuesList != null && lwcFlexTableHandler.DefaulValuesList.length > 0){
        for(let i=0; i < lwcFlexTableHandler.DefaulValuesList.length; i++){
            if(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.DefaulValuesList[i].fieldName].Type === 'BOOLEAN'){
                newrecord[lwcFlexTableHandler.DefaulValuesList[i].fieldName.toLowerCase()] = lwcFlexTableHandler.DefaulValuesList[i].defaultValue === 'true' ? true : false;
                saverecordmap[lwcFlexTableHandler.DefaulValuesList[i].fieldName] = lwcFlexTableHandler.DefaulValuesList[i].defaultValue === 'true' ? true : false;


            }else if(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.DefaulValuesList[i].fieldName].Type === 'DATE'){
                let isoDate;
               let dateString = lwcFlexTableHandler.DefaulValuesList[i].defaultValue;
               let dateParts = dateString.split('/');
               if (dateParts.length === 3) {
                    isoDate = dateParts[2] + '-' + dateParts[0] + '-' + dateParts[1]; 
                }
                if (isoDate !== undefined) {
                    var parts = isoDate.split("-");
                    var formattedDate = parts[0] + "-" + ("0" + parts[1]).slice(-2) + "-" + ("0" + parts[2]).slice(-2);
                    newrecord[lwcFlexTableHandler.DefaulValuesList[i].fieldName.toLowerCase()] = formattedDate;
                    saverecordmap[lwcFlexTableHandler.DefaulValuesList[i].fieldName.toLowerCase()] = formattedDate;
                }else{
                    newrecord[lwcFlexTableHandler.DefaulValuesList[i].fieldName.toLowerCase()] = lwcFlexTableHandler.DefaulValuesList[i].defaultValue;
                    saverecordmap[lwcFlexTableHandler.DefaulValuesList[i].fieldName.toLowerCase()] = lwcFlexTableHandler.DefaulValuesList[i].defaultValue;  
                }
               
  
            }else{
                newrecord[lwcFlexTableHandler.DefaulValuesList[i].fieldName.toLowerCase()] = lwcFlexTableHandler.DefaulValuesList[i].defaultValue;
                saverecordmap[lwcFlexTableHandler.DefaulValuesList[i].fieldName] = lwcFlexTableHandler.DefaulValuesList[i].defaultValue;


            }
        }
    }

   /// if(lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] === undefined){
        let saverecordList = lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] === undefined ||  Object.keys(lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] || {}).length === 0 ? [] : lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId];
        saverecordList.push(saverecordmap);
        lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] = saverecordList;
    //}
    if(lwcFlexTableHandler.data != undefined){
        lwcFlexTableHandler.data.splice(0,0,newrecord);
        lwcFlexTableHandler.newSaveRecordCount++;
    }else{
        let dataList=[];
        dataList.push(newrecord);
        lwcFlexTableHandler.data=dataList
        lwcFlexTableHandler.newSaveRecordCount++;
    }

}

function getUniqueId(lwcFlexTableHandler){

    let uniqueId;
    if(lwcFlexTableHandler.initResult.ParentFlexTable.FlexTableConfigMap.FlexTableConfig.FlexTableId == lwcFlexTableHandler.flexTableConfig.FlexTableId){
        lwcFlexTableHandler.globalMap['parent'] = 'pl1';
        uniqueId = lwcFlexTableHandler.parentId +'p' +lwcFlexTableHandler.newSaveRecordCount;
    }else if(lwcFlexTableHandler.initResult.Child1.FlexTableConfigMap.FlexTableConfig.FlexTableId == lwcFlexTableHandler.flexTableConfig.FlexTableId){
        lwcFlexTableHandler.globalMap['child1'] = 'cl1';
        uniqueId = lwcFlexTableHandler.parentId+'cl1' +lwcFlexTableHandler.newSaveRecordCount;
    }else if(lwcFlexTableHandler.initResult.Child2 != undefined && lwcFlexTableHandler.initResult.Child2.FlexTableConfigMap.FlexTableConfig.FlexTableId == lwcFlexTableHandler.flexTableConfig.FlexTableId){
        
        uniqueId =lwcFlexTableHandler.parentId +'cl2' +lwcFlexTableHandler.newSaveRecordCount;
    }else if(lwcFlexTableHandler.initResult.GrandChild1.FlexTableConfigMap.FlexTableConfig.FlexTableId == lwcFlexTableHandler.flexTableConfig.FlexTableId){
        
        uniqueId = lwcFlexTableHandler.parentId +'gc1' +lwcFlexTableHandler.newSaveRecordCount;
    }else if(lwcFlexTableHandler.initResult.GrandChild2.FlexTableConfigMap.FlexTableConfig.FlexTableId == lwcFlexTableHandler.flexTableConfig.FlexTableId){
        
        uniqueId = lwcFlexTableHandler.parentId +'gc2' +lwcFlexTableHandler.newSaveRecordCount;
    }

    return uniqueId;
}

export function checkForConfirmationMsg(lwcFlexTableHandler,action){
    if(action.ShowConfirmationBox === true){
        //checkedWindow = false;
        if(action.ConfirmationMessage != undefined){
            if(action.StandardAction === 'Delete' ){
                //showConfirmBox(lwcFlexTableHandler,action,action.ConfirmationMessage,false,true,false);
                
                lwcFlexTableHandler.rowIdList =[];
                if(action.Location === 'Row'){
                    
                    lwcFlexTableHandler.rowIdList.push(lwcFlexTableHandler.row.id);
                }else{
                    lwcFlexTableHandler.rowIdList = lwcFlexTableHandler.recordselection != undefined ? getselectedrecordId(lwcFlexTableHandler) : undefined;

                }

                if(lwcFlexTableHandler.rowIdList != undefined && lwcFlexTableHandler.rowIdList.length > 0){
                lwcFlexTableHandler.ConfirmationMessage = action.ConfirmationMessage;
                //lwcFlexTableHandler.OpenConfirmationBox = true;
                lwcFlexTableHandler.showWarningPopUp(lwcFlexTableHandler.ConfirmationMessage);
                lwcFlexTableHandler.isDelete = true;
                lwcFlexTableHandler.action=action;    
                }else{
                    lwcFlexTableHandler.ShowErrorMessage('Please select atleast one record. ');
                
                }   
            }else if(action.StandardAction === 'New'){
               // showConfirmBox(lwcFlexTableHandler,action,action.ConfirmationMessage,false,false,true);
                lwcFlexTableHandler.ConfirmationMessage = action.ConfirmationMessage;
                //lwcFlexTableHandler.OpenConfirmationBox = true;
                lwcFlexTableHandler.showWarningPopUp(lwcFlexTableHandler.ConfirmationMessage);
                lwcFlexTableHandler.isNew = true;
                lwcFlexTableHandler.EnableFilter = false;
                lwcFlexTableHandler.EnableQuickSearch = false;
                lwcFlexTableHandler.EnablePageSize = false;
                if(lwcFlexTableHandler.gridLevel ==0){
                    lwcFlexTableHandler.isSave=true;
                }
                if(lwcFlexTableHandler.gridLevel > 0){
                    let data={};
                                data['isError'] = false;
                                data['isSave'] = true;
                                data['isNew'] =true;
                                const showmessagesatparent =new CustomEvent('showmessage', {
                                    detail: data,
                                    bubbles: true,
                                    composed: true,
                                });
                                lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
                }
                
            }
            else{
                //showConfirmBox(lwcFlexTableHandler,action,action.ConfirmationMessage,false,false,false); 
                lwcFlexTableHandler.ConfirmationMessage = action.ConfirmationMessage;
                //lwcFlexTableHandler.OpenConfirmationBox = true;  
                lwcFlexTableHandler.showWarningPopUp(lwcFlexTableHandler.ConfirmationMessage); 
            }
        }
    }else{
        if(action.StandardAction === 'Delete' ){
            //action.ConfirmationMessage = 'Do you want to delete? Once it is deleted it cannot be restored.';
            //showConfirmBox(lwcFlexTableHandler,action,action.ConfirmationMessage,false,true,false);
            
            let rowIdList = [];
               
                if(action.Location === 'Row'){
                    
                    lwcFlexTableHandler.rowIdList.push(lwcFlexTableHandler.row.id);
                }else{
                    lwcFlexTableHandler.rowIdList = lwcFlexTableHandler.recordselection != undefined ? getselectedrecordId(lwcFlexTableHandler) : undefined;

                }

                //deleterow(lwcFlexTableHandler,action);
                if(lwcFlexTableHandler.rowIdList != undefined && lwcFlexTableHandler.rowIdList.length > 0){
                    lwcFlexTableHandler.isDelete = true;
                    lwcFlexTableHandler.action=action; 
                    lwcFlexTableHandler.ConfirmationMessage = 'Do you want to delete? Once it is deleted it cannot be restored.';
                    //lwcFlexTableHandler.OpenConfirmationBox = true;
                    lwcFlexTableHandler.showWarningPopUp(lwcFlexTableHandler.ConfirmationMessage);
                }else{
                    lwcFlexTableHandler.ShowErrorMessage('Please select atleast one record. ');
                
                }
        }else if(action.StandardAction === 'New'){
                lwcFlexTableHandler.isNew = true;
                if(lwcFlexTableHandler.gridLevel ==0){
                    lwcFlexTableHandler.isSave=true;
                }
                if(lwcFlexTableHandler.gridLevel > 0){
                    let data={};
                                data['isError'] = false;
                                data['isSave'] = true;
                                data['isNew'] =true;
                                const showmessagesatparent =new CustomEvent('showmessage', {
                                    detail: data,
                                    bubbles: true,
                                    composed: true,
                                });
                                lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
                }
                
                
                lwcFlexTableHandler.EnableFilter = false;
                lwcFlexTableHandler.EnableQuickSearch = false;
                lwcFlexTableHandler.EnablePageSize = false;
                addrow(lwcFlexTableHandler);
        }else if(action.StandardAction === 'View' && lwcFlexTableHandler.isContentNoteView){ /**Content note added TD  */
            lwcFlexTableHandler.noteContent = '';
           lwcFlexTableHandler.recordId = lwcFlexTableHandler.row.id;
           lwcFlexTableHandler.Title=action.ModalTitle != undefined ? action.ModalTitle :'View';
           textDescription({contentID : lwcFlexTableHandler.row.id}).then(response=>{
                if(response){
                    lwcFlexTableHandler.noteContent = response;
                }else{
                }
                }).catch(error =>{
                this.ErrorMessage=error;
            });
        }else{
            checkActionBehavior(lwcFlexTableHandler,action);    
        }
           
    }
}

function getselectedrecordId(lwcFlexTableHandler){

    let selectedId =[];
    if(lwcFlexTableHandler.recordselection != undefined){
    
        let IdList = Object.keys(lwcFlexTableHandler.recordselection);

        if(IdList.length > 0){
            
            for(let i=0; i < IdList.length; i++){
            
                if(lwcFlexTableHandler.recordselection[IdList[i]] === true){
                    selectedId.push(IdList[i]);
                }
            }
        }
    }

    return selectedId;
}

export function checkActionBehavior(lwcFlexTableHandler,action){
    switch(action.ActionBehavior){
        case 'EditRecord' : 
                editSingleRecord(lwcFlexTableHandler,action);
        break;
        case 'EditMultipleRecords' : 
                editMultipleRecords(lwcFlexTableHandler,action);
        break;
        case 'OpenURL' : 
                openUrl(lwcFlexTableHandler,action);    
        break;
        case 'OpenSheetJSUrl' : // By default for sheetjs
                openSheetJSUrl(action);    
            break;
        case 'ExecuteClass' : 
                executeClass(lwcFlexTableHandler,action);    
        break;    
        case 'Open in overlay' : 

            getModalDetails(lwcFlexTableHandler,action);
            break;      
            default:  
           // window.open(action.ActionURLLong,'_self');                
    }
}

    function getModalDetails(lwcFlexTableHandler,action){

       // lwcFlexTableHandler.OpenConfirmationBox = false;
        if(action.ActionURLLongLWC != undefined){
            lwcFlexTableHandler.ModalAttribute = isJsonString(action.ActionURLLongLWC) === false ? undefined : JSON.parse(action.ActionURLLongLWC);
        }else{
             lwcFlexTableHandler.ModalAttribute= undefined;
        }
        if(lwcFlexTableHandler.ModalAttribute != undefined){
            if(lwcFlexTableHandler.ModalAttribute != undefined && lwcFlexTableHandler.ModalAttribute['urlParams'] != undefined && lwcFlexTableHandler.ModalAttribute["flowName"] == undefined){
                lwcFlexTableHandler.ModalAttribute['urlParams'] = processUrl(lwcFlexTableHandler,action,lwcFlexTableHandler.ModalAttribute['urlParams'])
            }else if (lwcFlexTableHandler.ModalAttribute != undefined && lwcFlexTableHandler.ModalAttribute["urlParams"] != undefined && lwcFlexTableHandler.ModalAttribute["flowName"]){
                lwcFlexTableHandler.ModalAttribute["urlParams"] = JSON.parse(
                    processUrl(lwcFlexTableHandler, action, JSON.stringify(lwcFlexTableHandler.ModalAttribute["urlParams"]))
                );
            }
            lwcFlexTableHandler.ModalAttribute['govGrantPleaseWaitIcon'] = lwcFlexTableHandler.ModalAttribute != undefined ? lwcFlexTableHandler.govGrantPleaseWaitIcon : undefined; 
            //lwcFlexTableHandler.ModalRecordId = lwcFlexTableHandler.row != undefined ? lwcFlexTableHandler.row.id : undefined; //'a1i4P000004uCVCQA2' 
            lwcFlexTableHandler.ModalHeader = action.ModalTitle != undefined ? action.ModalTitle : lwcFlexTableHandler.initResult?.ParentFlexTable?.FlexTableConfigMap?.FlexTableConfig?.Name;
            lwcFlexTableHandler.isModalFlexLayout = true;
            lwcFlexTableHandler.ModalAttribute.isTableRefreshAvailable = action.RefreshBehaviour != undefined ? true : false;
            lwcFlexTableHandler.ModalAttribute.isLayout = false;
        }else{
            lwcFlexTableHandler.ShowErrorMessage('You need to fill the Action URL Long LWC field in Flex Table Action Config.');
        }
    }

function isJsonString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

export function editSingleRecord(lwcFlexTableHandler,action){

   
    updateRow(lwcFlexTableHandler.row.id,'isEdit',lwcFlexTableHandler);

        if(action != undefined){
            if(lwcFlexTableHandler.hideReadOnlyCellMap[lwcFlexTableHandler.row.id] == undefined){
                let readCellFields = Object.keys(lwcFlexTableHandler.readOnlyCellJSONMap);
                if(lwcFlexTableHandler.readOnlyCellJSONMap != undefined && readCellFields.length > 0){
                    let resultmap = {}
                    for(let i=0; i < readCellFields.length; i++){
                        let expressionResult = processExpression(lwcFlexTableHandler,lwcFlexTableHandler.readOnlyCellJSONMap[readCellFields[i]],lwcFlexTableHandler.row,undefined);
                        
                        resultmap[readCellFields[i]] = expressionResult;
                        lwcFlexTableHandler.hideReadOnlyCellMap[lwcFlexTableHandler.row.id] = resultmap;
                    }

                }

            }
        }
        let filters = [...lwcFlexTableHandler.template.querySelectorAll('c-fieldlwc')]
            .map(fieldschild =>{
                
                if(lwcFlexTableHandler.hideReadOnlyCellMap[lwcFlexTableHandler.row.id] != undefined){
                    
                    if(lwcFlexTableHandler.hideReadOnlyCellMap[lwcFlexTableHandler.row.id][fieldschild.dataset.fieldapiname] != true){
                        fieldschild.editRecord(lwcFlexTableHandler.row.id)
                    }
                    
                }else{
                    fieldschild.editRecord(lwcFlexTableHandler.row.id)
                }
                
            
            })  

    if(lwcFlexTableHandler.gridLevel === 0){
        lwcFlexTableHandler.isSave = true;
    }    
    if(lwcFlexTableHandler.gridLevel > 0){
        let data={};
                    data['isError'] = false;
                    data['isSave'] = true;
                    const showmessagesatparent =new CustomEvent('showmessage', {
                        detail: data,
                        bubbles: true,
                        composed: true,
                    });
                    lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
    } 
    
    lwcFlexTableHandler.EnableFilter = false;
    lwcFlexTableHandler.EnableQuickSearch = false;
    lwcFlexTableHandler.EnablePageSize = false;

            
}

export function deleterow(lwcFlexTableHandler,action){

    let deleteRecordsMap = {};
   
	//lwcFlexTableHandler.OpenConfirmationBox = ! lwcFlexTableHandler.OpenConfirmationBox;
    lwcFlexTableHandler.isLoading = true;
    // if(action.Location === 'Row'){
        
    //     rowIdList.push(lwcFlexTableHandler.row.id);
    // }else{
    //     rowIdList = lwcFlexTableHandler.selectedIds != undefined ? lwcFlexTableHandler.selectedIds : undefined;
        
    // }
    
        if(lwcFlexTableHandler.rowIdList != undefined && lwcFlexTableHandler.rowIdList.length > 0){
            deleteRecordsMap[lwcFlexTableHandler.tableMetaData.FlexTableConfigMap.FlexTableConfig.SObjectName] =  lwcFlexTableHandler.rowIdList; 
            let deleteRecordsParamJSON = JSON.stringify(deleteRecordsMap);
            deleteRecords({deleteRecordsParamJSON : deleteRecordsParamJSON}).then(response =>{

                if(response.Success){
                    //lwcFlexTableHandler.OpenConfirmationBox = ! lwcFlexTableHandler.OpenConfirmationBox;
                    lwcFlexTableHandler.isDelete=false;

                    //lwcFlexTableHandler.showtoastmeassage('Success',response.Message,'success');
                    if(action != undefined && action.MessageConfig != undefined){
                        lwcFlexTableHandler.ShowSuccessMessage(action.MessageConfig);
                    }else{
                        lwcFlexTableHandler.ShowSuccessMessage(response.Message);
                    }

                    if(action != undefined){
                        checkRefreshBehavior(lwcFlexTableHandler,action);
                    }
					for (var i = 0; i < lwcFlexTableHandler.rowIdList.length; i += 1) {
                        if(lwcFlexTableHandler.rowIdList[i] != undefined){
                           //delete this.listOfRows[i];
                        //    this.listOfRows = this.listOfRows.filter(function (letter) {
                        //     return letter !== event.currentTarget.dataset.id ;
                        // });
                        let  index = -1;
                        if(lwcFlexTableHandler.listOfRows.indexOf(lwcFlexTableHandler.rowIdList[i] ) != undefined){
                             index = lwcFlexTableHandler.listOfRows.indexOf(lwcFlexTableHandler.rowIdList[i] );
                        }
                            
                        if (index !== -1) {
                            lwcFlexTableHandler.listOfRows.splice(index, 1);
                        }
            
                    }
                       
                }
                getSelectedRows(lwcFlexTableHandler);
                let sessionStr = getSessionData(lwcFlexTableHandler);
                let initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};

                if (lwcFlexTableHandler.level == 1 && initSessionData.pageNumber != undefined && lwcFlexTableHandler.data.length == 1) {
                    lwcFlexTableHandler.isResetMessage = true;
                    setSessionData("pageNumber", lwcFlexTableHandler.currentPage, lwcFlexTableHandler);
                    setSessionData("showResetMessage", true, lwcFlexTableHandler);
                }
            }else{
                 lwcFlexTableHandler.ShowErrorMessage(response.Message);
                }
            }).catch(error => {
                lwcFlexTableHandler.ShowErrorMessage(error.message);
            }); 
        }   
	//	event.preventDefault();
}

export function onClose(lwcFlexTableHandler){

    let newRecordCount =0;
    let isUndo= false;
    if(lwcFlexTableHandler.data != undefined && lwcFlexTableHandler.data.length > 0){
    
        for(let i=0;i < lwcFlexTableHandler.data.length; i++ ){
        
            if(lwcFlexTableHandler.data[i].id == lwcFlexTableHandler.row.id){
                lwcFlexTableHandler.data.splice(i,1);
                lwcFlexTableHandler.newSaveRecordCount --;
                isUndo = true;
                break;
            }
        }
        // for(let i=0;i < lwcFlexTableHandler.data.length; i++ ){
        //     if(lwcFlexTableHandler.data[i].isNew != undefined && lwcFlexTableHandler.data[i].isNew == true){
        //         newRecordCount++;
        //     }
        // }
    }
    if(lwcFlexTableHandler.gridLevel > 0 && lwcFlexTableHandler.newSaveRecordCount == 0 && lwcFlexTableHandler.editRecordCount == 0){
        let data={};
                    data['isError'] = false;
                    data['isSave'] = false;
                    const showmessagesatparent =new CustomEvent('showmessage', {
                        detail: data,
                        bubbles: true,
                        composed: true,
                    });
                    lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
    }
    if(lwcFlexTableHandler.newSaveRecordCount == 0&& lwcFlexTableHandler.editRecordCount == 0){
        lwcFlexTableHandler.isSave = false;
    }
    if(lwcFlexTableHandler.newSaveRecordCount == 0){
    	//lwcFlexTableHandler.isSave = false;
        lwcFlexTableHandler.EnableFilter   = lwcFlexTableHandler.flexTableConfig.EnableFilter != undefined ? lwcFlexTableHandler.flexTableConfig.EnableFilter : false;
        lwcFlexTableHandler.EnableQuickSearch   = lwcFlexTableHandler.flexTableConfig.EnableQuickSearch != undefined ? lwcFlexTableHandler.flexTableConfig.EnableQuickSearch : false;
       // lwcFlexTableHandler.EnablePageSize = lwcFlexTableHandler.flexTableConfig.EnablePageSize != undefined ? lwcFlexTableHandler.PageSizeValue >= lwcFlexTableHandler.TotalCount  ?  false : true : false;
        lwcFlexTableHandler.EnablePageSize = lwcFlexTableHandler.flexTableConfig.EnablePageSize === true ? (lwcFlexTableHandler.PageSizeValue!=undefined && lwcFlexTableHandler.PageSizeValue < lwcFlexTableHandler.TotalCount)  ?  true : false : false; 
        lwcFlexTableHandler.isRecordOpenMode = false;
    }
    if(lwcFlexTableHandler.newSaveRecordCount == 0){
        lwcFlexTableHandler.isNew = false;
    }
    if(isUndo == true){
        

        if(lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId] !=  undefined){
            
            for(let i=0; i < lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId].length; i++){
            if(lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId][i].Id == lwcFlexTableHandler.row.id){
            
               // lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId].splice(i);
               lwcFlexTableHandler.saveRecordMap[lwcFlexTableHandler.FlexTableId].splice(i,1);
            }
            }
        }
     }
     lwcFlexTableHandler.row ={};

}

export function editMultipleRecords(lwcFlexTableHandler,action){
    
    //lwcFlexTableHandler.OpenConfirmationBox = false;
    if(lwcFlexTableHandler.data != undefined && lwcFlexTableHandler.data.length > 0){
        
        for(let i=0; i < lwcFlexTableHandler.data.length; i++){
        
            if(lwcFlexTableHandler.data[i].id != undefined){
                updateRow(lwcFlexTableHandler.data[i].id,'isEdit',lwcFlexTableHandler);
            }
        }
    
    }
    
     let filters = [...lwcFlexTableHandler.template.querySelectorAll('c-fieldlwc')]
             .map(fieldschild => fieldschild.setValues());

}

export function executeClass(lwcFlexTableHandler,action){
   
    //lwcFlexTableHandler.OpenConfirmationBox = false;
    lwcFlexTableHandler.isLoading = true;
        lwcFlexTableHandler.ExeClassAction=action;
        if(action.ActionClass != undefined){
           // $scope.communicator.openLoadingPopUp();
            let executeClassParamJson =executeClassParams(lwcFlexTableHandler,action);
            let copiedObject = {};
            if(executeClassParamJson != undefined){

                executeClas({executeClassParamJSON : executeClassParamJson}).then(response =>{
                    if(response.Success == true || response.Success == 'true'){
                        lwcFlexTableHandler.listOfRows = [];
                        lwcFlexTableHandler.recordselection = {};
                        if(action != undefined && action.MessageConfig != undefined){
                            lwcFlexTableHandler.ShowSuccessMessage(action.MessageConfig);
                        }else{
                            lwcFlexTableHandler.ShowSuccessMessage(response.Message);
                        }
                        if(response.PageURL != undefined){
                           copiedObject = Object.assign({}, action ,{ ActionURLLongLWC: response.PageURL});
                            openUrl(lwcFlexTableHandler,copiedObject);
                        }else{
                            checkRefreshBehavior(lwcFlexTableHandler,action);
                        }
                        
                    }else{
                        if(response.Success == false || response.Success == 'false'){
                            lwcFlexTableHandler.ShowErrorMessage(response.Message);
                            lwcFlexTableHandler.listOfRows = [];
                        lwcFlexTableHandler.recordselection = {};
                        
                        }
                    }

                }).catch(error => {
                    //thiss.showtoastmeassage('Error','Error','error');
                    lwcFlexTableHandler.ShowErrorMessage(error.message);
                    lwcFlexTableHandler.listOfRows = [];
                        lwcFlexTableHandler.recordselection = {};
                });

            }
            
            
        }

}


export function executeClassParams(lwcFlexTableHandler,action){

   
    let executeClassParamMap = {};
	    	executeClassParamMap['recordSelectionMap'] = lwcFlexTableHandler.recordselection;
	    	executeClassParamMap['stringParameters'] = JSON.stringify(lwcFlexTableHandler.stringParameters);// keyValueMap
            executeClassParamMap['listParameters'] = JSON.stringify(lwcFlexTableHandler.listParameters);// listmap
	    	executeClassParamMap['actionClass'] = action.ActionClass;
	    	executeClassParamMap['action'] = action;
	    	executeClassParamMap['tableName'] = lwcFlexTableHandler.flexTableConfig.Name;
	    	executeClassParamMap['gridName'] = lwcFlexTableHandler.gridname;
	    	if(lwcFlexTableHandler.isLightning === true){
                executeClassParamMap['url'] =lwcFlexTableHandler.currentPageReference != null && lwcFlexTableHandler.currentPageReference != undefined ? JSON.stringify(lwcFlexTableHandler.currentPageReference.state) : JSON.stringify({});
            }else{
				executeClassParamMap['url'] = JSON.stringify(getUrlParameter(lwcFlexTableHandler.flexGridEnhanced_currentPageURL));
			}
			executeClassParamMap['query'] = lwcFlexTableHandler.query;
	    	if(lwcFlexTableHandler.row != undefined){
	    		executeClassParamMap['selectedRecordId'] = lwcFlexTableHandler.row.id;
			}
			if(lwcFlexTableHandler.parentId != null){
	        	executeClassParamMap['parentRecordId'] = lwcFlexTableHandler.parentId;
	        }
            let executeClassParamJson = JSON.stringify(executeClassParamMap);
	    	return executeClassParamJson;
}

function getUrlParameter(url){
    let newUrlParamMap ={};
    if(url != undefined && url !=''){
    
        let URLParamsList = url.split('?',-1);
        if(URLParamsList.length >= 2){
            let URLparams = URLParamsList[1];
            if(URLparams != null && URLparams.length > 0){
                let ParamsList = URLparams.split('&',-1);
                for(let i=0; i< ParamsList.length; i++){
                    let paramKeyvalue = ParamsList[i].split('=',-1);
                    if(paramKeyvalue.length > 1) {
                        if(paramKeyvalue[1] != undefined && paramKeyvalue[1].includes('#/!') == true){
                            paramKeyvalue[1] = paramKeyvalue[1].remove('#/!');
                        }
                        newUrlParamMap[paramKeyvalue[0]]=paramKeyvalue[1];
                    }
                }
            }
        }
    }
    return newUrlParamMap;
}

export function toplevelActionMap(lwcFlexTableHandler,ifrefesh){

    if(ifrefesh === false){
    let AllTopLevelActions =[];
    let actions = [];
    let menuActions = [];
    let AllTopMenuActions =[];
    if(lwcFlexTableHandler.FlexTableActionMap.Top != undefined ){
        
        for(let i=0; i < lwcFlexTableHandler.FlexTableActionMap.Top.length; i++){
            if(lwcFlexTableHandler.FlexTableActionMap.Top[i].HeaderActionDisplayType != undefined && lwcFlexTableHandler.FlexTableActionMap.Top[i].HeaderActionDisplayType == 'Menu' ){
                menuActions.push(lwcFlexTableHandler.FlexTableActionMap.Top[i]);
            }else if(lwcFlexTableHandler.FlexTableActionMap.Top[i].StandardAction != "Save"){
                actions.push(lwcFlexTableHandler.FlexTableActionMap.Top[i]);
            }else if(lwcFlexTableHandler.FlexTableActionMap.Top[i].StandardAction == "Save"){
                lwcFlexTableHandler.saveTopAction = lwcFlexTableHandler.FlexTableActionMap.Top[i];
            }
     }
                AllTopLevelActions = setActionOrders(lwcFlexTableHandler,actions);
                AllTopMenuActions = setActionOrders(lwcFlexTableHandler,menuActions);
        
    }

    
    
    if(AllTopLevelActions != undefined){
        for(let index=0; index < AllTopLevelActions.length; index++){
            let toplevelactions={};
            let actionValue=AllTopLevelActions[index];
            if(actionValue.HideExpressionJSON != undefined){

                //lwcFlexTableHandler.hideActionMap['Top'] = lwcFlexTableHandler.hideActionMap['Top'] != undefined ? lwcFlexTableHandler.hideActionMap['Top'] : {};
                let hideExpressionResult = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(actionValue.HideExpressionJSON), false, true);
                lwcFlexTableHandler.finalParentExpressionEval = undefined;
                let finalHideExpressionResult = parentExpressionEval(lwcFlexTableHandler,hideExpressionResult);
                if(finalHideExpressionResult != true){
                    lwcFlexTableHandler.TopLevelAction.push(actionValue);
                }
                //this.hideActionMap['Top'][actionValue.Name] = finalHideExpressionResult;
            }else{
            
                lwcFlexTableHandler.TopLevelAction.push(actionValue);
            }


        }
    }
    if(AllTopMenuActions != undefined){
        for(let index=0; index < AllTopMenuActions.length; index++){
            let toplevelactions={};
            let actionValue=AllTopMenuActions[index];
            if(actionValue.HideExpressionJSON != undefined){

                let hideExpressionResult = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(actionValue.HideExpressionJSON), false, true);
                lwcFlexTableHandler.finalParentExpressionEval = undefined;
                let finalHideExpressionResult = parentExpressionEval(lwcFlexTableHandler,hideExpressionResult);
                if(finalHideExpressionResult != true){
                    lwcFlexTableHandler.menuLevelActions.push(actionValue);
                }
             }else{
            
                lwcFlexTableHandler.menuLevelActions.push(actionValue);
            }

            
        }
    }
    const menuActionRefresh=  {HideExpressionJSON:undefined, Iconcss:"utility:refresh",Id: "2",Name: "Refresh",Sequence: 1};
    const menuActionExportPDf=  {HideExpressionJSON:undefined, Iconcss:"utility:pdf_ext",Id: "3",Name: "Download as PDF",Sequence: 1};
    const menuActionExportCSV=  {HideExpressionJSON:undefined, Iconcss:"utility:file",Id: "4",Name: "Download as CSV",Sequence: 1};
    lwcFlexTableHandler.menuLevelActions.push(menuActionRefresh);
    if(lwcFlexTableHandler.EnableExport == true){
        lwcFlexTableHandler.menuLevelActions.push(menuActionExportPDf);
    }
    if(lwcFlexTableHandler.EnableExportXls == true){
        lwcFlexTableHandler.menuLevelActions.push(menuActionExportCSV);
    }
    if(lwcFlexTableHandler.menuLevelActions.length > 0){
        lwcFlexTableHandler.isMenuActionPresent = true;
 
    }

    //lwcFlexTableHandler.TopLevelAction = AllTopLevelActions;
}    
}

export function updateEditAllAction(lwcFlexTableHandler){


    for(let i=0; i< lwcFlexTableHandler.TopLevelAction.length; i++){
    
        if(lwcFlexTableHandler.TopLevelAction[i].isEditAll == true){
        	lwcFlexTableHandler.TopLevelAction[i]['ActionName'] = lwcFlexTableHandler.TopLevelAction[i].Name;
            lwcFlexTableHandler.TopLevelAction[i]['Name'] = lwcFlexTableHandler.TopLevelAction[i].Name != 'Undo Edit' ? 'Undo Edit' : lwcFlexTableHandler.action.Name;
        }
    }
}

export function openUrl(lwcFlexTableHandler,action){

    
    let winURL = processUrl(lwcFlexTableHandler,action,action.ActionURLLongLWC);
    
    let currentPageURL = lwcFlexTableHandler.flexGridEnhanced_currentPageURL;
        if (currentPageURL.indexOf('&retURL') != -1 || currentPageURL.indexOf('?retURL') != -1) {
            currentPageURL = currentPageURL.substring(0, currentPageURL.indexOf('retURL') - 1);
        }
        let newUrl = new URL(window.location.href);
        let retUrl = newUrl.href.replace(newUrl.origin, '');
        if (winURL.indexOf("?") === -1) {
            winURL = winURL + '?retURL=' + encodeURIComponent(retUrl);            
        }else {
            winURL = winURL + '&retURL=' + encodeURIComponent(retUrl);           
        }
    if(lwcFlexTableHandler.sObjectFormInstance == true){
    formDetails({recordId : lwcFlexTableHandler.row.id, actionURLLongLWC : action.ActionURLLongLWC}).then(response=>{
        if(response){
            
         if (action.WhereToOpen === 'SameWindow') {
            if(lwcFlexTableHandler.isLightning === true){
                let winURL = encodeUrlParams(response);
                window.open(winURL, '_self');
            
            }else if(lwcFlexTableHandler.initResult.isCommunitySiteUser){
                let winURL = encodeUrlParams(response);
                winURL = convertUrlToCommunitySite(lwcFlexTableHandler,winURL);
                if(winURL != undefined){
                    window.open(winURL, '_self');
                }
            }else{
               window.open(winURL, '_self');
            }
        
        }else if (action.WhereToOpen === 'NewTab') {
           if(lwcFlexTableHandler.isLightning === true){
                let winURL = encodeUrlParams(response);
                window.open(winURL, '_blank');
            }else if(lwcFlexTableHandler.initResult.isCommunitySiteUser){
                let winURL = encodeUrlParams(response);
                winURL = convertUrlToCommunitySite(lwcFlexTableHandler,winURL);
                if(winURL != undefined){
                    window.open(winURL, '_blank');
                }
            }else{
              window.open(winURL, '_blank');
        }
        
    }else if (action.WhereToOpen === 'NewWindow') {
        if(lwcFlexTableHandler.isLightning === true){
            let winURL = encodeUrlParams(response);
            window.open(winURL, '_blank', 'width='+window.innerWidth+',height=' +window.innerHeight);
            
        }else if(lwcFlexTableHandler.initResult.isCommunitySiteUser){
            let winURL = encodeUrlParams(response);
            winURL = convertUrlToCommunitySite(lwcFlexTableHandler,winURL);
            if(winURL != undefined){
                window.open(winURL, '_blank', 'width='+window.innerWidth+',height=' +window.innerHeight);
            }
        }else{
            window.open(winURL, '_blank', 'width='+window.innerWidth+',height=' +window.innerHeight);
        }
        
    }else if (action.WhereToOpen === 'Modal') {  
        
        getModalDetails(lwcFlexTableHandler,action);
    }else if (action.WhereToOpen === 'SplitScreen') {  
        const payload = {
            data: {
                openUrl: response,
                isSplitScreen: true
            }
        };
        publish(lwcFlexTableHandler.messageContext, messageChannel, payload);
    }
}
}).catch(error =>{
    lwcFlexTableHandler.ErrorMessage = error.body.message;
    lwcFlexTableHandler.isErrorMessage = true;
    setTimeout(() => {
        lwcFlexTableHandler.isErrorMessage = false; 
    }, lwcFlexTableHandler.messageTimeOut);
}); 
    }
          if(lwcFlexTableHandler.sObjectFormInstance != true){
          if (action.WhereToOpen === 'SameWindow') {
           

            if(lwcFlexTableHandler.isLightning === true){
                let newUrl = encodeUrlParams(winURL);
                if(newUrl != undefined){
                    window.open(newUrl, '_self');
                }
            }else if(lwcFlexTableHandler.initResult.isCommunitySiteUser){
                let newUrl = encodeUrlParams(winURL);
                newUrl = convertUrlToCommunitySite(lwcFlexTableHandler,newUrl);
                if(newUrl != undefined){
                    window.open(newUrl, '_self');
                }
            }else{
                window.open(winURL, '_self');
            }
           // window.open(winURL, '_self');
        }else if (action.WhereToOpen === 'NewTab') {
            

            if(lwcFlexTableHandler.isLightning === true){
                let newUrl = encodeUrlParams(winURL);
                if(newUrl != undefined){
                    window.open(newUrl, '_blank');
                }
            }else if(lwcFlexTableHandler.initResult.isCommunitySiteUser){
                let newUrl = encodeUrlParams(winURL);
                newUrl = convertUrlToCommunitySite(lwcFlexTableHandler,newUrl);
                if(newUrl != undefined){
                    window.open(newUrl, '_blank');
                }
            }else{
                window.open(winURL, '_blank');
            }
            
        }else if (action.WhereToOpen === 'NewWindow') {
           

            if(lwcFlexTableHandler.isLightning === true){
                let newUrl = encodeUrlParams(winURL);
                if(newUrl != undefined){
                    window.open(newUrl, '_blank', 'width='+window.innerWidth+',height=' +window.innerHeight);
                }
            }else if(lwcFlexTableHandler.initResult.isCommunitySiteUser){
                let newUrl = encodeUrlParams(winURL);
                newUrl = convertUrlToCommunitySite(lwcFlexTableHandler,newUrl);
                if(newUrl != undefined){
                    window.open(newUrl, '_blank', 'width='+window.innerWidth+',height=' +window.innerHeight);
                }
            }else{
                window.open(winURL, '_blank', 'width='+window.innerWidth+',height=' +window.innerHeight);
            }
            
        }else if (action.WhereToOpen === 'Modal') {  
		
        
            getModalDetails(lwcFlexTableHandler,action);
        }else if (action.WhereToOpen === 'SplitScreen') {  
            const payload = {
                data: {
                    openUrl: winURL,
                    isSplitScreen: true
                }
            };
            publish(lwcFlexTableHandler.messageContext, messageChannel, payload);
        }
    }
    
}

function encodeUrlParams(url) {

    try {

        if (url.includes("?")) {

            let urlStrings = url.split("?");

            let params = urlStrings[1].split("&");

            let encodedParams = [];




            params.forEach((param) => {

                let paramStrings = param.split("=");

                encodedParams.push(paramStrings[0] + "=" + window.btoa(paramStrings[1]));

            });




            encodedParams = encodedParams.join("&");

            let encodedUrl = urlStrings[0] + "?" + encodedParams;

            return encodedUrl;

        } else {

            return url;

        }

    } catch (error) {


        return null;

    }

}


export function convertUrlToCommunitySite(lwcFlexTableHandler,url){
    try {
        //record detail page
        if (url.toLowerCase().includes("/lightning/r/")) {
            let splittedUrl = url.split("/lightning/r/")[1];
            let recId = splittedUrl.split("/", 2)[1];
            let urlParams = splittedUrl.split("/view")[1];
            return lwcFlexTableHandler.initResult.CommunityBaseUrl + "/detail/" + recId + urlParams;
        } else if (url.toLowerCase().includes("/lightning/n/")) {
            //for flexi page type
            let splittedUrl = url.split("/lightning/n")[1];
            return lwcFlexTableHandler.initResult.CommunityBaseUrl + splittedUrl;
        }else if(url.toLowerCase().includes("/servlet.shepherd")) {
            return lwcFlexTableHandler.initResult.CommunityBaseUrl.slice(0,-2) + url;
        } else {
            //other urls like--> /sfc/servlet.shepherd/version/download/{!rowId}
            return lwcFlexTableHandler.initResult.CommunityBaseUrl + url;
        }
    } catch (error) {
        console.error("URL entered is invalid::", JSON.stringify(error));
        return lwcFlexTableHandler.initResult.CommunityBaseUrl;
    }
}


export function processUrl(lwcFlexTableHandler,action,url){

    let winURL = '';
    /*if(action.ActionURLLong != undefined){
        if(action.ActionURLLong.indexOf('#/!') != -1){
                action.ActionURLLong = action.ActionURLLong.replace('#/!','');
        }
        winURL = decodeURIComponent(action.ActionURLLong);   
    }*/
    if(url != undefined){
        if(url.indexOf('#/!') != -1){
            url = url.replace('#/!','');
        }
        winURL = decodeURIComponent(url);   
    }
    if(action.Location === 'Top'){
        winURL = replaceParentMergeFields(lwcFlexTableHandler,winURL);   
    }
    if(lwcFlexTableHandler.row != undefined){
        winURL = winURL.replaceAll('{!rowId}',lwcFlexTableHandler.row.id); 
        winURL = replaceParentMergeFields(lwcFlexTableHandler,winURL);
        winURL = replaceRelatedRecordFields(lwcFlexTableHandler,winURL);  
    }
    winURL = replaceStringParamters(lwcFlexTableHandler,winURL);
    winURL = replaceListParamters(lwcFlexTableHandler,winURL);
    winURL = winURL.replace('{!query}',lwcFlexTableHandler.query);

    return winURL;
}

export function replaceParentMergeFields(lwcFlexTableHandler,winURL){
    if(lwcFlexTableHandler.tableId === lwcFlexTableHandler.parentFlexTableId){
        if(lwcFlexTableHandler.parentRecordId != undefined){
        winURL = winURL.replace('{!parentId}',lwcFlexTableHandler.parentRecordId);
        }
    }
    if(lwcFlexTableHandler.parentId != undefined &&
        lwcFlexTableHandler.parentId != null && 
        lwcFlexTableHandler.parentId != ''){
        winURL = winURL.replace('{!parentId}', escape(lwcFlexTableHandler.parentId));    
    }
    return winURL;
}

export function replaceRelatedRecordFields(lwcFlexTableHandler,winURL){

    let  winMergeFields = [];
            winMergeFields = winURL.match(/{!([^}]*)}/g);
            if(winMergeFields === null){
                return winURL;
            }
            for (let i=0;i<winMergeFields.length;i++){
                winMergeFields[i] = winMergeFields[i].replace(/{!/g,'').replace(/}/g,''); //False +ve for incomplete - sanitization - as we are not using this for sanitization
                let merFields = winMergeFields[i].split(/\.(.+)/);    
                let valueGetter =merFields[1];
                let fieldValue = valueGetter != undefined ? lwcFlexTableHandler.row[valueGetter.toLowerCase()] : '';
                if(lwcFlexTableHandler.SObjectName === merFields[0]){
                    winURL = winURL.replace('{!'+merFields[0]+'.'+merFields[1]+'}',fieldValue);     
                }
                if(lwcFlexTableHandler.SObjectName !== merFields[0]){
                    let fieldValue = merFields[0] != undefined ? lwcFlexTableHandler.row[merFields[0].toLowerCase()] : '';
                    winURL = winURL.replace('{!'+merFields[0]+'.'+merFields[1]+'}',fieldValue);   
                }
            }
            return winURL;
}

export function QuickSearch(lwcFlexTableHandler,searchkey,check){

        lwcFlexTableHandler.isFirst = true;
        if(check == true){
        lwcFlexTableHandler.currentPage=1;
        }
        /*if(searchkey != ''){
        
            this.quicksearch = true;
        }else{
            this.quicksearch = false;
        }
        var tempArray =[];
        if(this.filterlist.length > 0){
        this.AdvancedFilter = true;
        }else{
            this.AdvancedFilter = false;
        }
        var data= this.AdvancedFilter === true ? this.QuicksearchData : this.flattenedData;
        var i;*/
        var tempArray =[];
        var data = lwcFlexTableHandler.dataforQuickSeach;
        //let processedSearchKey = quicksearchtermProcess(lwcFlexTableHandler,searchkey);
        if(searchkey != undefined && searchkey != ''){
            if (searchkey.includes("%") || searchkey.includes(".")) {
                searchkey = parseFloat(searchkey.replace(/[.%]/g, '')) / 100;
                searchkey = searchkey.toString();
              }
            for(let i=0; i< data.length; i++){
                let matchcount=0;
                let valuesArray = Object.values( data[i] );
              
                if(valuesArray.toString().toLowerCase().includes(searchkey.toLowerCase()) || searchkey.includes('/')){
                   if(lwcFlexTableHandler.QuickSearchColumnList != undefined){

                        
                    
                            for(let j=0; j< lwcFlexTableHandler.QuickSearchColumnList.length; j++){
                            
                                let fieldname =  lwcFlexTableHandler.QuickSearchColumnList[j];
                                let fieldtype =  lwcFlexTableHandler.FieldMetaData[fieldname].Type;
                                // let SearchValue     =  processedSearchKey[j].SearchValue;
                                if(data[i][fieldname.toLowerCase()] != undefined){
                                
                                    var fieldValue =JSON.stringify(data[i][fieldname.toLowerCase()]).toUpperCase();
                                    
                                    var SearchValue; 
                                    if(fieldtype === 'INTEGER' || fieldtype === 'CURRENCY' || fieldtype === 'DOUBLE' || fieldtype === 'PERCENT' || fieldtype === 'URL' || fieldtype ==='DATE' || fieldtype === 'MULTIPICKLIST' || fieldtype ==='DATETIME'){
                                    
                                        SearchValue = SearchValueProcess(lwcFlexTableHandler,fieldname,fieldtype,searchkey)
                                    }else if(fieldtype === 'REFERENCE' ){
                                    
                                        fieldname = getReferenceFieldName(lwcFlexTableHandler,fieldname)
                                        fieldValue =JSON.stringify(data[i][fieldname.toLowerCase()]).toUpperCase();
                                        SearchValue = searchkey;
                                    }else{ 
                                        SearchValue = searchkey;
                                    }
                                    if(SearchValue != null && SearchValue != undefined){
                                        if(fieldtype === 'INTEGER' ){
                                        
                                            if(parseInt(SearchValue) == fieldValue){
                                                matchcount= matchcount + 1;
                                                break;
                                            }
                                        }else if(fieldtype === 'DOUBLE' || fieldtype === 'CURRENCY'){
                                            if(!(fieldValue.includes('.'))){
                                                fieldValue = fieldValue + getappendedtext(lwcFlexTableHandler.FieldMetaData[fieldname].Scale);
                                            }
                                            if(fieldValue.includes(SearchValue)){
                                                matchcount= matchcount + 1;
                                                break;
                                            }
                                        }
                                        
                                        else{
                                            
                                            if(fieldValue.includes(SearchValue)){
                                                matchcount= matchcount + 1;
                                                break;
                                            }
                                        }
                                    }
                                
                                }
                            }
                    
                    }
               }


                if(matchcount > 0){
                        tempArray.push(data[i]);
                }
            }    
        }else{
            tempArray = lwcFlexTableHandler.dataforQuickSeach;
        }    
        if(tempArray.length > 0){
            lwcFlexTableHandler.quicksearchdata=tempArray;
            lwcFlexTableHandler.noRecords = false;
            lwcFlexTableHandler.TotalCount = lwcFlexTableHandler.quicksearchdata.length;
            lwcFlexTableHandler.Totoalrecords = 'Total Records: ' + lwcFlexTableHandler.TotalCount;
		     handlePagination(lwcFlexTableHandler);
            lwcFlexTableHandler.End = lwcFlexTableHandler.TotalCount < lwcFlexTableHandler.pageSize ? lwcFlexTableHandler.TotalCount : lwcFlexTableHandler.pageSize;
            if(tempArray.length <= lwcFlexTableHandler.pageSize){
                lwcFlexTableHandler.EnablePageSize = false;
                lwcFlexTableHandler.EnablePagination = false;

                if(lwcFlexTableHandler.PageSizeValue === 'All'){
                    if(tempArray.length === lwcFlexTableHandler.pageSize){
                        lwcFlexTableHandler.EnablePageSize= lwcFlexTableHandler.flexTableConfig.EnablePageSize === true ? true : false;
                    }
                }
             }else{

                lwcFlexTableHandler.EnablePageSize= lwcFlexTableHandler.flexTableConfig.EnablePageSize === true ? true : false;
                lwcFlexTableHandler.EnablePagination = true;
             }


             
         }
         else{
            lwcFlexTableHandler.data=undefined;
             lwcFlexTableHandler.noRecords = true;
             lwcFlexTableHandler.EnablePageSize = false;
             lwcFlexTableHandler.EnablePagination = false;
             lwcFlexTableHandler.End = 0;
             lwcFlexTableHandler.Start= lwcFlexTableHandler.currentPage;
             lwcFlexTableHandler.TotalCount=0;
			 lwcFlexTableHandler.Totoalrecords = '';
             lwcFlexTableHandler.ShowRecordMessage = false;
             lwcFlexTableHandler.AdvancedfilterData = undefined;
             lwcFlexTableHandler.isLoading = false;
             lwcFlexTableHandler.dynamicClass ='height:auto;'
         }
}


function SearchValueProcess(lwcFlexTableHandler,fieldname,fieldtype,searchkey){

    let key;
    if(fieldtype != undefined){
    
        switch(fieldtype){
            case 'CURRENCY' :
                if(searchkey != ''){
                
                    key = searchkey.replace(/[^0-9./ ]/g, '');
                    key = key ==='' ? null : key;

                }else{
                
                    key = searchkey;
                }
            break;
            case 'DOUBLE' :
                if(searchkey != ''){
                
                    key = searchkey.replace(/[^0-9./ ]/g, '');
                    key = key ==='' ? null : key;

                }else{
                
                    key = searchkey;
                }
            break;
            case 'PERCENT' :
                if(searchkey != ''){
                
                    key = searchkey.replace(/[^0-9. ]/g, '');
                   // key = ( key != '' && key != null ) ?  parseInt(key) > 100 ? parseInt(key) / 100 : parseInt(key)  : null;
                   key = ( key != '' && key != null ) ? parseInt(key)  : null;
                }else{
                
                    key = searchkey;
                }
            break;
            case 'URL' :
                if(searchkey != ''){
                
                    key = searchkey != undefined  ?  searchkey.replace('HTTPS://','') : null;
                }else{
                
                    key = searchkey;
                }
            break;
            case 'DATE' :
                if(searchkey != ''){
                    key = searchkey;
                    if(key.includes('/')){
                        let searchsplitkey = key.split('/');
            
                        key = searchsplitkey[2] != undefined ? searchsplitkey[2] : undefined;
                        key = searchsplitkey[0] != undefined ? searchsplitkey[0] >= 10 ? key +'-'+searchsplitkey[0] : key +'-0'+searchsplitkey[0] : undefined;
                        //key = searchsplitkey[1] != undefined ? key +'-'+searchsplitkey[1] : undefined;
                        key = searchsplitkey[1] != undefined ? searchsplitkey[1] >= 10 ? key +'-'+searchsplitkey[1] : key +'-0'+searchsplitkey[1] : undefined;
                    }
                    key = key != undefined ?  key : null;
                }else{
                
                    key = searchkey;
                }
            break;
            case 'DATETIME' :
                if(searchkey != ''){                   
                    const dateTime1= new Date(searchkey);
                    const tzDateTime= new Date(dateTime1.toLocaleString("en-US", {timeZone: lwcFlexTableHandler.timeZone}));
                    let hoursDiff = Math.abs(dateTime1 - tzDateTime) / 36e5;
                    const updatedDateTime= new Date(dateTime1.getTime()+ (hoursDiff * 60 * 60 * 1000));
                    // let isoString=new Date(searchkey).toISOString();        
                    let isoString=new Date(updatedDateTime).toISOString();     
                    key = isoString != undefined ?  isoString : null;        
                }else{               
                    key = searchkey;
                }
            break;
            case 'MULTIPICKLIST' :
                if(searchkey != ''){
                
                    key = searchkey.includes(';')  ?  getmultipicklistApi(lwcFlexTableHandler,fieldname,searchkey.toLowerCase()).toUpperCase() : searchkey;
                }else{
                
                    key = searchkey;
                }
            default :

            break;

        } 
    }
    return key;
}

function getmultipicklistApi(lwcFlexTableHandler,fieldname,searchkey){

    let SearchValue='';
    if(searchkey != undefined){
    
        let multiPicklistValueList = searchkey.split(';');
        let optionsMap = lwcFlexTableHandler.FieldMetaData[fieldname].PickListFieldInfo.FieldPicklistValueLabelMap != undefined ? Object.keys(lwcFlexTableHandler.FieldMetaData[fieldname].PickListFieldInfo.FieldPicklistValueLabelMap) : '';
        
        for(let i=0; i< multiPicklistValueList.length; i++){
        
            for(let j=0; j < optionsMap.length; j++){
                
                if(lwcFlexTableHandler.FieldMetaData[fieldname].PickListFieldInfo.FieldPicklistValueLabelMap[optionsMap[j]].toLowerCase() === multiPicklistValueList[i]){
                    SearchValue = SearchValue + optionsMap[j] +';';
                }
            }


        }


    }
    return SearchValue;
}

function quicksearchtermProcess(lwcFlexTableHandler,searchkey){


  
    let quicksearchList = [];
    
    if(lwcFlexTableHandler.QuickSearchColumnList != undefined &&  lwcFlexTableHandler.QuickSearchColumnList.length > 0 && searchkey != undefined){
    
        for(let i=0; i < lwcFlexTableHandler.QuickSearchColumnList.length; i++){
            let QuickSearchdata = {};
            let fieldname = lwcFlexTableHandler.QuickSearchColumnList[i];
            let fieldtype = lwcFlexTableHandler.FieldMetaData[fieldname].Type;

            if(fieldtype === 'CURRENCY'){
            
                QuickSearchdata['fieldName'] = fieldname.toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
                let key;
                if(searchkey != ''){
                
                    key = searchkey.replace(/[^0-9./ ]/g, '');
                    key = key ==='' ? null : key;

                }else{
                
                    key = searchkey;
                }
                QuickSearchdata['SearchValue'] = key;
                QuickSearchdata['AppendText'] = getappendedtext(lwcFlexTableHandler.FieldMetaData[fieldname].Scale);
                quicksearchList.push(QuickSearchdata);
            }else if(fieldtype === 'DOUBLE'){
            
                QuickSearchdata['fieldName'] = fieldname.toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
                let key;
                if(searchkey != ''){
                
                    key = searchkey.replace(/[^0-9./ ]/g, '');
                    key = key ==='' ? null : key;

                }else{
                
                    key = searchkey;
                }
                QuickSearchdata['SearchValue'] = key;
                QuickSearchdata['AppendText'] = getappendedtext(lwcFlexTableHandler.FieldMetaData[fieldname].Scale);
                quicksearchList.push(QuickSearchdata);
            }else if(fieldtype === 'PERCENT'){
            
                QuickSearchdata['fieldName'] = fieldname.toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
				let key ;
                //key = ( key != '' && key != null )?  parseInt(searchkey) / 100 : searchkey;
                if(searchkey != ''){
                
                    key = searchkey.replace(/[^0-9. ]/g, '');
                   // key = ( key != '' && key != null ) ?  parseInt(key) > 100 ? parseInt(key) / 100 : parseInt(key)  : null;
                   key = ( key != '' && key != null ) ? parseInt(key)  : null;
                }else{
                
                    key = searchkey;
                }
                QuickSearchdata['SearchValue'] = key;
                QuickSearchdata['AppendText'] = getappendedtext(lwcFlexTableHandler.FieldMetaData[fieldname].Scale);
                quicksearchList.push(QuickSearchdata);
            }else if(fieldtype === 'REFERENCE'){
            
                QuickSearchdata['fieldName'] = getReferenceFieldName(lwcFlexTableHandler,fieldname).toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
                let key;
                if(searchkey != ''){
                
                    key = searchkey;
                }else{
                
                    key = searchkey;
                }
                QuickSearchdata['SearchValue'] = key;
                quicksearchList.push(QuickSearchdata);
            }else if(fieldtype === 'URL'){
            
                QuickSearchdata['fieldName'] = getReferenceFieldName(lwcFlexTableHandler,fieldname).toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
                let key ;
                if(searchkey != ''){
                
                    key = searchkey != undefined  ?  searchkey.replace('HTTPS://','') : null;
                }else{
                
                    key = searchkey;
                }
                QuickSearchdata['SearchValue'] = key;
                quicksearchList.push(QuickSearchdata);
            }else if(fieldtype === 'DATE'){
            
                QuickSearchdata['fieldName'] = getReferenceFieldName(lwcFlexTableHandler,fieldname).toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
                
                let key ;
                if(searchkey != ''){
                    key = searchkey;
                    if(key.includes('/')){
                        let searchsplitkey = key.split('/');
            
                        key = searchsplitkey[2] != undefined ? searchsplitkey[2] : undefined;
                        key = searchsplitkey[0] != undefined ? searchsplitkey[0] >= 10 ? key +'-'+searchsplitkey[0] : key +'-0'+searchsplitkey[0] : undefined;
                        key = searchsplitkey[1] != undefined ? key +'-'+searchsplitkey[1] : undefined;
                            
                    }
                    key = key != undefined ?  key : null;
                }else{
                
                    key = searchkey;
                }
                
                QuickSearchdata['SearchValue'] = key;
                quicksearchList.push(QuickSearchdata);
            }else{
            
                QuickSearchdata['fieldName'] = fieldname.toLowerCase();
                QuickSearchdata['fieldType'] = fieldtype;
                let key ;
                if(searchkey != ''){
                
                    key = searchkey;
                }else{
                
                    key = searchkey;
                }
                QuickSearchdata['SearchValue'] = key;
                quicksearchList.push(QuickSearchdata);
            }
        
        }
    
    }

    return quicksearchList;
}

function getappendedtext(scale){
    let returntext;
    if(scale != undefined && scale > 0){
        returntext='.';
        for(let i=0;i < scale; i++){
            returntext = returntext +'0';
        }

    }else{
        returntext = '';
    }

    return returntext;
}

export function getAdvancedfilterSeachkey(lwcFlexTableHandler){

        //lwcFlexTableHandler.isLoading = true;
		lwcFlexTableHandler.isFirst = true;
        lwcFlexTableHandler.filtersadded=true;
        let newfilter={};
        lwcFlexTableHandler.keyIndex=lwcFlexTableHandler.keyIndex + 1;
        lwcFlexTableHandler.currentPage=1;
        let fieldType   =    lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Type != 'REFERENCE'  ?  lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Type  : lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].ReferenceFieldInfo.Type;
        let filtervalue;
        let filtervaluelabel;

        if(fieldType != undefined && fieldType != '' && fieldType != null){
            filtervalue =    lwcFlexTableHandler.Advancedfiltervalue;
            switch(fieldType){
                case 'CURRENCY' :

                    let value = Number(filtervalue).toFixed(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Scale);
                    filtervalue = value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                    filtervaluelabel = '$'+filtervalue;
                break;
                case 'PERCENT' :

                    filtervalue = Number(filtervalue).toFixed(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Scale);
                    filtervalue = filtervalue.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","); //False +ve for non literal regex used for sanitization, as we are not using for sanitization purpose
                    filtervaluelabel =filtervalue +'%';
                    //lwcFlexTableHandler.Advancedfiltervalue = lwcFlexTableHandler.Advancedfiltervalue != undefined ? lwcFlexTableHandler.Advancedfiltervalue / 100 : lwcFlexTableHandler.Advancedfiltervalue;
                break;
                case 'INTEGER' || 'DOUBLE' :

                    filtervalue = Number(filtervalue).toFixed(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Scale);
                    filtervalue = filtervalue.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
                    filtervaluelabel =filtervalue;
                break;
                case 'DATE' :

                    let filtervaluelabelsplit=filtervalue.split('-');
                    filtervaluelabel = filtervaluelabelsplit[1]+'/'+filtervaluelabelsplit[2]+'/'+filtervaluelabelsplit[0];
                break;
                case 'DATETIME' :

                    if(filtervalue != undefined){
                
                        const myDate =new Date(filtervalue);;
                        const time = new Date(filtervalue).toLocaleTimeString('en',{ timeStyle: 'short', hour12: true, timeZone: lwcFlexTableHandler.timeZone });
                        
                        let year = myDate.getFullYear();
                        let month = myDate.getMonth()+1 < 10 ? '0'+ (myDate.getMonth()+1) : myDate.getMonth()+1;
                        let dt = myDate.getDate() < 10 ? '0'+myDate.getDate() : myDate.getDate();
    
                        filtervaluelabel = month + '/'+dt+'/'+year+' '+time;
    
                    }
                break;
                default :
                    filtervaluelabel = lwcFlexTableHandler.Advancedfiltervalue;
                    if(!(lwcFlexTableHandler.AdvancedFilterFieldApi.toLowerCase().includes('__r')) && lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Type === 'REFERENCE'){
                        filtervaluelabel=lwcFlexTableHandler.AdvancedfiltervalueforLookup;
                    }
                break;
                
            }
        }

        newfilter['Id']=lwcFlexTableHandler.keyIndex+1;
        newfilter['name']=lwcFlexTableHandler.AdvancedFilterFieldLabel+' '+lwcFlexTableHandler.AdvanceFilterOperatorLabel+' '+filtervaluelabel;
        newfilter['FieldName']=lwcFlexTableHandler.AdvancedFilterFieldApi;
        newfilter['Operator']=lwcFlexTableHandler.AdvanceFilterOperatorValue;
        newfilter['Filtervalue']=lwcFlexTableHandler.Advancedfiltervalue;
        
        lwcFlexTableHandler.Advancedfilterlist.push(newfilter);
        Searchadvancedfilter(lwcFlexTableHandler);
}


function Searchadvancedfilter(lwcFlexTableHandler){
    
        
        
    getAdvancedFilterResult(lwcFlexTableHandler);

    //this.SObjectFieldName= this.FieldsOption[0] != undefined ? this.FieldsOption[0].apiname :'';
    lwcFlexTableHandler.AdvancedFilterFieldApi =  lwcFlexTableHandler.FieldsOption.length > 0 ? lwcFlexTableHandler.FieldsOption[0].value : '';
    //lwcFlexTableHandler.AdvancedFilterFieldLabel = getLabelForColumns(lwcFlexTableHandler,lwcFlexTableHandler.AdvancedFilterFieldApi);
    //this.SfieldName= this.loperandValue != undefined ? this.FieldsOption[0].apiname : undefined;
    //getFieldOptions(lwcFlexTableHandler,this.SfieldName, this.fieldApiName);
    resetcolumnNanme(lwcFlexTableHandler);
    lwcFlexTableHandler.OpratorOption=[];
    getOperatorOptions(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi]);
    updateOnColumnChange(lwcFlexTableHandler);
    // lwcFlexTableHandler.AdvanceFilterOperatorLabel = lwcFlexTableHandler.OpratorOption != undefined ? lwcFlexTableHandler.OpratorOption[0].value : '';
    lwcFlexTableHandler.Advancedfiltervalue='';
    //lwcFlexTableHandler.inputvalue=true;
}

function getAdvancedFilterResult(lwcFlexTableHandler){

    // this.inputvalue=true;
    // this.ClearValue = lwcFlexTableHandler.Advancedfilterlist.length > 0 ? false : true;
    
        //let datafiltobeSearched = this.quicksearch === true ? this.AdvancedfilterData : this.flattenedData;
        let filteredData=filterdata(lwcFlexTableHandler,lwcFlexTableHandler.flattenedData,lwcFlexTableHandler.Advancedfilterlist);
        if(filteredData.length > 0){
              //lwcFlexTableHandler.data = filteredData;
              lwcFlexTableHandler.quicksearchdata = filteredData;
            // this.QuicksearchData = filteredData;
             lwcFlexTableHandler.noRecords = false;
             lwcFlexTableHandler.TotalCount=lwcFlexTableHandler.quicksearchdata.length;
            lwcFlexTableHandler.ShowRecordMessage = true;
            lwcFlexTableHandler.Totoalrecords = 'Total Records: ' + lwcFlexTableHandler.TotalCount;
            
             if(filteredData.length <= lwcFlexTableHandler.pageSize){
                lwcFlexTableHandler.EnablePageSize = false;
                 lwcFlexTableHandler.EnablePagination =false;
             }else{
             lwcFlexTableHandler.EnablePageSize = lwcFlexTableHandler.flexTableConfig.EnablePageSize === true ? lwcFlexTableHandler.PageSizeValue > lwcFlexTableHandler.TotalCount  ?  false : true : false;
               lwcFlexTableHandler.EnablePagination =true;
            }
            
            handlePagination(lwcFlexTableHandler);
            lwcFlexTableHandler.End = lwcFlexTableHandler.quicksearchdata.length < lwcFlexTableHandler.pageSize ? lwcFlexTableHandler.quicksearchdata.length : lwcFlexTableHandler.pageSize;

            // if(filteredData.length < 9){
            //     this.datatableHeight='height: auto;';
            //  }else{
            //     if(this.PageSizeValue < 10){
            //         this.datatableHeight='height: auto;';
            //     }else{
                
            //         this.datatableHeight='height: 411.5px;';
            //     }
            // }
            
        }else{
           lwcFlexTableHandler.noRecords = true;
           lwcFlexTableHandler.data=undefined;
           lwcFlexTableHandler.TotalCount=0;
           lwcFlexTableHandler.EnablePageSize = false;
           lwcFlexTableHandler.EnablePagination =false;
           lwcFlexTableHandler.enableTotalRecords = false;
           lwcFlexTableHandler.End = 0;
           lwcFlexTableHandler.Start= lwcFlexTableHandler.currentPage;
           lwcFlexTableHandler.datatableHeight='height: auto;';
           lwcFlexTableHandler.QuicksearchData = undefined;
           lwcFlexTableHandler.Totoalrecords = '';
           lwcFlexTableHandler.ShowRecordMessage = false;
           lwcFlexTableHandler.isLoading = false;
           lwcFlexTableHandler.dynamicClass ='height:auto;'
        }
    
}

export function filterdata(lwcFlexTableHandler,flattendata,filter){

  

    let filtereddata=flattendata;
    let filterData=[];

    if(filter != undefined){

        filter.forEach(element =>{

            if(element.FieldName != null && element.Operator != null && element.Filtervalue != null){
                
                filterData= filtereddata != undefined ? filtereddata :undefined;
                filtereddata=[];
                if(filterData != undefined && filterData != ''){
                    
                    filterData.forEach(row =>{
                        switch(element.Operator){

                            case '=':
                                    let fieldname=element.FieldName.toLowerCase()
									if(row[fieldname] === undefined){
                                    
                                        if(element.Filtervalue === ''){
                                            filtereddata.push(row);
                                            
                                        }else{
                                            break;
                                        }
                                    
                                    }
                                    if(lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi].Type === 'DATETIME'){
                                    const myDate =new Date(element.Filtervalue);
                                    const myDate1 =new Date(row[fieldname]);
                                    let decMinutes;
                                    decMinutes = ((myDate1.getTime())/1000/60) - ((myDate.getTime())/1000/60);
                                    Math.floor(decMinutes);
                                    if(Math.floor(decMinutes) == 0){
                                        filtereddata.push(row);
                                    }
                                }else{
                                    if(row[fieldname] == element.Filtervalue){
                                        filtereddata.push(row);
                                    }
                                }
                                    break;
                            case '!=':
                                    let fieldname1=element.FieldName.toLowerCase()
                                    if(row[fieldname1] != element.Filtervalue){

                                        if(row[fieldname1] === undefined){
                                    
                                            if(element.Filtervalue === ''){
                                                break;
                                                
                                            }else{
                                                filtereddata.push(row);
                                            }
                                        
                                        }else{
                                        
                                            filtereddata.push(row);
                                        }
                                    }
                                    break;
                            case '>':
                                    let fieldname2=element.FieldName.toLowerCase()
                                    if(row[fieldname2] > element.Filtervalue){

                                        filtereddata.push(row);
                                    }
                                    break;
                            case '<':
                                    let fieldname3=element.FieldName.toLowerCase()
                                    if(row[fieldname3] < element.Filtervalue || row[fieldname3] === undefined){

                                        filtereddata.push(row);
                                    }
                                    break;
                            case '>=':
                                    let fieldname4=element.FieldName.toLowerCase()
                                    if(row[fieldname4] >= element.Filtervalue ){

                                        filtereddata.push(row);
                                    }
                                    break;
                            case '<=':
                                    let fieldname5=element.FieldName.toLowerCase()
                                    if(row[fieldname5] <= element.Filtervalue || row[fieldname5] === undefined){

                                        filtereddata.push(row);
                                    }
                                    break;
                            case 'Contains':
                                   
                                    let fieldname6=element.FieldName.toLowerCase()
                                   
                                    if(row[fieldname6] === undefined){
                                        break;
                                    }
                                    if(row[fieldname6].toUpperCase().includes(element.Filtervalue.toUpperCase()) ){
                                        
                                        filtereddata.push(row);
                                    }
                                  
                                    break;
                            case 'DoesNotContain':
                                   
                                    let fieldname7=element.FieldName.toLowerCase()
                                   
                                    if(row[fieldname7] === undefined){
                                        filtereddata.push(row);
                                        break;
                                    }
                                    if(!(row[fieldname7].toUpperCase().includes(element.Filtervalue.toUpperCase()))){

                                        filtereddata.push(row);
                                    }
                                    break;
                            case 'StartsWith':
                                  
                                    let fieldname8=element.FieldName.toLowerCase()
                                   if(row[fieldname8] === undefined){
                                        break;
                                    }
                                    if((row[fieldname8].toUpperCase().startsWith(element.Filtervalue.toUpperCase()))){

                                        filtereddata.push(row);
                                    }
                                   
                                    break;
                            case 'EndsWith':
                                   
                                    let fieldname9=element.FieldName.toLowerCase()
                                  
                                    if(row[fieldname9] === undefined){
                                        break;
                                    }
                                    if((row[fieldname9].toUpperCase().endsWith(element.Filtervalue.toUpperCase()))){

                                        filtereddata.push(row);
                                    }
                                    break;
                            case 'Includes' :
                                  
                                    let fieldname10=element.FieldName.toLowerCase()
                                  
                                    let value =element.Filtervalue;
                                    let valueList = String(value).split(',');
                                  
                                    if(row[fieldname10] === undefined || row[fieldname10]=== '' || row[fieldname10] === null){
                                        break;
                                    }
                                    for(let i=0;i< element.Filtervalue.length; i++){
                                      
                                        //if(row[fieldname10] != undefined&& row[fieldname10]=== '' && row[fieldname10] === null){
                                            if(row[fieldname10].includes(element.Filtervalue[i]) ){
                                                
                                                filtereddata.push(row);
                                            }
                                        //}
                                    }
                                    
                                    
                                    break;
                            
                        }
                    
                    });
                }
            }
        });
        
    }

    return filtereddata;
}

function resetcolumnNanme(lwcFlexTableHandler){

    lwcFlexTableHandler.template.querySelectorAll('c-outer-picklist').forEach(element => {
        if(element.name === 'columnnamePicklist'){
          
            element.setdata(lwcFlexTableHandler.AdvancedFilterFieldApi,null,lwcFlexTableHandler.FieldsOption);
        }
        
   });
}

export function handleRemoveFilter(lwcFlexTableHandler,filterId){

    lwcFlexTableHandler.Advancedfilterlist.splice(filterId, 1);
    getAdvancedFilterResult(lwcFlexTableHandler);
}

export function handleClearFilter(lwcFlexTableHandler){
    lwcFlexTableHandler.AdvancedFilterFieldApi =  lwcFlexTableHandler.FieldsOption.length > 0 ? lwcFlexTableHandler.FieldsOption[0].value : '';
    resetcolumnNanme(lwcFlexTableHandler);
    lwcFlexTableHandler.OpratorOption=[];
    getOperatorOptions(lwcFlexTableHandler,lwcFlexTableHandler.FieldMetaData[lwcFlexTableHandler.AdvancedFilterFieldApi]);
    updateOnColumnChange(lwcFlexTableHandler);
    lwcFlexTableHandler.Advancedfilterlist=[];
    lwcFlexTableHandler.isApply = true;
    lwcFlexTableHandler.isClear = false;
    getAdvancedFilterResult(lwcFlexTableHandler);
    lwcFlexTableHandler.Advancedfiltervalue = '';
    lwcFlexTableHandler.filtervalue = '';
    lwcFlexTableHandler.AdvanceFilterOperatorValue ='';
    let checkboxIpt =lwcFlexTableHandler.template.querySelector('[data-id="checkboxinput"]');
    if(checkboxIpt != null && checkboxIpt != undefined && checkboxIpt.type=='checkbox' && checkboxIpt.checked == true ){
            checkboxIpt.checked = false;
    }
}
export function checkRefreshBehavior(lwcFlexTableHandler,action){
    if(lwcFlexTableHandler.flexGridEnhanced_currentPageURL != undefined && lwcFlexTableHandler.flexGridEnhanced_currentPageURL.indexOf('#/!') != -1){
        lwcFlexTableHandler.flexGridEnhanced_currentPageURL = lwcFlexTableHandler.flexGridEnhanced_currentPageURL.replace('#/!','');
    }
    let ifrefesh = true;
    //let winURL = decodeURIComponent($scope.currentPageURL);
    let winURL = lwcFlexTableHandler.flexGridEnhanced_currentPageURL;
  
    let message = {message: lwcFlexTableHandler.message};
      switch(action.RefreshBehaviour){
        case 'Refresh the entire page':
            if(lwcFlexTableHandler.isModal === true){
                const fromTableToModal =new CustomEvent('modal_refresh', {
                    detail: {
                        refreshBehaviour : action.RefreshBehaviour,
                        
                        
                    },
                    bubbles: true,
                        composed: true
                
                });
                lwcFlexTableHandler.dispatchEvent(fromTableToModal);
            }else{
            
                window.open(winURL,'_self');
            }
            
            //publish(lwcFlexTableHandler.messageContext, flexLayoutMessageChannel, message);
            break;
        case 'Refresh parent page':
            //let message = {message: lwcFlexTableHandler.message};
            refreshLayout(lwcFlexTableHandler)
            break;
        case 'Refresh all flextables':
            setTimeout(() => {
            refreshAllFlexTables(lwcFlexTableHandler) // JavaScript finction (NOT a ANGULAR function) present in FlexGridEnhanced.Component
            }, lwcFlexTableHandler.messageTimeOut);//adding timer to show success msg
            break;
        case 'Refresh the grid':
            //$scope.tableCommunicator.refreshGrid();
            let sessionStrData = getSessionData(lwcFlexTableHandler);
            lwcFlexTableHandler.initSessionData= sessionStrData != null &&  sessionStrData != undefined ? JSON.parse(sessionStrData) : {};
            lwcFlexTableHandler.firstOnly = true;
            lwcFlexTableHandler.isSave = false;
            lwcFlexTableHandler.editRecordCount = 0;
            lwcFlexTableHandler.newSaveRecordCount=0;
            if(lwcFlexTableHandler.gridLevel > 0){
                let data={};
                            data['isError'] = false;
                            data['isSave'] = false;
                            const showmessagesatparent =new CustomEvent('showmessage', {
                                detail: data,
                                bubbles: true,
                                composed: true,
                            });
                            lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
            }

            if(lwcFlexTableHandler.isModal === true){
                const fromTableToModal =new CustomEvent('modal_refresh', {
                    detail: {
                        refreshBehaviour : action.RefreshBehaviour,
                        
                        
                    },
                    bubbles: true,
                        composed: true
                
                });
                lwcFlexTableHandler.dispatchEvent(fromTableToModal);
            }else{
            
                getdata(lwcFlexTableHandler,ifrefesh);
            }
              
            break;
        case 'Close modal and refresh grid':
                //$scope.tableCommunicator.refreshGrid();
                //refreshLayout(lwcFlexTableHandler)
                 // getdata(lwcFlexTableHandler,ifrefesh);
                    if(lwcFlexTableHandler.isModal === true){
                    const fromModalTable =new CustomEvent('modal_close', {
                        detail: {
                            refreshBehaviour : action.RefreshBehaviour,
                            
                            
                        },
                        bubbles: true,
                            composed: true
                    
                    });
                    lwcFlexTableHandler.dispatchEvent(fromModalTable);
                }else{
                
                    getdata(lwcFlexTableHandler,true);
                }

        break;
        case 'Close modal and refresh all flextables':
            //$scope.tableCommunicator.refreshGrid();
            //refreshLayout(lwcFlexTableHandler)
             // getdata(lwcFlexTableHandler,ifrefesh);

             if(lwcFlexTableHandler.isModal === true){
                const fromModalTable1 =new CustomEvent('modal_close', {
                    detail: {
                        refreshBehaviour : action.RefreshBehaviour,
                        
                        
                    },
                    bubbles: true,
                        composed: true
                
                });
                lwcFlexTableHandler.dispatchEvent(fromModalTable1);
            }else{
            
                refreshAllFlexTables(lwcFlexTableHandler)
            }

    break;
     default : 
     let sessionStr = getSessionData(lwcFlexTableHandler);
     lwcFlexTableHandler.initSessionData= sessionStr != null &&  sessionStr != undefined ? JSON.parse(sessionStr) : {};
     lwcFlexTableHandler.isSave = false;
     lwcFlexTableHandler.editRecordCount = 0;
     lwcFlexTableHandler.newSaveRecordCount=0;
     if(lwcFlexTableHandler.gridLevel > 0){
         let data={};
                     data['isError'] = false;
                     data['isSave'] = false;
                     const showmessagesatparent =new CustomEvent('showmessage', {
                         detail: data,
                         bubbles: true,
                         composed: true,
                     });
                     lwcFlexTableHandler.dispatchEvent(showmessagesatparent);
     }
           getdata(lwcFlexTableHandler,ifrefesh);
    }
    
    
}

export function refreshAllFlexTables(lwcFlexTableHandler){
    const payload = {
        data: {
            refreshAllFlexTables : true,
            pageLayoutId : ''                }
    };
  
    publish(lwcFlexTableHandler.messageContext, messageChannel, payload);
}

export function refreshLayout(lwcFlexTableHandler){
    const payload = {
        data: {
            refreshEntirePage : true,
            pageLayoutId : ''                }
    };
   
    publish(lwcFlexTableHandler.messageContext, messageChannel, payload);
}


export function handleSortDirection(lwcFlexTableHandler,fieldName,sortDirection){
    let direction;
    let isSorted ;
    let sortUp;
    let sortDown;
    Object.values(lwcFlexTableHandler.columns).forEach(record => {
       

        if(fieldName.toLowerCase() == record.fieldName.toLowerCase()){ ///first asc sorting
          
           
           
         
                record.isSorted  = true;
                record.sortUp = sortDirection.toLowerCase() =='asc'? true : false;
                record.sortDown =sortDirection.toLowerCase() =='desc'? true : false;
                direction = sortDirection.toLowerCase();
       
        
            sortUp =  record.sortUp;
            isSorted =  record.isSorted;
            sortDown = record.sortDown;
            
            if(fieldName.toLowerCase() == record.fieldName.toLowerCase() && isSorted== true  && fieldName!= 'sr__no' && sortUp == true ){
             
                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.contains('showArrow') == false ?lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('showArrow') :'';
                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.contains('hideArrow') == true ? lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('hideArrow') : '';

                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.remove('showArrow');
                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.add('hideArrow');

             }else if(isSorted== true  && fieldName!= 'sr__no' && sortDown == true && record.fieldName.toLowerCase() == fieldName.toLowerCase()){
                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.add('showArrow');
                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.remove('hideArrow');

                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('showArrow');
                lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('hideArrow');


             }

         } 
         if(fieldName.toLowerCase() !== record.fieldName.toLowerCase()){
            record.isSorted  = false;
            record.sortUp = false;
            record.sortDown =false;
            lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.add('hideArrow');
            lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[1].classList.remove('showArrow');

            lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.add('hideArrow');
            lwcFlexTableHandler.template.querySelectorAll('[data-id="' + record.fieldName + '"]')[2].classList.remove('showArrow');


         } 
     });

}
export function handleMenuActions(lwcFlexTableHandler,actionName){
    let actionId;
    actionId = actionName.value.Id;
   
        if(lwcFlexTableHandler.FlexTableActionMap.Top != undefined){
            for( let index =0; index < lwcFlexTableHandler.FlexTableActionMap.Top.length; index++){
                if(lwcFlexTableHandler.SObjectContentNote && lwcFlexTableHandler.FlexTableActionMap.Top[index].StandardAction == 'View'){
                    
                    lwcFlexTableHandler.isContentNoteView = true;
                    lwcFlexTableHandler.isNewOpen = true;
                   
                }else{
                    lwcFlexTableHandler.isContentNoteView = false;
                    lwcFlexTableHandler.noteContent = '';
                }
                if(actionId != undefined && lwcFlexTableHandler.FlexTableActionMap.Top[index].Id === actionId){
                    lwcFlexTableHandler.action=lwcFlexTableHandler.FlexTableActionMap.Top[index];
                // }
                    }
                }
            }

            if(lwcFlexTableHandler.action != undefined && lwcFlexTableHandler.action.isEditAll != undefined && lwcFlexTableHandler.action.isEditAll == true){
            
                updateEditAllAction(lwcFlexTableHandler);
            }

           
            if(lwcFlexTableHandler.action != undefined){
            // openUrl(lwcFlexTableHandler,action);

            checkForConfirmationMsg(lwcFlexTableHandler,lwcFlexTableHandler.action);
            }
}
function parseExceptionMessage(errorMessage){
    let innerMsg = '';
    if(errorMessage != undefined && errorMessage.indexOf('GNT.CustomExceptions.') !=-1 && errorMessage.indexOf('Class.GNT.') !=-1){
        //innerMsg = errorMessage.match(/(?<=GNT.CustomExceptions.\s*).*?(?=\s*Class.GNT.)/g);               
        var firstvariable = "GNT.CustomExceptions.";
        var secondvariable = "Class.GNT."; 
        errorMessage = errorMessage.replace(/(\r\n|\n|\r)/gm,"");                
        errorMessage = errorMessage.match(new RegExp(firstvariable + "(.*)" + secondvariable)); 
        innerMsg = errorMessage[1];
    }else{
        let parts;
        let subParts;
        innerMsg = errorMessage;
        parts = errorMessage.split(':', 2);
        if( parts[0] != undefined && parts.length > 1 ){
             innerMsg = parts[0] + ' : ';
            
            if( parts[1] != undefined && parts[1].indexOf(',') == -1){
                innerMsg += parts[1];
            }                        
        }               
        if(parts[1] != undefined && parts[1] != '' && parts[1].indexOf(',')!= -1){
            innerMsg = parts[1];
            subParts = parts[1].split(',',2);
             if(subParts[1] != undefined && subParts[1] != '' ){
                innerMsg = subParts[1];
                let partString = subParts[1]; // partString - This is trigger error In Progress.: []
                let partStringIndex = partString.indexOf(': [');
                let errorMessageStr;
                if(partStringIndex > 0){
                    errorMessageStr = partString.substring(0,partString.indexOf(': ['));
                }else{
                    errorMessageStr  = partString;
                }
                    // errorMessage -  This is trigger error In Progress.
                if(errorMessageStr != ""){
                    innerMsg = errorMessageStr.trim();
                    if(innerMsg.indexOf(':') != -1){
                        innerMsg = parseExceptionMessage(innerMsg); // called recursive funtion to parse stack trace of error messages for finding correct error message
                    }
                }
            }                    
        }                         
    }
    return innerMsg;
    }