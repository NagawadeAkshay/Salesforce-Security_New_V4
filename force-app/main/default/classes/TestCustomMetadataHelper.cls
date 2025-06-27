/**
 * Created by REI on 14-06-2020.
 */

@IsTest
private with sharing class TestCustomMetadataHelper {

    @TestSetup static void setup(){
        new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
    }

    @IsTest
    private static void testSetupTextFieldValue(){
        Test.startTest();
        Map<String,Object> fieldValueMap = TestHelper.setupCustomMetadataTextValueMap();
        System.assertNotEquals(null, fieldValueMap);
        CustomMetadataHelper custMetaHelper = new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
        custMetaHelper.setupTextFieldValue(fieldValueMap);
        Test.stopTest();
    }

    @IsTest
    private static void testSetupBooleanFieldValue(){
        Test.startTest();
        Map<String,Object> fieldValueMap = TestHelper.setupCustomMetadataBooleanValueMap();
        System.assertNotEquals(null, fieldValueMap);
        CustomMetadataHelper custMetaHelper = new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
        custMetaHelper.setupBooleanFieldValue(fieldValueMap);
        Test.stopTest();
    }

    @IsTest
    private static void testSetupDateFieldValue(){
        Test.startTest();
        Map<String,Object> fieldValueMap = TestHelper.setupCustomMetadataDateValueMap();
        System.assertNotEquals(null, fieldValueMap);
        CustomMetadataHelper custMetaHelper = new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
        custMetaHelper.setupDateFieldValue(fieldValueMap);
        Test.stopTest();
    }

    @IsTest
    private static void testSetupDateTimeFieldValue(){
        Test.startTest();
        Map<String,Object> fieldValueMap = TestHelper.setupCustomMetadataDateTimeValueMap();
        System.assertNotEquals(null, fieldValueMap);
        CustomMetadataHelper custMetaHelper = new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
        custMetaHelper.setupDateTimeFieldValue(fieldValueMap);
        Test.stopTest();
    }

    @IsTest
    private static void testSetupDecimalFieldValue(){
        Test.startTest();
        Map<String,Object> fieldValueMap = TestHelper.setupCustomMetadataDecimalValueMap();
        System.assertNotEquals(null, fieldValueMap);
        CustomMetadataHelper custMetaHelper = new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
        custMetaHelper.setupDecimalFieldValue(fieldValueMap);
        Test.stopTest();
    }

    @IsTest
    private static void testSetupIntegerFieldValue(){
        Test.startTest();
        Map<String,Object> fieldValueMap = TestHelper.setupCustomMetadataIntegerValueMap();
        System.assertNotEquals(null, fieldValueMap);
        CustomMetadataHelper custMetaHelper = new CustomMetadataHelper('TestKeyValueStore','TestKeyValueStore');
        custMetaHelper.setupIntegerFieldValue(fieldValueMap);
        Test.stopTest();
    }

    @IsTest
    static void testMyCallback() {
        // Instantiate the callback.
       CustomMetadataHelper.CustomMetadataCallback   callback = new CustomMetadataHelper.CustomMetadataCallback();
       System.assertNotEquals(null, callback);
        // Create test result and context objects.
        Metadata.DeployResult result = new Metadata.DeployResult();
        result.numberComponentErrors = 1;
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();

        // Invoke the callback's handleResult method.
        callback.handleResult(result, context);
    }

}