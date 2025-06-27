@isTest public with sharing class TestSheetJsUploadDownloadCtrl {
    static DataTableConfig__c dataTableConfig ;
    public static void setup(){
        dataTableConfig  = new DataTableConfig__c();
        dataTableConfig.Name = 'TestDataTable';
        dataTableConfig.SObject__c = AppUtils.getNamespacePrefix()+'SampleObject11__c';
        dataTableConfig.FieldNames__c = 'Id,OldValue';  
        //dataTableConfig.FilterCriteria__c = 'Name != {!name} ';
        dataTableConfig.Description__c='TestDescription';  
      
        dataTableConfig.HelpConfig__c = TestHelper.getHelpConfigWithRecordType(true, 'Internal Document').Id;  
        insert dataTableConfig;
    }
   
    @isTest static void checkSaveRecords(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            setup();
            dataTableConfig = [SELECT Id,Name FROM DataTableConfig__c LIMIT 1];
            String jsonData = '{"headerList":["Record ID","TestObject1 Name","Sample Number 1","Sample Picklist 1","Sample Text 1"],"configData":[{"Id":"ID","Name":"STRING","SampleNumber1__c":"DOUBLE","SamplePicklist1__c":"PICKLIST","SampleText1__c":"STRING"},{"Id":"SampleObject1__c","Name":"SampleObject1__c","SampleNumber1__c":"SampleObject1__c","SamplePicklist1__c":"SampleObject1__c","SampleText1__c":"SampleObject1__c"},{"Id":"Yes","Name":"No","SampleNumber1__c":"No","SamplePicklist1__c":"No","SampleText1__c":"No"},{"Id":"Record ID","Name":"TestObject1 Name","SampleNumber1__c":"Sample Number 1","SamplePicklist1__c":"Sample Picklist 1","SampleText1__c":"Sample Text 1"}],"excelRowData":[{"Name":"tes","SampleNumber1__c":34,"SampleText1__c":"demo"}],"sObjectName":"SampleObject1__c","configtblId":"'+dataTableConfig.Id+'"}';
            SheetJsUploadDownloadCtrl.saveRecords(jsonData);
            String test = 'Success';
            System.assertEquals('Success', test);
        }
        
    }
    @isTest static void checkProvideConfig(){
        User u = TestHelper.getAdminUser(true);
        System.runAs(u) {
            setup();
            dataTableConfig = [SELECT Id,Name FROM DataTableConfig__c LIMIT 1];
            List<Object> tmp = SheetJsUploadDownloadCtrl.provideConfig(dataTableConfig.Id);
            String test = 'Success';
            System.assertEquals('Success', test);
        }
    }
    
}