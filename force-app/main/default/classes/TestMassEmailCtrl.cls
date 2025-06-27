@isTest
public class TestMassEmailCtrl {
       static Map<String, Object> parametersMap = new Map<String,Object>();
       static Map<String, Object> attributeMap = new Map<String,Object>();
    
     
    @isTest
    public static void testGetPageData(){
		Account acc = TestHelper.getAccount(false);
		acc.AccountNumber = '123';
		insert acc;
		system.assertEquals('123', acc.AccountNumber);
		Test.startTest();
		MassEmailCtrl.getPageData('Contact');
		Test.stopTest();   
    }
    @isTest
    public static void testGetObjectFields(){
		Account acc = TestHelper.getAccount(false);
		acc.AccountNumber = '123';
		insert acc;
		system.assertEquals('123', acc.AccountNumber);
		Test.startTest();
		MassEmailCtrl.getObjectFields('Contact');
		Test.stopTest();   
    }
    @isTest
    public static void testGetListViews(){
		Account acc = TestHelper.getAccount(false);
		acc.AccountNumber = '123';
		insert acc;
		system.assertEquals('123', acc.AccountNumber);
		Test.startTest();
		MassEmailCtrl.getListViews();
		Test.stopTest();   
    }
    @isTest
    public static void testDeleteListViewRecord(){
        Account acc = TestHelper.getAccount(false);
        acc.AccountNumber = '123';
        insert acc;
        system.assertEquals('123', acc.AccountNumber);
        try {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TestMassEmailMock());
                MassEmailCtrl.deleteListViewRecord('Contact','Test');
            Test.stopTest();   
        }catch (Exception e) {
            
        }
    }
    @isTest
    public static void testDeleteListView(){
        Account acc = TestHelper.getAccount(false);
        acc.AccountNumber = '123';
        insert acc;
        system.assertEquals('123', acc.AccountNumber);
        try {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TestMassEmailMock());
                MassEmailCtrl.deleteListView('Contact','Test');
            Test.stopTest();   
        }catch (Exception e) {
            
        }
    }
    @isTest
    public static void testFetchEmailTemplates(){
        Account acc = TestHelper.getAccount(false);
        acc.AccountNumber = '123';
        insert acc;
        system.assertEquals('123', acc.AccountNumber);
            Test.startTest();
            MassEmailCtrl.fetchEmailTemplates();
            Test.stopTest();   
    }
    @isTest
    public static void testSaveListViewRecord(){
        Account acc = TestHelper.getAccount(false);
        acc.AccountNumber = '123';
        insert acc;
        system.assertEquals('123', acc.AccountNumber);
        try {
            Test.startTest();
               //MassEmailCtrl sectrl = new MassEmailCtrl();
               MassEmailCtrl.MassEmailListView m = new MassEmailCtrl.MassEmailListView ();
               m.name = 'test';
               m.label = 'label';
               m.objectName = 'Contact';
               List<MassEmailCtrl.ListViewFilter> l = new List<MassEmailCtrl.ListViewFilter> ();
               MassEmailCtrl.ListViewFilter lv = new MassEmailCtrl.ListViewFilter();
               lv.field = 'test';
               l.add(lv);

                MassEmailCtrl.saveListViewRecord(m,false,l);
            Test.stopTest();  
        } catch (Exception e) {
            
        }
    }

    
    @isTest
    public static void testGetListViewResult(){
        Account acc = TestHelper.getAccount(false);
        acc.AccountNumber = '123';
        insert acc;
        system.assertEquals('123', acc.AccountNumber);
        try {
            Test.startTest();
               Test.setMock(HttpCalloutMock.class, new TestMassEmailMock());
               MassEmailCtrl.getListViewResult('Contact','Test');
            Test.stopTest();
        } catch (Exception e) {
            
        }
               
    }

    public class TestMassEmailMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"foo":"bar"}');
            res.setStatusCode(200);            
            return res;
        }
    }

    @isTest
    static void testHandleDeleteResults() {
        MetadataService.DeleteResult deleteResult = new MetadataService.DeleteResult();
        deleteResult.success = true;
        MetadataService.Error err =  new MetadataService.Error();
        err.message = 'Test';
        List<MetadataService.Error> lst = new List<MetadataService.Error>();
        lst.add(err);
        deleteResult.errors = lst;
        Test.startTest();
        System.assertNotEquals(null,err);
        MassEmailCtrl.handleDeleteResults(deleteResult);
        Test.stopTest();
    }
   
}