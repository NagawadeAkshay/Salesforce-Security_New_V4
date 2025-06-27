global with sharing class LightningComponentCtrl {
    public String namespaceTmp {get;set;}
    public String getNamespacePrefix(){
        return String.isNotBlank(namespaceTmp) ? namespaceTmp : AppUtils.getNameSpacePrefix();
    }
	
    public String getSpinnerResourceURL(){
        return LightningUtilityCtrl.getSpinnerURL();
    }

    public Boolean getEnableDebugMode(){
        return KeyValueHolderHelper.getBooleanValue('EnableDebugMode');
    }
}