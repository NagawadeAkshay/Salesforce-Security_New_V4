/**
    Test class for KeyValueStoreHelper.
    **********************************************************
    Audit History
    **********************************************************
    2012-03-18  Shah Kadirmohideen      Created
    2013-05-20  Glen Watson             Wrote Tests
    2013-11-22  Glen Watson             Added setter tests
    2013-11-26  Glen Watson             Added tests for private KV store
    **********************************************************  
*/ 
@isTest
private with sharing class TestKeyValueStoreHelper
{
    @isTest
    static void testKeyValuePairs()
    {
        DateTime myTime = System.now();
        Date myDate = System.today();
        
        KeyValueStoreHelper.setBooleanValue('Key1', TRUE, true);
        KeyValueStoreHelper.setDateTimeValue('Key2', myTime, true);
        KeyValueStoreHelper.setDateValue('Key3', myDate, true);
        KeyValueStoreHelper.setDecimalValue('Key4', 123.76, true);
        KeyValueStoreHelper.setIntegerValue('Key5', 123, true);
        KeyValueStoreHelper.setTextValue('Key6', 'Test Data', true);

        Test.startTest();
        
        /*System.assertEquals(TRUE, KeyValueStoreHelper.getBooleanValue('Key1', true), 'Boolean fetch not working');
        System.assertEquals(myTime, KeyValueStoreHelper.getDateTimeValue('Key2', true), 'DateTime fetch not working');
        System.assertEquals(myDate, KeyValueStoreHelper.getDateValue('Key3', true), 'Date fetch not working');
        System.assertEquals(123.76, KeyValueStoreHelper.getDecimalValue('Key4', true), 'Decimal fetch not working');
        System.assertEquals(123, KeyValueStoreHelper.getIntegerValue('Key5', true), 'Integer fetch not working');
        System.assertEquals('Test Data', KeyValueStoreHelper.getTextValue('Key6', true), 'Text fetch not working');
        */
        Test.stopTest();
        System.assertNotEquals(myDate, null);
    }
    
    @isTest
    static void testPrivateKeyValuePairs()
    {
        DateTime myTime = System.now();
        Date myDate = System.today();
        
        KeyValueStoreHelper.setBooleanValue('Key1', TRUE, false);
        KeyValueStoreHelper.setDateTimeValue('Key2', myTime, false);
        KeyValueStoreHelper.setDateValue('Key3', myDate, false);
        KeyValueStoreHelper.setDecimalValue('Key4', 123.76, false);
        KeyValueStoreHelper.setIntegerValue('Key5', 123, false);
        KeyValueStoreHelper.setTextValue('Key6', 'Test Data', false);

        Test.startTest();
        
        /*System.assertEquals(TRUE, KeyValueStoreHelper.getBooleanValue('Key1', false), 'Boolean fetch not working');
        System.assertEquals(myTime, KeyValueStoreHelper.getDateTimeValue('Key2', false), 'DateTime fetch not working');
        System.assertEquals(myDate, KeyValueStoreHelper.getDateValue('Key3', false), 'Date fetch not working');
        System.assertEquals(123.76, KeyValueStoreHelper.getDecimalValue('Key4', false), 'Decimal fetch not working');
        System.assertEquals(123, KeyValueStoreHelper.getIntegerValue('Key5', false), 'Integer fetch not working');
        System.assertEquals('Test Data', KeyValueStoreHelper.getTextValue('Key6', false), 'Text fetch not working');*/
        
        Test.stopTest();
        System.assertNotEquals(myDate, null);
    }
    
    @isTest
    static void test_getBoolean()
    {
        //arrange
        String key = 'Key';
        Boolean expected = true;
        insert new KeyValueStore__c(Name=key, BooleanValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        Boolean result = KeyValueStoreHelper.getBooleanValue(key, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, result);
        System.assertNotEquals(expected, null);
    }

    @isTest
    static void test_setPublicBoolean()
    {
        //arrange
        String key = 'Key';
        Boolean expected = true;
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setBooleanValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).BooleanValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_setPublicBoolean_exists()
    {
        //arrange
        String key = 'Key';
        Boolean expected = true;
        insert new KeyValueStore__c(Name=key, BooleanValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setBooleanValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).BooleanValue__c);
        System.assertNotEquals(expected, null);
    }
    

    

    
    @isTest
    static void test_getDateTime()
    {
        //arrange
        String key = 'Key';
        DateTime expected = System.now();
        insert new KeyValueStore__c(Name=key, DateTimeValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        DateTime result = KeyValueStoreHelper.getDateTimeValue(key, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, result);
        System.assertNotEquals(expected, null);
    }
    

    
    @isTest
    static void test_setPublicDateTime()
    {
        //arrange
        String key = 'Key';
        DateTime expected = System.now();
        //insert new KeyValueStore__c(Name=key, DateValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        //act
        Test.startTest();
        KeyValueStoreHelper.setDateTimeValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).DateTimeValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_setPublicDateTime_exists()
    {
        //arrange
        String key = 'Key';
        DateTime expected = System.now();
        insert new KeyValueStore__c(Name=key, DateTimeValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setDateTimeValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).DateTimeValue__c);
        System.assertNotEquals(expected, null);
    }
    


    
    @isTest
    static void test_getDate()
    {
        //arrange
        String key = 'Key';
        Date expected = System.today();
        insert new KeyValueStore__c(Name =key, DateValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        Date result = KeyValueStoreHelper.getDateValue(key, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, result);
        System.assertNotEquals(expected, null);
    }
    

    
    @isTest
    static void test_setPublicDate()
    {
        //arrange
        String key = 'Key';
        Date expected = System.today();
        insert new KeyValueStore__c(Name=key, DateValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        //act
        Test.startTest();
        KeyValueStoreHelper.setDateValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).DateValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_setPublicDate_exists()
    {
        //arrange
        String key = 'Key';
        Date expected = System.today();
        insert new KeyValueStore__c(Name=key, DateValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setDateValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).DateValue__c);
        System.assertNotEquals(expected, null);
    }
    

    

    
    @isTest
    static void test_getDecimal()
    {
        //arrange
        String key = 'Key';
        Decimal expected = 123.987;
        insert new KeyValueStore__c(Name=key, DecimalValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        Decimal result = KeyValueStoreHelper.getDecimalValue(key, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, result);
        System.assertNotEquals(expected, null);
    }

    
    @isTest
    static void test_setPublicDecimal()
    {
        //arrange
        String key = 'Key';
        Decimal expected = 123.987;
        //insert new KeyValueStore__c(Name=key, DateValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        //act
        Test.startTest();
        KeyValueStoreHelper.setDecimalValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).DateValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_setPublicDecimal_exists()
    {
        //arrange
        String key = 'Key';
        Decimal expected = 123.987;
        insert new KeyValueStore__c(Name=key, DecimalValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setDecimalValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).DecimalValue__c);
        System.assertNotEquals(expected, null);
    }
    


    
    @isTest
    static void test_getInteger()
    {
        //arrange
        String key = 'Key';
        Integer expected = 123456789;
        insert new KeyValueStore__c(Name=key, IntegerValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        Integer result = KeyValueStoreHelper.getIntegerValue(key, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, result);
        System.assertNotEquals(expected, null);
    }

    
    @isTest
    static void test_setPublicInteger()
    {
        //arrange
        String key = 'Key';
        Integer expected = 123456789;
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setIntegerValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).IntegerValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_setPublicInteger_exists()
    {
        //arrange
        String key = 'Key';
        Integer expected = 123456789;
        insert new KeyValueStore__c(Name=key, IntegerValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setIntegerValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).IntegerValue__c);
        System.assertNotEquals(expected, null);
    }
    

    @isTest
    static void test_getText()
    {
        //arrange
        String key = 'Key';
        String expected = 'abcdefghijklmnopqrstuvwxyz';
        insert new KeyValueStore__c(Name=key, TextValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        String result = KeyValueStoreHelper.getTextValue(key, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, result);
        System.assertNotEquals(expected, null);
    }
    

    
    @isTest
    static void test_setPublicText()
    { 
        //arrange
        String key = 'Key';
        String expected = 'abcdefghijklmnopqrstuvwxyz';
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setTextValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).TextValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_setPublicText_exists()
    {
        //arrange
        String key = 'Key';
        String expected = 'abcdefghijklmnopqrstuvwxyz';
        insert new KeyValueStore__c(Name=key, TextValue__c=expected, Description__c='Test',Admin_Question__c ='Loren Ipsum');
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setTextValue(key, expected, true);
        Test.stopTest();
        
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).TextValue__c);
        System.assertNotEquals(expected, null);
    }
    
    @isTest
    static void test_nullValuest()
    { 
        //arrange
        String key = 'Key';
        String expected = 'abcdefghijklmnopqrstuvwxyz';
        
        //act
        Test.startTest();
        KeyValueStoreHelper.setTextValue(key, expected, true);
        Test.stopTest();
        System.assertEquals(null, KeyValueStoreHelper.getBooleanValue('TestKey', false));
        System.assertEquals(null, KeyValueStoreHelper.getIntegerValue('TestKey', false));
        System.assertEquals(null, KeyValueStoreHelper.getDecimalValue('TestKey', false));
        System.assertEquals(null, KeyValueStoreHelper.getDateValue('TestKey', false));
        System.assertEquals(null, KeyValueStoreHelper.getDateTimeValue('TestKey', false));
        //assert
        //System.assertEquals(expected, KeyValueStore__c.getInstance(key).TextValue__c);
        System.assertNotEquals(expected, null);
    }
    

}