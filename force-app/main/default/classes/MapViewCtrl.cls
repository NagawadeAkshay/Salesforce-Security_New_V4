/**
* 
*
* CHANGE HISTORY
*================================================================ 
* Dated          Name               Description  
  07/02/2014	 Prem Pal			Created     
*================================================================
*/
 
global with sharing class MapViewCtrl {
	
	@RemoteAction
    global static Map<String,Object> executeClass(String className,String URL) {
        Map<String, Object> result = new Map<String, Object>();              
        return result;    
    }   

}