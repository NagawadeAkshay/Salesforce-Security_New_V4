/*
* Class shows Approval History Information for a specific Record ID
*
* CHANGE HISTORY
* =============================================================================
* Date          Name            Description
* =============================================================================
* 03/12/2018    Tomy Pallissery Added ApprovalHistoryWrapper class in order to facilitate 
                                holding of reassignment comments, which is stored in 
                                ApprovalHistoryExtension object
* =============================================================================
*/
global with sharing class ApprovalHistoryCtrl {
    transient public ApprovalList aSW {get{
        recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        return generateData();
    } private set;}
    transient public ApprovalList aSWList {get; private set;}
    public transient boolean isPDF {get;set;}
    public transient Id recordId{get;set;}
    public Integer  timeOffset {
        get{            
            TimeZone tz = UserInfo.getTimeZone();           
            return tz.getOffset(System.now());
        }set;
    } 
     
    public String dateTimeLocaleFormat{get;set;}
     
    global ApprovalHistoryCtrl (){
        dateTimeLocaleFormat = AppUtils.getUserDateTimeFormat();
    }

    global ApprovalHistoryCtrl (String recordId){
        this.recordId = recordId;
        aSWList = generateData();
        dateTimeLocaleFormat = AppUtils.getUserDateTimeFormat();
    }

    @RemoteAction @AuraEnabled(cacheable=true)
    global static Map<String, Object> fetchApprovalHistory(String recordId) {
        Map<String, Object> returnMap = new Map<String, Object>();
        ApprovalHistoryCtrl ahc = new ApprovalHistoryCtrl(recordId);
        returnMap.put('approvalHistory', ahc.aSWList);
        return returnMap;
    }

    private ApprovalList generateData(){
        ApprovalList approvalResultForObject = new ApprovalList();
        if(String.isEmpty(recordId)) {
            return approvalResultForObject;
        }
        List<ApprovalStepWrapper> aSW = new List<ApprovalStepWrapper>();
        List<Id> processWorkInstanceItems = new List<Id>();
        String recallApprovalProcessLink;
        Boolean isSubmitForApproval = true;
        for(ProcessInstance pI : getProcessHistory(recordId).values()) {
            approvalResultForObject.overAllStatus = 'Pending';
            approvalResultForObject.pIId = pI.id;
            Map<Id,List<ProcessInstanceHistory>> mapOfProcessNodeIdAndProcessInstanceHistory = new Map<Id,List<ProcessInstanceHistory>>();
            Set<Id> processNodeId= new Set<Id>(); 
            
            for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems) {
                if(processNodeId.size() ==0)
                    processNodeId.add(sWI.ProcessNodeId);
                else if(processNodeId.size()>0 && processNodeId.contains(sWI.ProcessNodeId)!= NULL)
                    processNodeId.add(sWI.ProcessNodeId);
                
                if(sWI.StepStatus != 'unknown' && sWI.StepStatus != 'Started' && sWI.ProcessNode.Name!= NULL) {
                    if(sWI.StepStatus !='Removed') {
                        approvalResultForObject.overAllStatus= (sWI.StepStatus=='Pending'? (sWI.ProcessNode.Name + '(Pending for approval)') : (sWI.ProcessNode.Name + ''));
                    } else {
                        approvalResultForObject.overAllStatus= System.Label.ApprovalRequestRecalled;
                    }
                } else if(sWI.StepStatus != 'unknown') {
                    approvalResultForObject.overAllStatus= System.Label.ApprovalRequestSubmitted;
                }
            }
            
            for(Id pNId: processNodeId) {
                ApprovalStepWrapper aSWr = new ApprovalStepWrapper();
                for(ProcessInstanceHistory sWI:pI.StepsAndWorkitems){
                    if(sWI.processNodeId == pNID){
                        aSWr.listOfSteps.add(new ApprovalHistoryWrapper(sWI));
                    }
                    if(sWI.StepStatus == 'Pending'){
                        isSubmitForApproval = false;
                    }
                    if(sWI.StepStatus == 'Reassigned'){
                        processWorkInstanceItems.add(sWI.Id);
                    }
                   
                }
                aSW.add(aSWr);
            }
        }

        if(processWorkInstanceItems.size() > 0) {
            if(Schema.sObjectType.ApprovalHistoryExtension__c.isAccessible()){
                List<ApprovalHistoryExtension__c> approvalHistExtensions = [SELECT Id, WorkInstanceItemId__c, Comments__c
                                                                    FROM ApprovalHistoryExtension__c 
                                                                    WHERE WorkInstanceItemId__c IN:processWorkInstanceItems WITH USER_MODE]; //sf review

                Map<String,ApprovalHistoryExtension__c> commentsHolderMap = new Map<String,ApprovalHistoryExtension__c>();
                if(approvalHistExtensions.size() > 0) {
                    for(ApprovalHistoryExtension__c approvalHistExt : approvalHistExtensions) {
                        commentsHolderMap.put(approvalHistExt.WorkInstanceItemId__c, approvalHistExt);
                    }
                }

                for(ApprovalStepWrapper approvalStepWr : aSW) {
                    for(ApprovalHistoryWrapper approvalHistoryWrapper : approvalStepWr.listOfSteps) {
                        if(approvalHistoryWrapper.stepStatus == 'Reassigned') {
                            ApprovalHistoryExtension__c holder = commentsHolderMap.get(approvalHistoryWrapper.pIHistory.Id);
                            if(holder != NULL) {
                                approvalHistoryWrapper.comments = holder.Comments__c;
                            }
                        }
                    }
                }
            }
        }
        

        approvalResultForObject.approvals = aSW;
        approvalResultForObject.recordId = recordId;
        approvalResultForObject.isSubmitForApproval = isSubmitForApproval;
        approvalResultForObject.recallApprovalProcessLink = recallApprovalProcessLink;
        return approvalResultForObject;
    }
    
    private Map<Id,ProcessInstance> getProcessHistory(Id objectId){
       return new Map<Id,ProcessInstance>([SELECT Id, (SELECT ID, ProcessNodeId, StepStatus,Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending ,OriginalActorId,ProcessInstanceId,
                        RemindersSent,CreatedDate, Actor.Name, OriginalActor.Name , ProcessNode.Name, ProcessNode.ProcessDefinitionId FROM StepsAndWorkitems order by IsPending desc,createddate desc ) 
                        FROM ProcessInstance where TargetObjectId =:objectId WITH USER_MODE order by CreatedDate DESC]); //polymorphic field
    }

    @TestVisible 
    public with sharing class ApprovalWrapper{
        @AuraEnabled
		public list<sObject> ObjectList {get;set;}
		@AuraEnabled
		public Map<String, String> fieldKeyMap {get;set;}
		@AuraEnabled
		public Map<String, String> fieldDataMap  {get;set;}
		@AuraEnabled
		public Map<String, Integer> scale {get;set;}
		@AuraEnabled
		public String timelol {get;set;}   
		@AuraEnabled
		 public String userLol {get;set;}
		@AuraEnabled
		public String field {get;set;}
		 @AuraEnabled
		public String requiredfield {get;set;}
		 @AuraEnabled
		public String testrequired {get;set;}
		 @AuraEnabled
		public String fieldlabel {get;set;}
		@AuraEnabled
		public String key {get;set;}
		@AuraEnabled 
		public Boolean IsKeyAvailable{get;set;}
		@AuraEnabled 
		public String KeyValueMapRequired {get;set;}
		@AuraEnabled 
		public String AlternateFieldLabel {get;set;}
		@AuraEnabled 
		public Boolean IsAlternateFieldAvailable {get;set;}
		@AuraEnabled 
		public Boolean IsAlternateFieldRequired {get;set;}
		@AuraEnabled 
		public String parentObjectName {get;set;}
		@AuraEnabled 
		public String parentObjectType {get;set;}
		@AuraEnabled 
		public String parentObjectClassName {get;set;}
		@AuraEnabled 
		public Boolean IsfieldKeyMapAvailable {get;set;}
		@AuraEnabled 
		public Boolean IsfieldDataMapAvailable {get;set;}
		@AuraEnabled 
		public Boolean IsRequiredfield {get;set;}
		@AuraEnabled 
		public String RecordTypeName {get;set;}
         

        public ApprovalWrapper(list<sObject> sObjectList, Map<String, String> fieldLableMap,Map<String, String> fieldDataTypeMap,Map<String, Integer> scaleMap,String label,Boolean IsKeyAvailable,String KeyValueMapRequired,String AlternateFieldLabel, String parentObjectName, String parentObjectType, String parentObjectClassName,boolean IsfieldKeyMapAvailable,boolean IsfieldDataMapAvailable, boolean IsRequiredfield, string RecordTypeName){
            this.ObjectList = sObjectList;
        this.fieldKeyMap = fieldLableMap;
        this.fieldDataMap = fieldDataTypeMap;
        this.scale = scaleMap;
        this.timelol = (UserInfo.getTimeZone()).toString();
        this.userLol =UserInfo.getLocale();
        this.field = label;
        this.requiredfield = label;
        this.testrequired = label;
        this.fieldlabel = label;
        this.key  = label;
        this.IsKeyAvailable = IsKeyAvailable;
        this.KeyValueMapRequired = KeyValueMapRequired;
        this.AlternateFieldLabel = AlternateFieldLabel;
        this.parentObjectName = parentObjectName;
        this.parentObjectType = parentObjectType;
        this.parentObjectClassName = parentObjectClassName;
        this.IsfieldKeyMapAvailable = IsfieldKeyMapAvailable;
        this.IsfieldDataMapAvailable = IsfieldDataMapAvailable;
        this.IsRequiredfield = IsRequiredfield;
        this.RecordTypeName = RecordTypeName;
        }
    }
    
    public with sharing class ApprovalStepWrapper{
        @AuraEnabled
        public List<ApprovalHistoryWrapper> listOfSteps {get;set;}
        @AuraEnabled
        public String stepStatus{get;set;}
        @AuraEnabled
        public String stepStatus2;
        public ApprovalStepWrapper(){
            listOfSteps = new  List<ApprovalHistoryWrapper>();
        }
    }

    public with sharing class ApprovalHistoryWrapper{
        @AuraEnabled
        public Datetime createdDate {get;set;}
        @AuraEnabled
        public String formattedCreatedDate {get;set;}
        @AuraEnabled
        public String originalActorName {get;set;}
        @AuraEnabled
        public String actorName {get;set;}
        @AuraEnabled
        public String comments {get;set;}
        @AuraEnabled
        public String stepStatus {get;set;}
        @AuraEnabled
        public String stepStatus2;
        @AuraEnabled
        public ProcessInstanceHistory pIHistory {get;set;}
        @AuraEnabled
        public String pIhId {get;set;}
        @AuraEnabled
        public Boolean showActualApprover {get;set;}

        public ApprovalHistoryWrapper(ProcessInstanceHistory pIH){
            createdDate = pIH.CreatedDate;
            formattedCreatedDate = createdDate != NULL ? createdDate.format(AppUtils.getUserDateTimeFormat()) : '';
            originalActorName = pIH.OriginalActor.Name;
            actorName = pIH.Actor.Name == 'Automated Process' ? pIH.OriginalActor.Name : pIH.Actor.Name ;
            comments = pIH.comments;
            stepStatus = pIH.Stepstatus;
            stepStatus2 = pIH.Stepstatus == 'Removed' ? (System.Label.ApprovalHistoryRecallOverallLabel != null ? System.Label.ApprovalHistoryRecallOverallLabel : 'Removed' ) : pIH.Stepstatus; 
            showActualApprover = pIH.Stepstatus == 'Removed' ? false : true;
            pIHistory = pIH;
            pIhId = pIH.id;
        }
    }
    
    public with sharing class ApprovalList{
        @AuraEnabled
        public List<ApprovalStepWrapper> approvals {get;set;}
        @AuraEnabled
        public String recallApprovalProcessLink {get;set;}
        @AuraEnabled
        public Boolean isSubmitForApproval {get;set;}
        @AuraEnabled
        public Id recordId {get;set;}
        @AuraEnabled
        public String overAllStatus {get;set;}
        @AuraEnabled
        public String pIId {get; set;}
        public ApprovalList(){
            approvals = new List<ApprovalStepWrapper>();
            isSubmitForApproval = true;
        }
    }
      
}