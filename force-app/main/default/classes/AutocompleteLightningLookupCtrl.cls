/**
 @deprecated
**/

global with sharing class AutocompleteLightningLookupCtrl {
    global transient string fldAPIName {get; set;}
    global transient string parentObjAPIName {get; set;}
    global transient string fields {get; set;}
    global String sobjectName { get; set; }
    global String sortField { get; set; }
    global String sortDirection { get; set; }
    global String filterCriteria { get; set; }
    global String displayFields { get; set; }
    global String operatorForDate { get; set; }
    global String datatypeOfField { get; set; }
    global String allowedDecimal { get; set; }
    global String labelOfField { get; set; }
    global Map<String,String> mapOflabels;
    global Map<String,String> typOfColumn { get; set; }
    global Map<String,String> allowedDecml { get; set; }
    global Map<String,String> labelOfFields { get; set; }
    global transient string pageblckId {get;set;}
    public string flexTableParameters {get;set;}
    public string listParameter {get;set;}
    global transient string lookupSortByField{get; set;}
    global transient string lookupSortDirectionField{get; set;}
    global transient String displayFieldsTemp{get; set;}
    global string displayFieldsofsobject {get;set;}
    public String displayFieldLabel {get;set;}
    public String filterCriteriaPBD {get;set;}
    global string namespace {
        get {
        if(String.isEmpty(namespace)){
            return AppUtils.getNameSpacePrefix();
        }   
        return namespace; 
        }
        set;
    }

    // This method is to get the object api name 
    global string getObjAPIName() {
        return null;
    }

    // In this method we are giving first priority to pageblockdetail config & second priority to Sobjectlevel.
    global List<String> getFieldsToDisplay() {
        return null;
    }
}