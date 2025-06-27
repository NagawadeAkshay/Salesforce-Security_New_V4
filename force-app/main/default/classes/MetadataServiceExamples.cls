/*
    Metadata Service example class to update the translation & field sets
*/
/** 26th april 23 As discussed with Nakul commenting this out will verify with salesforce support team Note - in future 
 * if we found we are using this class then we need to uncomment and used oauth for sessionid 
 */
global with sharing class MetadataServiceExamples{
	// variables for updateCustomLabelTranslation
    global static String langCode{get;set;}
    
    public MetadataServiceExamples(){
    }
    
    /* This method takes label name and new value for the label and updates the English translation */
    @RemoteAction
    global static void updateCustomLabelTranslation(String updatedLabel,String existingLabel){
    }
}