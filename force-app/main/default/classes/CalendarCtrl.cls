/*
   @deprecated
*/

global with sharing class CalendarCtrl {

    //deprecated methods
    global static List < calEvent > getEventData() {
        return null;
    }
    global static List < calEvent > getEventData(String objectName, String fieldName, String dateFields, String filterClause) {
        return null;
    }
    global static List < calEvent > getEventData(Map <String, Object> paramMap){ 
        return null;
    } 
    global static Map < String, Object > getLayout(String idVal){                      
        return null;
    }
    global static Map < String, Object > getLayoutContent(Id pageLayoutConfigId, Id idVal, String SObjectName) {
        return null;
    }

    @RemoteAction
    global static List < calEvent > getCalendarEvents(Map <String, Object> paramMap){
        List <CalEvent> eventsToReturn = new List <CalEvent>();
        return eventsToReturn;
    }
       
    @RemoteAction
    global static String executeEventAction(String recordId, String actionName) {

        return 'Success';
    }
    // Program wrapperclass
    global with sharing class calEvent {
        public String id;
        public string elementId;
        public String title;                /*title of event */
        public String eventTitle;           /*name of the program, tasks etc.*/
        public Object start;                /* start date */
        public sobject objFields;           
        public String status;
        public String url;
        public Integer offset;
        public String objName;
        public String objLabel;
        public String colorCode;
        public String eventViewBehaviour;
        public SObject eventSobject;
        public DateTime ActivityDate;
        public String Subject;
        public String Description;
        public String OwnerName;
        public String OwnerEmail;
       //public String start;
    }
}