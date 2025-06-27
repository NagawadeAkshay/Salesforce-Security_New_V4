global with sharing class FormViewLayoutActionController {

   global DynamicLayoutHolder layoutHolder {get;set;}
    public FormViewLayoutActionController() {

    }
    public PageReference executeClass(String className, String recordId, String promptValue, Id actionId){
        Savepoint sp;
        Boolean isErrormsg; 
        try{
            System.Type t;
            t = String.isNotEmpty(className) && className.contains('.') ? System.Type.forName( className.split('\\.')[0], className.split('\\.')[1]) : System.Type.forName('', className);
            
            Object obj = t.newInstance();
            layoutHolder = new DynamicLayoutHolder(recordId , true);

            if(obj instanceOf DynamicLayoutActionStay){

                DynamicLayoutActionStay stay = (DynamicLayoutActionStay)obj;
                stay.layoutHolder = this.layoutHolder;  
                String successMsg = stay.whenClicked();
                isErrormsg = ApexPages.hasMessages(ApexPages.Severity.ERROR);

                if(isErrormsg == false){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,successMsg);
                    ApexPages.addMessage(myMsg);
                } 
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, stay.errorMsg);
                    ApexPages.addMessage(myMsg); 
                }

                //return null;
            } 

            else if(obj instanceOf DynamicLayoutActionRedirect){

                DynamicLayoutActionRedirect redirect = (DynamicLayoutActionRedirect)obj;
                redirect.layoutHolder = this.layoutHolder;
                redirect.promptInputValue = promptValue; 
                redirect.actionId = actionId;
                PageReference p = redirect.whenClicked();
                isErrormsg = ApexPages.hasMessages(ApexPages.Severity.ERROR);  

                if(isErrormsg == false){ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Class esecuted successfully');
                    ApexPages.addMessage(myMsg); 
                    p.setRedirect(true);
                    return p; 
                }else{
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Problem Excuting class');
                    ApexPages.addMessage(myMsg); 
                }         
            }
        }catch(Exception ex){
           if(sp!=null){
		   	Database.rollback(sp);
		   }
           if(ex instanceOf NullPointerException){
                CustomExceptions.logSystemException(ex,recordId,null);
            }
        }
        return null;
    }

    //Merge Field Replacement...
    /*
        Method to replace the Merge Fields here the FilterString is String with MergeFields
        MergeField Syntax : {!ObjectName.FieldName}
        Example:
        This is regular field {!SampleObject1__c.SampleText1__c} .
        This is relationship field {!SampleObject1__r.SampleObject2__r.SampleText2__c}
    */
    public static String replaceRecordMergeFields(String filterString,Id recordId){
        String objectAPIName = String.valueOf(recordId.getSobjectType());
        Pattern regexForExtractingUserFields = Pattern.compile('\\{!(.*?)\\}');
        Matcher regexMatcherForExtractingUserTokens = regexForExtractingUserFields.matcher(filterString);

        Map<String, String> acctFieldsToQueryMap = new Map<String, String>();
        while (regexMatcherForExtractingUserTokens.find()){//SOQL/SOSL Injection False +ve
            String userToken = regexMatcherForExtractingUserTokens.group();
            String userTokenAfterRemove = userToken.substring(2,userToken.length()-1);
            List<String> userSplitField = userTokenAfterRemove.split('\\.', 2);
            acctFieldsToQueryMap.put(userToken, userSplitField[1]);
        }
        if(acctFieldsToQueryMap.size() > 0) {
            String queryStr = 'SELECT '+ String.escapeSingleQuotes(String.join(acctFieldsToQueryMap.values(), ',')) + ' FROM ' + String.escapeSingleQuotes(objectAPIName) + ' WHERE Id =: recordId';//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes use in recordId in FormController class and method name actionURLReplacedMergeField
            List<SObject> records = Database.query(String.escapeSingleQuotes(queryStr),AccessLevel.USER_MODE);
            if(records.size() > 0) {
                for(String replaceStr : acctFieldsToQueryMap.keySet()) {
                    Object value = AppUtils.getFieldValue(records[0], acctFieldsToQueryMap.get(replaceStr));
                    if(value != null) {
                        filterString = filterString.replace(replaceStr, String.escapeSingleQuotes(string.valueOf(value)));
                    } else {
                        filterString = filterString.replace(replaceStr, '');
                    }
                }
            }
        }
        return filterString;
    }
}
/*if(String.isNotEmpty(className) && className.contains('.')){
                String[] splitStr = className.split('\\.');
                t = System.Type.forName(splitStr[0], splitStr[1]);
            }else{
                t = System.Type.forName('', className);
            } */