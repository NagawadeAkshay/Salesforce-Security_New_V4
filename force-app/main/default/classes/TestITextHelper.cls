/*
Created By    : Amol Darekar
Created Date  : 17th Sept 2018
Modified Date : 17th Sept 2018
Purpose: This class is used to unit test the ItextHelper class.
*/

@isTest
public class TestITextHelper {
    @isTest
    public static void verifyITextHelper(){
        Account objAccount = new Account(Name = 'TestAccount');
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);

        Attachment objAttachment = new Attachment(
            ParentId = objAccount.Id,
            Name = 'Test Attachment for Parent',
            Body = Blob.valueOf('Test Data')
        );        
        insert(objAttachment);
        System.assertNotEquals(null, objAttachment.Id);

        Task objTask = new Task(
            Subject = 'Test Task',
            Status = 'New',
            Priority = 'Normal',
            CallType = 'Outbound'
        );
        insert objTask;
        System.assertNotEquals(null, objTask.Id);

     
        Map<String, Object> mapParams = new Map<String, Object>();
        mapParams.put('attachmentIds', JSON.serialize(new List<String>{objAttachment.Id}));
        mapParams.put('parentRecordId', objAccount.Id);
        mapParams.put('task', JSON.serialize(objTask));
        mapParams.put('fileName', objAttachment.Name);

        Test.setMock(HttpCalloutMock.class, new TestITextHelperHttpCalloutMock());
        Test.startTest();
        Map<String, Object> result = ITextHelper.mergePDF(mapParams);
        System.assertNotEquals(null, result);

        try {
            result = ITextHelper.mergePDF(null);
            System.assertNotEquals(null, result);
        } catch(Exception ex) {
            System.assertNotEquals(null, ex);
        }
        Test.stopTest();
    }
}