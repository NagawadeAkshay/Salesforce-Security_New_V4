@isTest
public class TestClassSchemaManager {
     private static Map<String, Schema.SObjectType> globalSchemaMap; 
	@isTest
    private static void setupData(){
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',Sample_Object_2__c = s2.id);
        insert s1;
        
        SchemaManager.SObjectWrapper sobj = SchemaManager.getSObject(s2.id);
        system.assertNotEquals(null,sobj);    
        Boolean result = SchemaManager.doesObjExist(AppUtils.getNamespacePrefix()+'SampleObject2__c'); 
        system.assertNotEquals(null,result);         
        Schema.SObjectType result1 = SchemaManager.getSObjectTypeFromName(AppUtils.getNamespacePrefix()+'SampleObject2__c'); 
        system.assertNotEquals(null,result1);
        Map<String, SchemaManager.SObjectWrapper>  result2 = SchemaManager.getObjectsForReferenceFields(AppUtils.getNamespacePrefix()+'SampleObject2__c'); 
        system.assertEquals(null,result2);     
        SchemaManager.Field  result3 = SchemaManager.getFieldSchemaResult(AppUtils.getNamespacePrefix()+'SampleObject2__c', 'Name'); 
        system.assertNotEquals(null,result3);     
        Schema.SObjectField  result4 = SchemaManager.getSObjectField(AppUtils.getNamespacePrefix()+'SampleObject2__c','Name'); 
        system.assertNotEquals(null,result4);
        Schema.DescribeFieldResult  result5 = SchemaManager.fetchDescribeFieldResult(AppUtils.getNamespacePrefix()+'SampleObject2__c', 'Name');
        system.assertNotEquals(null,result5);
      //  SchemaManager.Field  result6 = SchemaManager.getSObjectFieldSet(AppUtils.getNamespacePrefix()+'SampleObject2__c', AppUtils.getNamespacePrefix()+'SampleNumber1__c'); 
     //   system.assertNotEquals(null,result6);          
     	SchemaManager obj = new SchemaManager();
        SchemaManager.getFields(AppUtils.getNamespacePrefix()+'SampleNumber1__c');
         SobjectConfig__c sobj1=new SobjectConfig__c(); 
        sobj1.UserFriendlyNameField__c='Name';
        sobj1.name=AppUtils.getNamespacePrefix()+'SampleObject2__c';
        insert sobj1;
        boolean res1=  SchemaManager.isUpsertableSobject(sobj1, 'Name');
        boolean res2 = SchemaManager.isAccessible(AppUtils.getNamespacePrefix()+'SampleObject2__c', 'Name');
        boolean res3 = SchemaManager.isAccessible(AppUtils.getNamespacePrefix()+'SampleObject2__c', AppUtils.getNamespacePrefix()+'SampleObject1__r.Name');
        boolean res4 = SchemaManager.isCreatable(AppUtils.getNamespacePrefix()+'SampleObject2__c', 'Name');
        boolean res5 = SchemaManager.isAccessible(AppUtils.getNamespacePrefix()+'SampleObject2__c', AppUtils.getNamespacePrefix()+'SampleObject1__r.Name'); 
       	boolean res6 = SchemaManager.isAccessible(AppUtils.getNamespacePrefix()+'SampleObject2__c', AppUtils.getNamespacePrefix()+'SampleObject1__c'); 
     	List<String> lst1 =SchemaManager.getTextAreaFieldNames(AppUtils.getNamespacePrefix()+'SampleObject2__c');
        List<String> lst2 =SchemaManager.getFieldNameList(s2.id);
        Map<String, Schema.SObjectField> mapobj1 = SchemaManager.getFieldsMap(AppUtils.getNamespacePrefix()+'SampleObject2__c');
        List<String> flds = SchemaManager.getFieldNameList(AppUtils.getNamespacePrefix()+'SampleObject2__c');
        
       //SchemaManager.Field flds1 = SchemaManager.getSObjectFieldSet(AppUtils.getNamespacePrefix()+'SampleObject2__c','Name');
       // String str = SchemaManager.getFieldSetId(AppUtils.getNamespacePrefix()+'SampleObject2__c', 'Name');
      //  String str1 =  SchemaManager.getCustomObjectId(AppUtils.getNamespacePrefix()+'SampleObject2__c');
      system.assertNotEquals(null,flds);        
    }
    
     
    
}