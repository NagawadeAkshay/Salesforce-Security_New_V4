@isTest
private with sharing class TestFlexGridSearchCtrl {
    static FlexGridSearchCtrl ctrl;
    static Map<string,Object> result;
    static void setup() {
    	
    	SampleObject11__c so1 = TestHelper.getSampleObject1(false);
    	so1.Name ='So1_Test';
    	insert so1;
    	
    	SampleObject11__c so11 = TestHelper.getSampleObject1(false);
    	so11.Name ='So11_Test';
    	so11.SampleObject11__c = so1.Id;    	
    	insert so11;
    	
    	SampleObject11__c so111 = TestHelper.getSampleObject1(false);
    	so111.Name ='So11_Test';
    	so111.SampleObject11__c = so11.Id;    	
    	insert so111;
    	
    	DataTableConfig__c flextable1 = new DataTableConfig__c();
	 	flextable1.Name = 'SampleN2GParent';
	 	flextable1.Header__c = 'Sample N2G Parent Table';
	 	flextable1.SObject__c = 'SampleObject11__c';
	 	flextable1.RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table');
	 	flextable1.FilterCriteria__c = 'RecordType.Name !=Null';
	 	flextable1.FieldNames__c = 'Id,Name';
	 	flextable1.Description__c = 'Test';
	 	insert flextable1;
    	
    	DataTableConfig__c flextable2 = new DataTableConfig__c();
	 	flextable2.Name = 'SampleN2GChild1';
	 	flextable2.Header__c = 'Sample N2G Child Table';
	 	flextable2.SObject__c = 'SampleObject11__c';
	 	flextable2.RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table');
	 	flextable2.FilterCriteria__c = 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null';
	 	flextable2.FieldNames__c = 'Id,Name';
	 	flextable2.Description__c = 'Test';
	 	flextable2.parentChildRelationshipField__c = 'SampleObject11__c';
	 	flextable2.parentGrantChildRelationshipField__c = 'SampleObject11__c';
	 	insert flextable2;
    	
    	DataTableConfig__c flextable3 = new DataTableConfig__c();
	 	flextable3.Name = 'SampleN2GGrandChild';
	 	flextable3.Header__c = 'Sample N2G Grand Child Table';
	 	flextable3.SObject__c = 'SampleObject11__c';
	 	flextable3.RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.DataTableConfig__c, 'Data Table');
	 	flextable3.FilterCriteria__c = 'SampleObject11__c=\'parentId\' AND RecordType.Name !=Null';
	 	flextable3.FieldNames__c = 'Id,Name';
	 	flextable3.Description__c = 'Test';
	 	flextable3.parentChildRelationshipField__c = 'SampleObject11__c';
	 	flextable3.parentGrantChildRelationshipField__c = 'SampleObject11__c';
	 	insert flextable3;
	 	
    	FlexGridConfig__c flexGrid = new FlexGridConfig__c();
    	flexGrid.Name = 'SampleN2GGridForSearch';
    	flexGrid.RecordTypeId = TestHelper.getRecordType(Schema.SObjectType.FlexGridConfig__c, 'Nested Navigation Grid');
		flexGrid.ParentFlexTable__c = flextable1.Id;
		flexGrid.Child1FlexTable__c = flextable2.Id;
		flexGrid.GrandChild1FlexTable__c = flextable3.Id;
		insert flexGrid;
		
		Map<String,String> keyValueMap = new Map<String,String>();  
        keyValueMap.put('name','test');  
        keyValueMap.put('istest','true');   
		
		ApexPages.currentPage().getParameters().put('gridName', 'SampleN2GGridForSearch');	
		ApexPages.currentPage().getParameters().put('searchTerm', 'test');	
		ApexPages.currentPage().getParameters().put('keyValueMap', JSON.serialize(keyValueMap));	
		ctrl = new FlexGridSearchCtrl();
		ctrl.getGenerate();
    	
    }
    @isTest
    static void testGridSearch(){
        user u = TestHelper.getAdminUser(false);
        system.runAs(u){
            test.StartTest();
                setup();                
            test.StopTest();
        }
        System.assertEquals(result,null);
    } 
}