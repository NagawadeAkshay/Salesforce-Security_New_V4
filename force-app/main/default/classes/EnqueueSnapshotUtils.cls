/**
 * Created by Dipak on 17-08-2020.
 */

global with sharing class EnqueueSnapshotUtils implements Queueable, Database.AllowsCallouts {
    Id recordId, stepWorkItemId;
    String templateName, flexTableParameterJSON, listParams, fileName, action;

    public EnqueueSnapshotUtils(Id stepWorkItemId, Id recordId, String templateName, String flexTableParameterJSON, String listParams, String fileName){
        this.stepWorkItemId =stepWorkItemId;
        this.recordId = recordId;
        this.templateName = templateName;
        this.flexTableParameterJSON = flexTableParameterJSON;
        this.listParams = listParams;
        this.fileName = fileName;
        this.action = 'Approval';
    }

    global EnqueueSnapshotUtils(Id recordId, String templateName, String flexTableParameterJSON, String listParams){
        this.recordId = recordId;
        this.templateName = templateName;
        this.flexTableParameterJSON = flexTableParameterJSON;
        this.listParams = listParams;
    }

    public void execute(QueueableContext context) {
        switch on this.action {
            // User Story 96008: Internal - POC - Snapshot - "Too many SOQL query" error displayed at program approval/reject/forward/send back
            when 'Approval' {
                SnapshotUtils.approvalSnapshot(stepWorkItemId,recordId,templateName,flexTableParameterJSON,listParams,fileName);
            }
            // User Story 96643: Internal - Issues after Installing Security Framework Package(5.250)
            when else {
                SnapshotUtils.createSnapshot(recordId, templateName, flexTableParameterJSON, listParams);
            }
        }
    }
}