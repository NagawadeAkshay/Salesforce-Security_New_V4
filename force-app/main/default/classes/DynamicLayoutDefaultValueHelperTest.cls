@isTest
private class DynamicLayoutDefaultValueHelperTest {
    @isTest
    static void verifyDynamicLayoutDefaultValueHelper(){
        DynamicLayoutDefaultValueHelper obj = new DynamicLayoutDefaultValueHelper('Test', 'Test', false);
        System.assertNotEquals(null, obj);

        obj = new DynamicLayoutDefaultValueHelper('Test', 1, false);
        System.assertNotEquals(null, obj);

        obj = new DynamicLayoutDefaultValueHelper('Test', Date.today(), false);
        System.assertNotEquals(null, obj);

        obj = new DynamicLayoutDefaultValueHelper('Test', Datetime.now(), false);
        System.assertNotEquals(null, obj);

        obj = new DynamicLayoutDefaultValueHelper('Test', 1.0, false);
        System.assertNotEquals(null, obj);

        obj = new DynamicLayoutDefaultValueHelper('Test', true, false);
        System.assertNotEquals(null, obj);

        obj = new DynamicLayoutDefaultValueHelper('Test', new Account(), false);
        System.assertNotEquals(null, obj);
    }
}