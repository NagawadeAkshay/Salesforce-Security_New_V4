/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private with sharing class TestTaskReassignmentCtrl {
  public static User user_1;
  public static User user_2;
  public static Task task;
  private static void setup(){
    //user_1 = TestHelper.getUser(true);
    //user_2 = TestHelper.getUser(true);
    task = TestHelper.getTask(true);
    ApexPages.currentPage().getParameters().put('sourceUser',UserInfo.getUserId());
    ApexPages.currentPage().getParameters().put('targetUser',UserInfo.getUserId());
    
    
  }
     @IsTest
    public static void testAllMethods(){
      setup();
      
      ApexPages.currentPage().getParameters().put('phaseName','Opportunity');
       TaskReassignmentCtrl ctrl = new TaskReassignmentCtrl();
       Test.startTest();
       String result_1 = ctrl.getKeyValueMap();
       Map<String,Object> result_3 = TaskReassignmentCtrl.fetchUser(UserInfo.getUserId());
       //TaskReassignmentCtrl.UserData userData = TaskReassignmentCtrl.UserData(task,'The new phone books are here Im somebody again');
       //Map<String,Object> result_2 = TaskReassignmentCtrl.fetchUsers('standarduser');
       Test.stopTest();
       System.assertNotEquals(result_1,null);
       
    }
    @IsTest
    public static void test_1(){
      setup();
      ApexPages.currentPage().getParameters().put('phaseName','');
       TaskReassignmentCtrl ctrl = new TaskReassignmentCtrl();
       Test.startTest();
       Test.stopTest();
       System.assertNotEquals(ctrl,null);
       
    }
}