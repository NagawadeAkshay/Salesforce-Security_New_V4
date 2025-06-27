/*
  This class has methods to create charts according to object name.
  **********************************************************
  Audit History
  **********************************************************
  2014-03-25  Manasi Gangal     Created
  **********************************************************  
*/

//Deprecated HighChart using Lightning Standard Charts. 
global with sharing class PieChartCtrl{
    
        public transient String currentFiscalYear{get;set;}
        public transient String defaultPhase{get;set;}
        public transient String recordId{get;set;}
    global transient string chartFilterParameters{get;set;}
    global PieChartCtrl(){
    }

    global static Map<string,string> fetchInitialData(String chartName,String filterClause,String phaseName,String chartId){
        // deprecated method
        return null;
    }
    global static Map<String,String> fetchData(String phaseName,String chartName,String filterClause,String chartId){
        // deprecated method
        return null;
    }
    //deprecated
    global static Map<string,Object> fetchInitData(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause){
        Map<String,Object> resultMap = new Map<String,Object> ();
        return resultMap;
    }
    //deprecated
    global static Map<string,Object> fetchInitDataWithRecordId(String chartName,String phaseName,String chartId,boolean isDashboard,string filterClause,string recordId){
        Map<String,Object> resultMap = new Map<String,Object> ();
        return resultMap;
    }

    @RemoteAction
    global static Map<String, Object> getChartsData(Map<String, Object> paramMap) {
        Map<String,Object> resultMap = new Map<String,Object> ();
        return resultMap;
    }

    public static Map<String, String> getActionIcon(){
    
        map<string,string> fafaLwcUtilityMap = new map<string,string>();
        fafaLwcUtilityMap.put('fa fa-pencil','utility:edit');
        fafaLwcUtilityMap.put('fa fa-arrow','utility:right');
        fafaLwcUtilityMap.put('fa fa-ban','utility:close');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-check','utility:success'); 
        fafaLwcUtilityMap.put('fa fa-clone','utility:clone');
        fafaLwcUtilityMap.put('fa fa-close','utility:close');
        fafaLwcUtilityMap.put('fa fa-cloud-download','utility:download');
        fafaLwcUtilityMap.put('fa fa-cloud-upload','utility:upload');
        fafaLwcUtilityMap.put('fa fa-comments','utility:chat');
        fafaLwcUtilityMap.put('fa fa-exchange','utility:exchange');
        fafaLwcUtilityMap.put('fa fa-external-link','utility:open');
        fafaLwcUtilityMap.put('fa fa-eye','utility:preview');
        fafaLwcUtilityMap.put('fa fa-file','utility:page');
        fafaLwcUtilityMap.put('fa fa-file-pdf','utility:file_pdf');
        fafaLwcUtilityMap.put('fa fa-file-text','utility:file');
        fafaLwcUtilityMap.put('fa fa-gavel','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-level-up','utility:up');
        fafaLwcUtilityMap.put('fa fa-money','utility:currency');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-plus-circle','utility:add');
        fafaLwcUtilityMap.put('fa fa-reply','utility:back');
        fafaLwcUtilityMap.put('fa fa-share','utility:share');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share_post');
        fafaLwcUtilityMap.put('fa fa-sign-in','utility:login');
        fafaLwcUtilityMap.put('fa fa-sign-out','utility:logout');
        fafaLwcUtilityMap.put('fa fa-sitemap','utility:hierarchy');
        fafaLwcUtilityMap.put('fa fa-sticky-note','utility:note');
        fafaLwcUtilityMap.put('fa fa-stop','utility:stop');
        fafaLwcUtilityMap.put('fa fa-tags','utility:tags');
        fafaLwcUtilityMap.put('fa fa-times','utility:close');
        fafaLwcUtilityMap.put('fa fa-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-trophy','custom:custom48');
        fafaLwcUtilityMap.put('fa fa-undo','utility:undo');
        fafaLwcUtilityMap.put('fa fa-unlock','utility:unlock');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-pencil','utility:edit');
        fafaLwcUtilityMap.put('glyphicon glyphicon-remove','utility:close');
        fafaLwcUtilityMap.put('glyphicon glyphicon-send','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        fafaLwcUtilityMap.put('glyphicon glyphicon-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-history','utility:skip_back');
        fafaLwcUtilityMap.put('fa fa-table','utility:table');
        fafaLwcUtilityMap.put('fa fa-coffee','utility:coffee');
        fafaLwcUtilityMap.put('fa fa-cubes','utility:cubes');
        fafaLwcUtilityMap.put('fa fa-star','utility:favorite');
        fafaLwcUtilityMap.put('fa fa-exclamation-triangle','utility:warning');
        fafaLwcUtilityMap.put('fa fa-line-chart','utility:lineChart');
        fafaLwcUtilityMap.put('fa fa-comment','utility:comments');
        fafaLwcUtilityMap.put('fa fa-caret-square-o-down','utility:down');
        fafaLwcUtilityMap.put('fa fa-wrench','utility:settings');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:lightning');
        fafaLwcUtilityMap.put('fa fa-trash-o','utility:delete');
        fafaLwcUtilityMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        fafaLwcUtilityMap.put('fa fa-file-text-o','utility:contract_doc');
        fafaLwcUtilityMap.put('fa fa-wechat','utility:chat');
        fafaLwcUtilityMap.put('fa fa-paperclip','utility:attach');
        fafaLwcUtilityMap.put('fa fa-usd','utility:moneybag');
        fafaLwcUtilityMap.put('glyphicon glyphicon-tasks','utility:task');
        //fafaLwcUtilityMap.put('fa fa-trophy','utility:funding_award_adjustment');
        fafaLwcUtilityMap.put('fa fa-folder','utility:open_folder');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
    
        return fafaLwcUtilityMap;
    }
    
    public static Map<String, String> getActionIconLwc(){
    
        map<string,string> fafaLwcUtilityMap = new map<string,string>();
        fafaLwcUtilityMap.put('fa fa-pencil','utility:edit');
        fafaLwcUtilityMap.put('fa fa-arrow','utility:right');
        fafaLwcUtilityMap.put('fa fa-ban','utility:error');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-check','utility:success'); 
        fafaLwcUtilityMap.put('fa fa-clone','utility:clone');
        fafaLwcUtilityMap.put('fa fa-close','utility:close');
        fafaLwcUtilityMap.put('fa fa-cloud-download','utility:download');
        fafaLwcUtilityMap.put('fa fa-cloud-upload','utility:upload');
        fafaLwcUtilityMap.put('fa fa-comments','utility:chat');
        fafaLwcUtilityMap.put('fa fa-exchange','utility:exchange');
        fafaLwcUtilityMap.put('fa fa-external-link','utility:open');
        fafaLwcUtilityMap.put('fa fa-eye','utility:preview');
        fafaLwcUtilityMap.put('fa fa-file','utility:page');
        fafaLwcUtilityMap.put('fa fa-file-pdf','utility:pdf_ext');
        fafaLwcUtilityMap.put('fa fa-file-pdf-o','utility:pdf_ext');
        fafaLwcUtilityMap.put('fa fa-file-text','utility:file');
        fafaLwcUtilityMap.put('fa fa-gavel','utility:thunder');
        fafaLwcUtilityMap.put('fa fa-level-up','utility:up');
        fafaLwcUtilityMap.put('fa fa-money','utility:currency');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-plus-circle','utility:add');
        fafaLwcUtilityMap.put('fa fa-reply','utility:back');
        fafaLwcUtilityMap.put('fa fa-share','utility:share');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share_post');
        fafaLwcUtilityMap.put('fa fa-sign-in','utility:login');
        fafaLwcUtilityMap.put('fa fa-sign-out','utility:logout');
        fafaLwcUtilityMap.put('fa fa-sitemap','utility:hierarchy');
        fafaLwcUtilityMap.put('fa fa-sticky-note','utility:note');
        fafaLwcUtilityMap.put('fa fa-stop','utility:stop');
        fafaLwcUtilityMap.put('fa fa-tags','utility:tags');
        fafaLwcUtilityMap.put('fa fa-times','utility:close');
        fafaLwcUtilityMap.put('fa fa-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-trophy','custom:custom48');
        fafaLwcUtilityMap.put('fa fa-undo','utility:undo');
        fafaLwcUtilityMap.put('fa fa-unlock','utility:unlock');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-pencil','utility:edit');
        fafaLwcUtilityMap.put('glyphicon glyphicon-remove','utility:close');
        fafaLwcUtilityMap.put('glyphicon glyphicon-send','utility:send');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        fafaLwcUtilityMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        fafaLwcUtilityMap.put('glyphicon glyphicon-trash','utility:delete');
        fafaLwcUtilityMap.put('fa fa-history','utility:skip_back');
        fafaLwcUtilityMap.put('fa fa-table','utility:table');
        fafaLwcUtilityMap.put('fa fa-coffee','utility:coffee');
        fafaLwcUtilityMap.put('fa fa-cubes','utility:cubes');
        fafaLwcUtilityMap.put('fa fa-star','utility:favorite');
        fafaLwcUtilityMap.put('fa fa-exclamation-triangle','utility:warning');
        fafaLwcUtilityMap.put('fa fa-line-chart','utility:graph');
        fafaLwcUtilityMap.put('fa fa-comment','utility:comments');
        fafaLwcUtilityMap.put('fa fa-caret-square-o-down','utility:down');
        fafaLwcUtilityMap.put('fa fa-wrench','utility:settings');
        fafaLwcUtilityMap.put('fa fa-share-square-o','utility:share');
        fafaLwcUtilityMap.put('fa fa-bolt','utility:lightning');
        fafaLwcUtilityMap.put('fa fa-trash-o','utility:delete');
        fafaLwcUtilityMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        fafaLwcUtilityMap.put('fa fa-file-text-o','utility:contract_doc');
        fafaLwcUtilityMap.put('fa fa-wechat','utility:chat');
        fafaLwcUtilityMap.put('fa fa-paperclip','utility:attach');
        fafaLwcUtilityMap.put('fa fa-usd','utility:moneybag');
        fafaLwcUtilityMap.put('glyphicon glyphicon-tasks','utility:task');
        //fafaLwcUtilityMap.put('fa fa-trophy','utility:funding_award_adjustment');
        fafaLwcUtilityMap.put('fa fa-folder','utility:open_folder');
        fafaLwcUtilityMap.put('fa fa-paper-plane-o','utility:send');
        fafaLwcUtilityMap.put('fa fa-play','utility:play');
        fafaLwcUtilityMap.put('fa fa-folder-open-o','utility:opened_folder');
        fafaLwcUtilityMap.put('fa fa-check-square-o','utility:multi_select_checkbox');
        fafaLwcUtilityMap.put('fa fa-male','utility:user');
    
        return fafaLwcUtilityMap;
    }
    
}