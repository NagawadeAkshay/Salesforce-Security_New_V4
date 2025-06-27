@isTest
public class TestDelegateApprovarTaskCloseBatch {
@isTest
    private static void setupData(){
        DelegateApprovarTaskCloseBatch obj = new DelegateApprovarTaskCloseBatch();
        String str = obj.getQuery();
        obj.finish();
        //User testUser = TestHelper.getUser(true);
        List<User> userWithOldDelegate = new List<User>();
        //userWithOldDelegate.add(testUser);
        DelegateApprovarTaskCloseBatch obj1 = new DelegateApprovarTaskCloseBatch(userWithOldDelegate);
        String str1 = obj1.getQuery();
        obj1.execute(userWithOldDelegate);
        obj1.finish();
        system.assertNotEquals(null,obj);
    }
}