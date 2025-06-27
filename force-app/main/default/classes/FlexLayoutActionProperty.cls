/**
    For a single button on flex view layout, it tells you if the button 
    should be rendered in disabled mode. Also it provides onclick properties
    for that button.

    @author Shah Kadirmohideen
*/
global with sharing class FlexLayoutActionProperty {
    public PageLayoutActionConfig__c action {get; set;}
    public Boolean disable {get; set;}
    public Boolean openModal {get; set;}
    public Boolean openNewWindow {get; set;}
    public Boolean openInTab {get;set;}
    public String url {get; set;}
    public String lightningUrl{get;set;}
    public String modalTitle {get; set;}
    public String className {get; set;}
    public String iconCSS {get;set;}
    public String refreshBehaviour{get;set;}
    public Integer modalHeight {get; set;}
    public Integer modalWidth {get; set;}
    public String submitWarningMsg {get;set;}
    public String toolTip {get; set;}
    public String toolTipId {get; set;}
    public String toolTipFooterId {get; set;}
    public Boolean showIconOnly {get; set;}
    public Boolean hideFromHeaderPanel {get; set;}
    public Boolean hideFromFooterPanel {get; set;}
    public Boolean showAsButton{get;set;}
    public Boolean showAsMenu{get;set;}
    public String promptDialogHeader{get;set;}
    public String promptDialogInputText{get;set;}
    public String buttonHelpText{get;set;}

    private String recordId;
    private String objectName;

    global FlexLayoutActionProperty(PageLayoutActionConfig__c action, String recordId, String objectName) {
        this.action = action;
        this.recordId = recordId;
        this.objectName = objectName;           
        init();
    }

    public override String toString() {
        return 'action: ' + action + ', disable: ' + disable;
    }

    /* PRIVATE METHODS */

    private void init() {
        buttonHelpText = action.ButtonHelpText__c;
        disable = false;
        iconCSS = action.IconCSS__c;
        refreshBehaviour = action.RefreshBehaviour__c;
        toolTip = action.ToolTip__c;
        toolTipId = action.Id + 'tooltip';
        toolTipFooterId = action.Id + 'tooltipFooter';
        showIconOnly = action.ShowIconOnly__c;
        showAsButton = action.DisplayArea__c == null || action.DisplayArea__c == 'Page Header' || action.DisplayArea__c == 'Both';
        showAsMenu = action.DisplayArea__c == 'Menu' || action.DisplayArea__c == 'Both';
        initWindowBehavior();
        initModalProperties();
        initClass();
        initURL();
        initWarningMessage();
        initPromptInputDailogBox();
        initHidePanel();
    }

    private void initPromptInputDailogBox(){
        promptDialogHeader = '';
        promptDialogInputText = '';
        if(action.EnablePromptInputDialog__c){
           if(String.isNotEmpty(action.PromptDailogHeader__c)){
               promptDialogHeader = String.escapeSingleQuotes(action.PromptDailogHeader__c);
           }
           if(String.isNotEmpty(action.PromptDialogText__c)){
               promptDialogInputText = String.escapeSingleQuotes(action.PromptDialogText__c);
           }
        }
    }
    private void initWindowBehavior() {
        openModal = false;
        openNewWindow = false;
        openInTab = false;
        if (action.ActionBehavior__c == 'Open in overlay') {
            openModal = true;
        }
        else if (action.ActionBehavior__c == 'Open in new window') {
            openNewWindow = true;
        }else if(action.ActionBehavior__c == 'Open in new tab'){
            openInTab = true;
        }               
    }

    private void initModalProperties() {
        modalHeight = 0;
        modalWidth = 0;
        if (action.ModalHeight__c != null) {
            modalHeight = Integer.valueOf(action.ModalHeight__c);
        }
        if (action.ModalWidth__c != null) {
            modalWidth = Integer.valueOf(action.ModalWidth__c);
        }
         if (action.ModalTitle__c != null) {
            modalTitle = (String)action.ModalTitle__c;
        }
    }

    private void initWarningMessage() {
        submitWarningMsg = '';
        if(String.isNotEmpty(action.SubmitWarningMessageLong__c)) {
            submitWarningMsg = String.escapeSingleQuotes(action.SubmitWarningMessageLong__c);
        } else if(String.isNotEmpty(action.SubmitWarningMessage__c)) {
            submitWarningMsg = String.escapeSingleQuotes(action.SubmitWarningMessage__c);
        }
    }

    private void initClass() {
        className = '';
        if(action.StandardAction__c == 'Delete'){
            className = 'DynamicLayoutDeleteHelper';
        }       
        else if (String.isNotEmpty(action.ActionClass__c)) {
            className = action.ActionClass__c;  
        }       
    }

    private void initURL() {
        lightningUrl = action.ActionURLLightning__c; // False+ve for URL redirection attack as this a Admin populated field.

        Boolean isValidJSON = false;
        if(AppUtils.isLightningTheme() && String.isNotEmpty(lightningUrl)){
            try{
                Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(lightningUrl);
                isValidJSON = true;
            }catch(JSONException e){
            }     
            
            if(!isValidJSON){
                lightningUrl = replaceMergeFields(lightningUrl, objectName, recordId);
            }
        }
    }

    private void initHidePanel() {
        this.hideFromHeaderPanel = false;
        this.hideFromFooterPanel = false;
        if (action.HidePanel__c != null && action.HidePanel__c == 'Header') {
            this.hideFromHeaderPanel = true;
        }
        if (action.HidePanel__c != null && action.HidePanel__c == 'Footer') {
            this.hideFromFooterPanel = true;
        }
    }

    private String replaceMergeFields(String urlString, String objectName, String recordId){                
        if(urlString != null && recordId != null){
            recordId = String.escapeSingleQuotes(recordId);
            Pattern regex = Pattern.compile('\\{!([^}]*)\\}'); 
            Matcher regexMatcher = regex.matcher(urlString); 
            Set<String> tokens = new Set<String>();
    
            while (regexMatcher.find()){//SOQL/SOSL Injection False +ve         
                String dirtyVariable = regexMatcher.group();
                String variable = dirtyVariable.substring(2,dirtyVariable.length()-1);
                if(!tokens.contains(variable)){
                    tokens.add(variable); 
                } 
            } 
            //Build dynamic query
            
            if(tokens != null && tokens.size() > 0){
                String qry = 'Select ';
                for(String s : tokens){
                    qry += String.escapeSingleQuotes(s) + ',';
                }
                
                qry = qry.substring(0, qry.length()-1); 
                SObject o = Database.query(qry + ' From ' + String.escapeSingleQuotes(objectName) + ' Where ID = :recordId',AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic parts of the query string is ecsapeSingleQuotes to prevent SOQL Injection    
                for(String s : tokens){         
                    urlString = urlString.replace('{!'+ s + '}', getValue(o, s)); 
                }  
            }
        }     
        return urlString; 
    }   

    private String getValue(SObject o, String fieldName){
        return (o.get(fieldName) != null) ? String.valueOf(o.get(fieldName)) : '';
    }

}