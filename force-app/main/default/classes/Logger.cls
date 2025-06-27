/**
	**********************************************************
	Audit History
	**********************************************************  
	2013-05-13		Glen Watson			Updated Tests
	2014-02-19		Glen Watson			Updated tests, changed public -> public
	2014-02-26		Glen Watson			Allows logs on tests
	**********************************************************  
*/
public with sharing class Logger {
	public static String logData = '';
	private static Boolean isLoggable = Test.isRunningTest() || KeyValueStoreHelper.getBooleanValue('EnableLogger', true);
	private static Integer LOG_SIZE_ROTATE = 32000;
	
	public static void debug(Object obj) {
		if (isLoggable) {
			String objStr = String.valueOf(obj);
			logData += '\n' + objStr;
			if (logData.length() >= LOG_SIZE_ROTATE) {
				store();
			}
		}
	}
	
	public static void debug(String[] lines) {
		for(String s : lines)
			debug(s);
	}
	
	public static void error(Exception e) {
		debug(e.getTypeName());
		debug(e.getMessage());
		debug(e.getStackTraceString());
		if(e instanceof  DMLException || e instanceof EmailException) {
			debug('Num failed: '+e.getNumDml());
		}
		Exception cause = e.getCause();
		if(cause != null) {
			debug('caused by:');
			error(cause);
		}
	}
	
	public static void store() {
		//send email to email service to log the entries as DMLs are not allowed when invoked from controller constructor
		if (isLoggable && logData != null) {
			String toEmail = !Test.isRunningTest() ? KeyValueStoreHelper.getTextValue('LoggerEmailAddress', true) : 'testemail@example.com';
			if (!String.isEmpty(toEmail)) {
				AppUtils.sendEmail(new String[]{toEmail}, 'Logger Email Service', logData, null);
			}
			logData = '';
		}
	}

}