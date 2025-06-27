global with sharing class PDFExecuteDownloadPdf extends FlexTableActionHandler{
    public String pathwayName;
    public String fileType;
    public String userEmailId;
     public String tableName;
    

    global override Map<String, Object> clickHandler() { 
        userEmailId = UserInfo.getUserEmail();
        String parentRecordId = urlParams.get('RecordId');
        fileType = 'PDF';
        tableName =dataTableConfigName;Map<String, Object> resultMap =  new Map<String, Object>();
        DownloadCSVBatch bt = new DownloadCSVBatch(parentRecordId,fileType,userEmailId,tableName);
        database.executebatch(bt,200);       
        resultMap.put('Message', 'You will receive an email within 30 mins. If you haven\'t receive any response please contact to system adminstrator.');
        return resultMap;
    }
}