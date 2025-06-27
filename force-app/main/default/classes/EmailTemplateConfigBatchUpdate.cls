/*Adding with sharing for SFDC security review */
global with sharing class EmailTemplateConfigBatchUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchableCon) {
        List<EmailTemplateConfig__c> emailConfig = [select id,EmailTemplateDeveloperName__c from 
                                            EmailTemplateConfig__c WHERE Id!= NULL WITH USER_MODE];
        
        List<String> emailTemplateNames = new List<String>();
        for(EmailTemplateConfig__c config : emailConfig){
            emailTemplateNames.add(string.escapeSingleQuotes(config.EmailTemplateDeveloperName__c));
        }
        String query;
        String folderQuery;
        List<Folder> folders = new List<Folder>();
        String folderList = KeyValueStoreHelper.getTextValue('EmailTemplateMigrationFolder',true);
        List<String> folderLst = folderList .split(',');
        List<String> folderLstSanitized = new List<String>();
        for(String str : folderLst){
            folderLstSanitized.add(string.escapeSingleQuotes(str));
        }
        String typeOfFolder = 'Email';
        if(!String.isEmpty(folderList)){
            folderQuery = 'select id from Folder where Name in:folderLstSanitized and Type =:typeOfFolder';
            folders = Database.query(String.escapeSingleQuotes(folderQuery),AccessLevel.USER_MODE);
        }
        
        if(emailTemplateNames.size () > 0){
            query = 'select id,name,developerName,body from EmailTemplate where DeveloperName not in :emailTemplateNames';
            if(folders.size () > 0){
                query += ' and FolderId in :folders WITH USER_MODE';
            }
        }else{
            query = 'select id,name,developerName,body from EmailTemplate';     
            if(folders.size () > 0){
                query += ' where FolderId in :folders WITH USER_MODE';
            }   
        }        
        if(!String.isEmpty(query)){
            query += ' LIMIT '+AppUtils.SOQL_LIMIT_FOR_BATCH;
            return Database.getQueryLocator(query);
        }
        return null;
       
    }
    
    global void execute(Database.BatchableContext batchableCon, List<sObject> scope) {
        List<EmailTemplateConfig__c> configs = new List<EmailTemplateConfig__c>();
        for(sobject s : scope){
             EmailTemplateConfig__c config = new EmailTemplateConfig__c();
             if(Schema.sObjectType.EmailTemplateConfig__c.fields.Name.isCreateable() && Schema.sObjectType.EmailTemplateConfig__c.fields.Name.isUpdateable()){
                config.Name = String.valueOf(s.get('Name'));
             }
             if(Schema.sObjectType.EmailTemplateConfig__c.fields.EmailTemplateDeveloperName__c.isCreateable() && Schema.sObjectType.EmailTemplateConfig__c.fields.EmailTemplateDeveloperName__c.isUpdateable()){
                config.EmailTemplateDeveloperName__c = String.valueOf(s.get('DeveloperName'));
             }
             if(!String.isEmpty(String.valueOf(s.get('body')))){
                List<String>mergeFields = AppUtils.getMergeFields(String.valueOf(s.get('body')));
                if(mergeFields.size () > 0){
                    String objectName = mergeFields[0].split('\\.')[0];
                    if(Schema.sObjectType.EmailTemplateConfig__c.fields.SobjectName__c.isCreateable() && Schema.sObjectType.EmailTemplateConfig__c.fields.SobjectName__c.isUpdateable()){
                        config.SobjectName__c = objectName;
                    }
                }
             }
             configs.add(config); 
        }
        if(Schema.sObjectType.EmailTemplateConfig__c.isCreateable() && Schema.sObjectType.EmailTemplateConfig__c.isUpdateable()){
            upsert as user configs;
        }
    }
    
    global void finish(Database.BatchableContext batchableCon) {
        BatchApexJobScheduler.abortObsoleteScheduledJobEntries(batchableCon.getJobId());
        EmailTemplateConfigBatchUpdate batch = new EmailTemplateConfigBatchUpdate ();
        Integer interval = KeyvalueStoreHelper.getIntegerValue('EmailTemplateMigrationScheduleInterval',true);
        String cronExpression = BatchApexJobScheduler.prepareJobsSchTime(System.now(),interval);
        String jobName = BatchApexJobScheduler.getUniqueJobName('EmailTemplateConfigBatchUpdate');
        if (!Test.isRunningTest()) {
            System.schedule(jobName, cronExpression, new BatchApexJobScheduler(batch, 1));
        }
    }

}