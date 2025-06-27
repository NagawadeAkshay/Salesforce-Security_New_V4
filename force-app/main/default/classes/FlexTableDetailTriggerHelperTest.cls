@isTest
private class FlexTableDetailTriggerHelperTest {
    @isTest
    static void verifyFlexTableDetailTriggerHelper(){
        SampleObject11__c sampleObj = TestHelper.getSampleObject1(true);
        System.assertNotEquals(null, sampleObj.Id);

        DataTableConfig__c dataTableConfig  = new DataTableConfig__c(
            Name = 'TestDataTable',
            SObject__c = AppUtils.getNamespacePrefix() + 'SampleObject11__c',
            FieldNames__c = 'Id, Name, SampleText1__c, SampleNumber1__c',
            Description__c = 'TestDescription',
            Header__c = 'TestHeader'
        );
        insert dataTableConfig;
        System.assertNotEquals(null, dataTableConfig.Id);

        DataTableDetailConfig__c obj1 = new DataTableDetailConfig__c(
            FieldAPIName__c = 'SampleText1__c',
            FlexTableConfig__c = dataTableConfig.Id,
            Formula__c = '{"LASTROW":"TEXT(Total)"}',
            EnableOverAllTotal__c = true
        );
        insert obj1;
        System.assertNotEquals(null, obj1.Id);

        DataTableDetailConfig__c obj2 = new DataTableDetailConfig__c(
            FieldAPIName__c = 'SampleNumber1__c',
            FlexTableConfig__c = dataTableConfig.Id,
            Formula__c = '{"LASTROW":"SUM(1:N)"}',
            EnableOverAllTotal__c = true
        );
        insert obj2;
        System.assertNotEquals(null, obj2.Id);

        DataTableDetailConfig__c obj3 = new DataTableDetailConfig__c(
            FieldAPIName__c = 'SampleNumber1__c',
            FlexTableConfig__c = dataTableConfig.Id,
            Formula__c = '{"GRANDTOTAL":"TEXT(Grand Total)"}',
            EnableOverAllTotal__c = true
        );
        insert obj3;
        System.assertNotEquals(null, obj3.Id);

        DataTableDetailConfig__c obj4 = new DataTableDetailConfig__c(
            FieldAPIName__c = 'SampleNumber1__c',
            FlexTableConfig__c = dataTableConfig.Id,
            Formula__c = '{"3":"SUM(1:2)","LASTROW":"SUM(1:N)"}',
            EnableOverAllTotal__c = true
        );
        insert obj4;
        System.assertNotEquals(null, obj4.Id);

        DataTableDetailConfig__c obj5 = new DataTableDetailConfig__c(
            FieldAPIName__c = 'SampleNumber1__c',
            FlexTableConfig__c = dataTableConfig.Id,
            Formula__c = '{"LASTROW":"TEXT(Total)"}',
            EnableOverAllTotal__c = true
        );
        insert obj5;
        System.assertNotEquals(null, obj5.Id);

        DataTableDetailConfig__c obj6 = new DataTableDetailConfig__c(
            FieldAPIName__c = 'SampleNumber1__c',
            FlexTableConfig__c = dataTableConfig.Id,
            Formula__c = '{"LASTROW":"MUL(1:N)"}',
            EnableOverAllTotal__c = true
        );
        insert obj6;
        System.assertNotEquals(null, obj6.Id);

        obj1.FieldWidth__c = 33;
        update obj1;

        obj2.FieldWidth__c = 33;
        update obj2;

        obj3.FieldWidth__c = 33;
        obj3.EnableOverAllTotal__c = false;
        update obj3;

        obj4.Formula__c = '{"LASTROW":"MUL(1:N)"}';
        update obj4;

        obj5.Formula__c = '{"LASTROW":"TEXT(Total)"}';
        update obj5;

        try {
            obj1.Formula__c = 'null';
            update obj1;
        } catch(Exception ex){}
    }
}