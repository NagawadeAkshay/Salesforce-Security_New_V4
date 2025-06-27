/*
    Used by approval request template to redirect the user to the correct
    sobject based on a given work instance item id.

    ***********************************************************
    Audit History
    ***********************************************************
    06/16/2014      Shah Kadirmohideen				Created
    *********************************************************** 
*/
public with sharing class ApprovalWorkItemRedirectCtrl {
	private String workItemId; //18 char id from Work Instance Item Object

	public ApprovalWorkItemRedirectCtrl() {
		this.workItemId = SFDCEncoder.SFDC_JSENCODE(ApexPages.currentPage().getParameters().get('id'));//NOPMD ApexXSSFromURLParam - False +Ve - We are using custom method for encoding 
	}

	public PageReference redirect() {
		List<ProcessInstanceWorkitem> items = new List<ProcessInstanceWorkitem>();	
		if(ProcessInstanceWorkitem.sObjectType.getDescribe().isAccessible() == true){
			items = [Select Id from ProcessInstanceWorkitem 
					where Id=:workItemId WITH USER_MODE];
		}
		if (items.size() == 0) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record not found in ProcessInstanceWorkitem object. Id=' + workItemId));
			return null;
		}
		this.workItemId = items.get(0).Id;
		List<Task> tasks = new List<Task>();
		if(Task.sObjectType.getDescribe().isAccessible() == true){
			tasks = [Select WhatId from Task where WorkItemId__c=:workItemId WITH USER_MODE limit 1];
		}
		if (tasks.size() == 0) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Task not found for process instance work item: ' + workItemId));
			return null;
		}
		else {
			Task t = tasks.get(0);
			PageReference nextPage = new PageReference(URL.getOrgDomainURL().toExternalForm() +'/' + t.WhatId); // ApexOpenRedirect  - False +Ve
			return nextPage;
		}
	}
}