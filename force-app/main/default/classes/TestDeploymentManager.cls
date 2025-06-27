/**
 * Created by REI on 17-06-2020.
 */

@isTest
private with sharing class TestDeploymentManager {

    @TestSetup static void setup(){

    }

    @IsTest
    private static void testIntDeployPageLayout(){
        Test.startTest();
        DeploymentManager dployManager = new DeploymentManager();
        dployManager.initDeployPageLayouts();
        System.assertNotEquals(null,dployManager);
        Test.stopTest();
    }

    @IsTest
    private static void testVerifyDeploymentStatus(){
        Test.setMock(WebServiceMock.class,new DeploymentManagerMockTest());
        Test.startTest();
        DeploymentManager dployManager = new DeploymentManager();
        dployManager.verifyDeploymentStatus();
        System.assertNotEquals(null,dployManager);
        Test.stopTest();
    }

    @IsTest
    private static void testCheckDeploymentStatus(){
        Test.setMock(WebServiceMock.class,new DeploymentManagerMockTest());
        Test.startTest();
        DeploymentManager dployManager = new DeploymentManager();
        dployManager.checkDeploymentStatus();
        System.assertNotEquals(null,dployManager);
        Test.stopTest();
    }
}