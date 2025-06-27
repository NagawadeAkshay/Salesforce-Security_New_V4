@isTest
public class TestConfigDataTableActionTriggerHelper {
	 Private Static DataTableConfig__c getflextableToInsert(String Name, String header, String SobjectName, String sobjectConfig,String FilterCriteria, String parentChildRelationshipField,String fields,String parentField){
        
        DataTableConfig__c table = new DataTableConfig__c(Name=Name,Header__c=header,SObject__c=SobjectName,SobjectConfig__c=sobjectConfig, RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table')
                                                          ,FilterCriteria__c=FilterCriteria,FieldNames__c =fields,EnableAutoIndex__c=true,EnableTotalRow__c=true,
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
    static void setup(){                      
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        Database.SaveResult SamObj2 = Database.insert(s2, false);
        SobjectConfig__c SampleObject2=getSobjectConfigToInsert(AppUtils.getNamespacePrefix() +'SampleObject2__c');       
        String sample2List = 'Id,Name';
       
        DataTableConfig__c flextable1 = getflextableToInsert('parentTable','Sample N2G Parent Table', AppUtils.getNamespacePrefix() +'SampleObject2__c',SampleObject2.id, 'id !=Null',null,sample2List,null);
 
        DataTableAction__c dataTableAction = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                    HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',ModalHeight__c = 100,
                                                                    ModalTitle__c = 'Sample Modal Title',ModalWidth__c = 100, Sequence__c = 8,
                                                                    ShowConfirmationBox__c = false, ConfirmationMessage__c = 'Are you Ready ?',
                                                                    HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}',
                                                                   RecordTypeId =Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('FlexGrid Enhanced Action').getRecordTypeId());
        insert dataTableAction; 
        dataTableAction.HideForUser__c = 'External';
        upsert dataTableAction;
       
		
        DataTableAction__c dataTablerowAction = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideForProfile__c = 'System Administrator',
                                                                        HideForUser__c = 'Internal',HideOperator__c = 'OR',Location__c = 'Top',Sequence__c = 8,
                                                                        ActionBehavior__c='edit',StandardAction__c='edit',EnableParentHideLogic__c = true,
                                                                        HideExpressionJSON__c='{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"SampleObject2__c"}',
                                                                       RecordTypeId =Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('FlexGrid Enhanced Action').getRecordTypeId() );
        insert dataTablerowAction;
        
        dataTablerowAction.HideForUser__c = 'External';
        upsert dataTablerowAction;
        
         DataTableAction__c dataTablerowAction2 = new DataTableAction__c( DataTableConfig__c = flextable1.Id,HideOperator__c = 'OR',Location__c = 'Row',Sequence__c = 8,
                                                                       StandardAction__c='edit',
                                                                        HideExpressionJSON__c = '{"LogicalOperator":"AND","Conditions":[{"LOperand":{"Type":"Field","DataType":"number","Value":"'+AppUtils.getNamespacePrefix()+'SampleNumber1__c"},"Operator":"=","ROperand":{"Type":"Freetext","Value":"8","Values":[]}}],"Groups":[],"ExpressionObject":"'+AppUtils.getNamespacePrefix()+'SampleObject2__c"}',
                                                                        RecordTypeId =Schema.SObjectType.DataTableAction__c.getRecordTypeInfosByName().get('FlexGrid Enhanced Action').getRecordTypeId());
        insert dataTablerowAction2;
		dataTablerowAction2.Sequence__c = 1;
        upsert dataTablerowAction2;
        

        
         System.assert(dataTablerowAction2 !=null);
    }
}