/*
 	Class that defines a skinny table using data tables
	***********************************************************
	Audit History
	***********************************************************
	04/07/2014		Vineeth Shetty             Created
	*********************************************************** 
*/
global with sharing class SkinnyTableCtrl {
	global SkinnyTableInfo headerValue {get;set;}
	global List<SkinnyTableInfo> tableData {get;set;}
}