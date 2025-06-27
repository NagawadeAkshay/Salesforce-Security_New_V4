/**
* @Class Name: TestEnhancedGridExportCtrl
* @Description: This class is test class for EnhancedGridExportCtrl
**************************************************************************************************
Audit History
**************************************************************************************************
2020-06-09    Aniket Deshmukh         Created
**************************************************************************************************
**/
@isTest
private class TestEnhancedGridExportCtrl {
    static String userDateTimeFormat;
    static String userDateFormat;
    static String userTimeFormat;
    static String currencySymbol;
    static String flexGridName;
    static String childTableHeaderName;
    static String child2TableHeaderName;
    static String parentHeaderLabel;
    static String grandchildTableHeaderName;
    static String grandchild2TableHeaderName;
    static String flexGridType;
    static String mode;
    static Id parentRecordId1;
    static Integer level1;
    
     @isTest
    static void setGetterSetter() {    
        EnhancedGridExportCtrl flexGridExport = new EnhancedGridExportCtrl();
        System.assertNotEquals(null, flexGridExport);
        userDateFormat = flexGridExport.userDateFormat;
        currencySymbol = flexGridExport.currencySymbol;
        userDateTimeFormat = flexGridExport.userDateTimeFormat;
        userTimeFormat = flexGridExport.userTimeFormat;
        flexGridName = flexGridExport.flexGridName;
        childTableHeaderName = flexGridExport.childTableHeaderName;
        child2TableHeaderName = flexGridExport.child2TableHeaderName;
        parentHeaderLabel = flexGridExport.parentHeaderLabel;
        grandchildTableHeaderName = flexGridExport.grandchildTableHeaderName;
        grandchild2TableHeaderName = flexGridExport.grandchild2TableHeaderName;
        flexGridType = flexGridExport.flexGridType;
    	mode = flexGridExport.mode;
    	parentRecordId1 = flexGridExport.parentRecordId1;
        level1 = flexGridExport.level1;
    }
    
    Private Static DataTableConfig__c getflextableToInsert(String Name, String header, String SobjectName, String sobjectConfig,String FilterCriteria, String parentChildRelationshipField,String fields,String parentField){
        
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,SobjectConfig__c=sobjectConfig,	RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table')
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c =fields,EnableAutoIndex__c=true,
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
    static void insertFlexGridInfo(){                      
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SamObj2 = Database.insert(s2, false);
        System.assertNotEquals(null, SamObj2);
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
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable5.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',                                                                                     
                                                                                      HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                                      ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTableDetailConfig;   

        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable1.Id,IsActive__c=true,IsMasterView__c=true,ShowInPDF__c=true,FilterClause__c='id != null');
        //insert listView;

       
        EnhancedGridExportCtrl flexGridExport = new EnhancedGridExportCtrl();         
        flexGridExport.flexGridName ='SampleN2GGridForSearch';
        flexGridExport.mode = 'pdf';
        flexGridExport.flexGridType ='FlexGrid';
       // flexGridExport.parentRecordId1 =SampleObject1.id;
        test.StartTest();
       	Component.Apex.OutputPanel enhancedFlexGrid = flexGridExport.getGridData();       
        test.StopTest();
        
        system.assert(enhancedFlexGrid !=null);
        
    }

