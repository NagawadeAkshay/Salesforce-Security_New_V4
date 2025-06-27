// 04/21/2023       As discussed with Nakul deprecating conga from framework
public with sharing class CongaInvokerCtrl {
	// private String recordId;
	// private String buttonId;
	// private transient CongaURLGenerator generator;
	// public String congaRedirectUrl {get; set;}
	// public String congaFileDownloadUrl {get; set;}

	// public CongaInvokerCtrl() {
	// 	Id recId = ApexPages.currentPage().getParameters().get('recordId');
	// 	this.recordId = recId != null ? String.escapeSinglequotes(recId) : '';
	// 	Id btnId = ApexPages.currentPage().getParameters().get('buttonId');
	// 	this.buttonId = btnId != null ? String.escapeSinglequotes(btnId) : '';
	// }

	// public PageReference redirect() {
	// 	CongaURLGenerator generator = new CongaURLGenerator(recordId, buttonId);
	// 	this.congaRedirectUrl = generator.generateURL();

    //     if (generator.button.CongaDownloadType__c == 'Download to Salesforce') {
    //     	String docName = generator.documentName + '.%';
    //     	if(Schema.sObjectType.Attachment.isDeletable() && Schema.sObjectType.Attachment.isAccessible()){
	// 			delete [SELECT Id FROM Attachment WHERE ParentId=:generator.masterRecord.Id and 
	// 					Name like :docName WITH SECURITY_ENFORCED];
	// 		}

	//         this.congaFileDownloadUrl= '/apex/' + AppUtils.getNamespacePrefix() + 
	//         			'CongaFileDownload?recordId=' + recordId + 
	//         			'&documentName=' + generator.documentName;
    //     }
	// 	return null;
	// }
}