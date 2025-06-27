@isTest
private with sharing class LightningComponentCtrlTest {
    @isTest
    static void verifyLightningComponentCtrl(){
        LightningComponentCtrl obj = new LightningComponentCtrl();
        String strNamespace = obj.getNamespacePrefix();
        System.assertEquals(AppUtils.getNameSpacePrefix(), strNamespace);

        String resourceURL = obj.getSpinnerResourceURL();
        System.assertNotEquals(null, resourceURL);

        Boolean enableDebugMode = obj.getEnableDebugMode();
    }
}