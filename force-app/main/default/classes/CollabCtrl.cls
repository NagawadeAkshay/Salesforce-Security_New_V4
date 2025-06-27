/**
* Getting a feed is simple. Use the getFeedItemsFromFeed static method to access pages of different feeds.
* Specify the feed type in the second parameter. The method also takes additional parameters such as a page number, page size, and sort order.
* If your organization uses Salesforce Communities, you can pass a Community ID as the first parameter.
* If not, or to target the internal community, pass null.
*
* The DemoController uses the FeedItemInfo view helper class we created earlier to format the Chatter data.
*
* CHANGE HISTORY
*==============================================================================================================================
* 06/29/2014                Kunal Shah              Created
* Ongoing                   William Moore           Modifying
* 8/1/2019                  Yogeshkumar Gaikwad     Added support for External user
*===============================================================================================================================
*/
global with sharing class CollabCtrl {

    global String themeDocURL {get; set;}
    global CollabCtrl(){}

    @RemoteAction
    static global List<List<String>> getGroupsList() {
        List<List<String>> options = new List<List<String>>();
        return options;
    }
    /*
        UI-Shrawan Raina : 10192015
        Added for CollabCount component
    */
    @RemoteAction
    global static Map<String, Integer> getCollabCount(boolean communityChk, String accountId){
        Map<String, Integer> countMap = new Map<String, Integer>();
        return countMap;
    }

    @RemoteAction
    static global List<List<String>> getOrganizationGroupsList() {
        List<List<String>> options = new List<List<String>>();
        return options;
    }

    @RemoteAction
    global static String postCommentWithFileViaRemoting(Map<String,Object> parametersMap) {
        return '';
    }
    @RemoteAction
    global static List<String> EntityLinks(String versionId) {// Dk : Spring Cleanup 7-4-16
        return null;
    }

    @RemoteAction
    global static Boolean canUpload(String documentId, String userId) {
        return false;
    }
    @RemoteAction
    global static List<User> getCommunityUsers(Boolean searching, String text) {
        return null;
    }
    @RemoteAction
    global static void joinGroup(String userId, String newId) {
    }
    @RemoteAction
    global static ConnectApi.GroupMembershipRequest requestGroupMembership(String community, String id){
        ConnectApi.GroupMembershipRequest result;
        return result;
    }
    @RemoteAction
    global static  Map<string,object> processGroupMembershipRequest(Map<String,Object> parametersMap){
        Map<string,object> resultMap = new Map<string,object>();
        return resultMap;
    }
    @RemoteAction
    global static void deleteGroupMember(String community, String id, String groupId){
    }
    @RemoteAction
    global static String getFullPhotoUrl(String newId) { // Dk : Spring Cleanup 7-4-16
        //return 'deprecated';
        return null;
    }
    @RemoteAction
    global static CollaborationGroup createGroup(Boolean isExternal,
                                                String community,
                                                Boolean canHaveChatterGuests,
                                                String name,
                                                String description,
                                                Boolean isAutoArchiveDisabled,
                                                String visibility) {
        return null;
    }
    @RemoteAction
    global static List<ElementCommentInfo> getAllComments(String community, String id) {
        List<ElementCommentInfo> result = new List<ElementCommentInfo>();
        return result;
    }
    @RemoteAction
    global static FeedElementInfo getElementInfo(String community, String id) {
        return new FeedElementInfo(ConnectApi.ChatterFeeds.getFeedElement(community, id));
    }
    @RemoteAction
    global static ElementCommentInfo getCommentInfo(String community, String id) {
        return new ElementCommentInfo(ConnectApi.ChatterFeeds.getComment(community, id));
    }
    @RemoteAction
    global static List<User> getColleagues(Boolean inCommunity, String accountId, String search, Boolean searching) {
       
        return null;
    }
    @RemoteAction
    global static List<User> getUsersToMention(Map<String,object> parametersMap) {
        return null;
    }
    @RemoteAction
    global static List<ConnectApi.MentionCompletion> getMentionCompletions(Map<String,object> parametersMap) {

        List<ConnectApi.MentionCompletion> mentionCompletions = new List<ConnectApi.MentionCompletion>(); 
        return mentionCompletions;
    }
    @RemoteAction
    global static List<customUser> getNextUserPage(Integer pageToken, String remoteSearchCriteria, Boolean remoteSearching) {  
        return null;
    }
    global with sharing class customUser {
        public ConnectApi.UserDetail thisUser {get; set;}
        public Integer token {get; set;}

        customUser() {
            token = 0;
        }
        customUser (Integer t) {
            token = t;
        }
        customUser (ConnectApi.UserDetail u) {
            thisUser = u;
        }
    }
    @RemoteAction
    global static List<CollaborationGroup> getGroups(Boolean inCommunity, String accountId, String search, Boolean searching) {
        List<CollaborationGroup> tmpList = new List<CollaborationGroup>();
        return tmpList;
    }
    @RemoteAction
    global static List<customGroup> getNextGroupPage(Integer pageToken, String remoteSearchCriteria, Boolean remoteSearching) { 
        return null;
    }
    global with sharing class customGroup {
        public ConnectApi.ChatterGroupDetail thisGroup {get; set;}
        public String token {get; set;}

        customGroup() {
            token = '';
        }
        customGroup (String t) {
            token = t;
        }
        customGroup (ConnectApi.ChatterGroupDetail g) {
            thisGroup = g;
        }
    }
    @RemoteAction
    global static List<FeedElementInfo> getNewsFeedNextPage(String community, String referenceId, String pageToken, Integer remotePageSize, String sortOrderString, String remoteSearchCriteria, Boolean remoteSearching, String news) {
        List<FeedElementInfo> result = new List<FeedElementInfo>();
        return result;
    }
    @RemoteAction
    global static Map<String, String> following() {
        Map<String, String> myFollowings = new Map<String, String>();
        return myFollowings;
    }
    @RemoteAction
    global static String follow(String community, String id) {
        return '';
    }
    @RemoteAction
    global static void unFollow(String community, String id) {
    }

    @RemoteAction
    global static ConnectApi.ChatterLikePage getCommentLikes(String community, String id, Integer token) {
        ConnectApi.ChatterLikePage result;
        return result;
    }
    @RemoteAction
    global static ConnectApi.ChatterLikePage getElementLikes(String community, String id, Integer token) {
        ConnectApi.ChatterLikePage result;
        return result;
    }
    @RemoteAction
    global static void deleteFeedElement(String community, String feedElementID) {
    }

    @RemoteAction
    global static void deleteComment(String community, String commentID) {
    }
    @RemoteAction
    global static void deleteGroup(String communityId, String groupId){
    }


    @RemoteAction
    global static FeedElementInfo postTextFeedElement(String community,String id,String feedElementText) {
        ConnectApi.FeedElement result;
        return new FeedElementInfo(result);
    }
    @RemoteAction
    global static FeedElementInfo postTextFeedElement(Map<String,object> parametersMap) {
        ConnectApi.FeedElement result;
        return new FeedElementInfo(result);
    }

    @RemoteAction
    global static FeedElementInfo postTextFeed(Map<String,object> parametersMap) {
        ConnectApi.FeedElement result;
        return new FeedElementInfo(result);
    }
    @RemoteAction
    global static FeedElementInfo shareFeedElement(String feedElementId, String shareId, String comment) {
        ConnectApi.FeedElement element;
        return new FeedElementInfo(element);
    }
    @RemoteAction
    global static ConnectApi.ChatterLike likeFeedElement( String communityId, String feedElementId ) {
        ConnectApi.ChatterLike result;
        return result;
    }

    @RemoteAction
    global static ConnectApi.ChatterLike likeComment( String communityId, String commentId ) {
        ConnectApi.ChatterLike result;
        return result;
    }

    @RemoteAction
    global static void unLikeElement( String communityId, String likeId ) {
    }
    @RemoteAction
    global static ElementCommentInfo postFeedComment( String communityId, String feedElementId, String text ) {
        ConnectApi.Comment result;
        return new ElementCommentInfo(result);
    }
    @RemoteAction
    global static ElementCommentInfo postFeedCommentNew(Map<String,object> parametersMap) {
        ConnectApi.Comment result; 
        return new ElementCommentInfo(result);       
    }
    @RemoteAction
    global static FeedElementInfo postLinkFeedElement(String community, String id, String feedElementText, String linkName, String linkUrl) {
        return null;
    }

    @RemoteAction
    global static void addBookmark(String community, String feedElementID) {
        ConnectApi.chatterFeeds.updateFeedElementBookmarks(community, feedElementID, true);
    }

    @RemoteAction
    global static void removeBookmark(String community, String feedElementID) {
        ConnectApi.chatterFeeds.updateFeedElementBookmarks(community, feedElementID, false);
    }

//Issue 116752: Internal : Collab Attach file- Upload file action and comment action should be work synchronously
    @RemoteAction
    global static void deleteFileUploaded(String contentDocumentId){
    }
        
}