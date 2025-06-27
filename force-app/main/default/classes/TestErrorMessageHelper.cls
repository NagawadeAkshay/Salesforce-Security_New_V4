@isTest
private class TestErrorMessageHelper{  
  @isTest
  private static void TestFetchMessage(){
      PhaseConfig__c phaseConfig = TestHelper.getPhase(true);
      CustomApp__c customAppConfig = new CustomApp__c();
      customAppConfig.Name = 'StateasGrantor';
      customAppConfig.Active__C = true;
      insert customAppConfig;
      System.assertNotEquals(null, customAppConfig.Id);

      ErrorMessageConfig__c errConfig = TestHelper.getErrorMessageConfig('TestCode', 'Error', phaseConfig.id, customAppConfig.id, true );
      System.assertNotEquals(null, errConfig.Id);
      errConfig = [SELECT Id, ErrorCode__c, Message__c, Message_Type__c FROM ErrorMessageConfig__c WHERE Id =:errConfig.Id];
      System.assertNotEquals(null, errConfig.Id);
      System.assertNotEquals(null, errConfig.ErrorCode__c);

      String messageType = ErrorMessageHelper.fetchMessageType(errConfig.ErrorCode__c);
      ErrorMessageHelper.addMessage(errConfig.ErrorCode__c);
      ErrorMessageHelper.fetchMessageType('');

      String errorMessage = ErrorMessageHelper.fetchMessage(errConfig.ErrorCode__c);
      errorMessage = ErrorMessageHelper.fetchMessage(errConfig.ErrorCode__c);
      ErrorMessageHelper.fetchMessage('');
      

      Map<String, String> mapErrMessages = ErrorMessageHelper.fetchMessages(new Set<String>{errConfig.ErrorCode__c});
      System.assertNotEquals(null, mapErrMessages);
      Map<String, String> mapErrMessages2 = ErrorMessageHelper.fetchMessages(new Set<String>{errConfig.ErrorCode__c,'Test2'});
     
      
      ErrorMessageHelper.addMessage(errConfig.ErrorCode__c);
      messageType = ErrorMessageHelper.fetchMessageType(errConfig.ErrorCode__c);

      errConfig = TestHelper.getErrorMessageConfig('TestErrorCode', 'Error', phaseConfig.id, customAppConfig.id, true );
      System.assertNotEquals(null, errConfig.Id);
      try {
        ErrorMessageHelper.addMessage('TestErrorCode');
      } catch (Exception ex) {}      
  } 
  
  @isTest
  private static void TestLightningPageMessage(){

    LightningPageMessage pgMessage = new LightningPageMessage();
    LightningPageMessage pgMessage2 = new LightningPageMessage('Warning','Test Warning Message using string');
    LightningPageMessage pgMessage3 = new LightningPageMessage(ApexPages.Severity.WARNING,'Test Warning Message using string');
    System.assertNotEquals(null, pgMessage3);
  }

  @isTest
   public static void testStartJobStatus() {
       ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'YourClassName',CronExpression__c=' 0 1 * * * ? ');
       insert jobConfig;
       
       JobManager jobManager = new JobManager();
       jobManager.jobConfigId = jobConfig.Id;
       Test.startTest();
       jobManager.startJobStatus();
       Test.stopTest();
       
       jobConfig= [SELECT Status__c, LastRunStartedOn__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Started', jobConfig.Status__c);
       System.assertNotEquals(null, jobConfig.LastRunStartedOn__c);
   }
   
   @isTest
   public static void testStopJobStatus() {
      ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'YourClassName',CronExpression__c=' 0 1 * * * ? ',
      ErrorMessage__c='Test');
       insert jobConfig;

