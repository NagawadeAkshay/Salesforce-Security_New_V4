/**
* Extend this class if you like to provide any custom key values for a 
* Dynamic form. Then implemented class name
* should be passed in the parameter with key as clsName to DyamicFormView and/or DynamicFormEdit page.
* parameter name : clsName
*   
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 21/05/2021    Rahul Thange            Created
* =============================================================================
*/
global abstract with sharing class DynamicKeyValues {
    
    /*
        The following variable is populated by Dynamic Page controller .
    */
    global Id recordId;

    /*
        Key Value pairs of merge fields to override or add new values dynamically
    */
    global Map<String, String> keyValueMapOverride = new Map<String, String>();

    /*
        Key Value pairs of merge fields with set of string as value to override or add new values dynamically
    */
    global Map<String,Set<String>> listKeyValueMapOverride = new Map<String,Set<String>>();

}