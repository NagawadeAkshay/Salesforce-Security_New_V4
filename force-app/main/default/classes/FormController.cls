global with sharing class FormController {

    global String orgNameSpace{get;set;}

    global FormController(){

    }

    global void convertDateVal(String sectionId, Date dateVal,CaptureItem__c cpItemObj){
        
    }

    @RemoteAction
    global static String getlocaleDateFormat(){
        return '';
    }
}