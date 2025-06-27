/*
Developer Name: Varsharani A.
Date:9/07/2018
Comment: UsertriggerHelper to associate gov grants license to the user.

*/

public with sharing class UserTriggerHelper extends TriggerHelper {
    List < GGLicenses__c > govLicenses = new List < GGLicenses__c > ();

    public override void processAfterInsert() {
        setGoveGrantsLicense(Trigger.new);
        processPermissionSets(Trigger.newMap, Trigger.oldMap);
    }
    public override void processAfterUpdate() {
        setGoveGrantsLicense(Trigger.new);
        processPermissionSets(Trigger.newMap, Trigger.oldMap);
    }

     void processPermissionSets(Map<Id, SObject> triggerNew, Map<Id, SObject> triggerOld){
        Set<Id> setUserIds = new Set<Id>();
        for(User obj : (List<User>)triggerNew.values()){
            if(obj.IsActive && Trigger.isInsert) {
                setUserIds.add(obj.Id);
            }
            if (obj.IsActive && Trigger.isUpdate){
                User oldObj = triggerOld != null && triggerOld.containsKey(obj.Id) ? (User)triggerOld.get(obj.Id) : null;
                if(oldObj != null && !oldObj.IsActive) {
                    setUserIds.add(obj.Id);
                }
            }
        }
        if(!setUserIds.isEmpty()){
            System.enqueueJob(new EnqueuePermissionSetAssignment(setUserIds));
        }
    }

    private void setGoveGrantsLicense(List < User > userList) {
        Boolean enableGGLicense = false;
        List<GGLicenses__c> ggLicDetailLst = new List<GGLicenses__c>();
        if (KeyValueStoreHelper.getBooleanValue('EnableGGLicense', true) != null) {
            enableGGLicense = KeyValueStoreHelper.getBooleanValue('EnableGGLicense', true);
        }
        if (enableGGLicense == true) {
            Set < Id > accountIdSet = new Set < Id > ();
            List < GGLicenses__c > govGrantsList = new List<GGLicenses__c>();

            for (User userObj : userList) {
                if (userObj.OrganizationId__c != null || userObj.OrganizationId__c != '') {
                    accountIdSet.add(userObj.OrganizationId__c);
                }
            }
            if(Schema.sObjectType.GGLicenses__c.isAccessible()){
            govGrantsList = new List < GGLicenses__c > ([Select Id, Name, TotalLicenses__c, UsedLicenses__c, RemainingLicenses__c, Organization__c from GGLicenses__c where Organization__c in:accountIdSet WITH USER_MODE]);
            }
            for (User userObj : userList) {
                for (GGLicenses__c gov: govGrantsList) {
                    if (Trigger.isAfter) {
                        if (Trigger.isInsert) {
                            if (gov.Organization__c == userObj.OrganizationId__c) {
                                if (gov.RemainingLicenses__c == 0) {
                                    userObj.addError(ErrorMessageHelper.fetchMessage('GEN-GRNTE-5671'));
                                }
                                if(Schema.sObjectType.GGLicenses__c.fields.UsedLicenses__c.isUpdateable()){
                                    gov.UsedLicenses__c = gov.UsedLicenses__c + 1;
                                }
                                govLicenses.add(gov);
                            }
                        } else if (Trigger.isUpdate) {
                            if (gov.Organization__c == userObj.OrganizationId__c && userObj.IsActive == false) {
                                if(Schema.sObjectType.GGLicenses__c.fields.UsedLicenses__c.isUpdateable()){
                                    gov.UsedLicenses__c = gov.UsedLicenses__c - 1;
                                }
                                govLicenses.add(gov);

                            } else if (gov.Organization__c == userObj.OrganizationId__c && userObj.IsActive == true) {
                                if (gov.RemainingLicenses__c == 0) {
                                    userObj.addError(ErrorMessageHelper.fetchMessage('GEN-GRNTE-5671'));
                                }
                                if(Schema.sObjectType.GGLicenses__c.fields.UsedLicenses__c.isUpdateable()){
                                    gov.UsedLicenses__c = gov.UsedLicenses__c + 1;
                                }
                                govLicenses.add(gov);
                            }
                        }
                    }
                }
            }
            if (!govLicenses.isEmpty()) {
                updateLicenseDetail(JSON.serialize(govLicenses));
            }
            //}
        }
    }

    @future
    private static void updateLicenseDetail(String JSONRequestBody) {
        if (String.isNotBlank(JSONRequestBody)) {
            List < GGLicenses__c > govLicenses = (List <GGLicenses__c > ) JSON.deserialize(JSONRequestBody, List < GGLicenses__c > .class); //Deserializing objects from an untrusted source is security-sensitive : False+ve as the JSON data being processed is controlled input through the code and not directly provided by users, the JSON structure is predefined and static, with no opportunity for external manipulation and the values from this JSON are accessed using static keys, ensuring that only expected data is retrieved.
            if(Schema.sObjectType.GGLicenses__c.isUpdateable()){
                update as user govLicenses;
            }
        }
    }

    static void assignPermissionSetsToUsers(){

    }
}