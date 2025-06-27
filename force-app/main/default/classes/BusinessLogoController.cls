/**
* To show business logo beside name component
* 1. Inputs Expected: pageLayConfigId & RecordID  recId
* 2. BusinessLogoController will fetch pageLayConfigId's LogoFieldAPIName__c and LogoType__cand query on related record to tech LogoFieldAPIName__c's Id to get relate logo Attachment
* 
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* 01/06/2018    Mayuresh G      Created
* =============================================================================
@deprecated
*/

global with sharing class BusinessLogoController{

    global BusinessLogoController() { }

    @RemoteAction
    global static string showBuzLogoAction(String pageLayoutId, String recId){
        return '';
    }
}