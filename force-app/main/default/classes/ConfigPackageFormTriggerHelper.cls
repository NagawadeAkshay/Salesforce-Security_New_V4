/*
This  TriggerHelper will check Validations on packageformConfig.
1.If ExternalForms is not enable it will check for FormConfig is present.
If FormConfig  Present:
2.CustomAppName of formConfig and PackConfig should be same and 
3.SobjectName of formConfig should be  equal to PackConfig  and 
  parentObject field API on formconfig should be present.

*******************************************************************************
Audit History
    
*******************************************************************************
2018-01-31         Shantanu Gadhe            Created.
08-01-2022      Tejashreee D        1. added with sharing for SF security review, Config package is Public R/W AND 
Config form is Public Read only     
*******************************************************************************
*/

public with sharing class ConfigPackageFormTriggerHelper extends TriggerHelper{

    public override void processBeforeInsert() { 
        for(PackageFormConfig__c packageFormConfig :(list<PackageFormConfig__c>)trigger.new){
           checkValidation(packageFormConfig);
        } 
    }
    
    public override void processBeforeUpdate(){
        for(PackageFormConfig__c packageFormConfig :(list<PackageFormConfig__c>)trigger.new){
             checkValidation(packageFormConfig);
        }
    }
    
    public void checkValidation(PackageFormConfig__c packageFormConfig ){
         if(packageFormConfig.ExternalForms__c == false){
             if(packageFormConfig.FormConfig__c == null){
                packageFormConfig.addError('FormConfig is Missing : Id-'+packageFormConfig.id+', InternalUniqueID-'+packageFormConfig.InternalUniqueID__c+', Name-'+packageFormConfig.Name);  
             }else if(packageFormConfig.FormConfig__c != null){
                if(packageFormConfig.PackageConfig__r.CustomAppConfig__r.Name != packageFormConfig.FormConfig__r.CustomAppConfig__r.Name){
                     packageFormConfig.addError('Custom App for Package config and Form config should be same. : Id-'+packageFormConfig.id+', InternalUniqueID-'+packageFormConfig.InternalUniqueID__c+', Name-'+packageFormConfig.Name);  
                }
                if((packageFormConfig.PackageConfig__r.PageTemplateConfig__r.SObjectName__c != packageFormConfig.FormConfig__r.SObjectName__c) && (packageFormConfig.FormConfig__r.ParentObjectFieldAPI__c == null)){
                     packageFormConfig.addError('Please specify parentObject field API on form. : Id-'+packageFormConfig.id+', InternalUniqueID-'+packageFormConfig.InternalUniqueID__c+', Name-'+packageFormConfig.Name);  
                }  
             }
         }  
    } 
    

}