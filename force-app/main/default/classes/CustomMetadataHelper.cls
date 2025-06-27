public with sharing class CustomMetadataHelper {
    public Metadata.CustomMetadata keyValueHolderMetadata;
   
    public CustomMetadataHelper(String fullName, String label) {
        this.keyValueHolderMetadata =  new Metadata.CustomMetadata();
        this.keyValueHolderMetadata.fullName = fullName;
        this.keyValueHolderMetadata.label = label;
    }

    public void setupTextFieldValue(Map<String,Object>fieldValueMap){

        List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
        for(String key : fieldValueMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            if(key == 'Description__c')
                customField.value = (String)fieldValueMap.get(key);
            else
		        customField.value = (String)fieldValueMap.get(key);
            customFields.add(customField);
        }	
       
    }
    public void setupBooleanFieldValue(Map<String,Object>fieldValueMap){

        List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
        for(String key : fieldValueMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            if(key == 'Description__c')
                customField.value = (String)fieldValueMap.get(key);
            else
		        customField.value = (Boolean)fieldValueMap.get(key);		   
            customFields.add(customField);
        }
        if(customFields.size()>0)
       	    deployMetadata(customFields);
    }
    public void setupDateFieldValue(Map<String,Object>fieldValueMap){

        List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
        for(String key : fieldValueMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
		    if(key == 'Description__c')
                customField.value = (String)fieldValueMap.get(key);
            else
		        customField.value = (Date)fieldValueMap.get(key);	
            customFields.add(customField);
        }	
        if(customFields.size()>0)
       	    deployMetadata(customFields);		
    }
    public void setupDateTimeFieldValue(Map<String,Object>fieldValueMap){

        List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
        for(String key : fieldValueMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
		    if(key == 'Description__c')
                customField.value = (String)fieldValueMap.get(key);
            else
		        customField.value = (DateTime)fieldValueMap.get(key);	
            customFields.add(customField);
        }	
        if(customFields.size()>0)
       	    deployMetadata(customFields);		
    }
    public void setupDecimalFieldValue(Map<String,Object>fieldValueMap){

        List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
        for(String key : fieldValueMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
		    if(key == 'Description__c')
                customField.value = (String)fieldValueMap.get(key);
            else
		        customField.value = (Decimal)fieldValueMap.get(key);	
            customFields.add(customField);
        }
        if(customFields.size()>0)
       	    deployMetadata(customFields);      		
    }
    public void setupIntegerFieldValue(Map<String,Object>fieldValueMap){

        List<Metadata.CustomMetadataValue> customFields = new List<Metadata.CustomMetadataValue>();
        for(String key : fieldValueMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
		    if(key == 'Description__c')
                customField.value = (String)fieldValueMap.get(key);
            else
		        customField.value = (Integer)fieldValueMap.get(key);
            customFields.add(customField);
        }	
        if(customFields.size()>0)
       	    deployMetadata(customFields);
    }

    private void deployMetadata(List<Metadata.CustomMetadataValue> customFields){
        this.keyValueHolderMetadata.values.addAll(customFields);
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
		mdContainer.addMetadata(this.keyValueHolderMetadata);
		CustomMetadataCallback callback = new CustomMetadataCallback(); 
        if(!Test.isRunningTest())
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
    public with sharing class CustomMetadataCallback implements Metadata.DeployCallback {
		public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
			if (result.status == Metadata.DeployStatus.Succeeded) {
			} else {
			}
		}
	}	
}