@isTest
public class TestSObjectAutoSnapshotExpBuilderctrl {
	@isTest
    private static void setupData(){
         String nameSpaceprefix  = AppUtils.getNamespacePrefix();
         SObjectConfig__c sObjCon = new SObjectConfig__c();
         sObjCon.Name = nameSpaceprefix + 'SampleObject11__c';
         sObjCon.CriteriaField__c =  nameSpaceprefix  + 'Status__c';
         insert sObjCon; 
         SObjectAutoSnapshot__c sobjAutoSnap = new SObjectAutoSnapshot__c(isActive__c=true,SObject__c=sObjCon.Id,SnapShotFileName__c='Demo Snap Shot');
         insert sobjAutoSnap;
         PageReference pageRef = Page.RedirectToFileDownload; // Add your VF page Name here
         pageRef.getParameters().put('id',sobjAutoSnap.id);
         Test.setCurrentPage(pageRef);  
         SampleObject11__c testAccount = new SampleObject11__c();
         ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
         SObjectAutoSnapshotExpBuilderctrl obj = new SObjectAutoSnapshotExpBuilderctrl(sc);
         system.assertNotEquals(null,obj);      
    }
}