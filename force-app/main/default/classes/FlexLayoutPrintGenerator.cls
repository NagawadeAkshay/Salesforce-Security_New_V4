/**
    It generates tabs for Print layout only. 
*/
public with sharing class FlexLayoutPrintGenerator {
    private transient DynamicLayoutHolder layoutHolder;
    private transient String html = '';
    private transient String indexhtml = '';
    private transient Component.Apex.OutputPanel body;
    private transient Boolean isPreview = false;
    private transient String flexTableParameters;
    private transient String chartParameters;
    private transient String listParams;
    private transient String subHeader;
    private transient boolean isOverview = false;
    public boolean isOverviewEnable = false;
    private Boolean isModal = false;
    public static Boolean isPrint = false;
    private transient Boolean showForms = false;
    
    public static  String selectedLayotId;
    public static transient Boolean isFormSelected = false;
    public static transient DynamicLayoutHolder selectedLayoutHolder;

    public FlexLayoutPrintGenerator(DynamicLayoutHolder layoutHolder, Boolean isPreview, String flexTableParameters, 
                    String listParams, String chartParameters,String subHeader ) {
        this(layoutHolder, isPreview, flexTableParameters, listParams, chartParameters,subHeader, false);
    }

    public FlexLayoutPrintGenerator(DynamicLayoutHolder layoutHolder, Boolean isPreview, String flexTableParameters, 
                    String listParams, String chartParameters,String subHeader, Boolean isModal) {
        this.layoutHolder = layoutHolder;  
        selectedLayoutHolder = layoutHolder;
        this.isPreview = isPreview == null ? false : isPreview;        
        this.flexTableParameters = flexTableParameters == null ? '' : flexTableParameters;
        this.listParams = listParams == null ? '' : listParams;
        this.chartParameters = chartParameters == null ? '' : chartParameters;
        this.body = new Component.Apex.OutputPanel();
        this.isModal = isModal;
        isPrint = true;
        this.subHeader = subHeader;
    }

    public Component.Apex.OutputPanel generate() {
        html += '<div id="myTabs" class="">';
        processFlexTables();
        isFormSelected = false;
        if(layoutHolder != null){
            generateHeader();
            isOverview = false;
            renderTabsBody(layoutHolder.layout, false);
        }
        
        addHTMLToBody();

        
    
        if(showForms == true) {
            if(layoutHolder.formLayouts != null) {
    
                for(PageLayoutConfigHelper.Layout layout : layoutHolder.formLayouts) {
        
                    selectedLayotId = layout.layoutId;
                    isFormSelected = true;
                    if(layoutHolder.formRecordMap.get(selectedLayotId) != null) {
                        html += '</div><div style="page-break-after:always;"></div>';  
                        
                        generateFormHeader(layout, layoutHolder.formRecordMap.get(selectedLayotId));
                        renderTabsBody(layout, true);
                    }
                }
            }
        }
        indexhtml += '<div style="page-break-after:always;"></div>';
        Boolean enablePDFIndex = KeyValueStoreHelper.getBooleanValue('EnablePDFIndex',true);
        if(enablePDFIndex != null && enablePDFIndex){
            addIndexToHTML(); 
        }
        return body;
    }
    
    @TestVisible
    private void generateFormHeader(PageLayoutConfigHelper.Layout layout, SObject obj) {
        if(layout.header != null ) {
            List<String> mergeFields = AppUtils.getMergeFields(layout.header);
            if(mergeFields.size() > 0){
                for(String field:mergeFields){
                    if(obj.get(field) != null)
                    layout.header = layout.header.replace('{!'+field+'}',string.valueOf(obj.get(field)));
                    else
                    layout.header = layout.header.replace('{!'+field+'}','');
                }   
            }
        }
        html += '<div class="pageHeader">Form - ' + (layout.header != null ? layout.header : '') + '</div>';
    }
    
    @TestVisible
    private void processFlexTables() {
        if(layoutHolder != null) {
            for (PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs) {
             
                if (tab.SkipForExport != true && (tab.hideTab != 'true' && tab.isOverview != true)) {
                    for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                        for (PageLayoutConfigHelper.PageBlock block : blocks) {
                            if (String.isNotEmpty(block.flexTableId) && block.isWBS != true) {
                                FlexTableExportCtrl.addFlexTable( block.flexTableName, layoutHolder.recordId );
                            }
                        }
                    }
                }
            } 
        
            if(layoutHolder.formLayouts != null) {
        
                for(PageLayoutConfigHelper.Layout layout : layoutHolder.formLayouts) {
                    for (PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs) {
                        if (tab.SkipForExport != true && (tab.hideTab != 'true' && tab.isOverview != true)) {
                            for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                                for (PageLayoutConfigHelper.PageBlock block : blocks) {
                                    if (String.isNotEmpty(block.flexTableId) && block.isWBS != true) {
                                        FlexTableExportCtrl.addFlexTable( block.flexTableName, (String)layoutHolder.formRecordMap.get(layout.layoutId).get('Id') );
                                    }
                                }
                            }
                        }
                    }
                }
                    
            }
            FlexTableExportCtrl.getTableRecords();
        }
    }

    public Component.Apex.OutputPanel generateHeader(){
        isOverview = true;
        html += '<div class="pageHeader">' + subHeader +'</div>' ;
        
        if(layoutHolder != null){
            renderHeaderOverviewBody();
        }
        addHTMLToBody();
        return body;   
    }

    /* PRIVATE METHODS */
     private void renderTabsBody(PageLayoutConfigHelper.Layout layout, Boolean isForm) {
        html += '<div id="myTabbedContent" class="tab-content">';
       
        integer i=0;
        integer tabSize = layout.tabs.size();
        if(isOverviewEnable){
            tabSize = tabSize-1;
        }
        for (PageLayoutConfigHelper.Tab tab : layout.tabs) {
             
            if (tab.SkipForExport != true && (tab.hideTab != 'true' && tab.isOverview != true)) {
                indexhtml += '<div class="top-go-link"><strong><dl><dt><a href="#abc'+i+'">'  + tab.Name + '</a></dt></dl></strong></div>'; 
                html += '<div class="" style="" id="abc'+i+'">';
                if(tabSize > 1){ 
                    html += '<div class="tabTittle">' + tab.Name + '</div>';
                }
                html += '<hr class="tabline">';
                html += '<div class="tabSection">';
                Integer activePageBlockCount = 0;    
                for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                    html += '<div>';
                    for (PageLayoutConfigHelper.PageBlock block : blocks) {
                        if (block.SkipForExport == true || (block.isHiddenPageBlock || block.hidePageBlock == 'true' ) || block.recordTypeName == 'ReCaptcha') continue;
                        indexhtml += '<div class="inner-go-link"><dl><dt><a href="#abcd'+i+'">' + block.title + '</a></dt></dl></div>';
                        html += '<div class="" style="" id="abcd'+i+'">';
                        
                        if(block.isFormTable) {
                            showForms = true;
                            continue;
                        }
						if(block.recordTypeName == 'Form Enhanced') {
                        	showForms = true;
                        }
                        renderPageBlock(block, tab, blocks.size(), isForm ? layout.layoutId : '');
                        activePageBlockCount++;
                        html += '</div>'; 
                    }
                    html += '</div>';   
                }
                html += '</div></div>';
                if(activePageBlockCount == 0) {
                    html = '';
                }
                
                addHTMLToBody();
            }
            i++;
        }
        html += '</div>';   
    }

    @TestVisible
    private void renderHeaderOverviewBody() {       
        for (PageLayoutConfigHelper.Tab tab : layoutHolder.layout.tabs) {
            if (tab.isOverview == true && tab.hideTab != 'true') {
                isOverviewEnable = true;
                html += '<div class="overview-pane" id="' + tab.tabId + '">';
                for (List<PageLayoutConfigHelper.PageBlock> blocks : tab.getFormattedPageBlocks()) {
                    for (PageLayoutConfigHelper.PageBlock block : blocks) {
                        if ((block.skipForExport || block.isHiddenPageBlock || block.hidePageBlock == 'true') && (block.recordTypeName != 'Form Enhanced')) {
                            continue;
                        }
                        renderPageBlock(block, tab, blocks.size(), '');
                    }
                }
                html += '</div>';
            }            
        }         
    }

    private void renderPageBlock(PageLayoutConfigHelper.PageBlock pb, PageLayoutConfigHelper.Tab tab, Integer totalBlocks, String layoutId) {
        Boolean hideBlockTitle = totalBlocks == 1;
        addHTMLToBody();
        if ((String.isNotEmpty(pb.flexTableId)) && (pb.isWBS != true || pb.recordTypeName == 'Form Enhanced')) {
           
            renderFlexTable(pb, layoutId);
        }
        else if (String.isNotEmpty(pb.flexGridId)) {
            renderFlexGrid(pb,layoutId);
        }
        else if (pb.isNotesAttachmentsList || pb.isAttachment) {
            renderNotesAndAttachments(pb);
        }
        else if (pb.isApprovalHistoryList && isPreview == false) {
            renderApprovalHistory(pb);
        }
        else if (pb.recordTypeName == 'Fields') {
            renderPageBlockFields(pb, hideBlockTitle, layoutId);
        }
        else if(pb.recordTypeName == 'Communication'){
            renderCommunicationTable(pb);
        }
        else if (pb.isRecordHistory) {
        }

    }
    
    private void renderFlexTable(PageLayoutConfigHelper.PageBlock pb, String layoutId) {
        html += '<div>';
        addHTMLToBody();
        FlexTableExportCtrl flxTblExpCtrl = new FlexTableExportCtrl();
        if( pb.flexTableName == null && pb.recordTypeName == 'Form Enhanced'){    
            pb.flexTableName = 'FormEnhancedTable';
         }
        body.childComponents.add(flxTblExpCtrl.createFlextblExportForPrint(pb.flexTableName, 'pdf'));
        html += '</div>';
    }

    @TestVisible
    private void renderCommunicationTable(PageLayoutConfigHelper.PageBlock pb) {
        if (isPreview) return;
        html += '<div>';
        addHTMLToBody();
        FlexTableExportCtrl flxTblExpCtrl = new FlexTableExportCtrl();
        if( pb.flexTableName == null){
            pb.flexTableName = 'CommunicationHistory';
        }
        body.childComponents.add(flxTblExpCtrl.createFlextblExportForPrint(pb.flexTableName, 'pdf'));
        if(String.isEmpty(pb.title)){
            html += '<span class="hidden508">No Data</span>';
        }
        html += '</div>';
    }
    private void renderFlexGrid(PageLayoutConfigHelper.PageBlock pb, String layoutId) {
        html += '<div>';
        addHTMLToBody();
        String recordTypeDeveloperName;
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible()){
            recordTypeDeveloperName = [select Id, RecordType.developerName from FlexGridConfig__c 
                                         where Id=:pb.flexGridId WITH USER_MODE].RecordType.developerName;
        }
        if(recordTypeDeveloperName == 'BudgetGrid') {
            Component.BudgetGridExport c = new Component.BudgetGridExport(gridName=pb.flexGridName);
            body.childComponents.add(c);
        } else if(recordTypeDeveloperName == 'NestedNavigationGrid') {
            Component.N2GGridExport c = new Component.N2GGridExport(gridName=pb.flexGridName, ExportMode='pdf');
            body.childComponents.add(c);
        } else if(recordTypeDeveloperName == 'MassEditableGrid') {
            String recIdProcess = String.isEmpty(layoutId) ? layoutHolder.recordId : (String)layoutHolder.formRecordMap.get(layoutId).get('Id');
            Component.MassEditableGridExport c = new Component.MassEditableGridExport(gridName=pb.flexGridName, ExportMode='pdf',RecordId=recIdProcess);
            body.childComponents.add(c);
        } else if(recordTypeDeveloperName == 'FlexGridEnhanced'){
            String recIdProcess = String.isEmpty(layoutId) ? layoutHolder.recordId : (String)layoutHolder.formRecordMap.get(layoutId).get('Id');
            Component.EnhancedGridExport c = new Component.EnhancedGridExport(gridName=pb.flexGridName, ExportMode='pdf',parentRecordId=recIdProcess,gridType='FlexGrid');
            body.childComponents.add(c);
        }
        
        html += '</div>';       
    }
    private void renderNotesAndAttachments(PageLayoutConfigHelper.PageBlock pb) {
        Component.AttachmentPDF c = new Component.AttachmentPDF(parentObject=layoutHolder.recordId != null ? layoutHolder.recordId : '', 
                title=pb.title != null ? pb.title : '', isDigitallySigned=false);
        body.childComponents.add(c);

        if (pb.isNotesAttachmentsList) {
            Component.NotesPDF n = new Component.NotesPDF(parentObject=layoutHolder.recordId, title='Notes');
            body.childComponents.add(n);
        } 
    }
    
    @TestVisible
    private void renderDigitallySigned(PageLayoutConfigHelper.PageBlock pb) {        
        Component.DigitallySigned c = new Component.DigitallySigned(parentObject=layoutHolder.recordId, 
                title=pb.title, pbId=pb.pageBlockId, messages=pb.messages, 
                attachmentClassification=pb.attachmentClassifications == null ? '' :pb.attachmentClassifications , isView=true, isDigitallySigned=true);
        body.childComponents.add(c);

        if (pb.isNotesAttachmentsList) {
            Component.Notes n = new Component.Notes(parentObject=layoutHolder.recordId, title='Notes');
            body.childComponents.add(n);
        } 
    }
        
    @TestVisible
    private void renderCollab(PageLayoutConfigHelper.PageBlock pb) {
        html += '<div class="CollabMainPage">';
        addHTMLToBody();
        if (pb == null || pb.isCollab) {
            Component.Collab c = new Component.Collab();
            body.childComponents.add(c);
        } else if (pb.isCollabInfo) {
            Component.CollabInfo c = new Component.CollabInfo();
            body.childComponents.add(c);
        }
        html += '</div>';
        addHTMLToBody();
    }
    private void renderGrid(PageLayoutConfigHelper.PageBlock pb, String layoutId) {
        String recordId = String.isEmpty(layoutId) ? layoutHolder.recordId : (String)layoutHolder.formRecordMap.get(layoutId).get('Id');
        Component.GridLayoutPDF c = new Component.GridLayoutPDF(gridId=pb.gridHeaderId, 
            recordId=recordId, Title='Budget grid');
       body.childComponents.add(c);
    }

    
    private void renderApprovalHistory(PageLayoutConfigHelper.PageBlock pb) {
        Component.ApprovalHistoryExport c = new Component.ApprovalHistoryExport();
        body.childComponents.add(c);
    }
    
    @TestVisible
    private void renderRecordHistoryTable(PageLayoutConfigHelper.PageBlock pb) {
        Component.Attachments c = new Component.Attachments(parentObject=layoutHolder.recordId != null ? layoutHolder.recordId : '', 
                title=pb.title != null ? pb.title : '', pbId=pb.pageBlockId, messages=pb.messages, isPreview=isPreview,  
                attachmentClassification=pb.attachmentClassifications == null ? '' :pb.attachmentClassifications , isView=true, isHistory=true);
        body.childComponents.add(c);
    }
    
    private void renderPageBlockFields(PageLayoutConfigHelper.PageBlock pb, Boolean hideBlockTitle, String layoutId) {
        if(!isOverview){
            html += '<div class="tab-inner-content">';
            html += '<div class="panel panel-default">';                
                html += '<div class="panel-heading">';
                renderPageBlockHeader(pb); 
                html += '</div>';
        }
        Set<String> fieldsToHide = new Set<String>();
        for (PageLayoutConfigHelper.PageBlockSection pbSection : pb.pbSections) {
            for (PageLayoutConfigHelper.Field f : pbSection.fields) {
                if(String.isNotEmpty(f.hideFieldsJSON)){
                    String hideVal='';
                    list<Map<String,String>> hideValuesMap = (List<Map<String,String>>)JSON.deserialize(f.hideFieldsJSON, List<Map<String,String>>.class);  //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved. 
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
                                if(splittedSet.contains(selectedValue)){
                                    fieldsToHide.add(fieldToHideApiname);
                                }
                            }else if(operator == 'NOT IN'){
                                List<String> splittedFields = new List<String>();
                                splittedFields = hideVal.split(',');
                                Set<String> splittedSet = new Set<String>();
                                splittedSet.addAll(splittedFields);
                                if(splittedSet.contains(selectedValue) == false){
                                    fieldsToHide.add(fieldToHideApiname);
                                }
                            }
                        }
                    }
                }
            }
        }

        html += '<div class="">';
        Integer colLength = 0;
        for (PageLayoutConfigHelper.PageBlockSection pbSection : pb.pbSections) {

            Boolean newRow = true;
            Boolean blankSpace = false;
            for (PageLayoutConfigHelper.Field ff : pbSection.fields) {
                if(ff.isBlankSpace){
                    blankSpace = true;
                    break;
                }
            }
            html += '<div class="">';
            for (PageLayoutConfigHelper.Field f : pbSection.fields) {
               if(f.fieldType == 'PageBlockSeparator'){
                    html += ' <div class = "clearFloat"></div><div class="panel-heading pageBlockSeparator" style="display: block;">  <h3  class="panel-title" style="">' ;
                    colLength = 0;
                    if(String.isNotEmpty(f.fieldLabel))
                        html +=  f.fieldLabel;
                        html += '</h3></div> ';
                        html += '<hr class="pageSectionline">';
                }

                if (f.isHiddenField || f.hideField == 'true' || f.skipForExport || f.fieldType == 'Captcha' || f.fieldType == 'PageBlockSeparator' ) continue;
                if(f.fieldAPIName!=null && fieldsToHide.contains(f.fieldAPIName))continue;
                html += '<div class="'+pbSection.className+'">';
                
                html += '<dl class="">';
                try {
                    html += new FlexLayoutFieldsPrintGenerator(layoutHolder, body, f, layoutId).generate();   
                } catch(Exception ex) {
                }
                html += '</dl>';
                html += '</div>';
                
                String colLengthString = pbSection.className.split(' ')[0].removeStart('col-md-');
                colLength += Integer.ValueOf(colLengthString);
                if(colLength < 12){                 
                    newRow = false;
                }else{
                    newRow = true;
                    colLength = 0;
                }
                if(newRow && blankSpace){
                    html += '</div>';
                    html += '<div class="clearFloat">';
                }else if(newRow){
                    html += '</div>';
                    if(!blankSpace){
                        html += '<div class="clearFloat">';
                    }
                }     
            }
            html += '</div>';
        }
        html += '</div><div class="clearFloat"></div>';
        addHTMLToBody();
        
    }
    
    private void renderPageBlockHeader(PageLayoutConfigHelper.PageBlock pb) {
        html += '<div>';
        html += '<div  class="panel-title">' ;
        if(String.isNotEmpty(pb.title))
        html +=  pb.title;
        html += '</div>';
        html += '</div>';
         html += '<hr class="pageSectionline">';
    }
    private void addHTMLToBody() {
        if (String.isNotEmpty(html)) {
            body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
            html = '';
        }       
    }
    
    @TestVisible
    private void addIndexToHTML() {
        Component.Apex.OutputPanel body1 = new Component.Apex.OutputPanel();
        if (String.isNotEmpty(indexhtml)) {
            body1.childComponents.add(new Component.Apex.OutputText(Value=indexhtml, escape=false));
            indexhtml = '';
        }
        body1.childComponents.add(body);
        body = body1;
    }
}