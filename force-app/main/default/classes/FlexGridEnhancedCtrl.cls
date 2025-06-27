/**
    *************************************************
    Audit History
    *************************************************
    2018-06-01     Ajinkya Raut         Created class
    *************************************************
**/
global with sharing class FlexGridEnhancedCtrl{
    public transient Boolean admnSetup{get;set;}
    public Integer  timeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
    }
    public String currencySymbol{
        get{
            return AppUtils.getLocaleCurrencySymbol();
        }set;
    }
    public String userTimeFormat{
        get{
            return AppUtils.getUserTimeZoneFormat();
        }set;
    }
    public String userDateFormat{
        get{
            return AppUtils.getUserDateFormat();
        }set;
    }
    public String userDateTimeFormat{
        get{
            return AppUtils.getUserDateTimeFormat();
        }set;
    }
    public String externalLibNew {
        get;
        set;
    }
    public String tooltipster {
        get;
        set;
    }
    public String govGrantsExternal {
        get;
        set;
    }
    public String govGrants {
        get;
        set;
    }
    public String flexGridEnhanced {
        get;
        set;
    }
    global FlexGridEnhancedCtrl(){
        admnSetup = GlobalConfigHelper.getEnableAdminSetup();
        if(admnSetup == null){
            admnSetup = false;
        }
        // List<String> resourceName= new List<String>{'ExternalLibNew','Tooltipster','GovGrants','GovGrantsExternal','FlexGridEnhanced'};
        // AppUtils.getResourceURL(resourceName);
        externalLibNew = AppUtils.getIcons('ExternalLibNew');
        tooltipster = AppUtils.getIcons('Tooltipster');
        govGrantsExternal = AppUtils.getIcons('GovGrantsExternal');
        govGrants = AppUtils.getIcons('GovGrants');
        flexGridEnhanced = AppUtils.getIcons('FlexGridEnhanced');
    }

    // Reading Value from Custom Setting for Message Close after certain time..

    @AuraEnabled(cacheable=true)
    public static Boolean getInstance(){
        Boolean isLightning;
        try {
            
            if(UserInfo.getUiTheme() =='Theme4d' || UserInfo.getUiTheme() == 'Theme4u'){   
                isLightning = true;
           }else{
                isLightning = false;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
      return isLightning;
    }


    @AuraEnabled
    public static Integer getmessageTimeOut(){
       return  KeyValueStoreHelper.getIntegerValue('PageMessageTimeOut',true);
    }
    @AuraEnabled
    public static Boolean getmessageTimeOutEnabled(){
       return  KeyValueStoreHelper.getBooleanValue('PageMessageTimeOut',true);
    }
    // Reading Value from Custom Setting For which Message Type Message To be Closed
    public String getmessageType(){
        return KeyValueStoreHelper.getTextValue('PageMessageTimeOut', true);
    }

    @RemoteAction @AuraEnabled
   
    global static Map<string, Object> getFlexGridInfo( String strJSONParams)
    {
        Map<string, Object> mapReturnValues = new Map<string, Object>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues = objFlexGridEnhancedHelper.getFlexGridInfo(strJSONParams);
            if(mapReturnValues.get('Success') == null){
                mapReturnValues.put('Success',true);
            }
        }
        catch(Exception ex)
        {
           mapReturnValues.put('Success',false);
           mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @RemoteAction   @auraEnabled

    global static Map<string, Object> getFlexTableInfo( String strJSONParams)
    {
        Map<string, Object> mapReturnValues = new Map<string, Object>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues = objFlexGridEnhancedHelper.getFlexTableInfo(strJSONParams);
            if(mapReturnValues.get('Success') == null){
                mapReturnValues.put('Success',true);
            }
        }
        catch(Exception ex)
        {
            mapReturnValues.put('Success',false);
            mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @RemoteAction   @auraEnabled
    global static List<sobject> getPageRecords( String strRecordsParams)
    {
        List<sobject> lstReturnValues = new List<sobject>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            lstReturnValues = objFlexGridEnhancedHelper.getPageRecords(strRecordsParams);
        }
        catch(Exception ex)
        {
           
        }
        return lstReturnValues;
    }

    @RemoteAction @AuraEnabled
    global static Map<String, Object> getPageRecordsMap( String strRecordsParams)
    {
        Map<String, Object> mapReturnValues = new Map<String, Object>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues = objFlexGridEnhancedHelper.getPageRecordsMap(strRecordsParams);
            mapReturnValues.put('Success',true);
        }
        catch(Exception ex)
        {
            mapReturnValues.put('Success',false);
            mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @RemoteAction @AuraEnabled
    global static Map<String,Object> executeClass( String executeClassParamJSON){
        Map<String,Object> mapReturnValues = new Map<String,Object>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues = objFlexGridEnhancedHelper.executeClass(executeClassParamJSON);
            if(mapReturnValues.get('Success') == null){
                mapReturnValues.put('Success',true);
            }
        }
        catch(Exception ex)
        {
            mapReturnValues.put('Success',false);
           mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @RemoteAction
    global static Map<String,Object> fetchLookUpData( String fetchLookupParamJSON){
        Map<String,Object> mapReturnValues = new Map<String,Object>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues = objFlexGridEnhancedHelper.fetchLookUpData(fetchLookupParamJSON);
            mapReturnValues.put('Success',true);
        }
        catch(Exception ex){
            mapReturnValues.put('Success',false);
            mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @RemoteAction
    global static Map<String,Object>fetchMiniLayout(Id referenceId){
        referenceId = String.escapeSingleQuotes(referenceId);
        return MiniLayoutController.getLayout(referenceId);
    }

    public static Map<String, String> getFlexGridEnhancedIcon(){

        map<string,string> FlexGridEnhancedIconMap = new map<string,string>();
        FlexGridEnhancedIconMap.put('fa fa-pencil','utility:edit');
        FlexGridEnhancedIconMap.put('fa fa-arrow','utility:right');
        FlexGridEnhancedIconMap.put('fa fa-ban','utility:close');
        FlexGridEnhancedIconMap.put('fa fa-bolt','utility:thunder');
        FlexGridEnhancedIconMap.put('fa fa-check','utility:success'); 
        FlexGridEnhancedIconMap.put('fa fa-clone','utility:clone');
        FlexGridEnhancedIconMap.put('fa fa-close','utility:close');
        FlexGridEnhancedIconMap.put('fa fa-cloud-download','utility:download');
        FlexGridEnhancedIconMap.put('fa fa-cloud-upload','utility:upload');
        FlexGridEnhancedIconMap.put('fa fa-comments','utility:chat');
        FlexGridEnhancedIconMap.put('fa fa-exchange','utility:exchange');
        FlexGridEnhancedIconMap.put('fa fa-external-link','utility:open');
        FlexGridEnhancedIconMap.put('fa fa-eye','utility:preview');
        FlexGridEnhancedIconMap.put('fa fa-file','utility:page');
        FlexGridEnhancedIconMap.put('fa fa-file-pdf','utility:file_pdf');
        FlexGridEnhancedIconMap.put('fa fa-file-text','utility:file');
        FlexGridEnhancedIconMap.put('fa fa-gavel','utility:thunder');
        FlexGridEnhancedIconMap.put('fa fa-level-up','utility:up');
        FlexGridEnhancedIconMap.put('fa fa-money','utility:currency');
        FlexGridEnhancedIconMap.put('fa fa-play','utility:play');
        FlexGridEnhancedIconMap.put('fa fa-plus-circle','utility:add');
        FlexGridEnhancedIconMap.put('fa fa-reply','utility:back');
        FlexGridEnhancedIconMap.put('fa fa-share','utility:share');
        FlexGridEnhancedIconMap.put('fa fa-share-square-o','utility:share_post');
        FlexGridEnhancedIconMap.put('fa fa-sign-in','utility:login');
        FlexGridEnhancedIconMap.put('fa fa-sign-out','utility:logout');
        FlexGridEnhancedIconMap.put('fa fa-sitemap','utility:hierarchy');
        FlexGridEnhancedIconMap.put('fa fa-sticky-note','utility:note');
        FlexGridEnhancedIconMap.put('fa fa-stop','utility:stop');
        FlexGridEnhancedIconMap.put('fa fa-tags','utility:tags');
        FlexGridEnhancedIconMap.put('fa fa-times','utility:close');
        FlexGridEnhancedIconMap.put('fa fa-trash','utility:delete');
        FlexGridEnhancedIconMap.put('fa fa-trophy','custom:custom48');
        FlexGridEnhancedIconMap.put('fa fa-undo','utility:undo');
        FlexGridEnhancedIconMap.put('fa fa-unlock','utility:unlock');
        FlexGridEnhancedIconMap.put('fa fa-paper-plane-o','utility:send');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-remove','utility:close');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-send','utility:send');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-trash','utility:delete');
        FlexGridEnhancedIconMap.put('fa fa-history','utility:skip_back');
        FlexGridEnhancedIconMap.put('fa fa-table','utility:table');
        FlexGridEnhancedIconMap.put('fa fa-coffee','utility:coffee');
        FlexGridEnhancedIconMap.put('fa fa-cubes','utility:cubes');
        FlexGridEnhancedIconMap.put('fa fa-star','utility:favorite');
        FlexGridEnhancedIconMap.put('fa fa-exclamation-triangle','utility:warning');
        FlexGridEnhancedIconMap.put('fa fa-line-FlexGridEnhanced','utility:lineFlexGridEnhanced');
        FlexGridEnhancedIconMap.put('fa fa-comment','utility:comments');
        FlexGridEnhancedIconMap.put('fa fa-caret-square-o-down','utility:down');
        FlexGridEnhancedIconMap.put('fa fa-wrench','utility:settings');
        FlexGridEnhancedIconMap.put('fa fa-share-square-o','utility:share');
        FlexGridEnhancedIconMap.put('fa fa-bolt','utility:lightning');
        FlexGridEnhancedIconMap.put('fa fa-trash-o','utility:delete');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        FlexGridEnhancedIconMap.put('fa fa-file-text-o','utility:contract_doc');
        FlexGridEnhancedIconMap.put('fa fa-wechat','utility:chat');
        FlexGridEnhancedIconMap.put('fa fa-paperclip','utility:attach');
        FlexGridEnhancedIconMap.put('fa fa-usd','utility:moneybag');
        FlexGridEnhancedIconMap.put('glyphicon glyphicon-tasks','utility:task');
        FlexGridEnhancedIconMap.put('fa fa-folder','utility:open_folder');
        FlexGridEnhancedIconMap.put('fa fa-paper-plane-o','utility:send');
        FlexGridEnhancedIconMap.put('fa fa-play','utility:play');
    
        return FlexGridEnhancedIconMap;
    }
    
    public static Map<String, String> getFlexGridEnhancedIconLwc(){
    
        map<string,string> FlexGridEnhancedIconMaplwc = new map<string,string>();
        FlexGridEnhancedIconMaplwc.put('fa fa-pencil','utility:edit');
        FlexGridEnhancedIconMaplwc.put('fa fa-arrow','utility:right');
        FlexGridEnhancedIconMaplwc.put('fa fa-ban','utility:error');
        FlexGridEnhancedIconMaplwc.put('fa fa-bolt','utility:thunder');
        FlexGridEnhancedIconMaplwc.put('fa fa-check','utility:success'); 
        FlexGridEnhancedIconMaplwc.put('fa fa-clone','utility:clone');
        FlexGridEnhancedIconMaplwc.put('fa fa-close','utility:close');
        FlexGridEnhancedIconMaplwc.put('fa fa-cloud-download','utility:download');
        FlexGridEnhancedIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        FlexGridEnhancedIconMaplwc.put('fa fa-comments','utility:chat');
        FlexGridEnhancedIconMaplwc.put('fa fa-exchange','utility:exchange');
        FlexGridEnhancedIconMaplwc.put('fa fa-external-link','utility:open');
        FlexGridEnhancedIconMaplwc.put('fa fa-eye','utility:preview');
        FlexGridEnhancedIconMaplwc.put('fa fa-file','utility:page');
        FlexGridEnhancedIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        FlexGridEnhancedIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        FlexGridEnhancedIconMaplwc.put('fa fa-file-text','utility:file');
        FlexGridEnhancedIconMaplwc.put('fa fa-gavel','utility:thunder');
        FlexGridEnhancedIconMaplwc.put('fa fa-level-up','utility:up');
        FlexGridEnhancedIconMaplwc.put('fa fa-money','utility:currency');
        FlexGridEnhancedIconMaplwc.put('fa fa-play','utility:play');
        FlexGridEnhancedIconMaplwc.put('fa fa-plus-circle','utility:add');
        FlexGridEnhancedIconMaplwc.put('fa fa-reply','utility:back');
        FlexGridEnhancedIconMaplwc.put('fa fa-share','utility:share');
        FlexGridEnhancedIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        FlexGridEnhancedIconMaplwc.put('fa fa-sign-in','utility:login');
        FlexGridEnhancedIconMaplwc.put('fa fa-sign-out','utility:logout');
        FlexGridEnhancedIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        FlexGridEnhancedIconMaplwc.put('fa fa-sticky-note','utility:note');
        FlexGridEnhancedIconMaplwc.put('fa fa-stop','utility:stop');
        FlexGridEnhancedIconMaplwc.put('fa fa-tags','utility:tags');
        FlexGridEnhancedIconMaplwc.put('fa fa-times','utility:close');
        FlexGridEnhancedIconMaplwc.put('fa fa-trash','utility:delete');
        FlexGridEnhancedIconMaplwc.put('fa fa-trophy','custom:custom48');
        FlexGridEnhancedIconMaplwc.put('fa fa-undo','utility:undo');
        FlexGridEnhancedIconMaplwc.put('fa fa-unlock','utility:unlock');
        FlexGridEnhancedIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        FlexGridEnhancedIconMaplwc.put('fa fa-history','utility:skip_back');
        FlexGridEnhancedIconMaplwc.put('fa fa-table','utility:table');
        FlexGridEnhancedIconMaplwc.put('fa fa-coffee','utility:coffee');
        FlexGridEnhancedIconMaplwc.put('fa fa-cubes','utility:cubes');
        FlexGridEnhancedIconMaplwc.put('fa fa-star','utility:favorite');
        FlexGridEnhancedIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        FlexGridEnhancedIconMaplwc.put('fa fa-line-FlexGridEnhanced','utility:graph');
        FlexGridEnhancedIconMaplwc.put('fa fa-comment','utility:comments');
        FlexGridEnhancedIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        FlexGridEnhancedIconMaplwc.put('fa fa-wrench','utility:settings');
        FlexGridEnhancedIconMaplwc.put('fa fa-share-square-o','utility:share');
        FlexGridEnhancedIconMaplwc.put('fa fa-bolt','utility:lightning');
        FlexGridEnhancedIconMaplwc.put('fa fa-trash-o','utility:delete');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        FlexGridEnhancedIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        FlexGridEnhancedIconMaplwc.put('fa fa-wechat','utility:chat');
        FlexGridEnhancedIconMaplwc.put('fa fa-paperclip','utility:attach');
        FlexGridEnhancedIconMaplwc.put('fa fa-usd','utility:moneybag');
        FlexGridEnhancedIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        FlexGridEnhancedIconMaplwc.put('fa fa-folder','utility:open_folder');
        FlexGridEnhancedIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        FlexGridEnhancedIconMaplwc.put('fa fa-play','utility:play');
        FlexGridEnhancedIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        FlexGridEnhancedIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        FlexGridEnhancedIconMaplwc.put('fa fa-male','utility:user');
    
        return FlexGridEnhancedIconMaplwc;
    }
            

    @RemoteAction
    global static Map<String,Object> deleteRecord(String deleteRecordParamJSON){
        //obsolete
        return null;  
    }

    @RemoteAction  @auraEnabled
    global static Map<String,Object> deleteRecords(String deleteRecordsParamJSON){
        Map<String,Object> mapReturnValues = new Map<String,Object>();
        try{
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues =  objFlexGridEnhancedHelper.deleteRecords(deleteRecordsParamJSON);  
            if(mapReturnValues.get('Success') == null){
                mapReturnValues.put('Success',true);     
            }
        }catch(Exception ex){
            mapReturnValues.put('Success',false);
            mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
            
    }
    @RemoteAction  @auraEnabled
    global static String getTextValueOfContent(Id contentID){
        ContentNote a = [Select id, Content from ContentNote where id =: contentID with USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        String textvalue = a.content.toString();
        return textvalue;
    }

    @RemoteAction @AuraEnabled
    global static Map<String,Object> saveRecords(String saveRecordsJSON){
        Map<String,Object> mapReturnValues = new Map<String,Object>();
        try{
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues =  objFlexGridEnhancedHelper.saveRecords(saveRecordsJSON);   
            if(mapReturnValues.get('Success') == null){
                mapReturnValues.put('Success',true); 
            } 
        }catch(Exception ex){
            mapReturnValues.put('Success',false);
            mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @RemoteAction
    global static Map<String,Object> getOverAllTotal(String overAllTotalJSON){
        Map<String,Object> mapReturnValues = new Map<String,Object>();
        try{
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            mapReturnValues =  objFlexGridEnhancedHelper.getOverAllTotal(overAllTotalJSON);   
            if(mapReturnValues.get('Success') == null){
                mapReturnValues.put('Success',true); 
            } 
        }catch(Exception ex){
            mapReturnValues.put('Success',false);
            mapReturnValues.put('Message','Exception :   ' + AppUtils.handleSystemExceptionMsg(ex) + '  StackTrace :  ' + ex.getStackTraceString() + '  @ line#  ' + ex.getLineNumber());
        }
        return mapReturnValues;
    }

    @AuraEnabled
    public static Boolean updateContentDocLink(Id noteId, Id parentRecordId){
        List<ContentDocumentLink> contDocRecords = [select Id,ContentDocumentId,LinkedEntityId 
                                            from ContentDocumentLink where ContentDocumentId =: noteId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        
            Boolean success = false;
            if(contDocRecords.size() > 0 ){
                       
                ContentDocumentLink link = new ContentDocumentLink();
                link.ContentDocumentId   = noteId;
                link.LinkedEntityId      = parentRecordId;
                if(Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()){
                    link.ShareType           = 'V';
                }
                if(Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable()){
                    link.Visibility          = 'AllUsers';
                }
                if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                    insert as user link;
                    success = true;
                }
            }
            return success;
        }
  
    @RemoteAction
    global  static Map<String,Object> searchWithAllRecord( String strRecordsParams)
    {
        Map<String,Object> lstReturnValues = new  Map<String,Object>();
        try
        {
            FlexGridEnhancedHelper objFlexGridEnhancedHelper = new FlexGridEnhancedHelper();
            lstReturnValues   = objFlexGridEnhancedHelper.searchWithAllRecord(strRecordsParams);
            lstReturnValues.put('Success',true);
        }
        catch(Exception ex)
        {
        }
        return lstReturnValues;
    }
}