       JobManager jobManager = new JobManager();
       jobManager.jobConfig = [SELECT id, ClassName__c ,Status__c, LastRunEndedOn__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       jobManager.jobConfigId = jobConfig.Id;
       
       Test.startTest();
       jobManager.stopJobStatus();
       Test.stopTest();

       jobConfig= [SELECT Status__c, LastRunEndedOn__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Completed', jobConfig.Status__c);
   }
   
   
   @isTest
   public static void testsetExceptionError() {
      ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'JobManager',
           Status__c = 'Started',CronExpression__c=' 0 1 * * * ? ');
       insert jobConfig;

       Test.startTest();
       JobManager jobManager = new JobManager();
       jobManager.jobConfigId = jobConfig.Id;
       jobManager.loadJobConfig();
       try {
           Integer result = 1 / 0;
       } catch (Exception e) {
           jobManager.setExceptionError(e);
       }
       Test.stopTest();

       jobConfig = [SELECT LastRunEndedOn__c, Status__c, ErrorMessage__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Failed', jobConfig.Status__c);
       System.assertNotEquals(null, jobConfig.LastRunEndedOn__c);
   
   }
   
   @isTest
   public static void testSetErrorWithException() {
        ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'JobManager',
           Status__c = 'Started',CronExpression__c=' 0 1 * * * ? ');
       insert jobConfig;
        Test.startTest();
       JobManager jobManager = new JobManager();
       jobManager.jobConfigId = jobConfig.Id;
       jobManager.loadJobConfig();
       try {
           Integer result = 1 / 0;
       } catch (Exception e) {
           jobManager.setError(e);
       }
       Test.stopTest();

       jobConfig = [SELECT LastRunEndedOn__c, Status__c, ErrorMessage__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Failed', jobConfig.Status__c);
       System.assertNotEquals(null, jobConfig.LastRunEndedOn__c);
   }
   
   @isTest
   public static void testSetErrorWithString() {
       ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'JobManager',
           Status__c = 'Started',CronExpression__c=' 0 1 * * * ? ');
       insert jobConfig;
       
        Test.startTest();
       JobManager jobManager = new JobManager();
       jobManager.jobConfigId = jobConfig.Id;
       jobManager.loadJobConfig();
       jobManager.setError('Test Error Message');
       Test.stopTest();

       jobConfig = [SELECT LastRunEndedOn__c, Status__c, ErrorMessage__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Failed', jobConfig.Status__c);
       System.assertNotEquals(null, jobConfig.LastRunEndedOn__c);
       System.assertEquals('Test Error Message', jobConfig.ErrorMessage__c);
   }
   
   @isTest
   public static void testPersistErrors() {
       Test.startTest();
       JobManager jobManager = new JobManager();
       jobManager.persistErrors();
       System.assertNotEquals(null, jobManager);
       Test.stopTest();
   }
   
    @isTest
    public static void testSetErrorWithExceptionAndScope() {
       ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'JobManager',
           Status__c = 'Started',CronExpression__c=' 0 1 * * * ? ');
       insert jobConfig;

       Test.startTest();
       
       JobManager jobManager = new JobManager();
       jobManager.jobConfigId = jobConfig.Id;
       jobManager.loadJobConfig();

       List<Object> scope = new List<Object>();
       scope.add(new Account(Name = 'Test Account'));

       try {
           Integer result = 1 / 0;
       } catch (Exception e) {
           jobManager.setError(e, scope);
       }
       Test.stopTest();

       jobConfig = [SELECT LastRunEndedOn__c, Status__c, ErrorMessage__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Failed', jobConfig.Status__c);
       System.assertNotEquals(null, jobConfig.LastRunEndedOn__c);
   }
   
    @isTest
    public static void testSetErrorWithExceptionAndObjectScope() {
       ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'JobManager',
           Status__c = 'Started',CronExpression__c=' 0 1 * * * ? ');
       insert jobConfig;

       Test.startTest();
       
       JobManager jobManager = new JobManager();
       jobManager.jobConfigId = jobConfig.Id;
       jobManager.loadJobConfig();

       List<sObject> scope = new List<sObject>();
       scope.add(new Account(Name = 'Test Account'));

       try {
           Integer result = 1 / 0;
       } catch (Exception e) {
           jobManager.setError(e, scope);
       }
       Test.stopTest();

       jobConfig = [SELECT LastRunEndedOn__c, Status__c, ErrorMessage__c FROM ApexJob__c WHERE Id = :jobConfig.Id];
       System.assertEquals('Failed', jobConfig.Status__c);
       System.assertNotEquals(null, jobConfig.LastRunEndedOn__c);
   }

   @isTest
   public static void testAddExceptionWithParentId() {
    ApexJob__c jobConfig= new ApexJob__c(ClassName__c = 'JobManager',
        Status__c = 'Started',CronExpression__c=' 0 1 * * * ? ');
    insert jobConfig;
    
    ErrorHandler errorHandler = new ErrorHandler();
    ErrorHandler.jobConfigId  = jobConfig.Id;
    
    try {
        Integer result = 1 / 0;
    } catch (Exception e) {
       errorHandler.add(e, jobConfig.Id);
    }

    System.assertEquals(1, errorHandler.errors.size());
    System.assertEquals(jobConfig.Id, errorHandler.errors[0].ParentId__c);
}

