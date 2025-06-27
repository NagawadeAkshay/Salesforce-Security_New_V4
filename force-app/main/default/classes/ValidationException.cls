/*
  DON'T USE THE DEFAULT CONSTRUCTORS, USE newInstance() INSTEAD
  Used to return "pretty" error messages in Javascript Remoting methods
  
  **********************************************************
  Audit History
  **********************************************************
  06/19/2015      Ramu Loke        Created
  **********************************************************  
*/
public with sharing class ValidationException extends Exception
{
  /*
    Creates a ValidationExcepetion using the message supplied 
  */
  public static ValidationException newInstance(String message)
  {
    return new ValidationException(prettyMessage(message));
  }
  
  /*
    Creates a ValidationExcepetion using the error messages in the exception
  */
  public static ValidationException newInstance(Exception ex)
  {
    String message = '';
    if (ex instanceof DMLException) {
      DMLException dmlEx = (DMLException) ex;
      Integer failCount = dmlEx.getNumDml();
      
      for(Integer i=0; i<failCount; i++)
      {
        message += prettyMessage(dmlEx.getDmlMessage(i));
        message += '<br/>';
      }
    }
    else {
      message = ex.getMessage();
    }
    return new ValidationException(message);
  }
  
  private static String prettyMessage(String message)
  {
    return message.replace('[', '').replace(']', '');
  }
}