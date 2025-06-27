/**
    This class has convenient methods to cache schema information for standard and custom objects.
    This will ensure that multiple calls to descibes aren't called so we don't hit governor limits.

    **********************************************************
    Audit History
    **********************************************************
    3/14/2012   Shah Kadirmohideen    Created
    **********************************************************  
*/
global with sharing class SchemaManager { 
    private static Map<String, Schema.SObjectType> globalSchemaMap;  //key->sobject name (with or without namespace - case insensitive)
    private static Map<String, SObjectWrapper> sobjectMap;  //key->object name (with namespace - lowercase)
    
    static {
        sobjectMap = new Map<String, SObjectWrapper>();
        globalSchemaMap = Schema.getGlobalDescribe();  //Needed
    }
    
    /* SOBJECT RELATED METHODS */
    
    //Input object name should have proper namespace (case sensitive)
    global static SObjectWrapper getSObject(String objectName) {
        SObjectWrapper result = sobjectMap.get(objectName.toLowerCase());
        if (result == null) {
            result = new SObjectWrapper(objectName);
            sobjectMap.put(objectName.toLowerCase(), result);
        }
        return result;
    }
    
    //Overloaded method that uses Id
    global static SObjectWrapper getSObject(Id objectId) {
        
        String objectName =  objectId.getSObjectType().getDescribe().getName();
        SObjectWrapper result = sobjectMap.get(objectName.toLowerCase());
        if (result == null) {
            result = new SObjectWrapper(objectName);
            sobjectMap.put(objectName.toLowerCase(), result);
        }
        return result;
    }
    
    //Checks if the input object name is defined in the schema
    global static Boolean doesObjExist(String objectName) {
        try {
            getSObject(objectName);
        }
        catch (AppUtils.ValidationException e) {
            return false;
        }
        return true; 
    }
    
    //Gets the sObject type from the name of the object. To improve performance, hardcoding is done for some types
    public static Schema.SObjectType getSObjectTypeFromName(string objectName) { 
        Schema.SObjectType sobjType = null;
        if(objectName.equalsIgnoreCase('Contact')) {
            sobjType = Contact.sObjectType;       
        }else if(objectName.equalsIgnoreCase('Package__c')) {
            sobjType = Package__c.sObjectType;
        }else if(objectName.equalsIgnoreCase('Account')) {
            sobjType = Account.sObjectType;
        }else if(objectName.equalsIgnoreCase('Task')) {
            sobjType = Task.sObjectType;
        }else if(objectName.equalsIgnoreCase('Case')) {  // Added by Davinder on 8/5/2015
            sobjType = Case.sObjectType;
        }else {
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            sobjType = gd.get(objectName);
        }

        if(sobjType == null){
            throw new AppUtils.ValidationException ('Get Sobject Type failed for '+objectName); 
        }
        
        return sobjType ; 
    }


    global static Map<String, SObjectWrapper> getObjectsForReferenceFields(String objectName) { // Dk : Spring Cleanup 7-6-16
        return null;
    }


    global static Field getFieldSchemaResult(String objectName, String fieldName) {
        String[] fieldArr = fieldName.split('\\.', -1);
        Field f = null;
        if (fieldArr.size() == 1) {
            SObjectFieldWrapper fieldWrapper = getSObject(objectName).getField(fieldName);
            if (fieldWrapper == null) {
                throw new AppUtils.ValidationException('Field not defined in object. Field: ' + fieldName + ', SObject: ' + objectName);
            }
            
            f = new Field(objectName, getSObject(objectName).objectType, fieldName, false);
            f.fieldDesc = fieldWrapper.fieldResult;
            f.isUpdatable = fieldWrapper.fieldResult.isUpdateable();         
        }
        else {
            f = resolveRelationshipField(objectName, fieldArr, false);
        }
        if (f == null) {
            throw new AppUtils.ValidationException('Field not defined in object. Field: ' + fieldName + ', SObject: ' + objectName);
        }
        return f;
    }   
    
    global static Schema.SObjectField getSObjectField(String objectName, String fieldName) {
        String[] fieldArr = fieldName.split('\\.', -1);
        Schema.SObjectField fieldResult = null;
        if (fieldArr.size() == 1) {
            fieldResult = getSObject(objectName).getField(fieldName).fieldResult.getSObjectField();
        }
        else {
            Field f = resolveRelationshipField(objectName, fieldArr, false);
            if (f == null) {
                throw new AppUtils.ValidationException('Field not defined in object. Field: ' + fieldName + ', SObject: ' + objectName);
            }
            fieldResult = getSObjectField(f.objectName, f.fieldName);
        }
        if (fieldResult == null) {
            throw new AppUtils.ValidationException('Field not defined in object. Field: ' + fieldName + ', SObject: ' + objectName);
        }
        return fieldResult;
    }
    
    /* this method returns field describe result*/
    global static Schema.DescribeFieldResult fetchDescribeFieldResult(String objectName, String fieldName){
        Schema.SObjectField sobjFld = SchemaManager.getSObjectField(objectName,fieldName);
        if(sobjFld != null){
            Schema.DescribeFieldResult dsr = sobjFld.getDescribe();
            return dsr;
        }
        if (sobjFld == null) {
            throw new AppUtils.ValidationException('Field not defined in object. Field: ' + fieldName + ', SObject: ' + objectName);
        }
        return null;
    }

    global static Field getSObjectFieldSet(String objectName, String fieldSetName) {
        String[] fieldArr = fieldSetName.split('\\.', -1);
        Field f = null;
        if (fieldArr.size() == 1) {
            SObjectFieldSetWrapper fieldSetWrapper = getSObject(objectName).getFieldSet(fieldSetName);
            f = new Field(objectName, getSObject(objectName).objectType, fieldSetName, false);
            f.fieldSetDesc = fieldSetWrapper.fieldSetResult;
        }
        else {
            f = resolveRelationshipField(objectName, fieldArr, true);
        }
        return f;
    }

    //Pass Object Name and the method returns the list of Field Names
    public static List<String> getFieldNameList(String objectName){
        if(objectName == null){
            return null;
        }
        SObjectWrapper wrapperInstance = SchemaManager.getSObject(objectName);
        List<String> fieldNameList = new List<String>(); 
        fieldNameList.addAll(wrapperInstance.fieldsMap.keySet());
        
        return fieldNameList;
    }


    global static Map<String, Schema.SObjectField> getFieldsMap (String objectName) {   // Dk : Spring Cleanup 7-6-16
        return null;
    }

    //Pass Object Id and the method returns the list of Field Names
    global static List<String> getFieldNameList(Id objectId){
        if(objectId == null)
        {
            return null;
        }
        SObjectWrapper wrapperInstance = SchemaManager.getSObject(objectId);
        List<String> fieldNameList = new List<String>(); 
        fieldNameList.addAll(wrapperInstance.fieldsMap.keySet());
        
        return fieldNameList;
    }
    
    /* UTILITY METHODS */
    
    global static List<String> getTextAreaFieldNames(String sObjectName) {  // Dk : Spring Cleanup 7-6-16
        return null;
    }
    
    
    /* PRIVATE METHODS */
    
    //objectName: StepReview__c, fieldArr: Campaign__r, Finance_Lead__r, Email
    private static Field resolveRelationshipField(String objectName, String[] fieldArr, Boolean isFieldSet) {
        String relationshipObjectName = objectName;
        String relationshipFieldName = null;        
        for (Integer i=0; i<fieldArr.size()-1; i++) {
            relationshipFieldName = fieldArr[i];
            if(relationshipFieldName.contains('__r')){
                relationshipFieldName = relationshipFieldName.replace('__r', '__c');
            }
            else if(relationshipFieldName.equalsIgnoreCase('Owner')) {
                relationshipFieldName ='OwnerId';                         
            } else if(relationshipFieldName.equalsIgnoreCase('CreatedBy')) {
                relationshipFieldName='CreatedById'; 
            } else if(relationshipFieldName.equalsIgnoreCase('What')) {
                relationshipFieldName ='WhatId';
            }else if(relationshipFieldName.equalsIgnoreCase('LastModifiedBy')) {
                relationshipFieldName ='LastModifiedById';                    
            }else if(relationshipFieldName.equalsIgnoreCase('Parent')) {
                relationshipFieldName ='ParentId';
            }else if(relationshipFieldName.equalsIgnoreCase('Actor')) {
                relationshipFieldName ='ActorId';
            }else if(relationshipFieldName.equalsIgnoreCase('ProcessInstance')) {
                relationshipFieldName ='ProcessInstanceId';
            }else if(relationshipFieldName.equalsIgnoreCase('SetupOwner')) {
                relationshipFieldName ='SetupOwnerId';
            }else if(relationshipFieldName.equalsIgnoreCase('Contact')) {
                relationshipFieldName ='ContactId';
            }else if(relationshipFieldName.equalsIgnoreCase('RecordType')) {
                relationshipFieldName ='RecordTypeId';
            }else{
                relationshipFieldName += 'Id';
            }                          
            Schema.DescribeFieldResult relationshipFieldDesc = getFieldSchemaResult(relationshipObjectName, relationshipFieldName).fieldDesc;            
            Schema.SObjectType parentObjType = relationshipFieldDesc.getReferenceTo().get(0);
            Schema.DescribeSObjectResult parentObjResult = getSObject(parentObjType.getDescribe().getName()).objectResult;
            relationshipObjectName = parentObjResult.getName();
        }
        relationshipFieldName = fieldArr[fieldArr.size()-1];
        
        //Validate
        if (isFieldSet == false) {
            getSObjectField(relationshipObjectName, relationshipFieldName);  //just validate
        }
        
        //Prepare the result;
        Field f = new Field(relationshipObjectName, getSObject(relationshipObjectName).objectType, relationshipFieldName, true);
        if (isFieldSet) {
            f.fieldSetDesc = getSObjectFieldSet(relationshipObjectName, relationshipFieldName).fieldSetDesc;    
        }
        else {
            f.fieldDesc = getFieldSchemaResult(relationshipObjectName, relationshipFieldName).fieldDesc;
            
        }
        return f; 
    }
    
    /* INNER CLASSES */
    
    global with sharing class SObjectWrapper {
        global String objectName; //with namespace (case sensitive)
        global Schema.DescribeSObjectResult objectResult;
        global Schema.SObjectType objectType;
        global Map<String, SObjectFieldWrapper> fieldsMap; //key->field name with namespace (lowercase)
        global Map<String, SObjectFieldSetWrapper> fieldSetsMap; //key->fieldset name with namespace (lowercase)
        
        //Input objectName should have proper namespace ALWAYS. It is the caller responsibility to pass the namespace.
        global SObjectWrapper(String objectName) {
            this.objectResult = fetchObjectResult(objectName);
            this.objectType = objectResult.getSobjectType();
            this.objectName = objectResult.getName(); //with namespace   
            setFields();
            setFieldSets();            
        }
         
        //fieldName should have proper namespace and case insensitive 
        global SObjectFieldWrapper getField(String fieldName) {
            SObjectFieldWrapper f = fieldsMap.get(fieldName.toLowerCase().trim());
            if (f == null) {
                throw new AppUtils.ValidationException('Field not defined in object. Field: ' + fieldName + ', SObject: ' + objectName);
            }
            return f;
        }

        //fieldName should have proper namespace and case insensitive 
        global SObjectFieldSetWrapper getFieldSet(String fieldSetName) {
            SObjectFieldSetWrapper f = fieldSetsMap.get(fieldSetName.toLowerCase());
            if (f == null) {
                throw new AppUtils.ValidationException('FieldSet not defined in object. FieldSet: ' + fieldSetName + ', SObject: ' + objectName);
            }
            return f;
        }
        
        //Input objectName should have proper namespace ALWAYS.  It is the caller responsibility to pass the namespace.
        public Schema.DescribeSObjectResult fetchObjectResult(String objectName) {
            String objectNameOrig = objectName;
            Schema.SObjectType objType = globalSchemaMap.get(objectName);
            if (objType == null) { //make one more attempt by explicitly removing govbd namespace 
                objectName = objectNameOrig.remove(AppUtils.getNamespacePrefix());  
                objType = globalSchemaMap.get(objectName);

                if (objType == null) { //make one more attempt by explicitly adding govbd namespace
                    objectName = AppUtils.getNamespacePrefix() + objectNameOrig;  
                    objType = globalSchemaMap.get(objectName);
                }
            }
            if (objType == null) {
                throw new AppUtils.ValidationException('SObject not defined in schema. SObject: ' + objectName);
            }
            if(objType.getDescribe().isAccessible()){
                return objType.getDescribe();
            }
            return null;
        }
        
        private void setFields() {
            this.fieldsMap = new Map<String, SObjectFieldWrapper>();
            for (Schema.SObjectField sf : objectResult.fields.getMap().values()) {
                Schema.DescribeFieldResult fieldResult = sf.getDescribe();
                this.fieldsMap.put(fieldResult.getName().toLowerCase(), new SObjectFieldWrapper(this, fieldResult));                 
            }
        }
        
        private void setFieldSets() {
            this.fieldSetsMap = new Map<String, SObjectFieldSetWrapper>();
            for (Schema.FieldSet sf : objectResult.fieldsets.getMap().values()) {
                String fieldsetName = AppUtils.getNameSpacePrefix() + sf.getName();
                this.fieldSetsMap.put(fieldsetName.toLowerCase(), new SObjectFieldSetWrapper(this, sf));                 
            }
        }
    }
    
    global with sharing class SObjectFieldWrapper {
        global String fieldName;  //with namespace (case sensitive)
        global Schema.DescribeFieldResult fieldResult;
        global SObjectWrapper objectWrapper;  //reference to it's sobject

        global SObjectFieldWrapper(SObjectWrapper objectWrapper, Schema.DescribeFieldResult fieldResult) {
            this.fieldName = fieldResult.getName();
            this.objectWrapper = objectWrapper;
            this.fieldResult = fieldResult;
        }
    }

    global with sharing class SObjectFieldSetWrapper {
        global String fieldSetName;  //with namespace (case sensitive)
        global Schema.FieldSet fieldSetResult;
        global SObjectWrapper objectWrapper;  //reference to it's sobject

        global SObjectFieldSetWrapper(SObjectWrapper objectWrapper, Schema.FieldSet fieldSetResult) {
            this.fieldSetName = fieldSetResult.getName();
            this.objectWrapper = objectWrapper;
            this.fieldSetResult = fieldSetResult;
        }
    }
    
    //This class represents either a field or field set
    global with sharing class Field {
        global String objectName;
        global SObjectType objectType;
        global String fieldName;
        global Schema.DescribeFieldResult fieldDesc;
        global Schema.FieldSet fieldSetDesc;
        global Boolean isRelationshipField;
        global Boolean isUpdatable;
        
        global Field(String objectName, SObjectType objectType, String fieldName, Boolean isRelationshipField) {
            this.objectName = objectName;
            this.objectType = objectType;
            this.fieldName = fieldName;
            this.isRelationshipField = isRelationshipField;
        }
    }

    /* OBSOLETE METHODS - DONT USE THEM */
    
    // Added following method for Security review SOQL SOSL field trim
    public static String getFields(String fields){
        List<String> fieldList = new List<String> { 'id', 'name' };
        List<String> userSuppliedFields = fields.split(',');

        for (String s : userSuppliedFields) {
            if (!fieldList.contains(s)) {
                fieldList.add(s.toLowerCase());
            }
        }
        return String.join(fieldList, ', ');
    }

    /*
	 Method : isAccessible
	 Puropose Utility methods for checking object and its field are accessible.
	 */
    public static Boolean isUpsertableSobject(sObject obj, String fields){
        String strObjType = String.valueOf(obj.getSObjectType());
        if(obj.Id == null){
            return isCreatable(strObjType, fields);
        }else{
            return isUpdatable(strObjType, fields);
        }
    }

    /*
	 Method : isAccessible
	 Puropose Utility methods for checking object and its field are accessible.
	 */
    public static Boolean isAccessible(String sObjectApiName, String fields){
		try{
			Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe();
			Map<String,Schema.SObjectField> fieldDescribeMap = sObjectDescribe.fields.getMap();
			if (sObjectDescribe.accessible && String.isNotEmpty(fields)){
				List<String> fieldsList = fields.split(',');
				for (String field : fieldsList){
                    if(!field.contains('.')){
                        if(! fieldDescribeMap.get(field).getDescribe().isAccessible()){
                            return false;
                        }
                    }else{					
                        String newFieldName = field.substring(field.lastIndexOf('.')+1); 
                        String referenceField = field.substring(0, field.lastIndexOf('.'));
                        referenceField = !referenceField.toLowerCase().endsWith('__r') ? referenceField+'Id' : referenceField.substring(0,referenceField.length()-1)+'c';
                        String referencedObj = getReferencingObjName(sObjectApiName, referenceField);
                        Boolean isReferencedObjAccessible = isAccessible(referencedObj,newFieldName);
                        if(!isReferencedObjAccessible){
                            return false;
                        }
                    }
				}
				return true;
			} else{
				return false;
			}
		} catch (Exception e){
		}
		return false;
	}

	/*
	 Method : isCreatable
	 Puropose Utility methods for checking object and its field are creatable.
	 */
	public static Boolean isCreatable(String sObjectApiName, String fields){
		try{
			List<String> fieldsList = fields.split(',');
			Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe();
			Map<String,Schema.SObjectField> fieldDescribeMap = sObjectDescribe.fields.getMap();
			if (sObjectDescribe.isCreateable()){
				for (String field : fieldsList){
                    if(!fieldDescribeMap.get(field).getDescribe().isCreateable()){
                        return false;
                    }
				}
				return true;
			} else{
				return false;
			}
		} catch (Exception e){
		}
		return false;
	}

	/*
	 Method : isUpdatable
	 Puropose Utility methods for checking object and its field are updatable.
	 */
	public static Boolean isUpdatable(String sObjectApiName, String fields){
		try{
			List<String> fieldsList = fields.split(',');
			Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe();
			Map<String,Schema.SObjectField> fieldDescribeMap = sObjectDescribe.fields.getMap();
			if (sObjectDescribe.isUpdateable()){
				for (String field : fieldsList){
                    if(! fieldDescribeMap.get(field).getDescribe().isUpdateable()){
                        return false;
                    }
				}
				return true;
			} else{
				return false;
			}
		} catch (Exception e){
		}
		return false;
	}

	/*
	 Method
	 Purpose :Method to get referenced obj
	 */
	public static String getReferencingObjName(String objectApiName, String relationField){
		if (!relationField.contains('.')){
			SObjectType sobjectDetails = Schema.getGlobalDescribe().get(objectApiName);
			Map<String, Schema.SObjectField> fieldDetailsMap = sobjectDetails.getDescribe().fields.getMap();
			List<Schema.SObjectType> references = fieldDetailsMap.get(relationField).getDescribe().getReferenceTo();
			if (references != null){
				String referencedObjs = '';
				for (Integer i = 0; i < references.size(); i++){
					if (i == references.size() - 1){
						referencedObjs += references.get(i).getDescribe().getName();
					} else{
						referencedObjs += references.get(i).getDescribe().getName() + ',';
					}
				}
				return referencedObjs;
			}
			return null;
		} else{
			SObjectType sobjectDetails = Schema.getGlobalDescribe().get(objectApiName);
			Map<String, Schema.SObjectField> fieldDetailsMap = sobjectDetails.getDescribe().fields.getMap();
			String fieldApiName = relationField.substring(0, relationField.indexOf('.')).replace('__r', '__c');
			fieldApiName = (!fieldApiName.contains('__c') ? fieldApiName + 'Id' : fieldApiName);
			String parentSobjectName = fieldDetailsMap.get(fieldApiName).getDescribe().getReferenceTo().get(0).getDescribe().getName();
			String remFieldApiString = relationField.substring(relationField.indexOf('.') + 1);
			return getReferencingObjName(parentSobjectName, remFieldApiString);
		}
	}
        
}