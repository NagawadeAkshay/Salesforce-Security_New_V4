@isTest
public class TestSendToOwnerEventHandler {
    @isTest static void testHandle(){
        SobjectConfig__c sobj = new SobjectConfig__c(); 
        sobj.UserFriendlyNameField__c = 'Name';
        sobj.name = AppUtils.getNameSpacePrefix() +'SobjectConfig__c';
        sobj.ApprovalReCallFieldAPIName__c = 'CaptureSnapshotonApproval__c';
        sobj.ApprovalReCallCommentFieldAPIName__c = AppUtils.getNameSpacePrefix() +'ApprovalDecisionCommentLabel__c';
        insert sobj;
        system.assertnotEquals(null,sobj.Id);
        
        Set<String> objSetOfString = new Set<String>();
        objSetOfString.add(sobj.ID);
        SendToOwnerEventHandler objSendToOwnerEventHandler =  new SendToOwnerEventHandler();
        objSendToOwnerEventHandler.handle(objSetOfString);
    }
}