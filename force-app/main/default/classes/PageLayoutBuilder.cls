global with sharing class PageLayoutBuilder{
    public String pageLayoutId;
    public Boolean isNewLayout;

    @RemoteAction    
    global static Map<String,Object> saveLayout(String formConfig){
        Map<String,Object> retVal = new Map<String,Object>();                
        retVal = PageLayoutBuilderHelper.saveLayout(formConfig);               
        return retVal;    
    } 

    @RemoteAction    
    global static Map<String,Object> getSetupInfo(Map<String,Object> params){
        Map<String,Object> retVal = new Map<String,Object>();        
        String sobjectConfigId = (String)params.get('SobjectConfigId');
        String pageLayoutId = (String)params.get('PageLayoutId');
        if(sobjectConfigId != null && sobjectConfigId != ''){
            PageLayoutBuilder plb = new PageLayoutBuilder();
            retVal.putAll(plb.getSobjectInfo(sobjectConfigId,params));     
        }else if(pageLayoutId != null && pageLayoutId != ''){
            PageLayoutBuilder plb = new PageLayoutBuilder();
            List<PageLayoutConfig__c> plc = new List<PageLayoutConfig__c>();
            if(Schema.sObjectType.PageLayoutConfig__c.isAccessible()){
            plc = [SELECT Id,SobjectConfig__c FROM PageLayoutConfig__c WHERE Id =:pageLayoutId WITH USER_MODE];
            }
            retVal.putAll(plb.getSobjectInfo(plc[0].SobjectConfig__c,params));     
        }else{
            retVal.put('Error','Sobject config Id not found in URL.');
        }
        return retVal;    
    }
    public Map<String,Object> getSobjectInfo(String sobjectConfigId,Map<String,Object> params){
        Map<String,Object> retVal = new Map<String,Object>(); 
        List<SobjectConfig__c> sobjectConfigList = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
        sobjectConfigList = [SELECT Id,Name FROM SobjectConfig__c WHERE Id = :sobjectConfigId WITH USER_MODE];      
        }    
        if(!sobjectConfigList.isEmpty()){
            SobjectConfig__c sobjectConfig = sobjectConfigList[0];
            retVal.put('SobjectConfig',sobjectConfig);                
            retVal.putAll(getAvailableFields(sobjectConfig.Name,null,0));          
            isNewLayout = true;           
            if((String)params.get('PageLayoutId') != null){
                isNewLayout = false;
                pageLayoutId = (String)params.get('PageLayoutId');
                retVal.putAll(getPageLayoutInfo(pageLayoutId));  
            }
            retVal.put('IsNewLayout',isNewLayout);
        }else{
            retVal.put('Error','Sobject config record not found for Id specified in URL.');
        }
        return retVal;
    }
    public Map<String,Object> getPageLayoutInfo(String pageLayoutId){
        Map<String,Object> retVal = new Map<String,Object>(); 
        PageLayoutConfigHelper pageLayoutConfigHelper = new PageLayoutConfigHelper(pageLayoutId,true);
        List<String> layoutIds = new List<String>{pageLayoutId};       
        pageLayoutConfigHelper.loadData(layoutIds,true,true,true,null,true,null);        
        retVal.put('Layout', pageLayoutConfigHelper.layout);        
        return retVal;
    }
    public void processBusinessFields(Schema.FieldSet fieldSet,String relationshipName,Integer level,
                                        Map<String,Schema.SObjectField> describeFieldResultMap,
                                        Map<String,Object> retVal){
        
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
        List<PageLayoutBuilderHelper.Field> availableFields = new List<PageLayoutBuilderHelper.Field>();
        Map<String,Integer> availableFieldsIndexMap = new Map<String,Integer>();
        Map<String,PageLayoutBuilderHelper.FieldDescribe> describeMap = new Map<String,PageLayoutBuilderHelper.FieldDescribe>();
        //Integer index = 0;
        for(Schema.FieldSetMember f : fieldSetMembers){
            PageLayoutBuilderHelper.Field field = new PageLayoutBuilderHelper.Field();
            field.fieldAPIName = relationshipName == null? f.getFieldPath() : relationshipName + '.' + f.getFieldPath() ;
            field.fieldLabel = f.getLabel();
            field.dataType = f.getType()+'';
            field.level = level;
            availableFields.add(field);
            //availableFieldsIndexMap.put(field.fieldAPIName,index++);

            Schema.DescribeFieldResult dfr = describeFieldResultMap.get(f.getFieldPath()).getDescribe();
            PageLayoutBuilderHelper.FieldDescribe fd = new PageLayoutBuilderHelper.FieldDescribe();
            if(dfr.isNamePointing() == false && field.dataType == 'REFERENCE'){
                fd.referenceTo = dfr.getReferenceTo().get(0) + '';
                String relationship = field.fieldAPIName.substringBeforeLast('.');
                fd.relationshipName =  relationshipName == null 
                                            ? dfr.getRelationshipName() + ''
                                            : relationshipName + '.' + dfr.getRelationshipName() + '';
                describeMap.put(field.fieldAPIName,fd);
                field.describeInfo = fd;
            }
        }
        retVal.put('AvailableFields',availableFields);
        retVal.put('DescribeMap',describeMap);
    }
    public void processAllFields(Map<String,Schema.SObjectField> describeFieldResultMap,String relationshipName,Integer level,
                                        Map<String,Object> retVal){
        List<PageLayoutBuilderHelper.Field> availableFields = new List<PageLayoutBuilderHelper.Field>();
        Map<String,PageLayoutBuilderHelper.FieldDescribe> describeMap = new Map<String,PageLayoutBuilderHelper.FieldDescribe>();

        for(Schema.SObjectField f : describeFieldResultMap.values()){
            Schema.DescribeFieldResult dfr = f.getDescribe();
            PageLayoutBuilderHelper.Field field = new PageLayoutBuilderHelper.Field();
            field.fieldAPIName = relationshipName == null? dfr.getName() : relationshipName + '.' + dfr.getName() ;
            field.fieldLabel = dfr.getLabel();
            field.dataType = dfr.getType()+'';
            field.level = level;
            availableFields.add(field);
            //availableFieldsIndexMap.put(field.fieldAPIName,index++);

            
            PageLayoutBuilderHelper.FieldDescribe fd = new PageLayoutBuilderHelper.FieldDescribe();
            if(dfr.isNamePointing() == false && field.dataType == 'REFERENCE'){
                fd.referenceTo = dfr.getReferenceTo().get(0) + '';
                String relationship = field.fieldAPIName.substringBeforeLast('.');
                fd.relationshipName =  relationshipName == null 
                                            ? dfr.getRelationshipName() + ''
                                            : relationshipName + '.' + dfr.getRelationshipName() + '';
                describeMap.put(field.fieldAPIName,fd);
                field.describeInfo = fd;
            }
        }
        retVal.put('AvailableFields',availableFields);        
        retVal.put('DescribeMap',describeMap);

    }
    public Map<String,Object> getAvailableFields(String sobjectName, String relationshipName, Integer level){
        Map<String,Object> retVal = new Map<String,Object>();
        
        
        List<Schema.DescribeSobjectResult> descSobjResults = Schema.describeSObjects(new String[]{sobjectName});
        Schema.DescribeSobjectResult sobjConfigDescResult = descSobjResults[0];
        // I think field sets should be fetched via configuration.
        
        Schema.FieldSet fieldSet = sobjConfigDescResult.fieldSets.getMap().get(AppUtils.getNamespacePrefix() +  'businessfields');
        Map<String,Schema.SObjectField> describeFieldResultMap = sobjConfigDescResult.fields.getMap();
        if(fieldSet != null){
            processBusinessFields(fieldSet,relationshipName,level,describeFieldResultMap,retVal);
        }else{
            processAllFields(describeFieldResultMap,relationshipName,level,retVal);   
        }
        return retVal;
    }

    @RemoteAction    
    global static Map<String,Object> getFields(String paramsString){
        Map<String,Object> retVal = new Map<String,Object>();
        Map<String,Object> paramsMap = (Map<String,Object>)JSON.deserializeUntyped(paramsString) ;  
        String sobjectName = (String)paramsMap.get('referenceTo');
        String relationshipName = (String)paramsMap.get('relationshipName');
        Integer level = (Integer)paramsMap.get('level');
        PageLayoutBuilder plb = new PageLayoutBuilder();                
        retVal = plb.getAvailableFields(sobjectName,relationshipName,level);               
        return retVal;    
    } 
    
    @TestVisible 
     public with sharing class PageWrapper{
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
         

        public PageWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
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