/* */
global with sharing class TaskSummaryCtrl{
    public transient  Boolean  isHideByphase {get{return getHideChartConfig().get('isHideByphase');} set;}
    public transient  Boolean isHideByDuedate {get{return getHideChartConfig().get('isHideByDuedate');} set;}

    private  Map<String,Boolean> getHideChartConfig(){
        Map<String,Boolean> hideChartConfigMAp = new Map<String,Boolean>();
        //Id profile_ID = userinfo.getProfileId();
        UserPreferences__c pref = UserPreferences__c.getInstance();              
        hideChartConfigMAp.put('isHideByphase',pref.IsHideByPhaseTaskSummaryChart__c);
        hideChartConfigMAp.put('isHideByDuedate',pref.IsHideByDuedateTaskSummaryChart__c);
        return hideChartConfigMAp;
    }
    
    @AuraEnabled (cacheable=true)
    public static Map<String,Boolean> getHideChartConfig2(){
        Map<String,Boolean> hideChartConfigMAp = new Map<String,Boolean>();
        UserPreferences__c pref = UserPreferences__c.getInstance();              
        hideChartConfigMAp.put('isHideByphase',pref.IsHideByPhaseTaskSummaryChart__c);
        hideChartConfigMAp.put('isHideByDuedate',pref.IsHideByDuedateTaskSummaryChart__c);
        return hideChartConfigMAp;
    }

    @AuraEnabled (cacheable=true)
    @RemoteAction
    global static  Map<String,Object> getTaskCountByPhase(){
       
        List<taskSummaryWrapper> assignedTaskSummaryWrapperList = new List<TaskSummaryWrapper>();
        Map<String,Object>phasesCount = new Map<String,Object>();
        Integer TotalAssignedTaskCount = 0;
        Integer TotalUnassignedTaskCount = 0;
        Integer countString = 0,unassignedCountString = 0;
        String flexTableName = KeyValueStoreHelper.getTextValue('TaskDisplayFlexTable',true);
        UserPreferences__c pref = UserPreferences__c.getInstance(); 
        String activeAppName = CustomAppConfig__c.getValues(pref.ActiveAppName__c).name;
        List<CustomAppPhaseConfig__c> customPhase = CustomAppPhaseConfig__c.getall().values();
        Map<String,Integer> phaseNames = new Map<String,Integer>();
        Map<String,String> phaseLabel = new Map<String,String>(); 
        List<String> phasesList = new List<String>();
        for(CustomAppPhaseConfig__c phase: customPhase){
            if(phase.CustomAppName__c == activeAppName && phase.isPhase__c && phase.Active__c){
                phaseNames.put(phase.name.toLowerCase(),Integer.valueOF(phase.sequence__c));
                phaseLabel.put(phase.name.toLowerCase(),phase.TabName__c);
                phasesList.add(phase.name);
            }
            
        }//CRUD/FLS False +ve with the help of AppUtils we have performed check
        AggregateResult[] groupedTasks = [select count(id) taskCount,PhaseName__c from Task where status in ('Not Started','In Progress') 
            and ownerId =: UserInfo.getUserId() and PhaseName__c in :phasesList WITH USER_MODE group by PhaseName__c];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Map<String,Integer> phaseCountMap = new Map<String,Integer> ();
               
        for(AggregateResult grpTasks  : groupedTasks){
                countString = 0;
                Object phaseName = grpTasks.get(AppUtils.getNamespacePrefix()+'PhaseName__c');
                if(phaseName != null)
                phaseCountMap.put(String.valueOf(phaseName).toLowerCase(),(Integer)grpTasks.get('taskCount'));
               
        }
        
        assignedTaskSummaryWrapperList = new List<taskSummaryWrapper>();
        for(String phase :phaseNames.keyset()){
            taskSummaryWrapper taskSummaryWrapper = new taskSummaryWrapper();
            
            if(!phaseCountMap.containsKey(phase.toLowerCase())){
                taskSummaryWrapper.taskCount = 0+'';
                //taskSummaryWrapper.actionUrl = '';
          
            }else{
                taskSummaryWrapper.taskCount =phaseCountMap.get(phase.toLowerCase())+'';
                taskSummaryWrapper.actionUrl = 'FlexTableView?flexTableName='+flexTableName+'&phaseName='+phase;
          
            } 
            taskSummaryWrapper.taskLabel = phaseLabel.get(phase.toLowerCase());
           // taskSummaryWrapper.actionUrl = 'FlexTableView?flexTableName='+flexTableName+'&phaseName='+phase;
            taskSummaryWrapper.sequence = phaseNames.get(phase.toLowerCase());
            if(phase == 'No Phase associated'){
                taskSummaryWrapper.actionUrl ='#';
                taskSummaryWrapper.sequence = 99;
            }
            assignedTaskSummaryWrapperList.add(taskSummaryWrapper); 
        }
        phasesCount.put('PhaseCount',assignedTaskSummaryWrapperList);
        return phasesCount;  
    }
    
    @AuraEnabled (cacheable=true)
    @RemoteAction
    global static  Map<String,Object> getLateTasks(){
        List<taskSummaryWrapper> LateTaskWrapper= new List<TaskSummaryWrapper>();
        taskSummaryWrapper tsWrapper =  new taskSummaryWrapper();
        Map<String,Object>lateTasksMap= new Map<String,Object>();
        UserPreferences__c pref = UserPreferences__c.getInstance(); 
        String activeAppName = CustomAppConfig__c.getValues(pref.ActiveAppName__c).name;
        List<CustomAppPhaseConfig__c> customPhase = CustomAppPhaseConfig__c.getall().values();
        Map<String,Integer> phaseNames = new Map<String,Integer>();
        Map<String,String> phaseLabel = new Map<String,String>(); 
        List<String> phasesList = new List<String>();
        for(CustomAppPhaseConfig__c phase: customPhase){
            if(phase.CustomAppName__c == activeAppName && phase.isPhase__c && phase.Active__c){
                phaseNames.put(phase.name.toLowerCase(),Integer.valueOF(phase.sequence__c));
                phaseLabel.put(phase.name.toLowerCase(),phase.TabName__c);
                phasesList.add(phase.name);
            }
            
        }
        tsWrapper .taskLabel  = 'Late';
        tsWrapper .actionUrl = KeyValueStoreHelper.getTextValue('FT_TasksLate', true);
        //CRUD/FLS False +ve with the help of AppUtils we have performed check
        AggregateResult[] lateTasks= [select count(id) taskCount from Task where status in ('Not Started','In Progress') 
            and ownerId =: UserInfo.getUserId() and PhaseName__c in :phasesList and LateTasks__c = true WITH USER_MODE];
        if(lateTasks.size () > 0){
            tsWrapper .taskCount = (Integer)lateTasks[0].get('taskCount')+'';
        }else{
            tsWrapper .taskCount = 0+'';
        }
        tsWrapper .sequence = 1;
        LateTaskWrapper.add(tsWrapper );
        lateTasksMap.put('LateTasks',LateTaskWrapper);
        return lateTasksMap;
    }
    
    @AuraEnabled (cacheable=true)
    @RemoteAction
    global static  Map<String,Object> getDueComingMonthsTasks(){
        List<taskSummaryWrapper> dueComingMonthTasks= new List<TaskSummaryWrapper>();
        taskSummaryWrapper tsWrapper =  new taskSummaryWrapper();
        Map<String,Object>dueComingMonthTasksMap= new Map<String,Object>();
        UserPreferences__c pref = UserPreferences__c.getInstance(); 
        String activeAppName = CustomAppConfig__c.getValues(pref.ActiveAppName__c).name;
        List<CustomAppPhaseConfig__c> customPhase = CustomAppPhaseConfig__c.getall().values();
        Map<String,Integer> phaseNames = new Map<String,Integer>();
        Map<String,String> phaseLabel = new Map<String,String>(); 
        List<String> phasesList = new List<String>();
        for(CustomAppPhaseConfig__c phase: customPhase){
            if(phase.CustomAppName__c == activeAppName && phase.isPhase__c && phase.Active__c){
                phaseNames.put(phase.name.toLowerCase(),Integer.valueOF(phase.sequence__c));
                phaseLabel.put(phase.name.toLowerCase(),phase.TabName__c);
                phasesList.add(phase.name);
            }   
        }
        tsWrapper .taskLabel  = 'Due in more than 30 Days';
        tsWrapper .actionUrl = KeyValueStoreHelper.getTextValue('FT_TasksAllOthers', true);
        List<Task> tasks = [select ActivityDate  from Task where status in ('Not Started','In Progress') 
                            and ownerId =: UserInfo.getUserId() and PhaseName__c in :phasesList 
                            and LateTasks__c = false WITH USER_MODE LIMIT :AppUtils.SOQL_JQUERY_LIMIT]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        BusinessHours  bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true];//NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Integer dueComingMonth = 0;
        for(Task t: tasks){
           Datetime activityDateTime = datetime.newInstance(t.ActivityDate.year(), t.ActivityDate.month(),t.ActivityDate.day());
	            Datetime businessDateTime = BusinessHours.add(bh.id,activityDateTime , -(Long)(1000L*60*60*720));             
	            date d = date.newinstance(businessDateTime .year(), businessDateTime .month(), businessDateTime .day());
	            if(system.today() < d){
	                dueComingMonth++;
	            }
        }
        tsWrapper .taskCount = tasks.size() == 10000?dueComingMonth+'+':dueComingMonth+'';
        tsWrapper .sequence = 1;
        dueComingMonthTasks.add(tsWrapper );
        dueComingMonthTasksMap.put('DueComingMonthsTask',dueComingMonthTasks);
        return dueComingMonthTasksMap;
    }
    
    @AuraEnabled (cacheable=true)
    @RemoteAction
    global static  Map<String,Object> getDueInSevenDaysTasks(){
        List<taskSummaryWrapper> dueSevenDaysTasks= new List<TaskSummaryWrapper>();
        taskSummaryWrapper tsWrapper =  new taskSummaryWrapper();
        Map<String,Object>dueSevenDaysTasksMap= new Map<String,Object>();
        UserPreferences__c pref = UserPreferences__c.getInstance(); 
        String activeAppName = CustomAppConfig__c.getValues(pref.ActiveAppName__c).name;
        List<CustomAppPhaseConfig__c> customPhase = CustomAppPhaseConfig__c.getall().values();
        Map<String,Integer> phaseNames = new Map<String,Integer>();
        Map<String,String> phaseLabel = new Map<String,String>(); 
        List<String> phasesList = new List<String>();
        for(CustomAppPhaseConfig__c phase: customPhase){
            if(phase.CustomAppName__c == activeAppName && phase.isPhase__c && phase.Active__c){
                phaseNames.put(phase.name.toLowerCase(),Integer.valueOF(phase.sequence__c));
                phaseLabel.put(phase.name.toLowerCase(),phase.TabName__c);
                phasesList.add(phase.name);
            }   
        }
        tsWrapper .taskLabel  = 'Due within 7 Days';
        tsWrapper .actionUrl = KeyValueStoreHelper.getTextValue('FT_TasksDueInSevenDays', true);
        List<Task> tasks = [select ActivityDate  from Task where status in ('Not Started','In Progress') 
            and ownerId =: UserInfo.getUserId() and PhaseName__c in :phasesList and LateTasks__c = false WITH USER_MODE 
            LIMIT :AppUtils.SOQL_JQUERY_LIMIT]; //NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        BusinessHours  bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true]; //NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Integer dueIn7Days= 0;
        for(Task t: tasks){
            //if(t.ActivityDate != null){ //B30u37g10 for Internal Users this was breaking if activitydate field is blank
	            Datetime activityDateTime = datetime.newInstance(t.ActivityDate.year(), t.ActivityDate.month(),t.ActivityDate.day());
	            Datetime businessDateTime = BusinessHours.add(bh.id,activityDateTime , -(Long)(1000L*60*60*168));             
	            date d = date.newinstance(businessDateTime .year(), businessDateTime .month(), businessDateTime .day());
	            if(system.today() > d && system.today() <=t.ActivityDate){
	                dueIn7Days++;
	            }
        	//}
        }
        tsWrapper .taskCount = tasks.size() == 10000?dueIn7Days+'+':dueIn7Days+'';
        tsWrapper .sequence = 1;
        dueSevenDaysTasks.add(tsWrapper );
        dueSevenDaysTasksMap.put('DueIn7Days',dueSevenDaysTasks);
        return dueSevenDaysTasksMap;
    }

    @AuraEnabled (cacheable=true)
    @RemoteAction
    global static  Map<String,Object> getDueInThirtyDaysTasks(){
        List<taskSummaryWrapper> dueThirtyDaysTasks= new List<TaskSummaryWrapper>();
        taskSummaryWrapper tsWrapper =  new taskSummaryWrapper();
        Map<String,Object>dueThirtyDaysTasksMap= new Map<String,Object>();
        UserPreferences__c pref = UserPreferences__c.getInstance(); 
        String activeAppName = CustomAppConfig__c.getValues(pref.ActiveAppName__c).name;
        List<CustomAppPhaseConfig__c> customPhase = CustomAppPhaseConfig__c.getall().values();
        Map<String,Integer> phaseNames = new Map<String,Integer>();
        Map<String,String> phaseLabel = new Map<String,String>(); 
        List<String> phasesList = new List<String>();
        for(CustomAppPhaseConfig__c phase: customPhase){
            if(phase.CustomAppName__c == activeAppName && phase.isPhase__c && phase.Active__c){
                phaseNames.put(phase.name.toLowerCase(),Integer.valueOF(phase.sequence__c));
                phaseLabel.put(phase.name.toLowerCase(),phase.TabName__c);
                phasesList.add(phase.name);
            }   
        }
        tsWrapper .taskLabel  = 'Due within 30 Days';
        tsWrapper .actionUrl = KeyValueStoreHelper.getTextValue('FT_TasksDueInThirtyDays', true);
        List<Task> tasks = [select ActivityDate  from Task where status in ('Not Started','In Progress') 
            and ownerId =: UserInfo.getUserId() and PhaseName__c in :phasesList and LateTasks__c = false 
            WITH USER_MODE LIMIT :AppUtils.SOQL_JQUERY_LIMIT]; //NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        BusinessHours  bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true]; //NOPMD CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        Integer dueIn30Days= 0;
        for(Task t: tasks){
            //if(t.ActivityDate != null){ //B30u37g10 for Internal Users this was breaking if activitydate field is blank
	            Datetime activityDateTime = datetime.newInstance(t.ActivityDate.year(), t.ActivityDate.month(),t.ActivityDate.day());
	            Datetime businessDateTime = BusinessHours.add(bh.id,activityDateTime , -(Long)(1000L*60*60*720));             
	            date d = date.newinstance(businessDateTime .year(), businessDateTime .month(), businessDateTime .day());
	            Datetime businessDateTimeToday = BusinessHours.add(bh.id,system.now(), (Long)(1000L*60*60*168));             
	            date dToday = date.newinstance(businessDateTimeToday .year(), businessDateTimeToday .month(), businessDateTimeToday .day());
	            if(dToday  >= d && dToday <=t.ActivityDate){
	                dueIn30Days++;
	                }
	        //}
        }
        tsWrapper .taskCount =tasks.size() == 10000?dueIn30Days+'+':dueIn30Days+'';
        tsWrapper .sequence = 1;
        dueThirtyDaysTasks.add(tsWrapper );
        dueThirtyDaysTasksMap.put('DueIn30Days',dueThirtyDaysTasks);
        return dueThirtyDaysTasksMap;
    }
    public with sharing class taskSummaryWrapper implements Comparable{
        @AuraEnabled
        public String taskCount {get;set;}
        @AuraEnabled
        public String taskLabel {get;set;}
        @AuraEnabled
        public String actionUrl {get;set;}
        @AuraEnabled
        public Decimal sequence {get;set;}
        
        public taskSummaryWrapper(){
            taskCount = 0+'';
        }
        
        public Integer compareTo(Object compareTo){
            taskSummaryWrapper compareToTaskSummary = (taskSummaryWrapper)compareTo;
            if(sequence == compareToTaskSummary.sequence) return 0;
            if(sequence > compareToTaskSummary.sequence) return 1;
            return -1; 
        } 
    }
       
}