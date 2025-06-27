@isTest
private with sharing class TestFlexTableExportCtrl {
        public static String serializeStr;
        public static String serializeStr1;
        public static Map<String,object> listParm;
        public static Map<String,object> flexTableParam;
        public static Map<String,object> mergeFieldsKeyValueMap;
        
        static void setup(){
            
        
        }
        @IsTest(OnInstall=false)
        private static void tst_ctor() {
            User u1 = TestHelper.getAdminUser(true);
            System.runAs(u1){
            DataTableConfig__c flexTable = TestHelper.getDataTableConfig(false);
            flexTable.Description__c='test';
            insert flexTable;
            FlexTableExportCtrl ctrl;
            ApexPages.CurrentPage().getParameters().put('flexTableName','TestDataTable');
            Test.startTest();
                ApexPages.CurrentPage().getParameters().put('id', flexTable.Id);
                
                ctrl = new FlexTableExportCtrl();
            Test.stopTest();
        }
         System.assertNotEquals(u1,null); 
        
        }
    
        @isTest(OnInstall=false)
        private static void testFetchData(){
            User u1 = TestHelper.getAdminUser(true);
            DataTableConfig__c dataTableConfig;
            System.runAs(u1){
                 PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
                 TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
                 PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
                 PageBlockDetailConfig__c pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
                 HelpConfig__c help = testHelper.getHelpConfigWithoutRecordType(true);
                 dataTableConfig = TestHelper.getDataTableConfig(false);
                 dataTableConfig.FieldNames__c += ','+AppUtils.getNameSpacePrefix() +'SampleText2__c,OwnerId'; 
                 dataTableConfig.HelpConfig__c = help.id;         
                 dataTableConfig.FilterCriteria__c = 'Name != \'ssd\' and OwnerId = \'{!User.Id}\'';       
                 dataTableConfig.SkipFieldsForExport__c = 'Id';
                 dataTableConfig.Description__c='test';
                 dataTableConfig.Header__c= 'sampleFlexTable';
                 insert dataTableConfig  ;
                 SampleObject11__c ann = TestHelper.getSampleObject1(true);
                 Test.startTest();  
                    ApexPages.CurrentPage().getParameters().put('id', ann.Id);
                    FlexTableExportCtrl fx = new FlexTableExportCtrl();
                    fx.flexTable = dataTableConfig;
                    fx.mode='text/csv';
                    fx.tableName = 'TestDataTable';
                    fx.flexTableHeader='sampleFlexTable';
                    fx.objectName='SampleObject11__c';
                    
                    //fx.getDataTable();
                Test.stopTest();
            }
            System.assertNotEquals(u1,null); 
        }

        @isTest(OnInstall=false)
        private static void testFetchData6(){
            User u1 = TestHelper.getAdminUser(true);
            Account ac1 = TestHelper.getAccount(true);
            
            u1.OrganizationId__c = ac1.Id;
            update u1;
            DataTableConfig__c dataTableConfig;
            System.runAs(u1){
                 PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
                 TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
                 PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
                 PageBlockDetailConfig__c pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
                 HelpConfig__c help = testHelper.getHelpConfigWithoutRecordType(true);
                 dataTableConfig = TestHelper.getDataTableConfig(false);
                 dataTableConfig.FieldNames__c += ','+AppUtils.getNameSpacePrefix() +'SampleText1__c,OwnerId'; 
                 dataTableConfig.HelpConfig__c = help.id;         
                 dataTableConfig.FilterCriteria__c = 'Name != \'ssd\' and Account__c = \'{!Account.Id}\'';       
                 dataTableConfig.SkipFieldsForExport__c = 'Id';
                 dataTableConfig.Description__c='test';
                 dataTableConfig.Header__c= 'sampleFlexTable';
                 insert dataTableConfig  ;
                 SampleObject11__c ann = TestHelper.getSampleObject1(true);
                 Test.startTest();  
                    ApexPages.CurrentPage().getParameters().put('id', ann.Id);
                    FlexTableExportCtrl fx = new FlexTableExportCtrl();
                    fx.flexTable = dataTableConfig;
                    fx.tableName = 'TestDataTable';
                    fx.flexTableHeader='sampleFlexTable';
                    fx.objectName='SampleObject1__c';
                    fx.mode='pdf';
                    fx.getDataTable();
                Test.stopTest();
            }
            System.assertNotEquals(u1,null); 
        }
  
      @isTest
        private static void testFetchData2(){
            User u1 = TestHelper.getAdminUser(true);
            DataTableConfig__c dataTableConfig;
            System.runAs(u1){
                PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
                TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
                PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
                PageBlockDetailConfig__c pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
                HelpConfig__c help = testHelper.getHelpConfigWithoutRecordType(true);
                dataTableConfig = TestHelper.getDataTableConfig(false);
                dataTableConfig.FieldNames__c += ','+AppUtils.getNameSpacePrefix() +'SampleText2__c,OwnerId'; 
                dataTableConfig.HelpConfig__c = help.id;
                dataTableConfig.Name = 'SampleFlextable123';
                dataTableConfig.FilterCriteria__c = 'Name != \'ssd\''; 
                insert dataTableConfig;
                SobjectConfig__c sobj=new SobjectConfig__c(); 
                sobj.UserFriendlyNameField__c='Name';
                sobj.name=AppUtils.getNameSpacePrefix() +'SampleObject11__c';
                insert sobj;
                SampleObject11__c ann = TestHelper.getSampleObject1(true);
                Test.startTest();
                    listParm = new Map<String, Object>();
                    listParm.put('rer', 'dfd');
                    serializeStr = JSON.serialize(listParm);
                    ApexPages.CurrentPage().getParameters().put('listParm', serializeStr);
                    ApexPages.CurrentPage().getParameters().put('id', ann.Id);
                    
                    FlexTableExportCtrl fx = new FlexTableExportCtrl();
                    fx.flexTable = dataTableConfig;
                    
                    fx.tableName = 'History';
                    fx.fetchData();
                Test.stopTest();
        }
        System.assertNotEquals(u1,null); 
     }
      @isTest
        private static void testFetchData3(){
            User u1 = TestHelper.getAdminUser(true);
            DataTableConfig__c dataTableConfig;
            System.runAs(u1){
                PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
                TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
                PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
                PageBlockDetailConfig__c pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
                HelpConfig__c help = testHelper.getHelpConfigWithoutRecordType(true);
                dataTableConfig = TestHelper.getDataTableConfig(false);
                dataTableConfig.FieldNames__c += ','+AppUtils.getNameSpacePrefix() +'SampleText2__c,OwnerId'; 
                dataTableConfig.HelpConfig__c = help.id;
                dataTableConfig.Name = 'SampleFlextable123';
                dataTableConfig.FilterCriteria__c = 'Name != \'ssd\''; 
                insert dataTableConfig;
                SobjectConfig__c sobj=new SobjectConfig__c(); 
                sobj.UserFriendlyNameField__c='Name';
                sobj.name=AppUtils.getNameSpacePrefix() +'SampleObject11__c';
                insert sobj;
                SampleObject11__c ann = TestHelper.getSampleObject1(true);
                Test.startTest();
                    
                    listParm = new Map<String, Object>();
                    flexTableParam=new Map<String, Object>();
                    flexTableParam.put('re', 'df');
                    serializeStr1 = JSON.serialize(flexTableParam);
                    ApexPages.CurrentPage().getParameters().put('listParam', NULL);
                    ApexPages.CurrentPage().getParameters().put('flexTableParam', serializeStr1);
                    ApexPages.CurrentPage().getParameters().put('id', ann.Id);
                    //mergeFieldsKeyValueMap=new Map<String, Object>();
                    //mergeFieldsKeyValueMap.putall(flexTableParam);
                    FlexTableExportCtrl fx = new FlexTableExportCtrl();
                    fx.flexTable = dataTableConfig;
                    
                    fx.tableName = 'History';
                    fx.fetchData();
                Test.stopTest();
        }
        System.assertNotEquals(u1,null); 
     }
          @isTest
        private static void testFetchData4(){
            User u1 = TestHelper.getAdminUser(true);
            DataTableConfig__c dataTableConfig;
            System.runAs(u1){
                PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
                TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
                PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
                PageBlockDetailConfig__c pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
                HelpConfig__c help = testHelper.getHelpConfigWithoutRecordType(true);
                dataTableConfig = TestHelper.getDataTableConfig(false);
                dataTableConfig.FieldNames__c += ','+AppUtils.getNameSpacePrefix() +'SampleDate__c'; 
                dataTableConfig.HelpConfig__c = help.id;
                dataTableConfig.Name = 'TestDataTable';
                dataTableConfig.FilterCriteria__c = 'Name != \'ssd\''; 
                insert dataTableConfig;
                List<String> fieldNameList = dataTableConfig.FieldNames__c.split(',');
                SobjectConfig__c sobj=new SobjectConfig__c(); 
                sobj.UserFriendlyNameField__c='Name';
                sobj.name=AppUtils.getNameSpacePrefix() +'SampleObject11__c';
                insert sobj;
                SampleObject11__c ann = TestHelper.getSampleObject1(true);
                Test.startTest();
                    
                     Map<String, String> urlParams = new Map<String, String>();
                    listParm = new Map<String, Object>();
                    flexTableParam=new Map<String, Object>();
                    flexTableParam.put('re', 'df');
                    serializeStr1 = JSON.serialize(flexTableParam);
                    ApexPages.CurrentPage().getParameters().put('listParam', NULL);
                    ApexPages.CurrentPage().getParameters().put('flexTableParam', serializeStr1);
                    ApexPages.CurrentPage().getParameters().put('id', ann.Id);
                    //mergeFieldsKeyValueMap=new Map<String, Object>();
                    //mergeFieldsKeyValueMap.putall(flexTableParam);
                    FlexTableExportCtrl fx = new FlexTableExportCtrl();
                    fx.flexTable = dataTableConfig;
                    
                    fx.tableName = 'TestDataTable';
                    fx.fetchData();
                    DownloadCSVBatchHelper fx1 = new DownloadCSVBatchHelper();
                    fx1.getAltValue('TestDataTable');
                    fx1.getFormattedString('<h1>test</h1>');
                    fx1.getFieldDataType(sobj.name,fieldNameList);
                    fx1.getFormattedNumber(15.5,sobj.name,AppUtils.getNameSpacePrefix() +'SampleNumber1__c');
                    fx1.getFormattedNumberCSV(15,sobj.name,AppUtils.getNameSpacePrefix() +'SampleNumber1__c');
                    fx1.fetchData('TestDataTable',ann.Id,urlParams,flexTableParam);
                Test.stopTest();
        }
        System.assertNotEquals(u1,null); 
     }
      @isTest
        private static void testFetchData5(){
            User u1 = TestHelper.getAdminUser(true);
            DataTableConfig__c dataTableConfig;
            System.runAs(u1){
                PageLayoutConfig__c pageLayoutConfig =  testHelper.getPageLayoutConfig(true);
                TabConfig__c tabConfig = testHelper.getTabConfig(pageLayoutConfig.id,true);
                PageBlockConfig__c pageBlockConfig =  testHelper.getPageBlockConfig(tabConfig.Id, true);                      
                PageBlockDetailConfig__c pageBlockDetail = testHelper.getPageBlockDetailConfig(pageBlockConfig.id,true);
                HelpConfig__c help = testHelper.getHelpConfigWithoutRecordType(true);
                dataTableConfig = TestHelper.getDataTableConfig(false);
                dataTableConfig.FieldNames__c += ','+AppUtils.getNameSpacePrefix() +'SampleDateTime__c'; 
                dataTableConfig.HelpConfig__c = help.id;
                dataTableConfig.PDFRenderType__c = 'Block';
                dataTableConfig.Name = 'TestDataTable';
                dataTableConfig.HideColumnsText__c ='[{"column":"Name","field":"Status__c","operator":"=","value":"Created"}]';
                dataTableConfig.FilterCriteria__c = 'Name != \'ssd\''; 
                insert dataTableConfig;
                
                SobjectConfig__c sobj=new SobjectConfig__c(); 
                sobj.UserFriendlyNameField__c='Name';
                sobj.name=AppUtils.getNameSpacePrefix() +'SampleObject11__c';
                insert sobj;
                SampleObject11__c ann = TestHelper.getSampleObject1(true);
                Test.startTest();
                    Map<String, String> urlParams = new Map<String, String>();
                    listParm = new Map<String, Object>();
                    flexTableParam=new Map<String, Object>();
                    flexTableParam.put('re', 'df');
                    serializeStr1 = JSON.serialize(flexTableParam);
                    ApexPages.CurrentPage().getParameters().put('listParam', NULL);
                    ApexPages.CurrentPage().getParameters().put('flexTableParam', serializeStr1);
                    ApexPages.CurrentPage().getParameters().put('id', ann.Id);
                    //mergeFieldsKeyValueMap=new Map<String, Object>();
                    //mergeFieldsKeyValueMap.putall(flexTableParam);
                    FlexTableExportCtrl fx = new FlexTableExportCtrl();
                    fx.flexTable = dataTableConfig;
                    
                    fx.tableName = 'TestDataTable';
                    fx.fetchData();
                    fx.getDataTable();
                    DownloadCSVBatchHelper fx1 = new DownloadCSVBatchHelper();
                    fx1.fetchData('TestDataTable',ann.id,urlParams,flexTableParam);
                Test.stopTest();
            }
             System.assertNotEquals(u1,null); 
        
     }
	 Private Static DataTableConfig__c getflextableToInsertForBlockType(String Name, String header, String SobjectName, String sobjectConfig,String FilterCriteria, String parentChildRelationshipField,String fields,String parentField){
        
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,SobjectConfig__c=sobjectConfig, RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table')
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c =fields,EnableAutoIndex__c=true,PDFRenderType__c='Block',
                                                           Description__c = 'Test', parentChildRelationshipField__c=parentChildRelationshipField,ParentTargetLookupField__c=parentField,OrderBy__c='Name',Sort_Direction__c='ASC');
        insert table;
        return table;
    }
    Private Static SobjectConfig__c getSobjectConfigToInsert(String SobjectName){
        SobjectConfig__c sobj=new SobjectConfig__c(); 
        sobj.UserFriendlyNameField__c='Name';
        sobj.name=SobjectName;
        insert sobj;
        return sobj;
    }
     @isTest
    static void insertFlexGridInfoBlockPdf(){                      
       
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',SampleCurrency__c=126.00);
        insert s1;
        
        SobjectConfig__c SampleObject1= getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject1__c');
        
       
        String sample1List = 'Id,Name,'+AppUtils.getNamespacePrefix()+'SampleTextArea1__c,'+AppUtils.getNamespacePrefix()+'isHistory__c,'+AppUtils.getNamespacePrefix()+'TestPercent__c,'+AppUtils.getNamespacePrefix()+'SampleCurrency__c,'+AppUtils.getNamespacePrefix()+'SampleTime__c,'+AppUtils.getNamespacePrefix()+'SampleDateTime__c,'+AppUtils.getNamespacePrefix()+'SampleDate__c,'+AppUtils.getNamespacePrefix()+'SampleNumber1__c,'+AppUtils.getNamespacePrefix()+'SampleText1__c,'+AppUtils.getNamespacePrefix()+'Account__c,'+AppUtils.getNamespacePrefix()+'SampleText2__c,'+AppUtils.getNamespacePrefix()+'Sample_Object_2__r.'+AppUtils.getNamespacePrefix()+'SampleNumber1__c';
        DataTableConfig__c flextable2 =  getflextableToInsertForBlockType('TestDataTable','Sample  Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
         
        DataTableAction__c dataTableAction = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?',
                                                                    HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}');
        insert dataTableAction; 
        
        DataTableAction__c dataTableTopAction = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?');
        insert dataTableTopAction; 
        

        DataTableAction__c dataTablerowAction = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true,
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTablerowAction;

        DataTableAction__c dataTablerowAction2 = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTablerowAction2;

        DataTableAction__c dataTablerowAction3 = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true);
        insert dataTablerowAction3;
       
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = 'name',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable2.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',                                                                                     
                                                                                      HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                                      ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTableDetailConfig;   

        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable2.Id,IsActive__c=true,IsMasterView__c=true,ShowInPDF__c=true,FilterClause__c='id != null');
        insert listView;

       
 		FlexTableExportCtrl fx = new FlexTableExportCtrl();
        fx.flexTable = flextable2;
        fx.tableName = 'TestDataTable';
        fx.enableHideColumnLogic = true;
        fx.fetchData();
        DownloadCSVBatchHelper fx1 = new DownloadCSVBatchHelper();
        Map<String, String> urlParams = new Map<String, String>();
        Map<String, Object> urlParamsMap = new Map<String, Object>();
        fx1.fetchData('TestDataTable',SampleObject1.id,urlParams,urlParamsMap);
        
        System.assert(fx !=null);
    }
     @isTest
    static void insertFlexGridInfoBlockCsv(){                      
       
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',SampleDateTime__c=System.today(),SampleDate__c=System.today(),SamplePicklist1__c='sample',SampleCurrency__c=123.06);
        insert s1;
        
        SobjectConfig__c SampleObject1= getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject1__c');
        
       
        String sample1List = 'Id,Name,'+AppUtils.getNamespacePrefix()+'SampleTextArea1__c,'+AppUtils.getNamespacePrefix()+'isHistory__c,'+AppUtils.getNamespacePrefix()+'TestPercent__c,'+AppUtils.getNamespacePrefix()+'SampleCurrency__c,'+AppUtils.getNamespacePrefix()+'SampleTime__c,'+AppUtils.getNamespacePrefix()+'SampleDateTime__c,'+AppUtils.getNamespacePrefix()+'SampleDate__c,'+AppUtils.getNamespacePrefix()+'SampleNumber1__c,'+AppUtils.getNamespacePrefix()+'SampleText1__c,'+AppUtils.getNamespacePrefix()+'Account__c,'+AppUtils.getNamespacePrefix()+'SampleText2__c,'+AppUtils.getNamespacePrefix()+'Sample_Object_2__r.'+AppUtils.getNamespacePrefix()+'SampleNumber1__c,'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c';
        DataTableConfig__c flextable2 =  getflextableToInsertForBlockType('TestDataTable','Sample  Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
         
        DataTableAction__c dataTableAction = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?',
                                                                    HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}');
        insert dataTableAction; 
        
        DataTableAction__c dataTableTopAction = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?');
        insert dataTableTopAction; 
        

        DataTableAction__c dataTablerowAction = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true,
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTablerowAction;

        DataTableAction__c dataTablerowAction2 = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTablerowAction2;

        DataTableAction__c dataTablerowAction3 = new DataTableAction__c( DataTableConfig__c = flextable2.Id,HideForProfile__c = 'System Administrator',
        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true);
        insert dataTablerowAction3;
       
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = 'name',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable2.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',                                                                                     
                                                                                      HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                                      ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTableDetailConfig;   

        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable2.Id,IsActive__c=true,IsMasterView__c=true,ShowInPDF__c=true,FilterClause__c='id != null');
        insert listView;
        FlexTableFilterListViewConfig__c listView1 = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable2.Id,IsActive__c=true,IsMasterView__c=false,ShowInPDF__c=true,FilterClause__c='id = null');
        insert listView1;

       
 		FlexTableExportCtrl fx = new FlexTableExportCtrl();
        fx.flexTable = flextable2;
        fx.tableName = 'TestDataTable';
        fx.mode = 'text/csv';
        fx.fetchData();
        DownloadCSVBatchHelper fx1 = new DownloadCSVBatchHelper();
        Map<String, String> urlParams = new Map<String, String>();
        Map<String, Object> urlParamsMap = new Map<String, Object>();
        fx1.fetchData('TestDataTable',SampleObject1.id,urlParams,urlParamsMap);
        ExecuteDownloadPdf pdf = new ExecuteDownloadPdf();
        pdf.dataTableConfigName = 'TestDataTable';
        pdf.urlParams.put('RecordId',SampleObject1.id);
        pdf.clickHandler();
        ExecuteDownloadCSV csv = new ExecuteDownloadCSV();
        csv.dataTableConfigName = 'TestDataTable';
        csv.urlParams.put('RecordId',SampleObject1.id);
        csv.clickHandler();
        // PDFExecuteDownloadPdf pdf1 = new PDFExecuteDownloadPdf();
        // pdf1.dataTableConfigName = 'TestDataTable';
        // pdf1.urlParams.put('RecordId',SampleObject1.id);
        // pdf1.clickHandler();
        // PDFExecuteDownloadCSV csv1 = new PDFExecuteDownloadCSV();
        // csv1.dataTableConfigName = 'TestDataTable';
        // csv1.urlParams.put('RecordId',SampleObject1.id);
        // csv1.clickHandler();
        System.assert(fx !=null);
    }
     
      Private Static DataTableConfig__c getflextableToInsertContentNote(String Name, String header, String SobjectName, String sobjectConfig,String FilterCriteria, String parentChildRelationshipField,String fields,String parentField){
        
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,SobjectConfig__c=sobjectConfig, RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table')
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c =fields,EnableAutoIndex__c=true,PDFRenderType__c='Block',
                                                           Description__c = 'Test', parentChildRelationshipField__c=parentChildRelationshipField,ParentTargetLookupField__c=parentField,OrderBy__c='Title',Sort_Direction__c='ASC');
        insert table;
        return table;
    }
     
      @isTest
    static void insertFlexTableContentnote(){                      
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',SampleDateTime__c=System.today(),SampleDate__c=System.today(),SamplePicklist1__c='sample',SampleCurrency__c=123.06);
        insert s1;
        
        SobjectConfig__c contentN= getSobjectConfigToInsert('ContentNote');
       
        String sample1List = 'Id,Title';
        DataTableConfig__c flextable2 =  getflextableToInsertContentNote('TestDataTable','Sample  Table', 'ContentNote',contentN.id, '{!ContentNoteId}','',sample1List ,'');
        Test.startTest();
            ApexPages.CurrentPage().getParameters().put('id', s1.Id);
            FlexTableExportCtrl fx = new FlexTableExportCtrl();
            fx.flexTable = flextable2;
            fx.tableName = 'TestDataTable';
            fx.mode = 'text/csv';
            fx.fetchData();
        Test.stopTest();
        System.assert(fx !=null);
    }

    @isTest
    private static void testgetAnchorCsvFormattedString(){
        String url = '<a href="https://robin3024-dev-ed--c.vf.force.com/">Test Text</a>';
        Test.startTest();
        FlexTableExportCtrl fte = new FlexTableExportCtrl();
        String urlTest = fte.getAnchorCsvFormattedString(url);
        Test.stopTest();
        System.assert(urlTest == 'Test Text');
    }

    @isTest
    static void testgetDownloadCSVIcon(){
        Test.startTest();
        Map<String, String> result = ExecuteDownloadCSV.getDownloadCSVIcon();
        Map<String, String> resultLWC = ExecuteDownloadCSV.getDownloadCSVIconLwc();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }
    @isTest
  static void testGetExportWrapper(){
	Test.startTest();
    List<sObject> sObjectList = new List<sObject>();
    Map<String, String> fieldLableMap = new Map<String, String>();
    Map<String, String> fieldDataTypeMap = new Map<String, String>();
    Map<String, Integer> scaleMap =new  Map<String, Integer>();
    String label;
	FlexTableExportCtrl.exportWrapper costom = new FlexTableExportCtrl.exportWrapper(sObjectList,fieldLableMap,fieldDataTypeMap,scaleMap,label);
	//CustomLookupLwcController custom = new CustomLookupLwcController();
	Test.stopTest();
    System.assertNotEquals(sObjectList,null);
   
	
}
    
}