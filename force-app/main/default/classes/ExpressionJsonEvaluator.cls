/*
* Author - Pankaj H.
 Modifications - Tomy Pallissery - Added support for user which is equivalent of salesforce user global variable - 27/09/2018
 Modifications - Tomy Pallissery - Added support to check if value is null, in case of field type - 04/10/2018
*Sample Expression – 
(ggf_dev2__FirstName__c = 'test' AND ggf_dev2__Currency1__c > 120 AND CreatedBy.Id = $User.Id AND ( ggf_dev2__FirstName__c != ggf_dev2__FirstName1__c OR ggf_dev2__Currency1__c > 150 ))

JSON for above expression will be as below –
{  
   "groups":[  
      {  
         "LogicalOperator":"AND",
         "Conditions":[  
            {  
               "LOperand":{  
                  "Type":"Field",
                  "Value":"ggf_dev2__FirstName__c"
               },
               "Operator":"=",
               "ROperand":{  
                  "Type":"Text",
                  "Value":"test"
               }
            },
            {  
               "LOperand":{  
                  "Type":"Field",
                  "Value":"ggf_dev2__Currency1__c"
               },
               "Operator":">",
               "ROperand":{  
                  "Type":"Text",
                  "Value":"120"
               }
            },
            {
                "LOperand": {
                    "Type": "Field",
                    "Value": "CreatedBy.Id"
                },
                "Operator": "=",
                "ROperand": {
                    "Type": "User",
                    "Value": "Id",
                    "Values": []
                }
            }
         ],
         "groups":[  
            {  
               "LogicalOperator":"OR",
               "Conditions":[  
                  {  
                     "LOperand":{  
                        "Type":"Field",
                        "Value":"ggf_dev2__FirstName__c"
                     },
                     "Operator":"!=",
                     "ROperand":{  
                        "Type":"Field",
                        "Value":"ggf_dev2__FirstName1__c"
                     }
                  },
                  {  
                     "LOperand":{  
                        "Type":"Field",
                        "Value":"ggf_dev2__Currency1__c"
                     },
                     "Operator":">",
                     "ROperand":{  
                        "Type":"Text",
                        "Value":"150"
                     }
                  }
               ]
            }
         ]
      }
   ]
}

In JSON we will have groups. Groups will contains multiple conditions or multiple inner groups.
Condition will have left operand, Operator and right operand.

In left operand(LOperand) Type will be Field, Profile, UserType, Context or CustomApp. If type is field then value will be Field API Name. 
In other cases value will be blank.
In right operand(ROperand) Type will be Freetext, Field, Regex, $User.

If the type is $User, the fields in the field selector will be the fields of User object. This simulates the behaviour of the $User global variable
of salesforce. The 'User' used in this class indicates the $User, and the instance of user is returned by the getCurrentUser method

*

*/
global with sharing class ExpressionJsonEvaluator {

    private static sObject userInstance = null;
    public static Map<String,sObject> recordMap = new Map<String,sObject>();
    public Static String updatedObjAPIName; 
    /*
    Modified by - Dipak Pawar on 25 June 2020
    Description - Due to LastPasswordChangeDate field access to SPI user, we have moved this logic to SystemContextMethodsHelper class to run in without sharing mode.
    */
    @TestVisible 
    private static sObject getCurrentUser() {
        if(userInstance == null) {
            return SystemContextMethodsHelper.getCurrentUserDetails();
        }
        return new User();
    }

    private static sObject getCurrentUserWithFields(String fieldName) {
        if(userInstance == null && !String.isEmpty(fieldName)) {
            Id loggedInUserId = userInfo.getUserId();
            String query =   'Select '+String.escapeSingleQuotes(fieldName)+ ' from User where Id=:loggedInUserId';
            sObject currentUser = Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE);
            return currentUser;
        }
        return new User();
    }
    
    
    global static Boolean evaluateExpression(String expr, sObject record, String context) {
        List<sObject> recdList = new List<sObject>{record};
        updatedObjAPIName = String.valueOf(record.getSObjectType());
        return evaluateExpression(expr, recdList, context);
    }
    
    global static Boolean evaluateExpression(String expr, List<sObject> record, String context) {
        ExpGroup expGrp = (ExpGroup)JSON.deserialize(SFDCEncoder.sanitizeJSON(expr), ExpGroup.Class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON

        if(record.size() > 0){
            for(sObject sobj : record){
                String objectAPIName =  String.valueOf(sobj.getSObjectType());
                recordMap.put(objectAPIName, sobj);
            }            
        }
        return evaluateGroup(expGrp, recordMap, context);
    }
    
    private static Boolean evaluateGroup(ExpGroup expGrp, Map<String, sObject> recordMap, String context) {
        Boolean result = null;
        if(expGrp.Conditions != null) {
            for(Condition cond : expGrp.Conditions) {
                Boolean evalResult = evaluateCondition(cond, recordMap, context);
                if(expGrp.LogicalOperator == 'OR' && evalResult == true) {
                    return true;
                }
                //no need to check for OR as it will return as soon as we got true.
                if(result == null) {
                    result = evalResult;
                } else if(expGrp.LogicalOperator == 'AND') {
                    result = result && evalResult;
                }
            }
        }
        
        if(expGrp.Groups != null) {
            for(ExpGroup expGrp1 : expGrp.Groups) {
                Boolean evalResult = evaluateGroup(expGrp1, recordMap, context);
                if(expGrp.LogicalOperator == 'OR' && evalResult == true) {
                    return true;
                }
                //no need to check for OR as it will return as soon as we got true.
                if(result == null) {
                    result = evalResult;
                } else if(expGrp.LogicalOperator == 'AND') {
                    result = result && evalResult;
                }
            }
        }
        return result;
    }
    
    private static Boolean evaluateCondition(Condition cond, Map<String, sObject> recordMap, String context) {
        Boolean result = false;
        sObject record;
        Schema.DisplayType leftFieldType;
        if(cond.LOperand.Type == 'Field' || cond.LOperand.Type == 'User') {

            if(String.isEmpty(cond.LOperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')) {
                return result;
            }
            
           Map<String, Object> loperandMap = new Map<String, Object>();
           loperandMap = getMultiRecordVal(cond.LOperand.Value);
           if(cond.LOperand.Type == 'User') {
                String FieldValforUser= (String)loperandMap.get('fieldVal');
                record = getCurrentUserWithFields(FieldValforUser);
           } else {
                record = (sObject)loperandMap.get('sobjectRecord');
           }
           
           String objectAPIName = cond.LOperand.Type == 'User' ? 'User' : String.valueOf(record.getSObjectType());
           cond.LOperand.Value = (String)loperandMap.get('fieldVal');
           leftFieldType = SchemaManager.getFieldSchemaResult(objectAPIName, cond.LOperand.Value).fieldDesc.getType();                                          

            if(leftFieldType == Schema.DisplayType.String || leftFieldType == Schema.DisplayType.TextArea
                || leftFieldType == Schema.DisplayType.Email || leftFieldType == Schema.DisplayType.Picklist || 
                leftFieldType == Schema.DisplayType.Phone || leftFieldType == Schema.DisplayType.MultiPicklist ||
                 leftFieldType == Schema.DisplayType.URL || leftFieldType == Schema.DisplayType.REFERENCE) {
                return evalStringCondition(cond, record);
            } else if(leftFieldType == Schema.DisplayType.Currency || leftFieldType == Schema.DisplayType.Double
                || leftFieldType == Schema.DisplayType.Integer || leftFieldType == Schema.DisplayType.Percent) {
                return evalNumberCondition(cond, record);
            } else if(leftFieldType == Schema.DisplayType.Boolean) {
                return evalBooleanCondition(cond, record);
            } else if(leftFieldType == Schema.DisplayType.Date) {
                return evalDateCondition(cond, record);
            } else if(leftFieldType == Schema.DisplayType.DateTime) {
                return evalDateTimeCondition(cond, record);
            } else if(leftFieldType == Schema.DisplayType.ID) {
                return evalIdCondition(cond, record);
            }
            
            //compare Date Times
        } else if(cond.LOperand.Type == 'Profile') {
            return evalUserProfile(cond);
        } else if(cond.LOperand.Type == 'UserType') {
            return evalUserType(cond);
        } else if(cond.LOperand.Type == 'Context') {
            return evalUserContext(cond, context);
        } else if(cond.LOperand.Type == 'UserApp') {
            return evalUserApp(cond);
        } else if(cond.LOperand.Type == 'Queue') {
            
        }
        return result;
    }
    
    private static Map<String, Object> getMultiRecordVal(String condVal){      
        Map<String, Object> returnMap = new Map<String, Object>();
        if(condVal.contains(':')){
            String[] lroperandValArr = condVal.split(':');
            returnMap.put('sobjectRecord', recordMap.get(lroperandValArr[0]));
            returnMap.put('fieldVal', lroperandValArr[1]);
        }else{
            if(recordMap.values().size() > 0) { //the size of recordmap will be > 0 only if expression contains field type
              //in a scenario where field type is invalid, we do not get sobject records, and hence this key of sobjectrecord is not needed 
              //in case of only $User condition (we get record value from getCurrentUser method instead of here), 
              //Added if block for User Story 204279: Internal Analysis - Auto Snapshot Configuration issues
              sObject record = recordMap.get(updatedObjAPIName);
                if(record != null){
                    returnMap.put('sobjectRecord', recordMap.get(updatedObjAPIName));
                }else{
                    returnMap.put('sobjectRecord', recordMap.values()[0]);
                }
            }
            returnMap.put('fieldVal', condVal); 
        }
        return returnMap;
    }
    
    private static Boolean evalUserType(Condition cond) {
        String userType = AppUtils.getUserType();
        if(String.isEmpty(userType)) {
            //throw exception
        }
        return compareString(userType, cond.ROperand.Value, cond.Operator,cond.ROperand.Values);
    }
    
    private static Boolean evalUserProfile(Condition cond) {
        String userProfile = AppUtils.getProfileInfo();
        return compareString(userProfile, cond.ROperand.Value, cond.Operator,cond.ROperand.Values);
    }
    
    private static Boolean evalUserContext(Condition cond, String context) {

        return compareString(context, cond.ROperand.Value, cond.Operator,cond.ROperand.Values);
    }
    
    private static Boolean evalUserApp(Condition cond) {
        String userApp = UserPreferenceHelper.getStringValue('ActiveAppName__c');
        return compareString(userApp, cond.ROperand.Value, cond.Operator,cond.ROperand.Values);
    }

    private static Boolean evalIdCondition(Condition cond, sObject record) {
        String leftOperand = (String)AppUtils.getFieldValue(record, cond.LOperand.Value);
        String rightOperand;
        sObject roperandRec;
        if(cond.ROperand.Type == 'Field' || cond.ROperand.Type == 'User') {
            //compare left and right field types and throw exception if it is wrong.
            if(String.isEmpty(cond.ROperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')){
                return false;
            }
            Map<String, Object> roperandMap = new Map<String, Object>(); 
            roperandMap = getMultiRecordVal(cond.ROperand.Value);
            if(cond.ROperand.Type == 'User') {
                String FieldValforUser= (String)roperandMap.get('fieldVal');
                roperandRec = getCurrentUserWithFields(FieldValforUser);
            } else {
                roperandRec = (sObject) roperandMap.get('sobjectRecord');
            }
            
            cond.ROperand.Value = (String) roperandMap.get('fieldVal');
            rightOperand = (String)AppUtils.getFieldValue(roperandRec, cond.ROperand.Value);
        } else if(String.isNotEmpty(cond.ROperand.Value) && cond.ROperand.Value.toLowerCase() == 'null') {
            return evaluateNullCondition(leftOperand, cond.Operator);
        } else {
            Id convertedId = cond.ROperand.Value;
            rightOperand = String.valueOf(convertedId);
        }
        return compareString(leftOperand, rightOperand, cond.Operator,null);
    }
    
    private static Boolean evalStringCondition(Condition cond, sObject record ) {
        String leftOperand =  (String)AppUtils.getFieldValue(record, cond.LOperand.Value);
       /* if(fieldType == Schema.DisplayType.MultiPicklist || fieldType == Schema.DisplayType.Picklist){
            leftOperand = (String)AppUtils.getMultiPickListFieldValue(record, cond.LOperand.Value);
        }else{
            leftOperand =  (String)AppUtils.getFieldValue(record, cond.LOperand.Value);
        }*/
        String rightOperand;
        sObject rightRecord;
        if(cond.ROperand.Type == 'Field' || cond.ROperand.Type == 'User') {
            //compare left and right field types and throw exception if it is wrong.
            if(String.isEmpty(cond.ROperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')){
                return false;
            }
            Map<String, Object> roperandMap = new Map<String, Object>();
            roperandMap = getMultiRecordVal(cond.ROperand.Value);
            if(cond.ROperand.Type == 'User') {
                String FieldValforUser= (String)roperandMap.get('fieldVal');
                rightRecord = getCurrentUserWithFields(FieldValforUser);
            } else {
                rightRecord = (sObject) roperandMap.get('sobjectRecord');
            }
            
            cond.ROperand.Value = (String) roperandMap.get('fieldVal'); 
            rightOperand = (String)AppUtils.getFieldValue(rightRecord, cond.ROperand.Value);
           /* if(fieldType == Schema.DisplayType.MultiPicklist || fieldType == Schema.DisplayType.Picklist){
                rightOperand = (String)AppUtils.getMultiPickListFieldValue(rightRecord, cond.ROperand.Value);
            }else{
                rightOperand = (String)AppUtils.getFieldValue(rightRecord, cond.ROperand.Value);
            }*/
        } else if(cond.ROperand.Type == 'Regex') {
            return evalRegex(leftOperand, rightOperand, cond.Operator);
        } else if(String.isNotEmpty(cond.ROperand.Value) && cond.ROperand.Value.toLowerCase() == 'null') {
            return evaluateNullCondition(leftOperand, cond.Operator);
        } else {
            rightOperand = cond.ROperand.Value;
        }
        return compareString(leftOperand, rightOperand, cond.Operator,null);
    }
    
    @TestVisible
    private static Boolean evalRegex(String value, String regex, String operator) {
    	if(String.isEmpty(value) || String.isEmpty(regex)) return false;
    	Boolean regexResult = Pattern.matches(regex, value);
    	if(operator == '=') {
    		return regexResult;
    	} else {
    		return !regexResult;
    	}
    	
    }
    
    private static Boolean evalNumberCondition(Condition cond, sObject record) {
        Double leftOperand = (Double)AppUtils.getFieldValue(record, cond.LOperand.Value);
        Double rightOperand;
        sObject rightRecord;
        if(cond.ROperand.Type == 'Field' || cond.ROperand.Type == 'User') {
            //compare left and right field types and throw exception if it is wrong.
            if(String.isEmpty(cond.ROperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')){
                return false;
            }
            Map<String, Object> roperandMap = new Map<String, Object>();
            roperandMap = getMultiRecordVal(cond.ROperand.Value);
            if(cond.ROperand.Type == 'User') {
                String FieldValforUser= (String)roperandMap.get('fieldVal');
                rightRecord = getCurrentUserWithFields(FieldValforUser);
            } else {
                rightRecord = (sObject) roperandMap.get('sobjectRecord');
            }
            
            cond.ROperand.Value = (String) roperandMap.get('fieldVal'); 
            rightOperand = (Double)AppUtils.getFieldValue(rightRecord, cond.ROperand.Value);
        } else if(String.isNotEmpty(cond.ROperand.Value) && cond.ROperand.Value.toLowerCase() == 'null') {
            return evaluateNullCondition(leftOperand, cond.Operator);
        } else {
            rightOperand = Double.valueOf(cond.ROperand.Value);
        }
        return compareNumber(leftOperand, rightOperand, cond.Operator);
    }
    
    @TestVisible
    private static Boolean evalBooleanCondition(Condition cond, sObject record) {
        Boolean leftOperand = (Boolean)AppUtils.getFieldValue(record, cond.LOperand.Value);
        Boolean rightOperand;
        sObject rightRecord;
        if(cond.ROperand.Type == 'Field' || cond.ROperand.Type == 'User') {
            //compare left and right field types and throw exception if it is wrong.
            if(String.isEmpty(cond.ROperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')){
                return false;
            }
            Map<String, Object> roperandMap = new Map<String, Object>();
            roperandMap = getMultiRecordVal(cond.ROperand.Value);
            if(cond.ROperand.Type == 'User') {
                String FieldValforUser= (String)roperandMap.get('fieldVal');
                rightRecord = getCurrentUserWithFields(FieldValforUser);
            } else {
                rightRecord = (sObject) roperandMap.get('sobjectRecord');
            }
            
            cond.ROperand.Value =(String) roperandMap.get('fieldVal');
            rightOperand = (Boolean)AppUtils.getFieldValue(rightRecord, cond.ROperand.Value);
        } else {
            rightOperand = Boolean.valueOf(cond.ROperand.Value);
        }
        return compareBoolean(leftOperand, rightOperand, cond.Operator);
    }

    private static Boolean evalDateCondition(Condition cond, sObject record) {
        Date leftOperand = (Date)AppUtils.getFieldValue(record, cond.LOperand.Value);
        Date rightOperand;
        sObject rightRecord;
        if(cond.ROperand.Type == 'Field' || cond.ROperand.Type == 'User') {
            //compare left and right field types and throw exception if it is wrong.
            if(String.isEmpty(cond.ROperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')){
                return false;
            }
            Map<String, Object> roperandMap = new Map<String, Object>();
            roperandMap = getMultiRecordVal(cond.ROperand.Value);
            if(cond.ROperand.Type == 'User') {
                String FieldValforUser= (String)roperandMap.get('fieldVal');
                rightRecord = getCurrentUserWithFields(FieldValforUser);
            } else {
                rightRecord = (sObject) roperandMap.get('sobjectRecord');
            }
            
            cond.ROperand.Value = (String) roperandMap.get('fieldVal'); 
            rightOperand = (Date)AppUtils.getFieldValue(rightRecord, cond.ROperand.Value);              
        } else if(String.isNotEmpty(cond.ROperand.Value) && cond.ROperand.Value.toLowerCase() == 'null') {
            return evaluateNullCondition(leftOperand, cond.Operator);
        } else {
            //for freetext
            rightOperand = date.parse(cond.ROperand.Value);
        }
        return compareDate(leftOperand, rightOperand, cond.Operator);
    }

    private static Boolean evalDateTimeCondition(Condition cond, sObject record) {
        DateTime leftOperand = (DateTime)AppUtils.getFieldValue(record, cond.LOperand.Value);
        DateTime rightOperand;
        sObject rightRecord;
        if(cond.ROperand.Type == 'Field' || cond.ROperand.Type == 'User') {
            //compare left and right field types and throw exception if it is wrong.
            if(String.isEmpty(cond.ROperand.Value) || (recordMap.size() == 0 && cond.LOperand.Type == 'Field')){
                return false;
            }
            Map<String, Object> roperandMap = new Map<String, Object>();
            roperandMap = getMultiRecordVal(cond.ROperand.Value);
            if(cond.ROperand.Type == 'User') {
                String FieldValforUser= (String)roperandMap.get('fieldVal');
                rightRecord = getCurrentUserWithFields(FieldValforUser);
            } else {
                rightRecord = (sObject) roperandMap.get('sobjectRecord');
            }
            
            cond.ROperand.Value = (String) roperandMap.get('fieldVal'); 
            rightOperand = (DateTime)AppUtils.getFieldValue(rightRecord, cond.ROperand.Value); 
        } else if(String.isNotEmpty(cond.ROperand.Value) && cond.ROperand.Value.toLowerCase() == 'null') {
            return evaluateNullCondition(leftOperand, cond.Operator);
        } else {
            //for freetext
            rightOperand = Datetime.parse(cond.ROperand.Value);
        }
        return compareDateTime(leftOperand, rightOperand, cond.Operator);
    }
    
    @TestVisible
    private static Boolean compareString(String leftOperand, String rightOperand, String operator,List<String> rightOperands) {
        if(operator == '=') {
            return (leftOperand==rightOperand);
        } else if(operator == '!=') {
            return (leftOperand!=rightOperand);
        } else if(operator == '>=') {
            return (leftOperand>=rightOperand);
        } else if(operator == '<=') {
            return (leftOperand<=rightOperand);
        }  else if(operator == '<') {
            return (leftOperand<rightOperand);
        }  else if(operator == '>') {
            return (leftOperand>rightOperand);
        } else if(operator == 'CONTAINS') {
            return (String.isNotEmpty(leftOperand) && String.isNotEmpty(rightOperand) &&  leftOperand.Contains(rightOperand));
        } else if(operator == 'IN' || operator == 'not in') { // list should be ; seprated
            List<String> leftOprValSet = new List<String>();
            if(String.isNotEmpty(leftOperand)){
               leftOprValSet = leftOperand.split(';'); 
            }
            List<String> rightValueList = new List<String>();
            if(String.isNotEmpty(rightOperand)){
               rightValueList = rightOperand.split(';'); 
            } else if(rightOperands != null && rightOperands.size() > 0){
               rightValueList.addAll(rightOperands);
            }
            Set<String> rightValueSet = new Set<String>();
            for(String rightOprVal: rightValueList){
                rightValueSet.add(rightOprVal.trim());
            }

            Boolean isValid = true;
            if(operator == 'IN'){
                if(leftOprValSet.size() < 1){
                    isValid = false;
                }
                for(String leftOprVal: leftOprValSet){
                    if(!rightValueSet.Contains(leftOprVal.trim())){
                        isValid = false;
                    }
                }
            } else{
                for(String leftOprVal: leftOprValSet){
                    if(rightValueSet.Contains(leftOprVal.trim())){
                        isValid = false;
                    }
                }
            }
            
            return isValid;
        }
        return false;
    }
    
    @TestVisible
    private static Boolean compareNumber(Double leftOperand, Double rightOperand, String operator) {
        if(operator == '=') {
            return (leftOperand==rightOperand);
        } else if(operator == '!=') {
            return (leftOperand!=rightOperand);
        } else if(operator == '>=') {
            return (leftOperand>=rightOperand);
        } else if(operator == '>') {
            return (leftOperand>rightOperand);
        } else if(operator == '<') {
            return (leftOperand<rightOperand);
        } else if(operator == '<=') {
            return (leftOperand<=rightOperand);
        }
        return false;
    }

    @TestVisible
    private static Boolean compareDate(Date leftOperand, Date rightOperand, String operator) {
        if(rightOperand == null){
            if(leftOperand != null){
                return true;
            }else{
                return false;
            }
        }else{
            if(leftOperand == null){
                return false;
            }else{
        if(operator == '=') {
            return (leftOperand.isSameDay(rightOperand));
        } else if(operator == '!=') {
            return !(leftOperand.isSameDay(rightOperand));
        } else if(operator == '>=') {
            return (leftOperand>=rightOperand);
        } else if(operator == '>') {
            return (leftOperand>rightOperand);
        } else if(operator == '<') {
            return (leftOperand<rightOperand);
        } else if(operator == '<=') {
            return (leftOperand<=rightOperand);
        }
            }
        }
        return false;
    }

    @TestVisible
    private static Boolean compareDateTime(DateTime leftOperand, DateTime rightOperand, String operator) {
        if(rightOperand == null){
            if(leftOperand != null){
                return true;
            }else{
                return false;
            }
        }else{
            if(leftOperand == null){
                return false;
            }else{
        if(operator == '=') {
           return (leftOperand.isSameDay(rightOperand));
        } else if(operator == '!=') {
            return !(leftOperand.isSameDay(rightOperand));
        } else if(operator == '>=') {
            return (leftOperand>=rightOperand);
        } else if(operator == '>') {
            return (leftOperand>rightOperand);
        } else if(operator == '<') {
            return (leftOperand<rightOperand);
        } else if(operator == '<=') {
            return (leftOperand<=rightOperand);
                }
            }
        }
        return false;
    }
    
    @TestVisible
    private static Boolean compareBoolean(Boolean leftOperand, Boolean rightOperand, String operator) {
        if(operator == '=') {
            return (leftOperand==rightOperand);
        } else if(operator == '!=') {
            return (leftOperand!=rightOperand);
        }
        return false;
    }
    public static String getfieldNamesFromJSON(String expJson){
        ExpGroup expGrp =(ExpGroup)JSON.deserialize(SFDCEncoder.sanitizeJSON(expJson),ExpGroup.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
        Set<String> expFieldsSet = new Set<String>();
        processExpGroup(expGrp,expFieldsSet);
        String fields = String.join(new List<String>(expFieldsSet),',');
        return fields;
    }
    private static void processExpGroup(ExpGroup expGroup,Set<String> fieldsSet){
        if(expGroup.Conditions != null){
            for(Condition condition:expGroup.Conditions){
                if(condition.LOperand.Type == 'Field'){
                    fieldsSet.add(condition.LOperand.Value);
                }
                if(condition.ROperand.Type == 'Field'){
                    fieldsSet.add(condition.ROperand.Value);
                }
            }
        }
        if(expGroup.Groups != null){
                for(ExpGroup childExpGroup:expGroup.Groups){
                    processExpGroup(childExpGroup,fieldsSet);
                }
          }
    }

    private static Boolean evaluateNullCondition(Object loperand, String operator) {
        if(operator == '=') {
            return loperand == null;
        } else if(operator == '!=') {
            return loperand != null;
        }
        return false;
    }
/* 
check if an Sobject has a field
*/
    public static boolean hasSObjectField(String fieldName,String objectName){
        try{
          List<String> fieldsList = fieldName.split(',');
          for (String field:fieldsList){
              SchemaManager.getSObjectField(objectName,field);
          }
          return true;
        } catch(Exception ex) { 
          return false; 
        }
    } 

    public with sharing class ExpGroup {
        public List<Condition> Conditions;
        public String LogicalOperator;
        public List<ExpGroup> Groups;
         
    }
    
    public with sharing class Condition {
        public TypeValue LOperand;
        public String Operator;
        public TypeValue ROperand;
    }
    
    public with sharing class TypeValue {
        public String Type;
        public String Value;
        public List<String> Values;
    }
    
    @TestVisible 
     public with sharing class expressionWprapper{
        @AuraEnabled
        public list<sObject> ObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldKeyMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scale {get;set;}
        @AuraEnabled
        public String timelol {get;set;}   
        @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public expressionWprapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
            this.ObjectList = sObjectList;
            this.fieldKeyMap = fieldLableMap;
            this.fieldDataMap = fieldDataTypeMap;
            this.scale = scaleMap;
            this.timelol = (UserInfo.getTimeZone()).toString();
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }

}