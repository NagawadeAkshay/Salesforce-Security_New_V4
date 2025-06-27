global with sharing class ProfileViewCtrl {
    
    public ProfileViewCtrl() {
        
    }
    
   
    global static void uploadUserPhoto(String profileHiddenFile,string profileHiddenType,string profileHiddenName){
        
    }
    @RemoteAction
    global static String uploadUserPhoto(String profileHiddenFile,string profileHiddenType,string profileHiddenName, Boolean isLast, Boolean isFirst){
        return null;
    }

    @RemoteAction
    global static String uploadUserPhotoNew(String profileHiddenFile,string profileHiddenType,string profileHiddenName, Boolean isLast, Boolean isFirst, Id userId){
        return null;
    }
    
    @RemoteAction
    global static List<User> getManagers(String name, String roleId) {
        return null;
    }
    
    @RemoteAction
    global static void deleteUserPhoto(String id) {
    }
    @RemoteAction
    global static List<CollaborationGroup> getMyGroups(String id) {
        Set<Id> groupIds = getGroupsForIds(new Set<Id>{id});
        return null;
    }
    // return all ids the user belongs to via direct or indirect membership
    global static Set<Id> getGroupsForIds(Set<Id> userOrGroupIds){
        return null;
    }

    @RemoteAction
    global static List<ContentVersion> getMyFiles(String id) {
        return null;
    }

    @RemoteAction
    global static ConnectApi.FollowerPage getFollowers(String community, String id, Integer token) {
        return null;
    }

    @RemoteAction
    global static ConnectApi.FollowingPage getUserFollowings(String community, String id, Integer token, String filterType) {
           return null; 
    }
    @RemoteAction
    global static ConnectApi.Subscription follow(String id) {       
        return null;
    }
    @RemoteAction 
    global static void unFollow(String id) {
        return;
    }

    //deprecated
    global with sharing class FakeContentVersion {
    }   
    //deprecated
    @RemoteAction
    global static ConnectApi.UserPage getAllUsers(Integer token) {
        return null;
    }
    //deprecated
    @RemoteAction
    global static ConnectApi.GroupMemberPage getGroupMembers(String id, Integer token) {
        return null;
    }
    //deprecated
    @RemoteAction
    global static List<ConnectApi.groupMembershipRequest> getPendingRequests(String id) {
        return null;
    }
    //deprecated
    @RemoteAction
    global static List<ContentVersion> getGroupFiles(String id) {
        return null;
    }
    //deprecated
    global static ConnectApi.FollowerPage getFollowers(String id, Integer token) {
        return null;
    }
    //deprecated
    @RemoteAction
    global static ConnectApi.FollowingPage getFollowings(String id, Integer token) {
        return null;
    }
}