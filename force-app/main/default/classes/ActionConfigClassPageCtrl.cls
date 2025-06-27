/**
**/
global with sharing class ActionConfigClassPageCtrl{

    public Id classId;

    public ActionConfigClassPageCtrl(){
        String className = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('className'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(String.isNotBlank(className)){
            List<ApexClass> lstClasses = new List<ApexClass>([SELECT Id FROM ApexClass WHERE Name =: className WITH USER_MODE]); //CRUD/FLS False +ve As per business scenario we can't check for portal/external users //SOQL Injection - False +ve - Dynamic part of query is static bind 
            if(!lstClasses.isEmpty()){
                classId = lstClasses[0].Id;
            }
        }
    }

    public PageReference getActionClass(){
        if(classId != null){
            PageReference pageRef = new PageReference(URL.getOrgDomainURL().toExternalForm() +'/'+classId);//ApexOpenRedirect  - False +Ve - fetching lstClasses[0].Id from query 
            return pageRef; 
        } else {
            return null;
        }        
    }
}