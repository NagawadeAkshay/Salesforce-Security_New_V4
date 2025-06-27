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
global abstract with sharing class DynamicLayoutAction{
    global DynamicLayoutHolder layoutHolder;
    global GenericLightningCtrl lightningObject = new GenericLightningCtrl ();
    
    global DynamicLayoutAction(DynamicLayoutHolder layoutHolder) {
        this.layoutHolder = layoutHolder;
    }
 	
 	global DynamicLayoutAction() {}

    global abstract PageReference whenClicked();
    
}