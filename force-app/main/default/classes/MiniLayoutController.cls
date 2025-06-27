global with sharing class  MiniLayoutController{

    public MiniLayoutController(CalendarCtrl controller) {
    }


    @RemoteAction
    global static Map<String,Object> getLayout(String recordId) {
        Map<String,Object> resultMap = new Map<String,Object>();
        return resultMap ;
    }
}