/*
 	Class that defines a row of a skinny table
	***********************************************************
	Audit History
	***********************************************************
	04/07/2014		Vineeth Shetty             Created
	*********************************************************** 
*/
global with sharing class SkinnyTableInfo {
	global List<RowCell> row {get;set;}
	
	global SkinnyTableInfo (){
		row = new List<RowCell>();
	}
	
	global void addStringRowCell(string rowCellValue){
		row.add(new RowCell(rowCellValue));
	}

	/*
		Class defines each cell in a row
	*/
	global with sharing class RowCell {
		global String stringCell {get;set;}
		
		global rowCell(String rowCellValue){
			this.stringCell = rowCellValue;
		}
	}	
}