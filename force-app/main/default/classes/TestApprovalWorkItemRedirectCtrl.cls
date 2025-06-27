@isTest
private class TestApprovalWorkItemRedirectCtrl {
  @isTest
  static void test_2() {  
    Test.setCurrentPageReference(new PageReference('Page.ApprovalWorkItemRedirect')); 
    System.currentPageReference().getParameters().put('id', null);
    ApprovalWorkItemRedirectCtrl ctrl = new ApprovalWorkItemRedirectCtrl();
    System.assertNotEquals(null, ctrl);

    PageReference pRef = ctrl.redirect();
    /*
    ProcessInstanceWorkItem workItem = Testhelper.getProcessInstanceWorkItem();
    System.assertNotEquals(null, workItem.Id);

    Test.setCurrentPageReference(new PageReference('Page.ApprovalWorkItemRedirect')); 
    System.currentPageReference().getParameters().put('id', workItem.Id);
    ctrl = new ApprovalWorkItemRedirectCtrl();
    System.assertNotEquals(null, ctrl);

    pRef = ctrl.redirect();
    */
  }
}