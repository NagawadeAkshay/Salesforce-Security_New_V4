/**
* TEST CLASS FOR AssignPanelApplicationToReviewersHelper
*/
@isTest
private with sharing class TestAssignPanelAppToRevHelper{
    /*
    static Map<String, String> urlParams = new Map<String, String>();
    static List<String> selectedRecordIds;
    static ReviewPanel__c reviewPanel ;
    static Review__c rev;
    static PanelUser__c panelUser ;
    static Review__c review ;
    
    @isTest static void testWhenClicked() {
        user u = TestHelper.getStandardUser(false);
        system.runAs(u){            
            TestHelper.createCustomSettings(true);
         }
        user u1 = TestHelper.getAdminUser(false);
        system.runAs(u1){            
            review = TestHelper.getReview(true);
         }
            rev = [Select PanelApplication__c From Review__c Where Id = :review.Id];
            reviewPanel = [SELECT Id, Name,ReviewStep__c FROM ReviewPanel__c WHERE Id=:review.ReviewPanel__c];           
            panelUser = [SELECT Id,Reviewer__c FROM PanelUser__c WHERE ReviewPanel__c = :reviewPanel.id];
          
          user u2 = TestHelper.getStandardUser(false);
          system.runAs(u2){  
          Test.startTest();               
                AssignPanelApplicationToReviewersHelper ctrl = new AssignPanelApplicationToReviewersHelper();
                ctrl.urlParams.put('id',reviewPanel.id);
                ctrl.urlParams.put('panelId',rev.PanelApplication__c);
                ctrl.selectedRecordIds = new List<String>();
                ctrl.selectedRecordIds.add(panelUser.Reviewer__c);
                Map<String,Object> clickHandler = new Map<String,Object>();
                Map<String,Object> clickHandlerResult = ctrl.clickHandler();
            Test.stopTest();
                system.assertNotEquals(clickHandlerResult,null);
        }
    }
      */  
    
}