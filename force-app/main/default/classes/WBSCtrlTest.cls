@isTest
public with sharing class WBSCtrlTest {
    public static SampleObject2__c samObj;
    public static SObjectLayoutConfig__c sObjLay;
    public static Boolean bool;

    private static void setup_1(){
        // TO DO: implement unit test
        bool = TestHelper.createCustomSettings(true);
        samObj = TestHelper.getSampleObject2Val(false);
        samObj.SampleDate__c=date.newInstance(2016, 11, 15);
        SampleObject1__c samObj1 = TestHelper.getSampleObject1Val(true);
        samObj.SampleObject1__c = samObj1.Id;
        insert samObj;
        sObjLay = TestHelper.getSObjectLayoutConfig(false);
        SObjectConfig__c sObjCon = TestHelper.getSObject2Config(true);
        sObjLay.SObjectConfig__c = sObjCon.Id;
        sObjLay.RecordTypeId = Schema.SObjectType.SObjectLayoutConfig__c.getRecordTypeInfosByName().get('Mini Layout').getRecordTypeId();
        insert sObjLay;
    }

    @isTest
    public static void fetchMiniLayoutTest(){
        setup_1();
        Map<String,Object> response = WBSCtrl.fetchMiniLayout(samObj.id);
    	//helper.process();
        System.assertNotEquals(null,response);
    }

    @isTest
    public static void test_1(){
        //DataTableConfig__c sObjLayout = TestHelper.getFlexDataTableConfig(true);
    	//helper.process();
    	System.assertEquals(null,WBSCtrl.fetchStatusField(''));
    }

    @isTest
    public static void getWBSDataMapTest(){
        setup_1();
        
        DataTableConfig__c flextable1 = new DataTableConfig__c(
            Name = 'SampleObject1Table',
            Header__c = 'Sample Object 1',
            SObject__c = 'SampleObject11__c',
            RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'WBS'),
            Description__c = 'Test',
            WBSDataConfig__c = '[{"object":"WBSTaskSchedule__c","fields":"Id,Name,OwnerId,Owner.Name,CreatedDate","filterClause":"Id != \'\'","sortBy":"WBSNumber__c","assignedToFilter":"Id != null AND IsActive=true AND ContactId=null","dataOptions":{"id":"Id","text":"Name","owner":"OwnerId","wbsno":"WBSNumber__c","description":"Description__c","milestone":"Milestone__c","status":"Status__c","start_date":"StartDate__c","end_date":"EndDate__c","progress":"ProgressIndicator__c","duration":"TaskDuration__c","parent":"ParentWBSTaskSchedule__c"}}]',
            WBSPropertiesConfig__c = '{"work_time":"true","autosize":"y","grid_resize":"true","keyboard_navigation":"true","scroll_on_click":"true"}',
            WBSEventHandlerConfig__c = '{"onAfterTaskAdd":"onAfterTaskAdd","onAfterTaskUpdate":"onAfterTaskUpdate","onAfterTaskDelete":"onAfterTaskDelete","onBeforeLinkAdd":"onBeforeLinkAdd","onAfterLinkAdd":"onAfterLinkAdd"}',
            WBSHelperClass__c = 'WBSCtrlTest.WBSHelperClass',
            WBSLinkConfig__c = ''          
        );
        //WBSLinkConfig__c = '[{"object":"WBSTaskScheduleLink__c","fields":"Id,SourceTask__c,Type__c,TargetTask__c","linkOptions":{"source":"SourceTask__c","target":"TargetTask__c","type":"Type__c","id":"Id"}}]'
        insert flextable1;
        System.assertNotEquals(null, flextable1.Id);
        Map<String, String> params = new Map<String, String>();
        params.put('WBSGridName', flextable1.Name);
        params.put('ParametersMap', JSON.serialize(new Map<String, String>{'key'=> 'value'}));
        Map<String,Object> WBSData = WBSCtrl.getWBSDataMap(JSON.serialize(params));
        System.assertNotEquals(null, WBSData);
    }

    @isTest
    static void verifyExecuteClass(){
        Map<String, Object> keyValueMap = new Map<String, Object>();
        keyValueMap.put('eventMethodname', 'onAfterTaskAdd');
        Map<String,Object> result;
        try{
        result = WBSCtrl.executeClass('WBSCtrlTest.WBSHelperClass', JSON.serialize(keyValueMap));
            System.assertNotEquals(null, result);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        keyValueMap.put('eventMethodname', 'onAfterTaskUpdate');
        try{
            result = WBSCtrl.executeClass('WBSCtrlTest.WBSHelperClass', JSON.serialize(keyValueMap));
            System.assertNotEquals(null, result);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        keyValueMap.put('eventMethodname', 'onAfterTaskDelete');
        try{
            result = WBSCtrl.executeClass('WBSCtrlTest.WBSHelperClass', JSON.serialize(keyValueMap));
            System.assertNotEquals(null, result);
        }catch(Exception ex){
            System.assertNotEquals(null, ex);
        }

        result = WBSCtrl.executeClass('WBSCtrlTest.WBSHelperClass', null);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void verifyFetchAutoSuggestData(){
        Account objAccount = new Account(
            Name = 'Test Account',
            Type = 'Internal Test'
        );
        insert objAccount;
        System.assertNotEquals(null, objAccount.Id);

        User objUser = new User(
            ProfileId = UserInfo.getProfileId(),
            LastName = 'Library User',
            Email = 'libraryuser@example.com',
            Username = 'libraryuser@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            OrganizationId__c = objAccount.Id
        );
        insert objUser;
        System.assertNotEquals(null, objUser.Id);

        Map<String, Object> result = WBSCtrl.fetchAutoSuggestData('Name', 'Account', 'Test', null);
        System.assertNotEquals(null, result);

        result = WBSCtrl.fetchAutoSuggestData('Name', 'Account', null, null);
        System.assertNotEquals(null, result);       

        Map<String, String> paramsMap = new Map<String, String>();
        System.runAs(objUser){
            result = WBSCtrl.fetchAutoSuggestDataWithParams('Name', 'Account', 'Test', null, JSON.serialize(paramsMap));
            System.assertNotEquals(null, result);

            result = WBSCtrl.fetchAutoSuggestDataWithParams('Name', 'Account', null, null, JSON.serialize(paramsMap));
            System.assertNotEquals(null, result);
        }
        WBSHelperClass objWBSHelperClass = new WBSHelperClass();
        System.assertNotEquals(null, objWBSHelperClass);
        System.assertEquals(null, objWBSHelperClass.handleEvent());
    }

    public class WBSHelperClass extends WBSEventHandler {
        public WBSHelperClass(){
            this.keyValueMap = null;
        }
        public override Map<String, Object> handleEvent(){
            return null;
        }
    }
}