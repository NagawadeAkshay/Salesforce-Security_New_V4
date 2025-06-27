@isTest
public class TestCaptureFormResponseWrapper {
    static CaptureForm__c cpForm;
    static CaptureSection__c cpSection;
    static CaptureItem__c cpItem;
    static CaptureItemResponse__c cpItemResponse;
    static SampleObject1__c sampleObject;
    static CaptureAction__c cpAction;
    @isTest  
    static  void setup(){
       SampleObject1__c sampleObject11 = Testhelper.getSampleObject1Val(true);
        List<CaptureForm__c> captureFormLst = new List<CaptureForm__c>();
        for(Integer i=0;i<1;i++) {
            captureFormLst.add(new CaptureForm__c(Name__c = 'Form Test'+i , ObjectType__c='SampleObject1__c'));
        }
        insert captureFormLst;  
        Map<Id, CaptureForm__c> captureFormMap = new Map<Id, CaptureForm__c>([SELECT Id,Name FROM CaptureForm__c]);
        List<CaptureSection__c> captureSectionLst = new List<CaptureSection__c>();
        for(Integer i = 0; i<=2; i++){
            for(Id formId: captureFormMap.keySet()){
                captureSectionLst.add(new CaptureSection__c(CaptureForm__c = formId, SectionColumn__c='Horizontal',Order__c=i, Name__c = 'Section '+i));
            }
        }
        insert captureSectionLst;
        Map<Id, CaptureSection__c> captureSectionMap = new Map<Id, CaptureSection__c>([SELECT Id,Name FROM CaptureSection__c]);  
        List<CaptureItem__c> captureItemLst = new List<CaptureItem__c>();
        for(Integer i =0; i<=2; i++){
            for(Id sectionId: captureSectionMap.keySet()){
                captureItemLst.add(new CaptureItem__c(CaptureSection__c = sectionId, QuestionRichText__c = 'Question '+i, Order__c=i, Type__c='Written'));
            }
        }
        insert captureItemLst;
        List<CaptureItemResponse__c> cpResLst =new List<CaptureItemResponse__c>();
        for(Integer i =0; i<=2;i++){
            for(CaptureItem__c cpItem : captureItemLst){
                CaptureItemResponse__c cpItemResponse = new CaptureItemResponse__c(Answer__c='Demo Val'+i,Score__c=10,CaptureItem__c=cpItem.Id, ParentId__c=sampleObject11.Id);
                cpResLst.add(cpItemResponse);
            }
        }
        insert cpResLst;       
        CaptureFormResponseWrapper.CaptureForm reult = CaptureFormResponseWrapper.getFormResponse(captureFormLst[0].id, sampleObject11.id);
         Map<String,Decimal> perForm = CaptureFormResponseWrapper.getPercentFormFilled(captureFormLst[0].id, sampleObject11.id);
        List<String> formValidate =  CaptureFormResponseWrapper.validateRequiredQuestion(captureFormLst[0].id, sampleObject11.id);
         System.assert(reult !=null);
    }
}