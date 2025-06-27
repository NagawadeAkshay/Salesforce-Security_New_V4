/**
* @Class Name: TestAccountHierarchyCtrl
* @Description: This class is test class for AccountHierarchyCtrl
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |15/03/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/
/**
* @Class Name: TestAccountHierarchyCtrl
* @Description: This class is test class for AccountHierarchyCtrl
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |15/03/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/
@IsTest
public with sharing class TestAccountHierarchyCtrl {
    
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: getAccountToInsert
* @Description: This method is used to create Account records
* @Param: type=Integer // number of records to be created
* @Return: List of created account.
* @Date: 15/03/2019
**/ 
    
    Private Static List<Account> getAccountToInsert(Integer Count)
    {
        List<Account> accountList= new List<Account>();
        for(integer i=0;i<Count;i++)
        {
            Account acc =TestHelper.getAccount(false);
            accountList.add(acc);
        }
        return accountList;
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testPositiveAccountHierarchyCtrl
* @Description: This method is used to get correct Account Hierarchy
* @Param: NA  
* @Return: NA
* @Date: 15/03/2019
**/ 
    @IsTest
    public static void testPositiveAccountHierarchyCtrl() 
    {
        User u = TestHelper.getAdminUser(true);
        
        System.runAs(u){
            
            List<User> userLst = new List<User>();
            user user = TestHelper.getStandardUser(false);
            userLst.add(user);
            insert userLst;
            
            List<Account> accountList= getAccountToInsert(1);
            insert accountList;
            List<Account> accountLst= getAccountToInsert(5);
            for(Account acc :accountLst)
            {
                acc.parentid=accountList[0].id;
            }
            insert accountLst;
            String id1= (String) accountLst[0].id;
            
            AccountHierarchyCtrl ahc = new AccountHierarchyCtrl();
            Test.startTest();
            Map<String,Object> Hierarchy=  AccountHierarchyCtrl.getAccountHierarchy(id1,'id!=null');
            System.assertNotEquals(null, Hierarchy);
            Test.stopTest();
            
            
        }
    }
    
    
     /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testNegativeAccountHierarchyCtrl
* @Description: This method is used to get correct Account Hierarchy
* @Param: NA  
* @Return: NA
* @Date: 15/03/2019
**/ 
    @IsTest
    public static void testNegativeAccountHierarchyCtrl() 
    {
        User u = TestHelper.getAdminUser(true);
        
        System.runAs(u){
            
            List<User> userLst = new List<User>();
            user user = TestHelper.getStandardUser(false);
            userLst.add(user);
            insert userLst;
            
            List<Account> accountList= getAccountToInsert(1);
            insert accountList;
            List<Account> accountLst= getAccountToInsert(5);
            for(Account acc :accountLst)
            {
                acc.parentid=accountList[0].id;
            }
            insert accountLst;
            String id1= (String) accountLst[0].id;
            
            AccountHierarchyCtrl ahc = new AccountHierarchyCtrl();
            Test.startTest();
            Boolean isSuccess= true;
            try
            {
               Map<String,Object> Hierarchy=  AccountHierarchyCtrl.getAccountHierarchy(id1,'ParentId == null');
            }catch(Exception e)
            {
                isSuccess= false;
            }
            System.assertNotEquals(true, isSuccess);
            Test.stopTest();
            
            
        }
    }
}