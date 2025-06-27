/**
**/
global with sharing class AttachmentAddCtrl { 
    public String parentObjectId ;

    // This is related for save / save Close Modal. 
    public Boolean isAttachedSuccess{get;set;}
    public Boolean isSaveClose{get;set;}
    public Boolean renderWorkSpace{get;set;}
    public String attachTableType{get;set;}

    public Boolean isUlFromWorkspace { get; set; }
    public String isDigitalSign {get;set;}//to get document related to digital signature
    public String classificationVal {
        get;
        set;
    }
    public Boolean hideWorkSpace {get;set;}
    public String attachClassifications;
    public String document {
        get;
        set;
    }
    public String pageBlockId ;
    private transient Map<String,Integer> allowedClassificationCountMap; 
    public Map<String,Integer> classificationCountMap;
    public List < wrapAttachment > wrapAttachmentList {
        get;
        set;
    }

    public set < Id > selectedAttachments {
        get;
        set;
    }
    public Attachment attachmentObj {
        get;
        set;
    }
     public List < wrapFields > wrapFieldsList {
        get;
        set;
    }
    public Integer fileSize { get; set; }
    public String saveBehaviour{get;set;}
    public AttachmentExtension__c attExtObj {get;set;} 
    String ns = AppUtils.getNameSpacePrefix();
    global AttachmentAddCtrl (){
    isUlFromWorkspace = false;
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
        attExtObj = new AttachmentExtension__c();
        wrapFieldsList = new List<wrapFields>();
        wrapAttachmentList = new List<wrapAttachment>();
        attachmentObj = new Attachment();
        parentObjectId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('parentId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 

        pageblockId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('pBlockId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        
        // Getting Attachment Table Type Through URL..
        attachTableType = SFDCEncoder.SFDC_JSENCODE(SFDCEncoder.SFDC_HTMLENCODE(apexpages.currentpage().getparameters().get('attchTableType')));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        attachTableType = '\''+ attachTableType + '\'';

        attachClassifications = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('classification'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        document = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('document'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        isDigitalSign = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('isDigiSign'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        classificationCountMap = new Map<String,Integer>();
        getWrapperAttachment();
        classificationsList = getClassfications();
        //This is used to fectch additional fields. Json format is store in field.
        String jsonField;
        if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
            List<PageBlockConfig__c> pageBlockList = [Select AdditionalFieldJSON__c from PageBlockConfig__c Where id=:pageblockId WITH USER_MODE];
            for(PageBlockConfig__c pageBlock: pageBlockList){
                jsonField = pageBlock.AdditionalFieldJSON__c;
            }
        }
        //Here we get json store in config.
        if(String.isNotEmpty(jsonField)) {
            wrapFieldsList = (List<wrapFields> )JSON.deserialize(jsonField, List<wrapFields>.class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
        }
    }
    
    public void getWrapperAttachment(){
        wrapAttachmentList.clear();
        if(wrapAttachmentList == null || wrapAttachmentList.size()==0) {
            list<id> attchmentsIds = new list<id>();
            list<Attachment> attach = new list<Attachment>();
            List<AttachmentExtension__c> attachExtList = new List<AttachmentExtension__c>();
            if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                attachExtList = WithSharingHelper.getRelatedAttachmentmentExtension();            
            }
            for(AttachmentExtension__c ae : attachExtList) {
                attchmentsIds.add(ae.Attachment__c);
            }
            if(Attachment.sObjectType.getDescribe().isAccessible() == true){
                attach = WithSharingHelper.getRelatedAttachments(attchmentsIds);
            }
            for(Attachment a: attach) {              
                wrapAttachmentList.add(new wrapAttachment(a));
            }
        }
    }
    private List<selectOption> getClassfications(){
        List<selectOption> options = new List<selectOption>();
        try{
            Id queryPageblockId = Id.valueOf(String.escapeSingleQuotes(pageblockId));
            List<PageBlockConfig__c> pgblock = new List<PageBlockConfig__c>();
            if(Schema.sObjectType.PageBlockConfig__c.isAccessible()){
                pgblock = [Select SaveAttachmentBehaviour__c,AttachmentClassifications__c,ClassificationFieldAPIName__c from PageBlockConfig__c Where id =: queryPageblockId  WITH USER_MODE];//here pageblock contains both attachemnt classficatioj fields
            }
            String classficationsString;
            String sobjectName = String.valueOf(((Id)parentObjectId).getSobjectType());//This is used to get sojectname from parentObjectId
            // Read Save Behaviour for page Block
            if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).SaveAttachmentBehaviour__c)){
                saveBehaviour = SFDCEncoder.SFDC_JSENCODE(pgblock.get(0).SaveAttachmentBehaviour__c);
            }
            if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).ClassificationFieldAPIName__c)){//this block is used to get feld api name in which classfication are store comma separated
                parentObjectId = String.escapeSingleQuotes(parentObjectId);
                String query1 = 'Select ' + String.escapeSingleQuotes(pgblock.get(0).ClassificationFieldAPIName__c)  + ' From ' + String.escapeSingleQuotes(sobjectName) + ' Where Id = : parentObjectId';
                Sobject sobj1;
                if(AppUtils.isObjectAccessible(sobjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sobj1 = Database.query(String.escapeSingleQuotes(query1),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind
                }
                if(AppUtils.getFieldValue(sobj1,pgblock.get(0).ClassificationFieldAPIName__c) == null){
                    CustomExceptions.logException(System.Label.ClassficationDoesNotExist, false,true);//in this we can get relationship field and also normal fields so we use apputils method

                }else{
                    classficationsString = (String)AppUtils.getFieldValue(sobj1,pgblock.get(0).ClassificationFieldAPIName__c);
                }

            }else if(pgblock.size() > 0 && String.isNotEmpty(pgblock.get(0).AttachmentClassifications__c)){//this block is used to get classification from normal classgication field.
                classficationsString = pgblock.get(0).AttachmentClassifications__c;

            }else{// this block is used to get classfications from sobject level
                if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
                    List<SobjectConfig__c> sobjectConfig = [Select AttachmentClassifications__c from SobjectConfig__c Where Name =: sobjectName  WITH USER_MODE];
                    classficationsString = sobjectConfig.get(0).AttachmentClassifications__c;
                }
            }
            if(String.isNotEmpty(classficationsString)){
                String [] sobjectdataSeparatedList1 = classficationsString.split(';');
                for(String classification : sobjectdataSeparatedList1) {
                    options.add(new selectOption(classification.trim(), classification.trim()));
                }

            }
        }catch (Exception ex){
            String errorMessage = AppUtils.handleSystemExceptionMsg(ex);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errorMessage);
            ApexPages.addMessage(msg);
        } 
        return options;
    }
    
    /*
        This Method is called when save and close modal button
    */
    global void addAttachmentCloseModal(){
        isSaveClose = true;
        addAttachment();
    }

    /*public addAttachmentUnCloseModal(){
        isSaveClose = false;
        addAttachment();
    }*/
    
    //Prajakta: Removed code from getter setter because try catch was not working properly. So created getClassfications() new method and in constructor assigned that method to getter setter.
    public List<selectOption> classificationsList{get;set;}
    public void addAttachment() {        
        try{            
           SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
           Boolean errorPresent = false; 
           if( fileSize > 25599158){
	            String s = 'This file exceeds the maximum size limit of 25MB.';
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, s));
            }
            else{
	           Boolean addAttachment =  allowAddAttachment();
	           if(addAttachment){
	                for(wrapFields wrap : wrapFieldsList){
	                    if(attExtObj.get(wrap.fieldName) == null && wrap.requiredField == true){
	                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(System.Label.AttachmentAdditionalField, new List<String>{wrap.fieldLabel}));
	                        ApexPages.addMessage(errorMsg);   
	                        errorPresent = true;//When error is present we make it as true. 
	                        isSaveClose = false;
	                    }   
	                } 
	             if(attachmentObj.Body == null){
	                    isUlFromWorkspace = false;
	                    isSaveClose = false;
	                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.DocumentRequiredLabel);
	                    ApexPages.addMessage(errorMsg);
	                    if(attachmentObj.Description== null){
	                     isUlFromWorkspace = false;
	                    ApexPages.Message errorMsg1= new ApexPages.Message(ApexPages.Severity.ERROR, Label.AttachmentDescriptionRequiredLabel);
	                    ApexPages.addMessage(errorMsg1); 
	                    attachmentObj = new Attachment();
	                    }
	             }else if(attachmentObj.Description== null ){
	                    isUlFromWorkspace = false;
	                    isSaveClose = false;
	                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.AttachmentDescriptionRequiredLabel);
	                    ApexPages.addMessage(errorMsg); 
	                    attachmentObj = new Attachment();
	            //When error is not present then attachement is save
	            }else if(errorPresent == false){
	                //FeedItem f = new FeedItem();
	                Attachment a = new Attachment();
	                Database.SaveResult[] srList = new List<Database.SaveResult>();
	                if(Schema.sObjectType.Attachment.isCreateable()){
	                
	                    List<Attachment> attachmentList = new List<Attachment>();
	                    if(Schema.sObjectType.Attachment.fields.Name.isCreateable()){
	                        a.Name = attachmentObj.Name;
	                    }
	                    if(Schema.sObjectType.Attachment.fields.Body.isCreateable()){
	                        a.Body = attachmentObj.Body;
	                    }
	                    if(Schema.sObjectType.Attachment.fields.Description.isCreateable()){
	                        a.Description = attachmentObj.Description;
	                    }
	                    //if(Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
	                        a.ParentId = parentObjectId;   //CRUD/FLS False +ve std id field               
	                    //}
	                    attachmentList.add(a);
	                    if(Schema.sObjectType.Attachment.isCreateable()){
	                        srList = cls.insertAttachments(attachmentList);
	                    }
	                } else {
	                    isSaveClose = false;
	                    String errorMessage = 'You lack permission to create the Attachment Object, please Contact support and have this permission enabled to add attachments';
	                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
	                    ApexPages.addMessage(errorMsg);
	                }   
	                // Iterate through each returned result
                    List<AttachmentExtension__c> listOfAttExtObj = new  List<AttachmentExtension__c>();
	                for (Database.SaveResult sr : srList) {
	                    if (sr.isSuccess()) {
	                        if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
	                            // Operation was successful, so get the ID of the record that was processed                      
	                            AttachmentExtension__c attExtObj = new AttachmentExtension__c();                                           
	                          
	                            if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isCreateable()){
	                                attExtObj.Classification__c = classificationVal ;
	                            }
	                            //FeedItem fi = [SELECT RelatedRecordId FROM FeedItem WHERE id =: f.id];
	                            //ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE id =: fi.RelatedRecordId];                          
	                            if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable()){
	                                attExtObj.Attachment__c = a.Id;
	                            }
	                            if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isCreateable()){
	                                attExtObj.Description__c = a.Description;
	                            }
	                            if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable()){
	                                attExtObj.ParentId__c = parentObjectId;  
	                            }
	                            if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable()){
	                                attExtObj.AttachmentType__c = 'Attachment';                       
	                            }
	                            if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
	                                listOfAttExtObj.add(attExtObj);
	                            }
	                            if(classificationCountMap.get(classificationVal) == null){
	                                classificationCountMap.put(classificationVal,1);    
	                            }else{
	                                classificationCountMap.put(classificationVal,classificationCountMap.get(classificationVal) + 1);
	                            }
	                            isAttachedSuccess = true;
	                            isUlFromWorkspace = false;
	                            //feedItemIds.add(sr.getId());
	                        } else {
	                            isAttachedSuccess = false;
	                            isUlFromWorkspace = false;
	                            String errorMessage = 'You lack permission to create the AttachmentExtension__c Object, please Contact support and have this permission enabled to add attachments';
	                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
	                            ApexPages.addMessage(errorMsg);
	                        }
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.AttachmentAddSuccessMsg));
	                        
	                        
	                    } else {              
	                        isSaveClose = false;             
	                        for(Database.Error err : sr.getErrors()) {
	                        }
	                    }
	                }   
	                if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
                        insert as user listOfAttExtObj;
                    }
	                attachmentObj = new Attachment();
	            }
            }
        } 
        } catch(DMLException e) {
            String errorMessage = AppUtils.handleSystemExceptionMsg(e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
            ApexPages.addMessage(myMsg);
        } finally {
            if(attachmentObj != null) {
                attachmentObj.Body = null;
            }
        }        
    }  
    
    private boolean allowAddAttachment(){
        boolean addAttachment = true;
        pageBlockId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('pBlockId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        List<PageAttachmentConfig__c> pageAttachmentConfigList = new List<PageAttachmentConfig__c>();
        if(PageAttachmentConfig__c.sObjectType.getDescribe().isAccessible() == true){  
            pageAttachmentConfigList = [SELECT Id,Name,HideForProfile__c,MaximumAttachmentCount__c,Classification__c,AttachmentCount__c 
                                        FROM PageAttachmentConfig__c
                                        WHERE PageBlockConfig__c = : pageBlockId
                                        WITH USER_MODE
                                    ];
        }
        allowedClassificationCountMap = new Map<String,Integer>();
        if(pageAttachmentConfigList.size() > 0){                
            for(PageAttachmentConfig__c pageAttachmentConfig : pageAttachmentConfigList ){      
                if(pageAttachmentConfig.Classification__c != null){                          
                    allowedClassificationCountMap.put(pageAttachmentConfig.Classification__c.toLowerCase(),(Integer)pageAttachmentConfig.MaximumAttachmentCount__c);   
                }
            }
            List<String> types = new List<String>();
            types.addAll(allowedClassificationCountMap.keySet());
            if(types.size() > 0){
                String classType = '(';
                for(String typeClass : types){
                    classType += '\'' + typeClass + '\',';
                }
                classType = classType.removeEnd(',');
                classType+= ')';
                String classificationQuery = '';
                if(!classType.equals('()')){
                    classificationQuery = 'and Classification__c IN :types ';
                }
                AggregateResult[] groupedResults;
                if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                    String parentId = string.escapeSingleQuotes(SFDCEncoder.SFDC_JSENCODE(parentObjectId));
                    String countQuery = 'select count(id),Classification__c from AttachmentExtension__c where parentId__c = :parentId ' + String.escapeSingleQuotes(classificationQuery) + ' group by Classification__c'; //sf review 
                    groupedResults  =  Database.Query(String.escapeSingleQuotes(countQuery),AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is static bind
                }
                Map<String,Integer> classificationCnt = new Map<String,Integer>();
                for(AggregateResult ext : groupedResults){
                    if(ext.get(AppUtils.getNamespacePrefix() + 'Classification__c') != null){
                    classificationCnt.put(String.valueOf(ext.get(AppUtils.getNamespacePrefix() + 'Classification__c')).toLowerCase(),(Integer)ext.get('expr0'));
                    }       
                }
                if(classificationCnt.size () > 0  && allowedClassificationCountMap.size () > 0 ){
                    for(String classificationType :allowedClassificationCountMap.keySet()){ 
                        if(allowedClassificationCountMap.get(classificationType) != null){
                            if(allowedClassificationCountMap.get(classificationVal.toLowerCase()) <= classificationCnt.get(classificationVal.toLowerCase())){
                                String errorMessage = Label.AttachmentLimitReached + ' ' + classificationVal;
                                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
                                ApexPages.addMessage(errorMsg);
                                addAttachment = false;
                            }
                        }
                    }
                }
            }
        }      
      return addAttachment;
    } 
public void processSelected() {
    Savepoint sp = Database.setSavepoint();
     try{  
        SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
        selectedAttachments = new set < Id > ();
        Database.SaveResult[] srList = new List<Database.SaveResult>();
        Database.SaveResult[] srAttachmentExt = new List < Database.SaveResult > ();
        List<Attachment> attachmentListToBeInsrted = new List<Attachment>();   
        List < AttachmentExtension__c > attachmentExtensionNewList = new List < AttachmentExtension__c > ();
        List < AttachmentExtension__c > attachmentExtensionList = new List < AttachmentExtension__c > ();
        list<Attachment>selectedattachmentrec = new list<Attachment>();
        
                    //list<Attachment>existingattachmentrec = new list<Attachment>();
//List<string> existingAttachNames= new List<string>();


        Map < Id, Attachment > AttachmentOldMap = new Map < Id, Attachment > ();

        if (Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.AttachmentExtension__c.isCreateable() && Attachment.sObjectType.getDescribe().isAccessible() == true) {
            for(wrapAttachment wrapAttachmentObj : wrapAttachmentList) {
                if(wrapAttachmentObj.selected == true ) {
                    selectedAttachments.add(wrapAttachmentObj.att.Id);  
                }                        
            }
            if(selectedAttachments.size() == 0 ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SelectAttachmentMsg));
                return;
            }

            selectedattachmentrec = cls.getAttachmentDetails(selectedAttachments);
            
            for(attachment attch :selectedattachmentrec ){
                Attachment a = new Attachment(); //Clone attachment                           
                if(Schema.sObjectType.Attachment.fields.Name.isCreateable()){
                    a.Name = attch.Name;
                }
                if(Schema.sObjectType.Attachment.fields.Body.isCreateable()){
                    a.Body = attch.Body;
                }
                if(Schema.sObjectType.Attachment.fields.Description.isCreateable()){
                    a.Description = attch.Description;                          
                }
                //if(Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
                    a.ParentId = parentObjectId;    //CRUD/FLS False +ve std id field             
                //}
                attachmentListToBeInsrted.add(a);
                AttachmentOldMap.put(attch.id, a);
            }
                        
            if(Schema.sObjectType.Attachment.isCreateable()){
                srList = cls.insertAttachments(attachmentListToBeInsrted); //Insert clone Attachment
            }
            
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
                if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isCreateable()){
                    attExtObj.Classification__c = AttachExtMap.get(attachmentExtObj.Attachment__c);
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable()){
                    attExtObj.Attachment__c = attachment.Id;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentName__c.isCreateable()){
                    attExtObj.AttachmentName__c = attachment.name;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.Description__c.isCreateable()){
                    attExtObj.Description__c = attachment.Description;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable()){
                    attExtObj.ParentId__c = parentObjectId;   
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.IsCloned__c.isCreateable()){
                    attExtObj.IsCloned__c = true; 
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable()){
                    attExtObj.AttachmentType__c = 'Attachment';                     
                }
                attachmentExtensionNewList.add(attExtObj);
                          
            }
            if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
                srAttachmentExt = Database.insert(attachmentExtensionNewList, true, AccessLevel.USER_MODE);
            }
            for (Database.SaveResult sr : srAttachmentExt) {
                if (sr.isSuccess()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, Label.AttachmentAddSuccessMsg));
                }
            }
            isUlFromWorkspace = true;
            
        } else {
                String errorMessage = 'You lack permission to create the Attachment Object, please Contact support and have this permission enabled to add attachments';
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
                ApexPages.addMessage(errorMsg);
                isUlFromWorkspace = true;
        } 
        
        
        getWrapperAttachment();
        
        } catch(DMLException e) {
            Database.rollback(sp);
            isUlFromWorkspace = true;
            String errorMessage = AppUtils.handleSystemExceptionMsg(e);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, errorMessage);
            ApexPages.addMessage(myMsg);
        } 
    }
    
    public with sharing class wrapAttachment {
        public Attachment att {
            get;
            set;
        }
        public Boolean selected {
            get;
            set;
        }
 
        public wrapAttachment(Attachment a) {
            att = a;
            selected = false;
        }
    }
    //This wrapper class is created to add additional field.
     public with sharing class wrapFields{
        public String fieldName{get;set;}
        public String fieldLabel{get;set;}   
        public Boolean requiredField{get;set;}   
       
    }
}