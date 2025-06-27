global with sharing class ExternalLibraryCtrl {
    global String govGrantsColorContrastName {
        get;
        set;
    }
    global String externalLibNew {
        get;
        set;
    }
    global String tooltipster {
        get;
        set;
    }
    global String govGrantsExternal {
        get;
        set;
    }
    global String govGrants {
        get;
        set;
    }
    global String govGrantsTheme{
        get;
        set;
    }
    global String themeDocURL {
        get;
        set;
    }

    global String analyticsId {
        get;
        set;
    }
    global Boolean enableAnalytics {
        get;
        set;
    }
    global String govGrantPleaseWaitIconURL {
        get;
        set;
    }
    global String faviconIconURL {
        get;
        set;
    }

    global Integer getmessageTimeOut(){
       return  null;
    }
    
    global String getmessageType(){
        return null;
    }
    
    global ExternalLibraryCtrl() {
    }

    global void loadExternalLibData() {
    }
    global void applyGoogleAnalytics() {      

    }
    global string applyColorTheme(Boolean isEnable508) {
        return null;
    }
    global Boolean applyColorTheme508(){
        return null;
    }

     global void getstaticResourceUrl(){
    }
}