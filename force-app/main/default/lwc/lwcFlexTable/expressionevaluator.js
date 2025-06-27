export function expressionEvaluatorme(lwcFlexTableHandler,expression, isColumnJSON, isParentRecord){
   
    var findCondition = {};
    var conditionsArray = [];
   
    if (expression.Conditions.length > 0) {
 
        for (let i = 0; i < expression.Conditions.length; i++) {
 
            let fieldCondition = conditionEvaluator(lwcFlexTableHandler,expression.Conditions[i], isColumnJSON, isParentRecord);
            conditionsArray.push(fieldCondition);
           
 
            if(expression.Conditions[i].LOperand.Type === 'Field'){ 
                if (expression.Conditions[i].LOperand != {}) {
                    if (fieldCondition != undefined && !isEmpty1(lwcFlexTableHandler,fieldCondition)) {
                        if (!isColumnJSON && !isParentRecord && lwcFlexTableHandler.expressionFieldsArray.indexOf(expression.Conditions[i].LOperand.Value) === -1) {
                            lwcFlexTableHandler.expressionFieldsArray.push(expression.Conditions[i].LOperand.Value);
                        }
                        else if ((isColumnJSON || isParentRecord) && lwcFlexTableHandler.expressionParentFieldsArray.indexOf(expression.Conditions[i].LOperand.Value) === -1) {
                            lwcFlexTableHandler.expressionParentFieldsArray.push(expression.Conditions[i].LOperand.Value);
                        }
                    }
                }
                if (expression.Conditions[i].ROperand != {} && expression.Conditions[i].ROperand.Type === 'Field') {
                    if (fieldCondition != undefined && ! isEmpty(lwcFlexTableHandler,fieldCondition)) {
                        if (!isColumnJSON && !isParentRecord && lwcFlexTableHandler.expressionFieldsArray.indexOf(fieldCondition) === -1) {
                            lwcFlexTableHandler.expressionFieldsArray.push(fieldCondition);
                        }
                        else if ((isColumnJSON || isParentRecord) && lwcFlexTableHandler.expressionParentFieldsArray.indexOf(fieldCondition) === -1) {
                            lwcFlexTableHandler.expressionParentFieldsArray.push(fieldCondition);
                        }
                    }
                } 
            }
            if(expression.Conditions[i].LOperand.Type === 'User'){
                if (!isEmpty1(lwcFlexTableHandler,expression.Conditions[i].LOperand)){
                    if (fieldCondition != undefined && (fieldCondition === false || !isEmpty1(lwcFlexTableHandler,fieldCondition))) {
                        if (lwcFlexTableHandler.expressionUserFieldsArray.indexOf(expression.Conditions[i].LOperand.Value) === -1) {
                            lwcFlexTableHandler.expressionUserFieldsArray.push(expression.Conditions[i].LOperand.Value);
                        }
                    }
                }                   
                if (!(isEmpty1(lwcFlexTableHandler,expression.Conditions[i].ROperand)) && expression.Conditions[i].ROperand.Type === 'Field') {
                    if (fieldCondition != undefined && (fieldCondition === false || !isEmpty1(lwcFlexTableHandler,fieldCondition))) {
                        if (lwcFlexTableHandler.expressionUserFieldsArray.indexOf(expression.Conditions[i].ROperand.Value) === -1) {
                            lwcFlexTableHandler.expressionUserFieldsArray.push(expression.Conditions[i].ROperand.Value);
                        }
                    }
                }
            } 
            if(expression.Conditions[i].ROperand.Type === 'User'){
                if (!(isEmpty1(lwcFlexTableHandler,expression.Conditions[i].ROperand))) {
                    if (fieldCondition != undefined && (fieldCondition === false || !isEmpty1(lwcFlexTableHandler,fieldCondition))) {
                        if (lwcFlexTableHandler.expressionUserFieldsArray.indexOf(expression.Conditions[i].ROperand.Value) === -1) {
                            lwcFlexTableHandler.expressionUserFieldsArray.push(expression.Conditions[i].ROperand.Value);
                        }
                    }
                } 
            }
        }
    }
    if (expression.Groups.length > 0) {
        for (let i = 0; i < expression.Groups.length; i++) {
            let groupFindCondition = expressionEvaluatorme(lwcFlexTableHandler,expression.Groups[i], isColumnJSON, isParentRecord);
        
            if (groupFindCondition != undefined && !isEmpty(lwcFlexTableHandler,groupFindCondition)) {
                /*if (!isColumnJSON && !isParentRecord && lwcFlexTableHandler.expressionFieldsArray.indexOf(groupFindCondition) != -1) {
                    lwcFlexTableHandler.expressionFieldsArray.push(groupFindCondition);
                }
                else if ((isColumnJSON || isParentRecord) && lwcFlexTableHandler.expressionParentFieldsArray.indexOf(groupFindCondition) != -1) {
                    lwcFlexTableHandler.expressionParentFieldsArray.push(groupFindCondition);
                }*/
                conditionsArray.push(groupFindCondition);
            }
        }
    }
 
    if (expression.LogicalOperator != '') {
        if (expression.LogicalOperator === 'AND') {
            findCondition['$and'] = conditionsArray;
        }
        if (expression.LogicalOperator === 'OR') {
            findCondition['$or'] = conditionsArray;
        }
    }
    
    return findCondition;
 }
 
 
 export function conditionEvaluator(lwcFlexTableHandler,condition, isColumnJSON, isParentRecord){
 
    var fieldCondition = {};
    var operand = {};
 
  
    if (condition && isEmpty1(lwcFlexTableHandler,condition.LOperand)) {
 
      
        if(condition.LOperand.Type === "User" && condition.ROperand.Type === "Field"){
            let lOperand = condition.LOperand;
            condition.LOperand = condition.ROperand;
            condition.ROperand = lOperand;
        } 
        let rValue
        switch (condition.LOperand.Type) {
            case 'Field':
                  
                isColumnJSON = isColumnJSON ===  undefined ? isColumnJSON = false : isColumnJSON;
              
                if(!isColumnJSON){
                    if (!isEmpty(lwcFlexTableHandler,condition.ROperand)) {
                        switch (condition.ROperand.Type) {
                            case 'Freetext':
 
                                rValue = condition.ROperand.Value;
                                if(rValue === 'null' || rValue === 'Null' || rValue === 'NULL' || rValue === null ){
                                    rValue = undefined;
                                }
                                if(condition.LOperand.Value != undefined && lwcFlexTableHandler.FieldMetaData[condition.LOperand.Value] != undefined && lwcFlexTableHandler.FieldMetaData[condition.LOperand.Value].Type != undefined){
                                    let localOffset = new Date().getTimezoneOffset() * 60000;
                                    let dataType = lwcFlexTableHandler.FieldMetaData[condition.LOperand.Value].Type;
                                    if(lwcFlexTableHandler.FieldMetaData[condition.LOperand.Value].Type === 'REFERENCE'){
                                        dataType = lwcFlexTableHandler.FieldMetaData[condition.LOperand.Value].ReferenceFieldInfo.Type ;    
                                    }
                                    switch (dataType) {                                                    
                                        case 'INTEGER':
                                        case 'DOUBLE':
                                        case 'PERCENT':
                                        case 'CURRENCY':
                                            if(typeof rValue === 'string' && rValue.indexOf(';')!= -1){
                                                rValue = rValue.split(';');
                                                let rValueArray = [];
                                                for(var key in rValue){
                                                    rValueArray.push(parseFloat(value));
                                                }
                                                rValue = rValueArray;
                                            }
                                            else{
                                                rValue = parseFloat(rValue);
                                            }
                                                
                                        break;
                                        case 'BOOLEAN':
                                            rValue = (typeof(rValue) != typeof(true)) ? JSON.parse(rValue.toLowerCase()) : JSON.parse(rValue);
                                        break;
                                        case 'DATE':
                                            rValue = new Date(rValue).getTime() - localOffset
                                        break;
                                        case 'DATETIME':
                                            rValue = new Date(rValue).getTime() - localOffset - timeOffset;
                                        break;
                                    }
                                }
 
                                if (condition.Operator.toLowerCase() === 'StartsWith'.toLowerCase()) {
                                    operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = ['^(' + rValue + ')', 'i'];
                                }
                                else if (condition.Operator.toLowerCase() === 'EndsWith'.toLowerCase()) {
                                        operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = ['(' + rValue + ')$', 'i'];
                                    }
                                else if(condition.Operator.toLowerCase() === 'in' || condition.Operator.toLowerCase() === 'not in'){
                                    if(typeof rValue != 'number'  && rValue.indexOf(';')!= -1){
                                        rValue = rValue.split(';');
                                    }
                                      //  rValue = condition.ROperand.Value;
                                      if(typeof rValue != 'object'){
                                        let temprval = rValue;
                                        rValue =[];
                                        rValue.push(temprval);                                                    
                                      }
                                     
                                      operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = rValue;   
                                }
                                else{
                                    operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = rValue;
                                }
                                fieldCondition[condition.LOperand.Value] = operand;
                                break;
 
                            case 'Field':
                        // changes for lwc flex table     
                                operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = condition.ROperand.Value;
                                fieldCondition[condition.LOperand.Value] = operand;
                            break;
                            case 'User':
                            
                                operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = lwcFlexTableHandler.currentUserInfo.UserInfo[condition.ROperand.Value];
                                fieldCondition[condition.LOperand.Value] = operand;
                            
                            break;
                            case 'regex':
                            
                                operand[getOperator(lwcFlexTableHandler,condition.Operator, true)] = [condition.ROperand.Value, 'i'];
                                fieldCondition[condition.LOperand.Value] = operand;
                            
                            break;
                    }
                }
            
            }
            if(isParentRecord){
                let expOperator = getOperator(lwcFlexTableHandler,condition.Operator, false);
                
                if(expOperator === undefined){
                    return undefined;
                }
               
                let lOperand =lwcFlexTableHandler.ParentRecord[condition.LOperand.Value.toLowerCase()];
                //let lOperand = scope.tableCommunicator.ParentRecord[condition.LOperand.Value];
                let rOperand =  rValue != undefined ?  rValue : condition.ROperand.Value;
                if(condition.ROperand.Type === "field"){
                    rOperand =lwcFlexTableHandler.ParentRecord[condition.ROperand.Value.toLowerCase()];
                }
                if(condition.ROperand.Type === "User"){
                    rOperand = lwcFlexTableHandler.currentUserInfo.UserInfo[condition.ROperand.Value];
                }
 
                // This handle null value for picklist field
                if(lOperand === undefined){
                    if(expOperator === 'in') {
                        fieldCondition = false;
                    }else if(expOperator === 'nin') {
                        fieldCondition = true;
                    } 
 
                }
                if(lOperand != undefined && isNaN(lOperand) || (lOperand instanceof Array) || (typeof lOperand === 'string' || lOperand instanceof String)){
                    let indexOfResult = rOperand.indexOf(lOperand) != -1 ? true : false;
                    if(expOperator === 'nin') {
                        fieldCondition = !indexOfResult;
                    } else if(expOperator === 'in') {
                        fieldCondition = indexOfResult;
                    } 
                } /* else */ {
                    // let lOperand = scope.tableCommunicator.ParentRecord[condition.LOperand.Value];
                    // let rOperand = condition.ROperand.Value;
                    // let evaluationExpression = 'lOperand  expOperator  rOperand';
                    // fieldCondition = scope.$eval(evaluationExpression);
                    //
 
                    if(rOperand != undefined && isNaN(rOperand) && !(lOperand instanceof Array) && !(rOperand instanceof Array)  && (rOperand.toLowerCase() === 'true' || rOperand.toLowerCase() === 'false')){
                        rOperand = JSON.parse(rOperand);
                    }
                    if(rOperand === 'null' || rOperand === 'Null' || rOperand === 'NULL' || rOperand === null){
                        rOperand = undefined;
                    }
                    if(expOperator != 'in' && expOperator != 'nin'){
                        fieldCondition = arithComparer(lwcFlexTableHandler,lOperand, expOperator, rOperand); 
                    }
                }                         
            }
        
        break;
        case 'Profile':
                
                    fieldCondition = false;
                    let UserProfiles = condition.ROperand.Values.map(function (x) { return x.toLowerCase(); });
                    let evalResult = UserProfiles.indexOf(lwcFlexTableHandler.currentUserInfo.UserProfile.toLowerCase()) != -1 ? true : false;
                    fieldCondition = getResult(lwcFlexTableHandler,evalResult,getOperator(lwcFlexTableHandler,condition.Operator,false));
                    break;
        case 'Queue':
                
                    fieldCondition = false;
                    let QueueList = condition.ROperand.Values.map(function (x) { return x.toLowerCase(); });
                    let UserQueueList = lwcFlexTableHandler.currentUserInfo.Queue.map(function (x) { return x.toLowerCase(); });
                    let evalResult4 = false;
                    if(QueueList.length > 0){
                         for(let i =0; i < QueueList.length; i++){
                            evalResult4 = UserQueueList.indexOf(QueueList[i]) != -1 ? true : false;
                            if(evalResult4 === true){
                               break;
                            }
                        }
                    }
                    fieldCondition = getResult(lwcFlexTableHandler,evalResult4,getOperator(lwcFlexTableHandler,condition.Operator,false));
                    break;
        case 'UserType':
                
                    fieldCondition = false;
                    let UserTypes = condition.ROperand.Values.map(function (x) { return x.toLowerCase(); });
                    let evalResult1 = UserTypes.indexOf(lwcFlexTableHandler.currentUserInfo.UserType.toLowerCase()) != -1 ? true : false;
                    fieldCondition = getResult(lwcFlexTableHandler,evalResult1,getOperator(lwcFlexTableHandler,condition.Operator,false));
                    break;
        case 'UserApp':
                    fieldCondition = false;
                    let UserAppNames = condition.ROperand.Values.map(function (x) { return x.toLowerCase(); });
                    let evalResult2 = UserAppNames.indexOf(lwcFlexTableHandler.currentUserInfo.UserAppName.toLowerCase()) != -1 ? true : false;
                    fieldCondition = getResult(lwcFlexTableHandler,evalResult2,getOperator(lwcFlexTableHandler,condition.Operator,false));
                    break;
        case 'Context':
                
                    fieldCondition = false;
                    let modes = condition.ROperand.Values.map(function (x) { return x.toLowerCase(); });
                    let evalResult3 = modes.indexOf(lwcFlexTableHandler.mode.toLowerCase()) != -1 ? true : false;
                    fieldCondition = getResult(lwcFlexTableHandler,evalResult3,getOperator(lwcFlexTableHandler,condition.Operator,false));
                    break;
        case 'User':
                
                    fieldCondition = false;
                    //scope.tableCommunicator.expressionUserFieldsArray.push(condition.LOperand.Value);
                    let lOperand = lwcFlexTableHandler.currentUserInfo.UserInfo[condition.LOperand.Value];
                    lOperand = lwcFlexTableHandler.currentUserInfo.UserInfo[condition.LOperand.Value];
                    let expOperator = getOperator(lwcFlexTableHandler,condition.Operator, false);
                    let rOperand = condition.ROperand.Value;
                    let inNotin = ['in', 'not in'];
                    if(inNotin.indexOf(expOperator) != -1){
                        let userValues = condition.ROperand.Values.map(function(x) { return x.toLowerCase(); });
                        let evalResult4 = userValues.indexOf(lwcFlexTableHandler.mode.toLowerCase()) != -1 ? true : false;
                        fieldCondition = getResult(lwcFlexTableHandler,evalResult4,getOperator(lwcFlexTableHandler,condition.Operator,false));
                    }
                    else{
                        fieldCondition = arithComparer(lwcFlexTableHandler,lOperand, expOperator, rOperand);
                    }
                    break;        
                   
    }
 
 }
    if(!isParentRecord){
        if(fieldCondition === true){
            fieldCondition = {};
            fieldCondition= { Id : {$ne : null}}    
        }
        if(fieldCondition === false){
            fieldCondition = {};
            fieldCondition= { Id : {$eq : null}}    
        }    
    }
    return fieldCondition;
 }
 
 
 export function getOperator(lwcFlexTableHandler,operator, isLokiOperator){
 
    switch (operator.toLowerCase()) {
        case "=":
            return isLokiOperator ?  '$eq' : '===';
            break;
        case "!=":
            return isLokiOperator ?  '$ne' : '!=';
            break;
        case "<":
            return isLokiOperator ?  '$lt' : '<';
            break;
        case "<=":
            return isLokiOperator ?  '$lte' : '<=';
            break;
        case ">=":
            return isLokiOperator ?  '$gte' : '>=';
            break;
        case ">":
            return isLokiOperator ?  '$gt' : '>';
            break;
        case "in":
            return isLokiOperator ?  '$in' : 'in';
            break;
        case "not in":
            return isLokiOperator ?  '$nin' : 'nin';
            break;
        case "regex":
        case "startswith":
        case "endswith":
            return isLokiOperator ?  '$regex' : undefined;
            break;
        case "contains":
        case "includes":
            return isLokiOperator ?  '$contains' : 'in';
            break;
        case "doesnotcontain":
        case "excludes":
            return isLokiOperator ?  '$containsNone' : 'nin';
            break;
    }
 }
 
 
 export function arithComparer(lwcFlexTableHandler,lOperand, expOperator, rOperand){
    
    if(rOperand === 'false'){
        rOperand = false;
    }if(rOperand === 'true'){
        rOperand = true;
    }
    let fieldCondition;
    switch (expOperator.toLowerCase()) {
        case "===":
            fieldCondition = (lOperand == rOperand) ? true : false;
            break;
        case "!=":
            fieldCondition = (lOperand != rOperand) ? true : false;
            break;
        case "<":
            fieldCondition = (lOperand < rOperand) ? true : false;
            break;
        case "<=":
            fieldCondition = (lOperand <= rOperand) ? true : false;
            break;
        case ">=":
            fieldCondition = (lOperand >= rOperand) ? true : false;
            break;
        case ">":
            fieldCondition = (lOperand > rOperand) ? true : false;
            break;
    }
 
    return fieldCondition;
 
 }
 
 export function isEmpty1(lwcFlexTableHandler,obj) {
   
    //return Object.keys(obj).length === 0;
    if(obj.constructor === Object){
        return true;
    }
    return false;
 }
 
 export function isEmpty(lwcFlexTableHandler,obj) {
   
    //return Object.keys(obj).length === 0;
    let keyset=Object.keys(obj);
   
    if(keyset.length === 0 && obj.constructor === Object){
        return true;
    }
    return false;
 }
 
 export function getResult(lwcFlexTableHandler,result,operator){
  
    switch(operator){
        case 'nin':
        result = !result;
    }
    return result;
 }
 
 
 export function generateRowLevelHideActionMap(lwcFlexTableHandler){
     let flexTableRowActions = lwcFlexTableHandler.FlexTableActionMap.Row;
     lwcFlexTableHandler.hideActionMap = lwcFlexTableHandler.hideActionMap != undefined ? lwcFlexTableHandler.hideActionMap : {};
     
     
     let cond;
     if(flexTableRowActions!=undefined){
 
 
     for(let index=0; index < flexTableRowActions.length; index++){
         let hidevaluesmap=[];
         let result=lwcFlexTableHandler.flattenedData;
         let data=lwcFlexTableHandler.flattenedData;
         let temp=[];
         let level=1;
         let actionValue=flexTableRowActions[index];
 
         if(actionValue.HideExpressionJSON != undefined){
             if(actionValue.EnableParentHideLogic != true){
                 let exp = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(actionValue.HideExpressionJSON), false, false);
                 lwcFlexTableHandler.RowLevelhideExpressionResult[actionValue.Id] = exp;
 
                 // if(exp != undefined){
                     
                 //     for(let j=0; j < result.length; j++){ 
                         
                 //         var returendresult = processExpression(lwcFlexTableHandler,exp,result[j],undefined);
                 //         if(returendresult === true){
                 //             lwcFlexTableHandler.hideActionMap[result[j].id] = lwcFlexTableHandler.hideActionMap[result[j].id] != undefined ? lwcFlexTableHandler.hideActionMap[result[j].id] : {};
                 //                 lwcFlexTableHandler.hideActionMap[result[j].id][actionValue.Id] = true;                        
                 //         }
                 //     }
                 //     //result = processExpression(lwcFlexTableHandler,exp,result,level);
                 //     //}
                 // }
 
             }
 
             if(actionValue.EnableParentHideLogic === true){   
                 let recordsList = lwcFlexTableHandler.flattenedData;
                 let hideExpressionResult = expressionEvaluatorme(lwcFlexTableHandler, JSON.parse(actionValue.HideExpressionJSON), false, true);
                // lwcFlexTableHandler.RowLevelhideExpressionResult[actionValue.Id] = hideExpressionResult;
                 let hideLogicResult;
                
                 lwcFlexTableHandler.finalParentExpressionEval = undefined;
                 hideLogicResult = parentExpressionEval(lwcFlexTableHandler,hideExpressionResult);
                 if(hideLogicResult != undefined){
                     // for(let i = 0; i < recordsList.length; i++){
                     //     lwcFlexTableHandler.hideActionMap[recordsList[i].id] = lwcFlexTableHandler.hideActionMap[recordsList[i].id] != undefined ? lwcFlexTableHandler.hideActionMap[recordsList[i].id] : {};
                     //     lwcFlexTableHandler.hideActionMap[recordsList[i].id][actionValue.Id] = hideLogicResult;
                     // }
 
                     lwcFlexTableHandler.EnableParentHideMap[actionValue.Id] = hideLogicResult;
                 }
 
             }
         }else {
             lwcFlexTableHandler.hideActionColumn = false;
        }
 
        
     }
    
  }
 }
 
 export function processExpression(lwcFlexTableHandler,exp,record,result){
 
     //let andresult = result;
     if(exp != undefined){
        
 
         for(var condition in exp){
             
 
             if(exp[condition].length  > 0 && exp[condition] != undefined){
             
                 for(let i = 0; i < exp[condition].length; i++){
                 
                     let element = exp[condition][i];
 
                     if(!isEmpty(lwcFlexTableHandler,element)){
                     
                         let key = Object.keys(element)[0];;
                         //let value = Object.values[0];
 
                         if(key === '$and' || key === '$or'){
                             // level =level + 1;
                             // length = length + 1;
                             if(condition === '$or'){
                                 result=result || processExpression(lwcFlexTableHandler,element,record, undefined);
                             }else{
                                 result=result && processExpression(lwcFlexTableHandler,element,record, undefined);
                             }
                            
                         }else{
                         
                             if(!isEmpty(lwcFlexTableHandler,element[key])){
                             
                                 let operator = Object.keys(element[key])[0];
                                 let value  =  operator != undefined ? element[key][operator] :undefined;
                                 let RoperandValue;
                                 if(value === undefined || value === null){
                                     
                                     RoperandValue = value;
                                     value = 'null';
                                 }else{
                                     RoperandValue = value;
                                 }
                                 if(condition === '$or'){
                                     let checkbooleanOr;
                                     if(value.toString().includes('__c') || value.toString().includes('__r')){
                                         checkbooleanOr = OperatorCondition(record[key.toLowerCase()],record[RoperandValue.toLowerCase()],operator);
                                     }else{
                                         checkbooleanOr = OperatorCondition(record[key.toLowerCase()],RoperandValue,operator);
 
                                     }
                                     result = result != undefined ? checkbooleanOr || result : checkbooleanOr;
                                 }else{
                                    // andresult = true;
                                    let checkbooleanAnd;
                                    if(value.toString().includes('__c') || value.toString().includes('__r')){
                                     checkbooleanAnd = OperatorCondition(record[key.toLowerCase()],record[RoperandValue.toLowerCase()],operator);
                                     }else{
                                         checkbooleanAnd = OperatorCondition(record[key.toLowerCase()],RoperandValue,operator);
 
                                     }
                                     //if(checkbooleanAnd === true){
                                     result = result != undefined ?  result && checkbooleanAnd : checkbooleanAnd;
                                     /*}else{
                                         andresult = false;
                                     }*/
                                 }
                             }
                         }
                     }
                 }
 
 
             }
 
             /*if(condition === '$and'){
                 result = andresult
             }*/
             
         }
     }
     
 
     return result;
 }
 
 
 
 
 
 export function OperatorCondition(Roperand,Loperand,Value){
 
    let response;
    
    
    if(Roperand != undefined){
     if(Roperand.toString().includes('-')){
 
             if(Roperand.split('-').length === 3 && isNaN(new Date(Roperand)) == false){
                 
                let RoperandList =Roperand.split('-');
                if(parseInt(RoperandList[0]) && parseInt(RoperandList[1]) && parseInt(RoperandList[2])){
                    Roperand  = new Date(Roperand).getTime()
                }
             }
         }
     }
 
    switch(Value){
 
        case '$eq':
                    if(Roperand === Loperand){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
        break;
        case '$ne':
                    if(Roperand != Loperand){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
        break;
        case '$lte':
                    if(Roperand === undefined || Roperand <= Loperand){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
        break;
        case '$gte':
                    if(Roperand != undefined && Roperand >= Loperand){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
        break;
        case '$lt':
              
                    if( Roperand === undefined  ||  Roperand < Loperand){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
        break;
        case '$gt':
               
                    if( Roperand > Loperand){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
        break;
        case '$contains':
              
                if(Roperand != undefined && Loperand != undefined){
                    if( Roperand.toString().toLowerCase().includes(Loperand.toString().toLowerCase())  ){
                        response=true;
 
                    }
                    else{
                        response=false;
                    }
                }
                else{
                    response=false;
                }
        break;
        case '$in':
              
                response=false;
                if(Roperand != undefined && Loperand != undefined){
                    let options=  Loperand != undefined ? Loperand.toString().split(',') : '';
                    if(options != undefined){
                    
                        for(let i=0; i < options.length; i++){
                        
                            if(options[i].toString().toLowerCase() === Roperand.toString().toLowerCase()){
                                response = true;
                                break;
                            }
                            
                        }
                    }
                    
                }
                else{
                    response=false;
                }
        break;
        case '$nin':
               
 
                if(Roperand != undefined && Loperand != undefined){
                    let options=  Loperand != undefined ? Loperand.toString().split(',') : '';
                    if(options != undefined){
                    
                        for(let i=0; i < options.length; i++){
                        
                            if(options[i].toString().toLowerCase() === Roperand.toString().toLowerCase()){
                                response = false;
                                break;
                            }else{
                                response = true;
                            }
                        }
                    }
                    
                }
                else{
                    if(Roperand === undefined){
                        if(Loperand === undefined){
                            response=false;
                        }else{
                            response=true;
                        }
                        
                    }else{
                        response=false;
                    }
                    
                }
        break;
    }
    return response;
 }
 
 
 export function validateStandardRefFields(fieldName){
 
        if(fieldName.indexOf('RecordTypeId') != -1){
            fieldName = fieldName.replace('RecordTypeId','RecordType');
        }
        if(fieldName.indexOf('ContentDocumentId') != -1){
            fieldName = fieldName.replace('ContentDocumentId','ContentDocument');
        }
        if(fieldName.indexOf('LinkedEntityId') != -1){
            fieldName = fieldName.replace('LinkedEntityId','LinkedEntity');
        }
        if(fieldName.indexOf('LastModifiedById') != -1){
            fieldName = fieldName.replace('LastModifiedById','LastModifiedBy');
        }
        if(fieldName.indexOf('CreatedById') != -1){
            fieldName = fieldName.replace('CreatedById','CreatedBy');
        }
        if(fieldName.indexOf('LinkedEntityId') != -1){
            fieldName = fieldName.replace('LinkedEntityId','LinkedEntity');
        }
        if(fieldName.indexOf('CollaborationGroupId') != -1){
            fieldName = fieldName.replace('CollaborationGroupId','CollaborationGroup');
        }
        if(fieldName.indexOf('MemberId') != -1){
            fieldName = fieldName.replace('MemberId','Member');
        }
        if(fieldName.indexOf('RequesterId') != -1){
            fieldName = fieldName.replace('RequesterId','Requester');
        }
        if(fieldName.indexOf('OwnerId') != -1){
            fieldName = fieldName.replace('OwnerId','Owner');
        }if(fieldName.indexOf('ParentId.') != -1){
            fieldName = fieldName.replace('ParentId','Parent');
        }
        if(fieldName.indexOf('ProfileId') != -1){
            fieldName = fieldName.replace('ProfileId','Profile');
        }
     return fieldName;
 }
 
 export function parentExpressionEval(lwcFlexTableHandler,exp){
     let prevConditon;
     if(exp.$or || exp.$and){
         let cond = (exp.$or ? exp.$or : exp.$and);
         let prevConditon = (exp.$or ? '||' : '&&');
 
         for(let i = 0; i < cond.length; i++){
             if(typeof cond[i] === 'object'){
                 lwcFlexTableHandler.finalParentExpressionEval = undefined;
                 cond[i] = parentExpressionEval(lwcFlexTableHandler,cond[i]);
             }
         }
         for(let i = 0; i < cond.length; i++){
             let condResult = typeof cond[i] === 'boolean' ? cond[i] : parentExpressionEval(lwcFlexTableHandler,cond[i]);
             if(prevConditon === '||'){
                 lwcFlexTableHandler.finalParentExpressionEval = lwcFlexTableHandler.finalParentExpressionEval != undefined ? lwcFlexTableHandler.finalParentExpressionEval : false;
                 lwcFlexTableHandler.finalParentExpressionEval = lwcFlexTableHandler.finalParentExpressionEval || condResult;
             }else{
                 lwcFlexTableHandler.finalParentExpressionEval = lwcFlexTableHandler.finalParentExpressionEval != undefined ? lwcFlexTableHandler.finalParentExpressionEval : true;
                 lwcFlexTableHandler.finalParentExpressionEval = lwcFlexTableHandler.finalParentExpressionEval && condResult;
             }
         } 
     }
     return lwcFlexTableHandler.finalParentExpressionEval;
 }
 
 
 export function getActions(lwcFlexTableHandler,row){
     let actions =[];
     if(lwcFlexTableHandler.RowLevelhideExpressionResult != undefined ){
                 
         for(let index=0; index < lwcFlexTableHandler.AllRowActions.length; index++){
         
             if(lwcFlexTableHandler.RowLevelhideExpressionResult[lwcFlexTableHandler.AllRowActions[index].Id] != undefined){
                 
                 var returendresult = processExpression(lwcFlexTableHandler,lwcFlexTableHandler.RowLevelhideExpressionResult[lwcFlexTableHandler.AllRowActions[index].Id],row,undefined);
                 if(returendresult === true){
                     lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row.id] = lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row.id] != undefined ? lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row.id] : {};
                     lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row.id][lwcFlexTableHandler.AllRowActions[index].Id] = true;                        
                 }
                
                 
             }
         }
     }
     //return actions;
 
         lwcFlexTableHandler.FirstRowClick[row.id] = true;
         getActionsFromHideActiionMap(lwcFlexTableHandler);
     
 } 
 
 export function getActionsFromHideActiionMap(lwcFlexTableHandler){
    //lwcFlexTableHandler.AllRowActionsCopy = [...lwcFlexTableHandler.AllRowActions];
    let actioString = JSON.stringify(lwcFlexTableHandler.AllRowActions)
    let actions = JSON.parse(actioString);
    let hideActionCount =0;
    let NoAction = [{"Id":"noActions","Name" : "No Actions Available","ButtonHelpText" : "No Actions Available","title" : "No Actions Available"}];
     if(lwcFlexTableHandler.hideActionMap != undefined){
                 
                     if(lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row['id']] != undefined){
                     
                         for(let i=0; i < actions.length; i++){
                             
                             if(lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row['id']][actions[i].Id] != undefined){
                                 if( lwcFlexTableHandler.hideActionMap[lwcFlexTableHandler.row['id']][actions[i].Id] === true){
 
                                     actions[i]['isHide'] = true;
                                     hideActionCount = hideActionCount + 1;
                                     if(lwcFlexTableHandler.ApprovalLockedRecordsMap[lwcFlexTableHandler.row['id']] === true){
                                         if(actions[i].isEdit === true || actions[i].isDelete === true){
                                             actions[i]['Iconcss'] = 'utility:lock';
                                             actions[i]['ActionLocked'] = true;
                                         }
                                         
                                     }
 
                                 }
                             }
                             else{
                                 if(lwcFlexTableHandler.EnableParentHideMap[actions[i].Id] === true){
                                     actions[i]['isHide'] = true;
                                     hideActionCount = hideActionCount + 1;
                                 }else{
                                     actions[i]['isHide'] = false;
                                     if(lwcFlexTableHandler.ApprovalLockedRecordsMap[lwcFlexTableHandler.row['id']] === true){
                                         if(actions[i].isEdit === true || actions[i].isDelete === true){
                                             actions[i]['Iconcss'] = 'utility:lock';
                                             actions[i]['ActionLocked'] = true;
                                         
                                         }
                                     
                                     }
                                 
                                 }
                                 
                             }
 
                             
 
                         }
                     }else{
                 
                         if(Object.keys(lwcFlexTableHandler.EnableParentHideMap).length > 0){
                              
                             for(let i=0; i < actions.length; i++){
                                 if(lwcFlexTableHandler.EnableParentHideMap[actions[i].Id] === true){
                                     actions[i]['isHide'] = true;
                                     hideActionCount = hideActionCount + 1;
                                 }else{
                                     actions[i]['isHide'] = false;
                                     if(lwcFlexTableHandler.ApprovalLockedRecordsMap[lwcFlexTableHandler.row['id']] === true){
                                        if(actions[i].isEdit === true || actions[i].isDelete === true){
                                            actions[i]['Iconcss'] = 'utility:lock';
                                            actions[i]['ActionLocked'] = true;
                                        
                                        }
                                    
                                    }
                                 }
                             }
                         }else{
                             for(let i=0; i < actions.length; i++){
                                 actions[i]['isHide'] = false;
                                 if(lwcFlexTableHandler.ApprovalLockedRecordsMap[lwcFlexTableHandler.row['id']] === true){
                                    if(actions[i].isEdit === true || actions[i].isDelete === true){
                                        actions[i]['Iconcss'] = 'utility:lock';
                                        actions[i]['ActionLocked'] = true;
                                    }
                                
                                }
                             }
                         }
                     }
                 }
                 lwcFlexTableHandler.RowActions = hideActionCount == actions.length ? NoAction : actions;
                 lwcFlexTableHandler.isAction = true;
             
 
 
}