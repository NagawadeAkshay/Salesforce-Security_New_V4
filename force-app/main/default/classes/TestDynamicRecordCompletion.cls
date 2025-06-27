@isTest
private with sharing class TestDynamicRecordCompletion{
    @isTest
    public static void constructorTest(){ 
         //arrange
        List<Id> createLayoutData = TestHelper.setLayoutData();
        DynamicLayoutHolder layoutHolder = null;
       // Opportunity opp = new Opportunity(Name='Test Opp',StageName='Prospecting',CloseDate=date.today());
        //insert opp;
        
        SampleObject11__c obj_1 = TestHelper.getSampleObject1(true);
        SampleObject12__c obj_2 = TestHelper.getSampleObject2(true,obj_1.id);
        
        Id pageLayoutId = createLayoutData.get(0);
        layoutHolder = new DynamicLayoutHolder(pageLayoutId, obj_2.ID,true);

        DynamicRecordCompletion objCtrl = new DynamicRecordCompletion (layoutHolder);
        System.assertNotEquals(null, objCtrl);
        
        layoutHolder.layout.completionPercent = null;
        objCtrl = new DynamicRecordCompletion (layoutHolder);
        System.assertNotEquals(null, objCtrl);        
    }    
}