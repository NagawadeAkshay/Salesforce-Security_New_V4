@isTest
private class TestAttachmentExtensionTrigger{
  
  @testSetup static void setup() {
       Account ac = TestHelper.getAccount(true);
       TestHelper.getAttachment(ac.Id,true);
   }
    
  @isTest
  private static void TestErrorMessageConfigInsert(){
    Test.startTest();
    AttachmentExtension__c ae = new AttachmentExtension__c();
    Attachment att = [SELECT Id,Name FROM Attachment LIMIT 1];
    ae.AttachmentName__c = att.Name;
    ae.Attachment__c = att.Id;
    insert ae;
    System.AssertEquals('Test Attachment',ae.AttachmentName__c); 
    Test.stopTest();   
  }
    
}