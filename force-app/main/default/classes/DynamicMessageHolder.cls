/**
**/
global with sharing class DynamicMessageHolder {
    
    public String parentId {get;set;}
    public List<String> messages {get;set;}
    public Boolean hasPageMessages {get;set;}
    public Boolean hasPageBlockMessages {get;set;}
    public Boolean hasMessagesToRender {get;set;}
    public transient Map<String,List<Message>> stdStyleMsgListMap{get; set;}
    public transient Map<String,Boolean> msgBlockRenderMap {get; set;}
    private transient boolean isViewLayout;
    private transient boolean isInternal;
    private transient boolean isApplicant;
    private transient string recordId;
    private transient string userProfile;
    
    private static transient List<DynamicMessageHolder> dynamicMessageHolderList = new List<DynamicMessageHolder>();
    public static transient Set<String> renderMessageFieldAPINameList = new Set<String>();
    
    
     public DynamicMessageHolder(String Id,Boolean isViewLayout,boolean isInternal,boolean isApplicant,String userProfile,string recordId){
        //Bug 133049: SD | Guest User Profile | External User Registration Issue | Merge Field not supports
        if(recordId == null || recordId == ''){
            Boolean skipUpdateAccessCheckForGuestUser = AppUtils.isSkipPermissionCheck();
            String gurId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('gurId'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
            if(skipUpdateAccessCheckForGuestUser && gurId != null && gurId != ''){
                recordId = gurId;
            }
        }
        this.isViewLayout = isViewLayout;
        this.recordId = recordId;
        this.isInternal = isInternal;
        this.isApplicant = isApplicant;
        this.userProfile = userProfile;
        this.parentId = Id;
        this.hasMessagesToRender = false;
        dynamicMessageHolderList.add(this);
       
    }
    
    public static void processDynamicMessageRecords() {
        if(dynamicMessageHolderList ==null || dynamicMessageHolderList.size() == 0) return;
        Map<String, DynamicMessageHolder> configObjById = new Map<String, DynamicMessageHolder>();
        for(DynamicMessageHolder messageHolder : dynamicMessageHolderList) {
            configObjById.put(messageHolder.parentId, messageHolder);
        }
        Map<String, List<MessageConfig__c>> messageByParentIdMap = new Map<String, List<MessageConfig__c>>(); 
        List<MessageConfig__c> messageList = new List<MessageConfig__c>();
        if(Schema.sObjectType.MessageConfig__c.isAccessible()){
            messageList = [SELECT ID,Name,RenderDecisionField__c,PageLayoutConfig__c,SetTimeOut__c,
                                                PageBlockConfig__c, MessageRich__c,HideForUser__c,HideForContext__c,HideForProfile__c,
                                                StandardStyle__c FROM MessageConfig__c 
                                                WHERE (PageLayoutConfig__c in :configObjById.KeySet() OR PageBlockConfig__c in :configObjById.KeySet()) WITH USER_MODE];
        }                                    
        for(MessageConfig__c msg : messageList) {
            if(msg.PageLayoutConfig__c != null) {
                if(messageByParentIdMap.get(msg.PageLayoutConfig__c) == null) {
                    messageByParentIdMap.put(msg.PageLayoutConfig__c, new List<MessageConfig__c>());
                }
                messageByParentIdMap.get(msg.PageLayoutConfig__c).add(msg);
            }
            
            if(msg.PageBlockConfig__c != null) {
                if(messageByParentIdMap.get(msg.PageBlockConfig__c) == null) {
                    messageByParentIdMap.put(msg.PageBlockConfig__c, new List<MessageConfig__c>());
                }
                messageByParentIdMap.get(msg.PageBlockConfig__c).add(msg);
            }
        }
        for(String parentId : configObjById.keySet()) {
            List<MessageConfig__c> msgs = messageByParentIdMap.get(parentId);
            DynamicMessageHolder messageHolder = configObjById.get(parentId);
            messageHolder.stdStyleMsgListMap = new Map<String,List<Message>>();
            messageHolder.messages = new List<String>();
            String mergeFieldsReplacedMsg='';
            if(msgs != null) {
                List<Message> msgList;
                for( MessageConfig__c plm : msgs ){              
                    Message m = new Message();
                    m.messageId = plm.Id;
                    m.name = plm.Name;
                    m.renderDecisionField = plm.RenderDecisionField__c;
                    if(String.isNotEmpty(m.renderDecisionField)) {
                        renderMessageFieldAPINameList.add(m.renderDecisionField);
                    }
                    m.layoutId = plm.PageLayoutConfig__c;
                    m.blockId = plm.PageBlockConfig__c;                        
                    m.isRendered = true;
                    m.hidePageMessage = AppUtils.showHideComponent(messageHolder.isViewLayout, messageHolder.isInternal, messageHolder.isApplicant,plm.HideForProfile__c, messageHolder.recordId, 
                                                                        plm.HideForContext__c, plm.HideForUser__c, messageHolder.userProfile);
                        
                    if(plm.PageBlockConfig__c != null){
                        messageHolder.hasPageBlockMessages = true;
                    }
                    if(plm.PageLayoutConfig__c != null){
                        messageHolder.hasPageMessages = true;
                    }
                    if(plm.SetTimeOut__c != null){
                          m.setTimeOut = plm.SetTimeOut__c;
                    }
                    String valueString='';
                    if(String.isNotEmpty(plm.StandardStyle__c)){ 
                        String value = plm.StandardStyle__c;      
                        valueString = value;                                   
                        PageMessageStyleConfig__c msgStyle= new PageMessageStyleConfig__c();
                        msgStyle= PageMessageStyleConfig__c.getValues(valueString); 
                        if(msgStyle != null){
                            m.bgGradientColor1 = msgStyle.BackgroundGradient1Color__c;
                            m.bgGradientColor2 = msgStyle.BackgroundGradient2Color__c;
                            m.textColor =  msgStyle.TextColor__c;
                        }                                        
                        if(messageHolder.recordId != null){             
                            mergeFieldsReplacedMsg = AppUtils.replaceMergeFields(plm.MessageRich__c,messageHolder.recordId);  
                        } else {
                            mergeFieldsReplacedMsg = plm.MessageRich__c;
                        }              
                        m.message = mergeFieldsReplacedMsg;
                        m.standardStyle = plm.StandardStyle__c;                                                  
                    } 
                    if(!messageHolder.stdStyleMsgListMap.isEmpty() && messageHolder.stdStyleMsgListMap.containsKey(valueString)){
                        List<Message> msgInMapList = new List<Message>();
                        msgInMapList = messageHolder.stdStyleMsgListMap.get(valueString); 
                        msgInMapList.add(m);   
                    }
                    else{
                        msgList = new List<Message>();
                        msgList.add(m);
                        messageHolder.stdStyleMsgListMap.put(valueString,msgList);
                    }            
                }        
                for(String s : messageHolder.stdStyleMsgListMap.keySet()){
                    messageHolder.messages.add(s);
                }
            }
            messageHolder.msgBlockRenderMap = new Map<String,Boolean> ();
            if(messageHolder.messages.size() > 0){
                messageHolder.hasMessagesToRender = true;
            }
        }
                                                
        
    }
   
    
    
    public void updateRenderOnDecision(String objectName, String recordId, SObject record){

        Integer notRenCt = 0;
        //if context is create, recordId will be null
        //no need to update render decision fields
        //display all info messages
        
        if(recordId != null && recordId != ''){
            
            if(stdStyleMsgListMap == null) {
                return;
            }
                
            for(String keyValue:stdStyleMsgListMap.keySet()){
                List<Message> messages = stdStyleMsgListMap.get(keyValue);
                Boolean blockRenderer = false;
                for( Message msg : messages ){
                    if(msg.renderDecisionField != null && msg.renderDecisionField != ''){
                        if(msg.hidePageMessage != null){
                            msg.isRendered = (Boolean)record.get(msg.renderDecisionField) && !msg.hidePageMessage;
                        }else{
                            msg.isRendered = (Boolean)record.get(msg.renderDecisionField);
                        }                       
                    }else{
                        msg.isRendered = msg.hidePageMessage != null? !msg.hidePageMessage : true;
                    }
                    blockRenderer = blockRenderer || (msg.isRendered == true ? true :false);                    
                }            
                msgBlockRenderMap.put(keyValue,blockRenderer);
            }

        }else{
            for(String keyValue:stdStyleMsgListMap.keySet()){
                List<Message> messages = stdStyleMsgListMap.get(keyValue);
                Boolean blockRenderer = false;
                for(Message msg : messages){
                    msg.isRendered = msg.hidePageMessage != null? !msg.hidePageMessage : true;
                    if(msg.isRendered != true){
                        notRenCt++;
                    }
                    blockRenderer = blockRenderer || (msg.isRendered == true ? true :false); 
                }
                
                msgBlockRenderMap.put(keyValue,blockRenderer);
            }
        }        
        if(notRenCt == messages.size()){
            hasMessagesToRender = false;
        }
    }
    
    
    /*
    * Represents a dynamic message object to be displayed
    */
    public with sharing class Message {
        public String layoutId {get;set;}
        public String blockId {get;set;}
        public String messageId {get;set;}
        public String name {get;set;}
        public String message {get;set;}
        public String renderDecisionField {get;set;}
        public boolean hidePageMessage {get;set;}
        public Boolean isRendered {get;set;}
        public String bgGradientColor1 {get;set;}
        public String bgGradientColor2 {get;set;}
        public String textColor{get;set;}
        public String standardStyle{get;set;}
        public double setTimeOut{get;set;}
        
        public Message() {
            this.message = '';
        }
    }
    
}