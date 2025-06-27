/**
* @Class Name: TestRecentlyViewedCtrl
* @Description: This class is test class for SendEmailCompCtrl
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |	19/03/2019  | Framework Team                      | Initail
* ====================================================================================================================
**/@isTest
private class TestFlexGridEnhancedCtrl {
    static String userDateTimeFormat;
    static String userDateFormat;
    static String userTimeFormat;
    static String currencySymbol;
    static String getmessageType;
    static Integer getmessageTimeOut;
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: getflextableToInsert
* @Description: This method is used to create Flex Table records
* @Param: type=Integer // number of records to be created
* @Return: List of created DataTableConfig__c table.
* @Date: 19/03/2019
**/ 
	 Private Static DataTableConfig__c getflextableToInsert(String Name, String header, String SobjectName, String sobjectConfig,String FilterCriteria, String parentChildRelationshipField,String fields,String parentField){
        HelpConfig__c heplConfig = new HelpConfig__c(DocumentName__c ='test',Header__c ='test',HelpContent__c ='test',HelpText__c ='test',RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.HelpConfig__c, 'Internal Document'));
        insert heplConfig;
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,SobjectConfig__c=sobjectConfig,	RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table'),HelpConfig__c = heplConfig.id
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c =fields,EnableAutoIndex__c=true,
                                                           Description__c = 'Test', parentChildRelationshipField__c=parentChildRelationshipField,ParentTargetLookupField__c=parentField,OrderBy__c='Name',Sort_Direction__c='ASC');
        insert table;
        return table;
    }
    Private Static DataTableConfig__c getflextableToInsert(String Name, String header, String SobjectName, String sobjectConfig,String FilterCriteria, String parentChildRelationshipField){
        HelpConfig__c heplConfig = new HelpConfig__c(DocumentName__c ='test',Header__c ='test',HelpContent__c ='test',HelpText__c ='test',RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.HelpConfig__c, 'Internal Document'));
        insert heplConfig;
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,SobjectConfig__c=sobjectConfig,	RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table'),HelpConfig__c = heplConfig.id
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c = 'Id,Name,'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c,'+AppUtils.getNamespacePrefix()+'Currency1__c,'+AppUtils.getNamespacePrefix()+'SampleDate__c,'+AppUtils.getNamespacePrefix()+'PhoneNo__c,'+AppUtils.getNamespacePrefix()+'SampleObject1__c,'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c,'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c,CreatedBy.Name,LastModifiedById.Name',
                                                           Description__c = 'Test', parentChildRelationshipField__c=parentChildRelationshipField,OrderBy__c='Name',Sort_Direction__c='ASC');
        insert table;
        return table;
    }

    Private Static DataTableConfig__c getflextableToInsertForFile(String Name, String header, String SobjectName,String FilterCriteria){
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,	RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table')
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c = 'Id', Description__c = 'Test',Sort_Direction__c='DESC');
        
        insert table;
        return table;
    }

    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: getSobjectConfigToInsert
