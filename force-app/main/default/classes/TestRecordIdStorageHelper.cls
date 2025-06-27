@isTest
public class TestRecordIdStorageHelper {
	@isTest
    private static void setRecordIds(){
        List<String> recordIds = new List<String>();
        SampleObject1__c so1 = TestHelper.getSampleObject1Val(true);
        SampleObject1__c so2 = TestHelper.getSampleObject1Val(true);
        recordIds.add(so1.id);
        recordIds.add(so2.id);
        RecordIdStorageHelper.setRecordIds(recordIds, 'test');
        List<Id> lst = RecordIdStorageHelper.getRecordIds('test');
        RecordIdStorageHelper.deleteRecordIds('test');
        system.assertNotEquals(null,lst); 
    }
}