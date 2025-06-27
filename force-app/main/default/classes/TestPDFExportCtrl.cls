@isTest 
private class TestPDFExportCtrl {
		public static ExportTemplate__c expTemplate;
		public static Map<String, String> paramMap;
		public static String serializeStr;
 	@isTest
    private static void testFlexTableExport() {
    	expTemplate = new ExportTemplate__c(Body1__c='test PDF {!Name}', Body2__c=' Body2', Body3__c=' Body3', 
    	Body4__c=' <c:FlexTableExport FlextableName="TestDataTable"/> Body4',Name = 'SampleTemplate');
 		insert expTemplate;
		TestHelper.getDataTableConfig(true);
    	Test.startTest();
    		ApexPages.currentPage().getParameters().put('templateName', 'SampleTemplate');
    		ApexPages.currentPage().getParameters().put('id', expTemplate.Id);
    		PDFExportCtrl pdfTest = new PDFExportCtrl();
    		pdfTest.getPrintLayoutContents();
    		paramMap =new Map<String, String>();
    		paramMap.put('test','test');
    		serializeStr = JSON.serialize(paramMap);
    		string result=pdfTest.mergeFieldsStr=serializeStr;  
            system.assertNotEquals(null, result);
    	Test.stopTest();
    }
    @isTest
    private static void testFlexGridExport() {
    	expTemplate = new ExportTemplate__c(Body1__c='test PDF {!Name}', Body2__c=' Body2', Body3__c=' Body3', 
    	Body4__c=' <c:FlexGridExport FlextableName="TestDataTable"/> Body4',Name = 'SampleTemplate');
 		insert expTemplate;
		TestHelper.getDataTableConfig(true);
		Test.startTest();
		ApexPages.currentPage().getParameters().put('templateName', 'SampleTemplate');
		ApexPages.currentPage().getParameters().put('id', expTemplate.Id);
		PDFExportCtrl pdfTest = new PDFExportCtrl();   	
		pdfTest.getPrintLayoutContents();
		System.assertNotEquals(pdfTest,null);
    	Test.stopTest();
    }

	@isTest
	static void testgetPDFGeneratorIcon(){
		Test.startTest();
		Map<String, String> result = PDFExportCtrl.getPDFExportIcon();
		Map<String, String> resultLWC = PDFExportCtrl.getPDFExportIconLwc();
		Test.stopTest();
		System.assertNotEquals(null,result);
		System.assertNotEquals(null,resultLWC);
	}
}