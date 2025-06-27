/*
    Created By    : Amol Darekar
    Created Date  : 27th Aug 2018
    Modified Date : 06th sept 2018
    Purpose: This class is used to export the contents of a Dynamic Layout Page in a PDF.
   4/21/2023 by removing Sessionid we are deprecating this functionality if in future we do not 
   received any bug related to this then we can comment out this class
   we are removing sessionid for security review
    */
public with sharing class DynamicLayoutExportMultipleFormsCtrl{
    //Properties declaration
    public transient ID recordId{get;set;}
    public String pkagId {get;set;}
    public String formInstanceJSON {get;set;}
    public String viewTemplateName {get;set;}
    public List<FormInstance__c> formInstanceList{get;set;}
    public string flexTableParam {get;set;}
    public String listParm{get;set;}
    public string pkgNameSpancePrefix{get;set;}
    public String formTypes{get;set;}
    public Integer iTextPollCounter {get;set;}
    public String sessionId {get;set;}

    // public string exportPageName{get;set;}
    //Constructor to get all form with its package
    public DynamicLayoutExportMultipleFormsCtrl() {
        
        recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        pkagId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('packageId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        viewTemplateName = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('viewTemplateName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        flexTableParam = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('flexTableParam'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        listParm = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('listParm'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            formTypes = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('formTypes'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 

        List<String> formTypeList = new List<String>();
        
        if(formTypes != '()'){
                formTypeList  = (List<String>)JSON.deserialize(SFDCEncoder.SFDC_JSDECODE(formTypes), List<String>.class);   // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.SFDC_JSDECODE 
        }
        
        //Get the form information to pass as parameters in url to DynamicLayoutExport page.  
        if(formTypeList.size() == 0){
            formInstanceJSON = JSON.serialize([SELECT Id, FormId__c, ParentRecordId__c, PackageBusinessForm__r.FormConfig__r.Name,PackageBusinessForm__r.FormConfig__r.ExportPageName__c , PackageBusinessForm__r.FormConfig__r.PrintLayoutConfig__r.Name
                                                            FROM FormInstance__c 
                                                            WHERE FormId__c !=: NULL AND ParentRecordId__c =: recordId AND PackageBusinessForm__c != NULL
                                                            WITH USER_MODE]);
        }else{
                formInstanceJSON = JSON.serialize([SELECT Id, FormId__c, ParentRecordId__c, PackageBusinessForm__r.FormConfig__r.Name,PackageBusinessForm__r.FormConfig__r.ExportPageName__c , PackageBusinessForm__r.FormConfig__r.PrintLayoutConfig__r.Name
                                                                FROM FormInstance__c 
                                                                WHERE PackageBusinessForm__r.FormConfig__r.FormType__c IN: formTypeList AND FormId__c !=: NULL AND ParentRecordId__c =: recordId AND PackageBusinessForm__c != NULL
                                                                WITH USER_MODE]);
        }

        //PackageBusinessForm__r.PackageConfig__c =:pkagId AND
                                                        
        pkgNameSpancePrefix = AppUtils.getNameSpacePrefix();
        
        //Max polling limit for the request.
        iTextPollCounter = KeyValueStoreHelper.getIntegerValue('iTextPollCounter',true);
        iTextPollCounter = iTextPollCounter == null ? 20 : iTextPollCounter;
    }

    //This function is used to store Form PDF into page data holder object record
    //public static Map<String, Object> saveFormPDF(Map<String, Object> urlParamMap){
    @RemoteAction
    public static Map<String, Object> saveFormPDF(Map<String, Object> urlParamMap){
        try{
            Map<String, Object> returnMap = new Map<String, Object>(); 
            Map<String, String> flexTableParamMap= (Map<String,String>)JSON.deserialize(SFDCEncoder.sanitizeJSON((string)urlParamMap.get('flexTableParam')), Map<String,String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
            String OrganizationId = [select OrganizationId__c from user where Id = :UserInfo.getUserId() WITH USER_MODE LIMIT 1].OrganizationId__c;
            flexTableParamMap.put('OrganizationId',OrganizationId);
            
            if(!urlParamMap.containsKey('PageDataHolderId')){
                PageDataHolder__c pageDataHolder = new PageDataHolder__c();
                if(Schema.sObjectType.PageDataHolder__c.fields.Name.isCreateable()){
                    pageDataHolder.Name = 'Test PDF Record';//flexTableParamMap.get('parentId')
                }
                if(Schema.sObjectType.PageDataHolder__c.isCreateable()){
                    insert pageDataHolder;
                }
                returnMap.put('PageDataHolderId',pageDataHolder.Id);
            }
            else{
                returnMap.put('PageDataHolderId',urlParamMap.get('PageDataHolderId'));
            }

            PageReference pdfPage;
            String exportPageName = (String)urlParamMap.get('exportPageName');
            System.debug('exportPageName ==>'+exportPageName);
            
            if(exportPageName  == null || (exportPageName!= null && exportPageName.contains('DynamicLayoutExport_MultipleForms'))){
                pdfPage = Page.DynamicLayoutExport;
            }else{
                pdfPage = new PageReference(System.URL.getSalesforceBaseUrl()+'/'+exportPageName);
            }
                
            pdfPage.getParameters().put('id',(String)urlParamMap.get('Id'));
            pdfPage.getParameters().put('viewTemplateName',(String)urlParamMap.get('viewTemplateName'));
            pdfPage.getParameters().put('flexTableParam',(String)urlParamMap.get('flexTableParam'));
            pdfPage.getParameters().put('listParm',(String)urlParamMap.get('listParm'));
            
            if( ((String)urlParamMap.get('skipRedirect'))  != null && ((String)urlParamMap.get('skipRedirect')) == 'true') {
                pdfPage.getParameters().put('skipRedirect','true');
            }
            pdfPage.setRedirect(true);
            System.debug('pdfPage==>'+pdfPage);

            Attachment attachmentObj = new Attachment();
            if(Schema.sObjectType.Attachment.fields.Name.isCreateable()){
                attachmentObj.Name = ((String)urlParamMap.get('viewTemplateName'))+'.pdf';
            }
            if(Schema.sObjectType.Attachment.fields.Body.isCreateable()){
                attachmentObj.Body = pdfPage.getContentAsPDF();
            }
            if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                attachmentObj.ContentType = 'application/pdf';
            }
            if(Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()){
                attachmentObj.IsPrivate = false;
            }
            //if(Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
                attachmentObj.ParentId = (String)(urlParamMap.containsKey('PageDataHolderId') ? urlParamMap.get('PageDataHolderId') : returnMap.get('PageDataHolderId'));
            //}
            if(Schema.sObjectType.Attachment.isCreateable()){
                insert attachmentObj;
            }
            returnMap.put('AttachmentIds',attachmentObj.Id);
            
            System.debug('pdfPage==>'+pdfPage);
            return returnMap;//returnMap;
        }
        catch(Exception ex){
            System.debug('DynamicLayoutExportMultipleFormsCtrl:saveFormPDF:Exception==>'+ex);
            CustomExceptions.logException(ex, true, true);
            return null;
        }
    }
        
    //This method call the Itext function to merge the attachments
    @RemoteAction
    public static Map<String, Object>getMergedItextPDF(Map<String, Object> objectParamMap){
        try{
            //Map<String, Object> paramMap = ITextHelper.mergePDF(objectParamMap);
            //return paramMap;
            return null;
        } catch(Exception ex){
            System.debug('DynamicLayoutExportMultipleFormsCtrl:getMergedItextPDF:Exception==>'+ex);
            CustomExceptions.logException(ex, true, true);
            return null;
        }
    }

    @RemoteAction
    public static Map<String,Object> pollForAttachment(Map<String,String> paramsMap){
        Map<String,Object> retVal = new Map<String,Object>();
        retVal.put('Success',false);
        
        System.debug('---paramsMap---'+ paramsMap);
        
        String recordId = paramsMap.get('recordId');

        List<Attachment> attList = [SELECT Id, Name, CreatedDate 
                                    FROM Attachment 
                                    WHERE ParentId =: paramsMap.get('parentId') AND Name =:'MergedFile.pdf'
                                    WITH USER_MODE
                                    LIMIT 1];
        if(attList.size() > 0){
            retVal.put('URL',AppUtils.docBaseUrl+'/servlet/servlet.FileDownload?file='+ attList[0].Id);
            retVal.put('Success',true);
        }else{
            retVal.put('Reason','AttachmentId_Not_Found');
        }                                            
        return retVal;
    }

    @RemoteAction
    public static PageDataHolder__c  getPlaceHolder(String placeHolderName){
        PageDataHolder__c pageDataHolderObj = new PageDataHolder__c();
        if(Schema.sObjectType.PageDataHolder__c.fields.Name.isCreateable()){
            pageDataHolderObj.Name = placeHolderName;//flexTableParamMap.get('parentId')
        }
        if(Schema.sObjectType.PageDataHolder__c.isCreateable()){
            insert pageDataHolderObj ;
        }
        return pageDataHolderObj ;
    }
}