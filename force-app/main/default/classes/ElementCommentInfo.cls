/**
* Chatter helper classes.
*
* CHANGE HISTORY
*================================================================ 
* 06/29/2014        Kunal Shah            Created 
*================================================================
*/

global with sharing class ElementCommentInfo {

    global ElementCommentInfo(ConnectApi.Comment inComment) {
    }
    
    global ConnectApi.Comment comment { get; private set; }
    global String userName { get; private set; }
    global String imageUrl { get; private set; }
    global String formattedText { get; private set; }
    global Integer totalLikes { get; private set; }   
    global String contentDescription { get; private set; }
    global String contentDownloadUrl { get; private set; }
    global String contentTitle { get; private set; }
    global Boolean hasImagePreview { get; private set; }
    global String contentId { get; private set; }
}