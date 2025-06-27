/**
**/
//Under security review changing this class to with sharing. Queries which we need in without sharing context moved to SystemContextMethodsHelper
global with sharing class AttachmentEditCtrl{
    public Attachment editAttachment { get; set; }
    public Id pageBlockId;

    // This is related for save / save Close Modal. 
    public Boolean isAttachedSuccess{get;set;}
    public Boolean isSaveClose{get;set;}
    public static Boolean isSaveCloseLWC{get;set;}
    public String attachTableType{get;set;}
    public Boolean renderWorkSpace{get;set;}
    public Boolean isUlFromWorkspace{get;set;}
    public AttachmentExtension__c attachmentExtension { get; set; }
    private String parentObjectId;
    private String attachmentId;
    public string classification { get; set; }
    public Boolean hideWorkSpace {get;set;}
    private string attachClassifications ;
    public List < selectOption > classificationsOptions { get; set; }
    //temp
    public String classificationVal { get; set; }
    
    public List < WrapAttachment > wrapAttachmentList { get; set; }
    public Set < Id > selectedAttachments { get; set; }
    public Attachment attachmentObj { get; set; }
    public List < WrapFields > wrapFieldsList { get; set; }
    public String saveBehaviour{get;set;}

    public static AttachmentExtension__c attachmentExtensionLWC { get; set; }
    public static Attachment editAttachmentLWC { get; set; }
    public static List < WrapFields > wrapFieldsListLWC { get; set; }
    public static String saveBehaviourForLwc{ get; set; }
    public static Boolean isUlFromWorkspaceLWC { get; set; }
    public static List < WrapAttachment > wrapAttachmentListLWC { get; set; }
    public static List < String > classificationsOptionsLWC { get; set; }
    public static Boolean isAttachedSuccessLWC{get;set;}
    private static String parentObjectIdLWC;
    global AttachmentEditCtrl() {
        try {
            renderWorkSpace = true;
            if(UserInfo.getUserType() == 'Guest'){
                renderWorkSpace = false;
            }
            if(KeyValueStoreHelper.getBooleanValue('HideAttachmentWorkspace',true) != null){
                hideWorkSpace = KeyValueStoreHelper.getBooleanValue('HideAttachmentWorkspace',true);
            }else{
                hideWorkSpace = false;   
            }
            isAttachedSuccess = false;
            isSaveClose = false;
            isUlFromWorkspace = false;
            attachmentExtension = new AttachmentExtension__c();
            wrapFieldsList = new List<WrapFields>();
            wrapAttachmentList = new List<WrapAttachment>();
            pageblockId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('pBlockId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 

            // Getting Attachment Table Type Through URL..
            attachTableType = SFDCEncoder.SFDC_JSENCODE(SFDCEncoder.SFDC_HTMLENCODE(apexpages.currentpage().getparameters().get('attchTableType')));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            attachTableType = '\''+ attachTableType + '\'';

            attachmentId = (SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) : null;
            parentObjectId = (SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentId')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentId')) : null;
            classificationVal = (SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('classification')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('classification')) : null;
            if( attachmentId == null || attachmentId.trim() == '' ) {
                throw new CustomExceptions.RequiredException('Attachement Id missing. Please contact support team.');
            }
            if(Attachment.sObjectType.getDescribe().isAccessible() == true){
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                editAttachment = cls.getAttachDetails(attachmentId);
            }
                                  
            // Pankaj : have a doubt regarding Attachment__c as external id
          
            // Here we fetch json value from pageblock additionalfieldjson field.
            String jsonField;
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                List<PageBlockConfig__c> pageBlockList = [Select AdditionalFieldJSON__c from PageBlockConfig__c Where id=:pageblockId WITH USER_MODE];
                for(PageBlockConfig__c pageBlock:pageBlockList){
                    jsonField = pageBlock.AdditionalFieldJSON__c;
                }
            }
            String additionalfield;
            if(jsonField !=null){
                wrapFieldsList = (List<WrapFields> )JSON.deserialize(SFDCEncoder.sanitizeJSON(jsonField), List<WrapFields>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                for(WrapFields wrap: wrapFieldsList){
                    additionalfield = wrap.fieldName;
                }
            }

            // The field pass in json need to be query. so its needs to be query in dynamic query.
            if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                String query = '';
                if(additionalfield != null){
                query = 'SELECT Id,Classification__c,Attachment__c ,Description__c, ParentId__c,'  +  String.escapeSingleQuotes(additionalfield)  + ' FROM AttachmentExtension__c WHERE Attachment__c =: attachmentId';
                }else{
                query = 'SELECT Id,Classification__c,Attachment__c ,Description__c, ParentId__c FROM AttachmentExtension__c WHERE Attachment__c =: attachmentId';
                }
                list<AttachmentExtension__c> attextlst;
                if(Schema.sObjectType.AttachmentExtension__c.isAccessible()) {
                    attextlst =  Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind
                }
                if(attextlst.size() > 0) {
                    attachmentExtension = attextlst.get(0);
                }
            }
            if( attachmentExtension == null ) {
                attachmentExtension = new AttachmentExtension__c();
            }

            getClassificationOptionList();
            getWrapperAttachment();
        
        } catch (Exception ex) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(ex.getMessage()) ) );
        }
    }

    @AuraEnabled
    public static Map<String, Object> getAttachmentDetails( String attachmentId,String parentId,Id pageblockId,String classificationVal,String attachTableType){
        Map<String,object> returnMap = new Map<String,object>();
        try {
           Boolean renderWorkSpace = true;
           Boolean hideWorkSpace;
            if(UserInfo.getUserType() == 'Guest'){
                renderWorkSpace = false;
            }
            if(KeyValueStoreHelper.getBooleanValue('HideAttachmentWorkspace',true) != null){
                hideWorkSpace = KeyValueStoreHelper.getBooleanValue('HideAttachmentWorkspace',true);
            }else{
                hideWorkSpace = false;   
            }            
            isAttachedSuccessLWC = false;
            isSaveCloseLWC = false;
            isUlFromWorkspaceLWC = false;
            attachmentExtensionLWC = new AttachmentExtension__c();
            wrapFieldsListLWC = new List<WrapFields>();
            wrapAttachmentListLWC = new List<WrapAttachment>();
            List<Attachment> attachmentList = new List<Attachment>();  

          attachTableType = '\''+ attachTableType + '\'';
            parentObjectIdLWC =parentId; //(SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentId')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentId')) : null;
            if(Attachment.sObjectType.getDescribe().isAccessible() == true && attachmentId != null && attachmentId.trim() != ''){
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                editAttachmentLWC = cls.getAttachDetails(attachmentId);
            }
            String jsonField;
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                List<PageBlockConfig__c> pageBlockList = [Select AdditionalFieldJSON__c from PageBlockConfig__c Where id=:pageblockId WITH USER_MODE];
                for(PageBlockConfig__c pageBlock:pageBlockList){
                    jsonField = pageBlock.AdditionalFieldJSON__c;
                }
            }
            String additionalfield;
            if(jsonField !=null){
                wrapFieldsListLWC = (List<WrapFields> )JSON.deserialize(SFDCEncoder.sanitizeJSON(jsonField), List<WrapFields>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                for(WrapFields wrap: wrapFieldsListLWC){
                    additionalfield = wrap.fieldName;
                }
            }

            // The field pass in json need to be query. so its needs to be query in dynamic query.
            if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                String query = '';
                if(additionalfield != null){
                query = 'SELECT Id,Classification__c,Attachment__c ,Description__c, ParentId__c,'  +  String.escapeSingleQuotes(additionalfield)  + ' FROM AttachmentExtension__c WHERE Attachment__c =: attachmentId';
                }else{
                query = 'SELECT Id,Classification__c,Attachment__c ,Description__c, ParentId__c FROM AttachmentExtension__c WHERE Attachment__c =: attachmentId';
                }
                list<AttachmentExtension__c> attextlst =  Database.query(String.escapeSingleQuotes(query),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind
                if(attextlst.size() > 0) {
                    attachmentExtensionLWC = attextlst.get(0);
                }
            }
            if( attachmentExtensionLWC == null ) {
                attachmentExtensionLWC = new AttachmentExtension__c();
            }
           
           //get classification details
            List<PageBlockConfig__c> pgblock = new List<PageBlockConfig__c>();
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                pgblock = [Select SaveAttachmentBehaviour__c,AttachmentClassifications__c,ClassificationFieldAPIName__c from PageBlockConfig__c Where id =: pageblockId WITH USER_MODE];//here pageblock contains both attachemnt classficatioj fields
            }
            classificationsOptionsLWC = new List<String>();
            String classficationsString;
            String sobjectName = String.valueOf(((Id)parentObjectIdLWC).getSobjectType());//This is used to get sojectname from parentObjectId
            // Read Save Behaviour for page Block
            if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).SaveAttachmentBehaviour__c )){
                saveBehaviourForLwc = pgblock.get(0).SaveAttachmentBehaviour__c;
            }
            if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).ClassificationFieldAPIName__c )){//this block is used to get feld api name in which classfication are store comma separated
                String query1 = 'Select ' + String.escapeSingleQuotes(pgblock.get(0).ClassificationFieldAPIName__c)  + ' From ' + String.escapeSingleQuotes(sobjectName) + ' Where Id =: parentObjectIdLWC';
                Sobject sobj1;
                if(AppUtils.isObjectAccessible(sobjectName)){
                    sobj1 = Database.query(String.escapeSingleQuotes(query1),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                }
                if(AppUtils.getFieldValue(sobj1,pgblock.get(0).ClassificationFieldAPIName__c) == null){
                    CustomExceptions.logException(String.format(System.Label.ClassficationDoesNotExist, new List<String>{}), false);//in this we can get relationship field and also normal fields so we use apputils method
                }else{
                    classficationsString = (String)AppUtils.getFieldValue(sobj1,pgblock.get(0).ClassificationFieldAPIName__c);
                }
            }else if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).AttachmentClassifications__c)){//this block is used to get classification from normal classgication field.
                classficationsString = pgblock.get(0).AttachmentClassifications__c;
            }else{// this block is used to get classfications from sobject level
                if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
                    list<SobjectConfig__c> sobjectConfig = [Select AttachmentClassifications__c from SobjectConfig__c Where Name =: sobjectName  WITH USER_MODE];
                    classficationsString = sobjectConfig.get(0).AttachmentClassifications__c;
                }
            }
            if(String.isNotEmpty(classficationsString)){
                String [] sobjectdataSeparatedList1 = classficationsString.split(';');
                for(String classification : sobjectdataSeparatedList1) {
                   classificationsOptionsLWC.add(classification);
                }
            }
            //getWrapperAttachment(); Warapper list
            if(wrapAttachmentListLWC != null){
                wrapAttachmentListLWC.clear();
            }           
            if(wrapAttachmentListLWC == null || wrapAttachmentListLWC.size()==0) {
                list<id> attchmentsIds = new list<id>();
                List<AttachmentExtension__c> attachExtList = new List<AttachmentExtension__c>();
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    attachExtList = WithSharingHelper.getRelatedAttachmentmentExtension();
                }   
                for(AttachmentExtension__c ae : attachExtList) {
                    attchmentsIds.add(ae.Attachment__c);
                }
                
                for(Attachment a: WithSharingHelper.getRelatedAttachments(attchmentsIds)) {   
                   attachmentList.add(a);
                    WrapAttachment test = new WrapAttachment(a);   
                    wrapAttachmentListLWC.add(test);
                }
            }
           
            returnMap.put('hideWorkSpace',hideWorkSpace);
            returnMap.put('renderWorkSpace',renderWorkSpace);
            returnMap.put('classificationsOptions',classificationsOptionsLWC);
            returnMap.put('editAttachment',editAttachmentLWC);
            returnMap.put('attachmentList',attachmentList);
            returnMap.put('saveBehaviour',saveBehaviourForLwc);
            returnMap.put('isUlFromWorkspace',isUlFromWorkspaceLWC);
            returnMap.put('wrapAttachmentList',wrapAttachmentListLWC);
            returnMap.put('attachmentClassifiction',attachmentExtensionLWC.Classification__c);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return returnMap;
    }
    public void getWrapperAttachment(){
        wrapAttachmentList.clear();
        if(wrapAttachmentList == null || wrapAttachmentList.size()==0) {
            list<id> attchmentsIds = new list<id>();
            List<AttachmentExtension__c> attachExtList = new List<AttachmentExtension__c>();
            if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                attachExtList = WithSharingHelper.getRelatedAttachmentmentExtension();
            }            
            for(AttachmentExtension__c ae : attachExtList) {
                attchmentsIds.add(ae.Attachment__c);
            }
            for(Attachment a: WithSharingHelper.getRelatedAttachments(attchmentsIds)) {              
                wrapAttachmentList.add(new WrapAttachment(a));
            }
        }
    }
    
    private void getClassificationOptionList() {
        //try{
            List<PageBlockConfig__c> pgblock = new List<PageBlockConfig__c>();
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                pgblock = [Select SaveAttachmentBehaviour__c,AttachmentClassifications__c,ClassificationFieldAPIName__c from PageBlockConfig__c Where id =: pageblockId WITH USER_MODE];//here pageblock contains both attachemnt classficatioj fields
            }
            classificationsOptions = new List<selectOption>();
            String classficationsString;
            String sobjectName = String.valueOf(((Id)parentObjectId).getSobjectType());//This is used to get sojectname from parentObjectId
            // Read Save Behaviour for page Block
            if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).SaveAttachmentBehaviour__c )){
                saveBehaviour = pgblock.get(0).SaveAttachmentBehaviour__c;
            }
            if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).ClassificationFieldAPIName__c )){//this block is used to get feld api name in which classfication are store comma separated
                String query1 = 'Select ' + String.escapeSingleQuotes(pgblock.get(0).ClassificationFieldAPIName__c)  + ' From ' + String.escapeSingleQuotes(sobjectName) + ' Where Id =: parentObjectId';
                Sobject sobj1;
                if(AppUtils.isObjectAccessible(sobjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sobj1 = Database.query(String.escapeSingleQuotes(query1),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                }
                if(AppUtils.getFieldValue(sobj1,pgblock.get(0).ClassificationFieldAPIName__c) == null){
                    CustomExceptions.logException(String.format(System.Label.ClassficationDoesNotExist, new List<String>{}), false);//in this we can get relationship field and also normal fields so we use apputils method
                }else{
                    classficationsString = (String)AppUtils.getFieldValue(sobj1,pgblock.get(0).ClassificationFieldAPIName__c);
                }
            }else if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).AttachmentClassifications__c)){//this block is used to get classification from normal classgication field.
                classficationsString = pgblock.get(0).AttachmentClassifications__c;
            }else{// this block is used to get classfications from sobject level
                if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
                    list<SobjectConfig__c> sobjectConfig = [Select AttachmentClassifications__c from SobjectConfig__c Where Name =: sobjectName  WITH USER_MODE];
                    classficationsString = sobjectConfig.get(0).AttachmentClassifications__c;
                }
            }
            if(String.isNotEmpty(classficationsString)){
                String [] sobjectdataSeparatedList1 = classficationsString.split(';');
                for(String classification : sobjectdataSeparatedList1) {
                    classificationsOptions.add(new selectOption(classification.trim(), classification.trim()));
                }
            }
    }


    /*
        This Method is called when save and close modal button
    */
    global void updateAttachmentCloseModal(){
        isSaveClose = true;
        updateAttachment();
    }
    @AuraEnabled 
    public static void updateAttachmentCloseModalLWC(){
        isSaveCloseLWC = true;
    } 
    @AuraEnabled   
    public static Map<String,Object> updateAttachmentLWC(Id id,Attachment editAttachmentLWC,String classification, Boolean isFileUpdated){
        Map<String, Object> resultMap = new Map<String, Object>();
        try {
            
            Boolean errorPresent = false;
            if( editAttachmentLWC.Body == null ) {
                isSaveCloseLWC = false;
                if(editAttachmentLWC.Description == null){
                    //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, Label.AttachmentDescriptionRequiredLabel) ); 
                }    
            }else if(editAttachmentLWC.Description == null){
                isSaveCloseLWC = false;
             }else if(errorPresent == false){
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                if(Schema.sObjectType.Attachment.isUpdateable()){
                    Attachment obj = new Attachment();
                    if(editAttachmentLWC.id != null){
                        obj.id = editAttachmentLWC.id;
                    }                    
                    if(Schema.sObjectType.Attachment.fields.Name.isCreateable() && Schema.sObjectType.Attachment.fields.Name.isUpdateable()){
                        obj.Name = editAttachmentLWC.Name;
                    }
                    if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isUpdateable() && editAttachmentLWC.Body != null && isFileUpdated){
                        obj.Body =  EncodingUtil.base64Decode(String.valueof(editAttachmentLWC.Body));//Blob.valueof(String.valueof(editAttachmentLWC.Body));
                    }
                    if(Schema.sObjectType.Attachment.fields.Description.isCreateable() && Schema.sObjectType.Attachment.fields.Description.isUpdateable()){
                        obj.Description = editAttachmentLWC.Description;
                    }
                    if(editAttachmentLWC.id == null){
                    	obj.ParentId = editAttachmentLWC.ParentId;     //CRUD/FLS False +ve Id field           
                    }
                    if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.Attachment.isUpdateable()){                  
                    	cls.upsertAttachment(obj);
                    }
                    if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isUpdateable()){
                        editAttachmentLWC.Body = null;
                    }
                    isAttachedSuccessLWC = true;
                    if(id == null){
                        editAttachmentLWC = obj;
                    }else{
                        editAttachmentLWC = cls.getAttachDetails(editAttachmentLWC.id);
                    }
                   
                    if(id != null || id != ''){
                        if(Schema.sObjectType.AttachmentExtension__c.isAccessible()){
                            list<AttachmentExtension__c> attextlst =  [SELECT Id,Classification__c,Attachment__c ,Description__c, ParentId__c FROM AttachmentExtension__c WHERE Attachment__c =:editAttachmentLWC.id WITH USER_MODE];
                            if(attextlst.size() > 0) {
                                attachmentExtensionLWC = attextlst.get(0);
                            }
                        }
                    }
                    if( attachmentExtensionLWC == null ) {
                        attachmentExtensionLWC = new AttachmentExtension__c();
                    }
                    if(classification != null && Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isUpdateable()){
                        attachmentExtensionLWC.Classification__c= classification;
                    }
                    
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isUpdateable()){
                        attachmentExtensionLWC.Attachment__c = editAttachmentLWC.Id;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isUpdateable()){
                        attachmentExtensionLWC.Description__c = editAttachmentLWC.Description;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isUpdateable()){
                        attachmentExtensionLWC.ParentId__c = editAttachmentLWC.ParentId;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isUpdateable()){
                        attachmentExtensionLWC.AttachmentType__c = 'Attachment';
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isUpdateable()){
                        upsert as user attachmentExtensionLWC;
                    }
                    isUlFromWorkspaceLWC = false;
                }
            }
            resultMap.put('isSucess',true);
        } catch(Exception e) {
             isSaveCloseLWC = false;           
             isUlFromWorkspaceLWC = false;
             String errMsg = Apputils.handleSystemExceptionMsg(e.getMessage());
             resultMap.put('Error',errMsg);
             resultMap.put('isSucess',false);
        } 
        return resultMap;
    }

     public void updateAttachment() {
        try {
            SystemContextMethodsHelper cls = new SystemContextMethodsHelper();

            if( !Schema.sObjectType.Attachment.isUpdateable() ) {
                String errorMessage = 'You lack permission to update the AttachmentExtension__c Object, please Contact support and have this permission enabled to add attachments';
                throw new CustomExceptions.AuthorizationException( errorMessage );
            }
            
            if( !Schema.sObjectType.AttachmentExtension__c.isUpdateable() && attachmentExtension.Id != null ) { 
                String errorMessage = 'You lack permission to update the AttachmentExtension__c Object, please Contact support and have this permission enabled to add attachments';
                throw new CustomExceptions.AuthorizationException( errorMessage );
            }
            
            if( !Schema.sObjectType.AttachmentExtension__c.isCreateable() && attachmentExtension.Id == null ) {
                String errorMessage = 'You lack permission to create the AttachmentExtension__c Object, please Contact support and have this permission enabled to add attachments';
                throw new CustomExceptions.AuthorizationException( errorMessage );
            }
            Boolean errorPresent = false;
            for(WrapFields wrap : wrapFieldsList){
                if(attachmentExtension.get(wrap.fieldName) == null && wrap.requiredField == true){
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(System.Label.AttachmentAdditionalField, new List<String>{wrap.fieldLabel}));
                    ApexPages.addMessage(errorMsg);   
                    errorPresent = true;   
                    isSaveClose = false;
                }
            }
            if( editAttachment.Body == null ) {
                isSaveClose = false;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, Label.DocumentRequiredLabel) ); 
                if(editAttachment.Description == null){
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, Label.AttachmentDescriptionRequiredLabel) ); 
                }    
            }else if(editAttachment.Description == null){
                isSaveClose = false;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, Label.AttachmentDescriptionRequiredLabel) ); 
            }else if(errorPresent == false){
                if(Schema.sObjectType.Attachment.isUpdateable() && Schema.sObjectType.Attachment.isAccessible()){
                    cls.updateAttachment(editAttachment);
                    if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isUpdateable()){
                        editAttachment.Body = null;
                    }
                    isAttachedSuccess = true;
                    editAttachment = cls.getAttachDetails(editAttachment.id);
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isUpdateable()){
                        attachmentExtension.Attachment__c = editAttachment.Id;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isUpdateable()){
                        attachmentExtension.Description__c = editAttachment.Description;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isUpdateable()){
                        attachmentExtension.ParentId__c = parentObjectId;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isUpdateable()){
                        attachmentExtension.AttachmentType__c = 'Attachment';
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isUpdateable()){
                        upsert as user attachmentExtension;
                    }
                    isUlFromWorkspace = false;
                }
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Attachement edited successfully.' ) );
            }
        } catch(Exception e) {
            isSaveClose = false;
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(e.getMessage()) ) );
            isUlFromWorkspace = false;
        } 
    }
    
    public void processSelected() {
        Savepoint sp = Database.setSavepoint();
        try{ 
            selectedAttachments = new Set < Id > ();
            Database.SaveResult[] srList = new List<Database.SaveResult>();
            Database.SaveResult[] srAttachmentExt = new List < Database.SaveResult > ();
            List<Attachment> attachmentListToBeInsrted = new List<Attachment>();   
            List < AttachmentExtension__c > attachmentExtensionNewList = new List < AttachmentExtension__c > ();
            List < AttachmentExtension__c > attachmentExtensionList = new List < AttachmentExtension__c > ();
            list<Attachment>selectedattachmentrec = new list<Attachment>();
            Map < Id, Attachment > AttachmentOldMap = new Map < Id, Attachment > ();

            if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isCreateable()&& Schema.sObjectType.Attachment.isUpdateable() && Schema.sObjectType.AttachmentExtension__c.isUpdateable()){
                for(WrapAttachment wrapAttachmentObj : wrapAttachmentList) {
                    if(wrapAttachmentObj.selected == true) {
                        selectedAttachments.add(wrapAttachmentObj.att.Id);  
                    }
                }
                if(selectedAttachments.size() == 0 ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SelectAttachmentMsg));
                    return;
                }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                selectedattachmentrec = cls.getAttachmentDetails(selectedAttachments);
                String attachmentId = (SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) : null;   
                AttachmentExtension__c oldAttExt = new AttachmentExtension__c();
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    oldAttExt = [SELECT Id, Classification__c, ParentId__c, Attachment__c FROM AttachmentExtension__c where Attachment__c = : attachmentId  WITH USER_MODE limit 1 ];
                }
                for(Attachment attch :selectedattachmentrec ){
                    Attachment a = new Attachment(); //Clone attachment
                    if(Schema.sObjectType.Attachment.fields.Name.isUpdateable()) {
                        a.Name = attch.Name;
                    }
                    if(Schema.sObjectType.Attachment.fields.Body.isUpdateable()) {
                        a.Body = attch.Body;
                    }
                    if(Schema.sObjectType.Attachment.fields.Description.isUpdateable()) {
                        a.Description = attch.Description;
                    }
                    //if(Schema.sObjectType.Attachment.fields.ParentId.isUpdateable()) {
                        a.ParentId = parentObjectId;// CRUD/FLS False Positive: Id std field 
                    //}
                    //if(Schema.sObjectType.Attachment.isUpdateable()) {
                        a.id = attachmentId; // CRUD/FLS False Positive: Id std field 
                    //}
                    attachmentListToBeInsrted.add(a);
                    AttachmentOldMap.put(attch.id, a);
                }
                srList = cls.updateAttachments(attachmentListToBeInsrted);                  //Insert clone Attachment
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    attachmentExtensionList = [SELECT Attachment__c, Classification__c FROM AttachmentExtension__c WHERE Attachment__c IN: selectedAttachments WITH USER_MODE limit 1];
                } 
                Map < Id, String > AttachExtMap = new Map < Id, String > ();
                for (AttachmentExtension__c attExt: attachmentExtensionList) {
                            AttachExtMap.put(attExt.Attachment__c, attExt.Classification__c);
                }

                for (AttachmentExtension__c attachmentExtObj: attachmentExtensionList) {
                    Attachment attachment = new Attachment();
                    attachment = AttachmentOldMap.get(attachmentExtObj.Attachment__c);

                    AttachmentExtension__c attExtObj = new AttachmentExtension__c();
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isUpdateable()) {
                        attExtObj.Classification__c = AttachExtMap.get(attachmentExtObj.Attachment__c);
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isUpdateable()) {
                        attExtObj.Attachment__c = attachment.Id;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isUpdateable()) {
                        attExtObj.ParentId__c = parentObjectId;  
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isUpdateable()) {
                        attExtObj.Description__c = attachment.Description;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.IsCloned__c.isUpdateable()) {
                        attExtObj.IsCloned__c = true;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isUpdateable()) {
                        attExtObj.AttachmentType__c = 'Attachment';
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.isUpdateable()) {
                        attExtObj.id = oldAttExt.id; // CRUD/FLS False Positive: Id field 
                    }
                    attachmentExtensionNewList.add(attExtObj);
                }
                if(Schema.sObjectType.AttachmentExtension__c.isUpdateable()) {
                    srAttachmentExt = Database.update(attachmentExtensionNewList, true, AccessLevel.USER_MODE); //clone AttachmentExtension with classification value
                }
                isUlFromWorkspace = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, Label.AttachmentEditSuccessMsg));
            } else {
                String errorMessage = 'You lack permission to create the Attachment Object, please Contact support and have this permission enabled to add attachments';
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
                ApexPages.addMessage(errorMsg);
                isUlFromWorkspace = true;
            }
            getWrapperAttachment();
        } catch(DMLException e) {
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AppUtils.handleSystemExceptionMsg(e.getMessage()));
            ApexPages.addMessage(myMsg);
        }
    }
    
    @AuraEnabled   
    public static void processSelectedLWC(List<Id>  selectedAttachments, String parentId,String attachmentId ) {
        Map<String,object> returnMap = new Map<String,object>();
        SystemContextMethodsHelper cls1 = new SystemContextMethodsHelper();

         try{ 
           
            Database.SaveResult[] srList = new List<Database.SaveResult>();
            Database.SaveResult[] srAttachmentExt = new List < Database.SaveResult > ();
            List<Attachment> attachmentListToBeInsrted = new List<Attachment>();   
            List < AttachmentExtension__c > attachmentExtensionNewList = new List < AttachmentExtension__c > ();
            List < AttachmentExtension__c > attachmentExtensionList = new List < AttachmentExtension__c > ();
            list<Attachment>selectedattachmentrec = new list<Attachment>();
            Map < Id, Attachment > AttachmentOldMap = new Map < Id, Attachment > ();

           if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isCreateable()&& Schema.sObjectType.Attachment.isUpdateable() && Schema.sObjectType.AttachmentExtension__c.isUpdateable()){
                
                if(selectedAttachments.size() == 0 ){
                    return;
                }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                selectedattachmentrec = cls.getAttachmentListDetails(selectedAttachments);
                AttachmentExtension__c oldAttExt = new AttachmentExtension__c();
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true && attachmentId != null){
                    oldAttExt = [SELECT Id, Classification__c, ParentId__c, Attachment__c FROM AttachmentExtension__c where Attachment__c = : attachmentId  WITH USER_MODE limit 1 ];
                }
                for(Attachment attch :selectedattachmentrec ){
                    Attachment a = new Attachment(); //Clone attachment
                    if(Schema.sObjectType.Attachment.fields.Name.isUpdateable()) {
                        a.Name = attch.Name;
                    }
                    if(Schema.sObjectType.Attachment.fields.Body.isUpdateable()) {
                        a.Body = attch.Body;
                    }
                    if(Schema.sObjectType.Attachment.fields.Description.isUpdateable()) {
                        a.Description = attch.Description;
                    }
                      a.ParentId = parentId;
                    
                    //if(Schema.sObjectType.Attachment.isUpdateable()) {
                        a.id = attachmentId; //CRUD/FLS false +Ve id field
                    //}
                    attachmentListToBeInsrted.add(a);
                    AttachmentOldMap.put(attch.id, a);
                }
                if( attachmentId != null) {
                    srList = cls1.updateAttachments(attachmentListToBeInsrted);                 //Insert clone Attachment
                }
                //if(Schema.sObjectType.Attachment.isCreateable()){
                    srAttachmentExt =cls1.insertAttachments(attachmentListToBeInsrted);  //CRUD/FLS false +Ve Std obj was failing for guest user 
                //}
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    attachmentExtensionList = [SELECT Attachment__c, Classification__c FROM AttachmentExtension__c WHERE Attachment__c IN: selectedAttachments WITH USER_MODE];
                } 
                Map < Id, String > AttachExtMap = new Map < Id, String > ();
                for (AttachmentExtension__c attExt: attachmentExtensionList) {
                            AttachExtMap.put(attExt.Attachment__c, attExt.Classification__c);
                }
                for (AttachmentExtension__c attachmentExtObj: attachmentExtensionList) {
                    Attachment attachment = new Attachment();
                    attachment = AttachmentOldMap.get(attachmentExtObj.Attachment__c);

                    AttachmentExtension__c attExtObj = new AttachmentExtension__c();
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isCreateable()
                    && Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isUpdateable()) {
                        attExtObj.Classification__c = AttachExtMap.get(attachmentExtObj.Attachment__c);
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable()
                    && Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isUpdateable()) {
                        attExtObj.Attachment__c = attachment.Id;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable()
                    && Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isUpdateable()) {
                        attExtObj.ParentId__c = parentId;  
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isCreateable()
                    && Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isUpdateable()) {
                        attExtObj.Description__c = attachment.Description;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.IsCloned__c.isCreateable()
                    && Schema.sObjectType.AttachmentExtension__c.fields.IsCloned__c.isUpdateable()) {
                        attExtObj.IsCloned__c = true;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable()
                    && Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isUpdateable()) {
                        attExtObj.AttachmentType__c = 'Attachment';
                    }
                    if(attachmentId != null) {
                        attExtObj.id = oldAttExt.id; //CRUD /FLS false +Ve Id field 
                    }
                    attachmentExtensionNewList.add(attExtObj);
                }
                if(Schema.sObjectType.AttachmentExtension__c.isUpdateable() && attachmentId != null) {
                    srAttachmentExt = Database.update(attachmentExtensionNewList, true, AccessLevel.USER_MODE);
                }else if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
                    srAttachmentExt = Database.insert(attachmentExtensionNewList, true, AccessLevel.USER_MODE);
                }
                isUlFromWorkspaceLWC = true;
           } else {
                String errorMessage = 'You lack permission to create the Attachment Object, please Contact support and have this permission enabled to add attachments';
           }
        } catch(DMLException e) {
        }
    }
      
    public with sharing class WrapAttachment {
        @AuraEnabled
        public Attachment att { get; set; }
        @AuraEnabled
        public Boolean selected { get; set; }
 
        public WrapAttachment() {

        }        
        public WrapAttachment(Attachment a) {
            att = a;
            selected = false;
        }
    }

    public with sharing class WrapFields{
        public String fieldName{get;set;}
        public String fieldLabel{get;set;}   
        public Boolean requiredField{get;set;}   
    }

    public void processSelected1() {
        Savepoint sp = Database.setSavepoint();
  
            selectedAttachments = new Set < Id > ();
            Database.SaveResult[] srList = new List<Database.SaveResult>();
            Database.SaveResult[] srAttachmentExt = new List < Database.SaveResult > ();
            List<Attachment> attachmentListToBeInsrted = new List<Attachment>();   
            List < AttachmentExtension__c > attachmentExtensionNewList = new List < AttachmentExtension__c > ();
            List < AttachmentExtension__c > attachmentExtensionList = new List < AttachmentExtension__c > ();
            list<Attachment>selectedattachmentrec = new list<Attachment>();
            Map < Id, Attachment > AttachmentOldMap = new Map < Id, Attachment > ();

            if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isCreateable()&& Schema.sObjectType.Attachment.isUpdateable() && Schema.sObjectType.AttachmentExtension__c.isUpdateable()){
                for(WrapAttachment wrapAttachmentObj : wrapAttachmentList) {
                    if(wrapAttachmentObj.selected == true) {
                        selectedAttachments.add(wrapAttachmentObj.att.Id);  
                    }
                }
                if(selectedAttachments.size() == 0 ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SelectAttachmentMsg));
                    return;
                }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                selectedattachmentrec = cls.getAttachmentDetails(selectedAttachments);
                String attachmentId = (SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) : null;   
                AttachmentExtension__c oldAttExt = new AttachmentExtension__c();
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    oldAttExt = [SELECT Id, Classification__c, ParentId__c, Attachment__c FROM AttachmentExtension__c where Attachment__c = : attachmentId  WITH USER_MODE limit 1 ];
                }
                for(Attachment attch :selectedattachmentrec ){
                    Attachment a = new Attachment(); //Clone attachment
                    if(Schema.sObjectType.Attachment.fields.Name.isUpdateable()) {
                        a.Name = attch.Name;
                    }
                    if(Schema.sObjectType.Attachment.fields.Body.isUpdateable()) {
                        a.Body = attch.Body;
                    }
                    if(Schema.sObjectType.Attachment.fields.Description.isUpdateable()) {
                        a.Description = attch.Description;
                    }
                    //if(Schema.sObjectType.Attachment.fields.ParentId.isUpdateable()) {
                        a.ParentId = parentObjectId;// CRUD/FLS False Positive: Id std field 
                    //}
                    //if(Schema.sObjectType.Attachment.isUpdateable()) {
                        a.id = attachmentId; // CRUD/FLS False Positive: Id std field 
                    //}
                    attachmentListToBeInsrted.add(a);
                    AttachmentOldMap.put(attch.id, a);
                }
                srList = cls.updateAttachments(attachmentListToBeInsrted);                  //Insert clone Attachment
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    attachmentExtensionList = [SELECT Attachment__c, Classification__c FROM AttachmentExtension__c WHERE Attachment__c IN: selectedAttachments WITH USER_MODE limit 1];
                } 
                Map < Id, String > AttachExtMap = new Map < Id, String > ();
                for (AttachmentExtension__c attExt: attachmentExtensionList) {
                            AttachExtMap.put(attExt.Attachment__c, attExt.Classification__c);
                }

                for (AttachmentExtension__c attachmentExtObj: attachmentExtensionList) {
                    Attachment attachment = new Attachment();
                    attachment = AttachmentOldMap.get(attachmentExtObj.Attachment__c);

                    AttachmentExtension__c attExtObj = new AttachmentExtension__c();
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isUpdateable()) {
                        attExtObj.Classification__c = AttachExtMap.get(attachmentExtObj.Attachment__c);
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isUpdateable()) {
                        attExtObj.Attachment__c = attachment.Id;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isUpdateable()) {
                        attExtObj.ParentId__c = parentObjectId;  
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isUpdateable()) {
                        attExtObj.Description__c = attachment.Description;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.IsCloned__c.isUpdateable()) {
                        attExtObj.IsCloned__c = true;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isUpdateable()) {
                        attExtObj.AttachmentType__c = 'Attachment';
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.isUpdateable()) {
                        attExtObj.id = oldAttExt.id; // CRUD/FLS False Positive: Id field 
                    }
                    attachmentExtensionNewList.add(attExtObj);
                }
                if(Schema.sObjectType.AttachmentExtension__c.isUpdateable()) {
                    srAttachmentExt = Database.update(attachmentExtensionNewList, true, AccessLevel.USER_MODE); //clone AttachmentExtension with classification value
                }
                isUlFromWorkspace = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, Label.AttachmentEditSuccessMsg));
            }
            getWrapperAttachment();

    }
    
    
     public void processSelected2() {
        Savepoint sp = Database.setSavepoint();
  
            selectedAttachments = new Set < Id > ();
            Database.SaveResult[] srList = new List<Database.SaveResult>();
            Database.SaveResult[] srAttachmentExt = new List < Database.SaveResult > ();
            List<Attachment> attachmentListToBeInsrted = new List<Attachment>();   
            List < AttachmentExtension__c > attachmentExtensionNewList = new List < AttachmentExtension__c > ();
            List < AttachmentExtension__c > attachmentExtensionList = new List < AttachmentExtension__c > ();
            list<Attachment>selectedattachmentrec = new list<Attachment>();
            Map < Id, Attachment > AttachmentOldMap = new Map < Id, Attachment > ();

            if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isCreateable()&& Schema.sObjectType.Attachment.isUpdateable() && Schema.sObjectType.AttachmentExtension__c.isUpdateable()){
                for(WrapAttachment wrapAttachmentObj : wrapAttachmentList) {
                    if(wrapAttachmentObj.selected == true) {
                        selectedAttachments.add(wrapAttachmentObj.att.Id);  
                    }
                }
                if(selectedAttachments.size() == 0 ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SelectAttachmentMsg));
                    return;
                }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                selectedattachmentrec = cls.getAttachmentDetails(selectedAttachments);
                String attachmentId = (SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) != null) ? SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('attachmentId')) : null;   
                AttachmentExtension__c oldAttExt = new AttachmentExtension__c();
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    oldAttExt = [SELECT Id, Classification__c, ParentId__c, Attachment__c FROM AttachmentExtension__c where Attachment__c = : attachmentId  WITH USER_MODE limit 1 ];
                }
                for(Attachment attch :selectedattachmentrec ){
                    Attachment a = new Attachment(); //Clone attachment
                    if(Schema.sObjectType.Attachment.fields.Name.isUpdateable()) {
                        a.Name = attch.Name;
                    }
                    if(Schema.sObjectType.Attachment.fields.Body.isUpdateable()) {
                        a.Body = attch.Body;
                    }
                    if(Schema.sObjectType.Attachment.fields.Description.isUpdateable()) {
                        a.Description = attch.Description;
                    }
                    //if(Schema.sObjectType.Attachment.fields.ParentId.isUpdateable()) {
                        a.ParentId = parentObjectId;// CRUD/FLS False Positive: Id std field 
                    //}
                    //if(Schema.sObjectType.Attachment.isUpdateable()) {
                        a.id = attachmentId; // CRUD/FLS False Positive: Id std field 
                    //}
                    attachmentListToBeInsrted.add(a);
                    AttachmentOldMap.put(attch.id, a);
                }
                srList = cls.updateAttachments(attachmentListToBeInsrted);                  //Insert clone Attachment
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    attachmentExtensionList = [SELECT Attachment__c, Classification__c FROM AttachmentExtension__c WHERE Attachment__c IN: selectedAttachments WITH USER_MODE limit 1];
                } 
                Map < Id, String > AttachExtMap = new Map < Id, String > ();
                for (AttachmentExtension__c attExt: attachmentExtensionList) {
                            AttachExtMap.put(attExt.Attachment__c, attExt.Classification__c);
                }

                for (AttachmentExtension__c attachmentExtObj: attachmentExtensionList) {
                    Attachment attachment = new Attachment();
                    attachment = AttachmentOldMap.get(attachmentExtObj.Attachment__c);

                    AttachmentExtension__c attExtObj = new AttachmentExtension__c();
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isUpdateable()) {
                        attExtObj.Classification__c = AttachExtMap.get(attachmentExtObj.Attachment__c);
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isUpdateable()) {
                        attExtObj.Attachment__c = attachment.Id;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isUpdateable()) {
                        attExtObj.ParentId__c = parentObjectId;  
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isUpdateable()) {
                        attExtObj.Description__c = attachment.Description;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.IsCloned__c.isUpdateable()) {
                        attExtObj.IsCloned__c = true;
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isUpdateable()) {
                        attExtObj.AttachmentType__c = 'Attachment';
                    }
                    if(Schema.sObjectType.AttachmentExtension__c.isUpdateable()) {
                        attExtObj.id = oldAttExt.id; // CRUD/FLS False Positive: Id field 
                    }
                    attachmentExtensionNewList.add(attExtObj);
                }
                if(Schema.sObjectType.AttachmentExtension__c.isUpdateable()) {
                    srAttachmentExt = Database.update(attachmentExtensionNewList, true, AccessLevel.USER_MODE); //clone AttachmentExtension with classification value
                }
                isUlFromWorkspace = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, Label.AttachmentEditSuccessMsg));
            }
            getWrapperAttachment();

    }


}