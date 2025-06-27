//For InitParams inner class 
@isTest
private class TestFlexGridEnhancedUtility{
   static Map<string,Object> result;
   static void DataForInitParams() {  
    
    //creating JSON object
    JSONGenerator generator = JSON.createGenerator(true);   
    generator.writeStartObject(); 
    generator.writeStringField('Name', 'test122');
    generator.writeStringField('type', 'FlexGrid Enhanced');              
    generator.writeNumberField('level',2);  
    generator.writeStringField('parentRecordId', 'a142M000004gyAF');
    generator.writeEndObject();                 
    String jsonString = generator.getAsString();     
   
    FlexGridEnhancedUtility.InitParams page = new FlexGridEnhancedUtility.InitParams(jsonString);      
}

   @isTest
    static void testInitParams(){
        user u = TestHelper.getAdminUser(false);
        system.runAs(u){
            test.StartTest();
                DataForInitParams();                
            test.StopTest();
        }
        System.assertEquals(result,null);
    } 

  
  static void DataForRecordParamsAndLookupData() {  
  SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
  Database.SaveResult SampleObject2 = Database.insert(s2, false);
    
    List<String> queryFieldsList1= new List<String>();
    queryFieldsList1.add('Aaaa');
    queryFieldsList1.add('Aaaa');
    queryFieldsList1.add('Aaaa');
    queryFieldsList1.add('Aaaa');
    queryFieldsList1.add('Aaaa');

    //creating JSON object
    JSONGenerator generator = JSON.createGenerator(true);  
    generator.writeStartObject(); 
    //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
    generator.writeObjectField('queryFieldsList', queryFieldsList1);
    generator.writeStringField('sObjectName', 'SampleObject2');
    generator.writeStringField('filterCriteria', 'SampleObject2!=null');
    generator.writeStringField('sortableColumn', 'Name');
    generator.writeStringField('sortDirection', 'ASC');            
    generator.writeNumberField('pageNo',2); 
    generator.writeNumberField('pageSize',11);  
    generator.writeNumberField('limitValue',2);    
    generator.writeStringField('enhancedSearchText', 'Test'); 
    generator.writeStringField('parentRecordId', 'a142M000004gyAF');
    generator.writeEndObject();                
    String jsonString = generator.getAsString();     
   
    FlexGridEnhancedUtility.RecordParams page = new FlexGridEnhancedUtility.RecordParams(jsonString);   
    FlexGridEnhancedUtility.LookupData page1 = new FlexGridEnhancedUtility.LookupData(s2.Id,'SampleObject2');      
}

   @isTest
    static void testRecordParamsAndLookupData(){
        user u = TestHelper.getAdminUser(false);
        system.runAs(u){
            test.StartTest();
                DataForRecordParamsAndLookupData();                
            test.StopTest();
        }
        System.assertEquals(result,null);
    } 
  
  // For FlexTableConfig() data
  static void DataForFlexTableConfig() {  
    
     DataTableConfig__c dataTableConfig =TestHelper.getDataTableConfig(true);
     
     FlexGridEnhancedUtility.FlexTableConfig page = new FlexGridEnhancedUtility.FlexTableConfig(dataTableConfig,false); 
     FlexGridEnhancedUtility.FlexTableConfig page1 = new FlexGridEnhancedUtility.FlexTableConfig(); 

  }

