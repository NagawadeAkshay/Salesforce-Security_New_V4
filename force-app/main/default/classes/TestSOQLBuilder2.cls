@isTest
private with sharing class TestSOQLBuilder2 {
    
    @isTest
    public static  void testfromx(){
        Test.startTest();
        SOQLBuilder2 soqlBuilder = new SOQLBuilder2().fromx('Contact');
        system.assert(soqlBuilder != null);
        Test.stopTest();
       
    }
    
    @isTest
    public static  void testselectx(){
        Test.startTest();
        SOQLBuilder2 soqlBuilder = new SOQLBuilder2().selectx('Name');
        system.assert(soqlBuilder != null);
        Test.stopTest();
       
    }
    
    @isTest
    public static  void testwherex(){
        Test.startTest();
        SOQLBuilder2 soqlBuilder = new SOQLBuilder2().wherex('Name','=','Test','');
        system.assert(soqlBuilder != null);
        Test.stopTest();
        
    }
    
    @isTest
    public static  void testtoSoql(){
        Test.startTest();
        SOQLBuilder2 soqlBuilder = new SOQLBuilder2();
         soqlBuilder.fromx('Contact');
        soqlBuilder.selectx('Name');
        soqlBuilder.wherex('Name','=','Test','');
        String soql = new SOQLBuilder2().toSoql();
        system.assert(soql != null);
        Test.stopTest();
        
    }
 
}