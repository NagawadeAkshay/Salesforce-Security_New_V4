/*
* Class Name	:	LightningUtilityCtrl
* Description	:	Utility class for Lightning Utility component methods
* --------------------------------------------------------------------------------------------------------------------
*   Version		Date        		Author						Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0			25 July 2019  		Dipak Pawar					Initial Development
* --------------------------------------------------------------------------------------------------------------------
*/
public with sharing class LightningUtilityCtrl {
    public with sharing class LightningUtilityCtrlException extends Exception{}
    
    @AuraEnabled
    public static Map<String, Object> getUtilityInfo(){
        try {
            Map<string, Object> mapUtilityInfo = new Map<string, Object>();
            mapUtilityInfo.put('spinnerUrl', getSpinnerURL());
            mapUtilityInfo.put('salesforceBaseUrl', 'callout:ApexMDApi');
            mapUtilityInfo.put('sessionId', UserInfo.getOrganizationId()+''+'{!$Credential.OAuthToken}');
            mapUtilityInfo.put('networkId', Network.getNetworkId());
            mapUtilityInfo.put('timeZone', UserInfo.getTimeZone().getID());
            mapUtilityInfo.put('namespacePrefix', AppUtils.getNameSpacePrefix());
            return mapUtilityInfo;
        } catch(Exception objException) {
            throw new AuraHandledException(parseExceptionMsg(objException.getMessage()));
        }        
    }
    
    public static String getVFSessionId(){
        return null;
    }
    
    /*
    * Description	:	Utility method to get Salesforce base URL in Lightning components
	* Created By	:	Dipak Pawar on 30 July 2019
	*/
	@AuraEnabled(cacheable=true)
    public static String getSalesforceBaseUrl(){
        return URL.getOrgDomainUrl().toExternalForm();
    }
    
    /*
    * Description	:	Utility method to get Salesforce Domain URL in Lightning components
	* Created By	:	Dipak Pawar on 30 July 2019
	*/
    @AuraEnabled
    public static String getOrgDomainUrl(){
        return Url.getOrgDomainUrl().toExternalForm();
    }
   
    /*
    * Description	:	Utility method to save records by passing records as a parameter. 
	* Created By	:	Dipak Pawar on 30 July 2019
	*/
    @AuraEnabled
    public static String saveRecords (List<SObject> records){
        SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
        String sObjName = cls.getSobjectName(records[0]);
        Savepoint objSavepoint = Database.setSavepoint();
        try{
            if(records != null && records.size() > 0 && records[0].Id != null){
                if(AppUtils.isObjectUpdateable(sObjName)){//FLS/CRUD false +ve as we are performing action on Sobject we are performing CRUD with the help of other cls
               		return JSON.serialize(Database.update(records, AccessLevel.USER_MODE)); 
                }
            } else {
                if(AppUtils.isObjectCreateable(sObjName)){//FLS/CRUD false +ve as we are performing action on Sobject we are performing CRUD with the help of other cls
                	return JSON.serialize(Database.insert(records, AccessLevel.USER_MODE));
            	}                      
            }
            return null;                      
        }catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new AuraHandledException(parseExceptionMsg(objException.getMessage()));
        }
    }
    
    /*
    * Description	:	Utility method to delete records by passing records as a parameter. 
	* Created By	:	Dipak Pawar on 30 July 2019
	*/
    @AuraEnabled
    public static String deleteRecords (List<SObject> records){        
        Savepoint objSavepoint = Database.setSavepoint();
        SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
        String sObjName = cls.getSobjectName(records[0]);
        try{
            if(AppUtils.isObjectDeletable(sObjName)){//CRUD false +ve as we are performing action on Sobject we are performing CRUD with the help of other cls
            	return JSON.serialize(Database.delete(records, AccessLevel.USER_MODE));//FLS False +ve - Used access level user mode to perform FLS
            }
            return null;
        }catch(Exception objException){
            Database.rollback(objSavepoint);
            throw new AuraHandledException(parseExceptionMsg(objException.getMessage()));
        }
    }
    
    public static String parseExceptionMsg(string errorMsg){
        String innerMsg = '';
        boolean isTriggerException = false;
        if(!String.isEmpty(errorMsg) && errorMsg.contains('GNT.CustomExceptions.') && errorMsg.contains('Class.GNT.') ){
            isTriggerException = true;
            innerMsg = errorMsg.substringBetween('GNT.CustomExceptions.','Class.GNT.');
        }
        
        if(!String.isEmpty(errorMsg) && errorMsg.contains(':') && !isTriggerException){            
            List<String> parts = new List<String>();
            List<String> subParts = new List<String>();
            innerMsg = errorMsg;
            parts = errorMsg.split(':', 2);
            if(!String.isEmpty(parts[1]) && parts[1].contains(',')){
                innerMsg = parts[1];
                subParts = parts[1].split(',',2);
                if(!String.isEmpty(subParts[1])){
                    innerMsg = subParts[1];
                    String partString = subParts[1]; // partString - This is trigger error In Progress.: []
                    String errorMessage = partString.substringBefore(': ['); // errorMessage -  This is trigger error In Progress.
                    if(!String.isEmpty(errorMessage)){
                        innerMsg = errorMessage.trim();
                        if(innerMsg.contains(':')){
                            innerMsg = parseExceptionMsg(innerMsg); // called recursive funtion to parse stack trace of error messages for finding correct error message
                        }
                    }
                }                    
            }                         
        } else {
            innerMsg = errorMsg;
        }
        return innerMsg;
    }
    
    /*
    * Description	:	Utility method to get Spinner Resource URL in Lightning components
	* Created By	:	Dipak Pawar on 05 August 2019
	*/
    //User Story 71061: Internal - Remove document object dependency and move to static resource
    @AuraEnabled
    public static String getSpinnerURL(){
        try{
           // String govGrantPleaseWaitIcon = KeyValueStoreHelper.getTextValue('govGrantPleaseWaitIcon', true);
            if(!Test.isRunningTest()){
                //StaticResource objStaticResource = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name =:govGrantPleaseWaitIcon];
                //return '/resource/' + objStaticResource.SystemModStamp.getTime() + '/' + (String.isNotBlank(objStaticResource.NamespacePrefix) ? objStaticResource.NamespacePrefix + '__' : '') + govGrantPleaseWaitIcon;  
                return String.escapeSingleQuotes(AppUtils.getIcons('govGrantPleaseWaitIcon'));
            } else if(Test.isRunningTest()){
                return 'Test Data';
            }
            return null;
        }catch(Exception objException){
            
            throw new AuraHandledException(AppUtils.handleSystemExceptionMsg(objException));
        }
    }
}