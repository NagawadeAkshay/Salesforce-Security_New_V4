/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global with sharing class PostInstallClass implements System.InstallHandler {
    
    global PostInstallClass() {

    }
    global void onInstall(System.InstallContext context) {
        try{
    		Boolean skipPostInstallScript = false;
    		if(KeyValueStoreHelper.getBooleanValue('skipPostInstallScript', true) != null) {
    			skipPostInstallScript = KeyValueStoreHelper.getBooleanValue('skipPostInstallScript', true);
    		}
    		if(skipPostInstallScript == false) {
    			createFormInstanceTable();
                //copyAttachmentToAttachmentExt();
                createEnhancedAttachmentTable();
                createDisableRecordLocking();
                updateHeaderImagesDocName();
                //createDefaultITextEndpoint(); This method is remvoed for SF review
                createHideFlexTableHeaderForCSVExport(); // Creating Custom Setting in keyValue Store
                createApexBatchEnhancedGrid();
                Boolean versionTestPass = context.previousVersion().compareTo(new Version(4,400)) <= 0 ? true : false;
                if(versionTestPass) {
                    activeBooleanOfBusinessShare();
                }

                Boolean versionTestFourFifty = context.previousVersion().compareTo(new Version(4,450)) <= 0 ? true : false;
                if(versionTestFourFifty) {
                    executeMethod('upsertSobjectPhaseConfigRecords');
                }

                // User Story 91157: Internal - Assignment of Manage Permission Set using Post Install Script and within User Trigger
                assignManageGNTPermissionSet();
           }
         }catch (Exception e){
            CustomExceptions.logException(e,true,false);
         }
    }

    global void executeMethod(String method) {
        if(method == 'upsertSobjectPhaseConfigRecords') {
            upsertSobjectPhaseConfigRecords();
        }
    }

    //User Story 91157: Internal - Assignment of Manage Permission Set using Post Install Script and within User Trigger
    private void assignManageGNTPermissionSet(){
        Map<Id, User> mapUsersByIds = new Map<Id, User>([SELECT Id FROM User WHERE IsActive = TRUE WITH USER_MODE]);//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        SystemContextMethodsHelper.processPermissionSets(mapUsersByIds.keySet());
    }
    	
    private void createFormInstanceTable(){
        String p = AppUtils.getNamespacePrefix();
        List<DataTableConfig__c> dataTableConfig = new List<DataTableConfig__c>();
        if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
        dataTableConfig = [Select id,Name from DataTableConfig__c where Name = 'FormEnhancedTable' WITH USER_MODE];
        }
        if(dataTableConfig.size() > 0 ){
            return;
        }
        DataTableConfig__c formEnhancedTable = new DataTableConfig__c();
        if(Schema.sObjectType.DataTableConfig__c.fields.Name.isCreateable()){
            formEnhancedTable.Name = 'FormEnhancedTable';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.FieldNames__c.isCreateable()){
            formEnhancedTable.FieldNames__c = p+'PackageBusinessForm__r.'+p+'FormConfig__r.Name,'+p+'PackageBusinessForm__r.'+p+'isMandatory__c,'+p+'Percentage__c,'+p+'IsNotApplicable__c,LastModifiedBy.Name,LastModifiedDate';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.FilterCriteria__c.isCreateable()){
            formEnhancedTable.FilterCriteria__c = p+'ParentRecordId__c = \'{!parentId}\'';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Header__c.isCreateable()){
            formEnhancedTable.Header__c = 'Form Enhanced Table';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Description__c.isCreateable()){
            formEnhancedTable.Description__c = 'Enhanced Forms';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.SobjectConfig__c.isCreateable()){
            formEnhancedTable.SobjectConfig__r.Name = p+'FormInstance__c';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.InternalUniqueID__c.isCreateable()){
            formEnhancedTable.InternalUniqueID__c = 'FormEnhancedTable';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.RecordTypeId.isCreateable()){
            formEnhancedTable.RecordTypeId = Schema.sObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Data Table').getRecordTypeId();
        }
        if(Schema.sObjectType.DataTableConfig__c.isCreateable()){
            insert  formEnhancedTable;
        }

        DataTableAction__c viewAction = new DataTableAction__c();
        if(Schema.sObjectType.DataTableAction__c.fields.RecordTypeId.isCreateable()){
            viewAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable()){
            viewAction.ActionBehavior__c = 'Open in same window';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable()){
            viewAction.ActionURLLong__c ='/apex/DynamicFormView?formTypes=&formId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'FormConfig__c}&id={!'+p+'FormInstance__c.'+p+'FormId__c}&templateName={!'+p+'FormInstance__r.'+p+'PackageBusinessForm__r.'+p+'FormConfig__r.Name}&parentLayoutId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'PackageConfig__r.'+p+'PageTemplateConfig__c}&packageId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'PackageConfig__c}&parentId={!'+p+'FormInstance__c.'+p+'ParentRecordId__c}&formInstanceId={!'+p+'FormInstance__c.Id}';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()){
            viewAction.DataTableConfig__c = formEnhancedTable.id;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable()){
            viewAction.IconCSS__c = '<i class="fa fa-eye" ></i>';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable()){
            viewAction.Location__c = 'ROW';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()){
            viewAction.Sequence__c = 1;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable()){
            viewAction.Name = 'View';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable()){
            viewAction.InternalUniqueID__c = 'FormEnhancedTableAction1';
        }

        DataTableAction__c editAction = new DataTableAction__c();
        if(Schema.sObjectType.DataTableAction__c.fields.RecordTypeId.isCreateable()){
            editAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable()){
            editAction.ActionBehavior__c = 'Open in same window';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable()){
            editAction.ActionURLLong__c ='/apex/DynamicFormEdit?formTypes=&formId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'FormConfig__c}&id={!'+p+'FormInstance__c.'+p+'FormId__c}&templateName={!'+p+'FormInstance__r.'+p+'PackageBusinessForm__r.'+p+'FormConfig__r.Name}&parentLayoutId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'PackageConfig__r.'+p+'PageTemplateConfig__c}&packageId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'PackageConfig__c}&parentId={!'+p+'FormInstance__c.'+p+'ParentRecordId__c}&formInstanceId={!'+p+'FormInstance__c.Id}';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()){
            editAction.DataTableConfig__c = formEnhancedTable.id;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable()){
            editAction.IconCSS__c = '<i class="fa fa-pencil" ></i>';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable()){
            editAction.Location__c = 'ROW';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()){
            editAction.Sequence__c = 2;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable()){
            editAction.Name = 'Edit';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable()){
            editAction.InternalUniqueID__c = 'FormEnhancedTableAction2';
        }

        DataTableAction__c previewAction = new DataTableAction__c();
        if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable()){
            previewAction.ActionBehavior__c = 'Open in new window';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable()){
            previewAction.ActionURLLong__c ='/apex/DynamicViewLayout?isPreviewLayout=true&formPackageId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__c}';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()){
            previewAction.DataTableConfig__c = formEnhancedTable.id;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable()){
            previewAction.IconCSS__c = '<i class="fa fa-file-pdf-o"></i>';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable()){
            previewAction.Location__c = 'ROW';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()){
            previewAction.Sequence__c = 3;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable()){
            previewAction.Name = 'Preview';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable()){
            previewAction.InternalUniqueID__c = 'FormEnhancedTableAction3';
        }

        DataTableAction__c downloadAction = new DataTableAction__c();
        if(Schema.sObjectType.DataTableAction__c.fields.RecordTypeId.isCreateable()){
            downloadAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable()){
            downloadAction.ActionBehavior__c = 'Open in new window';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable()){
            downloadAction.ActionURLLong__c ='/apex/DynamicLayoutExport?packageId={!'+p+'FormInstance__c.'+p+'PackageBusinessForm__r.'+p+'PackageConfig__c}&id={!'+p+'FormInstance__c.'+p+'FormId__c}&viewTemplateName={!'+p+'FormInstance__r.'+p+'PackageBusinessForm__r.'+p+'FormConfig__r.Name}';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()){
            downloadAction.DataTableConfig__c = formEnhancedTable.id;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable()){
            downloadAction.IconCSS__c = '<i class="fa fa-cloud-download"></i>';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable()){
            downloadAction.Location__c = 'ROW';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()){
            downloadAction.Sequence__c = 4;
        }
        if(Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable()){
            downloadAction.Name = 'Download';
        }
        if(Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable()){
            downloadAction.InternalUniqueID__c = 'FormEnhancedTableAction4';
        }
        
        if(Schema.sObjectType.DataTableAction__c.isCreateable()){
            insert  viewAction;
            insert  editAction;
            insert  previewAction;
        }
        FlexTableFilterListViewConfig__c listView = new FlexTableFilterListViewConfig__c();
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.IsActive__c.isCreateable()){
        listView.IsActive__c = true;
        }
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.FlexTableConfig__c.isCreateable()){
        listView.FlexTableConfig__c  = formEnhancedTable.id;
        }
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.IsMasterView__c.isCreateable()){
        listView.IsMasterView__c = true;
        }
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.FilterClause__c.isCreateable()){
        listView.FilterClause__c = p+'ParentRecordId__c = \'{!parentId}\'';
        }
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.Label__c.isCreateable()){
        listView.Label__c = 'All Forms';
        }
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.fields.InternalUniqueID__c.isCreateable()){
        listView.InternalUniqueID__c = 'FormEnhancedTableListView1';
        }
        if(Schema.sObjectType.FlexTableFilterListViewConfig__c.isCreateable()){
            insert  listView;
        }
        DataTableDetailConfig__c dataTableDetailConfig = new DataTableDetailConfig__c();
        DataTableDetailConfig__c dataTableDetailConfig1 = new DataTableDetailConfig__c();
        DataTableDetailConfig__c dataTableDetailConfig2 = new DataTableDetailConfig__c();
        DataTableDetailConfig__c dataTableDetailConfig3 = new DataTableDetailConfig__c();

        if(Schema.sObjectType.DataTableDetailConfig__c.fields.FieldAPIName__c.isCreateable()){
            dataTableDetailConfig.FieldAPIName__c = p+'PackageBusinessForm__r.'+p+'FormConfig__r.Name';
            dataTableDetailConfig1.FieldAPIName__c = p+'PackageBusinessForm__r.'+p+'isMandatory__c';
            dataTableDetailConfig2.FieldAPIName__c = p+'IsNotApplicable__c';
            dataTableDetailConfig3.FieldAPIName__c = 'LastModifiedBy.Name';
        }
        if(Schema.sObjectType.DataTableDetailConfig__c.fields.FieldLabelOverride__c.isCreateable()){
            dataTableDetailConfig.FieldLabelOverride__c = 'Form Name';
            dataTableDetailConfig1.FieldLabelOverride__c = 'Is Mandatory?';
            dataTableDetailConfig2.FieldLabelOverride__c = 'Is Not Applicable?';
            dataTableDetailConfig3.FieldLabelOverride__c = 'Last Modified By';
        }
        if(Schema.sObjectType.DataTableDetailConfig__c.fields.FlexTableConfig__c.isCreateable()){
            dataTableDetailConfig.FlexTableConfig__c = formEnhancedTable.id;
            dataTableDetailConfig1.FlexTableConfig__c = formEnhancedTable.id;
            dataTableDetailConfig2.FlexTableConfig__c = formEnhancedTable.id;
            dataTableDetailConfig3.FlexTableConfig__c = formEnhancedTable.id;
        }
        if(Schema.sObjectType.DataTableDetailConfig__c.fields.RenderType__c.isCreateable()){
            dataTableDetailConfig.RenderType__c  = 'Autosuggest';
            dataTableDetailConfig1.RenderType__c  = 'Autosuggest';
            dataTableDetailConfig2.RenderType__c  = 'Autosuggest';
            dataTableDetailConfig3.RenderType__c  = 'Autosuggest';
        }
        if(Schema.sObjectType.DataTableDetailConfig__c.isCreateable()){
            insert  dataTableDetailConfig;
            insert  dataTableDetailConfig1;
            insert  dataTableDetailConfig2;
            insert  dataTableDetailConfig3;
        }
	}
    
        private void createEnhancedAttachmentTable(){
            String nameSpace = AppUtils.getNamespacePrefix();
            List<DataTableConfig__c> dataTableConfig = new List<DataTableConfig__c>();
            if(Schema.sObjectType.DataTableConfig__c.isAccessible()){
            dataTableConfig = [Select id,Name from DataTableConfig__c where Name = 'EnhancedAttachmentTable' WITH USER_MODE];
            }
            List<DataTableAction__c> dataTableActionConfig = new List<DataTableAction__c>();
            if(dataTableConfig.size() > 0 ){
                return;
            }
            DataTableConfig__c formEnhancedTable;
            if(Schema.sObjectType.DataTableConfig__c.fields.Name.isCreateable() && Schema.sObjectType.DataTableConfig__c.fields.FieldNames__c.isCreateable()
            && Schema.sObjectType.DataTableConfig__c.fields.FilterCriteria__c.isCreateable() && Schema.sObjectType.DataTableConfig__c.fields.Header__c.isCreateable()
            && Schema.sObjectType.DataTableConfig__c.fields.Description__c.isCreateable() && Schema.sObjectType.DataTableConfig__c.fields.SobjectConfig__c.isCreateable()
            && Schema.sObjectType.DataTableConfig__c.fields.InternalUniqueID__c.isCreateable()){
                formEnhancedTable = new DataTableConfig__c(Name = 'EnhancedAttachmentTable',FieldNames__c = nameSpace+'AttachmentName__c,'+nameSpace+'Classification__c,'+nameSpace+'Description__c,'+'CreatedById,OwnerId',FilterCriteria__c = nameSpace+'ParentId__c = \'{!RecordId}\'',Header__c = 'Enhanced Attachment Table',Description__c = 'Enhanced Attachment Table',SobjectConfig__c = nameSpace+'AttachmentExtension__c',InternalUniqueID__c = 'EnhancedAttachmentTable',RecordTypeId = Schema.sObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Data Table').getRecordTypeId());
	            if(Schema.sObjectType.DataTableConfig__c.isCreateable()){
	                insert  formEnhancedTable;
	            }
            }
            if(Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.DisplayArea__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.HeaderActionDisplayType__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable() ){
            	DataTableAction__c newAction = new DataTableAction__c(RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId(),ActionBehavior__c = 'Open in overlay',ActionURLLong__c ='/apex/AttachmentAdd?parentId={!RecordId}&pBlockId={!pageBlockId}',DataTableConfig__c = formEnhancedTable.id,Location__c = 'TOP',Sequence__c = 1,Name = 'New',DisplayArea__c = 'Both',HeaderActionDisplayType__c = 'Button',InternalUniqueID__c = 'EnhancedAttachmentTableAction1');
            	if(Schema.sObjectType.DataTableAction__c.isCreateable()){
                insert  newAction;
            	}
            }

            if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable() ){
	            DataTableAction__c editAction = new DataTableAction__c(RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId(),ActionBehavior__c = 'Open in overlay',ActionURLLong__c ='/apex/AttachmentEdit?parentId={!'+nameSpace+'AttachmentExtension__r.'+nameSpace+'ParentId__c}&pBlockId={!pageBlockId}&attachmentId={!'+nameSpace+'AttachmentExtension__r.'+nameSpace+'Attachment__c}',DataTableConfig__c = formEnhancedTable.id,IconCSS__c = '<i class="fa fa-pencil" ></i>',Location__c = 'ROW',Sequence__c = 2,Name = 'Edit',InternalUniqueID__c = 'EnhancedAttachmentTableAction2');
	            if(Schema.sObjectType.DataTableAction__c.isCreateable()){
	                insert  editAction;
	            }
            }

            if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable() 
            && Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable() 
            && Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.StandardAction__c.isCreateable()){
	            DataTableAction__c deleteAction = new DataTableAction__c(RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId(),ActionBehavior__c = 'Open in same window',DataTableConfig__c = formEnhancedTable.id,IconCSS__c = '<i class="fa fa-trash-o" ></i>',Location__c = 'ROW',Sequence__c = 3,Name = 'Delete',StandardAction__c = 'Delete',InternalUniqueID__c = 'EnhancedAttachmentTableAction3');
	            if(Schema.sObjectType.DataTableAction__c.isCreateable()){
	                insert  deleteAction;
	            }
            }
            if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.ActionURLLong__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable()
            && Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable() && Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable())
            {
	            DataTableAction__c downloadAction = new DataTableAction__c(RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId(),ActionBehavior__c = 'Open in new window',ActionURLLong__c ='/servlet/servlet.FileDownload?file={!'+nameSpace+'AttachmentExtension__r.'+nameSpace+'Attachment__c}',DataTableConfig__c = formEnhancedTable.id,IconCSS__c = '<i class="fa fa-cloud-download"></i>',Location__c = 'ROW',Sequence__c = 4,Name = 'Download',InternalUniqueID__c = 'EnhancedAttachmentTableAction4');
	            if(Schema.sObjectType.DataTableAction__c.isCreateable()){
	                insert  downloadAction;
	            }
        	}
        }

    /*
        Author  : Tomy Pallissery
        Date    : 
    */
    private void updateHeaderImagesDocName() {
        String govGrantsHeaderImage = KeyValueStoreHelper.getTextValue('govGrantsHeaderImage', true);
        String govGrantsHeaderImageAfterCollapse = KeyValueStoreHelper.getTextValue('govGrantsHeaderImageAfterCollapse', true);

        Set<String> docNames = new Set<String>();  
        docNames.add(govGrantsHeaderImage);
        docNames.add(govGrantsHeaderImageAfterCollapse);

        List< document > documentList = [SELECT Name, DeveloperName FROM document WHERE Name IN:docNames  WITH USER_MODE];//CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        List<KeyValueStore__c > keyValueRecordList = new List<KeyValueStore__c >();
        if(documentList.size() > 0) {
            for(Document doc : documentList) {
                if(govGrantsHeaderImage != null && doc.Name == govGrantsHeaderImage) {
                    keyValueRecordList.add(getTextValue('govGrantsHeaderImage', doc.DeveloperName, true));
                }
                if(govGrantsHeaderImageAfterCollapse != null && doc.Name == govGrantsHeaderImageAfterCollapse) {
                   keyValueRecordList.add(getTextValue('govGrantsHeaderImageAfterCollapse', doc.DeveloperName, true));
                }
            }
            setTextValue(keyValueRecordList , true);
        }  


    }


    private KeyValueStore__c getTextValue(String keyWord, String value, boolean isPublic) {
		if(isPublic) {
			KeyValueStore__c keyValueRecord = getPublicRecord(keyWord);
			if(keyValueRecord == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
				return new KeyValueStore__c(Name=keyWord, TextValue__c=value, Description__c=keyWord,Admin_Question__c ='Loren Ipsum');
			} else {
				if(Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isUpdateable()){
					keyValueRecord.TextValue__c = value;
				}
				if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					return keyValueRecord;
				}
			}
		} 
        return null ; 
	}

    private void setTextValue(List<KeyValueStore__c > keyValueRecordList , boolean isPublic) {
		if(isPublic) {
			if(keyValueRecordList == null && Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Name.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.TextValue__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Description__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.fields.Admin_Question__c.isCreateable()) {
                insert as user  keyValueRecordList ; 
			} else if(Schema.sObjectType.KeyValueStore__c.isUpdateable()){
					update as user keyValueRecordList;
			}
			
		} 
	}
    private static KeyValueStore__c getPublicRecord(String keyWord) {
		return KeyValueStore__c.getInstance(keyWord);
	}



    private void activeBooleanOfBusinessShare(){
        List<BusinessShareConfig__c> businessShareList = BusinessShareConfig__c.getAll().values();
        for(BusinessShareConfig__c objBusinessShareConfig:businessShareList){
            if(Schema.SObjectType.BusinessShareConfig__c.fields.Active__c.isUpdateable()){
            objBusinessShareConfig.Active__c = true;
            }
        }
        if(Schema.sObjectType.BusinessShareConfig__c.isUpdateable() && Schema.sObjectType.BusinessShareConfig__c.isAccessible()){
            update  businessShareList;
        }
    }

    /*
        Author  : Tomy Pallissery
        Date    : 20/08/2018
    */
    @testVisible
    private void upsertSobjectPhaseConfigRecords() {
         List<SObjectPhaseConfig__c> dbListSobjectPhase = new List<SObjectPhaseConfig__c>();
         if(Schema.sObjectType.SObjectPhaseConfig__c.isAccessible()){
         dbListSobjectPhase = [SELECT PhaseConfig__c, SObjectConfig__c, GlobalSearchLabel__c, GlobalSearchFlexTableConfig__c,
                                                                  GlobalSearchVisibility__c, RecentlyViewedVisibility__c
                                                            FROM SObjectPhaseConfig__c WITH USER_MODE LIMIT 10000];
         }

        //To configure global search
        List<SearchConfig__c> phaseSearchConfigList = new List<SearchConfig__c>();
        if(Schema.sObjectType.SearchConfig__c.isAccessible()){
        phaseSearchConfigList = [SELECT Active__c, FlexTableConfig__c, Label__c, PhaseConfig__c, 
                                                              PhaseConfig__r.SObject__c, PhaseConfig__r.Name,SObject__c
                                                        FROM SearchConfig__c WITH USER_MODE LIMIT 10000];
        }

        //To configure recently viewed
        List<PhaseConfig__c> phaseConfigList = new List<PhaseConfig__c>();
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
        phaseConfigList = [SELECT Id, Name, SObject__c FROM PhaseConfig__c WHERE SObject__c != null WITH USER_MODE];
        }
        Map<String, SObjectPhaseConfig__c> existingSobjectPhaseRecords = new Map<String, SObjectPhaseConfig__c> ();
        for(SObjectPhaseConfig__c sobjPhaseConfig : dbListSobjectPhase) {
            string uniqueKey = sobjPhaseConfig.PhaseConfig__c + ';' + sobjPhaseConfig.SObjectConfig__c;
            existingSobjectPhaseRecords.put(uniqueKey, sobjPhaseConfig);
        }

        Map<Id, String> searchConfigToSobjectMap = new Map<Id, String>();
        Set<String> sObjectNameSet = new Set<String>();

        for(SearchConfig__c searchConfig : phaseSearchConfigList) {
            searchConfigToSobjectMap.put(searchConfig.Id, searchConfig.SObject__c);
            sObjectNameSet.add(searchConfig.SObject__c);
        }

        for(PhaseConfig__c phase : phaseConfigList) {
            sObjectNameSet.addAll(phase.SObject__c.split(';'));
        }

        //Creating mapping for sobject name and its related sobject config Id
        List<SobjectConfig__c> sobjectConfigList = new List<SobjectConfig__c>();
        if(Schema.sObjectType.SobjectConfig__c.isAccessible()){
        sobjectConfigList = [SELECT Id, Name FROM SobjectConfig__c WHERE Name IN : sObjectNameSet WITH USER_MODE];
        }
        Map<String, Id> sobjNameToConfigIdMap = new Map<String, Id>();
        for(SobjectConfig__c sobjConfig : sobjectConfigList) {
            sobjNameToConfigIdMap.put(sobjConfig.Name, sobjConfig.Id);
        }

        List<SObjectPhaseConfig__c> sobjPhaseListToInsert = new List<SObjectPhaseConfig__c>();
        Map<String, SObjectPhaseConfig__c> createdSobjectPhaseRecords = new Map<String, SObjectPhaseConfig__c>();
        createdSobjectPhaseRecords.putAll(existingSobjectPhaseRecords);

        //Creation of sobject phase records and setting global search visibility
        for(SearchConfig__c searchConfig : phaseSearchConfigList) {

            String phaseConfigId = searchConfig.PhaseConfig__c;
            String sobjectConfigId = sobjNameToConfigIdMap.get(searchConfigToSobjectMap.get(searchConfig.Id));
            String uniqueId = phaseConfigId + ';' + sobjectConfigId;

            if(existingSobjectPhaseRecords.get(uniqueId) == null) {
                SObjectPhaseConfig__c sobjectPhase = new SObjectPhaseConfig__c();
                //if(Schema.sObjectType.SObjectPhaseConfig__c.fields.PhaseConfig__c.isCreateable() && Schema.sObjectType.SObjectPhaseConfig__c.fields.PhaseConfig__c.isUpdateable()){
                    sobjectPhase.PhaseConfig__c = phaseConfigId; // CRUD/FLS False Positive: MD  
                //}
                //if(Schema.sObjectType.SObjectPhaseConfig__c.fields.SObjectConfig__c.isCreateable() && Schema.sObjectType.SObjectPhaseConfig__c.fields.SObjectConfig__c.isUpdateable()){
                    sobjectPhase.SObjectConfig__c = sobjectConfigId;// CRUD/FLS False Positive: MD  
                //}
                if(Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchLabel__c.isCreateable() 
                && Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchLabel__c.isUpdateable()){
                    sobjectPhase.GlobalSearchLabel__c = searchConfig.Label__c;
                }
                if(Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchFlexTableConfig__c.isCreateable() 
                && Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchFlexTableConfig__c.isUpdateable()){
                    sobjectPhase.GlobalSearchFlexTableConfig__c = searchConfig.FlexTableConfig__c;
                }
                if(Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchVisibility__c.isCreateable() 
                && Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchVisibility__c.isUpdateable()){
                    sobjectPhase.GlobalSearchVisibility__c = true;
                }
                createdSobjectPhaseRecords.put(uniqueId, sobjectPhase);
            } else {
                SObjectPhaseConfig__c sobjectPhase = existingSobjectPhaseRecords.get(uniqueId);
                if(Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchVisibility__c.isCreateable() 
                && Schema.sObjectType.SObjectPhaseConfig__c.fields.GlobalSearchVisibility__c.isUpdateable()){
                    sobjectPhase.GlobalSearchVisibility__c = true;
                }
               createdSobjectPhaseRecords.put(uniqueId, sobjectPhase);
            }
        }

        //setting up recently viewed visibility
        for(PhaseConfig__c phase : phaseConfigList) {
            for(String sobjectName : phase.SObject__c.split(';')) {
                String uniqueId = phase.Id + ';' + sobjNameToConfigIdMap.get(sobjectName);
                if(createdSobjectPhaseRecords.get(uniqueId) == null) {
                    SObjectPhaseConfig__c sobjectPhase = new SObjectPhaseConfig__c();
                    if(Schema.sObjectType.SObjectPhaseConfig__c.fields.PhaseConfig__c.isCreateable() 
                    && Schema.sObjectType.SObjectPhaseConfig__c.fields.PhaseConfig__c.isUpdateable() ){
                        sobjectPhase.PhaseConfig__c = phase.Id;
                    }
                    if(Schema.sObjectType.SObjectPhaseConfig__c.fields.SObjectConfig__c.isCreateable() 
                    && Schema.sObjectType.SObjectPhaseConfig__c.fields.SObjectConfig__c.isUpdateable() ){
                        sobjectPhase.SObjectConfig__c = sobjNameToConfigIdMap.get(sobjectName);
                    }
                    if(Schema.sObjectType.SObjectPhaseConfig__c.fields.RecentlyViewedVisibility__c.isCreateable() 
                    && Schema.sObjectType.SObjectPhaseConfig__c.fields.RecentlyViewedVisibility__c.isUpdateable()){
                        sobjectPhase.RecentlyViewedVisibility__c = true;
                    }
                    createdSobjectPhaseRecords.put(uniqueId, sobjectPhase);
                } else {
                    SObjectPhaseConfig__c sobjectPhase = createdSobjectPhaseRecords.get(uniqueId);
                    if(Schema.sObjectType.SObjectPhaseConfig__c.fields.RecentlyViewedVisibility__c.isCreateable() 
                    && Schema.sObjectType.SObjectPhaseConfig__c.fields.RecentlyViewedVisibility__c.isUpdateable()){
                        sobjectPhase.RecentlyViewedVisibility__c = true;
                    }
                    createdSobjectPhaseRecords.put(uniqueId, sobjectPhase);
                }
            }
        }

        List<SObjectPhaseConfig__c> finalListSobjPhase = createdSobjectPhaseRecords.values();
        Set<Id> phaseConfigIds = new Set<Id>();
        Set<Id> sobjConfigIds = new Set<Id>();

        for(SObjectPhaseConfig__c sobjPhase : finalListSobjPhase) {
            phaseConfigIds.add(sobjPhase.PhaseConfig__c);
            sobjConfigIds.add(sobjPhase.SObjectConfig__c);
        }

        List<PhaseConfig__c> pcList = new List<PhaseConfig__c>();
        if(Schema.sObjectType.PhaseConfig__c.isAccessible()){
        pcList = [SELECT Id, Name, Abbreviation__c FROM PhaseConfig__c WHERE Id IN:phaseConfigIds WITH USER_MODE];
        }
        List<SObjectConfig__c> scList = new List<SObjectConfig__c>();
        if(Schema.sObjectType.SObjectConfig__c.isAccessible()){
        scList = [SELECT Id, Name FROM SObjectConfig__c WHERE Id IN:sobjConfigIds WITH USER_MODE];
        }

        Map<Id,String> mapIDandPhaseName = new  Map<Id,String>();
        Map<Id,String> mapIDandSObjName = new  Map<Id,String>();

        for(PhaseConfig__c phase : pcList) {
            mapIDandPhaseName.put(phase.Id, phase.Abbreviation__c);
        }

        for(SObjectConfig__c sobjConfig : scList) {
            mapIDandSObjName.put(sobjConfig.Id, sobjConfig.Name);
        }

        for(SObjectPhaseConfig__c spc : finalListSobjPhase) {
            if(Schema.sObjectType.SObjectPhaseConfig__c.fields.InternalUniqueID__c.isCreateable() && 
            Schema.sObjectType.SObjectPhaseConfig__c.fields.InternalUniqueID__c.isUpdateable()){
	            spc.InternalUniqueID__c = mapIDandPhaseName.get(spc.PhaseConfig__c) + '_' + mapIDandSObjName.get(spc.SObjectConfig__c);
	            Integer maxSize = 31; // max length of InternalUniqueID__c is 32, keeping 31 for sanity
	            if(String.isNotEmpty(spc.InternalUniqueID__c) && spc.InternalUniqueID__c.length() > maxSize ){
	                spc.InternalUniqueID__c = spc.InternalUniqueID__c.substring(0, maxSize);
                }
            }
        }

        sobjPhaseListToInsert.addAll(finalListSobjPhase);
        if(Schema.sObjectType.SObjectPhaseConfig__c.isCreateable() && Schema.sObjectType.SObjectPhaseConfig__c.isUpdateable()){
            upsert  sobjPhaseListToInsert;
        }
    }
    
    /** removed createDefaultITextEndpoint() for SF review */
    /*
        Author : Atul Naik
        Purpose: Create Custom Setting under Key Value Store to skip header during CSV Export.
    */
    private void createHideFlexTableHeaderForCSVExport(){
        Boolean createHideFlexTblHeaderForCSV = KeyValueStoreHelper.getBooleanValue('HideFlexTableHeaderForCSV',true) == null ? true : false;
        KeyValueStore__c keyValueRecord = KeyValueStore__c.getInstance('HideFlexTableHeaderForCSV');
        String description = 'Hide Header of Flex Table for CSV Render';
        if(createHideFlexTblHeaderForCSV || keyValueRecord == null) {
            if(Schema.sObjectType.KeyValueStore__c.isCreateable()){
                insert new KeyValueStore__c(Name='HideFlexTableHeaderForCSV', BooleanValue__c=false, Description__c=description);//FLS False +ve As per business scenario it is breaking for portal/guest users.
            }
        }else{
            if(Schema.sObjectType.KeyValueStore__c.fields.Description__c.isUpdateable()){
                keyValueRecord.Description__c = description;
            }
            if(Schema.sObjectType.KeyValueStore__c.isUpdateable() && Schema.sObjectType.KeyValueStore__c.isAccessible()){
                update  keyValueRecord;
            }
        }     
    }
     /*
        Author : Robin Kumar
        Purpose: Create Custom Setting under Key Value Store to skip record locking criteria.
    */
    private void createDisableRecordLocking(){       
        KeyValueStore__c keyValueRecord = KeyValueStore__c.getInstance('DisableRecordLocking');
        String description = 'To disable record locking';
        if(keyValueRecord != null){
            if(Schema.sObjectType.KeyValueStore__c.fields.Description__c.isUpdateable()){
                keyValueRecord.Description__c =  description ;
            }
            if(Schema.sObjectType.KeyValueStore__c.isUpdateable() && Schema.sObjectType.KeyValueStore__c.isAccessible()){
                update  keyValueRecord;
            }
        }
        else{
            if(Schema.sObjectType.KeyValueStore__c.isCreateable() && Schema.sObjectType.KeyValueStore__c.isAccessible()){
                insert new KeyValueStore__c(Name='DisableRecordLocking', BooleanValue__c=true, Description__c=description);//FLS False +ve As per business scenario it is breaking for portal/guest users.
            }
        }
        
    }

    /*
        Author : Atul.Naik  
        Purpose : Creating Flex Grid Batch Job Enhanced...
    */
    private void createApexBatchEnhancedGrid(){
        String nameSpace = AppUtils.getNamespacePrefix();
        List<FlexGridConfig__c> flexGridConfig = new List<FlexGridConfig__c>();
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible()){
        flexGridConfig = [SELECT Id,Name FROM FlexGridConfig__c WHERE Name = 'ApexBatchEnhancedConfig' WITH USER_MODE];
        }
        if(flexGridConfig.size() > 0){
            return;
        }
        DataTableConfig__c apexBatchEnhancedTable = new DataTableConfig__c();
        if(Schema.sObjectType.DataTableConfig__c.fields.Name.isCreateable()){
            apexBatchEnhancedTable.Name ='ApexBatchEnhancedConfig';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.FieldNames__c.isCreateable()){
            apexBatchEnhancedTable.FieldNames__c = nameSpace+'Name,'+nameSpace+'ClassName__c,'+nameSpace+'CronExpression__c,'+nameSpace+'IntervalMins__c,'+nameSpace+'BatchSize__c,'+nameSpace+'Active__c,'+nameSpace+'Status__c,'+nameSpace+'KickNow__c,'+nameSpace+'ErrorMessage__c,'+nameSpace+'LastRunEndedOn__c';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Header__c.isCreateable()){
            apexBatchEnhancedTable.Header__c = 'Apex Batches';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.Description__c.isCreateable()){
            apexBatchEnhancedTable.Description__c = 'Admin Module - ApexBatchConfig';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.SobjectConfig__c.isCreateable()){
            apexBatchEnhancedTable.SobjectConfig__r.Name = nameSpace+'ApexJob__c';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.InternalUniqueID__c.isCreateable()){
            apexBatchEnhancedTable.InternalUniqueID__c = 'ApexBatchEnhancedConfig';
        }
        if(Schema.sObjectType.DataTableConfig__c.fields.RecordTypeId.isCreateable()){
            apexBatchEnhancedTable.RecordTypeId = Schema.sObjectType.DataTableConfig__c.getRecordTypeInfosByName().get('Data Table').getRecordTypeId();
        }
        if(Schema.sObjectType.DataTableConfig__c.isCreateable()){
            insert  apexBatchEnhancedTable;
        }
        
        DataTableAction__c newAction = new DataTableAction__c();
        DataTableAction__c saveAction = new DataTableAction__c();
        DataTableAction__c scheduleEnhancedJobsAction = new DataTableAction__c();
        DataTableAction__c editJobsAction = new DataTableAction__c();
        DataTableAction__c stopScheduleApexJobsAction = new DataTableAction__c();
        DataTableAction__c deleteAction = new DataTableAction__c();
        if(Schema.sObjectType.DataTableAction__c.fields.RecordTypeId.isCreateable()){
            newAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action Grid').getRecordTypeId();
            saveAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action Grid').getRecordTypeId();
            scheduleEnhancedJobsAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action Class').getRecordTypeId();
            editJobsAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action Grid').getRecordTypeId();
            stopScheduleApexJobsAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action Class').getRecordTypeId();
            deleteAction.RecordTypeId = Schema.sObjectType.DataTableAction__c.getRecordTypeInfosByName().get('Action URL').getRecordTypeId();
        }

        if(Schema.sObjectType.DataTableAction__c.fields.ActionClass__c.isCreateable()){
            scheduleEnhancedJobsAction.ActionClass__c = 'ScheduleApexJobsEnhancedHelper';
            stopScheduleApexJobsAction.ActionClass__c = 'DeleteScheduledApexJobsHelper';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.ActionBehavior__c.isCreateable()){
            newAction.ActionBehavior__c = 'Open in same window';
            saveAction.ActionBehavior__c = 'Open in same window';
            editJobsAction.ActionBehavior__c = 'Open in inline mode';
            scheduleEnhancedJobsAction.ActionBehavior__c = 'Open in same window';
            stopScheduleApexJobsAction.ActionBehavior__c = 'Open in same window';
            deleteAction.ActionBehavior__c = 'Open in same window';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.StandardAction__c.isCreateable()){
            newAction.StandardAction__c = 'New';
            saveAction.StandardAction__c = 'Save';
            editJobsAction.StandardAction__c = 'Edit';
            deleteAction.StandardAction__c = 'Delete';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.DataTableConfig__c.isCreateable()){
            newAction.DataTableConfig__c = apexBatchEnhancedTable.Id;
            saveAction.DataTableConfig__c = apexBatchEnhancedTable.Id;
            scheduleEnhancedJobsAction.DataTableConfig__c = apexBatchEnhancedTable.Id;
            editJobsAction.DataTableConfig__c = apexBatchEnhancedTable.Id;
            stopScheduleApexJobsAction.DataTableConfig__c = apexBatchEnhancedTable.Id;
            deleteAction.DataTableConfig__c = apexBatchEnhancedTable.Id;
        }

        if(Schema.sObjectType.DataTableAction__c.fields.DisplayArea__c.isCreateable()){
            newAction.DisplayArea__c = 'Both';
            saveAction.DisplayArea__c = 'Page Header';
            scheduleEnhancedJobsAction.DisplayArea__c = 'Page Header';
            stopScheduleApexJobsAction.DisplayArea__c = 'Page Header';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.HeaderActionDisplayType__c.isCreateable()){
            newAction.HeaderActionDisplayType__c = 'Button';
            saveAction.HeaderActionDisplayType__c = 'Button';
            scheduleEnhancedJobsAction.HeaderActionDisplayType__c = 'Button';
            stopScheduleApexJobsAction.HeaderActionDisplayType__c = 'Button';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.Location__c.isCreateable()){
            newAction.Location__c = 'Top';
            saveAction.Location__c = 'Top';  
            scheduleEnhancedJobsAction.Location__c = 'Top';
            editJobsAction.Location__c = 'Row';
            stopScheduleApexJobsAction.Location__c = 'Top';
            deleteAction.Location__c = 'Row';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.RefreshBehavior__c.isCreateable()){
            newAction.RefreshBehavior__c = 'Refresh the grid';
            saveAction.RefreshBehavior__c = 'Refresh the grid';
            stopScheduleApexJobsAction.RefreshBehavior__c = 'Refresh the grid';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.Sequence__c.isCreateable()){
            newAction.Sequence__c = 1;
            saveAction.Sequence__c = 2;
            scheduleEnhancedJobsAction.Sequence__c = 1;
            editJobsAction.Sequence__c = 1;
            stopScheduleApexJobsAction.Sequence__c = 2;
            deleteAction.Sequence__c = 3;
        }

        if(Schema.sObjectType.DataTableAction__c.fields.Name.isCreateable()){
            newAction.Name = 'New';
            saveAction.Name = 'Save';
            scheduleEnhancedJobsAction.Name = 'Schedule Enhanced Jobs';
            editJobsAction.Name = 'Edit';
            stopScheduleApexJobsAction.Name = 'Delete ScheduledApexJobs';
            deleteAction.Name = 'Delete';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.IconCSS__c.isCreateable()){
            editJobsAction.IconCSS__c =  '<i class="fa fa-pencil"></i>';
            deleteAction.IconCSS__c = '<i class="fa fa-trash-o" ></i>';
        }

        if(Schema.sObjectType.DataTableAction__c.fields.InternalUniqueID__c.isCreateable()){
            newAction.InternalUniqueID__c = 'apexBatchEnhancedTable1';
            saveAction.InternalUniqueID__c = 'apexBatchEnhancedTable2';
            scheduleEnhancedJobsAction.InternalUniqueID__c = 'apexBatchEnhancedTable3';
            editJobsAction.InternalUniqueID__c = 'apexBatchEnhancedTable4';
            stopScheduleApexJobsAction.InternalUniqueID__c = 'apexBatchEnhancedTable5';
            deleteAction.InternalUniqueID__c = 'apexBatchEnhancedTable6';
        }
        if(Schema.sObjectType.DataTableAction__c.isCreateable()){
            insert  newAction;
            insert  saveAction;
            insert  scheduleEnhancedJobsAction;
            insert  editJobsAction;
            insert  stopScheduleApexJobsAction;
            insert  deleteAction;
        }

        // Creation of Flex Grid 
        FlexGridConfig__c flexGridVal = new FlexGridConfig__c();
        if(Schema.sObjectType.FlexGridConfig__c.fields.Name.isCreateable()){
            flexGridVal.Name = 'ApexBatchEnhancedConfig';
        }
        if(Schema.sObjectType.FlexGridConfig__c.fields.RecordTypeId.isCreateable()){
            flexGridVal.RecordTypeId = Schema.sObjectType.FlexGridConfig__c.getRecordTypeInfosByName().get('Mass Editable Grid').getRecordTypeId(); 
        }
        if(Schema.sObjectType.FlexGridConfig__c.fields.HeaderInstruction__c.isCreateable()){
            flexGridVal.HeaderInstruction__c = 'You can define list of batch classes those you want to execute.<br>'+
                                                'Cron Expression syntax :- <br>'+
                                                'Seconds Minutes Hours Day_of_month Month Day_of_week optional_year <br>'+

                                                'Examples - <br>'+
                                                'Expression  Description <br>'+
                                                '0 0 0 ? * * *   at 12:00 AM every day <br>'+
                                                '0 0 10 ? * *    at 10.00 AM every day <br>'+
                                                '0 0-5 15 * * ?  Every minute starting at 3:00 PM and ending at 3:05 PM, every day <br>'+
                                                '0 15 17 ? * MON-FRI at 5:15 PM every Monday, Tuesday, Wednesday, Thursday and Friday <br>'+
                                                '0 15 10 15 * ?  at 5:15 PM on the 15th day of every month <br>'+
                                                '0 15 17 ? * 6#3 at 5:15 PM on the third Friday of every month';
        }
        if(Schema.sObjectType.FlexGridConfig__c.fields.ParentFlexTable__c.isCreateable()){
            flexGridVal.ParentFlexTable__c =  apexBatchEnhancedTable.Id; 
        }
        if(Schema.sObjectType.FlexGridConfig__c.fields.EnablePagination__c.isCreateable()){
            flexGridVal.EnablePagination__c = true;
        }
        if(Schema.sObjectType.FlexGridConfig__c.isAccessible() && Schema.sObjectType.FlexGridConfig__c.isCreateable()){
            insert  flexGridVal;
        }
    }
}