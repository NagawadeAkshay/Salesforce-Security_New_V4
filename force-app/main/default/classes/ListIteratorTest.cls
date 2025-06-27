@isTest
private class ListIteratorTest {
    @isTest
    static void verifyListIterator(){
        List<Account> lstAccounts = new List<Account>();
        for(Integer cnt = 1; cnt <= 10; cnt++){
            lstAccounts.add(new Account(Name = 'Test Account '+ cnt));
        }
        insert lstAccounts;
        for(Account obj : lstAccounts){
            System.assertNotEquals(null, obj.Id);
        }

        ListIterator objListIterator = new ListIterator(lstAccounts, 3);
        System.assertNotEquals(null, objListIterator);        
        Boolean hasNext = objListIterator.hasNext();
        List<Object> lstNext = objListIterator.next();

        try {
            objListIterator = new ListIterator(null, 3);       
            hasNext = objListIterator.hasNext();
            lstNext = objListIterator.next();
        } catch(Exception ex){
            System.assertNotEquals(null, ex);
        }
    }
}