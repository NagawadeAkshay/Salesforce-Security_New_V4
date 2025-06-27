/*
* test change
*/
public with sharing class AccountHierarchyCtrl{


    public AccountHierarchyCtrl(ApexPages.StandardController controller) {

    }

    public AccountHierarchyCtrl(){}
    
    public static String selectedAccountId;
    public static String rootAccountId;
    public static Map<Id,Set<Id>> selectedToItsParentsMap;
    public static Boolean selectedExpanded;
 
   
    public static Map<String,Object> getAccountHierarchy(String accountId,String treeFilter){
    	selectedExpanded = false;
    	selectedToItsParentsMap = new Map<Id,Set<Id>>();
    	selectedAccountId = accountId;
        Map<String,Object> retVal = new Map<String,Object>();
        AccountHierarchyCtrl actrl = new AccountHierarchyCtrl();
        Set<Id> currentParentSet = new Set<Id>(); 
        Account rootAccount = actrl.getRootAccount(accountId); 
        rootAccountId = rootAccount.Id;
        currentParentSet.add(rootAccount.Id);
        String query ='Select Name,ParentId,Parent.Name, Id From Account Where ParentId != null'; 
        if(String.isNotBlank(treeFilter)){
            query += ' AND '+ AppUtils.parseWhereClause(treeFilter); //SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of treefilter clause
        }
        if(AppUtils.isObjectAccessible('Account')){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
            List<Account> childAccounts = Database.query(query, AccessLevel.USER_MODE);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes //CRUD/FLS False +ve with the help of AppUtils we have performed check
	        Map<String, List<Account>> childAccountMap = actrl.prepareAccountHierarchyMap(childAccounts);
	        
	        List<TreeWrapper> TreeWrapperList = new List<TreeWrapper>();
	        
	        TreeWrapper pd = new TreeWrapper(rootAccount);
	        
	        // Call method for processing child accounts   records.
	        actrl.processChildAccount(pd, childAccountMap);
	        
	        TreeWrapperList.add(pd);
	        
	        retVal.put('AccountHierarchy',TreeWrapperList);
        }                                                  
        return retVal;
    }
    public static Map<String,Object> getAccountHierarchyLwc(String accountId,String treeFilter){
    	selectedExpanded = false;
    	selectedToItsParentsMap = new Map<Id,Set<Id>>();
    	selectedAccountId = accountId;
        Map<String,Object> retVal = new Map<String,Object>();
        AccountHierarchyCtrl actrl = new AccountHierarchyCtrl();
        Set<Id> currentParentSet = new Set<Id>(); 
        Account rootAccount = actrl.getRootAccount(accountId); 
        rootAccountId = rootAccount.Id;
        currentParentSet.add(rootAccount.Id);
        String query ='Select Name,ParentId,Parent.Name, Id From Account Where ParentId != null'; 
        if(String.isNotBlank(treeFilter)){
            query += ' AND '+ AppUtils.parseWhereClause(treeFilter); //SOQL Injection - False +ve - Using AppUtils.parseWhereClause method to applying escapeSingleQuotes to each value of treefilter clause
        }
        if(AppUtils.isObjectAccessible('Account')){ //CRUD/FLS False +ve with the help of AppUtils we have performed check
            List<Account> childAccounts = Database.query(query, AccessLevel.USER_MODE);  //SOQL Injection - False +ve - Dynamic part of query is escapeSingleQuotes //CRUD/FLS False +ve with the help of AppUtils we have performed check
	        Map<String, List<Account>> childAccountMap = actrl.prepareAccountHierarchyMap(childAccounts);
	        
	        List<TreeWrapper> TreeWrapperList = new List<TreeWrapper>();
	        
	        TreeWrapper pd = new TreeWrapper(rootAccount);
	        
	        // Call method for processing child accounts   records.
	        actrl.processChildAccount(pd, childAccountMap);
	        
	        TreeWrapperList.add(pd);
	        
	        retVal.put('AccountHierarchy',TreeWrapperList);
        }                                                  
        return retVal;
    }
    private void processChildAccount(TreeWrapper parentTreeWrapper, Map<String, List<Account>> childAccountMap) {
        
        if(parentTreeWrapper != null && parentTreeWrapper.id != null && childAccountMap!= null) {
           
            // getting all child accounts associated with this parent accounts . 
            List<Account> childAccounts = childAccountMap.get(parentTreeWrapper.id);
            parentTreeWrapper.hasChildren = false;          
            if(childAccounts != null && !childAccounts.isEmpty() ) {
                 parentTreeWrapper.hasChildren = true;                
                for(Account pc : childAccounts ) {                	
                    TreeWrapper pd = new TreeWrapper(pc);                                                                               
            
                    // Call method for processing child accounts records.
                    processChildAccount(pd, childAccountMap);
                    
                    // Adding the Account wrapper as child to the parent accounts wrapper.
                    
                    parentTreeWrapper.addChild(pd);
                }
            }
        }
    }
    private Map<String, List<Account>> prepareAccountHierarchyMap(List<Account> accountList) {
        
        Map<String, List<Account>> childAccountMap = new Map<String, List<Account>>();
        
        for(Account pc : accountList) {
            
            if(pc.ParentId!= null) {
                List<Account> childAccountList = childAccountMap.get(pc.ParentId);
                if(childAccountList  == null) {
                    childAccountList = new List<Account>();
                    childAccountMap.put(pc.ParentId, childAccountList );
                }
                childAccountList.add(pc);
            }
        }
        return childAccountMap;
    }
    private Account getRootAccount(String accountId){
        Account a;
        Boolean root = false;
        while (!root){
    	if(AppUtils.isObjectAccessible('Account')){ //CRUD/FLS False +ve with the help of AppUtils we have performed check       
            a = [ Select a.Id, a.ParentId,a.Name From Account a where a.Id =: accountId WITH USER_MODE limit 1]; //SF Seq review //SOQL Injection - False +ve - Dynamic part of query is static bind 
            if (a.ParentId != null ){
                accountId = a.ParentId;
            }else{
                root= true;
            }
        }            
        }        
        return a;
    }
    public with sharing class TreeWrapper{
        public ID Id {get;set;}       
        public string text{get;set;}
        public Account account {get;set;}
        public List<TreeWrapper> nodes{get;set;}
        public boolean hasChildren{get;set;}
        //public NodeStates state{get;set;}        
        
        public TreeWrapper(Account account) {
            this.id = account.Id;
            this.text = account.Name;                      
            this.account =account;
            this.text = this.text.trim();
            //this.text = '<a href=# >'+this.text+'</a>';
            //this.state = new NodeStates(false);
                         
        }
        
        public void addChild(TreeWrapper child) {
            if(this.nodes == null){
                this.nodes= new List<TreeWrapper>();
            }
            this.nodes.add(child);
        }
    }
    
}