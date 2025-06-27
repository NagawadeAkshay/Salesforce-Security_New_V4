global with sharing class ReportCtrl{
    
    //Properties
    global String flexTableParameters {get;set;}
    global String DivisionName{get;set;}
    global String flexTableName{get;set;}
    global Boolean renderFielter{get;set;}
     
    // swati - 10/20/2015  added a method to get the namespace prefix
    global String getNamespace() {
        return AppUtils.getNameSpacePrefix();
    }
    
    global ReportCtrl(){
    	  
    }
    
    // swati - 10/20/2015  method to populate the phases in the drop down
	//Modified by Prajakta
     global static Map<String, Object> initPhases(){
        return new Map<String, Object>();
    }
    
     @RemoteAction
    global static Map<String, Object> initPhases(String reportApps){
        return new Map<String, Object>();
    }
   
    
     /* This method is used to filter reports on applying the phase filter */
     global void getReportsPerPhase(){
        
    }
    
    global string getListParameters(){ 
        Map<String,Set<String>> listParams = new Map<String,Set<String>>();
        return JSON.serialize(listParams);
    }

    public static Map<String, String> getReportIcon(){
        map<string,string> ReportIconMap = new map<string,string>();
        ReportIconMap.put('fa fa-pencil','utility:edit');
        ReportIconMap.put('fa fa-arrow','utility:right');
        ReportIconMap.put('fa fa-ban','utility:close');
        ReportIconMap.put('fa fa-bolt','utility:thunder');
        ReportIconMap.put('fa fa-check','utility:success'); 
        ReportIconMap.put('fa fa-clone','utility:clone');
        ReportIconMap.put('fa fa-close','utility:close');
        ReportIconMap.put('fa fa-cloud-download','utility:download');
        ReportIconMap.put('fa fa-cloud-upload','utility:upload');
        ReportIconMap.put('fa fa-comments','utility:chat');
        ReportIconMap.put('fa fa-exchange','utility:exchange');
        ReportIconMap.put('fa fa-external-link','utility:open');
        ReportIconMap.put('fa fa-eye','utility:preview');
        ReportIconMap.put('fa fa-file','utility:page');
        ReportIconMap.put('fa fa-file-pdf','utility:file_pdf');
        ReportIconMap.put('fa fa-file-text','utility:file');
        ReportIconMap.put('fa fa-gavel','utility:thunder');
        ReportIconMap.put('fa fa-level-up','utility:up');
        ReportIconMap.put('fa fa-money','utility:currency');
        ReportIconMap.put('fa fa-play','utility:play');
        ReportIconMap.put('fa fa-plus-circle','utility:add');
        ReportIconMap.put('fa fa-reply','utility:back');
        ReportIconMap.put('fa fa-share','utility:share');
        ReportIconMap.put('fa fa-share-square-o','utility:share_post');
        ReportIconMap.put('fa fa-sign-in','utility:login');
        ReportIconMap.put('fa fa-sign-out','utility:logout');
        ReportIconMap.put('fa fa-sitemap','utility:hierarchy');
        ReportIconMap.put('fa fa-sticky-note','utility:note');
        ReportIconMap.put('fa fa-stop','utility:stop');
        ReportIconMap.put('fa fa-tags','utility:tags');
        ReportIconMap.put('fa fa-times','utility:close');
        ReportIconMap.put('fa fa-trash','utility:delete');
        ReportIconMap.put('fa fa-trophy','custom:custom48');
        ReportIconMap.put('fa fa-undo','utility:undo');
        ReportIconMap.put('fa fa-unlock','utility:unlock');
        ReportIconMap.put('fa fa-paper-plane-o','utility:send');
        ReportIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        ReportIconMap.put('glyphicon glyphicon-remove','utility:close');
        ReportIconMap.put('glyphicon glyphicon-send','utility:send');
        ReportIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        ReportIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        ReportIconMap.put('glyphicon glyphicon-trash','utility:delete');
        ReportIconMap.put('fa fa-history','utility:skip_back');
        ReportIconMap.put('fa fa-table','utility:table');
        ReportIconMap.put('fa fa-coffee','utility:coffee');
        ReportIconMap.put('fa fa-cubes','utility:cubes');
        ReportIconMap.put('fa fa-star','utility:favorite');
        ReportIconMap.put('fa fa-exclamation-triangle','utility:warning');
        ReportIconMap.put('fa fa-line-chart','utility:lineChart');
        ReportIconMap.put('fa fa-comment','utility:comments');
        ReportIconMap.put('fa fa-caret-square-o-down','utility:down');
        ReportIconMap.put('fa fa-wrench','utility:settings');
        ReportIconMap.put('fa fa-share-square-o','utility:share');
        ReportIconMap.put('fa fa-bolt','utility:lightning');
        ReportIconMap.put('fa fa-trash-o','utility:delete');
        ReportIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        ReportIconMap.put('fa fa-file-text-o','utility:contract_doc');
        ReportIconMap.put('fa fa-wechat','utility:chat');
        ReportIconMap.put('fa fa-paperclip','utility:attach');
        ReportIconMap.put('fa fa-usd','utility:moneybag');
        ReportIconMap.put('glyphicon glyphicon-tasks','utility:task');
        //ReportIconMap.put('fa fa-trophy','utility:funding_award_adjustment');
        ReportIconMap.put('fa fa-folder','utility:open_folder');
        ReportIconMap.put('fa fa-paper-plane-o','utility:send');
        ReportIconMap.put('fa fa-play','utility:play');
    
        return ReportIconMap;
    }
    
    public static Map<String, String> getReportIconLwc(){ 
        map<string,string> ReportIconMaplwc = new map<string,string>();
        ReportIconMaplwc.put('fa fa-pencil','utility:edit');
        ReportIconMaplwc.put('fa fa-arrow','utility:right');
        ReportIconMaplwc.put('fa fa-ban','utility:error');
        ReportIconMaplwc.put('fa fa-bolt','utility:thunder');
        ReportIconMaplwc.put('fa fa-check','utility:success'); 
        ReportIconMaplwc.put('fa fa-clone','utility:clone');
        ReportIconMaplwc.put('fa fa-close','utility:close');
        ReportIconMaplwc.put('fa fa-cloud-download','utility:download');
        ReportIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        ReportIconMaplwc.put('fa fa-comments','utility:chat');
        ReportIconMaplwc.put('fa fa-exchange','utility:exchange');
        ReportIconMaplwc.put('fa fa-external-link','utility:open');
        ReportIconMaplwc.put('fa fa-eye','utility:preview');
        ReportIconMaplwc.put('fa fa-file','utility:page');
        ReportIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        ReportIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        ReportIconMaplwc.put('fa fa-file-text','utility:file');
        ReportIconMaplwc.put('fa fa-gavel','utility:thunder');
        ReportIconMaplwc.put('fa fa-level-up','utility:up');
        ReportIconMaplwc.put('fa fa-money','utility:currency');
        ReportIconMaplwc.put('fa fa-play','utility:play');
        ReportIconMaplwc.put('fa fa-plus-circle','utility:add');
        ReportIconMaplwc.put('fa fa-reply','utility:back');
        ReportIconMaplwc.put('fa fa-share','utility:share');
        ReportIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        ReportIconMaplwc.put('fa fa-sign-in','utility:login');
        ReportIconMaplwc.put('fa fa-sign-out','utility:logout');
        ReportIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        ReportIconMaplwc.put('fa fa-sticky-note','utility:note');
        ReportIconMaplwc.put('fa fa-stop','utility:stop');
        ReportIconMaplwc.put('fa fa-tags','utility:tags');
        ReportIconMaplwc.put('fa fa-times','utility:close');
        ReportIconMaplwc.put('fa fa-trash','utility:delete');
        ReportIconMaplwc.put('fa fa-trophy','custom:custom48');
        ReportIconMaplwc.put('fa fa-undo','utility:undo');
        ReportIconMaplwc.put('fa fa-unlock','utility:unlock');
        ReportIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        ReportIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        ReportIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        ReportIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        ReportIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        ReportIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        ReportIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        ReportIconMaplwc.put('fa fa-history','utility:skip_back');
        ReportIconMaplwc.put('fa fa-table','utility:table');
        ReportIconMaplwc.put('fa fa-coffee','utility:coffee');
        ReportIconMaplwc.put('fa fa-cubes','utility:cubes');
        ReportIconMaplwc.put('fa fa-star','utility:favorite');
        ReportIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        ReportIconMaplwc.put('fa fa-line-chart','utility:graph');
        ReportIconMaplwc.put('fa fa-comment','utility:comments');
        ReportIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        ReportIconMaplwc.put('fa fa-wrench','utility:settings');
        ReportIconMaplwc.put('fa fa-share-square-o','utility:share');
        ReportIconMaplwc.put('fa fa-bolt','utility:lightning');
        ReportIconMaplwc.put('fa fa-trash-o','utility:delete');
        ReportIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        ReportIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        ReportIconMaplwc.put('fa fa-wechat','utility:chat');
        ReportIconMaplwc.put('fa fa-paperclip','utility:attach');
        ReportIconMaplwc.put('fa fa-usd','utility:moneybag');
        ReportIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        //ReportIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
        ReportIconMaplwc.put('fa fa-folder','utility:open_folder');
        ReportIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        ReportIconMaplwc.put('fa fa-play','utility:play');
        ReportIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        ReportIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        ReportIconMaplwc.put('fa fa-male','utility:user');
    
        return ReportIconMaplwc;
    }
        
                
    
    @RemoteAction
    global static  Map<String,Object> GetFiscalYearValues () {
        Map<String,Object>mapResult = new Map<String,Object>();
        mapResult.put('FiscalYearValues',AppUtils.getFiscalYearPickListValues());
        mapResult.put('currentFiscalYear',AppUtils.getCurrentFiscalYear());
        return mapResult;
    }
    
    @RemoteAction
    global static  Map<String,Object> getTypeAheadRecords (String searchTerm,String objectName, String FieldName, Boolean stdObject) {
        Map<String,Object>mapResult = new Map<String,Object>();
        return mapResult;
    }  
      
}