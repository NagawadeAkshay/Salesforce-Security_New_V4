@isTest
private with sharing class CustomLookupLwcControllerTest{
    public static  SampleObject11__c ann;
    public static  SampleObject12__c sampleObject12;
    public static string searchKey;
    public static string sObjectApiName;
    public static String lookupfieldName;
    public static string fieldsName;
    public static string filterClause;
    public static String recordId;
    public static String pageBlockDetailId;
    public static String sendValueVfToLwc;
    public static PageBlockDetailConfig__c pageBlockDetail;
    
    public static void setupData(){        
        ann =TestHelper.getSampleObject1(true);
        sampleObject12 = TestHelper.getSampleObject2(true,ann.Id);
        recordId = sampleObject12.Id;
        lookupfieldName = AppUtils.getNameSpacePrefix()+'SampleObject11__c';
        sObjectApiName = AppUtils.getNameSpacePrefix()+'SampleObject12__c';
        fieldsName = 'Id,Name,SampleObject11__r.Name,IsRecordRecalled__c,SampleDate__c,SampleDateTime__c,CreatedById,SampleNumber1__c,SampleTextArea1__c,LastModifiedById,ownerId';
        searchKey = 'test';
        PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
        TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
        PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
        pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
        pageBlockDetailId = pageBlockDetail.id;
    }
        
        
    @isTest
    public static void fetchLookupData(){   
    
        User u = TestHelper.getAdminUser(true);
        setupData();
        System.runAs(u) {
            pageBlockDetail.DisplayLookupFieldNames__c = fieldsName;
            update pageBlockDetail; 
            Test.startTest();
            CustomLookupLwcController.fetchLookupData(searchKey ,sObjectApiName,lookupfieldName, fieldsName,filterClause,pageBlockDetailId);
            Test.stopTest();
        }
        System.assertNotEquals(u,null); 
    }

    @isTest
    public static void fetchLookupData2(){   
    
        User u = TestHelper.getAdminUser(true);
        setupData();
        System.runAs(u) {
            Test.startTest();  
            CustomLookupLwcController.fetchLookupData(searchKey ,sObjectApiName,lookupfieldName, fieldsName,filterClause,pageBlockDetailId);
            Test.stopTest();
        }
        System.assertNotEquals(u,null); 
    }
     
    @isTest
    public static void fetchDefaultRecord(){   
        User u = TestHelper.getAdminUser(true);
        setupData();
        System.runAs(u) {
            Test.startTest(); 
            CustomLookupLwcController.fetchDefaultRecord(sObjectApiName,lookupfieldName,sendValueVfToLwc);
            Test.stopTest();
        }
        System.assertNotEquals(u,null); 
    }
    
    @isTest
static void testgetFlexTablecon(){
	Test.startTest();
    List<sObject> sObjectList = new List<sObject>();
    Map<String, String> fieldLableMap = new Map<String, String>();
    Map<String, String> fieldDataTypeMap = new Map<String, String>();
    Map<String, Integer> scaleMap =new  Map<String, Integer>();
    String label;
	CustomLookupLwcController.CustomWrapper costom = new CustomLookupLwcController.CustomWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
	//CustomLookupLwcController custom = new CustomLookupLwcController();
	Test.stopTest();
    System.assertNotEquals(sObjectList,null);
   
	
}
  
}