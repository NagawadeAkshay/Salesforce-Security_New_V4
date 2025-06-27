/**
* @Class Name: testSobjectActionTriggerHelper
* @Description: This class is test class for SobjectActionTriggerHelper
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       | 10/07/2019  | Framework Team                      | Initail
* ====================================================================================================================
**/
@isTest
public class testSobjectActionTriggerHelper {
    
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: insertSobjectActionConfigRecords 
* @Description: This method is used to insert records of SobjectActionConfig__c along with corresponding SObjectConfig__c records.
* @Param: Name: name of SobjectActionConfig__c
* @Return:map of list of records. 
* @Date: 10/07/2019
**/ 
    
    static  SobjectActionConfig__c insertSobjectActionConfigRecords(String SObjectConfigName)
    {
        SObjectConfig__c sObjCon = new SObjectConfig__c();
        sObjCon.Name = AppUtils.getNamespacePrefix() + SObjectConfigName;
        insert sObjCon;
        System.assertNotEquals(null, sObjCon.Id);
        SobjectActionConfig__c sObjActionCon = new SobjectActionConfig__c();
        sObjActionCon.Name = AppUtils.getNamespacePrefix() + SObjectConfigName;
        sObjActionCon.SObjectConfig__c = sObjCon.Id;
        return sObjActionCon; 
    }
    
    /**
* @Author: Sonali Bajirao Jadhav
* @Method name: testForMultipleprocessBeforeInsert
* @Description: This method is used to test with Multiple records of SobjectActionConfig__c 
* @Param: NA
* @Return:NA
* @Date: 10/07/2019
**/ 
    @isTest 
    static void testForMultipleprocessBeforeInsert(){
        test.startTest();
        List<SobjectActionConfig__c> SobjectActionConfigList= new List<SobjectActionConfig__c>();
        SobjectActionConfigList.add(insertSobjectActionConfigRecords('SampleObject11__c'));
        SobjectActionConfigList.add(insertSobjectActionConfigRecords('SampleObject12__c'));
        SobjectActionConfigList.add(insertSobjectActionConfigRecords('SampleObject1__c'));
        SobjectActionConfigList.add(insertSobjectActionConfigRecords('SampleObject2__c'));
        insert SobjectActionConfigList;
        System.assertNotEquals(null, SobjectActionConfigList);

        List<SobjectActionConfig__c> updateList= new List<SobjectActionConfig__c>();
        
        for(SobjectActionConfig__c sobj:SobjectActionConfigList)
        {
            sobj.HideExpressionFields__c=null;
            updateList.add(sobj);
        }
        update updateList;
        test.stopTest();
    }
    
}