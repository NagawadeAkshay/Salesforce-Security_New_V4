public with sharing class MassEmailCtrl {
    public with sharing class MassEmailCtrlException extends Exception {}
    
    @AuraEnabled
    public static Map<String, Object> getPageData(String objectAPIName){
        Map<String, Object> mapPageData = new Map<String, Object>();
        mapPageData.put('namespace', AppUtils.getNameSpacePrefix());
        List<MassEmailObject> lstObjects = new List<MassEmailObject>();
        
        for(Schema.SObjectType objType : Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult objectResult = objType.getDescribe();
            String objectName = objectResult.getName();            
            if((!objectName.containsignorecase('history') && !objectName.containsignorecase('tag') && !objectName.containsignorecase('share') && !objectName.containsignorecase('feed'))){
                lstObjects.add(new MassEmailObject(objectName, objectResult.getLabel()));
            }            
        }
        lstObjects.sort();
        mapPageData.put('objects', lstObjects);
        mapPageData.put('listviews', getObjectListViews(objectAPIName));
        mapPageData.put('objectFields', getObjectFields(objectAPIName));
        return mapPageData;
    }
    
    public with sharing class MassEmailObject implements Comparable {
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        
        public MassEmailObject(String name, String label){
            this.name = name;
            this.label = label;
            this.value = name;
        }
        
        public Integer compareTo(Object objMassEmail) {
            return label.compareTo(((MassEmailObject)objMassEmail).label);
        }
    }
    
    public with sharing class MassEmailListView implements Comparable {
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String objectName {get;set;}
        @AuraEnabled
        public String visibility {get;set;}
        @AuraEnabled
        public List<Object> filterList {get;set;}
        @AuraEnabled
        public List<String> columnFields {get;set;}
        
        public MassEmailListView() {}
        
        public MassEmailListView(String name, String label){
            this.name = name;
            this.label = label;
            this.value = name;
        }
        
        public Integer compareTo(Object objMassEmail) {
            return label.compareTo(((MassEmailListView)objMassEmail).label);
        }
    }
    
    @AuraEnabled
    public static List<MassEmailListView> getObjectListViews(String objectAPIName){
        List<MassEmailListView> lstObjectListViews = new List<MassEmailListView>();
        for(ListView objListView : [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType, IsSoqlCompatible FROM ListView WHERE SobjectType =:objectAPIName]){//NOPMD CRUD  FLS- False +ve - Std obj  - will not check permission here  
            lstObjectListViews.add(new MassEmailListView(objListView.DeveloperName, objListView.Name));
        }
        lstObjectListViews.sort();
        return lstObjectListViews;
    }
    
    public with sharing class MassEmailTemplate implements Comparable {
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String body {get;set;}
        @AuraEnabled
        public String htmlValue {get;set;}
        @AuraEnabled
        public String markup {get;set;}
        @AuraEnabled
        public String subject {get;set;}
        
        public MassEmailTemplate(String name, String label, String body, String htmlValue, String markup, String subject){
            this.name = name;
            this.label = label;
            this.value = name;
            this.body = body;
            this.htmlValue = htmlValue;
            this.markup = markup;
            this.subject = subject;
        }
        
        public Integer compareTo(Object objMassEmailTemplate) {
            return label.compareTo(((MassEmailTemplate)objMassEmailTemplate).label);
        }
    }
    
    public with sharing class ListViewFilterCriteria{
        @AuraEnabled
        public String field {get;set;}
        @AuraEnabled
        public String operator {get;set;}
        @AuraEnabled
        public String value {get;set;}
        
        public ListViewFilterCriteria(String field, String operator, String value){
            this.field = field;
            this.operator = operator;
            this.value = value;
        }
    }
    
    @AuraEnabled
    public static Map<String, Object> getListViewResult(String objectName, String listviewName){
        listviewName = listviewName;
        Map<String, Object> mapListViewResult = new Map<String, Object>();
        ListView lstView = new ListView();
		lstView = [SELECT Id from ListView where DeveloperName =:listviewName and SobjectType =:objectName];//NOPMD CRUD  FLS- False +ve - Std obj  - will not check permission here 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ApexMDApi' + '/services/data/v52.0/sobjects/' + objectName + '/listviews/' + lstView.Id + '/describe');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res =  new System.Http().send(req);
        String responseBody = res.getBody();
        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        mapListViewResult.put('response', response);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        
        // Read List View definition
        MetadataService.ListView listView = (MetadataService.ListView) service.readMetadata('ListView', new String[] { objectName+'.'+listviewName }).getRecords()[0];
        if(listView.filters != null){
            List<ListViewFilterCriteria> filterList = new List<ListViewFilterCriteria>();
            for(MetadataService.ListViewFilter filter : listView.filters){
                filterList.add(new ListViewFilterCriteria(filter.field, filter.operation, string.escapeSingleQuotes(filter.value)));
            }
            mapListViewResult.put('filters', filterList);
        }
        if(listView.columns != null){
            List<String> columns = new List<String>();
            for(String column : listView.columns){
                columns.add(column);
            }
            mapListViewResult.put('columns', columns);
        }
            
        
        String query = response != null && response.containsKey('query') ? String.valueOf(response.get('query')) : null;
        if(String.isNotBlank(query)){
            if(query.contains(', Id, CreatedDate, LastModifiedDate, SystemModstamp')){
                query = query.remove(', Id, CreatedDate, LastModifiedDate, SystemModstamp');
            }
            mapListViewResult.put('records', Database.query(query));//NOPMD SOQL Injection - False +ve - escapeSingleQuotes Applied on filterList values using  AppUtils.parseWhereClause method to prevent SOQL injection
        }
        
        List<MassEmailTemplate> lstEmailTemplates = new List<MassEmailTemplate>();
        Map<String, MassEmailTemplate> mapEmailTemplates = new Map<String, MassEmailTemplate>();
        for(EmailTemplate objEmailTemplate : [SELECT Id, Name, DeveloperName, NamespacePrefix, IsActive, TemplateStyle, TemplateType, Subject, HtmlValue, Body, Markup, RelatedEntityType FROM EmailTemplate WHERE Folder.Name = 'MassEmail' AND IsActive = true]){//CRUD  FLS- False +ve - Std obj  - will not check permission here 
            lstEmailTemplates.add(new MassEmailTemplate(
                objEmailTemplate.Id,
                objEmailTemplate.Name,
                objEmailTemplate.Body,
                objEmailTemplate.HtmlValue,
                objEmailTemplate.Markup,
                objEmailTemplate.Subject
            ));
            mapEmailTemplates.put(objEmailTemplate.Id, new MassEmailTemplate(
                objEmailTemplate.Id,
                objEmailTemplate.Name,
                objEmailTemplate.Body,
                objEmailTemplate.HtmlValue,
                objEmailTemplate.Markup,
                objEmailTemplate.Subject
            ));
        }
        mapListViewResult.put('templates', lstEmailTemplates);
        mapListViewResult.put('templateMap', mapEmailTemplates);
        String tempName = 'AllContacts';
        List<ListView> objListView = [SELECT Id, Name, DeveloperName FROM ListView WHERE DeveloperName =: tempName];//NOPMD CRUD  FLS- False +ve - Std obj  - will not check permission here 
        if(objListView.size() > 0){
            mapListViewResult.put('metadata', objListView[0]);
        }        
        return mapListViewResult;
    }
    
    @AuraEnabled
    public static List<Map<String, Object>> getObjectFields(String objectName){        
        List<Map<String, Object>> lstObjectFields = new List<Map<String, Object>>();
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Name', 'value' => 'FULL_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'First Name', 'value' => 'CONTACT.FIRST_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Last Name', 'value' => 'CONTACT.LAST_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Account Name', 'value' => 'ACCOUNT.NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Email', 'value' => 'CONTACT.EMAIL' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Birthdate', 'value' => 'CONTACT.BIRTHDATE' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Owner First Name', 'value' => 'CORE.USERS.FIRST_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Created Date', 'value' => 'CONTACT.CREATED_DATE' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Owner Last Name', 'value' => 'CORE.USERS.LAST_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Reports To Last Name', 'value' => 'CONTACT.REPORTS_TO.LAST_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Reports To First Name', 'value' => 'CONTACT.REPORTS_TO.FIRST_NAME' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Account: Type', 'value' => 'ACCOUNT.TYPE' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Account: Account Record Type', 'value' => 'ACCOUNT.RECORDTYPE' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Account: Website', 'value' => 'ACCOUNT.URL' });
        lstObjectFields.add(new Map<String, Object>{ 'label' => 'Languages', 'value' => 'LANGUAGES__c' });
        
        return lstObjectFields;
    }
    
    @AuraEnabled
    public static List<sObject> fetchEmailTemplates(){
        String queryString = 'SELECT Id, Name, Body, Subject FROM EmailTemplate WHERE IsActive = true AND RelatedEntityType = \'Contact\'';//CRUD  FLS- False +ve - Std obj  - will not check permission here 
        List<sObject> lstRecords = Database.query(queryString);//SOQL Injection - False +ve - As queryString doesn't have any dynamic part.
        return lstRecords;
    }
    
    public with sharing class ListViewFilter {
        @AuraEnabled
        public String field {get;set;}
        @AuraEnabled
        public String operator {get;set;}
        @AuraEnabled
        public String value {get;set;}
        
        public ListViewFilter(){}
    }
    
    @AuraEnabled
    public static void saveListViewRecord(MassEmailListView record, Boolean isEdit, List<ListViewFilter> filterList){
       try{
            record.objectName = record.objectName.toUpperCase();     
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            MetadataService.ListView listView = new MetadataService.ListView();
            String namespacePrefix = [SELECT NamespacePrefix FROM Organization WITH USER_MODE LIMIT 10000].NamespacePrefix;//CRUD  FLS- False +ve - Std obj  - will not check permission here 
            if(isEdit && namespacePrefix != null){
                namespacePrefix = namespacePrefix + '__';
            }else {
                namespacePrefix = '';
            }
            listView.fullName = record.objectName+'.' + namespacePrefix + record.name;
            listView.label = record.label;
            List<MetadataService.ListViewFilter> listViewFilter = new List<MetadataService.ListViewFilter>();
            for(ListViewFilter filterObj : filterList){
                MetadataService.ListViewFilter filter = new MetadataService.ListViewFilter();
                filter.field = filterObj.field;
                filter.operation = filterObj.operator;
                filter.value = filterObj.value;
                listViewFilter.add(filter);
            }
            
            listView.filters = listViewFilter;//getFilter(filterList);//filterListToAdd;
            listView.filterScope = 'Everything';
            listView.columns = record.columnFields;//columnList;
            List<MetadataService.SaveResult> results;
            if(isEdit){
                results = service.updateMetadata(new MetadataService.Metadata[] { listView });
            } else {
                results = service.createMetadata(new MetadataService.Metadata[] { listView });
            }
            handleSaveResults(results[0]);
        } catch(Exception objException){
            throw new MassEmailCtrlException(LightningUtilityCtrl.parseExceptionMsg(objException.getMessage()));
        }
    }
    
    @AuraEnabled
    public static List<MetadataService.DeleteResult> deleteListView(String objectName, String listviewName){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        String namespacePrefix = [SELECT NamespacePrefix FROM Organization WITH USER_MODE LIMIT 10000].NamespacePrefix;//CRUD  FLS- False +ve - Std obj  - will not check permission here 
        if(namespacePrefix != null){
            namespacePrefix = namespacePrefix + '__';
        }else{
            namespacePrefix = '';
        }
        List<MetadataService.DeleteResult> results = service.deleteMetadata('ListView', new String[] { objectName+'.'+namespacePrefix+listviewName });
        return results;
    }
    
    @AuraEnabled
    public static void deleteListViewRecord(String objectName, String devloperName){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        String namespacePrefix = [SELECT NamespacePrefix FROM Organization WITH USER_MODE LIMIT 10000].NamespacePrefix;//CRUD  FLS- False +ve - Std obj  - will not check permission here 
        if(namespacePrefix != null){
            namespacePrefix = namespacePrefix + '__';
        }else{
            namespacePrefix = '';
        }
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'ListView', new String[] { objectName+'.'+namespacePrefix+devloperName });
        handleDeleteResults(results[0]);
    }
    

