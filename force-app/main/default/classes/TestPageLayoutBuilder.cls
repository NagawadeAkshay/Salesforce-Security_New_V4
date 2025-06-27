@isTest
public class TestPageLayoutBuilder {
	
	 @isTest
    private static void getSetupInfo(){
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true); 
        SObjectConfig__c sobj = TestHelper.getSObjectConfig(true);
        Map<String,Object> params = new Map<String,Object>();
        params.put('SobjectConfigId',pageLayout.id);
        params.put('PageLayoutId',sobj.id);
        Map<String,Object> result = PageLayoutBuilder.getSetupInfo(params);  
        Map<String,Object> params2 = new Map<String,Object>();
        params2.put('PageLayoutId',pageLayout.id);
        Map<String,Object> result2 = PageLayoutBuilder.getSetupInfo(params2);  
        Map<String,Object> params3 = new Map<String,Object>();
        Map<String,Object> result3 = PageLayoutBuilder.getSetupInfo(params3);  
        system.assert(result != null);        
    }
         
    @isTest
    private static void getSobjectInfo(){
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true); 
        SObjectConfig__c sobj = TestHelper.getSObjectConfig(true);
        Map<String,Object> params = new Map<String,Object>();
        params.put('SobjectConfigId',pageLayout.id);
        params.put('PageLayoutId',sobj.id);
         PageLayoutBuilder PageLayoutBuilderObj = new PageLayoutBuilder();
        Map<String,Object> result = PageLayoutBuilderObj.getSobjectInfo(sobj.id,params);  
        system.assert(result != null);        
    }    
    
    @isTest
    private static void getPageLayoutInfo(){
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true); 
        PageLayoutBuilder PageLayoutBuilderObj = new PageLayoutBuilder();
        Map<String,Object> result = PageLayoutBuilderObj.getPageLayoutInfo(pageLayout.id);  
        system.assert(result != null);        
    }
    
    @isTest
    private static void getPageLayoutInfo1(){
        PageLayoutConfig__c pageLayout = TestHelper.getPageLayoutConfig(true); 
        PageLayoutBuilder PageLayoutBuilderObj = new PageLayoutBuilder();
        Map<String,Object> result = PageLayoutBuilderObj.getPageLayoutInfo(pageLayout.id);  
        system.assert(result != null);        
    }
    
  @isTest
static void testgetPageLayoutcon(){
	Test.startTest();
    List<sObject> sObjectList = new List<sObject>();
    Map<String, String> fieldLableMap = new Map<String, String>();
    Map<String, String> fieldDataTypeMap = new Map<String, String>();
    Map<String, Integer> scaleMap =new  Map<String, Integer>();
    String label;
	PageLayoutBuilder.PageWrapper costom = new PageLayoutBuilder.PageWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
	Test.stopTest();
    System.assertNotEquals(sObjectList,null);
  

    
}
}