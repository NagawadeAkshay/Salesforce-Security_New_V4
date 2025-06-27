public with sharing class FlexLayoutFieldsPrintGenerator {
    private transient DynamicLayoutHolder layoutHolder;
    private transient String html = '';
    private transient Component.Apex.OutputPanel body;
    private transient PageLayoutConfigHelper.Field f;
    private transient Object fieldValue;
    private transient String layoutId;
    private static final String DECIMAL_FORMAT = '###,###,###,##0';
    public static set<String> fieldsToHide = new set<String>();

    public FlexLayoutFieldsPrintGenerator(DynamicLayoutHolder layoutHolder,  
                        Component.Apex.OutputPanel body, PageLayoutConfigHelper.Field f, String layoutId) {
        this.layoutHolder = layoutHolder;
        this.body = body;
        this.f = f;
        this.layoutId = layoutId;
        //evaluateHideFields(f);
    }
    /*
    Commented this code as it is not used anywhere due to same code in flexLayoutPrintGenarator.cls
     public void evaluateHideFields(PageLayoutConfigHelper.Field f) {
        //String selectedValue = String.valueof(layoutHolder.getFieldValue(f));
        if(f.hideFieldsJSON != null){
            list<Map<String,String>> hideValuesMap = (List<Map<String,String>>)JSON.deserialize(f.hideFieldsJSON, list<Map<String,String>>.class);
        //Map<String,String> hideValuesMap = (Map<String,String>)JSON.deserialize(hideFields,Map<String,String>.class);
            //String hide = f.fieldAPIName;
            String selectedValue = String.valueof((String.isEmpty(layoutId)) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));////this condition is added to see whether fields are render from main layout or from form
         

            for(Map<String,String> m1 : hideValuesMap){
                String operation = m1.get('Action');
                if(String.isempty(operation) || operation == 'hide'){
                    String fieldToHideApiname = m1.get('FieldToHide');
                    String operator = m1.get('Operator');
                    String hideVal = m1.get('FieldValue');
                    
                    if(operator == '=='){
                        if(selectedValue == hideVal ){
                            fieldsToHide.add(fieldToHideApiname);
                        }

                    }else if(operator == '!='){
                        if(selectedValue != hideVal ){
                            fieldsToHide.add(fieldToHideApiname);
                        }
                    /*Prajakta:Added IN and NOT IN because it is breaking for multiple JSON. For example,
                    [{"FieldToHide":"ggf_dev6__SampleText1__c","FieldValue":"sample2","Operator":"==","Action":"hide"},{"FieldToHide":"ggf_dev6__SampleText1__c","FieldValue":"sample123","Operator":"==","Action":"hide"}] 
                    [{"FieldToHide":"ggf_dev6__SampleObject1__c","FieldValue":"Grant,Grants","Operator":"IN","Action":"hide"}]* /
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
*/
    public String generate() {
        if (f.isHiddenField) return html;
         if(f.fieldAPIName!=null && fieldsToHide.contains(f.fieldAPIName)) return html;
        //this.fieldValue = String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId);
        if (f.isBlankSpace) {
            renderBlankSpace();
        }
        else if (f.isStaticText) {
            renderStaticText();
        }
        else if (f.altRen != null) {
            renderFieldLabelAndHelpText();
            if (f.altRen.typex == 'Picklist' || f.altRen.typex == 'Multiselect') {
                renderAltRenPicklist();
            }
            else if (f.altRen.typex == 'Typeahead') {
                renderAltRenTypeahead();
            }
            else if (f.altRen.typex == 'Radio') {
                renderAltRenRadio();
            }
            else if (f.altRen.typex == 'Checkbox') {
                renderAltRenCheckbox();
            }
        }
        else if(f.isFieldLevelAttachment) {
           renderFieldLevelAttachment();
        }
        else {
            renderNativeFields();
        }

        //renderVisibleHelpText();
        //}
        return html;
    }

    /* PRIVATE METHODS */

    @TestVisible
    private void renderVisibleHelpText() {
        if (String.isNotEmpty(f.helpTextPost)) {
            html += '<span class="helpTextPostStyle">' + f.helpTextPost + '</span>';
        }
    }

    private void renderStaticText() {
        //html += '<span class="static-text" id="editorStaticText">' + f.staticText + '</span>';
        String str = f.staticText;
        if(String.isNotEmpty(str) && str.contains('<br>')){
            str = str.replaceAll('^(<br\\s*\\/?>)+','');  
        }  
        str = str.replace('&lt;PageBreak&gt;','<div style="page-break-after:always;"></div>');
        html += '<div style="' + f.style + '" class="static-text customLabelstyle" id="editorStaticText1">' + str + '</div>';
    }

    private void renderBlankSpace() {
        html += '<span class="' + f.boldTextStyleClass + '">&nbsp;</span>';
        html += '<span class="' + f.fieldValueStyleClass + '">&nbsp;</span>';
    }

    private void renderAltRenTypeahead() {
        html += '<div class="' + f.fieldValueStyleClass +
                    '">';
        String selectedValue = (String.isEmpty(layoutId) ? layoutHolder.getFieldValueAsString(f) : layoutHolder.getFormFieldValueAsString(f, layoutId));
        html += '<span style="' + f.style + '">' + selectedValue + '</span>';
        html += '</div>';
    }

    @TestVisible
    private void renderAltRenPicklist() {
        
        html += '<div class="' +  f.fieldValueStyleClass +
                    '">';
       
        string result='';
        String selectedValue = String.valueOf(String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
        
        for(SelectOption op : f.altRen.displayValues){
            if(op.getValue() == selectedValue){
                result = op.getLabel(); 
                break;   
            }
        }  
        html += '<span style="' + f.style + '">' + result + '</span>';
        html += '</div>';
    
    }

    private void renderAltRenRadio() {
       html += '<div class="' + f.fieldValueStyleClass +
                    '">';
                            
        String selectedValue = String.valueOf(String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
                     
      for (SelectOption opt : f.altRen.displayValues) {
          if(opt.getValue() == selectedValue){
             html += '<div class="' +'radio' +' ' +'sfvi-radio-content' +
                        '">';
                                
                                    
                html += String.isNotBlank(opt.getValue()) ? opt.getLabel() : '';
                                  
                 html += '</div>';
        }
        }
        html += '</div>';
    }

    @TestVisible
    private void renderAltRenCheckbox() {
        html += '<dd class="field-val-dl"><div class="' + f.fieldValueStyleClass +
                    '">';
       String selectedValue = String.valueOf(String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));//this condition is added to see whether fields are render from main layout or from form
       List<String> selectedValuesList = new List<String>();
       Set<String> selectedValuesSet = new Set<String>();
       if(!String.isEmpty(selectedValue)){
             selectedValuesList = selectedValue.split(';');
             if(selectedValuesList.size() > 0){
                selectedValuesSet.addAll(selectedValuesList);
             }       
       }             
       
       for (SelectOption opt : f.altRen.displayValues) {
            if(selectedValuesSet.contains(opt.getValue())) {
                //html += String.isNotBlank(opt.getValue()) ? 'true' : 'false'  + ', ';
                //html += opt.getValue()+ '; ';
                html += String.isNotBlank(opt.getValue()) ? opt.getLabel()+ '; <br/>' : '';
            }
                    
        } 
        html = html.removeEnd('; <br/>');
        html += '</div></dd>';
    }
    
    //Bug 202440: OSPI: CK Editor - Data should be displayed properly in the downloaded PDF in case any style is applied to the Rich Text Area field
    private String handleHtmlTag(String htmlTag){
        String styleClosingTag ='';
        string closingOpeningTag = '<>';
        String handleClosingOpeningTag = closingOpeningTag.escapeHtml4();
        String styleOpeningTag = htmlTag.SubStringBefore('<>');
        if(htmlTag.SubStringafter('<>').contains('<>')){
            styleClosingTag = handleHtmlTag(htmlTag.SubStringafter('<>'));
        }else{
            styleClosingTag = htmlTag.SubStringafter('<>');
        }
        return styleOpeningTag+ handleClosingOpeningTag + styleClosingTag;
    }

    private void renderNativeFields() {
        renderFieldLabelAndHelpText();
        html += '<dd class="field-val-dl">';
        if(f.dataType == 'REFERENCE'){
            html += '<span class="tooltip referenceOpacity tooltip-ext ' + f.fieldValueStyleClass + '" style="' + f.style + '">';
        }else{
            html += '<span class="' + f.fieldValueStyleClass + '" style="' + f.style + '">';
        }
        if (f.isRichTextAreaField) {
            Object val = ((String.isEmpty(layoutId)) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            String textAreaValue = '';
            if(val != null) {
                textAreaValue = String.valueOf(val);
            }
            //handle special case related with <>
            //Bug 202440: OSPI: CK Editor - Data should be displayed properly in the downloaded PDF in case any style is applied to the Rich Text Area field
            if(textAreaValue.contains('<>')){
                string closingOpeningTag = '<>';
                String handleClosingOpeningTag = closingOpeningTag.escapeHtml4();
                String styleOpeningTag = textAreaValue.SubStringBefore('<>');
               // String styleClosingTag = textAreaValue.SubStringafter('<>');
                String styleClosingTag ='';
                if(textAreaValue.SubStringafter('<>').contains('<>')){
                    styleClosingTag = handleHtmlTag(textAreaValue.SubStringafter('<>'));
                }else{
                    styleClosingTag = textAreaValue.SubStringafter('<>');
                }
                textAreaValue = styleOpeningTag+ handleClosingOpeningTag + styleClosingTag;
            }
            html += '<span style="' + f.style + '">' + ((textAreaValue != null) ? textAreaValue : '') + '</span>';
        }
        else if (f.dataType == 'CURRENCY' || f.dataType == 'PERCENT' || f.dataType == 'DOUBLE') {
            html += formatDecimal();
        }
        else if (f.dataType == 'REFERENCE') {
            Map<String,String> mapFields  =  String.isEmpty(layoutId) ? layoutHolder.fieldMap : layoutHolder.formFieldMap != null ?layoutHolder.formFieldMap.get(layoutId): new Map<String, String>();
            sObject o;
            sObject referenceObject;
                //o = String.isEmpty(layoutId) ? layoutHolder.recordMap.get(f.getAdjustedObjectAPIName()) : layoutHolder.formRecordMap.get(layoutId);
                if(String.isEmpty(layoutId)) {
                     Object obj =AppUtils.getParentRecord(((Sobject)layoutHolder.recordMap.get(f.objectAPIName)), f.fieldAPIName);
                     if(obj != null)
                        o = (Sobject)obj;
                } else {
                    o = layoutHolder.formRecordMap.get(layoutId);
                }

                if(o != null){
                    string objName = f.getAdjustedFieldAPIName().replace('__c','__r');
                    if(!f.getAdjustedFieldAPIName().containsIgnoreCase('__c')){
                        objName = mapFields.get( f.getAdjustedFieldAPIName().toLowerCase());
                    }
                    if(o.getSobject(objName)!=null)
                    html += '<a id=\''+f.getAdjustedFieldAPIName().toLowerCase()+'\'" >' + o.getSobject(objName).get('Name') + '</a>';
                    
                }
        }
        else if(f.dataType == 'TIME'){
            Time timeVal = (Time) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            //Date a = new Date(tval.);
            if(timeVal != null){
            Datetime dt = Datetime.newInstance(System.today(), timeVal);
            String dtStrVal = dt.format(AppUtils.getUserDateTimeFormat());
            if(dtStrVal !=null){
                List<String> dtStrvalLst = dtStrVal.split(' ');
                String ampmVal = dtStrvalLst.size() > 2 ? dtStrvalLst[2] : '';
                html +=dtStrvalLst[1]+' '+ampmVal;
            }
        }
        }
        else if (f.dataType == 'DATETIME') {
            DateTime d = (DateTime) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            if (d != null) { 
                if(String.isNotEmpty(f.dateTimeFormat)){              
                        if(f.dateTimeFormat != null){
                            html += d.format(f.dateTimeFormat); 
                        }else{
                            html += d.format('MM/dd/yyyy hh:mm a'); 
                        }               
                }else{
                     html += d.format(AppUtils.getUserDateTimeFormat());
                }
            }
        }
        else if (f.dataType == 'DATE') {            
            Date d = (Date) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            if (d != null) {
               //html += Date.valueOf(layoutHolder.getFieldValue(f)).format(AppUtils.getUserDateFormat());
               // html += d.month() + '/' + d.day() + '/' + d.year();
               //html += d.day() + '/' + d.month() + '/' + d.year();
               String dVal =  Datetime.valueOf(layoutHolder.getFieldValue(f)+'').format(AppUtils.getUserDateFormat());
               //dVal = dVal.substring(0,10);
               html += dVal;
            }
        }
		else if(f.dataType == 'MULTIPICKLIST'){
             renderMultiSelectPicklist();
        }
       /* else if (f.dataType == 'DATETIME') {
            DateTime d = (DateTime) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            if (d != null) {
                if(f.dateTimeFormat != null){
                    html += d.format(f.dateTimeFormat); 
                }else{
                    html += d.format('MM/dd/yyyy hh:mm a'); 
                }    
                
            }
        }
        else if (f.dataType == 'DATE') {            
            Date d = (Date) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            if (d != null) {
                html += d.month() + '/' + d.day() + '/' + d.year();
            }
        }*/
        else if (f.dataType == 'BOOLEAN') {
            Boolean checked = (Boolean) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));      
            if (checked == null) checked = false;
            if(checked){
                html += 'true'; // 508
            }else{
                html += 'false'; // 508
            }
        }
        /*In case of Text Area field line breaks, where not reflecting in pdf.*/
        else if(f.dataType == 'TEXTAREA'){
            Object val = ((String.isEmpty(layoutId)) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
            String textAreaValue = '';
            if(val != null) {
                textAreaValue = String.valueOf(val);
                textAreaValue = textAreaValue.replace('\n', '<br/>');
            }
            //handle special case related with <>
            //Bug 202440: OSPI: CK Editor - Data should be displayed properly in the downloaded PDF in case any style is applied to the Rich Text Area field
            if(textAreaValue.contains('<>')){
                string closingOpeningTag = '<>';
                String handleClosingOpeningTag = closingOpeningTag.escapeHtml4();
                String styleOpeningTag = textAreaValue.SubStringBefore('<>');
               // String styleClosingTag = textAreaValue.SubStringafter('<>');
                String styleClosingTag ='';
                if(textAreaValue.SubStringafter('<>').contains('<>')){
                    styleClosingTag = handleHtmlTag(textAreaValue.SubStringafter('<>'));
                }else{
                    styleClosingTag = textAreaValue.SubStringafter('<>');
                }
                textAreaValue = styleOpeningTag+ handleClosingOpeningTag + styleClosingTag;
            }
            html += '<span style="' + f.style + '">' + ((textAreaValue != null) ? textAreaValue : '') + '</span>';
        }else if(f.dataType == 'PICKLIST'){
            renderPicklist();
        }
        else { 
            html += (String.isEmpty(layoutId) ? layoutHolder.getFieldValueAsString(f) : layoutHolder.getFormFieldValueAsString(f, layoutId));
        }
        html += '</span>';
        html += '</dd>';
    }

    private void renderPicklist(){
        String picklistVal = (String)layoutHolder.getFieldValue(f);
        Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(layoutHolder.layout.objectName,f.fieldAPIName);
        for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
            String label = ple.getLabel();
            if(ple.getValue() == picklistVal){
                picklistVal = label; 
                break;
            } 
        }
        if(picklistVal != null){
            html += '<span class="wordPre ' + f.fieldValueStyleClass + '" style="' + f.style + '">'+picklistVal;
        }
    }

    
    private void renderFieldLevelAttachment(){
        html += '<dt>';
        html += '<span class="customLabelstyle">' + f.fieldLabel + '</span>';
        html += '</dt>';
        html += '<dd class="field-val-dl">';
        html += '<span></span>';
        html += '</dd>';
        
    }

    private void renderFieldLabelAndHelpText() {
        if(f.isFieldLevelAttachment != true){
        html += '<dt>';
            html += '<span class="customLabelstyle">' + f.fieldLabel + '</span>';           
        html += '</dt>';
        }
    }

    /*private String formatDecimal() {
        Decimal d = (Decimal) (String.isEmpty(layoutId) ? layoutHolder.getFieldValue(f) : layoutHolder.getFormFieldValue(f, layoutId));
        if (d == null) return '';

        String format = DECIMAL_FORMAT;
        Integer scale = f.decimalScale == null ? 0 : f.decimalScale;
        if (scale > 0) {
            format += '.';
        }
        for (Integer i=0; i<scale; i++) {
            format += '0';
        }
        List<String> args = new String[]{'0','number',format};
        String val = String.format(d.format(), args);
        if (f.dataType == 'PERCENT') {
            val += '%';
        }
        else if (f.dataType == 'CURRENCY') {
            val = '$' + val; 
        }
        return val;
    }*/
	
	// Added by Chinmay for fixing the decimal issue in case of PDF.
	
	private String formatDecimal() {
        Decimal d = (Decimal) layoutHolder.getFieldValue(f);
        String val='';
        if(d != null){
        String format = DECIMAL_FORMAT;
        Integer scale = f.decimalScale == null ? 0 : f.decimalScale;        
       if(scale > 1 && f.dataType != 'DOUBLE')
        {
            scale = 2;
        } 
            val = string.valueOf(d.setScale(scale));
        String[] valList = val.reverse().split('\\.');      
        String formated;
        String currSymbol = AppUtils.getLocaleCurrencySymbol();
        	if(valList.size() > 0){						
			List<String> stringList = new List<String>{};
			Integer subs = 0;
			String fristPart, secondPart;
			if(valList.size()==2){
				fristPart = valList[1];
				secondPart = valList[0];
			}
			else if(valList.size()==1){
				fristPart = valList[0];
			}
            for(Integer x = 1; x < fristPart.length() + 1; x++){
                if(math.mod(x, 3) == 0){
                    stringList.add(fristPart.substring(subs, x));
                    subs = x;
                }
                else if(x == fristPart.length()){
                    stringList.add(fristPart.substring(subs, x));
                }
            }
			fristPart = string.join(stringList, ',');
			formated = fristPart;
			valList = new List<String>();
			if( secondPart !=null ){
                /*if(secondPart.length() == 1){
					secondPart = secondPart + '0';
                }*/                          
				valList.add(secondPart);
				valList.add(fristPart);
				formated = string.join(valList, '.');				
            }					
            formated=formated.reverse();
            if(formated.endsWith(',00')){
				formated=formated.substring(0,formated.lastIndexOf(','));
            }
		}
        if (f.dataType == 'PERCENT') {    
            val = formated + '%';
        }
        else if (f.dataType == 'CURRENCY') {
           
            val = currSymbol+''+ formated;              
        } 
        else{
            val = formated;
        }
        if(val.contains('-')){
            val = val.remove('-');
            val = '('+val+')';
        }
        if(val.contains(currSymbol + ',')){
            val = val.replace(currSymbol + ',',currSymbol);
        }
         if(val.contains('(,')){
            val = val.replace('(,','(');
        }
        }
        return val;
    }
	
    private void renderMultiSelectPicklist(){
        String picklistVal = (String)layoutHolder.getFieldValue(f);
        Schema.DescribeFieldResult dsr = SchemaManager.fetchDescribeFieldResult(layoutHolder.layout.objectName,f.fieldAPIName);
        List<String> picklistValues = new List<String>();
        if(String.isNotEmpty(picklistVal)){
             picklistValues = picklistVal.split(';');
        }
        List<String> picklistLabelList = new List<String>();
        for(String values : picklistValues){
            boolean containsVal = false;
            for(Schema.PicklistEntry ple : dsr.getPicklistValues()){
                String label = ple.getLabel(); 
                if(ple.getValue() == values){
                    picklistLabelList.add(label);
                    containsVal = true;
                }
            }
            if(!containsVal)
                picklistLabelList.add(values);           
        }
        if(picklistVal != null){
            html += '<span class="wordPre ' + f.fieldValueStyleClass + '" style="' + f.style + '">'+String.join(picklistLabelList,';<br/>');
        }
    }

}