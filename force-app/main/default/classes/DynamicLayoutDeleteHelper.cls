/*
    Class to delete a record from the dynamic layout
    Usage: Setup a delete button on dynamic layout action 
    Note: No need to set any Action Class. 
    ***********************************************************
    Audit History
    ***********************************************************
    06/09/2014      Kunal Shah             Created
    *********************************************************** 
*/

public with sharing class DynamicLayoutDeleteHelper extends DynamicLayoutActionRedirect{
	
	public override PageReference whenClicked(){
		return deleteRecord();
	}
	
	/*
    * Method to delete the current record
    */
    public PageReference deleteRecord()
    {
    	Id rcrdId = String.escapeSingleQuotes(layoutHolder.getPrimarySObject().Id);
    	
        // Get all the objects info
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    
        // Now map all key prefixes to object type labels.
        // We don't know how many different types of What IDs there can be. This handles all possible object types.
        String prefix;
        map<String, String> prefixMap = new map<String, String>();
        for (Schema.SObjectType ot : gd.values())
        { 
            prefix = ot.getDescribe().getKeyPrefix();
            if (prefix != null)
            {
            prefixMap.put(prefix, ot.getDescribe().getName());
            }
        }
        
        String objectName;
        String sub;
        // Get the first three characters from the rcrdId.
        sub = String.valueOf(rcrdId).substring(0, 3);
        if (sub != null)
        { 
            // Look up the prefix in the map.
            objectName = prefixMap.get(sub);
        }   

        try{
            if (objectName != null) {
                string deleteQuery = 'SELECT ID FROM ' + string.escapeSingleQuotes(objectName) + ' WHERE ID  =:rcrdId ';//SOQL Injection - False +ve - Dynamic part of query string is escapeSingleQuotes
                sObject obj;
                if(AppUtils.isObjectAccessible(objectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
                    obj = Database.query(String.escapeSingleQuotes(deleteQuery), AccessLevel.USER_MODE);
                }
                SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                String objName = cls.getSobjectName(obj);
                 if(obj != null && AppUtils.isObjectDeletable(objName)){
                	    delete obj;//CRUD False +ve with the help of apputil we have performed check / FLS False +ve - as it is breaking for portal/guest users
                } 
            }   
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AppUtils.handleSystemExceptionMsg(e)));
            return null;
        }
        
        //deletePage is pagereference variable that we pass as attribute from flexviewlayout component.
        if(layoutHolder.deletePage != null){
           return layoutHolder.deletePage;
        }else{
        return AppUtils.getHomePage();
   
        }
    }
}