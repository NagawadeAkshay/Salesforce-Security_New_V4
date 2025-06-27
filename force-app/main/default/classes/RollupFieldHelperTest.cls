@isTest
private class RollupFieldHelperTest {
    @isTest
    static void verifyRollupFieldHelper(){
        SampleObject2__c parent1 = TestHelper.getSampleObject2Val(false);
        insert parent1;        
        System.assertNotEquals(null, parent1.Id);

        SampleObject2__c parent2 = TestHelper.getSampleObject2Val(false);
        insert parent2;        
        System.assertNotEquals(null, parent2.Id);

        List<SampleObject1__c> lst = new List<SampleObject1__c>();
        for(Integer i = 1; i <= 6; i++){
            SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(false);
            sampleObject1.SampleNumber2__c = i * 10;
            sampleObject1.Sample_Object_2__c = Math.mod(i, 2) == 0 ? parent2.Id : parent2.Id;
            lst.add(sampleObject1);
        }
        insert lst;
        for(SampleObject1__c obj : lst){
            System.assertNotEquals(null, obj.Id);
            obj.SampleNumber2__c = obj.SampleNumber2__c * 2;
        }
        
        update lst;

        lst[0].Sample_Object_2__c = null;
        lst[2].Sample_Object_2__c = null;
        update lst;

        delete new List<SampleObject1__c>{lst[4]};
    }
}