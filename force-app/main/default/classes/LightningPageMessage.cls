global with sharing class LightningPageMessage  {
    global String messageType;
    global String messageBody;
    public Integer messageTimeOut;
    global LightningPageMessage (){}
      
    global LightningPageMessage (String messageType , String messageBody ){
        this.messageType = messageType;
        this.messageBody = messageBody;
    }

    global LightningPageMessage (ApexPages.Severity messageType , String messageBody ){
        this.messageType = messageType.name();
        this.messageBody = messageBody;
    }
}