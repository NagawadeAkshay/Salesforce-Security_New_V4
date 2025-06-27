global with sharing class NotesCtrl {
    global Id parentObjectId {get;set;}
    //public string parentRecordId {get;set;}
    global transient String titleValue {get;set;}
   public String govGrantPleaseWaitIconURL {
        get{
            /*String govGrantPleaseWaitIcon = KeyValueStoreHelper.getTextValue('govGrantPleaseWaitIcon', true);
            Set<String> resourceNames = new Set<String>();
            resourceNames.add(govGrantPleaseWaitIcon);
            List<StaticResource> resourceList= [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name IN: resourceNames];
            for(StaticResource sr : resourceList){
                String namespace = sr.NamespacePrefix;
                if(govGrantPleaseWaitIcon == sr.Name){
                    govGrantPleaseWaitIconURL = '/resource/' + sr.SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + govGrantPleaseWaitIcon;          
                }
            }*/

            
            //User Story 71061: Internal - Remove document object dependency and move to static resource
            govGrantPleaseWaitIconURL = AppUtils.getIcons('govGrantPleaseWaitIcon');
            return govGrantPleaseWaitIconURL;

        }
        set;
    }
    public String govGrants {
        get{
            govGrants= AppUtils.getIcons('GovGrants');
            RETURN govGrants;
        }
        set;
}
     global Integer  timeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
        }   
    
   // public String delMsg {get;set;}
    
    /*public List<NotesWrapper> NotesList{
        get{
            List<NotesWrapper> notesLst = new List<NotesWrapper>();
             
            List<Note> NoteList = [SELECT Id,Body,Title,OwnerId,
                CreatedDate,LastModifiedDate,Owner.Name,ParentId,CreatedBy.Name
                                        FROM Note 
                                        WHERE ParentId = :parentObjectId ORDER BY LastModifiedDate DESC];
                
                for(Note a : NoteList){
                    notesLst.add(new NotesWrapper(a));
                    
                }
            return notesLst;
        }
    }*/
   @RemoteAction @AuraEnabled(cacheable = true ) 
    global static Map<String,object> fetchNotes(String parentObjectIds,string pblockId,boolean isView){
        Map<String,object> returnMap = new Map<String,object>();
        Id parentObjectId = Id.valueOf(parentObjectIds);
      Boolean isOwner = false;
       List<NotesWrapper> notesLst = new List<NotesWrapper>();
            List<Note> NoteList = [SELECT Id,Body,Title,OwnerId,
                CreatedDate,LastModifiedDate,Owner.Name,ParentId,CreatedBy.Name
                                        FROM Note 
                                      WHERE ParentId = :parentObjectId WITH USER_MODE
                                      ORDER BY LastModifiedDate DESC];//CRUD/FLS False +ve with the help of Schema we have performed the check
                
                for(Note a : NoteList){
                	notesLst.add(new NotesWrapper(a,isOwner));
                }
          returnMap.put('NotesLocaleDateTime',AppUtils.getUserDateTimeFormat());        
          returnMap.put('NoteList',notesLst); 
          Map<String,object> AttachmentConfigMap = new Map<String,Object>();
        
          AttachmentConfigMap = getNoteConfigData(parentObjectId,pblockId,isView);
          returnMap.put('ActionConfig',AttachmentConfigMap.get('ActionConfig'));  
          returnMap.put('isParentRecEditAccess',AttachmentConfigMap.get('isParentRecEditAccess'));
        return returnMap;         
     }

     private static Map<String,object> getNoteConfigData(Id parentObjectId,string pblockId,boolean isView){
      Id actionConfId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Note config').getRecordTypeId();
      String sObjName = parentObjectId.getSObjectType().getDescribe().getName(); 
      List<PageAttachmentConfig__c> pageAttachmentActionConfigList = new List<PageAttachmentConfig__c>();  
      if(PageAttachmentConfig__c.sObjectType.getDescribe().isAccessible() == true){   
         pageAttachmentActionConfigList = [SELECT Id,Name,RecordTypeId,HideForProfile__c,PageBlockConfig__r.HideDisableRowactions__c,PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c,HideForContext__c,HideForUser__c,HideDecisionField__c,HideOperator__c,Classification__c,AttachmentCount__c 
                                                                  FROM PageAttachmentConfig__c
                                        WHERE PageBlockConfig__c=:pblockId and RecordTypeId =:actionConfId WITH USER_MODE];
      } 

  // Added by Chinmay to get sobject name based on parentobjectid & fetching the it's related sobject config.
    String objectname = parentObjectId.getSObjectType().getDescribe().getName();
  List<SobjectConfig__c> objsobjectcong = [Select id, name,NoteAddHideExpressionJSON__c, NoteDeleteHideExpressionJSON__c, NoteEditHideExpressionJSON__c 
                                          from SobjectConfig__c WHERE Name=:objectname WITH USER_MODE];



  List<UserRecordAccess> accessList = [SELECT HasDeleteAccess, HasEditAccess, HasReadAccess, RecordId 
                                      FROM UserRecordAccess 
                                      WHERE RecordId = :parentObjectId AND UserId = :UserInfo.getUserId() WITH USER_MODE];//CRUD/FLS False +ve with the help of Schema we have performed the check

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
              if(objsobjectcong[0].NoteEditHideExpressionJSON__c != null){
                  
               SOQLquery = NotesCtrl.prepareSOQLForNote(parentObjectId,objsobjectcong[0].NoteEditHideExpressionJSON__c);
              }
              if(objsobjectcong[0].NoteAddHideExpressionJSON__c != null){
                 SOQLquery = NotesCtrl.prepareSOQLForNote(parentObjectId,objsobjectcong[0].NoteAddHideExpressionJSON__c);
              }

              if(objsobjectcong[0].NoteDeleteHideExpressionJSON__c != null){  
               SOQLquery = NotesCtrl.prepareSOQLForNote(parentObjectId,objsobjectcong[0].NoteDeleteHideExpressionJSON__c); 
                 
              }
    // hiding the actions based on page block rule config if page block rule config is not null & expressionjson for the delete or edit button is null.
    if(objsobjectcong[0].NoteEditHideExpressionJSON__c == null || objsobjectcong[0].NoteDeleteHideExpressionJSON__c == null){
        if(pageAttachmentActionConfigList.size()>0){
        	SOQLquery = NotesCtrl.prepareSOQL(pageAttachmentActionConfigList,parentObjectId);
        }
        
        SObject parentObj;
        
        if( SOQLquery != null ) {
          parentObj = Database.query( SOQLquery );//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes in NotesCtrl.prepareSOQL() method.
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
                 if(pageAttachmentActionConfigList.size() > 0){
                    SOQLquery = NotesCtrl.prepareSOQL(pageAttachmentActionConfigList,parentObjectId);
              }
              }
              //String SOQLquery = 'Select id,Name,'+pageAttachmentActionConfigList;
              SObject parentObj;
              if( SOQLquery != null ) {
                  parentObj = Database.query( SOQLquery );//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes in NotesCtrl.prepareSOQL() method.
              }

      Boolean hideActionOnExpr =  false;
      parentObjectId = string.escapeSingleQuotes(parentObjectId);

            Map<String,Object> AttachmentActionInfo = new Map<String,object>();
            Boolean hideAction =  false;
            if(objsobjectcong.size()>0){
              if(objsobjectcong[0].NoteEditHideExpressionJSON__c != null) {
                String expressionJson = objsobjectcong[0].NoteEditHideExpressionJSON__c;
                String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              string query = 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE';
                sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
               hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteEditHideExpressionJSON__c, records, 'view');
                if(hideActionOnExpr) {
                  //break;
	          Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
	          AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
	          AttachmentActionNameToInfoMap.put('Edit', AttachmentActionInfohideaction);
	        }
              } 
          if(objsobjectcong[0].NoteAddHideExpressionJSON__c != null) {

            String expressionJson = objsobjectcong[0].NoteAddHideExpressionJSON__c;
            String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
          string query = String.isNotBlank(fields) ? 'select id, Name, '+ string.escapeSingleQuotes(fields) +' from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE':
                                                     'select id, Name from '+ string.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE';
           sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes         
            hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteAddHideExpressionJSON__c, records, 'view');
            
            if(hideActionOnExpr) {
              Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
              AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
              AttachmentActionNameToInfoMap.put('Create', AttachmentActionInfohideaction);
            }
          } 

              if(objsobjectcong[0].NoteDeleteHideExpressionJSON__c != null) {
                String expressionJson = objsobjectcong[0].NoteDeleteHideExpressionJSON__c;
                String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              string query = 'select id, Name, '+ String.escapeSingleQuotes(fields) +' from '+ String.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE';
                
                sobject records = Database.query(query);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/Static Bind          
                
              // If NoteDeleteHideExpressionJSON is not null then calling evaluateExpression method.
                hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteDeleteHideExpressionJSON__c, records, 'view');
                if(hideActionOnExpr) {
                 // break;
	          Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
	          AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
	          AttachmentActionNameToInfoMap.put('Delete', AttachmentActionInfohideaction);
	        }
              }
            }
                else {
                    for(PageAttachmentConfig__c attConfig : pageAttachmentActionConfigList) {
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
                Map<String,Object> AttachmentActionInfohideaction = new Map<String,object>();
                AttachmentActionInfohideaction.put('hideAction', hideActionOnExpr);
            if(objsobjectcong.size()>0){
              if(objsobjectcong[0].NoteEditHideExpressionJSON__c != null) {
                String expressionJson = objsobjectcong[0].NoteEditHideExpressionJSON__c;
                String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              string query = 'select id, Name, '+ String.escapeSingleQuotes(fields) +' from '+ String.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE';
                
                sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/Static Bind         
                  
                hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteEditHideExpressionJSON__c, records, 'view');
                // If boolean value of hideActionOnExpr is true then hiding the Edit action.
                if(hideActionOnExpr){
                   
                  AttachmentActionNameToInfoMap.put('Edit', AttachmentActionInfohideaction);
                  }
              }
              if(objsobjectcong[0].NoteAddHideExpressionJSON__c != null) {
                String expressionJson = objsobjectcong[0].NoteAddHideExpressionJSON__c;
                String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              string query = String.isNotBlank(fields)? 'select id, Name, '+ String.escapeSingleQuotes(fields) +' from '+ String.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE':
                                                        'select id, Name from '+ String.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE';
                
                sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/Static bind         
                  
                hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteAddHideExpressionJSON__c, records, 'view');
                // If boolean value of hideActionOnExpr is true then hiding the Edit action.
                if(hideActionOnExpr){
                   
                  AttachmentActionNameToInfoMap.put('Create', AttachmentActionInfohideaction);
                  }
              }

              if(objsobjectcong[0].NoteDeleteHideExpressionJSON__c != null) {
                String expressionJson = objsobjectcong[0].NoteDeleteHideExpressionJSON__c;
                String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
              string query = 'select id, Name, '+ String.escapeSingleQuotes(fields) +' from '+ String.escapeSingleQuotes(objectname) +' where Id=:parentObjectId WITH USER_MODE';
                
                sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/Static Bind         
                
                hideActionOnExpr = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteDeleteHideExpressionJSON__c, records, 'view');
                // If boolean value of hideActionOnExpr is true then hiding the Delete action.
                if(hideActionOnExpr){
                    
                   AttachmentActionNameToInfoMap.put('Delete', AttachmentActionInfohideaction);
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

  // Method to create soql for Notes.
  private static String prepareSOQLForNote(id parentObjectId,string HideExpressionJSON) {

    
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
  objsobjectcong = [Select id, name, NoteDeleteHideExpressionJSON__c, NoteEditHideExpressionJSON__c 
                                          from SobjectConfig__c WHERE Name=:sObj WITH USER_MODE];
  }
    if(objsobjectcong.size()>0){
    // If NoteEditHideExpressionJSON is not empty then calling getfieldNamesFromJSON method of ExpressionJSONEvaluator to get the fields from the JSON.
    if(string.isNotEmpty(objsobjectcong[0].NoteEditHideExpressionJSON__c)){
        String expressionJson = objsobjectcong[0].NoteEditHideExpressionJSON__c;
        String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
        

      string query = 'select id, Name, '+ String.escapeSingleQuotes(fields) +' from '+ String.escapeSingleQuotes(sObj) +' where Id=:parentObjectId WITH USER_MODE';
        
        sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/Bind Static          
        
        
        if(String.isNotEmpty(fields)){
          fieldSet.addAll(fields.split(','));
        }
         
        if(fieldSet.size()>0){
          Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteEditHideExpressionJSON__c, records, 'view');
          
        }
    }
    // If NoteDeleteHideExpressionJSON is not empty then calling getfieldNamesFromJSON method of ExpressionJSONEvaluator to get the fields from the JSON.
    
     if(string.isNotEmpty(objsobjectcong[0].NoteDeleteHideExpressionJSON__c)){
        String expressionJson = objsobjectcong[0].NoteDeleteHideExpressionJSON__c;
        String fields = ExpressionJSONEvaluator.getfieldNamesFromJSON(expressionJson);
        
      string query = 'select id, Name, '+ String.escapeSingleQuotes(fields) +' from '+ String.escapeSingleQuotes(sObj) +' where Id=:parentObjectId WITH USER_MODE';
        
        sobject records = Database.query(query); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/Static Bind         
        
        
        if(String.isNotEmpty(fields)){
          fieldSet.addAll(fields.split(','));
        }
        if(fieldSet.size()>0){
          Boolean hideResult = ExpressionJsonEvaluator.evaluateExpression(objsobjectcong[0].NoteDeleteHideExpressionJSON__c, records, 'view');
         }
    }
  }
    /*for (PageAttachmentConfig__c pb : pageAttachmentConfigList) { 
        soqlBuilder.selectx(pb.HideDecisionField__c);
    }*/
    soqlBuilder
            .fromx(parentObjectId.getSObjectType().getDescribe().getName())
            .wherex('Id', '=', string.escapeSingleQuotes(parentObjectId), null);
    
    return soqlBuilder.toSoql(); 
      
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
          soqlBuilder.selectx(String.valueOf(pb.HideDecisionField__c));
      }
      soqlBuilder
              .fromx(String.escapeSingleQuotes(pageAttachmentConfigList[0].PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c))
              .wherex('Id', '=', String.escapeSingleQuotes(parentObjectId), null);
      
      return soqlBuilder.toSoql(); 
      
  }

  @RemoteAction
  global static Map<String,Object> deleteNote(String noteId){
    Map<String, Object> retVal = new Map<String, Object>();
    List<Note> noteList = new List<Note>();
  	noteList =  [SELECT Id FROM Note WHERE id =:noteId WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
	   
	    try{
	      if(Schema.sObjectType.Note.isDeletable()){
	        Database.DeleteResult[] drList;
	        drList = Database.delete(noteList, false, AccessLevel.USER_MODE);//FLS False +ve - Used access level user mode to perform FLS
	        for (Database.DeleteResult dr : drList ) {  
	            if (dr.isSuccess()) {
	              retVal.put('Message','Record deleted successfully.');
	              retVal.put('Success',true);                  
	            }
	        }
	      }else{
	        retVal.put('Message','Error: Insufficient privileges.'); 
	        retVal.put('Success',false); 
	        return retVal;  
	      }            
	    }catch(Exception e) {            
	      
	      retVal.put('Message','Error: '+ AppUtils.handleSystemExceptionMsg(e)); 
	      retVal.put('Success',false); 
	      return retVal;         
	    }
    	return retVal;    
    }
   
    public Note noteObj{
        get {
        if (noteObj== null)
            noteObj= new Note();
            return noteObj;
        }
        set;
    } 
    global NotesCtrl (){                 
    }

  @AuraEnabled
  public static Boolean AddNotes(String Tilte,String Description, String recId){
    Boolean result;
    try{ 
      Note nt=new Note();
      if(Schema.sObjectType.Note.fields.title.isCreateable()){
        nt.title=Tilte;
      }
      if(Schema.sObjectType.Note.fields.Body.isCreateable()){
        nt.Body=Description;
      }
        nt.ParentId=recId;
        if(Schema.sObjectType.Note.isCreateable()){
          Database.SaveResult sr= Database.insert(nt, false, AccessLevel.USER_MODE);
            if(sr.isSuccess()){
              result=true;
            }
            else{
              result=false;
            }
        }
      }catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
   return result;
}
  
  /**Methods for LWC note started from here  */
  @AuraEnabled
    global static Map<String,object> fetchNotes1(String parentObjectIds,string pbId,boolean isView){
    Map<String,object> returnMap = new Map<String,object>();
    Id parentObjectId = parentObjectIds;
    String loggedInUserId = UserInfo.getUserId();
    Boolean isOwner = false;
    List<ContentNoteWrapper> notesLst = new List<ContentNoteWrapper>();
    
    Set<Id> contentDocIds = new Set<Id>();

    List<ContentDocumentLink> contentDocLink = [Select id ,LinkedEntityId, ContentDocumentId from ContentDocumentLink
                                                 where LinkedEntityId =: parentObjectId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
              
    if(contentDocLink.size() > 0 ){
        for(ContentDocumentLink conDoc : contentDocLink){
          contentDocIds.add(conDoc.ContentDocumentId);
        }
        if(contentDocIds.size() > 0 ){
          List<ContentNote> NoteList = [SELECT Id,Title,Content,OwnerId,CreatedDate,LastModifiedDate,Owner.Name,CreatedBy.Name
          FROM ContentNote WHERE Id =: contentDocIds WITH USER_MODE ORDER BY LastModifiedDate DESC];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
          String dateFormat = AppUtils.getUserDateTimeFormat();
          String formatedDate;
            if(NoteList.size() > 0 ){
              for(ContentNote a : NoteList){
                  formatedDate = a.CreatedDate != NULL ? a.CreatedDate.format(dateFormat) : '';
                   if(a.OwnerId == loggedInUserId){
                     isOwner = true;
                    }else{
                      isOwner = false;
                    }
                    String strNotes =   a.Content.toString(); //.replaceAll( '<[^>]+>',' ' );    //EncodingUtil.base64Encode(a.Content);
                   String strTitleNotes =   a.Content.toString().replaceAll( '<[^>]+>',' ' ); 
                    notesLst.add(new ContentNoteWrapper(a, isOwner,formatedDate, strNotes, strTitleNotes));
                }
              returnMap.put('NotesLocaleDateTime',AppUtils.getUserDateTimeFormat());        
              returnMap.put('NoteList',JSON.serializePretty(notesLst)); 
    		}
        }
    }
      Map<String,object> attachmentConfigMap = new Map<String,Object>();
      attachmentConfigMap = getNoteConfigData(parentObjectId,pbId,isView);
      returnMap.put('ActionConfig',attachmentConfigMap.get('ActionConfig'));  
      returnMap.put('isParentRecEditAccess',attachmentConfigMap.get('isParentRecEditAccess'));
    return returnMap;         
  } 
	@AuraEnabled
	global static Map<String,object> getContentNoteView(Id noteId){
		Map<String,object> returnMap = new Map<String,object>();
		List<ContentNoteWrapper> notesLst = new List<ContentNoteWrapper>();
		ContentNote enhancedNote = [SELECT Id,Title,Content FROM ContentNote 
		                                WHERE Id =: noteId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                                        
                                    String strNotes =   enhancedNote.Content.toString();//.replaceAll( '<[^>]+>',' ' );  
                                    notesLst.add(new ContentNoteWrapper(enhancedNote, strNotes));
    		returnMap.put('enhancedNote',JSON.serializePretty(notesLst)); 
    		return returnMap;
    }       

@AuraEnabled
global static Boolean deleteNoteRecord(String noteId){
    Boolean retVal ;
    List<ContentNote> noteList = new List<ContentNote>();
    noteList =  [SELECT Id FROM ContentNote WHERE id =:noteId WITH USER_MODE]; 
	    try{
		      if(Schema.sObjectType.ContentNote.isDeletable()){
			        Database.DeleteResult[] drList;
			        drList = Database.delete(noteList, false, AccessLevel.USER_MODE);//FLS False +ve - Used access level user mode to perform FLS
			        for (Database.DeleteResult dr : drList ) {
			            if (dr.isSuccess()) {
			              retVal = true;       //Record deleted successfully.           
			            }
			            }            
			      }else{
			        retVal = false;      
			        return retVal;  
			      }            
	    }catch(Exception e) {            
	      retVal = false; 
	      return retVal;         
	    }
    	return retVal =true;    
    }  
    
     @AuraEnabled
  public static Boolean updateNoteRecord(String title,String Description, Id noteRecordId,Id parentRecordId){ 
       Boolean result;
		 try{ 
      ContentNote con = [SELECT id,Title,Content FROM ContentNote WHERE Id=:noteRecordId]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
      if(Schema.SObjectType.ContentNote.fields.Title.isUpdateable()){
             if(title != null){
               con.Title = title;
             }else{
                  con.Title = con.Title;
             }
    
           }
           if(Schema.SObjectType.ContentNote.fields.Content.isUpdateable()){
             if(Description != null){
               con.Content = blob.valueOf(Description); 
             }else{
                 con.Content =con.Content;
             }
    
           }
           if(Schema.sObjectType.ContentNote.isUpdateable() && Schema.sObjectType.ContentNote.isAccessible()){
               update as user con; 
               result=true;
           }
		  }catch(Exception e) {            
		    result = false; 
		  } 
    return result;         
}

@AuraEnabled
public static Boolean addNotes(String title,String Description, Id parentRecordId){
      Boolean result;
      try{
	      ContentNote nt=new ContentNote(); //.escapeHTML4()
	      nt.Title=title;
	      nt.Content= Blob.valueOf(Description);
          if(Schema.sObjectType.ContentNote.isCreateable()){
	          Database.SaveResult sr= Database.insert(nt, false, AccessLevel.USER_MODE);
		         if(sr.isSuccess()){
		          result=true;
		            ContentDocumentLink link = new ContentDocumentLink();
		            link.ContentDocumentId   = sr.getId();
		            link.LinkedEntityId      = parentRecordId;
		          if(Schema.sObjectType.ContentDocumentLink.fields.ShareType.isCreateable()){
		            link.ShareType           = 'V';
		          }
		          if(Schema.sObjectType.ContentDocumentLink.fields.Visibility.isCreateable()){
		            link.Visibility          = 'AllUsers';
		          }
		          if(ContentDocumentLink.sObjectType.getDescribe().isAccessible() == true && Schema.sObjectType.ContentDocumentLink.isCreateable()){
		            insert as user link;
		         }
                }else{
          			result=false;
         		}
            }
        }catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
    
    public with sharing class ContentNotesWrapper{
        @AuraEnabled public String title{get;set;}
        @AuraEnabled public String contentTxt{get;set;}
        @AuraEnabled public String noteRecordId{get;set;}
    }
    
    @AuraEnabled
    public static Map<String,Object> addNoteList(String contentNotes, Id parentRecordId){
        Map<String,Object> result = new Map<String,Object>();
        List<ContentNotesWrapper> contentNotesWrappList;
        List<ContentNote> contentNotesList=new List<ContentNote>();     
        try{
            contentNotesWrappList=(List<ContentNotesWrapper>) System.JSON.deserialize(contentNotes, List<ContentNotesWrapper>.class);
           for(ContentNotesWrapper contWrapRcd:contentNotesWrappList){
                ContentNote conNoteRcd=new ContentNote(); 
                if(contWrapRcd.title!=null){          
                    conNoteRcd.Title=contWrapRcd.title;
                }
                if(contWrapRcd.contentTxt!=null){
                    conNoteRcd.Content=Blob.valueOf(contWrapRcd.contentTxt);
                }
                contentNotesList.add(conNoteRcd);
            }
            if(contentNotesList.size()>0){    
                if(Schema.sObjectType.ContentNote.isCreateable()){
                  List<Database.Saveresult> insertResults=Database.insert(contentNotesList, false, AccessLevel.USER_MODE);
                  List<ContentDocumentLink> conDocList=new List<ContentDocumentLink>();
                  for (Database.SaveResult sr : insertResults) {
                      if (sr.isSuccess()) {
                          ContentDocumentLink link = new ContentDocumentLink();
                          link.ContentDocumentId   = sr.getId();
                          link.LinkedEntityId      = parentRecordId;
                          link.ShareType           = 'V';
                          link.Visibility          = 'AllUsers';
                          conDocList.add(link);
                      }else{
                        String msg = '';
                        for(Database.Error err : sr.getErrors()) {
                            result.put('success',false);
                            msg = err.getMessage();
                            msg = AppUtils.handleSystemExceptionMsg(msg);
                            result.put ('message',msg);
                        }
                    }
                  }             
                  if(conDocList.size()>0){
                    // result=true;
                      result.put('success',true);
                      try{
                        if(ContentDocumentLink.sObjectType.getDescribe().isAccessible() == true && Schema.sObjectType.ContentDocumentLink.isCreateable()){
                          insert as user conDocList;
                        }
                      }
                      catch (Exception e) {
                          result.put('message',e.getMessage());
                          throw new AuraHandledException(e.getMessage());
                      }
                  }
                  else{
                      result.put('success',false);
                  }  
                }         
            }
            else{
                result.put('success',false);
            }
        } catch (Exception e) {
            result.put('message',e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
    
    @AuraEnabled
    public static Map<String,Object> updateNoteList(String contentNotes, Id parentRecordId){
        Map<String,Object> result = new Map<String,Object>();
        List<ContentNotesWrapper> contentNotesWrappList;
        List<ContentNote> updateConNoteList=new List<ContentNote>();   
        Set<String> contentNoteIdSet=new Set<String>();
        
        Boolean isTitleUpdatable= Schema.SObjectType.ContentNote.fields.Title.isUpdateable();
        Boolean isConNoteUpdatable= Schema.SObjectType.ContentNote.fields.Content.isUpdateable();
        Boolean isConNoteObjUpdatable= Schema.sObjectType.ContentNote.isUpdateable();
        Boolean isConNoteObjAccessable= Schema.sObjectType.ContentNote.isAccessible();
        try{
            contentNotesWrappList=(List<ContentNotesWrapper>) System.JSON.deserialize(contentNotes, List<ContentNotesWrapper>.class);
            for(ContentNotesWrapper contWrapRcd1:contentNotesWrappList){
                if(contWrapRcd1.noteRecordId!=null){
                    contentNoteIdSet.add(contWrapRcd1.noteRecordId);
                }           
            }
            Map<Id,ContentNote> conNotesMap =new Map<Id,ContentNote>([SELECT id,Title,Content FROM ContentNote WHERE Id=:contentNoteIdSet WITH USER_MODE]); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            for(ContentNotesWrapper contWrapRcd:contentNotesWrappList){
                ContentNote conNoteRcd=new ContentNote();  
                if(contWrapRcd.noteRecordId!=null){
                    conNoteRcd.Id = contWrapRcd.noteRecordId;
                }           
                if(isConNoteUpdatable && contWrapRcd.contentTxt!=null){
                    conNoteRcd.Content=Blob.valueOf(contWrapRcd.contentTxt);
                }
                if(isTitleUpdatable && contWrapRcd.title!=null){       
                    conNoteRcd.Title=contWrapRcd.title;
                }
                else if((contWrapRcd.title==null||contWrapRcd.title=='') && conNotesMap.size()>0 && contWrapRcd.noteRecordId!=null){
                    conNoteRcd.Title= conNotesMap.get(contWrapRcd.noteRecordId).Title;
                }
                updateConNoteList.add(conNoteRcd);
            }
            if(updateConNoteList.size()>0 && isConNoteObjUpdatable && isConNoteObjAccessable){           
                //update updateConNoteList;        
                List<Database.Saveresult> updateResults=Database.update(updateConNoteList, false, AccessLevel.USER_MODE);//CRUD False +ve with the help of Schema we have performed check in line 790 and 791/ FLS False +ve - Used access level user mode to perform FLS
                
                for(Database.SaveResult sr1 : updateResults) {
                    if (sr1.isSuccess()) {
                        result.put('success',true);
                    }
                    else {
                        String msg = '';
                        for(Database.Error err : sr1.getErrors()) {
                            result.put('success',false);
                            msg = err.getMessage();
                            msg = AppUtils.handleSystemExceptionMsg(msg);
                            result.put ('message',msg);
                        }
                    }
                }
            }
            else{
                result.put('success',false);
                result.put('message','You have no access to edit this record');
            }
        } catch (Exception e) {
            result.put('success',false);
            result.put('message',e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
    
    
    
    @AuraEnabled
    public static String getNoteContent(Id noteId){
      string result;
       
        try{
            ContentNote note = [Select id, Title, Content from ContentNote 
                                where id =: noteId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            //description = note.Content; 
            result = note.Content.toString().replaceAll( '<[^>]+>',' ' );  
       } catch (Exception e) {
         throw new AuraHandledException(e.getMessage());
       }
      return result;
     }
    public with sharing class ContentNoteWrapper implements Comparable{                          
      @AuraEnabled  
      public ContentNote note{get;set;}
      public Boolean isOwner{get;set;}
      @AuraEnabled
      public String formatedCreatedDate;
      public string title{get;set;}
      @AuraEnabled  
      public String strNotes;  
      public String strTitleNotes;   
      public DateTime lastModifiedDate {get;set;}
      public ContentNoteWrapper(ContentNote note , Boolean isOwner, String formatedCreatedDate,String strNotes, String strTitleNotes){           
        this.note = note;                                  
        this.isOwner = isOwner;
        this.formatedCreatedDate = formatedCreatedDate;
        this.strNotes = strNotes;
        this.strTitleNotes = strTitleNotes;
      }
      public ContentNoteWrapper(ContentNote note ,String strNotes){           
        this.note = note;                                  
        this.strNotes = strNotes;
    }
    public ContentNoteWrapper( String title ,String strNotes){           
      this.title = title;                                  
      this.strNotes = strNotes;
      }
      public Integer compareTo(Object ObjToCompare) {
        return Integer.valueOf(((ContentNoteWrapper)objToCompare).lastModifiedDate.getTime() - lastModifiedDate.getTime());
      }
    }
        
    public with sharing class NotesWrapper implements Comparable{                          
        public DateTime lastModifiedDate {get;set;}
        public Id objId {get;set;}
        public Note note{get;set;}
        public Boolean isOwner{get;set;}
        @AuraEnabled
        public String formatedCreatedDate;
        public NotesWrapper(Note note){           
		    this.note = note;                                  
		}
      public NotesWrapper(Note note , Boolean isOwner){           
          this.note = note;                                  
          this.isOwner = isOwner;
      }
      public NotesWrapper(Note note , Boolean isOwner, String formatedCreatedDate){           
          this.note = note;                                  
          this.isOwner = isOwner;
          this.formatedCreatedDate = formatedCreatedDate;
      }
        public Integer compareTo(Object ObjToCompare) {
            return Integer.valueOf(((NotesWrapper)objToCompare).lastModifiedDate.getTime() - lastModifiedDate.getTime());
        }
    }
    
  //depricated 
  @AuraEnabled
  global static Map<String,object> fetchNotes1(Id parentObjectIds,string pblockId,boolean isView){
    return null;
}

public with sharing class EnhancedtNoteWrapper{                          
	  @AuraEnabled  
	  public String Content{get;set;}
	  @AuraEnabled  
	  public String TextPreview{get;set;}
	  public Boolean isOwner{get;set;}
	  @AuraEnabled
	  public String SharingPrivacy;
	  @AuraEnabled
	  public User CreatedBy{get;set;}
	  @AuraEnabled
	  public User Owner{get;set;}
	  @AuraEnabled
	  public String FileType{get;set;}
	  @AuraEnabled    
	  public String Title; 
	  @AuraEnabled   
	  public id Id; 
	  @AuraEnabled   
	  public DateTime CreatedDate;
	  @AuraEnabled   
	  public DateTime LastViewedDate;
	  @AuraEnabled   
	  public DateTime ContentModifiedDate;
	  public DateTime lastModifiedDate {get;set;}
	  public EnhancedtNoteWrapper(ContentNote rec,String strNotes){           
		    this.Content = strNotes;
		    this.Id = rec.Id;                              
		    this.Title = rec.Title;
		    this.TextPreview = rec.TextPreview;
		    this.SharingPrivacy = rec.SharingPrivacy;
		    this.Owner  = rec.Owner;
		    this.FileType =rec.FileType;
		    this.CreatedDate = rec.CreatedDate;
		    this.LastViewedDate = rec.LastViewedDate;
		    //this.ContentModifiedDate = contentModifiedDate;
		    this.CreatedBy = rec.CreatedBy;
	  	}
    }
}