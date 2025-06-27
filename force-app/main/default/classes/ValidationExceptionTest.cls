@isTest
private class ValidationExceptionTest {
    @isTest
    static void verifyValidationException(){
        try {
            insert new Lead();
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
            ValidationException obj = ValidationException.newInstance(ex.getMessage());
            obj = ValidationException.newInstance(ex);
        }
        
        try {
            List<SObject> lst = Database.query('SELECT Id FROM TestAccount');
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
            ValidationException obj = ValidationException.newInstance(ex.getMessage());
            obj = ValidationException.newInstance(ex);
        }
    }
}