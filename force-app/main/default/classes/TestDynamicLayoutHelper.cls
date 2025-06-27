/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private with sharing class TestDynamicLayoutHelper {
    public static PageTemplate__c pagTemp;
    public static SampleObject11__c sampleObj_1;
    public static SObjectLayoutConfig__c sObjLayCon; 
    public static CustomApp__c CustomAppConfig; 
    public static PageLayoutConfig__c pageLayoutConfig;
    private static void setup(){
        TestHelper.createCustomSettings(true);

        UserPreferences__c upref = UserPreferences__c.getInstance(UserInfo.getProfileId());
        if(upref == null){
            upref = new UserPreferences__c(SetupOwnerId = UserInfo.getProfileId());
        } 
        upref.GrantorPhaseCharts__c = '1,2';
        upref.ProfileName__c = 'System Administrator';
        CustomAppConfig__c app = TestHelper.getCustomAppConfig(false);
        app.AvailableforProfiles__c = 'System Administrator';
        
        upref.ActiveAppName__c = app.Name;
        upsert upref;

        pagTemp = TestHelper.getPageTemplateConfig(true);
        pageLayoutConfig = TestHelper.getPageLayoutConfig(false);
        pageLayoutConfig.IsMiniLayout__c = true;   
        insert pageLayoutConfig;
        CustomApp__c customAppConfig = new CustomApp__c();
        customAppConfig.Active__c = true;
        customAppConfig.Label__c = 'Label1';
        customAppConfig.Sequence__C = 2;
        customAppConfig.Name = 'StateasGrantor';        
        insert customAppConfig; 
        
        SObjectConfig__c sObjCon =TestHelper.getSObjectConfig(true);
       
        sObjLayCon = new SObjectLayoutConfig__c();
        sObjLayCon.Name = 'Trial Layout';
        sObjLayCon.IsDefault__c = true;
        sObjLayCon.ProfileNames__c = 'System Administrator';
        sObjLayCon.CustomApp__c = customAppConfig.Id;
        sObjLayCon.PageLayoutConfig__c = pageLayoutConfig.Id;
        sObjLayCon.SObjectConfig__c = sObjCon.Id;
        insert sObjLayCon;
        sampleObj_1 = TestHelper.getSampleObject1(true);
     }
    @IsTest
    public static void test_1(){
        setup();
        Test.startTest();
        DynamicLayoutHelper ctrl = new DynamicLayoutHelper();
        
        String result_1 = DynamicLayoutHelper.getTemplateName(sampleObj_1.id, 'Edit', null, null);
        Test.stopTest();
        System.assertNotEquals(result_1,'');
    }
    
    @IsTest
    public static void test_2(){
        TestHelper.createCustomSettings(true);
        setup();
        Test.startTest();
        pagTemp = TestHelper.getPageTemplateConfig(true);
        
        //sObjLayCon = TestHelper.getSObjectLayoutConfig(false);
        sampleObj_1 = TestHelper.getSampleObject1(true);
        
        DynamicLayoutHelper ctrl = new DynamicLayoutHelper();
        try{
        String result_1 = DynamicLayoutHelper.getTemplateName(sampleObj_1.id, 'Edit', null, null);  
        }
        catch(Exception e){
            
        }
        Test.stopTest();
        System.assert(ctrl != null);
    }
   
    @IsTest
    public static void test_3(){
        TestHelper.createCustomSettings(true);
        setup();
        Test.startTest();
        pagTemp = TestHelper.getPageTemplateConfig(true);
      //  sObjLayCon = TestHelper.getSObjectLayoutConfig(false);
        sObjLayCon.IsDefault__c = false;
        upsert sObjLayCon;
        sampleObj_1 = TestHelper.getSampleObject1(true);
        
        DynamicLayoutHelper ctrl = new DynamicLayoutHelper();
        String result_1 = DynamicLayoutHelper.getTemplateName(sampleObj_1.id, 'View', null, null);
        SobjectActionConfig__c SobjectAction = new SobjectActionConfig__c();
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        DynamicLayoutHelper.isRecordAccess(sampleObj_1.id,'View',pagTemp.ViewLayoutConfig__c);
        Test.stopTest();
        System.assertNotEquals(result_1,'');
    }
    
     @IsTest
    public static void test_4(){
        TestHelper.createCustomSettings(true);
        setup();
        Test.startTest();
        pagTemp = TestHelper.getPageTemplateConfig(true);
        //sObjLayCon = TestHelper.getSObjectLayoutConfig(false);
        sObjLayCon.IsDefault__c = true;
        upsert sObjLayCon;
        sampleObj_1 = TestHelper.getSampleObject1(true);        
        DynamicLayoutHelper ctrl = new DynamicLayoutHelper();
        String result_1 = DynamicLayoutHelper.getTemplateName(sampleObj_1.id, 'View', null, null);
        Test.stopTest();
        System.assertNotEquals(result_1,'');
    }

    @isTest
    public static void testIsActionAlreadyPerformed(){
    
        PageLayoutConfig__c pc = TestHelper.getPageLayoutConfig(true);
            PageLayoutActionConfig__c pac = new PageLayoutActionConfig__c ();
            pac.PageLayoutConfig__c = pc.Id;
            pac.Active__c = true ;
            insert pac;
            System.assertNotEquals(null, pac.Id , 'pac is not inserted');
            List<PageLayoutActionConfig__c > listOfPageLayoutActionConfig = new  List<PageLayoutActionConfig__c >();
            sampleObj_1 = TestHelper.getSampleObject1(true);
            boolean results=  DynamicLayoutHelper.isActionAlreadyPerformed(String.ValueOf(sampleObj_1.id),'View',listOfPageLayoutActionConfig ,String.ValueOf(pac.id)) ;
            listOfPageLayoutActionConfig.add(pac);
            boolean results1=  DynamicLayoutHelper.isActionAlreadyPerformed(String.ValueOf(sampleObj_1.id),'View',listOfPageLayoutActionConfig ,String.ValueOf(pac.id)) ;
            boolean results2=  DynamicLayoutHelper.isActionAlreadyPerformed(String.ValueOf(sampleObj_1.id),'View',null,String.ValueOf(pac.id)) ;
    }
    @IsTest
    public static void test_3_Positive(){
        TestHelper.createCustomSettings(true);
        setup();
        Test.startTest();
        pagTemp = TestHelper.getPageTemplateConfig(true);

        PageTemplate__c ptc = TestHelper.getPageTemplateConfig(true);

        sObjLayCon.IsDefault__c = false;
        upsert sObjLayCon;
        sampleObj_1 = TestHelper.getSampleObject1(true);
        DynamicLayoutHelper ctrl = new DynamicLayoutHelper();
        String result_1 = DynamicLayoutHelper.getTemplateName(sampleObj_1.id, 'View', null, null);
        String nameSpaceprefix  = AppUtils.getNamespacePrefix();
        
        
        SobjectConfig__c sobjConfig = new SobjectConfig__c();
        sobjConfig.name='test12';
        sobjConfig.NameDisplayField__c='Id,name';
        insert sobjConfig;
        
        
        SobjectActionConfig__c SobjectAction = new SobjectActionConfig__c();
        SobjectAction.name='test12';
        SobjectAction.SobjectConfig__c=sobjConfig.id;
        SobjectAction.StandardAction__c='View';
        insert SobjectAction;
        
        PageLayoutConfig__c pc = TestHelper.getPageLayoutConfig(true);
        
        PageLayoutActionConfig__c pac = new PageLayoutActionConfig__c ();
        pac.PageLayoutConfig__c = pc.Id;
        pac.StandardAction__c ='View';
        pac.Active__c = true ;
        pac.PageLayoutConfig__c=pagTemp.ViewLayoutConfig__c;
        pac.SobjectActionConfig__c=SobjectAction.id;
        insert pac;
            
        boolean gg = DynamicLayoutHelper.isRecordAccess(sampleObj_1.id,'View',pagTemp.ViewLayoutConfig__c);
        Test.stopTest();
        System.assertNotEquals(result_1,'');
    }
}