global abstract with sharing class FormTableActionHandler {
	global Id packageId;
	global List<String> formTypes;
	global Id recordId;
	/*This method should be implemented by the custom class implementor
     For now we have 2 keys that are returned:
    1. Success/Error message e.g. resultMap.put('Msg','success');  
    2. operation success or failed e.g resultMap.put('IsSuccess',true/false);*/

		public void createFormTableActionHandler(){
			clickHandler();
		}

    global abstract Map<String,Object> clickHandler();
}