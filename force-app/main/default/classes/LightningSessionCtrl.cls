public with sharing class LightningSessionCtrl {
    public String getSessionId() {
       return '{!$Credential.OAuthToken}';
   }
}