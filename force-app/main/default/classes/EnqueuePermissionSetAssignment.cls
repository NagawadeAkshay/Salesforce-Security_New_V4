/**
 * Created by Dipak on 18-08-2020.
 * User Story 97080: Internal - Enhancement - Assign permission set to user on insertion
 */

public with sharing class EnqueuePermissionSetAssignment implements Queueable {
    Set<Id> userIds {
        get;
        set;
    }

    public EnqueuePermissionSetAssignment(Set<Id> userIds) {
        this.userIds = userIds;
    }

    public void execute(QueueableContext context) {
        SystemContextMethodsHelper.processPermissionSets(this.userIds);
    }
}