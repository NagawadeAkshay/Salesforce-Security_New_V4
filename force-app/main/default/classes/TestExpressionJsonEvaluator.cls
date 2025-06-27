@isTest
private class TestExpressionJsonEvaluator {
    
    @isTest
    public static void evaluateExpressionTest(){
        Test.StartTest();
        ExpressionJsonEvaluator.getCurrentUser();
        Test.StopTest();
    }

    @isTest
    static void testEvalRegex() {
        Test.startTest();
        Boolean result1 = ExpressionJsonEvaluator.evalRegex('123abc', '\\d+\\w+', '=');
        System.assertEquals(true, result1, 'Expected true when value matches regex with "=" operator');
        Boolean result2 = ExpressionJsonEvaluator.evalRegex('123abc', '\\d+\\d+', '=');
        System.assertEquals(false, result2, 'Expected false when value does not match regex with "=" operator');
        Test.stopTest();
    }

    @isTest
    static void testCompareStringEqual() {
        Boolean result = ExpressionJsonEvaluator.compareString('Test', 'Test', '=', null);
        System.assert(result, 'Expected true for equal strings with "=" operator');

        result = ExpressionJsonEvaluator.compareString('Test', 'Different', '=', null);
        System.assert(!result, 'Expected false for different strings with "=" operator');
    }

    @isTest
    static void testCompareStringNotEqual() {
        Boolean result = ExpressionJsonEvaluator.compareString('Test', 'Different', '!=', null);
        System.assert(result, 'Expected true for different strings with "!=" operator');

        result = ExpressionJsonEvaluator.compareString('Test', 'Test', '!=', null);
        System.assert(!result, 'Expected false for equal strings with "!=" operator');
    }

    @isTest
    static void testCompareStringGreaterThanOrEqual() {
        Boolean result = ExpressionJsonEvaluator.compareString('Test', 'Test', '>=', null);
        System.assert(result, 'Expected true for equal strings with ">=" operator');

        result = ExpressionJsonEvaluator.compareString('Test', 'AAA', '>=', null);
        System.assert(result, 'Expected true when left string is greater with ">=" operator');

        result = ExpressionJsonEvaluator.compareString('AAA', 'Test', '>=', null);
        System.assert(!result, 'Expected false when left string is less with ">=" operator');
    }

    @isTest
    static void testCompareStringLessThanOrEqual() {
        Boolean result = ExpressionJsonEvaluator.compareString('Test', 'Test', '<=', null);
        System.assert(result, 'Expected true for equal strings with "<=" operator');

        result = ExpressionJsonEvaluator.compareString('AAA', 'Test', '<=', null);
        System.assert(result, 'Expected true when left string is less with "<=" operator');

        result = ExpressionJsonEvaluator.compareString('Test', 'AAA', '<=', null);
        System.assert(!result, 'Expected false when left string is greater with "<=" operator');
    }

    @isTest
    static void testCompareStringLessThan() {
        Boolean result = ExpressionJsonEvaluator.compareString('AAA', 'Test', '<', null);
        System.assert(result, 'Expected true when left string is less with "<" operator');

        result = ExpressionJsonEvaluator.compareString('Test', 'AAA', '<', null);
        System.assert(!result, 'Expected false when left string is greater with "<" operator');
    }

    @isTest
    static void testCompareStringGreaterThan() {
        Boolean result = ExpressionJsonEvaluator.compareString('Test', 'AAA', '>', null);
        System.assert(result, 'Expected true when left string is greater with ">" operator');

        result = ExpressionJsonEvaluator.compareString('AAA', 'Test', '>', null);
        System.assert(!result, 'Expected false when left string is less with ">" operator');
    }

    @isTest
    static void testCompareStringContains() {
        Boolean result = ExpressionJsonEvaluator.compareString('This is a test', 'test', 'CONTAINS', null);
        System.assert(result, 'Expected true when left string contains right string with "CONTAINS" operator');

        result = ExpressionJsonEvaluator.compareString('This is a test', 'Test', 'CONTAINS', null);
        System.assert(!result, 'Expected false when left string does not contain right string with "CONTAINS" operator');
    }

    @isTest
    static void testCompareStringIn() {
        List<String> rightOperands = new List<String>{'Test', 'Sample'};
        Boolean result = ExpressionJsonEvaluator.compareString('Test', null, 'IN', rightOperands);
        System.assert(result, 'Expected true when left string is in rightOperands list with "IN" operator');

        result = ExpressionJsonEvaluator.compareString('Unknown', null, 'IN', rightOperands);
        System.assert(!result, 'Expected false when left string is not in rightOperands list with "IN" operator');
    }

    @isTest
    static void testCompareStringNotIn() {
        List<String> rightOperands = new List<String>{'Test', 'Sample'};
        Boolean result = ExpressionJsonEvaluator.compareString('Unknown', null, 'not in', rightOperands);
        System.assert(result, 'Expected true when left string is not in rightOperands list with "not in" operator');

        result = ExpressionJsonEvaluator.compareString('Test', null, 'not in', rightOperands);
        System.assert(!result, 'Expected false when left string is in rightOperands list with "not in" operator');
    }

