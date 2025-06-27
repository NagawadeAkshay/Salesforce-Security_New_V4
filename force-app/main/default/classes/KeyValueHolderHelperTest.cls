@isTest
private class KeyValueHolderHelperTest {
    @isTest
    static void verifyKeyValueHolderHelper(){
        String strKey = 'EnableDebugMode';
        String textValue = KeyValueHolderHelper.getTextValue(strKey);
        System.assertNotEquals(null, textValue);

        Boolean booleanValue = KeyValueHolderHelper.getBooleanValue(strKey);
        System.assertNotEquals(null, booleanValue);

        Integer integerValue = KeyValueHolderHelper.getIntegerValue(strKey);
        System.assertEquals(null, integerValue);

        Decimal decimalValue = KeyValueHolderHelper.getDecimalValue(strKey);
        System.assertEquals(null, decimalValue);
        
        //Date dateValue = KeyValueHolderHelper.getDateValue(strKey);
        //System.assertNotEquals(null, dateValue);

        //DateTime datetimeValue = KeyValueHolderHelper.getDateTimeValue(strKey);
        //System.assertNotEquals(null, datetimeValue);*/

        String descriptionValue = KeyValueHolderHelper.getDescriptionValue(strKey);
        System.assertNotEquals(null, descriptionValue);

        ///String moduleValue = KeyValueHolderHelper.getModuleValue(strKey);
        //System.assertNotEquals(null, moduleValue);

        //moduleValue = KeyValueHolderHelper.getModuleValue(strKey+'Test');
        //System.assertEquals(null, moduleValue);
    }
}