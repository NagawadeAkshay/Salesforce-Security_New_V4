global with sharing class DigitallySignedCtrl {
    global Id parentObjectId{get;set;} 
    global String titleValue{get; set; }
    global String pageBlockId {get;set;}
    global String classification {get;set;}
    global Boolean isDigiSign {get;set;}
    public Boolean isViewVal{get;set;}
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
    global DigitallySignedCtrl() {    	

    }
    //Method to fetch documents
    @RemoteAction
    global static Map<String,object> fetchDocuments(String parentObjectId,String pblockId,boolean isView,Boolean loadConfigData,boolean isDigiSign){
    	Map<String,object> returnMap = new Map<String,object>();
        List<AttachmentExtension__c> attachExtList;
		if(Schema.sObjectType.AttachmentExtension__c.isAccessible()){
			if(isDigiSign == true) {
				attachExtList = [SELECT Id,CreatedDate,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c,signedDocument__r.ParentId__c,signedDocument__r.LastModifiedDate,signedDocument__r.Attachment__c,DigitalSignature__r.SignatureStatus__c,DigitalSignature__r.DocverifyId__c 
				FROM AttachmentExtension__c 
				WHERE ParentId__c =: parentObjectId and Classification__c =:'Digitally Signed Original' WITH USER_MODE];
				for(AttachmentExtension__c a : attachExtList) {
				}
			} else {
					attachExtList = [SELECT Id,CreatedDate,Classification__c,Attachment__c,ParentId__c ,HistoryReason__c  FROM AttachmentExtension__c 
					WHERE ParentId__c =: parentObjectId and Classification__c !='Digitally Signed Original' WITH USER_MODE];
				}
		}
        Map<String, AttachmentExtension__c> extMap = new Map<String, AttachmentExtension__c>();
        List<String> attachments = new List<String>();
        for(AttachmentExtension__c ae: attachExtList) {
            extMap.put(ae.Attachment__c, ae);
            attachments.add(ae.Attachment__c);
        }
		List<Attachment> attList = new List<Attachment>();
		if(Attachment.sObjectType.getDescribe().isAccessible() == true){ 
			attList = [SELECT Id, Description, Name,CreatedDate, LastModifiedDate, Owner.Name 
										FROM Attachment WHERE Id IN: attachments WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
		}										
		List<AttachmentWrapper> result = new List<AttachmentWrapper>();
		for(Attachment a: attList) {
			AttachmentExtension__c attExt = extMap.get(a.Id);
			//result.add(new AttachmentWrapper(extMap.get(a.Id), a));
			result.add(new AttachmentWrapper(attExt.CreatedDate, attExt.signedDocument__r.LastModifiedDate, attExt.signedDocument__r.Attachment__c, attExt.DigitalSignature__r.SignatureStatus__c, attExt.DigitalSignature__r.Id, attExt.DigitalSignature__r.DocverifyId__c, a));
		}		
        returnMap.put('DocumentList',result);
        Map<String,object> AttachmentConfigMap = new Map<String,Object>();
        if(loadConfigData){
          AttachmentConfigMap = getDocumentConfigData(pblockId,parentObjectId,isView);
          returnMap.put('ActionConfig',AttachmentConfigMap.get('ActionConfig'));  
          returnMap.put('HideDisableRowActions',AttachmentConfigMap.get('HideDisableRowActions'));
        }     
        return returnMap;
    }
    private static Map<String,object> getDocumentConfigData(String pblockId,Id parentObjectId,boolean isView){
    	Id actionConfId = Schema.SObjectType.PageAttachmentConfig__c.getRecordTypeInfosByName().get('Action config').getRecordTypeId();
		String sObjName = parentObjectId.getSObjectType().getDescribe().getName(); 
		List<PageAttachmentConfig__c> pageAttachmentActionConfigList = new List<PageAttachmentConfig__c>();  
		if(PageAttachmentConfig__c.sObjectType.getDescribe().isAccessible() == true){   
			pageAttachmentActionConfigList = [SELECT Id,Name,RecordTypeId,HideForProfile__c,PageBlockConfig__r.HideDisableRowactions__c,PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c,HideForContext__c,HideForUser__c,HideDecisionField__c,HideOperator__c,Classification__c,AttachmentCount__c 
												FROM PageAttachmentConfig__c
												WHERE PageBlockConfig__c=:pblockId and RecordTypeId =:actionConfId WITH USER_MODE];
		} 
		Map<String,Object> attachmentActionConfigMap = new Map<String,object>();
		Map<String,Object> AttachmentActionNameToInfoMap = new Map<String,Object>();
		Boolean isInternal = AppUtils.isInternalUser();
		Boolean isApplicant = AppUtils.isApplicant();
		String userProfile = AppUtils.getProfileInfo();  
		if(pageAttachmentActionConfigList.size() > 0){ //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
			String SOQLquery = DigitallySignedCtrl.prepareSOQL(pageAttachmentActionConfigList,parentObjectId);	
			SObject parentObj;
			if( SOQLquery != null ) {//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
				parentObj = Database.query( SOQLquery , AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes in DigitallySignedCtrl.prepareSOQL method.
			}
			for(PageAttachmentConfig__c attConfig : pageAttachmentActionConfigList){
				Map<String,Object> AttachmentActionInfo = new Map<String,object>();
				Boolean hideAction = AppUtils.showHideComponent(isView, isInternal, isApplicant, attConfig.HideForProfile__c, (String)parentObjectId, attConfig.HideForContext__c, attConfig.HideForUser__c, userProfile,attConfig.HideOperator__c);	
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
			attachmentActionConfigMap.put('ActionConfig',AttachmentActionNameToInfoMap);
			attachmentActionConfigMap.put('HideDisableRowActions',pageAttachmentActionConfigList[0].PageBlockConfig__r.HideDisableRowactions__c);
		}else{
			attachmentActionConfigMap.put('HideDisableRowActions','');
		}
		return attachmentActionConfigMap;
    }
    
	private static String prepareSOQL(List<PageAttachmentConfig__c> pageAttachmentConfigList, Id parentObjectId) {
		String sObj = pageAttachmentConfigList[0].PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c;
		SoqlBuilder2 soqlBuilder = new SoqlBuilder2()
			.selectx('Id');
		if(sObj.equalsIgnoreCase('case')){
		} else {
			soqlBuilder.selectx('Name');
		}
		for (PageAttachmentConfig__c pb : pageAttachmentConfigList) { 
			soqlBuilder.selectx(pb.HideDecisionField__c);
		}
		soqlBuilder
			.fromx(string.escapeSingleQuotes(pageAttachmentConfigList[0].PageBlockConfig__r.TabLayoutConfig__r.PageLayoutConfig__r.ObjectAPIName__c))
			.wherex('Id', '=', string.escapeSingleQuotes(parentObjectId), null);
		return soqlBuilder.toSoql();
	}
    @RemoteAction
    global static void cancelSignature(String apiKey,String apiSig,String DocverifyId){    
    }
    
    @RemoteAction
	global static Map<String,Object> deleteDocument(String docId){
		Map<String, Object> retVal = new Map<String, Object>();
		return retVal;    
	} 
    public with sharing class AttachmentWrapper implements Comparable{
        public Attachment attachment {get;set;}
        public DateTime CreatedDate {get;set;}
        public DateTime LastModifiedDate {get;set;}
        public String SignedAttachment {get;set;}
        public String SignatureStatus {get;set;}
        public String digisignatureId {get;set;}
        public String docVerifyId {get;set;}
        
        public AttachmentWrapper(DateTime CreatedDate, DateTime LastModifiedDate, String SignedAttachment, String SignatureStatus, String digisignatureId, String docVerifyId, Attachment attachment) {
        	this.LastModifiedDate = CreatedDate;
        	this.LastModifiedDate = LastModifiedDate;
        	this.SignedAttachment = SignedAttachment;
        	this.SignatureStatus = SignatureStatus;
        	this.digisignatureId = digisignatureId;
        	this.docVerifyId = docVerifyId;
        	this.attachment = attachment;
        	
        }
        /*public AttachmentExtension__c attachmentext {get;set;}
        public AttachmentWrapper(AttachmentExtension__c attachmentext,Attachment attachment){
            this.attachmentext = attachmentext; 
            this.attachment = attachment ;                                  
        }*/
        public Integer compareTo(Object ObjToCompare) {
            return Integer.valueOf(((AttachmentWrapper)objToCompare).CreatedDate.getTime() - CreatedDate.getTime());
        }
    }   
}