     @isTest
      static void testFlexTableConfig(){
          user u = TestHelper.getAdminUser(false);
          system.runAs(u){
              test.StartTest();
                  DataForFlexTableConfig();                
              test.StopTest();
          }
          System.assertEquals(result,null);
      } 
//For FlexTableActionConfig()
//static void DataForFlexTableActionConfig() {  
    
//    DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
//    dataTableConfig.Name = 'TestDataTable1';
//    dataTableConfig.SObject__c = AppUtils.getNameSpacePrefix()+'SampleObject11__c';
//    dataTableConfig.FieldNames__c = 'Id, Name';       
//    dataTableConfig.OrderBy__c = 'Name'; 
//    dataTableConfig.description__c='testDescription';
//    dataTableConfig.RecordTypeId = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Data Table').getRecordTypeId();
//    insert dataTableConfig;

//    DataTableAction__c dataTableAction = new DataTableAction__c(); 
//    dataTableAction.Name = 'Test Action';   
//    dataTableAction.Sequence__c = 1;  
//    dataTableAction.RecordTypeId = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
//    dataTableAction.ActionURL__c = '/test/URL?istest={!istest}'; 
//    dataTableAction.DataTableConfig__c = dataTableConfig.Id;  
//    insert dataTableAction;

//    FlexGridEnhancedUtility.FlexTableActionConfig page = new FlexGridEnhancedUtility.FlexTableActionConfig(dataTableAction); 
//    FlexGridEnhancedUtility.FlexTableActionConfig page1 = new FlexGridEnhancedUtility.FlexTableActionConfig(); 
//    page1.FlexTableActionToObject(page);
//}

//     @isTest
//      static void testFlexTableActionConfig(){
//          user u = TestHelper.getAdminUser(false);
//          system.runAs(u){
//              test.StartTest();
//                  DataForFlexTableActionConfig();                
//              test.StopTest();
//          }
//          System.assertEquals(result,null);
//      } 
      
//For DataForDataTableDetailInfo() method
  static void DataForDataTableDetailInfo() {  
    
     DataTableConfig__c config =TestHelper.getDataTableConfig(true);
     DataTableDetailConfig__c datadataDetailConfig = new DataTableDetailConfig__c(FlexTableConfig__c=config.Id, FieldAPIName__c='OldValue', 
                                        FieldLabelOverride__c='test', FieldWidth__c=23.0);
      insert datadataDetailConfig;
     
     FlexGridEnhancedUtility.DataTableDetailInfo page = new FlexGridEnhancedUtility.DataTableDetailInfo(datadataDetailConfig); 
}

     @isTest
      static void testDataTableDetailInfo(){
          user u = TestHelper.getAdminUser(false);
          system.runAs(u){
              test.StartTest();
                  DataForDataTableDetailInfo();                
              test.StopTest();
          }
          System.assertEquals(result,null);
      } 

//For DataForFlexTableListFilterListView()
      static void DataForFlexTableListFilterListView() {  
        DataTableConfig__c config =TestHelper.getDataTableConfig(true);
        FlexTableFilterListViewConfig__c flexTableFilterListViewConfig=TestHelper.getFlexTableFilterListView(config.id,true);
         
        FlexGridEnhancedUtility.FlexTableListFilterListView page = new FlexGridEnhancedUtility.FlexTableListFilterListView(flexTableFilterListViewConfig);        
      }

       @isTest
        static void testFlexTableListFilterListView(){
            user u = TestHelper.getAdminUser(false);
            system.runAs(u){
                test.StartTest();
                    DataForFlexTableListFilterListView();                
                test.StopTest();
            }
            System.assertEquals(result,null);
        } 
//DataForFlexGridConfigMetaData()
  static void DataForFlexGridConfigMetaData() {  
    
     FlexGridConfig__c config =TestHelper.getFlexGridConfig(true);
     FlexGridEnhancedUtility.FlexGridConfigMetaData page = new FlexGridEnhancedUtility.FlexGridConfigMetaData(config); 
}

     @isTest
      static void testFlexGridConfigMetaData(){
          user u = TestHelper.getAdminUser(false);
          system.runAs(u){
              test.StartTest();
                  DataForFlexGridConfigMetaData();                
              test.StopTest();
          }
          System.assertEquals(result,null);
      } 

