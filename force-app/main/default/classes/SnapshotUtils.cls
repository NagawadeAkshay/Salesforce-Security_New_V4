/**
* Class to take a snapshot of the record data at the current state for a given parent record id and clone it 
*
* CHANGE HISTORY
* =============================================================================
* Date              Name                        Description
* 02/10/2014        Vineeth Shetty              Created
* 09/09/2015        Shah Kadirmohideen          Repurposed this class for history PDF
* =============================================================================
*/



global with sharing class SnapshotUtils {
   public static string skipRedirect;
    
    global static String createSnapshot(Id recordId, String templateName, String flexTableParameter, String listParams) {
        return createSnapshot(recordId, templateName, flexTableParameter, listParams, recordId);
    }
    
    global static String createSnapshot(Id recordId, String templateName, String flexTableParameter, String listParams, Id targetRecordId) {                                                                 
        return createSnapshot(recordId, templateName, flexTableParameter, listParams, targetRecordId, null, null);
    }
    
    global static String createSnapshot(Id recordId, String templateName, String flexTableParameter, String listParams, Id targetRecordId,String classification,String attachmentName) { 
        return createSnapshot(recordId, templateName, flexTableParameter, listParams, targetRecordId, classification, attachmentName, null);
    }

    global static String createSnapshot(Id recordId, String templateName, String flexTableParameter, String listParams, Id targetRecordId,String classification,String attachmentName, String attachmentType) {                                                                 
        String url;
        PageReference pdfPage;
        String objName = recordId.getSobjectType().getDescribe().getName();
        if(AppUtils.isObjectUpdateable(objName)){
            url =  getTemplateName(templateName) + '?id=' +
            recordId + '&viewTemplateName=' + templateName + '&flexTableParam=' + SFDCEncoder.SFDC_URLENCODE(flexTableParameter) + '&listParm=' +
            ((String.isNotEmpty(listParams) && listParams!='null') ? listParams : '')+skipRedirect;
    
            if(String.valueOf(url).startsWith('/')){
                String.valueOf(url).replaceFirst('/','');
            }
             pdfPage = new PageReference(EncodingUtil.urlEncode(url,'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
        }

        Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
        if(isSalesforceFileEnabled == null){
            isSalesforceFileEnabled = false;
        }

        if(isSalesforceFileEnabled){
            ContentVersion cvFile = AttachmentUtils.exportAsFilePDF(pdfPage, targetRecordId,
            (classification == null ? 'History' : classification  ), null, (attachmentName == null ? 'SnapShot on ' + System.now().format() : attachmentName), attachmentType);
            return cvFile.Id;
        }else{
        Attachment att = AttachmentUtils.exportAsPDF(pdfPage, targetRecordId,
            (classification == null ? 'History' : classification  ), null, (attachmentName == null ? 'SnapShot on ' + System.now().format() : attachmentName), attachmentType);//'SnapShot on ' + System.now().format()
        return att.Id;
    }
    }
    
    
    public static String createSnapshot(Id recordId, String templateName, String flexTableParameter, String listParams,
                String pkgId, List<String> formTypes, String parentLayId, String classification) {
       
        Map<string,object> stringMap = new Map <string,object>();
        String fileName = '';
        if(flexTableParameter!=null && flexTableParameter!=''){
            stringMap = (Map<string,object>)JSON.deserializeUntyped(flexTableParameter);
            if(stringMap!=null){
                if(stringMap.get('SnapshotName')!=null){
                    fileName = (String)stringMap.get('SnapshotName');
                }
            }
        }
        
        String url = getTemplateName(templateName)+'?id=' +
                recordId + '&viewTemplateName=' +  templateName + '&flexTableParam=' + SFDCEncoder.SFDC_URLENCODE(flexTableParameter) + '&listParm=' +
                ((String.isNotEmpty(listParams) && listParams!='null') ? listParams : '') +
                ((formTypes != null && formTypes.size() > 0) ? '&formTypes='+JSON.serialize(formTypes) : '') +
                (parentLayId != null ? '': ((String.isNotEmpty(pkgId)) ? '&packageId='+pkgId : '')) + skipRedirect;
        PageReference pdfPage = new PageReference(EncodingUtil.urlEncode(url,'UTF-8')); //ApexOpenRedirect  - False +Ve - We are using custom method for encoding

         Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
        if(isSalesforceFileEnabled == null){
            isSalesforceFileEnabled = false;
        }

        if(isSalesforceFileEnabled){
            ContentVersion cvFile = AttachmentUtils.exportAsFilePDF(pdfPage, recordId,
            (classification == null ? 'History' : classification  ), null, (fileName != '' ? fileName+' ' + System.now().format():'SnapShot on ' + System.now().format()), 'History');
            return cvFile.Id;
        }else{
            Attachment att = AttachmentUtils.exportAsPDF(pdfPage, recordId,
            (classification == null ? 'History' : classification  ), null, (fileName != '' ? fileName+' ' + System.now().format():'SnapShot on ' + System.now().format()), 'History');//'SnapShot on ' + System.now().format()
        return att.Id;
        }
    }
   
    public static SObject createSnapshot(Id recordId, String templateName, String flexTableParameter, String listParams, Id targetRecordId,String classification,String attachmentName, String attachmentType , Boolean extraPraram) {                                                                 
        String url;
        PageReference pdfPage;
        String objName = recordId.getSobjectType().getDescribe().getName();
        if(AppUtils.isObjectUpdateable(objName)){
            url =  getTemplateName(templateName) + '?id=' +
            recordId + '&viewTemplateName=' + templateName + '&flexTableParam=' + SFDCEncoder.SFDC_URLENCODE(flexTableParameter) + '&listParm=' +
            ((String.isNotEmpty(listParams) && listParams!='null') ? listParams : '')+skipRedirect;
    
            if(String.valueOf(url).startsWith('/')){
                String.valueOf(url).replaceFirst('/','');
            }
             pdfPage = new PageReference(EncodingUtil.urlEncode(url,'UTF-8'));
        }

        Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
        if(isSalesforceFileEnabled == null){
            isSalesforceFileEnabled = false;
        }

        if(isSalesforceFileEnabled){
            ContentVersion cvFile = AttachmentUtils.exportAsFilePDF(pdfPage, targetRecordId,
            (classification == null ? 'History' : classification  ), null, (attachmentName == null ? 'SnapShot on ' + System.now().format() : attachmentName), attachmentType);
            return cvFile;
        }else{
            Attachment att = AttachmentUtils.exportAsPDF(pdfPage, targetRecordId,
                (classification == null ? 'History' : classification  ), null, (attachmentName == null ? 'SnapShot on ' + System.now().format() : attachmentName), attachmentType);//'SnapShot on ' + System.now().format()
            return att;
        }
    }
    global static void historyPostAction(String actionId, Id recordId, String templateName, 
            String flexTableParameterJSON, String listParams) {
         PageLayoutActionConfig__c actionConfig = loadAction(actionId);
         if (actionConfig != null) {
            if (actionConfig.HistoryPostAction__c) {
                Boolean enableHistory = true;
                if (String.isNotEmpty(actionConfig.HistoryPostActionCondition__c)) {
                    String soql = 'Select ' + String.escapeSingleQuotes(actionConfig.HistoryPostActionCondition__c) + 
                        ' from ' + String.escapeSingleQuotes(actionConfig.PageLayoutConfig__r.ObjectAPIName__c) +
                         ' where Id=\'' +String.escapeSingleQuotes(recordId) + '\'';
                    SObject record; 
                    if(AppUtils.isObjectAccessible(actionConfig.PageLayoutConfig__r.ObjectAPIName__c)){  //CRUD/FLS False +ve with the help of AppUtils we have performed check
                         record = Database.query(soql, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection
                    }
                    enableHistory = (Boolean) record.get(actionConfig.HistoryPostActionCondition__c);
                }
                if (enableHistory) {
                    String url = getTemplateName(String.escapeSingleQuotes(templateName))+'?id=' +
                        recordId + '&viewTemplateName=' + 
                        templateName + '&flexTableParam=' +
                        SFDCEncoder.SFDC_URLENCODE(flexTableParameterJSON)+ '&listParm=' + 
                        ((String.isNotEmpty(listParams) && listParams!='null') ? listParams : '');      
                    PageReference pdfPage = new PageReference(EncodingUtil.urlEncode(url,'UTF-8'));  //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
                    String historyClassification = String.isNotEmpty(actionConfig.HistoryPostActionClassification__c) ? actionConfig.HistoryPostActionClassification__c : 'History';          

                    // Custom Setting for getting Salesforce File.....
                     Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
                     if(isSalesforceFileEnabled == null){
                            isSalesforceFileEnabled = false;
                        }

	       				 // Genrating Snap Shot on bases of Files or Attachment.
	       				if(isSalesforceFileEnabled){
	       					AttachmentUtils.exportAsFilePDF(pdfPage, recordId,
                        		historyClassification, actionConfig.HistoryPostActionPDFFilename__c, 'History',null);
	   				 	}else{
                    AttachmentUtils.exportAsPDF(pdfPage, recordId,
                        historyClassification,null,actionConfig.HistoryPostActionPDFFilename__c,'History');
	   				 	}
                    }
                }
            }
        }
    global static void approvalSnapshot(Id stepWorkItemId, Id recordId, String templateName, 
            String flexTableParameterJSON, String listParams,String fileName) {
                    String url = getTemplateName(String.escapeSingleQuotes(templateName))+'?id=' +
                recordId + '&viewTemplateName=' + 
                        templateName + '&flexTableParam=' +
                          SFDCEncoder.SFDC_URLENCODE(flexTableParameterJSON) + '&listParm=' + 
                ((String.isNotEmpty(listParams) && listParams!='null') ? listParams : '') +'&isSnapshot=true'+skipRedirect;      
                        PageReference pdfPage = new PageReference(EncodingUtil.urlEncode(url,'UTF-8'));  //ApexOpenRedirect  - False +Ve - We are using custom method for encoding     
                    // Custom Setting for getting Salesforce File.....
                     Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
                     if(isSalesforceFileEnabled == null){
                            isSalesforceFileEnabled = false;
                        }

       				 ContentVersion cvFile;
       				 Attachment attchPdf;

       				 // Genrating Snap Shot on bases of Files or Attachment..
       				if(isSalesforceFileEnabled){
						cvFile = AttachmentUtils.exportAsApprovalFilePDF(pdfPage, recordId,'History',fileName);						       					
       				}else{
       					 attchPdf = AttachmentUtils.exportAsPDF(pdfPage, recordId,'History',fileName);
       				}

                    if(attchPdf !=null || cvFile !=null){
                        if(Schema.sObjectType.ApprovalSnapshot__c.fields.attachmentId__c.isCreateable() &&
                            Schema.sObjectType.ApprovalSnapshot__c.fields.parentId__c.isCreateable()){
                    		ApprovalSnapshot__c aSnapshot = new ApprovalSnapshot__c(Name=stepWorkItemId,attachmentId__c = attchPdf.id != null? attchPdf.id : cvFile.id,parentId__c = recordId);
                        	if(ApprovalSnapshot__c.sObjectType.getDescribe().isCreateable()){
                            	insert as user aSnapshot;
        					}
                    	}    
                    }    
    
    }
    
                
    /* PRIVATE METHODS */

    private static PageLayoutActionConfig__c loadAction(String actionId) {
        if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
         return [Select Id, HistoryPostAction__c, HistoryPostActionCondition__c, HistoryPostActionPDFFilename__c, HistoryPostActionClassification__c, PageLayoutConfig__r.ObjectAPIName__c 
                    FROM PageLayoutActionConfig__c WHERE Id=:actionId WITH USER_MODE ];
        }else{
            return new PageLayoutActionConfig__c();
        }
    }

    
    private static String getTemplateName(String templateName) {
        String pageTemplateName = '';
        List<PageTemplate__c> templateConfigList = new List<PageTemplate__c>();
        if(Schema.sObjectType.PageTemplate__c.isAccessible()){
        templateConfigList = [SELECT PrintLayoutConfig__c ,PrintLayoutConfig__r.ObjectAPIName__c,
                                                           PrintLayoutConfig__r.PDFRenderType__c,ExportPageName__c
                                                                            FROM PageTemplate__c 
                                                                             WHERE NAME = :templateName WITH USER_MODE
                                                                            LIMIT 1];
        }                                                                                                                                    
       if(templateConfigList.size() > 0){
        if(String.isNotBlank(templateConfigList[0].ExportPageName__c) && !(templateConfigList[0].ExportPageName__c.contains('DynamicLayoutExport_MultipleForms'))){ 
          pageTemplateName+= AppUtils.getPdfRedirectionURL()+''+((templateConfigList[0].ExportPageName__c));
        }
        else{
            skipRedirect = '&skipRedirect=true';
            pageTemplateName+= '/apex/'+AppUtils.getNameSpacePrefix() + 'DynamicLayoutExport'; 
         }
        }  
        else{
          pageTemplateName+= '/apex/'+AppUtils.getNameSpacePrefix() + 'DynamicLayoutExport'; 
        }
        
        return pageTemplateName;
    
    }
 }