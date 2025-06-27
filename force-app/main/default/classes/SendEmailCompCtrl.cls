/**
    Controller for Handling Emails Component
    ************************************************************************************************************************
    Audit History
    ************************************************************************************************************************
    1/11/2018   Atul Naik                   Created
    ************************************************************************************************************************
    23/09/2019  Yogeshkumar Gaikwad         Added support for Autocomplete drop down for Internal,External and Collab Groups
*/
global with sharing class SendEmailCompCtrl {
    // there will be multiple calls to this method or it can be only one call
    // parentId is mandatory
    // in first call taskId will be null
    // if it is isLast then send email 

   //  Chunking Code While Sending Multiple Email...

    // Added to identify whether user is external or internal
    public boolean isExternal {
          get {
            User user = [SELECT ContactId FROM User WHERE Id =:UserInfo.getUserId() AND IsActive=true WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(user.ContactId != null){
                return true;
            }else {
                return false;
            }
        }
    }
    public String govGrantPleaseWaitIconURL {
        get{
            govGrantPleaseWaitIconURL = AppUtils.getIcons('govGrantPleaseWaitIcon');
            return govGrantPleaseWaitIconURL;

        }
        set;
    }

    public boolean isAttachmentEnabled {
        get {           
            return KeyValueHolderHelper.getBooleanValue('EnableEmailAttachment') == null ? false : KeyValueHolderHelper.getBooleanValue('EnableEmailAttachment');
        }
    }

    public DynamicLayoutHolder layoutHolder {get;set;}
    public String parentIdVal{get;set;}
    public static List<ContentVersion> contentVersionLinkList {get;set;}
    public static List<String> contentVersionIdList {get;set;}
    public static Id PageDataHolderId;
    public static Boolean isFilesLinkBlock{get;set;}
    public static String queryFieldName{get;set;}
    public static String filesTableName{get;set;}
    public static String parameterVal{get;set;}
    public string namespacePrefix{get;set;}
    public string activePageName{get;set;}

    public String internalLink {get;set;}
    public String externalLink {get;set;}
    public String recordName {get;set;}
    public String userOrganization {get;set;}
    public String sender {get;set;}

    @TestVisible
    global with sharing class ResultWrapper{
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String collaborationType;
        @AuraEnabled
        public Integer memberCount;
        @AuraEnabled
        public String objType;
        public ResultWrapper(Sobject sobj,Boolean isGroup){
            this.id = (Id)sobj.get('Id');
            String strId = String.valueof(Id);
            if(strId.startsWith('005')){
                this.objType = 'User';
            }else {
                this.objType = 'Contact';
            }

            this.name = (String)sobj.get('Name');          
            if(isGroup){
                this.collaborationType = (String)sobj.get('CollaborationType');
                this.memberCount = (Integer)sobj.get('MemberCount');
            }
            else{
                this.email = (String)sobj.get('Email');
            }
        }
    }

    global SendEmailCompCtrl(){
        try{
            loadInputParams();
        }catch (Exception ex) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL,  ex.getMessage() ) );
        }

    }

    private void loadInputParams() {
        if(parentIdVal == null && ApexPages.currentPage() != null){
            parentIdVal = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('parentIdVal') == null? (ApexPages.currentPage().getParameters().get('parentId') == null? '':ApexPages.currentPage().getParameters().get('parentId')): ApexPages.currentPage().getParameters().get('parentIdVal'));
        }
        namespacePrefix = AppUtils.getNameSpacePrefix();
        
        if(parentIdVal != '' && KeyValueHolderHelper.getBooleanValue('SendEmaiBody')){
            String bodySetting = KeyValueHolderHelper.getTextValue('SendEmaiBody');
            GlobalConfig__c gcInstance = GlobalConfig__c.getInstance();
            
            if(bodySetting.contains('Internal_URL') && gcInstance.InternalURLDomain__c != null){
                internalLink = gcInstance.InternalURLDomain__c + '/' +parentIdVal ;
            }
            if(bodySetting.contains('External_URL') && gcInstance.CommunityURLDomain__c != null){
                externalLink = gcInstance.CommunityURLDomain__c + '/' +parentIdVal ;
            }
            if(bodySetting.contains('EGMS_ID')){
                String query = 'SELECT Id, Name FROM '
                + String.valueOf(Id.ValueOf(parentIdVal).getSobjectType())
                + ' WHERE Id=:parentIdVal WITH USER_MODE LIMIT 1';
                try{
                    List<SObject> record = Database.query(query);//SOQL Injection - False +ve -Dynamic parts of the query string(Object name) is fetched from Schema Method to prevent SOQL Injection //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    recordName = String.valueOf(record[0].get('Name'));
                }catch(Exception e){
                    recordName = '';
                }
            }
            if(bodySetting.contains('Sender_Org')){
                Id accountId = [SELECT OrganizationId__c FROM User WHERE id=:UserInfo.getUserId() LIMIT 1].OrganizationId__c;  // CRUD  FLS- False +ve - std obj removed  WITH SECURITY_ENFORCED
                if(accountId != null){
                    userOrganization = [SELECT Name FROM Account WHERE Id =:accountId LIMIT 1].Name;  //CRUD  FLS- False +ve - std obj WITH SECURITY_ENFORCED removed because of SPI
                }
            }

            sender = (bodySetting.contains('Sender_Email') ? UserInfo.getUserEmail()+', ':'') + (bodySetting.contains('Sender_Name') ? UserInfo.getName() : '');
            
        }


        //Show or Hide for File Attachement block.............
        isFilesLinkBlock = false;  
        //Task 163529: NED - Performance optimization Auguest 2021 release start       
        String StrMeta  = KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') != null ? KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') : '';		       
            if(String.isNotBlank(StrMeta)){              
                if(StrMeta.contains('?')){
                     String PageName = StrMeta.split('\\?').size() > 0 ? StrMeta.split('\\?')[0] : '';
                    if(PageName.contains('/apex/')){                    
                     activePageName  = PageName.substringAfter('/apex/') !=null? PageName.substringAfter('/apex/'): namespacePrefix + 'FilesLinksPage';                     
                     String checkValueParam = StrMeta.split('\\?').size() > 0? StrMeta.split('\\?')[1] : '';
                     String tableName = checkValueParam.split('\\&').size() > 0 ? checkValueParam.split('\\&')[0] : '';
                     filesTableName = tableName.split('\\=').size() > 0  ? tableName.split('\\=')[1] : 'FilesLink';                   
                     }                    
                }else
                        {
                            activePageName = namespacePrefix + 'FilesLinksPage';
                            filesTableName = 'FilesLink'; 
                        }  
            }else
                {
                    activePageName = namespacePrefix + 'FilesLinksPage';
                    filesTableName = 'FilesLink'; 
                }  
            parameterVal = '?isdtp=vw';      			
            isFilesLinkBlock = KeyValueHolderHelper.getBooleanValue('SendEmailFilesLinkConfigHolder') != null ? true : false;            
            if(String.isNotBlank(StrMeta)){               
            queryFieldName =  StrMeta.split('&')[1].split('=').size() > 1 ? StrMeta.split('&')[1].split('=')[1] : '';
            }
            //Task 163529: NED - Performance optimization Auguest 2021 release end       
            if(isFilesLinkBlock){
                if(String.isNotBlank(filesTableName)){
                throw new CustomExceptions.RequiredException(System.Label.FilesTableNameMissing);
            }
        }
    }     

    @RemoteAction
    global static List<ContentVersion> getContentVersionListVal(String layoutHolderId){
        contentVersionLinkList = new List<ContentVersion>();
        try{
            contentVersionIdList = new List<String>();
            //String contentVersionIdStr = KeyValueHolderHelper.getAdminQuestionValue('SendEmailContentVersionIdHolder');
            PageDataHolder__c pageDataHolder;
            if(Schema.sObjectType.PageDataHolder__c.isAccessible()){
            pageDataHolder = [select id, JSONData1__c from PageDataHolder__c 
                                                where id=:layoutHolderId WITH USER_MODE];
            }

            if(pageDataHolder.JSONData1__c != null) {
                contentVersionIdList = (List<String>)JSON.deserialize(pageDataHolder.JSONData1__c, List<String>.Class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
            }
            if(contentVersionIdList !=null && contentVersionIdList.size() > 0){
                /// Bug 167786: Internal: Send email- Attach file functionality is not working (links) start
                //String queryFieldName = KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') != null ? KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder'):'';
                String StrMeta1 = KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') != null ? KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder'):'';
                String queryFieldName = StrMeta1.split('&')[1].split('=').size() > 1 ? StrMeta1.split('&')[1].split('=')[1] : ''; 
                //Bug 167786: Internal: Send email- Attach file functionality is not working (links) end               
                //List<String> contentVersionIdList = contentVersionIdStr.split(',');
                String queryContentVersion = '';
                if(queryFieldName != null && queryFieldName !=''){
                    queryContentVersion = 'SELECT Id,Title,Description,ContentUrl,'+string.escapeSingleQuotes(queryFieldName)+
                    ' FROM ContentVersion WHERE Id IN :contentVersionIdList and IsLatest = true';// WITH SECURITY_ENFORCED removed because of SPI
                }else{
                    queryContentVersion = 'SELECT Id,Title,Description,ContentUrl  FROM ContentVersion WHERE Id IN :contentVersionIdList and IsLatest = true';// WITH USER_MODE removed because of SPI
                }

                contentVersionLinkList = Database.query(queryContentVersion);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            }
            return contentVersionLinkList;

        }catch(Exception objException){
            return contentVersionLinkList;
        }
    }

    @RemoteAction
    global static List<ResultWrapper> getRecordsNew(Map<String, Object> paramatersMap ){
        String searchString = (String)paramatersMap.get('searchString');
        String objectApiName = (String)paramatersMap.get('objectApiName');
        String fieldToDisplay =  (String)paramatersMap.get('fieldToDisplay')!=null ?  (String)paramatersMap.get('fieldToDisplay') : '';
        String fieldBindToTarget = (String)paramatersMap.get('fieldBindToTarget');
        String fieldToFilter = (String)paramatersMap.get('fieldToFilter');
        String selectedRecordIds = (String)paramatersMap.get('selectedRecordIds');

     
        String searchType = (String)paramatersMap.get('searchType');
        Boolean isExternalUser = false;
        if(searchType.trim().equals('External')){
            isExternalUser = true;
        }
        List<Sobject> records;
        List<ResultWrapper> resultWrappersWithSingleOccourance = new List<ResultWrapper>();
        List<ResultWrapper> resultWrappers = new List<ResultWrapper>();
        try{

            List<String> lstSelectedRecordIds = selectedRecordIds.split(',');           
            Set<String> filteredRecordIds = new Set<String>();
            Set<String> filteredRecordIdsSanitized = new Set<String>();
            if(lstSelectedRecordIds.size()>0){
                filteredRecordIds.addall(lstSelectedRecordIds);
            }

            if(filteredRecordIds.size()>0){

                  // segrgate ids as user or contact ids     
                List<Id>filteredUserIds = new List<Id>();
                List<Id>filteredContactIds = new List<Id>();
                for (String filteredRecordId : filteredRecordIds) {
                    if(filteredRecordId.startsWith('005')){
                        filteredUserIds.add(filteredRecordId);
                    }
                   if(filteredRecordId.startsWith('003')){
                        filteredContactIds.add(filteredRecordId);
                   }
                   filteredRecordIdsSanitized.add(filteredRecordId);
                } 
                Set<String>filteredEmails = new Set<String>();
                List<User>filteredUserDetails = filteredUserIds.size()>0 ? [SELECT Email FROM User WHERE Id IN:filteredUserIds WITH USER_MODE] : null;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                List<Contact>filteredContactDetails = filteredContactIds.size()>0 ? [SELECT Email FROM Contact WHERE Id IN:filteredContactIds WITH USER_MODE] : null;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(filteredUserDetails != null && filteredUserDetails.size()>0){
                    for(User user : filteredUserDetails){
                        filteredEmails.add(user.Email);
                    }
                }
                if(filteredContactDetails != null && filteredContactDetails.size()>0){
                    for(Contact contact : filteredContactDetails){
                        filteredEmails.add(contact.Email);
                    }
                }
            }
            String userQuery = '';
            if(objectApiName.toLowercase() == 'user' ){
                //User Story 157140: LAHSA : Send Email Component Enhancements
                // if(isExternalUser){
                //userQuery = 'SELECT '+SchemaManager.getFields('id,email,'+fieldToDisplay)+' FROM '+objectApiName+' WHERE Id NOT IN :filteredRecordIds AND '+fieldToFilter+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND contactId != NULL AND IsActive=true WITH SECURITY_ENFORCED';
                // }
                List<Sobject> InternalContacts = new List<Sobject>();
                if(!isExternalUser || searchType == 'Both'){    //&& searchType != 'Both'){objectApiName 
                    userQuery = 'SELECT '+string.escapeSingleQuotes(SchemaManager.getFields('id,email,'+fieldToDisplay))+' FROM '+string.escapeSingleQuotes(objectApiName)+' WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND UserType = \'Standard\' AND IsActive=true WITH USER_MODE';
                    if(AppUtils.isObjectAccessible(objectApiName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                        if( SchemaManager.isAccessible(objectApiName, 'Email,'+fieldToDisplay)){
                            records = Database.query(userQuery);//NOPMD SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                        }
                    }
                    for(Integer count=0;count<records.size();count++){
                        resultWrappers.add(new ResultWrapper(records[count],false));
                    }

                    //User Story 158413: Enhancement - Send Email - adding internal contacts who are not users
                    String contactQuery = 'SELECT Id,Name,Email FROM Contact WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND Email != NULL AND Account.RecordType.name = \'Internal\' WITH USER_MODE';
                    if(AppUtils.isObjectAccessible('Contact')){   //CRUD False +ve with the help of AppUtils we have performed check
                        if( SchemaManager.isAccessible('Contact', 'Name,Email,'+fieldToFilter)){//FLS False +ve with the help of SchemaManager we have performed check
                            InternalContacts = Database.query(contactQuery);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                        }
                    }
                    for(Integer count=0;count<InternalContacts.size();count++){                           
                        resultWrappers.add(new ResultWrapper(InternalContacts[count],false));
                    }
                }
                
                // if(searchType == 'Both'){
                //     userQuery = 'SELECT '+SchemaManager.getFields('id,email,'+fieldToDisplay)+' FROM '+objectApiName+' WHERE Id NOT IN :filteredRecordIds AND '+fieldToFilter+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND IsActive=true WITH SECURITY_ENFORCED';
                // }

                // Added support for contact search
                List<Sobject> contacts = new List<Sobject>();
                if(isExternalUser || searchType == 'Both'){
                    String contactQuery = 'SELECT Id,Name,Email FROM Contact WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND Email != NULL AND Account.RecordType.name != \'Internal\' WITH USER_MODE';
                    if(AppUtils.isObjectAccessible('Contact')){   //CRUD False +ve with the help of AppUtils we have performed check
                        if( SchemaManager.isAccessible('Contact', 'Name,Email,'+fieldToFilter)){//FLS False +ve with the help of SchemaManager we have performed check
                            contacts = Database.query(contactQuery);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                        }
                    }
                    for(Integer count=0;count<contacts.size();count++){                           
                        resultWrappers.add(new ResultWrapper(contacts[count],false));
                    }
                }
            }
            if(objectApiName.toLowercase() == 'collaborationgroup'){
                String groupQuery = '';
                objectApiName = 'collaborationgroup';
                string ownerId = String.escapeSingleQuotes(UserInfo.getUserId());    
                groupQuery = 'SELECT CollaborationType,'+SchemaManager.getFields(fieldToDisplay)+'MemberCount FROM '+string.escapeSingleQuotes(objectApiName)+' WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND OwnerId =:ownerId WITH USER_MODE';      
                records = Database.query(groupQuery);//NOPMD SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(Integer count=0;count<records.size();count++){
                    resultWrappers.add(new ResultWrapper(records[count],true));
                }
            }
            if(objectApiName.toLowercase() == 'contact'){
                String contactQuery = 'SELECT Id,Name,Email FROM Contact WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND Email != NULL AND Account.RecordType.name != \'Internal\' WITH USER_MODE';
                List<Sobject> contacts;
                if(Schema.sObjectType.Contact.isAccessible()){
                    contacts = Database.query(contactQuery);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                }
                for(Integer count=0;count<contacts.size();count++){
                    resultWrappers.add(new ResultWrapper(contacts[count],false));
                }
            }
            Set<String> uniqueNames = new Set<String>();
             for(ResultWrapper ResultWrapperRec :resultWrappers){
                if(!uniqueNames.contains(ResultWrapperRec.name)){
                    resultWrappersWithSingleOccourance.add(ResultWrapperRec);
                    uniqueNames.add(ResultWrapperRec.name);
                }
            }
        }
        catch(Exception e){
        }
        return resultWrappersWithSingleOccourance;
    }

    @RemoteAction
    global static List<SObject> getRecords(Map<String, Object> paramatersMap ){
        List<Sobject> records = new List<Sobject>();
      
        return records;
    }


    @RemoteAction
    global static List<SObject> getCollabGroupMemberIds(Map<String, Object> paramatersMap ){
        String groupId = (String)paramatersMap.get('groupId'); 
        List<Id>groupIds = new List<Id>();
        List<Sobject> records;

        try{  
            if(!String.isBlank(groupId)){
                groupIds.add(Id.valueOf(String.escapeSingleQuotes(groupId)));
                String query = '';
                query = 'SELECT MemberId,Member.Email FROM CollaborationGroupMember WHERE CollaborationGroupId IN :groupIds AND Member.IsActive=true WITH USER_MODE';
                records = Database.query(query); //SOQL Injection - False +ve - Hole query string is staic and have no dynamic part. //CRUD/FLS False +ve As per business scenario we can't check for portal/external users            
            }   
        }
        catch(Exception e){
        }     
        return records;
    }

    @RemoteAction
   global static Map<String, Id> uploadAttachment(Map<String, Object> attributeMap){
        Map<String, Id> returnMap = new Map<String, Id>();
            String[] attachmentIdArray = new String[]{};
            Task emailObjTask;
            Attachment attachment = new Attachment();
            String content = (String)attributeMap.get('AttachmentBody');
            String attachmentId = (String)attributeMap.get('AttachmentId');
            Boolean isUploadDone = (Boolean)attributeMap.get('UploadDone');
            String taskIdStr = (String)attributeMap.get('TaskId');
            String parentId = (String)attributeMap.get('ParentId');
            Id taskId = (Id)attributeMap.get('TaskId');
                if(String.isNotEmpty(attachmentId)){
                    attachment = [SELECT Id,Body FROM Attachment WHERE Id =:attachmentId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    String newBody = '';
                    Blob AttachmentBlob = attachment.Body;
                    if(AttachmentBlob != null) {
                        newBody = EncodingUtil.base64Encode(AttachmentBlob);
                    }
                    newBody += content;
                    //attch.Body = Blob.valueOf(newBody);
                    if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isupdateable()){
                        attachment.Body = EncodingUtil.base64Decode(newBody);
                    }
                    if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.Attachment.isupdateable()){
                        upsert as user attachment;
                    }
                    returnMap.put('AttchId', attachment.Id);
                }else{
                    if(content !=null){
                        String[] base64result = safeSplit(content,',');
                        if(base64result !=null && base64result.size() > 1){

                        if(Schema.sObjectType.Attachment.fields.Body.isCreateable()){
                            attachment.Body = EncodingUtil.base64Decode(base64result[1]);
                        }
                        if(Schema.sObjectType.Attachment.fields.Name.isCreateable()){
                            attachment.Name = (String)attributeMap.get('AttachmentName');
                        }
                        if(Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
                            attachment.ParentId = (Id)attributeMap.get('TaskId');
                        }
                        if(Schema.sObjectType.Attachment.isCreateable()){
                            insert as user attachment;
                        }
                        returnMap.put('AttchId', attachment.Id);
                        }

                      }  
                }

                if(isUploadDone != null && isUploadDone){
                    emailObjTask  =  getTaskDetails(taskIdStr);
                    attachmentIdArray = getAttachmentIdOnTaskforId(taskId);
                    Boolean sendACopyToMe = (Boolean)attributeMap.get('sendACopyToMe');
                    // add to address, cc address, Bcc address in map, Subject and email body
                    String toAddress =(String)attributeMap.get('toAddress');
                     
                    String ccAddress =(String)attributeMap.get('ccAddress');
                     
                    String subject =(String)attributeMap.get('subject');
                    
                    String emailBody=(String)attributeMap.get('body');
                    String mode = (String)attributeMap.get('mode'); 
                    String bccAddress = '';
                    if(sendACopyToMe){
                        //User Story 129846: Enhancement - Send Email - Send Copy to me - change to CC instead of BCC
                        List<String> ccAddressList = new List<String>();
                        if(String.isNotBlank(ccAddress) && String.isNotEmpty(ccAddress)){
                            ccAddressList = ccAddress.split(';');
                        }
                        ccAddressList.add(UserInfo.getUserEmail());
                        ccAddress = String.join(ccAddressList, ';');
                        //bccAddress = UserInfo.getUserEmail();
                    }

                    sendEMail(emailObjTask, parentId, sendACopyToMe, attachmentIdArray, toAddress, ccAddress, bccAddress, subject, emailBody,mode);
                }
       return  returnMap;       
    }


    // Provide Array of AttachId For Task..
    private static String[] getAttachmentIdOnTaskforId(Id taskId){
        
        String[] attachmentArray = new String[]{};
        List<Attachment> attObj = [SELECT Id FROM Attachment WHERE ParentId=:taskId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        for(Attachment acc:attObj){
           attachmentArray.add(acc.Id);
        }
        //logic added for update the attachment flag
        if(attachmentArray!=null && attachmentArray.size()>0){
            Task t = [SELECT Id, Attachment__c from Task Where Id=:taskId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(Schema.SObjectType.Task.fields.Attachment__c.isUpdateable()){
                t.Attachment__c = true;
            }
            if(Schema.sObjectType.Task.isUpdateable()){
                update as user t;
            }
        }
        return attachmentArray;
    }
    
    global static Map<String, Object> sendEmail(String parentId, String taskId, Map<String, Object> attrMap, String temp) {
        return null;
    }

    @RemoteAction
    global static Map<String, Object> sendEmail(String parentId, String taskId, Map<String, Object> attrMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        String[] accId = new String[]{};
       // List<Attachment> attachObjList = new List<Attachment>();
        
        try {
            Task emailObj;
            Boolean isLast = (Boolean)attrMap.get('isLast');
            Boolean isAttachmentNotPresent = (Boolean)attrMap.get('isAttachNotPresent');
            String mode = (String)attrMap.get('mode');
            String emailFieldName = (String)attrMap.get('emailFieldName');
            String oldTaskId = (String)attrMap.get('oldTaskId');
            Boolean sendACopyToMe = (Boolean)attrMap.get('sendACopyToMe');

            String formattedToAddress =(String)attrMap.get('formattedToAddress');
            String formattedCCAddress =(String)attrMap.get('formattedCCAddress');


            // add to address, cc address, Bcc address in map, Subject and email body
            String toAddress =(String)attrMap.get('toAddress');
            String ccAddress =(String)attrMap.get('ccAddress');
            String subject = (String)attrMap.get('subject');
            
            if(KeyValueHolderHelper.getBooleanValue('SendEmaiSubject')){
                String bodySetting = KeyValueHolderHelper.getTextValue('SendEmaiSubject');
                String addToSubject = subject.startsWith('RE: ') ? 'RE: [[':'[[';
                String userOrg;
                Id accountId = [SELECT OrganizationId__c FROM User WHERE id=:UserInfo.getUserId() LIMIT 1].OrganizationId__c;//CRUD  FLS- False +ve - std obj - WITH SECURITY_ENFORCED removed because of SPI
                if(accountId != null){
                    userOrg = [SELECT Name FROM Account WHERE Id =:accountId LIMIT 1].Name;//CRUD  FLS- False +ve - std obj WITH SECURITY_ENFORCED removed because of SPI
                }
                if(bodySetting.contains('Sender_Name')){
                    addToSubject += UserInfo.getName() + (userOrg != null ?', ':'');
                }
                if(bodySetting.contains('Sender_Org') && userOrg != null){
                    addToSubject += userOrg;
                }
                subject = addToSubject + ']] - '+ (subject.startsWith('RE: ') ? subject.substring(Subject.indexOf('RE: ') + 4) : subject);
            }

            String emailBody=(String)attrMap.get('body');
            boolean enableEmailValidation = KeyValueHolderHelper.getBooleanValue('EnableEmailValidation') == null ? false : KeyValueHolderHelper.getBooleanValue('EnableEmailValidation');            
            Map<String,boolean>invalidCCEmails = new Map<String,Boolean>();
            Map<String,boolean>invalidEmails = new Map<String,Boolean>();
            if(enableEmailValidation){
                Map<String,boolean>emailValidityMap = validateEmails(split(toAddress));
                Map<String,boolean>ccemailValidityMap = validateEmails(split(ccAddress));               

                for(String email : emailValidityMap.keySet()){
                    if(!emailValidityMap.get(email)){
                        invalidEmails.put(email,false);
                    }
                }

                for(String email : ccemailValidityMap.keySet()){
                    if(!ccemailValidityMap.get(email)){
                        invalidCCEmails.put(email,false);
                    }
                }
            }
        

           
            if(invalidEmails.keySet().size() == 0 && invalidCCEmails.keySet().size() == 0){
                String bccAddress = '';
                //User Story 158751: start
                Boolean toValue = validateEmailFormat(toAddress);
                Boolean ccValue = validateEmailFormat(ccAddress);
                if(!toValue){
                    invalidEmails.put(toAddress,false);
                }
                if(!ccValue){
                    invalidCCEmails.put(ccAddress,false);
                }
                if(invalidEmails.keySet().size() == 0 && invalidCCEmails.keySet().size() == 0){
                if(sendACopyToMe){
                    //User Story 129846: Enhancement - Send Email - Send Copy to me - change to CC instead of BCC
                    List<String> ccAddressList = new List<String>();
                    if(String.isNotBlank(ccAddress) && String.isNotEmpty(ccAddress)){
                        ccAddressList = ccAddress.split(';');
                    }
                    ccAddressList.add(UserInfo.getUserEmail());
                    ccAddress = String.join(ccAddressList, ';');
                    //bccAddress = UserInfo.getUserEmail();
                }
                if(String.isEmpty(taskId)) {
                    // code is added to check whether activity is enabled on sobject
                    Schema.SObjectType objectAPIName = ((Id)parentId).getSObjectType();
                    String strObjAPIName = String.valueOf(objectAPIName);
                    Set<String>activityEnabledObjects = getObjectsWithActivitiesEnabled();
                    if(!activityEnabledObjects.contains(strObjAPIName)){
                        returnMap.put('ErrorMsg', 'Please Enable Allow Activities on "'+(Id.valueOf(parentId)).getSObjectType().getDescribe().getLabel()+'"');
                        returnMap.put('IsSuccess', false);
                        return returnMap;
                    }

                    emailObj = insertTaskRecord(parentId, mode, emailFieldName, oldTaskId, toAddress, ccAddress, subject, emailBody,sendACopyToMe,formattedToAddress,formattedCCAddress);
                    taskId = emailObj.Id+''; 
                } else {
                    emailObj = getTaskDetails(taskId);
                }

                if(isAttachmentNotPresent){
                    sendEMail(emailObj, parentId, sendACopyToMe, accId, toAddress, ccAddress, bccAddress, subject, emailBody,mode);              
                }
                    
                returnMap.put('TaskId', taskId);
                // returnMap.put('AttachId', '');
                returnMap.put('IsSuccess', true);
                returnMap.put('fromAddress',emailObj.FromAddress__c);
                returnMap.put('toAddress',toAddress);
                returnMap.put('ccAddress',ccAddress);
               // returnMap.put('formattedToAddress',formattedToAddress);
               // returnMap.put('formattedCCAddress',formattedCCAddress);
                returnMap.put('formattedToAddress',loadformattedNames(formattedToAddress));
                returnMap.put('formattedCCAddress',loadformattedNames(formattedCCAddress));
                returnMap.put('subject',subject);
                returnMap.put('body',emailBody);
            }else
            {//User Story 158751: start
                returnMap.put('IsSuccess', false);
                returnMap.put('InvalidEmails',invalidEmails);
                returnMap.put('InvalidCCEmails',invalidCCEmails);
                returnMap.put('EmailValidation','InnerError');
            }//User Story 158751: end
        }
            else{                        
                returnMap.put('IsSuccess', false);
                returnMap.put('InvalidEmails',invalidEmails);
                returnMap.put('InvalidCCEmails',invalidCCEmails);
                returnMap.put('EmailValidation','RelatedEmail');
            }
                
        } catch(Exception ex) {
            returnMap.put('ErrorMsg', AppUtils.handleSystemExceptionMsg(ex));
            returnMap.put('ErrorMsgLine', ex.getLineNumber());
            returnMap.put('IsSuccess', false);
            rollbackData(taskId);
        }
        return returnMap;        
    }
    
    @TestVisible
    private static Map<String,Boolean> validateEmails(String [] emails){
        Map<String,Boolean> responseMap = new Map<String,Boolean>();        
        Set<String> setEmails = New Set<String>();
        setEmails.addAll(emails);

        if(setEmails.size()>0){
            for(Contact contact : [SELECT Email FROM Contact WHERE Email IN: setEmails WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(setEmails.contains(contact.Email)){
                    responseMap.put(contact.Email,true);
                }
            }  
            for(User user : [SELECT Email FROM User WHERE Email IN: setEmails WITH USER_MODE]){//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(setEmails.contains(user.Email)){
                    responseMap.put(user.Email,true);
                }
            } 
            Set<String> validEmails =  responseMap.keySet();
            for(String email : setEmails)  {
                if(!validEmails.contains(email)){
                    responseMap.put(email,false);
                }
            }        
        }
        return responseMap;
    }
    
    private static String[] split(String data) {
        List<String> dataArray = new List<String>();
        if(String.isNotEmpty(data)){
            data = data.replace(',', ';');
            data = data.replace(' ', ';');
            String[] dataArrayUntrimmed = data.split(';');
            for (String email : dataArrayUntrimmed) { 
                email = email.trim();
                if (String.isNotEmpty(email)) {
                    dataArray.add(email);
                }
            }
        }

        return dataArray;
    }

    //User Story 158751: LAHSA - Send Email - If user wants to send the email to different email address at the same time, it is not adding/making spaces for email addresses.
    private static Boolean validateEmailFormat(String data){
        Boolean returnValue = true;
        List<String> dataArray = new List<String>();
        if(String.isNotEmpty(data)){
            data = data.replace(',', ';');
            data = data.replace(' ', ';');
            String[] dataArrayUntrimmed = data.split(';');
            for (String email : dataArrayUntrimmed) { 
                email = email.trim();
                if (String.isNotEmpty(email)) {
                    if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', email))
                    {
                        returnValue = false;
                    }
                }
            }
        }
        return returnValue;
    }

    
    // parentId, mode and emailFieldName parameters are mandatory. oldTaskId is required in case of reply
    private static Task insertTaskRecord(String parentId, String mode, String emailFieldName, String oldTaskId, String toAddress, String ccAddress, String subject, String emailBody, Boolean sendACopyToMe,String formattedToAddress,String formattedCCAddress ) {
        Task emailObj;
        if (mode == 'send') {
            emailObj = prepareTaskForSend(parentId, mode, emailFieldName,toAddress,ccAddress,subject,emailBody,sendACopyToMe,formattedToAddress,formattedCCAddress);
        }
        else if (mode == 'reply') {
            emailObj = prepareTaskForReply(parentId, mode, emailFieldName, oldTaskId);
        }
           //added logic for update the attachment filesFlag
        if(emailObj.Description != null && emailObj.Description.startsWith('<b>Links to Additional Attachments ')){
            if(Schema.sObjectType.Task.fields.Attachment__c.isCreateable()){
                emailObj.Attachment__c = true;
            }
        }
        if(Schema.sObjectType.Task.isCreateable()){
            insert as user emailObj;
        }
        return emailObj;
    }
    
    private static void sendEMail(Task emailObj, String parentId,  Boolean sendACopyToMe,  String[] attchmentId, String toemailId, String ccemailId, String bccemailId, String subject, String body,String mode) {
        boolean EnableReplyEmailsFromCollab = KeyValueHolderHelper.getBooleanValue('EnableReplyEmailsFromCollab') == null ? false : KeyValueHolderHelper.getBooleanValue('EnableReplyEmailsFromCollab');
        if(String.isBlank(body)){
            body ='';
        }

        if(String.isBlank(emailObj.Description)){
            emailObj.Description = '';
        }

        String description = emailObj.Description;
        String[] toAddresses;
        String[] ccAddresses;
        String bccAddress = bccemailId;
        String headerData;
        headerData = URL.getOrgDomainUrl().toExternalForm();
        String identifier = '<div style="font-size:12px;">[ref:' + parentId + ':ref]';
        String AttentionTo = '';
        //BrandTemplate collabSendEmailTemplate = new BrandTemplate();
        String plainTextBody = '';
        String htmlBody = '';
        List<String> contentParts = new List<String>();
        if((mode=='send' || mode==null) && EnableReplyEmailsFromCollab==true){
            description += '<br><br>To view this record, please <a href= "' + headerData + '/' + parentId + '"> click here </a>'  ;
            description +='<br><br><i style="font-size: 14px;"> <b>Note:</b> This e-mail was sent from '+userinfo.getorganizationname()+ ' via Salesforce. Please do not delete the text below.</i>';
            AttentionTo = '[AttentionTo:' + emailObj.id + ':AttentionTo]</div>';
        }
        plainTextBody =description + identifier + AttentionTo;
        htmlBody = '<div style="margin-left:10px;">'+'<br>'+description +'<br><br>'+ identifier +'<br><br>' +AttentionTo + '<br><br>'+'</div>';
        String emailSubject = subject;
        if(String.isNotBlank(emailObj.ToAddress__c)){
            toAddresses = split(emailObj.ToAddress__c);
        } else {
            toAddresses = split(toemailId);
        }
        if(String.isNotBlank(emailObj.CCAddress__c)){
            ccAddresses = split(emailObj.CCAddress__c);
        } else {
            ccAddresses = split(ccemailId);
        }
        

        String replyToEmail;
        List<EmailServicesAddress> emailAddresses = [SELECT AuthorizedSenders,EmailDomainName,FunctionId,IsActive,LocalPart,RunAsUserId 
        FROM EmailServicesAddress where Function.FunctionName = 'EmailConversationHandler' and IsActive=true and Function.IsActive=true];  //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(emailAddresses.size() == 0) {
            throw new CustomExceptions.RequiredException('Email address or Email service with name EmailConversationHandler missing. Please contact admin user');
        } 
        replyToEmail = emailAddresses.get(0).LocalPart + '@' + emailAddresses.get(0).EmailDomainName;  
        String toAddress = String.join(toAddresses, ','); 
        String ccAddress = String.join(ccAddresses, ',');
         
        String attchId = String.join(attchmentId, ','); 
        
        new EmailFeeder().toEmail(toAddress).ccEmail(ccAddress).bccEmail(bccAddress).replyToEmail(replyToEmail).subject(emailSubject).htmlBody(htmlBody).plainTextBody(plainTextBody).attachmentIdString(attchId).send();
    }
    
    private static Task prepareTaskForSend(String parentId, String mode, String emailFieldName, String toAddress, String ccAddress, String subject, String emailBody, Boolean sendACopyToMe,String formattedToAddress,String formattedCCAddress) {
        Task emailObj;
        if(Schema.sObjectType.Task.fields.Type.isCreateable() && Schema.sObjectType.Task.fields.ToAddress__c.isCreateable() 
            && Schema.sObjectType.Task.fields.CCAddress__c.isCreateable() && Schema.sObjectType.Task.fields.EmailSubject__c.isCreateable() 
            && Schema.sObjectType.Task.fields.IsRead__c.isCreateable() && Schema.sObjectType.Task.fields.FromAddress__c.isCreateable()
            && Schema.sObjectType.Task.fields.EmailType__c.isCreateable() && Schema.sObjectType.Task.fields.IsVisibleInSelfService.isCreateable()
            && Schema.sObjectType.Task.fields.SendACopyToMe__c.isCreateable() && Schema.sObjectType.Task.fields.FormattedToAddress__c.isCreateable()
            && Schema.sObjectType.Task.fields.FormattedCCAddress__c.isCreateable() ){
                emailObj  = new Task(Type='Email', ToAddress__c=toAddress, CCAddress__c=ccAddress, EmailSubject__c=subject , Subject=subject, 
                Description=emailBody ,IsRead__c=true, FromAddress__c=UserInfo.getUserEmail(),
                EmailType__c='Outbound', Status='Completed', IsVisibleInSelfService=true,SendACopyToMe__c=sendACopyToMe,
                FormattedToAddress__c=formattedToAddress,FormattedCCAddress__c=formattedCCAddress);
            }
        Schema.SObjectType objectAPIName = ((Id)parentId).getSObjectType();
        if(Schema.sObjectType.Task.fields.WhoId.isCreateable()){
            if(String.valueOf(objectAPIName).equalsIgnoreCase('Contact')) {
                emailObj.WhoId=parentId;
            } else {
                emailObj.WhatId=parentId;
            }
        }
        return emailObj;
    }

    private static Task prepareTaskForReply(String parentId, String mode, String emailFieldName, String oldTaskId) {
        Task emailObj = getTaskDetails(oldTaskId);
        emailObj.Id = null;
        if(Schema.sObjectType.Task.fields.Description.isCreateable()){
            if(emailObj.Description == null){
                    emailObj.Description = '';
            }
            emailObj.Description = prepareReplyBodyHeader(emailObj) + emailObj.Description;
        }
        //User Story 167030: LAHSA Enhancement : Collab Send Email - Changes in Email Body - Add EGMIS Id and other details to email footer - Part 2
        if(Schema.sObjectType.Task.fields.Subject.isCreateable()){
            if(emailObj.Subject.contains('[[') && emailObj.Subject.contains(']] -')) {
                emailObj.Subject = emailObj.Subject.substring(emailObj.Subject.indexOf(']] - ') + 5);
            }

            if(emailObj.Subject.startsWith('Re:') == false && emailObj.Subject.startsWith('RE:') == false) {
                emailObj.Subject = 'RE: ' + emailObj.Subject;
            }
        }
                 
        if(emailObj.EmailType__c == 'Inbound') {
            if(Schema.sObjectType.Task.fields.ToAddress__c.isCreateable()){
                emailObj.ToAddress__c = emailObj.FromAddress__c;
            }
            if(Schema.sObjectType.Task.fields.FromAddress__c.isCreateable()){
                emailObj.FromAddress__c = UserInfo.getUserEmail();
            }
        }
        return emailObj;
    }
    
    private static String prepareReplyBodyHeader(Task emailObj) {
        return '<br><br><br>-----Original Message-----' +
                    '<br>From: ' + emailObj.FromAddress__c + 
                    '<br>Sent: ' + emailObj.CreatedDate.format('EEEE, MMMM d, y h:mm a') +
                    '<br>To: '+ emailObj.ToAddress__c +
                    '<br>Subject: '+ emailObj.Subject + '<br><br>';
    }
    
    private static Task getTaskDetails(String taskId) {
        if(Task.sObjectType.getDescribe().isAccessible() == true) {
            Task emailObj = [Select ToAddress__c, CCAddress__c, Subject, Description, WhatId, WhoId, Type, IsRead__c , 
                                    FromAddress__c, OwnerId, EmailType__c, CreatedDate, Status,FormattedToAddress__c, FormattedCCAddress__c,
                                    IsVisibleInSelfService from Task where Id=:taskId WITH USER_MODE];
            return emailObj;
        }
        return null;
    }
    @TestVisible
    private static String associateAttachToTask(String taskId, String attachId, String attachBody, String attachName, Task taskObj) {
        Attachment att = new Attachment();
        if(String.isNotEmpty(attachId)) {
            att = getAttachment(attachId);
            String newBody = '';
            if(att.Body != null) {
                newBody = EncodingUtil.base64Encode(att.Body);
            }
            newBody += attachBody;
            if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isupdateable()){
                att.Body = EncodingUtil.base64Decode(newBody);
            }
        } else {
            // Removes data:text/plain;base64, from attachments Body.
            //String[] base64result = attachBody.split(',');
            //String bigInput = attachBody.repeat(numRepeats);
            //attachBody = attachBody.substring(attachBody.firstIndexOf(" , "),attachBody.length());
            String[] base64result = safeSplit(attachBody,',');
            att.OwnerId = taskObj.OwnerId != null ? taskObj.OwnerId : UserInfo.getUserId();
            if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isupdateable()){
                att.Body = EncodingUtil.base64Decode(base64result[1]);
            }
            if(Schema.sObjectType.Attachment.fields.Name.isCreateable() && Schema.sObjectType.Attachment.fields.Name.isupdateable()){
                att.Name = attachName;
            }
           // if(Schema.sObjectType.Attachment.fields.parentId.isCreateable() && Schema.sObjectType.Attachment.fields.parentId.isupdateable()){
                if(!String.isEmpty(taskId)){  //CRUD /FLS false +ve Id field
                att.parentId = (Id)taskId;
                }else{
                    if(taskObj !=null){
                        att.parentId = taskObj.Id; 
                    }
                }
           // }
            
        }
        if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.Attachment.isupdateable()){
            upsert as user att;
        }
        return att.Id;
    }
    
    private static Attachment getAttachment(String attId) {
        Attachment attachments = new Attachment();
        attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attId WITH USER_MODE][0];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        return attachments;
    }
    @TestVisible
    private static void rollbackData(String taskId) {
        if(String.isNotEmpty(taskId) && Schema.sObjectType.Task.isDeletable()) {
            Database.delete(taskId, AccessLevel.USER_MODE); //FLS/ CRUD False +ve used schema method to check isDeletable
        }
    }

    /*Method to handle Regex Complication*/
   private static List<String> safeSplit(String inStr, String delim)
    {
       Integer regexFindLimit = 1000000000;
       Integer regexFindCount = 0;
    
       List<String> output = new List<String>();
    
       Matcher m = Pattern.compile(delim).matcher(inStr);
    
      Integer lastEnd = 0;

      while(!m.hitEnd())
      {
        while(regexFindCount < regexFindLimit && !m.hitEnd())
        {
            if(m.find())//SOQL/SOSL Injection False +ve
            {
                output.add(inStr.substring(lastEnd, m.start()));  
                lastEnd = m.end();
            }
            else
            {
                output.add(inStr.substring(lastEnd));
                lastEnd = inStr.length();
            }
            
            regexFindCount++;
        }

        // Note: Using region() to advance instead of substring() saves 
        // drastically on heap size. Nonetheless, we still must reset the 
        // (unmodified) input sequence to avoid a 'Regex too complicated' 
        // error.
        m.reset(inStr);        
        m.region(lastEnd, m.regionEnd());
        
        regexFindCount = 0;
     }
    
      return output;
    }

    @RemoteAction
    global static  Map<String, Object> uploadNewVal(Boolean sendACopyToMe, Boolean emailSent, String mode, Id taskId, String parentId, String emailFieldName) {
         sendACopyToMe = false;
         emailSent = false;
         Task emailObj;
         Map<String, String> attchMap = new Map<String, String>();
         String[] attachNames = new String[]{};
         Map<String, Object> returnMap = new Map<String, Object>();
        if (mode == 'send') {
            emailObj = new Task(Type='Email', IsRead__c=true, FromAddress__c=UserInfo.getUserEmail(),
                                EmailType__c='Outbound', Status='Completed', IsVisibleInSelfService=true);
            Schema.SObjectType token = ((Id)parentId).getSObjectType();
            if(String.valueOf(token).equalsIgnoreCase('Contact')) {
                emailObj.WhoId=parentId;
            } else {
                emailObj.WhatId=parentId;
            }
            if (String.isNotEmpty(emailFieldName)) {
                Id recordId = String.escapeSingleQuotes((Id) parentId);
                Schema.DescribeSObjectResult dr = recordId.getSObjectType().getDescribe();
                String soql = 'Select ' + string.valueOf(emailFieldName) + ' from ' + string.escapeSingleQuotes(dr.getName()) + ' where Id=:recordId  WITH USER_MODE ';
                if(AppUtils.isObjectAccessible(dr.getName())) { //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    SObject record = Database.query(String.escapeSingleQuotes(soql));//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                    
                    if (record != null) {
                        emailObj.ToAddress__c = getFieldValue(record,emailFieldName);
                    }
                }
            }
            returnMap.put('toAddress',emailObj.ToAddress__c);
        }
        else if (mode == 'reply') {
            List<Task> emailObjList = new List<Task>();
            emailObj=getTaskDetails(taskId);
            emailObj.Id = null;
            if(emailObj.Description == null){
                 emailObj.Description = '';
            }
            emailObj.Description = prepareReplyBodyHeader(emailObj) + emailObj.Description;

            //User Story 167030: LAHSA Enhancement : Collab Send Email - Changes in Email Body - Add EGMIS Id and other details to email footer - Part 2
            if(emailObj.Subject.contains('[[') && emailObj.Subject.contains(']] -')) {
                emailObj.Subject = emailObj.Subject.substring(emailObj.Subject.indexOf(']] - ') + 5);
            }
            
            if (emailObj.Subject.startsWith('Re:') == false && emailObj.Subject.startsWith('RE:') == false) {
                emailObj.Subject = 'RE: ' + emailObj.Subject;
            }

            if (emailObj.EmailType__c == 'Inbound') {
                emailObj.ToAddress__c = emailObj.FromAddress__c;
                emailObj.FromAddress__c = UserInfo.getUserEmail();
            }
            emailObjList.add(emailObj);
            for(Task tsk :emailObjList){
                returnMap.put('toAddress',tsk.ToAddress__c);
                returnMap.put('ccAddress',tsk.CCAddress__c);
                returnMap.put('formattedToAddress',loadformattedNames(tsk.FormattedToAddress__c));
                returnMap.put('formattedCCAddress',loadformattedNames(tsk.FormattedCCAddress__c));
                returnMap.put('formattedToIds',tsk.FormattedToAddress__c);
                returnMap.put('formattedCCIds',tsk.FormattedCCAddress__c);
                returnMap.put('subject',tsk.Subject);
                returnMap.put('body',tsk.Description);
                returnMap.put('fromAddress',tsk.FromAddress__c);
                //returnMap.put('AttachId', attachId);
            }
        }
        else {  //mode = 'view'
            List<Task> emailObjList = loadTask(taskId);
           // FormattedToAddress__c
           // FormattedCCAddress__c
            List<Attachment> attachObjList = loadAttachment(taskId);
            // Task Iteration...
            for(Task tsk :emailObjList){
                
                String descrip = tsk.Description;
                if(String.isNotEmpty(descrip)){
                if(descrip.containsIgnoreCase('\n')){
                   descrip.replace('\n', '<br>');
                   tsk.Description = descrip;
                }
                }
                returnMap.put('toAddress',tsk.ToAddress__c);
                returnMap.put('ccAddress',tsk.CCAddress__c);
                
                //returnMap.put('formattedToAddress',tsk.FormattedToAddress__c);
                returnMap.put('formattedToAddress',loadformattedNames(tsk.FormattedToAddress__c));
                //returnMap.put('formattedCCAddress',tsk.FormattedCCAddress__c);
                returnMap.put('formattedCCAddress',loadformattedNames(tsk.FormattedCCAddress__c));

                returnMap.put('subject',tsk.Subject);
                returnMap.put('body',tsk.Description);
                returnMap.put('fromAddress',tsk.FromAddress__c);
                returnMap.put('SendACopyToMe',tsk.SendACopyToMe__c);
                
                Datetime objDateTime = (Datetime)tsk.CreatedDate; 
                string dateString = objDateTime.format();
                returnMap.put('SentDate', dateString);
                //returnMap.put('AttachId', attachId);
            }
            // Attachment Iteration....
            for(Attachment attch :attachObjList){
               attchMap.put('attachId', attch.Id); 
               attachNames.add(attch.Name);     
               attachNames.add(attch.Id);     
            }
            returnMap.put('AttachId', attachObjList);
        }
        return returnMap;
    }

    private static String loadformattedNames(String formattedIds){
        String strFormattedNames = '';
        List<Sobject>records = new List<Sobject>();
        List<String> lstOfManualEmail = new List<String>(); //Bug 71089: Internal: Send Email- External Email is not visible on View/Reply action at To/CC field
        if(String.isNotBlank(formattedIds)){
            List<Id>userIds = new List<Id>();
            List<Id>contactIds = new List<Id>();
            List<Id>groupIds = new List<Id>();

            List<String> lstFormattedIds = formattedIds.split(';');
            if(lstFormattedIds.size()>0){
                for(String strFormattedId : lstFormattedIds){
                    if(!strFormattedId.contains('@')){ ////Bug 71089: Internal: Send Email- External Email is not visible on View/Reply action at To/CC field
                        Id formattedId = Id.valueOf(strFormattedId);
                        if(String.valueOf(formattedId.getSobjectType()).equalsIgnoreCase('user')){
                            userIds.add(formattedId);
                        }
                        if(String.valueOf(formattedId.getSobjectType()).equalsIgnoreCase('contact')){
                            contactIds.add(formattedId);
                        }
                        if(String.valueOf(formattedId.getSobjectType()).equalsIgnoreCase('collaborationgroup')){
                            groupIds.add(formattedId);
                        }
                    }else{
                         lstOfManualEmail.add(strFormattedId); //Bug 71089: Internal: Send Email- External Email is not visible on View/Reply action at To/CC field
                    }
                }
                if(userIds.size()>0){
                    records.addAll(Database.query('SELECT Id,Name FROM User WHERE Id IN :userIds WITH USER_MODE'));//CRUD/FLS False +ve with the help of AppUtils we have performed check //SOQL Injection - False +ve - Hole query string is staic and have no dynamic part.
                }
                if(contactIds.size()>0){
                    records.addAll(Database.query('SELECT Id,Name FROM Contact WHERE Id IN :contactIds WITH USER_MODE'));//SOQL Injection - False +ve - Hole query string is staic and have no dynamic part.//CRUD/FLS False +ve with the help of AppUtils we have performed check
                }
                if(groupIds.size()>0){
                    records.addAll(Database.query('SELECT Id,Name FROM CollaborationGroup WHERE Id IN :groupIds'));//CRUD/FLS False +ve with the help of AppUtils we have performed check //SOQL Injection - False +ve - Hole query string is staic and have no dynamic part.
                }
            }
            if(records.size()>0){
                for(sobject sobj: records){
                    String str = sobj.get('Name') + ';';
                    strFormattedNames += str;
                }  
                strFormattedNames = strFormattedNames.removeEnd(';');
                // Bug 71089: Internal: Send Email- External Email is not visible on View/Reply action at To/CC field
                if(lstOfManualEmail!=null && lstOfManualEmail.size()>0){
                    for(String itrManualEmail : lstOfManualEmail){
                        strFormattedNames +=  ';'+ itrManualEmail;
                    }
                }
                strFormattedNames = strFormattedNames.removeEnd(';');
            }
        }
        return strFormattedNames;
    }

    private static List<Attachment> loadAttachment(Id taskId){
        List<Attachment> attachObj;
        if(Attachment.sObjectType.getDescribe().isAccessible() == true){
           attachObj = [SELECT ContentType,Id,IsPrivate,Name,ParentId FROM Attachment
                               WHERE ParentId=:taskId WITH USER_MODE];

        }
        return attachObj;
    }
    private static List<Task> loadTask(Id taskId) {
        List<Task> emailObj;
        if(Task.sObjectType.getDescribe().isAccessible() == true) {
            emailObj = [Select ToAddress__c,SendACopyToMe__c, CCAddress__c, EmailSubject__c, Subject, Description, WhatId, WhoId, Type, IsRead__c , 
                                    FromAddress__c, OwnerId, EmailType__c, CreatedDate, Status,FormattedToAddress__c, FormattedCCAddress__c,
                                    IsVisibleInSelfService from Task where Id=:taskId WITH USER_MODE];
        }
        return emailObj;
    }

    private static String getFieldValue(SObject record, String emailFieldName) {
        String[] fields = emailFieldName.split('\\.');

        for (Integer i=0; i<fields.size()-1; i++) {
            record = record.getSObject(fields[i]);
        }
        return (String) record.get(fields.get(fields.size()-1));
    }
    private static set<String> getObjectsWithActivitiesEnabled(){
        Set<String> objectsWithActivitiesEnabled = new Set<String>();
        for (Schema.SObjectType objectType : Task.WhatId.getDescribe().getReferenceTo()) {
            objectsWithActivitiesEnabled.add(''+objectType);   
        }
        return objectsWithActivitiesEnabled;
    }

    // Creating of PageDataHolderId....
    @RemoteAction
    global static Map<String, Object> creationPageDataHolderId(){
        try{
            Map<String, Object> returnMap = new Map<String, Object>();
            PageDataHolder__c pageDataHolder = new PageDataHolder__c();
            if(Schema.sObjectType.PageDataHolder__c.fields.Name.isCreateable()){
                pageDataHolder.Name = 'Content Version Id Holder';//flexTableParamMap.get('parentId')
            }
            if(Schema.sObjectType.PageDataHolder__c.isCreateable()){
                insert as user pageDataHolder;
            }
            returnMap.put('PageDataHolderId',pageDataHolder.Id);
            return returnMap;
        }catch(Exception ex){
            CustomExceptions.logException(ex, true, true);
            return null;
        }
    }

    @AuraEnabled
    global static List<ResultWrapper> getRecordsNewLWC(Map<String, Object> paramatersMap )
    {
        String searchString = (String)paramatersMap.get('searchString');
        String objectApiName = (String)paramatersMap.get('objectApiName');
        String fieldToDisplay =  (String)paramatersMap.get('fieldToDisplay')!=null ?  (String)paramatersMap.get('fieldToDisplay') : '';
        String fieldBindToTarget = (String)paramatersMap.get('fieldBindToTarget');
        String fieldToFilter = (String)paramatersMap.get('fieldToFilter');
        String selectedRecordIds = (String)paramatersMap.get('selectedRecordIds');

     
        String searchType = (String)paramatersMap.get('searchType');
        Boolean isExternalUser = false;
        if(searchType!='' &&searchType!=null ){
            if(searchType.trim().equals('External')){
                isExternalUser = true;
            }
        }
        
        List<Sobject> records;
        List<ResultWrapper> resultWrappersWithSingleOccourance = new List<ResultWrapper>();
        List<ResultWrapper> resultWrappers = new List<ResultWrapper>();
        try{

            List<String> lstSelectedRecordIds = selectedRecordIds.split(',');           
            Set<String> filteredRecordIds = new Set<String>();
            Set<String> filteredRecordIdsSanitized = new Set<String>();

            if(lstSelectedRecordIds.size()>0){
                filteredRecordIds.addall(lstSelectedRecordIds);
            }

            if(filteredRecordIds.size()>0){

                  // segrgate ids as user or contact ids     
                List<Id>filteredUserIds = new List<Id>();
                List<Id>filteredContactIds = new List<Id>();
                for (String filteredRecordId : filteredRecordIds) {
                    if(filteredRecordId.startsWith('005')){
                        filteredUserIds.add(filteredRecordId);
                    }
                   if(filteredRecordId.startsWith('003')){
                        filteredContactIds.add(filteredRecordId);
                   }
                   filteredRecordIdsSanitized.add(String.escapeSingleQuotes(filteredRecordId));
                } 
                Set<String>filteredEmails = new Set<String>();
                List<User>filteredUserDetails = filteredUserIds.size()>0 ? [SELECT Email FROM User WHERE Id IN:filteredUserIds WITH USER_MODE] : null;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                List<Contact>filteredContactDetails = filteredContactIds.size()>0 ? [SELECT Email FROM Contact WHERE Id IN:filteredContactIds WITH USER_MODE] : null;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(filteredUserDetails != null && filteredUserDetails.size()>0){
                    for(User user : filteredUserDetails){
                        filteredEmails.add(user.Email);
                    }
                }
                if(filteredContactDetails != null && filteredContactDetails.size()>0){
                    for(Contact contact : filteredContactDetails){
                        filteredEmails.add(contact.Email);
                    }
                }
            }
            String userQuery = '';
            if(objectApiName.toLowercase() == 'user' ){
                List<Sobject> InternalContacts = new List<Sobject>();
                if(!isExternalUser || searchType == 'Both'){   
                    userQuery = 'SELECT '+SchemaManager.getFields('id,email,'+fieldToDisplay)+' FROM '+string.escapeSingleQuotes(objectApiName)+' WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND UserType = \'Standard\' AND IsActive=true WITH USER_MODE';
                    if(AppUtils.isObjectAccessible(objectApiName)){   //CRUD/FLS False +ve with the help of AppUtils we have performed check
                        if( SchemaManager.isAccessible(objectApiName, 'Email,'+fieldToDisplay)){
                            records = Database.query(userQuery);//NOPMD SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                        }
                    }
                    for(Integer count=0;count<records.size();count++){
                        resultWrappers.add(new ResultWrapper(records[count],false));
                    }

                    String contactQuery = 'SELECT Id,Name,Email FROM Contact WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND Email != NULL AND Account.RecordType.name = \'Internal\' WITH USER_MODE';
                    if(Schema.sObjectType.Contact.isAccessible()){
                        if( SchemaManager.isAccessible('Contact', 'Name,Email,'+fieldToFilter)){
                            InternalContacts = Database.query(contactQuery);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                        }
                    }
                    for(Integer count=0;count<InternalContacts.size();count++){                           
                        resultWrappers.add(new ResultWrapper(InternalContacts[count],false));
                    }
                }

                List<Sobject> contacts = new List<Sobject>();
                if(isExternalUser || searchType == 'Both'){
                    String contactQuery = 'SELECT Id,Name,Email FROM Contact WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND Email != NULL AND Account.RecordType.name != \'Internal\' WITH USER_MODE';
                    if(Schema.sObjectType.Contact.isAccessible()){
                        if( SchemaManager.isAccessible('Contact', 'Name,Email,'+fieldToFilter)){
                            contacts = Database.query(contactQuery);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                        }
                    }
                    for(Integer count=0;count<contacts.size();count++){                           
                        resultWrappers.add(new ResultWrapper(contacts[count],false));
                    }
                }
            }
            if(objectApiName.toLowercase() == 'collaborationgroup'){
                String groupQuery = '';
                objectApiName = 'collaborationgroup';
                string ownerId = String.escapeSingleQuotes(UserInfo.getUserId());          
                groupQuery = 'SELECT CollaborationType,'+SchemaManager.getFields(fieldToDisplay)+'MemberCount FROM '+string.escapeSingleQuotes(objectApiName)+' WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND OwnerId =:ownerId WITH USER_MODE';      
                records = Database.query(groupQuery);//NOPMD SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(Integer count=0;count<records.size();count++){
                    resultWrappers.add(new ResultWrapper(records[count],true));
                }
            }
            if(objectApiName.toLowercase() == 'contact'){
                String contactQuery = 'SELECT Id,Name,Email FROM Contact WHERE Id NOT IN :filteredRecordIdsSanitized AND '+string.escapeSingleQuotes(fieldToFilter)+' LIKE \'%'+string.escapeSingleQuotes(searchString)+'%\' AND Email != NULL AND Account.RecordType.name != \'Internal\' WITH USER_MODE';
                List<Sobject> contacts = Database.query(contactQuery);//SOQL Injection - False +ve -Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(Integer count=0;count<contacts.size();count++){
                    resultWrappers.add(new ResultWrapper(contacts[count],false));
                }
            }
            Set<String> uniqueNames = new Set<String>();
            for(ResultWrapper ResultWrapperRec :resultWrappers){
                if(!uniqueNames.contains(ResultWrapperRec.name)){
                    resultWrappersWithSingleOccourance.add(ResultWrapperRec);
                    uniqueNames.add(ResultWrapperRec.name);
                }
            }
        }
        catch(Exception e){
        }
        return resultWrappersWithSingleOccourance;
    }

    @AuraEnabled
    global static  Map<String, Object> uploadNewValNew(Boolean sendACopyToMe, Boolean emailSent, String mode, Id taskId, String parentId, String emailFieldName) {
         sendACopyToMe = false;
         emailSent = false;
         Task emailObj;
         Map<String, String> attchMap = new Map<String, String>();
         String[] attachNames = new String[]{};
         Map<String, Object> returnMap = new Map<String, Object>();
        if (mode == 'send') {
            emailObj = new Task(Type='Email', IsRead__c=true, FromAddress__c=UserInfo.getUserEmail(),
                                EmailType__c='Outbound', Status='Completed', IsVisibleInSelfService=true);
            Schema.SObjectType token = ((Id)parentId).getSObjectType();
            if(String.valueOf(token).equalsIgnoreCase('Contact')) {
                emailObj.WhoId=parentId;
            } else {
                emailObj.WhatId=parentId;
            }
            if (String.isNotEmpty(emailFieldName)) {
                Id recordId = String.escapeSingleQuotes((Id) parentId);
                Schema.DescribeSObjectResult dr = recordId.getSObjectType().getDescribe();
                String soql = 'Select ' + string.valueOf(emailFieldName) + ' from ' + dr.getName() + ' where Id=:recordId  WITH USER_MODE ';
                if(AppUtils.isObjectAccessible(dr.getName())) {
                    SObject record = Database.query(String.escapeSingleQuotes(soql));
                    
                    if (record != null) {
                        emailObj.ToAddress__c = getFieldValue(record,emailFieldName);
                    }
                }
            }
            returnMap.put('toAddress',emailObj.ToAddress__c);
        }
        else if (mode == 'reply') {
            
            List<Task> emailObjList = new List<Task>();
            emailObj=getTaskDetails(taskId);
            emailObj.Id = null;
            if(emailObj.Description == null){
                 emailObj.Description = '';
            }
            emailObj.Description = prepareReplyBodyHeader(emailObj) + emailObj.Description;

            //User Story 167030: LAHSA Enhancement : Collab Send Email - Changes in Email Body - Add EGMIS Id and other details to email footer - Part 2
            if(emailObj.Subject.contains('[[') && emailObj.Subject.contains(']] -')) {
                emailObj.Subject = emailObj.Subject.substring(emailObj.Subject.indexOf(']] - ') + 5);
            }
            
            if (emailObj.Subject.startsWith('Re:') == false && emailObj.Subject.startsWith('RE:') == false) {
                emailObj.Subject = 'RE: ' + emailObj.Subject;
            }

            if (emailObj.EmailType__c == 'Inbound') {
                emailObj.ToAddress__c = emailObj.FromAddress__c;
                emailObj.FromAddress__c = UserInfo.getUserEmail();
            }
            emailObjList.add(emailObj);
            for(Task tsk :emailObjList){
                returnMap.put('toAddress',tsk.ToAddress__c);
                returnMap.put('ccAddress',tsk.CCAddress__c);
                returnMap.put('formattedToAddress',loadformattedNames(tsk.FormattedToAddress__c));
                returnMap.put('formattedCCAddress',loadformattedNames(tsk.FormattedCCAddress__c));
                returnMap.put('formattedToIds',tsk.FormattedToAddress__c);
                returnMap.put('formattedCCIds',tsk.FormattedCCAddress__c);
                returnMap.put('subject',tsk.Subject);
                returnMap.put('body',tsk.Description);
                returnMap.put('fromAddress',tsk.FromAddress__c);
                //returnMap.put('AttachId', attachId);
            }
        }
        else {  //mode = 'view'
            List<Task> emailObjList = loadTask(taskId);
           // FormattedToAddress__c
           // FormattedCCAddress__c
            // List<Attachment> attachObjList = loadAttachment(taskId);//old method to read the attachments and make available in view mode
            List<ContentVersion> fileObjList = loadFileOnTask(taskId); //this will read the files attached to the TaskDetailMessageCtrl
            // Task Iteration...
            for(Task tsk :emailObjList){
                
                String descrip = tsk.Description;
                if(String.isNotEmpty(descrip)){
                if(descrip.containsIgnoreCase('\n')){
                   descrip.replace('\n', '<br>');
                   tsk.Description = descrip;
                }
                }
                returnMap.put('toAddress',tsk.ToAddress__c);
                returnMap.put('ccAddress',tsk.CCAddress__c);
                returnMap.put('formattedToAddress',loadformattedNames(tsk.FormattedToAddress__c));
                returnMap.put('formattedCCAddress',loadformattedNames(tsk.FormattedCCAddress__c));
                returnMap.put('subject',tsk.Subject);
                returnMap.put('body',tsk.Description);
                returnMap.put('fromAddress',tsk.FromAddress__c);
                returnMap.put('SendACopyToMe',tsk.SendACopyToMe__c);
                
                Datetime objDateTime = (Datetime)tsk.CreatedDate; 
                string dateString = objDateTime.format();
                returnMap.put('SentDate', dateString);
                //returnMap.put('AttachId', attachId);
            }
            // Attachment Iteration....
            
            returnMap.put('AttachId', fileObjList);
        }
        return returnMap;
    }

    @AuraEnabled
    global static Map<String, Object> sendEmailNew(String parentId, String taskId, Map<String, Object> attrMap) {
        Map<String, Object> returnMap = new Map<String, Object>();
        String[] accId = new String[]{};
       // List<Attachment> attachObjList = new List<Attachment>();
        try {
            Task emailObj;
            Boolean isLast = (Boolean)attrMap.get('isLast');
            Boolean isAttachmentNotPresent = (Boolean)attrMap.get('isAttachNotPresent');
            String mode = (String)attrMap.get('mode');
            String emailFieldName = (String)attrMap.get('emailFieldName');
            String oldTaskId = (String)attrMap.get('oldTaskId');
            Boolean sendACopyToMe = (Boolean)attrMap.get('sendACopyToMe');

            String formattedToAddress =(String)attrMap.get('formattedToAddress');
            String formattedCCAddress =(String)attrMap.get('formattedCCAddress');
            // add to address, cc address, Bcc address in map, Subject and email body
            String toAddress =(String)attrMap.get('toAddress');
            String ccAddress =(String)attrMap.get('ccAddress');
            String subject = (String)attrMap.get('subject');
            if(KeyValueHolderHelper.getBooleanValue('SendEmaiSubject')){
                String bodySetting = KeyValueHolderHelper.getTextValue('SendEmaiSubject');
                String addToSubject = subject.startsWith('RE: ') ? 'RE: [[':'[[';
                String userOrg;
                Id accountId = [SELECT OrganizationId__c FROM User WHERE id=:UserInfo.getUserId() WITH USER_MODE LIMIT 1].OrganizationId__c;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                if(accountId != null){
                    userOrg = [SELECT Name FROM Account WHERE Id =:accountId WITH USER_MODE LIMIT 1].Name;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                }
                if(bodySetting.contains('Sender_Name')){
                    addToSubject += UserInfo.getName() + (userOrg != null ?', ':'');
                }
                if(bodySetting.contains('Sender_Org') && userOrg != null){
                    addToSubject += userOrg;
                }
                subject = addToSubject + ']] - '+ (subject.startsWith('RE: ') ? subject.substring(Subject.indexOf('RE: ') + 4) : subject);
            }

            String emailBody=(String)attrMap.get('body');
            boolean enableEmailValidation = KeyValueHolderHelper.getBooleanValue('EnableEmailValidation') == null ? false : KeyValueHolderHelper.getBooleanValue('EnableEmailValidation');            
            Map<String,boolean>invalidCCEmails = new Map<String,Boolean>();
            Map<String,boolean>invalidEmails = new Map<String,Boolean>();
            if(enableEmailValidation){
                Map<String,boolean>emailValidityMap = validateEmails(split(toAddress));
                Map<String,boolean>ccemailValidityMap = validateEmails(split(ccAddress));               

                for(String email : emailValidityMap.keySet()){
                    if(!emailValidityMap.get(email)){
                        invalidEmails.put(email,false);
                    }
                }

                for(String email : ccemailValidityMap.keySet()){
                    if(!ccemailValidityMap.get(email)){
                        invalidCCEmails.put(email,false);
                    }
                }
            }
           if(invalidEmails.keySet().size() == 0 && invalidCCEmails.keySet().size() == 0){
                String bccAddress = '';
                //User Story 158751: start
                Boolean toValue = validateEmailFormat(toAddress);
                Boolean ccValue = validateEmailFormat(ccAddress);
                if(!toValue){
                    invalidEmails.put(toAddress,false);
                }
                if(!ccValue){
                    invalidCCEmails.put(ccAddress,false);
                }
                if(invalidEmails.keySet().size() == 0 && invalidCCEmails.keySet().size() == 0){
                if(sendACopyToMe){
                    //User Story 129846: Enhancement - Send Email - Send Copy to me - change to CC instead of BCC
                    List<String> ccAddressList = new List<String>();
                    if(String.isNotBlank(ccAddress) && String.isNotEmpty(ccAddress)){
                        ccAddressList = ccAddress.split(';');
                    }
                    if(!ccAddressList.contains(UserInfo.getUserEmail())){
                        ccAddressList.add(UserInfo.getUserEmail());
                    }
                    ccAddress = String.join(ccAddressList, ';');
                    //bccAddress = UserInfo.getUserEmail();
                }
                if(String.isEmpty(taskId)) {
                    // code is added to check whether activity is enabled on sobject
                    Schema.SObjectType objectAPIName = ((Id)parentId).getSObjectType();
                    String strObjAPIName = String.valueOf(objectAPIName);
                    Set<String>activityEnabledObjects = getObjectsWithActivitiesEnabled();
                    if(!activityEnabledObjects.contains(strObjAPIName)){
                        returnMap.put('ErrorMsg', 'Please Enable Allow Activities on "'+(Id.valueOf(parentId)).getSObjectType().getDescribe().getLabel()+'"');
                        returnMap.put('IsSuccess', false);
                        return returnMap;
                    }
                    emailObj = insertTaskRecord(parentId, mode, emailFieldName, oldTaskId, toAddress, ccAddress, subject, emailBody,sendACopyToMe,formattedToAddress,formattedCCAddress);
                    taskId = emailObj.Id+''; 
                } else {
                    emailObj = getTaskDetails(taskId);
                }

                if(isAttachmentNotPresent){
                    sendEMail(emailObj, parentId, sendACopyToMe, accId, toAddress, ccAddress, bccAddress, subject, emailBody,mode);              
                }
                returnMap.put('TaskId', taskId);
                // returnMap.put('AttachId', '');
                returnMap.put('IsSuccess', true);
                returnMap.put('fromAddress',emailObj.FromAddress__c);
                returnMap.put('toAddress',toAddress);
                returnMap.put('ccAddress',ccAddress);
                returnMap.put('sendCopyToMe',sendACopyToMe);
                returnMap.put('formattedToAddress',loadformattedNames(formattedToAddress));
                returnMap.put('formattedCCAddress',loadformattedNames(formattedCCAddress));
                returnMap.put('subject',subject);
                returnMap.put('body',emailBody);
            }else
            {//User Story 158751: start
                returnMap.put('IsSuccess', false);
                returnMap.put('InvalidEmails',invalidEmails);
                returnMap.put('InvalidCCEmails',invalidCCEmails);
                returnMap.put('EmailValidation','InnerError');
            }//User Story 158751: end
        }
            else{                        
                returnMap.put('IsSuccess', false);
                returnMap.put('InvalidEmails',invalidEmails);
                returnMap.put('InvalidCCEmails',invalidCCEmails);
                returnMap.put('EmailValidation','RelatedEmail');
            }
                
        } catch(Exception ex) {            
            returnMap.put('ErrorMsg', AppUtils.handleSystemExceptionMsg(ex));
            returnMap.put('ErrorMsgLine', ex.getLineNumber());
            returnMap.put('IsSuccess', false);
            rollbackData(taskId);
        }
        return returnMap;        
    }
    @AuraEnabled
    global static Map<String, Object> getLoadData() {
        Map<String, Object> returnMap = new Map<String, Object>();

        String namespacePrefix = AppUtils.getNameSpacePrefix();
        String baseURL = URL.getOrgDomainUrl().toExternalForm();

        String StrMeta  = KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') != null ? KeyValueHolderHelper.getTextValue('SendEmailFilesLinkConfigHolder') : '';		
        Boolean isExternalUser;
        Boolean isFilesLinkBlock = KeyValueHolderHelper.getBooleanValue('SendEmailFilesLinkConfigHolder');
        Boolean isAttachBlock = KeyValueHolderHelper.getBooleanValue('EnableEmailAttachment');   
        //read the USer and send to frontend
        User user = [SELECT ContactId FROM User WHERE Id =:UserInfo.getUserId() AND IsActive=true WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        if(user.ContactId != null){
            isExternalUser = true;
            // return true;
        }else {
            isExternalUser = false;
            // return false;
        }
        
        if(String.isNotBlank(StrMeta)){              
            if(StrMeta.contains('?')){
                 String PageName = StrMeta.split('\\?').size() > 0 ? StrMeta.split('\\?')[0] : '';
                if(PageName.contains('/apex/')){                    
                 String activePageName  = PageName.substringAfter('/apex/') !=null? PageName.substringAfter('/apex/'): namespacePrefix + 'FilesLinksPage';                     
                 String checkValueParam = StrMeta.split('\\?').size() > 0? StrMeta.split('\\?')[1] : '';
                 String tableName = checkValueParam.split('\\&').size() > 0 ? checkValueParam.split('\\&')[0] : '';
                 filesTableName = tableName.split('\\=').size() > 0  ? tableName.split('\\=')[1] : 'FilesLink';                   
                 }                    
            }else
                    {
                        // activePageName = namespacePrefix + 'FilesLinksPage';
                        filesTableName = 'FilesLinkForLightning'; 
                    }  
        }else
            {
                // activePageName = namespacePrefix + 'FilesLinksPage';
                filesTableName = 'FilesLinkForLightning'; 
            }  

            returnMap.put('fileBlock',isFilesLinkBlock );
            returnMap.put('tableName', filesTableName);
            returnMap.put('namespace', namespacePrefix);
			returnMap.put('isExternalUser',isExternalUser);
            returnMap.put('attachBlock',isAttachBlock);
            returnMap.put('baseURL',baseURL);
        return returnMap;
    }

    @AuraEnabled
    global static List<SObject> getCollabGroupMemberIdsLWC(Map<String, Object> paramatersMap ){
        String groupId = (String)paramatersMap.get('groupId'); 
        List<Id>groupIds = new List<Id>();
        List<Sobject> records;

        try{  
            if(!String.isBlank(groupId)){
                groupIds.add(Id.valueOf(String.escapeSingleQuotes(groupId)));
                String query = '';
                query = 'SELECT MemberId,Member.Email FROM CollaborationGroupMember WHERE CollaborationGroupId IN :groupIds AND Member.IsActive=true WITH USER_MODE';
                records = Database.query(query);//SOQL Injection - False +ve - Hole query is static and have no dynamic part.   //CRUD/FLS False +ve As per business scenario we can't check for portal/external users             
            }   
        }
        catch(Exception e){
        }     
        return records;
    }
    @AuraEnabled
    global static Map<String, Object> uploadAttachmentFiles(Map<String, Object> mapData, List<Object> fileDetails)
    {
        Map<String, Object> returnMap     = new Map<String, Object>();
        Map<String,Object> paramsMap = new Map<string, Object>();
        
        return returnMap;
    }   

    @AuraEnabled
    global static Map<String, Object> uploadAttachmentFiles(Map<String, Object> mapData, Object fileDetails)
    {
        Map<String, Object> returnMap = new Map<String, Object>();
        Map<String,Object> paramsMap = new Map<string, Object>();
        try{
        String parentId = (String)mapData.get('parentId'); 
        String taskId = (String)mapData.get('taskId'); 
        Boolean uploadDone = (Boolean)mapData.get('UploadDone');
        String str = '';
            List<Id> cvIds = new List<Id>();
            List<ContentVersion> cvList = new List<ContentVersion>();
            List<ContentDocumentLink> cdocLink = new List<ContentDocumentLink>();
            paramsMap = (Map<string, Object>)JSON.deserializeUntyped(JSON.serialize(fileDetails));
            if(paramsMap!=null){
                ContentVersion cv = createContentVersion((String)paramsMap.get('filename'),(String)paramsMap.get('base64'));
                if (Schema.sObjectType.ContentVersion.isCreateable()) {
	                insert as user cv;
	                cvList.add(cv);
	                cvIds.add(cv.Id);
            	}
            }
            if(cvList.size()>0){
                cdocLink = createContentLink(cvIds, taskId);
                if(cdocLink.size()>0){
                    if (Schema.sObjectType.ContentDocumentLink.isCreateable()) {
                    	insert as user cdocLink;
                    }
                }
            }
            if(cdocLink.size()>0){
               if(uploadDone){
                Task emailObjTask  =  getTaskDetails(taskId);
                Map<String,List<Object>> returnData = getFilesIdOnTaskforId(taskId);
                String[] attachmentIdArray = (List<String>)returnData.get('Ids');
                List<ContentVersion> contentData = (List<ContentVersion>)returnData.get('Records');
                Boolean sendACopyToMe = (Boolean)mapData.get('sendACopyToMe');
                // add to address, cc address, Bcc address in map, Subject and email body
                String toAddress =(String)mapData.get('toAddress');
                String ccAddress =(String)mapData.get('ccAddress');
                String subject =(String)mapData.get('subject');
                String emailBody=(String)mapData.get('body');
                String mode = (String)mapData.get('mode');
                String bccAddress = '';
                sendEMail(emailObjTask, parentId, sendACopyToMe, attachmentIdArray, toAddress, ccAddress, bccAddress, subject, emailBody,mode);
                returnMap.put('AttachId', contentData);
                returnMap.put('IsSuccess', true);
                returnMap.put('isUploadDone', true);
                returnMap.put('ErrorMsg', null);
               }else{
                returnMap.put('AttachId', null);
                returnMap.put('IsSuccess', true);
                returnMap.put('isUploadDone', false);
                returnMap.put('ErrorMsg', null);
               }
                
                
                
            }else{
                returnMap.put('AttachId', null);
                returnMap.put('IsSuccess', false);
                returnMap.put('ErrorMsg', 'Error while creation of Files');
            }
        
            return  returnMap;
        }catch(Exception e){
            returnMap.put('AttachId', null);
            returnMap.put('IsSuccess', false);
            returnMap.put('ErrorMsg', e.getMessage());
            return  returnMap;
        }
    }

    /*
   * @method createContentVersion() [private]
   * @desc Creates a content version from a given file's base64 and name
   * 
   * @param {String} base64 - base64 string that represents the file
   * @param {String} filename - full file name with extension, i.e. 'Invoice.pdf'
   * 
   * @return {ContentVersion} - returns the newly created ContentVersion, or null
   *   if there was an error inserting the record
   */
  private static ContentVersion createContentVersion(String filename,String base64) {
    ContentVersion cv = new ContentVersion();
    if (Schema.sObjectType.ContentVersion.fields.VersionData.isCreateable()) {
        cv.VersionData = EncodingUtil.base64Decode(base64);
    }
    if (Schema.sObjectType.ContentVersion.fields.Title.isCreateable()) {
        cv.Title = filename;
    }
    if (Schema.sObjectType.ContentVersion.fields.PathOnClient.isCreateable()) {
        cv.PathOnClient = filename;
    }
    try {
      return cv;
    } catch(DMLException e) {
      return null;
    }
  }
    

  private static List<ContentDocumentLink> createContentLink(List<Id> cVersions, String recordId) {
              if (cVersions == null || recordId == null) { return null; }
              List<ContentDocumentLink> cdocLink = new List<ContentDocumentLink>();
              Map<Id,Id> verDocData = new Map<Id,Id>();
              List<ContentVersion> versionsList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN:cVersions WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
              For(Integer m=0; m<versionsList.size(); m++){
                verDocData.put(versionsList[m].Id,versionsList[m].ContentDocumentId);
              }
              for(Integer k=0; k<versionsList.size();k++){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = verDocData.get(cVersions[k]);  //CRUD/FLS False+ve ID field
                cdl.LinkedEntityId = recordId; //CRUD/FLS False+ve ID field
                
                if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
                    cdl.ShareType = 'V';
                }
                if (Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable()) {
                    cdl.Visibility = 'AllUsers';
                }
                cdocLink.add(cdl);
              }
    try {
      return cdocLink;
    } catch(DMLException e) {
      return null;
    }
  }

  private static ContentDocumentLink createContentLink(ContentVersion cVersion, String recordId) {
    if (cVersion == null || recordId == null) { return null; }
      ContentDocumentLink cdl = new ContentDocumentLink();
      cdl.ContentDocumentId = [
        SELECT ContentDocumentId 
        FROM ContentVersion 
        WHERE Id =: cVersion.id
      WITH USER_MODE].ContentDocumentId; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
      cdl.LinkedEntityId = recordId;
      if (Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()) {
        cdl.ShareType = 'V';
      }
      if (Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable()) {
        cdl.Visibility = 'AllUsers';
      }
      
    try {
        return cdl;
    } catch(DMLException e) {
        return null;
    }
}

