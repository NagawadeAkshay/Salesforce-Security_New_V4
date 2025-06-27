/**
**/
public with sharing class PageBlockDetailEditPageCtrl{
    public ID recordId {get;set;}
    public PageReference savePage {get;set;}
    public PageReference cancelPage {get;set;}
    public String templateName{get;set;}
    public List<DynamicLayoutDefaultValueHelper> listDefaultValues {get;set;}
    
    public PageBlockDetailEditPageCtrl(ApexPages.StandardController controller) {
            recordId = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding  
            listDefaultValues = new List<DynamicLayoutDefaultValueHelper>();
            DynamicLayoutDefaultValueHelper dv = new DynamicLayoutDefaultValueHelper('Type','Regular',true);
            listDefaultValues.add(dv);
            templateName = 'PageBlockDetailLayout';
    }
    public string getKeyValueMap(){
        Map<String,String> keyValueMap = new Map<String,String>();
        
        return JSON.serialize(keyValueMap);
    }
}