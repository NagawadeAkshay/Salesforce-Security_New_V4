@isTest
private with sharing class TestPageBlockDetailConfigTrigger{
    static PageBlockDetailConfig__c pbdc;
    public static void setUp(){
        PageLayoutConfig__c pl = TestHelper.getPageLayoutConfig(true);
        TabConfig__c tab = TestHelper.getTabConfig(pl.Id,true) ;
        PageBlockConfig__c pb = TestHelper.getPageBlockConfig(tab.Id,true);
        pbdc= TestHelper.getPageBlockDetailConfig(pb.Id,false); 
        insert pbdc;
        update pbdc;        
    }
   
    @isTest
    static void testAll(){
        Test.startTest();
            setUp();
        	System.assertEquals('Name', pbdc.FieldAPIName__c);
        Test.stopTest();
    }
}