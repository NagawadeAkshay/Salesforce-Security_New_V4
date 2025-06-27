/**
* @Class Name: FlexTableListViewTriggerHelperTest
* @Description: This class is test class for FlexTableListViewTriggerHelper
* ====================================================================================================================
*   Version   | Date        | Author                              | Comments
* --------------------------------------------------------------------------------------------------------------------
*   1.0       |07/08/2019   | Framework Team                      | Initail
* ====================================================================================================================
**/
@IsTest public class FlexTableListViewTriggerHelperTest {
  
    
      /**
* @Author: Sonali Bajirao Jadhav
* @Method name: getCountOfDefaults
* @Description: This method is used to get total no of records with IsDefault__c as a set
* @Param: List of records
* @Return: integer 
* @Date: 07/08/2019
**/ 
    
    Private Static integer getCountOfDefaults( List<FlexTableFilterListViewConfig__c> ExistingRecords )
    {
        integer count= 0;
        for(FlexTableFilterListViewConfig__c rec : ExistingRecords)
        {
            if(rec.IsDefault__c)
            {
                count =count +1;
            }
        }
        return count;
    }
   /**
* @Author: Sonali Bajirao Jadhav
* @Method name: VerifyUpdateRelatedDefault
* @Description: This method is used to verify UpdateRelatedDefault method
* @Param: 
* @Return:
* @Date: 07/08/2019
**/ 
      @IsTest
    public static void VerifyUpdateRelatedDefault() 
    {
        DataTableConfig__c flextable = TestHelper.getFlexDataTableConfig(true);
        List<FlexTableFilterListViewConfig__c> Listview = new List<FlexTableFilterListViewConfig__c>();
        Listview.add(new FlexTableFilterListViewConfig__c(IsDefault__c= true , IsActive__c= true ,FlexTableConfig__c = flextable.id));
        Listview.add(new FlexTableFilterListViewConfig__c(IsDefault__c= false , IsActive__c= true ,FlexTableConfig__c = flextable.id));
        Listview.add(new FlexTableFilterListViewConfig__c(IsDefault__c= false , IsActive__c= true ,FlexTableConfig__c = flextable.id));
		Listview.add(new FlexTableFilterListViewConfig__c(IsDefault__c= false , IsActive__c= true ,FlexTableConfig__c = flextable.id));
        
        Test.startTest();
        insert Listview;
        List<FlexTableFilterListViewConfig__c> ExistingRecords =  new List<FlexTableFilterListViewConfig__c>([SELECT IsActive__c, FlexTableConfig__c, IsMasterView__c, IsDefault__c, Id, Name FROM FlexTableFilterListViewConfig__c]);
		Integer cnt = getCountOfDefaults(ExistingRecords);
        System.assertEquals(1, cnt);

        
        List<FlexTableFilterListViewConfig__c> updateRecords= new List<FlexTableFilterListViewConfig__c>(); 
        for(FlexTableFilterListViewConfig__c rec : ExistingRecords)
        {
            if(!rec.IsDefault__c)
            {
                rec.IsDefault__c=true;
                 updateRecords.add(rec);
            }
        }
        update updateRecords;
        List<FlexTableFilterListViewConfig__c> ExistingRecords1 =  new List<FlexTableFilterListViewConfig__c>([SELECT IsActive__c, FlexTableConfig__c, IsMasterView__c, IsDefault__c, Id, Name FROM FlexTableFilterListViewConfig__c]);
		Integer cnt1 = getCountOfDefaults(ExistingRecords1);
        System.assertEquals(1, cnt);
        Test.stopTest();
    }    
}