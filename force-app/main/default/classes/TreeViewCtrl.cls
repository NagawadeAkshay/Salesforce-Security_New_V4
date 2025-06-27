/*
    Class which provide All Parent Account  with Child Account in wrapperList
    to create Account Hierarchy no AccountTreeView PAge
    **********************************************************
    Audit History
    
    **********************************************************
    2017-05-15         Shantanu Gadhe            Created.             
    **********************************************************  
*/
global with sharing class TreeViewCtrl{
    private static Map<Id, Boolean> toggleIconMap = new Map<Id, Boolean>(); 

    @RemoteAction
    global static Map<String, Object> getAccountHierarchy( Map<String, Object> colParamMap){
        String objectAPIName = String.valueOf(colParamMap.get('objectAPIName'));
        String selfLookupFieldAPIName = String.valueOf(colParamMap.get('selfLookupFieldAPIName'));
        String filterClause = String.valueOf(colParamMap.get('filterClause'));
        Map<String,Object> retVal = new Map<String,Object>();       
        Map <Id, sObject> parentAccountsMap = new Map <Id, sObject>();       
        parentAccountsMap = getParentAccounts(objectAPIName, selfLookupFieldAPIName, filterClause); 
        String query = 'SELECT id, Name, '+ string.escapeSingleQuotes(selfLookupFieldAPIName) +' FROM '+ string.escapeSingleQuotes(objectAPIName) + ' Where ' + string.escapeSingleQuotes(selfLookupFieldAPIName) + ' != null ';
        if(String.isNotEmpty(filterClause)){
           query += ' AND '+ AppUtils.parseWhereClause(filterClause);
        }
        List<sObject> childAccounts = Database.query(query,AccessLevel.USER_MODE);  //SOQL Injection - False +ve - escapeSingleQuotes Applied on filterClause values using  AppUtils.parseWhereClause method to prevent SOQL injection                                            
        Map<String, List<sObject>> childAccountMap = prepareAccountHierarchyMap( childAccounts, selfLookupFieldAPIName ); 
        //WrapperList with all parent and child wrappers
        List<TreeWrapper> TreeWrapperList = new List<TreeWrapper>();
        for(String id : parentAccountsMap.KeySet()) {
            sObject  sobj = parentAccountsMap.get(id);
            if(sobj.get(selfLookupFieldAPIName) == null && childAccountMap.get(id) == null){
                TreeWrapper pw = new TreeWrapper(sObj);
                TreeWrapperList.add(pw); 
            }    
        }      
        for(String parentId:childAccountMap.KeySet()){
            if(parentAccountsMap.get(parentId) != null){
                TreeWrapper pd = new TreeWrapper(parentAccountsMap.get(parentId));
                processChildAccount(pd,childAccountMap);
                TreeWrapperList.add(pd);
            } 
        }                                               
        retVal.put('AccountHierarchy',TreeWrapperList);
        retVal.put('ToggleIconMap',toggleIconMap);   
        return retVal;
    }
    
    private static void processChildAccount(TreeWrapper parentTreeWrapper, Map<String, List<sObject>> childAccountMap) {       
        if(parentTreeWrapper != null && parentTreeWrapper.id != null && childAccountMap!= null) {
            toggleiconMap.put(parentTreeWrapper.id,false);
            // getting all child accounts associated with this parent accounts . 
            List<sObject> childAccounts = childAccountMap.get(parentTreeWrapper.id);
            parentTreeWrapper.hasChildren = false;
            if(childAccounts != null && !childAccounts.isEmpty()) {
                parentTreeWrapper.hasChildren = true;
                for(sObject pc : childAccounts) {
                    toggleIconMap.put((String)pc.get('id'), false);
                    TreeWrapper pd = new TreeWrapper(pc);
            
                    // Call method for processing child accounts records.
                    processChildAccount(pd, childAccountMap);
                    
                    // Adding the Account wrapper as child to the parent accounts wrapper.
                    parentTreeWrapper.addChild(pd);
                }
            }
        }
    }
    
    private static Map<String, List<sObject>> prepareAccountHierarchyMap(List<sObject> accountList, String selfLookupFieldAPIName) {               
        Map<String, List<sObject>> childAccountMap = new Map<String, List<sObject>>();      
        for(sObject pc : accountList) {                      
                if(childAccountMap.get((String)pc.get(selfLookupFieldAPIName))  == null) {
                    childAccountMap.put((String)pc.get(selfLookupFieldAPIName), new List<sObject>());
                }
                childAccountMap.get((String)pc.get(selfLookupFieldAPIName)).add(pc);
        }
        return childAccountMap;
    }
    
    private static Map<Id,sObject> getParentAccounts(String objectAPIName, String  selfLookupFieldAPIName, String filterClause){
        String query = 'SELECT id, Name, '+ string.escapeSingleQuotes(selfLookupFieldAPIName) +' FROM '+ string.escapeSingleQuotes(objectAPIName) + ' Where ' + string.escapeSingleQuotes(selfLookupFieldAPIName) + ' = null ';
        if(String.isNotEmpty(filterClause)){
            query  += ' AND ' + AppUtils.parseWhereClause(filterClause);
        }
        List<sObject> parentAccountsList = Database.query(query,AccessLevel.USER_MODE);//SOQL Injection - False +ve - escapeSingleQuotes Applied on filterClause values using  AppUtils.parseWhereClause method to prevent SOQL injection
        Map<Id,sObject> parentAccountMap = new Map<Id,sObject>();
        for(sObject parentAcc : parentAccountsList){
           parentAccountMap.put(parentAcc.id, parentAcc);
        }
        return parentAccountMap;
    }
   
    public with sharing class TreeWrapper{
        public ID Id;
        public string text;
        public sObject account;
        public List<TreeWrapper> nodes;
        public boolean hasChildren;
        
        public TreeWrapper(sObject account) {
            this.id = account.Id;
            this.text= String.valueOf(account.get('Name'));
            this.account =account;            
        }
        
        public void addChild(TreeWrapper child) {
            if(this.nodes == null){
                this.nodes= new List<TreeWrapper>();
            }
            this.nodes.add(child);
        }
    }

}