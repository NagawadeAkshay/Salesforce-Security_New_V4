/**
      This class is used for calculating record completion from dynamic layout
      Formula : (Number of fields filled / Total fields on page)
      **************************************************************
      Audit History
      **************************************************************
      5/15/13           Kunal Shah              Created
      6/4/2014          Ryan Chadwick           Modified for updated record completion in GovGrants
      **************************************************************
*/

public with sharing class DynamicRecordCompletion {
    public double curPercentageSubmit {get;set;}
    public double curPercentageAll {get;set;}
    public double percentSubmitRequired {get;set;}
    public double percentAllRequired {get;set;}
    public Boolean isSubmitRequired {get;set;}
    public Boolean isAllRequired {get;set;}
    
    public DynamicRecordCompletion(DynamicLayoutHolder holder)
    {
        calculateCompletionSubmit(holder);
        calculateCompletionAll(holder);
        isAllRequired = false;
        percentAllRequired = 0.0;
        if(holder.layout.completionPercent != null){
            isSubmitRequired = true;
            percentSubmitRequired = holder.layout.completionPercent;
        }else{
            isSubmitRequired = false;
            percentSubmitRequired = 0.0;
        }
    }
    
    private void calculateCompletionSubmit(DynamicLayoutHolder holder){
        sObject obj;
        integer fieldcount = 0;
        integer fieldcountpopulated = 0;
        for (PageLayoutConfigHelper.Tab tab : holder.layout.tabs) 
        {
            for(PageLayoutConfigHelper.PageBlock pageBlock : tab.pageBlocks)
            {
                for(PageLayoutConfigHelper.Field field : pageBlock.fields)
                {
                    if( field.requiredForSubmit ){
                        fieldcount++;                    
                        if(field.fieldType == 'Field'){
                            if (field.isRelationshipField()) {                            
                            PageLayoutConfigHelper.Field relField = field.relationshipField;
                            obj = holder.recordMap.get(relField.ObjectAPIName);                            
                            if(obj.get(relField.fieldAPIName) != null)
                            {                                
                                fieldcountpopulated++;
                            }
                        }
                        else
                        {
                            obj = holder.recordMap.get(field.ObjectAPIName);                            
                            if(obj.get(field.fieldAPIName) != null)
                            {                                
                                fieldcountpopulated++;
                            }
                        }
                        }
                    }
                }
            }
        }               
        if(fieldcount == 0)
        {
            curPercentageSubmit = 0;
        }
        else
        {
            curPercentageSubmit = (fieldcountpopulated *100/fieldcount);
        }        
    }
    
    private void calculateCompletionAll(DynamicLayoutHolder holder)
    {
        //Todo: remove object hardcoding
        sObject obj;
        integer fieldcount = 0;
        integer fieldcountpopulated = 0;
        for (PageLayoutConfigHelper.Tab tab : holder.layout.tabs) 
        {
            for(PageLayoutConfigHelper.PageBlock pageBlock : tab.pageBlocks)
            {
                for(PageLayoutConfigHelper.Field field : pageBlock.fields)
                {
                    fieldcount++;                   
                    if(field.fieldType == 'Field')
                    {
                        if (field.isRelationshipField()) {                            
                            PageLayoutConfigHelper.Field relField = field.relationshipField;
                            obj = holder.recordMap.get(relField.ObjectAPIName);                            
                            if(obj.get(relField.fieldAPIName) != null)
                            {                                
                                fieldcountpopulated++;
                            }
                        }
                        else
                        {
                            obj = holder.recordMap.get(field.ObjectAPIName);                            
                            if(obj.get(field.fieldAPIName) != null)
                            {                                
                                fieldcountpopulated++;
                            }
                        }
                    }
                }
            }
        }               
        if(fieldcount == 0)
        {
            curPercentageAll = 0;
        }
        else
        {
            curPercentageAll = (fieldcountpopulated *100/fieldcount);
        }        
    }
}