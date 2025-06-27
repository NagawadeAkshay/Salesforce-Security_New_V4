//deprecated cls
global with sharing virtual class GenericViewCtrl {
    global GenericViewCtrl(){}
    global GenericViewCtrl(ApexPages.StandardController stdController){}
    global virtual string init(Id recordId, boolean isLightning){return null;}
    global virtual String getKeyValueMapGeneric(Id recordId, boolean isLightning){return null;} 
    global virtual String getWarningMessage(){return null;}
 }