/*Attachments component controller*/
global with sharing class AttachmentsCtrl {       
    global Id parentObjectId{get;set;} 
    global String titleValue{get; set; }
    global String pageBlockId {get;set;}
    global String classification {get;set;}
    global Boolean isDigiSign {get;set;}
    global Boolean isPreviewAttach {get;set;}
    public Boolean isViewVal{get;set;} 
    public Boolean isFieldLevelAtt{get;set;}
    public string namespace {get{ 
        if(String.isEmpty(namespace)){
            return AppUtils.getNameSpacePrefix();
        }   
        return namespace; 
    }set;}
    
    global Integer  timeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
    }
    
    public String govGrantPleaseWaitIconURL {
        get{
            govGrantPleaseWaitIconURL = AppUtils.getIcons('govGrantPleaseWaitIcon');
            return govGrantPleaseWaitIconURL;

        }
        set;
    }
    public String govGrants {
        get{
            govGrants= AppUtils.getIcons('GovGrants');
            return govGrants;
        }
        set;
    }
    global AttachmentsCtrl(){        
        //List<AttachmentWrapper> attachmentWrapperList = new List<AttachmentWrapper>();   
    }
    // @AuraEnabled( cacheable = true ) 
    // global static Map<String,object> fetchAttachments(String parentObjectIds,String pblockId,boolean isView,Boolean loadConfigData,boolean isDigiSign){
    //         return null;
    //     }
    @RemoteAction @AuraEnabled( cacheable = true ) 
    global static Map<String,object> fetchAttachments(String parentObjectIds,String pblockId,boolean isView,Boolean loadConfigData,boolean isDigiSign, Boolean isHistory){
        Id parentObjectId = Id.valueOf(parentObjectIds);
        Map<String,object> returnMap = new Map<String,object>();
        List<AttachmentExtension__c> attachExtList = new List<AttachmentExtension__c>();
        if(isDigiSign == true) {

          if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
            attachExtList = [SELECT Id,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c WHERE ParentId__c =: parentObjectId with USER_MODE];
          }

        } 
        else if(isHistory == true){
         
          if(PageBlockConfig__c.sObjectType.getDescribe().isAccessible() == true){
            List<PageBlockConfig__c> listPageBlock = [SELECT AttachmentClassifications__c FROM PageBlockConfig__c WHERE Id =: pblockId with USER_MODE];
              Set<String> attClassificationsSet = new Set<String>();
              if(listPageBlock.size() > 0 && String.isNotEmpty(listPageBlock[0].AttachmentClassifications__c)) {
                attClassificationsSet.addAll(listPageBlock[0].AttachmentClassifications__c.split(';'));
              }
              if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                  attachExtList = [SELECT Id,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c WHERE ParentId__c =: parentObjectId and (Classification__c IN ('History') OR (AttachmentType__c = 'History' AND Classification__c IN :attClassificationsSet)) with USER_MODE];
              }
          }
        } 
        else {
          
          if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
            attachExtList = [SELECT Id,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c WHERE ParentId__c =: parentObjectId and Classification__c NOT IN ('Digitally Signed','Digitally Signed Original','History') AND AttachmentType__c NOT IN ('History', 'Digital Signature') with USER_MODE ];
          }
        }

        Map<Id, String> extMap = new Map<Id, String>();
        List<Id> attachments = new List<Id>();
        
        for(AttachmentExtension__c ae: attachExtList) {
            extMap.put(ae.Attachment__c, ae.classification__c);
            attachments.add(ae.Attachment__c);
            
        }
        List<Attachment> attList = new List<Attachment>();
        if(Attachment.sObjectType.getDescribe().isAccessible() == true){
        attList = [SELECT Id, Description,ContentType, Name, LastModifiedDate, Owner.Name FROM Attachment WHERE Id IN: attachments with USER_MODE ORDER BY LastModifiedDate DESC];
        }
        String dateFormat = AppUtils.getUserDateTimeFormat();
        List<AttachmentWrapper> attresult = new List<AttachmentWrapper>();
        for(Attachment a: attList) {
          String formatedDate = a.LastModifiedDate != NULL ? a.LastModifiedDate.format(dateFormat) : '';
           attresult.add(new AttachmentWrapper(a.Id,a.Name,null,extMap.get(a.id),null,a.Description,a.Owner.Name,a.LastModifiedDate,formatedDate));           
        }
        
        returnMap.put('AttachmentDateTime',AppUtils.getUserDateTimeFormat());
        returnMap.put('AttachmentList',attresult); 
        Map<String,object> AttachmentConfigMap = new Map<String,Object>();
        if(loadConfigData && isHistory == false){
          AttachmentConfigMap = getAttachmentConfigData(pblockId,parentObjectId,isView);
          returnMap.put('ActionConfig',AttachmentConfigMap.get('ActionConfig'));  
          returnMap.put('HideDisableRowActions',AttachmentConfigMap.get('HideDisableRowActions'));
          returnMap.put('isParentRecEditAccess',AttachmentConfigMap.get('isParentRecEditAccess'));
        }        
        return returnMap;     
      
    } 
    @RemoteAction @AuraEnabled  
    global static Map<String,object> fetchAttachments1(String parentObjectIds,String pblockId,boolean isView,Boolean loadConfigData,boolean isDigiSign, Boolean isHistory){
        Id parentObjectId = Id.valueOf(parentObjectIds);
        Map<String,object> returnMap = new Map<String,object>();
        List<AttachmentExtension__c> attachExtList = new List<AttachmentExtension__c>();
        if(isDigiSign == true) {

          if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
              attachExtList = [SELECT Id,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c 
              WHERE ParentId__c =: parentObjectId  WITH USER_MODE]; //sf review
          }

        } 
        else if(isHistory == true){
         
          if(PageBlockConfig__c.sObjectType.getDescribe().isAccessible() == true){
              List<PageBlockConfig__c> listPageBlock = [SELECT AttachmentClassifications__c FROM PageBlockConfig__c WHERE Id =: pblockId  WITH USER_MODE]; //sf review
              Set<String> attClassificationsSet = new Set<String>();
              if(listPageBlock.size() > 0 && String.isNotEmpty(listPageBlock[0].AttachmentClassifications__c)) {
                attClassificationsSet.addAll(listPageBlock[0].AttachmentClassifications__c.split(';'));
              }
              if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
                  attachExtList = [SELECT Id,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c WHERE ParentId__c =: parentObjectId and (Classification__c IN ('History') OR (AttachmentType__c = 'History' AND Classification__c IN :attClassificationsSet) ) WITH USER_MODE ]; //sf review
              }
          }
        } 
        else {
          
          if(AttachmentExtension__c.sObjectType.getDescribe().isAccessible() == true){
              attachExtList = [SELECT Id,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c WHERE ParentId__c =: parentObjectId and Classification__c NOT IN ('Digitally Signed','Digitally Signed Original','History') AND AttachmentType__c NOT IN ('History', 'Digital Signature')  WITH USER_MODE]; //sf review
          }
        }

        Map<Id, String> extMap = new Map<Id, String>();
        List<Id> attachments = new List<Id>();
        
        for(AttachmentExtension__c ae: attachExtList) {
            extMap.put(ae.Attachment__c, ae.classification__c);
            attachments.add(ae.Attachment__c);
            
        }
        List<Attachment> attList = new List<Attachment>();
        if(Attachment.sObjectType.getDescribe().isAccessible() == true){
          attList = [SELECT Id, Description,ContentType, Name, LastModifiedDate, Owner.Name FROM Attachment WHERE Id IN: attachments WITH USER_MODE ORDER BY LastModifiedDate DESC]; //sf review
        }
        String dateFormat = AppUtils.getUserDateTimeFormat();
        List<AttachmentWrapper> attresult = new List<AttachmentWrapper>();
        for(Attachment a: attList) {
          String formatedDate = a.LastModifiedDate != NULL ? a.LastModifiedDate.format(dateFormat) : '';
           attresult.add(new AttachmentWrapper(a.Id,a.Name,null,extMap.get(a.id),null,a.Description,a.Owner.Name,a.LastModifiedDate,formatedDate));           
        }
        
        returnMap.put('AttachmentDateTime',AppUtils.getUserDateTimeFormat());
        returnMap.put('AttachmentList',attresult);  
        Map<String,object> AttachmentConfigMap = new Map<String,Object>();
        if(loadConfigData && isHistory == false){
          AttachmentConfigMap = getAttachmentConfigData(pblockId,parentObjectId,isView);
          returnMap.put('ActionConfig',AttachmentConfigMap.get('ActionConfig'));  
          returnMap.put('HideDisableRowActions',AttachmentConfigMap.get('HideDisableRowActions'));
          returnMap.put('isParentRecEditAccess',AttachmentConfigMap.get('isParentRecEditAccess'));
        }        
        return returnMap;         
      
    } 
    
    
    private static Map<String,object> getAttachmentConfigData(String pblockId,Id parentObjectId,boolean isView){
      Id actionConfId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Action config').getRecordTypeId(); 
      
    List<PageAttachmentConfig__c> pageAttachmentActionConfigList = new List<PageAttachmentConfig__c>();  
      if(PageAttachmentConfig__c.sObjectType.getDescribe().isAccessible() == true){   
         pageAttachmentActionConfigList = [SELECT Id,Name,RecordTypeId,HideForProfile__c,PageBlockConfig__r.HideDisableRowactions__c,PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c,HideForContext__c,HideForUser__c,HideDecisionField__c,HideOperator__c,Classification__c,AttachmentCount__c 
                                                                  FROM PageAttachmentConfig__c
                                                                WHERE PageBlockConfig__c=:pblockId and RecordTypeId =:actionConfId with USER_MODE];
      } 
    // Added by Chinmay to get parentobjectobject name based on it's id & fetching it's related sobject config. 
      String objectname = parentObjectId.getSObjectType().getDescribe().getName();
      List<SobjectConfig__c> objsobjectcong = new List<SobjectConfig__c>();
      if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
        objsobjectcong = [Select id, name, AttachmentEditHideExpressionJSON__c,AttachmentAddHideExpressionJSON__c , AttachmentDeleteHideExpressionJSON__c 
                                              from SobjectConfig__c WHERE Name=:objectname WITH USER_MODE]; //sf review
      }

      if(UserRecordAccess.sObjectType.getDescribe().isAccessible() == true){
          List<UserRecordAccess> accessList = [SELECT HasDeleteAccess, HasEditAccess, HasReadAccess, RecordId FROM UserRecordAccess WHERE RecordId = :parentObjectId AND UserId = :UserInfo.getUserId() WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
      }
      Map<String,Object> attachmentActionConfigMap = new Map<String,object>();
      
      Map<String,Object> AttachmentActionNameToInfoMap = new Map<String,Object>();
      Boolean isInternal = AppUtils.isInternalUser();
      Boolean isApplicant = AppUtils.isApplicant();
      String userProfile = AppUtils.getProfileInfo();  
      String SOQLquery;
    
    // Checking the list size.
    if(pageAttachmentActionConfigList == null || pageAttachmentActionConfigList.size() >= 0){   
        
        if(objsobjectcong.size()>0){
           
           
          // Checking NoteEdithideExpressionJson & NoteDeleteHideExpressionJSON, if it's not null then calling prepareSOQLForNote method else calling prepareSOQL method.
          if(objsobjectcong[0].AttachmentEditHideExpressionJSON__c != null){
             SOQLquery = AttachmentsCtrl.prepareSOQLForAttachment(parentObjectId,objsobjectcong[0].AttachmentEditHideExpressionJSON__c);
          }
          if(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c != null){
             SOQLquery = AttachmentsCtrl.prepareSOQLForAttachment(parentObjectId,objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c);
          }
          if(objsobjectcong[0].AttachmentAddHideExpressionJSON__c != null){
            SOQLquery = AttachmentsCtrl.prepareSOQLForAttachment(parentObjectId,objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c);
          }
      // hiding the actions based on page block rule config if page block rule config is not null & expressionjson for the delete or edit button is null.
      if(objsobjectcong[0].AttachmentEditHideExpressionJSON__c == null || objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c == null){
         if(pageAttachmentActionConfigList.size() > 0){
        SOQLquery = AttachmentsCtrl.prepareSOQL(pageAttachmentActionConfigList,parentObjectId);
         }
        
        SObject parentObj;
        if( SOQLquery != null ) {
          parentObj = Database.query( SOQLquery ,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes in AttachmentsCtrl.prepareSOQL method
        }
        for(PageAttachmentConfig__c attConfig : pageAttachmentActionConfigList){
          Map<String,Object> AttachmentActionInfo = new Map<String,object>();
          Boolean hideAction = AppUtils.showHideComponent(isView, isInternal, isApplicant, attConfig.HideForProfile__c, (String)parentObjectId, attConfig.HideForContext__c, attConfig.HideForUser__c, userProfile, attConfig.HideOperator__c);
           
          if( parentObj != null && attConfig.HideDecisionField__c != null ) {
              if(attConfig.HideOperator__c == 'AND'){
                hideAction = hideAction != null ? (hideAction && (Boolean)parentObj.get(attConfig.hideDecisionField__c) ) : (Boolean)parentObj.get(attConfig.hideDecisionField__c);
              }else{
                hideAction = hideAction != null ? (hideAction || (Boolean)parentObj.get(attConfig.hideDecisionField__c) ) : (Boolean)parentObj.get(attConfig.hideDecisionField__c);
              }              
            }
          

          if(hideAction == null){
            hideAction = false;
          }
          
          AttachmentActionInfo.put('hideAction',hideAction);
          
            AttachmentActionNameToInfoMap.put(attConfig.Name,AttachmentActionInfo);
            
        }
          
          
      }
      
        }
        else{
          SOQLquery = AttachmentsCtrl.prepareSOQL(pageAttachmentActionConfigList,parentObjectId);
        }
        
        //String SOQLquery = 'Select id,Name,'+pageAttachmentActionConfigList;
        SObject parentObj;
        if( SOQLquery != null ) {
          parentObj = Database.query( SOQLquery ,AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes in AttachmentsCtrl.prepareSOQL method
        }
        Boolean hideActionOnExpr =  false;
        
          Map<String,Object> AttachmentActionInfo = new Map<String,object>();
          Boolean hideAction =  false;
        if(objsobjectcong.size()>0){  
          if(objsobjectcong[0].AttachmentEditHideExpressionJSON__c != null) {
            // If AttachmentEditHideExpressionJSON is not null then calling evaluateExpression method.
            String expressionJson = objsobjectcong[0].AttachmentEditHideExpressionJSON__c;
            String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
            parentObjectId = String.escapeSingleQuotes(parentObjectId);
            String query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId  WITH USER_MODE' : 'select id, Name' +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE'; //sf review
            
            sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes         
            
            hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentEditHideExpressionJSON__c, records, 'view');
            if(hideActionOnExpr) {
            //break;

            Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
            AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
            AttachmentActionNameToInfoMap.put('Edit', AttachmentActionInfohideaction);
            }
          }
          if(objsobjectcong[0].AttachmentAddHideExpressionJSON__c != null) {
            // If AttachmentEditHideExpressionJSON is not null then calling evaluateExpression method.
            String expressionJson = objsobjectcong[0].AttachmentAddHideExpressionJSON__c;
            String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
            parentObjectId = String.escapeSingleQuotes(parentObjectId);
            String query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId  WITH USER_MODE' : 'select id, Name' +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId  WITH USER_MODE'; //sf review
            
            sobject records = Database.query(query);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes         
            
            hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentAddHideExpressionJSON__c, records, 'view');
            if(hideActionOnExpr) {
            //break;

            Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
            AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
            AttachmentActionNameToInfoMap.put('Create', AttachmentActionInfohideaction);
            }
          }

          if(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c != null) {
            String expressionJson = objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c;
            String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
            parentObjectId = String.escapeSingleQuotes(parentObjectId);
            String query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE' : 'select id, Name' +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE'; //sf review
            sobject records = Database.query(query);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes         
            
          // If AttachmentDeleteHideExpressionJSON is not null then calling evaluateExpression method.  
           hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c, records, 'view');
            if(hideActionOnExpr) {
            //break;
			Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
          AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
          AttachmentActionNameToInfoMap.put('Delete', AttachmentActionInfohideaction);
          
            }
          }
        }
          else {
            for(PageAttachmentConfig__c attConfig : pageAttachmentActionConfigList){
                hideAction = AppUtils.showHideComponent(isView, isInternal, isApplicant, attConfig.HideForProfile__c, (String)parentObjectId, attConfig.HideForContext__c, attConfig.HideForUser__c, userProfile, attConfig.HideOperator__c);
           
            if( parentObj != null && attConfig.HideDecisionField__c != null ) {
                    if(attConfig.HideOperator__c == 'AND'){
                        hideAction = hideAction != null ? (hideAction && (Boolean)parentObj.get(attConfig.hideDecisionField__c) ) : (Boolean)parentObj.get(attConfig.hideDecisionField__c);
                    }else{
                        hideAction = hideAction != null ? (hideAction || (Boolean)parentObj.get(attConfig.hideDecisionField__c) ) : (Boolean)parentObj.get(attConfig.hideDecisionField__c);
                    }              
              }
               
          
              if(hideAction == null){
                hideAction = false;
              }
              //AttachmentActionInfo.put('hideForProfile',attConfig.HideForProfile__c);
              //AttachmentActionInfo.put('hideForContext',attConfig.HideForContext__c);
              //AttachmentActionInfo.put('hideDecisionField',(Boolean)parentObj.get(attConfig.HideDecisionField__c));
              //AttachmentActionInfo.put('hideForUser',attConfig.HideForUser__c);
              AttachmentActionInfo.put('hideAction',hideAction);
              
              AttachmentActionNameToInfoMap.put(attConfig.Name,AttachmentActionInfo);
            } 
        }

        if(hideActionOnExpr) {
         // Map<String,Object> AttachmentActionInfo = new Map<String,object>();
          AttachmentActionInfo.put('hideAction', hideActionOnExpr);
      if(objsobjectcong.size()>0){
        if(objsobjectcong[0].AttachmentEditHideExpressionJSON__c != null) {
            
            String expressionJson = objsobjectcong[0].AttachmentEditHideExpressionJSON__c;
            String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
            parentObjectId = String.escapeSingleQuotes(parentObjectId);
            string query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE' : 'select id, Name' +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE'; // sf review 
            sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes       
           
          hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentEditHideExpressionJSON__c, records, 'view');
          // If boolean value of hideActionOnExpr is true then hiding the Edit action.
          if(hideActionOnExpr) {
          AttachmentActionNameToInfoMap.put('Edit', AttachmentActionInfo);
          }
        }
        if(objsobjectcong[0].AttachmentAddHideExpressionJSON__c != null) {
            
          String expressionJson = objsobjectcong[0].AttachmentAddHideExpressionJSON__c;
          String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
          parentObjectId = String.escapeSingleQuotes(parentObjectId);
          string query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE' : 'select id, Name' +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE'; //sf review 
          sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes          
         
        hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentAddHideExpressionJSON__c, records, 'view');
        // If boolean value of hideActionOnExpr is true then hiding the Edit action.
        if(hideActionOnExpr) {
        AttachmentActionNameToInfoMap.put('Create', AttachmentActionInfo);
        }
      }

        if(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c != null) {
            String expressionJson = objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c;
            String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
            parentObjectId = String.escapeSingleQuotes(parentObjectId);
            string query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE' : 'select id, Name' +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE'; //sf review 
            sobject records = Database.query(query);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes          
            
          hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c, records, 'view');
          // If boolean value of hideActionOnExpr is true then hiding the Delete action.
          if(hideActionOnExpr) {
              
           AttachmentActionNameToInfoMap.put('Delete', AttachmentActionInfo);
          }
        }
      }
        }

        attachmentActionConfigMap.put('ActionConfig',AttachmentActionNameToInfoMap);
        if(pageAttachmentActionConfigList.size()>0){
        attachmentActionConfigMap.put('HideDisableRowActions',pageAttachmentActionConfigList[0].PageBlockConfig__r.HideDisableRowactions__c);
        }
    }
    else{
          attachmentActionConfigMap.put('HideDisableRowActions','');
        }
        
        
        
      return attachmentActionConfigMap;
    }

  private static String prepareSOQLForAttachment(id parentObjectId,string HideExpressionJSON) {
        
        String sObj = parentObjectId.getSObjectType().getDescribe().getName();
        SoqlBuilder2 soqlBuilder = new SoqlBuilder2()
            .selectx('Id');
  
      if(sObj.equalsIgnoreCase('case')){

      }
      else
             soqlBuilder.selectx('Name');

        
        Set<String> fieldSet = new Set<String>() ;
    
    // dynamic query to fetch the status of the parent object.    
           

        List<SobjectConfig__c> objsobjectcong = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
          objsobjectcong = [Select id, name, AttachmentEditHideExpressionJSON__c, AttachmentDeleteHideExpressionJSON__c from SobjectConfig__c WHERE Name=:sObj  WITH USER_MODE]; //sf review
        }
        if(objsobjectcong.size()>0){
          // If AttachmentEditHideExpressionJSON is not empty then calling getfieldNamesFromJSON method of ExpressionJSONEvaluator to get the fields from the JSON.
          if(string.isNotEmpty(objsobjectcong[0].AttachmentEditHideExpressionJSON__c)){
              String expressionJson = objsobjectcong[0].AttachmentEditHideExpressionJSON__c;
              String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              parentObjectId = String.escapeSingleQuotes(parentObjectId);
              string query = String.isNotEmpty(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(sobj) +' where Id=:parentObjectId WITH USER_MODE':'select id, Name ' +' from '+ string.escapeSingleQuotes(sobj) +' where Id=:parentObjectId WITH USER_MODE'; //sf review 
            
              sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes         
                  
              if(String.isNotEmpty(fields)){
                fieldSet.addAll(fields.split(','));
              }
              if(fieldSet.size()>0){
                Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentEditHideExpressionJSON__c, records, 'view');
              }
            }
          // If AttachmentDeleteHideExpressionJSON is not empty then calling getfieldNamesFromJSON method of ExpressionJSONEvaluator to get the fields from the JSON.
          else if(string.isNotEmpty(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c)){
              String expressionJson = objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c;
              String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              parentObjectId = String.escapeSingleQuotes(parentObjectId);
              string query = 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(sobj) +' where Id=:parentObjectId WITH USER_MODE'; //sf review 
              
              sobject records = Database.query(query);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
              
              if(String.isNotEmpty(fields)){
                fieldSet.addAll(fields.split(','));
              }

              if(fieldSet.size()>0){
                Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].AttachmentDeleteHideExpressionJSON__c, records, 'view');
                
              }
          }
        }
        /*for (PageAttachmentConfig__c pb : pageAttachmentConfigList) { 
            soqlBuilder.selectx(pb.HideDecisionField__c);
        }*/
        soqlBuilder
                .fromx(String.escapeSingleQuotes(parentObjectId.getSObjectType().getDescribe().getName()))
                .wherex('Id', '=', string.escapeSingleQuotes(parentObjectId), null);
        
        return soqlBuilder.toSoql(); 
        
    }  

   @RemoteAction @AuraEnabled
  global static Map<String,Object> deleteAttchment(String attachmentId){
    Map<String, Object> retVal = new Map<String, Object>();
    return retVal;    
  }
    
    
 
    private static String prepareSOQL(List<PageAttachmentConfig__c> pageAttachmentConfigList,id parentObjectId) {
        
        String sObj = pageAttachmentConfigList[0].PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c;
        
        SoqlBuilder2 soqlBuilder = new SoqlBuilder2()
                .selectx('Id');
                
                // Modified the code to exclude Name field from Case Object - (Davinder -- 8/6/15)
               if(sObj.equalsIgnoreCase('case')){
             //skip it
                }
        else
             soqlBuilder.selectx('Name');
        
        for (PageAttachmentConfig__c pb : pageAttachmentConfigList) { 
            soqlBuilder.selectx(string.escapeSingleQuotes(pb.HideDecisionField__c));
        }
        soqlBuilder
                .fromx(string.escapeSingleQuotes(pageAttachmentConfigList[0].PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c))
                .wherex('Id', '=', string.escapeSingleQuotes(parentObjectId), null);
        
        return soqlBuilder.toSoql(); 
        
    }
    
 
    public with sharing class AttachmentWrapper{
        @AuraEnabled
        public String attachmentId;
        @AuraEnabled
        public String attachmentName;
        @AuraEnabled
        public String attachmentSize;
        @AuraEnabled
        public String classification; 
        @AuraEnabled
        public String attachmentDescription;   
        @AuraEnabled 
        public String attachmentOwner;
        @AuraEnabled
        public Datetime LastModified;
        @AuraEnabled
        public String formatedLastModified;
        @AuraEnabled
        public blob attachmentBody;
        public AttachmentWrapper(String attachmentId,String attachmentName,String attachmentSize,String classification,blob attachmentBody,String attachmentDescription,String attachmentOwner,Datetime LastModified, String formatedLastModified){
            this.attachmentId=attachmentId;
            this.attachmentName=attachmentName;
            this.attachmentSize=attachmentSize;
            this.classification=classification;
            this.attachmentBody = attachmentBody;
            this.attachmentDescription = attachmentDescription;               
            this.attachmentOwner = attachmentOwner;
            this.LastModified = LastModified;
            this.formatedLastModified = formatedLastModified;
        }
    }
    
    public with sharing class AttachmentConfigWrapper{
      
    }
    
}