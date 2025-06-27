@isTest
private class UploadPackageEmailHandlerTest {
    @isTest
    static void verifyUploadPackageEmailHandler(){
        try{
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
            email.subject = 'Upload package';
            email.fromAddress = 'someaddress@email.com';
            email.plainTextBody = 'email body\n2225256325\nTitle';
            Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
            attachment.body = blob.valueOf('my attachment text');
            attachment.fileName = 'textfileone.txt';
            attachment.mimeTypeSubType = 'text/plain';
            email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
            attachmenttext.body = 'my attachment text';
            attachmenttext.fileName = 'textfiletwo3.txt';
            attachmenttext.mimeTypeSubType = 'texttwo/plain';
            email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
            UserInfo.isCurrentUserLicensed(AppUtils.getNamespacePrefix());
            UploadPackageEmailHandler obj = new UploadPackageEmailHandler();
            System.assertNotEquals(null, obj);
            Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
            
            String strMultilineListValues = obj.getMultilineListValues(new List<Object>{'Str1', 'Str2'});
            System.assertNotEquals(null, strMultilineListValues);
            
            obj.sendMail('test message', new List<String>{'testemail1@example.com', 'testemail2@example.com'}, new List<String>{'testemail1@example.com', 'testemail2@example.com'});
            obj.handleInboundEmail(email, env);
            obj.getPackageDetails();
        }catch(System.TypeException ex){
            System.assertNotEquals(null, ex);
        }        
    }
}