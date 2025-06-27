@isTest
public class TestSiteLoginController {
	@isTest
    private static void setupData(){
         SiteLoginController obj = new SiteLoginController();
         System.assertNotEquals(null, obj);
         obj.login();
         PageReference pageRef = Page.RedirectToFileDownload; // Add your VF page Name here
         pageRef.getParameters().put('startURL','www.login.salesforce.com');
         Test.setCurrentPage(pageRef);  
    }
}