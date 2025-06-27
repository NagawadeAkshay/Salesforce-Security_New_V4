public with sharing class DynamicLayoutHelper {
    /*
        Modified By        : Tomy Pallissery
        Last Modified Date : 16/04/2018
        Modifications      : 09/04/2018
                             1. Changed getTemplateName method signature, added @context param
                             2. Added support displaying layout based on expression created using expression builder
                             13/04/2018
                             1. Changed the layout name to pick from PageLayoutConfig__r.Name, instead of PackageConfig__r.PageTemplateConfig__r.Name
                             16/04/2018
                             1. Introduced FormConfig__c lookup on SObjectConfig__c object
                             2. Changed the layout name to pick from FormConfig__r.Name, instead of PackageConfig__r.PageTemplateConfig__r.Name
        Assumptions   : Method assumes the criteria for choosing template, will be either expression based or criteria field based
                        for all the layouts collectively for a particular sObject. Mixing expression and criteria fields wil not work. 
        Params        : @idVal - Id of the record, 
                        @context - current context among ['Create', 'View', 'Edit']
                        @listDefaultValues - default values list in case of create context
                        @sObjName - name of sobject, required in case of create context

    */
    public static String getTemplateName(String idVal, String context, List<DynamicLayoutDefaultValueHelper> listDefaultValues, String sObjName) {
        //Id profileId = userinfo.getProfileId();
        UserPreferences__c pref = UserPreferences__c.getInstance();
        String profileName;
        if(pref != null){ 
            profileName = pref.ProfileName__c; //[Select Id,Name from Profile where Id=:profileId].Name;
            if(String.isBlank(profileName)) {
                throw new CustomExceptions.RequiredException('Please configure profile at user preference level.');
            }
        }
        
        String customAppName = pref.ActiveAppName__c;
        String SObjectName = '';

        if(String.isNotBlank(idVal)) {
            SObjectName = ((ID)idVal).getSobjectType().getDescribe().getName();
        } else if(String.isNotBlank(sObjName)) {
            SObjectName = sObjName;
        } else {
            throw new CustomExceptions.RequiredException('Please provide Id or Name of the related SObject whose layout has to be selected.');
        }

        List<SObjectLayoutConfig__c> sObjectLayoutConfig = new List<SObjectLayoutConfig__c>();
        if(Schema.sObjectType.SObjectLayoutConfig__c.isAccessible()){
            sObjectLayoutConfig = [SELECT id, SObjectConfig__r.CriteriaField__c, ProfileNames__c, 
                                                                CriteriaValue__c,CustomApp__c,IsDefault__c,
                                                                PageLayoutConfig__r.Name, FormConfig__r.Name,
                                                                PackageConfig__r.PageTemplateConfig__r.Name, DisplayLayoutExpressionJSON__c,
                                                                DisplayLayoutExpressionFields__c
                                                                FROM SObjectLayoutConfig__c 
                                                                WHERE SObjectConfig__r.Name=:SObjectName and CustomApp__r.Name=:customAppName 
                                                                and RecordType.DeveloperName != 'Mini Layout' and RecordType.DeveloperName != 'MiniLayout' 
                                                                WITH USER_MODE ORDER BY IsDefault__c DESC];
        }
        if( sObjectLayoutConfig.size() == 0 ) {
            throw new CustomExceptions.RequiredException('Please configure template.');
        }
        
        String criteriaTemplateName, query = ' SELECT ';
        Boolean isExpressionEval = false, isCriteriaFieldEval = false;
        SObject sObjRecord;

        if(context.equalsIgnoreCase('Create')) {
            sObjRecord = Schema.getGlobalDescribe().get(SObjectName).newSObject();
            if(listDefaultValues != null) {
                for(DynamicLayoutDefaultValueHelper dv : listDefaultValues) {
                    sObjRecord.put(dv.fieldAPIName, dv.defaultValue);
                }
            }

        } else { 

            Set<String> expressionFieldsSet = new Set<String>();

            for(SObjectLayoutConfig__c pageLayoutConfig : sObjectLayoutConfig) {
                if(String.isNotBlank(pageLayoutConfig.DisplayLayoutExpressionJSON__c)) { 
                    if(String.isNotBlank(pageLayoutConfig.DisplayLayoutExpressionFields__c)) {

                        List<String> expFieldsList = pageLayoutConfig.DisplayLayoutExpressionFields__c.toLowerCase().split(',');
                        expressionFieldsSet = new Set<String>(expFieldsList);
                    }
                    isExpressionEval = true;
                }
            }

            if(isExpressionEval) {
                query += string.escapeSingleQuotes(String.join(new List<String>(expressionFieldsSet), ','));
            } else if(sObjectLayoutConfig[0].SObjectConfig__r.CriteriaField__c != null) { 
                query += string.escapeSingleQuotes(sObjectLayoutConfig[0].SObjectConfig__r.CriteriaField__c);
                isCriteriaFieldEval = true;
            }

            query += ' FROM ' + string.escapeSingleQuotes(SObjectName);
            query += ' WHERE Id =:idVal ';


            if(isExpressionEval || isCriteriaFieldEval) {
                List<SObject> sObjList;
                if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    sObjList = Database.query(query, AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
                }
                if( sObjList.size() == 0 ) {
                    throw new CustomExceptions.SOQLException('No records found for ' + SObjectName);
                }
                
                sObjRecord = sObjList[0];
            }
            
        }

        if(isExpressionEval) {
            for(SObjectLayoutConfig__c sobjLayoutConfig : sObjectLayoutConfig) { 
                if(String.isNotBlank(sobjLayoutConfig.DisplayLayoutExpressionJSON__c)){
                    Boolean expressionEvalResult = ExpressionJsonEvaluator.evaluateExpression(sobjLayoutConfig.DisplayLayoutExpressionJSON__c, sObjRecord, context);
                    if(expressionEvalResult) {
                        return sobjLayoutConfig.FormConfig__r.Name;
                    }
                }
            }
        } else { //old approach support
            if(isCriteriaFieldEval) {
                String objVal = (String)sObjRecord.get(sObjectLayoutConfig[0].SObjectConfig__r.CriteriaField__c);
                for( SObjectLayoutConfig__c sobjLayoutConfig : sObjectLayoutConfig ) {
                    if(sobjLayoutConfig.ProfileNames__c != null && sobjLayoutConfig.ProfileNames__c.contains(profileName) && sobjLayoutConfig.CriteriaValue__c == objVal ) {
                        return sobjLayoutConfig.FormConfig__r.Name;
                    } else if( sobjLayoutConfig.CriteriaValue__c == objVal ){
                        /*criteriaTemplateName = pageLayoutConfig.PackageConfig__r.PageTemplateConfig__c;
                          //Tomy - 09/04/2018 - modified to return name instead of id
                        */
                        criteriaTemplateName = sobjLayoutConfig.FormConfig__r.Name;
                    }
                }
                
            }
            for( SObjectLayoutConfig__c sobjLayoutConfig : sObjectLayoutConfig ) {
                if(sobjLayoutConfig.ProfileNames__c != null && sobjLayoutConfig.ProfileNames__c.contains(profileName)) {
                    return sobjLayoutConfig.FormConfig__r.Name;
                }
            }
        }
        
        if(criteriaTemplateName != null ) {
            return criteriaTemplateName;
        }
        if(sObjectLayoutConfig[0].IsDefault__c) {
              //Tomy - 09/04/2018 - modified to return name instead of id
            return sObjectLayoutConfig[0].FormConfig__r.Name;
        } else {
            throw new CustomExceptions.RequiredException('Please configure default template.');
        }
        
    }
    
    public static boolean isRecordAccess(String recId,String type,String ViewTamplateId) {
        boolean isAccess = true;
        Boolean isViewLayout = false;
        
        String userProfileName = AppUtils.getProfileInfo();
        String userType = AppUtils.getUserType();
        Boolean isInternalUser = AppUtils.isInternalUser();
        Boolean isApplicant = AppUtils.isApplicant();
        String hideExp;
        String hideFields;
        String SobjectActionConfigId;
        String userRole = AppUtils.getRoleInfo();
        List<SobjectActionConfig__c> sObjectActionConfig = new List<SobjectActionConfig__c>();
        String SObjectName = ((ID)recId).getSobjectType().getDescribe().getName();

        List<PageLayoutActionConfig__c> pageLayoutActionConfig= new List<PageLayoutActionConfig__c>();
        if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
            pageLayoutActionConfig = [SELECT id,SobjectActionConfig__c,HideForProfile__c,StandardAction__c,HideDecisionField__c,HideDecisionExpression__c,HideDecisionExpressionLong__c,HideForContext__c,HideForUser__c,HideOperator__c,HideForRole__c,HideExpressionFields__c,HideExpressionJSON__c
            from PageLayoutActionConfig__c where PageLayoutConfig__c =:ViewTamplateId and Active__c=true and StandardAction__c =: type WITH USER_MODE];
        }
        if(pageLayoutActionConfig.size() != 0 && String.isNotEmpty(pageLayoutActionConfig[0].SobjectActionConfig__c)){           
            SobjectActionConfigId = pageLayoutActionConfig[0].SobjectActionConfig__c; 
            if(Schema.sObjectType.SobjectActionConfig__c.isAccessible()){
                sObjectActionConfig = [select id,SObjectConfig__c,StandardAction__c,HideDecisionField__c,HideDecisionExpression__c,HideDecisionExpressionLong__c,HideForContext__c,HideForProfile1__c,HideForUser__c,HideOperator__c,HideForRole__c,HideExpressionFields__c,HideExpressionJSON__c,HideForProfile__c
                from SobjectActionConfig__c where SObjectConfig__r.Name=:SObjectName and StandardAction__c=:type and Id =: SobjectActionConfigId WITH USER_MODE];
            }
        }
        
        if(sObjectActionConfig.size() == 0) {
            if(isAccess){
                if(pageLayoutActionConfig.size() != 0){
                    isAccess =  DynamicLayoutHelper.isActionAlreadyPerformed(recId,type,pageLayoutActionConfig,null);
                }
            }
           return isAccess;
         }
                    
        List<Sobject> sObjectConfig = new List<Sobject> ();
        if(String.isNotEmpty(sObjectActionConfig[0].HideExpressionFields__c)){ 
            // hideFields store comma separated fields.          
            hideFields = string.escapeSingleQuotes(sObjectActionConfig[0].HideExpressionFields__c); 
        }else if(String.isNotEmpty(sObjectActionConfig[0].HideDecisionExpressionLong__c)){            
            hideExp = string.escapeSingleQuotes(sObjectActionConfig[0].HideDecisionExpressionLong__c); 
        }
        else if(String.isNotEmpty(sObjectActionConfig[0].HideDecisionExpression__c)){            
            hideExp = string.escapeSingleQuotes(sObjectActionConfig[0].HideDecisionExpression__c); 
        }
        else{
            if(String.isNotEmpty(sObjectActionConfig[0].HideDecisionField__c)){ 
                hideExp = string.escapeSingleQuotes(sObjectActionConfig[0].HideDecisionField__c);              
                hideExp += '=true';             
            }
        } 
      
        if(String.isNotEmpty(hideFields)){
            //Below query gives sobject record. 
            if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check           
                sObjectConfig = Database.query('select ' + string.escapeSingleQuotes(hideFields) +' from '+string.escapeSingleQuotes(SObjectName)+' where id = \''+string.escapeSingleQuotes(recId)+'\'', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
            }
        } else if(hideExp != null){
            if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
        	    sObjectConfig = Database.query('select id,Name from '+string.escapeSingleQuotes(SObjectName)+' where '+ hideExp + ' and id = \''+string.escapeSingleQuotes(recId)+'\'', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes
            }
            if( sObjectConfig.size() > 0 ){
                isAccess= false;                
            }
        }else{
            if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                sObjectConfig = Database.query('select id,Name from '+string.escapeSingleQuotes(SObjectName)+' where id = \''+string.escapeSingleQuotes(recId)+'\'', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes and SObjectName is fetched from schema standard method.    
            }
        }
        
        if(type == 'View'){
             isViewLayout = true;           
        } 
        if(String.isNotEmpty(sObjectActionConfig[0].HideExpressionJSON__c)){
            //Prajakta:ExpressionJsonEvaluator.evaluateExpression method returns boolean value.It is used to hide based on conditions.
            Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(sObjectActionConfig[0].HideExpressionJSON__c, sObjectConfig.size()>0?sObjectConfig[0]:null, isViewLayout == true ?'View':'Edit');
            if(hideResult == true){
                isAccess= false;
            }
        }else{
                boolean hideAction = AppUtils.showHideComponent(isViewLayout, isInternalUser, isApplicant, sObjectActionConfig[0].HideForProfile__c,recId, sObjectActionConfig[0].HideForContext__c, sObjectActionConfig[0].HideForUser__c, userProfileName,sObjectActionConfig[0].HideForRole__c,userRole,sObjectActionConfig[0].HideOperator__c);
                if(hideAction== true){
                    isAccess= false;
            }
        
        } 
        
        return isAccess;
    }

    public static boolean isActionAlreadyPerformed(String recId,String type,List<PageLayoutActionConfig__c> pageLayoutActionConfig,String actionId) {
        boolean isAccess = true;
        Boolean isViewLayout = false;
        String userProfileName = AppUtils.getProfileInfo();
        String userType = AppUtils.getUserType();
        Boolean isInternalUser = AppUtils.isInternalUser();
        Boolean isApplicant = AppUtils.isApplicant();
        String hideExp;
        String hideFields;
        String userRole = AppUtils.getRoleInfo();
        String SObjectName = ((ID)recId).getSobjectType().getDescribe().getName();
        if(pageLayoutActionConfig == null){
            if(Schema.sObjectType.PageLayoutActionConfig__c.isAccessible()){
                pageLayoutActionConfig= [SELECT id,SobjectActionConfig__c,HideForProfile__c,StandardAction__c,HideDecisionField__c,HideDecisionExpression__c,HideDecisionExpressionLong__c,HideForContext__c,HideForUser__c,HideOperator__c,HideForRole__c,HideExpressionFields__c,HideExpressionJSON__c 
                from PageLayoutActionConfig__c where Active__c=true and Id =: actionId WITH USER_MODE];
            }
        }

        if(pageLayoutActionConfig.size() == 0) {
            return true;
        }
                    
        List<Sobject> sObjectConfig = new List<Sobject> ();
        //for security need to escapce this using Apputils.parseWhereClause
        if(String.isNotEmpty(pageLayoutActionConfig[0].HideExpressionFields__c)){ 
            hideFields = pageLayoutActionConfig[0].HideExpressionFields__c;
        }else if(String.isNotEmpty(pageLayoutActionConfig[0].HideDecisionExpressionLong__c)){            
            hideExp = pageLayoutActionConfig[0].HideDecisionExpressionLong__c;
        }
        else if(String.isNotEmpty(pageLayoutActionConfig[0].HideDecisionExpression__c)){            
            hideExp = pageLayoutActionConfig[0].HideDecisionExpression__c;
        }
        else{
            if(String.isNotEmpty(pageLayoutActionConfig[0].HideDecisionField__c)){ 
                hideExp = pageLayoutActionConfig[0].HideDecisionField__c;
                hideExp += '=true';             
            }
        } 
      
        if(String.isNotEmpty(hideFields)){
            if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                sObjectConfig = Database.query('select ' + hideFields +' from '+string.escapeSingleQuotes(SObjectName)+' where id = \''+string.escapeSingleQuotes(recId)+'\'', AccessLevel.USER_MODE);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes    
            }
        } else if(hideExp != null){
            if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
            sObjectConfig = Database.query('select id,Name from '+string.escapeSingleQuotes(SObjectName)+' where '+ hideExp + ' and id = \''+string.escapeSingleQuotes(recId)+'\'', AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
            }
            if( sObjectConfig.size() > 0 ){
                isAccess= false;                
            }
        }else{
            if(AppUtils.isObjectAccessible(SObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
            sObjectConfig = Database.query('select id,Name from '+string.escapeSingleQuotes(SObjectName)+' where id = \''+string.escapeSingleQuotes(recId)+'\'',AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes     
            }
        }
        
        if(type == 'View'){
             isViewLayout = true;           
        } 
        if(String.isNotEmpty(pageLayoutActionConfig[0].HideExpressionJSON__c)){
            Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(pageLayoutActionConfig[0].HideExpressionJSON__c, sObjectConfig.size()>0?sObjectConfig[0]:null,'View');
            if(hideResult == true){
                isAccess= false;
            }
        } 
        return isAccess;
    }
}