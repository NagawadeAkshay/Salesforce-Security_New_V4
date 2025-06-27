/*
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    08-01-2022      Tejashreee D        1. added with sharing for SF security review
    ****************************************************************************************
*/
global with sharing class UploadPackageEmailHandler implements Messaging.InboundEmailHandler 
{
    public UploadPackageEmailHandler(){}
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();        
        return result;
    }

    public String getMultilineListValues(list<Object> strList)
    {
        String str = '';     
        Integer SrNo = 1;  
        for(Object strListValue : strList )
        {
            str += SrNo + ' :   ' + (String)strListValue + '    <br/>   ';
        }
        return str;
    }

    public void getPackageDetails()
    {
        
    }

    public void sendMail(String msg, String[] toMailAddress, String[] ccMailAddress)
    {
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toMailAddress);
        mail.setReplyTo(toMailAddress[0]);
        mail.setSenderDisplayName('GNT Package Upload');
        mail.setSubject('Package Upload Info');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody(msg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}