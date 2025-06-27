/*
 * @description    
 */
@isTest
private class ApprovalDecisionActionHandlerTest {
    @isTest
    static void verifyApprovalDecisionActionHandler(){
        ApprovalDecisionActionHandlerHelper obj = new ApprovalDecisionActionHandlerHelper();
        System.assertNotEquals(null, obj);
        System.assertEquals(null, obj.execute());
    }

    public class ApprovalDecisionActionHandlerHelper extends ApprovalDecisionActionHandler {
        public ApprovalDecisionActionHandlerHelper(){
            this.selectedRecordId = null;
            this.selectedAction = null;
        }
        public override String execute(){            
            return null;
        }
    }

}