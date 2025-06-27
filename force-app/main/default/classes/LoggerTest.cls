@isTest
private class LoggerTest {
    @isTest
    static void verifyLogger(){
        List<String> lstLines = new List<String>{'Line1', 'Line2'};
        Logger.debug(lstLines);
        System.assert(String.isNotBlank(Logger.logData));
        Logger.store();
        try {
            insert new Account();
        } catch(Exception ex) {
            System.assertNotEquals(null, ex);
            Logger.error(ex);
        }
    }
}