global with sharing class CollabNavigator implements Site.UrlRewriter {
     
     global PageReference mapRequestUrl(PageReference currentURL){
          return null;
     }
     public List<System.PageReference> generateUrlFor(List<System.PageReference> pageRefList) {
          return pageRefList; 
     }
}