/**
    Helps to evaluate an apex expression to return either true or false. 
    An expression is something that you typically define in a custom formula (checkbox) field
    or in a native validation rule formula. 

    A single expression could have three parts (left operand, operator & right operand).
    An expression can contain several other expressions joined with logical operators. 
    An operand could be: 
        - simple fields (eg: ggInt__Status__c, Name, Id)
        - relationshp fields (eg: RecordType.DeveloperName, ggInt__Announcement__r.ggInt__Program__r.Name)
        - fixed constant (eg: 'Complete', 2000)
        - current login user fields (eg: $User.ggInt__Department__c)
        - current login user profile fields (eg: $Profile.UserType)
        - current login user role fields (eg: $UserRole.Name)
        - hierarchy custom setting fields (eg: $Setup.ggsInt__GlobalConfig__c.ggsInt__Namespace__c)
        - SOQL statement (eg: [Select Name from ggInt__BudgetCategory__c where ggInt__ApplicationLookup__c=ggInt__Application__c limit 1])
    
    Logical operators: ==, !=, >, <, >=, <=, &&, ||

    Sample expressions:
    1. RecordType.DeveloperName == 'TaskBasedFlexTable'  &&  ggsInt__TaskSummaryAPI__c == null
    2. (ggsInt__Status__c == 'Negotiation In Progress' || $User.ggsInt__IsExternalUser__c) && 
            ggsInt__RequestedAmount__c > 20000 && 
            [Select count() from ggInt__BudgetCategory__c where ggInt__ApplicationLookup__c=ggInt__Application__c] == 5
*/
//Sharing Violation false+ve As per our business use case can't make this class with Sharing, and data used in this class is created or updated by only admin user in config sobject.
public without sharing class ExpressionEvaluator{
    
    private string expression;
    private Set<String> fields = new Set<String>();
    private Map<String, boolean> expressionMap = new Map<String, boolean>{'1' => true, '0' => false};
    private Map<String, string> booleanMap = new Map<String, string>{'true' => '1', 'false' => '0','&&' => '&','||' => '|'};
    private List<String> operatorList = new List<String>();
    private List<String> operandList = new List<String>();

    public ExpressionEvaluator(String expression) {
        this.expression = expression;
        //inspect();

    }
    public Boolean evaluate(Id recordId){
        return true;
    }
    public Set<String> getFieldNames(){
        return fields;
    }
    public Boolean evaluate (SObject record){
        String expr = expression;
        expr = evaluateMergeFieldsAndQuery(expr,record);
        String result = evaluateExpression(expr);
        return Boolean.valueOf(result);
    }
    /* PRIVATE METHODS */

    // private void inspect() {

    // }
    private string evaluateMergeFieldsAndQuery(string expr,Sobject record){
            AppUtils.dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
            expr = AppUtils.replaceMergeFields(expr,record);
            AppUtils.dateTimeFormat = null;
            Id recId = (Id)record.get('id');
            Map<String, Schema.SObjectField> fieldMap  = new Map<String, Schema.SObjectField>();
            if(recId != null){
                fieldMap =recId.getSObjectType().getDescribe().fields.getMap();
            }
                Pattern pt = Pattern.compile('\\s*\'*\\[.+\\]\\s*\'*');
                Matcher m = pt.matcher(expr);
                List<String> queries = new List<String>();
                while (m.find()) {//SOQL/SOSL Injection False +ve 
                    queries.add(m.group());
                }
                for(String query : queries){
                     if(query.containsIgnoreCase('Sum') || query.containsIgnoreCase('Avg') || query.containsIgnoreCase('min') || query.containsIgnoreCase('max')
                            ||  query.containsIgnoreCase('count')){
                        String queryOrg = query.substringBetween('[', ']');
                        List<AggregateResult> agr = Database.query(String.escapeSingleQuotes(queryOrg), AccessLevel.USER_MODE);   
                        for (AggregateResult ar : agr)    {
                            Integer value = Integer.valueOf(ar.get('expr0'));
                            if(value == null){
                             expr = expr.replace(query, '');
                            }
                            else{
                                expr = expr.replace(query, String.valueOf(value));
                            }
                        }
                    }
                    else{
                        String queryOrg = query.substringBetween('[', ']');
                        Sobject rec = Database.Query(String.escapeSingleQuotes(queryOrg), AccessLevel.USER_MODE);
                        String value = '';
                        string field = queryOrg.toLowerCase().substringBetween('select ',' from');
                        if(rec != null && rec.get(field) != null ){  
                           Schema.SObjectField f = fieldMap.get(field);  
                           if(f != null){
                                String dataType = f.getDescribe().getType() + '';
                                if(dataType == 'DateTime' || dataType == 'Date'){
                                    datetime d = Datetime.valueOf(rec.get(field));
                                    value = d.format('yyyy-MM-dd HH:mm:ss');
                                }else{
                                    value = rec.get(field) + '';
                                }
                           }else{
                                value = rec.get(field) + '';
                           }
                            
                        }
                        String tmpQuery = query.substringBetween('\'', '\'');
                        if(String.isNotEmpty(tmpQuery) && tmpQuery.startsWith('[')){
                                expr = expr.replace(query,'\'' + value + '\'');
                        }else{
                                expr = expr.replace(query,value); 
                       }

                    }
                }       
        return expr;
    }
    private string evaluateExpression(string expr){
        // Replace || with #, as || gets converted &$124; in string and causes issue in processing.
        expr = expr.replace('||', '#');
        // Reg ex to fetch the expression like '3 > 4', 'test' == 'test' from the entire expression
        Pattern pt = Pattern.compile('(\\s*\'*\\s*(\\w+-*\\s*\\:*\\.*)*\\s*\'*\\s*((<=)|(>=)|(==)|>|<|=)\\s*\'*\\s*(\\w+:*\\s*-*\\.*)*\\s*\'*\\s*)+');
        Matcher m = pt.matcher(expr);
        string singleExpr;
        Boolean result = false;
        string operand1String,operand2String;
        DateTime operand1Date,operand2Date;
        Integer operand1,operand2;
        /* Start -  evaluate the single expressions to get the result and replace the value in the original expression */
        while (m.find()) {//SOQL/SOSL Injection False +ve 
            singleExpr = m.group();
            operand1 = operand2 = null;
            operand1String = operand2String =null;
            string separator;
            if(singleExpr.contains('>=')){
                separator = '>=';  
            }else if(singleExpr.contains('<=')){
                separator = '<=';    
            }else if(singleExpr.contains('>')){
                separator = '>';
            }else if(singleExpr.contains('<')){   
                separator = '<';
            }else if(singleExpr.contains('==')){
                separator = '==';
            }else if((singleExpr.contains('='))){
                separator = '=';
            }
            List<String> equ = singleExpr.split(separator);
            if(equ[0].trim().isNumeric()){
                operand1= Integer.valueOf(equ[0].trim());
            }else{
                try{
                    operand1Date = datetime.valueOf(equ[0].trim());
                }catch(Exception e){
                    operand1String = equ[0].trim();
                    if(String.isBlank(operand1String)){
                        operand1String ='\'\'';
                    }
                 }
            }
            if(equ[1].trim().isNumeric()){
                operand2 = Integer.valueOf(equ[1].trim());    
            }else{
                try{
                    operand2Date = datetime.valueOf(equ[1].trim());
                }catch(Exception e){
                    operand2String = equ[1].trim();
                    if(String.isBlank(operand2String )){
                        operand2String ='\'\'';
                    }
                    }
            }
            if(singleExpr.contains('>=')){
                if(operand1 != null && operand2 != null){
                    result = boolean.valueOf(operand1 >= operand2);      
                }else if(!String.isEmpty(operand1String) && !String.isEmpty(operand2String)){
                    result = boolean.valueOf(operand1String >= operand2String);
                }else if(operand1Date != null && operand2Date != null){   
                    result = boolean.valueOf(operand1Date >= operand2Date);   
                }
            }else if(singleExpr.contains('<=')){
                if(operand1 != null && operand2 != null){
                    result = boolean.valueOf(operand1 <= operand2);      
                }else if(!String.isEmpty(operand1String) && !String.isEmpty(operand2String)){
                    result = boolean.valueOf(operand1String <= operand2String);
                }else if(operand1Date != null && operand2Date != null){   
                    result = boolean.valueOf(operand1Date <= operand2Date);   
                }   
            }else if(singleExpr.contains('>')){
                if(operand1 != null && operand2 != null){
                    result = boolean.valueOf(operand1 > operand2);      
                }else if(!String.isEmpty(operand1String) && !String.isEmpty(operand2String)){
                    result = boolean.valueOf(operand1String > operand2String);
                }else if(operand1Date != null && operand2Date != null){   
                    result = boolean.valueOf(operand1Date > operand2Date);   
                }   
            }else if(singleExpr.contains('<')){   
                if(operand1 != null && operand2 != null){
                    result = boolean.valueOf(operand1 < operand2);      
                }else if(!String.isEmpty(operand1String) && !String.isEmpty(operand2String)){
                    result = boolean.valueOf(operand1String < operand2String);
                }else if(operand1Date != null && operand2Date != null){   
                    result = boolean.valueOf(operand1Date < operand2Date);   
                }  
            }else if(singleExpr.contains('==') || singleExpr.contains('=')){
                if(operand1 != null && operand2 != null){
                    result = boolean.valueOf(operand1 == operand2);      
                }else if(operand1Date != null && operand2Date != null){   
                    result = boolean.valueOf(operand1Date == operand2Date);   
                }else{
                    result = boolean.valueOf(operand1String == operand2String);
                } 
            }
            expr = expr.replace(singleExpr,String.valueOf(result));  
        }
        if(expr.contains('&&') || expr.contains('#')){
            return String.valueOf(evaluateBooeleanOperators(expr));
        }
        if(expr.contains('(')){
            return expr.substringBetween('(',')');    
        }
      
        return expr;
    }
   
    private boolean evaluateBooeleanOperators(String expression){
        /* Start - For Processing Purpose replacing true by 1 and false by 0 and && by single & */
        expression = expression.replaceAll('true', '1');
        expression = expression.replaceAll('false', '0');
        expression = expression.replaceAll('&&', '&');
        /* End */
        expression = expression.deleteWhitespace();  
       expression = '('+expression+')';  
        String result;
        /* Convert string to Char array */
        List<String> expressionList = expression.split('');  
        /* Evaluate AND | OR * as per the Bracket precedence */
        for(String op : expressionList){
             if(op.isNumeric()){
                   operandList.add(op); 
             }else if(!op.equals(')')){
                   operatorList.add(op); 
             }else{
                   evaluateBrackets();
             }   
        }
        result = operandList.remove(operandList.size()-1);
        return expressionMap.get(result);

    }

    private void evaluateBrackets(){
        Integer operandSize = operandList.size();
        Integer operatorSize = operatorList.size();
        String operator =  popup((operatorSize - 1),true); // Popup the Operator
       String value1, value2, result;
        while(operator != '('){
                value1 = popup((operandSize-1),false); // Popup Operand 1 
                operandSize = operandList.size();
                if(operandSize != 0){
                    value2 = popup((operandSize-1),false); // Popup Operand 2
                }else{
                    value2 = value1;
                }
                // Evaluate based on AND | OR
                if(operator == '&'){ 
                    result = String.valueOf(expressionMap.get(value1) && expressionMap.get(value2));
                }else if(operator == '#'){
                    result = String.valueOf(expressionMap.get(value1) || expressionMap.get(value2));
                }
                operandList.add(booleanMap.get(result));
                operandSize = operandList.size();
                operatorSize = operatorList.size();
                if(operatorSize != 0)
                operator = popup((operatorSize-1),true);
            
        }
    }

    private string popup(Integer index,Boolean isOperator){
        if(isOperator){
            return operatorList.remove(index);
        }else{
            return operandList.remove(index);
        }
    }

}