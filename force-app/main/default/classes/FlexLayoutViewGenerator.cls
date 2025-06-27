/**
    It generates tabs for view & print layouts only. 
*/
public with sharing class FlexLayoutViewGenerator { 
    private DynamicLayoutHolder layoutHolder;
    private String html = '';
    private Component.Apex.OutputPanel body;
    private Boolean isPreview = false;
    private String flexTableParameters;
    private String chartParameters;
    private String listParams;
    private boolean isOverview = false;
    private Boolean isModal = false;
    private boolean isEditLayout = false;
    private KeyValueHolder__mdt objMetadataHolder;
    public static List<XSSSanitization__mdt> lstMetadata;
    public static List<String> xssSanitizeStr = new List<String>();

    static{
        if(XSSSanitization__mdt.sObjectType.getDescribe().isAccessible()) {
            lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues' WITH USER_MODE]; 
        }        
        if(!lstMetadata.isempty())
             xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c) ? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();
    }
    public FlexLayoutViewGenerator(DynamicLayoutHolder layoutHolder, Boolean isPreview, String flexTableParameters, 
                    String listParams, String chartParameters) {
        this(layoutHolder, isPreview, flexTableParameters, listParams, chartParameters, false);
    }

    public FlexLayoutViewGenerator(DynamicLayoutHolder layoutHolder, Boolean isPreview, String flexTableParameters, 
                    String listParams, String chartParameters, Boolean isModal) {
        this(layoutHolder, isPreview, flexTableParameters, listParams, chartParameters,isModal,false);
        
    }

    public FlexLayoutViewGenerator(DynamicLayoutHolder layoutHolder, Boolean isPreview, String flexTableParameters,
            String listParams, String chartParameters, Boolean isModal,Boolean isEditLayout) {
        this.layoutHolder = layoutHolder;
        this.isPreview = isPreview == null ? false : isPreview;
        this.flexTableParameters = flexTableParameters == null ? '' : flexTableParameters;
        this.listParams = listParams == null ? '' : listParams;
        this.chartParameters = chartParameters == null ? '' : chartParameters;
        this.body = new Component.Apex.OutputPanel();
        this.isModal = isModal;
        this.isEditLayout = isEditLayout;
        this.objMetadataHolder = KeyValueHolderHelper.getKeyValueHolder('EnableLWC'); 
    }

    public Component.Apex.OutputPanel generate() {
        html += '<div class="panel tabsPanelWrap"><div class="panel-body"><div id="myTabs" class="">';
        if(layoutHolder != null){
            renderTabsHeader();
            renderTabsBody();
        }
        html += '</div></div></div>';   
        addHTMLToBody();

        return body;
    }

    public Component.Apex.OutputPanel generateHeader(){
        isOverview = true;
        if(layoutHolder != null){
            renderHeaderOverviewBody();
        }
        addHTMLToBody();
        return body;   
    }

    /* PRIVATE METHODS */

    private void renderTabsHeader() {
        html += '<ul id="topTabsID" class="nav nav-tabs">';      
        
        for (PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs) {
            if (tab.hideTab != 'true' && tab.isOverview != true) {
                html += '<li class="listyle" tabindex="0" style="' + (tab.active?'':'display:none') + '" >';
                html += '<a style="' + (layoutHolder.layout.activeTabSize > 1?'':'display:none') + 
                            '" href="#' + tab.tabId + '" id="' + tab.tabId + 'tab" name="' + tab.Name + 
                            '"  data-toggle="tab" onclick="setCookie(\'' + tab.tabId + 'tab\',\'' + tab.Name + 
                            '\');setTimeout(function(){if(typeof modalHandler != \'undefined\'){modalHandler();}},200);">';
                
                if(tab.Icon != null){
                    html += tab.Icon + '&nbsp;';     
                }   html += '<span>' + tab.Name + '<span class="dot tabYellowDot" title="Missing fields information" style="'+(tab.requiredFieldForSubmit == true || tab.requiredFieldForSave == true ? 'display:inline-block': 'display:none')+'"></span></span>';
                html += '</a>';
                html += '<span id="' + tab.tabId + 'tab" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + tab.Name + '\',\'type\':\'tab\',\'title\':\''+ tab.Name + '\',\'tabId\':\''+tab.tabId+'tab\'}">' + tab.Name + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
                html += '</li>';
            }
        }
        html += '</ul>';        
    }
    
     private void renderTabsBody() {
        html += '<div id="myTabbedContent" class="tab-content">';
        for (PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs) {
            if (tab.hideTab != 'true' && tab.isOverview != true) {
                html += '<div class="tab-pane fade" id="' + tab.tabId + '" style="' + 
                                    (tab.active?'':'display:none') + '">';
                
                html += '<div class="tabSection">';
                if(isEditLayout){
                    html += '<div id="editDiv"><div class="TOP_DOWN">'; 
                }                                
                        
                if(String.isEmpty(tab.headerInstructionText) == false) {
                    html += '<div class="tabheaderinstruction" tabindex="0">' + tab.headerInstructionText + '</div>';
                }
                {
                    
                    Integer totalActivePageBLocks = 0;
                    for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                        for (PageLayoutConfigHelper.PageBlock block : blocks) {
                            if (block.isHiddenPageBlock || block.hidePageBlock == 'true') continue;
                            totalActivePageBLocks++;
                        }
                        }
                    
                    for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                        
                        html += '<div class="clearfix">';
                        for (PageLayoutConfigHelper.PageBlock block : blocks) {
                            if (block.isHiddenPageBlock || block.hidePageBlock == 'true') continue;
                            renderPageBlock(block, tab, totalActivePageBLocks);
                        }
                        html += '</div>';   
                    }
                }
                html += '</div></div>';
                if(isEditLayout){
                    html += '</div></div>'; 
                }  
            }
            
        }
        html += '</div>';   
    }

    private void renderHeaderOverviewBody() {       
        for (PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs) {
            if (tab.isOverview == true && tab.hideTab != 'true') {
                html += '<div class="overview-pane" id="' + tab.tabId + '">';
                Integer totalActivePageBLocks = 0;
                    for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                    for (PageLayoutConfigHelper.PageBlock block : blocks) {
                        if (block.isHiddenPageBlock || block.hidePageBlock == 'true') continue;
                        totalActivePageBLocks++;
                    }
                    }
                    
                for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                    for (PageLayoutConfigHelper.PageBlock block : blocks) {
                        if (block.isHiddenPageBlock || block.hidePageBlock == 'true') {
                            continue;
                        }
                        renderPageBlock(block, tab, totalActivePageBLocks);
                    }
                }
                html += '</div>';
            }            
        }         
    }

    private void renderPageBlock(PageLayoutConfigHelper.PageBlock pb, PageLayoutConfigHelper.Tab tab, Integer totalBlocks) {
        Boolean hideBlockTitle = totalBlocks == 1;
        addHTMLToBody();
        if (String.isNotEmpty(pb.flexTableId) && pb.isWBS != true && (pb.recordTypeName=='Flex Table' || pb.recordTypeName=='Flex Table Enhanced' || pb.recordTypeName=='Field History' || pb.recordTypeName == 'Form Enhanced')) {
            renderFlexTable(pb,totalBlocks);
        }else if(pb.recordTypeName == 'ReCaptcha'){
            renderCaptcha(pb);
        }
        else if (String.isNotEmpty(pb.flexGridId)) {
            renderFlexGrid(pb,totalBlocks);
        }else if(pb.recordTypeName=='Files'){
            renderFilesFlexTable(pb,totalBlocks);
        }
        else if(pb.recordTypeName=='Library'){
            renderFilesLibrary(pb,totalBlocks);
        }
        else if (pb.isFormTable != null && pb.isFormTable) { 
            renderFormLayoutTable(pb,totalBlocks);
        }
        else if (pb.isNotesAttachmentsList || pb.isAttachment) {
            renderNotesAndAttachments(pb);
        }
        else if (pb.isDigitallySigned) {    //to display digital signature component            
            Boolean showDigiSign = KeyValueStoreHelper.getBooleanValue('EnableDigitalSignature', true);
            if(showDigiSign != null && showDigiSign == true) {
                renderDigitallySigned(pb);
            }
        }
        else if ((pb.isCollab || pb.isCollabInfo) && UserInfo.getUserType() != 'Guest') {
            renderCollab(pb);
        }
        else if (String.isNotEmpty(pb.gridHeaderId)) {
            renderGrid(pb);
        }
        else if (pb.isMapBlock) {
            renderMap(pb, tab);
        }
        else if (String.isNotEmpty(pb.chartConfigId) && (pb.recordTypeName == 'Charts')) {
            renderChart(pb);
        }
        else if (String.isNotEmpty(pb.chartConfigId) && (pb.recordTypeName == 'Enhanced Chart')) {
            renderEnhancedChart(pb);
        }
        else if (pb.isApprovalHistoryList && isPreview == false) {
            renderApprovalHistory(pb,totalBlocks);
        }
        else if (pb.recordTypeName == 'Fields') {
            renderPageBlockFields(pb, hideBlockTitle, totalBlocks);
        }
        else if (pb.recordTypeName == 'Communication') {
            renderCommunicationTable(pb,totalBlocks);
        }
        else if (pb.isRecordHistory) {
            renderRecordHistoryTable(pb, totalBlocks);
        }
        else if (pb.isWBS) {
            renderWBS(pb);
        }
    }

    private void renderCaptcha(PageLayoutConfigHelper.PageBlock pb){
        if(pb.captchaFieldAPIName != null && layoutHolder.recordId != null){
            Id pageRecordId = layoutHolder.recordId;
            String sObjName = pageRecordId.getSObjectType().getDescribe().getName();
            SObject obj = layoutHolder.recordMap.get(sObjName);
            Object captchaFieldValue = AppUtils.getFieldValue(obj, pb.captchaFieldAPIName); 
            if(captchaFieldValue != null && (captchaFieldValue == 'false' || captchaFieldValue == false)){
                html += '<div>';
                html += '<span id="' +pb.pageBlockId + 'pageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\' ' + pb.title + ' \',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'\'}"> ' + pb.title + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
                addHTMLToBody();
                Component.Captcha captcha = new Component.Captcha(fieldName=pb.captchaFieldAPIName ,recordsId=layoutHolder.recordId);
                body.childComponents.add(captcha);
                html += '</div>';    
            }
        }
    }

    private void renderFormLayoutTable(PageLayoutConfigHelper.PageBlock pb, Integer totalBlocks) {
        Integer noOfPageBlocks = totalBlocks;
        html += '<div>';
        html += '<span id="' +pb.pageBlockId + 'pageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\' ' + pb.title + ' \',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'\'}"> ' + pb.title + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
        addHTMLToBody();
        Component.FormLayouts c = new Component.FormLayouts(
        layoutId=layoutHolder.layoutId,
        pageBlockSize = noOfPageBlocks,
        packageId = layoutHolder.packageId == null ? '' : layoutHolder.packageId,
        formTypes = (layoutHolder.formTypes != null && layoutHolder.formTypes.size()>0)?JSON.serialize(layoutHolder.formTypes):'',
        pageBLockId= (pb!=null)?pb.pageBlockId:'',
        isPreview = this.isPreview);
        body.childComponents.add(c);
        html += '</div>';
    }
    private void renderWBS(PageLayoutConfigHelper.PageBlock pb) {
        html += '<span id="' + pb.flexTableName + 'flexTable" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'FlexTable\',\'title\':\''+ pb.skipNavFlexTableHeaderName + '\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.flexTableName+'FlexTable\'}">' + pb.skipNavFlexTableHeaderName + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
        html += '<div>';
        addHTMLToBody();
        Component.WBS c = new Component.WBS(wbsGridName=pb.flexTableName,paramtersMap=flexTableParameters);
        body.childComponents.add(c);
        html += '</div>';
    }
    
    private void renderFlexTable(PageLayoutConfigHelper.PageBlock pb,Integer totalBlocks) {
        html += '<span id="' + pb.flexTableName + 'flexTable" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'FlexTable\',\'title\':\''+ pb.skipNavFlexTableHeaderName + '\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.flexTableName+'FlexTable\'}">' + pb.skipNavFlexTableHeaderName + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
        html += '<div>';
        addHTMLToBody();
        Map<String,Object> tableParamMap = new Map<String, Object>();
        if (String.isNotEmpty(flexTableParameters)) {
            tableParamMap = (Map<String,Object>) JSON.deserializeUntyped(flexTableParameters);
        }
        if (tableParamMap == null) {
            tableParamMap = new Map<String, Object>();
        }
        Integer noOfPageBlocks = totalBlocks;

        tableParamMap.put('pageBlockId', pb.pageBlockId);
        String tableParamStr = JSON.serialize(tableParamMap);
        if(pb.recordTypeName == 'Flex Table Enhanced'){
            if( objMetadataHolder != null && objMetadataHolder.BooleanValue__c && objMetadataHolder.TextValue__c.contains('flexTable')){
                String listParamsLwc = listParams.replaceAll('"', ''); 
                String tableParamStrLwc = tableParamStr.replaceAll('"', ''); 
                Component.LightningComponent  c1= new Component.LightningComponent( lightningComponentName='flexTableLWC', params='name='+pb.flexTableName+';stringParameters='+tableParamStrLwc+';listParameters='+listParamsLwc+';mode='+'View',isLWC='true');    
                body.childComponents.add(c1); 
            }else{
            Component.FlexTableEnhanced c = new Component.FlexTableEnhanced(tableName=pb.flexTableName,
                stringParameters=tableParamStr,
                listParameters=listParams,
                pBlockId=pb.pageBlockId,
                isPreview=isPreview,
                mode='View');
            body.childComponents.add(c);
            }
            
        }else{
            Component.FlexTable c = new Component.FlexTable(isPreview=isPreview, 
                pageBlockSize = noOfPageBlocks,
                pgLayoutName=layoutHolder.layout.Name,
                skipNavTabName = pb.skipNavTabName,
                flexTableName=pb.flexTableName, 
                tableId=pb.flexTableName, 
                listParams=listParams, 
                flexTableParameters=tableParamStr, 
                insideDynamicLayout=true, 
                headerDescription=pb.flexHeaderDesc == null ? '' : pb.flexHeaderDesc, 
                sObjectOfFieldHistory=layoutHolder.objName, 
                isFieldHistoryFlexTable=pb.isFieldHistory == null ? false : pb.isFieldHistory, 
                isModalWindow = isModal,
                mode = layoutHolder.isViewLayout == true?'View':'Edit',
                parentRecord=layoutHolder.recordId != null ? layoutHolder.recordId : '');
            body.childComponents.add(c);
        }
        
        html += '</div>';
    }
    
    @TestVisible
    private void renderFormTable(PageLayoutConfigHelper.PageBlock pb) {
        String formTableName = 'FormEnhancedTable';
        if(String.isNotEmpty(pb.flexTableName)){
            formTableName = pb.flexTableName;
        }
        
        String flexTableHeaderName = String.isEmpty(pb.title) ? 'Messages' : pb.title;
        html += '<span id="'+formTableName+'flexTable" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'FlexTable\',\'title\':\''+flexTableHeaderName+'\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+formTableName+'FlexTable\'}"> '+flexTableHeaderName+' </span>'; /*<!-- For 508 SkipNavigation  -->*/
        if (isPreview) return;
        html += '<div>';
        addHTMLToBody();

        Map<String,Object> tableParamMap = new Map<String, Object>();
        if (String.isNotEmpty(flexTableParameters)) {
            tableParamMap = (Map<String,Object>) JSON.deserializeUntyped(flexTableParameters);
        }
        if (tableParamMap == null) {
            tableParamMap = new Map<String, Object>();
        }
        tableParamMap.put('recordId', layoutHolder.recordId);
        String tableParamStr = JSON.serialize(tableParamMap);
       
        Component.FlexTable c = new Component.FlexTable(isPreview=isPreview, 
                pgLayoutName=layoutHolder.layout.Name,
                skipNavTabName = pb.skipNavTabName,
                flexTableName=formTableName , 
                tableId=formTableName , 
                listParams=listParams, 
                flexTableParameters=tableParamStr, 
                insideDynamicLayout=true, 
                headerDescription=pb.flexHeaderDesc == null ? '' : pb.flexHeaderDesc, 
                sObjectOfFieldHistory=layoutHolder.objName, 
                isFieldHistoryFlexTable=false, 
                flexTableHeader=String.isEmpty(pb.title) ? '' : pb.title,
                parentRecord=layoutHolder.recordId != null ? layoutHolder.recordId : '');
        body.childComponents.add(c);
        if(String.isEmpty(pb.title)){
            html += '<span class="hidden508">No Data</span>';
        }
        html += '</div>';
        addHTMLToBody();
    }

    private void renderCommunicationTable(PageLayoutConfigHelper.PageBlock pb, Integer totalBlocks) {
        Integer noOfPageBlocks = totalBlocks;
        String communicationTableName = 'CommunicationHistory';
        String flexTableHeaderName = String.isEmpty(pb.title) ? 'Messages' : pb.title;
        html += '<span id="'+communicationTableName+'flexTable" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'FlexTable\',\'title\':\''+flexTableHeaderName+'\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+communicationTableName+'FlexTable\'}"> '+flexTableHeaderName+' </span>'; /*<!-- For 508 SkipNavigation  -->*/
        if (isPreview) return;
        html += '<div>';
        addHTMLToBody();

        Map<String,Object> tableParamMap = new Map<String, Object>();
        if (String.isNotEmpty(flexTableParameters)) {
            tableParamMap = (Map<String,Object>) JSON.deserializeUntyped(flexTableParameters);
        }
        if (tableParamMap == null) {
            tableParamMap = new Map<String, Object>();
        }
        tableParamMap.put('emailFieldName', pb.communicationFieldName == null ? '' : pb.communicationFieldName);
        String tableParamStr = JSON.serialize(tableParamMap);
       
        Component.FlexTable c = new Component.FlexTable(isPreview=isPreview, 
                pageBlockSize = noOfPageBlocks,
                pgLayoutName=layoutHolder.layout.Name,
                skipNavTabName = pb.skipNavTabName,
                flexTableName=communicationTableName, 
                mode= 'View',
                tableId=communicationTableName, 
                listParams=listParams, 
                flexTableParameters=tableParamStr, 
                insideDynamicLayout=true, 
                headerDescription=pb.flexHeaderDesc == null ? '' : pb.flexHeaderDesc, 
                sObjectOfFieldHistory=layoutHolder.objName, 
                isFieldHistoryFlexTable=false, 
                flexTableHeader=String.isEmpty(pb.title) ? '' : pb.title,
                parentRecord=layoutHolder.recordId != null ? layoutHolder.recordId : '');
        body.childComponents.add(c);
        if(String.isEmpty(pb.title)){
            html += '<span class="hidden508">No Data</span>';
        }
        html += '</div>';
        addHTMLToBody();
    }
    
    private void renderFlexGrid(PageLayoutConfigHelper.PageBlock pb,Integer totalBlocks) {
        Integer noOfPageBlocks = totalBlocks;
        if(isPreview == true){
            if(pb.recordTypeName == 'Flex Grid Enhanced'){
                Component.FlexGridEnhanced c = new Component.FlexGridEnhanced(tableName=pb.flexGridName,
                listParameters=listParams,
                stringParameters=flexTableParameters,
                skipNavTabName = pb.skipNavTabName,
                pBlockId = pb.pageBlockId,
                isPreview=isPreview,
                mode= 'View',
                flexGridType = 'FlexGrid');
                body.childComponents.add(c);
            }else{
                pb.flexTableName = pb.parentFlexTableName;
                renderFlexTable(pb,totalBlocks);
            }           
        }else{
            String flexGridHeaderName = (String)pb.skipNavFlexGridHeaderName != null ? SFDCEncoder.EncodeRichText((String)(String)pb.skipNavFlexGridHeaderName,xssSanitizeStr) : '';
            html += '<span id="' + pb.flexGridName + 'flexGrid" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'FlexGrid\',\'title\':\''+ flexGridHeaderName + '\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.flexGridName+'FlexGrid\'}">' + flexGridHeaderName + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
            html += '<div>';
            addHTMLToBody();
            if(pb.recordTypeName == 'Flex Grid Enhanced'){
                Component.FlexGridEnhanced c = new Component.FlexGridEnhanced(tableName=pb.flexGridName,
                                                                            listParameters=listParams,
                                                                            stringParameters=flexTableParameters,
                                                                            skipNavTabName = pb.skipNavTabName,
                                                                            pBlockId = pb.pageBlockId,
                                                                            isPreview=isPreview,
                                                                            mode = layoutHolder.isViewLayout == true?'View':'Edit',
                                                                            flexGridType = 'FlexGrid'); 
                body.childComponents.add(c);   
            }else{
                Component.FlexGrid c = new Component.FlexGrid(tableId=pb.flexGridName,
                                                            pageBlockSize = noOfPageBlocks,
                                                            listParams=listParams,
                                                            flexTableParameters=flexTableParameters,
                                                            skipNavTabName = pb.skipNavTabName,
                                                            mode = layoutHolder.isViewLayout == true?'View':'Edit'); 

                body.childComponents.add(c);
            }
            html += '</div>'; 
        }     
    }

    private void renderFilesFlexTable(PageLayoutConfigHelper.PageBlock pb,Integer totalBlocks) {
        if(isPreview == true){
            pb.flexTableName = pb.parentFlexTableName;
            renderFlexTable(pb,totalBlocks);
        }else{
            html += '<span id="' + pb.flexGridName + 'flexGrid" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'FlexGrid\',\'title\':\''+ pb.skipNavFlexGridHeaderName + '\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.flexGridName+'FlexGrid\'}">' + pb.skipNavFlexGridHeaderName + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
            html += '<div>';
            addHTMLToBody();
            if(pb.recordTypeName == 'Files'){
                list<string> conDocIdList = new List<string>();
                List<ContentDocumentLink> conLinkList = [SELECT Id,ContentDocumentId FROM ContentDocumentLink 
                                                        WHERE LinkedEntityId =:layoutHolder.recordId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                for(ContentDocumentLink conLink : conLinkList){
                    conDocIdList.add(conLink.ContentDocumentId);
                }
                string condoc =  String.join(conDocIdList, '\',\'');
                string ContentDocLinkId = 'ContentDocumentId in'+ '(\'' +condoc +'\')';


                Map<String,Object> tableParamMap = new Map<String, Object>();
                if (String.isNotEmpty(flexTableParameters)) {
                        tableParamMap = (Map<String,Object>) JSON.deserializeUntyped(flexTableParameters);
                }
                if (tableParamMap == null) {
                    tableParamMap = new Map<String, Object>();
                }

                tableParamMap.put('pageBlockId', pb.pageBlockId);
               tableParamMap.put('ContentDocLinkId', ContentDocLinkId);
        String tableParamStr = JSON.serialize(tableParamMap);
                Component.FlexGridEnhanced c = new Component.FlexGridEnhanced(tableName=pb.flexTableName,
                                                                            listParameters=listParams,
                                                                            stringParameters=tableParamStr,
                                                                            pBlockId=pb.pageBlockId,
                                                                            isPreview=isPreview,
                                                                            flexGridType = 'FlexTable'); 
                body.childComponents.add(c);   
            }
            html += '</div>'; 
        }     
    }

    private void renderFilesLibrary(PageLayoutConfigHelper.PageBlock pb,Integer totalBlocks) {
        String flexTableParameters = String.valueOf(this.layoutHolder.flexTableParameters);
        if(String.isNotBlank(pb.WorkspaceHierarchy) && String.isNotBlank(flexTableParameters)){
            Pattern regexMergeField = Pattern.compile('(\\{!)(.*?)(\\})');
            Matcher regexMatcher = regexMergeField.matcher(pb.WorkspaceHierarchy);
            String keyField;
            while (regexMatcher.find()){//SOQL/SOSL Injection False +ve
                keyField = regexMatcher.group(2);
            }
            Map<String, String> tableParameters = (Map<String, String>)JSON.deserialize(SFDCEncoder.sanitizeJSON(flexTableParameters),Map<String, String>.class); // false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
            if(String.isNotBlank(keyField) && tableParameters != null && tableParameters.containsKey(keyField) && String.isNotBlank(tableParameters.get(keyField))){
                String workspaceId = tableParameters.get(keyField);
                html += '<div class="panel panel-default">';
                html += '<span id="' +pb.pageBlockId + 'pageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\' ' + pb.title + ' \',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'pageBlock\'}"> ' + pb.title + '</span>';
                html += '<div class="panel-heading"><div class="row"><div class="col-xs-6 "><span class="bold-text"><h2 class="panel-title" id="pageHeaderId" tabindex="0" style="display: inline-block;">'+ pb.title +'</h2> </span> </div>';
                html += '</div></div><div class="panel-body">';
                addHTMLToBody();
                Component.WorkSpaceLibrary c = new Component.WorkSpaceLibrary(workspaceId=workspaceId);
                body.childComponents.add(c);
                html += '</div></div>';
            }
        }       
    }
    private void renderNotesAndAttachments(PageLayoutConfigHelper.PageBlock pb) {
         
        html += '<div>';
        html += '<span id="' +pb.pageBlockId + 'pageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\' ' + pb.title + ' \',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'pageBlock\'}"> ' + pb.title + '</span>'; /*<!-- For 508 SkipNavigation  -->*/       
        addHTMLToBody();
        if( objMetadataHolder != null && objMetadataHolder.BooleanValue__c && objMetadataHolder.TextValue__c.contains('attachment')){
             //add LWC Attchemnt component       
             Component.LightningComponent  c1= new Component.LightningComponent( lightningComponentName='attachment', params='parentId='+layoutHolder.recordId+';pblockId='+pb.pageBlockId+';pbTitle='+pb.title,isLWC='true');    
             body.childComponents.add(c1); 
         }else{
        Component.Attachments c = new Component.Attachments(parentObject=layoutHolder.recordId != null ? layoutHolder.recordId : '', 
                title=pb.title != null ? pb.title : '', pbId=pb.pageBlockId, messages=pb.messages,isPreview=isPreview,  
                attachmentClassification=pb.attachmentClassifications == null ? '' :pb.attachmentClassifications , isView=true,isDigitallySigned=false, isHistory=false,headerInstructionText = pb.headerInstructionText == null ? '' : pb.headerInstructionText); 
        body.childComponents.add(c);
         }
        
        html += '</div>'; 
        if (pb.isNotesAttachmentsList) {
            
            html += '<div class="NotesAttach">';
            html += '<span id="' +pb.pageBlockId + 'NotespageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\' Notes \',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'Notes\'}"> Notes </span>'; /*<!-- For 508 SkipNavigation  -->*/
            addHTMLToBody();                                                 
             if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c && objMetadataHolder.TextValue__c.contains('notes')){                 
                Component.LightningComponent  n1= new Component.LightningComponent( lightningComponentName='notes', params='recordId='+layoutHolder.recordId+';pblockId='+pb.pageBlockId,isLWC='true');    
                body.childComponents.add(n1);     
               
           }else{
            Component.Notes n = new Component.Notes(parentObject=layoutHolder.recordId !=null ? layoutHolder.recordId : '', title='Notes',pbId=pb.pageBlockId,isView=true,isPreview = isPreview);
            body.childComponents.add(n);
           }  
            html += '</div>'; 
        }
    }
    
    private void renderDigitallySigned(PageLayoutConfigHelper.PageBlock pb) {
        Component.DigitallySigned c = new Component.DigitallySigned(parentObject=layoutHolder.recordId, 
                title=pb.title, pbId=pb.pageBlockId, messages=pb.messages, 
                attachmentClassification=pb.attachmentClassifications == null ? '' :pb.attachmentClassifications , isView=true, isDigitallySigned=true);
        body.childComponents.add(c);

        if (pb.isNotesAttachmentsList) {
            Component.Notes n = new Component.Notes(parentObject=layoutHolder.recordId !=null ? layoutHolder.recordId : '' , title='Notes');
            body.childComponents.add(n);
        }   
    }
        
    private void renderCollab(PageLayoutConfigHelper.PageBlock pb) {
        html += '<div class="panel panel-default">';       
        html += '<div class="panel-heading">';
        html += '<h3 class="panel-title" tabindex="0">' ;  
        pb.title = String.isNotEmpty(pb.title) ? pb.title : 'My Feed';
        html +='  <a id="' + pb.pageBlockId + 'pageBlock" !=null  data-toggle="collapse" href="#" data-target="#toggleBlock' +pb.pageBlockId  +'" onclick="setTimeout(function(){if(modalHandler(15) != undefined){modalHandler(15);}},300);setCollapseIcon(this.id);"><span class="togglePageBlock fa fa-caret-up "></span >'+ pb.title +'</a>';
        if (String.isNotEmpty(pb.helpText)) {
            pb.helpText = SFDCEncoder.SFDC_HTMLENCODE(pb.helpText);
            html += '&nbsp;<a href="JavaScript:Void(0);" id="'+ pb.pageBlockId +'tooltip" onmouseover="showHelpTooltip(\''+ pb.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ pb.pageBlockId + '\')" onfocus= "showHelpTooltip(\''+ pb.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ pb.pageBlockId + '\')" onblur="hideHelpTooltip(\''+ pb.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ pb.pageBlockId + '\')" style="outline: none !important;">';          
            html += '<span class="fa fa-info helpIcon"></span>'; 
            html += '<span class="hidden508">Help: '+pb.helpText+'</span>';
            html += '</a>';
        }        
        if (GlobalConfigHelper.getEnableAdminSetup()) { 
            html += '<a href="/' + pb.pageBlockId + '?isdtp=vw" target="_blank" title="Edit Page Block Layout" class="class="focusOutline" tabIndex="-1" ">';           
            html += '<span class="fa fa-cog pbSetup pull-right pageLayoutSetupIcon" title="Edit Page Block Layout"></span>';
            html += '<span class="hidden508">Settings</span>';
            html += '</a>';
        }
        html += '<span id="' + pb.pageBlockId + 'pageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\''+ pb.title + '\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'pageBlock\'}">' + pb.title + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
        html += '</h3>';
        html += '</div></div>';
        html += '<div class="CollabMainPage collapse in" id="toggleBlock'+ pb.pageBlockId +'">';       
        addHTMLToBody();
        if (pb == null || pb.isCollab) {          
            Component.Collab c = new Component.Collab();
            c.isEditMode = true;
            c.pageBlockId = pb.pageBlockId;
            body.childComponents.add(c);
        } else if (pb.isCollabInfo) {
            Component.CollabInfo c = new Component.CollabInfo();
            body.childComponents.add(c);
        }
        html += '</div>';
    }
    private void renderGrid(PageLayoutConfigHelper.PageBlock pb) {
        Component.GridLayout c = new Component.GridLayout(layoutHolder=layoutHolder, 
                gridId=pb.gridHeaderId, isViewMode=layoutHolder.isViewLayout, headerLevelInstruction=pb.headerInstructionText!=null?pb.headerInstructionText:'');
       body.childComponents.add(c);
    }
    private void renderMap(PageLayoutConfigHelper.PageBlock pb, PageLayoutConfigHelper.Tab tab) {
        Component.MapView c = new Component.MapView(isPreview=isPreview, 
                mapClass=pb.mapClassName, tabId=tab.tabId, headerTitle=pb.title);
        body.childComponents.add(c);
    }
    private void renderChart(PageLayoutConfigHelper.PageBlock pb) {
        Component.ChartComponent c = new Component.ChartComponent(chartType=pb.chartRecordType, 
                chartName=pb.chartConfigName, ChartHTMLId=pb.ChartId, ChartParameters=chartParameters, 
                contextRecordId=layoutHolder.recordId);
        body.childComponents.add(c);

    }
    private void renderEnhancedChart(PageLayoutConfigHelper.PageBlock pb) {
        Component.EnhancedChart c = new Component.EnhancedChart(chartName=pb.chartConfigName, 
            ChartHTMLId=pb.ChartId, ChartParameters=chartParameters,           
            contextRecordId=layoutHolder.recordId);
        body.childComponents.add(c);
    }
    private void renderApprovalHistory(PageLayoutConfigHelper.PageBlock pb, Integer totalBlocks) {
        Integer noOfPageBlocks = totalBlocks;
        
        if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c && objMetadataHolder.TextValue__c.contains('approvalHistory')){  
           Component.LightningComponent  c1= new Component.LightningComponent( lightningComponentName='approvalHistory', params='recordId='+layoutHolder.recordId,isLWC='true');    
           body.childComponents.add(c1);   
                    
        }else{
        Component.ApprovalHistory c = new Component.ApprovalHistory(pageBlockSize = noOfPageBlocks);
        body.childComponents.add(c);
        }
           
    }
    private void renderRecordHistoryTable(PageLayoutConfigHelper.PageBlock pb, Integer totalBlocks) {
         Integer noOfPageBlocks = totalBlocks;
         if(objMetadataHolder != null && objMetadataHolder.BooleanValue__c && objMetadataHolder.TextValue__c.contains('snapshotHistory')){  
        Component.LightningComponent  c1= new Component.LightningComponent( lightningComponentName='snapshotHistory', params='parentId='+layoutHolder.recordId+';pblockId='+pb.pageBlockId,isLWC='true');    
        body.childComponents.add(c1); 
         }else{
        Component.Attachments c = new Component.Attachments(parentObject=layoutHolder.recordId != null ? layoutHolder.recordId : '', 
                title=pb.title != null ? pb.title : '', pageBlockSize = noOfPageBlocks, pbId=pb.pageBlockId, messages=pb.messages, isPreview=isPreview,  
                attachmentClassification=pb.attachmentClassifications == null ? '' :pb.attachmentClassifications , isView=true, isHistory=true);
        body.childComponents.add(c);
    }
                
    }
    private void renderPageBlockFields(PageLayoutConfigHelper.PageBlock pb, Boolean hideBlockTitle, Integer totalBlocks) {
        if(!isOverview){
            html += '<div class="tab-inner-content">';
            html += '<div class="panel panel-default">';                
            html += '<div class="panel-heading">';
            renderPageBlockHeader(pb, totalBlocks); 
            html += '</div>';           
        }
        html += '<div id="toggleBlock'+ pb.pageBlockId +'"  class="panel-body collapse in">';

        if(String.isEmpty(pb.headerInstructionText) == false) {
                    html += '<div class="row"><div class="col-md-12"><span class="pbNormalText" tabindex="0">'+ pb.headerInstructionText +'</span></div></div>';
        }
             
        if(!isOverview){                         
            renderPageMessages(pb);
        }
        
        Integer colLength = 0;
        Boolean newRow = true;
        if(pb.pbSections.size() > 0 ) {
            html += '<div class="row"><div class="textFieldWrapFlex">';
        }
        Set<String> fieldsToHide = new Set<String>();
        for (PageLayoutConfigHelper.PageBlockSection pbSection : pb.pbSections) {
            for (PageLayoutConfigHelper.Field f : pbSection.fields) {
                if(String.isNotEmpty(f.hideFieldsJSON)){
                    String hideVal=''; 
                    list<Map<String,String>> hideValuesMap = (List<Map<String,String>>)JSON.deserialize(f.hideFieldsJSON, List<Map<String,String>>.class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
                    String selectedValue = String.valueof(layoutHolder.getFieldValue(f));
                    for(Map<String,String> mapVal : hideValuesMap){
                        String operation = mapVal.get('Action');
                        if(String.isempty(operation) || operation == 'hide'){
                            String fieldToHideApiname = mapVal.get('FieldToHide');
                            String operator = mapVal.get('Operator');
                            if(f.dataType =='REFERENCE'){
                                sObject objVal;
                                objVal = layoutHolder.recordMap.get(f.getAdjustedObjectAPIName());
                                if(objVal !=null){
                                    string objName = f.getAdjustedFieldAPIName().replace('__c','__r');
                                    if(objVal.getSobject(objName)!=null){
                                        selectedValue = (String)objVal.getSobject(objName).get('Name');
                                    }
                                } 
                            }
                            hideVal = mapVal.get('FieldValue'); 
                            
                            hideVal = Apputils.removeDecimalPart(hideVal);
                            selectedValue = Apputils.removeDecimalPart(selectedValue);
                            if(operator == '=='){
                                if(String.isNotBlank(selectedValue)){
                                    if(selectedValue == hideVal ){
                                        fieldsToHide.add(fieldToHideApiname);
                                    }
                                }else if(String.isBlank(hideVal) ){
                                    fieldsToHide.add(fieldToHideApiname);
                                }
                            }else if(operator == '!='){
                                if(String.isNotBlank(selectedValue)){
                                    if(selectedValue != hideVal ){
                                        fieldsToHide.add(fieldToHideApiname);
                                    }
                                }else if(String.isNotBlank(hideVal)){
                                    fieldsToHide.add(fieldToHideApiname);
                                }
                           }else if(operator == 'IN'){
                                List<String> splittedFields = new List<String>();
                                splittedFields = hideVal.split(',');
                                Set<String> splittedSet = new Set<String>();
                                splittedSet.addAll(splittedFields);
                                if(f.dataType == 'MULTIPICKLIST' || (f.altRen != null && f.altRen.typex == 'Checkbox') ){
                                    if(selectedValue != NULL){
                                        Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(layoutHolder.layout.objectName,f.fieldAPIName);
                                        List<String> picklistValues = new List<String>();
                                        if(String.isNotEmpty(selectedValue)){
                                             picklistValues = selectedValue.split(';');
                                        }
                                        for(String values : picklistValues){                    
                                            for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                                                 String label = ple.getValue();
                                                 if(label == values){
                                                    if(splittedSet.contains(label)){
                                                        fieldsToHide.add(fieldToHideApiname);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }else{
                                    if(splittedSet.contains(selectedValue)){
                                        fieldsToHide.add(fieldToHideApiname);
                                    }
                                }
                            }else if(operator == 'NOT IN'){
                                List<String> splittedFields = new List<String>();
                                splittedFields = hideVal.split(',');
                                Set<String> splittedSet = new Set<String>();
                                splittedSet.addAll(splittedFields);
                              
                                if(f.dataType == 'MULTIPICKLIST' || (f.altRen != null && f.altRen.typex == 'Checkbox') ){
                                    if(selectedValue != NULL){
                                        Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(layoutHolder.layout.objectName,f.fieldAPIName);
                                        List<String> picklistValues = new List<String>();
                                        if(String.isNotEmpty(selectedValue)){
                                             picklistValues = selectedValue.split(';');
                                        }
                                        Boolean checkForHideField = false;
                                        for(String values : picklistValues){                    
                                            for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                                                 String label = ple.getValue();
                                                
                                                 if(label == values){
                                                    if(splittedSet.contains(label)){
                                                        checkForHideField = true ;
                                                    }
                                                }
                        
                                            }
                                        }
                                        if(checkForHideField == false){
                                            fieldsToHide.add(fieldToHideApiname);
                                        }
                                    }else{
                                        fieldsToHide.add(fieldToHideApiname);
                                    }
                                }else{
                                    if(splittedSet.contains(selectedValue) == false ){
                                        fieldsToHide.add(fieldToHideApiname);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        for (PageLayoutConfigHelper.PageBlockSection pbSection : pb.pbSections) {
            for (PageLayoutConfigHelper.Field f : pbSection.fields) {
                
                    if ((f.isHiddenField || f.hideField == 'true' || f.fieldType == 'Captcha' ) && !isEditLayout) continue;
                    // in case of hidden field we should calulate next hideen field but no need to generate html
                    if(f.fieldAPIName!=null && fieldsToHide.contains(f.fieldAPIName) && !isEditLayout) {
                         new FlexLayoutFieldsPreviewGenerator(layoutHolder, body, f);
                         continue;
                    } 
                                       
                        if(f.fieldAPIName!=null && fieldsToHide.contains(f.fieldAPIName) && isEditLayout){
                            html += '<div id="field'+f.getAdjustedFieldAPIName()+'" class="'+pbSection.className+' textFieldWrap"  style="display: none;">';
                        }else if(f.dataType == 'TEXTAREA'){
                           if(f.isRichTextAreTrue ){
                            html += '<div id="field'+f.dataType+f.getAdjustedFieldAPIName()+'" class="'+pbSection.className+' textFieldWrap richTextAreaField">';
                            }else{
                                html += '<div id="field'+f.dataType+f.getAdjustedFieldAPIName()+'" class="'+pbSection.className+' longTextAreaCss textFieldWrap richTextAreaField">';
                            }
                        }else{
                            html += '<div id="field'+f.getAdjustedFieldAPIName()+'" class="'+pbSection.className+' textFieldWrap">';
                        }                      
                        html += '<dl>';
                        if(f.fieldType != 'PageBlockSeparator') {
                            if (isPreview) {
                                html += new FlexLayoutFieldsPreviewGenerator(layoutHolder, body, f).generate();
                            } else if(isEditLayout){
                                addHTMLToBody();                               
                                //new FlexLayoutFieldsEditGenerator(layoutHolder, body, f).generate();

                            }else{
                                //html += new FlexLayoutFieldsViewGenerator(layoutHolder, body, f).generate();   
                            }
                        }
                        html += '</dl>';
                    html += '</div>';
                    if(f.fieldType == 'PageBlockSeparator'){
                   html+=' <div class="panel-heading pageBlockSeparator"  style="'+ (f.fieldType == 'PageBlockSeparator'?'display: block':'display:none') +'"><h3 class="panel-title" tabindex="0"><a>'+ f.fieldLabel + '</a>';
                    if (String.isNotEmpty(f.helpText)) {
                        f.helpText = SFDCEncoder.SFDC_HTMLENCODE(f.helpText);
                        html += '&nbsp;<a href="JavaScript:Void(0);" id="'+ f.fieldLabel +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ f.fieldLabel + '\')" onfocus= "showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ f.fieldLabel + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ f.fieldLabel + '\')" style="outline: none !important;">';          
                        html += '<span class="fa fa-info helpIcon"></span>'; 
                        html += '<span class="hidden508">Help: '+f.helpText+'</span>';
                        html += '</a>';
                    }   
                    html += '</h3>';
                    html += '</div>';
                }
                String colLengthString = pbSection.className.split(' ')[0].removeStart('col-md-');
                colLength += Integer.ValueOf(colLengthString);
                if(colLength < 12){                 
                    newRow = false;
                }else{
                    newRow = true;
                    colLength = 0;
                }
            }
        }
        if(pb.pbSections.size() > 0 ) {
            html += '</div></div>';
        }
        html += '</div>';
        if(!isOverview){
            html += '</div></div>';
        }
    }
    
    private void renderPageBlockHeader(PageLayoutConfigHelper.PageBlock pb, Integer totalBlocks ) {
        html += '<div>';
        html += '<h3  class="panel-title" tabindex="0">' ;    
        Integer noOfPageBlocks = totalBlocks;
       if(String.isNotEmpty(pb.title))
        html += '  <a id="' + pb.pageBlockId + 'pageBlock" '+ ( noOfPageBlocks == 1 ? '' : ' data-toggle="collapse" href="#" data-target="#toggleBlock') + '' + pb.pageBlockId  +'" onclick="setTimeout(function(){if(modalHandler(15) != undefined){modalHandler(15);}},300);setCollapseIcon(this.id);"><span class="'+(noOfPageBlocks == 1 ? '' : 'togglePageBlock fa fa-caret-up') + '"></span >'+ pb.title+'</a>';
        
              
        if (String.isNotEmpty(pb.helpText)) {
            pb.helpText = SFDCEncoder.SFDC_HTMLENCODE(pb.helpText);
            html += '&nbsp;<a href="JavaScript:Void(0);" id="'+ pb.pageBlockId +'tooltip" onmouseover="showHelpTooltip(\''+ pb.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ pb.pageBlockId + '\')" onfocus= "showHelpTooltip(\''+ pb.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ pb.pageBlockId + '\')" onblur="hideHelpTooltip(\''+ pb.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ pb.pageBlockId + '\')" style="outline: none !important;">';          
            html += '<span class="fa fa-info helpIcon"></span>'; 
            html += '<span class="hidden508">Help: '+pb.helpText+'</span>';
            html += '</a>';
        }   
        
        if (GlobalConfigHelper.getEnableAdminSetup()) { 
            html += '<a href="/' + pb.pageBlockId + '?isdtp=vw" target="_blank" title="Edit Page Block Layout" class="class="focusOutline" tabIndex="-1" ">';           
            html += '<span class="fa fa-cog pbSetup pull-right pageLayoutSetupIcon" title="Edit Page Block Layout"></span>';
            html += '<span class="hidden508">Settings</span>';
            html += '</a>';
        }
        html += '<span id="' + pb.pageBlockId + 'pageBlock" class="hidden508 skipNavSectionItem" name="{\'tabName\':\'' + pb.skipNavTabName + '\',\'type\':\'pageBlock\',\'title\':\''+ pb.title + '\',\'tabId\':\''+pb.tabId+'tab\',\'pageBlockId\':\''+pb.pageBlockId+'pageBlock\'}">' + pb.title + '</span>'; /*<!-- For 508 SkipNavigation  -->*/
        html += '</h3>';

        html += '</div>';
    }
    private void renderPageMessages(PageLayoutConfigHelper.PageBlock pb) {
        if (pb.messages.hasMessagesToRender && !isPreview) {
            html += '<div class="col-md-12">';
            addHTMLToBody();
            Component.DynamicPageMessages m = new Component.DynamicPageMessages(messageHolder=pb.messages);
            body.childComponents.add(m);
            if(String.isEmpty(pb.headerInstructionText) == false){
            html += pb.headerInstructionText;
            }
            html += '</div>';
        }       
    }
    private void addHTMLToBody() {
        if (String.isNotEmpty(html)) {
            body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
            html = '';
        }       
    }
        @TestVisible 
     public with sharing class FlexLayoutWrapper{
        @AuraEnabled
        public list<sObject> ObjectList {get;set;}
        @AuraEnabled
        public Map<String, String> fieldKeyMap {get;set;}
        @AuraEnabled
        public Map<String, String> fieldDataMap {get;set;}
        @AuraEnabled
        public Map<String, Integer> scale {get;set;}
        @AuraEnabled
        public String timelol {get;set;}   
        @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public FlexLayoutWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label){
            this.ObjectList = sObjectList;
            this.fieldKeyMap = fieldLableMap;
            this.fieldDataMap = fieldDataTypeMap;
            this.scale = scaleMap;
            this.timelol = (UserInfo.getTimeZone()).toString();
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }
    
      @TestVisible 
     public with sharing class FlexlayoutGeneratorWrapper{
           @AuraEnabled
         public String userLol {get;set;}
        @AuraEnabled
        public String field {get;set;}
         @AuraEnabled
        public String requiredfield {get;set;}
         @AuraEnabled
        public String testrequired {get;set;}
         @AuraEnabled
        public String fieldlabel {get;set;}
         @AuraEnabled
        public String key {get;set;}
         

        public FlexlayoutGeneratorWrapper(String label){
            this.userLol =UserInfo.getLocale();
            this.field = label;
            this.requiredfield = label;
            this.testrequired = label;
            this.fieldlabel = label;
            this.key  = label;
        }
    }
}