  @isTest
    public static void testPersist() {
        ErrorHandler errorHandler = new ErrorHandler();

        Test.startTest();
        errorHandler.persist();
        Test.stopTest();

        List<ErrorLog__c> persistedErrors = [SELECT ParentId__c, ErrorMessage__c FROM ErrorLog__c];
        System.assertEquals(0, persistedErrors.size());
    }

        @isTest
    public static void testAdd_1() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Id parentId = testAccount.Id;
        String errorMessage = 'Test error message';
        Test.startTest();
        ErrorHandler handler = new ErrorHandler();
        ErrorHandler result = handler.add(errorMessage, parentId);
        Test.stopTest();
        System.assertEquals(handler, result);
    }

    @isTest
    public static void testAdd_2() {
        Account acc1 = new Account(Name='Test Account');
        Account acc2 = new Account(Name='Test Account 2');
        insert acc1;
        insert acc2;
    
        Set<String> parentIds = new Set<String>{
            acc1.id,
            acc2.id
        };
        String errorMessage = 'Test error message';
        ErrorHandler handler = new ErrorHandler();
        Test.startTest();
            ErrorHandler result = handler.add(errorMessage, parentIds);
        Test.stopTest();
        System.assertEquals(handler, result);
    }

    @isTest
    public static void testgetException() {
        Test.startTest();
        try{
            Integer result = 1 / 0;
        } catch (Exception e) {
        ErrorHandler.getException(e);
        System.assertNOTEquals(null,ErrorHandler.getException(e));
        }
        Test.stopTest(); 
    }
    @isTest
    public static void testgetScopeRecordIds() {
        List<SObject> scope = new List<SObject>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        List<SObject> scope1; 
        ErrorHandler handler = new ErrorHandler();
        String ret;
        Test.startTest();
        ret = handler.getScopeRecordIds(scope);
        handler.getScopeRecordIds(scope1);
        Test.stopTest();
        System.assertNotEquals(null,ret);
        
    }

    @isTest
    public static void testgetConcatenatedErrorMessages() {
        ErrorLog__c log = new ErrorLog__c(Errordescription__c = 'test');
        ErrorHandler handler = new ErrorHandler();
        handler.errors.add(log);
        String ret;
        Test.startTest();
        ret = handler.getConcatenatedErrorMessages();
        handler.isEmpty();
        Test.stopTest();
        System.assertNotEquals(null,ret);
    }

    @isTest
    public static void testadd() {
        Account acc = new Account(Name = 'Test Account 1');
        ErrorHandler handler = new ErrorHandler();
        Test.startTest();
        try {
            Integer result = 1 / 0;
        } catch (Exception e) {
        handler.add(e, acc .Id);
        System.assertNotEquals(null,handler.add(e, acc .Id));
        }
        Test.stopTest();        
    }

    @isTest
    public static void testAddErrorLog() {
        Account acc = new Account(Name = 'Test Account 1');
        insert acc;

        ErrorHandler errorHandler = new ErrorHandler();
        ErrorLog__c errorLog = new ErrorLog__c(ParentId__c = acc .Id, ErrorMessage__c = 'Test Error Message');

        errorHandler.add(errorLog);

        Test.startTest();
        errorHandler.persist();
        Test.stopTest();

        List<ErrorLog__c> errorLogs = [SELECT Id, ParentId__c, ErrorMessage__c FROM ErrorLog__c WHERE ParentId__c = :acc.Id];
        System.assertEquals(1, errorLogs.size(), 'One error log should have been persisted');
    }

    @isTest
    public static void testAddparent() {
        ErrorHandler handler = new ErrorHandler();
        List<SObject> lst = new List<SObject>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert lst;
        Set<String> parentIds = new Set<String>();
        
        for(Sobject s : lst){
            parentIds.add(s.id);
        }
        System.assertNotEquals(null,parentIds);

        Test.startTest();
        try {
            Integer result = 1 / 0;
            
        } catch (Exception e) {
            handler.add(e, parentIds);
            handler.add(e, lst);
        }
        Test.stopTest();
       

    }  
}