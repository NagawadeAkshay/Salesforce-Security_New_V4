global with sharing class PageLayoutBuilderHelper{
    public static String pageLayoutConfigId;
    public static Map<String,Object> saveLayout(String pageLayoutString){
        Map<String,Object> retVal = new Map<String,Object>();

        PageLayoutBuilderHelper.PageLayout pageLayout = (PageLayoutBuilderHelper.PageLayout)JSON.deserializeStrict(pageLayoutString, PageLayoutBuilderHelper.PageLayout.class) ;   //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.

        PageLayoutBuilderHelper plbHelper = new PageLayoutBuilderHelper();
        pageLayoutConfigId = pageLayout.layoutId;
        plbHelper.processLayoutList(pageLayout,retVal);
        return retVal;
    }

    public PageLayoutConfig__c getPageLayoutConfig(PageLayout pageLayout){
        PageLayoutConfig__c pageLayoutConfig = new PageLayoutConfig__c();
        if(Schema.sObjectType.PageLayoutConfig__c.isAccessible() && Schema.sObjectType.PageLayoutConfig__c.isCreateable() && Schema.sObjectType.PageLayoutConfig__c.isUpdateable()){
            pageLayoutConfig.Id = pageLayout.layoutId;
        }
        if(Schema.sObjectType.PageLayoutConfig__c.fields.ObjectAPIName__c.isCreateable() && Schema.sObjectType.PageLayoutConfig__c.fields.ObjectAPIName__c.isUpdateable()){
            pageLayoutConfig.ObjectAPIName__c = pageLayout.objectAPIName;
        }
        if(Schema.sObjectType.PageLayoutConfig__c.fields.Description__c.isCreateable() && Schema.sObjectType.PageLayoutConfig__c.fields.Description__c.isUpdateable()){
            pageLayoutConfig.Description__c = pageLayout.description;
        }
        return pageLayoutConfig;
    }

    public void processLayoutList(PageLayout pageLayout,Map<String,Object> retVal){     
        List<PageLayoutConfig__c> pageLayoutList = new List<PageLayoutConfig__c>();
        PageLayoutConfig__c pageLayoutConfig = new PageLayoutConfig__c();
        if(Schema.sObjectType.PageLayoutConfig__c.isCreateable() && Schema.sObjectType.PageLayoutConfig__c.isUpdateable()){
            pageLayoutConfig = getPageLayoutConfig(pageLayout);
            pageLayoutList.add(pageLayoutConfig);
            upsert as user pageLayoutList;
        }
        processTabList(pageLayoutConfig.Id,pageLayout.tabConfigList);
        retVal.put('LayoutList',pageLayoutList);        
    }

    public TabConfig__c getTabConfig(Tab tab,Id pageLayoutId){
        TabConfig__c tabConfig = new TabConfig__c();
        if(Schema.sObjectType.TabConfig__c.isAccessible() && Schema.sObjectType.TabConfig__c.isCreateable() && Schema.sObjectType.TabConfig__c.isUpdateable()){
            tabConfig.Id = tab.tabId;
        }
        if(Schema.sObjectType.TabConfig__c.fields.SortOrder__c.isCreateable() && Schema.sObjectType.TabConfig__c.fields.SortOrder__c.isUpdateable()){
            tabConfig.SortOrder__c = tab.index;
        }
        if(Schema.sObjectType.TabConfig__c.fields.StandardTabName__c.isCreateable() && Schema.sObjectType.TabConfig__c.fields.StandardTabName__c.isUpdateable()){
            tabConfig.StandardTabName__c = tab.title;
        }
        if(Schema.sObjectType.TabConfig__c.fields.PageLayoutConfig__c.isCreateable() && Schema.sObjectType.TabConfig__c.fields.PageLayoutConfig__c.isUpdateable()){
            tabConfig.PageLayoutConfig__c = pageLayoutId;
        }
        return tabConfig;
    }

    public void processTabList(Id pageLayoutId, List<Tab> tabConfigList){
        List<TabConfig__c> tabList = new List<TabConfig__c>();
        Map<String,TabConfig__c> tabIdObjectMap = new Map<String,TabConfig__c>();
        List<PageBlock> pageBlockConfigList = new List<PageBlock>();
        
        if(Schema.sObjectType.TabConfig__c.isCreateable() && Schema.sObjectType.TabConfig__c.isUpdateable()){
            for(Tab tab:tabConfigList){
                TabConfig__c tabConfig = getTabConfig(tab,pageLayoutId);            
                tabList.add(tabConfig); 
                tabIdObjectMap.put(tab.id,tabConfig);       
                pageBlockConfigList.addAll(tab.pageBlockConfigList);
            }
            upsert as user tabList;
        }
        processPageBlockList(tabIdObjectMap,pageBlockConfigList);       
    }
    
    public PageBlockConfig__c getPageBlockConfig(TabConfig__c tabConfig,PageBlock pb){
        PageBlockConfig__c pageBlockConfig = new PageBlockConfig__c();
        if(Schema.sObjectType.PageBlockConfig__c.fields.TabLayoutConfig__c.isCreateable() && Schema.sObjectType.PageBlockConfig__c.fields.TabLayoutConfig__c.isUpdateable()){
            pageBlockConfig.TabLayoutConfig__c = tabConfig.Id;
        }
        if(Schema.sObjectType.PageBlockConfig__c.isAccessible() && Schema.sObjectType.PageBlockConfig__c.isCreateable() && Schema.sObjectType.PageBlockConfig__c.isUpdateable()){
            pageBlockConfig.Id = pb.pageBlockId;
        }
        if(Schema.sObjectType.PageBlockConfig__c.fields.SortOrder__c.isCreateable() && Schema.sObjectType.PageBlockConfig__c.fields.SortOrder__c.isUpdateable()){
            pageBlockConfig.SortOrder__c = pb.index;
        }
        if(Schema.sObjectType.PageBlockConfig__c.fields.BodyColumns__c.isCreateable() && Schema.sObjectType.PageBlockConfig__c.fields.BodyColumns__c.isUpdateable()){
            pageBlockConfig.BodyColumns__c =    pb.columns == 'single' ? '1' : 
                                                pb.columns == 'double' ? '2' :
                                                pb.columns == 'triple' ? '3' :
                                                pb.columns == 'quad'   ? '4' : '1';
        }
        if(Schema.sObjectType.PageBlockConfig__c.fields.PageBlockTitle__c.isCreateable() && Schema.sObjectType.PageBlockConfig__c.fields.PageBlockTitle__c.isUpdateable()){
            pageBlockConfig.PageBlockTitle__c = pb.title;
        }
        return pageBlockConfig;
    }

    public void processPageBlockList(Map<String,TabConfig__c> tabIdObjectMap,List<PageBlock> pageBlockConfigList){
        List<PageBlockConfig__c> pageBlockList = new List<PageBlockConfig__c>();
        Map<String,PageBlockConfig__c> pageBlockIdObjectMap = new Map<String,PageBlockConfig__c>();
        List<PageBlockDetail> pageBlockDetailConfigList = new List<PageBlockDetail>();

        if(Schema.sObjectType.PageBlockConfig__c.isCreateable() && Schema.sObjectType.PageBlockConfig__c.isUpdateable()){
            for(PageBlock pb : pageBlockConfigList){
                PageBlockConfig__c pageBlockConfig = getPageBlockConfig(tabIdObjectMap.get(pb.parentId),pb);
                pageBlockList.add(pageBlockConfig);
                pageBlockIdObjectMap.put(pb.id,pageBlockConfig);
                pageBlockDetailConfigList.addAll(pb.pageBlockDetailConfigList);
            }
            upsert as user pageBlockList;
        }
        processPageBlockDetailList(pageBlockIdObjectMap,pageBlockDetailConfigList);
    }

    public PageBlockDetailConfig__c getPageBlockDetailConfig(PageBlockConfig__c pageBlockConfig,PageBlockDetail pbd){
        PageBlockDetailConfig__c pageBlockDetailConfig = new PageBlockDetailConfig__c();
        if(Schema.sObjectType.PageBlockDetailConfig__c.fields.PageBlockConfig__c.isCreateable() && Schema.sObjectType.PageBlockDetailConfig__c.fields.PageBlockConfig__c.isUpdateable()){
            pageBlockDetailConfig.PageBlockConfig__c = pageBlockConfig.Id;
        }
        if(Schema.sObjectType.PageBlockDetailConfig__c.isAccessible() && Schema.sObjectType.PageBlockDetailConfig__c.isCreateable() && Schema.sObjectType.PageBlockDetailConfig__c.isUpdateable()){
            pageBlockDetailConfig.Id = pbd.fieldInfo.fieldId;
        }
        if(Schema.sObjectType.PageBlockDetailConfig__c.fields.SortOrder__c.isCreateable() && Schema.sObjectType.PageBlockDetailConfig__c.fields.SortOrder__c.isUpdateable()){
            pageBlockDetailConfig.SortOrder__c = pbd.index;
        }
        if(Schema.sObjectType.PageBlockDetailConfig__c.fields.FieldAPIName__c.isCreateable() && Schema.sObjectType.PageBlockDetailConfig__c.fields.FieldAPIName__c.isUpdateable()){
            pageBlockDetailConfig.FieldAPIName__c = pbd.fieldInfo.fieldAPIName;
        }
        if(Schema.sObjectType.PageBlockDetailConfig__c.fields.FieldLabelOverride__c.isCreateable() && Schema.sObjectType.PageBlockDetailConfig__c.fields.FieldLabelOverride__c.isUpdateable()){
            pageBlockDetailConfig.FieldLabelOverride__c = pbd.fieldInfo.fieldLabel;
        }
        return pageBlockDetailConfig;
    }

    public void processPageBlockDetailList(Map<String,PageBlockConfig__c> pageBlockIdObjectMap,List<PageBlockDetail> pageBlockDetailConfigList){
        List<PageBlockDetailConfig__c> pageBlockDetailList = new List<PageBlockDetailConfig__c>();
        if(Schema.sObjectType.PageBlockDetailConfig__c.isCreateable() && Schema.sObjectType.PageBlockDetailConfig__c.isUpdateable()){
            for(PageBlockDetail pbd : pageBlockDetailConfigList){
                PageBlockDetailConfig__c pageBlockDetailConfig = getPageBlockDetailConfig(pageBlockIdObjectMap.get(pbd.pageBlockConfigId),pbd);
                pageBlockDetailList.add(pageBlockDetailConfig);
            }
            upsert as user pageBlockDetailList;
        }
        deleteRemovedPageBlockDetails(pageBlockDetailList);
    }

    public void deleteRemovedPageBlockDetails(List<PageBlockDetailConfig__c> pageBlockDetailList){
        List<Id> pbdIds = new List<Id>();
        for(PageBlockDetailConfig__c pbd : pageBlockDetailList){
            pbdIds.add(pbd.Id);
        }
        List<PageBlockDetailConfig__c> pbdToDelete = new List<PageBlockDetailConfig__c>();
        if(Schema.sObjectType.PageBlockDetailConfig__c.isAccessible()){
        pbdToDelete = [SELECT ID 
            FROM PageBlockDetailConfig__c 
            WHERE PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__c = :pageLayoutConfigId
            AND Id NOT IN :pbdIds  WITH USER_MODE];
        }

        if(Schema.sObjectType.PageBlockDetailConfig__c.isDeletable() && Schema.SObjectType.PageBlockDetailConfig__c.isAccessible()){
            delete as user pbdToDelete;
        }
    }

    public with sharing class PageLayout{
        public String layoutId;
        public String objectAPIName;
        public String description;
        public List<Tab> tabConfigList;    
    } 

    public with sharing class Tab implements Comparable{
        public String layoutId;
        public String tabId;
        public String id;
        public Integer index;
        public String title;
        public List<PageBlock> pageBlockConfigList;

        public Integer compareTo(Object compareTo) {
            Tab t = (Tab) compareTo;
            return index - t.index;
        }    
    } 

    public with sharing class PageBlock implements Comparable{
        public String parentId;
        public String pageBlockId;
        public String columns;
        public String title;
        public String id;
        public Integer index;
        public List<PageBlockDetail> pageBlockDetailConfigList;

        public Integer compareTo(Object compareTo) {
            PageBlock pb = (PageBlock) compareTo;
            return index - pb.index;
        }    
    } 

    public with sharing class PageBlockDetail implements Comparable{
        public String pageBlockConfigId;
        public Field fieldInfo;
        public Integer index;       
        public Integer availableFieldsIndex;
        public String fieldId;

        public Integer compareTo(Object compareTo) {
            PageBlockDetail pbd = (PageBlockDetail) compareTo;
            return index - pbd.index;
        }    
    }


    public with sharing class Field implements Comparable{
        public String fieldId;
        public String fieldAPIName;
        public String fieldLabel;
        public String dataType;
        public Integer sortOrder;
        public Boolean disabled;
        public Integer level;
        public FieldDescribe describeInfo;

        public Integer compareTo(Object compareTo) {
            Field f = (Field) compareTo;
            return sortOrder - f.sortOrder;
        }
    } 

    public with sharing class FieldDescribe {
        public String referenceTo;
        public String relationshipName;
    }
}