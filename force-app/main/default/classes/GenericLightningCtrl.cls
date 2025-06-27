global with sharing class GenericLightningCtrl {
    global Boolean isLightning = false;
    global String currentPageUrl;
    global Id currentRecordId;
    global String redirectUrl;
    global List<DynamicLayoutDefaultValueHelper> listDefaultValuesLightning = new List<DynamicLayoutDefaultValueHelper>();
    global list<LightningPageMessage> messageList = new list<LightningPageMessage> ();

    global String pageTemplateName;
    global String flexTableName;
    global String Type;
    global Object keyValueMap;
    global Object listValueMap;

    global GenericLightningCtrl(){
        isLightning = AppUtils.isLightningTheme();
	if(isLightning==false){
            isLightning = AppUtils.isExperienceCloud();
        }
    }

}