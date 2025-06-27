@isTest
public class TestRelationshipFieldComponentCtrl {
@isTest
    public static void setupData(){
        RelationshipFieldComponentCtrl obj = new RelationshipFieldComponentCtrl();
        SampleObject2__c s2 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s2;
        
        SampleObject1__c s1 = new  SampleObject1__c(Name='test',SampleText1__c='test',Sample_Object_2__c = s2.id);
        insert s1;
        obj.primaryRecord = s1;
        obj.relationshipFieldApiName = AppUtils.getNamespacePrefix()+'Sample_Object_2__r.'+AppUtils.getNamespacePrefix()+'SampleObject1__c';
        Boolean result = obj.hasFieldValue;
        system.assertNotEquals(null,result); 
         
        RelationshipFieldComponentCtrl obj1 = new RelationshipFieldComponentCtrl();
        SampleObject2__c s21 = new SampleObject2__c(Name='test', SampleText1__c ='test', Currency1__c=233, Currency2__c=34343);
        insert s21;        
        SampleObject1__c s11 = new  SampleObject1__c(Name='test',SampleText1__c='test');
        insert s11;
        obj1.primaryRecord = s11;
        obj1.relationshipFieldApiName =AppUtils.getNamespacePrefix()+'Sample_Object_2__r.'+AppUtils.getNamespacePrefix()+'Sample_Object_2__r.'+AppUtils.getNamespacePrefix()+'SampleObject1__c';
        Boolean result1 = obj1.hasFieldValue;
        system.assertNotEquals(null,result1);       
       
        
        	
    }
}