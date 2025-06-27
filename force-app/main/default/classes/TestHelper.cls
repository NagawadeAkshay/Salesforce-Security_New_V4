/*
    Used to setup test records for other test classes. It has several create() methods for
    various objects which can be used by individual controller and other classes 
    for testing purposes. It is recommended to have all data creation happens in this 
    class and let other classes use it by invoking them.
    
    *************************************************************************************************
    Audit History
    **************************************************************************************************
    2/24/2014        Manasi Gangal              Added few methods to create test data for Sidebar Component
    2/25/2014        Prem Pal                   Added few methods to create test data for FlextTable Component
    4/14/2014        Nakul Kadam                Added methods to create test data for ChartConfig__c, FundingSource, FundingSourceYear & updated 
    ()
    4/17/2014        Hafsa Syed                 Moved test data methods from PlanningChartsControllerTest.cls
    5/28/2014        Hafsa Syed                 Added getBusinessRuleConfig method
    5/29/2014        Ryan Chadiwck              Fixed getAnnouncment()
    6/20/2014        Ryan Chadwick              added getWorkItem, getTask, getAssignedTasks, getUnassignedTasks
    8/15/2014        Raghav Mehta               added getHelpConfig, getPackageMandatoryField, getThemeConfig, getTaskActionSummary, getTaskFieldMapping methods
    7/30/2018        Atul Naik                  added SobjectAutoSnapShot Config.
    *********************************************************getAdminUser*****************************************************  


*/
@isTest
public  class TestHelper {
    static CustomApp__c custApp;
    public static Boolean skipApprovalStepTrigger = false;
    public static Boolean skipCustomAppTrigger = false;

    /*Creating Content Version Object*/
    public static ContentVersion createContentVersion(boolean create){
        String base64Data = 'DERFC Upload Content Val';
        base64Data = EncodingUtil.urlDecode(base64Data,'UTF-8');
        ContentVersion cv = new ContentVersion(Title='Upload File',PathOnClient='Upload File',VersionData=EncodingUtil.base64Decode(base64Data));
        if(create){
            insert cv;
        }
        return cv;
    }

    public static User getAdminUser(boolean create)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(Alias = 'admtp', Email='sysAdmin@govbd.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='sysAdmin'+Math.random()+'@govbd.dev');
        if(create)
            insert u;
        return u;
    }

    public static User getAdminUserDept(boolean create)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(Alias = 'admtp', Email='sysAdmin@govbd.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='sysAdmin'+Math.random()+'@govbd.dev'); //, Department__c='CHA'
        if(create)
            insert u;
        return u;
    }
    
