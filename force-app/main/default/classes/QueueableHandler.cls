public abstract with sharing class QueueableHandler extends JobManager implements Queueable{
    
    public void execute(QueueableContext context){
        try{
            startJobStatus();
            execute();
            stopJobStatus();
        }catch(Exception e){
            setExceptionError(e);
            persistErrors();
        }             
    }

    public abstract void execute();
}