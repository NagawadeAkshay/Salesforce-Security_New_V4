/**
 * Created by REI on 24-06-2020.
 */

@IsTest
private with sharing class TestFlexTableActionHandler {

     @IsTest
     private static void testAbstractMethod(){
         Test.startTest();
         SampleFlexTableActionHandler samplFlexTableObj = new SampleFlexTableActionHandler();
         samplFlexTableObj.whenClicked();
         Test.stopTest();
         System.assertNotEquals(null,samplFlexTableObj);
     }
}