private static Map<String,List<Object>> getFilesIdOnTaskforId(Id taskId){

    String[] docIds = new String[]{};
    String[] verIds = new String[]{};
    Map<String,List<Object>> returnMap = new Map<String,List<Object>>();
    
        List<ContentDocumentLink> attObj = [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE LinkedEntityId =:taskId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        for(ContentDocumentLink cdL:attObj){
            docIds.add(cdL.ContentDocumentId);
        }

        List<ContentVersion> versionList = [SELECT ContentDocumentId,Id,IsLatest,Title FROM ContentVersion WHERE ContentDocumentId IN: docIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users

        for(ContentVersion cvL:versionList){
            verIds.add(cvL.Id);
        }
        //logic added for update the attachment flag
        if(verIds!=null && verIds.size()>0){
            Task t = [SELECT Id, Attachment__c from Task Where Id=:taskId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            if(Schema.SObjectType.Task.fields.Attachment__c.isUpdateable()){
                t.Attachment__c = true;
            }
            if(Schema.sObjectType.Task.isUpdateable()){
                update as user t;
            }
        }
        returnMap.put('Ids',verIds);
        returnMap.put('Records',versionList);
        return returnMap;
}
        


private static List<ContentVersion> loadFileOnTask(Id taskId){

    String[] docIds = new String[]{};
    List<ContentDocumentLink> attObj = [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE LinkedEntityId =:taskId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        for(ContentDocumentLink cdL:attObj){
            docIds.add(cdL.ContentDocumentId);
        }

        List<ContentVersion> versionList = [SELECT ContentDocumentId,Id,IsLatest,Title FROM ContentVersion WHERE ContentDocumentId IN: docIds WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users

        
        return versionList;
}
        
}