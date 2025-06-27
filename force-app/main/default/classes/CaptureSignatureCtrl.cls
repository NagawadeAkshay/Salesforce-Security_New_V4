/**Added with sharing SF Security Review */
public with sharing class CaptureSignatureCtrl {
    public Attachment attachmentObj {get; set;} 
    public CaptureSignatureCtrl(){
        captureEvent();
    }     
    public static String extractRequestInfo() {
        String debugInfo = '';
        String docid;                
        Attachment attachmentObj = new Attachment();
        return null;
    }
    
    public void captureEvent(){
        Map<String, String> params = ApexPages.currentPage().getParameters();
            String debugInfo = extractRequestInfo();
            String recipient = SFDCEncoder.SFDC_JSENCODE(params.get('recipient'));
            String event = SFDCEncoder.SFDC_JSENCODE(params.get('event'));
            String senderDomain = SFDCEncoder.SFDC_JSENCODE(params.get('domain'));
            String error = SFDCEncoder.SFDC_JSENCODE(params.get('error'));
            String code = SFDCEncoder.SFDC_JSENCODE(params.get('code'));
    }
}