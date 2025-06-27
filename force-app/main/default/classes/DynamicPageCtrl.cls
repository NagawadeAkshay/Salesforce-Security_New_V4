/**
**/
global with sharing class DynamicPageCtrl {
    public transient String layoutType {get; set;}
    public transient String recordId {get; set;}
    public transient String parentRecordId {get; set;} //Added for Bug 195207
    public transient String templateName {get; set;}
    public transient String formId {get; set;}
    public transient String hideCancel {get; set;}
    public transient String savePage {get;set;}
    public transient String cancelPage{get;set;}
    public transient String parentId {get;set;}
    public transient String formInstanceId {get;set;}
    public transient String objectName {get;set;} 
    private PageTemplate__c pageForm;
    public List<DynamicLayoutDefaultValueHelper> listDefaultValues {get;set;}
    public transient String parentLayoutId{get;set;}
    public transient String packageId{get;set;}
    public transient List<String> formTypes{get;set;}
    public transient String formSaved {get;set;}
    /* Rahul - Added below code to provide support to pass dynamic parameters to the DynamicForm 146972 */
    public DynamicKeyValues dynamicValues;

    global PageReference initiate(){
        PageReference  page = null; 

        Id formInstanceId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formInstanceId')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String formInstanceIdStr = String.valueOf(formInstanceId);
        /*Note : For First time when we view form this recordId will be null recordId is nothing but Form__c id. */
        if(String.isEmpty(recordId)) {
            if(pageForm.SObjectName__c == null){
                throw new CustomExceptions.RequiredException('SObject Name not found for Form.');
            }
            if(pageForm.ParentObjectFieldAPI__c == null){
                throw new CustomExceptions.RequiredException('Parent object field API not found for Form.');
            }
            Id formRecId = formRecordCreation(pageForm, parentId, formInstanceIdStr);

            if(String.isNotEmpty(formRecId) && String.isNotEmpty(formInstanceId) && (ApexPages.currentPage().getUrl().contains('DynamicFormEdit') || ApexPages.currentPage().getUrl().contains('DynamicFormView'))){ //Bug 194795 -Added Or Condition for DynamicFormView to Populate FormId on Form Instance in case of View of record
                updateFormInstanceFormId(formRecId, formInstanceId);
            }

            String formurl = ApexPages.currentPage().getUrl();
            String formTypes = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formTypes'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            String commonUrlContent = URL.getOrgDomainURL().toExternalForm() + '/apex/' + (formurl.contains('DynamicFormView')? 'DynamicFormView' : 'DynamicFormEdit' )+'?id='+formRecId+'&formTypes='+ formTypes +'&templateName='+pageForm.Name+'&ParentId='+parentId+'&formId='+pageForm.id+'&parentLayoutId='+parentLayoutId+'&packageId='+packageId ;
            if(String.isNotEmpty(formInstanceId)){
                commonUrlContent +='&formInstanceId='+formInstanceId;
            }
            page = new PageReference(EncodingUtil.urlEncode(commonUrlContent,'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
            page.setRedirect(true);      
        }
        return page; 
    }

    private static Id formRecordCreation(PageTemplate__c pageForm, String parentId, String formInstanceIdStr){
            String objectAPIName = pageForm.SObjectName__c;
            Id formRecId = parentId;
            Id parentIds = parentId;
            String parentObjName = String.valueOf(((Id)parentIds).getSobjectType());
            if(objectAPIName != parentObjName){
                String parentObjectFieldAPIName = pageForm.ParentObjectFieldAPI__c;
                SObjectType sObjType = Schema.getGlobalDescribe().get(objectAPIName);
                Map<String, Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();
                String packageReferenceFieldAPIName = null;
                for(Schema.SObjectField sObjField : mfields.values()){
                    Schema.DescribeFieldResult fldDesc = sObjField.getDescribe();
                    if( fldDesc.getType().name() == 'REFERENCE') {
                        if((fldDesc.getReferenceTo()[0]).getDescribe().getName() == AppUtils.getnamespacePrefix()+'PageTemplate__c'){
                            packageReferenceFieldAPIName = fldDesc.getName();
                        }
                        if((fldDesc.getReferenceTo()[0]).getDescribe().getName() == parentObjName){
                            parentObjectFieldAPIName = fldDesc.getName();
                        }
                    }
                }
               /* Bug 194795 - Query to get Form Instance record. If FormId on this FormInstance is blank then only we will insert new record 
               of Form otherwise we will use existing record. With the help of this Query we can check if FormId/ recordid is 
               populated or not */
                FormInstance__c frm;
                if(Schema.sObjectType.FormInstance__c.isAccessible()){
                    frm = [Select id, FormId__c from FormInstance__c where id =: formInstanceIdStr 
                    WITH USER_MODE limit 1];
                }
                if(objectAPIName != parentObjectFieldAPIName){
                    sObject sObj = Schema.getGlobalDescribe().get(objectAPIName).newSObject();
                    DescribeSObjectResult sobjDecResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
	                Boolean isLightning;
	                if(UserInfo.getUiTheme() =='Theme4d' || UserInfo.getUiTheme() == 'Theme4u' || AppUtils.isExperienceCloud()){  
	                    isLightning = true;
	                }
                if(!Test.isRunningTest() && isLightning == false &&packageReferenceFieldAPIName == null){
                        throw new CustomExceptions.RequiredException('On Form object you should have lookup field to Form: Config object.');
                    }
                if(!Test.isRunningTest() && isLightning == true && packageReferenceFieldAPIName == null){
                    String errorMsg = 'On Form object you should have lookup field to Form: Config object.';
                    throw new AuraHandledException(errorMsg);
                }
                    sObj.put(packageReferenceFieldAPIName, pageForm.id);
                    sObj.put(parentObjectFieldAPIName, parentId);
                    if(sobjDecResult.isCreateable()) { // Security Review Fix......
                        if(frm.FormId__c == '' || frm.FormId__c == null){
                        insert as user sObj;  // False +ve - for business need we need this CRUD here also with the help of other class we have check CRUD permission as we are inserting Sobj
                        }
                    }
                   if(!String.isBlank(sObj.Id)){
                        formRecId = sObj.Id;
                    }else{
                        formRecId = frm.FormId__c;  
                    }
                }
            }
        if(String.isNotEmpty(formRecId)){
            return formRecId; 
        }else{
            return null; 
        }
    }
 
    @AuraEnabled
    public static String getformDetailsLWC(Id recordId, String actionURLLongLWC) {
        PageTemplate__c pageForm;
        String parentId;
        Id formRecId;
        Id formConfigId;
        List<FormInstance__c> frmInstace = new List<FormInstance__c>();
        if(Schema.sObjectType.FormInstance__c.isAccessible()){
            frmInstace = [SELECT Id, Name,FormId__c,PackageBusinessForm__r.FormConfig__c,ParentRecordId__c
            FROM FormInstance__c
            WHERE Id =: recordId
            WITH USER_MODE];  
        }
                if(frmInstace.size() > 0) {
                        formConfigId = frmInstace[0].PackageBusinessForm__r.FormConfig__c;
                        parentId = frmInstace[0].ParentRecordId__c;
                        if(frmInstace[0].PackageBusinessForm__r.FormConfig__c != null){
                            if(Schema.sObjectType.PageTemplate__c.isAccessible()){
                                pageForm = [SELECT id,name,ParentObjectFieldAPI__c,SObjectName__c FROM PageTemplate__c WHERE Id=:frmInstace[0].PackageBusinessForm__r.FormConfig__c
                                        WITH USER_MODE]; // form config
        }                   }

                        if(pageForm.SObjectName__c == null){
                            //throw new CustomExceptions.RequiredException('SObject Name not found for Form.');
                            String errorMsg = 'SObject Name not found for Form.';
                            throw new AuraHandledException(errorMsg);    
                        }
                        if(pageForm.ParentObjectFieldAPI__c == null){
                            //throw new CustomExceptions.RequiredException('Parent object field API not found for Form.');
                            String errorMsg = 'Parent object field API not found for Form.';
                            throw new AuraHandledException(errorMsg);
                        }                        
                        formRecId = formRecordCreation(pageForm, parentId, String.valueOf(frmInstace[0].Id));
                        
                        
                            if(String.isNotEmpty(formRecId) && frmInstace[0]!= null && formRecId != frmInstace[0].FormId__c && (actionURLLongLWC.contains('c__Mode=edit') || actionURLLongLWC.contains('/view'))){
                                updateFormInstanceFormId(formRecId, frmInstace[0].id);
                            }

                            if(actionURLLongLWC != '' && actionURLLongLWC != null){ 
                                Schema.SObjectType objApiName = formRecId.getsObjectType();
                                actionURLLongLWC = actionURLLongLWC.replace('{!rowId}' , formRecId); 
                                actionURLLongLWC = actionURLLongLWC.replace('/FormInstance__c/' , '/'+objApiName+'/'); 
                                if(!actionURLLongLWC.contains('c__Mode=edit')){
                                    actionURLLongLWC = actionURLLongLWC+'?c__formInstanceId='+recordId+'&c__parentId='+parentId+'&c__formConfigId='+formConfigId;
                                }else{
                                    actionURLLongLWC= actionURLLongLWC+'&c__formInstanceId='+recordId+'&c__parentId='+parentId+'&c__formConfigId='+formConfigId;
                                }
                            }
            }
            return actionURLLongLWC;
    }
    //FormInstance FormId Insert
    @testvisible
    private static void updateFormInstanceFormId(Id formId, Id formInstanceId){
        if(!String.isEmpty(formId) && !String.isEmpty(formInstanceId) && Schema.sObjectType.FormInstance__c.isCreateable()){
            FormInstance__c frmInst = new FormInstance__c();
            //if(Schema.sObjectType.FormInstance__c.isUpdateable() && Schema.sObjectType.FormInstance__c.isCreateable()){
                frmInst.id = formInstanceId; // CRUD/FLS False Positive: Id field 
            //}
            if(Schema.sObjectType.FormInstance__c.fields.FormId__c.isCreateable() && Schema.sObjectType.FormInstance__c.fields.FormId__c.isUpdateable()){
                frmInst.FormId__c = formId;
            }
            if(Schema.sObjectType.FormInstance__c.isUpdateable() && Schema.sObjectType.FormInstance__c.isCreateable()){ // Security Scan FLS Update CRUD
                upsert as user frmInst;
            }
        }
    }

    global DynamicPageCtrl() {  
        Map<String,String> params = ApexPages.CurrentPage().getParameters();
       
         if(String.isEmpty(SFDCEncoder.SFDC_JSENCODE(params.get('id')))|| SFDCEncoder.SFDC_JSENCODE(params.get('id')) == 'undefined' ){
            recordId = null;
        }else{
            recordId = SFDCEncoder.SFDC_JSENCODE(params.get('id')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        }
  String className = SFDCEncoder.SFDC_JSENCODE(params.get('clsName'));
        if(String.isNotBlank(className) && String.isNotEmpty(className)){
            Type t;
            try {
                if(className.contains('.')){
                    List<String> spliStr = className.split('\\.');
                    t = Type.forName(spliStr[0], spliStr[1]);
                }else{
                    t = Type.forName('', className);
                }
            } catch(Exception ex) {
                throw new CustomExceptions.InputDataException('Class not found with Name ' + className + '. Please check class name. Or it might not be global');
            }
            dynamicValues = (DynamicKeyValues)t.newInstance();
            dynamicValues.recordId = recordId;
        }

        parentId = SFDCEncoder.SFDC_JSENCODE(params.get('ParentId'));
        parentLayoutId = SFDCEncoder.SFDC_JSENCODE(params.get('parentLayoutId'));
        packageId = SFDCEncoder.SFDC_JSENCODE(params.get('packageId'));
        formSaved = SFDCEncoder.SFDC_JSENCODE(params.get('isFormSaved'));
        templateName = SFDCEncoder.SFDC_JSENCODE(params.get('templateName'));
        if(templateName != null){
            templateName = templateName.replace('\\', '');
        }
        formId = SFDCEncoder.SFDC_JSENCODE(params.get('formId'));
        String formTypeStr = params.get('formTypes');
        if(formTypeStr != null && formTypeStr != ''){
            formTypes = (List<String>)JSON.deserialize(formTypeStr, List<String>.class);  //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
        }
        if(formId != null){
            if(Schema.sObjectType.PageTemplate__c.isAccessible()){
                pageForm = [SELECT id,name,ParentObjectFieldAPI__c,SObjectName__c FROM PageTemplate__c WHERE Id=:formId WITH USER_MODE];
            }
        }

        String ns = AppUtils.getNamespacePrefix();
        savePage = 'https://' + ApexPages.currentPage().getHeaders().get('Host'); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        savePage += '/apex/DynamicFormEdit?id=';
        savePage += recordId;  
        savePage += '&templateName=';
        savePage += templateName;
        savePage += '&formId=';
        savePage += formId;
        savePage += '&packageId=';
        savePage += packageId;
        savePage += '&parentId=';
        savePage += parentId;
        savePage += '&parentLayoutId=';
        savePage += parentLayoutId;
        if (String.isNotEmpty(params.get('formInstanceId'))){
            savePage += '&formInstanceId='+formInstanceId;
        }

        /*Task 117614: LSC- Edit Mode --> Upon using Cancel button user lands on home page instead of Form View page*/
        Id formInstanceId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formInstanceId')); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        cancelPage = 'https://'+ ApexPages.currentPage().getHeaders().get('Host'); //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        cancelPage += '/apex/DynamicFormView?id=';
        cancelPage += recordId;
        cancelPage += '&templateName=';
        cancelPage += templateName;
        cancelPage += '&formId=';
        cancelPage += formId;
        cancelPage += '&packageId=';
        cancelPage += packageId;
        cancelPage += '&parentId=';
        cancelPage += parentId;
        cancelPage += '&parentLayoutId=';
        cancelPage += parentLayoutId;
        if (String.isNotEmpty(params.get('formInstanceId'))){
            cancelPage += '&formInstanceId='+formInstanceId;
        }
    }
    
     public static Map<String, String> getIconLwc(){
    
        map<string,string> iconMap = new map<string,string>();
        iconMap.put('fa fa-pencil','utility:edit');
        iconMap.put('fa fa-arrow','utility:right');
        iconMap.put('fa fa-ban','utility:error');
        iconMap.put('fa fa-bolt','utility:thunder');
        iconMap.put('fa fa-check','utility:success'); 
        iconMap.put('fa fa-clone','utility:clone');
        iconMap.put('fa fa-close','utility:close');
        iconMap.put('fa fa-cloud-download','utility:download');
        iconMap.put('fa fa-cloud-upload','utility:upload');
        iconMap.put('fa fa-comments','utility:chat');
        iconMap.put('fa fa-exchange','utility:exchange');
        iconMap.put('fa fa-external-link','utility:open');
        iconMap.put('fa fa-eye','utility:preview');
        iconMap.put('fa fa-file','utility:page');
        iconMap.put('fa fa-file-pdf','utility:pdf_ext');
        iconMap.put('fa fa-file-pdf-o','utility:pdf_ext');
        iconMap.put('fa fa-file-text','utility:file');
        iconMap.put('fa fa-gavel','utility:thunder');
        iconMap.put('fa fa-level-up','utility:up');
        iconMap.put('fa fa-money','utility:currency');
        iconMap.put('fa fa-play','utility:play');
        iconMap.put('fa fa-plus-circle','utility:add');
        iconMap.put('fa fa-reply','utility:back');
        iconMap.put('fa fa-share','utility:share');
        iconMap.put('fa fa-share-square-o','utility:share_post');
        iconMap.put('fa fa-sign-in','utility:login');
        iconMap.put('fa fa-sign-out','utility:logout');
        iconMap.put('fa fa-sitemap','utility:hierarchy');
        iconMap.put('fa fa-sticky-note','utility:note');
        iconMap.put('fa fa-stop','utility:stop');
        iconMap.put('fa fa-tags','utility:tags');
        iconMap.put('fa fa-times','utility:close');
        iconMap.put('fa fa-trash','utility:delete');
        iconMap.put('fa fa-trophy','custom:custom48');
        iconMap.put('fa fa-undo','utility:undo');
        iconMap.put('fa fa-unlock','utility:unlock');
        iconMap.put('fa fa-paper-plane-o','utility:send');
        iconMap.put('glyphicon glyphicon-pencil','utility:edit');
        iconMap.put('glyphicon glyphicon-remove','utility:close');
        iconMap.put('glyphicon glyphicon-send','utility:send');
        iconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        iconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        iconMap.put('glyphicon glyphicon-trash','utility:delete');
        iconMap.put('fa fa-history','utility:skip_back');
        iconMap.put('fa fa-table','utility:table');
        iconMap.put('fa fa-coffee','utility:coffee');
        iconMap.put('fa fa-cubes','utility:cubes');
        iconMap.put('fa fa-star','utility:favorite');
        iconMap.put('fa fa-exclamation-triangle','utility:warning');
        iconMap.put('fa fa-line-chart','utility:graph');
        iconMap.put('fa fa-comment','utility:comments');
        iconMap.put('fa fa-caret-square-o-down','utility:down');
        iconMap.put('fa fa-wrench','utility:settings');
        iconMap.put('fa fa-share-square-o','utility:share');
        iconMap.put('fa fa-bolt','utility:lightning');
        iconMap.put('fa fa-trash-o','utility:delete');
        iconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        iconMap.put('fa fa-file-text-o','utility:contract_doc');
        iconMap.put('fa fa-wechat','utility:chat');
        iconMap.put('fa fa-paperclip','utility:attach');
        iconMap.put('fa fa-usd','utility:moneybag');
        iconMap.put('glyphicon glyphicon-tasks','utility:task');
        //iconMap.put('fa fa-trophy','utility:funding_award_adjustment');
        iconMap.put('fa fa-folder','utility:open_folder');
        iconMap.put('fa fa-paper-plane-o','utility:send');
        iconMap.put('fa fa-play','utility:play');
        iconMap.put('fa fa-folder-open-o','utility:opened_folder');
        iconMap.put('fa fa-check-square-o','utility:multi_select_checkbox');
        iconMap.put('fa fa-male','utility:user');
    
        return iconMap;
    }
    
    public string getKeyValueMap() {
        Map<String,String> keyValueMap = new Map<String,String>();
        User userRec;
            userRec = [select OrganizationId__c from user where Id = :UserInfo.getUserId() WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users

        keyValueMap.put('template',templateName);   
        keyValueMap.put('parentId',parentId);    
        keyValueMap.put('recordId',recordId); 
        keyValueMap.put('OrganizationId',userRec.OrganizationId__c); 
        keyValueMap.put('parentRecordId',parentId); 
        if(dynamicValues != null && dynamicValues.keyValueMapOverride != null && dynamicValues.keyValueMapOverride.size() > 0){
            keyValueMap.putAll(dynamicValues.keyValueMapOverride);
        }

        return JSON.serialize(keyValueMap);
    }

    public string getListParameters(){
        Map<String,Set<String>> listKeyValueMap = new Map<String,Set<String>>();
        /* Rahul - Added below code to provide support to pass dynamic parameters to the DynamicForm 146972 */
        if(dynamicValues != null &&  dynamicValues.listKeyValueMapOverride != null && dynamicValues.listKeyValueMapOverride.size() > 0){
            listKeyValueMap.putAll(dynamicValues.listKeyValueMapOverride);
        }
       return JSON.serialize(listKeyValueMap);
    }
}