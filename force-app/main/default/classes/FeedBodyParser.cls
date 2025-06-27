/**
* To post a feed item, build an instance of ConnectApi.FeedItemInput and set its body to an instance of MessageBodyInput. 
* MessageBodyInput contains the data necessary to post @mentions and other rich text.
* This code parses out @-mentions from user-provided text and converts the text into a ConnectApi.FeedItemInput that's ready to post.
*
* CHANGE HISTORY
*================================================================ 
* 06/29/2014		Kunal Shah		      Created 
*================================================================
*/

public with sharing class FeedBodyParser {
  public FeedBodyParser(){}
}