/**
* @Class Name: TestUserTriggerHelper
* @Description: This class is test class for UserTriggerHelper
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |15/03/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/

@isTest
private class TestUserTriggerHelper{
    
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
* @Method name: getGGLicensesToInsert
* @Description: This method is used to create GGLicenses__c records
* @Param: type=Integer // number of records to be created
* @Return: List of created GGLicenses__c.
* @Date: 15/03/2019
**/ 
    Private Static List<GGLicenses__c> getGGLicensesToInsert(Integer Count)
    {
        List<GGLicenses__c> GGLicensesList= new List<GGLicenses__c>();
        for(integer i=0;i<Count;i++)
        {
            GGLicenses__c gg = new GGLicenses__c(LicenseName__c='GovGrants Agency - Active User',TotalLicenses__c=5,UsedLicenses__c=2);
            GGLicensesList.add(gg);
        }
        return GGLicensesList;
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: getUserToInsert
* @Description: This method is used to create User records
* @Param: type=Integer // number of records to be created
* @Return: List of created User.
* @Date: 15/03/2019
**/ 
    Private Static List<User> getUserToInsert(Integer Count)
    {
        List<User> UserList= new List<User>();
        for(integer i=0;i<Count;i++)
        {
            User user =TestHelper.getAdminUserDept(false);
            UserList.add(user);
        }
        return UserList;
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testForPostiveSINGLERecordInsertion
* @Description: This method is used to test postivie scenario of single GGLicenses__c record insertion
* @Param: NA  
* @Return: NA
* @Date: 15/03/2019
**/ 
    @isTest
    private static void testForPostiveSINGLERecordInsertion(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            integer CNT=1;
            KeyValueStoreHelper.setBooleanValue('EnableGGLicense', true, true) ;
            
            List<Account> accountLst= getAccountToInsert(CNT);
            insert accountLst;
            
            List<GGLicenses__c> GGLicensesLst= getGGLicensesToInsert(CNT);
            for(integer i=0;i<CNT;i++)
            {
                GGLicensesLst[i].Organization__c=accountLst[i].id;
            }
            insert  GGLicensesLst;
            
            
            List<user> UserLst=getuserToInsert(5);
            for(integer i=0;i<CNT;i++)
            {
                UserLst[i].OrganizationId__c= accountLst[i].id;
            }
            Test.startTest();
            insert UserLst;
            Test.stopTest();
            
            List<GGLicenses__c> GGLicensesList= [SELECT id,UsedLicenses__c,LicenseName__c, TotalLicenses__c FROM GGLicenses__c ]; 
            for(GGLicenses__c GGLicenses :GGLicensesList)
            {
                system.assert(GGLicenses.UsedLicenses__c==3);
            }
            
        }
    }
    
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testForPostiveBULKRecordInsertion
* @Description: This method is used to test postivie scenario of list of GGLicenses__c record insertion
* @Param: NA  
* @Return: NA
* @Date: 15/03/2019
**/ 
    @isTest
    private static void testForPostiveBULKRecordInsertion(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            integer CNT=5;
            KeyValueStoreHelper.setBooleanValue('EnableGGLicense', true, true) ;
            
            List<Account> accountLst= getAccountToInsert(CNT);
            insert accountLst;
            
            List<GGLicenses__c> GGLicensesLst= getGGLicensesToInsert(CNT);
            for(integer i=0;i<CNT;i++)
            {
                GGLicensesLst[i].Organization__c=accountLst[i].id;
            }
            insert  GGLicensesLst;
            
            
            List<user> UserLst=getuserToInsert(CNT);
            for(integer i=0;i<CNT;i++)
            {
                UserLst[i].OrganizationId__c= accountLst[i].id;
            }
            Test.startTest();
            insert UserLst;
            Test.stopTest();
            
             List<GGLicenses__c> GGLicensesList= [SELECT id,UsedLicenses__c,LicenseName__c, TotalLicenses__c FROM GGLicenses__c ]; 
            for(GGLicenses__c GGLicenses :GGLicensesList)
            {
                system.assert(GGLicenses.UsedLicenses__c==3);
            }
            
        }
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testForPostiveUpdation
* @Description: This method is used to test postivie scenario of GGLicenses__c single record updation where user is Active user
* @Param: NA  
* @Return: NA
* @Date: 15/03/2019
**/ 
    @isTest
    private static void testForPostiveSINGLEUpdation(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            
            integer CNT=1;
            KeyValueStoreHelper.setBooleanValue('EnableGGLicense', true, true) ;
            
            List<Account> accountLst= getAccountToInsert(CNT);
            insert accountLst;
            
            List<GGLicenses__c> GGLicensesLst= getGGLicensesToInsert(CNT);
            for(integer i=0;i<CNT;i++)
            {
                GGLicensesLst[i].Organization__c=accountLst[i].id;
            }
            insert  GGLicensesLst;
            
            List<user> UserLst=getuserToInsert(5);
            for(integer i=0;i<CNT;i++)
            {
                UserLst[i].OrganizationId__c= accountLst[i].id;
                UserLst[i].IsActive=false;
            }
            insert UserLst;
            
            //govObj.LicenseName__c ='true';
            //update govObj;
            //List<GGLicenses__c> GGLicensesList= [SELECT id,LicenseName__c FROM GGLicenses__c where id=: govObj.id]; 
            
            List<user> ToUpdateUserLst= new List<user>();
            Test.startTest();
            for(user us:UserLst){
                us.IsActive = true;
                ToUpdateUserLst.add(us);
            }
            update ToUpdateUserLst;
            Test.stopTest();
            
             List<GGLicenses__c> GGLicensesList= [SELECT id,UsedLicenses__c,LicenseName__c, TotalLicenses__c FROM GGLicenses__c ]; 
            for(GGLicenses__c GGLicenses :GGLicensesList)
            {
                system.assert(GGLicenses.UsedLicenses__c==3);
            }
            
        }
    }
    
    
     /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testForPostiveBULKUpdation
