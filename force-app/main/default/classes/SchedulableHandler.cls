global abstract with sharing class SchedulableHandler extends JobManager implements Schedulable {
	
	global void execute(SchedulableContext context) {
		try {
			startJobStatus();
			execute();
			stopJobStatus();
		}
		catch (Exception e) {
			setExceptionError(e);
			persistErrors();
		}
	}

	global abstract void execute();
}