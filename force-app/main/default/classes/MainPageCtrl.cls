/**
* 
* Controller class for the Main Page Template
*
* CHANGE HISTORY
*================================================================ 
* Dated          Name               Description  
* 02/10/2014    Vinayak Sharma      Created 
* 02/10/2014    Jag Valaiyapathy    Show/Hide Home Tab
*================================================================
*/

global with sharing class MainPageCtrl {
    
    global transient   boolean hidepublicSearch {get;set;}
    global transient   boolean homeTabFlag {get;set;}
    global transient   boolean hideSidebar {get;set;}
    global transient  boolean isMaintenance {get; set;}
    global transient String maintenanceTitle {get; set;}
    global transient  String maintenanceMessage {get; set;}
    global String themeDocURL {get; set;}

    global transient  List<FooterConfig> footerList {get; set;}
    global transient  boolean showFeedbackComponent {get;set;}
    global transient  boolean adminSetupFlag {get;set;}
    global transient String clientFooterLogoDocId {get; set;}
    global transient String clientFooterLogoText {get; set;}
    global transient List<String> URLStringList {get;set;}
    global transient Boolean isGuest {get;set;} 
    
    global String expandTextCharSize {get; set;}
    global String expandTextMoreStr {get; set;}
    global String expandTextLessStr {get; set;}

    global transient string enableGTM {get;set;} 
    global transient String tagMangerId {get;set;}  
    global transient String gtmDataLayer {get;set;}    
    global transient String userType {get;set;}  
    global transient String selectedApp {get; set;}   
     

    global transient string enableWhatFix {get; set;}
    global transient String whatFixEntId {get;set;}  
    global transient String isSandbox {get; set;}   
    global transient String orgName {get;set;}   
    global transient String packageName {get; set;}
    global transient String profileName {get; set;}   

    
    global MainPageCtrl(){
    }

    @RemoteAction
    global static void hideUserSideBarPreference(){       
    }
    
    @RemoteAction
    global static void showUserSideBarPreference() {                    
    }

    global boolean showHideHomeTab(){   
        return null;
    }

    global boolean hidepublicSearchBar(){       
        return null;
    }
    
    @RemoteAction
    global static String getlocaleDateFormat(){
        return null;
    }

    @RemoteAction
    global static String getlocaleDateTimeFormat(){
        return null;
    }
  
    /* INNER CLASSES */

    global with sharing class FooterConfig implements Comparable {
        global String displayText {get; set;}
        global String targetURL {get; set;}
        global Boolean lastEntry {get; set;}

        private Integer sequence;

        global FooterConfig(String displayText, String targetURL, Integer sequence) {
            this.displayText = displayText;
            this.targetURL = targetURL;
            this.sequence = sequence;
            this.lastEntry = false;
        }

        global Integer compareTo (Object other) {
            FooterConfig otherObj = (FooterConfig) other;
            if (this.sequence < otherObj.sequence) {
                return -1;
            }
            else if (this.sequence > otherObj.sequence) {
                return 1;
            }
            else {
                return 0;
            }
        }
    }    
}