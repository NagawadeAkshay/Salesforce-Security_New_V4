/*
    Controller to handle the theme settings for a user
    **********************************************************
    Audit History
    
    **********************************************************
    2014-06-19         Kunal Shah            Created 
    **********************************************************  
*/
global with sharing class CustomCSSCtrl {
    public String themeDocumentId {get; set;}

    global CustomCSSCtrl() {
        findThemeDocumentId();
    }

    /*
        For logged in users (non guest users), theme id is grabbed from user preference custom setting.
        For guest users, we use browser token to differentiate between external & internal and apply the 
        theme appropriately. For guest users, browser cookie is set when the internal/community login page 
        is acessed.
    */
    public void findThemeDocumentId() {
        if(UserInfo.getUserType() == 'GUEST'){ // Site guest user or Community guest user
            UserPreferences__c userPrefInstance = UserPreferences__c.getInstance();
            this.themeDocumentId = userPrefInstance.ThemeDocumentID__c;
        }else{ // Internal user or External user
            UserPreferences__c userPrefInstance = UserPreferences__c.getInstance();
            this.themeDocumentId = userPrefInstance.ThemeDocumentID__c;
        }
    }

}