global with sharing class DynamicLayoutDefaultValueHelper {
    global string fieldAPIName {get;set;}
    global object defaultValue {get;set;}
    global boolean isHidden {get;set;}  
    
    global DynamicLayoutDefaultValueHelper(string fldName, string value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden;
    }
    
    global DynamicLayoutDefaultValueHelper(string fldName, Integer value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden;
    }

    global DynamicLayoutDefaultValueHelper(string fldName, Date value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden;
    }

    global DynamicLayoutDefaultValueHelper(string fldName, DateTime value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden; 
    }

    global DynamicLayoutDefaultValueHelper(string fldName, Decimal value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden;
    }
    
    global DynamicLayoutDefaultValueHelper(string fldName, Boolean value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden;
    }
    
     global DynamicLayoutDefaultValueHelper(string fldName, sObject value, boolean hidden) {
        this.fieldAPIName = fldName;
        this.defaultValue = value;
        this.isHidden = hidden;
    }
    
}