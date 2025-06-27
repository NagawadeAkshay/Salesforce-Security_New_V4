@IsTest
private with sharing class TestAccordionTrigger {

    private static List<AccordionContent__c> contentList;
    private static void setup(){    
         PhaseConfig__c phase = TestHelper.getPhase(true);         
         AccordionHeader__c header = TestHelper.getAccordionHeader(phase.id,true);
         AccordionSubHeader__c subHeader = TestHelper.getAccordionSubHeader(header.id,true);
         update subHeader;
         AccordionContent__c content = TestHelper.getAccordionContent(subHeader.id,false);
         contentList = new List<AccordionContent__c>();
         contentList.add(content);   
         insert contentList;         
    }
    
    @isTest
    public static void testBeforeInsert(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            Test.startTest();
                setup();                
            Test.stopTest();                    
        }
        System.assertNotEquals(contentList,null);
    }
    


    @isTest
    public static void testBeforeUpdate(){
        User u = TestHelper.getAdminUser(true);
        AccordionContent__c content;
        System.runAs(u){
            Test.startTest();
             PhaseConfig__c phase = TestHelper.getPhase(true);
             AccordionHeader__c header = TestHelper.getAccordionHeader(phase.id,true);
             AccordionSubHeader__c subHeader = TestHelper.getAccordionSubHeader(header.id,true);
             content = TestHelper.getAccordionContent(subHeader.id,false);            
             insert content;
             update content;
           Test.stopTest();         
        }
         System.assertNotEquals(content,null);
    }
    
    
    
}