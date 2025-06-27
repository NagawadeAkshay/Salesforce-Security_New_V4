@isTest
public class LogExceptionHandlerTest {

    @isTest
    private static void verifyLogException(){
        try{
            Lead objLead = new Lead();
            insert objLead;
            System.assertNotEquals(null, objLead.Id);
        } catch(Exception ex){
            Test.startTest();
            LogExceptionHandler.logException(ex);
            Test.stopTest();
        }
    }
}