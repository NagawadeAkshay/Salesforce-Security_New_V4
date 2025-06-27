global with sharing class PhaseViewCtrl extends ParentController {
    global transient String currentTabName {get; set;}
    global transient String currentTabLabelName {get; set;}
    global transient PhaseConfig__c phaseConfig {get; set;}
    global transient String flexTableName {get; set;}
    global transient String previousTabName {get; set;}
    global PageReference bodyPageIncludeTop {get; set;}
    global PageReference bodyPageIncludeBottom {get; set;}
    global transient Map<String,List<String>> tableTypeWithSobjectMap {get; set;}

    global PhaseViewCtrl() {
    }

    global Boolean getDisplayFlexTable() {
        return true;
    }
    //This method returns list of Data table and Datatable Enhanced config in phase 
    global Map<String,List<String>> getTableTypeWithSobjectMap(List<String> objectNames) {
        Map<String,List<String>> tempMap = new Map<String,List<String>>();        
        return tempMap;
    }

    global String getKeyValueMap(){
        Map<String,String> keyValueMap = new Map<String,String>();
        return JSON.serialize(keyValueMap);        
    }
    public String getKeyValueMap1(){
        Map<String,String> keyValueMap = new Map<String,String>();
        return JSON.serialize(keyValueMap); 
    }
}