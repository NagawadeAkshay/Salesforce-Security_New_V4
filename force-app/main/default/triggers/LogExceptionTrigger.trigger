trigger LogExceptionTrigger on Log_Exception__e (after insert) {    
    LogExceptionHandler.logException((List<Log_Exception__e>)Trigger.New);
}