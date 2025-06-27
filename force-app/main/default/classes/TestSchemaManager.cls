@isTest
private with sharing class TestSchemaManager  {
    private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
        Object stub, Object request, Map<String, Object> response,
        String endpoint, String soapAction, String requestName,
        String responseNS, String responseName, String responseType)
        {
            if(request instanceof MetadataService.retrieve_element)
                response.put('response_x', new MetadataService.retrieveResponse_element());
            else if(request instanceof MetadataService.checkDeployStatus_element)
                response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
            else if(request instanceof MetadataService.listMetadata_element) {
                MetadataService.FileProperties fp = new MetadataService.FileProperties();
                fp.createdById='005G0000003UhQXIA0';
                fp.createdById_type_info= new String[]{fp.createdById, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fp.fileName='objects/UserRegistration__c.object'; 
                fp.fileName_type_info= new String[] {fp.fileName, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fp.fullName='UserRegistration__c.ExtUserReg_Additional_Information_2'; 
                fp.fullName_type_info= new String[] {fp.fullName, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fp.id='0sss0000000XZDaOAZ';//'0IXG0000000XZDzOAO'; 
                fp.id_type_info= new String[]{fp.id, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fp.manageableState='unmanaged'; 
                fp.manageableState_type_info=new String[] {fp.manageableState, 'https://soap.sforce.com/2006/04/metadata', 'null', '0', '1', 'false'}; 
                fp.namespacePrefix= AppUtils.getNamespacePrefix(); 
                fp.namespacePrefix_type_info= new String[] {fp.namespacePrefix, 'https://soap.sforce.com/2006/04/metadata', 'null', '0', '1', 'false'}; 
                fp.type_x='CustomObject'; 
                fp.type_x_type_info= new String[] {fp.type_x, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'};
                MetadataService.FileProperties fpFS = new MetadataService.FileProperties();
                fpFS.createdById='005G0000003UhQXIA0';
                fpFS.createdById_type_info= new String[]{fpFS.createdById, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fpFS.fileName='objects/UserRegistration__c.object'; 
                fpFS.fileName_type_info= new String[] {fpFS.fileName, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fpFS.fullName='UserRegistration__c.ExtUserReg_Additional_Information_2'; 
                fpFS.fullName_type_info= new String[] {fpFS.fullName, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fpFS.id='0sss0000000XZDaOAZ';//'0IXG0000000XZDzOAO'; 
                fpFS.id_type_info= new String[]{fpFS.id, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'}; 
                fpFS.manageableState='unmanaged'; 
                fpFS.manageableState_type_info=new String[] {fpFS.manageableState, 'https://soap.sforce.com/2006/04/metadata', 'null', '0', '1', 'false'}; 
                fpFS.namespacePrefix= AppUtils.getNamespacePrefix(); 
                fpFS.namespacePrefix_type_info= new String[] {fpFS.namespacePrefix, 'https://soap.sforce.com/2006/04/metadata', 'null', '0', '1', 'false'}; 
                fpFS.type_x='FieldSet'; 
                fpFS.type_x_type_info= new String[] {fpFS.type_x, 'https://soap.sforce.com/2006/04/metadata', 'null', '1', '1', 'false'};
                MetadataService.listMetadataResponse_element lmr = new MetadataService.listMetadataResponse_element();
                List<MetadataService.FileProperties> metadatafpList = new List<MetadataService.FileProperties>(); 
                metadatafpList.add(fp);
                metadatafpList.add(fpFS);
                lmr.result = metadatafpList;
                response.put('response_x', lmr);
            }
            else if(request instanceof MetadataService.checkRetrieveStatus_element)
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
            else if(request instanceof MetadataService.describeMetadata_element)
                response.put('response_x', new MetadataService.describeMetadataResponse_element());
            else if(request instanceof MetadataService.deploy_element)
                response.put('response_x', new MetadataService.deployResponse_element());
            else if(request instanceof MetadataService.updateMetadata_element)
                response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof MetadataService.renameMetadata_element)
                response.put('response_x', new MetadataService.renameMetadataResponse_element());
            else if(request instanceof  MetadataService.cancelDeploy_element)
                response.put('response_x', new MetadataService.cancelDeployResponse_element());
            else if(request instanceof  MetadataService.deleteMetadata_element)
                response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            else if(request instanceof  MetadataService.upsertMetadata_element)
                response.put('response_x', new MetadataService.upsertMetadataResponse_element());
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());
            return;
        }
    }

    //@isTest
    // private static void testgetMetadataComponentIds () {
    //     Test.startTest();
    //     System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
    //     SchemaManager.getCustomObjectId('UserRegistration__c');
    //     // SchemaManager.getFieldSetId('UserRegistration__c','ExtUserReg_Additional_Information_2');
    //     // SchemaManager.createService();//fsc.readCustomObjectSync();
    //     //SchemaManager.getCustomLabelId();
    //     //system.assertNotEquals(null, SchemaManager.createService());
    //     Test.stopTest();
    // }

    @IsTest(OnInstall=false)
    public static void testSchemaManagerMethods() {
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
        Test.startTest();
        System.assertNotEquals(null, SchemaManager.getSObject(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));
        System.assertNotEquals(null, SchemaManager.getSObject(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));
        
        
        System.assertNotEquals(null, SchemaManager.getFieldSchemaResult(AppUtils.getNamespacePrefix() + 'TabConfig__c', 
                    AppUtils.getNamespacePrefix() + 'SortOrder__c').fieldDesc);
         
        System.assertNotEquals(null, SchemaManager.getFieldSchemaResult('User','Profile.Name'));
        System.assertEquals(true, SchemaManager.doesObjExist(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));               
        System.assertNotEquals(null, SchemaManager.getSObjectField(AppUtils.getNamespacePrefix() + 'TabConfig__c', 
                    AppUtils.getNamespacePrefix() + 'SortOrder__c'));  
        //System.assertNotEquals(null, SchemaManager.getApiNames(AppUtils.getNamespacePrefix() + 'TabConfig__c')); 
        //System.assertNotEquals(null, SchemaManager.getLabels(AppUtils.getNamespacePrefix() + 'TabConfig__c')); 
        //System.assertNotEquals(null, SchemaManager.getTextAreaFieldNames(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));              
                    
        System.assertNotEquals(null, SchemaManager.getFieldNameList(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));
        
        //System.assertNotEquals(null, SchemaManager.getObjectsForReferenceFields(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));
        
        System.assertNotEquals(null, SchemaManager.getSObjectTypeFromName(AppUtils.getNamespacePrefix() + 'SampleObject11__c'));
       
        SampleObject11__c ann = TestHelper.getSampleObject1(true);
        Schema.DescribeFieldResult result = SchemaManager.fetchDescribeFieldResult(AppUtils.getNamespacePrefix() +'SampleObject11__c','Name');
        Schema.DescribeFieldResult result2 = SchemaManager.fetchDescribeFieldResult(AppUtils.getNamespacePrefix() +'SampleObject11__c',AppUtils.getNamespacePrefix()+'Account__r.Name');

        SchemaManager.Field fieldResult_1 = SchemaManager.getSObjectFieldSet(AppUtils.getNamespacePrefix() +'SampleObject11__c',AppUtils.getNamespacePrefix()+'TestListView');
        
       
      //  Schema.SObjectType res_1  = SchemaManager.getSObjectTypeFromName('SampleObject11__c');
     //   Schema.SObjectType res_2  = SchemaManager.getSObjectTypeFromName('SampleObject12__c');
        Schema.SObjectType res_3  = SchemaManager.getSObjectTypeFromName('Contact');
     //   Schema.SObjectType res_4  = SchemaManager.getSObjectTypeFromName('SampleObject11__c');
    //    Schema.SObjectType res_5  = SchemaManager.getSObjectTypeFromName('Package__c');
        Schema.SObjectType res_6  = SchemaManager.getSObjectTypeFromName('Account');
    //    Schema.SObjectType res_7  = SchemaManager.getSObjectTypeFromName('FundingSource__c');
        Schema.SObjectType res_8  = SchemaManager.getSObjectTypeFromName('Task');
        System.assertNotEquals(null, SchemaManager.getSObject(ann.Id));
        System.assertNotEquals(null, SchemaManager.getFieldNameList(ann.Id));
        Test.stopTest();
        }
    }

    @isTest 
    public static void testGetFields() {
        Test.startTest();
        SchemaManager.getFields('Name');
        Test.stopTest();
        System.assertNotEquals(null, true);
    }
    
     @isTest 
    public static void testIsUpsertableSobject() {
        Test.startTest();
        User u = TestHelper.getAdminUser(true);
        SchemaManager.isUpsertableSobject(u,'Name');
        Test.stopTest();
        System.assertNotEquals(null, true);
    }
    
     @isTest 
    public static void testIsAccessible() {
        Test.startTest();
        SchemaManager.isAccessible('User','Name');
        Test.stopTest();
        System.assertNotEquals(null, true);
    }
    
    @isTest 
    public static void testIsAccessibleWithRefField() {
        Test.startTest();
        SchemaManager.isAccessible('User','Profile.Name');
        Test.stopTest();
        System.assertNotEquals(null, true);
    }
    
     @isTest 
    public static void testIsCreatable() {
        Test.startTest();
        SchemaManager.isCreatable('User','Name');
        Test.stopTest();
        System.assertNotEquals(null, true);
    }
    
     @isTest 
    public static void testGetReferencingObjName() {
        Test.startTest();
        SchemaManager.getReferencingObjName('User','Profile.Name');
        Test.stopTest();
        System.assertNotEquals(null, true);
    }
}