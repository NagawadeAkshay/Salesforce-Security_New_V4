/**
* Class to handle the DynamicLayoutExport page.
* This class is used to export the contents of a Dynamic Layout Page in a PDF. 
* Either we can configure Default values in Key value custom settig or we can configure at page layout level.
* for page layout level need to provide JSON like below
    { 
        "PDFTopLeftImageDocName": "docName", 
        "PDFTopMiddleImageDocName": "docName", 
        "PDFTopRightImageDocName": "docName", 
        "PDFBottomLeftImageDocName": "docName", 
        "PDFBottomRightImageDocName": "docName", 
        "PDFBottomMiddleImageDocName": "docName", 
        "PDFTopLeftText": "text", 
        "PDFTopMiddleText": "text", 
        "PDFTopRightText": "text", 
        "PDFBottomLeftText": "text", 
        "PDFBottomRightText": "text", 
        "PDFBottomMiddleText": "text", 
        "PDFTopRightTimeStamp": "true", 
        "ShowPageNumber": "false" 
    }
*   
*   Inputs Expected: ViewPageTemplateName & RecordID    
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 02/12/2014    Kunal Shah      Created
* 01/25/2018    Pankaj H.       JSON support for attributes
* =============================================================================
*/

public with sharing class DynamicLayoutExportCtrl {
    
    //Properties
    public transient ID recordId{get;set;}
    public transient Id pkgId{get;set;}
    public transient string printTemplateName{get;set;}
    
    public transient String topLeftImageURL{get;set;}
    public transient String topMiddleImageURL{get;set;}
    public transient String topRightImageURL{get;set;}
    public transient String bottomLeftImageURL{get;set;}
    public transient String bottomRightImageURL{get;set;}
    public transient String bottomMiddleImageURL{get;set;}
    public transient String topLeftString{get;set;}
    public transient String topMiddleString{get;set;}
    public transient String topRightString{get;set;}
    public transient String bottomLeftString{get;set;}
    public transient String bottomRightString{get;set;}
    public transient String bottomMiddleString{get;set;}
    public transient String themeDocURL {get; set;}
    public transient String themeDocURL1 {get; set;}
    
    public transient Boolean showTimeStamp {get;set;}
    public transient List<String> formTypes {get;set;}
    public transient List<PageLayoutConfig__c> pageLayout{get;set;}
    public transient DateTime currentDateTime {get;set;}
    private transient PageTemplate__c printTemplate;
    
    public DynamicLayoutExportCtrl() {
       
        PageLayoutConfigHelper.isPrint = true;
        recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String templateFileName;
        pkgId = (SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('packageId')) != '') ? 
                            SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('packageId')) : null;
        string viewTemplateName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('viewTemplateName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 

        //Code to Handle Special Characters within Form Config/Page Layout Name................
        if(viewTemplateName != null && viewTemplateName != ''){
            viewTemplateName = viewTemplateName.unescapeJava();
        }
       
        Map<String, String> pageLayoutAttr = new Map<String, String>();
        if(viewTemplateName != Null) {
            findPrintTemplate(viewTemplateName);
            templateFileName=printTemplate.PrintLayoutConfig__r.OverridePdfThemeFile__c;
            if(String.isNotEmpty(printTemplate.PrintLayoutConfig__r.PDFAttributesJSON__c)) {
                String jsondata  = AppUtils.replaceMergeFields(printTemplate.PrintLayoutConfig__r.PDFAttributesJSON__c,recordId);
                pageLayoutAttr = (Map<String, String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(jsondata), 
                                                                Map<String, String>.Class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON 
             }
        }
        
        String formTypeStr = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('formTypes'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String fileName = KeyValueStoreHelper.getTextValue('PDFName',true);
        fileName = (fileName == null ? 'GovGrants '  : fileName) +' '+' '+ (System.now().format('MM/dd/yyyy HH:mm:ss'));
        String mode = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('mode'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(mode == 'pdf' || String.isEmpty(mode) ) {
            Apexpages.currentPage().getHeaders().put('content-disposition', 'filename='+ SFDCEncoder.SFDC_HTMLENCODE(fileName)+ '.pdf');
        }
        if(!String.isEmpty(formTypeStr)) {
            List<String> result = (List<String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(formTypeStr), List<String>.Class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON 
			formTypes = new List<String>();
			for(String r: result){
				formTypes.add(SFDCEncoder.SFDC_JSENCODE(r));
			}        
		} else {
            formTypes = new List<String>();
        }
        
        //User Story 71061: Internal - Remove document object dependency and move to static resource
        //User Story 110349: Internal - Optimization - CPU time limit - AppUtils.getIcons method

        Map<String, String> mapResources =  new Map<String, String>();
        mapResources.put('PDFTopLeftImageDocName', pageLayoutAttr.containsKey('PDFTopLeftImageDocName') ? pageLayoutAttr.get('PDFTopLeftImageDocName') : KeyValueStoreHelper.getTextValue('PDFTopLeftImageDocName',true));
        mapResources.put('PDFTopMiddleImageDocName', pageLayoutAttr.containsKey('PDFTopMiddleImageDocName') ? pageLayoutAttr.get('PDFTopMiddleImageDocName') : KeyValueStoreHelper.getTextValue('PDFTopMiddleImageDocName',true));
        mapResources.put('PDFTopRightImageDocName', pageLayoutAttr.containsKey('PDFTopRightImageDocName') ? pageLayoutAttr.get('PDFTopRightImageDocName') : KeyValueStoreHelper.getTextValue('PDFTopRightImageDocName',true));
        mapResources.put('PDFBottomLeftImageDocName', pageLayoutAttr.containsKey('PDFBottomLeftImageDocName') ? pageLayoutAttr.get('PDFBottomLeftImageDocName') : KeyValueStoreHelper.getTextValue('PDFBottomLeftImageDocName',true));
        mapResources.put('PDFBottomRightImageDocName', pageLayoutAttr.containsKey('PDFBottomRightImageDocName') ? pageLayoutAttr.get('PDFBottomRightImageDocName') : KeyValueStoreHelper.getTextValue('PDFBottomRightImageDocName',true));
        mapResources.put('PDFBottomMiddleImageDocName', pageLayoutAttr.containsKey('PDFBottomMiddleImageDocName') ? pageLayoutAttr.get('PDFBottomMiddleImageDocName') : KeyValueStoreHelper.getTextValue('PDFBottomMiddleImageDocName',true));
        mapResources.put('themeDocURL1', templateFileName);

        Boolean skipDefaultTheme = pageLayoutAttr.containsKey('PDFSkipMainPDF') ? Boolean.valueOf( pageLayoutAttr.get('PDFSkipMainPDF') ) : false;
        if(skipDefaultTheme == false) {
          // if no theme configured then take detaul theme
           // themeDocURL = AppUtils.getIcons('GovGrantsThemeToPrint');
           // mapResources.put('themeDocURL', themeDocURL);
            mapResources.put('themeDocURL', 'GovGrantsThemeToPrint');
        }
        // Optimization GNT:Too many SOQL queries: 101 error display on Download as PDF: static resource object Optimization
        List<String> resourceNameList = new List<String>{'govGrantPleaseWaitIcon', 'FaviconIcon', 'GovGrantsTheme','govGrantsFooterImage', 'govGrantsFooterImageAfterCollapse','GovGrantsTheme_Collab', 'govGrantsColorContrast_collab','ColorContrast_Grantor','GovGrants','ExternalLibNew','Tooltipster','GovGrants','GovGrantsExternal', 'SessionLogout','BulbIconInstruction','FlexGridEnhanced'};
        resourceNameList.addAll(mapResources.values());
        AppUtils.fetchIcons(resourceNameList);
        //
        //AppUtils.fetchIcons(mapResources.values());
        themeDocURL = AppUtils.getIcons(mapResources.get('themeDocURL'));
        topLeftImageURL = AppUtils.getIcons(mapResources.get('PDFTopLeftImageDocName'));
        topMiddleImageURL = AppUtils.getIcons(mapResources.get('PDFTopMiddleImageDocName'));
        topRightImageURL = AppUtils.getIcons(mapResources.get('PDFTopRightImageDocName'));
        bottomLeftImageURL = AppUtils.getIcons(mapResources.get('PDFBottomLeftImageDocName'));
        bottomMiddleImageURL = AppUtils.getIcons(mapResources.get('PDFBottomRightImageDocName'));
        bottomRightImageURL = AppUtils.getIcons(mapResources.get('PDFBottomMiddleImageDocName'));
        themeDocURL1 = AppUtils.getIcons(mapResources.get('themeDocURL1'));

        showTimeStamp = pageLayoutAttr.containsKey('PDFTopRightTimeStamp') ? Boolean.valueOf( pageLayoutAttr.get('PDFTopRightTimeStamp') )
                : KeyValueStoreHelper.getBooleanValue('PDFTopRightTimeStamp',true);
        currentDateTime = System.now();
        topLeftString = pageLayoutAttr.containsKey('PDFTopLeftText') ? pageLayoutAttr.get('PDFTopLeftText')
                : KeyValueStoreHelper.getTextValue('PDFTopLeftText',true);
        topMiddleString = pageLayoutAttr.containsKey('PDFTopMiddleText') ? pageLayoutAttr.get('PDFTopMiddleText')
                : KeyValueStoreHelper.getTextValue('PDFTopMiddleText',true);
        topRightString = pageLayoutAttr.containsKey('PDFTopRightText') ? pageLayoutAttr.get('PDFTopRightText')
                : KeyValueStoreHelper.getTextValue('PDFTopRightText',true);
        bottomLeftString = pageLayoutAttr.containsKey('PDFBottomLeftText') ? pageLayoutAttr.get('PDFBottomLeftText')
                : KeyValueStoreHelper.getTextValue('PDFBottomLeftText',true);
        bottomRightString = pageLayoutAttr.containsKey('PDFBottomRightText') ? pageLayoutAttr.get('PDFBottomRightText')
                : KeyValueStoreHelper.getTextValue('PDFBottomRightText',true);
        bottomMiddleString = pageLayoutAttr.containsKey('PDFBottomMiddleText') ? pageLayoutAttr.get('PDFBottomMiddleText')
                : KeyValueStoreHelper.getTextValue('PDFBottomMiddleText',true);
            redirect();
    }
    
    /*
    * Method to find the print layout for a given view template
    */
    List<PageTemplate__c> templateConfigList  = new List<PageTemplate__c>();
    public void findPrintTemplate(string template) {
        //1. Get the Page Template Name
    //    printTemplate = [SELECT ID,NAME,PrintLayoutConfig__r.OverridePdfThemeFile__c,PrintLayoutConfig__r.PDFAttributesJSON__c 
    //                                        FROM PageTemplate__c 
    //                                         WHERE NAME = : template WITH SECURITY_ENFORCED ];
        if(Schema.sObjectType.PageTemplate__c.isAccessible()){
            templateConfigList = [SELECT ID,NAME,PrintLayoutConfig__r.OverridePdfThemeFile__c,
            PrintLayoutConfig__r.PDFAttributesJSON__c ,PrintLayoutConfig__c ,PrintLayoutConfig__r.ObjectAPIName__c,
            PrintLayoutConfig__r.PDFRenderType__c,ExportPageName__c
                                    FROM PageTemplate__c 
                                    WHERE NAME = :template
                                    WITH USER_MODE
                                    LIMIT 1]; 
            if(templateConfigList.size() > 0) {
                printTemplateName = templateConfigList[0].NAME;   
                printTemplate =  templateConfigList[0];                                 
            }
        }
    }
    
    public PageReference redirect(){
        PageReference p;
        String recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String templateName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('viewTemplateName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String flexTableParam = SFDCEncoder.sanitizeJSON(ApexPages.CurrentPage().getParameters().get('flexTableParam'));
        String listParm = SFDCEncoder.sanitizeJSON(ApexPages.CurrentPage().getParameters().get('listParm'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        String skipRedirect = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('skipRedirect'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(skipRedirect == 'true') return null;

        if(templateConfigList.size() > 0 && String.isNotBlank(templateConfigList[0].ExportPageName__c)){
           String url = AppUtils.docBaseUrl+templateConfigList[0].ExportPageName__c +'?id='+recordId+'&viewTemplateName='+templateName+'&flexTableParam='+flexTableParam;
           url+='&listParm='+listParm+'&packageId='+pkgId+'&formTypes='+formTypes;
           p = new PageReference(EncodingUtil.urlEncode(url,'UTF-8'));  //ApexOpenRedirect  - False +Ve - We are using custom method for encoding
           p.setRedirect(true);  
          }
        return p;    
    }
   
}