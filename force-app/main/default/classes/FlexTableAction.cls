/**
* Extend this class if you like to provide any custom behavior for a 
* custom button/link placed on flex table. Then implemented class name
* should be entered on FlexTgableActionConfig object.
*   
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 05/06/2014    Shah Kadirmohideen      Created
* =============================================================================
*/
global abstract with sharing class FlexTableAction{
    /*
        The following variable is populated by flex table controller when the custom action is defined
        on the header level and if checkbox selection is enabled for each record.
    */
    global GenericLightningCtrl lightningObject = new GenericLightningCtrl ();
    global List<String> selectedRecordIds;  
    
    /*
        The following variable is populated by flex table controller when the custom action is defined
        at the row level instead of header.
    */
    global Id selectedRecordId;
    
    /*
        Key Value pairs of url parameters which were used to display the flex table
    */
    global Map<String, String> urlParams = new Map<String, String>();
    
    /*
        Key Value pairs of url parameters which were used to display the flex table
    */
    global Map<String, Object> urlParamsMap = new Map<String, Object>();

    /*
        The Action button or link that was clicked
    */
    global DataTableAction__c actionConfig;
     /*
        The Action that was clicked :used in FlexGridEnhanced
    */
    global Map<String, Object> actionconfigMap;

    /*
    Name of flex table record
    */
    global String dataTableConfigName ;

    /*
    Data table qurey with replace merge fields 
    */
    global String query;
    
    //This method has been deprecated
    global abstract PageReference whenClicked();


}