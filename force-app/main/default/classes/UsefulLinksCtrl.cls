global with sharing class UsefulLinksCtrl {
    global List<UsefulLinkWrapper> extendedLinksList {get;set;}
    global List<UsefulLinkWrapper> minLinksList {get;set;}
    global Integer minItemsCount {get;set;}
    global Integer actualItemCount {get;set;}
    
    global UsefulLinksCtrl (){
    }

    global void initialize(){
       
    }
    
    global with sharing class UsefulLinkWrapper{
        global string label{get;set;}
        global string url{get;set;}
        global boolean openInNewWindow {get;set;}
        global UsefulLinkWrapper(String label, String url, boolean openInNewWindow){
            this.label = label;
            this.url = url;
            this.openInNewWindow = openInNewWindow;
        }
    }
}