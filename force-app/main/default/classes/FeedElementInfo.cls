/**
* The FeedItemInfo class uses the FeedFormatter and CommentInfo classes and 
* assembles the Apex output to display @mentions, hashtags, embedded links and other rich text in HTML.
*
* CHANGE HISTORY
*====================================================================
* 06/29/2014        Kunal Shah            Created FeedItemInfo
* 11/20/2014		William Moore		  Modified to FeedElementInfo
*====================================================================
*/
global with sharing class FeedElementInfo {

    global FeedElementInfo(String newToken) {
    	token = newToken;
    }
    global FeedElementInfo(ConnectApi.FeedElement inFeedElement) {
    	token = '';
    }
  
    //-------- properties ----------//
    global ConnectApi.feedElement feedElement { get; private set; }
    global String userName { get; private set; }
    global String userID { get; private set; }
    global String imageUrl { get; private set; }
    global String linkUrl { get; private set; }
    global String linkTitle { get; private set; }
    global String contentDescription { get; private set; }
    global String contentDownloadUrl { get; private set; }
    global String contentTitle { get; private set; }
    global Boolean hasImagePreview { get; private set; }
    global String formattedText { get; private set; }
    global String contentId { get; private set; }
    global List<ElementCommentInfo> comments { get; private set; }
    global Boolean hasTopics { get; private set; }
    global String userFirstName { get; private set; }
    global String userLastName { get; private set; }
    global String originalPosterName { get; private set; }
    global String originalPosterId { get; private set; }
    global Integer totalLikes { get; private set; }
    global String token {get; private set;}

    @TestVisible
    global Integer commentCount;
        
}