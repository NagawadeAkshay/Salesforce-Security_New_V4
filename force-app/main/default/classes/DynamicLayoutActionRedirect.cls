/**
* Extend this class if you like to provide any custom behavior for a 
* custom button/link placed on dynamic layout. Then implemented class name
* should be entered on DynamicLayoutActionConfig object.
*   
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 05/06/2014    Shah Kadirmohideen      Created
* =============================================================================
*/
global abstract with sharing class DynamicLayoutActionRedirect{
    global DynamicLayoutHolder layoutHolder;
    global Id actionId;
    global String promptInputValue;
    global GenericLightningCtrl lightningObject = new GenericLightningCtrl ();
    
    global DynamicLayoutActionRedirect(DynamicLayoutHolder layoutHolder) {
        this.layoutHolder = layoutHolder;
    }
    
    global DynamicLayoutActionRedirect() {}
    
    //This method will be used when some action is performed, and you want to redirect to some other page
    global abstract PageReference whenClicked();
}