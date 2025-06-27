/** Tejashree 27th April 23 I have verified this functionality is not working so discussed with nakul 
 * and commenting out. As discussed if required product / project team will implement this at their end 
 */
global with sharing class PDFGeneratorCtrl {
	public Integer iTextPollCounter {get;set;}
    public static String endpointURL;
    public String govGrantPleaseWaitIconURL {
        get{

            //User Story 71061: Internal - Remove document object dependency and move to static resource
            govGrantPleaseWaitIconURL = AppUtils.getIcons('govGrantPleaseWaitIcon');
            return govGrantPleaseWaitIconURL;

        }
        set;
    }
	
	public PDFGeneratorCtrl(){
	}
    @RemoteAction
    global static Map<String,Object> generatePDF(Map<String,String> paramsMap){
        return null;
    } 
    public static void getLatestPDFFromAWSLambda(Map<String,Object> retVal,Map<String,String> paramsMap){
    }
    @RemoteAction
    global static Map<String,Object> pollForAttachment(Map<String,String> paramsMap){
    return null;
    }

    public static Map<String, String> getPDFGeneratorIcon(){

        map<string,string> PDFGeneratorIconMap = new map<string,string>();
        PDFGeneratorIconMap.put('fa fa-pencil','utility:edit');
        PDFGeneratorIconMap.put('fa fa-arrow','utility:right');
        PDFGeneratorIconMap.put('fa fa-ban','utility:close');
        PDFGeneratorIconMap.put('fa fa-bolt','utility:thunder');
        PDFGeneratorIconMap.put('fa fa-check','utility:success'); 
        PDFGeneratorIconMap.put('fa fa-clone','utility:clone');
        PDFGeneratorIconMap.put('fa fa-close','utility:close');
        PDFGeneratorIconMap.put('fa fa-cloud-download','utility:download');
        PDFGeneratorIconMap.put('fa fa-cloud-upload','utility:upload');
        PDFGeneratorIconMap.put('fa fa-comments','utility:chat');
        PDFGeneratorIconMap.put('fa fa-exchange','utility:exchange');
        PDFGeneratorIconMap.put('fa fa-external-link','utility:open');
        PDFGeneratorIconMap.put('fa fa-eye','utility:preview');
        PDFGeneratorIconMap.put('fa fa-file','utility:page');
        PDFGeneratorIconMap.put('fa fa-file-pdf','utility:file_pdf');
        PDFGeneratorIconMap.put('fa fa-file-text','utility:file');
        PDFGeneratorIconMap.put('fa fa-gavel','utility:thunder');
        PDFGeneratorIconMap.put('fa fa-level-up','utility:up');
        PDFGeneratorIconMap.put('fa fa-money','utility:currency');
        PDFGeneratorIconMap.put('fa fa-play','utility:play');
        PDFGeneratorIconMap.put('fa fa-plus-circle','utility:add');
        PDFGeneratorIconMap.put('fa fa-reply','utility:back');
        PDFGeneratorIconMap.put('fa fa-share','utility:share');
        PDFGeneratorIconMap.put('fa fa-share-square-o','utility:share_post');
        PDFGeneratorIconMap.put('fa fa-sign-in','utility:login');
        PDFGeneratorIconMap.put('fa fa-sign-out','utility:logout');
        PDFGeneratorIconMap.put('fa fa-sitemap','utility:hierarchy');
        PDFGeneratorIconMap.put('fa fa-sticky-note','utility:note');
        PDFGeneratorIconMap.put('fa fa-stop','utility:stop');
        PDFGeneratorIconMap.put('fa fa-tags','utility:tags');
        PDFGeneratorIconMap.put('fa fa-times','utility:close');
        PDFGeneratorIconMap.put('fa fa-trash','utility:delete');
        PDFGeneratorIconMap.put('fa fa-trophy','custom:custom48');
        PDFGeneratorIconMap.put('fa fa-undo','utility:undo');
        PDFGeneratorIconMap.put('fa fa-unlock','utility:unlock');
        PDFGeneratorIconMap.put('fa fa-paper-plane-o','utility:send');
        PDFGeneratorIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        PDFGeneratorIconMap.put('glyphicon glyphicon-remove','utility:close');
        PDFGeneratorIconMap.put('glyphicon glyphicon-send','utility:send');
        PDFGeneratorIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        PDFGeneratorIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        PDFGeneratorIconMap.put('glyphicon glyphicon-trash','utility:delete');
        PDFGeneratorIconMap.put('fa fa-history','utility:skip_back');
        PDFGeneratorIconMap.put('fa fa-table','utility:table');
        PDFGeneratorIconMap.put('fa fa-coffee','utility:coffee');
        PDFGeneratorIconMap.put('fa fa-cubes','utility:cubes');
        PDFGeneratorIconMap.put('fa fa-star','utility:favorite');
        PDFGeneratorIconMap.put('fa fa-exclamation-triangle','utility:warning');
        PDFGeneratorIconMap.put('fa fa-line-PDFGenerator','utility:linePDFGenerator');
        PDFGeneratorIconMap.put('fa fa-comment','utility:comments');
        PDFGeneratorIconMap.put('fa fa-caret-square-o-down','utility:down');
        PDFGeneratorIconMap.put('fa fa-wrench','utility:settings');
        PDFGeneratorIconMap.put('fa fa-share-square-o','utility:share');
        PDFGeneratorIconMap.put('fa fa-bolt','utility:lightning');
        PDFGeneratorIconMap.put('fa fa-trash-o','utility:delete');
        PDFGeneratorIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        PDFGeneratorIconMap.put('fa fa-file-text-o','utility:contract_doc');
        PDFGeneratorIconMap.put('fa fa-wechat','utility:chat');
        PDFGeneratorIconMap.put('fa fa-paperclip','utility:attach');
        PDFGeneratorIconMap.put('fa fa-usd','utility:moneybag');
        PDFGeneratorIconMap.put('glyphicon glyphicon-tasks','utility:task');
        //PDFGeneratorIconMap.put('fa fa-trophy','utility:funding_award_adjustment');
        PDFGeneratorIconMap.put('fa fa-folder','utility:open_folder');
        PDFGeneratorIconMap.put('fa fa-paper-plane-o','utility:send');
        PDFGeneratorIconMap.put('fa fa-play','utility:play');
    
        return PDFGeneratorIconMap;
    }
    
    public static Map<String, String> getPDFGeneratorIconLwc(){
    
        map<string,string> PDFGeneratorIconMaplwc = new map<string,string>();
        PDFGeneratorIconMaplwc.put('fa fa-pencil','utility:edit');
        PDFGeneratorIconMaplwc.put('fa fa-arrow','utility:right');
        PDFGeneratorIconMaplwc.put('fa fa-ban','utility:error');
        PDFGeneratorIconMaplwc.put('fa fa-bolt','utility:thunder');
        PDFGeneratorIconMaplwc.put('fa fa-check','utility:success'); 
        PDFGeneratorIconMaplwc.put('fa fa-clone','utility:clone');
        PDFGeneratorIconMaplwc.put('fa fa-close','utility:close');
        PDFGeneratorIconMaplwc.put('fa fa-cloud-download','utility:download');
        PDFGeneratorIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        PDFGeneratorIconMaplwc.put('fa fa-comments','utility:chat');
        PDFGeneratorIconMaplwc.put('fa fa-exchange','utility:exchange');
        PDFGeneratorIconMaplwc.put('fa fa-external-link','utility:open');
        PDFGeneratorIconMaplwc.put('fa fa-eye','utility:preview');
        PDFGeneratorIconMaplwc.put('fa fa-file','utility:page');
        PDFGeneratorIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        PDFGeneratorIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        PDFGeneratorIconMaplwc.put('fa fa-file-text','utility:file');
        PDFGeneratorIconMaplwc.put('fa fa-gavel','utility:thunder');
        PDFGeneratorIconMaplwc.put('fa fa-level-up','utility:up');
        PDFGeneratorIconMaplwc.put('fa fa-money','utility:currency');
        PDFGeneratorIconMaplwc.put('fa fa-play','utility:play');
        PDFGeneratorIconMaplwc.put('fa fa-plus-circle','utility:add');
        PDFGeneratorIconMaplwc.put('fa fa-reply','utility:back');
        PDFGeneratorIconMaplwc.put('fa fa-share','utility:share');
        PDFGeneratorIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        PDFGeneratorIconMaplwc.put('fa fa-sign-in','utility:login');
        PDFGeneratorIconMaplwc.put('fa fa-sign-out','utility:logout');
        PDFGeneratorIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        PDFGeneratorIconMaplwc.put('fa fa-sticky-note','utility:note');
        PDFGeneratorIconMaplwc.put('fa fa-stop','utility:stop');
        PDFGeneratorIconMaplwc.put('fa fa-tags','utility:tags');
        PDFGeneratorIconMaplwc.put('fa fa-times','utility:close');
        PDFGeneratorIconMaplwc.put('fa fa-trash','utility:delete');
        PDFGeneratorIconMaplwc.put('fa fa-trophy','custom:custom48');
        PDFGeneratorIconMaplwc.put('fa fa-undo','utility:undo');
        PDFGeneratorIconMaplwc.put('fa fa-unlock','utility:unlock');
        PDFGeneratorIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        PDFGeneratorIconMaplwc.put('fa fa-history','utility:skip_back');
        PDFGeneratorIconMaplwc.put('fa fa-table','utility:table');
        PDFGeneratorIconMaplwc.put('fa fa-coffee','utility:coffee');
        PDFGeneratorIconMaplwc.put('fa fa-cubes','utility:cubes');
        PDFGeneratorIconMaplwc.put('fa fa-star','utility:favorite');
        PDFGeneratorIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        PDFGeneratorIconMaplwc.put('fa fa-line-PDFGenerator','utility:graph');
        PDFGeneratorIconMaplwc.put('fa fa-comment','utility:comments');
        PDFGeneratorIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        PDFGeneratorIconMaplwc.put('fa fa-wrench','utility:settings');
        PDFGeneratorIconMaplwc.put('fa fa-share-square-o','utility:share');
        PDFGeneratorIconMaplwc.put('fa fa-bolt','utility:lightning');
        PDFGeneratorIconMaplwc.put('fa fa-trash-o','utility:delete');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        PDFGeneratorIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        PDFGeneratorIconMaplwc.put('fa fa-wechat','utility:chat');
        PDFGeneratorIconMaplwc.put('fa fa-paperclip','utility:attach');
        PDFGeneratorIconMaplwc.put('fa fa-usd','utility:moneybag');
        PDFGeneratorIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        //PDFGeneratorIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
        PDFGeneratorIconMaplwc.put('fa fa-folder','utility:open_folder');
        PDFGeneratorIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        PDFGeneratorIconMaplwc.put('fa fa-play','utility:play');
        PDFGeneratorIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        PDFGeneratorIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        PDFGeneratorIconMaplwc.put('fa fa-male','utility:user');
    
        return PDFGeneratorIconMaplwc;
    }

}