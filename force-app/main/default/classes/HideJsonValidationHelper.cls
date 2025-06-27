public with sharing class HideJsonValidationHelper  {
    public static void hideFieldValidation(List<CaptureItem__c> captureItemLst){
        Id secId = captureItemLst[0].CaptureSection__c;
        SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
        List<CaptureItem__c> capItmsLstInSec = cls.getCaptureItems(secId);
        for(CaptureItem__c captureItem: captureItemLst){
            if(captureItem.DependentQuestionJson__c != null){
                String dependentFieldJson = captureItem.DependentQuestionJson__c;
                JSONParser parsedValue = JSONParser.parse(dependentFieldJson);
                List<DependentFields> dependentFieldLst = parsedValue.dependentFields;
                List<String> dependentFieldToCheckLst = new List<String>();
                for(DependentFields dpField: dependentFieldLst){
                    dependentFieldToCheckLst.add(dpField.question);
                }
                List<String> isRequiredLst = !dependentFieldToCheckLst.isEmpty() ? isHideFieldRequired(dependentFieldToCheckLst,capItmsLstInSec) : null;
                if(!isRequiredLst.isEmpty()){
                     String requiredFields = string.join(isRequiredLst,',');
                     captureItem.addError(requiredFields+' are marked as required Questions for save. Only non-required Questions for save are allowed in Dependent Question Json field below.');
                }
            }
        }
    }
    public static List<String> isHideFieldRequired(List<String> hideFieldLst, List<CaptureItem__c> captureItemLst){
        List<String> fieldLst;
        if(!hideFieldLst.isEmpty()){
            fieldLst = new List<String>();
            for(String hideField : hideFieldLst){
                if(captureItemLst.size() > 0){
                for(CaptureItem__c captureItem: captureItemLst){
                    if(captureItem.QuestionIdentifier__c != null && captureItem.QuestionIdentifier__c.equalsIgnoreCase(hideField) && captureItem.QuestionApplicable__c!= null && captureItem.QuestionApplicable__c.equalsIgnoreCase('Required to save')){
                        fieldLst.add(hideField);
                    }
                }            
                }          
            }
            
        }
        return fieldLst;
    }
    public with sharing class JSONParser {
        public String controllingFields;
        public List<DependentFields> dependentFields;
        public JSONParser(String controllingFields,List<DependentFields> dependentFields){
            this.controllingFields = controllingFields;
            this.dependentFields = dependentFields;
        }
    }
    public static JSONParser parse(String json) {
       
        if(String.isNotEmpty(json))
            return (JSONParser) System.JSON.deserialize(json, JSONParser.class);
        else 
            return null;
    }
    public with sharing class DependentFields {
        public String question;
        public String value;
        public String action;
        public DependentFields(String question,String value,String action){
            this.action = action;
            this.question = question;
            this.value = value;
        }
    }
}