* @Description: This method is used to test postivie scenario of GGLicenses__c BULK record updation where user is Inactive user
* @Param: NA  
* @Return: NA
* @Date: 15/03/2019
**/ 
    @isTest
    private static void testForPostiveBULKUpdation(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            
            integer CNT=3;
            KeyValueStoreHelper.setBooleanValue('EnableGGLicense', true, true) ;
            
            List<Account> accountLst= getAccountToInsert(CNT);
            insert accountLst;
            
            List<GGLicenses__c> GGLicensesLst= getGGLicensesToInsert(CNT);
            for(integer i=0;i<CNT;i++)
            {
                GGLicensesLst[i].Organization__c=accountLst[i].id;
            }
            insert  GGLicensesLst;
            
            
            List<user> UserLst=getuserToInsert(5);
            for(integer i=0;i<CNT;i++)
            {
                UserLst[i].OrganizationId__c= accountLst[i].id;
                UserLst[i].IsActive=true;
            }
            insert UserLst;
            
            //govObj.LicenseName__c ='true';
            //update govObj;
            //List<GGLicenses__c> GGLicensesList= [SELECT id,LicenseName__c FROM GGLicenses__c where id=: govObj.id]; 
            
            List<user> ToUpdateUserLst= new List<user>();
            Test.startTest();
            for(user us:UserLst){
                us.IsActive = false;
                ToUpdateUserLst.add(us);
            }
            update ToUpdateUserLst;
            Test.stopTest();
            
            List<GGLicenses__c> GGLicensesList= [SELECT id,UsedLicenses__c,LicenseName__c, TotalLicenses__c FROM GGLicenses__c ]; 
            for(GGLicenses__c GGLicenses :GGLicensesList)
            {
                system.assert(GGLicenses.UsedLicenses__c==1);
            }
            
        }
    }
    
    
}