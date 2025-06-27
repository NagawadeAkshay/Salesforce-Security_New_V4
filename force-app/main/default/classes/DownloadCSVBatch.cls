/**
 * @description       : 
 * @author            : Shubham Pawar
 * @group             : 
 * @last modified on  : 03-10-2022
 * @last modified by  : Shubham Pawar
**/
global with sharing class DownloadCSVBatch implements Database.Batchable<sObject>,Database.Stateful {
   
    global transient String csvColumnHeader;
    global transient String pathwayName;
    global String fileType;
    global String emailId;
    //transient String pathwayString = '';
    String tableName = '';
    global static String tableName1 = '';
    transient String sobjectName;
    List<String> flexFieldNames ;
    List<String> csvHeaderLableName = new List<String>();
    global  List<String> csvRowValues = new List<String>();  
    public static final String FORM_HTML_START = '<HTML><BODY>';
    public static final String FORM_HTML_END = '</BODY></HTML>';
    String  pdfContent = '' + FORM_HTML_START;        
    public Boolean isHeapSizelimitexceed = false;    
    DownloadCSVBatchHelper ab = new DownloadCSVBatchHelper();
    String query;
    public static Boolean flag = false;
    string soqlQueryWithMergeField;
    String nameSpace = '';
    String userDateFormat =  AppUtils.getUserDateFormat();
    String userDateTimeFormat = AppUtils.getUserDateTimeFormat();
    String flexTableListViewHeader;
    Map<String, String> mapResources =  new Map<String, String>();
     public transient String topLeftImageURL{get;set;}
       
     public List<String> fieldNames2;
     global List<String> rowLable = new List<String>();  
     global DownloadCSVBatch(String RecordId1, String fileTypeName, String userEmailId,String tableName) {
     }

     global DownloadCSVBatch(String RecordId1, String fileTypeName, String userEmailId,String tableName, Map<String, String> urlParams, Map<String, Object> urlParamsMap) {
        this.pathwayName = RecordId1;
        this.fileType = fileTypeName;
        this.emailId = userEmailId;
        this.tableName = tableName;
        tableName1 = tableName;
        soqlQueryWithMergeField = ab.fetchData(tableName,RecordId1,urlParams,urlParamsMap);
        this.nameSpace = AppUtils.getNameSpacePrefix();
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        DataTableConfig__c flexTableRecords = [SELECT id,Name,FieldNames__c,FilterCriteria__c,Header__c,HelpConfig__c,OrderBy__c,SObject__c,SkipFieldsForExport__c
                                    ,SobjectConfig__r.Name,RecordTypeId,HeaderIconDocumentName__c,PDFRenderType__c,Sort_Direction__c,SubHeader__c
                                    FROM DataTableConfig__c 
                                    WHERE Name = : tableName WITH USER_MODE]; //CRUD/FLS False +ve As per business scenario we can't check for portal/external users
        sobjectName = flexTableRecords.SObject__c;
        SObject dynamicType = (SObject)Type.forName(sobjectName).newInstance();
        flexFieldNames = flexTableRecords.FieldNames__c.split(',');
       
        soqlQueryWithMergeField = soqlQueryWithMergeField.substringAfter('FROM');
        if(ab.exportFieldNames != null){
           flexFieldNames = ab.exportFieldNames;
        } 
         fieldNames2 = ab.fieldNamesOfColumns.split(',');
  
        query='' ;
        query+='SELECT '+String.escapeSingleQuotes(ab.fieldNamesOfColumns); 
     
        
        query+=' from ';
        query =query+''+soqlQueryWithMergeField;  
        flexTableListViewHeader = ab.flexTableHeader;
        pdfContent = pdfContent + '<H6 align="center"><b>'+ab.flexTableHeader+'</b></H6><br>';
        pdfContent = pdfContent + '<table style="font-size:5px" border="0.1"> <tr style="font-size: 6px;"><b>';
        //Dynamic Column Header Start 

        Map<String,String> fieldLabelMap = new Map<String,String>();
        
         for(Integer indx: ab.index){
           
            pdfContent  = pdfContent+'<th>'+ab.indexLabel.get(indx)+'</th>';
            pdfContent  = pdfContent+ ',';
            csvHeaderLableName.add(ab.indexLabel.get(indx));  
                 
          }

     
        pdfContent  = pdfContent.removeEnd(',');
        pdfContent =pdfContent+'</b></tr>';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Sobject record :scope){
            if(Limits.getHeapSize() < Limits.getLimitHeapSize()){
                if(fileType.contains('CSV')){
                    String rowStr='' ;
                    for(Integer indx : ab.index){
                        string s = ab.indexAPI.get(indx);
                        String datatype = ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''));
                        Integer fieldScale = 0;
                        if(datatype == 'CURRENCY'){
                           
                            
                            if(s.contains('__r')){
                                try{
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                }catch(Exception exc){
                                    String[] fieldArr = s.split('\\.', -1);
                                    String fname='';
                                    for (String str : fieldArr){
                                        fname+=AppUtils.getNameSpacePrefix()+str;
                                        fname+='.';
                                    }
                                    fname = fname.removeEnd('.');
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName,fname).getDescribe().getScale();
                                }
                                Object fieldValue = AppUtils.getFieldValue(record,s);
                                rowStr += String.valueOf(fieldValue)==null ? '': '$' +String.valueOf(fieldValue).escapeCsv();
                            }else{
                                try{
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                } catch(Exception exc){
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName, AppUtils.getNameSpacePrefix() + s).getDescribe().getScale();
                                }
                                rowStr += record.get(s)==null?'': AppUtils.getFormattedNumber(Double.valueOf(record.get(s)),fieldScale,true,datatype).escapeCsv();
                            }
                            rowStr +=',';
                        }else if(datatype == 'DOUBLE'){
                            if(s.contains('__r')){
                                try{
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                }catch(Exception exc){
                                    String[] fieldArr = s.split('\\.', -1);
                                    String fname='';
                                    for (String str : fieldArr){
                                        fname+=AppUtils.getNameSpacePrefix()+str;
                                        fname+='.';
                                    }
                                    fname = fname.removeEnd('.');
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName,fname).getDescribe().getScale();
                                }
                                Object fieldValue = AppUtils.getFieldValue(record,s);
                                rowStr += String.valueOf(fieldValue)==null ? '': String.valueOf(fieldValue).escapeCsv();
                            }else{
                                try{
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                } catch(Exception exc){
                                    fieldScale = SchemaManager.getSObjectField(ab.objectName, AppUtils.getNameSpacePrefix() + s).getDescribe().getScale();
                                }
                                rowStr += record.get(s)==null?'': AppUtils.getFormattedNumber(Double.valueOf(record.get(s)),fieldScale,false,datatype).escapeCsv();
                            }
                            rowStr +=',';
                        }else if(datatype == 'Date'){
                            String dateValue;
                            Object fieldValue = AppUtils.getFieldValue(record,s);
                            if(fieldValue != null){
                                dateValue = Datetime.valueOf(String.valueOf(fieldValue)).format(userDateFormat);
                            }                      
                            if(s.contains('__r') && dateValue!= null){
                                if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date'  ){
                                    rowStr += dateValue;
                                }
                            }else{
                                if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date' && dateValue!= null ){
                                    rowStr += dateValue;
                                }
                            }
                            rowStr +=',';
                                    
                        }else if(datatype == 'DateTime'){
                            DateTime DateTimeVal;
                            Object fieldValue = AppUtils.getFieldValue(record,s);
                            if(fieldValue != null){
                                DateTimeVal = Datetime.valueOfgmt(String.valueOf(fieldValue)); 
                            }                      
                            if(s.contains('__r') && DateTimeVal!= null){
                                if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'DateTime' ){
                                    rowStr += Datetime.valueOf(DateTimeVal).format(userDateTimeFormat);
                                }
                                if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date'  ){
                                    rowStr += Datetime.valueOf(DateTimeVal).format(userDateFormat);
                                }
                            }else{
                                if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'DateTime' && DateTimeVal!= null ){
                                    rowStr += Datetime.valueOf(DateTimeVal).format(userDateTimeFormat);
                                }
                                if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date' && DateTimeVal!= null ){
                                    rowStr +=Datetime.valueOf(DateTimeVal).format(userDateFormat);
                                }
                            }
                            rowStr +=',';
                                    
                        }else if(datatype =='PERCENT'){

                            if(s.contains('__r')){
                                    Object fieldValue = AppUtils.getFieldValue(record,s);
                                    rowStr += String.valueOf(fieldValue)==null ? '': String.valueOf(fieldValue) + '%';
                                }else{
                                rowStr += record.get(s)==null?'':  record.get(s) + '%';
                                }
                                rowStr +=',';
                        }else if(dataType == 'STRING' || dataType == 'TEXTAREA'){
                            Object fieldValue = AppUtils.getFieldValue(record,s);
                            String fieldString ;
                            if(fieldValue != null){
                                fieldString = String.valueOf(fieldValue).escapeCsv();
                            } 
                            if(String.isNotEmpty(fieldString)){                        
                                if(fieldString.startsWith('<img')){
                                  String formulaTxt = ab.getAltValue(fieldString); 
                                  rowStr += formulaTxt;
                                }else if(fieldString.startsWith('<a')){
                                   String formulaTxt = ab.getFormattedString(fieldString);
                                   rowStr += formulaTxt;
                                }else{
                                    String val = ab.getFormattedString(fieldString);
                                    rowStr += val.replaceAll('\n','<br />') ;
                                }
                            }else if(String.isEmpty(fieldString)){
                                rowStr +='';
                            }
                            rowStr +=','; 
                        }else{ 
                            if(s.contains('__r')){
                                Object fieldValue = AppUtils.getFieldValue(record,s);
                                rowStr += String.valueOf(fieldValue)==null ? '': String.valueOf(fieldValue).escapeCsv();
                            }else{
                                Object fieldValue = AppUtils.getFieldValue(record,s);  
                                rowStr += fieldValue==null?'':String.valueOf(fieldValue).escapeCsv() ;
                            }
                            rowStr +=',';
                        }                   
    
                    }
                    rowStr  = rowStr.removeEnd(',');
                    csvRowValues.add(rowStr);
                } 
                if(fileType.contains('PDF')) {
                        pdfContent += '<tr>';
                        String datatype ='';
                        string s = '';
                        for(Integer indx : ab.index){
                            s = ab.indexAPI.get(indx);
                            datatype = ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''));
                            Integer fieldScale = 0;
                            pdfContent += '<td>';
                            if(datatype == 'CURRENCY'){
                                
                                if(s.contains('__r')){
                                    try{
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                    }catch(Exception exc){
                                        String[] fieldArr = s.split('\\.', -1);
                                        String fname='';
                                        for (String str : fieldArr){
                                            fname+=AppUtils.getNameSpacePrefix()+str;
                                            fname+='.';
                                        }
                                        fname = fname.removeEnd('.');
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName,fname).getDescribe().getScale();
                                    }
                                    Object fieldValue = AppUtils.getFieldValue(record,s);
                                    pdfContent += String.valueOf(fieldValue)==null ? '': AppUtils.getFormattedNumber(Double.valueOf(fieldValue),fieldScale,true,datatype);
                                }else{
                                    try{
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                    }catch(Exception exc){
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName, AppUtils.getNameSpacePrefix() + s).getDescribe().getScale();
                                    }
                                     pdfContent += record.get(s)==null ? '': AppUtils.getFormattedNumber(Double.valueOf(record.get(s)),fieldScale,true,datatype);
                                }
                            }else if(datatype == 'DOUBLE'){
                                if(s.contains('__r')){
                                    try{
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                    }catch(Exception exc){
                                        String[] fieldArr = s.split('\\.', -1);
                                        String fname='';
                                        for (String str : fieldArr){
                                            fname+=AppUtils.getNameSpacePrefix()+str;
                                            fname+='.';
                                        }
                                        fname = fname.removeEnd('.');
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName,fname).getDescribe().getScale();
                                    }
                                    Object fieldValue = AppUtils.getFieldValue(record,s);
                                    pdfContent += String.valueOf(fieldValue)==null ? '': AppUtils.getFormattedNumber(Double.valueOf(fieldValue),fieldScale,false,datatype);
                                }else{
                                    try{
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName, s).getDescribe().getScale();
                                    }catch(Exception exc){
                                        fieldScale = SchemaManager.getSObjectField(ab.objectName, AppUtils.getNameSpacePrefix() + s).getDescribe().getScale();
                                    }
                                    pdfContent += record.get(s)==null?'': AppUtils.getFormattedNumber(Double.valueOf(record.get(s)),fieldScale,false,datatype);
                                }
                            }else if(datatype == 'Date'){
                                String dateValue;
                                Object fieldValue = AppUtils.getFieldValue(record,s);
                                if(fieldValue != null){
                                    dateValue = Datetime.valueOf(String.valueOf(fieldValue)).format(userDateFormat);
                                }                      
                                if(s.contains('__r') && dateValue!= null){
                                    if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date'  ){
                                        pdfContent += dateValue;
                                    }
                                }else{
                                    if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date' && dateValue!= null ){
                                        pdfContent += dateValue;
                                    }
                                }
                            }else if(datatype == 'DateTime'){
                                DateTime DateTimeVal;
                                Object fieldValue = AppUtils.getFieldValue(record,s);
                                if(fieldValue != null){
                                    DateTimeVal = Datetime.valueOfgmt(String.valueOf(fieldValue)); 
                                }                      
                                if(s.contains('__r') && DateTimeVal!= null){
                                    if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'DateTime' ){
                                        pdfContent += Datetime.valueOf(DateTimeVal).format(userDateTimeFormat);
                                    }
                                    if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date'  ){
                                        pdfContent += Datetime.valueOf(DateTimeVal).format(userDateFormat);
                                    }
                                }else{
                                    if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'DateTime' && DateTimeVal!= null ){
                                        pdfContent += Datetime.valueOf(DateTimeVal).format(userDateTimeFormat);
                                    }
                                    if(ab.fieldApiNameToDataType.get( s.replaceAll(nameSpace,''))== 'Date' && DateTimeVal!= null ){
                                        pdfContent +=Datetime.valueOf(DateTimeVal).format(userDateFormat);
                                    }
                                }
                                        
                            }else if(datatype =='PERCENT'){

                                if(s.contains('__r')){
                                    Object fieldValue = AppUtils.getFieldValue(record,s);
                                    pdfContent += String.valueOf(fieldValue)==null ? '': String.valueOf(fieldValue) + '%';
                                }else{
                                    pdfContent += record.get(s)==null?'':  record.get(s) + '%';
                                }
                                    
                            }else if(dataType == 'STRING' || dataType == 'TEXTAREA') {
                                Object fieldValue = AppUtils.getFieldValue(record,s);
                                String fieldString ;
                                if(fieldValue != null){
                                    fieldString = String.valueOf(fieldValue);
                                } 
                                
                                if(String.isNotEmpty(fieldString)){                        
                                    if(fieldString.startsWith('<img')){
                                      String formulaTxt = ab.getAltValue(fieldString); 
                                      pdfContent += formulaTxt;
                                    }else if(fieldString.startsWith('<a')){
                                       String formulaTxt = ab.getFormattedString(fieldString);
                                       pdfContent += formulaTxt;
                                    }else{
                                        String val = ab.getFormattedString(fieldString);
                                        pdfContent += val.replaceAll('\n','<br />') ;
                                    }
                                }else if(String.isEmpty(fieldString)){
                                    pdfContent+='';
                                }
                            }else{
                                if(s.contains('__r')){
                                    Object fieldValue = AppUtils.getFieldValue(record,s);
                                    pdfContent += String.valueOf(fieldValue)==null?'':String.valueOf(fieldValue);
                                }else{
                                    Object fieldValue = AppUtils.getFieldValue(record,s);
                                    pdfContent += fieldValue==null?'':fieldValue;
                                }
                            }  
                            pdfContent += '</td>'; 
                            pdfContent +=',';
                        }
                    pdfContent  = pdfContent.removeEnd(',');
                    pdfContent += '</tr>';
                    }
              }else{
                    isHeapSizelimitexceed = true;
                    pdfContent  = '';
        }
    }
}
        
   
    global void finish(Database.BatchableContext BC){
      pdfContent = pdfContent + '</table>' + FORM_HTML_END;
        if(true){
 
          if(fileType.contains('CSV')){
                csvColumnHeader = string.join(csvHeaderLableName,',');
                csvColumnHeader = csvColumnHeader+'\n';
                String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
                blob contentBody = Blob.valueOf(csvFile);
                sendEmail(contentBody,null,fileType,emailId,tableName,isHeapSizelimitexceed,flexTableListViewHeader);

            }else if(fileType.contains('PDF')){
                 if(!isHeapSizelimitexceed){ 
                    pdfContent  +=FORM_HTML_END ;
                    sendEmail(null,pdfContent,fileType,emailId,tableName,isHeapSizelimitexceed,flexTableListViewHeader);
                 }else{
                    sendEmail(null,null,fileType,emailId,tableName,isHeapSizelimitexceed,flexTableListViewHeader);
                 }               
            }
       }
    }
    public static void sendEmail(Blob body, string pdfFile, String fileType, String emailId,String tableName,Boolean isHeapSizelimitexceed,String flexTableListViewHeader){
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        if(fileType.contains('CSV')){
            attach.setContentType('application/vnd.ms-excel');                
            attach.setFileName(flexTableListViewHeader+' -CSV- '+ Datetime.now().format('EEE, d MMM yyyy HH:mm:ss Z')+'.xls');
            attach.Body = body;
        }else if(fileType.contains('PDF')){
             if(!isHeapSizelimitexceed){
                attach.setContentType('application/pdf');
                attach.setFileName(flexTableListViewHeader+' -PDF- '+ Datetime.now().format('EEE, d MMM yyyy HH:mm:ss Z')+'.pdf');
                attach.Body = Blob.toPDF(pdfFile);
            }
            
        }
        attach.setInline(false);
         //Apex Single email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] {emailId});//Set To Email Address
        mail.setSubject('Attachment for Bulk PDF/XLS download');//Set Subject
        if(!isHeapSizelimitexceed){
             mail.setHtmlBody('Hello '+ UserInfo.getName()+',<br/><br/>'+
                            +'Thank you for downloading the Bulk PDF/XLS from ' + flexTableListViewHeader + '.<br/>'+
                            +'Please find the attachment to this email.<br/><br/>'+
                            +'Thank you.');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
        }else{
             mail.setHtmlBody('Hello '+ UserInfo.getName()+',<br/><br/>'+
                            +'Thank you for trying to download the Bulk PDF/XLS from ' + flexTableListViewHeader + '.<br/>'+
                            +'Download of Bulk PDF/XLS failed. Number of record present on the table exceeded the limit of bulk functionality.<br/><br/>'+
                            +'Thank you.');
        }
       
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}