global with sharing class CollabFilesCtrl {
   
    global CollabFilesCtrl(){
    }

    public Boolean publicFiles {get; set;}
    public String networkId {get; set;}
    public String identifier {get; set;}
    public String fileOwnerId {get; set;}

    @RemoteAction
    global static void uploadNewFeedContentVersionFile(String filesHiddenFile, String filesHiddenName, String filesHiddenText) {
    }

    @RemoteAction
    global static void uploadInternalFeedContentFile(String filesHiddenFile, String filesHiddenName, String filesHiddenText,String filesHiddenType) {

    }

    @RemoteAction
    global static void uploadExternalFeedContentFile(String filesHiddenFile, String filesHiddenName, String filesHiddenText,String filesHiddenType) {

    }

    @RemoteAction
    global static String editDesc(String id, String myDesc) {
        return 'failure';
    }

    @RemoteAction
    global static List<CollaborationGroup> getGroups(String accountId, String search, Boolean allowExternal, String networkId) {
        return new List<CollaborationGroup>();
    }

    @RemoteAction
    global static List<User> getUsers(String accountId, Boolean allowExternal, String name, String userId) {
        List<User>  usrRecord; 
        return usrRecord;
    }

    @RemoteAction
    global static void removeAccess(String userId, String linkedEntityId, String documentId) {
    }

    @RemoteAction
    global static void makeViewer(String userId, String linkedEntityId, String documentId) {
    }

    @RemoteAction
    global static void makeCollab(String userId, String linkedEntityId, String documentId) {
    }

    @RemoteAction
    global static void makePrivate(String id) {
    }

    @RemoteAction
    global static String addEntityLinks(String documentId, String entityIds, String shareTypes, String message) {
        return '';
    }

    @RemoteAction
    global static List<String> EntityLinks(String versionId) {
        List<String> result = new List<String>();
        return result;
    }

   @RemoteAction
    global static void deleteFile(String versionId) { 
    }

    @RemoteAction
    global static Boolean canUploadNewVersion(String documentId, String userId) {
        return false;
    }

    @RemoteAction
    global static Map<String, String> following() {
        Map<String, String> myFollowings = new Map<String, String>();
        return myFollowings;
    }

    @RemoteAction
    global static String follow(String id) {        
        ConnectApi.Subscription subscription = ConnectApi.ChatterUsers.follow(Network.getNetworkId(), 'me', id);        
        return subscription.id;
    }

    @RemoteAction 
    global static void unFollow(String id) {
    }

    public static Map<String, String> getCollabFilesFilesIcon(){

        map<string,string> CollabFilesIconMap = new map<string,string>();
        CollabFilesIconMap.put('fa fa-pencil','utility:edit');
        CollabFilesIconMap.put('fa fa-arrow','utility:right');
        CollabFilesIconMap.put('fa fa-ban','utility:close');
        CollabFilesIconMap.put('fa fa-bolt','utility:thunder');
        CollabFilesIconMap.put('fa fa-check','utility:success'); 
        CollabFilesIconMap.put('fa fa-clone','utility:clone');
        CollabFilesIconMap.put('fa fa-close','utility:close');
        CollabFilesIconMap.put('fa fa-cloud-download','utility:download');
        CollabFilesIconMap.put('fa fa-cloud-upload','utility:upload');
        CollabFilesIconMap.put('fa fa-comments','utility:chat');
        CollabFilesIconMap.put('fa fa-exchange','utility:exchange');
        CollabFilesIconMap.put('fa fa-external-link','utility:open');
        CollabFilesIconMap.put('fa fa-eye','utility:preview');
        CollabFilesIconMap.put('fa fa-file','utility:page');
        CollabFilesIconMap.put('fa fa-file-pdf','utility:file_pdf');
        CollabFilesIconMap.put('fa fa-file-text','utility:file');
        CollabFilesIconMap.put('fa fa-gavel','utility:thunder');
        CollabFilesIconMap.put('fa fa-level-up','utility:up');
        CollabFilesIconMap.put('fa fa-money','utility:currency');
        CollabFilesIconMap.put('fa fa-play','utility:play');
        CollabFilesIconMap.put('fa fa-plus-circle','utility:add');
        CollabFilesIconMap.put('fa fa-reply','utility:back');
        CollabFilesIconMap.put('fa fa-share','utility:share');
        CollabFilesIconMap.put('fa fa-share-square-o','utility:share_post');
        CollabFilesIconMap.put('fa fa-sign-in','utility:login');
        CollabFilesIconMap.put('fa fa-sign-out','utility:logout');
        CollabFilesIconMap.put('fa fa-sitemap','utility:hierarchy');
        CollabFilesIconMap.put('fa fa-sticky-note','utility:note');
        CollabFilesIconMap.put('fa fa-stop','utility:stop');
        CollabFilesIconMap.put('fa fa-tags','utility:tags');
        CollabFilesIconMap.put('fa fa-times','utility:close');
        CollabFilesIconMap.put('fa fa-trash','utility:delete');
        CollabFilesIconMap.put('fa fa-trophy','custom:custom48');
        CollabFilesIconMap.put('fa fa-undo','utility:undo');
        CollabFilesIconMap.put('fa fa-unlock','utility:unlock');
        CollabFilesIconMap.put('fa fa-paper-plane-o','utility:send');
        CollabFilesIconMap.put('glyphicon glyphicon-pencil','utility:edit');
        CollabFilesIconMap.put('glyphicon glyphicon-remove','utility:close');
        CollabFilesIconMap.put('glyphicon glyphicon-send','utility:send');
        CollabFilesIconMap.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        CollabFilesIconMap.put('glyphicon glyphicon-thumbs-up','utility:like');
        CollabFilesIconMap.put('glyphicon glyphicon-trash','utility:delete');
        CollabFilesIconMap.put('fa fa-history','utility:skip_back');
        CollabFilesIconMap.put('fa fa-table','utility:table');
        CollabFilesIconMap.put('fa fa-coffee','utility:coffee');
        CollabFilesIconMap.put('fa fa-cubes','utility:cubes');
        CollabFilesIconMap.put('fa fa-star','utility:favorite');
        CollabFilesIconMap.put('fa fa-exclamation-triangle','utility:warning');
        CollabFilesIconMap.put('fa fa-line-chart','utility:lineChart');
        CollabFilesIconMap.put('fa fa-comment','utility:comments');
        CollabFilesIconMap.put('fa fa-caret-square-o-down','utility:down');
        CollabFilesIconMap.put('fa fa-wrench','utility:settings');
        CollabFilesIconMap.put('fa fa-share-square-o','utility:share');
        CollabFilesIconMap.put('fa fa-bolt','utility:lightning');
        CollabFilesIconMap.put('fa fa-trash-o','utility:delete');
        CollabFilesIconMap.put('glyphicon glyphicon-book','utility:knowledge_base');
        CollabFilesIconMap.put('fa fa-file-text-o','utility:contract_doc');
        CollabFilesIconMap.put('fa fa-wechat','utility:chat');
        CollabFilesIconMap.put('fa fa-paperclip','utility:attach');
        CollabFilesIconMap.put('fa fa-usd','utility:moneybag');
        CollabFilesIconMap.put('glyphicon glyphicon-tasks','utility:task');
        //CollabFilesIconMap.put('fa fa-trophy','utility:funding_award_adjustment');
        CollabFilesIconMap.put('fa fa-folder','utility:open_folder');
        CollabFilesIconMap.put('fa fa-paper-plane-o','utility:send');
        CollabFilesIconMap.put('fa fa-play','utility:play');
    
        return CollabFilesIconMap;
    }
    
    public static Map<String, String> getCollabFilesIconLwc(){
    
        map<string,string> CollabFilesIconMaplwc = new map<string,string>();
        CollabFilesIconMaplwc.put('fa fa-pencil','utility:edit');
        CollabFilesIconMaplwc.put('fa fa-arrow','utility:right');
        CollabFilesIconMaplwc.put('fa fa-ban','utility:error');
        CollabFilesIconMaplwc.put('fa fa-bolt','utility:thunder');
        CollabFilesIconMaplwc.put('fa fa-check','utility:success'); 
        CollabFilesIconMaplwc.put('fa fa-clone','utility:clone');
        CollabFilesIconMaplwc.put('fa fa-close','utility:close');
        CollabFilesIconMaplwc.put('fa fa-cloud-download','utility:download');
        CollabFilesIconMaplwc.put('fa fa-cloud-upload','utility:upload');
        CollabFilesIconMaplwc.put('fa fa-comments','utility:chat');
        CollabFilesIconMaplwc.put('fa fa-exchange','utility:exchange');
        CollabFilesIconMaplwc.put('fa fa-external-link','utility:open');
        CollabFilesIconMaplwc.put('fa fa-eye','utility:preview');
        CollabFilesIconMaplwc.put('fa fa-file','utility:page');
        CollabFilesIconMaplwc.put('fa fa-file-pdf','utility:pdf_ext');
        CollabFilesIconMaplwc.put('fa fa-file-pdf-o','utility:pdf_ext');
        CollabFilesIconMaplwc.put('fa fa-file-text','utility:file');
        CollabFilesIconMaplwc.put('fa fa-gavel','utility:thunder');
        CollabFilesIconMaplwc.put('fa fa-level-up','utility:up');
        CollabFilesIconMaplwc.put('fa fa-money','utility:currency');
        CollabFilesIconMaplwc.put('fa fa-play','utility:play');
        CollabFilesIconMaplwc.put('fa fa-plus-circle','utility:add');
        CollabFilesIconMaplwc.put('fa fa-reply','utility:back');
        CollabFilesIconMaplwc.put('fa fa-share','utility:share');
        CollabFilesIconMaplwc.put('fa fa-share-square-o','utility:share_post');
        CollabFilesIconMaplwc.put('fa fa-sign-in','utility:login');
        CollabFilesIconMaplwc.put('fa fa-sign-out','utility:logout');
        CollabFilesIconMaplwc.put('fa fa-sitemap','utility:hierarchy');
        CollabFilesIconMaplwc.put('fa fa-sticky-note','utility:note');
        CollabFilesIconMaplwc.put('fa fa-stop','utility:stop');
        CollabFilesIconMaplwc.put('fa fa-tags','utility:tags');
        CollabFilesIconMaplwc.put('fa fa-times','utility:close');
        CollabFilesIconMaplwc.put('fa fa-trash','utility:delete');
        CollabFilesIconMaplwc.put('fa fa-trophy','custom:custom48');
        CollabFilesIconMaplwc.put('fa fa-undo','utility:undo');
        CollabFilesIconMaplwc.put('fa fa-unlock','utility:unlock');
        CollabFilesIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-pencil','utility:edit');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-remove','utility:close');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-send','utility:send');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-thumbs-down','utility:dislike');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-thumbs-up','utility:like');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-trash','utility:delete');
        CollabFilesIconMaplwc.put('fa fa-history','utility:skip_back');
        CollabFilesIconMaplwc.put('fa fa-table','utility:table');
        CollabFilesIconMaplwc.put('fa fa-coffee','utility:coffee');
        CollabFilesIconMaplwc.put('fa fa-cubes','utility:cubes');
        CollabFilesIconMaplwc.put('fa fa-star','utility:favorite');
        CollabFilesIconMaplwc.put('fa fa-exclamation-triangle','utility:warning');
        CollabFilesIconMaplwc.put('fa fa-line-chart','utility:graph');
        CollabFilesIconMaplwc.put('fa fa-comment','utility:comments');
        CollabFilesIconMaplwc.put('fa fa-caret-square-o-down','utility:down');
        CollabFilesIconMaplwc.put('fa fa-wrench','utility:settings');
        CollabFilesIconMaplwc.put('fa fa-share-square-o','utility:share');
        CollabFilesIconMaplwc.put('fa fa-bolt','utility:lightning');
        CollabFilesIconMaplwc.put('fa fa-trash-o','utility:delete');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-book','utility:knowledge_base');
        CollabFilesIconMaplwc.put('fa fa-file-text-o','utility:contract_doc');
        CollabFilesIconMaplwc.put('fa fa-wechat','utility:chat');
        CollabFilesIconMaplwc.put('fa fa-paperclip','utility:attach');
        CollabFilesIconMaplwc.put('fa fa-usd','utility:moneybag');
        CollabFilesIconMaplwc.put('glyphicon glyphicon-tasks','utility:task');
        //CollabFilesIconMaplwc.put('fa fa-trophy','utility:funding_award_adjustment');
        CollabFilesIconMaplwc.put('fa fa-folder','utility:open_folder');
        CollabFilesIconMaplwc.put('fa fa-paper-plane-o','utility:send');
        CollabFilesIconMaplwc.put('fa fa-play','utility:play');
        CollabFilesIconMaplwc.put('fa fa-folder-open-o','utility:opened_folder');
        CollabFilesIconMaplwc.put('fa fa-check-square-o','utility:multi_select_checkbox');
        CollabFilesIconMaplwc.put('fa fa-male','utility:user');
    
        return CollabFilesIconMaplwc;
    }
        
}