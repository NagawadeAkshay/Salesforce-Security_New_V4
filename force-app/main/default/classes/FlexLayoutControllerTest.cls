@isTest
public with sharing class FlexLayoutControllerTest {

    
    @isTest
    public static void getHeaderDetails() {
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        PageLayoutConfig__c pageLayoutConfig = TestHelper.getPageLayoutConfig(true,recordId.getSobjectType().getDescribe().getName());
        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
        tabConfig.isOverview__c = true;
        
        upsert tabConfig;
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true,'Fields');
        PageLayoutActionConfig__c pageAction = TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        pageAction.DisableDecisionExpression__c=null;
        pageAction.ActionURL__c = '';
        pageAction.HideExpressionJSON__c= '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Name"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}';        
        upsert pageAction;
        FlexLayoutController.ActionWrapper ActionWrapper = new FlexLayoutController.ActionWrapper(pageAction);
        String Json1 = JSON.serialize(ActionWrapper);
        PageLayoutActionConfig__c pageAction1 = TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        pageAction1.DisableDecisionExpression__c=null;
        pageAction1.ActionURL__c = '';
        pageAction1.ActionClass__c = 'FlexLayoutControllerTest.DynamicLayoutDeleteHelperLayoutTest';
        pageAction1.HideExpressionJSON__c= '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Name"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}';
        upsert pageAction1;
        FlexLayoutController.ActionWrapper ActionWrapper1 = new FlexLayoutController.ActionWrapper(pageAction1);
        String Json2 = JSON.serialize(ActionWrapper1);
        PageLayoutActionConfig__c pageAction2 = TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        pageAction2.DisableDecisionExpression__c=null;
        pageAction2.ActionURL__c = '';
        pageAction2.ActionClass__c = 'FlexLayoutControllerTest.DynamicLayoutDeleteHelperLayoutTest1';
        pageAction2.HideExpressionJSON__c= '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","Value":"Name"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"test","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}';
        upsert pageAction2;
        FlexLayoutController.ActionWrapper ActionWrapper2 = new FlexLayoutController.ActionWrapper(pageAction2);
        String Json3 = JSON.serialize(ActionWrapper2);
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        pageBlockDetailConfig.HideFieldsJSON__c ='Name';
        upsert pageBlockDetailConfig;
        pageLayoutConfig.title__c = 'TestMerge - {!Name}';
        pageLayoutConfig.SaveButtonLabel__c = 'Save';
        pageLayoutConfig.CancelButtonLabel__c = 'Cancel';
        pageLayoutConfig.IsActive__c = true;
        pageLayoutConfig.ObjectAPIName__c= recordId.getSobjectType().getDescribe().getName();
        pageLayoutConfig.Name = 'templateName';
        FlexLayoutController.PageLayoutWrapper pageLayoutWrapper = new FlexLayoutController.PageLayoutWrapper(pageLayoutConfig);
        pageLayoutWrapper.recordId = recordId;
        String Json = JSON.serialize(pageLayoutWrapper); 
        upsert pageLayoutConfig;
        SObjectConfig__c sobjectConfig =  TestHelper.getSObjectConfig(true);
        sobjectConfig.DetailLayoutInitializer__c = '[{ "type" : "PageTemplate", "value" : "templateName" }]';
        sobjectConfig.name = AppUtils.getNamespacePrefix()+'SampleObject1__c';
        upsert sobjectConfig;
        insert new KeyValueStore__c(name='PreventURLHacking',Description__c='PreventURLHacking',BooleanValue__c=true);        
        Test.startTest();
        String output1 = FlexLayoutController.getHeaderDetails(pageLayoutConfig.Id, recordId,'',true);
        String output2 = FlexLayoutController.actionClassExecute(Json1, recordId,'',null,null,pageLayoutConfig.Name,null);
        output2 = FlexLayoutController.actionClassExecute(Json2, recordId,'',null,null,pageLayoutConfig.Name,null);
        output2 = FlexLayoutController.actionClassExecute(Json3, recordId,'',null,null,pageLayoutConfig.Name,null);
        List<String> output3 = FlexLayoutController.getPageLayoutActions(Json,'',true,'View', false, '');
        String output4 = FlexLayoutController.getPageTemplateDetails(recordId,null,'');
        output4 = FlexLayoutController.getPageTemplateDetails(recordId,null,'{"type":"standard__recordPage","attributes":{"objectApiName":"Program__c","recordId":"a1N3u000004uvLHEAY","actionName":"view"},"state":{}}');
        output4 = FlexLayoutController.getPageTemplateDetails(recordId,'Test View Layout','');
        Boolean b1 = FlexLayoutController.hasRecordEditAccess(recordId,'Edit',pageLayoutConfig.Id);
        Test.stopTest();
        System.assertNotEquals(null, output1);
    }

    @isTest
    public static void getHeaderDetails2() {
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        PageLayoutConfig__c pageLayoutConfig = TestHelper.getPageLayoutConfig(true,recordId.getSobjectType().getDescribe().getName());
        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
        tabConfig.isOverview__c = true;
        upsert tabConfig;
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true,'Fields');
        // PageLayoutActionConfig__c pageAction = TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        pageBlockDetailConfig.HideFieldsJSON__c ='';
        upsert pageBlockDetailConfig;
        pageLayoutConfig.title__c = 'TestMerge {!Name}';
        pageLayoutConfig.IsActive__c = true;
        pageLayoutConfig.ObjectAPIName__c= recordId.getSobjectType().getDescribe().getName();
        pageLayoutConfig.Name = 'templateName';        
        FlexLayoutController.PageLayoutWrapper pageLayoutWrapper = new FlexLayoutController.PageLayoutWrapper(pageLayoutConfig);
        pageLayoutWrapper.recordId = recordId;
        String Json = JSON.serialize(pageLayoutWrapper); 
        upsert pageLayoutConfig;
        Id pageLayoutId = pageLayoutConfig.Id;
        PageTemplate__c template = new PageTemplate__c(Name='templateName', EditLayoutConfig__c=pageLayoutId,
                                        ViewLayoutConfig__c=pageLayoutId,PrintLayoutConfig__c = pageLayoutId,Description__c='testDesc',
                                        RTALimitConfig__c='Enforce Char Limit',
                                        OMBNumber__c='F-0001',PackageType__c='Application',Type__c='Standard');
        upsert template;
        MessageConfig__c msgConfig = new MessageConfig__c(StandardStyle__c='warning',
                                        MessageRich__c='MessageRich__c',PageLayoutConfig__c=pageLayoutId,PageBlockConfig__c=pageBlockConfig.Id);
        upsert msgConfig;
        SObjectConfig__c sobjectConfig =  TestHelper.getSObjectConfig(true);
        sobjectConfig.DetailLayoutInitializer__c = '[{ "type" : "ApexClass", "value" : "FlexLayoutControllerTest.PageTemplateDetailsClassTest" },{ "type" : "PageTemplate", "value" : "templateName" }]';
       
        sobjectConfig.name = AppUtils.getNamespacePrefix()+'SampleObject1__c';
        upsert sobjectConfig;

        Test.startTest();
        String output1 = FlexLayoutController.getHeaderDetails(pageLayoutConfig.Id, recordId,'',true);
        String output2 = FlexLayoutController.actionClassExecute(Json, recordId,'',null,null,pageLayoutConfig.Name,null);
        output2 = FlexLayoutController.getLayoutOnLoadDetails('a1N3u000004uvLHEAY',recordId,true);
        Id layoutId = FlexLayoutController.getPageLayoutConfigId('templateName',recordId);
        pageLayoutConfig.title__c = 'TestMerge {!NameInvalid}';
        upsert pageLayoutConfig;
        layoutId = FlexLayoutController.getPageLayoutConfigId('templateName',recordId);
        List<String> output3 = FlexLayoutController.getPageLayoutActions(Json,'',true,'View', false , '');
        String output4 = FlexLayoutController.getPageTemplateDetails(recordId,null,'');
        String output5 =  FlexLayoutController.getPageTemplateDetailsForModal('{"PageTemplate" : ["templateName"],"ApexClass":"FlexLayoutControllerTest.PageTemplateDetailsClassTest"}','SampleObject1__c');        
        String output6 =  FlexLayoutController.getPageTemplateDetailsForModal('{"ApexClass":"FlexLayoutControllerTest.PageTemplateDetailsClassTest"}','SampleObject1__c');        
        Test.stopTest();
        System.assertNotEquals(null, output1);
    }
    @isTest
    public static void getHeaderDetailsForms() {
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        PageLayoutConfig__c pageLayoutConfig = TestHelper.getPageLayoutConfig(true,recordId.getSobjectType().getDescribe().getName());
        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
        tabConfig.isOverview__c = true;
        upsert tabConfig;
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true,'Fields');
        // PageLayoutActionConfig__c pageAction = TestHelper.getPageLayoutActionConfig(true,pageLayoutConfig.Id);
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        pageBlockDetailConfig.HideFieldsJSON__c ='';
        upsert pageBlockDetailConfig;
        pageLayoutConfig.title__c = 'TestMerge {!Name}';
        pageLayoutConfig.IsActive__c = true;
        pageLayoutConfig.ObjectAPIName__c= recordId.getSobjectType().getDescribe().getName();
        pageLayoutConfig.Name = 'templateName';        
        FlexLayoutController.PageLayoutWrapper pageLayoutWrapper = new FlexLayoutController.PageLayoutWrapper(pageLayoutConfig);
        pageLayoutWrapper.recordId = recordId;
        String Json = JSON.serialize(pageLayoutWrapper); 
        upsert pageLayoutConfig;
        Id pageLayoutId = pageLayoutConfig.Id;
        PageTemplate__c template = new PageTemplate__c(Name='templateName', EditLayoutConfig__c=pageLayoutId,
                                        ViewLayoutConfig__c=pageLayoutId,PrintLayoutConfig__c = pageLayoutId,Description__c='testDesc',
                                        RTALimitConfig__c='Enforce Char Limit',
                                        OMBNumber__c='F-0001',PackageType__c='Application',Type__c='Standard');
        upsert template;
        MessageConfig__c msgConfig = new MessageConfig__c(StandardStyle__c='warning',
                                        MessageRich__c='MessageRich__c',PageLayoutConfig__c=pageLayoutId);
        upsert msgConfig;
        SObjectConfig__c sobjectConfig =  TestHelper.getSObjectConfig(true);
        sobjectConfig.DetailLayoutInitializer__c = '[{ "type" : "PageTemplate", "value" : "templateName" }]';
        sobjectConfig.name = AppUtils.getNamespacePrefix()+'SampleObject1__c';
        upsert sobjectConfig;

        //insert new KeyValueStore__c(name='EnableSalesforceFile',Description__c='EnableSalesforceFile',BooleanValue__c=true);
        FlexLayoutController.PageLayoutWrapper pageLayoutWrapper2 = FlexLayoutController.getFormConfigDetails('templateName',pageLayoutWrapper);        
        String json2 = System.JSON.serialize(pageLayoutWrapper2);         
        
        Test.startTest();
        String output1 = FlexLayoutController.getHeaderDetails(pageLayoutConfig.Id, recordId,'',true);
        String output2 = FlexLayoutController.actionClassExecute(Json, recordId,'',null,null,pageLayoutConfig.Name,null);
        String parentid = sampleObject1.Id;
        List<String> output3 = FlexLayoutController.getPageLayoutActions(Json,'',true,'View', true , parentid);
        String output4 = FlexLayoutController.getPageTemplateDetails(recordId,null,'');
        String output5 =  FlexLayoutController.getPageTemplateDetailsForModal(null,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        String output6 =  FlexLayoutController.getLayoutOnLoadDetailsForModal('templateName',recordId,true);

        //onDemandSnapShotHelper() test
        String output7 = FlexLayoutController.onDemandSnapShotHelper(recordId,json2);
        //negative scenario
        output7 = FlexLayoutController.onDemandSnapShotHelper(recordId,recordId);

        Test.stopTest();
        System.assertNotEquals(null, output1);
    }

    @isTest
    public static void getLayoutOnLoadDetails() {
        SampleObject1__c sampleObject1 = TestHelper.getSampleObject1Val(true);
        Id recordId = sampleObject1.id;
        PageLayoutConfig__c pageLayoutConfig = TestHelper.getPageLayoutConfig(true,recordId.getSobjectType().getDescribe().getName());
        TabConfig__c tabConfig =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
        tabConfig.TabIcon__c = '<span class="fa fa-wrench"></span>';
        upsert tabConfig;
        TabConfig__c tabConfig1 =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
        tabConfig1.TabIcon__c = '<span class="fa fa-wrench" aria-hidden="true"></span>';
        upsert tabConfig1;
        TabConfig__c tabConfig2 =  TestHelper.getTabConfig(pageLayoutConfig.Id,true);
        tabConfig2.TabIcon__c = 'utility:up';
        upsert tabConfig2;
        PageBlockConfig__c pgBlock = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        pgBlock.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Table').getRecordTypeId();
        upsert pgBlock;
        PageBlockConfig__c pgBlock1 = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        FlexGridConfig__c flexGridConfig = TestHelper.getFlexGridConfig(true);
        pgBlock1.FlexGridName__c = flexGridConfig.Id;
        pgBlock1.FlexTableName__c = null;
        pgBlock1.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Flex Grid').getRecordTypeId();
        upsert pgBlock1;
        PageBlockConfig__c pgBlock2 = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        pgBlock2.FlexTableName__c = null;
        pgBlock2.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Communication').getRecordTypeId();
        upsert pgBlock2;
        PageBlockConfig__c pgBlock3 = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        pgBlock3.FlexTableName__c = null;
        pgBlock3.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Approval History').getRecordTypeId();
        upsert pgBlock3;
        PageBlockConfig__c pgBlock4 = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        pgBlock4.FlexTableName__c = null;
        pgBlock4.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Attachments').getRecordTypeId();
        upsert pgBlock4;
        PageBlockConfig__c pgBlock5 = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        pgBlock5.FlexTableName__c = null;
        pgBlock5.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Record History').getRecordTypeId();
        upsert pgBlock5;
        PageBlockConfig__c pgBlock6 = TestHelper.getPageBlockConfig(tabConfig1.Id,true);
        pgBlock6.FlexTableName__c = null;
        pgBlock6.RecordTypeId = Schema.SObjectType.PageBlockConfig__c.getRecordTypeInfosByName().get('Notes and Attachments').getRecordTypeId();
        upsert pgBlock6;
        PageBlockConfig__c pageBlockConfig =  TestHelper.getPageBlockConfig(tabConfig.Id, true,'Fields');
        PageBlockDetailConfig__c pageBlockDetailConfig = TestHelper.getPageBlockDetailConfig2(pageBlockConfig.Id,true); 
        PageBlockDetailConfig__c pageBlockDetailConfig1 = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        pageBlockDetailConfig1.HideFieldsJSON__c ='';
        pageBlockDetailConfig1.RequiredBehavior__c = 'Required for Save';
        pageBlockDetailConfig1.RequiredByRole__c= 'test';
        upsert pageBlockDetailConfig1;
        PageBlockDetailConfig__c pageBlockDetailConfig2 = TestHelper.getPageBlockDetailConfig(pageBlockConfig.Id,true); 
        pageBlockDetailConfig2.HideFieldsJSON__c ='';
        pageBlockDetailConfig2.RequiredBehavior__c = 'Required for Submit';
        pageBlockDetailConfig2.RequiredForSubmitByRole__c= 'test;test;test';
        upsert pageBlockDetailConfig2;

        pageBlockDetailConfig.FieldAPIName__c = AppUtils.getNameSpacePrefix()+'Sample_Object_2__r.name';
        upsert pageBlockDetailConfig;
        pageLayoutConfig.title__c = 'TestMerge {!Name}';
        pageLayoutConfig.IsActive__c = true;
        pageLayoutConfig.ObjectAPIName__c= recordId.getSobjectType().getDescribe().getName();
        pageLayoutConfig.Name = 'templateName';

        upsert pageLayoutConfig;
        MessageConfig__c msgConfig = new MessageConfig__c(StandardStyle__c='warning',
                                        MessageRich__c='MessageRich__c',PageLayoutConfig__c=pageLayoutConfig.Id,PageBlockConfig__c=pageBlockConfig.Id);
        upsert msgConfig;
        
        
        FlexLayoutController.FieldWrapper fw = new FlexLayoutController.FieldWrapper();
        FlexLayoutController.FieldWrapper fw1 = new FlexLayoutController.FieldWrapper(pageBlockDetailConfig,true,false);
        FlexLayoutController.FieldWrapper fw2 = new FlexLayoutController.FieldWrapper(pageBlockDetailConfig,false,true);       
        Test.startTest();
        String output1;
        // String output1 = FlexLayoutController.getLayoutOnLoadDetails(pageLayoutConfig.Id, recordId,true);
        List<String> output2 = FlexLayoutController.getPageBlockDetails(tabConfig.Id, recordId,pageLayoutConfig.ObjectAPIName__c,true,null,true);
        output2 = FlexLayoutController.getPageBlockDetails(tabConfig1.Id, recordId,pageLayoutConfig.ObjectAPIName__c,true,null,true);        
        List<String> output3 = FlexLayoutController.getPageLayoutTabs(pageLayoutConfig.Id,pageLayoutConfig.ObjectAPIName__c,recordId,null,true,true);
        List<String> tabsOpened = new List<String>();
        output1 = FlexLayoutController.requiredForSubmitOrSave(pageLayoutConfig.Id,recordId,'SampleObject1__c','Required for Submit',JSON.serialize(tabsOpened),'',true);
        output1 = FlexLayoutController.requiredForSubmitOrSave(pageLayoutConfig.Id,recordId,'SampleObject1__c','Required for Save',JSON.serialize(tabsOpened),'',true);
        Object outPut_1 = FlexLayoutController.getAutoSnapshotFieldValue(recordId,'SampleObject1__c','Status__c');
        outPut_1 = FlexLayoutController.getAutoSnapshotFieldValue(recordId,'SampleObject1__c','invalid');
        FlexLayoutController.initiateAutoSnapshot(recordId,null,null,'In Progress');
        Test.stopTest();
        System.assertNotEquals(null, output2);
    }

    public with sharing class DynamicLayoutDeleteHelperLayoutTest extends DynamicLayoutActionStay{
	
        public override String whenClicked(){
            return deleteRecord();
        }
        
        /*
        * Method to delete the current record
        */
        public String deleteRecord()
        {
            Id rcrdId = layoutHolder.getPrimarySObject().Id;
            
            // Get all the objects info
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
            // Now map all key prefixes to object type labels.
            // We don't know how many different types of What IDs there can be. This handles all possible object types.
            String prefix;
            map<String, String> prefixMap = new map<String, String>();
            for (Schema.SObjectType ot : gd.values())
            { 
                prefix = ot.getDescribe().getKeyPrefix();
                if (prefix != null)
                {
                prefixMap.put(prefix, ot.getDescribe().getName());
                }
            }
            
            String objectName;
            String sub;
            // Get the first three characters from the rcrdId.
            sub = String.valueOf(rcrdId).substring(0, 3);
            if (sub != null)
            { 
                // Look up the prefix in the map.
                objectName = prefixMap.get(sub);
            }   
    
            try{
                if (objectName != null) {
                    string deleteQuery = 'SELECT ID FROM ' + string.escapeSingleQuotes(objectName) + ' WHERE ID  =:rcrdId  WITH SECURITY_ENFORCED';
                    sObject obj = Database.query(String.escapeSingleQuotes(deleteQuery));
                    SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                    String objName = cls.getSobjectName(obj);
                     if(obj != null && AppUtils.isObjectDeletable(objName)){
                            delete obj;//FLS/ CRUD False +ve with the help of apputil we have performed check
                    } 
                }   
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AppUtils.handleSystemExceptionMsg(e)));
                return null;
            }
            
            //deletePage is pagereference variable that we pass as attribute from flexviewlayout component.
            if(layoutHolder.deletePage != null){
               return String.valueOf(layoutHolder.deletePage);
            }else{
            return String.valueOf(AppUtils.getHomePage());
       
            }
        }
    }

    public without sharing class PageTemplateDetailsClassTest extends GenericCtrl {
        public PageTemplateDetailsClassTest(){
        }

        public override string init(){
            return 'templateName';
        }

        public override string getKeyValueMapGeneric(Id recordId){
            String userInfoId = UserInfo.getUserId();
            Map<String,Object> keyValueMap = new Map<String,Object>();  
             keyValueMap.put('userInfoId', userInfoId);   
             return JSON.serialize(keyValueMap);   
         }

         public override string getListParamsGeneric(Id recordId){
            Map<String,Set<String>> listKeyValueMap = new Map<String,Set<String>>();
             return JSON.serialize(listKeyValueMap);
        }

    }

    public with sharing class DynamicLayoutDeleteHelperLayoutTest1 extends DynamicLayoutAction{
	
        public override PageReference whenClicked(){
            return deleteRecord();
        }
        
        /*
        * Method to delete the current record
        */
        public PageReference deleteRecord()
        {
            Id rcrdId = layoutHolder.getPrimarySObject().Id;
            
            // Get all the objects info
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
            // Now map all key prefixes to object type labels.
            // We don't know how many different types of What IDs there can be. This handles all possible object types.
            String prefix;
            map<String, String> prefixMap = new map<String, String>();
            for (Schema.SObjectType ot : gd.values())
            { 
                prefix = ot.getDescribe().getKeyPrefix();
                if (prefix != null)
                {
                prefixMap.put(prefix, ot.getDescribe().getName());
                }
            }
            
            String objectName;
            String sub;
            // Get the first three characters from the rcrdId.
            sub = String.valueOf(rcrdId).substring(0, 3);
            if (sub != null)
            { 
                // Look up the prefix in the map.
                objectName = prefixMap.get(sub);
            }   
    
            try{
                if (objectName != null) {
                    string deleteQuery = 'SELECT ID FROM ' + string.escapeSingleQuotes(objectName) + ' WHERE ID  =:rcrdId  WITH SECURITY_ENFORCED';
                    sObject obj = Database.query(String.escapeSingleQuotes(deleteQuery));
                    SystemContextMethodsHelper cls = new SystemContextMethodsHelper();
                    String objName = cls.getSobjectName(obj);
                     if(obj != null && AppUtils.isObjectDeletable(objName)){
                            delete obj;//FLS/ CRUD False +ve with the help of apputil we have performed check
                    } 
                }   
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AppUtils.handleSystemExceptionMsg(e)));
                return null;
            }
            
            //deletePage is pagereference variable that we pass as attribute from flexviewlayout component.
            if(layoutHolder.deletePage != null){
               return layoutHolder.deletePage;
            }else{
            return AppUtils.getHomePage();
       
            }
        }
    }
}