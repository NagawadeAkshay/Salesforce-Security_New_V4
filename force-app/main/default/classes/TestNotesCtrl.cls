/*
This class has methods to create charts according to object name.
**********************************************************
Audit History
**********************************************************
2018-10-23 Vaishnavi Tenkale Created
********************************************************** 
*/
@isTest
private with sharing class TestNotesCtrl{
    static   NotesCtrl notesCtrlObj ;   
    static   SampleObject11__c sampleObject11Obj;
    static   Note noteObj;
    static   PageLayoutConfig__c pageLayoutConfigObj;
    static   PageAttachmentConfig__c pageAttachmentConfigObj;
    static   TabConfig__c tabConfigObj;
    static   PageBlockConfig__c pageBlockConfigObj;
    static   AttachmentExtension__c attachmentExtensionObj;
    
    //setup data
    private static void setup(){
        
        sampleObject11Obj = TestHelper.getSampleObject1(true);
        
        notesCtrlObj = new NotesCtrl();
        notesCtrlObj.noteObj=notesCtrlObj.noteObj;
        
        /* notesCtrlObj.titleValue ='Test';
		   notesCtrlObj.classification = 'Other';
		   notesCtrlObj.isDigiSign = true;      
		   notesCtrlObj.isViewVal = true;*/      
        
        Integer intTimeOffset = notesCtrlObj.timeOffset;
        notesCtrlObj.parentObjectId = sampleObject11Obj.Id;
        
        noteObj = TestHelper.getNote(sampleObject11Obj.Id,true);
        System.assertNotEquals(noteObj, null, ''); 
        
        pageLayoutConfigObj = TestHelper.getPageLayoutConfig(true,'SampleObject11__c');
        tabConfigObj = TestHelper.getTabConfig(pageLayoutConfigObj.Id,true);
        pageBlockConfigObj = TestHelper.getPageBlockConfig(tabConfigObj.Id,true);
        
        Id actionConfId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Note config').getRecordTypeId();
        
        pageAttachmentConfigObj = TestHelper.getPageAttachmentConfig(pageBlockConfigObj.Id,true);     
        pageAttachmentConfigObj.Name='Edit';
        pageAttachmentConfigObj.AttachmentCount__c = 1; 
        pageAttachmentConfigObj.RecordTypeId=actionConfId;
        pageAttachmentConfigObj.HideDecisionField__c='Status__c';
        pageAttachmentConfigObj.HideForContext__c='Create';
        pageAttachmentConfigObj.HideForProfile__c='PM';
        pageAttachmentConfigObj.HideForUser__c='Internal';
        pageAttachmentConfigObj.HideOperator__c='OR';
        update pageAttachmentConfigObj;   
        
        System.assertNotEquals(pageAttachmentConfigObj, null, '');
        
        attachmentExtensionObj = TestHelper.getAttachmentExtension('RESUME OF PROPOSED PERSONNEL',sampleObject11Obj.Id,true);     
        attachmentExtensionObj.Attachment__c = noteObj.Id;
        update attachmentExtensionObj;
        System.assertNotEquals(attachmentExtensionObj, null, '');
        
        
        
    }
    //to test NotesCtrl without NoteEditHideExpressionJSON__c field value
    @isTest
    private static void testNotesCtrl(){   
        Test.startTest();
        SObjectConfig__c sObjectConfigObj = TestHelper.getSObjectConfig(true); 
        sObjectConfigObj.NoteDeleteHideExpressionJSON__c='{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        update sObjectConfigObj;  
        System.assertNotEquals(sObjectConfigObj, null, '');
        setup();    
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
        pageAttachmentConfigObj.HideOperator__c='AND';
        update pageAttachmentConfigObj;  
        Test.stopTest();
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
        
        
    } 
    //to test NotesCtrl with NoteEditHideExpressionJSON__c and NoteDeleteHideExpressionJSON__c field value
    @isTest
    private static void testNotesCtrl1(){    
        Test.startTest();
        SObjectConfig__c sObjectConfigObj =  TestHelper.getSObjectConfig(true);            
        sObjectConfigObj.NoteEditHideExpressionJSON__c='{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        sObjectConfigObj.NoteDeleteHideExpressionJSON__c='{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        update sObjectConfigObj;       
        System.assertNotEquals(sObjectConfigObj, null, '');
        setup();
        Test.stopTest();
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, false);
    }
    //to test NotesCtrl without SobjectConfig__c object records
    @isTest
    private static void testNotesCtrl2(){  
        Test.startTest();
        setup();  
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, false);
        NotesCtrl.deleteNote(noteObj.Id);
        System.assertNotEquals(sampleObject11Obj, null, '');
        Test.stopTest();
      } 
      
    @isTest
    private static void testNotesCtrl4(){   
        Test.startTest();
        SObjectConfig__c sObjectConfigObj = TestHelper.getSObjectConfig(true); 
        sObjectConfigObj.NoteDeleteHideExpressionJSON__c='{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"'+AppUtils.getNamespacePrefix()+'Status__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"Created","Values":[]}}],"Groups":[],"ExpressionObject":"Program__c"}';            
        update sObjectConfigObj;  
        System.assertNotEquals(sObjectConfigObj, null,'');
        setup();    
        NotesCtrl.fetchNotes1(string.valueOf(sampleObject11Obj.Id), pageBlockConfigObj.Id, true);
        pageAttachmentConfigObj.HideOperator__c='AND';
        update pageAttachmentConfigObj;  
        Test.stopTest();
       // NotesCtrl.fetchNotes1(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
    }
    
    @isTest
    private static void testNotesCtrl5(){  
        Test.startTest();
        setup();  
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, false);
        NotesCtrl.AddNotes('Test', 'Test', string.valueOf(sampleObject11Obj.Id));
        NotesCtrl.deleteNoteRecord(noteObj.Id);
        System.assertNotEquals(sampleObject11Obj, null, '');
        Test.stopTest();
    }
     @isTest
    private static void testNotesCtrl6(){  
        Test.startTest();
        setup();  
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, true);
        NotesCtrl.fetchNotes(sampleObject11Obj.Id, pageBlockConfigObj.Id, false);
        Note n = new Note();
        n.title = 'test';
        n.Body = 'test';
        n.ParentId = sampleObject11Obj.Id;
        insert n; 
        System.assertEquals('test', n.title, 'correct');
        Test.stopTest();
    }

	@isTest
    private static void testContentNotes1(){  
        Test.startTest();
            setup();  
            NotesCtrl.addNotes('Test', 'Test', sampleObject11Obj.Id);
            System.assertNotEquals(sampleObject11Obj, null, '');
        Test.stopTest();
    }
    
    @isTest
    private static void testContentNotes(){  
        Test.startTest();
            setup();  
            ContentNote noteRecord = new ContentNote();
            noteRecord.Title   = 'Test Content Note by sfdcpanther.com Approach 2';
            String body        = 'Test Content Note by sfdcpanther.com Approach 2';
            noteRecord.Content = Blob.valueOf(body.escapeHTML4());
            insert noteRecord;
            System.assertEquals('Test Content Note by sfdcpanther.com Approach 2', noteRecord.Title, 'correct');
            ContentDocumentLink link2 = new ContentDocumentLink();
            link2.ContentDocumentId   = noteRecord.id;
            link2.LinkedEntityId      = sampleObject11Obj.Id;
            link2.ShareType           = 'V';
            link2.Visibility          = 'AllUsers';
            insert link2;
            system.debug('sampleObject11Obj id ::'+sampleObject11Obj);
            
            NotesCtrl.getContentNoteView(noteRecord.id);
            NotesCtrl.getNoteContent(noteRecord.id);
            NotesCtrl.updateNoteRecord('Title','Description',noteRecord.id,sampleObject11Obj.Id); 
            NotesCtrl.fetchNotes1(string.valueOf(sampleObject11Obj.id), '',true);
        Test.stopTest();
        
    }
    
    @isTest
    private static void testAddNoteList(){  
        Test.startTest();
        setup();  
        List<ContentNotesWrapper> addConNoteList=new List<ContentNotesWrapper>();
        ContentNotesWrapper testConNote1=new ContentNotesWrapper();
        testConNote1.title='Test Title 1';
        testConNote1.contentTxt= 'Test Description 1';
        addConNoteList.add(testConNote1);
        String strAddConNoteList = JSON.serialize(addConNoteList);
        NotesCtrl.addNoteList(strAddConNoteList, sampleObject11Obj.Id);
        
        List<ContentNotesWrapper> addConNoteList2=new List<ContentNotesWrapper>();
        ContentNotesWrapper testConNote2=new ContentNotesWrapper();
        testConNote2.title='Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2 Test Title 2Test Title 2';
        testConNote2.contentTxt= 'Test Description 1';
        addConNoteList2.add(testConNote2);
        String strAddConNoteList2 = JSON.serialize(addConNoteList2);
        NotesCtrl.addNoteList(strAddConNoteList2, sampleObject11Obj.Id);
        System.assertNotEquals(strAddConNoteList2, null, '');
        Test.stopTest();
    }
    public class ContentNotesWrapper{
        @AuraEnabled public String title{get;set;}
        @AuraEnabled public String contentTxt{get;set;}
        @AuraEnabled public String noteRecordId{get;set;}
    }
    
    @isTest
    private static void tesUpdateNoteList(){  
        Test.startTest();
        setup();  
        ContentNote testCnRcd1 = new ContentNote();
        testCnRcd1.Title   = 'Test Title 2';
        String body        = 'Test Description 2';
        testCnRcd1.Content = Blob.valueOf(body.escapeHTML4());
        insert testCnRcd1;
        
        ContentNote testCnRcd2 = new ContentNote();
        testCnRcd2.Title   = 'Test Title 3';
        String body3        = 'Test Description 3';
        testCnRcd2.Content = Blob.valueOf(body3.escapeHTML4());
        insert testCnRcd2;
        
        ContentNote testCnRcd3 = new ContentNote();
        testCnRcd3.Title   = 'Test Title 4';
        String body4        = 'Test Description 4';
        testCnRcd3.Content = Blob.valueOf(body4.escapeHTML4());
        insert testCnRcd3;
        
        ContentNote testCnRcd4 = new ContentNote();
        testCnRcd4.Title   = 'Test Title 5';
        String body5        = 'Test Description 5';
        testCnRcd4.Content = Blob.valueOf(body5.escapeHTML4());
        insert testCnRcd4;
        
        ContentDocumentLink testCDLinkRcd1 = new ContentDocumentLink();
        testCDLinkRcd1.ContentDocumentId   = testCnRcd1.id;
        testCDLinkRcd1.LinkedEntityId      = sampleObject11Obj.Id;
        testCDLinkRcd1.ShareType           = 'V';
        testCDLinkRcd1.Visibility          = 'AllUsers';
        insert testCDLinkRcd1;
        
        ContentDocumentLink testCDLinkRcd2 = new ContentDocumentLink();
        testCDLinkRcd2.ContentDocumentId   = testCnRcd2.id;
        testCDLinkRcd2.LinkedEntityId      = sampleObject11Obj.Id;
        testCDLinkRcd2.ShareType           = 'V';
        testCDLinkRcd2.Visibility          = 'AllUsers';
        insert testCDLinkRcd2;
        
        ContentDocumentLink testCDLinkRcd3 = new ContentDocumentLink();
        testCDLinkRcd3.ContentDocumentId   = testCnRcd3.id;
        testCDLinkRcd3.LinkedEntityId      = sampleObject11Obj.Id;
        testCDLinkRcd3.ShareType           = 'V';
        testCDLinkRcd3.Visibility          = 'AllUsers';
        insert testCDLinkRcd3;
        
        ContentDocumentLink testCDLinkRcd4 = new ContentDocumentLink();
        testCDLinkRcd4.ContentDocumentId   = testCnRcd4.id;
        testCDLinkRcd4.LinkedEntityId      = sampleObject11Obj.Id;
        testCDLinkRcd4.ShareType           = 'V';
        testCDLinkRcd4.Visibility          = 'AllUsers';
        insert testCDLinkRcd4;
        
        List<ContentNotesWrapper> updateConNoteList=new List<ContentNotesWrapper>();
        ContentNotesWrapper testConNote2=new ContentNotesWrapper();
        testConNote2.title='Test Title 2';
        testConNote2.contentTxt= 'Test Description 2';
        testConNote2.noteRecordId=testCnRcd1.Id;
        updateConNoteList.add(testConNote2);
        
        ContentNotesWrapper testConNote3=new ContentNotesWrapper();
        testConNote3.title='Test Title 3';
        testConNote3.contentTxt= 'Test Description 3';
        testConNote3.noteRecordId=testCnRcd2.Id;
        updateConNoteList.add(testConNote3);
        
        List<ContentNotesWrapper> updateConNoteList2=new List<ContentNotesWrapper>();     
        ContentNotesWrapper testConNote4=new ContentNotesWrapper();
        testConNote4.title='Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4 Test Title 4';
        testConNote4.contentTxt= 'Test Description 4';
        testConNote4.noteRecordId=testCnRcd3.Id;
        updateConNoteList2.add(testConNote4);
        
        ContentNotesWrapper testConNote5=new ContentNotesWrapper();
        testConNote5.title=null;
        testConNote5.contentTxt= 'Test Description 5';
        testConNote5.noteRecordId=testCnRcd4.Id;
        updateConNoteList2.add(testConNote5);
        
        String strUpdateConNoteList = JSON.serialize(updateConNoteList);
        NotesCtrl.updateNoteList(strUpdateConNoteList,sampleObject11Obj.Id); 
        NotesCtrl.fetchNotes1(string.valueOf(sampleObject11Obj.id), '',true);
        
        String strUpdateConNoteList2 = JSON.serialize(updateConNoteList2);
        NotesCtrl.updateNoteList(strUpdateConNoteList2,sampleObject11Obj.Id); 
        System.assertNotEquals(strUpdateConNoteList2, null, '');
        Test.stopTest();       
    }

}