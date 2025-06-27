/**
 * Created by Dipak on 18-08-2020.
 */

@IsTest
private class EnqueuePermissionSetAssignmentTest {
    @IsTest
    static void verifyEnqueuePermissionSetAssignment() {
        Test.startTest();
        EnqueuePermissionSetAssignment obj = new EnqueuePermissionSetAssignment(new Set<Id>());
        Id jobId = System.enqueueJob(obj);
        System.assertNotEquals(null, jobId);
        Test.stopTest();
    }
}