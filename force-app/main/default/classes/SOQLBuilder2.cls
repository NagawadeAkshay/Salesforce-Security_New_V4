public with sharing class SOQLBuilder2 {
	private String selectObject;
	private Set<String> selectFields = new Set<String>();
	private List<Condition> whereClauses = new List<Condition>();

	public SOQLBuilder2() {		
	}

	public SOQLBuilder2 fromx(String selectObject) {
		this.selectObject = selectObject;
		return this;
	}

	public SOQLBuilder2 selectx(Set<String> selectFieldSet) {
		if(selectFieldSet!=null && selectFieldSet.size()>0){
			for(String selectField : selectFieldSet){
				selectFields.add(String.EscapeSingleQuotes(selectField));
			}			
		}
		return this;
	}

	public SOQLBuilder2 selectx(String selectField) {
	if(!String.isEmpty(selectField)){
		selectFields.add(string.escapeSingleQuotes(selectField));
	}
	return this;
 	}

	public SOQLBuilder2 wherex(String fieldName, String operator, Object fieldValue, String joinClause) {
		whereClauses.add(new Condition(fieldName, operator, fieldValue, joinClause));
		return this;
	}

	public String toSoql() {		
		String soql = 'Select ' + AppUtils.concatenate(selectFields, ', ') + ' from ' + selectObject;
				
		if (whereClauses.size() > 0) {
			soql += ' where ';
		}
		for (Condition whereClause : whereClauses) {
			soql += whereClause.toSoql(); //WITH SECURITY_ENFORCED - removed this as this was breaking Application PDF
		}		
		return soql;
	}

	/* PRIVATE METHODS */

    public with sharing class Condition {
    	public String fieldName;
    	public String operator;  //=, like (Note: in operator is currently not supported)
    	public Object fieldValue;
    	public String joinClause;  //AND, OR

    	public Condition(String fieldName, String operator, Object fieldValue, String joinClause) {
    		this.fieldName = string.escapeSingleQuotes(fieldName);
    		this.operator = operator;
    		this.fieldValue = fieldValue;
    		this.joinClause = joinClause;
    	}

    	public String toSoql() {
			String soql = fieldName + ' ' + operator + ' ' + convertString() + ' ';
			if (!String.isEmpty(joinClause)) {
				soql += joinClause + ' ';
			}
			return soql;
		}

		//Private methods

	    private String convertString() {
	        if(fieldValue instanceof String  || fieldValue instanceOf ID) {
	        	String str = '\'';
	        	if (operator == 'like') {
	        		str += '%';
	        	}
	        	if( fieldValue != null && fieldValue != ''){
		            str += String.escapeSingleQuotes((String) fieldValue);
	        	}
	        	if (operator == 'like') {
	        		str += '%';
	        	}
	        	str += '\'';
	        	return str;
	        } 
	        else if(fieldValue instanceOf Boolean ||
	                    fieldValue instanceOf Integer || 
	                    fieldValue instanceOf Long    || 
	                    fieldValue instanceOf Double  || 
	                    fieldValue instanceOf Decimal) {
	            return String.valueOf(fieldValue);
	        } 
	        else if(fieldValue instanceOf Date) {
	            return Datetime.newInstance(((Date)fieldValue).year(), ((Date)fieldValue).month(), ((Date)fieldValue).day()).format('yyyy-MM-dd');
	        } 
	        else if(fieldValue instanceOf Datetime) {
	            return ((Datetime) fieldValue).format('yyyy-MM-dd') + 'T' + ((Datetime) fieldValue).format('hh:mm:ss') + 'Z';
	        } 
	        else {
	            throw new AppUtils.ValidationException('invalid data type for fieldValue parameter: ' + fieldValue);
	        }

	    }

    }

}