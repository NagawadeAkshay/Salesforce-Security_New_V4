/**
*   Interacts with UserPreferences__c custom setting to fetch and* sets various values.
*
* CHANGE HISTORY
*================================================================ 
* Dated          Name                   Description 
* 02/28/2014     Shah Kadirmohideen     Created
  06/12/2014     Nakul Kadam            Updated - Changed getInstance to getValues as it causes the issue - 
                                        getInstance fetches all the data from hierarchy records 
                                        and the upsert updates the current record with values from its parent.
  07/29/2015     Shrawan Raina          Updated - Changed getBooleanValue to handle null cases
*================================================================   
*/
global with sharing class UserPreferenceHelper {

    //Input fieldName may or may not have namespace
    global static Boolean getBooleanValue(String fieldName) {
        UserPreferences__c pref = UserPreferences__c.getInstance();
        if(pref.get(AppUtils.applyNameSpacePrefix(fieldName)) == null)
            return false;
        else
            return Boolean.valueOf(pref.get(AppUtils.applyNameSpacePrefix(fieldName)));
    }

    //Input fieldName may or may not have namespace
    global static void setBooleanValue(String fieldName, Boolean fieldValue) {}

    //Input fieldName may or may not have namespace
    global static String getStringValue(String fieldName) {
        Boolean isLightning = AppUtils.isLightningTheme();

        if(isLightning && fieldName == 'ActiveAppName__c'){  
            AppDefinition appDef = new AppDefinition();
            if(UserAppInfo.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.UserAppInfo.fields.Id.isAccessible() && Schema.SObjectType.UserAppInfo.fields.AppDefinitionId.isAccessible()) {
                UserAppInfo userApp = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() LIMIT 1];
                if(AppDefinition.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.AppDefinition.fields.DeveloperName.isAccessible() && Schema.SObjectType.AppDefinition.fields.Label.isAccessible()) {
                    appDef = [SELECT DeveloperName, Label FROM AppDefinition Where DurableId = :userApp.AppDefinitionId LIMIT 1];
                }
            }
            return appDef.DeveloperName;
        }else{
            UserPreferences__c pref = UserPreferences__c.getInstance();
            return String.valueOf(pref.get(AppUtils.applyNameSpacePrefix(fieldName)));
        }
        
    }

    public static String getAppName(String fieldName,Id ownerId) {
        Boolean isLightning = AppUtils.isLightningTheme();
        if(isLightning && fieldName == 'ActiveAppName__c'){  
            AppDefinition appDef = new AppDefinition();
            if(UserAppInfo.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.UserAppInfo.fields.Id.isAccessible() && Schema.SObjectType.UserAppInfo.fields.AppDefinitionId.isAccessible()) {
                List<UserAppInfo> userApp = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :ownerId LIMIT 1];
                if(userApp.size() > 0 && AppDefinition.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.AppDefinition.fields.DeveloperName.isAccessible() && Schema.SObjectType.AppDefinition.fields.Label.isAccessible()) {
                    appDef = [SELECT DeveloperName, Label FROM AppDefinition Where DurableId = :userApp[0].AppDefinitionId LIMIT 1];
                }else{
                    UserPreferences__c pref = UserPreferences__c.getInstance();
                    return String.valueOf(pref.get(AppUtils.applyNameSpacePrefix(fieldName)));
                }
            }
            return appDef.DeveloperName;
        }else{
            UserPreferences__c pref = UserPreferences__c.getInstance();
            return String.valueOf(pref.get(AppUtils.applyNameSpacePrefix(fieldName)));
        }
        
    }

    //Input fieldName may or may not have namespace
    global static void setStringValue(String fieldName, String fieldValue) {
        UserPreferences__c pref = UserPreferences__c.getInstance();
        if(pref == null) { 
            pref = UserPreferences__c.getInstance();
        }
        pref.put(AppUtils.applyNameSpacePrefix(fieldName), fieldValue);
        upsert pref;//NOPMD CRUD/ FLS false +ve this is custom setting we will skip this as we were getting an error for external users 
    }
    //get current logged in user app
    public static String getCurrentApp() {
        UserPreferences__c pref = UserPreferences__c.getInstance();
        if(pref != null && pref.ActiveAppName__c != null ) {
            return pref.ActiveAppName__c;
        }
        return null;
   } 

}