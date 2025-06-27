/*
    Author: Nakul Kadam
    Purpose: Form validation abstract 
*/
global with sharing abstract class FormSpecificValidationAbstractHandler{
    global Boolean skipFormValidations = false;
    
    global virtual void updateFormInstanceValidationFlag(Object formInstanceParam){
    }

    global virtual void updateFormInstanceValidationFlagToNo(Object formInstanceParam){
    }

    global virtual List<String> formValidations(Object formValidationWrapper){ 
        return new List<String>();
    }

    //Deprecated
    global abstract void skipTriggersAndUpdate(Id formInstanceId,Id formId);
    global abstract List<String> validateForm(String objName,String frmId,String parentId,String formInstanceId);
}