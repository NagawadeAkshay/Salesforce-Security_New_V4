/**
* To handle an action for Approval Decision
* CHANGE HISTORY
* =============================================================================
* Date          Name                    Description
* 02/13/2018    Shantanu Gadhe          Created
* =============================================================================
*/
global abstract with sharing class ApprovalDecisionActionHandler{

global Id selectedRecordId;
/*
Approval Action choosen
*/
global String selectedAction;


/*
This method will be used when some action is performed,and you want to stay on the same page with confirmation 
message which is returned by this method
*/
global abstract String execute();


}