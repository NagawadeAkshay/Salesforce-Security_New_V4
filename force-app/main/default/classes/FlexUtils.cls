global with sharing class FlexUtils {
    public static String ns = AppUtils.getNamespacePrefix();
    // Pankaj : bulkified method

    /*
       Method : This Method used to get Form Percentage Based on Layout Package Id and Record Id
       Parameter : Package Id and Record Id.
    */
    global static Map<String, FormCompletionDTO> getLayoutCompletion(Id recordId, String packageId){
        return getLayoutCompletion(recordId, packageId, null);
    }
    
    // get no of fields populated which are required for save and required for submit.
    //in this method we will have query per object. Example- If form are present for Form1__c, Form2__c and Application__c
    //object then there will be 3 SOQL queries.
    global static Map<String, FormCompletionDTO> getLayoutCompletion(Id recordId, String packageId, List<String> formTypes){
        return getLayoutCompletion(recordId, packageId, formTypes, null);
    }
    global static Map<String, FormCompletionDTO> getLayoutCompletion(Id recordId, String packageId, List<String> formTypes, String formId){
        Package__c packageObj;
        if(Schema.sObjectType.Package__c.isAccessible()){
            if(formTypes != null) {
                packageObj = [SELECT Id, Name, (SELECT isMandatory__c, FormConfig__r.ViewLayoutConfig__c, FormConfig__r.Status__c,Order__c,
                            FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c, FormConfig__r.OMBExpiration__c, FormConfig__r.EditLayoutConfig__c, 
                            FormConfig__r.Name, FormConfig__r.DisplayName__c ,FormConfig__r.OMBNumber__c
                            FROM PackageFormsConfig__r where FormConfig__r.FormType__c in:formTypes and FormConfig__c!=null order By Order__c )  FROM Package__c WHERE id =: packageId WITH USER_MODE LIMIT 1];
            } else if(formId !=null) {
                packageObj = [SELECT Id, Name, (SELECT isMandatory__c, FormConfig__r.ViewLayoutConfig__c, FormConfig__r.Status__c,Order__c,
                            FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c, FormConfig__r.OMBExpiration__c, FormConfig__r.EditLayoutConfig__c, 
                            FormConfig__r.Name, FormConfig__r.DisplayName__c ,FormConfig__r.OMBNumber__c
                            FROM PackageFormsConfig__r where FormConfig__c =:formId  order By Order__c )  FROM Package__c WHERE id =: packageId WITH USER_MODE LIMIT 1];
            } else {
                packageObj = [SELECT Id, Name, (SELECT isMandatory__c, FormConfig__r.ViewLayoutConfig__c, FormConfig__r.Status__c,Order__c,
                            FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c, FormConfig__r.OMBExpiration__c, FormConfig__r.EditLayoutConfig__c, 
                            FormConfig__r.Name, FormConfig__r.DisplayName__c ,FormConfig__r.OMBNumber__c
                            FROM PackageFormsConfig__r Where FormConfig__c!=null order By Order__c )   FROM Package__c WHERE id =: packageId WITH USER_MODE LIMIT 1];
            }
        }
        List<String> pageLayouts = new List<String>();
        Map<String,PackageFormConfig__c> SobjNameTopackageForm = new Map<String,PackageFormConfig__c>();
        Map<String,List<String>> SobjNameTopageLayout = new Map<String,List<String>>();
        for(PackageFormConfig__c packageForm: packageObj.PackageFormsConfig__r) {
            pageLayouts.add(packageForm.FormConfig__r.ViewLayoutConfig__c);
            if( SobjNameTopageLayout.get(packageForm.FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c) == null){
                SobjNameTopageLayout.put(packageForm.FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c, new List<String>() );
            }
            SobjNameTopageLayout.get(packageForm.FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c).add(packageForm.FormConfig__r.ViewLayoutConfig__c);
            SobjNameTopackageForm.put(packageForm.FormConfig__r.ViewLayoutConfig__c,packageForm);

        }
        
        return getLayoutCompletionDetails(pageLayouts, recordId, SobjNameTopackageForm, SobjNameTopageLayout);
       }
       
    
    /*
      Method : This Method Provide Query Result based on Sobject Details
      Parameters : Field Set , sObject Api Name, record Id and Parent Id
    */
    private static List<SObject> getSObjectList(Set<String> fieldSet, String objectAPIName, String recordId, String parentObjectAPIName, String conditionObjectAPIName){
        String query = ' select ';
        fieldSet.add('id');
        for(String fieldAPI : fieldSet){
            query += string.escapeSingleQuotes(fieldAPI)+', ';
        }
        query = query.subString(0, query.length()-2);
        if(objectAPIName.equalsIgnoreCase(parentObjectAPIName)){
            query+= ' from '+ string.escapeSingleQuotes(objectAPIName) + ' where Id=\''+ string.escapeSingleQuotes(recordId) +'\'';
        } else {
            query+= ' from '+ string.escapeSingleQuotes(objectAPIName) + ' where '+ string.escapeSingleQuotes(conditionObjectAPIName) +'=\''+ string.escapeSingleQuotes(recordId) +'\'';
        }
        return Database.query(query, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
    }
    
    /*
       Methods : This Method Perform Actual Calculation of Fields which is Reqiured for Submit or Save and return value in Percentage
       Parameter  :  LayoutMap of related sobj , PageBlockDetails Map contians Fields in Layout, packageForm Details optional. 
    */
    private static Map<String, FormCompletionDTO> getLayoutCompletion(Map<String, SObject> layoutToSObj, Map<String, List<PageBlockDetailConfig__c>> layoutToPageBlockMap, Map<String, PackageFormConfig__c> SobjNameTopackageForm){
        Map<String, FormCompletionDTO> returnMap = new Map<String, FormCompletionDTO>(); 
        for(String layoutId : layoutToPageBlockMap.keySet()){
            if(SobjNameTopackageForm !=null){
            returnMap.put(layoutId, new FormCompletionDTO(layoutId,0,0,0,null,SobjNameTopackageForm.get(layoutId)) );
            }else{
              returnMap.put(layoutId, new FormCompletionDTO(layoutId,0,0,0,null));
            }
            if( layoutToSObj.containsKey(layoutId) ){
                Set<String> saveFieldSet = new Set<String>();
                Set<String> submitFieldSet = new Set<String>();
                List<String> totalFieldSet = new List<String>();
                
                for(PageBlockDetailConfig__c field : layoutToPageBlockMap.get(layoutId)) {
                    if( field.FieldAPIName__c != null && !field.FieldAPIName__c.contains('.') ){
                        if(field.fieldAPIName__c !='null' ){
                            totalFieldSet.add(field.fieldAPIName__c);
                        }               
                        if(field.RequiredBehavior__c == 'Required for Submit') {
                            //saveFieldSet.add(field.fieldAPIName__c);
                            submitFieldSet.add(field.fieldAPIName__c);
                        } else if (field.RequiredBehavior__c == 'Required for Save') {
                            saveFieldSet.add(field.fieldAPIName__c);
                            submitFieldSet.add(field.fieldAPIName__c);
                        }
                    }
                }
                SObject sobj = layoutToSObj.get(layoutId);
                Double saveFields = 0;
                Double submitFields = 0;
                Double totalFields = 0;
                String recordId = null;
                if(sobj != null) {
                    recordId = (String)sobj.get('Id');
                    for(String field : totalFieldSet) {
                        if(sobj.get(field.removeStart(ns)) != null && sobj.get(field.removeStart(ns)) != '') {
                            totalFields++;
                            if(saveFieldSet.contains(field)) {
                                saveFields++;
                            }
                            if (submitFieldSet.contains(field)) {
                                submitFields++;
                                saveFields++;
                            } 
                        }
                    }
                }
                
                /* Dk - 4/13/16 - Reason : Shows 0% even there is no required for submit field
                Decimal totalPercent = (totalFieldSet.size() > 0) ? 100*totalFields/totalFieldSet.size() : 0;
                Decimal savePercent = (saveFieldSet.size() > 0) ? 100*saveFields/saveFieldSet.size() : 0; 
                Decimal submitPercent = (submitFieldSet.size() > 0) ? 100*submitFields/submitFieldSet.size() : 0;
                */
                Decimal totalPercent = (totalFieldSet.size() > 0) ? 100*totalFields/totalFieldSet.size() : 100;
                Decimal savePercent = (saveFieldSet.size() > 0) ? 100*saveFields/saveFieldSet.size() : 100; 
                Decimal submitPercent = (submitFieldSet.size() > 0) ? 100*submitFields/submitFieldSet.size() : 100;
                
                
                if(SobjNameTopackageForm !=null){
                returnMap.put(layoutId, new FormCompletionDTO(layoutId, savePercent, submitPercent, totalPercent, recordId, SobjNameTopackageForm.get(layoutId)));
                }else{
                  returnMap.put(layoutId, new FormCompletionDTO(layoutId, savePercent, submitPercent, totalPercent, recordId));
                }
            }
        }
        return returnMap;
    }
    
    /*
      Method : To Chk for Id Present in Form Instance Record
    */
    private static Boolean checkforRecordIdInFormInstance(String recId){
       Boolean isRecordIdVal = false; 
       List<FormInstance__c> fcInstance = new List<FormInstance__c>();
       if(Schema.sObjectType.FormInstance__c.isAccessible()){
       fcInstance = [SELECT Id, FormId__c FROM FormInstance__c Where FormId__c=:recId WITH USER_MODE];
       }
       if(fcInstance.size() > 0){
          isRecordIdVal = true;
       }
       return  isRecordIdVal;
    }
    
    /*
       Method : To Calculate Form Percentage on Bases of Form Id for Form Instances Record.
       Parameter : RecordId and FormId.
    */
    global static Map<String, FormCompletionDTO> getLayoutCompletionOnFormId(Id recordId, String formId){
        List<FormInstance__c> formInstanceObj = new List<FormInstance__c>();
        Id idVal;
        String packId;
        String frmType;
        Id frmId;
        Map<String, FormCompletionDTO> returnMap = new Map<String, FormCompletionDTO>(); 
        Boolean chkFrmVal = checkforRecordIdInFormInstance(recordId);
        if(recordId !=null && formId !=null && chkFrmVal){
            if(Schema.sObjectType.FormInstance__c.isAccessible()){
            formInstanceObj = [Select PackageBusinessForm__r.PackageConfig__c, PackageBusinessForm__r.FormConfig__r.FormType__c, PackageBusinessForm__r.FormConfig__c, FormId__c FROM FormInstance__c WHERE FormId__c =:recordId WITH USER_MODE];
            }
        }
        if(formInstanceObj.size() > 0){
            idVal = (Id) formInstanceObj[0].FormId__c;
            packId = (String) formInstanceObj[0].PackageBusinessForm__r.PackageConfig__c;
            frmType = formInstanceObj[0].PackageBusinessForm__r.FormConfig__r.FormType__c;
            frmId = (Id) formInstanceObj[0].PackageBusinessForm__r.FormConfig__c;
            if(idVal !=null && packId !=null && frmId !=null){
               returnMap =  getLayoutCompletion(idVal, packId, null, frmId);
            }
        }
        
        return returnMap;
    }
    

     /*
       Method : This Method is used for Calculating form Percentage based on Layout Id.
       Parameter : RecordId and LayoutId.
     */
     global static Map<String, FormCompletionDTO> getLayoutCompletionByLayoutId(Id recordId, String layoutId){
        //change id to 18 digit
        layoutId = String.valueOf(Id.valueOf(layoutId));
        Map<String, FormCompletionDTO> returnMap = new Map<String, FormCompletionDTO>();
        List<String> layoutIdLst = new List<String>();
        layoutIdLst.add(layoutId); 
        if(recordId != null && layoutIdLst.size() > 0){
           returnMap = getLayoutCompletionWithoutSobjNameTopageLayout(layoutIdLst, recordId, null);   
        } 
        return returnMap; 
     }

      /* 
         Method : This Method to provide Object Api Name based on Layout Id
      */
      private static String getLayoutObjAPI(String layoutId){
           String layoutObjApi = '';
           List<PackageFormConfig__c> packageFormObj = new List<PackageFormConfig__c>();
           if(!String.isEmpty(layoutId)){
            if(Schema.sObjectType.PackageFormConfig__c.isAccessible()){
               packageFormObj = [SELECT FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c
                             FROM PackageFormConfig__c WHERE FormConfig__r.ViewLayoutConfig__c =:layoutId WITH USER_MODE]; 
            }
           } 
           if(packageFormObj.size() > 0){
             layoutObjApi = packageFormObj[0].FormConfig__r.ViewLayoutConfig__r.ObjectAPIName__c;
           }
           return layoutObjApi;
     }

     /*
        Method : This Method provided with common code for Layout Completion on bases of layotId and recordId and SobjNameTopageLayout 
     */
     private static Map<String, FormCompletionDTO> getLayoutCompletionDetails(List<String> pageLayouts, Id recordId,  Map<String,PackageFormConfig__c> sobjNameTopackageForm, Map<String,List<String>> SobjNameTopageLayout){ 
         Map<String, SObject> layoutToSObj = new Map<String, SObject>();
         // Page layout to associated fields for that layout
         Map<String, List<PageBlockDetailConfig__c>> pageBlockMap = new Map<String, List<PageBlockDetailConfig__c>>();
          if(recordId !=null && pageLayouts.size() > 0){
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                PageBlockConfig__c[] pbs = [SELECT Id,TabLayoutConfig__r.PageLayoutConfig__r.Name,(SELECT FieldAPIName__c, RequiredBehavior__c, PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.Name
                FROM PageBlockFieldConfig__r where IsActive__c = true and ReadOnly__c!=true and FieldAPIName__c!=null) from PageBlockConfig__c
                WHERE TabLayoutConfig__r.PageLayoutConfig__c in: pageLayouts and TabLayoutConfig__r.IsActive__c=true and IsActive__c=true WITH USER_MODE];
               
               for(PageBlockConfig__c pb : pbs){
                    if(pageBlockMap.get(pb.TabLayoutConfig__r.PageLayoutConfig__c) == null ) {
                        pageBlockMap.put(pb.TabLayoutConfig__r.PageLayoutConfig__c, new List<PageBlockDetailConfig__c>() );
                    }
                    for(PageBlockDetailConfig__c pbd : pb.PageBlockFieldConfig__r){
                        if(pbd.FieldAPIName__c != null && !pbd.FieldAPIName__c.contains('.')) {
                            pageBlockMap.get(pbd.PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__c).add( pbd );
                        }
                    }
               }
            }
               String parentObjectAPIName = ( (Id)recordId).getSobjectType().getDescribe().getName();
               // Condition to check for SobjNameTopageLayout null
               if(SobjNameTopageLayout != null){
                    for( String objectAPIName : SobjNameTopageLayout.keySet()){
                        Set<String> fieldSet = new Set<String>();
                        for(String layoutId : SobjNameTopageLayout.get(objectAPIName)){
                            if( pageBlockMap.get(layoutId) != null ){
                                for(PageBlockDetailConfig__c pbd : pageBlockMap.get(layoutId)) {
                                    if( pbd.FieldAPIName__c != null && !pbd.FieldAPIName__c.contains('.') ){
                                        fieldSet.add(pbd.FieldAPIName__c.toLowerCase());
                                    }
                                }
                            }
                        }
                        String packageReferenceFieldAPIName = '';
                        String parentObjectFieldAPIName = '';
                        if(!objectAPIName.equalsIgnoreCase(parentObjectAPIName) ){
                            SObjectType parentSObjType = Schema.getGlobalDescribe().get(objectAPIName);
                            if(parentSObjType !=null){
                                    Map<String, Schema.SObjectField> mfields = parentSObjType.getDescribe().fields.getMap();
                                    String conditionObjectAPIName = '';
                                    for(Schema.SObjectField sObjField : mfields.values()){
                                        Schema.DescribeFieldResult fldDesc = sObjField.getDescribe();
                                        if( fldDesc.getType().name() == 'REFERENCE') {
                                            if( ( (fldDesc.getReferenceTo()[0]).getDescribe().getName()) == parentObjectAPIName){
                                                parentObjectFieldAPIName = fldDesc.getName();
                                            } else if( (fldDesc.getReferenceTo()[0]).getDescribe().getName() == ns+'PageTemplate__c'){
                                                packageReferenceFieldAPIName = fldDesc.getName();
                                            }
                                        }
                                    }
                                    if(packageReferenceFieldAPIName != null && packageReferenceFieldAPIName != ''){
                                        fieldSet.add(packageReferenceFieldAPIName.toLowercase());
                                        fieldSet.add(packageReferenceFieldAPIName.toLowercase().replaceAll('__c','__r')+'.ViewLayoutConfig__c');
                                    }   
                            }
                        }
                        List<SObject> sObjs = getSObjectList(fieldSet, objectAPIName, recordId, parentObjectAPIName, parentObjectFieldAPIName);
                        if(objectAPIName.equalsIgnoreCase(parentObjectAPIName)){
                            for(String layoutId : SobjNameTopageLayout.get(objectAPIName)){
                                layoutToSObj.put(layoutId, sObjs[0]);
                            }
                        } else {
                            for(SObject sobj: sobjs) {
                                if( sobj.get(packageReferenceFieldAPIName) != null ) {
                                    PageTemplate__c pageTemplate = (PageTemplate__c)sobj.getSObject(packageReferenceFieldAPIName.replaceAll('__c','__r'));
                                    layoutToSObj.put(pageTemplate.ViewLayoutConfig__c, SObj);
                                }
                            }  
                        }  
                   }  
               }
          }
          return getLayoutCompletion(layoutToSObj, pageBlockMap, sobjNameTopackageForm); 
     }

    /*
        Method : This Method provided with common code for Layout Completion on bases of layotId and recordId 
     */
    private static Map<String, FormCompletionDTO> getLayoutCompletionWithoutSobjNameTopageLayout(List<String> pageLayouts, Id recordId,  Map<String,PackageFormConfig__c> sobjNameTopackageForm){
        Map<String, SObject> layoutToSObj = new Map<String, SObject>();
         // Page layout to associated fields for that layout
        Map<String, List<PageBlockDetailConfig__c>> pageBlockMap = new Map<String, List<PageBlockDetailConfig__c>>();
        if(recordId !=null && pageLayouts.size() > 0){
            String parentObjectAPIName = ( (Id)recordId).getSobjectType().getDescribe().getName();
             String objectAPIName = getLayoutObjAPI(pageLayouts[0]); 
             Set<String> fieldSet = new Set<String>();
             if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
             PageBlockConfig__c[] pbs = [SELECT Id,TabLayoutConfig__r.PageLayoutConfig__r.Name,(SELECT FieldAPIName__c, RequiredBehavior__c, PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.Name
                    FROM PageBlockFieldConfig__r where IsActive__c = true and ReadOnly__c!=true and FieldAPIName__c!=null) from PageBlockConfig__c
                    WHERE TabLayoutConfig__r.PageLayoutConfig__c in: pageLayouts and TabLayoutConfig__r.IsActive__c=true and IsActive__c=true WITH USER_MODE];
                   
                   for(PageBlockConfig__c pb : pbs){
                        if(pageBlockMap.get(pb.TabLayoutConfig__r.PageLayoutConfig__c) == null ) {
                            pageBlockMap.put(pb.TabLayoutConfig__r.PageLayoutConfig__c, new List<PageBlockDetailConfig__c>() );
                        }
                        for(PageBlockDetailConfig__c pbd : pb.PageBlockFieldConfig__r){
                            if(pbd.FieldAPIName__c != null && !pbd.FieldAPIName__c.contains('.')) {
                                pageBlockMap.get(pbd.PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__c).add( pbd );
                            }
                        }
                   }
               if( pageBlockMap.get(pageLayouts[0]) != null ){
                    for(PageBlockDetailConfig__c pbd : pageBlockMap.get(pageLayouts[0])) {
                        if( pbd.FieldAPIName__c != null && !pbd.FieldAPIName__c.contains('.') ){
                            fieldSet.add(pbd.FieldAPIName__c.toLowerCase());
                        }
                    }
                }
            }
            String packageReferenceFieldAPIName = '';
            String parentObjectFieldAPIName = '';
            if(!String.isEmpty(objectAPIName)){
                if(!objectAPIName.equalsIgnoreCase(parentObjectAPIName) ){
                    SObjectType parentSObjType = Schema.getGlobalDescribe().get(objectAPIName);
                    if(parentSObjType !=null){
                            Map<String, Schema.SObjectField> mfields = parentSObjType.getDescribe().fields.getMap();
                            String conditionObjectAPIName = '';
                            for(Schema.SObjectField sObjField : mfields.values()){
                                Schema.DescribeFieldResult fldDesc = sObjField.getDescribe();
                                if( fldDesc.getType().name() == 'REFERENCE') {
                                    if( ( (fldDesc.getReferenceTo()[0]).getDescribe().getName()) == parentObjectAPIName){
                                        parentObjectFieldAPIName = fldDesc.getName();
                                    } else if( (fldDesc.getReferenceTo()[0]).getDescribe().getName() == ns+'PageTemplate__c'){
                                        packageReferenceFieldAPIName = fldDesc.getName();
                                    }
                                }
                            }
                            if(packageReferenceFieldAPIName != null && packageReferenceFieldAPIName != ''){
                                fieldSet.add(packageReferenceFieldAPIName.toLowercase());
                                fieldSet.add(packageReferenceFieldAPIName.toLowercase().replaceAll('__c','__r')+'.ViewLayoutConfig__c');
                            }   
                    }
                }
                List<SObject> sObjs = getSObjectList(fieldSet, objectAPIName, recordId, parentObjectAPIName, parentObjectFieldAPIName); 
                if(objectAPIName.equalsIgnoreCase(parentObjectAPIName)){
                    layoutToSObj.put(pageLayouts[0], sObjs[0]);
                } else {
                    for(SObject sobj: sobjs) {
                        if( sobj.get(packageReferenceFieldAPIName) != null ) {
                            PageTemplate__c pageTemplate = (PageTemplate__c)sobj.getSObject(packageReferenceFieldAPIName.replaceAll('__c','__r'));
                            layoutToSObj.put(pageTemplate.ViewLayoutConfig__c, SObj);
                        }
                        //layoutToSObj.put((String)sobj.get(packageReferenceFieldAPIName), SObj);
                    }  
                }                                          
            }
        }
        return getLayoutCompletion(layoutToSObj, pageBlockMap, sobjNameTopackageForm);  
    } 


    // Inner Wrapper Class For Calculation Form Field and return result in Percentage.
    global with sharing class FormCompletionDTO{
        global String layoutId;
        global Decimal savePercentage;
        global Decimal submitPercentage;
        global Decimal totalPercentage;
        global String recordId;
        global PackageFormConfig__c packageForm;
        global FormCompletionDTO(String layoutId, Decimal savePercentage, Decimal submitPercentage, Decimal totalPercentage, String recordId){
            this.layoutId = layoutId;
            this.savePercentage = savePercentage;
            this.submitPercentage = submitPercentage;
            this.totalPercentage = totalPercentage;
            this.recordId = recordId;
           
        }
       global FormCompletionDTO(String layoutId, Decimal savePercentage, Decimal submitPercentage, Decimal totalPercentage, String recordId, PackageFormConfig__c packageForm){
            this.layoutId = layoutId;
            this.savePercentage = savePercentage;
            this.submitPercentage = submitPercentage;
            this.totalPercentage = totalPercentage;
            this.recordId = recordId;
            this.packageForm = packageForm;
       }
    } 
}