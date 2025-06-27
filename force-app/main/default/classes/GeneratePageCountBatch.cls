/**
* Scans through Content version records and get page count
*/
global with sharing class GeneratePageCountBatch extends BatchApexHandler {
    global String query;
    Set<String> errors = new Set<String>();
    private static final String BASE_URL = URL.getOrgDomainUrl().toExternalForm();
    Integer recordCount;
    global override String getQuery(){
        query = 'SELECT Id FROM ContentVersion WHERE PageCount__c = null AND IsLatest = true WITH USER_MODE ORDER BY CreatedDate DESC LIMIT 20' ;
        return query;
    }

    global override void execute(List<SObject> scope){
        try{
            List<ContentVersion> contentVersionList = (List<ContentVersion>) scope;
            processPageCounts(contentVersionList);
		}
        catch(Exception exc){
            errors.add(exc.getMessage() + ':<br/>' + exc.getStackTraceString() + '<br/><br/>');
        }
    }

    global override void finish() {
        if (errors.size() > 0) {
            String errorDetails = 'generatePageCount batch has failed with below errors. Please take necessary actions: <br/><br/>';
            for (String err : errors) {
                errorDetails += err;
            }
            new EmailFeeder().TargetObjectId(UserInfo.getUserId()).htmlBody(errorDetails).subject('generatePageCount has failed').send();
        }
        String msgDetails = 'Task Completed for'+ Date.today();
        msgDetails+='<br>  Total number of content versions processed: '+recordCount;

        if(errors.size() > 0) {
            new EmailFeeder().TargetObjectId(UserInfo.getUserId()).htmlBody(msgDetails).subject('Calculated Page Count for Files').send();
        }
    }

    private void processPageCounts(List<ContentVersion> contentVersions){
 		if(Schema.sObjectType.ContentVersion.isUpdateable()){
            update as user contentVersions;
        }
    }
}