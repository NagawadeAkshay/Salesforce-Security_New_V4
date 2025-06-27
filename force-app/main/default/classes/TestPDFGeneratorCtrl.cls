@isTest
public class TestPDFGeneratorCtrl {    

    @isTest
    static void testgetPDFGeneratorIcon(){
        Test.startTest();
        Map<String, String> result = PDFGeneratorCtrl.getPDFGeneratorIcon();
        Map<String, String> resultLWC = PDFGeneratorCtrl.getPDFGeneratorIconLwc();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }

}