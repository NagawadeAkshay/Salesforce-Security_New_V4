/*
This class has methods to create charts according to object name.
******************************************************************
Audit History
******************************************************************
2018-10-30 Vaishnavi Tenkale Created
****************************************************************** 
*/

@isTest
private class TestAttachmentEditCtrl {
    static AttachmentEditCtrl attachmentEditCtrlObj;
    static AttachmentExtension__c attachmentExtensionObj;
    static PageBlockConfig__c pageBlockConfigObj;
    Static Attachment attachmentObj;
    static SObjectConfig__c sobjectConfigObj;
    static SampleObject11__c SampleObject11Obj;
    static PageLayoutConfig__c PageLayoutConfigObj;
    static TabConfig__c TabConfigObj;
    static PageAttachmentConfig__c PageAttachmentConfigObj;
    
    //Setup Data for testing
    private static void setup(){
        
        sobjectConfigObj =  TestHelper.getSObjectConfig(true);
        Case caseObj = new Case();
        caseObj.Origin = 'Phone';
        insert caseObj;
        System.assertNotEquals(caseObj,null); 
        
        SampleObject11Obj=TestHelper.getSampleObject1(true);  
        System.assertNotEquals(SampleObject11Obj,null); 
        
        AttachmentObj = TestHelper.getAttachment(caseObj.Id,true);
        AttachmentObj.Name = 'New Attachment';
        AttachmentObj.Body = Blob.valueOf('Test');
        AttachmentObj.Description = 'Description';     
        update AttachmentObj;
        System.assertNotEquals(AttachmentObj,null);
        
        AttachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',SampleObject11Obj.Id,true); 
        AttachmentExtensionObj.Attachment__c = AttachmentObj.Id;          
        AttachmentExtensionObj.Description__c='test';
        update AttachmentExtensionObj;
        System.assertNotEquals(AttachmentExtensionObj,null);
        
        PageLayoutConfigObj = TestHelper.getPageLayoutConfig(true);
        TabConfigObj = TestHelper.getTabConfig(PageLayoutConfigObj.Id, true);
        
        PageBlockConfigObj = TestHelper.getPageBlockConfig(TabConfigObj.Id, true);
        String pageblockId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('pBlockId'));        
        update PageBlockConfigObj;
        System.assertNotEquals(PageBlockConfigObj,null); 
        
