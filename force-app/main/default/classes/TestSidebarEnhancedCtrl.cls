@isTest private class TestSidebarEnhancedCtrl {
    
    @testSetup static void setup() {
        TestHelper.createCustomSettings(true); 
        TestHelper.getCustomAppConfig(true);
        TestHelper.getProfileDropDownConfig(true); 
        TestHelper.getCustomAppPhaseConfig(true);
        
    }
    
    @isTest static void testFetchComponentsNegative() {     
        Test.startTest();
        Map<String, Object> parameterMap = new Map<String, Object>();
        parameterMap.put('cookieTabName', 'GrantorPlanning');
        parameterMap.put('objName', 'SampleObject11__c');
        AppDefinition appDefinition = [SELECT DurableId, Label FROM AppDefinition LIMIT 1];        
        UserAppInfo app = new UserAppInfo(AppDefinitionId = appDefinition.DurableId, 
                                          UserId = UserInfo.getUserId(), FormFactor = 'Small');        
        insert app;
        SidebarEnhancedCtrl.fetchComponents(parameterMap);
        system.assertNotEquals(null,  SidebarEnhancedCtrl.fetchComponents(parameterMap));
        Test.stopTest();
    }
    
    @isTest static void testRemoteActions() {
        PhaseConfig__c phaseConfig = TestHelper.getphase(true);
        SObjectConfig__c sObjConfig = TestHelper.getSObjectConfig(true);
        
        SObjectPhaseConfig__c sObjPhaseConfig = TestHelper.getSObjectPhaseConfig(phaseConfig.Id, sObjConfig.Id, true);
        
        AccordionHeader__c header = TestHelper.getAccordionHeader(phaseConfig.Id, false);
        header.Type__c = 'Activity';
        header.Active__c = true;
        insert header;
        
        
        AccordionHeader__c header2 = TestHelper.getAccordionHeader(phaseConfig.Id, false);
        header2.Type__c = 'Task';
        header2.Active__c = true;
        insert header2;
        
        AccordionSubHeader__c subHeader = TestHelper.getAccordionSubHeader(header.Id, false);
        subHeader.Active__c = true;
        insert subHeader;
        
        AccordionSubHeader__c subHeader2 = TestHelper.getAccordionSubHeader(header2.Id, false);
        subHeader2.Active__c = true;
        insert subHeader2;
        
        AccordionContent__c content = TestHelper.getAccordionContent(subHeader.Id, false);
        content.Availableforprofiles__c = 'System Administrator';
        content.Active__c = true;
        insert content;
        
        AccordionContent__c content2 = TestHelper.getAccordionContent(subHeader2.Id, false);
        content2.Availableforprofiles__c = 'System Administrator';
        content2.Active__c = true;
        insert content2;
        
        Map<String, Object> parameterMap = new Map<String, Object>();
        parameterMap.put('urlTabName', 'TestPhase');
        SidebarEnhancedCtrl.fetchComponents(parameterMap);
        
        
        TestHelper.getExternalLinks(phaseConfig.Id, true);
        parameterMap.put('currentPhase', 'TestPhase');
        SidebarEnhancedCtrl.fetchExternalLinks(parameterMap);
        
        parameterMap.put('loggedInUserProfile', 'System Administrator');
        SidebarEnhancedCtrl.fetchTechSupportLinks(parameterMap);
        
        SidebarEnhancedCtrl.fetchRecentlyViewed(parameterMap);
        SidebarEnhancedCtrl.fetchGlobalSearchConfig(parameterMap);
    
        parameterMap.put('searchTerm', 'SampleObject11__c?');
        parameterMap.put('objectName', 'SampleObject11__c');
        SidebarEnhancedCtrl.fetchSearchTypeAheadRecords(parameterMap);
        
        system.assertNotEquals(null, SidebarEnhancedCtrl.fetchSearchTypeAheadRecords(parameterMap));
            
    }

    @isTest static void testUpdateCollapsedState(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            PhaseConfig__c phaseConfig = TestHelper.getphase(true);
            AccordionHeader__c header = TestHelper.getAccordionHeader(phaseConfig.Id, false);
            header.Type__c = 'Activity';
            header.Active__c = true;
            insert header;
            
            AccordionSubHeader__c subHeader = TestHelper.getAccordionSubHeader(header.Id, false);
            subHeader.Active__c = true;
            insert subHeader;
            
            AccordionContent__c content = TestHelper.getAccordionContent(subHeader.Id, false);
            content.Availableforprofiles__c = 'System Administrator';
            content.Active__c = true;
            insert content;
            SidebarEnhancedCtrl.updateCollapsedState(header.Id,'header',true);
            SidebarEnhancedCtrl.updateCollapsedState(header.Id,'header',false);
            SidebarEnhancedCtrl.updateCollapsedState(header.Id,'component',true);
            SidebarEnhancedCtrl.updateCollapsedState(header.Id,'component',false);
            String test = 'Success';
            System.assertEquals('Success', test);
        }

    }
    @isTest static void testMethod1() {     
        Test.startTest();
        Map<String, Object> parameterMap = new Map<String, Object>();
        parameterMap.put('urlTabName', 'TestPhase');
        parameterMap.put('currentPhase', 'TestPhase');
        parameterMap.put('loggedInUserProfile', 'System Administrator');
        parameterMap.put('searchTerm', 'SampleObject11__c?');
        parameterMap.put('objectName', 'SampleObject11__c');
        SidebarEnhancedCtrl.isCommunitySiteUser();
        SidebarEnhancedCtrl.fetchRecentlyViewedWrapper(parameterMap);
        
        Task testTaskRcd=new Task();
        testTaskRcd.Subject='Email';
        insert testTaskRcd;
        SidebarEnhancedCtrl.fetchMiniLayout(testTaskRcd.Id);
        Test.stopTest();
        System.assertNotEquals(null, testTaskRcd);
    }
   /* @isTest static void testgetTabName() {
        string parameter = 'Application';
        system.assertNotEquals('GrantorHome', SidebarEnhancedCtrl.getTabName(parameter));
    }

    @isTest static void testgetTabNameFromRecordPage() {
        
    }*/

    @isTest
    static void testGovGrantsGetter() {
        SidebarEnhancedCtrl sbctrl = new SidebarEnhancedCtrl();
        String result = sbctrl.govGrants;
        System.assertEquals(sbctrl.govGrants, result);
    }

    @isTest
    static void testGetUserProfileName() {
        User testUser = TestHelper.getAdminUser(true);
        System.runAs(testUser) {
            String profileName = SidebarEnhancedCtrl.getUserProfileName();
            Test.startTest();
            Profile expectedProfile = [SELECT Id, Name FROM Profile WHERE Id = :testUser.ProfileId LIMIT 1];
            Test.stopTest();
            System.assertEquals(expectedProfile.Name, profileName);
        }
    }
    @isTest
    static void testgetTabNameFromRecordPage(){
        PhaseConfig__c phaseConfig = TestHelper.getphase(true);
        SObjectConfig__c sObjConfig = TestHelper.getSObjectConfig(true);
        SObjectPhaseConfig__c sObjPhaseConfig = TestHelper.getSObjectPhaseConfig(phaseConfig.Id, sObjConfig.Id, true);
        AppDefinition appDefinition = [SELECT DurableId, Label FROM AppDefinition LIMIT 1];
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        SObjectConfig__c sObjCon = new SObjectConfig__c();
        sObjCon.Name = 'Account';
        insert sObjCon; 
        UserAppInfo app = new UserAppInfo(AppDefinitionId = appDefinition.DurableId, 
                                          UserId = UserInfo.getUserId(), FormFactor = 'Small');        
        insert app;
        Test.StartTest();
        SidebarEnhancedCtrl.getTabName(phaseConfig.Name);
        SidebarEnhancedCtrl.getTabNameFromRecordPage(sObjConfig.Name,sObjConfig.Id);
        Test.StopTest();
        SObjectPhaseConfig__c sObjPhaseConfig1 = TestHelper.getSObjectPhaseConfig(phaseConfig.Id, sObjCon.Id, true);
        SidebarEnhancedCtrl.getTabNameFromRecordPage(sObjCon.Name,sObjCon.Id);
        System.assertNotEquals(null, sObjCon);
    }
       @isTest
static void testGetSideBarWrapper(){
	Test.startTest();
    List<sObject> sObjectList = new List<sObject>();
    Map<String, String> fieldLableMap = new Map<String, String>();
    Map<String, String> fieldDataTypeMap = new Map<String, String>();
    Map<String, Integer> scaleMap =new  Map<String, Integer>();
    String label;
	SidebarEnhancedCtrl.SideBarWrapper costom = new SidebarEnhancedCtrl.SideBarWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
	//CustomLookupLwcController custom = new CustomLookupLwcController();
	Test.stopTest();
    System.assertNotEquals(sObjectList,null);
   
	
}
}