    @isTest
    static void testCompareNumberEqual() {
        // Test equality operator
        Boolean result = ExpressionJsonEvaluator.compareNumber(10, 10, '=');
        System.assert(result, 'Expected true for equal numbers with "=" operator');

        Boolean result1 = ExpressionJsonEvaluator.compareNumber(10, 5, '!=');
        System.assert(result1, 'Expected true for different numbers with "!=" operator');

        Boolean result2 = ExpressionJsonEvaluator.compareNumber(10, 10, '>=');
        System.assert(result2, 'Expected true for equal numbers with ">=" operator');

        Boolean result3 = ExpressionJsonEvaluator.compareNumber(10, 5, '>=');
        System.assert(result3, 'Expected true when left number is greater with ">=" operator');
        
        Boolean result4 = ExpressionJsonEvaluator.compareNumber(10, 10, '<=');
        System.assert(result4, 'Expected true for equal numbers with "<=" operator');

        Boolean result5 = ExpressionJsonEvaluator.compareNumber(5, 10, '<');
        System.assert(result5, 'Expected true when left number is less with "<" operator');

        Boolean result6 = ExpressionJsonEvaluator.compareNumber(10, 5, '>');
        System.assert(result6, 'Expected true when left number is greater with ">" operator');
        
        Boolean result7 = ExpressionJsonEvaluator.compareNumber(5, 10, '>');
    }

    @isTest
    static void testCompareDateEqual() {
        Date leftDate = Date.newInstance(2023, 6, 1);
        Date rightDate = Date.newInstance(2023, 6, 1);
        Boolean result = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '=');
        System.assert(result, 'Expected true for equal dates with "=" operator');

        Boolean result1 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '!=');
        System.assert(result, 'Expected true for different dates with "!=" operator');

        leftDate = Date.newInstance(2023, 6, 1);
        rightDate = Date.newInstance(2023, 6, 1);
        Boolean result2 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '>=');
        System.assert(result, 'Expected true for equal dates with ">=" operator');

        leftDate = Date.newInstance(2023, 6, 1);
        rightDate = Date.newInstance(2023, 6, 1);
        Boolean result3 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '<=');
        System.assert(result, 'Expected true for equal dates with "<=" operator');

        leftDate = Date.newInstance(2023, 6, 1);
       rightDate = Date.newInstance(2023, 6, 2);
        Boolean result4 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '<');
        System.assert(result, 'Expected true when left date is earlier with "<" operator');

        rightDate = Date.newInstance(2023, 5, 31);
        result4 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '<');

        leftDate = Date.newInstance(2023, 6, 2);
        rightDate = Date.newInstance(2023, 6, 1);
        Boolean result5 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '>');
        System.assert(result, 'Expected true when left date is later with ">" operator');

        rightDate = Date.newInstance(2023, 6, 3);
        result5 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, '>');


        leftDate = Date.newInstance(2023, 6, 1);
        rightDate = Date.newInstance(2023, 6, 2);
        Boolean result6 = ExpressionJsonEvaluator.compareDate(leftDate, rightDate, null);
        System.assert(!result6, 'Expected false when operator is null');
    }

    @isTest
    static void testCompareDateTimeEqual() {
        // Test equality operator
        DateTime leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        DateTime rightDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        Boolean result = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '=');
        System.assert(result, 'Expected true for equal datetimes with "=" operator');

        leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        rightDateTime = DateTime.newInstance(2023, 6, 2, 12, 0, 0);
        Boolean result1 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '!=');
        System.assert(result1, 'Expected true for different datetimes with "!=" operator');

        leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        rightDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        Boolean result2 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '>=');
        System.assert(result2, 'Expected true for equal datetimes with ">=" operator');

        leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        rightDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        Boolean result3 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '<=');
        System.assert(result3, 'Expected true for equal datetimes with "<=" operator');

        leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        rightDateTime = DateTime.newInstance(2023, 6, 2, 12, 0, 0);
        Boolean result4 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '<');
        System.assert(result4, 'Expected true when left datetime is earlier with "<" operator');

        leftDateTime = DateTime.newInstance(2023, 6, 2, 12, 0, 0);
        rightDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        Boolean result5 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '>');
        System.assert(result5, 'Expected true when left datetime is later with ">" operator');

        leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        rightDateTime = null;
        Boolean result6 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, '=');
        System.assert(result6, 'Expected true when right datetime is null and left datetime is not null');

        leftDateTime = DateTime.newInstance(2023, 6, 1, 12, 0, 0);
        rightDateTime = DateTime.newInstance(2023, 6, 2, 12, 0, 0);
        Boolean result7 = ExpressionJsonEvaluator.compareDateTime(leftDateTime, rightDateTime, null);
        System.assert(!result7, 'Expected false when operator is null');
    }

    @isTest
    static void testCompareBooleanEqual() {
        Boolean leftOperand = true;
        Boolean rightOperand = true;
        Boolean result = ExpressionJsonEvaluator.compareBoolean(leftOperand, rightOperand, '=');
        System.assert(result, 'Expected true for equal booleans with "=" operator');

        leftOperand = true;
        rightOperand = false;
        Boolean result1 = ExpressionJsonEvaluator.compareBoolean(leftOperand, rightOperand, '!=');
        System.assert(result1, 'Expected true for different booleans with "!=" operator');

        leftOperand = null;
        rightOperand = null;
        Boolean result2 = ExpressionJsonEvaluator.compareBoolean(leftOperand, rightOperand, '=');
        System.assert(result2, 'Expected true for null booleans with "=" operator');

        rightOperand = true;
        result1 = ExpressionJsonEvaluator.compareBoolean(leftOperand, rightOperand, '=');
        System.assert(!result1, 'Expected false for null leftOperand with "=" operator');

        result2 = ExpressionJsonEvaluator.compareBoolean(leftOperand, rightOperand, '!=');
        System.assert(result2, 'Expected true for null leftOperand with "!=" operator');

        leftOperand = true;
        rightOperand = true;
        Boolean result3 = ExpressionJsonEvaluator.compareBoolean(leftOperand, rightOperand, '<>');
        System.assert(!result3, 'Expected false for invalid operator');
    }

 






   

}