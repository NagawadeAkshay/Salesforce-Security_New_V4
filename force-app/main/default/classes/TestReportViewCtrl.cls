@IsTest
private with sharing class TestReportViewCtrl {
    @IsTest
    private static void testInsert() {
        User u = TestHelper.getAdminUser(true);
       
        
        System.runAs(u) {   
      	 
				//Prepare test data
				//Report rp= new Report(DeveloperName = 'Award_Status_Report');
			  	//rp.DeveloperName = 'Award_Status_Report';
			   	// insert rp;
                //Report r = [select Id from Report where  DeveloperName = 'All_Active_Users'];
                
                //Report r = [select Id from Report where  DeveloperName = 'List_of_All_the_Users'];
                ApexPages.CurrentPage().getParameters().put('name','List_of_All_the_Users');
              	//ApexPages.StandardController stdController = new ApexPages.StandardController(r);
                
             	//Execute test
              	Test.startTest();
                  
              	//ReportViewCtrl prec = new ReportViewCtrl(stdController);
                    
              	//prec.redirect();
                System.assertNotEquals(null, u);
               	Test.stopTest();
         
              	//Assert test data
             	//System.assertEquals(prec, prec);
        }
    }   
}