@AuraEnabled
public static List<ListView> getListViews() {
    List<ListView> listviews =
        [SELECT Id, Name FROM ListView WHERE SobjectType = 'Contact'];//NOPMD CRUD  FLS- False +ve - Std obj  - will not check permission here 

    // Perform isAccessible() check here
    return listviews;
}
    private with sharing class queryWrapper{
        String query{get;set;}
    }
    
    public static void handleDeleteResults(MetadataService.DeleteResult deleteResult){
        // Nothing to see?
        if(deleteResult==null || deleteResult.success)
            return;
        if(deleteResult.errors!=null){
            List<String> messages = new List<String>();
            for(MetadataService.Error error : deleteResult.errors)
                messages.add( error.message );
            if(messages.size() > 0)
                throw new MassEmailCtrlException(String.join(messages, ' '));
        }
        if(!deleteResult.success){
            throw new MassEmailCtrlException('Request failed with no specified error.');
        }
    }
    
    public static void handleSaveResults(MetadataService.SaveResult saveResult){
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null){
            List<String> messages = new List<String>();
            for(MetadataService.Error error : saveResult.errors)
                messages.add( error.message );
            if(messages.size()>0)
                throw new MassEmailCtrlException(String.join(messages, ' '));
        }
        if(!saveResult.success){
            throw new MassEmailCtrlException('Request failed with no specified error.');
        }
    }
    
    @AuraEnabled
    public static void sendMassEmail(String templateId, List<String> recipientIds){
        if(recipientIds.size() > 0 && templateId != null && templateId != ''){
            try{
                Messaging.MassEmailMessage emails=new Messaging.MassEmailMessage();
                emails.setTargetObjectIds(recipientIds);
                emails.setTemplateId(templateId);
                //emails.setsubject('note');
                emails.saveAsActivity = false;
                Messaging.SendEmail(New Messaging.MassEmailMessage[]{emails});
            } catch(Exception objException){
                throw new MassEmailCtrlException(LightningUtilityCtrl.parseExceptionMsg(objException.getMessage()));
            }
        }else{
            throw new MassEmailCtrlException('Problem in recipients or email template');
        }
    }
}