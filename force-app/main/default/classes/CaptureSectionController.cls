/**
 * Created by MCPL-L72 on 22-11-2019.
 */

global with sharing class CaptureSectionController {

    global String pbSectionId{get;set;}
    global List<CaptureItem__c> captureItemsLst{get;set;}
    global Map<String , CaptureItemResponse__c> captureItemsResponseMap{get; set;}
    global static List<String> captureFieldAPIArray;
    global static String recordIdVal{get;set;}
    global static List<CaptureItem__c> cpturItemLst;
    global static List<String> cpItemIdlist;

    global CaptureSectionController(){


        captureFieldAPIArray = new List<String>{'Record ID','Capture Section','Capture Item','IsScoreApplicable(Obsolete)','Created Date','Deleted','Created By ID','Last Modified Date','Last Modified By ID','System Modstamp','Last Activity Date','Last Viewed Date','Last Referenced Date','Internal Unique Id','Answer(Obsolete)'};
    }
     global  void getCaptureItems(Id sectionId){
        
    }

    global void getCaptureItemsResponse(Set<Id> captureItemsIdSet){
       
    }

}