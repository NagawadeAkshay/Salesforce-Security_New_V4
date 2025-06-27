/**
    Master controller for all controller classes. All controllers must extend this controller. 
    
    **********************************************************
    Audit History
    **********************************************************
    2014-03-01      Shah Kadirmohideen          Created
    **********************************************************  
*/
global virtual with sharing class ParentController {
	public String searchText = '';
    global ParentController() {
    	
        
    }

    global void makeIECompatible() {
        Map<String,String> m = ApexPages.currentPage().getHeaders();          
        if(m != null && m.containsKey('User-Agent')) {
            String strUserAgent = m.get('User-Agent');
            if(strUserAgent != null){
                if(strUserAgent.contains('MSIE 10.0')) {
                    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9.0');       
                }                   
            }
        }
      
    }

    global string getSearchText() {
        return SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('searchText'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
    }

    global Boolean getDisplaySearchResult() {
    	/*Anuja : added try catch upload file was failing on collab due to page reload */
    	try{
   	 		searchText = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('searchText'));//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
    	}
    	catch(Exception e){
    		
    	}                   
        return !String.isEmpty(searchText);
    }
    
    global List<String> getSearchObjects() {
        List<String> objectNames = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('searchObject')).split(',');//ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        List<String> resultNames = new List<String>();
        for (String name : objectNames) {
            resultNames.add(name.trim());
        }        
        return resultNames;
    }

    global string getSearchKeyValueMap() {
        Map<String,String> keyValueMap = new Map<String,String>();
        //TODO: what is this parameter? is it needed for search?
        keyValueMap.put('ProgramId',ApexPages.currentPage().getParameters().get('id')); //ApexXSSFromURLParam - False +Ve  - After encoding format was changing which was breaking our functionality
        return JSON.serialize(keyValueMap);
    }    
}