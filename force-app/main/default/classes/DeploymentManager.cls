/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review
    ****************************************************************************************
*/
global with sharing class DeploymentManager {    

    global Id DeploymentId {get; set;}    
    global string DeploymentStatus {get; set;}    
    global boolean IsSuccess {get; set;}    
    global boolean IsDone {get; set;} 
    global string Message {get; set;}
    
    global DeploymentManager(){   
        Message = '';
        IsDone = false;
        IsSuccess = false;
        DeploymentStatus = '';
    }   
  
    global PageReference initDeployPageLayouts(){ 
        this.Message = 'Message connected...';
        String nameSpacePrefix = 'GNT';
        StaticResource resource;
        if(Test.isRunningTest()){
            resource = new StaticResource();
            resource.Body = Blob.valueOf('Test Data');
        }else{
            if(StaticResource.sObjectType.getDescribe().isAccessible() == true){ 
                resource = [SELECT Id, Body, Name,NamespacePrefix FROM StaticResource WHERE Name='ConfigPageLayouts' AND NamespacePrefix=:nameSpacePrefix WITH USER_MODE LIMIT 1];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
            }
        }

        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = false;
        deployOptions.runTests = null;
        deployOptions.runAllTests = false;
        deployOptions.singlePackage = true;     
        try{
            MetadataService.AsyncResult asyncResult = service.deploy(EncodingUtil.base64Encode(resource.body).trim(),deployOptions);
            if(asyncResult!= NULL && asyncResult.Id != NULL){
                this.DeploymentId = asyncResult.Id;
                this.DeploymentStatus = asyncResult.State;
                this.Message = asyncResult.State == 'Succeeded' ?  'PageLayout Deployment ::'+asyncResult.State : 'PageLayout Deployment ::'+asyncResult.message;               
            } 
        }
        catch(Exception e){                    
           this.Message = AppUtils.handleSystemExceptionMsg(e) + '' + e.getLineNumber();     
        }
        return null;
    }
    global void verifyDeploymentStatus(){
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult result = service.checkDeployStatus(this.DeploymentId,true);
        this.DeploymentId = result.Id;
        this.DeploymentStatus = result.status;
        this.IsSuccess = result.success;
        this.IsDone = result.done;
        this.Message = 'PageLayout Deployment :: '+this.DeploymentStatus; 
    }
    global PageReference checkDeploymentStatus(){
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult result = service.checkDeployStatus(this.DeploymentId,true);
        this.DeploymentId = result.Id;
        this.DeploymentStatus = result.status;
        this.IsSuccess = result.success;
        this.IsDone = result.done;       
        return null;       
    }
    
    public static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId =  UserInfo.getSessionId();
        return service;    
    }  
}