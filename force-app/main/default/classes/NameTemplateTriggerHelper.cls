/*
  This class is called by the before insert trigger of  any object where we want to set the Name field
  on the record being created according to the Template defined in 
  the NameTemplateConfig  and  the current count of the autonumber is 
  maintained in the  Name template Sequence object .
  The template is defined as a combination of static and dynamic texts 
  and the autonubmer is appended towards the end of the name . 
  **********************************************************
  Audit History
  **********************************************************
  2014-03-05   Vinayak Sharma Created
  **********************************************************  
*/


global with sharing class NameTemplateTriggerHelper  {
    
    public static Map<String,NameTemplateSequence__c> currYearNameTemplateSeqMap; //Map to hold up CurrentYear NameTemplateSeqName key along NameTempSeq Obj.
    public static Map<String,NameTemplateSequence__c> prevYearNameTemplateSeqMap; //Map to hold up PreviousYear NameTemplateSeqName key along NameTempSeq Obj.


    global static void beforeInsert(){ 
                         
        Schema.sObjectType strObjectType = Trigger.new[0].getsObjectType();       
        String strObject = strObjectType+'';    NameTemplateConfig__c   nameTemplate =  NameTemplateConfig__c.getInstance(strObject);
        if(nameTemplate != null){   
            boolean isActive = nameTemplate.Active__c;  
            String  formulaField = nameTemplate.FormulaFieldName__c;       // Name of the formula Field  on the object 
            String  objectName = nameTemplate.Name;                        // Name of the Object on which this custom setting is defined 
            String  autoNumberFormat = nameTemplate.AutoNumberFormat__c;   // Formatting of the Auto Number       
            Integer startNumber = nameTemplate.StartNumber__c.intValue(); 
            boolean skipAutoNumber = nameTemplate.SkipAutoNumberReset__c;
            boolean nameTemplateSequenceExists = false;
            currYearNameTemplateSeqMap = new Map<String,NameTemplateSequence__c>();
            prevYearNameTemplateSeqMap = new Map<String,NameTemplateSequence__c>();

           // To do if the custom setting is not defined then show Error  Message           
          if(isActive){
                String templateFormulaField = '';                            // Formula part of the tempalte that we will be getting from the incoming record 
                Set<String> setFormulaField = new Set<String>();             //  This is just used to pull out the  different temaplates 
                                                
                for(sObject currentObject : (List<SObject>)Trigger.new){ 
                    templateFormulaField = (String)currentObject.get(formulaField);                     
                    setFormulaField.add(templateFormulaField); 
                }    
                
                                        
                Integer currentYear = System.today().year();
                                        
                Set<Integer> years = new Set<Integer>();
                years.add(currentYear);
                years.add(currentYear - 1);

                List<NameTemplateSequence__c> lstCurrAndPrevSequences = getCurrAndPrevYearTemplateSeq(strObject, setFormulaField, years);                               
                
                generateNameTemplateSeqMap(lstCurrAndPrevSequences);

                Set<String> nonExistentTemplateSeqFormulas = new Set<String>();
                if(setFormulaField.size() > currYearNameTemplateSeqMap.values().size()) {
                    for(String tempFormulaField : setFormulaField) {
                        if(currYearNameTemplateSeqMap != null && String.isNotBlank(tempFormulaField) && currYearNameTemplateSeqMap.get(tempFormulaField.toLowercase()) == null) {
                            nonExistentTemplateSeqFormulas.add(tempFormulaField);
                        }
                    }
                }

                List<NameTemplateSequence__c> nameTemplateSeqToCreate = new List<NameTemplateSequence__c>();
                        
                for(String tempFormulaField : nonExistentTemplateSeqFormulas) {
                    NameTemplateSequence__c  newNameTemplate = new NameTemplateSequence__c();
                    if(Schema.sObjectType.NameTemplateSequence__c.fields.Name.isCreateable()){
                        newNameTemplate.Name = tempFormulaField;
                    }
                    if(Schema.sObjectType.NameTemplateSequence__c.fields.StartSequence__c.isCreateable()){
                        newNameTemplate.StartSequence__c = startNumber;  
                    }
                    if(Schema.sObjectType.NameTemplateSequence__c.fields.ObjectName__c.isCreateable()){
                        newNameTemplate.ObjectName__c = strObject;
                    }
                    if(Schema.sObjectType.NameTemplateSequence__c.fields.Year__c.isCreateable()){
                        newNameTemplate.Year__c = currentYear;
                    }
                    
                    if(skipAutoNumber){ 
                        NameTemplateSequence__c prevNameTemplate = prevYearNameTemplateSeqMap.get(tempFormulaField);
                        if(prevNameTemplate == null) {
                            if(Schema.sObjectType.NameTemplateSequence__c.fields.LastSequence__c.isCreateable()){
                                newNameTemplate.LastSequence__c = startNumber - 1;  
                            }
                        }else {
                            if(Schema.sObjectType.NameTemplateSequence__c.fields.StartSequence__c.isCreateable()){
                                newNameTemplate.StartSequence__c = prevNameTemplate.LastSequence__c;
                            }
                            if(Schema.sObjectType.NameTemplateSequence__c.fields.LastSequence__c.isCreateable()){
                                newNameTemplate.LastSequence__c = prevNameTemplate.LastSequence__c;
                            }
                        }
                    } else {    
                        if(Schema.sObjectType.NameTemplateSequence__c.fields.LastSequence__c.isCreateable()){
                            newNameTemplate.LastSequence__c = startNumber - 1;  // Intializing value to make sequnce start from 1 for new created Template.
                        }
                    }
                    nameTemplateSeqToCreate.add(newNameTemplate);
                }                   

                if(Schema.sObjectType.NameTemplateSequence__c.isCreateable()){
                    insert as user nameTemplateSeqToCreate;
                }
                
                List<NameTemplateSequence__c> lstSequencesFinal = getNameTemplateSequence(strObject, setFormulaField, currentYear);
                currYearNameTemplateSeqMap = new Map<String,NameTemplateSequence__c>();
                generateNameTemplateSeqMap(lstSequencesFinal);
                
                lstSequencesFinal = setObjectNameNew(lstSequencesFinal, Trigger.new, formulaField, autoNumberFormat);
                  
                if(lstSequencesFinal.size() > 0 && Schema.sObjectType.NameTemplateSequence__c.isUpdateable()) { 
                    update as user lstSequencesFinal;   // updated the template sequence with the next available number  
                }    
            }
         }
    }


    /*
        Method Name: setObjectNameNew()
        Purpose: New Approach for generating sequences for Sobject based on NameTemplate Seq..
    */
    private static List<NameTemplateSequence__c> setObjectNameNew(List<NameTemplateSequence__c> lstNextSequence , List<sObject> lstObject, String formulaField, String autoNumberFormat){
        // if the NameTemplate sequence already has a record  Iterate over the lstObject 
        
        Integer nextSequence = 1; 
        String nameField = '';
       
      
        for(sObject currentObject: lstObject ){ 
            nameField = (String)currentObject.get(formulaField);     
            if(String.isNotEmpty(nameField))   {
                NameTemplateSequence__c templateSequence = currYearNameTemplateSeqMap.get(nameField.toLowercase());
                if(templateSequence !=null){
                nextSequence = templateSequence.LastSequence__c.intValue()+1 ;
                String numberFormat = getAutoGeneratedNumber(autoNumberFormat, nextSequence);                            
                templateSequence.LastSequence__c = nextSequence;    
                    
                currentObject.put('Name', nameField+numberFormat );                                       
                }else{
                    throw new CustomExceptions.RequiredException('Please Check Name Tamplates Sequence: '+nameField+' for currentYear.');
                } 
            }                                     
                                                
        }             
  
        return currYearNameTemplateSeqMap.values();
    }   

    /*
        Method Name: generateNameTemplateSeqMap()
        Purpose: This method for intilizing values within current-year and prev-year name template seq map...
    */
     private static void generateNameTemplateSeqMap(List<NameTemplateSequence__c> nameTempSeqList){
        Integer currentYear = System.today().year();
        if(nameTempSeqList.size() > 0){
            for(NameTemplateSequence__c seqVal : nameTempSeqList){
                String nameField = seqVal.Name;
                if(String.isEmpty(nameField)) {
                    continue;
                }

                if(seqVal.Year__c == currentYear) {
                    currYearNameTemplateSeqMap.put(nameField.toLowercase(), seqVal);
                } else {
                    prevYearNameTemplateSeqMap.put(nameField, seqVal);
                }
            }
         }
    }    

    private static List<NameTemplateSequence__c> getCurrAndPrevYearTemplateSeq(String strObject,Set<String> setFormulaField, Set<Integer> setYear){        
        List<NameTemplateSequence__c> lstNextSequence = new List<NameTemplateSequence__c>();
        if(Schema.sObjectType.NameTemplateSequence__c.isAccessible()){
        lstNextSequence = [Select Name, LastSequence__c, ObjectName__c, Year__c , StartSequence__c from NameTemplateSequence__c
                                                             where  ObjectName__c =: strObject and Name in :setFormulaField  and Year__c in : setYear WITH USER_MODE];          
        }                                                     
        return lstNextSequence;
    }
    
    private static List<NameTemplateSequence__c> getNameTemplateSequence(String strObject,Set<String> setFormulaField, Integer currentYear){        
        
        List<NameTemplateSequence__c> lstNextSequence = new List<NameTemplateSequence__c>();
        if(Schema.sObjectType.NameTemplateSequence__c.isAccessible()){
        lstNextSequence = [Select Name, LastSequence__c, ObjectName__c, Year__c , StartSequence__c from NameTemplateSequence__c
                                                             where  ObjectName__c =: strObject and Name in :setFormulaField  and Year__c =: currentYear WITH USER_MODE for update];          
        }                                                    
        return  lstNextSequence;                                                    
    }
    @TestVisible
    private static String getAutoGeneratedNumber(String autoNumberFormat, integer nextSequence){
        
        final Integer next = nextSequence; 
        final String regexZero = '\\{0+\\}';
        final String regexYear = '\\{Y+\\}';
        final String regexMonth = '\\{M+\\}';
        final Date dateToday = system.today();
        
        String strPattern = autoNumberFormat; 
        Pattern patZero = Pattern.compile(regexZero);
        Pattern patYear = Pattern.compile(regexYear);
        Pattern patMonth = Pattern.compile(regexMonth);
        
        Matcher matcherZero = patZero.matcher(strPattern);
        if(matcherZero.find()) {//SOQL/SOSL Injection False +ve
            Integer numOfZeros = matcherZero.group().length() - 2;
            strPattern = matcherZero.replaceFirst(String.valueOf(next).leftPad(numOfZeros, '0'));
        }
        Matcher matcherYear = patYear.matcher(strPattern);
        if(matcherYear.find()) {//SOQL/SOSL Injection False +ve
            Integer numOfYear = matcherYear.group().length() - 2;  
            if(numOfYear ==4){
                strPattern = matcherYear.replaceFirst(String.valueOf(dateToday.year()).leftPad(numOfYear, '0'));
            }
            if(numOfYear ==2){
                strPattern = matcherYear.replaceFirst(String.valueOf(dateToday.year()).subString(2).leftPad(numOfYear, '0'));
            }        
        }
        Matcher matcherMonth = patMonth.matcher(strPattern);
        if(matcherMonth.find()) {//SOQL/SOSL Injection False +ve
            Integer numOfMonth = matcherMonth.group().length() - 2;
            strPattern = matcherMonth.replaceFirst(String.valueOf(dateToday.month()).leftPad(numOfMonth, '0'));
        } 
                               
        return strPattern;
    }    
}