/**
* @author Pankaj
* @description - Exceptions class to be throw Exception.              
*/


global with sharing class CustomExceptions {
    
    public with sharing class InputDataException extends Exception {}
    public with sharing class RequiredException extends Exception {}     
    public with sharing class GovernorLimitException extends Exception {}    
    public with sharing class CommunityException extends Exception{}
    public with sharing class RecordLockedException extends Exception{}
    public with sharing class AuthorizationException extends Exception {}
    public with sharing class SOQLException extends Exception {}
    public with sharing class TriggerException extends Exception {}

    global static void logException(Exception ex, Boolean logToDatabase) {
		logException(ex, logToDatabase, true);
	}


    global static void handleException(Exception ex,Savepoint sp,ErrorMessageConfig__c errorMessageConfig,Boolean sendEmail){
		String errorMessage =ex.getMessage();
		if(errorMessageConfig != null){
			errorMessage =errorMessageConfig.Message__c;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessageConfig.Message__c + '\n' +  ex.getMessage()));  
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
		}
		if(sp != null){
			Database.rollback(sp);
		}
		if(sendEmail == true){
            String expectionMessage = 'Message: ' + errorMessage +'\n';
            expectionMessage = expectionMessage + 'Line number: ' + ex.getLineNumber()+ '\n';    
            expectionMessage = expectionMessage + 'Stack trace: ' + ex.getStackTraceString();
            new EmailFeeder().TargetObjectId(userInfo.getUserId()).subject('Exception').htmlBody(expectionMessage).plainTextBody(expectionMessage).send();   
		}
	}

    public static void handleException(Exception ex,Savepoint sp,ErrorMessageConfig__c errorMessageConfig,Boolean sendEmail,Id recordId){
        String errorMessage =ex.getMessage();
        if(errorMessageConfig != null){
			errorMessage =errorMessageConfig.Message__c;
			errorMessage = AppUtils.replaceRecordMergeFields(errorMessage,recordId);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessageConfig.Message__c + '\n' +  ex.getMessage()));  
        }else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        if(sp != null){
			Database.rollback(sp);
        }
        if(sendEmail == true){
			String expectionMessage = 'Message: ' + errorMessage +'\n';
			expectionMessage = expectionMessage + 'Line number: ' + ex.getLineNumber()+ '\n';    
			expectionMessage = expectionMessage + 'Stack trace: ' + ex.getStackTraceString();
			new EmailFeeder().TargetObjectId(userInfo.getUserId()).subject('Exception').htmlBody(expectionMessage).plainTextBody(expectionMessage).send();   
        }
    }

    public static void handleException(Exception ex, Savepoint sp,ErrorMessageConfig__c errorMessageConfig,Boolean sendEmail,List<Sobject> recordParamList){
        String errorMessage =ex.getMessage();
        List<Sobject> recordList = new List<SObject>();
        if(recordParamList != null && recordParamList.size() > 0){
            for(Sobject record: recordParamList){
        if(errorMessageConfig != null){
			errorMessage =errorMessageConfig.Message__c;
			if(record != null){
                        List<String>objApilist = new List<String>();
                        objApilist.add(String.valueOf(record.getSobjectType()));
                        List<String> mergeFieldsList = AppUtils.getMergeFieldSupport(errorMessage,objApilist);
              recordList.add(record);
            errorMessage = AppUtils.replceMergeFieldsList(errorMessage, recordList, mergeFieldsList);
			}
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessageConfig.Message__c + '\n' +  ex.getMessage()));  
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        if(sp != null){
			Database.rollback(sp);
        }
        if(sendEmail == true){
          String expectionMessage = 'Message: ' + errorMessage +'\n';
          expectionMessage = expectionMessage + 'Line number: ' + ex.getLineNumber()+ '\n';    
          expectionMessage = expectionMessage + 'Stack trace: ' + ex.getStackTraceString();
          new EmailFeeder().TargetObjectId(userInfo.getUserId()).subject('Exception').htmlBody(expectionMessage).plainTextBody(expectionMessage).send();   
        }
    }
        }

    }

    global static void logException(Exception ex, Boolean logToDatabase, Boolean throwException) {
		if(logToDatabase == true) {
			ErrorLog__c error = new ErrorLog__c();
			if(Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()){
				if(ex.getMessage().length() > 255){
					error.ErrorMessage__c = ex.getMessage().substring(0,254);
				} else {
					error.ErrorMessage__c =  ex.getMessage();
				}
			}
			if(Schema.sObjectType.ErrorLog__c.fields.Errordescription__c.isCreateable()){
				error.Errordescription__c = ex.getStackTraceString();
			}
			if(Schema.sObjectType.ErrorLog__c.isCreateable()){
				insert as user error;
			}
		}
		if(throwException == true) {
		String errMsg = Apputils.handleSystemExceptionMsg(ex.getMessage());
		throw new CustomExceptions.InputDataException(errMsg);
		}
    }

	global static void logException(String ex, Boolean logToDatabase) {
		if(logToDatabase == true) {
			ErrorLog__c error = new ErrorLog__c();
			if(Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()){
				if(ex.length() > 255){
					error.ErrorMessage__c = ex.substring(0,254);
				} else {
					error.ErrorMessage__c = ex;
				}
			}
			if(Schema.sObjectType.ErrorLog__c.fields.Errordescription__c.isCreateable()){
				if(ex.length() > 131071){
					error.Errordescription__c = ex.substring(0,131071);
				}else {
					error.Errordescription__c = ex;
				}
			}
			if(Schema.sObjectType.ErrorLog__c.isCreateable()){
				insert as user error;
			}
		} else {
			String errMsg = Apputils.handleSystemExceptionMsg(ex);
			throw new CustomExceptions.InputDataException(errMsg);
		}
	}

	global static void logException(String ex, Boolean logToDatabase, Boolean throwException) {
		if(logToDatabase == true) {
			ErrorLog__c error = new ErrorLog__c();
			if(Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()){
				if(ex.length() > 255){
					error.ErrorMessage__c = ex.substring(0,254);
				} else {
					error.ErrorMessage__c =  ex;
				}
			}
			if(Schema.sObjectType.ErrorLog__c.fields.Errordescription__c.isCreateable()){
				if(ex.length() > 131071){
					error.Errordescription__c = ex.substring(0,131071);
				}else {
					error.Errordescription__c = ex;
				}
			}
			if(Schema.sObjectType.ErrorLog__c.isCreateable()){
				insert as user error;
			}
		//Log Exception to database
		//forcefully commit to database.
		}
		if(throwException == true) {
			String errMsg = Apputils.handleSystemExceptionMsg(ex);
			throw new CustomExceptions.InputDataException(errMsg); 
		}
    }

    /*
        Author : Atul.Naik
        Purpose : This Method to Added System Level Exception to be logged in Error Log.
    */
    global static void logSystemException(Exception ex ,String recordId, List<String> recordIds){
        ErrorLog__c error = new ErrorLog__c();
        String recIds;
		if(Schema.sObjectType.ErrorLog__c.fields.ErrorMessage__c.isCreateable()){
			if(ex.getMessage().length() > 255){
					error.ErrorMessage__c = ex.getMessage().substring(0,254);
			}else{
				error.ErrorMessage__c =  ex.getMessage();
			}
		}
        if(Schema.sObjectType.ErrorLog__c.fields.Errordescription__c.isCreateable()){
			error.Errordescription__c = ex.getStackTraceString();
		}
        if(Schema.sObjectType.ErrorLog__c.fields.ParentId__c.isCreateable()){
			error.ParentId__c = recordId;
		}

        if(recordIds != null && recordIds.size() > 0 && Schema.sObjectType.ErrorLog__c.fields.RecordIds__c.isCreateable()){ 
          error.RecordIds__c = String.join(recordIds,';');
        }
        if(Schema.sObjectType.ErrorLog__c.isCreateable()){
          insert as user error;
        }
    }
}