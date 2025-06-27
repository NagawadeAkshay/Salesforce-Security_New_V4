// Deprecated class
global with sharing class LightningFileUploadCtrl{
 
  public String lghtURL{get;set;}
  public String userInfoId{get;set;}
  global String namespacePrefix{get{
  	 if(String.isEmpty(namespacePrefix)){
            return AppUtils.getNameSpacePrefix();
        }   
        return namespacePrefix; 
  	}set;}
  
  global LightningFileUploadCtrl(){} 
}