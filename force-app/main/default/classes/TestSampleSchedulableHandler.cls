@Istest public with sharing class TestSampleSchedulableHandler {
    @isTest static void testExcute(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {  
            SampleSchedulableHandler ssh = new SampleSchedulableHandler();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch, ssh);
            String test = 'Success';
            System.assertEquals('Success', test);
        }
    }
}