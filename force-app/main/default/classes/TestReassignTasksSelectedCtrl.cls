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
private with sharing class TestReassignTasksSelectedCtrl {

 	@isTest
    private static void test_1() {
    	TestHelper.createCustomSettings(true);
        TestHelper.getCustomAppConfig(true);
    	Task task = TestHelper.getTask(true);
    	List<String> selectedRecordIds_trial = new List<String>();
    	selectedRecordIds_trial.add(task.id);
    	Map<String, String> urlParams_trial = new Map<String, String>();
    	Id ownerId = UserInfo.getUserId();
    	Id targetUser = UserInfo.getUserId();
    	urlParams_trial.put('sourceUser',ownerId);
    	urlParams_trial.put('targetUser',ownerId);
    	ReassignTasksSelectedCtrl ctrl = new ReassignTasksSelectedCtrl();
    	Test.startTest();
    	ctrl.urlParams = urlParams_trial;
    	ctrl.selectedRecordIds = selectedRecordIds_trial; 
        ctrl.clickHandler();
        Test.stopTest();
        System.assert(ctrl != null);
    }
}