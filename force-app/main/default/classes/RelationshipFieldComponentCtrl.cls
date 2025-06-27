/*
    Controller for RelationshipField component.
    
    ****************************************************************************************
    Audit History
    ****************************************************************************************
    04-06-2018		Tomy Pallissery		Created
	08-01-2022      Tejashreee D        1. added with sharing for SF security review
    ****************************************************************************************
*/
global with sharing class RelationshipFieldComponentCtrl {
	global SObject primaryRecord { get; set; }
	global String relationshipFieldApiName { get; set; }

	global Boolean hasFieldValue { 
		get {
			if(String.isNotBlank(relationshipFieldApiName)) {
				if(relationshipFieldApiName.contains('.')) {
		            List<String> relationshipFields = relationshipFieldApiName.split('\\.');
		            Sobject relatedRecord;
		            integer i = 0;
		            for(i=0; i < relationshipFields.size()-1; i++) {    
		                String singleField = relationshipFields[i];                                                 
		                if(i == 0) {
		                    relatedRecord = primaryRecord.getSobject(singleField);	                    
		                } else if(relatedRecord != NULL) {
		                    relatedRecord = relatedRecord.getSobject(singleField);
	                    } else if(relatedRecord == NULL) {
	                        break;
	                    }
		            } 
	                if (relatedRecord != NULL) {
	                	return true;
	                }
		        }
		    }
			return false;
		}
		set;
	}
}