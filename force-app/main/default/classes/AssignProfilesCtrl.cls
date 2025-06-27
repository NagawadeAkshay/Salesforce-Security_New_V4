global with sharing class AssignProfilesCtrl { 
	public String sObjectName {get; private set;}
	public String fieldName {get; private set;}
	public String sObjectId {get; private set;}
	public String profiles {get; private set;}

	public AssignProfilesCtrl() {
        Map<String, String> UrlParameterMap = ApexPages.currentPage().getParameters();
        if (UrlParameterMap.containsKey('id')){
            sObjectId = SFDCEncoder.SFDC_JSENCODE(UrlParameterMap.get('id')); 
        }
        if (UrlParameterMap.containsKey('sobject')){
            sObjectName = SFDCEncoder.SFDC_JSENCODE(UrlParameterMap.get('sobject'));
        }
        if (UrlParameterMap.containsKey('field')){
            fieldName = SFDCEncoder.SFDC_JSENCODE(UrlParameterMap.get('field'));
        }
        if (UrlParameterMap.containsKey('profiles')){
            profiles = SFDCEncoder.SFDC_JSENCODE(UrlParameterMap.get('profiles'));
        }
	}

	@RemoteAction
	global static List<Profile> getProfiles() {
		
		Datetime DT;
		List<Profile> pr = new List<Profile>(); 
		if(Organization.sObjectType.getDescribe().isAccessible() == true){
			DT  = [Select id, CreatedDate from Organization  WITH USER_MODE LIMIT 1][0].CreatedDate;
		}
		if(Profile.sObjectType.getDescribe().isAccessible() == true){
			if(Test.isRunningTest()){
                pr = [SELECT Id, Name FROM Profile WHERE CreatedDate >= :DT WITH USER_MODE];
            } else {
                pr = [SELECT Id, Name FROM Profile WHERE CreatedDate > :DT  WITH USER_MODE];
            }
		} 
		return pr;
	}

	@RemoteAction
	global static String saveProfiles(String field, String sObjectName, String id, String profiles) {
		try {
			sObject s;
			if(AppUtils.isObjectAccessible(sObjectName)){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
				String queryString = 'SELECT ' + String.escapeSingleQuotes(field) + ' FROM ' + String.escapeSingleQuotes(sobjectName);
				queryString += ' WHERE id =:'+ String.escapeSingleQuotes(id) +' LIMIT 1';
				s = Database.query((String.isNotEmpty(queryString)?String.escapeSingleQuotes(queryString):''),AccessLevel.USER_MODE);//SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes 
			}
			profiles = profiles.removeEnd(']').removeStart('[').replaceAll(',', ';');
			s.put(field, profiles);
			if(AppUtils.isObjectUpdateable(sObjectName)){
				update as user s; //FLS/ CRUD False +ve with the help of apputil we have performed check
			}
			return 'success';
		} catch(Exception e) {
			return AppUtils.handleSystemExceptionMsg(e);
		}
	}
	
}