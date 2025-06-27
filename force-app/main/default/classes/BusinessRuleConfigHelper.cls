/*  
    This class leverages BusinessRuleConfig__c custom setting
    **********************************************************
    Audit History
    **********************************************************
    05-28-2014  Hafsa Syed  Created  
	06-28-2018  Pankaj Hingane  Updated  
    **********************************************************  
    
    HOW TO USE:

        BusinessRuleResult result = BusinessRuleConfigHelper.execute('ValidateCommunityRegOrgData', userReg);
        if (result != null && result.hasErrors()) {
            result.addErrorsToPage();
            return;
        }   
*/

public with sharing class BusinessRuleConfigHelper {
    public static BusinessRuleResult execute(Sobject record,DynamicLayoutHolder holder){
        String SobjectType = AppUtils.getNamespacePrefix() + 'LayoutBusinessRuleConfig__c';
        if (Schema.sObjectType.RecordType.fields.Id.isAccessible()) {
        List<RecordType> recordType = [SELECT id from RecordType where (DeveloperName ='SaveActionClassbasedRule' OR DeveloperName = 'SaveActionConfigbasedRule' )
                    and SobjectType = :SobjectType];//CRUD  FLS- False +ve - Std obj  - will not check permission here 
        List<LayoutBusinessRuleConfig__c> businessRule = new List<LayoutBusinessRuleConfig__c>();
        if(Schema.sObjectType.LayoutBusinessRuleConfig__c.isAccessible()){
            businessRule = [select ClassName__c,Expression__c,ErrorMessage__c from LayoutBusinessRuleConfig__c 
                            where PageLayoutConfig__c =: holder.layoutId and PageLayoutActionConfig__c = null 
                                        and active__c = true and RecordTypeId in :recordType WITH USER_MODE]; //SF review 
        }
        BusinessRuleResult  result = executeBusinessRule(businessRule,record,holder);
        return result;                            
        }
        return null;                      
    } 

    public static BusinessRuleResult execute(Id actionId,Sobject record,DynamicLayoutHolder holder){
        String SobjectType = AppUtils.getNamespacePrefix() + 'LayoutBusinessRuleConfig__c';
        List<RecordType> recordType = [SELECT id from RecordType where (DeveloperName ='CustomActionClassbasedRule' or DeveloperName = 'CustomActionConfigbasedRule')
            and SobjectType = :SobjectType]; //CRUD  FLS- False +ve - Std obj  - will not check permission here 
            List<LayoutBusinessRuleConfig__c> businessRule =  new List<LayoutBusinessRuleConfig__c>();
            if(Schema.sObjectType.LayoutBusinessRuleConfig__c.isAccessible()){
                businessRule = [select ClassName__c,Expression__c,ErrorMessage__c from LayoutBusinessRuleConfig__c 
                                where PageLayoutConfig__c =: holder.layoutId
                                        and active__c = true and PageLayoutActionConfig__c =:actionId and RecordTypeId in:recordType WITH USER_MODE]; //SF review
            }
            BusinessRuleResult result = executeBusinessRule(businessRule,record,holder);
        return result;
    } 


    private static BusinessRuleResult executeBusinessRule(List<LayoutBusinessRuleConfig__c> businessRule,Sobject record,DynamicLayoutHolder holder){
        List<String> classNamesList = new List<String>();
        List<String> expressionList = new List<String>();
        Map<String,String> expressionErrorMessageMap = new Map<String,String>();
        BusinessRuleResult result ;
        if(businessRule.size() > 0){
            for(LayoutBusinessRuleConfig__c rule : businessRule){
                if(!String.isEmpty(rule.ClassName__c)){
                       classNamesList.add(rule.ClassName__c.trim()); 
                }else if(!String.isEmpty(rule.Expression__c)){
                    expressionList.add(rule.Expression__c);
                    expressionErrorMessageMap.put(rule.Expression__c,rule.ErrorMessage__c);
                }
            }
            for(String cls : classNamesList){
                System.Type t;
                if(cls.contains('.')){
                    String[] splitStr = cls.split('\\.');
                    t = System.Type.forName(splitStr[0], splitStr[1]);
                }else{
                    t = System.Type.forName('', cls);
                }
                //Type t = Type.forName(cls);  
                if(t.newInstance() instanceof BusinessRuleHandler){     
                    BusinessRuleHandler handler = (BusinessRuleHandler) t.newInstance(); 
                    result = handler.execute(record);                    
                }
                if(t.newInstance() instanceof BusinessRuleHandlerWithLayoutHolder ){ 
                    BusinessRuleHandlerWithLayoutHolder handlerWithLayout = (BusinessRuleHandlerWithLayoutHolder) t.newInstance(); 
                    result = handlerWithLayout.execute(record,holder);                    
                }
            }
            if(expressionList.size() > 0){
                    for(String expression : expressionList){
                        /*
                        ExpressionEvaluator expEval = new ExpressionEvaluator(expression);
                        Boolean value = expEval.evaluate(record);
                        */
                        //here assuming we will not configure record context. It is passed as Edit. 
                        if(ExpressionJsonEvaluator.evaluateExpression(expression, record, 'Edit')){ 
                            if(result == null){
                                result = new BusinessRuleResult();
                            }
                            result.errors.add(expressionErrorMessageMap.get(expression));
                        }
                    }
            }
            if(result!=null && result.hasErrors()){
                return result;
            }
            
        }
        return null;
    }
}