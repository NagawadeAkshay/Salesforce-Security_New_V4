/**
    Test class for DynamicMessageHolder
    **********************************************************
    Audit History
    **********************************************************
    06-18-2014      Ryan Chadwick       added tests
    **********************************************************  
*/
@IsTest
public with sharing class TestDynamicMessageHolder {
    
 	public static Map<String,List<DynamicMessageHolder.Message>> stdStyleMsgListMap = new  Map<String,List<DynamicMessageHolder.Message>>();   	
 	public static Map<String,Boolean> trialMap = new Map<String,Boolean>();
    public static  PageLayoutConfig__c pl;
    public static  TabCOnfig__c tab;
    public static PageBlockConfig__c pb ;
    public static void setup(){
        pl = TestHelper.getPageLayoutConfig(true);
        tab = TestHelper.getTabConfig(pl.Id, true);
        pb = TestHelper.getPageBlockConfig(tab.Id, true);
      
    }
    @IsTest
    public static void testPageLayoutMessage(){
        //setup
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            TestHelper.createCustomSettings(true);
            String message = 'garbage';
            setup();
            MessageConfig__c newMsg = new MessageConfig__c();
            newMsg.MessageRich__c = message;           
            newMsg.PageLayoutConfig__c = pl.Id;
            newMsg.StandardStyle__c = 'Success';
            //execute
            Test.startTest();
            insert newMsg;
            DynamicMessageHolder msgholder = new DynamicMessageHolder(pl.Id,true,true,true,'project Admin',null);        
            DynamicMessageHolder.Message dmsg = new DynamicMessageHolder.Message();
            DynamicMessageHolder.processDynamicMessageRecords();
            system.assertEquals('',dmsg.message);
            system.assertEquals(pl.Id,msgholder.parentId);
            Test.stopTest();
            
       }
    }
    
    @IsTest
    public static void testPageBlockMessage(){
        //setup
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            TestHelper.createCustomSettings(true);
            String message = 'newMessage';
            setup();
            MessageConfig__c newMsg = new MessageConfig__c();
            newMsg.MessageRich__c = message;
            newMsg.PageBlockConfig__c = pb.Id;
            newMsg.StandardStyle__c = 'Success';
            //execute
            Test.startTest();
            insert newMsg;
            DynamicMessageHolder msgholder = new DynamicMessageHolder(pb.Id,true,true,true,'project Admin',null);
            system.assertEquals(pb.Id,msgholder.parentId);
            Test.stopTest();
            
        }
    }
    
    @IsTest
    public static void testUpdatedRender(){
        //setup
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            TestHelper.createCustomSettings(true);
            String message = 'garbage';
           setup();
            MessageConfig__c newMsg = new MessageConfig__c();
            newMsg.MessageRich__c = message;
            newMsg.PageLayoutConfig__c = pl.Id;
            newMsg.PageBlockConfig__c = pb.Id;
            newMsg.StandardStyle__c = 'Success';
            //execute
            Test.startTest();
            insert newMsg;
            SampleObject11__c obj_1 = TestHelper.getSampleObject1(true);
            SampleObject12__c obj_2 = TestHelper.getSampleObject2(true,obj_1.id);
            
            DynamicMessageHolder msgholder = new DynamicMessageHolder(pl.Id,true,true,true,'project Admin',null);
            system.assertEquals(pl.Id,msgholder.parentId);
            msgholder.updateRenderOnDecision(pl.ObjectAPIName__c, obj_2.Id, null);
            Test.stopTest();
            
        }
    }
    
     @IsTest
    public static void testUpdatedRender2(){
        //setup
        User u = TestHelper.getAdminUser(true);
        System.runAs(u){
            TestHelper.createCustomSettings(true);
            String message = 'garbage';
            setup();
            MessageConfig__c newMsg = new MessageConfig__c();
            newMsg.MessageRich__c = message;
            newMsg.PageLayoutConfig__c = pl.Id;
            newMsg.PageBlockConfig__c = pb.Id;
            newMsg.StandardStyle__c = 'Success';
            
            
            //execute
            Test.startTest();
            insert newMsg;
           
            DynamicMessageHolder msgholder = new DynamicMessageHolder(pl.Id,true,true,true,'project Admin',null);
            DynamicMessageHolder msgholder1 = new DynamicMessageHolder(pl.Id,true,true,true,'project Admin',null);
            
            system.assertEquals(pl.Id,msgholder.parentId);
            Test.stopTest();
            
        }
    }
}