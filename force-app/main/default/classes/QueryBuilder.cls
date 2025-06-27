/**
*************************************************
Audit History
*************************************************
2018-06-06     Shantanu Gadhe         Created
*************************************************
**/
public with sharing class QueryBuilder{

    public String strFields;
    public String strQuery;
    public String strsObjectName;
    public String strFilterClause;
    public Integer limitValue;
    public String strSortField;    
    public String strSortOrder;
    public Boolean nullsFirst;
    public String strGroupBy;
    public integer offSet;
    public List<SObject> resultList;


    public QueryBuilder addFields(List<String> lstFields){
        // Explaination for Line # 28 
        // Step 1 : Join to make a string out of the given List :-- String.join(new List<string>(lstFields),',')
        // Step 2 : Trim and delete all unnecessary whiteSpaces in the generated String :-- .trim().deleteWhitespace()
        // Step 3 : Getting back the List (in the arg) with all Whitespaces removed :-- .split( ',')
        lstFields  = String.join(lstFields,',').trim().deleteWhitespace().split(','); 

        // Step 4 : Join to make a string out of the given List without any duplicate Field : String.join(new List<string>(new set<string>(lstFields)),',')
        // new set<string>(lstFields) is used only to remove the duplicate fields present in the Given List, If any.
        this.strFields = String.join(new List<string>(new set<string>(lstFields)),',');
        return this;
    }   

    public QueryBuilder addFields(String strFields){
        this.strFields = strFields.trim().deleteWhitespace().removeEnd(',');
        return this.addFields(this.strFields.split(','));
        //return this;
    }

    public QueryBuilder addContentFields(List<String> lstFields){
        
        this.strFields = 'Id,Title,Content,TextPreview,SharingPrivacy,FileType,CreatedDate,LastViewedDate,CreatedById,CreatedBy.Name,OwnerId,LastModifiedDate,Owner.Name';
        return this;
    } 
    
    public QueryBuilder addFilter(String strFilterClause){
        this.strFilterClause = strFilterClause;
        return this;
    }

    public QueryBuilder setNullOrder(String strNullValuesOrder){
        
        if(strNullValuesOrder.equals('FIRST')){
            this.nullsFirst = true;
            return this;
        }else{
             this.nullsFirst = false;
            return this;
        }
    }
    
    public QueryBuilder nullsFirst(){
        this.nullsFirst = true;
        return this;
    }

    public QueryBuilder nullsLast(){
        this.nullsFirst = false;
        return this;
    }

    public QueryBuilder setsObject(String strsObjectName){
        this.strsObjectName = strsObjectName;
        return this;
    }

    public QueryBuilder setLimit(Integer limitValue){
        this.limitValue = limitValue;
        return this;
    }

    public QueryBuilder setSortField(String strSortField){
        this.strSortField = strSortField;
        return this;
    }

    public QueryBuilder setOrder(String strSortOrder){
        this.strSortOrder = strSortOrder;
        return this;
    }

    public QueryBuilder setGroupBy(String strGroupBy){
        this.strGroupBy = strGroupBy;
        return this;
    }

    public QueryBuilder setOffset(integer offSet){
        this.offSet = offSet;
        return this;
    }

    public QueryBuilder createQuery(){
        this.strQuery = 'SELECT ' + string.escapeSingleQuotes(this.strFields) + ' FROM ' + string.escapeSingleQuotes(this.strsObjectName);
        if(String.isNotBlank(this.strFilterClause))
            this.strQuery += ' WHERE ' + AppUtils.parseWhereClause(this.strFilterClause.trim());
            /* this.strQuery += ' WITH SECURITY_ENFORCED'; removing this as this is dynamic query and for Note 
           and attachment object it contains polymorphic field which break our funtionality*/ 
        if(String.isNotBlank(this.strGroupBy))
            this.strQuery += ' GROUP BY ' + string.escapeSingleQuotes(this.strGroupBy);
        if(String.isNotBlank(this.strSortField)){
            this.strQuery += ' ORDER BY ' + string.escapeSingleQuotes(this.strSortField);
            if(String.isNotBlank(this.strSortOrder)){
                this.strQuery += ' ' + this.strSortOrder;
            }
            if(this.nullsFirst != null){
                this.strQuery += ((this.nullsFirst == true) ? ' NULLS FIRST ' : ' NULLS LAST ');
            }
        }
        if(this.limitValue != null && this.limitValue != 0 ){
            this.strQuery += ' LIMIT ' + Integer.valueOf(this.limitValue);
            if(this.offSet != null){
                this.strQuery += ' OFFSET ' + Integer.valueOf(this.offSet);
            }
        }
        return this;
    }


    public List<SObject> execute(){
        resultList = Database.Query(strQuery,AccessLevel.USER_MODE);   //SOQL Injection - False +ve - escapeSingleQuotes Applied on whereClause values using  AppUtils.parseWhereClause method(in createQuery() method) to prevent SOQL injection, Dynamic Part of query is escapeSingleQuotes.
        return resultList;
    }

    public Map<Id,SObject> execute(String identifier){ // Argument 'identifier' is just to identify that this method is invoked, as Apex do not allow Polymorphism on RetunType
        resultList = Database.Query(strQuery,AccessLevel.USER_MODE);  //SOQL Injection - False +ve - escapeSingleQuotes Applied on whereClause values using  AppUtils.parseWhereClause method(in createQuery() method) to prevent SOQL injection, Dynamic Part of query is escapeSingleQuotes.
        Map<Id,SObject> resultMap = new Map<Id,SObject>(resultList);
        return resultMap;
    }
}