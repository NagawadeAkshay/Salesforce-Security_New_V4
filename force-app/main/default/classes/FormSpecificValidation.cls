global with sharing virtual class FormSpecificValidation extends FormSpecificValidationAbstractHandler {
    //global overrride updateFormInstanceValidationFlag(Object);
    //Deprecated
    global override List<String> validateForm(String objName,String frmId,String parentId,String formInstanceId) {List<String> errorList = new List<String>(); return errorList;}
    global override Void skipTriggersAndUpdate(Id formInstanceId,Id formId){}
}