    @isTest
    static void insertFlexGridInfo2(){                      
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SamObj2 = Database.insert(s2, false);
        System.assertNotEquals(null, SamObj2);
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
        flextable1.PDFRenderType__c = 'Block';
        flextable2.PDFRenderType__c = 'Block';
        flextable3.PDFRenderType__c = 'Block';
        flextable4.PDFRenderType__c = 'Block';
        flextable5.PDFRenderType__c = 'Block';
        upsert flextable1;
        upsert flextable2;
        upsert flextable3;
        upsert flextable4;
        upsert flextable5;
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
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,WhereClause__c = ' Id != null',EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable5.Id,HelpText__c = 'Help Text',DefaultValue__c='Test',DisplayFields__c='name',                                                                                     
                                                                                      HideColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                                      ReadOnlyColumnJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}');
        insert dataTableDetailConfig;   

        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable1.Id,IsActive__c=true,IsMasterView__c=true,ShowInPDF__c=true,FilterClause__c='id != null');
        //insert listView;

       
        EnhancedGridExportCtrl flexGridExport = new EnhancedGridExportCtrl();         
        flexGridExport.flexGridName ='SampleN2GGridForSearch';
        flexGridExport.mode = 'pdf';
        flexGridExport.flexGridType ='FlexGrid';
       // flexGridExport.parentRecordId1 =SampleObject1.id;
        test.StartTest();
       	Component.Apex.OutputPanel enhancedFlexGrid = flexGridExport.getGridData();       
        test.StopTest();
        
        system.assert(enhancedFlexGrid !=null);
        
    }

     @isTest
    static void insertFlexGridInfoForCsv(){                      
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SamObj2 = Database.insert(s2, false);
        System.assertNotEquals(null, SamObj2);
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',Sample_Object_2__c = s2.id);
        insert s1;
        
        SampleObject12__c s12 = new SampleObject12__c(Name='test',SampleObject1__c= s1.id, SampleText1__c ='test', Currency1__c=233, Currency2__c=34343, SampleNumber1__c=12);
        insert s12 ;        
          
        
        SobjectConfig__c SampleObject1=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject1__c');
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');
        SobjectConfig__c SampleObject12=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject12__c');
        String sample2List = 'Id,Name';
        String sample1List = 'Id,Name,LastModifiedById';
        String sample12List =AppUtils.getNamespacePrefix()+'SampleText1__c,'+AppUtils.getNamespacePrefix()+'SampleTextArea1__c,'+AppUtils.getNamespacePrefix()+'SamplePicklist1__c,'+AppUtils.getNamespacePrefix()+'SampleNumber1__c,LastModifiedDate';
        DataTableConfig__c flextable1 = getflextableToInsert('parentTable','Sample N2G Parent Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'id !=Null',null,sample2List,null);
        DataTableConfig__c flextable2 =  getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
        DataTableConfig__c flextable3 =getflextableToInsert('N2GChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
        DataTableConfig__c flextable4 =getflextableToInsert('N2GGrandChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject12__c', SampleObject12.id,'id !=Null','SampleObject1__c',sample12List,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        DataTableConfig__c flextable5 =getflextableToInsert('N2GGrandChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject12__c', SampleObject12.id,'id !=Null','SampleObject1__c',sample12List,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        
        FlexGridConfig__c flexGrid = new FlexGridConfig__c(Name = 'SampleN2GGridForSearch',
                                                           ParentFlexTable__c = flextable1.Id,Child1FlexTable__c = flextable2.Id,Child2FlexTable__c = flextable3.Id,
                                                           GrandChild1FlexTable__c = flextable4.Id,GrandChild2FlexTable__c = flextable5.Id);        
        insert flexGrid;  
        
        DataTableDetailConfig__c dataTableDetailConfigparent = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber1__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable1.Id);
        insert dataTableDetailConfigparent; 
     	
         DataTableDetailConfig__c dataTableDetailConfigChild1 = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber1__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable2.Id);
        insert dataTableDetailConfigChild1; 
         DataTableDetailConfig__c dataTableDetailConfigChild11 = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber2__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable2.Id);
        insert dataTableDetailConfigChild11;
        
         DataTableDetailConfig__c dataTableDetailConfigChild2 = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber1__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable3.Id);
        insert dataTableDetailConfigChild2;   
        
        DataTableDetailConfig__c dataTableDetailConfigGrandChild1 = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber1__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable4.Id);
        insert dataTableDetailConfigGrandChild1;
       
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber1__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,EnableOverAllTotal__c=true,
                                                                                      FlexTableConfig__c = flextable5.Id);
        insert dataTableDetailConfig; 
        DataTableDetailConfig__c dataTableDetailConfigGrandChild2 = new DataTableDetailConfig__c(EnableTotal__c = false,
                                                                                      EnableRowGrouping__c = false, SubTotalLabel__c = 'SubTotal',FieldAPIName__c = AppUtils.getNamespacePrefix()+'SampleNumber2__c',
                                                                                      FieldLabelOverride__c = ' Number',FieldWidth__c = 50,Formula__c='{"GRANDTOTAL":"TEXT(GRANDTOTAL)"}',
                                                                                      FlexTableConfig__c = flextable5.Id);
        insert dataTableDetailConfigGrandChild2; 
        

        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c( FlexTableConfig__c = flextable1.Id,IsActive__c=true);
        //insert listView;

       
        EnhancedGridExportCtrl flexGridExport = new EnhancedGridExportCtrl();         
        flexGridExport.flexGridName ='SampleN2GGridForSearch';
        flexGridExport.mode = 'pdf';
        flexGridExport.flexGridType ='FlexGrid';
       // flexGridExport.parentRecordId1 =SampleObject1.id;
        test.StartTest();
       	Component.Apex.OutputPanel enhancedFlexGrid = flexGridExport.getGridData();       
        test.StopTest();
        system.assert(enhancedFlexGrid !=null);
        
    }
    
    @isTest
    static void insertFlexGridInfoNegative(){                      
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
        DataTableConfig__c flextable1 = getflextableToInsert('parentTable','Sample N2G Parent Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'Id !=Null',null,sample2List,null);
        DataTableConfig__c flextable2 =  getflextableToInsert('N2GChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
        DataTableConfig__c flextable3 =getflextableToInsert('N2GChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject1__c',SampleObject1.id, 'id !=Null','SampleObject2__c',sample1List,AppUtils.getNamespacePrefix()+'Sample_Object_2__c');
        DataTableConfig__c flextable4 =getflextableToInsert('N2GGrandChild1','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject12__c', SampleObject12.id,'id !=Null','SampleObject1__c',sample12List,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        DataTableConfig__c flextable5 =getflextableToInsert('N2GGrandChild2','Sample N2G Child Table', AppUtils.getNamespacePrefix() +'SampleObject12__c', SampleObject12.id,'id !=Null','SampleObject1__c',sample12List,AppUtils.getNamespacePrefix()+'SampleObject1__c');
        
        FlexGridConfig__c flexGrid = new FlexGridConfig__c(Name = 'SampleN2GGridForSearch',
                                                           ParentFlexTable__c = flextable1.Id,Child1FlexTable__c = flextable2.Id,Child2FlexTable__c = flextable3.Id,
                                                           GrandChild1FlexTable__c = flextable4.Id,GrandChild2FlexTable__c = flextable5.Id);        
        insert flexGrid;     
       
        EnhancedGridExportCtrl flexGridExport = new EnhancedGridExportCtrl();         
        flexGridExport.flexGridName ='SampleN2GGridForSearch';
        flexGridExport.mode = 'pdf';
        flexGridExport.flexGridType ='FlexGrid';
       	flexGridExport.parentRecordId1 =SampleObject1.id;
        test.StartTest();
       	Component.Apex.OutputPanel enhancedFlexGrid = flexGridExport.getGridData();       
        test.StopTest();
        
        system.assert(enhancedFlexGrid !=null);        
    }
    
    @isTest
    static void contentFilterTest(){
        SampleObject2__c s1 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s1;
        SampleObject2__c sampleObj = [Select id from SampleObject2__c where Name='test' limit 1];
        String base64Content = EncodingUtil.Base64Encode( Blob.valueOf( 'Testing File' ));
        Blob blobContent = EncodingUtil.base64Decode( base64Content );
        ContentVersion objCV = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.txt',
            VersionData = blobContent 
        );
        insert objCV;
        objCV = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id =: objCV.Id
        ];
        ContentDocumentLink objCDL = new ContentDocumentLink(
            ContentDocumentId = objCV.ContentDocumentId,
            LinkedEntityId = sampleObj.id,
            Visibility = 'AllUsers'
        );
        insert objCDL;
        EnhancedGridExportCtrl flexGridExport = new EnhancedGridExportCtrl();   
        EnhancedGridExportCtrl.contentFilterRecord  ContentFilter = new EnhancedGridExportCtrl.contentFilterRecord();
        List<String> parentTargetField = new List<String>();
        parentTargetField.add(sampleObj.id);
        test.StartTest();
        ContentFilter = flexGridExport.contentFilter(parentTargetField);
        test.StopTest();
        system.assertNotEquals(ContentFilter.ContentVersionFilter,'');   
        system.assertEquals(sampleObj.id,ContentFilter.ContentVersionParentIdsMap.get(String.valueOf(objCV.ContentDocumentId)));   
    }
    @isTest
    static void verifyGridExportCtrl(){
        GridExportCtrl obj = new GridExportCtrl();
        system.assertNotEquals(null, obj);
    }
}