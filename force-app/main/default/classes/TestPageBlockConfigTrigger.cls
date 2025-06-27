@isTest
private with sharing class TestPageBlockConfigTrigger{
    
    @isTest
    static void testAll(){
  
       // PageLayoutConfig__c pl = TestHelper.getPageLayoutConfig(true);
        
        PageLayoutConfig__c pl = new PageLayoutConfig__c(Name='Test View Layout', Description__c='Test Page Layout',
                    ObjectAPIName__c='Opportunity');
       
        insert pl;
       
        TabConfig__c tab = TestHelper.getTabConfig(pl.Id,true) ;
        PageBlockConfig__c pb = new PageBlockConfig__c();
        pb.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Field History').getRecordTypeId(); 
        pb.SortOrder__c = 1;
        pb.TabLayoutConfig__c = tab.Id;
        insert pb;
        list <PageBlockConfig__c> pbc =[select id from PageBlockConfig__c];
        system.assertNotEquals(null, pbc);
    }
    
}