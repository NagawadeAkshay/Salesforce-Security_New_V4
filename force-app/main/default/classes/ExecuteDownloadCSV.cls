global with sharing class ExecuteDownloadCSV extends FlexTableActionHandler{
    public String pathwayName;
    public String fileType;
    public String userEmailId;
    public String tableName;  
    global override Map<String, Object> clickHandler() { 
        userEmailId = UserInfo.getUserEmail();
        String parentRecordId = urlParams.get('RecordId');
        if(parentRecordId == null){
            parentRecordId = String.valueOf(urlParamsMap.get('RecordId'));
        }
        fileType = 'CSV';
        tableName =dataTableConfigName;
        Map<String, Object> resultMap =  new Map<String, Object>();
        DownloadCSVBatch bt = new DownloadCSVBatch(parentRecordId,fileType,userEmailId,tableName,urlParams,urlParamsMap);
        database.executebatch(bt,200);       
        resultMap.put('Message', 'You will receive an email within 30 minutes. If you haven\'t received any response, please contact your system administrator.');
        return resultMap;
    }

    public static Map<String, String> getDownloadCSVIcon(){

        map<string,string> DownloadCSVIconMap = new map<string,string>();
        DownloadCSVIconMap.put('fa fa-pencil','utility:edit');
        DownloadCSVIconMap.put('fa fa-arrow','utility:right');
        DownloadCSVIconMap.put('fa fa-ban','utility:close');
        DownloadCSVIconMap.put('fa fa-bolt','utility:thunder');
        DownloadCSVIconMap.put('fa fa-check','utility:success'); 
        DownloadCSVIconMap.put('fa fa-clone','utility:clone');
        DownloadCSVIconMap.put('fa fa-close','utility:close');
        DownloadCSVIconMap.put('fa fa-cloud-download','utility:download');
        DownloadCSVIconMap.put('fa fa-cloud-upload','utility:upload');
        DownloadCSVIconMap.put('fa fa-comments','utility:chat');
        DownloadCSVIconMap.put('fa fa-exchange','utility:exchange');
        DownloadCSVIconMap.put('fa fa-external-link','utility:open');
        DownloadCSVIconMap.put('fa fa-eye','utility:preview');
        DownloadCSVIconMap.put('fa fa-file','utility:page');
        DownloadCSVIconMap.put('fa fa-file-pdf','utility:file_pdf');
        DownloadCSVIconMap.put('fa fa-file-text','utility:file');
        DownloadCSVIconMap.put('fa fa-gavel','utility:thunder');
        DownloadCSVIconMap.put('fa fa-level-up','utility:up');
        DownloadCSVIconMap.put('fa fa-money','utility:currency');
        DownloadCSVIconMap.put('fa fa-play','utility:play');
        DownloadCSVIconMap.put('fa fa-plus-circle','utility:add');
        DownloadCSVIconMap.put('fa fa-reply','utility:back');
        DownloadCSVIconMap.put('fa fa-share','utility:share');
        DownloadCSVIconMap.put('fa fa-share-square-o','utility:share_post');
        DownloadCSVIconMap.put('fa fa-sign-in','utility:login');
        DownloadCSVIconMap.put('fa fa-sign-out','utility:logout');
        DownloadCSVIconMap.put('fa fa-sitemap','utility:hierarchy');
        DownloadCSVIconMap.put('fa fa-sticky-note','utility:note');
        DownloadCSVIconMap.put('fa fa-stop','utility:stop');
        DownloadCSVIconMap.put('fa fa-tags','utility:tags');
        DownloadCSVIconMap.put('fa fa-times','utility:close');
        DownloadCSVIconMap.put('fa fa-trash','utility:delete');
        DownloadCSVIconMap.put('fa fa-trophy','custom:custom48');
        DownloadCSVIconMap.put('fa fa-undo','utility:undo');
        DownloadCSVIconMap.put('fa fa-unlock','utility:unlock');
        DownloadCSVIconMap.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        DownloadCSVIconMap.put('glyphicon glyphicon-remove','utility:close');
        DownloadCSVIconMap.put('glyphicon glyphicon-send','utility:send');
        DownloadCSVIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        DownloadCSVIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        DownloadCSVIconMap.put('glyphicon glyphicon-trash','utility:delete');
        DownloadCSVIconMap.put('fa fa-history','utility:skip_back');
        DownloadCSVIconMap.put('fa fa-table','utility:table');
        DownloadCSVIconMap.put('fa fa-coffee','utility:coffee');
        DownloadCSVIconMap.put('fa fa-cubes','utility:cubes');
        DownloadCSVIconMap.put('fa fa-star','utility:favorite');
        DownloadCSVIconMap.put('fa fa-exclamation-triangle','utility:warning');
        DownloadCSVIconMap.put('fa fa-line-DownloadCSV','utility:lineDownloadCSV');
        DownloadCSVIconMap.put('fa fa-comment','utility:comments');
        DownloadCSVIconMap.put('fa fa-caret-square-o-down','utility:down');
        DownloadCSVIconMap.put('fa fa-wrench','utility:settings');
        DownloadCSVIconMap.put('fa fa-share-square-o','utility:share');
        DownloadCSVIconMap.put('fa fa-bolt','utility:lightning');
        DownloadCSVIconMap.put('fa fa-trash-o','utility:delete');
        DownloadCSVIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        DownloadCSVIconMap.put('fa fa-file-text-o','utility:contract_doc');
        DownloadCSVIconMap.put('fa fa-wechat','utility:chat');
        DownloadCSVIconMap.put('fa fa-paperclip','utility:attach');
        DownloadCSVIconMap.put('fa fa-usd','utility:moneybag');
        DownloadCSVIconMap.put('glyphicon glyphicon-tasks','utility:task');
        //DownloadCSVIconMap.put('fa fa-trophy','utility:funding_award_adjustment');
        DownloadCSVIconMap.put('fa fa-folder','utility:open_folder');
        DownloadCSVIconMap.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMap.put('fa fa-play','utility:play');
    
        return DownloadCSVIconMap;
    }
    
    public static Map<String, String> getDownloadCSVIconLwc(){
    
        map<string,string> DownloadCSVIconMaplwc = new map<string,string>();
        DownloadCSVIconMaplwc.put('fa fa-pencil','utility:edit');
        DownloadCSVIconMaplwc.put('fa fa-arrow','utility:right');
        DownloadCSVIconMaplwc.put('fa fa-ban','utility:error');
        DownloadCSVIconMaplwc.put('fa fa-bolt','utility:thunder');
        DownloadCSVIconMaplwc.put('fa fa-check','utility:success'); 
        DownloadCSVIconMaplwc.put('fa fa-clone','utility:clone');
        DownloadCSVIconMaplwc.put('fa fa-close','utility:close');
        DownloadCSVIconMaplwc.put('fa fa-cloud-download','utility:download');
        DownloadCSVIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        DownloadCSVIconMaplwc.put('fa fa-comments','utility:chat');
        DownloadCSVIconMaplwc.put('fa fa-exchange','utility:exchange');
        DownloadCSVIconMaplwc.put('fa fa-external-link','utility:open');
        DownloadCSVIconMaplwc.put('fa fa-eye','utility:preview');
        DownloadCSVIconMaplwc.put('fa fa-file','utility:page');
        DownloadCSVIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        DownloadCSVIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        DownloadCSVIconMaplwc.put('fa fa-file-text','utility:file');
        DownloadCSVIconMaplwc.put('fa fa-gavel','utility:thunder');
        DownloadCSVIconMaplwc.put('fa fa-level-up','utility:up');
        DownloadCSVIconMaplwc.put('fa fa-money','utility:currency');
        DownloadCSVIconMaplwc.put('fa fa-play','utility:play');
        DownloadCSVIconMaplwc.put('fa fa-plus-circle','utility:add');
        DownloadCSVIconMaplwc.put('fa fa-reply','utility:back');
        DownloadCSVIconMaplwc.put('fa fa-share','utility:share');
        DownloadCSVIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        DownloadCSVIconMaplwc.put('fa fa-sign-in','utility:login');
        DownloadCSVIconMaplwc.put('fa fa-sign-out','utility:logout');
        DownloadCSVIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        DownloadCSVIconMaplwc.put('fa fa-sticky-note','utility:note');
        DownloadCSVIconMaplwc.put('fa fa-stop','utility:stop');
        DownloadCSVIconMaplwc.put('fa fa-tags','utility:tags');
        DownloadCSVIconMaplwc.put('fa fa-times','utility:close');
        DownloadCSVIconMaplwc.put('fa fa-trash','utility:delete');
        DownloadCSVIconMaplwc.put('fa fa-trophy','custom:custom48');
        DownloadCSVIconMaplwc.put('fa fa-undo','utility:undo');
        DownloadCSVIconMaplwc.put('fa fa-unlock','utility:unlock');
        DownloadCSVIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        DownloadCSVIconMaplwc.put('fa fa-history','utility:skip_back');
        DownloadCSVIconMaplwc.put('fa fa-table','utility:table');
        DownloadCSVIconMaplwc.put('fa fa-coffee','utility:coffee');
        DownloadCSVIconMaplwc.put('fa fa-cubes','utility:cubes');
        DownloadCSVIconMaplwc.put('fa fa-star','utility:favorite');
        DownloadCSVIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        DownloadCSVIconMaplwc.put('fa fa-line-DownloadCSV','utility:graph');
        DownloadCSVIconMaplwc.put('fa fa-comment','utility:comments');
        DownloadCSVIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        DownloadCSVIconMaplwc.put('fa fa-wrench','utility:settings');
        DownloadCSVIconMaplwc.put('fa fa-share-square-o','utility:share');
        DownloadCSVIconMaplwc.put('fa fa-bolt','utility:lightning');
        DownloadCSVIconMaplwc.put('fa fa-trash-o','utility:delete');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        DownloadCSVIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        DownloadCSVIconMaplwc.put('fa fa-wechat','utility:chat');
        DownloadCSVIconMaplwc.put('fa fa-paperclip','utility:attach');
        DownloadCSVIconMaplwc.put('fa fa-usd','utility:moneybag');
        DownloadCSVIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        //DownloadCSVIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
        DownloadCSVIconMaplwc.put('fa fa-folder','utility:open_folder');
        DownloadCSVIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        DownloadCSVIconMaplwc.put('fa fa-play','utility:play');
        DownloadCSVIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        DownloadCSVIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        DownloadCSVIconMaplwc.put('fa fa-male','utility:user');
    
        return DownloadCSVIconMaplwc;
    }
}