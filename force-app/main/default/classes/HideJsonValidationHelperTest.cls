@isTest
private class HideJsonValidationHelperTest {
    @isTest
    static void verifyHideJsonValidationHelper(){
        List<CaptureForm__c> captureFormLst = new List<CaptureForm__c>();
        for(Integer i=0;i<1;i++) {
            captureFormLst.add(new CaptureForm__c(Name__c = 'Form Test'+i , ObjectType__c='Announcement__c'));
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
        List<CaptureItem__c> lstCaptureItems = new List<CaptureItem__c>();
        for(Integer i = 0; i <= 2; i++){
            for(Id sectionId: captureSectionMap.keySet()){
                
                if(i==2){
                    String dependentJson = '{"Controllingfields": "a1b2M000005M1ub","Dependentfields": [{"Question": "Testa1b2M000005M1uZ","Value": "No","Action": "NotRequired"}]}';
                    lstCaptureItems.add(new CaptureItem__c(CaptureSection__c = sectionId,QuestionIdentifier__c='Testa1b2M000005M1uZ', QuestionApplicable__c='Required to save', QuestionRichText__c = 'Question '+i, Order__c=i, Type__c='Written'));
                }else if(i==1){
                    String dependentJson = '{"Controllingfields": "a1b2M000005M1ub","Dependentfields": [{"Question": "Testa1b2M000005M1uZ","Value": "No","Action": "NotRequired"}]}';
                    lstCaptureItems.add(new CaptureItem__c(CaptureSection__c = sectionId,QuestionIdentifier__c='a1b2M000005M1ub',DependentQuestionJson__c=dependentJson, QuestionRichText__c = 'Question '+i, Order__c=i, Type__c='Written'));
                }else{
                    String dependentJson = '{"Controllingfields": "a1b2M000005M1ub1","Dependentfields": [{"Question": "Testinga1b2M000005M1uZ","Value": "No","Action": "NotRequired"}]}';
                    lstCaptureItems.add(new CaptureItem__c(CaptureSection__c = sectionId,DependentQuestionJson__c=dependentJson, QuestionRichText__c = 'Question '+i, Order__c=i, Type__c='Written'));
                }
            }
        }
        insert lstCaptureItems;
        for(CaptureItem__c obj : lstCaptureItems){
            System.assertNotEquals(null, obj.Id);
        }
        
        HideJsonValidationHelper.hideFieldValidation(lstCaptureItems);
    }
}