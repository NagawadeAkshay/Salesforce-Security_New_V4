/**
**/
global with sharing class PDFExportCtrl {
    public transient String exportString{get;set;}
    private transient Id recordId;
    public transient Component.Apex.OutputPanel printLayoutTabsContent{get;set;}
    private Boolean isExecuted = false;
    global string mergeFieldsStr{get;
    	set{
    		mergeFieldsStr = value;
    		if(isExecuted  == false) {
	    		getPrintLayoutContents();
    		}
    		isExecuted = true;
    	}
    }
    
    global PDFExportCtrl() {
    	recordId = SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
    	getExportString();
    	printLayoutTabsContent = new Component.Apex.OutputPanel();
    	//Map<String, Object> mergeFields
    }
    
    private void getExportString() {
    	exportString = '';
    	if(ExportTemplate__c.sObjectType.getDescribe().isAccessible() == true) {
	    	ExportTemplate__c exportTemplate = [select Id,Body1__c,Body2__c,Body3__c,Body4__c from ExportTemplate__c where Name=:SFDCEncoder.SFDC_JSENCODE(Apexpages.currentPage().getParameters().get('templateName')) WITH USER_MODE][0];//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding //CRUD/FLS False +ve with the help of Schema we are performing the check
	    	if(exportTemplate.Body1__c != null) { 
	    		exportString = exportTemplate.Body1__c;
	    	}
	    	
	    	if(exportTemplate.Body2__c != null) {
	    		exportString += exportTemplate.Body2__c;
	    	}
	    	
	    	if(exportTemplate.Body3__c != null) {
	    		exportString += exportTemplate.Body3__c;
	    	}
	    	
	    	if(exportTemplate.Body4__c != null) {
	    		exportString += exportTemplate.Body4__c;
	    	}
	    	exportString  = exportString.unescapeHtml4();
	    }
    }
    
    public void getPrintLayoutContents() {
    	if(mergeFieldsStr != null) {
	    	exportString = replaceMergeFields(exportString, (Map<String, String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(mergeFieldsStr), Map<String, String>.class));  // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
    	}
    	exportString = AppUtils.replaceMergeFields(exportString, String.valueOf(recordId));
    	replaceComponents();
    }
    
    // added {!! because we already added same thing for merge field for custom fields
    private String replaceMergeFields(String inputStr, Map<String, String> mergeFields) {
    	for(String mergeField : mergeFields.keySet()) {
    		inputStr = inputStr.replaceAll('\\(!'+mergeField+'\\)', String.valueOf(mergeFields.get(mergeField)));
    	}
    	return inputStr;
    }
    
    private void replaceComponents() {
    	Map<Integer, String> componentMap = getMergeComponents();
		//printLayoutTabsContent = new Component.Apex.OutputPanel();
		Integer previousIndex = 0;
		for(Integer index : componentMap.keyset()) {
			String componentVal = componentMap.get(index);
			if(componentVal.contains('c:FlexTableExport')) {
		    	addHTMLToBody(exportString.subString(previousIndex, index));
		    	previousIndex = previousIndex + componentVal.length();
		    	replaceFlexTableComponent(componentVal);
			} else if(componentVal.contains('c:FlexGridExport')) {
				addHTMLToBody(exportString.subString(previousIndex, index));
				previousIndex = previousIndex + componentVal.length();
		    	//replaceFlexGridComponent();
			}
		}
		addHTMLToBody(exportString.subString(previousIndex));
    }
    
    private void replaceFlexTableComponent(String component) {
    	Component.FlexTableExport c = new Component.FlexTableExport(FlextableName=getFlexTableName(component), 
                ExportMode='pdf');
        printLayoutTabsContent.childComponents.add(c);
    }

	public static Map<String, String> getPDFExportIcon(){

		map<string,string> PDFExportIconMap = new map<string,string>();
		PDFExportIconMap.put('fa fa-pencil','utility:edit');
		PDFExportIconMap.put('fa fa-arrow','utility:right');
		PDFExportIconMap.put('fa fa-ban','utility:close');
		PDFExportIconMap.put('fa fa-bolt','utility:thunder');
		PDFExportIconMap.put('fa fa-check','utility:success'); 
		PDFExportIconMap.put('fa fa-clone','utility:clone');
		PDFExportIconMap.put('fa fa-close','utility:close');
		PDFExportIconMap.put('fa fa-cloud-download','utility:download');
		PDFExportIconMap.put('fa fa-cloud-upload','utility:upload');
		PDFExportIconMap.put('fa fa-comments','utility:chat');
		PDFExportIconMap.put('fa fa-exchange','utility:exchange');
		PDFExportIconMap.put('fa fa-external-link','utility:open');
		PDFExportIconMap.put('fa fa-eye','utility:preview');
		PDFExportIconMap.put('fa fa-file','utility:page');
		PDFExportIconMap.put('fa fa-file-pdf','utility:file_pdf');
		PDFExportIconMap.put('fa fa-file-text','utility:file');
		PDFExportIconMap.put('fa fa-gavel','utility:thunder');
		PDFExportIconMap.put('fa fa-level-up','utility:up');
		PDFExportIconMap.put('fa fa-money','utility:currency');
		PDFExportIconMap.put('fa fa-play','utility:play');
		PDFExportIconMap.put('fa fa-plus-circle','utility:add');
		PDFExportIconMap.put('fa fa-reply','utility:back');
		PDFExportIconMap.put('fa fa-share','utility:share');
		PDFExportIconMap.put('fa fa-share-square-o','utility:share_post');
		PDFExportIconMap.put('fa fa-sign-in','utility:login');
		PDFExportIconMap.put('fa fa-sign-out','utility:logout');
		PDFExportIconMap.put('fa fa-sitemap','utility:hierarchy');
		PDFExportIconMap.put('fa fa-sticky-note','utility:note');
		PDFExportIconMap.put('fa fa-stop','utility:stop');
		PDFExportIconMap.put('fa fa-tags','utility:tags');
		PDFExportIconMap.put('fa fa-times','utility:close');
		PDFExportIconMap.put('fa fa-trash','utility:delete');
		PDFExportIconMap.put('fa fa-trophy','custom:custom48');
		PDFExportIconMap.put('fa fa-undo','utility:undo');
		PDFExportIconMap.put('fa fa-unlock','utility:unlock');
		PDFExportIconMap.put('fa fa-paper-plane-o','utility:send');
		PDFExportIconMap.put('glyphicon glyphicon-pencil','utility:edit');
		PDFExportIconMap.put('glyphicon glyphicon-remove','utility:close');
		PDFExportIconMap.put('glyphicon glyphicon-send','utility:send');
		PDFExportIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
		PDFExportIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
		PDFExportIconMap.put('glyphicon glyphicon-trash','utility:delete');
		PDFExportIconMap.put('fa fa-history','utility:skip_back');
		PDFExportIconMap.put('fa fa-table','utility:table');
		PDFExportIconMap.put('fa fa-coffee','utility:coffee');
		PDFExportIconMap.put('fa fa-cubes','utility:cubes');
		PDFExportIconMap.put('fa fa-star','utility:favorite');
		PDFExportIconMap.put('fa fa-exclamation-triangle','utility:warning');
		PDFExportIconMap.put('fa fa-line-PDFExport','utility:linePDFExport');
		PDFExportIconMap.put('fa fa-comment','utility:comments');
		PDFExportIconMap.put('fa fa-caret-square-o-down','utility:down');
		PDFExportIconMap.put('fa fa-wrench','utility:settings');
		PDFExportIconMap.put('fa fa-share-square-o','utility:share');
		PDFExportIconMap.put('fa fa-bolt','utility:lightning');
		PDFExportIconMap.put('fa fa-trash-o','utility:delete');
		PDFExportIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
		PDFExportIconMap.put('fa fa-file-text-o','utility:contract_doc');
		PDFExportIconMap.put('fa fa-wechat','utility:chat');
		PDFExportIconMap.put('fa fa-paperclip','utility:attach');
		PDFExportIconMap.put('fa fa-usd','utility:moneybag');
		PDFExportIconMap.put('glyphicon glyphicon-tasks','utility:task');
		//PDFExportIconMap.put('fa fa-trophy','utility:funding_award_adjustment');
		PDFExportIconMap.put('fa fa-folder','utility:open_folder');
		PDFExportIconMap.put('fa fa-paper-plane-o','utility:send');
		PDFExportIconMap.put('fa fa-play','utility:play');
	
		return PDFExportIconMap;
	}
	
	public static Map<String, String> getPDFExportIconLwc(){
	
		map<string,string> PDFExportIconMaplwc = new map<string,string>();
		PDFExportIconMaplwc.put('fa fa-pencil','utility:edit');
		PDFExportIconMaplwc.put('fa fa-arrow','utility:right');
		PDFExportIconMaplwc.put('fa fa-ban','utility:error');
		PDFExportIconMaplwc.put('fa fa-bolt','utility:thunder');
		PDFExportIconMaplwc.put('fa fa-check','utility:success'); 
		PDFExportIconMaplwc.put('fa fa-clone','utility:clone');
		PDFExportIconMaplwc.put('fa fa-close','utility:close');
		PDFExportIconMaplwc.put('fa fa-cloud-download','utility:download');
		PDFExportIconMaplwc.put('fa fa-cloud-upload','utility:upload');
		PDFExportIconMaplwc.put('fa fa-comments','utility:chat');
		PDFExportIconMaplwc.put('fa fa-exchange','utility:exchange');
		PDFExportIconMaplwc.put('fa fa-external-link','utility:open');
		PDFExportIconMaplwc.put('fa fa-eye','utility:preview');
		PDFExportIconMaplwc.put('fa fa-file','utility:page');
		PDFExportIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
		PDFExportIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
		PDFExportIconMaplwc.put('fa fa-file-text','utility:file');
		PDFExportIconMaplwc.put('fa fa-gavel','utility:thunder');
		PDFExportIconMaplwc.put('fa fa-level-up','utility:up');
		PDFExportIconMaplwc.put('fa fa-money','utility:currency');
		PDFExportIconMaplwc.put('fa fa-play','utility:play');
		PDFExportIconMaplwc.put('fa fa-plus-circle','utility:add');
		PDFExportIconMaplwc.put('fa fa-reply','utility:back');
		PDFExportIconMaplwc.put('fa fa-share','utility:share');
		PDFExportIconMaplwc.put('fa fa-share-square-o','utility:share_post');
		PDFExportIconMaplwc.put('fa fa-sign-in','utility:login');
		PDFExportIconMaplwc.put('fa fa-sign-out','utility:logout');
		PDFExportIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
		PDFExportIconMaplwc.put('fa fa-sticky-note','utility:note');
		PDFExportIconMaplwc.put('fa fa-stop','utility:stop');
		PDFExportIconMaplwc.put('fa fa-tags','utility:tags');
		PDFExportIconMaplwc.put('fa fa-times','utility:close');
		PDFExportIconMaplwc.put('fa fa-trash','utility:delete');
		PDFExportIconMaplwc.put('fa fa-trophy','custom:custom48');
		PDFExportIconMaplwc.put('fa fa-undo','utility:undo');
		PDFExportIconMaplwc.put('fa fa-unlock','utility:unlock');
		PDFExportIconMaplwc.put('fa fa-paper-plane-o','utility:send');
		PDFExportIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
		PDFExportIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
		PDFExportIconMaplwc.put('glyphicon glyphicon-send','utility:send');
		PDFExportIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
		PDFExportIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
		PDFExportIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
		PDFExportIconMaplwc.put('fa fa-history','utility:skip_back');
		PDFExportIconMaplwc.put('fa fa-table','utility:table');
		PDFExportIconMaplwc.put('fa fa-coffee','utility:coffee');
		PDFExportIconMaplwc.put('fa fa-cubes','utility:cubes');
		PDFExportIconMaplwc.put('fa fa-star','utility:favorite');
		PDFExportIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
		PDFExportIconMaplwc.put('fa fa-line-PDFExport','utility:graph');
		PDFExportIconMaplwc.put('fa fa-comment','utility:comments');
		PDFExportIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
		PDFExportIconMaplwc.put('fa fa-wrench','utility:settings');
		PDFExportIconMaplwc.put('fa fa-share-square-o','utility:share');
		PDFExportIconMaplwc.put('fa fa-bolt','utility:lightning');
		PDFExportIconMaplwc.put('fa fa-trash-o','utility:delete');
		PDFExportIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
		PDFExportIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
		PDFExportIconMaplwc.put('fa fa-wechat','utility:chat');
		PDFExportIconMaplwc.put('fa fa-paperclip','utility:attach');
		PDFExportIconMaplwc.put('fa fa-usd','utility:moneybag');
		PDFExportIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
		//PDFExportIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
		PDFExportIconMaplwc.put('fa fa-folder','utility:open_folder');
		PDFExportIconMaplwc.put('fa fa-paper-plane-o','utility:send');
		PDFExportIconMaplwc.put('fa fa-play','utility:play');
		PDFExportIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
		PDFExportIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
		PDFExportIconMaplwc.put('fa fa-male','utility:user');
	
		return PDFExportIconMaplwc;
	}
    
    private String getFlexTableName(String component) {
		if (component == null) return '';
		String findStr = '';
		Pattern regex = Pattern.compile('FlextableName="([^"]*)\\"');  
		Matcher regexMatcher = regex.matcher(component);
		regexMatcher.find();//SOQL/SOSL Injection False +ve
		String tableName = regexMatcher.group();
		tableName = tableName.subString(15, tableName.length() - 1);
		return tableName;
    }
    
    private Map<Integer, String> getMergeComponents() {
    	//String header = 'pankaj<c:asa name="pankaj" /> dfdf <c:test name="Pankaj"/>';
		Map<Integer, String> startByComponentname = new Map<Integer, String>();
		if (exportString == null) return startByComponentname;
		Pattern regex = Pattern.compile('\\<c:([^>]*)\\>');  
		Matcher regexMatcher = regex.matcher(exportString);        
		
		while (regexMatcher.find()){//SOQL/SOSL Injection False +ve       
			startByComponentname.put(regexMatcher.start(), regexMatcher.group());
		}
		
		return startByComponentname;
    }
    
    private void addHTMLToBody(String htmlBody) {
    	printLayoutTabsContent.childComponents.add(new Component.Apex.OutputText(Value=htmlBody, escape=false));
    }
    
}