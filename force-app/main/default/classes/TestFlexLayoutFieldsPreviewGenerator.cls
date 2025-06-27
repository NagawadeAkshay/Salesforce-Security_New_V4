@isTest
private class TestFlexLayoutFieldsPreviewGenerator {
    public static PageLayoutConfig__c pageLay;
    public static SampleObject12__c Sample_2;
    public static DynamicFieldConfigData__mdt dynCon;
    public static SampleObject11__c Sample_1;
    public static PageLayoutConfigHelper.Field pageHelperField;
    public static Component.Apex.OutputPanel body;
    public static DynamicLayoutHolder layoutHolder;
    public static PageLayoutConfigHelper.AlternativeRendering altRen_1;
    public static List<SelectOption> options;
    private static void setup(){                
        Sample_1 = TestHelper.getSampleObject1(true);        
        Sample_2 = TestHelper.getSampleObject2(true,Sample_1.Id);
        pageLay = TestHelper.getPageLayoutConfig(true);
        layoutHolder = new DynamicLayoutHolder(pageLay.Id,Sample_2.Id,true);
        pageHelperField = new PageLayoutConfigHelper.Field();
        body = new Component.Apex.OutputPanel();    
        PageLayoutConfigHelper pageLayHelper = new PageLayoutConfigHelper();  
    }

    @IsTest
    public static void testMethod_1(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = true;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();  
        Test.stopTest();
        System.assertNotEquals('test1','test2');      
    }
    @IsTest
    public static void testMethod_2(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = true;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    @IsTest
    public static void testMethod_4(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        dynCon = TestHelper.getDynamicFieldConfig(true,'Checkbox'); 
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_5(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        dynCon = TestHelper.getDynamicFieldConfig(true,'Radio');    
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_6(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.helpText = 'Help test for field';
        dynCon = TestHelper.getDynamicFieldConfig(true,'Typeahead');    
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_7(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.fieldAPIName = 'name';
        //pageHelperField.fieldAlignment = 'Horizontal';
        //pageHelperField.helpText = 'Help test for field';
        dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist'); 
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_8(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        /*dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist');   
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;*/
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'This is help text';
        pageHelperField.isFieldLevelAttachment = false;
        pageHelperField.dataType = 'REFERENCE';
        //pageHelperField.getAdjustedObjectAPIName();
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        //String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_9(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        /*dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist');   
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;*/
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'This is help text';
        pageHelperField.isRichTextAreaField = true;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        //String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_10(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        /*dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist');   
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;*/
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'Help test for field';
        pageHelperField.dataType = 'BOOLEAN';
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_11(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        /*dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist');   
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;*/
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'Help test for field';
        pageHelperField.dataType = 'DATE';
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_12(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        /*dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist');   
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;*/
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'Help test for field';
        pageHelperField.dataType = 'CURRENCY';
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
    
    @IsTest
    public static void testMethod_13(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        /*dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist');   
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;*/
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'Help test for field';
        pageHelperField.dataType = 'DATETIME';
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');        
    }

    @IsTest
    public static void testMethod_14(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.fieldAPIName = 'name';
        //pageHelperField.fieldAlignment = 'Horizontal';
        //pageHelperField.helpText = 'Help test for field';
        dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist'); 
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        //pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }

    @IsTest
    public static void testMethod_15(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.fieldAPIName = 'name';
        //pageHelperField.fieldAlignment = 'Vertical';
        //pageHelperField.helpText = 'Help test for field';
        dynCon = TestHelper.getDynamicFieldConfig(true,'Picklist'); 
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        //pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }

    @IsTest
    public static void testMethod_16(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.helpText = 'Help test for field';
        dynCon = TestHelper.getDynamicFieldConfig(true,'Typeahead');    
        altRen_1 = new PageLayoutConfigHelper.AlternativeRendering(dynCon);
        pageHelperField.altRen = altRen_1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');
    }
     @IsTest
    public static void testMethod_17(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'Help test for field';
        pageHelperField.dataType = 'DOUBLE';
        pageHelperField.decimalScale=1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');        
    }
    @IsTest
    public static void testMethod_18(){
        setup(); 
        Test.startTest();
        pageHelperField.isBlankSpace = false;
        pageHelperField.isStaticText = false;
        pageHelperField.isFieldLevelAttachment = false; 
        pageHelperField.helpTextPost = 'This is help text';
        pageHelperField.helpText = 'Help test for field';
        pageHelperField.dataType = 'PERCENT';
        pageHelperField.decimalScale=1;
        FlexLayoutFieldsPreviewGenerator ctrl = new FlexLayoutFieldsPreviewGenerator(layoutHolder,body,pageHelperField);
        String result_1 = ctrl.generate();
        Test.stopTest();
        System.assertNotEquals('test1','test2');        
    }

}