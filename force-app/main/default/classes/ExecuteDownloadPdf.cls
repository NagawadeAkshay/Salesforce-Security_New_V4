global with sharing class ExecuteDownloadPdf extends FlexTableActionHandler{
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
        fileType = 'PDF';
        tableName =dataTableConfigName;
        Map<String, Object> resultMap =  new Map<String, Object>();
        DownloadCSVBatch bt = new DownloadCSVBatch(parentRecordId,fileType,userEmailId,tableName,urlParams,urlParamsMap);
        database.executebatch(bt,200);       
        resultMap.put('Message', 'You will receive an email within 30 minutes. If you haven\'t received any response, please contact your system administrator.');
        return resultMap;
    }

    public static Map<String, String> getDownloadPdfIcon(){

        map<string,string> DownloadPdfIconMap = new map<string,string>();
        DownloadPdfIconMap.put('fa fa-pencil','utility:edit');
        DownloadPdfIconMap.put('fa fa-arrow','utility:right');
        DownloadPdfIconMap.put('fa fa-ban','utility:close');
        DownloadPdfIconMap.put('fa fa-bolt','utility:thunder');
        DownloadPdfIconMap.put('fa fa-check','utility:success'); 
        DownloadPdfIconMap.put('fa fa-clone','utility:clone');
        DownloadPdfIconMap.put('fa fa-close','utility:close');
        DownloadPdfIconMap.put('fa fa-cloud-download','utility:download');
        DownloadPdfIconMap.put('fa fa-cloud-upload','utility:upload');
        DownloadPdfIconMap.put('fa fa-comments','utility:chat');
        DownloadPdfIconMap.put('fa fa-exchange','utility:exchange');
        DownloadPdfIconMap.put('fa fa-external-link','utility:open');
        DownloadPdfIconMap.put('fa fa-eye','utility:preview');
        DownloadPdfIconMap.put('fa fa-file','utility:page');
        DownloadPdfIconMap.put('fa fa-file-pdf','utility:file_pdf');
        DownloadPdfIconMap.put('fa fa-file-text','utility:file');
        DownloadPdfIconMap.put('fa fa-gavel','utility:thunder');
        DownloadPdfIconMap.put('fa fa-level-up','utility:up');
        DownloadPdfIconMap.put('fa fa-money','utility:currency');
        DownloadPdfIconMap.put('fa fa-play','utility:play');
        DownloadPdfIconMap.put('fa fa-plus-circle','utility:add');
        DownloadPdfIconMap.put('fa fa-reply','utility:back');
        DownloadPdfIconMap.put('fa fa-share','utility:share');
        DownloadPdfIconMap.put('fa fa-share-square-o','utility:share_post');
        DownloadPdfIconMap.put('fa fa-sign-in','utility:login');
        DownloadPdfIconMap.put('fa fa-sign-out','utility:logout');
        DownloadPdfIconMap.put('fa fa-sitemap','utility:hierarchy');
        DownloadPdfIconMap.put('fa fa-sticky-note','utility:note');
        DownloadPdfIconMap.put('fa fa-stop','utility:stop');
        DownloadPdfIconMap.put('fa fa-tags','utility:tags');
        DownloadPdfIconMap.put('fa fa-times','utility:close');
        DownloadPdfIconMap.put('fa fa-trash','utility:delete');
        DownloadPdfIconMap.put('fa fa-trophy','custom:custom48');
        DownloadPdfIconMap.put('fa fa-undo','utility:undo');
        DownloadPdfIconMap.put('fa fa-unlock','utility:unlock');
        DownloadPdfIconMap.put('fa fa-paper-plane-o','utility:send');
        DownloadPdfIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        DownloadPdfIconMap.put('glyphicon glyphicon-remove','utility:close');
        DownloadPdfIconMap.put('glyphicon glyphicon-send','utility:send');
        DownloadPdfIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        DownloadPdfIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        DownloadPdfIconMap.put('glyphicon glyphicon-trash','utility:delete');
        DownloadPdfIconMap.put('fa fa-history','utility:skip_back');
        DownloadPdfIconMap.put('fa fa-table','utility:table');
        DownloadPdfIconMap.put('fa fa-coffee','utility:coffee');
        DownloadPdfIconMap.put('fa fa-cubes','utility:cubes');
        DownloadPdfIconMap.put('fa fa-star','utility:favorite');
        DownloadPdfIconMap.put('fa fa-exclamation-triangle','utility:warning');
        DownloadPdfIconMap.put('fa fa-line-DownloadPdf','utility:lineDownloadPdf');
        DownloadPdfIconMap.put('fa fa-comment','utility:comments');
        DownloadPdfIconMap.put('fa fa-caret-square-o-down','utility:down');
        DownloadPdfIconMap.put('fa fa-wrench','utility:settings');
        DownloadPdfIconMap.put('fa fa-share-square-o','utility:share');
        DownloadPdfIconMap.put('fa fa-bolt','utility:lightning');
        DownloadPdfIconMap.put('fa fa-trash-o','utility:delete');
        DownloadPdfIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        DownloadPdfIconMap.put('fa fa-file-text-o','utility:contract_doc');
        DownloadPdfIconMap.put('fa fa-wechat','utility:chat');
        DownloadPdfIconMap.put('fa fa-paperclip','utility:attach');
        DownloadPdfIconMap.put('fa fa-usd','utility:moneybag');
        DownloadPdfIconMap.put('glyphicon glyphicon-tasks','utility:task');
        DownloadPdfIconMap.put('fa fa-folder','utility:open_folder');
        DownloadPdfIconMap.put('fa fa-paper-plane-o','utility:send');
        DownloadPdfIconMap.put('fa fa-play','utility:play');
    
        return DownloadPdfIconMap;
    }
    
    public static Map<String, String> getDownloadPdfIconLwc(){
    
        map<string,string> DownloadPdfIconMaplwc = new map<string,string>();
        DownloadPdfIconMaplwc.put('fa fa-pencil','utility:edit');
        DownloadPdfIconMaplwc.put('fa fa-arrow','utility:right');
        DownloadPdfIconMaplwc.put('fa fa-ban','utility:error');
        DownloadPdfIconMaplwc.put('fa fa-bolt','utility:thunder');
        DownloadPdfIconMaplwc.put('fa fa-check','utility:success'); 
        DownloadPdfIconMaplwc.put('fa fa-clone','utility:clone');
        DownloadPdfIconMaplwc.put('fa fa-close','utility:close');
        DownloadPdfIconMaplwc.put('fa fa-cloud-download','utility:download');
        DownloadPdfIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        DownloadPdfIconMaplwc.put('fa fa-comments','utility:chat');
        DownloadPdfIconMaplwc.put('fa fa-exchange','utility:exchange');
        DownloadPdfIconMaplwc.put('fa fa-external-link','utility:open');
        DownloadPdfIconMaplwc.put('fa fa-eye','utility:preview');
        DownloadPdfIconMaplwc.put('fa fa-file','utility:page');
        DownloadPdfIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        DownloadPdfIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        DownloadPdfIconMaplwc.put('fa fa-file-text','utility:file');
        DownloadPdfIconMaplwc.put('fa fa-gavel','utility:thunder');
        DownloadPdfIconMaplwc.put('fa fa-level-up','utility:up');
        DownloadPdfIconMaplwc.put('fa fa-money','utility:currency');
        DownloadPdfIconMaplwc.put('fa fa-play','utility:play');
        DownloadPdfIconMaplwc.put('fa fa-plus-circle','utility:add');
        DownloadPdfIconMaplwc.put('fa fa-reply','utility:back');
        DownloadPdfIconMaplwc.put('fa fa-share','utility:share');
        DownloadPdfIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        DownloadPdfIconMaplwc.put('fa fa-sign-in','utility:login');
        DownloadPdfIconMaplwc.put('fa fa-sign-out','utility:logout');
        DownloadPdfIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        DownloadPdfIconMaplwc.put('fa fa-sticky-note','utility:note');
        DownloadPdfIconMaplwc.put('fa fa-stop','utility:stop');
        DownloadPdfIconMaplwc.put('fa fa-tags','utility:tags');
        DownloadPdfIconMaplwc.put('fa fa-times','utility:close');
        DownloadPdfIconMaplwc.put('fa fa-trash','utility:delete');
        DownloadPdfIconMaplwc.put('fa fa-trophy','custom:custom48');
        DownloadPdfIconMaplwc.put('fa fa-undo','utility:undo');
        DownloadPdfIconMaplwc.put('fa fa-unlock','utility:unlock');
        DownloadPdfIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        DownloadPdfIconMaplwc.put('fa fa-history','utility:skip_back');
        DownloadPdfIconMaplwc.put('fa fa-table','utility:table');
        DownloadPdfIconMaplwc.put('fa fa-coffee','utility:coffee');
        DownloadPdfIconMaplwc.put('fa fa-cubes','utility:cubes');
        DownloadPdfIconMaplwc.put('fa fa-star','utility:favorite');
        DownloadPdfIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        DownloadPdfIconMaplwc.put('fa fa-line-DownloadPdf','utility:graph');
        DownloadPdfIconMaplwc.put('fa fa-comment','utility:comments');
        DownloadPdfIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        DownloadPdfIconMaplwc.put('fa fa-wrench','utility:settings');
        DownloadPdfIconMaplwc.put('fa fa-share-square-o','utility:share');
        DownloadPdfIconMaplwc.put('fa fa-bolt','utility:lightning');
        DownloadPdfIconMaplwc.put('fa fa-trash-o','utility:delete');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        DownloadPdfIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        DownloadPdfIconMaplwc.put('fa fa-wechat','utility:chat');
        DownloadPdfIconMaplwc.put('fa fa-paperclip','utility:attach');
        DownloadPdfIconMaplwc.put('fa fa-usd','utility:moneybag');
        DownloadPdfIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        //DownloadPdfIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
        DownloadPdfIconMaplwc.put('fa fa-folder','utility:open_folder');
        DownloadPdfIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        DownloadPdfIconMaplwc.put('fa fa-play','utility:play');
        DownloadPdfIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        DownloadPdfIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        DownloadPdfIconMaplwc.put('fa fa-male','utility:user');
    
        return DownloadPdfIconMaplwc;
    }
}