    public static User getStandardUser(boolean create)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' limit 1];
        User u = new User(Alias = 'standt', Email='standarduser@govbd.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser'+Math.random()+'@govbd.dev');
        if(create)
            insert u;
        return u;
    }
    
    /* for all type of user*/
    public static User getUser(boolean create) {
        Profile p = [SELECT Id FROM Profile limit 1];
        User u = new User(Alias = 'standt', Email='standarduser@govbd.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser'+Math.random()+'@govbd.dev');
        if(create)
            insert u;
        return u;
    }
    
    public static Group getGroup(boolean create){
        Group grp = new Group(Name = 'Technology Partner Content',DeveloperName = 'test1234', type = 'Queue');
        if(create)
            insert grp;
        return grp; 
        }
    
   public static TechnicalLinkConfig__c getTechLinkConfig(String phaseId, Boolean create) {
        TechnicalLinkConfig__c tecLink = new TechnicalLinkConfig__c(PhaseConfig__c=phaseId);
        if(create) {
            insert tecLink;
        }
        return tecLink;
   }
   public static TaskConfig__c getTaskConfig(string action,boolean create) {
        TaskConfig__c taskSummary = new TaskConfig__c();
        taskSummary.TaskAction__c = action;
        taskSummary.name = action;
        if(create)
            insert taskSummary;
        return taskSummary;
    }
    
    public static User getPortalUser(boolean create) {
        Contact contact;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User currentUser = TestHelper.getStandardUser(false);
        currentUser.UserRoleId = portalRole.id;
        insert currentUser ;
        
        system.runAs(currentUser){
            Account account = TestHelper.getAccount(false);
            //account.ApplicantType__c = 'State governments';
            account.type = 'Customer';
            //account.EINo__c = 999;
            //account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('External').getRecordTypeId();
            insert account;
            
            contact = TestHelper.getContact(false);
            contact.AccountId= account.id;
            insert contact;
        }

        Profile profile = [select Id,name from Profile where UserLicense.Name like 'Partner Community Login' limit 1];
        
        User portalUser = new User(
            Username = System.now().millisecond() + 'test12345@test1.com',
            ContactId = contact.Id,
            ProfileId = profile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        if(create)
            insert portalUser;
        return portalUser;
    }
       
    public static User getStandardPlatformUser(boolean create)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User'];
        List<User> users = [Select Id, Name from User where username='standarduser@govgrants.dev.test'];
        if (users.size() == 1) {
            return users.get(0);
        }
        User u = new User(Alias = 'standt', Email='standarduser@govbd.dev', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/New_York', UserName='standarduser@govgrants.dev.test');
        if(create)
            insert u;
        return u;
    }
    public static Document createTestDocument(boolean create, string name){
         Document d = new Document();
         d.name = name;
         d.body = Blob.valueof('Test Data');
         d.AuthorId = UserInfo.getUserId();
         d.FolderId = UserInfo.getUserId();
         if(create){
             insert d;  
         }
         return d;
    }
    
    public static User getStandardUser(boolean create, string username)
    {
        User u;
        List<User> userList = [SELECT Id, Name FROM User WHERE Username = :username];
        
        if(userList.size() > 0)
        {
            u = userList.get(0);
        }
        else
        {
            
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            u = new User(Alias = 'user9idu',  
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/New_York');
            u.Username = username;
            u.Email = username;
            
            if(create) {
                insert u;
            }
        }
        return u;
    }
    
    //Create a sample contact record for a given account record id.
    public static Contact getContact(Boolean create) {
        Contact contact = new Contact(Firstname='FirstName', Lastname='LastName',Email='email@email.com', Title='Title',Phone ='123-123-1234');
        if (create) {  
            insert contact;
        }
        return contact;
    }
    
    public static ProcessInstanceWorkitem getWorkItem(){
        ProcessInstanceWorkitem witem;
        User tmpusr = getStandardPlatformUser(true);
        System.runAs( tmpusr ){
            witem = new ProcessInstanceWorkitem();
        }
        
        return witem;
    }
    
    
    public static ApexJob__c createApexJob(Boolean create) {
        ApexJob__c apexJob = new ApexJob__c(Name='test',IntervalMins__c=5);
        if(create) {
            insert apexJob; 
        }
        return apexJob;
    }

   
    public static Task getTask(Boolean create){
        SampleObject11__c sam = getSampleObject1(true);
        Task tempTask = new Task();
        tempTask.ActivityDate = System.today();
        tempTask.ActivityDuplicateDate__c= System.today();
        tempTask.Description = 'The new phone books are here Im somebody again';
        tempTask.DocumentType__c = 'SampleObjects';
        tempTask.whatId = sam.id;
        if(create){
            insert tempTask;
        }
        return tempTask;
    }
    
    public static List<Task> getAssignedTasks(Boolean create){
        List<Task> taskList = new List<Task>();
        
        String[] theDocs = new List<String> {'Announcement', 'Application', 'Pre-Application','Progress Report', 'Program',
                                'Funding Source', 'Funding Account', 'Review Award', 'Create Award', 
                                'Organization', 'User', 'Submission Package'};
        
        for( String docStr : theDocs ){
            Task tempTask = getTask(false);
            tempTask.WorkitemId__c = getWorkItem().Id;
            tempTask.DocumentType__c = docStr;
            taskList.add(tempTask);
        }
        if (create) {
            insert taskList;
        }
        return taskList;
    }
    
    public static List<Task> getUnassignedTasks(Boolean create){
        List<Task> taskList = new List<Task>();
        
        String[] theDocs = new List<String> {'Announcement', 'Application', 'Pre-Application','Progress Report', 'Program',
                                'Funding Source', 'Funding Account', 'Review Award', 'Create Award', 
                                'Organization', 'User', 'Submission Package'};
        
        for( String docStr : theDocs ){
            Task tempTask = getTask(false);
            tempTask.WorkitemId__c = getWorkItem().Id;
            tempTask.GroupId__c = 'more garbage';
            tempTask.GroupName__c = 'System Administrator';
            tempTask.DocumentType__c = docStr;
            taskList.add(tempTask);
        }
        
        if (create) {
            insert taskList;
        }
        return taskList;
    }
    
    public static Id getPageAttachmentConfigRecordTypeId(){
        Id recordTypeId;
        recordTypeId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Action config').getRecordTypeId();
        return recordTypeId;
    }

    public static PageAttachmentConfig__c getPageAttachmentConfig(String pageBlockid, Boolean create) {
        PageAttachmentConfig__c pageAttachmentConfig = new PageAttachmentConfig__c(PageBlockConfig__c=pageBlockid);
        pageAttachmentConfig.HideForContext__c = 'Edit';
        pageAttachmentConfig.RecordTypeId = getPageAttachmentConfigRecordTypeId();
        if(create) {
            insert pageAttachmentConfig;
        }
        return pageAttachmentConfig;
    }
    
    public static MessageConfig__c getMessageConfig(String pageLayoutId, String pageBlockId, Boolean create) {
        MessageConfig__c messageConfig = new MessageConfig__c(PageBlockConfig__c=pageBlockId, PageLayoutConfig__c=pageLayoutId, MessageRich__c='test');
        if(create) {
            insert messageConfig;
        }
        return messageConfig;
    }
    
    public static LayoutBusinessRuleConfig__c getLayoutBizRule(String pageBLockId, String pageLaoutId, Boolean create) {
        LayoutBusinessRuleConfig__c layoutBizRule = new LayoutBusinessRuleConfig__c(PageBlockConfig__c=pageBLockId,
            PageLayoutConfig__c=pageLaoutId);
        if(Create) {
            insert layoutBizRule;
        }
        return layoutBizRule;
    }
   
    public static void setFlexTableConfig(Id tabConfig, Id  tableId, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Table').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Flex Table',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId,FlexTableName__c=tableId);
        if (create) {
            insert pageBlockConfig;
        }
    }

    public static void setMassEditableFlexGridConfig(Id tabConfig, Id  gridId, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Grid').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Flex Table',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId, FlexGridName__c = gridId);
        if (create) {
            insert pageBlockConfig;
        }
    }

    public static void setN2GFlexGridConfig(Id tabConfig, Id  gridId, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Grid').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Flex Table',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId, FlexGridName__c = gridId);
        if (create) {
            insert pageBlockConfig;
        }
    }

    public static void setBudgetFlexGridConfig(Id tabConfig, Id  gridId, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Grid').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Flex Table',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId, FlexGridName__c = gridId);
        if (create) {
            insert pageBlockConfig;
        }
    }

    public static void setPageBlockConfigWithForm(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Forms').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Form',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {
            insert pageBlockConfig;
        }

    }

    public static void setCommunicationPageBlock(Id tabConfig, Id  tableId,Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Communication').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Collab',
                SortOrder__c=2,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId,CommunicationEmailFieldName__c='Owner.Email',FlexTableName__c=tableId);
        if (create) {
            insert pageBlockConfig;
        }
    }
    public static void setCommunicationPageBlock(Id tabConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Communication').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test Collab',
                SortOrder__c=2,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId,CommunicationEmailFieldName__c='Owner.Email');
        if (create) {
            insert pageBlockConfig;
        }
    }

    public static void setPageBlockConfigWithNotes(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Notes and Attachments').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {
            insert pageBlockConfig;
        }

    }

    public static void setPageBlockConfigWithAttachment(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Attachments').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c = '1', IsActive__c = true, PageBlockTitle__c = 'Test',
                SortOrder__c = 0, TabLayoutConfig__c = tabConfig, RecordTypeId = recTypeId);
        if (create) {
            insert pageBlockConfig;
        }
    }

    public static void setPageBlockConfigWithApprovalHistory(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Approval History').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId,IsApprovalHistoryList__c=true);
        if (create) {
            insert pageBlockConfig;
        }

    }

    public static void setPageBlockConfigWithCollab(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Collab').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {
            insert pageBlockConfig;
        }

    }

    public static void setPageBlockConfigWithDigitalSigned(Id tabConfig, Boolean create) {
        // Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Digitally Signed').getRecordTypeId();
        // PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
        //         SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        // if (create) {
        //    insert pageBlockConfig;
        // }


    }


    public static PageTemplate__c getPageTemplateConfigForPrintGenrator(Boolean create) {
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(true);
        TabConfig__c tabConfig = new TabConfig__c(IsActive__c=true,PageLayoutConfig__c=pageLayoutConfig.id,SortOrder__c=0,StandardTabName__c='Tab 1',HideforQueue__c='test',HeaderInstructionText__c='test',isOverview__c=false,SkipForExport__c=false);
        insert tabConfig;      
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true,'Fields');//getPageBlockConfig(tabConfig.Id, true);
        getPageAttachmentConfig(pageBlockConfig.Id, true);
        DataTableConfig__c dtComConfig = getFlexTableConfig(true,true);
        setCommunicationPageBlock(tabConfig.Id,dtComConfig.Id,true);
        DataTableConfig__c dtConfig = getFlexTableConfig(true,false);
        setFlexTableConfig(tabConfig.Id, dtConfig.Id,true);      
        FlexGridConfig__c flexGridConfig = getFlexGridConfig(true);
        setBudgetFlexGridConfig(tabConfig.Id, flexGridConfig.Id,true);
       
        //    FlexGridConfig__c flexGridConfigMe = getFlexGridConfigME(true);
       
        FlexGridConfig__c flexGridConfigN2G =  getFlexGridConfigN2G(true);
        //   setMassEditableFlexGridConfig(tabConfig.Id, flexGridConfigMe.Id,true);
        setN2GFlexGridConfig(tabConfig.Id, flexGridConfigN2G.Id,true);
        setPageBlockConfigWithForm(tabConfig.Id, true);
        setPageBlockConfigWithAttachment(tabConfig.Id, true);
        setPageBlockConfigWithNotes(tabConfig.Id, true);
        setPageBlockConfigWithApprovalHistory(tabConfig.Id, true);
        setPageBlockConfigWithCollab(tabConfig.Id, true);
        //setPageBlockConfigWithDigitalSigned(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true);

        renderBlankSpace(pageBlockConfig.Id,true);
        renderStaticPageBlockDetail(pageBlockConfig.Id,true);
        renderFieldLevelAttachment(pageBlockConfig.Id,true);
        renderCurrencyFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderMultiSelectPicklistFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderDateFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderDateTimeFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderTimeFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderRichTextAreaFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderRefrenceFieldPageBlockDetail(pageBlockConfig.Id,true);

        renderBooleanFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderTextAreaFieldPageBlockDetail(pageBlockConfig.Id,true);
        renderPicklistFieldPageBlockDetail(pageBlockConfig.Id,true);


        renderAlternateRenderPicklist(pageBlockConfig.Id,true);
        renderAlternateRenderCheckBox(pageBlockConfig.Id,true);
        renderAlternateRenderRadio(pageBlockConfig.Id, true);
        //renderAlternateRenderTypeahead(pageBlockConfig.Id,true);
        //getPageBlockConfigWithFlexTable(tabConfig.Id, true);
        getPageLayoutActionConfig(true, pageLayoutConfig.Id);
        getMessageConfig(pageLayoutConfig.Id, pageBlockConfig.Id, true);
        getLayoutBizRule(pageBlockConfig.Id, pageLayoutConfig.Id, true);

        //getPageBlockConfigWithNotes(tabConfig.Id, true);
        //getPageBlockConfigWithAttachment(tabConfig.Id, true);
        //getPageBlockConfigWithForm(tabConfig.Id, true);
        //getPageBlockConfigWithRecordHistory(tabConfig.Id, true);
        //getPageBlockConfigWithApprovalHistory(tabConfig.Id, true);
        //getPageBlockConfigWithCollab(tabConfig.Id, true);
        //getPageBlockConfigWithDigitalSigned(tabConfig.Id, true);


        /*tabConfig =  getTabConfig(pageLayoutConfig.Id,false);
        tabConfig.isOverview__c = true;
        insert tabConfig;
        pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);

        pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true);*/

        if(custApp == null) {
            custApp = getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',SkipFormDownload__c=false,
                RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
        if (create) {
            insert template;
        }
        return template;
    }

    public static PageTemplate__c getPageTemplateConfig(Boolean create) {
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(true);
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
        getPageAttachmentConfig(pageBlockConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true);
        //getPageBlockConfigWithFlexTable(tabConfig.Id, true);
        getPageLayoutActionConfig(true, pageLayoutConfig.Id);
        getMessageConfig(pageLayoutConfig.Id, pageBlockConfig.Id, true);
        getLayoutBizRule(pageBlockConfig.Id, pageLayoutConfig.Id, true);
        //getPageBlockConfigWithNotes(tabConfig.Id, true);
        //getPageBlockConfigWithAttachment(tabConfig.Id, true);
        //getPageBlockConfigWithForm(tabConfig.Id, true);
        //getPageBlockConfigWithRecordHistory(tabConfig.Id, true);
        //getPageBlockConfigWithApprovalHistory(tabConfig.Id, true);
        //getPageBlockConfigWithCollab(tabConfig.Id, true);
        //getPageBlockConfigWithDigitalSigned(tabConfig.Id, true);
        
        tabConfig =  getTabConfig(pageLayoutConfig.Id,false);
        tabConfig.isOverview__c = true;
        insert tabConfig;
        pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
        pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true);
        if(custApp == null) {
            custApp = getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate1'+System.now().millisecond(), EditLayoutConfig__c=pageLayoutConfig.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Description__c ='testDesc',
                ViewLayoutConfig__c=pageLayoutConfig.Id,PrintLayoutConfig__c = pageLayoutConfig.Id, CustomAppConfig__c=custApp.Id,OMBNumber__c='F-0001',SkipFormDownload__c=false,
                                         RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Business Form').getRecordTypeId(),PackageType__c='Application',Type__c='Standard');
        if (create) {
            insert template;
        }
        return template;
    }
    

    public static PageTemplate__c getPageTemplateConfig(Boolean create,Id pageLayoutId) {
        if(custApp == null) {
            custApp = getCustomApp(true);
        }
        PageTemplate__c template = new PageTemplate__c(Name='TestTemplate', EditLayoutConfig__c=pageLayoutId,
                                        ViewLayoutConfig__c=pageLayoutId,PrintLayoutConfig__c = pageLayoutId, CustomAppConfig__c=custApp.Id,SObjectName__c =AppUtils.getNamespacePrefix()+'SampleObject12__c',Type__c='Custom',
                                        PackageType__c='Application',Description__c ='testDesc',RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId());
        if (create) {  
            insert template;
        }
        return template;
    }
    
    public static Package__c getPackage(Boolean create,PageTemplate__c pageTemplate) {
        Account acc = getAccount(true);        
        if(custApp == null) {
            custApp = getCustomApp(true);
        }
        Package__c packageNew = new Package__c (PageTemplateConfig__c =pageTemplate.id,Status__c = 'Active',
                            SubmissionType__c = 'Application',LatestVersion__c=true,Description__c='testDescription1', CustomAppConfig__c=custApp.Id,
                            ObjectAPIName__c=AppUtils.getNamespacePrefix()+'SampleObject12__c',ValidateFormFieldAPIName__c=AppUtils.getNamespacePrefix()+'FormsValidated__c',
                            RecordTypeId = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId());
        if (create) {  
            insert packageNew ;
        }
        return packageNew ;
    }
    public static Package__c getPackage(Boolean create,String submissionType) {
        PageTemplate__c ptc = getPageTemplateConfig(true);
        if(custApp == null) {
            custApp = getCustomApp(true);
        }
        Package__c packageNew = new Package__c (Status__c = 'Active',PageTemplateConfig__c =ptc.id,
                            RecordTypeId = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId(),
                            SubmissionType__c = submissionType,LatestVersion__c=true,Description__c='testDescription1', CustomAppConfig__c=custApp.Id);
        if (create) {  
            insert packageNew ;
        }
        return packageNew ;
    }
    
    public static Package__c getPackage_Data_1(Boolean create,String submissionType) {
        PageTemplate__c ptc = getPageTemplateConfig(false);
        ptc.RecordTypeId = Schema.SObjectType.PageTemplate__c.getRecordTypeInfosByName().get('Layout Form').getRecordTypeId();
        insert ptc;
        if(custApp == null) {
            custApp = getCustomApp(true);
        }
        Package__c packageNew = new Package__c (Status__c = 'Active',PageTemplateConfig__c =ptc.id,
                            RecordTypeId = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get('Standard').getRecordTypeId(),
                            SubmissionType__c = submissionType,LatestVersion__c=true,Description__c='testDescription1', CustomAppConfig__c=custApp.Id);
        if (create) {  
            insert packageNew ;
        }
        return packageNew ;
    }
    
    public static PageLayoutActionConfig__c getPageLayoutActionConfig(Boolean create,Id pageConfigId) {
       PageLayoutActionConfig__c pageAction = new PageLayoutActionConfig__c(ActionURL__c='/apex/abc?xyz={!abc}',Type__c='Button',PageLayoutConfig__c=pageConfigId,
       HideForContext__c='Edit', HideForUser__c='Internal', HideForQueue__c = 'test1234', HideForProfile__c= 'System Administrator', 
       DisableDecisionExpression__c='true', HideDecisionExpression__c = 'SampleNumber1__c =2', HideOperator__c = 'AND',HidePanel__c = 'Header', 
       StandardAction__c = 'Delete',ActionClass__c = 'DynamicLayoutDeleteHelper',ActionBehavior__c = 'Open in overlay', DisplayArea__c='Menu',
       ModalHeight__c = 400, ModalWidth__c = 400, ModalTitle__c = 'Sample Modal', SubmitWarningMessage__c = 'Do you want to delete record?', 
       RecordTypeId = Schema.SObjectType.PageLayoutActionConfig__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId()); 
         if (create) {  
            insert pageAction ;
        }
        return pageAction ;
    }
    
    public static PageLayoutConfig__c getPageLayoutConfig(Boolean create) {
        PageLayoutConfig__c pageLayout = new PageLayoutConfig__c(Name='Test View Layout',isActive__c = true, Description__c='Test Page Layout',
                    ObjectAPIName__c=AppUtils.getNamespacePrefix()+'SampleObject12__c');
                    
        if (create) {  
            insert pageLayout;
        }
        return pageLayout;
    } 
   

    public static PageLayoutConfig__c getPageLayoutConfig(Boolean create, String objectAPIName ) {
        PageLayoutConfig__c pageLayout = new PageLayoutConfig__c(Name='Test View Layout', Description__c='Test Page Layout',
                    ObjectAPIName__c= objectAPIName);
        if (create) {  
            insert pageLayout;
        }
        return pageLayout;
    }
    
       
    
    public static HelpConfig__c getHelpConfig(Boolean create) {
       
        return null;
    }
    
    public static HelpConfig__c getHelpConfigWithoutRecordType(Boolean create) {
        Id recTypeId = Schema.SObjectType.HelpConfig__c.getRecordTypeInfosByName().get('External Link').getRecordTypeId();
        HelpConfig__c helpConfig = new HelpConfig__c(RecordTypeId=recTypeId);
        if (create) {  
            insert helpConfig;
        }
        return helpConfig;
    }
    
    public static HelpConfig__c getHelpConfigWithRecordType(Boolean create, String name) {
        Id recTypeId = Schema.SObjectType.HelpConfig__c.getRecordTypeInfosByName().get(name).getRecordTypeId();
        HelpConfig__c helpConfig = new HelpConfig__c(RecordTypeId=recTypeId, DocumentName__c='testClassDoc');
        if (create) {  
            insert helpConfig;
        }
        return helpConfig;
    }
    
    public static TabConfig__c getTabConfig(Id pageLayout,Boolean create) {
        TabConfig__c tabConfig = new TabConfig__c(IsActive__c=true,PageLayoutConfig__c=pageLayout,SortOrder__c=0,StandardTabName__c='Tab 1',HideforQueue__c='test',HeaderInstructionText__c='test',isOverview__c=false,SkipForExport__c=false);
        if (create) {  
            insert tabConfig;
        }
        return tabConfig;
    }
    

    public static PageBlockConfig__c getPageBlockConfig(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Fields').getRecordTypeId();
        DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable'+AppUtils.generateToken(null).substring(0, 10);
        dataTableConfig.SObject__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        dataTableConfig.FieldNames__c = 'Id,OldValue';  
        //dataTableConfig.FilterCriteria__c = 'Name != {!name} ';
        dataTableConfig.Description__c='TestDescription';  
      
        dataTableConfig.HelpConfig__c = getHelpConfigWithRecordType(true, 'Internal Document').Id;  
        insert dataTableConfig;
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(FlexTableName__c=dataTableConfig.Id,BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfig(Id tabConfig, Boolean create,String recordType) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithFlexTable(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Table').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId, FlexTableName__c=getDataTableConfig(true).Id);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithFlexGrid(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Fields').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithNotes(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Notes and Attachments').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithAttachment(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Attachments').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithForm(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Forms').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithRecordHistory(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Record History').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithApprovalHistory(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Approval History').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithCollab(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Collab').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockConfig__c getPageBlockConfigWithDigitalSigned(Id tabConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Digitally Signed').getRecordTypeId();
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c(BodyColumns__c='1',IsActive__c=true,PageBlockTitle__c='Test',
                    SortOrder__c=0,TabLayoutConfig__c=tabConfig,RecordTypeId=recTypeId);
        if (create) {  
            insert pageBlockConfig;
        }
        return pageBlockConfig;
    }
    
    public static PageBlockDetailConfig__c getPageBlockDetailConfig(Id pageBlockConfig, Boolean create) {
        
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c='Name',
                HideFieldsJSON__c='[{"FieldToHide":"ggf_dev3__SampleObject1__c","FieldValue":"Grant,Grants","Operator":"IN","Action":"hide"},{"FieldToHide":"ggf_dev6__SampleText1__c","FieldValue":"sample123","Operator":"NOT IN","Action":"hide"},' +
                        '{"FieldToHide":"ggf_dev6__SampleText1__c","FieldValue":"sample2","Operator":"==","Action":"hide"},{"FieldToHide":"ggf_dev6__SampleText1__c","FieldValue":"sample123","Operator":"!=","Action":"hide"}]');
        
        if (create) {  
            insert pageBlockDetail;
        }
        return pageBlockDetail;
    }
    

    public static void renderStaticPageBlockDetail(Id pageBlockConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Static Text').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c='Name',StaticText__c='Global Leason Learned in 2020');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderBlankSpace(Id pageBlockConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Blank Space').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig);

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderFieldLevelAttachment(Id pageBlockConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field Level Attachment').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c='Name',AttachmentClassifications__c='History',ClassificationFieldAPIName__c='Name');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderCurrencyFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'Currency1__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderMultiSelectPicklistFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleMultiSelectPicklist1__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderDateFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleDate__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderDateTimeFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        Datetime dtVal = System.now();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleDateTime__c',DefaultValue__c=String.valueOf(dtVal));

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderTimeFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'TimeVal__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderBooleanFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleCheckbox2__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderTextAreaFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleTextArea1__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderRichTextAreaFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'Sample_Rich_text__c',IsRichTextArea__c=true);

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderRefrenceFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleObject11__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderPicklistFieldPageBlockDetail(Id pageBlockConfig, Boolean create){
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'Status__c');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderAlternateRenderCheckBox(Id pageBlockConfig, Boolean create) {
        DynamicFieldConfigData__mdt checkboxConfig = getDynamicFieldConfig(true,'Checkbox');
        Picklist__c pickVal = getPicklist(true);
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleHideForms__c',AltRenderingConfig__c='TestName');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderAlternateRenderRadio(Id pageBlockConfig, Boolean create) {
        DynamicFieldConfigData__mdt fieldConfig = getDynamicFieldConfig(true,'Radio');
        Picklist__c pickVal = getPicklist(true);
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleAltRen__c',AltRenderingConfig__c='TestName');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderAlternateRenderPicklist(Id pageBlockConfig, Boolean create){
        DynamicFieldConfigData__mdt picklistConfig = getDynamicFieldConfig(true,'Picklist');
        PickList__c pickVal = getPicklist(true);
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c='Name',AltRenderingConfig__c='TestName');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static void renderAlternateRenderTypeahead(Id pageBlockConfig, Boolean  create){
        DynamicFieldConfigData__mdt typeheadConfig = getDynamicFieldConfig(true,'Typeahead');
        PickList__c pickVal = getPicklist(true);
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                PageBlockConfig__c=pageBlockConfig,
                FieldAPIName__c=AppUtils.getNameSpacePrefix()+'SampleObject11__c',AltRenderingConfig__c='TestName');

        if (create) {
            insert pageBlockDetail;
        }
    }

    public static PageBlockDetailConfig__c getPageBlockDetailConfigFieldSet(Id pageBlockConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field Set').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                    PageBlockConfig__c=pageBlockConfig, FieldAPIName__c='Id');
        if (create) {  
            insert pageBlockDetail;
        }
        return pageBlockDetail;
    }
    
    public static PageBlockDetailConfig__c getPageBlockDetailConfig2(Id pageBlockConfig, Boolean create) {
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        PageBlockDetailConfig__c pageBlockDetail = new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                    PageBlockConfig__c=pageBlockConfig, FieldAPIName__c='Account.Name');
        if (create) {  
            insert pageBlockDetail;
        }
        return pageBlockDetail;
    }
    
    public static List<ID> setLayoutData() {
        List<ID> layoutIDs = new List<ID>();
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(true);
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        PageLayoutActionConfig__c pageAction = getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        layoutIDs.add(pageLayoutConfig.Id);
        layoutIDs.add(tabConfig.ID);
        layoutIDs.add(pageBlockConfig.Id);
        layoutIDs.add(pageBlockDetailConfig.Id);
        layoutIDs.add(pageAction.Id);
        return layoutIDs;       
    }

    public static List<ID> setLayoutData(String objectAPIName) {
        List<ID> layoutIDs = new List<ID>();
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(true,objectAPIName);
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        PageLayoutActionConfig__c pageAction = getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        layoutIDs.add(pageLayoutConfig.Id);
        layoutIDs.add(tabConfig.ID);
        layoutIDs.add(pageBlockConfig.Id);
        layoutIDs.add(pageBlockDetailConfig.Id);
        layoutIDs.add(pageAction.Id);
        return layoutIDs;       
    }
    
    public static List<ID> setLayoutDataRelationShipField() {
        List<ID> layoutIDs = new List<ID>();
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(true);
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
        PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig2(pageBlockConfig.Id,true); 
        
        layoutIDs.add(pageLayoutConfig.Id);
        layoutIDs.add(tabConfig.ID);
        layoutIDs.add(pageBlockConfig.Id);
        layoutIDs.add(pageBlockDetailConfig.Id);
        return layoutIDs;       
    }
    public static PhaseConfig__c getPhase(boolean create) {
        CustomApp__c customAppObj = getCustomApp(true);
        PhaseConfig__c phase = new PhaseConfig__c();
        phase.Name = 'TestPhase';
        phase.TabName__c='PLANNING';
        phase.CustomAppName__c = customAppObj.Name;//'StateAsGrantor';
        phase.URL__c = '/apex/planning';
        phase.GroupName__c='2';
        phase.Sequence__c=2;
        phase.Abbreviation__c ='PL';
        phase.SObject__c = 'Accouncement__c;Program__c;Package__c'; 
        phase.AccordionHeader__c = 'Planning';
        phase.EnableSearch__c = true;
        phase.SidebarSearchLabel__c = 'Search';
        phase.SidebarRecentlyViewedLabel__c = 'Recently Viewed';
        phase.SidebarExternalLinksLabel__c = 'External Links';     
        phase.SearchResultPage__c ='/apex/planning';
        phase.SidebarComponentSequence__c = 'Search,Links,RecentlyViewed,SubMenu,ActivityMenu';
        phase.EnableExternalLinks__c = true;
     
        phase.Active__c= true;
        phase.PhaseType__c = 'Phase';
        phase.SelectedByDefault__c = true;
        
        if (create) {
            insert phase;
        } 
        return phase;    
    }
    
    public static PhaseConfig__c getDashboardPhase(boolean create) {
        
        getCustomApp(true);
        PhaseConfig__c phase = new PhaseConfig__c();
        phase.Name = 'TestDashboardPhase';
        phase.CustomAppName__c = 'StateAsGrantor';
        phase.Abbreviation__c ='PL';
        phase.SObject__c = ''; 
        phase.AccordionHeader__c = 'Dashboard';
        phase.EnableSearch__c = true;
        phase.SidebarSearchLabel__c = 'Search';
        phase.SidebarRecentlyViewedLabel__c = 'Recently Viewed';
        phase.SidebarExternalLinksLabel__c = 'External Links';
        //phase.URL__c = '/apex/Dashboard';
        phase.SearchResultPage__c ='/apex/Dashboard';
        phase.SidebarComponentSequence__c = 'Search,Links,RecentlyViewed,SubMenu';
        phase.TabName__c='DASHBOARD';
        //phase.GroupName__c='2';
        phase.Sequence__c=2;
        phase.Active__c= true;
        phase.PhaseType__c = 'Dashboard';
        phase.URL__c = 'https://www.mpictures.co.th';
        phase.GroupName__c = 'TestName';
        phase.SelectedByDefault__c = true;
        
        if (create) {
            insert phase;
        } 
        return phase;    
    }
    
     public static ChartConfig__c getBoxChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Box'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
     public static ChartConfig__c getEnhancedChartConfig(Boolean create, Id phaseConfigId) {
     String ns;
     ns=AppUtils.getNameSpacePrefix();
      ChartConfig__c chart = new ChartConfig__c();
        chart.Name = 'Sample bar chart1';
        chart.Title__c = 'sample bar chart1';
      //  chart.Query__c = 'select Id, name,CodeNumber__c,ApplicantNumber__c from user  WHERE CodeNumber__c!=null ApplicantNumber__c !=null limit 12';    
        chart.PhaseConfig__c = phaseConfigId;
        chart.Query__c = 'select Id, name,ggf_dev1__CodeNumber__c,ggf_dev1__ApplicantNumber__c from user where ggf_dev1__CodeNumber__c !=null and ggf_dev1__ApplicantNumber__c!=null Limit 12';                                                                                                                                                          // Query2
        chart.DataTableQueryForAllData__c = 'select Id,name,ggf_dev1__CodeNumber__c,ggf_dev1__ApplicantNumber__c from user where ggf_dev1__CodeNumber__c  !=null and ggf_dev1__ApplicantNumber__c!=null';     
        chart.DataTableQueryForSelectedData__c = 'select Id,name,ggf_dev1__CodeNumber__c ,ggf_dev1__ApplicantNumber__c from user where Name = Alex and  ggf_dev1__CodeNumber__c = 321';  
       // chart.ggf_dev1__ApexClassName__c = 'EnhancedChartHelper';
       // chart.ObjectName__c=ns+'User';
        chart.UniqueName__c= 'sample chart';
        chart.DisplayDataType__c = 'Currency';
     //   chart.ChartType__c =null ;                                                                                                                                                                         
        chart.GlobalFilterApplicable__c = true;                                                                                                                                                                
                                                                                                                                                                       
        chart.DataTableHeader__c = 'User data';                                                                                                                                                              
        chart.AllDataTableHeader__c = 'test';                                                                                                                                                                
        chart.XAxis__c = 'Name';                                                                                                                                                                                
        chart.XAxisLabel__c = 'Name';                                                                                                                                                                         
        chart.YAxis__c = 'ggf_dev1__CodeNumber__c';                                                                                                                                                         
        chart.YAxisLabel__c = 'Code Number';                                                                                                                                                                 
        chart.YAxisDualAxisChart__c = 'ggf_dev1__ApplicantNumber__c';                                                                                                                                      
        chart.YAxisLabelDual__c = 'Applicant Number';                                                                                                                                                       
        chart.DualChartType1__c = 'column';                                                                                                                                                                  
        chart.DualChartType2__c = 'line';                                                                                                                                                                   
        chart.XAxisPrefix__c = 'xxxx';                                                                                                                                                                     
        chart.XAxisSuffix__c = 'xx';                                                                                                                                                                          
        chart.YAxisPrefix__c = 'yyyy';                                                                                                                                                                          
        chart.YAxisSuffix__c = 'yy';                                                                                                                                                                           
        chart.ZAxisPrefix__c = 'zzzz';                                                                                                                                                                         
        chart.ZAxisSuffix__c = 'zz';                                                                                                                                                                          
        chart.XFormattedNumber__c = false;                                                                                                                                                                    
        chart.AllowDecimalNumberXaxis__c = true;                                                                                                                                                              
        chart.YFormattedNumber__c = false;                                                                                                                                                                   
        chart.AllowDecimalNumberYaxis__c = false;                                                                                                                                                             
        chart.ZFormattedNumber__c = false;                                                                                                                                                                   
        chart.AllowDecimalNumberZaxis__c = false; 
        chart.MapRegion__c='World';
        Chart.HeaderStyle__c='Horizontal';
          if (create) {  
            insert Chart ;
        }
        return Chart;
        }
    public static ChartDetailConfig__c getBoxChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
    
    public static ChartConfig__c getPie3DChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Pie - 3D'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getPie3DChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
     public static ChartConfig__c getBarStackChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Bar - Stacked'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getBarStackChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
     public static ChartConfig__c getGaugeAngularChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Gauge - Angular'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getGaugeAngularChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
    
    public static ChartConfig__c getFunnelBasicChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Funnel - Basic'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getFunnelBasicChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
    
     public static ChartConfig__c getBasicLineChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Basic Line'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getBasicLineChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
     public static ChartConfig__c getBarBasicChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Bar - Basic'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getBarBasicChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }  
      
    public static ChartConfig__c getColumnBasicChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Column - Basic'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getColumnBasicChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
    
     public static ChartConfig__c getHeatMapChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'HeatMap'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getHeatMapChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
    public static ChartConfig__c getStackedColumnChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Stacked-Column'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getStackedColumnChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;  
    }  
    
     public static ChartConfig__c getColumnDrillChart(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Summary',UniqueName__c = '92',active__c = true,ObjectName__c='SampleObject11__c',
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Column Drill Down'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getColumnDrillChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Summary ', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;  
    }  
    
    
    
    public static ChartConfig__c getProgressChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Progress', ObjectName__c=AppUtils.getNamespacePrefix()+'FundingSourceYear__c', 
                    Title__c='Progress',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId,UniqueName__c = '92',active__c = true, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Progress Bar'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartDetailConfig__c getProgressChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Currency', Title__c='Program Progress', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }    
    
    
    public static ChartConfig__c getDonutChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='ProgramStatus', ObjectName__c=AppUtils.getNamespacePrefix()+'Program__c', 
                    Title__c='ProgramStatus',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId,UniqueName__c = '92',active__c = true, 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Pie - Semi Circle Donut'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    
     public static ChartDetailConfig__c getDonutChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Program Status', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }
    

     public static ChartConfig__c getAnnouncementChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Total Announcement', ObjectName__c='SampleObject11__c',UniqueName__c = '92',active__c = true, 
                    Title__c='Total Announcement',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, FilterFieldNames__c='FiscalYear__c', 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Pie - Basic'));
        if (create) {  
            insert ChartConfig ;
        }
        
        return ChartConfig ;
    }
    
     public static SampleObject1__c getSampleObject1Val(Boolean create) {
        SampleObject1__c sampleObj = new SampleObject1__c(Name='test',Status__c = 'In Progress',SamplePicklist1__c = 'Sample');
        if(create) {
            insert sampleObj;
        }
        return sampleObj;
    }
    
    public static SampleObject11__c getSampleObject1(Boolean create) {
        SampleObject11__c sampleObj = new SampleObject11__c(Name='test',Status__c = 'In Progress',SamplePicklist1__c = 'Sample');
        if(create) {
            insert sampleObj;
        }
        return sampleObj;
    }
    
    public static SampleObject12__c getSampleObject2(Boolean create, String sampleObj1) {
        SampleObject12__c sampleObj = new SampleObject12__c(Name='test', SampleObject11__c=sampleObj1, SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        if(create) {
            insert sampleObj;
        }
        return sampleObj;
    }
    
    public static SampleObject2__c getSampleObject2Val(Boolean create) {
        SampleObject2__c sampleObj = new SampleObject2__c(Name='test', SampleText1__c ='test', Status__c ='InProgress');
        if(create) {
            insert sampleObj;
        }
        return sampleObj;
    }
    
     public static ChartDetailConfig__c getPieChartDetailConfig(Boolean create,Id ChartConfig) {
        ChartDetailConfig__c ChartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Announcement Status', 
                     ChartConfig__c = ChartConfig);
                     
        if (create) {  
            insert ChartDetailConfig ;
        }
        return ChartDetailConfig ;
    }
    //TODO: don't return any value and no need for input parameter. Also line wrap more than 80 characters.
    public static boolean createCustomSettings(Boolean create) {
        List<KeyValueStore__c> listCustomSetting = new List<KeyValueStore__c>();
        
        KeyValueStore__c FeedbackSupportEmail = new KeyValueStore__c(Name='FeedbackSupportEmail',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        
        KeyValueStore__c keyValueEmail = new KeyValueStore__c(Name='exSendErrorEmailRealTime',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Flag to indicate that the exception email should be sent in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueEmailSubject = 
                new KeyValueStore__c(Name='exEmailSubject',TextValue__c='Please take the necessary steps', 
                Description__c='Subject of the Error Email which will be sent to the users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueSavetoSalesforce = new KeyValueStore__c(Name='exSavetoSalesforce',
                TextValue__c='Flag to indicate to save to SF',BooleanValue__c=true,Description__c='Flag to save to Salesforce',Admin_Question__c = 'Loren Ipsum'); 
        KeyValueStore__c keyValueexDispalyGenericErrorUI =  new KeyValueStore__c(Name='exDispalyGenericErrorUI',
                TextValue__c='Following Exception occured in the System',BooleanValue__c=true,Description__c='Flag to Display the Generic Message',Admin_Question__c = 'Loren Ipsum');  
        KeyValueStore__c keyRecentlyViewedRecordsLimit =  new KeyValueStore__c(Name='RecentlyViewedRecordsLimit',IntegerValue__c=10, 
                Description__c='Count of the recently v',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHomeTabFlag =  new KeyValueStore__c(Name='homeTabFlag',BooleanValue__c=true,
                Description__c='Custom setting to hide the home tab',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHidepublicSearch =  new KeyValueStore__c(Name='HidepublicSearch',BooleanValue__c=true,
                Description__c='Custom setting to hide the public Search',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyEnableSearchTypeAhead= new KeyValueStore__c(Name='EnableSearchTypeAhead',BooleanValue__c=true,
                Description__c='Custom setting to enable Type ahead search',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keySearchTypeAheadLimit= new KeyValueStore__c(Name='SearchTypeAheadLimit',IntegerValue__c=10,Description__c='Limit to SOSL query',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c StateLogoDocumentName= new KeyValueStore__c(Name='StateLogoDocumentName',TextValue__c='Test Doc',Description__c='Logo Name',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SearchPageSize= new KeyValueStore__c(Name='SearchPageSize',IntegerValue__c=10,Description__c='Search Page record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c MaxViewHistorySize = new KeyValueStore__c(Name='MaxViewHistorySize',IntegerValue__c=10,Description__c='Max view history record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c FlexTableStandardObjects = new KeyValueStore__c(Name='FlexTableStandardObjects',TextValue__c='ProcessInstanceWorkItem;Task',
                Description__c='List of std objects that are not supported by std list contorller',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalUserPublicGroup = new KeyValueStore__c(Name='ExternalUserPublicGroup',TextValue__c='AllExternalUsers',
                Description__c='This setting contains name of the Public Group which has all the Portal users as its members.',Admin_Question__c = 'Loren Ipsum');
         KeyValueStore__c ExternalLogin= new KeyValueStore__c(Name='ExternalLoginPage',TextValue__c='ExternalUser',
                Description__c='login page for external user',Admin_Question__c = 'Loren Ipsum');
                
        KeyValueStore__c awardApprovalEmail= new KeyValueStore__c(Name='AwardApprovalEmailTemplate',TextValue__c='AwardApproved',
                Description__c='This is AwardApprovalEmailTemplate',Admin_Question__c = 'Loren Ipsum');
        
         KeyValueStore__c taskReassignmentEmailFields= new KeyValueStore__c(Name='TaskReassignmentEmailFields',TextValue__c='subject',
                Description__c='This is AwardApprovalEmailTemplate',Admin_Question__c = 'Loren Ipsum');  
                
        KeyValueStore__c awardRejectionEmail= new KeyValueStore__c(Name='AwardRejectionEmailTemplate',TextValue__c='AwardRejected',
                Description__c='This is AwardRejectionEmailTemplate',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c InviteReviewerEmailTemplate= new KeyValueStore__c(Name='ReviewerInviteEmailTemplate',TextValue__c='ReviewerInvite',
                Description__c='This is Reviewer Invite EmailTemplate',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c IsExternalUserRegApprovalRequired= new KeyValueStore__c(Name='IsExternalUserRegApprovalRequired',BooleanValue__c=true,
                Description__c='IsExternalUserRegApprovalRequired',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c autoCreateUserRegistrations= new KeyValueStore__c(Name='autoCreateUserRegistrations',BooleanValue__c=true,
                Description__c='autoCreateUserRegistrations?',Admin_Question__c = 'Loren Ipsum');
        
        User loginUser = [Select Username from User where Id=:UserInfo.getUserId()];
        
        KeyValueStore__c keyTaskDueDateOffset= new KeyValueStore__c(Name='TaskDueDateOffset',IntegerValue__c=10,Description__c='TaskDueDateOffset',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c keyQueueAdminUsername= new KeyValueStore__c(Name='QueueAdminUsername',TextValue__c=getStandardUser(false).Email,Description__c='Owner of the Task that is created from the Approval Process',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityUserLicense= new KeyValueStore__c(Name='CommunityUserLicense',TextValue__c='Partner Community Login',Description__c='License assigned to community user',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityAdminProfileName= new KeyValueStore__c(Name='CommunityAdminProfileName',TextValue__c='Project Admin',Description__c='Deafult Profile assigned to Community Admins',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityPDProfileName= new KeyValueStore__c(Name='CommunityProjectDirProfileName',TextValue__c='Project Director/Manager',Description__c='Community users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityStaffProfileName= new KeyValueStore__c(Name='CommunityStaffProfileName',TextValue__c='Project Staff',Description__c='Community',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksExpandedItemsCount = new KeyValueStore__c(Name='UsefulLinksExpandedItemsCount',IntegerValue__c=6,Description__c='number of characters displayed for each useful link item on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksVisibleItemsCount = new KeyValueStore__c(Name='UsefulLinksVisibleItemsCount',IntegerValue__c=3,Description__c='number of Items to display when VIEW ALL items are clicked in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksCharacterCount = new KeyValueStore__c(Name='UsefulLinksCharacterCount',IntegerValue__c=150,Description__c='number of Items to display by default in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ApplicationRejectionEmailTemplate  = new KeyValueStore__c(Name='ApplicationRejectionEmailTemplate',TextValue__c = 'RejectionTemplateTest',Description__c='Application rejection template',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c AutoCreateApplication  = new KeyValueStore__c(Name='AutoCreateApplication',BooleanValue__c = true,Description__c='Auto create application',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SetOWDEmail= new KeyValueStore__c(Name='SetOWDEmail',BooleanValue__c = true,Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c OWDName= new KeyValueStore__c(Name='OWDName',TextValue__c = 'GovGrants',Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalLoginValidationType= new KeyValueStore__c(Name='ExternalLoginValidationType',TextValue__c = 'EIN',Description__c='EIN',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c adminProfileNames= new KeyValueStore__c(Name='AdminProfileNames',TextValue__c = 'System Administrator, Project Admin', Description__c='List of admin profiel names',Admin_Question__c = 'Loren Ipsum');
       // KeyValueStore__c showDynaLayoutSetupLink= new KeyValueStore__c(Name='ShowDynaLayoutSetupLink',BooleanValue__c = true, Description__c='show dynamic layout?');
        KeyValueStore__c communityURLDomain= new KeyValueStore__c(Name='CommunityURLDomain',TextValue__c = 'https://login.com', Description__c='community url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c siteURLDomain= new KeyValueStore__c(Name='SiteURLDomain',TextValue__c = 'https://logoff.com', Description__c='site url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c checkAvailabilityProfile= new KeyValueStore__c(Name='ProfileForCheckAvailability',TextValue__c = 'Project Staff', Description__c='random profile',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaApplicantHeader= new KeyValueStore__c(Name='NDAApplicantHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaReviewerHeader= new KeyValueStore__c(Name='NDAReviewerHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c hideUserAvatar= new KeyValueStore__c(Name='HideUserAvatar',BooleanValue__c = true, Description__c='hide avatar',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c reviewTasksFailureReciever= new KeyValueStore__c(Name='ReviewTasksFailureReciever',TextValue__c=loginUser.Username,Description__c='The user name specified here receives any error email, when the review tasks creation process fails.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationRecommendationMatchParam = new KeyValueStore__c(Name='ApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between Application -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c preApplicationRecommendationMatchParam = new KeyValueStore__c(Name='PreApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between PreApplication -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationScoringFactor = new KeyValueStore__c(Name='ApplicationScoringFactor',TextValue__c='NumberOfStepsAddedTo__c',Description__c='What is the API name of the field from application object that provides the weightage factor (which is a number)',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c COIInfo = new KeyValueStore__c(Name='Conflict Of Interest Information',TextValue__c='COIReviewer',Description__c='COIReviewer',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c techSupportEmail = new KeyValueStore__c(Name='TechSupportEmail',TextValue__c='abcd@xyzq.com',Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c MarkUserAsPrimary = new KeyValueStore__c(Name='Is First User the primary user',TextValue__c='test',BooleanValue__c = true,IntegerValue__c=1,Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c autoCreateUserRegistrationRecords= new KeyValueStore__c(Name='AutoCreateUserRegistrationRecords',TextValue__c=TestHelper.getStandardUser(false).Username,BooleanValue__c=true,Description__c='AutoCreateUserRegistrationRecords',Admin_Question__c ='Loren Ipsum');                          
        KeyValueStore__c chartFilter= new KeyValueStore__c(Name='DashBoardYearFilterClause',TextValue__c = 'CALENDAR_YEAR(CreatedDate) in', Description__c='DashBoardYearFilterClause',Admin_Question__c = 'DashBoardYearFilterClause');
        
        KeyValueStore__c PDFTopLeftImageDocName = new KeyValueStore__c(Name='PDFTopLeftImageDocName',TextValue__c='PDFTopLeftImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c PDFTopMiddleImageDocName = new KeyValueStore__c(Name='PDFTopMiddleImageDocName',TextValue__c='PDFTopMiddleImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c PDFTopRightImageDocName = new KeyValueStore__c(Name='PDFTopRightImageDocName',TextValue__c='PDFTopRightImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c PDFBottomLeftImageDocName = new KeyValueStore__c(Name='PDFBottomLeftImageDocName',TextValue__c='PDFBottomLeftImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c PDFBottomRightImageDocName = new KeyValueStore__c(Name='PDFBottomRightImageDocName',TextValue__c='PDFBottomRightImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        
        KeyValueStore__c PDFFooterImageDocName = new KeyValueStore__c(Name='PDFFooterImageDocName',TextValue__c='PDFFooterImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c PDFHeaderImageDocName = new KeyValueStore__c(Name='PDFHeaderImageDocName',TextValue__c='PDFHeaderImageDocName',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
       
        KeyValueStore__c DisableRecordLocking = new KeyValueStore__c(Name='DisableRecordLocking', BooleanValue__c=true, Description__c='To disable record locking');
        KeyValueStore__c EnableOldHeader = new KeyValueStore__c(Name='EnableOldHeader', BooleanValue__c=true, Description__c='EnableOldHeader');
        KeyValueStore__c GoogleMapAPIKey = new KeyValueStore__c(Name='GoogleMapAPIKey', TextValue__c='GoogleMapAPIKey', Description__c='GoogleMapAPIKey');
        KeyValueStore__c MapProvider = new KeyValueStore__c(Name='MapProvider', TextValue__c='MapProvider', Description__c='MapProvider');

        // Added to get DigitalVerify API key and Signature Key.......
        KeyValueStore__c DocverifyAPIKey = new KeyValueStore__c(Name='DocverifyAPIKey',TextValue__c='UOcqPZwcOK86fC7cDGhVVvg29hWUT4gY',Description__c='DocverifyAPIKey');
        KeyValueStore__c DocverifyAPISignature = new KeyValueStore__c(Name='DocverifyAPISignature',TextValue__c='7A791F5F74F2664E51098433891C4E01',Description__c='DocverifyAPISignature');

        // Added with Capta Secret Key
        KeyValueStore__c CaptchaSecretKey = new KeyValueStore__c(Name='CaptchaSecretKey',TextValue__c='6LemsLIUAAAAAO4pG9Xw7MuNRSdIxgFNN1u7NEqq',Description__c='CaptchaSecretKey');
        listCustomSetting.add(CaptchaSecretKey);
        listCustomSetting.add(DocverifyAPIKey);
        listCustomSetting.add(DocverifyAPISignature);
        listCustomSetting.add(DisableRecordLocking);
        listCustomSetting.add(PDFTopLeftImageDocName);
        listCustomSetting.add(PDFTopMiddleImageDocName);
        listCustomSetting.add(PDFTopRightImageDocName);
        listCustomSetting.add(PDFBottomLeftImageDocName);
        listCustomSetting.add(PDFBottomRightImageDocName);
        
		 listCustomSetting.add(EnableOldHeader);

        listCustomSetting.add(GoogleMapAPIKey);
        listCustomSetting.add(MapProvider);
        listCustomSetting.add(chartFilter);
        listCustomSetting.add(ndaApplicantHeader);
        listCustomSetting.add(ndaReviewerHeader);
        listCustomSetting.add(awardApprovalEmail);
        listCustomSetting.add(awardRejectionEmail);
        listCustomSetting.add(keySearchTypeAheadLimit);
        listCustomSetting.add(MaxViewHistorySize );
        listCustomSetting.add(SearchPageSize);
        listCustomSetting.add(StateLogoDocumentName);
        listCustomSetting.add(keyValueEmail);
        listCustomSetting.add(keyValueEmailSubject);
        listCustomSetting.add(keyValueSavetoSalesforce); 
        listCustomSetting.add(keyValueexDispalyGenericErrorUI);
        listCustomSetting.add(keyRecentlyViewedRecordsLimit);
        listCustomSetting.add(keyHomeTabFlag); 
        listCustomSetting.add(keyHidepublicSearch);
        listCustomSetting.add(keyEnableSearchTypeAhead);
        listCustomSetting.add(FlexTableStandardObjects);
        listCustomSetting.add(keyTaskDueDateOffset);
        listCustomSetting.add(keyQueueAdminUsername);
        listCustomSetting.add(keyCommunityUserLicense);
        listCustomSetting.add(keyCommunityAdminProfileName);
        listCustomSetting.add(keyCommunityPDProfileName);
        listCustomSetting.add(keyCommunityStaffProfileName);
        listCustomSetting.add(FeedbackSupportEmail);
        listCustomSetting.add(ExternalUserPublicGroup);
        listCustomSetting.add(InviteReviewerEmailTemplate);
        listCustomSetting.add(ExternalLogin);
        listCustomSetting.add(ApplicationRejectionEmailTemplate);
        listCustomSetting.add(AutoCreateApplication);
        listCustomSetting.add(SetOWDEmail);
        listCustomSetting.add(OWDName);
        listCustomSetting.add(IsExternalUserRegApprovalRequired);
        listCustomSetting.add(ExternalLoginValidationType);
        listCustomSetting.add(adminProfileNames);
        listCustomSetting.add(autoCreateUserRegistrations);
        listCustomSetting.add(communityURLDomain);
        listCustomSetting.add(siteURLDomain);
        listCustomSetting.add(checkAvailabilityProfile);
        listCustomSetting.add(hideUserAvatar);
        listCustomSetting.add(reviewTasksFailureReciever);
        listCustomSetting.add(applicationRecommendationMatchParam);
        listCustomSetting.add(preApplicationRecommendationMatchParam);
        listCustomSetting.add(applicationScoringFactor);
        listCustomSetting.add(COIInfo);
        listCustomSetting.add(techSupportEmail);
        listCustomSetting.add(taskReassignmentEmailFields);
        listCustomSetting.add(MarkUserAsPrimary);
        listCustomSetting.add(autoCreateUserRegistrationRecords);
        listCustomSetting.add(PDFFooterImageDocName);
        listCustomSetting.add(PDFHeaderImageDocName);

        KeyValueStore__c PDFHeaderBgColor = new KeyValueStore__c(Name='PDFHeaderBgColor',TextValue__c='#FFF', Description__c='PDFHeaderBgColor', BooleanValue__c = true);
        listCustomSetting.add(PDFHeaderBgColor);
        KeyValueStore__c PDFFooterBgColor = new KeyValueStore__c(Name='PDFFooterBgColor',TextValue__c='#FFF', Description__c='PDFFooterBgColor', BooleanValue__c = true);
        listCustomSetting.add(PDFFooterBgColor);
        KeyValueStore__c NDA_PDFHeaderHeight = new KeyValueStore__c(Name='NDA_PDFHeaderHeight',IntegerValue__c = 10, Description__c='PDFFooterBgColor', BooleanValue__c = true);
        listCustomSetting.add(NDA_PDFHeaderHeight);
        KeyValueStore__c NDA_PDFFooterHeight = new KeyValueStore__c(Name='NDA_PDFFooterHeight',IntegerValue__c = 10, Description__c='PDFFooterBgColor', BooleanValue__c = true);
        listCustomSetting.add(NDA_PDFFooterHeight);

        KeyValueStore__c ShowFeedbackComponent = new KeyValueStore__c(Name='ShowFeedbackComponent', BooleanValue__c = true, Description__c='PDFFooterBgColor');
        listCustomSetting.add(ShowFeedbackComponent);
          
        UserPreferenceHelper.setBooleanValue('HideSidebar__c', true);
        UserPreferenceHelper.setBooleanValue('HideHeader__c', true);
        UserPreferenceHelper.setBooleanValue('SidebarSearchCollapsed__c', true);
        UserPreferenceHelper.setStringValue('ActiveAppName__c', 'StateAsGrantor');
        UserPreferenceHelper.setStringValue('ProfileName__c','System Administrator');
        //UserPreferenceHelper.setBooleanValue('IsInternal__c',true);
         List<PageMessageStyleConfig__c> listPageMsgCustomSetting = new List<PageMessageStyleConfig__c>();
        PageMessageStyleConfig__c pageMessage = new PageMessageStyleConfig__c(Name='Success',BackgroundGradient1Color__c='Red',BackgroundGradient2Color__c='yellow',TextColor__c='green');
        listPageMsgCustomSetting.add(pageMessage); 
        
        if (create) {   
            insert listCustomSetting;
            insert listPageMsgCustomSetting;
            return true; 
        }
        else {
            return false;
        }
    }
    
      public static boolean createCustomSettings_1(Boolean create) {
        List<KeyValueStore__c> listCustomSetting = new List<KeyValueStore__c>();
        
        KeyValueStore__c FeedbackSupportEmail = new KeyValueStore__c(Name='FeedbackSupportEmail',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        
        KeyValueStore__c keyValueEmail = new KeyValueStore__c(Name='exSendErrorEmailRealTime',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Flag to indicate that the exception email should be sent in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueEmailSubject = 
                new KeyValueStore__c(Name='exEmailSubject',TextValue__c='Please take the necessary steps', 
                Description__c='Subject of the Error Email which will be sent to the users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueSavetoSalesforce = new KeyValueStore__c(Name='exSavetoSalesforce',
                TextValue__c='Flag to indicate to save to SF',BooleanValue__c=true,Description__c='Flag to save to Salesforce',Admin_Question__c = 'Loren Ipsum'); 
        KeyValueStore__c keyValueexDispalyGenericErrorUI =  new KeyValueStore__c(Name='exDispalyGenericErrorUI',
                TextValue__c='Following Exception occured in the System',BooleanValue__c=true,Description__c='Flag to Display the Generic Message',Admin_Question__c = 'Loren Ipsum');  
        KeyValueStore__c keyRecentlyViewedRecordsLimit =  new KeyValueStore__c(Name='RecentlyViewedRecordsLimit',IntegerValue__c=10, 
                Description__c='Count of the recently v',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHomeTabFlag =  new KeyValueStore__c(Name='homeTabFlag',BooleanValue__c=true,
                Description__c='Custom setting to hide the home tab',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHidepublicSearch =  new KeyValueStore__c(Name='HidepublicSearch',BooleanValue__c=true,
                Description__c='Custom setting to hide the public Search',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyEnableSearchTypeAhead= new KeyValueStore__c(Name='EnableSearchTypeAhead',BooleanValue__c=true,
                Description__c='Custom setting to enable Type ahead search',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keySearchTypeAheadLimit= new KeyValueStore__c(Name='SearchTypeAheadLimit',IntegerValue__c=10,Description__c='Limit to SOSL query',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c StateLogoDocumentName= new KeyValueStore__c(Name='StateLogoDocumentName',TextValue__c='Test Doc',Description__c='Logo Name',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SearchPageSize= new KeyValueStore__c(Name='SearchPageSize',IntegerValue__c=10,Description__c='Search Page record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c MaxViewHistorySize = new KeyValueStore__c(Name='MaxViewHistorySize',IntegerValue__c=10,Description__c='Max view history record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c FlexTableStandardObjects = new KeyValueStore__c(Name='FlexTableStandardObjects',TextValue__c='ProcessInstanceWorkItem;Task',
                Description__c='List of std objects that are not supported by std list contorller',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalUserPublicGroup = new KeyValueStore__c(Name='ExternalUserPublicGroup',TextValue__c='AllExternalUsers',
                Description__c='This setting contains name of the Public Group which has all the Portal users as its members.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalLogin= new KeyValueStore__c(Name='ExternalLoginPage',TextValue__c='ExternalUser',
                Description__c='login page for external user',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c InternalLogin= new KeyValueStore__c(Name='InternalLoginPage',TextValue__c='InternalUser',
                Description__c='login page for internal user',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c awardApprovalEmail= new KeyValueStore__c(Name='AwardApprovalEmailTemplate',TextValue__c='AwardApproved',
                Description__c='This is AwardApprovalEmailTemplate',Admin_Question__c = 'Loren Ipsum');
                
        KeyValueStore__c awardRejectionEmail= new KeyValueStore__c(Name='AwardRejectionEmailTemplate',TextValue__c='AwardRejected',
                Description__c='This is AwardRejectionEmailTemplate',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c InviteReviewerEmailTemplate= new KeyValueStore__c(Name='ReviewerInviteEmailTemplate',TextValue__c='ReviewerInvite',
                Description__c='This is Reviewer Invite EmailTemplate',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c IsExternalUserRegApprovalRequired= new KeyValueStore__c(Name='IsExternalUserRegApprovalRequired',BooleanValue__c=true,
                Description__c='IsExternalUserRegApprovalRequired',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c autoCreateUserRegistrations= new KeyValueStore__c(Name='autoCreateUserRegistrations',BooleanValue__c=true,
                Description__c='autoCreateUserRegistrations?',Admin_Question__c = 'Loren Ipsum');
        
        User loginUser = [Select Username from User where Id=:UserInfo.getUserId()];
        
        KeyValueStore__c keyTaskDueDateOffset= new KeyValueStore__c(Name='TaskDueDateOffset',IntegerValue__c=10,Description__c='TaskDueDateOffset',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c keyQueueAdminUsername= new KeyValueStore__c(Name='QueueAdminUsername',TextValue__c=getStandardUser(false).Email,Description__c='Owner of the Task that is created from the Approval Process',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityUserLicense= new KeyValueStore__c(Name='CommunityUserLicense',TextValue__c='Partner Community Login',Description__c='License assigned to community user',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityAdminProfileName= new KeyValueStore__c(Name='CommunityAdminProfileName',TextValue__c='Project Admin',Description__c='Deafult Profile assigned to Community Admins',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityPDProfileName= new KeyValueStore__c(Name='CommunityProjectDirProfileName',TextValue__c='Project Director/Manager',Description__c='Community users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityStaffProfileName= new KeyValueStore__c(Name='CommunityStaffProfileName',TextValue__c='Project Staff',Description__c='Community',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksExpandedItemsCount = new KeyValueStore__c(Name='UsefulLinksExpandedItemsCount',IntegerValue__c=6,Description__c='number of characters displayed for each useful link item on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksVisibleItemsCount = new KeyValueStore__c(Name='UsefulLinksVisibleItemsCount',IntegerValue__c=3,Description__c='number of Items to display when VIEW ALL items are clicked in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksCharacterCount = new KeyValueStore__c(Name='UsefulLinksCharacterCount',IntegerValue__c=150,Description__c='number of Items to display by default in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ApplicationRejectionEmailTemplate  = new KeyValueStore__c(Name='ApplicationRejectionEmailTemplate',TextValue__c = 'RejectionTemplateTest',Description__c='Application rejection template',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c AutoCreateApplication  = new KeyValueStore__c(Name='AutoCreateApplication',BooleanValue__c = true,Description__c='Auto create application',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SetOWDEmail= new KeyValueStore__c(Name='SetOWDEmail',BooleanValue__c = true,Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c OWDName= new KeyValueStore__c(Name='OWDName',TextValue__c = 'GovGrants',Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalLoginValidationType= new KeyValueStore__c(Name='ExternalLoginValidationType',TextValue__c = 'EIN',Description__c='EIN',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c adminProfileNames= new KeyValueStore__c(Name='AdminProfileNames',TextValue__c = 'System Administrator, Project Admin', Description__c='List of admin profiel names',Admin_Question__c = 'Loren Ipsum');
       // KeyValueStore__c showDynaLayoutSetupLink= new KeyValueStore__c(Name='ShowDynaLayoutSetupLink',BooleanValue__c = true, Description__c='show dynamic layout?');
        KeyValueStore__c communityURLDomain= new KeyValueStore__c(Name='CommunityURLDomain',TextValue__c = 'https://login.com', Description__c='community url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c siteURLDomain= new KeyValueStore__c(Name='SiteURLDomain',TextValue__c = 'https://logoff.com', Description__c='site url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c checkAvailabilityProfile= new KeyValueStore__c(Name='ProfileForCheckAvailability',TextValue__c = 'Project Staff', Description__c='random profile',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaApplicantHeader= new KeyValueStore__c(Name='NDAApplicantHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaReviewerHeader= new KeyValueStore__c(Name='NDAReviewerHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c hideUserAvatar= new KeyValueStore__c(Name='HideUserAvatar',BooleanValue__c = true, Description__c='hide avatar',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c reviewTasksFailureReciever= new KeyValueStore__c(Name='ReviewTasksFailureReciever',TextValue__c=loginUser.Username,Description__c='The user name specified here receives any error email, when the review tasks creation process fails.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationRecommendationMatchParam = new KeyValueStore__c(Name='ApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between Application -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c preApplicationRecommendationMatchParam = new KeyValueStore__c(Name='PreApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between PreApplication -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationScoringFactor = new KeyValueStore__c(Name='ApplicationScoringFactor',TextValue__c='NumberOfStepsAddedTo__c',Description__c='What is the API name of the field from application object that provides the weightage factor (which is a number)',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c COIInfo = new KeyValueStore__c(Name='Conflict Of Interest Information',TextValue__c='COIReviewer',Description__c='COIReviewer',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c techSupportEmail = new KeyValueStore__c(Name='TechSupportEmail',TextValue__c='abcd@xyzq.com',Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c MarkUserAsPrimary = new KeyValueStore__c(Name='Is First User the primary user',TextValue__c='test',BooleanValue__c = true,IntegerValue__c=1,Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c autoCreateUserRegistrationRecords= new KeyValueStore__c(Name='AutoCreateUserRegistrationRecords',TextValue__c=TestHelper.getStandardUser(false).Username,BooleanValue__c=true,Description__c='AutoCreateUserRegistrationRecords',Admin_Question__c ='Loren Ipsum');                          
        KeyValueStore__c chartFilter= new KeyValueStore__c(Name='DashBoardYearFilterClause',TextValue__c = 'CALENDAR_YEAR(CreatedDate) in', Description__c='DashBoardYearFilterClause',Admin_Question__c = 'DashBoardYearFilterClause');
        listCustomSetting.add(chartFilter);

        KeyValueStore__c ClientFooterLogoDocName = new KeyValueStore__c(Name='ClientFooterLogoDocName',TextValue__c = 'DOHFooterImage2', Description__c='DOHFooterImage2');        
        listCustomSetting.add(ClientFooterLogoDocName);
        listCustomSetting.add(ndaApplicantHeader);
        listCustomSetting.add(ndaReviewerHeader);
        listCustomSetting.add(awardApprovalEmail);
        listCustomSetting.add(awardRejectionEmail);
        listCustomSetting.add(keySearchTypeAheadLimit);
        listCustomSetting.add(MaxViewHistorySize );
        listCustomSetting.add(SearchPageSize);
        listCustomSetting.add(StateLogoDocumentName);
        listCustomSetting.add(keyValueEmail);
        listCustomSetting.add(keyValueEmailSubject);
        listCustomSetting.add(keyValueSavetoSalesforce); 
        listCustomSetting.add(keyValueexDispalyGenericErrorUI);
        listCustomSetting.add(keyRecentlyViewedRecordsLimit);
        listCustomSetting.add(keyHomeTabFlag); 
        listCustomSetting.add(keyHidepublicSearch);
        listCustomSetting.add(keyEnableSearchTypeAhead);
        listCustomSetting.add(FlexTableStandardObjects);
        listCustomSetting.add(keyTaskDueDateOffset);
        listCustomSetting.add(keyQueueAdminUsername);
        listCustomSetting.add(keyCommunityUserLicense);
        listCustomSetting.add(keyCommunityAdminProfileName);
        listCustomSetting.add(keyCommunityPDProfileName);
        listCustomSetting.add(keyCommunityStaffProfileName);
        listCustomSetting.add(FeedbackSupportEmail);
        listCustomSetting.add(ExternalUserPublicGroup);
        listCustomSetting.add(InviteReviewerEmailTemplate);
        listCustomSetting.add(ExternalLogin);
        listCustomSetting.add(InternalLogin);
        listCustomSetting.add(ApplicationRejectionEmailTemplate);
        listCustomSetting.add(AutoCreateApplication);
        listCustomSetting.add(SetOWDEmail);
        listCustomSetting.add(OWDName);
        listCustomSetting.add(IsExternalUserRegApprovalRequired);
        listCustomSetting.add(ExternalLoginValidationType);
        listCustomSetting.add(adminProfileNames);
        listCustomSetting.add(autoCreateUserRegistrations);
        listCustomSetting.add(communityURLDomain);
        listCustomSetting.add(siteURLDomain);
        listCustomSetting.add(checkAvailabilityProfile);
        listCustomSetting.add(hideUserAvatar);
        listCustomSetting.add(reviewTasksFailureReciever);
        listCustomSetting.add(applicationRecommendationMatchParam);
        listCustomSetting.add(preApplicationRecommendationMatchParam);
        listCustomSetting.add(applicationScoringFactor);
        listCustomSetting.add(COIInfo);
        listCustomSetting.add(techSupportEmail);
        listCustomSetting.add(MarkUserAsPrimary);
        listCustomSetting.add(autoCreateUserRegistrationRecords);

        UserPreferenceHelper.setBooleanValue('HideSidebar__c', true);
        UserPreferenceHelper.setBooleanValue('HideHeader__c', true);
        UserPreferenceHelper.setBooleanValue('SidebarSearchCollapsed__c', true);
        UserPreferenceHelper.setStringValue('ActiveAppName__c', 'StateasGrantee');
        UserPreferenceHelper.setStringValue('ProfileName__c','System Administrator');
         List<PageMessageStyleConfig__c> listPageMsgCustomSetting = new List<PageMessageStyleConfig__c>();
        PageMessageStyleConfig__c pageMessage = new PageMessageStyleConfig__c(Name='Success',BackgroundGradient1Color__c='Red',BackgroundGradient2Color__c='yellow',TextColor__c='green');
        listPageMsgCustomSetting.add(pageMessage); 
        
        if (create) {   
            insert listCustomSetting;
            insert listPageMsgCustomSetting;
            return true; 
        }
        else {
            return false;
        }
    }
    
    
    public static boolean createCustomSettings_2(Boolean create) {
        List<KeyValueStore__c> listCustomSetting = new List<KeyValueStore__c>();
        
        KeyValueStore__c FeedbackSupportEmail = new KeyValueStore__c(Name='FeedbackSupportEmail',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c CommunicationReplyEmailService = new KeyValueStore__c(Name='CommunicationReplyEmailService',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        
        KeyValueStore__c keyValueEmail = new KeyValueStore__c(Name='exSendErrorEmailRealTime',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Flag to indicate that the exception email should be sent in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueEmailSubject = 
                new KeyValueStore__c(Name='exEmailSubject',TextValue__c='Please take the necessary steps', 
                Description__c='Subject of the Error Email which will be sent to the users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueSavetoSalesforce = new KeyValueStore__c(Name='exSavetoSalesforce',
                TextValue__c='Flag to indicate to save to SF',BooleanValue__c=true,Description__c='Flag to save to Salesforce',Admin_Question__c = 'Loren Ipsum'); 
        KeyValueStore__c keyValueexDispalyGenericErrorUI =  new KeyValueStore__c(Name='exDispalyGenericErrorUI',
                TextValue__c='Following Exception occured in the System',BooleanValue__c=true,Description__c='Flag to Display the Generic Message',Admin_Question__c = 'Loren Ipsum');  
        KeyValueStore__c keyRecentlyViewedRecordsLimit =  new KeyValueStore__c(Name='RecentlyViewedRecordsLimit',IntegerValue__c=10, 
                Description__c='Count of the recently v',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHomeTabFlag =  new KeyValueStore__c(Name='homeTabFlag',BooleanValue__c=true,
                Description__c='Custom setting to hide the home tab',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHidepublicSearch =  new KeyValueStore__c(Name='HidepublicSearch',BooleanValue__c=true,
                Description__c='Custom setting to hide the public Search',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyEnableSearchTypeAhead= new KeyValueStore__c(Name='EnableSearchTypeAhead',BooleanValue__c=true,
                Description__c='Custom setting to enable Type ahead search',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keySearchTypeAheadLimit= new KeyValueStore__c(Name='SearchTypeAheadLimit',IntegerValue__c=10,Description__c='Limit to SOSL query',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c StateLogoDocumentName= new KeyValueStore__c(Name='StateLogoDocumentName',TextValue__c='Test Doc',Description__c='Logo Name',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SearchPageSize= new KeyValueStore__c(Name='SearchPageSize',IntegerValue__c=10,Description__c='Search Page record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c MaxViewHistorySize = new KeyValueStore__c(Name='MaxViewHistorySize',IntegerValue__c=10,Description__c='Max view history record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c FlexTableStandardObjects = new KeyValueStore__c(Name='FlexTableStandardObjects',TextValue__c='ProcessInstanceWorkItem;Task',
                Description__c='List of std objects that are not supported by std list contorller',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalUserPublicGroup = new KeyValueStore__c(Name='ExternalUserPublicGroup',TextValue__c='AllExternalUsers',
                Description__c='This setting contains name of the Public Group which has all the Portal users as its members.',Admin_Question__c = 'Loren Ipsum');
         KeyValueStore__c ExternalLogin= new KeyValueStore__c(Name='ExternalLoginPage',TextValue__c='ExternalUser',
                Description__c='login page for external user',Admin_Question__c = 'Loren Ipsum');
                
        KeyValueStore__c awardApprovalEmail= new KeyValueStore__c(Name='AwardApprovalEmailTemplate',TextValue__c='AwardApproved',
                Description__c='This is AwardApprovalEmailTemplate',Admin_Question__c = 'Loren Ipsum');
                
        KeyValueStore__c awardRejectionEmail= new KeyValueStore__c(Name='AwardRejectionEmailTemplate',TextValue__c='AwardRejected',
                Description__c='This is AwardRejectionEmailTemplate',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c InviteReviewerEmailTemplate= new KeyValueStore__c(Name='ReviewerInviteEmailTemplate',TextValue__c='ReviewerInvite',
                Description__c='This is Reviewer Invite EmailTemplate',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c IsExternalUserRegApprovalRequired= new KeyValueStore__c(Name='IsExternalUserRegApprovalRequired',BooleanValue__c=true,
                Description__c='IsExternalUserRegApprovalRequired',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c autoCreateUserRegistrations= new KeyValueStore__c(Name='autoCreateUserRegistrations',BooleanValue__c=true,
                Description__c='autoCreateUserRegistrations?',Admin_Question__c = 'Loren Ipsum');
        
        User loginUser = [Select Username from User where Id=:UserInfo.getUserId()];
        
        KeyValueStore__c keyTaskDueDateOffset= new KeyValueStore__c(Name='TaskDueDateOffset',IntegerValue__c=10,Description__c='TaskDueDateOffset',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c keyQueueAdminUsername= new KeyValueStore__c(Name='QueueAdminUsername',TextValue__c=getStandardUser(false).Email,Description__c='Owner of the Task that is created from the Approval Process',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityUserLicense= new KeyValueStore__c(Name='CommunityUserLicense',TextValue__c='Partner Community Login',Description__c='License assigned to community user',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityAdminProfileName= new KeyValueStore__c(Name='CommunityAdminProfileName',TextValue__c='Project Admin',Description__c='Deafult Profile assigned to Community Admins',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityPDProfileName= new KeyValueStore__c(Name='CommunityProjectDirProfileName',TextValue__c='Project Director/Manager',Description__c='Community users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityStaffProfileName= new KeyValueStore__c(Name='CommunityStaffProfileName',TextValue__c='Project Staff',Description__c='Community',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksExpandedItemsCount = new KeyValueStore__c(Name='UsefulLinksExpandedItemsCount',IntegerValue__c=6,Description__c='number of characters displayed for each useful link item on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksVisibleItemsCount = new KeyValueStore__c(Name='UsefulLinksVisibleItemsCount',IntegerValue__c=3,Description__c='number of Items to display when VIEW ALL items are clicked in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksCharacterCount = new KeyValueStore__c(Name='UsefulLinksCharacterCount',IntegerValue__c=150,Description__c='number of Items to display by default in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ApplicationRejectionEmailTemplate  = new KeyValueStore__c(Name='ApplicationRejectionEmailTemplate',TextValue__c = 'RejectionTemplateTest',Description__c='Application rejection template',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c AutoCreateApplication  = new KeyValueStore__c(Name='AutoCreateApplication',BooleanValue__c = true,Description__c='Auto create application',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SetOWDEmail= new KeyValueStore__c(Name='SetOWDEmail',BooleanValue__c = true,Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c OWDName= new KeyValueStore__c(Name='OWDName',TextValue__c = 'GovGrants',Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalLoginValidationType= new KeyValueStore__c(Name='ExternalLoginValidationType',TextValue__c = 'EIN',Description__c='EIN',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c adminProfileNames= new KeyValueStore__c(Name='AdminProfileNames',TextValue__c = 'System Administrator, Project Admin', Description__c='List of admin profiel names',Admin_Question__c = 'Loren Ipsum');
       // KeyValueStore__c showDynaLayoutSetupLink= new KeyValueStore__c(Name='ShowDynaLayoutSetupLink',BooleanValue__c = true, Description__c='show dynamic layout?');
        KeyValueStore__c communityURLDomain= new KeyValueStore__c(Name='CommunityURLDomain',TextValue__c = 'https://login.com', Description__c='community url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c siteURLDomain= new KeyValueStore__c(Name='SiteURLDomain',TextValue__c = 'https://logoff.com', Description__c='site url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c checkAvailabilityProfile= new KeyValueStore__c(Name='ProfileForCheckAvailability',TextValue__c = 'Project Staff', Description__c='random profile',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaApplicantHeader= new KeyValueStore__c(Name='NDAApplicantHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaReviewerHeader= new KeyValueStore__c(Name='NDAReviewerHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c hideUserAvatar= new KeyValueStore__c(Name='HideUserAvatar',BooleanValue__c = true, Description__c='hide avatar',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c reviewTasksFailureReciever= new KeyValueStore__c(Name='ReviewTasksFailureReciever',TextValue__c=loginUser.Username,Description__c='The user name specified here receives any error email, when the review tasks creation process fails.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationRecommendationMatchParam = new KeyValueStore__c(Name='ApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between Application -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c preApplicationRecommendationMatchParam = new KeyValueStore__c(Name='PreApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between PreApplication -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationScoringFactor = new KeyValueStore__c(Name='ApplicationScoringFactor',TextValue__c='NumberOfStepsAddedTo__c',Description__c='What is the API name of the field from application object that provides the weightage factor (which is a number)',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c COIInfo = new KeyValueStore__c(Name='Conflict Of Interest Information',TextValue__c='COIReviewer',Description__c='COIReviewer',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c techSupportEmail = new KeyValueStore__c(Name='TechSupportEmail',TextValue__c='abcd@xyzq.com',Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c MarkUserAsPrimary = new KeyValueStore__c(Name='Is First User the primary user',TextValue__c='test',BooleanValue__c = true,IntegerValue__c=1,Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c autoCreateUserRegistrationRecords= new KeyValueStore__c(Name='AutoCreateUserRegistrationRecords',TextValue__c=TestHelper.getStandardUser(false).Username,BooleanValue__c=true,Description__c='AutoCreateUserRegistrationRecords',Admin_Question__c ='Loren Ipsum');                          
        KeyValueStore__c chartFilter= new KeyValueStore__c(Name='DashBoardYearFilterClause',TextValue__c = 'CALENDAR_YEAR(CreatedDate) in', Description__c='DashBoardYearFilterClause',Admin_Question__c = 'DashBoardYearFilterClause');
        
        listCustomSetting.add(chartFilter);
        listCustomSetting.add(ndaApplicantHeader);
        listCustomSetting.add(ndaReviewerHeader);
        listCustomSetting.add(awardApprovalEmail);
        listCustomSetting.add(awardRejectionEmail);
        listCustomSetting.add(keySearchTypeAheadLimit);
        listCustomSetting.add(MaxViewHistorySize );
        listCustomSetting.add(SearchPageSize);
        listCustomSetting.add(StateLogoDocumentName);
        listCustomSetting.add(keyValueEmail);
        listCustomSetting.add(keyValueEmailSubject);
        listCustomSetting.add(keyValueSavetoSalesforce); 
        listCustomSetting.add(keyValueexDispalyGenericErrorUI);
        listCustomSetting.add(keyRecentlyViewedRecordsLimit);
        listCustomSetting.add(keyHomeTabFlag); 
        listCustomSetting.add(keyHidepublicSearch);
        listCustomSetting.add(keyEnableSearchTypeAhead);
        listCustomSetting.add(FlexTableStandardObjects);
        listCustomSetting.add(keyTaskDueDateOffset);
        listCustomSetting.add(keyQueueAdminUsername);
        listCustomSetting.add(keyCommunityUserLicense);
        listCustomSetting.add(keyCommunityAdminProfileName);
        listCustomSetting.add(keyCommunityPDProfileName);
        listCustomSetting.add(keyCommunityStaffProfileName);
        listCustomSetting.add(FeedbackSupportEmail);
        listCustomSetting.add(CommunicationReplyEmailService);
        listCustomSetting.add(ExternalUserPublicGroup);
        listCustomSetting.add(InviteReviewerEmailTemplate);
        listCustomSetting.add(ExternalLogin);
        listCustomSetting.add(ApplicationRejectionEmailTemplate);
        listCustomSetting.add(AutoCreateApplication);
        listCustomSetting.add(SetOWDEmail);
        listCustomSetting.add(OWDName);
        listCustomSetting.add(IsExternalUserRegApprovalRequired);
        listCustomSetting.add(ExternalLoginValidationType);
        listCustomSetting.add(adminProfileNames);
        listCustomSetting.add(autoCreateUserRegistrations);
        listCustomSetting.add(communityURLDomain);
        listCustomSetting.add(siteURLDomain);
        listCustomSetting.add(checkAvailabilityProfile);
        listCustomSetting.add(hideUserAvatar);
        listCustomSetting.add(reviewTasksFailureReciever);
        listCustomSetting.add(applicationRecommendationMatchParam);
        listCustomSetting.add(preApplicationRecommendationMatchParam);
        listCustomSetting.add(applicationScoringFactor);
        listCustomSetting.add(COIInfo);
        listCustomSetting.add(techSupportEmail);
        listCustomSetting.add(MarkUserAsPrimary);
        listCustomSetting.add(autoCreateUserRegistrationRecords);

        UserPreferenceHelper.setBooleanValue('HideSidebar__c', true);
        UserPreferenceHelper.setBooleanValue('HideHeader__c', true);
        UserPreferenceHelper.setBooleanValue('SidebarSearchCollapsed__c', true);
        UserPreferenceHelper.setStringValue('ActiveAppName__c', 'Recipient');
        UserPreferenceHelper.setStringValue('ProfileName__c','System Administrator');
         List<PageMessageStyleConfig__c> listPageMsgCustomSetting = new List<PageMessageStyleConfig__c>();
        PageMessageStyleConfig__c pageMessage = new PageMessageStyleConfig__c(Name='Success',BackgroundGradient1Color__c='Red',BackgroundGradient2Color__c='yellow',TextColor__c='green');
        listPageMsgCustomSetting.add(pageMessage); 
        
        if (create) {   
            insert listCustomSetting;
            insert listPageMsgCustomSetting;
            return true; 
        }
        else {
            return false;
        }
    }
    
    public static boolean createCustomSettings_3(Boolean create) {
        List<KeyValueStore__c> listCustomSetting = new List<KeyValueStore__c>();
        
        KeyValueStore__c FeedbackSupportEmail = new KeyValueStore__c(Name='FeedbackSupportEmail',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c CommunicationReplyEmailService = new KeyValueStore__c(Name='CommunicationReplyEmailService',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Email address to send feedback of the customer in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        
        KeyValueStore__c keyValueEmail = new KeyValueStore__c(Name='exSendErrorEmailRealTime',TextValue__c='GovBDsupport@reisystems.com',
                        Description__c='Flag to indicate that the exception email should be sent in real time',BooleanValue__c=true,Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueEmailSubject = 
                new KeyValueStore__c(Name='exEmailSubject',TextValue__c='Please take the necessary steps', 
                Description__c='Subject of the Error Email which will be sent to the users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyValueSavetoSalesforce = new KeyValueStore__c(Name='exSavetoSalesforce',
                TextValue__c='Flag to indicate to save to SF',BooleanValue__c=true,Description__c='Flag to save to Salesforce',Admin_Question__c = 'Loren Ipsum'); 
        KeyValueStore__c keyValueexDispalyGenericErrorUI =  new KeyValueStore__c(Name='exDispalyGenericErrorUI',
                TextValue__c='Following Exception occured in the System',BooleanValue__c=true,Description__c='Flag to Display the Generic Message',Admin_Question__c = 'Loren Ipsum');  
        KeyValueStore__c keyRecentlyViewedRecordsLimit =  new KeyValueStore__c(Name='RecentlyViewedRecordsLimit',IntegerValue__c=10, 
                Description__c='Count of the recently v',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHomeTabFlag =  new KeyValueStore__c(Name='homeTabFlag',BooleanValue__c=true,
                Description__c='Custom setting to hide the home tab',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyHidepublicSearch =  new KeyValueStore__c(Name='HidepublicSearch',BooleanValue__c=true,
                Description__c='Custom setting to hide the public Search',Admin_Question__c = 'Loren Ipsum');   
        KeyValueStore__c keyEnableSearchTypeAhead= new KeyValueStore__c(Name='EnableSearchTypeAhead',BooleanValue__c=true,
                Description__c='Custom setting to enable Type ahead search',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keySearchTypeAheadLimit= new KeyValueStore__c(Name='SearchTypeAheadLimit',IntegerValue__c=10,Description__c='Limit to SOSL query',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c StateLogoDocumentName= new KeyValueStore__c(Name='StateLogoDocumentName',TextValue__c='Test Doc',Description__c='Logo Name',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SearchPageSize= new KeyValueStore__c(Name='SearchPageSize',IntegerValue__c=10,Description__c='Search Page record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c MaxViewHistorySize = new KeyValueStore__c(Name='MaxViewHistorySize',IntegerValue__c=10,Description__c='Max view history record limit',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c FlexTableStandardObjects = new KeyValueStore__c(Name='FlexTableStandardObjects',TextValue__c='ProcessInstanceWorkItem;Task',
                Description__c='List of std objects that are not supported by std list contorller',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalUserPublicGroup = new KeyValueStore__c(Name='ExternalUserPublicGroup',TextValue__c='AllExternalUsers',
                Description__c='This setting contains name of the Public Group which has all the Portal users as its members.',Admin_Question__c = 'Loren Ipsum');
         KeyValueStore__c ExternalLogin= new KeyValueStore__c(Name='ExternalLoginPage',TextValue__c='ExternalUser',
                Description__c='login page for external user',Admin_Question__c = 'Loren Ipsum');
                
        KeyValueStore__c awardApprovalEmail= new KeyValueStore__c(Name='AwardApprovalEmailTemplate',TextValue__c='AwardApproved',
                Description__c='This is AwardApprovalEmailTemplate',Admin_Question__c = 'Loren Ipsum');
                
        KeyValueStore__c awardRejectionEmail= new KeyValueStore__c(Name='AwardRejectionEmailTemplate',TextValue__c='AwardRejected',
                Description__c='This is AwardRejectionEmailTemplate',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c InviteReviewerEmailTemplate= new KeyValueStore__c(Name='ReviewerInviteEmailTemplate',TextValue__c='ReviewerInvite',
                Description__c='This is Reviewer Invite EmailTemplate',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c IsExternalUserRegApprovalRequired= new KeyValueStore__c(Name='IsExternalUserRegApprovalRequired',BooleanValue__c=true,
                Description__c='IsExternalUserRegApprovalRequired',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c autoCreateUserRegistrations= new KeyValueStore__c(Name='autoCreateUserRegistrations',BooleanValue__c=true,
                Description__c='autoCreateUserRegistrations?',Admin_Question__c = 'Loren Ipsum');
        
        User loginUser = [Select Username from User where Id=:UserInfo.getUserId()];
        
        KeyValueStore__c keyTaskDueDateOffset= new KeyValueStore__c(Name='TaskDueDateOffset',IntegerValue__c=10,Description__c='TaskDueDateOffset',Admin_Question__c = 'Loren Ipsum');        
        KeyValueStore__c keyQueueAdminUsername= new KeyValueStore__c(Name='QueueAdminUsername',TextValue__c=getStandardUser(false).Email,Description__c='Owner of the Task that is created from the Approval Process',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityUserLicense= new KeyValueStore__c(Name='CommunityUserLicense',TextValue__c='Partner Community Login',Description__c='License assigned to community user',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityAdminProfileName= new KeyValueStore__c(Name='CommunityAdminProfileName',TextValue__c='Project Admin',Description__c='Deafult Profile assigned to Community Admins',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityPDProfileName= new KeyValueStore__c(Name='CommunityProjectDirProfileName',TextValue__c='Project Director/Manager',Description__c='Community users',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c keyCommunityStaffProfileName= new KeyValueStore__c(Name='CommunityStaffProfileName',TextValue__c='Project Staff',Description__c='Community',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksExpandedItemsCount = new KeyValueStore__c(Name='UsefulLinksExpandedItemsCount',IntegerValue__c=6,Description__c='number of characters displayed for each useful link item on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksVisibleItemsCount = new KeyValueStore__c(Name='UsefulLinksVisibleItemsCount',IntegerValue__c=3,Description__c='number of Items to display when VIEW ALL items are clicked in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c UsefulLinksCharacterCount = new KeyValueStore__c(Name='UsefulLinksCharacterCount',IntegerValue__c=150,Description__c='number of Items to display by default in the "Useful Links" section on the Login Page',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ApplicationRejectionEmailTemplate  = new KeyValueStore__c(Name='ApplicationRejectionEmailTemplate',TextValue__c = 'RejectionTemplateTest',Description__c='Application rejection template',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c AutoCreateApplication  = new KeyValueStore__c(Name='AutoCreateApplication',BooleanValue__c = true,Description__c='Auto create application',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c SetOWDEmail= new KeyValueStore__c(Name='SetOWDEmail',BooleanValue__c = true,Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c OWDName= new KeyValueStore__c(Name='OWDName',TextValue__c = 'GovGrants',Description__c='check if OWEmail required',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ExternalLoginValidationType= new KeyValueStore__c(Name='ExternalLoginValidationType',TextValue__c = 'EIN',Description__c='EIN',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c adminProfileNames= new KeyValueStore__c(Name='AdminProfileNames',TextValue__c = 'System Administrator, Project Admin', Description__c='List of admin profiel names',Admin_Question__c = 'Loren Ipsum');
       // KeyValueStore__c showDynaLayoutSetupLink= new KeyValueStore__c(Name='ShowDynaLayoutSetupLink',BooleanValue__c = true, Description__c='show dynamic layout?');
        KeyValueStore__c communityURLDomain= new KeyValueStore__c(Name='CommunityURLDomain',TextValue__c = 'https://login.com', Description__c='community url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c siteURLDomain= new KeyValueStore__c(Name='SiteURLDomain',TextValue__c = 'https://logoff.com', Description__c='site url',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c checkAvailabilityProfile= new KeyValueStore__c(Name='ProfileForCheckAvailability',TextValue__c = 'Project Staff', Description__c='random profile',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaApplicantHeader= new KeyValueStore__c(Name='NDAApplicantHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c ndaReviewerHeader= new KeyValueStore__c(Name='NDAReviewerHeader',TextValue__c = 'NDA', Description__c='page header',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c hideUserAvatar= new KeyValueStore__c(Name='HideUserAvatar',BooleanValue__c = true, Description__c='hide avatar',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c reviewTasksFailureReciever= new KeyValueStore__c(Name='ReviewTasksFailureReciever',TextValue__c=loginUser.Username,Description__c='The user name specified here receives any error email, when the review tasks creation process fails.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationRecommendationMatchParam = new KeyValueStore__c(Name='ApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between Application -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c preApplicationRecommendationMatchParam = new KeyValueStore__c(Name='PreApplicationRecommendationMatchParam',TextValue__c='Title__c:Title',Description__c='The fields to be matched between PreApplication -> Contacts.',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c applicationScoringFactor = new KeyValueStore__c(Name='ApplicationScoringFactor',TextValue__c='NumberOfStepsAddedTo__c',Description__c='What is the API name of the field from application object that provides the weightage factor (which is a number)',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c COIInfo = new KeyValueStore__c(Name='Conflict Of Interest Information',TextValue__c='COIReviewer',Description__c='COIReviewer',Admin_Question__c = 'Loren Ipsum');
        KeyValueStore__c techSupportEmail = new KeyValueStore__c(Name='TechSupportEmail',TextValue__c='abcd@xyzq.com',Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c MarkUserAsPrimary = new KeyValueStore__c(Name='Is First User the primary user',TextValue__c='test',BooleanValue__c = true,IntegerValue__c=1,Description__c='TechSupportEmail',Admin_Question__c = 'TechSupportEmail');
        KeyValueStore__c autoCreateUserRegistrationRecords= new KeyValueStore__c(Name='AutoCreateUserRegistrationRecords',TextValue__c=TestHelper.getStandardUser(false).Username,BooleanValue__c=true,Description__c='AutoCreateUserRegistrationRecords',Admin_Question__c ='Loren Ipsum');                          
        KeyValueStore__c chartFilter= new KeyValueStore__c(Name='DashBoardYearFilterClause',TextValue__c = 'CALENDAR_YEAR(CreatedDate) in', Description__c='DashBoardYearFilterClause',Admin_Question__c = 'DashBoardYearFilterClause');
        
        listCustomSetting.add(chartFilter);
        listCustomSetting.add(ndaApplicantHeader);
        listCustomSetting.add(ndaReviewerHeader);
        listCustomSetting.add(awardApprovalEmail);
        listCustomSetting.add(awardRejectionEmail);
        listCustomSetting.add(keySearchTypeAheadLimit);
        listCustomSetting.add(MaxViewHistorySize );
        listCustomSetting.add(SearchPageSize);
        listCustomSetting.add(StateLogoDocumentName);
        listCustomSetting.add(keyValueEmail);
        listCustomSetting.add(keyValueEmailSubject);
        listCustomSetting.add(keyValueSavetoSalesforce); 
        listCustomSetting.add(keyValueexDispalyGenericErrorUI);
        listCustomSetting.add(keyRecentlyViewedRecordsLimit);
        listCustomSetting.add(keyHomeTabFlag); 
        listCustomSetting.add(keyHidepublicSearch);
        listCustomSetting.add(keyEnableSearchTypeAhead);
        listCustomSetting.add(FlexTableStandardObjects);
        listCustomSetting.add(keyTaskDueDateOffset);
        listCustomSetting.add(keyQueueAdminUsername);
        listCustomSetting.add(keyCommunityUserLicense);
        listCustomSetting.add(keyCommunityAdminProfileName);
        listCustomSetting.add(keyCommunityPDProfileName);
        listCustomSetting.add(keyCommunityStaffProfileName);
        listCustomSetting.add(FeedbackSupportEmail);
        listCustomSetting.add(CommunicationReplyEmailService);
        listCustomSetting.add(ExternalUserPublicGroup);
        listCustomSetting.add(InviteReviewerEmailTemplate);
        listCustomSetting.add(ExternalLogin);
        listCustomSetting.add(ApplicationRejectionEmailTemplate);
        listCustomSetting.add(AutoCreateApplication);
        listCustomSetting.add(SetOWDEmail);
        listCustomSetting.add(OWDName);
        listCustomSetting.add(IsExternalUserRegApprovalRequired);
        listCustomSetting.add(ExternalLoginValidationType);
        listCustomSetting.add(adminProfileNames);
        listCustomSetting.add(autoCreateUserRegistrations);
        listCustomSetting.add(communityURLDomain);
        listCustomSetting.add(siteURLDomain);
        listCustomSetting.add(checkAvailabilityProfile);
        listCustomSetting.add(hideUserAvatar);
        listCustomSetting.add(reviewTasksFailureReciever);
        listCustomSetting.add(applicationRecommendationMatchParam);
        listCustomSetting.add(preApplicationRecommendationMatchParam);
        listCustomSetting.add(applicationScoringFactor);
        listCustomSetting.add(COIInfo);
        listCustomSetting.add(techSupportEmail);
        listCustomSetting.add(MarkUserAsPrimary);
        listCustomSetting.add(autoCreateUserRegistrationRecords);

        UserPreferenceHelper.setBooleanValue('HideSidebar__c', true);
        UserPreferenceHelper.setBooleanValue('HideHeader__c', true);
        UserPreferenceHelper.setBooleanValue('SidebarSearchCollapsed__c', true);
        UserPreferenceHelper.setStringValue('ActiveAppName__c', 'Admin');
        UserPreferenceHelper.setStringValue('ProfileName__c','System Administrator');
         List<PageMessageStyleConfig__c> listPageMsgCustomSetting = new List<PageMessageStyleConfig__c>();
        PageMessageStyleConfig__c pageMessage = new PageMessageStyleConfig__c(Name='Success',BackgroundGradient1Color__c='Red',BackgroundGradient2Color__c='yellow',TextColor__c='green');
        listPageMsgCustomSetting.add(pageMessage); 
        
        if (create) {   
            insert listCustomSetting;
            insert listPageMsgCustomSetting;
            return true; 
        }
        else {
            return false;
        }
    }
    
    

    public static CustomAppConfig__c getCustomAppConfig(boolean create){
         List<CustomAppConfig__c> customApps = [select Name,Label__c,Active__c,Sequence__c,URL__c,ReportsFolderName__c,AvailableForProfiles__c from CustomAppConfig__c where Name = 'StateasGrantor'];
         if(customApps.size() > 0) {
             return customApps[0];
         }
         CustomAppConfig__c customAppConfig = new CustomAppConfig__c();
         customAppConfig.Label__c = 'State as Grantor';
         customAppConfig.Active__c = true;
         customAppConfig.Sequence__c = 1;
         customAppConfig.Label__c = 'Label1';
         customAppConfig.Name = 'StateAsGrantor';
         customAppConfig.URL__c = '/apex/PhaseView';
         customAppConfig.AvailableForProfiles__c = 'System Administrator';
         customAppConfig.ReportsFolderName__c = 'State_as_Grantor';

         if(create){
             upsert customAppConfig; 
         }
        return customAppConfig;
    }
    
    public static CustomApp__c getCustomApp(boolean create){
        List<CustomApp__c> custApps = [select Active__c, Label__c,Sequence__c, Name from CustomApp__c where Name = 'StateAsGrantor'];
        if(custApps.size() > 0) {
            return custApps[0];
        }
        custApp = new CustomApp__c();
        custApp.RecordTypeJSON__c = '{"PaymentRequest__c":"Master","GNT__Package__c":"Master","Program__r.Application__r.PreApplication__c":"Grantor","Program__r.SiteVisit__c":"Grantor","PreApplication__c":"Grantor","ProgressReports__c":"Grantor","Grant__c":"Grantor","Program__c":"InternalProgram,ExternalProgram","UserRegistration__c":"Applicant,Reviewer","Award__c":"Grantor","Account":"External,Internal,Recipient,Reviewers","Announcement__c":"Grantor","Review__c":"Master","Closeout__c":"Master","RiskAssessment__c":"Master","AmendmentRequest__c":"CarryForward,FormalAmendments,PeriodicAnnualRenewal","StrategicPlan__c":"Objectives,StrategicGoal,StrategicPlan","ServiceArea__c":"Master","FundingSource__c":"External,Internal","MasterKPI__c":"Master","ReviewStep__c":"Application","Contact":"NOAContact"}';
        custApp.Active__c = true;
        custApp.Label__c = 'Label1';
        custApp.Sequence__C = 2;
        custApp.Name = 'StateAsGrantor';
        custApp.AvailableForProfiles__c = 'System Administration';

         if(create){
            skipCustomAppTrigger = true;
             insert custApp; 
         }
        return custApp;
    }
    
    public static SobjectActionConfig__c getSObjectActionConfig(boolean create){
         String nameSpaceprefix  = AppUtils.getNamespacePrefix();
         SObjectConfig__c sObjCon =  getSObjectConfig(true);
         
         SobjectActionConfig__c sObjActionCon = new SobjectActionConfig__c();
         sObjActionCon.Name = nameSpaceprefix + 'SampleObject11__c';
         sObjActionCon.SObjectConfig__c = sObjCon.Id;
         
         if(create){
             insert sObjActionCon; 
         }
        return sObjActionCon;
    }
    
    public static SObjectConfig__c getSObjectConfig(boolean create){
         String nameSpaceprefix  = AppUtils.getNamespacePrefix();
         SObjectConfig__c sObjCon = new SObjectConfig__c();
         sObjCon.Name = nameSpaceprefix + 'SampleObject11__c';
         sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
         sObjCon.EnableTimeBaseApproval__c = true;
         if(create){
             insert sObjCon; 
         }
        return sObjCon;
    }

    public static SObjectConfig__c getSObjectConfigTask(boolean create){
            String nameSpaceprefix  = AppUtils.getNamespacePrefix();
            SObjectConfig__c sObjCon = new SObjectConfig__c();
            sObjCon.Name = 'Task';
            sObjCon.CriteriaField__c = 'Type';
            sObjCon.EnableTimeBaseApproval__c = true;
            if(create){
                insert sObjCon; 
            }
            return sObjCon;
    }


    public static SObjectConfig__c getSObject2Config(boolean create){
         String nameSpaceprefix  = AppUtils.getNamespacePrefix();
         SObjectConfig__c sObjCon = new SObjectConfig__c();
         sObjCon.Name = nameSpaceprefix + 'SampleObject2__c';
         sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
         if(create){
             insert sObjCon; 
         }
        return sObjCon;
    }
    public static void getGlobalConfig() {
        GlobalConfig__c gcOrgDefault =  GlobalConfig__c.getOrgDefaults();
        gcOrgDefault.SetUpOwnerId = UserInfo.getUserId();
        upsert gcOrgDefault;
                     
        GlobalConfig__c gcUserLevel =  GlobalConfig__c.getInstance();
        gcUserLevel.EnableChatter__c = true;
        upsert gcUserLevel; 
               
    }

    public static SObjectPhaseConfig__c getSObjectPhaseConfig(Id phaseConfigId, Id sobjectConfigId, boolean create){

         SObjectPhaseConfig__c sobjPhaseConfig = new SObjectPhaseConfig__c();
         sobjPhaseConfig.PhaseConfig__c = phaseConfigId;
         sobjPhaseConfig.SObjectConfig__c = sobjectConfigId;
         sobjPhaseConfig.GlobalSearchVisibility__c = true;
         sobjPhaseConfig.RecentlyViewedVisibility__c = true;

         if(create){
             insert sobjPhaseConfig; 
         }
        return sobjPhaseConfig;
    }
    
    public static SObjectLayoutConfig__c getSObjectLayoutConfig(boolean create){
        CustomApp__c customAppConfig = getCustomApp(true);
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(false);
        pageLayoutConfig.IsMiniLayout__c = true;
        
        insert pageLayoutConfig;
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
        List<PageBlockDetailConfig__c> pageBlockDetailConfig = getPageBlockDetailConfigList(pageBlockConfig.Id,true);
        //PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        SObjectConfig__c sObjCon =  getSObjectConfig(true);
        SObjectLayoutConfig__c sObjLayCon = new SObjectLayoutConfig__c();
        sObjLayCon.Name = 'Trial Layout';
        sObjLayCon.IsDefault__c = true;
        sObjLayCon.ProfileNames__c = 'System Administrator';
        sObjLayCon.CustomApp__c = customAppConfig.Id;
        sObjLayCon.PageLayoutConfig__c = pageLayoutConfig.Id;
        sObjLayCon.SObjectConfig__c = sObjCon.Id;
        
        if(create){
             insert sObjLayCon; 
         }
        return sObjLayCon;
    }

    public static SObjectLayoutConfig__c getSObjectLayoutConfigTask(boolean create){
        CustomApp__c customAppConfig = getCustomApp(true);
        PageLayoutConfig__c pageLayoutConfig =  getPageLayoutConfig(false);
        pageLayoutConfig.IsMiniLayout__c = true;
        
        insert pageLayoutConfig;
        TabConfig__c tabConfig =  getTabConfig(pageLayoutConfig.Id,true);
        PageBlockConfig__c pageBlockConfig =  getPageBlockConfig(tabConfig.Id, true);
       // List<PageBlockDetailConfig__c> pageBlockDetailConfig = getPageBlockDetailConfigList(pageBlockConfig.Id,true);
        SObjectConfig__c sObjCon =  getSObjectConfigTask(true);
        SObjectLayoutConfig__c sObjLayCon = new SObjectLayoutConfig__c();
        sObjLayCon.Name = 'Trial Layout';
        sObjLayCon.IsDefault__c = true;
        sObjLayCon.ProfileNames__c = 'System Administrator';
        sObjLayCon.CustomApp__c = customAppConfig.Id;
        sObjLayCon.PageLayoutConfig__c = pageLayoutConfig.Id;
        sObjLayCon.SObjectConfig__c = sObjCon.Id;
        
        if(create){
             insert sObjLayCon; 
         }
        return sObjLayCon;
    }
    
    public static KeyValueStore__c getKeyValueStore(boolean create) {
        KeyValueStore__c KeyValueStore = new KeyValueStore__c();
        KeyValueStore.Description__c = 'Test';
        KeyValueStore.TextValue__c = 'Test Name';
        KeyValueStore.Name='Name';
        KeyValueStore.Admin_Question__c = 'Loren Ipsum';
                     
        if (create) {  
            insert KeyValueStore;
        }
        return KeyValueStore;
    }
    
    public static DynamicFieldConfigData__mdt getDynamicFieldConfig(boolean create,String type) {
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        DynamicFieldConfigData__mdt dynFieldConf = new DynamicFieldConfigData__mdt();
        dynFieldConf.Name__c = 'TestName';
        dynFieldConf.DisplayField__c =  nameSpaceprefix+ 'DisplayValue__c';
        dynFieldConf.Object__c = nameSpaceprefix +'Picklist__c';
        dynFieldConf.ReturnField__c = nameSpaceprefix + 'Value__c';
        dynFieldConf.Type__c = type;
        if(create) {
            //insert dynFieldConf;
        }
        return dynFieldConf;
    }

    public static Picklist__c getPicklist (boolean create) {
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        Picklist__c picklist = new Picklist__c();
        picklist.Name = 'TestName-0';
        picklist.DisplayValue__c =  'test1';
        picklist.Value__c = 'test1';
        picklist.GroupName__c = 'TestName';
        
        if(create) {
            insert picklist;
        }
        return picklist;
    }
     
    public static ThemeConfig__c getThemeConfig(boolean create) {
        ThemeConfig__c themeConfig = new ThemeConfig__c(Name='SampleName',Sequence__c=99,PreviewImageDocumentName__c='Sample PreviewImageDocumentName',CSSDocumentName__c='Sample CSS Document Name');
                     
        if (create) {  
            insert themeConfig ;
        }
        return themeConfig ;
    }
    
    
    public static TaskConfig__c getTaskConfig(boolean create) {
        TaskConfig__c taskActionSummary = new TaskConfig__c(Name='SampleName');
                     
        if (create) {  
            insert taskActionSummary ;
        }
        return taskActionSummary ;
    }
            
    public static Task getTaskObj(boolean create) {
        SampleObject2__c samp2Obj = getSampleObject2Val(true);

         Account Acct= new Account(Name = 'Test');
        insert Acct;

        contact cont = new contact(Accountid = Acct.id,LastName = 'Test');
        insert cont;

        Task taskSummary = new Task(WhoId = cont.id, WhatId = samp2Obj.Id, Status = 'Completed', Priority = 'Normal', Subject = 'Dummy subject' , ActivityDate = system.today());
                     
        if (create) {  
            insert taskSummary ;
        }
        return taskSummary ;
    }
            
    
     public static CustomAppPhaseConfig__c getCustomAppPhaseConfig(boolean create){
         CustomAppPhaseConfig__c customAppPhaseConfig= new CustomAppPhaseConfig__c();
         customAppPhaseConfig.TabName__c = 'Planning';
         customAppPhaseConfig.Active__c = true;
         customAppPhaseConfig.Sequence__c = 1;
         customAppPhaseConfig.Name = 'Planning';
         customAppPhaseConfig.URL__c = '/apex/PhaseView';
         customAppPhaseConfig.CustomAppName__c= 'StateasGrantor';
         customAppPhaseConfig.SelectedByDefault__c = true;
         customAppPhaseConfig.GroupName__c = 'g1';
         customAppPhaseConfig.AvailableforProfiles__c = 'System Administrator';

         if(create){
             insert customAppPhaseConfig; 
         }
        return customAppPhaseConfig;
    }
    
    public static  ProfileDropDownConfig__c getProfileDropDownConfig(boolean create){
         ProfileDropDownConfig__c  profileDropDownConfig = new  ProfileDropDownConfig__c();
         profileDropDownConfig.Label__c = 'Grantor';
         profileDropDownConfig.Active__c = true;
         profileDropDownConfig.Sequence__c = 1;
         profileDropDownConfig.Name = 'Grantor';
         profileDropDownConfig.URL__c = '/apex/PhaseView';
         profileDropDownConfig.External_URL__c = '/apex/PhaseView';
        
         
         if(create){
             insert profileDropDownConfig ; 
         }
        return profileDropDownConfig ;
    }
    
    public static AccordionHeader__c getAccordionHeader(Id PhaseConfig,boolean create){
        AccordionHeader__c accordionHeader = new AccordionHeader__c();
        accordionHeader.Name='Test Header';
        accordionHeader.sequence__c = 2;
        accordionHeader.PhaseConfig__c = PhaseConfig;

        if (create) {
            insert accordionHeader;
        }  
        return accordionHeader;    
     }
     
     public static AccordionSubHeader__c getAccordionSubHeader(Id AccordionHeader,boolean create){
        AccordionSubHeader__c accordionSubHeader = new AccordionSubHeader__c();
        accordionSubHeader.Name='Test SubHeader';
        accordionSubHeader.sequence__c = 2;
        accordionSubHeader.AccordionHeader__c = AccordionHeader;
        accordionSubHeader.hide__c = false;

        if (create) {
            insert accordionSubHeader;
        } 
        return accordionSubHeader;    
     }
     
     public static AccordionContent__c getAccordionContent(Id AccordionSubHeader,boolean create){
        AccordionContent__c accordionContent = new AccordionContent__c();
        accordionContent.Name='Test Content';
        accordionContent.sequence__c = 2;
        accordionContent.AccordionSubHeader__c = AccordionSubHeader;
        accordionContent.Link__c = '/apex/Planning';
        if (create) {
            insert accordionContent;
        } 
        return accordionContent;    
     }
    
    
    public static ExternalLinkConfig__c getExternalLinks(Id PhaseConfigId, boolean create) {
        ExternalLinkConfig__c externalLink = new ExternalLinkConfig__c(); 
        externalLink.Name = 'Link1';
        externalLink.PhaseConfig__c = PhaseConfigId; 
        externalLink.URL__c = 'www.hrsa.gov';
        externalLink.OpenNewWindow__c = true;
        externalLink.Active__c = true;
        externalLink.sequence__c = Decimal.valueOf('2');
        if (create) {
            insert externalLink;
        }   
        return externalLink;    
    }   
    
    //TODO: Use Id instead of entire object as the parent for input parameters
   
  
     
    public static Account getAccount(boolean create) {
        Account account = new Account();
        account.Name = 'New Grants Account'+system.now()+Math.random();
   
        //Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Internal').getRecordTypeId();     
        //account.RecordTypeId = recTypeId;
                 
        if (create) {
            insert account;
        }   
        return account;
    } 
        public static Account getAccount(Id parentId, boolean create) {
        Account account = new Account();
        account.Name = 'New Child Account'+Math.random();
        account.ParentId = parentId;
       
        if (create) {
            insert account;
        }   
        return account;
    } 
    
     public static SearchConfig__c getSearchConfig(Id phaseId, boolean create) {
        SearchConfig__c searchConfig = new SearchConfig__c();
        searchConfig.PhaseConfig__c= phaseId;
        searchConfig.SObject__c = 'Program__c';
        if (create) { 
            insert searchConfig ;
        }   
        return searchConfig ;
    }   
    public static SearchConfig__c getFlexSearchConfig(Id phaseId, Id flexId,boolean create) {
        SearchConfig__c searchConfig = new SearchConfig__c();
        searchConfig.PhaseConfig__c= phaseId;
        searchConfig.FlexTableConfig__c= flexId;
        searchConfig.SObject__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        if (create) { 
            insert searchConfig ;
        }   
        return searchConfig ;
    }
    
    public static UserPreferences__c getUserPreference(boolean create,string fieldName, string fieldValue){
        UserPreferenceHelper.setBooleanValue('HideSidebar__c', true);
        UserPreferenceHelper.setBooleanValue('SidebarSearchCollapsed__c', true);
        UserPreferenceHelper.setBooleanValue('SidebarMenuCollapsed__c', true);        
        UserPreferenceHelper.setStringValue(fieldName, fieldValue);
       
        return UserPreferences__c.getInstance();
    }
    
    public static CustomAppFooterConfig__c getCustomAppFooterConfig(boolean create){
        CustomAppFooterConfig__c customAppFooterConfig= new CustomAppFooterConfig__c();
        customAppFooterConfig.Active__c = true;
        customAppFooterConfig.Sequence__c = 1;
        customAppFooterConfig.Name = 'StateAsGrantor';
        customAppFooterConfig.TargetURL__c = '/apex/test';
        customAppFooterConfig.DisplayText__c = 'test';
        customAppFooterConfig.CustomAppName__c= 'StateasGrantor';
        if(create){
            insert customAppFooterConfig; 
        }
        return customAppFooterConfig;
    }
    
    public static DataTableConfig__c getFlexDataTableConfig(boolean create){
        DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable';
        dataTableConfig.SObject__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        dataTableConfig.FieldNames__c = 'Id, Name';  
        //dataTableConfig.FilterCriteria__c = 'Name != {!name} ';
        dataTableConfig.Description__c='TestDescription';  
         dataTableConfig.Header__c='TestHeader';  
            
        if(create){
            insert dataTableConfig  ;
        } 
            return dataTableConfig;      
    }
    
    public static DataTableConfig__c getFlexDataTableHistoryConfig(boolean create){
        DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable';
        dataTableConfig.SObject__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        dataTableConfig.FieldNames__c = 'Id,OldValue';  
        //dataTableConfig.FilterCriteria__c = 'Name != {!name} ';
        dataTableConfig.Description__c='TestDescription';  
      
        dataTableConfig.HelpConfig__c = getHelpConfigWithRecordType(true, 'Internal Document').Id;     
        if(create){
            insert dataTableConfig  ;
            DataTableDetailConfig__c datadataDetailConfig = new DataTableDetailConfig__c(FlexTableConfig__c=dataTableConfig.Id, FieldAPIName__c='OldValue', 
                                        FieldLabelOverride__c='test', FieldWidth__c=23.0);
                                        insert datadataDetailConfig;
        } 
            return dataTableConfig;      
    }
    
    public static DataTableConfig__c getFlexDataTableConfigForReport(boolean create){
        DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable';
        dataTableConfig.SObject__c = 'Report';
        dataTableConfig.FieldNames__c = 'Id, Name';          
        if(create){
            insert dataTableConfig  ;
        } 
            return dataTableConfig  ;      
    }
    public static DataTableConfig__c getDataTableConfig(boolean create){
        DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable';
        dataTableConfig.SObject__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        dataTableConfig.FieldNames__c = 'Id, Name';       
        dataTableConfig.OrderBy__c = 'Name'; 
        dataTableConfig.description__c='testDescription';
        dataTableConfig.RecordTypeId = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Search Table').getRecordTypeId();
        
        if(create){
            insert dataTableConfig  ;
        } 
            return dataTableConfig  ;      
    }
    public static DataTableAction__c  getDataTableAction(Id dataTableConfigId, boolean create){
        DataTableAction__c dataTableAction = new DataTableAction__c(); 
        dataTableAction.DataTableConfig__c = dataTableConfigId;  
        dataTableAction.Name = 'Test Action';   
        dataTableAction.Sequence__c = 1;  
        dataTableAction.ActionURL__c = '/test/URL?istest={!istest}';  
        
        if(create){
            insert dataTableAction ;
        } 
            return dataTableAction ;   
    }
    
    //TEST HELPER METHOD FOR REVIEW PANEL CHANGES 
  
   

    /*
        Creates an Announcement and attaches the attachment to the Announcement
    */
    public static Attachment getAttachment(Id parentId, boolean create){
        
        Attachment attachementInstance = new Attachment();
        attachementInstance.Name = 'Test Attachment';
        attachementInstance.Body = Blob.valueOf('This is a test body');
        attachementInstance.ParentId = parentId;
        
        if(create){
            insert attachementInstance;
        }
        return attachementInstance;
    }
       /*
        Creates an Note  
    */ 
     public static Note getNote(Id parentId, boolean create){        
        Note noteInstance = new Note();
        noteInstance.Title = 'Test Note';
        noteInstance.Body = 'This is a test body';
        noteInstance.ParentId = parentId;        
        if(create){
            insert noteInstance;
        }
        return noteInstance;
    }
    
    
    public static AttachmentExtension__c getAttachmentExtension(String classification, Id parentId, boolean create){
        Attachment attachementInstance = getAttachment(parentId, true);
        AttachmentExtension__c attachmentExtension = new AttachmentExtension__c();
        attachmentExtension.Classification__c = classification;
        attachmentExtension.Attachment__c = attachementInstance.Id;
        attachmentExtension.ParentId__c = parentId;
        
        if(create){
            insert attachmentExtension;
        }
        return attachmentExtension;
    }

    public static AttachmentExtension__c getAttachmentExtensionForDigSign(String classification, Id parentId, boolean create){
        Attachment attachementInstance = getAttachment(parentId, true);
        AttachmentExtension__c attachmentExtension = new AttachmentExtension__c();
        attachmentExtension.Classification__c = classification;
        attachmentExtension.Attachment__c = attachementInstance.Id;
        attachmentExtension.ParentId__c = parentId;
        attachmentExtension.HistoryReason__c = 'DigSin History';
        DigitalSignature__c digSign = getDigitalSignature(true);
        attachmentExtension.DigitalSignature__c = digSign.Id;
        attachmentExtension.DigitalSignature__r = digSign;
        attachmentExtension.Classification__c = classification;
        if(create){
            insert attachmentExtension;
        }
        return attachmentExtension;
    }

    public static DigitalSignature__c getDigitalSignature(Boolean create){
        DigitalSignature__c digSignObj = new DigitalSignature__c();
        digSignObj.Name = 'Test Doucument';
        digSignObj.SignatureStatus__c = 'Verified';
        digSignObj.DocverifyId__c = 'f81fd695-8634-96cc-42157149cbeO';
        if(create){
            insert digSignObj;
        }
        return digSignObj;
    }


    public static Highlight__c getHighlight(boolean create){
        Highlight__c highlightInstance = new Highlight__c();
        highlightInstance.Summary__c = 'Sample Highlight Summary';
        highlightInstance.StartDate__c = Date.today();
        highlightInstance.EndDate__c = Date.today().addDays(2);
        
        Id recordTypeId = Schema.Sobjecttype.Highlight__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        highlightInstance.RecordTypeId = recordTypeId;
        if(create){
            insert highlightInstance;
        }
        return highlightInstance;
    }
    
    public static RecordCopyConfig__c getCopyConfig(boolean create) {
        RecordCopyConfig__c record = new RecordCopyConfig__c(SourceObjectName__c='Account', SourceFieldName__c='Name', TargetObjectName__c='Contact',
                        TargetFieldName__c='Firstname');
        if (create) {
            insert record;
        }
        return record;
    }

    
    public static NameTemplateSequence__c getNameTemplateSequence(boolean create){
        NameTemplateSequence__c templateSeq = new NameTemplateSequence__c(); 
        templateSeq.Name = 'APP-New Announcement-TBD-';  // this will be equal to the formula name 
        String nameSpace = AppUtils.getNameSpacePrefix();
        templateSeq.ObjectName__c = nameSpace+'Application__c';
        templateSeq.StartSequence__c = 1000;
        templateSeq.Year__c = System.today().year();
        if(create){
            insert templateSeq;
        }
        return templateSeq;
    }
    
     
    public static NameTemplateConfig__c getNameTemplateConfig(boolean create){
        NameTemplateConfig__c config = new NameTemplateConfig__c();
        String nameSpace = AppUtils.getNameSpacePrefix();
        config.Name = nameSpace+'SampleObject11__c';   
        config.Active__c = true;   
        config.AutoNumberFormat__c = '{00000}-{YYYY}';
        config.StartNumber__c = 0;
        config.FormulaFieldName__c = AppUtils.getNameSpacePrefix()+'SampleFormula__c';
        config.SkipAutoNumberReset__c = false; 
        if(create){  
            insert config; 
        }
        return config; 
    }
    
    
   public static NameTemplateSequence__c getNameTemplateSequenceAnnouncement(boolean create){
        NameTemplateSequence__c templateSeq = new NameTemplateSequence__c(); 
        templateSeq.Name = 'ANN-New Grants Program1-';  // this will be equal to the formula name 
        String nameSpace = AppUtils.getNameSpacePrefix();
        templateSeq.ObjectName__c = nameSpace+'SampleObject11__c'; 
        templateSeq.StartSequence__c = 1000; 
        templateSeq.Year__c = System.today().year();
        if(create){ 
            insert templateSeq;
        }
        return templateSeq;
    }
     

    public static NameTemplateConfig__c getNameTemplateConfigAnnouncement(boolean create){
        NameTemplateConfig__c config = new NameTemplateConfig__c();
        String nameSpace = AppUtils.getNameSpacePrefix();
        config.Name = nameSpace+'SampleObject11__c';     
        config.Active__c = true;   
        config.AutoNumberFormat__c = '{00000}-{YYYY}';
        config.StartNumber__c = 0;
        config.FormulaFieldName__c = nameSpace+'NameTemplate__c'; 
        config.SkipAutoNumberReset__c = false;  
        if(create){  
            insert config; 
        }
        return config; 
    }
    
    public static String getFundsChartData(){
      String Year = '2014';
              return Year;
    } 
    
     public static Integer getActiveProgramData(){
     Integer Year = 2014;
              return Year;
    } 
    
   
    public static List<Document> createPostInstallScriptData(){ String ns = AppUtils.getNamespacePrefix(); 
        String csvBodyPostInstallScript = 'Name,' + ns+'Install__c,'+ns+'Sequence__c  \n' + ns+'NameTemplateConfig__c,true,1\n' +ns+ 
                'CustomAppConfig__c,true,2\n' +ns+ 'PhaseConfig__c,true,3';        
        String csvBodyNameTemplateConfig  = 'NAME,'+ns+'ACTIVE__C,'+ns+'AUTONUMBERFORMAT__C,'+ns+'FORMULAFIELDNAME__C,'+ns+'SKIPAUTONUMBERRESET__C,'+
                ns+'STARTNUMBER__C \n'+ns+'Application__c,TRUE,{000000}-{YY},'+ns+'NameTemplate__c,TRUE,2000';                                                 
        String csvCustomAppConfig ='NAME,'+ns+'ACTIVE__C,'+ns+'LABEL__C,'+ns+'SEQUENCE__C,'+ns+'URL__C,'+ns+
                'REPORTSFOLDERNAME__C \nStateAsGrantee,true,State as Grantee,1,/apex/PhaseView?t=GranteeHome,Admin';
        String csvPhaseConfig = 'ID,NAME,'+ns+'ACCORDIONHEADER__C,'+ns+'ACTIVE__C,'+ns+'BODYPAGEINCLUDEURL__C,'+ns+'BODYTABLE__C,'+ns+
                'CUSTOMAPPNAME__C,'+ns+'ENABLEEXTERNALLINKS__C,'+ns+'ENABLEMENU__C,'+ns+'ENABLERECENTLYVIEWED__C,'+ns+'ENABLESEARCH__C,'+
                ns+'GROUPNAME__C,'+ns+'SOBJECT__C,'+ns+'SEARCHRESULTPAGE__C,'+ns+'SELECTEDBYDEFAULT__C,'+ns+'SEQUENCE__C,'+ns+'SIDEBARCOMPONENTSEQUENCE__C,'+
                ns+'SIDEBAREXTERNALLINKSLABEL__C,'+ns+'SIDEBARRECENTLYVIEWEDLABEL__C,'+ns+'SIDEBARSEARCHLABEL__C,'+ns+'TABNAME__C,'+
                ns+'URL__C,'+ns+'ABBREVIATION__C,'+ns+'BODYBOTTOMPAGEURL__C,'+ns+'FLEXTABLEPARAMETERS__C,'+ns+'PhaseType__c,'+ns+'TOTALCHARTSALLOWEDPERROW__C,'+
                ns+'TOTALCHARTSALLOWED__C'+
                '\n a0eG00000064gXmIAI,Admin,Actions,TRUE,,a0JG000000PsF88MAF,Admin,FALSE,TRUE,FALSE,FALSE,1,,,TRUE,1,SubMenu,,,,,Admin,' + 
                '/apex/PhaseView?t=Admin,Adm,,orgType=Division,Home,,,';
         
        List<Document> lstDocument = new List<Document>();  
        Folder folder = [Select Id From Folder  limit 1 ]; 
                     
         
        Document postInstallScript = new Document(Name= ns+'PostInstallConfig__c', Body = Blob.valueOf(csvBodyPostInstallScript) , FolderId =folder.Id);
        insert postInstallScript; 
        lstDocument.add(postInstallScript);
        Document nameTemplateConfigScript = new Document(Name= ns+'NameTemplateConfig__c', Body = Blob.valueOf(csvBodyNameTemplateConfig) , FolderId =folder.Id);
        insert nameTemplateConfigScript;
        lstDocument.add(nameTemplateConfigScript);
        Document customAppConfigScript = new Document(Name= ns+'CustomAppConfig__c', Body = Blob.valueOf(csvCustomAppConfig)  , FolderId =folder.Id);  
        insert customAppConfigScript; 
        
        Document phaseConfigScript = new Document(Name= ns+'PhaseConfig__c', Body = Blob.valueOf(csvPhaseConfig)  , FolderId =folder.Id);  
        insert phaseConfigScript;  
         
        
        List<CustomAppConfig__c> CustomAppConfiglst  = [Select Id ,Name from CustomAppConfig__c Limit 1000];
         
        
        lstDocument.add(customAppConfigScript);
        return lstDocument;
    } 
    private static Integer autUniqueNo = 1;
    public static ChartConfig__c getChartConfig(Boolean create) {
        ChartConfig__c chartConfig = new ChartConfig__c(ObjectName__c='SampleObject11__c',Name='Test Chart',title__c='Test Chart',
                UniqueName__c = autUniqueNo + 'abc');
                autUniqueNo++;
        if (create) {  
            insert chartConfig ;
        }
        return chartConfig ;
    }


    public static ChartDetailConfig__c getChartDetailConfig(Boolean create, Id chartConfig) {
        ChartDetailConfig__c chartDetailConfig = new ChartDetailConfig__c(DisplayDataType__c='Count', Title__c='Test Chart Detail', 
                     ChartConfig__c = ChartConfig); 
        chartDetailConfig.query__c = 'SELECT count(Id), ' + AppUtils.getNamespacePrefix() + 'Sample_Object_2__r.' + AppUtils.getNamespacePrefix() + 
                        'Account__r.Name Test1 FROM ' + AppUtils.getNamespacePrefix() + 'SampleObject11__c  WHERE (' + AppUtils.getNamespacePrefix() + 
                        'Sample_Object_2__r.' + AppUtils.getNamespacePrefix() + 'Account__r.Name!=Null ) Group By ' + AppUtils.getNamespacePrefix() + 
                        'Sample_Object_2__r.' + AppUtils.getNamespacePrefix() + 'Account__r.Name ORDER By Count(Id) DESC LIMIT 10' ;                                
        if (create) {  
            insert chartDetailConfig ;
        }
        return chartDetailConfig ;
    }
     /*     
     public static ChartConfig__c getChartConfig(Boolean create) {
        PhaseConfig__c phase = 
        (false);
        phase.abbreviation__c = 'P01';
        insert phase;
        ChartConfig__c ChartConfig = new ChartConfig__c(ObjectName__c='SampleObject11__c',Name='Announcement Chart',title__c='Announcement Chart',
                    PhaseConfig__c = phase.id);
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    */
    public static Id getRecordType(DescribeSObjectResult sobjType, String recordTypeName) {
        return sobjType.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    
    public static ChartConfig__c getActiveProgramsChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='ActivePrograms', ObjectName__c='Program__c', Title__c='Total Active Programs',
                    ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, FilterFieldNames__c=AppUtils.getNamespacePrefix()+'StartDate__c;'+AppUtils.getNamespacePrefix()+'EndDate__c', 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Bar - Stacked'),UniqueName__c ='ActivePrograms');
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    
    public static ChartConfig__c getTotalFundingChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='TotalFunding', ObjectName__c='FundingSourceYear__c', Title__c='Total Funding',
                ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, FilterFieldNames__c=AppUtils.getNamespacePrefix()+'FiscalYear__c', 
                RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Pie - Basic'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
     public static ChartConfig__c getTotalFundingSourceYearChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='Funds Summary', ObjectName__c='FundingSourceYear__c', Title__c='Funds Summary',
                    ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, FilterFieldNames__c=AppUtils.getNamespacePrefix()+'FiscalYear__c', 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Pie - Basic'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
    public static ChartConfig__c getTotalAnnouncementChartConfig(Boolean create, Id phaseConfigId) {
        ChartConfig__c ChartConfig = new ChartConfig__c(Name='TotalAnnouncement', ObjectName__c=AppUtils.getNameSpacePrefix()+'SampleObject11__c', 
                    Title__c='Total Announcement',ChartPageURL__c='/apex/testPageUrl', PhaseConfig__c = phaseConfigId, FilterFieldNames__c=AppUtils.getNamespacePrefix()+'FiscalYear__c', 
                    RecordTypeId=getRecordType(Schema.SObjectType.ChartConfig__c, 'Bar - Stacked'));
        if (create) {  
            insert ChartConfig ;
        }
        return ChartConfig ;
    }
   
  
    /** assert equals **/
    public static void assertEquals(String[] expected, String[] actual) {
        System.assertEquals(expected.size(), actual.size());
        for(Integer i=0; i<expected.size(); i++) {
            System.assertEquals(expected[i], actual[i]);
        }
    }
    

    public static EmailTemplate getEmailTemplate(boolean create,String name,String developer){
        //List<Folder> lstFolder = [Select Id From Folder Where Name ='GovGrants' and Type = 'Email' ];
        EmailTemplate e;
            e=new EmailTemplate(TemplateType= 'Text', Name = name,developerName =developer,FolderId = UserInfo.getUserId());                    
        if (create) {  
            insert e;
        }
        return e;
    }
    
    /*
    public static ElectronicSignature__c getElectronicSignature(Boolean create) {
        ElectronicSignature__c sign = new ElectronicSignature__c();
        if (create) {
            insert sign;
        }
        return sign;
    }*/

    public static GridHeaderConfig__c getGridHeader(Boolean create) {
        String ns = AppUtils.getNameSpacePrefix();
        GridHeaderConfig__c h = new  GridHeaderConfig__c(UniqueName__c='TestName' + String.valueOf(System.Now().getTime()),SObjectName__c=ns+'ApplicationBudgetCategory__c', GridTitle__c='test',
            DisplayFields__c='Name, ' + ns + 'Year1Amount__c, ' + ns + 'Year2Amount__c', ParentRelationshipField__c=ns+'Application__c',
            ReadOnlyFields__c=ns + 'Year3Amount__c', RowNumberIdentifierField__c=ns+'RowNumber__c');
        if (create) {
            insert h;
        }
        return h;
    }
    public static GridHeaderConfig__c getGridHeaderForPDF(Boolean create) {
        String ns = AppUtils.getNameSpacePrefix();
        GridHeaderConfig__c h = new  GridHeaderConfig__c(UniqueName__c='TestName' + String.valueOf(System.Now().getTime()),SObjectName__c=ns+'SampleObject12__c', GridTitle__c='test',
            DisplayFields__c= ns + 'Currency1__c, ' + ns + 'Currency2__c', ParentRelationshipField__c=ns+'SampleObject11__c',
            ReadOnlyFields__c=ns + 'SampleNumber1__c', RowNumberIdentifierField__c=ns+'SampleNumber1__c');
        if (create) {
            insert h;
        }
        return h;
    }

    public static GridDetailConfig__c getGridDetail(Id headerId, Boolean create) {
        GridDetailConfig__c detail = new GridDetailConfig__c(GridHeaderConfig__c=headerId,SummaryRange__c='3,4-5,8', RowNumber__c=1);
        if (create) {
            insert detail;
        }
        return detail;
    }

     
    public static ContentVersion getContentVersion(boolean create) {
        
        ContentVersion cv = new ContentVersion();
        
        cv.versionData = Blob.valueOf('Unit Test Content Version');
        cv.title = 'testFile.txt';
        cv.pathOnClient ='/' + cv.title;
        if (create) {
            insert cv;
        }
        return cv;
    }
    public static CollaborationGroup getCollaborationGroup(boolean create) {
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'testGroup';
        cg.CollaborationType = 'Public';
        if (create) {
            insert cg;
        }
        return cg;
    }
    public static ErrorMessageConfig__c getErrorMessageConfig(String errorCode,String Message,Id phaseConfigId,Id customAppConfigId,boolean create) {
        ErrorMessageConfig__c errorMessage = new ErrorMessageConfig__c();
        errorMessage.Name = errorCode;
        errorMessage.ErrorCode__c = errorCode;
        errorMessage.Message__c = Message;
        errorMessage.PhaseConfig__c = phaseConfigId;
        errorMessage.Message_Type__c = 'success';
        errorMessage.CustomAppConfig__c = customAppConfigId;
        if (create) {
            insert errorMessage;
        }
        return errorMessage;
    }
    public static ErrorMessageConfig__c getErrorMessageConfig(String Message,Id phaseConfigId,Id customAppConfigId,boolean create) {
        ErrorMessageConfig__c errorMessage = new ErrorMessageConfig__c();
        errorMessage.Message__c = Message;
        errorMessage.PhaseConfig__c = phaseConfigId;
        errorMessage.Message_Type__c = 'test';
        errorMessage.CustomAppConfig__c = customAppConfigId;
        if (create) {
            insert errorMessage;
        }
        return errorMessage;
    } 
    
    public static List<PageBlockDetailConfig__c> getPageBlockDetailConfigList(Id pageBlockConfig, Boolean create) {                                     /*Inserted list of fileds : AJ */ 
        Id recTypeId = Schema.SObjectType.PageBlockDetailConfig__c.getRecordTypeInfosByName().get('Field').getRecordTypeId();
        List<PageBlockDetailConfig__c> pageBlockDetail = new List<PageBlockDetailConfig__c>();
        //pageBlockDetail.add(new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
          //          PageBlockConfig__c=pageBlockConfig, FieldAPIName__c='Account.Name'));
        pageBlockDetail.add(new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                    PageBlockConfig__c=pageBlockConfig, FieldAPIName__c=AppUtils.getNamespacePrefix()+'SampleDate__c'));
        pageBlockDetail.add(new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                    PageBlockConfig__c=pageBlockConfig, FieldAPIName__c='LastModifiedDate'));
        pageBlockDetail.add(new PageBlockDetailConfig__c(IsActive__c=true,RecordTypeId=recTypeId,SortOrder__c=0,
                    PageBlockConfig__c=pageBlockConfig, FieldAPIName__c=AppUtils.getNamespacePrefix()+'UserFriendlyNameField__c'));
        if (create) {  
            insert pageBlockDetail;
        }
        return pageBlockDetail;
    }
    
    public static ApprovalSnapshot__c getApprovalSnapshot(Boolean create) {
        ApprovalSnapshot__c apprvalsnap = new ApprovalSnapshot__c(AttachmentID__c='test', ParentID__c='[arentId]');
        if(create) {
            insert apprvalsnap;
        }
        return apprvalsnap;
    }
    
    public static CalendarConfig__c getCalConfig(Boolean create) {
        SObjectConfig__c sobj = new SObjectConfig__c(Name = 'Account');
        insert sobj; 
        CalendarConfig__c calConfig = new CalendarConfig__c(Name='calconfig', ParentSobject__c = sobj.Id, Active__c=true, RelatedSobject__c='Task', DateFields__c='CreatedDate',
            RelationshipField__c='Name');
        if(create) {
            insert calConfig;
        }
        return calConfig;
    }
    
    public static ExportTemplate__c getExportTemplate(Boolean create) {
        ExportTemplate__c expConfig = new ExportTemplate__c(Name='expCOnfig', Body1__c='testse', Body3__c='test');
        if(create) {
            insert expConfig;
        }
        return expConfig;
    }
    
    public static ApprovalDecisionActionConfig__c getApprovalDecisionAction(String sobjId, String custId, Boolean create) {
        ApprovalDecisionActionConfig__c approvalaction = new ApprovalDecisionActionConfig__c(CustomAppConfig__c=custId, SobjectConfig__c=sobjId);
        if(create) {
            insert approvalaction;
        }
        return approvalaction;
    }
    
    public static CongaQuery__c getCongaQuery(Boolean create) {
        CongaQuery__c congaQuery = new CongaQuery__c(Name='congaQuery', ObjectAPIName__c='Account');
        if(create) {
            insert congaQuery;
        }
        return congaQuery;
    }
    
    public static EmailTemplateConfig__c getEmailTempalteConfig(Boolean create) {
        EmailTemplateConfig__c emailTemplate = new EmailTemplateConfig__c(Name='emailTemplate', EmailTemplateDeveloperName__c='Dev');
        if(create) {
            insert emailTemplate;
        }
        return emailTemplate;
    }
    
    public static FlexGridConfig__c getFlexGridConfigBudgetGrid(Boolean create){
        FlexGridConfig__c flexGridConfig = new FlexGridConfig__c();
        Id recTypeId = Schema.SObjectType.FlexGridConfig__c.getRecordTypeInfosByName().get('Budget Grid').getRecordTypeId();
        flexGridConfig.RecordTypeId = recTypeId;
        DataTableConfig__c dataBuDataTableConfig = getFlexBudgetGridConfig(true);
        flexGridConfig.ParentFlexTable__c = dataBuDataTableConfig.Id;
        flexGridConfig.Name = 'TestingBudget Grid';
        if(create){
            insert flexGridConfig;
        }
        return flexGridConfig;
    }

    public static DataTableConfig__c getFlexBudgetGridConfig(Boolean create){
        Id recTypeId = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Budget Grid').getRecordTypeId();

        DataTableConfig__c childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c= AppUtils.getNamespacePrefix()+'SampleObject12__c';
        childDataTableConfig.Name = 'TestChildDataTable1';
        childDataTableConfig.RecordTypeId = recTypeId;

        //childDataTableConfig.FieldNames__c = 'Id, Name';
        childDataTableConfig.Description__c='TestDescription';
        childDataTableConfig.RowGroupingFieldsJSON__c = '[{"field":"Account__c","column":"Account__r.Name"}' +
                ',{"field":"SampleObject11__c","column":"SampleObject11__r.Name"}]';

        childDataTableConfig.ColumnGroupingFieldJSON__c = '[{"field":"SampleObject1__c","column":"SampleObject1__r.Name"}]';
        childDataTableConfig.budgetGridEditCondition__c = '[{"field":"SampleCheckbox1__c","value":true}]';
        childDataTableConfig.Sort_Direction__c = 'ASC';
        childDataTableConfig.HideColumnsText__c = '[{"column":"SampleObject1__c","field":"Status__c","operator":"=","value":"Review In Progress"}]';


        if(create){
            insert childDataTableConfig;
        }
        return childDataTableConfig;
    }


    public static DataTableConfig__c getFlexTableConfig(Boolean create, Boolean communicationTable){
        String strUniqueKey = AppUtils.generateToken(null);
        DataTableConfig__c childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c= AppUtils.getNamespacePrefix()+'SampleObject11__c';
        if(communicationTable){
            childDataTableConfig.Name = 'CommunicationHistory';
        }else{
            childDataTableConfig.Name = 'TestChildDataTable1';
        }
        if(String.isNotBlank(strUniqueKey)){
            childDataTableConfig.Name += strUniqueKey = strUniqueKey.substring(0, strUniqueKey.length() < 10 ? strUniqueKey.length() : 10);
        }
        childDataTableConfig.FieldNames__c = 'Id, Name';
        childDataTableConfig.Description__c='TestDescription';

        if(create){
            insert childDataTableConfig;
        }
        return childDataTableConfig;
    }
    public static DataTableConfig__c getFlexTableConfig(Boolean create){
        String strUniqueKey = AppUtils.generateToken(null);
        DataTableConfig__c childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c= AppUtils.getNamespacePrefix()+'SampleObject11__c';
        childDataTableConfig.Name = 'TestChildDataTable1';
        
        if(String.isNotBlank(strUniqueKey)){
            childDataTableConfig.Name += strUniqueKey = strUniqueKey.substring(0, strUniqueKey.length() < 10 ? strUniqueKey.length() : 10);
        }
        childDataTableConfig.FieldNames__c = 'Id, Name';
        childDataTableConfig.Description__c='TestDescription';

        if(create){
            insert childDataTableConfig;
        }
        return childDataTableConfig;
    }

    public static FlexGridConfig__c getFlexGridConfigN2G(Boolean create) {
        String strUniqueKey = AppUtils.generateToken(null);
        DataTableConfig__c childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c= AppUtils.getNamespacePrefix()+'SampleObject11__c';
        childDataTableConfig.Name = 'TestChildDataTableN2G';
        if(String.isNotBlank(strUniqueKey)){
            childDataTableConfig.Name += strUniqueKey = strUniqueKey.substring(0, strUniqueKey.length() < 10 ? strUniqueKey.length() : 10);
        }
        childDataTableConfig.FieldNames__c = 'Id, Name';
        childDataTableConfig.Description__c='TestDescription';

        insert childDataTableConfig;

        FlexGridConfig__c fgc = new FlexGridConfig__c();
        fgc.Name = 'sample N2G grid';
        fgc.ParentFlexTable__c = childDataTableConfig.Id;
        fgc.Child1FlexTable__c = childDataTableConfig.Id;
        fgc.Child1RelationshipName__c = 'SampleObject1__r';
        fgc.Child1RelationshipLabel__c = 'Sub task';
        Id recTypeId = Schema.SObjectType.FlexGridConfig__c.getRecordTypeInfosByName().get('Nested Navigation Grid').getRecordTypeId();
        fgc.RecordTypeId = recTypeId;
        insert fgc;
        return fgc;
    }


    public static FlexGridConfig__c getFlexGridConfigME(Boolean create) {
        DataTableConfig__c childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c= AppUtils.getNamespacePrefix()+'SampleObject11__c';
        childDataTableConfig.Name = 'TestChildDataTableMassEditable';
        childDataTableConfig.FieldNames__c = 'Id, Name';
        childDataTableConfig.Description__c='TestDescription';

        insert childDataTableConfig;

        FlexGridConfig__c fgc = new FlexGridConfig__c();
        fgc.Name = 'sample mass edit';
        fgc.ParentFlexTable__c = childDataTableConfig.Id;
        fgc.Child1FlexTable__c = childDataTableConfig.Id;
        fgc.Child1RelationshipName__c = 'SampleObject1__r';
        fgc.Child1RelationshipLabel__c = 'Sub task';
        Id recTypeId = Schema.SObjectType.FlexGridConfig__c.getRecordTypeInfosByName().get('Mass Editable Grid').getRecordTypeId();
        fgc.RecordTypeId = recTypeId;
        insert fgc;
        return fgc;
    }

    public static FlexGridConfig__c getFlexGridConfig(Boolean create) {
        String strUniqueKey = AppUtils.generateToken(null);
        DataTableConfig__c childDataTableConfig = new DataTableConfig__c();
        childDataTableConfig.SObject__c= AppUtils.getNamespacePrefix()+'SampleObject11__c';  
        childDataTableConfig.Name = 'TestChildDataTable';
        if(String.isNotBlank(strUniqueKey)){
        	childDataTableConfig.Name += strUniqueKey = strUniqueKey.substring(0, strUniqueKey.length() < 10 ? strUniqueKey.length() : 10);
        }
        childDataTableConfig.FieldNames__c = 'Id, Name';          
        childDataTableConfig.Description__c='TestDescription';  

        insert childDataTableConfig;
        
        FlexGridConfig__c fgc = new FlexGridConfig__c();
        fgc.Name = 'sample mass edit';
        strUniqueKey = AppUtils.generateToken(null);
        if(String.isNotBlank(strUniqueKey)){
        	fgc.Name += strUniqueKey = strUniqueKey.substring(0, strUniqueKey.length() < 10 ? strUniqueKey.length() : 10);
        }
        fgc.ParentFlexTable__c = childDataTableConfig.Id;
        fgc.Child1FlexTable__c = childDataTableConfig.Id;    
        fgc.Child1RelationshipName__c = 'SampleObject1__r';
        fgc.Child1RelationshipLabel__c = 'Sub task';        
        insert fgc; 
        return fgc;
    }
    
    public static FlexTableFilterListViewConfig__c getFlexTableFilterListView(Id dataTableid, Boolean create) {
        FlexTableFilterListViewConfig__c fl = new FlexTableFilterListViewConfig__c(FlexTableConfig__c = dataTableid);
        if(create) {
            insert fl;
        }
        return fl;
    }
    
    public static PackageFormConfig__c getPackageFormConfig(Boolean create, String packageId, Id formId) {
        PackageFormConfig__c packageFormConfig = new PackageFormConfig__c(FormConfig__c=formId, PackageConfig__c=packageId);
        if(create) {
            insert packageFormConfig;
        }
        return packageFormConfig;
    }
    
    public static PackageTypeConfig__c getPackageType(Id formConfig, String custAppId, Boolean create) {
        PackageTypeConfig__c packageType = new PackageTypeConfig__c(CustomAppConfig__c=custAppId, LayoutForm__c=formConfig, Name='Application');
        if(create) {
            insert packageType;
        }
        return packageType;
    }
    
    public static StepProgressbarHeader__c getStepProgressbarHeader(Boolean create) {
        StepProgressbarHeader__c stepProgressBar = new StepProgressbarHeader__c(sObjectName__c='Account',DecisionFieldAPIName__c='Name',
            GroupName__c='test');
        if(Create) {
            insert stepProgressBar;
        }
        return stepProgressBar;
    }
    
    public static StepProgressbarDetail__c getStepProgressBarDetail(String headerId, Boolean create) {
        StepProgressbarDetail__c stepPorgressbar = new StepProgressbarDetail__c(ProgressbarHeaderConfig__c=headerId,PicklistValue__c='test',
                Sequence__c=1);
        if(create) {
            insert stepPorgressbar;
        }
        return stepPorgressbar;
    }
    
    public static RecordIdStorage__c getRecordIdStorage(Boolean create) {
        RecordIdStorage__c recordIdStorage = new RecordIdStorage__c(Name='recodTypeid');
        if(create) {
            insert recordIdStorage;
        }
        return recordIdStorage;
    }
    
    public static SObjectAutoSnapshot__c getSObjectAutoSnap(Boolean create){
        SObjectConfig__c sObjCon =  getSObjectConfig(true);       
        SObjectAutoSnapshot__c sobjAutoSnap = new SObjectAutoSnapshot__c(isActive__c=true,SObject__c=sObjCon.Id,SnapShotFileName__c='Demo Snap Shot');
        if(create){
            insert sobjAutoSnap;
        }
        return sobjAutoSnap;
    }

    // Dynamic Form Config ....
    public static CaptureForm__c getCaptureFormConfig(Boolean create) {
        CaptureForm__c cpForm = new CaptureForm__c(Name__c = 'Sample Form Test',ScoreCalculationBehaviour__c='Yes', ObjectType__c = 'SampleObject1__c');
        if (create) {
            insert cpForm;
        }
        return cpForm;
    }

    public static CaptureSection__c getCaptureSectionConfig(Boolean create){
        CaptureForm__c cpFormVal = getCaptureFormConfig(true);
        CaptureSection__c cpSection = new CaptureSection__c(Name__c='Section 1',CaptureForm__c=cpFormVal.Id,Order__c=1,SectionColumn__c='Horizontal');
        if(create){
            insert cpSection;
        }
        return cpSection;
    }

    public static CaptureItem__c getCaptureItemConfig(Boolean create){
        CaptureSection__c cpSection = getCaptureSectionConfig(true);
        String dependentJson = '{"Controllingfields": "a1b2M000005M1ub","Dependentfields": [{"Question": "a1b2M000005M1uZ","Value": "No","Action": "NotRequired"}]}';
        CaptureItem__c cpItem = new CaptureItem__c(QuestionRichText__c='Demo Question',DependentQuestionJson__c=dependentJson,Type__c='Written',MaxScore__c=20,Order__c=1,CaptureSection__c=cpSection.Id);
        if(create){
            insert cpItem;
        }
        return cpItem;
    }
    public static CaptureAction__c getCaptureActionConfig(Boolean create ,Id formId){
        Id RecordTypeId = Schema.SObjectType.CaptureAction__c.getRecordTypeInfosByName().get('Custom Action').getRecordTypeId();
        CaptureAction__c cpAction = new CaptureAction__c(Name__c='CA-001' ,RecordTypeId=RecordTypeId, CaptureForm__c = formId,HideExpressionFields__c='SampleText1__c',HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"SampleText1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Test","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject1__c"}',Action__c='Action URL',ActionTarget__c='https://login.salesforce.com/',IsActive__c=true);
        if(create){
            insert cpAction;
        }
        return cpAction;
    }

    public static CaptureItemResponse__c getCaptureItemResponseConfig(Boolean create){
        CaptureItem__c cpItem = getCaptureItemConfig(true);
        CaptureItemResponse__c cpItemResponse = new CaptureItemResponse__c(Answer__c='Demo Val',Score__c=10,CaptureItem__c=cpItem.Id);
        if(create){
            insert cpItemResponse;
        }
        return cpItemResponse;
    }

    public static void createDisableRecordLocking(){       
        KeyValueStore__c keyValueRecord = KeyValueStore__c.getInstance('DisableRecordLocking');
        String description = 'To disable record locking';
        if(keyValueRecord != null){
            keyValueRecord.Description__c =  description ;
            update keyValueRecord;  
        }
        else
            insert new KeyValueStore__c(Name='DisableRecordLocking', BooleanValue__c=true, Description__c=description);  
    }

    public static ProcessDefinition getProcessDefination(){
        ProcessDefinition procDef = new  ProcessDefinition();
        procDef = [SELECT ID, Name, DeveloperName FROM ProcessDefinition WHERE DeveloperName = 'TestClassSampleApprovalProcess'];
        return procDef;
    }

    public static ProcessInstance getProcessInstance(){
        ProcessDefinition procDef = getProcessDefination();
        ProcessInstance procInstance = [SELECT Id FROM ProcessInstance WHERE ProcessDefinitionId =: procDef.Id LIMIT 1];
        return procInstance;
    }

    public static ProcessInstanceWorkItem getProcessInstanceWorkItem(){
        ProcessInstance procInstance = getProcessInstance();
        ProcessInstanceWorkItem workItem = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstanceId =: procInstance.Id LIMIT 1];
        return workItem;
    }

    public static List<ProcessInstanceNode> getProcessInstanceNodes(){
        List<ProcessInstanceNode> procInstNodeList = new  List<ProcessInstanceNode>();
        procInstNodeList = [SELECT Id,NodeStatus,ProcessNodeId,ProcessNodeName FROM ProcessInstanceNode WHERE ProcessNodeId='04b360000004WAq' and NodeStatus = 'Pending'];
        return procInstNodeList;
    }

    public static Id getStepId(String processDefName){
        Id processDefId = [SELECT Id,Name,DeveloperName FROM ProcessDefinition
                            WHERE DeveloperName =:processDefName LIMIT 1].Id;
        Id ApprovalStepId = [SELECT Id,Name,ProcessDefinitionId FROM ProcessNode
                             WHERE ProcessDefinitionId =: processDefId LIMIT 1].Id;
        return ApprovalStepId;
    }

    public static ApprovalProcessStepCache__c createApprovalProcessStepCache(Boolean create){
        ApprovalProcessStepCache__c apsc = new ApprovalProcessStepCache__c();
        SObjectConfig__c sObjCon =  getSObjectConfig(true);
        apsc.EnableTimeBaseApproval__c = true;
        apsc.Name = 'Approve';
        apsc.ApprovalStepId__c = getStepId('TestClassSampleApprovalProcess');
        apsc.StepName__c='Approve';
        apsc.SobjectText__c = sObjCon.Name;
        apsc.ProcessDefinitionName__c = 'TestClassSampleApprovalProcess';
        apsc.TimeForApproval__c = '{"min":1}';
        if(create){
            skipApprovalStepTrigger = true;
            insert apsc;
        }
        return apsc;
    }

    public static void createCaptureForm(){
        CaptureForm__c ccf = new CaptureForm__c();
        ccf.Name__c = 'Sample Form Test';
        ccf.ObjectType__c = 'SampleObject1__c';
        insert ccf;
    }

    public static String getKeyValueStoreStringValue(String keyName){
        String resultVal = '';
       return resultVal = [SELECT TextValue__c,Name FROM KeyValueStore__c WHERE Name=: keyName LIMIT 1].TextValue__c;
    }

    public static Map<String,Object> setupCustomMetadataTextValueMap(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('HeaderLogoAllignment','Right');
        fieldValueMap.put('FeedbackSupportEmail','GovBDsupport@reisystems.com');
        fieldValueMap.put('Description__c','FeedbackSupportEmail Holder');
        return fieldValueMap;
    }

    public static Map<String,Object> setupCustomMetadataBooleanValueMap(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('RenderDownloadPDFMenuAsButton',true);
        fieldValueMap.put('RenderModalDownloadPDFMenuAsButton',false);
        fieldValueMap.put('Description__c','RenderModalDownloadPDFMenuAsButton Holder');
        return fieldValueMap;
    }

    public static Map<String,Object> setupCustomMetadataDateValueMap(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Date myDate = Date.newInstance(2020, 5, 4);
        fieldValueMap.put('ProgramValidate Date',myDate);
        fieldValueMap.put('Description__c','ProgramValidate Date Holder');
        return fieldValueMap;
    }

    public static Map<String,Object> setupCustomMetadataDateTimeValueMap(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Datetime myDateTime = Datetime.newInstance(2020, 2, 17);
        fieldValueMap.put('ProgramValidate Date Time',myDateTime);
        fieldValueMap.put('Description__c','ProgramValidate Date Time Holder');
        return fieldValueMap;
    }

    public static Map<String,Object> setupCustomMetadataDecimalValueMap(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Decimal decMalVal = 34.50;
        fieldValueMap.put('Program IncomeVal',decMalVal);
        fieldValueMap.put('Description__c','Program IncomeVal Decimal Value Holder');
        return fieldValueMap;
    }

    public static Map<String,Object> setupCustomMetadataIntegerValueMap(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Integer intVal = 4;
        fieldValueMap.put('Chart PerPhase',intVal);
        fieldValueMap.put('Description__c','Chart PerPhase Integer Value Holder');
        return fieldValueMap;
    }

    public static ApexJob__c getApexJob(Boolean create){
        ApexJob__c apexJob = new ApexJob__c();
        apexJob.Name = 'Test for Schedule';
        apexJob.ClassName__c = 'DelegateApprovarTaskCreationBatch';
        apexJob.IntervalMins__c = 2;
        apexJob.CronExpression__c = '0 0 0 3 9 ? 2022';
        apexJob.BatchSize__c = 1;
        apexJob.Active__c = true;
        if(create){
            insert apexJob;
        }
        return apexJob;
    }

    public static DynamicLayoutHolder getDynamicLayoutHolder(){
       PageTemplate__c pgTempVal =  getPageTemplateConfig(True);
        SampleObject11__c sampleObject11 = getSampleObject1(true);
        SampleObject12__c sampleObject12 = getSampleObject2(true,sampleObject11.Id);
        String printLayoutId = pgTempVal.PrintLayoutConfig__c;
        DynamicLayoutHolder dynamicHolder;
        dynamicHolder = new DynamicLayoutHolder(printLayoutId, sampleObject12.Id, true);
        return dynamicHolder;
    }

    public static PageLayoutConfigHelper getPageLayoutConfigHelper(){
        PageLayoutConfigHelper pageLayoutHelper;
        PageLayoutConfig__c pagelayoutObj = getPageLayoutConfig(true);
        pageLayoutHelper = new PageLayoutConfigHelper(pagelayoutObj.Id,true);
        return pageLayoutHelper;
    }


}