* @Description: This method is used to create Sobject Config records
* @Param: type=String // name of the sobject
* @Return: List of created SobjectConfig__c .
* @Date: 19/03/2019
**/ 
    Private Static SobjectConfig__c getSobjectConfigToInsert(String SobjectName){
        SobjectConfig__c sobj=new SobjectConfig__c(); 
        sobj.UserFriendlyNameField__c='Name';
        sobj.name=SobjectName;
        insert sobj;
        return sobj;
    }

    Private Static ContentVersion getFileSobjectConfigToInsert(String SobjectName){
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = 'testing.txt'; 
        conVer.Title = 'Testing Files';   
        conVer.VersionData = EncodingUtil.base64Decode('test');       
        insert conVer;
        return conVer;
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataForPositiveGetFlexGridInfo
* @Description: This method is used to fetch flex grid data
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/  
    @isTest
    static void dataForPositiveGetFlexGridInfo(){      
        
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SamObj2 = Database.insert(s2, false);
        
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',Sample_Object_2__c = s2.id);
        insert s1;
        
        SampleObject12__c s12 = new SampleObject12__c(Name='test',SampleObject1__c= s1.id, SampleText1__c ='test', Currency1__c=233, Currency2__c=34343, SampleNumber1__c=12);
        insert s12 ;        
          
        
        SobjectConfig__c SampleObject1=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject1__c');
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        SobjectConfig__c SampleObject12=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject12__c');
        String sample2List = 'Id,Name';
        String sample1List = 'Id,Name,LastModifiedById,'+AppUtils.getNamespacePrefix()+'SampleTextArea1__c,'+AppUtils.getNamespacePrefix()+'isHistory__c,'+AppUtils.getNamespacePrefix()+'TestPercent__c,'+AppUtils.getNamespacePrefix()+'SampleCurrency__c,'+AppUtils.getNamespacePrefix()+'SampleTime__c,'+AppUtils.getNamespacePrefix()+'SampleDateTime__c,'+AppUtils.getNamespacePrefix()+'SampleDate__c,'+AppUtils.getNamespacePrefix()+'SampleNumber1__c,'+AppUtils.getNamespacePrefix()+'SampleText1__c,'+AppUtils.getNamespacePrefix()+'Account__c,'+AppUtils.getNamespacePrefix()+'SampleText2__c,'+AppUtils.getNamespacePrefix()+'Sample_Object_2__r.'+AppUtils.getNamespacePrefix()+'SampleNumber1__c';
        String sample12List ='Name,'+AppUtils.getNamespacePrefix()+'SampleText1__c,'+AppUtils.getNamespacePrefix()+'SampleTextArea1__c,'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c,'+AppUtils.getNamespacePrefix()+'SampleNumber1__c,LastModifiedDate';
        DataTableConfig__c flextable1 = getflextableToInsert('parentTable','Sample N2G Parent Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'id !=Null',null,sample2List,null);
        DataTableConfig__c flextable2 =  getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
        DataTableConfig__c flextable3 =getflextableToInsert('N2GChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
        DataTableConfig__c flextable4 =getflextableToInsert('N2GGrandChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject12__c', SampleObject12.id,'id !=Null','SampleObject1__c',sample12List,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        DataTableConfig__c flextable5 =getflextableToInsert('N2GGrandChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject12__c', SampleObject12.id,'id !=Null','SampleObject1__c',sample12List,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        
        FlexGridConfig__c flexGrid = new FlexGridConfig__c(Name = 'SampleN2GGridForSearch',
                                                           ParentFlexTable__c = flextable1.Id,Child1FlexTable__c = flextable2.Id,Child2FlexTable__c = flextable3.Id,
                                                           GrandChild1FlexTable__c = flextable4.Id,GrandChild2FlexTable__c = flextable5.Id);        
        insert flexGrid;   
        
        DataTableAction__c dataTableAction = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?',
                                                                    HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}');
        insert dataTableAction; 
        
        DataTableAction__c dataTableTopAction = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?');
        insert dataTableTopAction; 
        

        DataTableAction__c dataTablerowAction = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true,
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTablerowAction;

        DataTableAction__c dataTablerowAction2 = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTablerowAction2;

        DataTableAction__c dataTablerowAction3 = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true);
        insert dataTablerowAction3;
       
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = 'name',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',
                                                                                      FlexTableConfig__c = flextable1.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',
                                                                                      HideCellJSON__c = '{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"500","Values":[]}}],"Groups":[]"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}',
                                                                                      HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                                      ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTableDetailConfig;   

        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable1.Id,IsActive__c=true,IsMasterView__c=true,FilterClause__c='id != null');
        insert listView;
        FlexTableFilterListViewConfig__c listView1 = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable1.Id,IsActive__c=true,IsMasterView__c=true,FilterClause__c='id = {!appName}');
        insert listView1;

        JSONGenerator generator = JSON.createGenerator(true);   
        generator.writeStartObject(); 
        generator.writeStringField('Name', 'SampleN2GGridForSearch');
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('flexGridType', 'FlexGrid');    
        generator.writeStringField('parentRecordId',s1.id);             
        generator.writeNumberField('level',3);  
        generator.writeEndObject();                 
        String jsonString = generator.getAsString();                      
        FlexGridEnhancedCtrl flexGridEnhanced = new FlexGridEnhancedCtrl();   
        Integer intTimeOffset = flexGridEnhanced.timeOffset;
        
        test.StartTest();
        Map<string, Object> enhancedFlexGridInfo = FlexGridEnhancedCtrl.getFlexGridInfo(jsonString);
        Boolean isLightning =  FlexGridEnhancedCtrl.getInstance(); 
        Map<String,String> IconCssMap = AppUtils.getActionIcon();     
        test.StopTest();
        system.assert(enhancedFlexGridInfo!=null);
        
    }
    
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataForNegativeGetFlexGridInfo
* @Description: This method is used to fetch flex grid data
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/  
    @isTest
    static void dataForNegativeGetFlexGridInfo(){      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343, SampleNumber1__c=12);
        insert s2 ;
        
        SampleObject11__c s1=TestHelper.getSampleObject1(false);
        s1.Sample_Object_2__c = s2.id;
        s1.SampleNumber1__c=12;
        insert s1;    
        
        SobjectConfig__c SampleObject1=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject1__c');
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        
        DataTableConfig__c flextable1 =getflextableToInsert('N2GParent','Sample N2G Parent Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'RecordType.Name !=Null',null);
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        DataTableConfig__c flextable3 =getflextableToInsert('N2GChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null','SampleObject11__c');
        DataTableConfig__c flextable4 =getflextableToInsert('N2GGrandChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c', SampleObject1.id,'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null','SampleObject11__c');
        DataTableConfig__c flextable5 =getflextableToInsert('N2GGrandChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c', SampleObject1.id,'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null','SampleObject11__c');
        
        FlexGridConfig__c flexGrid = new FlexGridConfig__c(Name = 'SampleN2GGridForSearch',
                                                           ParentFlexTable__c = flextable1.Id,Child1FlexTable__c = flextable2.Id,Child2FlexTable__c = flextable3.Id,
                                                           GrandChild1FlexTable__c = flextable4.Id,GrandChild2FlexTable__c = flextable5.Id);        
        insert flexGrid;    
        
        DataTableAction__c dataTableAction = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?');
        insert dataTableAction;    
        
        
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = 'name',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',
                                                                                      FlexTableConfig__c = flextable1.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',
                                                                                      HideCellJSON__c = '{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"500","Values":[]}}],"Groups":[]"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}',
                                                                                      HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                                      ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTableDetailConfig;   
        
        JSONGenerator generator = JSON.createGenerator(true);   
        generator.writeStartObject(); 
        generator.writeStringField('Name', 'SampleN2GGridForSearch');
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('flexGridType', 'FlexGrid');              
        generator.writeNumberField('level',3);  
        generator.writeEndObject();                 
        String jsonString = generator.getAsString();                      
        FlexGridEnhancedCtrl flexGridEnhanced = new FlexGridEnhancedCtrl();   
        Integer intTimeOffset = flexGridEnhanced.timeOffset;
        test.StartTest();
        Map<string, Object> enhancedFlexGridInfo = FlexGridEnhancedCtrl.getFlexGridInfo(jsonString);       
        test.StopTest();
        system.assert(enhancedFlexGridInfo!=null);
        system.assert(enhancedFlexGridInfo.get('Success')==false);
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataGetPageRecords
* @Description: This method is used to get data from  getPageRecords()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void dataGetPageRecords() {      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        queryFieldsList1.add('LastModifiedById');
        queryFieldsList1.add(''+AppUtils.getNamespacePrefix()+'SampleTextArea1__c');
        queryFieldsList1.add('Account__c');
        queryFieldsList1.add('user__c');
        queryFieldsList1.add('Sample_Object_2__r.Name');
          
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeObjectField('queryFieldsList', queryFieldsList1);
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('filterCriteria', 'id!=null');
        generator.writeStringField('sortableColumn', 'Name');
        generator.writeStringField('sortDirection', '');            
        generator.writeNumberField('pageNo',2); 
        generator.writeNumberField('pageSize',2);  
        generator.writeNumberField('limitValue',2);  
        generator.writeEndObject();      
        String jsonString = generator.getAsString();
        test.StartTest();
        List<sobject> enhancedFlexGridPageRecords = FlexGridEnhancedCtrl.getPageRecords(jsonString);   
        test.StopTest();
        system.assert(enhancedFlexGridPageRecords!=null);
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataNegativeGetPageRecords
* @Description: This method is used to get data from  getPageRecords()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void dataNegativeGetPageRecords() {      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        queryFieldsList1.add('xyz');
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeObjectField('queryFieldsList', queryFieldsList1);
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');  
        generator.writeEndObject();      
        String jsonString = generator.getAsString();
        test.StartTest();
        List<sobject> enhancedFlexGridPageRecords = FlexGridEnhancedCtrl.getPageRecords(jsonString);   
        test.StopTest();
        system.assert(enhancedFlexGridPageRecords!=null);
        
    }
    
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: datagetPageRecordsMap
* @Description: This method is used to get data from  getPageRecordsMap()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void datagetPageRecordsMap() {      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeObjectField('queryFieldsList', queryFieldsList1);
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('filterCriteria', 'id!=null');
        generator.writeStringField('sortableColumn', 'Name');
        generator.writeStringField('sortDirection', '');            
        generator.writeNumberField('pageNo',2); 
        generator.writeNumberField('pageSize',2);  
        generator.writeNumberField('limitValue',2);   
        generator.writeEndObject();      
        String jsonString = generator.getAsString();
        test.StartTest();
        Map<String, Object> enhancedFlexGridPageRecords = FlexGridEnhancedCtrl.getPageRecordsMap(jsonString);   
        test.StopTest();
        system.assert(enhancedFlexGridPageRecords!=null);
        //system.assert(enhancedFlexGridPageRecords.get('Success')!=false);
        
    }

    @isTest
    static void datagetPageRecordsMapForSerchTable() {      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeObjectField('queryFieldsList', queryFieldsList1);
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('filterCriteria', 'id!=null');
        generator.writeStringField('sortableColumn', 'Name');
        generator.writeStringField('sortDirection', '');            
        generator.writeStringField('enhancedSearchText', 'test'); 
        generator.writeEndObject();      
        String jsonString = generator.getAsString();
        test.StartTest();
        Map<String, Object> enhancedFlexGridPageRecords = FlexGridEnhancedCtrl.getPageRecordsMap(jsonString);   
        test.StopTest();
        system.assert(enhancedFlexGridPageRecords!=null);
        //system.assert(enhancedFlexGridPageRecords.get('Success')!=false);
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataNegativegetPageRecordsMap
* @Description: This method is used to get data from  getPageRecordsMap()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void dataNegativegetPageRecordsMap() {      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        queryFieldsList1.add('xyz');
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeObjectField('queryFieldsList', queryFieldsList1);
        generator.writeStringField('sObjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeEndObject();      
        String jsonString = generator.getAsString();
        test.StartTest();
        Map<String, Object> enhancedFlexGridPageRecords = FlexGridEnhancedCtrl.getPageRecordsMap(jsonString);   
        test.StopTest();
        system.assert(enhancedFlexGridPageRecords!=null);
        system.assert(enhancedFlexGridPageRecords.get('Success')!=true);
        
    }
    
    
    @isTest
    static void dataContentNote() {      
        
        ContentNote s2 = new ContentNote(Title='test', Content=blob.valueOf('Test'));
        insert s2;
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        queryFieldsList1.add('xyz');
        
        //creating JSON object
        String sobj='ContentNote';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeObjectField('queryFieldsList', queryFieldsList1);
        generator.writeStringField('sObjectName','ContentNote');
        generator.writeEndObject();      
        String jsonString = generator.getAsString();
        test.StartTest();
        Map<String, Object> enhancedFlexGridPageRecords = FlexGridEnhancedCtrl.getPageRecordsMap(jsonString);   
        test.StopTest();
        system.assert(enhancedFlexGridPageRecords!=null);
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: datafetchLookupRecords
* @Description: This method is used to fetch LookUp Data()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void datafetchLookupRecords() {      
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test');
        insert s1;
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleObject1__c=s1.id,SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SampleObject2 = Database.insert(s2, false);
        String sobjName  = AppUtils.getNamespacePrefix() + 'SampleObject2_c';
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject2__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
      
        generator.writeStringField('refField',AppUtils.getNamespacePrefix() +'SampleText1__c');
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('searchTerm','t'); 
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.fetchLookUpData(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
        system.assert(retMap.get('Success')!=false);
        
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataNegativefetchLookupRecords
* @Description: This method is used to fetch LookUp Data()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void dataNegativefetchLookupRecords() {      
        
        SampleObject12__c s2 = new SampleObject12__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SampleObject2 = Database.insert(s2, false);
        String sobjName  = AppUtils.getNamespacePrefix() + 'SampleObject12__c';
        
        
        //creating JSON object
        String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeStringField('fieldName',AppUtils.getNamespacePrefix() +'SampleObject2__r.'+AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'xyz');
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.fetchLookUpData(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
        system.assert(retMap.get('Success')!=true);
        
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: datagetFlexTableInfo
* @Description: This method is used to get FlexTable Info()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void datagetFlexTableInfo() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
       
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c(EnableTotal__c = false,
        EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = 'name',
        FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',
        FlexTableConfig__c = flextable2.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',
        HideCellJSON__c = '{"LogicalOperator":"OR","Conditions":[{"LOperand":{"Type":"Field","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"500","Values":[]}}],"Groups":[]"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
        HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}',
        ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"}');
        insert dataTableDetailConfig;   
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        generator.writeStringField('fieldName',AppUtils.getNamespacePrefix() +'SampleObject2__r.'+AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('displayField',AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('searchTerm','test'); 
        generator.writeStringField('flexGridType', 'FlexTable');              
        generator.writeStringField('filterClause','id!=null'); 
        generator.writeStringField('keyValueMapString','test');  
        generator.writeStringField('flexGridName','N2GChild1'); 
        generator.writeStringField('Name','N2GChild1'); 
        generator.writeStringField('parentRecordId','a142M000007Nmp9');   
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.getFlexTableInfo(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
        
        
        
    }

    @isTest
    static void negativedatagetFlexTableInfo() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        generator.writeStringField('fieldName',AppUtils.getNamespacePrefix() +'SampleObject2__r.'+AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('displayField',AppUtils.getNamespacePrefix() +'Status__c');      
        generator.writeStringField('flexGridType', 'FlexTable');              
        generator.writeStringField('filterClause','parentId'); 
        generator.writeStringField('keyValueMapString','test');  
        generator.writeStringField('flexGridName','N2GChild1'); 
        generator.writeStringField('Name','N2GChild1');  
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.getFlexTableInfo(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
        //system.assert(retMap.get('Success')!=false);
        
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: dataNegativegetFlexTableInfo
* @Description: This method is used to get FlexTable Info()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
*
    @isTest
    static void dataNegativegetFlexTableInfo() {      
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        generator.writeStringField('fieldName',AppUtils.getNamespacePrefix() +'SampleObject2__r.'+AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('displayField',AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'xyz');
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.getFlexTableInfo(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
        system.assert(retMap.get('Success')!=false);
        
        
    }*/

    @isTest
    static void datagetFileFlexTableInfo() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Title');
        
        
        ContentVersion SampleObject2=getFileSobjectConfigToInsert('ContentVersion');
        DataTableConfig__c flextable2 =getflextableToInsertForFile('EnhancedFile','EnhancedFile', 'ContentVersion', 'parentId = {!ContentDocLinkId}');
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject();         
        generator.writeStringField('sobjectName','ContentVersion');       
        generator.writeStringField('flexGridType', 'FlexTable');              
        generator.writeStringField('filterClause','parentId = {!ContentDocLinkId}');         
        generator.writeStringField('flexGridName','EnhancedFile'); 
        generator.writeStringField('Name','EnhancedFile'); 
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.getFlexTableInfo(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
              
        
    }

   
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testExecuteClass
* @Description: This method is used to test ExecuteClass()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void testExecuteClass(){
        test.StartTest();
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
      
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        generator.writeStringField('actionClass','TestFlexGridEnhancedUtility');
        generator.writeStringField('displayField',AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'SampleObject2__c');
        generator.writeStringField('searchTerm','test'); 
        generator.writeStringField('tableName','N2GChild1');            
        generator.writeStringField('filterClause','id!=null'); 
        generator.writeStringField('url','https://product-internal-dev-ed--c.na72.visual.force.com/apex/TmpEnhancedGridView?id=a191H000007JIHQ');  
        generator.writeStringField('query','Select name from sampleObject2');  
        generator.writeStringField('selectedRecordId',SampleObject2.id); 
        Map<String, Object> actionConfigMap = new Map<String, Object>();
        actionConfigMap.put('ActionBehavior','ExecuteClass'); 
        actionConfigMap.put('ActionClass','TestFlexGridEnhancedUtility');
        actionConfigMap.put('DataTableConfig',flextable2);
        actionConfigMap.put('Name','Execute Class');  
        actionConfigMap.put('SkipRollbackLogic',false);
        generator.writeObjectField('action',actionConfigMap); 
        Map<String, Object> recordSelectionConfigMap = new Map<String, Object>();
        recordSelectionConfigMap.put('selectedRecordId',SampleObject2.id);
        generator.writeObjectField('recordSelectionMap',recordSelectionConfigMap);
        generator.writeStringField('keyValueMapString','test'); 
        generator.writeEndObject();   
        String jsonString = generator.getAsString();     
          
               
        Map<String,Object> retMap=FlexGridEnhancedCtrl.executeClass(jsonString);        
        test.StopTest();
        System.assert(retMap!=null);
        system.assert(retMap.get('Success')!=true);
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testNegativeExecuteClass
* @Description: This method is used to test ExecuteClass()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void testNegativeExecuteClass(){
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
        test.StartTest();
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        generator.writeStringField('actionClass',AppUtils.getNamespacePrefix() +'SampleObject2__r.'+AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('displayField',AppUtils.getNamespacePrefix() +'Status__c');
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'SampleObject2__c');
        generator.writeStringField('searchTerm','test'); 
        generator.writeStringField('tableName','N2GChild1');            
        generator.writeStringField('filterClause','id!=null'); 
        generator.writeStringField('url','https://product-internal-dev-ed--c.na72.visual.force.com/apex/TmpEnhancedGridView?id=a191H000007JIHQ');  
        generator.writeStringField('query','Select name from sampleObject2');  
        generator.writeStringField('selectedRecordId',SampleObject2.id); 
        Map<String, Object> actionConfigMap = new Map<String, Object>();
        actionConfigMap.put('ActionBehavior','ExecuteClass'); 
        actionConfigMap.put('ActionClass','TestFlexGridEnhancedUtility');
        actionConfigMap.put('DataTableConfig',flextable2);
        actionConfigMap.put('Name','Execute Class');  
        actionConfigMap.put('SkipRollbackLogic',false);
        generator.writeObjectField('action',actionConfigMap); 
        Map<String, Object> recordSelectionConfigMap = new Map<String, Object>();
        recordSelectionConfigMap.put('selectedRecordId',SampleObject2.id);
        generator.writeObjectField('recordSelectionMap',recordSelectionConfigMap);
        generator.writeStringField('keyValueMapString','test'); 
        generator.writeEndObject();   
        String jsonString = generator.getAsString();     
        
        Map<String,Object> retMap=FlexGridEnhancedCtrl.executeClass(jsonString);        
        test.StopTest();
        System.assert(retMap!=null);
        system.assert(retMap.get('Success')!=true);
    }
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testfetchMiniLayout
* @Description: This method is used to test fetchMiniLayout method.
* @Param: type=NA
* @Return: NA
* @Date:  19/03/2019
**/
    @isTest
    static void testfetchMiniLayout(){     
        TestHelper.createCustomSettings(true); 
        
        SampleObject12__c obj2 = new SampleObject12__c(Name='test',SampleText1__c='test sampleText');
        insert obj2;
        
        SampleObject11__c ann = TestHelper.getSampleObject1(false);
        ann.Sample_Object_2__c= obj2.id;
        insert ann;
        
        test.starttest();
        Map<String,Object> mapRecentlyViewed=FlexGridEnhancedCtrl.fetchMiniLayout(ann.id);          
        test.stopTest();
        System.assert(mapRecentlyViewed!=null);
        system.assert(mapRecentlyViewed.get('Success')!=false);
        
        
    }         
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: datadeleteRecords
* @Description: This method is used to delete Records()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void datadeleteRecords() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        List<Id> samplList = new List<Id>();
        samplList.add(SampleObject2.id);
        generator.writeObjectField(AppUtils.getNamespacePrefix() +'SampleObject2__c',samplList);   
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.deleteRecords(jsonString); 
        Map<String,Object> retMap1=FlexGridEnhancedCtrl.deleteRecord(jsonString); 
        test.StopTest();
        system.assert(retMap!=null);
        system.assert(retMap1==null);
        system.assert(retMap.get('Success')!=true);
        
    }

    @isTest
    static void dataNegativedeleteRecords() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        List<Id> samplList = new List<Id>();
        samplList.add(SampleObject2.id);
        generator.writeObjectField(AppUtils.getNamespacePrefix() +'SampleObject1__c',samplList);   
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.deleteRecords(jsonString); 
        Map<String,Object> retMap1=FlexGridEnhancedCtrl.deleteRecord(jsonString); 
        test.StopTest();
        system.assert(retMap!=null);
        system.assert(retMap1==null);
        system.assert(retMap.get('Success')!=true);
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: datasaveRecords
* @Description: This method is used to save Records()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void datasaveRecords() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
        test.StartTest();  
        String jsonString1 = '{"tableObjectsMap":{"Parent":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c","Child1":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","Child2":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","GrandChild1":"'+AppUtils.getNamespacePrefix()+'SampleObject12__c","GrandChild2":"'+AppUtils.getNamespacePrefix()+'SampleObject12__c"},"saveRecordsMap":{"a0J2M00000NS9giUAD":[{"Id":"a142M000007NUbmQAG","'+AppUtils.getNamespacePrefix()+'Currency1__c":933333333449}]},"levelVsTableIdMap":{"Parent":"a0J2M00000NS9giUAD","Child1":"a0J2M00000NS9gnUAD","Child2":"a0J2M00000PhuVQUAZ","GrandChild1":"a0J2M00000NS9gxUAD","GrandChild2":"a0J2M00000Phul9UAB"},"parentLookupFieldMap":{"a0J2M00000NS9gnUAD":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000PhuVQUAZ":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000NS9gxUAD":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","a0J2M00000Phul9UAB":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"},"queryfieldsMap":{"a0J2M00000NS9giUAD":["Id","Name","'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c","'+AppUtils.getNamespacePrefix()+'Currency1__c","'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'PhoneNo__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c","CreatedBy.Name","LastModifiedDate","'+AppUtils.getNamespacePrefix()+'SampleNumber2__c","'+AppUtils.getNamespacePrefix()+'SampleNumber1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'SampleText1__c","'+AppUtils.getNamespacePrefix()+'SampleDateTime__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleEmail__c","'+AppUtils.getNamespacePrefix()+'TestPercent__c","'+AppUtils.getNamespacePrefix()+'Contact__r.Owner.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__r.Name","'+AppUtils.getNamespacePrefix()+'TestPercent__c"]}}';      
        Map<String,Object> retMap1 =FlexGridEnhancedCtrl.saveRecords(jsonString1);          
        system.assert(retMap1!=null);
       // system.assert(retMap1.get('Success')==true);
        

        String jsonString2 = '{"tableObjectsMap":{"Parent":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c","Child1":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","Child2":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","GrandChild1":"'+AppUtils.getNamespacePrefix()+'SampleObject12__c","GrandChild2":"'+AppUtils.getNamespacePrefix()+'SampleObject12__c"},"saveRecordsMap":{"a0J2M00000NS9giUAD":[{"Id":"p1","'+AppUtils.getNamespacePrefix()+'Currency1__c":933333333449}]},"levelVsTableIdMap":{"Parent":"a0J2M00000NS9giUAD","Child1":"a0J2M00000NS9gnUAD","Child2":"a0J2M00000PhuVQUAZ","GrandChild1":"a0J2M00000NS9gxUAD","GrandChild2":"a0J2M00000Phul9UAB"},"parentLookupFieldMap":{"a0J2M00000NS9gnUAD":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000PhuVQUAZ":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000NS9gxUAD":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","a0J2M00000Phul9UAB":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"},"queryfieldsMap":{"a0J2M00000NS9giUAD":["Id","Name","'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c","'+AppUtils.getNamespacePrefix()+'Currency1__c","'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'PhoneNo__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c","CreatedBy.Name","LastModifiedDate","'+AppUtils.getNamespacePrefix()+'SampleNumber2__c","'+AppUtils.getNamespacePrefix()+'SampleNumber1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'SampleText1__c","'+AppUtils.getNamespacePrefix()+'SampleDateTime__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleEmail__c","'+AppUtils.getNamespacePrefix()+'TestPercent__c","'+AppUtils.getNamespacePrefix()+'Contact__r.Owner.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__r.Name","'+AppUtils.getNamespacePrefix()+'TestPercent__c"]}}';      
        Map<String,Object> retMap2 =FlexGridEnhancedCtrl.saveRecords(jsonString2);   
        test.StopTest();
        system.assert(retMap2!=null);
       // system.assert(retMap2.get('Success')==true);
        
    }


    @isTest
    static void dataNegativesaveRecords() {      
        
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
        
        //creating JSON object
        //String sobj=AppUtils.getNamespacePrefix() + 'SampleObject1__c';
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject(); 
        //sObjectName queryFieldsList filterCriteria pageNo pageSize limitValue sortableColumn sortDirection    
        generator.writeStringField('fieldName',AppUtils.getNamespacePrefix() +'SampleObject2__r.'+AppUtils.getNamespacePrefix() +'Status__c');       
        generator.writeStringField('sobjectName',AppUtils.getNamespacePrefix() +'SampleObject1__c');
        generator.writeStringField('flexGridType', 'FlexTable');              
        generator.writeStringField('filterClause','id!=null'); 
        generator.writeStringField('keyValueMapString','test');  
        generator.writeStringField('flexGridName','N2GChild1'); 
        generator.writeStringField('Name','N2GChild1');  
        generator.writeEndObject();   
        
        String jsonString = generator.getAsString();      
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.saveRecords(jsonString); 
        system.assert(retMap!=null);
        system.assert(retMap.get('Success')!=true);
        String jsonString12 = '{"tableObjectsMap":{"Parent":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"},"saveRecordsMap":{"a0J2M00000NS9giUAD":[{"Id":"a142M000007NUbmQAG","Currency3__c":933333333449}]},"levelVsTableIdMap":{"Parent":"a0J2M00000NS9giUAD","Child1":"a0J2M00000NS9gnUAD","Child2":"a0J2M00000PhuVQUAZ","GrandChild1":"a0J2M00000NS9gxUAD","GrandChild2":"a0J2M00000Phul9UAB"},"parentLookupFieldMap":{"a0J2M00000NS9gnUAD":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000PhuVQUAZ":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000NS9gxUAD":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","a0J2M00000Phul9UAB":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"},"queryfieldsMap":{"a0J2M00000NS9giUAD":["Id","Name","'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c","'+AppUtils.getNamespacePrefix()+'Currency1__c","'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'PhoneNo__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c","CreatedBy.Name","LastModifiedDate","'+AppUtils.getNamespacePrefix()+'SampleNumber2__c","'+AppUtils.getNamespacePrefix()+'SampleNumber1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'SampleText1__c","'+AppUtils.getNamespacePrefix()+'SampleDateTime__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleEmail__c","'+AppUtils.getNamespacePrefix()+'TestPercent__c","'+AppUtils.getNamespacePrefix()+'Contact__r.Owner.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__r.Name","'+AppUtils.getNamespacePrefix()+'TestPercent__c"]}}';      
        Map<String,Object> retMap12 =FlexGridEnhancedCtrl.saveRecords(jsonString12);          
        system.assert(retMap12!=null);
        system.assert(retMap12.get('Success')!=true);

        String jsonString1 = '{"tableObjectsMap":{"Parent":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"},"saveRecordsMap":{"a0J2M00000NS9giUAD":[{"Id":"a142M000007NUbmQAG","Currency3__c":933333333449}]},"parentLookupFieldMap":{"a0J2M00000NS9gnUAD":"'+AppUtils.getNamespacePrefix()+'Sample_Object_1__c","a0J2M00000PhuVQUAZ":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000NS9gxUAD":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","a0J2M00000Phul9UAB":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"},"queryfieldsMap":{"a0J2M00000NS9giUAD":["Id","Name","'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c","'+AppUtils.getNamespacePrefix()+'Currency1__c","'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'PhoneNo__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c","CreatedBy.Name","LastModifiedDate","'+AppUtils.getNamespacePrefix()+'SampleNumber2__c","'+AppUtils.getNamespacePrefix()+'SampleNumber1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'SampleText1__c","'+AppUtils.getNamespacePrefix()+'SampleDateTime__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleEmail__c","'+AppUtils.getNamespacePrefix()+'TestPercent__c","'+AppUtils.getNamespacePrefix()+'Contact__r.Owner.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__r.Name","'+AppUtils.getNamespacePrefix()+'TestPercent__c"]}}';      
        Map<String,Object> retMap1 =FlexGridEnhancedCtrl.saveRecords(jsonString1);          
        system.assert(retMap1!=null);
        system.assert(retMap1.get('Success')!=true);
        
        String jsonString2 = '{"tableObjectsMap":{"Parent":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"},"saveRecordsMap":{"a0J2M00000NS9giUAD":[{"Id":"p1","'+AppUtils.getNamespacePrefix()+'Currency3__c":933333333449}]},"levelVsTableIdMap":{"Parent":"a0J2M00000NS9giUAD","Child1":"a0J2M00000NS9gnUAD","Child2":"a0J2M00000PhuVQUAZ","GrandChild1":"a0J2M00000NS9gxUAD","GrandChild2":"a0J2M00000Phul9UAB"},"parentLookupFieldMap":{"a0J2M00000NS9gnUAD":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000PhuVQUAZ":"'+AppUtils.getNamespacePrefix()+'Sample_Object_2__c","a0J2M00000NS9gxUAD":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c","a0J2M00000Phul9UAB":"'+AppUtils.getNamespacePrefix()+'SampleObject1__c"},"queryfieldsMap":{"a0J2M00000NS9giUAD":["Id","Name","'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c","'+AppUtils.getNamespacePrefix()+'Currency1__c","'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'PhoneNo__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c","CreatedBy.Name","LastModifiedDate","'+AppUtils.getNamespacePrefix()+'SampleNumber2__c","'+AppUtils.getNamespacePrefix()+'SampleNumber1__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleDate__c","'+AppUtils.getNamespacePrefix()+'SampleText1__c","'+AppUtils.getNamespacePrefix()+'SampleDateTime__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleEmail__c","'+AppUtils.getNamespacePrefix()+'TestPercent__c","'+AppUtils.getNamespacePrefix()+'Contact__r.Owner.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__c","'+AppUtils.getNamespacePrefix()+'SampleObject1__r.Name","'+AppUtils.getNamespacePrefix()+'UserFriendlyNameField__r.Name","'+AppUtils.getNamespacePrefix()+'TestPercent__c"]}}';      
        Map<String,Object> retMap2 =FlexGridEnhancedCtrl.saveRecords(jsonString2);   
        test.StopTest();
        system.assert(retMap2!=null);
        system.assert(retMap2.get('Success')!=true);
       
        
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: datagetOverAllTotal
* @Description: This method is used to get OverAllTotal()
* @Param: type=NA
* @Return: NA
* @Date: 19/03/2019
**/
    @isTest
    static void datagetOverAllTotal() { 
        
        List<String> queryFieldsList1= new List<String>();
        queryFieldsList1.add('Name');
        
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        DataTableConfig__c flextable2 =getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null',null);
       
        
        String jsonString = '{"sObjectName":"SampleObject2__c","columnList":["Currency1__c","SampleObject1__r.'+AppUtils.getNamespacePrefix()+'SampleCurrency__c"],"filterClause":{"Currency1__c":"PhoneNo__c != null","SampleObject1__r.SampleCurrency__c":"PhoneNo__c != null"}}';    
        test.StartTest();  
        Map<String,Object> retMap=FlexGridEnhancedCtrl.getOverAllTotal(jsonString);   
        test.StopTest();
        system.assert(retMap!=null);
       // system.assert(retMap.get('Success')==true);
        
        
    }
    
    @isTest
    static void setGetterSetter() {    
        FlexGridEnhancedCtrl flexGrid = new FlexGridEnhancedCtrl();
        userDateFormat = flexGrid.userDateFormat;
        currencySymbol = flexGrid.currencySymbol;
        userDateTimeFormat = flexGrid.userDateTimeFormat;
        userTimeFormat = flexGrid.userTimeFormat;
        getmessageType = flexGrid.getmessageType();
       // getmessageTimeOut = flexGrid.getmessageTimeOut();
        system.assert(flexGrid!=null);
    }
    
    @isTest
    static void testupdateContentDocLink() {    
        SampleObject11__c sampleObj1= TestHelper.getSampleObject1(true);
        ContentNote note1 = new ContentNote();
        note1.Title = 'Test1';
        note1.Content = Blob.valueof('testg'); 
        insert note1;
        System.AssertEquals(note1.Title, 'Test1', 'Title of record is Test1');
        FlexGridEnhancedCtrl.updateContentDocLink(note1.id,sampleObj1.Id);
        FlexGridEnhancedCtrl.getTextValueOfContent(note1.id);  
        FlexGridEnhancedCtrl.getmessageTimeOut();      
    }

    @isTest
    static void testgetFlexGridEnhancedIcon(){
        Test.startTest();
        Map<String, String> result = FlexGridEnhancedCtrl.getFlexGridEnhancedIcon();
        Map<String, String> resultLWC = FlexGridEnhancedCtrl.getFlexGridEnhancedIconLwc();
        Test.stopTest();
        System.assertNotEquals(null,result);
        System.assertNotEquals(null,resultLWC);
    }

    
}