        PageAttachmentConfigObj = TestHelper.getPageAttachmentConfig(PageBlockConfigObj.Id,true);       
        PageAttachmentConfigObj.AttachmentCount__c = -12;
        PageAttachmentConfigObj.MaximumAttachmentCount__c = -11;     
        update PageAttachmentConfigObj;      
        System.assertNotEquals(PageAttachmentConfigObj,null); 
    }
    
    //To test AttachmentEditCtrl() , getClassificationOptionList(),   getWrapperAttachment();
    
    @isTest
    private static void TestAttachmentEditCtrl(){ 
        Test.startTest();
        setup();
        apexpages.currentpage().getparameters().put('attachmentId',AttachmentObj.id);            
        apexpages.currentpage().getparameters().put('classification','a;b;c;d');
        ApexPages.currentPage().getParameters().put('parentId',  SampleObject11Obj.id); 
        ApexPages.currentPage().getParameters().put('pBlockId',  PageBlockConfigObj.id);
        
        PageBlockConfigObj.AttachmentClassifications__c='other';
        PageBlockConfigObj.ClassificationFieldAPIName__c='SampleText1__c';
        update PageBlockConfigObj ;
        System.assertNotEquals(PageBlockConfigObj,null); 
        
        attachmentEditCtrlObj= new AttachmentEditCtrl();
        
        sobjectConfigObj.AttachmentClassifications__c = 'other';      
        sobjectConfigObj.Name = SampleObject11Obj.Name;
        update sobjectConfigObj;
        System.assertNotEquals(sobjectConfigObj,null); 
        
        PageBlockConfigObj.AdditionalFieldJSON__c='[{"requiredField": true,"fieldName": "Description__c","fieldLabel": "gsdaj"}]';
        update PageBlockConfigObj;
        System.assertNotEquals(PageBlockConfigObj,null); 
        
        System.currentPageReference().getParameters().put('id', 'a;b;c;d');
        attachmentEditCtrlObj= new AttachmentEditCtrl();
         SampleObject11Obj=TestHelper.getSampleObject1(true);  
        System.assertNotEquals(SampleObject11Obj,null); 
        
        sobjectConfigObj =  TestHelper.getSObjectConfig(true);
        Case caseObj = new Case();
        caseObj.Origin = 'Phone';
        insert caseObj;
        System.assertNotEquals(caseObj,null);         
        AttachmentObj = TestHelper.getAttachment(caseObj.Id,true);
        AttachmentObj.Name = 'New Attachment';
        AttachmentObj.Body = Blob.valueOf('Test');
        AttachmentObj.Description = 'Description';     
        update AttachmentObj;
        System.assertNotEquals(AttachmentObj,null);
        PageBlockConfigObj = TestHelper.getPageBlockConfig(TabConfigObj.Id, true);
        String pageblockId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('pBlockId'));
        Map<String, Object> result = AttachmentEditCtrl.getAttachmentDetails(AttachmentObj.id,SampleObject11Obj.id, PageBlockConfigObj.id,'test','');
        System.assertNotEquals(result,null); 
        Test.stopTest();        
    }
    
    //To test UpdateAttachment()
    @isTest
    private static void TestupdateAttachment(){ 
        Test.startTest();
        setup();             
        //without attachmentId
        attachmentEditCtrlObj= new AttachmentEditCtrl();
        apexpages.currentpage().getparameters().put('attachmentId',AttachmentObj.id);  
        ApexPages.currentPage().getParameters().put('parentId',  SampleObject11Obj.id);  
        
        attachmentEditCtrlObj= new AttachmentEditCtrl(); 
        attachmentEditCtrlObj.updateAttachment();
        
        SampleObject11Obj=TestHelper.getSampleObject1(true);  
        System.assertNotEquals(SampleObject11Obj,null); 
        Case caseObj = new Case();
        caseObj.Origin = 'Phone';
        insert caseObj;
        System.assertNotEquals(caseObj,null); 
        AttachmentObj = TestHelper.getAttachment(caseObj.Id,true);
        AttachmentObj.Name = 'New Attachment';
        AttachmentObj.Body = Blob.valueOf('Test');
        AttachmentObj.Description = 'Description';     
        update AttachmentObj;
        System.assertNotEquals(AttachmentObj,null);
        
        AttachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',SampleObject11Obj.Id,true); 
        AttachmentExtensionObj.Attachment__c = AttachmentObj.Id;          
        AttachmentExtensionObj.Description__c='test';
        update AttachmentExtensionObj;
        System.assertNotEquals(AttachmentExtensionObj,null);
        
        PageLayoutConfigObj = TestHelper.getPageLayoutConfig(true);
        TabConfigObj = TestHelper.getTabConfig(PageLayoutConfigObj.Id, true);
        
        PageBlockConfigObj = TestHelper.getPageBlockConfig(TabConfigObj.Id, true);
        String pageblockId = SFDCEncoder.SFDC_JSENCODE(apexpages.currentpage().getparameters().get('pBlockId'));        
        update PageBlockConfigObj;
        System.assertNotEquals(PageBlockConfigObj,null); 
        
        AttachmentEditCtrl.updateAttachmentLWC(SampleObject11Obj.id, AttachmentObj,'test',false);
        Test.stopTest();        
    }
    
    //To test processSelected()
    @isTest    
    public static void TestprocessSelected(){ 
        Test.startTest();
        setup();    
        apexpages.currentpage().getparameters().put('attachmentId',AttachmentObj.id);  
        ApexPages.currentPage().getParameters().put('parentId',  SampleObject11Obj.id);  
        
        AttachmentEditCtrl.wrapAttachment wraAtt = new AttachmentEditCtrl.wrapAttachment(attachmentobj);
        attachmentEditCtrlObj= new AttachmentEditCtrl();
    
        attachmentEditCtrlObj.processSelected();
        attachmentEditCtrlObj.attachmentObj = attachmentobj;
        if(attachmentEditCtrlObj.wrapAttachmentList.size() >0)
        attachmentEditCtrlObj.wrapAttachmentList[0].selected=true;
        attachmentEditCtrlObj.processSelected();

        Case caseObj = new Case();
        caseObj.Origin = 'Phone';
        insert caseObj;
         SampleObject11Obj=TestHelper.getSampleObject1(true);  
         AttachmentObj = TestHelper.getAttachment(caseObj.Id,true);
        AttachmentObj.Name = 'New Attachment';
        AttachmentObj.Body = Blob.valueOf('Test');
        AttachmentObj.Description = 'Description';     
        update AttachmentObj;
         AttachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',SampleObject11Obj.Id,true); 
        AttachmentExtensionObj.Attachment__c = AttachmentObj.Id;          
        AttachmentExtensionObj.Description__c='test';
        update AttachmentExtensionObj;
        List<Id> attId = new List<Id>();
        attId.add(AttachmentObj.id);
        AttachmentEditCtrl.processSelectedLWC(attId,SampleObject11Obj.id,AttachmentObj.id);
        attachmentEditCtrlObj.updateAttachmentCloseModal();
        Test.stopTest(); 
        system.assertNotEquals(null,attId); 
    }

    @isTest    
    public static void TestprocessSelected1(){ 
        Test.startTest();
        setup();    
        apexpages.currentpage().getparameters().put('attachmentId',AttachmentObj.id);  
        ApexPages.currentPage().getParameters().put('parentId',  SampleObject11Obj.id);  
        
        AttachmentEditCtrl.wrapAttachment wraAtt = new AttachmentEditCtrl.wrapAttachment(attachmentobj);
        attachmentEditCtrlObj= new AttachmentEditCtrl();
    
        attachmentEditCtrlObj.processSelected1();
        attachmentEditCtrlObj.attachmentObj = attachmentobj;
        if(attachmentEditCtrlObj.wrapAttachmentList.size() >0)
        attachmentEditCtrlObj.wrapAttachmentList[0].selected=true;
        attachmentEditCtrlObj.processSelected1();

        Case caseObj = new Case();
        caseObj.Origin = 'Phone';
        insert caseObj;
         SampleObject11Obj=TestHelper.getSampleObject1(true);  
         AttachmentObj = TestHelper.getAttachment(caseObj.Id,true);
        AttachmentObj.Name = 'New Attachment';
        AttachmentObj.Body = Blob.valueOf('Test');
        AttachmentObj.Description = 'Description';     
        update AttachmentObj;
         AttachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',SampleObject11Obj.Id,true); 
        AttachmentExtensionObj.Attachment__c = AttachmentObj.Id;          
        AttachmentExtensionObj.Description__c='test';
        update AttachmentExtensionObj;
        List<Id> attId = new List<Id>();
        attId.add(AttachmentObj.id);
        AttachmentEditCtrl.processSelectedLWC(attId,SampleObject11Obj.id,AttachmentObj.id);
        attachmentEditCtrlObj.updateAttachmentCloseModal();
        Test.stopTest(); 
    }
    
     @isTest    
    public static void TestprocessSelected2(){ 
        Test.startTest();
        setup();    
        apexpages.currentpage().getparameters().put('attachmentId',AttachmentObj.id);  
        ApexPages.currentPage().getParameters().put('parentId',  SampleObject11Obj.id);  
        
        AttachmentEditCtrl.wrapAttachment wraAtt = new AttachmentEditCtrl.wrapAttachment(attachmentobj);
        attachmentEditCtrlObj= new AttachmentEditCtrl();
    
        attachmentEditCtrlObj.processSelected2();
        attachmentEditCtrlObj.attachmentObj = attachmentobj;
        if(attachmentEditCtrlObj.wrapAttachmentList.size() >0)
        attachmentEditCtrlObj.wrapAttachmentList[0].selected=true;
        attachmentEditCtrlObj.processSelected2();

        Case caseObj = new Case();
        caseObj.Origin = 'Phone';
        insert caseObj;
         SampleObject11Obj=TestHelper.getSampleObject1(true);  
         AttachmentObj = TestHelper.getAttachment(caseObj.Id,true);
        AttachmentObj.Name = 'New Attachment';
        AttachmentObj.Body = Blob.valueOf('Test');
        AttachmentObj.Description = 'Description';     
        update AttachmentObj;
         AttachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',SampleObject11Obj.Id,true); 
        AttachmentExtensionObj.Attachment__c = AttachmentObj.Id;          
        AttachmentExtensionObj.Description__c='test';
        update AttachmentExtensionObj;
        List<Id> attId = new List<Id>();
        attId.add(AttachmentObj.id);
        AttachmentEditCtrl.processSelectedLWC(attId,SampleObject11Obj.id,AttachmentObj.id);
        attachmentEditCtrlObj.updateAttachmentCloseModal();
        Test.stopTest(); 
    }

    @isTest
    static void testUpdateAttachmentCloseModalLWC() {
        AttachmentEditCtrl.updateAttachmentCloseModalLWC();
        System.assertEquals(true, AttachmentEditCtrl.isSaveCloseLWC);
        AttachmentEditCtrl ctrl = new AttachmentEditCtrl();
        ctrl.classification = 'Test Classification';
        System.assertNotEquals(null,ctrl.classification);
    }
}