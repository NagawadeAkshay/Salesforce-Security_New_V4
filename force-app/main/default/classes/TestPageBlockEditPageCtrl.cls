@isTest
public class TestPageBlockEditPageCtrl {
	public PageReference savePage;
    public PageReference cancelPage;
	 @isTest
    private static void setup_1(){
 		Task tsk_1 = TestHelper.getTask(false); 
 		insert tsk_1;
 		PageReference pageRef = Page.SampleViewPage1;
 		Test.setCurrentPage(pageRef);
		ApexPages.CurrentPage().getParameters().put('id',tsk_1.id);
    	ApexPages.StandardController sc = new ApexPages.standardController(tsk_1);
        PageBlockEditPageCtrl sic = new PageBlockEditPageCtrl(sc);
        sic.orgType = '';
        sic.savePage = pageRef;
        sic.cancelPage = pageRef;
        sic.listDefaultValues = new List<DynamicLayoutDefaultValueHelper>();
        sic.getKeyValueMap();        
        system.assert(sic!=null);
 	}    
}