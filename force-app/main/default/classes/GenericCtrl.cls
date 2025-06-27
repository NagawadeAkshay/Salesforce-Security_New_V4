global virtual with sharing class GenericCtrl{
    public String pageTemplateName;
    public String flexTableName;
    public Boolean showTable;
    global GenericLightningCtrl lightningObject = new GenericLightningCtrl ();

    global GenericCtrl(){}  
    global GenericCtrl(ApexPages.StandardController stdController){}
     
    global virtual string getWarningMessage(){return null;} 
    global virtual string init(){return null;}
    global virtual string init(Id recordId){return null;}
    global virtual string init(Id recordId, string urlVar){return null;}
     
    public virtual String getKeyValueMapGeneric(Id recordId, Id pageLayoutId){return null;} 
    global virtual String getKeyValueMapGeneric(Id recordId){return null;} 
    public virtual String getKeyValueMapGeneric(string recorobjectNamedId, Id pageLayoutId){return null;} 
    global virtual String getListParamsGeneric(string recordId){return null;} 
    global virtual String getListParamsGeneric(Id recordId){return null;}
    public virtual String getChartParameters(string recordId){return null;}
}