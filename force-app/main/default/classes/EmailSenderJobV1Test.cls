@isTest
private class EmailSenderJobV1Test{
    @isTest private static void schedulerTest() {
        List<EmailQueue__C> EQrec = new List<EmailQueue__C>();       
         Test.startTest();
        EmailSenderJobV1 obj = new EmailSenderJobV1();
        String query= obj.getQuery();
        obj.execute(EQrec);
        Test.stopTest();
        System.assertNotEquals(null, query);      
    }
}