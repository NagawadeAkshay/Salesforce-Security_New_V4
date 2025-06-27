@isTest
private class WorkSpaceFilesCtrlTest{
  
    @isTest
    public static void test(){
        User u = TestHelper.getAdminUser(true);
          System.runAs(u) {

            WorkSpaceFilesCtrl wsfc = new WorkSpaceFilesCtrl();
            wsfc.getKeyValueMap();
            system.assertNotEquals(null, wsfc);
          }
       
    }

}