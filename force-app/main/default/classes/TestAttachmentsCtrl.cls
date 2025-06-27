/*
This class has methods to create charts according to object name.
******************************************************************
Audit History
******************************************************************
2018-10-22 Vaishnavi Tenkale Created
****************************************************************** 
*/

@isTest
private with sharing class TestAttachmentsCtrl{
    
    static  AttachmentsCtrl   attachmentsCtrlObj;
    static  Attachment   attachmentObj;
    static  SampleObject11__c  sampleObject11Obj;   
    static  PageLayoutConfig__c  pageLayoutConfigObj;
    static  PageAttachmentConfig__c pageAttachmentConfigObj;
    static  TabConfig__c tabConfigObj;
    static  AttachmentExtension__c  attachmentExtensionObj;
    static  PageBlockConfig__c  pageBlockConfigObj;
    static  SObjectConfig__c sObjectConfigObj;
    static String ns;
    
    // To Create Test Data  
    private static void setup(){    
        sampleObject11Obj = TestHelper.getSampleObject1(true);
        ns=AppUtils.getNameSpacePrefix();
        attachmentsCtrlObj = new AttachmentsCtrl();
        attachmentsCtrlObj.titleValue = attachmentsCtrlObj.namespace;
        attachmentsCtrlObj.classification = String.valueOf(attachmentsCtrlObj.timeOffset);
        attachmentsCtrlObj.parentObjectId = sampleObject11Obj.Id;
        
        attachmentObj = TestHelper.getAttachment(sampleObject11Obj.Id,true);
        attachmentObj.Name = 'New Attachment';
        attachmentObj.Body = Blob.valueOf('Test');
        attachmentObj.Description = 'Description';     
        update attachmentObj;           
        System.assertNotEquals(attachmentObj,null);
        
        Id actionConfId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Action config').getRecordTypeId(); 
        
        pageLayoutConfigObj = TestHelper.getPageLayoutConfig(true,'SampleObject11__c');        
        tabConfigObj = TestHelper.getTabConfig(pageLayoutConfigObj.Id,true);
        
        pageBlockConfigObj = TestHelper.getPageBlockConfig(tabConfigObj.id,true);
        
        attachmentsCtrlObj.PageBlockId = pageBlockConfigObj.Id;
        
        pageAttachmentConfigObj = TestHelper.getPageAttachmentConfig(pageBlockConfigObj.Id,true); 
        pageAttachmentConfigObj.AttachmentCount__c = 1;
        pageAttachmentConfigObj.RecordTypeId=actionConfId;
        pageAttachmentConfigObj.HideDecisionField__c= ns+'Status__c';
        pageAttachmentConfigObj.HideForContext__c='Create';
        pageAttachmentConfigObj.HideForProfile__c='PM';
        pageAttachmentConfigObj.HideForUser__c='Internal';
        pageAttachmentConfigObj.HideOperator__c='AND';
        update pageAttachmentConfigObj;      
        System.assertNotEquals(pageAttachmentConfigObj,null); 
        
        attachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',sampleObject11Obj.Id,true);     
        attachmentExtensionObj.Attachment__c = attachmentObj.Id;      
        update AttachmentExtensionObj;
        System.assertNotEquals(attachmentExtensionObj,null);
        
        //AttachmentsCtrl.fetchAttachments(sampleObject11Obj.Id, pageBlockConfigObj.Id, true, true, false);            
        AttachmentsCtrl.fetchAttachments(sampleObject11Obj.Id, pageBlockConfigObj.Id, true, true, false, false);
        AttachmentsCtrl.fetchAttachments(sampleObject11Obj.Id, pageBlockConfigObj.Id, true, true, true, false);
        AttachmentsCtrl.fetchAttachments(sampleObject11Obj.Id, pageBlockConfigObj.Id, false, true, false, true);
        AttachmentsCtrl.deleteAttchment(attachmentObj.Id);   
    }   
    
    @isTest
    //To test All Conditions where AttachmentEditHideExpressionJSON__c,AttachmentDeleteHideExpressionJSON__c value is required
    Private static void TestAttachmentsCtrl(){  
        Test.startTest();   
        sObjectConfigObj =  TestHelper.getSObjectConfig(true);            
        sObjectConfigObj.AttachmentEditHideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        sObjectConfigObj.AttachmentDeleteHideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        update sObjectConfigObj;
        System.assertNotEquals(sObjectConfigObj,null);
        setup();            
          sampleObject11Obj = TestHelper.getSampleObject1(true);
        ns=AppUtils.getNameSpacePrefix();
        attachmentsCtrlObj = new AttachmentsCtrl();
        attachmentsCtrlObj.titleValue = attachmentsCtrlObj.namespace;
        attachmentsCtrlObj.classification = String.valueOf(attachmentsCtrlObj.timeOffset);
        attachmentsCtrlObj.parentObjectId = sampleObject11Obj.Id;
        
        attachmentObj = TestHelper.getAttachment(sampleObject11Obj.Id,true);
        attachmentObj.Name = 'New Attachment';
        attachmentObj.Body = Blob.valueOf('Test');
        attachmentObj.Description = 'Description';     
        update attachmentObj;           
        System.assertNotEquals(attachmentObj,null);
        
        Id actionConfId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Action config').getRecordTypeId(); 
        
        pageLayoutConfigObj = TestHelper.getPageLayoutConfig(true,'SampleObject11__c');        
        tabConfigObj = TestHelper.getTabConfig(pageLayoutConfigObj.Id,true);
        
        pageBlockConfigObj = TestHelper.getPageBlockConfig(tabConfigObj.id,true);
        
        attachmentsCtrlObj.PageBlockId = pageBlockConfigObj.Id;
        
        pageAttachmentConfigObj = TestHelper.getPageAttachmentConfig(pageBlockConfigObj.Id,true); 
        pageAttachmentConfigObj.AttachmentCount__c = 1;
        pageAttachmentConfigObj.RecordTypeId=actionConfId;
        pageAttachmentConfigObj.HideDecisionField__c= ns+'Status__c';
        pageAttachmentConfigObj.HideForContext__c='Create';
        pageAttachmentConfigObj.HideForProfile__c='PM';
        pageAttachmentConfigObj.HideForUser__c='Internal';
        pageAttachmentConfigObj.HideOperator__c='AND';
        update pageAttachmentConfigObj;      
        System.assertNotEquals(pageAttachmentConfigObj,null); 
        
        attachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',sampleObject11Obj.Id,true);     
        attachmentExtensionObj.Attachment__c = attachmentObj.Id;      
        update AttachmentExtensionObj;
        System.assertNotEquals(attachmentExtensionObj,null);
        Map<String,object> result = new Map<String,object>();
        result= AttachmentsCtrl.fetchAttachments1(String.valueof(sampleObject11Obj.Id), String.valueof(pageBlockConfigObj.Id), true, true, false,false);            
        result=AttachmentsCtrl.fetchAttachments1(sampleObject11Obj.Id, pageBlockConfigObj.Id, true, true, false, false);
        result=AttachmentsCtrl.fetchAttachments1(sampleObject11Obj.Id, pageBlockConfigObj.Id, true, true, true, false);
        result=AttachmentsCtrl.fetchAttachments1(sampleObject11Obj.Id, pageBlockConfigObj.Id, false, true, false, true);
        Test.stopTest();             
        
    }
    @isTest
    // To test condition :AttachmentEditHideExpressionJSON__c == null
    Private static void TestAttachmentsCtrl1(){    
        
        Test.startTest();       
        sObjectConfigObj =  TestHelper.getSObjectConfig(true);    
        sObjectConfigObj.AttachmentDeleteHideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        update sObjectConfigObj;
        System.assertNotEquals(sObjectConfigObj,null);
        setup();
        Test.stopTest();             
        
    }  
    @isTest
    // To test condition :SObjectConfig__c == null
    Private static void TestAttachmentsCtrl2(){            
        Test.startTest();       
        sObjectConfigObj =  TestHelper.getSObjectConfig(false);           
        setup();
        Test.stopTest();         
        System.assertNotEquals(sObjectConfigObj,null);   
    }   
}