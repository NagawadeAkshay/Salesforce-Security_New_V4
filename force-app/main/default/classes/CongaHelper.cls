public with sharing class CongaHelper {

    public static Boolean isCongaInstalled() {
        return SchemaManager.doesObjExist('APXTConga4__Conga_Merge_Query__c');
    }

    /* PRIVATE METHODS */


}