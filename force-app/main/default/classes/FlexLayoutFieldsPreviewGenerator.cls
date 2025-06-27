public with sharing class FlexLayoutFieldsPreviewGenerator {
    private DynamicLayoutHolder layoutHolder;
    private String html = '';
    private Component.Apex.OutputPanel body;
    private PageLayoutConfigHelper.Field f;

    public FlexLayoutFieldsPreviewGenerator(DynamicLayoutHolder layoutHolder,  
                        Component.Apex.OutputPanel body, PageLayoutConfigHelper.Field f) {
        this.layoutHolder = layoutHolder;
        this.body = body;
        this.f = f;
    }

    public String generate() {
        if (f.isHiddenField) return html;

        if (f.isBlankSpace) {
            renderBlankSpace();
        } else if (f.isStaticText) {
            renderStaticText();
        } else if (f.altRen != null) {
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
        } else if (f.fieldAlignment == 'Horizontal') {
                renderFieldHorizontalAlign();
        } 
        //User Story 113341: Internal - Optimization - Remove unnecessary code related to FieldAlignment in GG code
        /*else {
            if (f.fieldAlignment == 'Horizontal') {
                renderFieldHorizontalAlign();
            } else {  //vertical
                renderFieldVerticalAlign();
            }
        }*/
        renderVisibleHelpText();
        return html;
    }

    /* PRIVATE METHODS */

    private void renderFieldLabelAndHelpText() {

        // encoded helptext to support double quote character during rendering
        f.helpText = SFDCEncoder.SFDC_HTMLENCODE(f.helpText);
   
        html += '<span class="' + f.boldTextStyleClass + '">';
        if (String.isNotEmpty(f.helpText)) {
            html += '<span class="relativePanel">';
            if(String.isEmpty(f.fieldLabel)){
                    html += '<span class="customLabelstyle">Manage Attachments</span>'; 
                }
                else
                {
                      html += '<span class="customLabelstyle">' + f.fieldLabel + '</span>';  
                }
                   // UI-Shrawan-10062015  Moved Field Label out of the link
            /*html += '<a class="labelHelpTooltip" href="#" onclick="event.preventDefault();" ' + 
                                'title="' + f.helpText + '">';
            html += '<span class="fa fa-info helpIcon"></span>'; 
            html += '</a>';*/
            if(f.fieldAPIName != null) {
                String idTooltip = f.fieldAPIName.replaceAll('[\\.]','');
                html += '<a href="JavaScript:Void(0);" id="'+ idTooltip +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onfocus="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" style="outline: none !important;">';                                
            }else if(f.isFieldLevelAttachment == true){
                String idTooltip = f.fieldId;
                
               
                
                
                html += '<a href="JavaScript:Void(0);" id="'+ idTooltip +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onfocus="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" style="outline: none !important;">';
            }                               
            html += '<span class="fa fa-info helpIcon"></span>'; 
            html += '<span class="hidden508">Help: '+f.helpText+'</span>';
            html += '</a>';
            html += '<div class="fieldApiNameDisplay"><div class="fieldNameContainer"><div class="carrot"></div>';
            //html += '<span>' + f.fieldApiName + '</span></div></div>';
            html += '<span></span></div></div>';
            html += '</span>';
        }
        else { 
           if(String.isNotEmpty(f.fieldLabel) && f.fieldLabel != null) 
             html += '<span class="customLabelstyle">' + f.fieldLabel + '</span>';
        }
        html += '</span>';
    }

    private void renderVisibleHelpText() {
        if (String.isNotEmpty(f.helpTextPost)) {
            html += '<span class="helpTextPostStyle">' + f.helpTextPost + '</span>';
        }
    }

    private void renderStaticText() {
        html += '<span class="static-text customLabelstyle" id="editorStaticText">' + f.staticText + '</span>';
    }

    private void renderBlankSpace() {
        html += '<span class="' + f.boldTextStyleClass + '">&nbsp;</span>';
        html += '<span class="' + f.fieldValueStyleClass + '">&nbsp;</span>';
    }

    private void renderAltRenTypeahead() {
        html += '<div class="' + f.fieldValueStyleClass +'">';
        String selectedValue = layoutHolder.getFieldValueAsString(f);
        html += '<span style="' + f.style + '">' + selectedValue + '</span>';
        if(f.fieldAPIName != null && String.isNotEmpty(f.helpText)) {
                String idTooltip = f.altRen.typex + f.fieldAPIName.replaceAll('[\\.]','');
                html += '<a href="#" id="'+ idTooltip +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onfocus="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')">';                                
                html += '<span class="fa fa-info helpIcon"></span>'; 
                html += '<span class="hidden508">Help: '+f.helpText+'</span>';
                html += '</a>';
        }
        html += '</div>';
    }

    private void renderAltRenPicklist() {
        html += '<div class="' + f.fieldValueStyleClass +'">';
        //addHTMLToBody();
        //body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
        //SelectOption[] selectOptions = new List<SelectOption>();
        //selectOptions.addall(f.altRen.displayValues);
        //List<Object> objs = new List<Object>();
        //objs.addAll(f.altRen.displayValues); 
        /*Component.SelectList s = new Component.SelectList(multiselect=false,                                                                               
                                            label=f.fieldLabel, 
                                            required=f.required,
                                            style=f.style, 
                                            size='1',
                                            disabled='false',
                                            readOnly='true',
                                            displayValuesJSON=JSON.serialize(f.altRen.selectMap),
                                            sObject=layoutHolder.recordMap.get(f.getAdjustedObjectAPIName()),
                                            field=f.getAdjustedFieldAPIName()); */
        string result='';
        for(SelectOption op : f.altRen.displayValues){                
            /*if(op.getValue() == String.valueOf(layoutHolder.recordMap.get(f.getAdjustedObjectAPIName()).get(f.getAdjustedFieldAPIName()))){
                result = op.getLabel(); 
                break;   
            }*/
                result = op.getLabel(); 
                break;   
            }
        if(f.fieldLabel != null) {
            html += '<div><span class="customLabelstyle">' + f.fieldLabel + '</span>';
            if(f.fieldAPIName != null && String.isNotEmpty(f.helpText)) {
                String idTooltip = f.altRen.typex + f.fieldAPIName.replaceAll('[\\.]','');
                html += '<a href="#" id="'+ idTooltip +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onfocus="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')">';                                
                html += '<span class="fa fa-info helpIcon"></span>'; 
                html += '<span class="hidden508">Help: '+f.helpText+'</span>';
                html += '</a>';
           }
           html += '</div>'; 

            //html += '<div><span class="' + f.fieldValueStyleClass + '"style="' + f.style + '">' + result + '</span></div>';
            html += '</div>';
        }
        
    }

    private void renderAltRenRadio() {
       html += '<div class="' + f.fieldValueStyleClass +'">';

        String selectedValue = String.valueOf(layoutHolder.getFieldValue(f));
      html += '<div><span class="customLabelstyle">' + f.fieldLabel + '</span>'; 
      if(f.fieldAPIName != null && String.isNotEmpty(f.helpText)) {
                String idTooltip = f.altRen.typex + f.fieldAPIName.replaceAll('[\\.]','');
                html += '<a href="#" id="'+ idTooltip +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onfocus="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')">';                                
                html += '<span class="fa fa-info helpIcon"></span>'; 
                html += '<span class="hidden508">Help: '+f.helpText+'</span>';
                html += '</a>';
      }
      html += '</div>';            
      for (SelectOption opt : f.altRen.displayValues) {
                                
           /* html += '<input type="radio" disabled="true" value="' + opt.getValue() + '" ' +
                            (opt.getValue() == selectedValue ? 'checked' : '') + '/>' + 
                            opt.getLabel() + '<br/>';  */         
        }
        html += '</div>';
    }

    private void renderAltRenCheckbox() {
        html += '<div class="' + f.fieldValueStyleClass +'">';
       // addHTMLToBody();       
       /* Component.SelectCheckboxes s = new Component.SelectCheckboxes(disabled='true', 
                                                label=f.fieldLabel, 
                                                style=f.style,
                                                displayValues=f.altRen.displayValues,
                                                field=f.getAdjustedFieldAPIName(),
                                                layout=f.altRen.checkBoxAlignment,
                                                sObject=layoutHolder.recordMap.get(f.getAdjustedObjectAPIName()));*/
       // body.childComponents.add(s);
       String selectedValue = String.valueOf(layoutHolder.getFieldValue(f));
       List<String> selectedValuesList = new List<String>();
       Set<String> selectedValuesSet = new Set<String>();
       if(!String.isEmpty(selectedValue)){
             selectedValuesList = selectedValue.split(';');
             if(selectedValuesList.size() > 0){
                selectedValuesSet.addAll(selectedValuesList);
             }       
       }             
       html += '<div><span class="customLabelstyle">' + f.fieldLabel + '</span>'; 
       if(f.fieldAPIName != null && String.isNotEmpty(f.helpText)) {
                String idTooltip = f.altRen.typex + f.fieldAPIName.replaceAll('[\\.]','');
                html += '<a href="#" id="'+ idTooltip +'tooltip" onmouseover="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onfocus="showHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')" onblur="hideHelpTooltip(\''+ f.helpText +'\''+ ',\'tooltipster-noir\','+'\''+ idTooltip + '\')">';                                
                html += '<span class="fa fa-info helpIcon"></span>'; 
                html += '<span class="hidden508">Help: '+f.helpText+'</span>';
                html += '</a>';
      }
      html += '</div>'; 
       /*for (SelectOption opt : f.altRen.displayValues) {
                                
            html += '<input type="checkbox" disabled="true" value="' + opt.getValue() + '" ' +
                            (selectedValuesSet.contains(opt.getValue()) ? 'checked' : '') + '/>' + '&nbsp;&nbsp;'+
                            opt.getLabel() + '<br/>';           
        }*/
              
        html += '</div>';
    }

    private void renderFieldHorizontalAlign() {
        renderFieldLabelAndHelpText();
        html += '<span class="' + f.fieldValueStyleClass + '" style="' + f.style + '">';
        if (f.dataType == 'CURRENCY') {
            //html += '$123,456';
            if (f.decimalScale != null) {
                if (f.decimalScale == 1) {
                    //html += '.0';
                }
                else {
                    //html += '.00';
                }
            }
        }
        else if (f.dataType == 'REFERENCE') {
            //html += '<a>Sample ' + f.fieldLabel + '</a>';
        }
        else if (f.dataType == 'DATETIME') {
            //html += System.now().format('MM/dd/yyyy hh:mm a');
        }
        else if (f.dataType == 'DATE') {
            //html += System.now().format('MM/dd/yyyy');  
        }
        else if (f.dataType == 'BOOLEAN') {
            //html += '<input type="checkbox" checked="true" disabled="true" />';
        }
        else if (f.dataType == 'DOUBLE') {
            //html += '123,456';
            if (f.decimalScale != null) {
                if (f.decimalScale == 1) {
                    //html += '.0';
                }
                else {
                    //html += '.00';
                }
            }
        }
        else if (f.dataType == 'PERCENT') {
            //html += '98';
            if (f.decimalScale != null) {
                if (f.decimalScale == 1) {
                    //html += '.0';
                }
                else {
                    //html += '.00';
                }
            }
            //html += '%';
        }
        else {
            //html += 'Sample ' + f.fieldLabel;
        }
        html += '</span>';
    }

    private void renderFieldVerticalAlign() {

    }
    /*
    private void addHTMLToBody() {  // Dk : Spring Cleanup 7-5-16
        if (String.isNotEmpty(html)) {
            body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
            html = '';
        }       
    }*/

}