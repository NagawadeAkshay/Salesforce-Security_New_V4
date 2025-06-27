/*
**********************************************************
Audit History

**********************************************************
2018-07-26      Atul Naik            Created 
    Helper Class For Genrate Auto Snap Shot 
**********************************************************  
*/

public with sharing class AutoSnapShotHelper{
    
    
     /*
    * Author : Atul.N
    * Description : This method used to Generate Snap Shot based on field API Name in Sobject  value being changed.
    *
    */
    public static  void createAutoSnapShot(){
        List<SObject> sojRecordLst = new List<SObject>();
      for(SObject record : Trigger.new){
              sojRecordLst.add(record);
    }
        AutoSnapShotHelper.generateAutoSnapShot(sojRecordLst);
    }
    
       /* Method : Generate Auto Snap Shot
      Parameter : Sobject Record is passed.
   */ 
    public static void generateAutoSnapShot(List<SObject> recordLst){
        if(!recordLst.isEmpty() && recordLst.size() > 0){
            Set<Id> recordIdSet = new  Set<Id>();
            List<SObjectAutoSnapshotCache__c> sObjectAutoSnapList = new List<SObjectAutoSnapshotCache__c>();
            String objectAPIName ='';
            String flexTableParam = '';
            String listTableParam = '';
            for(SObject record : recordLst){
            SObjectCache__c sobjectCache = SObjectCache__c.getInstance(String.valueOf(record.getSObjectType()));
            if(sobjectCache == null || String.isEmpty(sobjectCache.AutoSnapShotFieldAPIName__c) || SObjectAutoSnapshotCache__c.getAll().values() == null) return;
            if(record.get(sobjectCache.AutoSnapShotFieldAPIName__c) == null) return;
            Sobject oldRecord;
            if(Trigger.oldMap != null){
                oldRecord = Trigger.oldMap.get(record.Id);
            }
            if(TriggerHelper.autoSnapShotForLightning){
                if(record.get(sobjectCache.AutoSnapShotFieldAPIName__c)==TriggerHelper.autoSnapShotFieldValue){
                    return;
                }
            }else {
                if(Trigger.oldMap != null && record.get(sobjectCache.AutoSnapShotFieldAPIName__c) == oldRecord.get(sobjectCache.AutoSnapShotFieldAPIName__c)){
                    return;
                }
           }    
                 objectAPIName = String.valueOf(record.getSObjectType());
            for(SObjectAutoSnapshotCache__c sobjAutoSnap : SObjectAutoSnapshotCache__c.getAll().values()){
                String expJson='';
                if(String.isNotEmpty(sobjAutoSnap.ExpressionJson__c))
                    expJson += sobjAutoSnap.ExpressionJson__c;
                if(String.isNotEmpty(sobjAutoSnap.ExpressionJson2__c)) 
                    expJson += sobjAutoSnap.ExpressionJson2__c;
                if(String.isNotEmpty(sobjAutoSnap.ExpressionJson3__c))
                    expJson += sobjAutoSnap.ExpressionJson3__c;
                if(String.isNotEmpty(sobjAutoSnap.ExpressionJson4__c))  
                    expJson += sobjAutoSnap.ExpressionJson4__c;         

                if(sobjAutoSnap.SobjectFieldConfigName__c != objectAPIName  || String.isEmpty(expJson)) continue;
                Map<String, Object> flexTablekeyValMap =  TriggerHelper.controllerParamsMap;
                Map<String, Object> flexTableListkeyValMap =  TriggerHelper.controllerListParamsMap;

                    flexTableParam = JSON.serialize(flexTablekeyValMap);
                    listTableParam = JSON.serialize(flexTableListkeyValMap);
                
                if(ExpressionJsonEvaluator.evaluateExpression(expJson, record, null)) {
                        recordIdSet.add(record.Id);
                        sObjectAutoSnapList.add(sobjAutoSnap);
                   }
               }
           }
         
            if(recordIdSet.size() > 0 && sObjectAutoSnapList.size() > 0){
                autoSnapShot(recordIdSet,objectAPIName,JSON.serialize(sObjectAutoSnapList),flexTableParam,listTableParam);
                }
            }           
    } 
    
    @Future(callout=true)
        public static void autoSnapShot(Set<Id> recordIdSet, String sobjName, String sObjectAutoSnapVal,String flexTableParam, String listTableParam) {
            try{
                    String classficationName='';
                    String snapFileName ='';
                    Set<Id> recordIdSetSanitized =  new Set<Id>();
                    for(Id recSet : recordIdSet){
                        recordIdSetSanitized.add(String.escapeSingleQuotes(recSet));
                    }
                   String sobjQuery = 'SELECT Id,Name FROM '+string.escapeSingleQuotes(sobjName)+ ' WHERE Id IN :recordIdSetSanitized';
                    List<Sobject> sObjectRecList = Database.query(sobjQuery, AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind

                    if(String.isNotBlank(sObjectAutoSnapVal)){
                        List < SObjectAutoSnapshotCache__c > sObjAutoSnapCache = (List <SObjectAutoSnapshotCache__c > ) JSON.deserialize(SFDCEncoder.sanitizeJSON(sObjectAutoSnapVal), List <SObjectAutoSnapshotCache__c> .class);// false+ for Deserializing objects from an untrusted source is security-sensitive as sanitizing it by using SFDCEncoder.sanitizeJSON
                        classficationName = sObjAutoSnapCache[0].SnapshotClassification__c;
                        snapFileName = sObjAutoSnapCache[0].SnapShotFileName__c;
                    }
                    if(sObjectRecList.size() > 0){
                        Boolean isSalesforceFileEnabled = KeyValueStoreHelper.getBooleanValue('EnableSalesforceFile', true);
                        if(isSalesforceFileEnabled == null){
                            isSalesforceFileEnabled = false;
                        }
                        List<ContentVersion> cvFileList=  new List<ContentVersion>();
                        List<Attachment> attList =  new List<Attachment>();
                        List<Sobject> listOfSobject =new List<Sobject>();
                        Map<  Id  ,ContentVersion > contentVersionMap = new  Map<  Id ,ContentVersion >();
                        Map<  Id ,Attachment > attachmentMap = new  Map< Id ,Attachment >();
                        for(Sobject sobj: sObjectRecList){
                            List<DynamicLayoutDefaultValueHelper> dynLayoutDftList = new List<DynamicLayoutDefaultValueHelper>();
                                        String sobjStrRecId = sobj.Id + '';
                            String layoutName = DynamicLayoutHelper.getTemplateName(sobjStrRecId, 'View', dynLayoutDftList, sobjName);
                            Sobject sobj1 =          SnapshotUtils.createSnapshot(sobj.Id, layoutName, flexTableParam, listTableParam, sobj.Id, classficationName, snapFileName, 'History' , false);
                            if(isSalesforceFileEnabled){
                                cvFileList.add( (ContentVersion) sobj1);
                                contentVersionMap.put( sobj.Id , (ContentVersion) sobj1  );
                            }else{
                                attList.add( (Attachment) sobj1);
                            }
                        }

                        if(isSalesforceFileEnabled && cvFileList.size() > 0 ){
                            if(Schema.sObjectType.ContentVersion.isCreateable() && ContentVersion.sObjectType.getDescribe().isAccessible() == true){
                                insert as user cvFileList;
                            }
                            if(Schema.sObjectType.ContentDocumentLink.isCreateable() && ContentDocumentLink.sObjectType.getDescribe().isAccessible() == true){
                                List<ContentDocumentLink>  cdList =  getConetentLinkList(contentVersionMap);
                                insert as user cdList;
                            }
                        }else if(attList.size() > 0 ){
                            if(Schema.sObjectType.Attachment.isCreateable() && Attachment.sObjectType.getDescribe().isAccessible() == true){
                                insert as user attList;
                            }
                            if(Schema.sObjectType.AttachmentExtension__c.isCreateable()){
                                List<AttachmentExtension__c> listOfAttachmentExtension = getAttachmentList(attList , classficationName ,   'History' ,  'History');
                                insert as user listOfAttachmentExtension;
                            }
                        }
                        
                    }
                        
                }      
                catch(Exception ex){
                    CustomExceptions.logException(ex,true);                
                }                      
        }  
        
        private static List<ContentDocumentLink> getConetentLinkList( Map<  id  , ContentVersion> cvFileList){
            List<ContentDocumentLink>  cdList = new List<ContentDocumentLink>();
                                    
            for(Id parentId:  cvFileList.keySet() ){
    
                ContentVersion cvDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id=:cvFileList.get(parentId).id and IsLatest=true  WITH USER_MODE];
                ContentDocumentLink contentlink=new ContentDocumentLink();
                contentlink.LinkedEntityId=parentId;
                contentlink.ShareType= 'I';
                contentlink.ContentDocumentId=cvDocId.ContentDocumentId;
                cdList.add(contentlink);
            }
            
           return cdList;
        }
    
        private static List<AttachmentExtension__c> getAttachmentList( List<Attachment> attachmentList , String classification , String attachmentType  , String historyReason){
            
            List<AttachmentExtension__c> attExtList = new List<AttachmentExtension__c>();
            for(Attachment attach : attachmentList){
                AttachmentExtension__c attExt = new AttachmentExtension__c();
                if(Schema.sObjectType.AttachmentExtension__c.fields.Attachment__c.isCreateable()){
                    attExt.Attachment__c = attach.id;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.Classification__c.isCreateable()){
                    attExt.Classification__c = classification;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentType__c.isCreateable()){
                    attExt.AttachmentType__c = attachmentType;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.ParentId__c.isCreateable()){
                    attExt.ParentId__c = attach.parentId;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.AttachmentName__c.isCreateable()){
                    attExt.AttachmentName__c = attach.Name;
                }
                if(Schema.sObjectType.AttachmentExtension__c.fields.HistoryReason__c.isCreateable()){
                    attExt.HistoryReason__c = historyReason;
                }
                attExtList.add(attExt);
            }
           return attExtList ;
           
        }
  
}