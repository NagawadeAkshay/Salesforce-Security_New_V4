/*
  This class has methods to fetch the Sidebar typeahead search result and persist the user preference for sidebar search.
  **********************************************************
  Audit History
  **********************************************************
  2014-02-05  Manasi Gangal     Created
  6-19-2014     Nakul Kadam     code refinement, added getPhaseConfigDetails()
  **********************************************************  
*/ 


global with sharing class SidebarSearchCtrl{

    global transient string phaseNameVal {get;set;}
    
    global SidebarSearchCtrl(String phaseName){
        
    }
    global SidebarSearchCtrl(){
     
    }
    
    
    @RemoteAction
    global static Map<String,Object> fetchSearchInitialData(String phaseName){
        
        return null;
    }
    
    @RemoteAction
    global static void updateSidebarCollapsed(String collapsed){
    }

    public static Map<String, String> getSidebarSearchIcon(){

        map<string,string> SidebarSearchIconMap = new map<string,string>();
        SidebarSearchIconMap.put('fa fa-pencil','utility:edit');
        SidebarSearchIconMap.put('fa fa-arrow','utility:right');
        SidebarSearchIconMap.put('fa fa-ban','utility:close');
        SidebarSearchIconMap.put('fa fa-bolt','utility:thunder');
        SidebarSearchIconMap.put('fa fa-check','utility:success'); 
        SidebarSearchIconMap.put('fa fa-clone','utility:clone');
        SidebarSearchIconMap.put('fa fa-close','utility:close');
        SidebarSearchIconMap.put('fa fa-cloud-download','utility:download');
        SidebarSearchIconMap.put('fa fa-cloud-upload','utility:upload');
        SidebarSearchIconMap.put('fa fa-comments','utility:chat');
        SidebarSearchIconMap.put('fa fa-exchange','utility:exchange');
        SidebarSearchIconMap.put('fa fa-external-link','utility:open');
        SidebarSearchIconMap.put('fa fa-eye','utility:preview');
        SidebarSearchIconMap.put('fa fa-file','utility:page');
        SidebarSearchIconMap.put('fa fa-file-pdf','utility:file_pdf');
        SidebarSearchIconMap.put('fa fa-file-text','utility:file');
        SidebarSearchIconMap.put('fa fa-gavel','utility:thunder');
        SidebarSearchIconMap.put('fa fa-level-up','utility:up');
        SidebarSearchIconMap.put('fa fa-money','utility:currency');
        SidebarSearchIconMap.put('fa fa-play','utility:play');
        SidebarSearchIconMap.put('fa fa-plus-circle','utility:add');
        SidebarSearchIconMap.put('fa fa-reply','utility:back');
        SidebarSearchIconMap.put('fa fa-share','utility:share');
        SidebarSearchIconMap.put('fa fa-share-square-o','utility:share_post');
        SidebarSearchIconMap.put('fa fa-sign-in','utility:login');
        SidebarSearchIconMap.put('fa fa-sign-out','utility:logout');
        SidebarSearchIconMap.put('fa fa-sitemap','utility:hierarchy');
        SidebarSearchIconMap.put('fa fa-sticky-note','utility:note');
        SidebarSearchIconMap.put('fa fa-stop','utility:stop');
        SidebarSearchIconMap.put('fa fa-tags','utility:tags');
        SidebarSearchIconMap.put('fa fa-times','utility:close');
        SidebarSearchIconMap.put('fa fa-trash','utility:delete');
        SidebarSearchIconMap.put('fa fa-trophy','custom:custom48');
        SidebarSearchIconMap.put('fa fa-undo','utility:undo');
        SidebarSearchIconMap.put('fa fa-unlock','utility:unlock');
        SidebarSearchIconMap.put('fa fa-paper-plane-o','utility:send');
        SidebarSearchIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        SidebarSearchIconMap.put('glyphicon glyphicon-remove','utility:close');
        SidebarSearchIconMap.put('glyphicon glyphicon-send','utility:send');
        SidebarSearchIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        SidebarSearchIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        SidebarSearchIconMap.put('glyphicon glyphicon-trash','utility:delete');
        SidebarSearchIconMap.put('fa fa-history','utility:skip_back');
        SidebarSearchIconMap.put('fa fa-table','utility:table');
        SidebarSearchIconMap.put('fa fa-coffee','utility:coffee');
        SidebarSearchIconMap.put('fa fa-cubes','utility:cubes');
        SidebarSearchIconMap.put('fa fa-star','utility:favorite');
        SidebarSearchIconMap.put('fa fa-exclamation-triangle','utility:warning');
        SidebarSearchIconMap.put('fa fa-line-SidebarSearch','utility:lineSidebarSearch');
        SidebarSearchIconMap.put('fa fa-comment','utility:comments');
        SidebarSearchIconMap.put('fa fa-caret-square-o-down','utility:down');
        SidebarSearchIconMap.put('fa fa-wrench','utility:settings');
        SidebarSearchIconMap.put('fa fa-share-square-o','utility:share');
        SidebarSearchIconMap.put('fa fa-bolt','utility:lightning');
        SidebarSearchIconMap.put('fa fa-trash-o','utility:delete');
        SidebarSearchIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        SidebarSearchIconMap.put('fa fa-file-text-o','utility:contract_doc');
        SidebarSearchIconMap.put('fa fa-wechat','utility:chat');
        SidebarSearchIconMap.put('fa fa-paperclip','utility:attach');
        SidebarSearchIconMap.put('fa fa-usd','utility:moneybag');
        SidebarSearchIconMap.put('glyphicon glyphicon-tasks','utility:task');
        SidebarSearchIconMap.put('fa fa-folder','utility:open_folder');
        SidebarSearchIconMap.put('fa fa-paper-plane-o','utility:send');
        SidebarSearchIconMap.put('fa fa-play','utility:play');
    
        return SidebarSearchIconMap;
    }
    
    public static Map<String, String> getSidebarSearchIconLwc(){
    
        map<string,string> SidebarSearchIconMaplwc = new map<string,string>();
        SidebarSearchIconMaplwc.put('fa fa-pencil','utility:edit');
        SidebarSearchIconMaplwc.put('fa fa-arrow','utility:right');
        SidebarSearchIconMaplwc.put('fa fa-ban','utility:error');
        SidebarSearchIconMaplwc.put('fa fa-bolt','utility:thunder');
        SidebarSearchIconMaplwc.put('fa fa-check','utility:success'); 
        SidebarSearchIconMaplwc.put('fa fa-clone','utility:clone');
        SidebarSearchIconMaplwc.put('fa fa-close','utility:close');
        SidebarSearchIconMaplwc.put('fa fa-cloud-download','utility:download');
        SidebarSearchIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        SidebarSearchIconMaplwc.put('fa fa-comments','utility:chat');
        SidebarSearchIconMaplwc.put('fa fa-exchange','utility:exchange');
        SidebarSearchIconMaplwc.put('fa fa-external-link','utility:open');
        SidebarSearchIconMaplwc.put('fa fa-eye','utility:preview');
        SidebarSearchIconMaplwc.put('fa fa-file','utility:page');
        SidebarSearchIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        SidebarSearchIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        SidebarSearchIconMaplwc.put('fa fa-file-text','utility:file');
        SidebarSearchIconMaplwc.put('fa fa-gavel','utility:thunder');
        SidebarSearchIconMaplwc.put('fa fa-level-up','utility:up');
        SidebarSearchIconMaplwc.put('fa fa-money','utility:currency');
        SidebarSearchIconMaplwc.put('fa fa-play','utility:play');
        SidebarSearchIconMaplwc.put('fa fa-plus-circle','utility:add');
        SidebarSearchIconMaplwc.put('fa fa-reply','utility:back');
        SidebarSearchIconMaplwc.put('fa fa-share','utility:share');
        SidebarSearchIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        SidebarSearchIconMaplwc.put('fa fa-sign-in','utility:login');
        SidebarSearchIconMaplwc.put('fa fa-sign-out','utility:logout');
        SidebarSearchIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        SidebarSearchIconMaplwc.put('fa fa-sticky-note','utility:note');
        SidebarSearchIconMaplwc.put('fa fa-stop','utility:stop');
        SidebarSearchIconMaplwc.put('fa fa-tags','utility:tags');
        SidebarSearchIconMaplwc.put('fa fa-times','utility:close');
        SidebarSearchIconMaplwc.put('fa fa-trash','utility:delete');
        SidebarSearchIconMaplwc.put('fa fa-trophy','custom:custom48');
        SidebarSearchIconMaplwc.put('fa fa-undo','utility:undo');
        SidebarSearchIconMaplwc.put('fa fa-unlock','utility:unlock');
        SidebarSearchIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        SidebarSearchIconMaplwc.put('fa fa-history','utility:skip_back');
        SidebarSearchIconMaplwc.put('fa fa-table','utility:table');
        SidebarSearchIconMaplwc.put('fa fa-coffee','utility:coffee');
        SidebarSearchIconMaplwc.put('fa fa-cubes','utility:cubes');
        SidebarSearchIconMaplwc.put('fa fa-star','utility:favorite');
        SidebarSearchIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        SidebarSearchIconMaplwc.put('fa fa-line-SidebarSearch','utility:graph');
        SidebarSearchIconMaplwc.put('fa fa-comment','utility:comments');
        SidebarSearchIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        SidebarSearchIconMaplwc.put('fa fa-wrench','utility:settings');
        SidebarSearchIconMaplwc.put('fa fa-share-square-o','utility:share');
        SidebarSearchIconMaplwc.put('fa fa-bolt','utility:lightning');
        SidebarSearchIconMaplwc.put('fa fa-trash-o','utility:delete');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        SidebarSearchIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        SidebarSearchIconMaplwc.put('fa fa-wechat','utility:chat');
        SidebarSearchIconMaplwc.put('fa fa-paperclip','utility:attach');
        SidebarSearchIconMaplwc.put('fa fa-usd','utility:moneybag');
        SidebarSearchIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        SidebarSearchIconMaplwc.put('fa fa-folder','utility:open_folder');
        SidebarSearchIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        SidebarSearchIconMaplwc.put('fa fa-play','utility:play');
        SidebarSearchIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        SidebarSearchIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        SidebarSearchIconMaplwc.put('fa fa-male','utility:user');
    
        return SidebarSearchIconMaplwc;
    }
    
    @RemoteAction
    global static  Map<String,Object> getTypeAheadRecords (String searchTerm,String objectName) {
        return null; 
    }   
        
}