global with sharing class BusinessRuleResult {
	global List<String> errors {get; set;}

	global BusinessRuleResult() {
		this.errors = new List<String>();
	}

	global Boolean hasErrors() {
		return errors.size() > 0;
	}

	global void addErrorsToPage() {
		for (String  errorMsg : errors) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
		}
	}
}