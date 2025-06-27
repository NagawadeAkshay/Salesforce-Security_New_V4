public with sharing class FlexTableDetailTriggerHelper  extends TriggerHelper {
    public override void processBeforeInsert() {
        generateFormulaToJSON(Trigger.new);       
    }
    
    public override void processBeforeUpdate() {
        generateFormulaToJSON(Trigger.new);       
    }

    public override void processAfterInsert() {
        checkTotalFlexGridWidth(Trigger.new);       
    }
    
    public override void processAfterUpdate() {
        checkTotalFlexGridWidth(Trigger.new);       
    }
    
    private void checkTotalFlexGridWidth(List<DataTableDetailConfig__c> dataTableDetailList) {
        if(Schema.sObjectType.DataTableDetailConfig__c.isAccessible()){
            List<AggregateResult> aggResult = [select sum(FieldWidth__c) totalWidth from DataTableDetailConfig__c 
                                                where FlexTableConfig__c=:dataTableDetailList[0].FlexTableConfig__c WITH USER_MODE];
            Decimal totalWidth = (Decimal)aggResult[0].get('totalWidth');
        }
    }


    private void generateFormulaToJSON(List<DataTableDetailConfig__c> dataTableDetailList) {
        for (DataTableDetailConfig__c dataTableDetail: dataTableDetailList) {
            String formulaJSON = '';
            try{    
                if(dataTableDetail.EnableSubTotal__c == true && dataTableDetail.EnableColumnSubtotalPercentage__c == true){
                    dataTableDetailList[0].addError('can not enable subtotal and column subtotal percentage at same time');    
                 }
                 if(dataTableDetail.EnableColumnSubtotalPercentage__c == true && String.isBlank(dataTableDetail.ColumnSubtotalPercentageJSON__c)){
                    dataTableDetailList[0].addError('If you enable column subtotal percent then you have to provide column subtotal percentage JSON');    
                 }
                if (String.isNotBlank(dataTableDetail.Formula__c)) {
                    Map<String, Object> formulaMap = (Map<String, Object>) JSON.deserializeUntyped(dataTableDetail.Formula__c);                    
                    Map<String, Object> massagedformulaMap = new Map<String, Object>();
                    if(dataTableDetail.EnableOverAllTotal__c == true){
                        if(!dataTableDetail.Formula__c.contains('GRANDTOTAL')){
                            formulaMap.put('GRANDTOTAL','SUM()');
                            dataTableDetail.Formula__c = JSON.serialize(formulaMap);
                        }
                    }

                    if(dataTableDetail.EnableOverAllTotal__c == true){
                        if(dataTableDetail.Formula__c.contains('GRANDTOTAL') && (formulaMap.get('GRANDTOTAL') != null)){
                            formulaMap.remove('GRANDTOTAL');
                            dataTableDetail.Formula__c = JSON.serialize(formulaMap);
                        }
                    }

                    for (String rowKey: formulaMap.keySet()) {
                        String formula = String.valueOf(formulaMap.get(rowKey));
                        if(rowKey.equalsIgnoreCase('GRANDTOTAL')) {
                            if (formula.substring(0, 4).equalsIgnoreCase('TEXT')) {
                                massagedformulaMap.put(rowKey, formula.replace('TEXT(', '').replace(')', ''));
                                if( !formula.endsWith(')') ){  
                                    dataTableDetailList[0].addError('Invalid JSON Format');
                                } 
                            }
                            else{                            
                               if (formula.substring(0, 3).equalsIgnoreCase('SUM')) {
                                    massagedformulaMap.put(rowKey, formula);
                                }
                            }
                        } else if (rowKey.equalsIgnoreCase('LASTROW')) {
                            if (formula.substring(0, 4).equalsIgnoreCase('TEXT')) {
                                massagedformulaMap.put(rowKey, formula.replace('TEXT(', '').replace(')', ''));
                                if( !formula.endsWith(')') ){  
                                    dataTableDetailList[0].addError('Invalid JSON Format');
                                }  
                            }
                            else{
                               massagedformulaMap.put(rowKey, formula);                               
                               if(!formula.substring(4, 7).equals('1:N') || !formula.endsWith('N)') ){  
                                    dataTableDetailList[0].addError('LASTROW key must have range 1:N');
                               }                                   
                            }
                        }else if (formula.substring(0, 3).equalsIgnoreCase('SUM')) {
                            dataTableDetail.Formula__c = dataTableDetail.Formula__c.deleteWhitespace();
                            List<String> parts = new List<String>();
                            formula = formula.deleteWhitespace();
                            list<String> rowNumbers = new list<String>();
                            String range = formula.replace('SUM(', '').replace(')', '');
                            if(range.contains(':')){
                                parts = range.split(':', 2);
                                integer startIndex = integer.valueof(parts[0]);
                                integer stopIndex = integer.valueof(parts[1]);
                               
                                if(integer.valueof(rowKey)<=stopIndex){
                                     dataTableDetailList[0].addError('Row key must be greater than sum Range');
                                }
                                for(integer rowNo = startIndex; rowNo <= stopIndex; rowNo++){
                                    rowNumbers.add(String.valueOf(rowNo));
                                }                                
                               
                            }
                            else if(range.contains(',')){
                                rowNumbers = range.split(',');
                            }
                            else{
                                 dataTableDetailList[0].addError('SUM function only accept : or ,');
                            }
                            String actualFormula = ''; 
                            for(String rowIndex : rowNumbers){
                                integer rowIndexInt = math.abs(integer.valueof(rowIndex))-1;
                                if(rowIndex.startsWith('-')){
                                    actualFormula = actualFormula + '-r.f[' + rowIndexInt + ']';
                                }
                                else{
                                    actualFormula = actualFormula + '+r.f[' +  rowIndexInt + ']';  
                                }
                            }
                            massagedformulaMap.put(String.valueOf(integer.valueof(rowKey)-1),actualFormula.removeStart('+'));
                        }else if (formula.substring(0, 3).equalsIgnoreCase('MUL')) {
                            dataTableDetail.Formula__c = dataTableDetail.Formula__c.deleteWhitespace();
                            formula = formula.deleteWhitespace();
                            list<String> rowNumbers = new list<String>();
                            String range = formula.replace('MUL(', '').replace(')', '');
                            if(range.contains(':')){
                                integer startIndex = integer.valueof(range.split(':')[0]);
                                integer stopIndex = integer.valueof(range.split(':')[1]);
                                for(integer rowNo = startIndex; rowNo <= stopIndex; rowNo++){
                                    rowNumbers.add(String.valueOf(rowNo));
                                }
                            }
                            else if(range.contains(',')){
                                rowNumbers = range.split(',');
                            }
                            String actualFormula = ''; 
                            for(String rowIndex : rowNumbers){
                                integer rowIndexInt = math.abs(integer.valueof(rowIndex))-1;
                                if(rowIndex.startsWith('-')){
                                    actualFormula = actualFormula + '-r.f[' + rowIndexInt + ']*';
                                }
                                else{
                                    actualFormula = actualFormula + 'r.f[' +  rowIndexInt + ']*';
                                }
                            }
                            massagedformulaMap.put(String.valueOf(integer.valueof(rowKey)-1),actualFormula.removeEnd('*')); 
                        }else if (formula.substring(0, 4).equalsIgnoreCase('TEXT')) {
                            massagedformulaMap.put(String.valueOf(integer.valueof(rowKey)-1), formula.replace('TEXT(', '').replace(')', ''));
                            if( !formula.endsWith(')') ){  
                                dataTableDetailList[0].addError('Invalid JSON Format');
                            } 
                        }
                        formulaJSON = JSON.serialize(massagedformulaMap);
                    }
                }
                dataTableDetail.FormulaJSON__c = formulaJSON;
            }catch(Exception e){dataTableDetailList[0].addError('Invalid Formula JSON');
            }
        }
    }
}