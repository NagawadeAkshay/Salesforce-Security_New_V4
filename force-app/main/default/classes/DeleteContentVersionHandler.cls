public with sharing class DeleteContentVersionHandler extends FlexTableActionHandler{
   
   public override Map<String,Object> clickHandler(){
      Map<String,Object> resultMap = new Map<String,Object>();
      
      if(selectedRecordId == null){
          resultMap.put('Message','No Records have been selected For Deleting');
          return resultMap;
      }
      
      try{
          Id delCotentDocId = [SELECT ContentDocumentId FROM ContentVersion 
                                 WHERE Id =:selectedRecordId and IsLatest = true WITH USER_MODE].ContentDocumentId;//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
          
          List<ContentDocument> delContDocList = [SELECT Id,Title FROM ContentDocument 
                                                     WHERE Id =:delCotentDocId WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
          
        if(Schema.sObjectType.ContentDocument.isDeletable() && Schema.sObjectType.ContentDocument.isAccessible()){
            delete as user delContDocList;
        }
          resultMap.put('Message','Selected File Deleted Succesfully..');    
      }catch(Exception e){
      } 
      return resultMap;          
   } 

}