/**
 * Created by REI on 27-07-2020.
 */

global with sharing class FormLayoutPrintController {
    global string type {get; set;}
    global string recordId {get; set;}
    global string formId {get; set;}
    global Boolean showHeader{get; set;}
    
    global FormLayoutPrintController(){

    }

    global FormLayoutPrintController(String type,String recordId,String formId,Boolean showHeader){
       
    }

    global Component.Apex.OutputPanel getPrintLayoutTabsContent() {
        return null;
    }

}