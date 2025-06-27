/**
**/
public with sharing class PageBlockEditPageCtrl{
    
    public ID recordId {get;set;}
    public String orgType {get;set;}
    public PageReference savePage {get;set;}
    public PageReference cancelPage {get;set;}
    public String templateName{get;set;}
    public List<DynamicLayoutDefaultValueHelper> listDefaultValues {get;set;}

    public PageBlockEditPageCtrl(ApexPages.StandardController stdController) {
        recordId =SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));   //NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding   
        templateName = 'PageBlockLayout';
    }   
    public string getKeyValueMap(){
        Map<String,String> keyValueMap = new Map<String,String>();
        keyValueMap.put('orgId',recordId);
        return JSON.serialize(keyValueMap);
    }
}