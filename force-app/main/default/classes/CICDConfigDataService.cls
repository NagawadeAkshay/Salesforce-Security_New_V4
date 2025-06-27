@RestResource(urlMapping='/CICDConfigDataService/*')

global with sharing class CICDConfigDataService {
    @HttpPost
    global static String doDuplicateParamsTest(List<String> objectList, DateTime lastModifiedDate) {
        Map<String, Object> response = new Map<String, Object>();
        response.put('StatusCode', 200);
        Map<String, String> ErrorMap = new Map<String, String>();
        Map<String, List<sObject>> recordMap = new Map<String, List<sObject>>();
        if(objectList != NULL && !objectList.isEmpty()){
            STring query = '';
            for(String objectName : objectList){
            if(objectName =='SetupAuditTrail')
            {
                query ='SELECT Action,CreatedById,CreatedDate,Display,Id,Section FROM SetupAuditTrail';
            }
            else
            {
                query = 'SELECT Name, Id, LastModifiedDate, IsDeleted, CreatedDate, LastModifiedById, LastModifiedBy.Name FROM GNT__'+ String.escapeSingleQuotes(objectName);
            }
                if(lastModifiedDate != NULL){
                    query += ' WHERE LastModifiedDate >:lastModifiedDate';
                }
                try{
                    List<sObject> sObjectList = Database.query(String.escapeSingleQuotes(query), AccessLevel.USER_MODE); //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes/static bind //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
                    if(sObjectList != NULL && !sObjectList.isEmpty()) recordMap.put(objectName, sObjectList);
                }catch(Exception ex){
                    response.put('StatusCode', 207);
                    ErrorMap.put(objectName, ex.getStackTraceString());
                }
            }
        }
        response.put('ErrorMap', ErrorMap); 
        response.put('recordMap', recordMap); 
        return JSON.serializePretty(response);
    }
}