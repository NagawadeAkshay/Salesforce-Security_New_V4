@isTest
private with sharing class TestWBSTaskScheduleTrigger{
  
    @isTest
    private static void TestStatusForPastDate(){
        list<WBSTaskSchedule__c> wbsLista = new list<WBSTaskSchedule__c>();
        wbsLista.add(new WBSTaskSchedule__c(Name = 'WBS task', StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
       insert  wbsLista;
        for(WBSTaskSchedule__c wbsObj : wbsLista ){
            wbsObj.EndDate__c  = wbsObj.EndDate__c.addDays(-10);
        }
        test.startTest();
        update wbsLista ;
        test.stopTest();
        for(WBSTaskSchedule__c updatedWBSObj : wbsLista ){
            system.assertNotequals('Incomplete', updatedWBSObj.Status__c );
        }
    }
    @isTest
    private static void TestStatusForProgressCheck(){
         list<WBSTaskSchedule__c> wbsListab = new list<WBSTaskSchedule__c>();
        wbsListab.add(new WBSTaskSchedule__c(Name = 'WBS task', StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
       insert  wbsListab;
        list<WBSTaskSchedule__c> wbsLista = new list<WBSTaskSchedule__c>();
        wbsLista.add(new WBSTaskSchedule__c(Name = 'WBS task1',ProgressIndicator__c = 10, ParentWBSTaskSchedule__c = wbsListab[0].id,StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
        insert wbsLista ;
        for(WBSTaskSchedule__c wbsObj : wbsLista ){
            wbsObj.EndDate__c  = wbsObj.EndDate__c.addDays(-10);
        }
        test.startTest();
        update wbsLista ;
        test.stopTest();
        for(WBSTaskSchedule__c updatedWBSObj : wbsLista ){
            system.assertNotequals('Incomplete', updatedWBSObj.Status__c );
        }
    }
    @isTest
    private static void TestForProgressCheck(){
         list<WBSTaskSchedule__c> wbsListab = new list<WBSTaskSchedule__c>();
        wbsListab.add(new WBSTaskSchedule__c(Name = 'WBS task', StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
       insert  wbsListab;
        list<WBSTaskSchedule__c> wbsLista = new list<WBSTaskSchedule__c>();
        wbsLista.add(new WBSTaskSchedule__c(Name = 'WBS task1',ProgressIndicator__c = 10, ParentWBSTaskSchedule__c = wbsListab[0].id,StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
        insert wbsLista ;
        for(WBSTaskSchedule__c wbsObj : wbsLista ){
            wbsObj.ProgressIndicator__c  = 100;
        }
        test.startTest();
        update wbsLista ;
        test.stopTest();
        for(WBSTaskSchedule__c updatedWBSObj : wbsLista ){
            system.assertNotequals('Complete', updatedWBSObj.Status__c );
        }
    }
    @isTest
    private static void TestForStartAndEndDate(){
         list<WBSTaskSchedule__c> wbsListab = new list<WBSTaskSchedule__c>();
        wbsListab.add(new WBSTaskSchedule__c(Name = 'WBS task', StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
       insert  wbsListab;
        list<WBSTaskSchedule__c> wbsLista = new list<WBSTaskSchedule__c>();
        wbsLista.add(new WBSTaskSchedule__c(Name = 'WBS task1',ProgressIndicator__c = 10, ParentWBSTaskSchedule__c = wbsListab[0].id,StartDate__c = date.today().addDays(-1), EndDate__c = date.today().addDays(10), Milestone__c = false, Status__c = 'New'));
        insert wbsLista ;
        for(WBSTaskSchedule__c wbsObj : wbsLista ){
            wbsObj.ProgressIndicator__c  = 100;
        }
        test.startTest();
        update wbsLista ;
        test.stopTest();
        List<WBSTaskSchedule__c> parentList = [SELECT id, StartDate__c, EndDate__c FROM WBSTaskSchedule__c WHERE Id =: wbsListab[0].Id];
        for(WBSTaskSchedule__c updatedWBSObj : parentList ){
            system.assertequals(date.today().addDays(-1), updatedWBSObj.StartDate__c );
            system.assertequals(date.today().addDays(10), updatedWBSObj.EndDate__c );
        }
    }
    @isTest
    private static void TestDeleteWBSrecord(){
         list<WBSTaskSchedule__c> wbsListab = new list<WBSTaskSchedule__c>();
        wbsListab.add(new WBSTaskSchedule__c(Name = 'WBS task', StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
       insert  wbsListab;
        list<WBSTaskSchedule__c> wbsLista = new list<WBSTaskSchedule__c>();
        wbsLista.add(new WBSTaskSchedule__c(Name = 'WBS task1',ProgressIndicator__c = 10, ParentWBSTaskSchedule__c = wbsListab[0].id,StartDate__c = date.today().addDays(-1), EndDate__c = date.today().addDays(10), Milestone__c = false, Status__c = 'New'));
        insert wbsLista ;
        List<WBSTaskSchedule__c> parentList = [SELECT id, StartDate__c, EndDate__c FROM WBSTaskSchedule__c WHERE Id =: wbsListab[0].Id];
        for(WBSTaskSchedule__c updatedWBSObj : parentList ){
            system.assertequals(date.today().addDays(-1), updatedWBSObj.StartDate__c );
            system.assertequals(date.today().addDays(10), updatedWBSObj.EndDate__c );
        }      
        test.startTest();
        delete wbsLista ;
        test.stopTest();
        List<WBSTaskSchedule__c> parentListafterDelete = [SELECT id, StartDate__c, EndDate__c FROM WBSTaskSchedule__c WHERE Id =: wbsListab[0].Id];
        for(WBSTaskSchedule__c updatedWBSObj : parentListafterDelete ){
            system.assertequals(null, updatedWBSObj.StartDate__c );
            system.assertequals(null, updatedWBSObj.EndDate__c );
        } 
    }
	 @isTest
    private static void TestUnDeleteWBSrecord(){
         list<WBSTaskSchedule__c> wbsListab = new list<WBSTaskSchedule__c>();
        wbsListab.add(new WBSTaskSchedule__c(Name = 'WBS task', StartDate__c = date.today(), EndDate__c = date.today().addDays(5), Milestone__c = false, Status__c = 'New'));
       insert  wbsListab;
        list<WBSTaskSchedule__c> wbsLista = new list<WBSTaskSchedule__c>();
        wbsLista.add(new WBSTaskSchedule__c(Name = 'WBS task1',ProgressIndicator__c = 10, ParentWBSTaskSchedule__c = wbsListab[0].id,StartDate__c = date.today().addDays(-1), EndDate__c = date.today().addDays(10), Milestone__c = false, Status__c = 'New'));
        insert wbsLista ;
        List<WBSTaskSchedule__c> parentList = [SELECT id, StartDate__c, EndDate__c FROM WBSTaskSchedule__c WHERE Id =: wbsListab[0].Id];
        for(WBSTaskSchedule__c updatedWBSObj : parentList ){
            system.assertequals(date.today().addDays(-1), updatedWBSObj.StartDate__c );
            system.assertequals(date.today().addDays(10), updatedWBSObj.EndDate__c );
        }    
		delete wbsLista ;		
        test.startTest();
        undelete wbsLista ;
        test.stopTest();
        List<WBSTaskSchedule__c> parentListafterDelete = [SELECT id, StartDate__c, EndDate__c FROM WBSTaskSchedule__c WHERE Id =: wbsListab[0].Id];
        for(WBSTaskSchedule__c updatedWBSObj : parentListafterDelete ){
            system.assertequals(date.today().addDays(-1), updatedWBSObj.StartDate__c );
            system.assertequals(date.today().addDays(10), updatedWBSObj.EndDate__c );
        } 
    }
}