    static void DataForFlexTableConfigDataAndFieldDescribe() {  
        Schema.DescribeFieldResult fieldDescribe = Account.Description.getDescribe();
         //flex table action config
        DataTableConfig__c dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable';
        dataTableConfig.SObject__c = AppUtils.getNameSpacePrefix()+'SampleObject11__c';
        dataTableConfig.FieldNames__c = 'Id, Name';       
        dataTableConfig.OrderBy__c = 'Name'; 
        dataTableConfig.description__c='testDescription';
        dataTableConfig.RecordTypeId = Schema.SObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Data Table').getRecordTypeId();
        insert dataTableConfig;

        DataTableAction__c dataTableAction = new DataTableAction__c(); 
        dataTableAction.Name = 'Test Action';   
        dataTableAction.Sequence__c = 1;  
        dataTableAction.RecordTypeId = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
        dataTableAction.ActionURL__c = '/test/URL?istest={!istest}'; 
        dataTableAction.DataTableConfig__c = dataTableConfig.Id;  
        insert dataTableAction;

        DataTableAction__c dataTableAction1 = new DataTableAction__c(); 
        dataTableAction1.Name = 'Test Action';   
        dataTableAction1.Sequence__c = 1;  
        dataTableAction1.RecordTypeId = Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
        dataTableAction1.ActionURL__c = '/test/URL?istest={!istest}'; 
        dataTableAction1.DataTableConfig__c = dataTableConfig.Id;  
        dataTableAction1.SobjectActionConfig__c =  TestHelper.getSObjectActionConfig(true).id;
        insert dataTableAction1;
        // DataTableAction__c dataTableAction =TestHelper.getDataTableAction(dataTableConfig.id,true); 
        FlexGridEnhancedUtility.FlexTableActionConfig flextableAction = new FlexGridEnhancedUtility.FlexTableActionConfig();  
        FlexGridEnhancedUtility.FlexTableActionConfig page = new FlexGridEnhancedUtility.FlexTableActionConfig(dataTableAction); 
        FlexGridEnhancedUtility.FlexTableActionConfig page2 = new FlexGridEnhancedUtility.FlexTableActionConfig(dataTableAction1);
         DataTableAction__c dataTableAction3 = page.FlexTableActionToObject(page);
         //flex table list view config
         FlexTableFilterListViewConfig__c flexTableFilterListViewConfig=TestHelper.getFlexTableFilterListView(dataTableConfig.id,true);
         FlexGridEnhancedUtility.FlexTableListFilterListView page1 = new FlexGridEnhancedUtility.FlexTableListFilterListView(flexTableFilterListViewConfig);        

         List<FlexGridEnhancedUtility.FlexTableListFilterListView> lst=new List<FlexGridEnhancedUtility.FlexTableListFilterListView>();
         List<FlexGridEnhancedUtility.FlexTableActionConfig> lst1=new List<FlexGridEnhancedUtility.FlexTableActionConfig>();
        
         Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>> param=new Map<String,List<FlexGridEnhancedUtility.FlexTableActionConfig>>();

         FlexGridEnhancedUtility.FlexTableConfigData pg = new FlexGridEnhancedUtility.FlexTableConfigData(param);        
         FlexGridEnhancedUtility.FlexTableConfigData pg1 = new FlexGridEnhancedUtility.FlexTableConfigData(lst);        
         FlexGridEnhancedUtility.FlexTableConfigData pg2 = new FlexGridEnhancedUtility.FlexTableConfigData();  
         FlexGridEnhancedUtility.FieldDescribe pg3 = new FlexGridEnhancedUtility.FieldDescribe(fieldDescribe);  
         FlexGridEnhancedUtility.FieldDescribe pg4 = new FlexGridEnhancedUtility.FieldDescribe(); 
           
      }

       @isTest
        static void testFlexTableConfigDataAndFieldDescribe(){
            user u = TestHelper.getAdminUser(false);
            system.runAs(u){
                test.StartTest();
                    DataForFlexTableConfigDataAndFieldDescribe();                
                test.StopTest();
            }
            System.assertEquals(result,null);
        } 
      
}