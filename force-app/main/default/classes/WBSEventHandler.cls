global abstract with sharing class WBSEventHandler {
    
    global Map<String, Object> keyValueMap = new Map<String, Object>();
    
    //This method should be implemented by the custom class implementor
    global abstract Map<String,Object> handleEvent();
    
    public void test(){
        handleEvent();
    }
    
}