/**
* To handle an action for flex table, extend this class instead of
* FlexTableAction.
*   
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 02/16/2014    Shah Kadirmohideen      Created
* =============================================================================
*/
global abstract with sharing class FlexTableActionHandler extends FlexTableAction {
    //The below one is deprecated
    global override PageReference whenClicked() {
        clickHandler();
        return null;
    }

    //This method should be implemented by the custom class implementor
    // For now we have 2 keys that are returned:
    //1. PageReference for the URL that is to be returned back e.g. resultMap.put('PageReference',Page.FlexTableExport);  
    //2. Message - for any message to be displayed back on the parent page e.g resultMap.put('Message','Record added successfully');
    global abstract Map<String,Object> clickHandler();
    
}