@isTest
private class ActionConfigClassPageCtrlTest {    
    @isTest 
    Static void testgetActionClass(){ 
        Test.setCurrentPageReference(new PageReference('Page.ActionConfigClassPageCtrl')); 
        System.currentPageReference().getParameters().put('className', 'ActionConfigClassPageCtrlTest');
        ActionConfigClassPageCtrl ActionConfigClassPageCtrlObj = new ActionConfigClassPageCtrl();
        PageReference pg = ActionConfigClassPageCtrlObj.getActionClass();
        System.assertNotEquals(null, pg);
        ActionConfigClassPageCtrlObj.classId = null;
        try {
            System.currentPageReference().getParameters().put('className', null);
            pg = ActionConfigClassPageCtrlObj.getActionClass();
            System.assertEquals(null, pg);
        } catch(Exception ex) {
            System.assertNotEquals(null, ex);
        }        
    }    
}