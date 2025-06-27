/**
**/
global with sharing class FlexGridSearchCtrl {
    public String keyValueMap{get;set;}
    public String searchTerm{get;set;}
    public String html = '';
    public Component.Apex.OutputPanel body;    
    public String parentFilterClause;
    public String childFilterClause;
    public String grandChildFilterClause;
    public String childClause;
    public String grandCNewClause;
    List<FlexGridConfig__c> flexGridConfigData;
    
    global FlexGridSearchCtrl(){
        String parentFlexTableId;
        String childFlexTableId;
        String grandChilFlexTableId;
        List<String> flexTablesIds = new List<String>();
        List<DataTableConfig__c> allFilterCriteria = new List<DataTableConfig__c>();
        
        String gridName = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('gridName'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        searchTerm = SFDCEncoder.SFDC_JSENCODE(ApexPages.CurrentPage().getParameters().get('searchTerm'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        keyValueMap = SFDCEncoder.sanitizeJSON(ApexPages.CurrentPage().getParameters().get('keyValueMap'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible() && Schema.sObjectType.FlexGridConfig__c.fields.Name.isAccessible()){
        	flexGridConfigData = [SELECT Child1FlexTable__c,GrandChild1FlexTable__c,ParentFlexTable__c,Id, Child1FlexTable__r.Name,GrandChild1FlexTable__r.Name,ParentFlexTable__r.Name,Child1FlexTable__r.Header__c,GrandChild1FlexTable__r.Header__c,ParentFlexTable__r.Header__c 
							FROM FlexGridConfig__c WHERE Name =: gridName WITH USER_MODE];
		}
		if(flexGridConfigData.size() > 0) {
        if(flexGridConfigData[0].ParentFlexTable__c != null) {
        	flexTablesIds.add(flexGridConfigData[0].ParentFlexTable__c);
        	parentFlexTableId = flexGridConfigData[0].ParentFlexTable__c;
        }
        if(flexGridConfigData[0].Child1FlexTable__c != null) {
        	flexTablesIds.add(flexGridConfigData[0].Child1FlexTable__c);
        	childFlexTableId = flexGridConfigData[0].Child1FlexTable__c;
        }
        if(flexGridConfigData[0].GrandChild1FlexTable__c != null) {
        	flexTablesIds.add(flexGridConfigData[0].GrandChild1FlexTable__c);
        	grandChilFlexTableId = flexGridConfigData[0].GrandChild1FlexTable__c;
        }
		}
        if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
        allFilterCriteria = [SELECT Id,FilterCriteria__c, (SELECT Id,Name,Label__c,FilterClause__c,IsActive__c,IsDefault__c,IsMasterView__c 
                                FROM Flex_Table_Filter_List_View_Configs__r), (SELECT Id,Name,User__c,FlexTableListViewConfig__r.Label__c,FlexTableListViewConfig__r.FilterClause__c                                
                                FROM Flex_Table_List_View_User_Configs__r)
                                 FROM DataTableConfig__c WHERE Id IN: flexTablesIds WITH USER_MODE];
		}
                                 
		for(DataTableConfig__c flexTableConfig : allFilterCriteria){
	        String flexListViewConfigClause;
	        String flexListViewUserConfigClause; 			
			if(flexTableConfig.Flex_Table_Filter_List_View_Configs__r.size() > 0 ){
				flexListViewConfigClause = flexTableConfig.Flex_Table_Filter_List_View_Configs__r[0].FilterClause__c;
			}
			
			if(flexTableConfig.Flex_Table_List_View_User_Configs__r.size() > 0 ){
				flexListViewUserConfigClause = flexTableConfig.Flex_Table_List_View_User_Configs__r[0].FlexTableListViewConfig__r.FilterClause__c;
			}
			
			String filterClause = (String.isNotEmpty(flexListViewConfigClause)) ? flexListViewConfigClause :
									(String.isNotEmpty(flexListViewUserConfigClause)) ? flexListViewUserConfigClause : flexTableConfig.FilterCriteria__c;

			if(flexTableConfig.Id == parentFlexTableId) {
				parentFilterClause = filterClause;	
			}else if(flexTableConfig.Id == childFlexTableId) {
				childFilterClause = filterClause;
			}else if(flexTableConfig.Id == grandChilFlexTableId){
				grandChildFilterClause = filterClause;
			}
			if(flexTableConfig.Id == childFlexTableId && flexTableConfig.Id == grandChilFlexTableId) {
				grandChildFilterClause = filterClause;
			}
		}
        this.body = new Component.Apex.OutputPanel();    
        if(childFilterClause != null) {
        	createChildLevelFilterClause();
        }
        if(grandChildFilterClause != null) {
        	createGrandChildLevelFilterClause();
        }
    }
    
    private void createChildLevelFilterClause() {
    	String parentFilterClauseNew = parentFilterClause;
    	String childFilterClauseNew = childFilterClause;
    	String relationshipField;
    	String replaceParentId = '\\s*=\\s*\'parentId\'';
    	
    	Pattern regexReplaceParentId = Pattern.compile(replaceParentId);
		Matcher regexMatcherId = regexReplaceParentId.matcher(childFilterClauseNew);
    	while(regexMatcherId.find()){//SOQL/SOSL Injection False +ve
    		String fieldname = regexMatcherId.group();
    		List<String> newList = new List<String>();
    		newList = childFilterClauseNew.split(fieldname);
    		childFilterClauseNew = newList[0]+ ' != NULL ';
    		if(newList.size() > 1) {
    			childFilterClauseNew += newList[1];  	
    		}
    		relationshipField = newList[0];
    		if(relationshipField.contains('__c')) {
    		relationshipField = relationshipField.replace('__c','__r.');
    		}else {
    			relationshipField = relationshipField.remove('Id');
    			relationshipField = relationshipField + '.';
    		}
    	}
		String parentLevelClause = createFilterClause(relationshipField,parentFilterClauseNew);
		childClause = childFilterClauseNew + ' AND ' + parentLevelClause;
		}
		
    private void createGrandChildLevelFilterClause(){
		String parentFilterClauseNew = parentFilterClause;
		String childFilterClauseNew = childFilterClause;    	
    	String grandChildFilterClauseNew = grandChildFilterClause;
		String childClausePart1;
    	String relationshipFieldGC;
		
    	String replaceParentId = '\\s*=\\s*\'parentId\'';
    	Pattern regexReplaceParentId = Pattern.compile(replaceParentId);
		Matcher regexMatcherId = regexReplaceParentId.matcher(grandChildFilterClauseNew);
    	while(regexMatcherId.find()){//SOQL/SOSL Injection False +ve
    		String fieldname = regexMatcherId.group();
    		List<String> newList = new List<String>();
    		newList = grandChildFilterClauseNew.split(fieldname);
    		childClausePart1 = newList[0]+ ' != NULL ';
    		if(newList.size() > 1) {
    			childClausePart1 += newList[1];  	
    		}
    		relationshipFieldGC = newList[0];
    		if(relationshipFieldGC.contains('__c')) {
    		relationshipFieldGC = relationshipFieldGC.replace('__c','__r.');
    		}else {
    			relationshipFieldGC = relationshipFieldGC.remove('Id');
    			relationshipFieldGC = relationshipFieldGC + '.';
    		}
    	}
		
		String relationshipFieldC;
		String regex = '\\w+__c';
    	String regex1 = '\\b+[(\\w.\\w)]+[^__c\\s][^__r\\s]\\s*=';
    	String regex2 = '\\b+[(\\w.\\w)]+[^__c\\s][^__r\\s]\\s*!=';    	
		String replacefieldname;
		String replacedField;
		String childClausePart2;
		Pattern regexReplaceParentId1 = Pattern.compile(replaceParentId);
		Matcher regexMatcherId1 = regexReplaceParentId1.matcher(childFilterClauseNew);
		while(regexMatcherId1.find()){//SOQL/SOSL Injection False +ve
    		String fieldname = regexMatcherId1.group();
    		List<String> newList = new List<String>();
    		newList = childFilterClauseNew.split(fieldname);
    		childClausePart2 = relationshipFieldGC+newList[0]+ ' != NULL ';
    		if(newList.size() > 1) {
				Pattern regexPattern2 = Pattern.compile(regex);
				Matcher regexMatcher2 = regexPattern2.matcher(newList[1]);
				while(regexMatcher2.find()){//SOQL/SOSL Injection False +ve
					replacefieldname = regexMatcher2.group();
					replacedField = relationshipFieldGC+replacefieldname;
					childClausePart2 += newList[1].replace(replacefieldname,replacedField);
				}
    		}
    		relationshipFieldC = newList[0];
    		if(relationshipFieldC.contains('__c')) {
    		relationshipFieldC = relationshipFieldC.replace('__c','__r.');
    		}else {
    			relationshipFieldC = relationshipFieldC.remove('Id');
    			relationshipFieldC = relationshipFieldC + '.';
    	}
    	}/*
    	//Do not delete
		Pattern regexPattern5 = Pattern.compile(regex1);
		Matcher regexMatcher5 = regexPattern5.matcher(childClausePart2);
		while(regexMatcher5.find()){
			replacefieldname = regexMatcher5.group();
			replacedField = relationshipFieldGC+replacefieldname;
			childClausePart2 = childClausePart2.replace(replacefieldname,replacedField);
		}
		Pattern regexPattern6 = Pattern.compile(regex2);
		Matcher regexMatcher6 = regexPattern6.matcher(childClausePart2);
		while(regexMatcher6.find()){
			replacefieldname = regexMatcher6.group();
			replacedField = relationshipFieldGC+replacefieldname;
			childClausePart2 = childClausePart2.replace(replacefieldname,replacedField);
		}
		*/
		String parentLevelClause = createFilterClause(relationshipFieldGC+relationshipFieldC,parentFilterClauseNew);
		grandCNewClause = childClausePart1 + ' AND ' + childClausePart2 + ' AND ' +  parentLevelClause;
		}
		
	private String createFilterClause(String relationshipFieldName, String filterClause) {
		String regex = '\\w+__c';
		String regex1 = '\\b+[(\\w.\\w)]+[^__c\\s][^__r\\s]\\s*=';
		String regex2 = '\\b+[(\\w.\\w)]+[^__c\\s][^__r\\s]\\s*!=';    	
		String replacefieldname;
		String replacedField;
			
		Pattern regexPattern = Pattern.compile(regex);
		Matcher regexMatcher = regexPattern.matcher(filterClause);
		while(regexMatcher.find()){//SOQL/SOSL Injection False +ve
			replacefieldname = regexMatcher.group();
			replacedField = relationshipFieldName+replacefieldname;
			filterClause = filterClause.replace(replacefieldname,replacedField);
		}
		
		Pattern regexPattern1 = Pattern.compile(regex1);
		Matcher regexMatcher1 = regexPattern1.matcher(filterClause);
		while(regexMatcher1.find()){//SOQL/SOSL Injection False +ve
			replacefieldname = regexMatcher1.group();
			replacedField = relationshipFieldName+replacefieldname;
			filterClause = filterClause.replace(replacefieldname,replacedField);
		}
		
		Pattern regexPattern2 = Pattern.compile(regex2);
		Matcher regexMatcher2 = regexPattern2.matcher(filterClause);
		while(regexMatcher2.find()){//SOQL/SOSL Injection False +ve
			replacefieldname = regexMatcher2.group();
			replacedField = relationshipFieldName+replacefieldname;
			filterClause = filterClause.replace(replacefieldname,replacedField);
		}
		return filterClause;
	}
	
    public Component.Apex.OutputPanel getGenerate() {
        html += '<div id="myTabs" class="">';
            renderTabs();
            renderTabBody();
        html += '</div>';   
        addHTMLToBody();
        return body;
    }
    
    private void renderTabs(){          
        html += '<div id="topTabsID">'+
            '<ul class="nav nav-tabs">';
                if(flexGridConfigData[0].ParentFlexTable__c != null && flexGridConfigData[0].ParentFlexTable__r.Name != null) {
                   //html +=  '<li class="active"><a data-toggle="pill" href="#'+ flexGridConfigData[0].ParentFlexTable__c +'Level1">'+flexGridConfigData[0].ParentFlexTable__r.Header__c+'</a></li>';
                    html +=  '<li class="active"><a data-toggle="pill" href="#'+ flexGridConfigData[0].ParentFlexTable__c +'Level1">Level 1</a></li>';
                }
                if(flexGridConfigData[0].Child1FlexTable__c != null && flexGridConfigData[0].Child1FlexTable__r.Name != null) {
                    //html +=  '<li><a data-toggle="pill" href="#'+ flexGridConfigData[0].Child1FlexTable__c +'Level2">'+flexGridConfigData[0].Child1FlexTable__r.Header__c+'</a></li>';
                    html +=  '<li><a data-toggle="pill" href="#'+ flexGridConfigData[0].Child1FlexTable__c +'Level2">Level 2</a></li>';
                }
                if(flexGridConfigData[0].GrandChild1FlexTable__c != null && flexGridConfigData[0].GrandChild1FlexTable__r.Name != null) {
                    //html += '<li><a data-toggle="pill" href="#'+ flexGridConfigData[0].GrandChild1FlexTable__c +'Level3">'+flexGridConfigData[0].GrandChild1FlexTable__r.Header__c+'</a></li>';
                    html += '<li><a data-toggle="pill" href="#'+ flexGridConfigData[0].GrandChild1FlexTable__c +'Level3">Level 3</a></li>';
                }                
            html += '</ul>'+
        '</div>';

    }
    
    private void renderTabBody(){
        html+='<div class="tab-content">';
        if(flexGridConfigData[0].ParentFlexTable__c != null && flexGridConfigData[0].ParentFlexTable__r.Name != null) {
            html+='<div id="'+ flexGridConfigData[0].ParentFlexTable__c +'Level1" class="tab-pane fade in active">';
            renderFlexTableParam(flexGridConfigData[0].ParentFlexTable__c+'Level1',flexGridConfigData[0].ParentFlexTable__r.Name,'',keyValueMap);
            html+='</div>';
        }
        if(flexGridConfigData[0].Child1FlexTable__c != null && flexGridConfigData[0].Child1FlexTable__r.Name != null) {
            html+='<div id="'+ flexGridConfigData[0].Child1FlexTable__c +'Level2" class="tab-pane fade">';
            renderFlexTableParam(flexGridConfigData[0].Child1FlexTable__c+'Level2',flexGridConfigData[0].Child1FlexTable__r.Name,childClause,keyValueMap);
            html+='</div>';
        }
        if(flexGridConfigData[0].GrandChild1FlexTable__c != null && flexGridConfigData[0].GrandChild1FlexTable__r.Name != null) {
            html+='<div id="'+ flexGridConfigData[0].GrandChild1FlexTable__c +'Level3" class="tab-pane fade">';
            renderFlexTableParam(flexGridConfigData[0].GrandChild1FlexTable__c+'Level3',flexGridConfigData[0].GrandChild1FlexTable__r.Name,grandCNewClause,keyValueMap);
            html+='</div>';
        }
        html+='</div>';
    }
    
    private void renderFlexTableParam(String flexTableId, String flexTableName, String ParentClause,String keyValueMap) {
        html += '<div>';
        addHTMLToBody();
        Component.FlexTable c = new Component.FlexTable(
                flexTableName = flexTableName, 
                tableId = flexTableId,
                gridSearchText = searchTerm,
                isModalWindow = true,
                isN2GGridSearch = true,
                filterClauseGridSearch = ParentClause,
                flexTableParameters = keyValueMap
                );
        body.childComponents.add(c);
        html += '</div>';
    }
    
    private void addHTMLToBody() {
        if (String.isNotEmpty(html)) {
            body.childComponents.add(new Component.Apex.OutputText(Value=html, escape=false));
            html = '';
        }       
    }
}